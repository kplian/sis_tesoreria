CREATE OR REPLACE FUNCTION tes.f_gestionar_cbte_transferencia_eliminacion (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_int_comprobante integer,
  p_conexion varchar = NULL::character varying
)
RETURNS boolean AS
$body$
/***************************************************************************
 SISTEMA:        Sistema de Tesoreria
 FUNCION:        tes.f_gestionar_cbte_transferencia_eliminacion 
 DESCRIPCION:    Gestiona la eliminación del comprobante y cambia de estado solicitud de transferencias
 AUTOR:          MMV
 FECHA:          20/01/2020
 COMENTARIOS:
***************************************************************************
 ISSUE  SIS       EMPRESA       FECHA       AUTOR       DESCRIPCION

 ****************************************************************************/


DECLARE

	v_nombre_funcion   	text;
	v_resp				varchar;
	v_estado_cbte 		varchar;
	v_transferencia		record;
    v_id_tipo_estado	integer;
    v_id_funcionario	integer;
    v_id_usuario_reg	integer;
    v_id_depto			integer;
    v_codigo_estado		varchar;
    v_id_estado_wf_ant 	integer;
    v_id_proceso_wf		integer;
    v_acceso_directo		varchar; 
    v_clase					varchar;
    v_parametros_ad			varchar;
    v_tipo_noti				varchar;
    v_titulo				varchar;
    v_id_estado_actual		integer;
    v_etado_cbte			varchar;
BEGIN

	v_nombre_funcion = 'kaf.f_gestionar_cbte_transferencia_eliminacion';

    --Obtención de datos del movimiento
    if exists(select 1
              from tes.tsolicitud_transferencia s
              inner join conta.tint_comprobante c on c.id_int_comprobante = s.id_int_comprobante
              where s.id_int_comprobante = p_id_int_comprobante) then
            
   		select
		ic.estado_reg
		into
		v_etado_cbte
	    from conta.tint_comprobante ic
		where ic.id_int_comprobante = p_id_int_comprobante;

		if v_estado_cbte = 'validado' then
			raise exception 'No puede eliminarse el comprobante por estar Validado';
		end if;
			
    	select s.id_solicitud_transferencia,
               s.id_proceso_wf,
               s.id_estado_wf
               into 
               v_transferencia
        from tes.tsolicitud_transferencia s
        where s.id_int_comprobante = p_id_int_comprobante;


		 select ps_id_tipo_estado,
                ps_id_funcionario,
                ps_id_usuario_reg,
                ps_id_depto,
                ps_codigo_estado,
                ps_id_estado_wf_ant
          		into
               v_id_tipo_estado,
               v_id_funcionario,
               v_id_usuario_reg,
               v_id_depto,
               v_codigo_estado,
               v_id_estado_wf_ant 
            from wf.f_obtener_estado_ant_log_wf(v_transferencia.id_estado_wf);

			  --
          select 
               ew.id_proceso_wf 
            into 
               v_id_proceso_wf
          from wf.testado_wf ew
          where ew.id_estado_wf= v_id_estado_wf_ant;
          
          
         --configurar acceso directo para la alarma   
             v_acceso_directo = '';
             v_clase = '';
             v_parametros_ad = '';
             v_tipo_noti = 'notificacion';
             v_titulo  = 'Notificacion'; 
          
          -- registra nuevo estado
                      
          v_id_estado_actual = wf.f_registra_estado_wf( v_id_tipo_estado, 
                                                        v_id_funcionario, 
                                                        v_transferencia.id_estado_wf, 
                                                        v_id_proceso_wf, 
                                                        p_id_usuario,
                                                        p_id_usuario_ai,
                                                        p_usuario_ai,
                                                        v_id_depto,
                                                        '[RETROCESO]',
                                                        v_acceso_directo,
                                                        v_clase,
                                                        v_parametros_ad,
                                                        v_tipo_noti,
                                                        v_titulo);
              
                --actualizar estado solicitud
          update tes.tsolicitud_transferencia
          set estado = v_codigo_estado,
          id_estado_wf = v_id_estado_actual,
          id_int_comprobante = null,
          id_usuario_mod = p_id_usuario,
		  fecha_mod = now(),
          id_usuario_ai = p_id_usuario_ai,
		  usuario_ai = p_usuario_ai
          where id_proceso_wf = v_id_proceso_wf;
          
          
    ELSE
    	RAISE EXCEPTION 'El comprobante no esta relacionado a ningún solicitud de transferencia';
	END IF;

	RETURN  TRUE;

EXCEPTION

	WHEN OTHERS THEN

		v_resp = '';
		v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', SQLERRM);
		v_resp = pxp.f_agrega_clave(v_resp, 'codigo_error', SQLSTATE);
		v_resp = pxp.f_agrega_clave(v_resp, 'procedimientos', v_nombre_funcion);

		RAISE EXCEPTION '%', v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
PARALLEL UNSAFE
COST 100;