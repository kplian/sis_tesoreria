--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_gestionar_cuota_plan_pago_eliminacion (
  p_id_usuario integer,
  p_id_int_comprobante integer
)
RETURNS boolean AS
$body$
/*

Autor: RAC KPLIAN
Fecha:   6 junio de 2013
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
    
BEGIN

	v_nombre_funcion = 'tes.f_gestionar_cuota_plan_pago_eliminacion';
    
    
    
    -- 1) con el id_comprobante identificar el plan de pago
   
      select 
      pp.id_plan_pago,
      pp.id_estado_wf,
      pp.id_proceso_wf,
      pp.tipo,
      pp.estado,
      pp.id_plan_pago_fk,
      pp.id_obligacion_pago,
      pp.nro_cuota,
      pp.id_plantilla,
      pp.monto_ejecutar_total_mo,
      pp.monto_no_pagado,
      pp.liquido_pagable,
     
      op.id_depto ,
      op.pago_variable,
      pp.id_cuenta_bancaria ,
      pp.nombre_pago,
      pp.forma_pago,
      pp.tipo_cambio,
      pp.tipo_pago,
      pp.fecha_tentativa,
      pp.otros_descuentos,
      pp.monto_retgar_mo,
      op.numero
      into
      v_registros
      from  tes.tplan_pago pp
      inner join tes.tobligacion_pago  op on op.id_obligacion_pago = pp.id_obligacion_pago 
      where  pp.id_int_comprobante = p_id_int_comprobante; 
    
    
    --2) Validar que tenga un plan de pago
    
    
     IF  v_registros.id_plan_pago is NULL  THEN
     
        raise exception 'El comprobante no esta relacionado con nigun plan de pagos';
     
     END IF;
     
     
     
     
     --  recuperaq estado anterior segun Log del WF
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
              v_id_depto,
              'Eliminación de comprobante de la OP:'|| COALESCE(v_registros.numero,'NaN')||', cuota nro: '|| COALESCE(v_registros.nro_cuota,'NAN'));
                      
                    
                      
          -- actualiza estado en la solicitud
            update tes.tplan_pago pp set 
               id_estado_wf =  v_id_estado_actual,
               estado = v_codigo_estado,
               id_usuario_mod=p_id_usuario,
               fecha_mod=now(),
               id_int_comprobante = NULL
             where pp.id_plan_pago = v_registros.id_plan_pago;
     
     
     
             --cheque si tiene prorrateo en tesoria (modulo de obligacion de pagos)
            for v_rec_cbte_trans in (select * 
                                     from conta.tint_transaccion
                                      where id_int_comprobante = p_id_int_comprobante) LOOP
            
                  update tes.tprorrateo p set
                       id_int_transaccion = NULL
                  where p.id_int_transaccion = v_rec_cbte_trans.id_int_transaccion;
           
            END LOOP;
     
     
    
     -- 3.1)  si es tipo es devengado_pago
      IF   v_registros.tipo = 'devengado_pagado' THEN
           
             
           
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