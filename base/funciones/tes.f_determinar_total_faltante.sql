--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_determinar_total_faltante (
  p_id_obligacion_pago integer,
  p_filtro varchar = 'registrado'::character varying,
  p_id_plan_pago integer = NULL::integer
)
RETURNS numeric AS
$body$
DECLARE
    v_consulta   		 		varchar;
	v_parametros  				record;
	v_nombre_funcion   			text;
	v_resp						varchar;
     v_monto_total_registrado 	numeric;
     v_monto_total 				numeric;
     v_monto_total_ejecutar_mo 	numeric;
     v_porc_ant 			  	numeric;
     v_monto_ant_descontado   	numeric;
     v_monto_aux                numeric;
     
     v_tipo_fil  varchar;
     v_monto    numeric;
			    
BEGIN

	v_nombre_funcion = 'tes.f_determinar_total_faltante';
   
 
            IF p_filtro not in ('registrado','registrado_pagado','total_registrado_pagado','devengado','pagado','ant_parcial','ant_parcial_descontado','ant_aplicado_descontado','dev_garantia') THEN
              
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
                            and pp.tipo in('devengado','devengado_pagado','rendicion','anticipo','devengado_pagado_1c')
                            and pp.id_obligacion_pago = p_id_obligacion_pago; 
                            
                          
                      v_monto_total  = COALESCE(v_monto_total,0)- COALESCE(v_monto_total_registrado,0);
                            
                        
                      return v_monto_total;    
           
        
             ELSEIF     p_filtro in ('registrado_pagado') THEN
             
                       --  fltro para determinar el total de pago registrado par auna cuota de devenngado
                     
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
                        where  pp.estado_reg = 'activo'  
                              and pp.tipo = 'pagado'
                              and pp.id_plan_pago_fk = p_id_plan_pago; 
                              
                            
                        v_monto_total  = COALESCE(v_monto_total_ejecutar_mo,0)- COALESCE(v_monto_total_registrado,0);
                              
                          
                        return v_monto_total; 
            
             ELSEIF     p_filtro  = 'ant_aplicado_descontado' THEN
             
            
             
                     --  fltro para recupera el total del anticipo total
                   
                     select 
                      pp.monto
                     into
                       v_monto
                     from tes.tplan_pago pp
                     where pp.id_plan_pago = p_id_plan_pago; 
                    
                     -- determina el total registrado  como antticipo faltante
                      select 
                       sum(pp.monto)
                      into
                       v_monto_total_registrado
                      from tes.tplan_pago pp
                      where  pp.estado_reg = 'activo'  
                            and pp.tipo = 'ant_aplicado'                --recupera la suma de los anticipos aplicados
                            and pp.id_plan_pago_fk = p_id_plan_pago; 
                            
                     v_monto_total  = COALESCE(v_monto,0)- COALESCE(v_monto_total_registrado,0);
                     return v_monto_total; 
            
            ELSEIF  p_filtro = 'ant_parcial' THEN
                    --  recupera el monto maximo que se puede anticipar segun politica
                
                     select 
                      op.total_pago
                     into
                       v_monto_total
                     from tes.tobligacion_pago op
                     where op.id_obligacion_pago = p_id_obligacion_pago; 
                    
                     v_porc_ant = pxp.f_get_variable_global('politica_porcentaje_anticipo')::numeric;
                     
                     IF v_porc_ant is NULL THEN
                       raise exception 'No se tiene valor en la variable global,  politica_porcentaje_anticipo';
                     END IF;
                     
                     return v_monto_total*v_porc_ant;
            
            ELSEIF  p_filtro = 'ant_parcial_descontado' THEN
            
                     --recuperar el total de anticipo parcial que falta descontar
                     
                     select 
                         sum(pp.monto)
                        into
                         v_monto_total_registrado
                        from tes.tplan_pago pp
                        where  pp.estado_reg='activo'  
                              and pp.tipo in('ant_parcial')
                              and pp.id_obligacion_pago = p_id_obligacion_pago; 
                     
                     --recuperar el total de ancitipo parcial descontado
                     
                     select 
                         sum(pp.descuento_anticipo)
                        into
                         v_monto_ant_descontado
                        from tes.tplan_pago pp
                        where  pp.estado_reg='activo'  
                              and pp.tipo in('pagado','devengado_pagado_1c')          --un supeusto es que los descuentos de anticipo solo se hacen en el comprobante de pago
                              and pp.id_obligacion_pago = p_id_obligacion_pago;
                     
                     
                      --todos los  devengado_pagado   que no tienen pago registrado (--basta con que tenga uno ya no se lo cnsidera)                                
                      select 
                         sum(pp.descuento_anticipo)
                      into 
                         v_monto_aux
                      from tes.tplan_pago pp
                      where  pp.estado_reg='activo'  
                            and pp.tipo in('devengado_pagado')      
                            and pp.id_obligacion_pago = p_id_obligacion_pago
                            and  pp.id_plan_pago not in (select 
                                                             pp2.id_plan_pago_fk
                                                        from tes.tplan_pago pp2
                                                        where  pp2.estado_reg='activo'  
                                                              and pp2.tipo in('pagado')      
                                                              and pp2.id_obligacion_pago = p_id_obligacion_pago); 
                     
                     
                     --devolver la diferencias, el monto que falta descontar
                     
                     return COALESCE(v_monto_total_registrado,0) - COALESCE(v_monto_ant_descontado,0) - COALESCE(v_monto_aux,0);
            
            
            
            
             ELSEIF  p_filtro = 'dev_garantia' THEN
            
                       --recupera los montos retenidos por garantia en las trasacciones de devengado unicamente
                       
                        select 
                         sum(pp.monto_retgar_mo)
                        into
                         v_monto_total_registrado
                        from tes.tplan_pago pp
                        where  pp.estado_reg='activo'  
                              and pp.tipo in('devengado','devengado_pagado','devengado_pagado_1c')
                              and pp.id_obligacion_pago = p_id_obligacion_pago;
                       
                       --  recuperar los montos de garantia devueltos
                       
                        select 
                         sum(pp.monto)
                        into
                         v_monto_ant_descontado
                        from tes.tplan_pago pp
                        where  pp.estado_reg='activo'  
                              and pp.tipo in('dev_garantia') 
                              and pp.id_obligacion_pago = p_id_obligacion_pago;
                       
                      
                       return COALESCE(v_monto_total_registrado,0) - COALESCE(v_monto_ant_descontado,0);
            
            
            ELSEIF     p_filtro in ('total_registrado_pagado') THEN
             
                       --  fltro para determinar el total de pago registrado para
                       --  la obligacion de pago
                     
                       -- determina el total a pagar
                   
                       select 
                        op.total_pago
                       into
                         v_monto_total
                       from tes.tobligacion_pago op
                       where op.id_obligacion_pago = p_id_obligacion_pago; 
                      
                        --recupera el total de dinero pagado
                     
                        select 
                         sum(pp.monto)
                        into
                         v_monto_total_registrado
                        from tes.tplan_pago pp
                        where  pp.estado_reg='activo'  
                              and pp.tipo in('pagado','devengado_pagado_1c','anticipo')       
                              and pp.id_obligacion_pago = p_id_obligacion_pago;
                     
                     
                         --todos los  devengado_pagado   que no tienen pago registrado (--basta con que tenga uno ya no se lo cnsidera)                                
                        select 
                           sum(pp.monto)
                        into 
                           v_monto_aux
                        from tes.tplan_pago pp
                        where  pp.estado_reg='activo'  
                              and pp.tipo in('devengado_pagado')      
                              and pp.id_obligacion_pago = p_id_obligacion_pago
                              and  pp.id_plan_pago not in (select 
                                                               pp2.id_plan_pago_fk
                                                          from tes.tplan_pago pp2
                                                          where  pp2.estado_reg='activo'  
                                                                and pp2.tipo in('pagado')      
                                                              and pp2.id_obligacion_pago = p_id_obligacion_pago);  
                              
                            
                        v_monto_total  = COALESCE(v_monto_total,0) - COALESCE(v_monto_total_registrado,0) - COALESCE(v_monto_aux,0);
                              
                          
                        return v_monto_total; 
            
            
            ELSE
               
                     raise exception 'Los otros filtros no fueron implementados %',p_filtro;
            
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