--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_determinar_total_faltante (
  p_id_obligacion_pago integer,
  p_filtro varchar = 'registrado'::character varying,
  p_id_plan_pago integer = NULL::integer
)
RETURNS numeric AS
$body$
DECLARE
    v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
     v_monto_total_registrado numeric;
     v_monto_total numeric;
     v_monto_total_ejecutar_mo numeric;
			    
BEGIN

	v_nombre_funcion = 'tes.f_determinar_total_faltante';
   
 
            IF p_filtro not in ('registrado','registrado_pagado','devengado','pagado') THEN
              
              raise exception 'filtro no reconocido';
            
            END IF;
            
            IF   p_filtro = 'registrado' THEN
            
                 -- determina el total por registrar
               
                 select 
                  op.total_pago
                 into
                   v_monto_total
                 from tes.tobligacion_pago op
                 where op.id_obligacion_pago = p_id_obligacion_pago; 
                
                 -- determina el total registrado 
                  select 
                   sum(pp.monto)
                  into
                   v_monto_total_registrado
                  from tes.tplan_pago pp
                  where  pp.estado_reg='activo'  
                        and pp.tipo in('devengado_pagado','devengado')
                        and pp.id_obligacion_pago = p_id_obligacion_pago; 
                        
                      
                    v_monto_total  = COALESCE(v_monto_total,0)- COALESCE(v_monto_total_registrado,0);
                        
                    
                    return v_monto_total;    
           
        
             ELSEIF     p_filtro = 'registrado_pagado' THEN
             
             
              --  fltro para faltante por devengar, faltante por pagar 
               
                 select 
                  pp.monto_ejecutar_total_mo
                 into
                   v_monto_total_ejecutar_mo
                 from tes.tplan_pago pp
                 where pp.id_plan_pago = p_id_plan_pago; 
                
                 -- determina el total registrado 
                  select 
                   sum(pp.monto)
                  into
                   v_monto_total_registrado
                  from tes.tplan_pago pp
                  where  pp.estado_reg='activo'  
                        and pp.tipo = 'pagado'
                        and pp.id_plan_pago_fk = p_id_plan_pago; 
                        
                      
                    v_monto_total  = COALESCE(v_monto_total_ejecutar_mo,0)- COALESCE(v_monto_total_registrado,0);
                        
                    
                    return v_monto_total; 
            
            
            
            ELSE
          
            
              raise exception 'Los otros filtros no fueron implementados';
            
            
            
            END IF;



 
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