--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_validar_periodo_costo (
  p_id_plan_pago integer
)
RETURNS boolean AS
$body$
DECLARE
   
    v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
    v_registros_pp			record;
BEGIN
	v_nombre_funcion = 'tes.f_validar_periodo_costo';
    
     -- recuperamos datos del plan de pagos
      select
      pp.tipo_pago,
      pp.tipo,
      pp.fecha_costo_fin,
      pp.fecha_costo_ini,
      pp.id_plan_pago,
      pp.id_obligacion_pago,
      op.tipo_obligacion,
      pp.estado
      into
       v_registros_pp
      from   tes.tplan_pago pp
      inner  join tes.tobligacion_pago op on op.id_obligacion_pago = pp.id_obligacion_pago
      where  pp.id_plan_pago = p_id_plan_pago;
      
      
    
     --si el proceso esta en borrador y viene de adquisciones no entra a la validacion
     IF  v_registros_pp.tipo_obligacion = 'adquisiciones' and v_registros_pp.estado = 'borrador'  THEN
       return True;
      
     ELSE
     
            -- verificamos que sea un tipo de plan pago de devengado exluimos recusos humanos
           IF  v_registros_pp.tipo  in ('devengado', 'devengado_pagado_1c', 'devengado_pagado','anticipo','ant_aplicado')  THEN 
              
              -- verificamos si tiene un concepto de gasto del tipo servicio
             
                 IF exists (
                      select 1
                      from tes.tobligacion_det od
                      inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = od.id_concepto_ingas 
                      where    od.id_obligacion_pago =  v_registros_pp.id_obligacion_pago 
                           and od.estado_reg = 'activo'
                           and lower(cig.tipo) = 'servicio'
                             
                     ) THEN
                     
                     
                      -- verificamos si fecha inicio y fin son validas
                        
                       IF v_registros_pp.fecha_costo_fin is NULL or v_registros_pp.fecha_costo_ini is NULL THEN
                           raise exception 'Para servicios es requerido indicar el periodo del gasto';
                       END IF;
                       
                       IF v_registros_pp.fecha_costo_fin < v_registros_pp.fecha_costo_ini  THEN
                           raise exception 'La fecha fin no puede ser menor a la fecha de inicio';
                       END IF;
                         
                END IF;
             
           END IF;  
     END IF; 
     return True;
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