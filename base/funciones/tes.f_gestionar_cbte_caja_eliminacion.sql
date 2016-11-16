--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_gestionar_cbte_caja_eliminacion (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_int_comprobante integer,
  p_conexion varchar = NULL::character varying
)
RETURNS boolean AS
$body$
/*
Autor: RAC KPLIANF
Fecha:   28 marzo de 2016
Descripcion  Esta funcion retrocede el estado de los planes de pago cuando los comprobantes son eliminados

  

*/


DECLARE
  
	v_nombre_funcion   	text;
	v_resp				varchar;
    
    
    v_registros 		record;
    
    v_id_estado_actual  integer;
    
    
    va_id_tipo_estado integer[];
    va_codigo_estado varchar[];
    va_disparador    varchar[];
    va_regla         varchar[]; 
    va_prioridad     integer[];
    
    v_tipo_sol   varchar;
    
    v_nro_cuota numeric;
    
     v_id_proceso_wf integer;
     v_id_estado_wf integer;
  
     v_id_plan_pago integer;
     v_verficacion  boolean;
     v_verficacion2  varchar[];
     
     
      v_id_tipo_estado integer;
     v_id_funcionario  integer;
     v_id_usuario_reg integer;
     v_id_depto integer;
     v_codigo_estado varchar;
     v_id_estado_wf_ant  integer;
     v_rec_cbte_trans   record;
     v_reg_cbte   		record;
    
BEGIN

	v_nombre_funcion = 'tes.f_gestionar_cbte_caja_eliminacion';
    
    
    
    -- 1) con el id_int_comprobante identificar el proceso de caja
   
      select 
          pc.id_proceso_caja,
          pc.id_estado_wf,
          pc.id_proceso_wf,
          tpc.id_tipo_proceso_caja,
          tpc.codigo,
          pc.estado,
          pc.tipo,          
          c.id_int_comprobante,         
          c.temporal,
          c.estado_reg as estadato_cbte
      into
          v_registros
      from  tes.tproceso_caja pc
      inner join tes.ttipo_proceso_caja tpc on tpc.id_tipo_proceso_caja = pc.id_tipo_proceso_caja
      inner join conta.tint_comprobante  c on c.id_int_comprobante = pc.id_int_comprobante 
      where  pc.id_int_comprobante = p_id_int_comprobante; 
    
    
    --2) Validar que tenga un plan de pago
    
    
     IF  v_registros.id_proceso_caja is NULL  THEN     
        raise exception 'El comprobante no esta relacionado proceso de caja';
     END IF;
     
     
     
    select
      ic.estado_reg
    INTO
     v_reg_cbte
    from conta.tint_comprobante ic
    where ic.id_int_comprobante = p_id_int_comprobante;
     
    IF v_reg_cbte.estado_reg = 'validado' THEN
       raise exception 'no puede eliminar comprobantes validados';
    END IF;
     
   --  recupera estado anterior segun Log del WF
        SELECT  
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
        FROM wf.f_obtener_estado_ant_log_wf(v_registros.id_estado_wf);
        
         --
         
          select 
               ew.id_proceso_wf 
            into 
               v_id_proceso_wf
          from wf.testado_wf ew
          where ew.id_estado_wf= v_id_estado_wf_ant;
                      
          -- registra nuevo estado
                      
          v_id_estado_actual = wf.f_registra_estado_wf(
              v_id_tipo_estado, 
              v_id_funcionario, 
              v_registros.id_estado_wf, 
              v_id_proceso_wf, 
              p_id_usuario,
              p_id_usuario_ai,
              p_usuario_ai,
              v_id_depto,
              'Eliminación de comprobante de caja:'|| COALESCE(v_registros.id_int_comprobante::varchar,'NaN'));
                      
         
          
          IF v_codigo_estado != 'pendiente' THEN          
                      
            -- actualiza estado en la solicitud
              update tes.tproceso_caja pc set 
                 id_estado_wf =  v_id_estado_actual,
                 estado = v_codigo_estado,
                 id_usuario_mod=p_id_usuario,
                 fecha_mod=now(),
                 id_int_comprobante = NULL,
                 id_usuario_ai = p_id_usuario_ai,
                 usuario_ai = p_usuario_ai
               where pc.id_proceso_caja = v_registros.id_proceso_caja;
          ELSE
          -- si el estado es pendiente conservamos el ID del cbte ...
            
            -- actualiza estado del proceso de caja
              update tes.tproceso_caja pc set 
                 id_estado_wf =  v_id_estado_actual,
                 estado = v_codigo_estado,
                 id_usuario_mod=p_id_usuario,
                 fecha_mod=now(),
                 id_usuario_ai = p_id_usuario_ai,
                 usuario_ai = p_usuario_ai
               where pc.id_proceso_caja = v_registros.id_proceso_caja;
          
          END IF;   
             
     
    
  
RETURN  TRUE;



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