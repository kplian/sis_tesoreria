CREATE OR REPLACE FUNCTION tes.f_pago_tiene_servicio (
  p_id_plan_pago integer
)
RETURNS integer AS
$body$
DECLARE
   
    v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
    v_registros_pp			record;
    v_res					integer;
BEGIN
	v_nombre_funcion = 'tes.f_pago_tiene_servicio';
    v_res = 2;
      		select * into v_registros_pp
            from tes.tplan_pago
            where id_plan_pago = p_id_plan_pago;
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
                     
                     
                      v_res = 1;
                         
                END IF;
             
           END IF;  
     
     return v_res;
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