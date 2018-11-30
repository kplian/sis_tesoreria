--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_fun_regreso_solicitud_efectivo_wf (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_estado_wf integer,
  p_id_proceso_wf integer,
  p_codigo_estado varchar
)
RETURNS boolean AS
$body$
/*
*
*  Autor:   GSS
*  DESC:    funcion que actualiza los estados despues del registro de un retroceso en caja
*  Fecha:   09/12/2015
*
*/

DECLARE

  v_nombre_funcion      text;
    v_resp            varchar;
    v_mensaje         varchar;
    v_id_solicitud_efectivo integer;
    v_rec         record;
  v_id_tipo_estado    integer;
    v_id_estado_actual    integer;
  v_id_funcionario    integer;
    v_id_usuario_reg    integer;
    v_id_depto        integer;
    v_codigo_estado     varchar;
    v_id_estado_wf_ant    integer;
    v_acceso_directo    varchar;
    v_clase         varchar;
    v_parametros_ad     varchar;
    v_tipo_noti       varchar;
    v_titulo        varchar;
  
    
BEGIN

  v_nombre_funcion = 'tes.f_fun_regreso_solicitud_efectivo_wf';

    -- actualiza estado en la solicitud
    update tes.tsolicitud_efectivo  se set 
         id_estado_wf =  p_id_estado_wf,
         estado = p_codigo_estado,
         id_usuario_mod=p_id_usuario,
         fecha_mod=now(),
         id_usuario_ai = p_id_usuario_ai,
         usuario_ai = p_usuario_ai
    where id_proceso_wf = p_id_proceso_wf;
   
     IF p_codigo_estado = 'entregado' THEN
      delete
        from tes.tsolicitud_efectivo
        where id_solicitud_efectivo_fk=(
        select id_solicitud_efectivo
        from tes.tsolicitud_efectivo
        where id_proceso_wf=p_id_proceso_wf) and estado='devuelto';
    END IF;    
    
    --------------------------------------------------------------------------------------
    --RCM 28-03-2018: Caso de que el recibo haya sido generado desde cuenta documentada
    --------------------------------------------------------------------------------------
    --Obtiene el id de la solicitud de efectivo
    select id_solicitud_efectivo
    into v_id_solicitud_efectivo
    from tes.tsolicitud_efectivo
    where id_proceso_wf = p_id_proceso_wf;
    
    --Verifica si viene de cuenta documentada
    select
    id_cuenta_doc, id_cuenta_doc_fk, id_proceso_wf, id_estado_wf, estado, id_depto_lb,
    dev_tipo, dev_saldo
    into v_rec
    from cd.tcuenta_doc
    where id_solicitud_efectivo = v_id_solicitud_efectivo;

    if v_rec.id_cuenta_doc is not null then
      --Anular el recibo de pago
        select te.id_tipo_estado
        into v_id_tipo_estado
        from wf.tproceso_wf pw 
        inner join wf.ttipo_proceso tp on pw.id_tipo_proceso = tp.id_tipo_proceso
        inner join wf.ttipo_estado te on te.id_tipo_proceso = tp.id_tipo_proceso and te.codigo = 'anulado'               
        where pw.id_proceso_wf = p_id_proceso_wf;
        
        if v_id_tipo_estado is null then
          raise exception 'El estado Anulado no está parametrizado en el workflow de la Solicitud de Efectivo';  
        end if;
        
        v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado, 
                                                     NULL, 
                                                     p_id_estado_wf, 
                                                     p_id_proceso_wf,
                                                     p_id_usuario,
                                                     p_id_usuario_ai,
                                                     p_id_usuario_ai::varchar,
                                                     null,
                                                     'Solicitud de Efectivo generada desde Cuenta Documentada anulada');
        
        update tes.tsolicitud_efectivo set 
        id_estado_wf =  v_id_estado_actual,
        estado = 'anulado',
        id_usuario_mod=p_id_usuario,
        fecha_mod=now(),
        estado_reg='inactivo',
        id_usuario_ai = p_id_usuario_ai
        where id_solicitud_efectivo  = v_id_solicitud_efectivo;

        --Verifica si el recibo corresponde a una solicitud de cuenta documentada o a una devolución/reposición
        if v_rec.dev_tipo is not null and coalesce(v_rec.dev_saldo,0) > 0 then
        
            --Devolución/reposición: se quita relación con solicitud de efectivo
            update cd.tcuenta_doc set
            id_solicitud_efectivo = null,
            dev_tipo = null,
            dev_a_favor_de = null,
            dev_nombre_cheque = null,
            id_caja_dev = null,
            dev_saldo = null
            where id_cuenta_doc = v_rec.id_cuenta_doc;


        else
            --Corresponde a una solicitud: Retrocede la cuenta documentada
            select
               ps_id_tipo_estado,
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
            from wf.f_obtener_estado_ant_log_wf(v_rec.id_estado_wf);
            
            v_acceso_directo = '../../../sis_cuenta_documentada/vista/cuenta_doc/CuentaDocVb.php';
            v_clase = 'CuentaDocVb';
            v_parametros_ad = '{filtro_directo:{campo:"cd.id_proceso_wf",valor:"'||v_rec.id_proceso_wf::varchar||'"}}';
            v_tipo_noti = 'notificacion';
            v_titulo  = 'Visto Bueno';
            
            v_id_estado_actual = wf.f_registra_estado_wf(v_id_tipo_estado,                --  id_tipo_estado al que retrocede
                                                        v_id_funcionario,                --  funcionario del estado anterior
                                                        v_rec.id_estado_wf,            --  estado actual ...
                                                        v_rec.id_proceso_wf,             --  id del proceso actual
                                                        p_id_usuario,                    -- usuario que registra
                                                        p_id_usuario_ai,
                                                        p_id_usuario_ai::varchar,
                                                        v_rec.id_depto_lb,               --depto del estado anterior
                                                        '[RETROCESO] ',
                                                        v_acceso_directo,
                                                        v_clase,
                                                        v_parametros_ad,
                                                        v_tipo_noti,
                                                        v_titulo);
                                                        
            update cd.tcuenta_doc set
            id_estado_wf =  v_id_estado_actual,
            estado = v_codigo_estado,
            id_usuario_mod = p_id_usuario,
            fecha_mod = now(),
            id_usuario_ai = p_id_usuario_ai,
            id_solicitud_efectivo = null
            where id_cuenta_doc = v_rec.id_cuenta_doc;

        end if;


        
        
        
    end if;
    

  RETURN   TRUE;



EXCEPTION
          
  WHEN OTHERS THEN
      v_resp='';
      v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
      v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
      v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
      raise exception '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;