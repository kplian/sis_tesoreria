--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_prorrateo_plan_pago (
  p_id_plan_pago integer,
  p_id_obligacion_pago integer,
  p_pago_variable varchar,
  p_monto_ejecutar_total_mo numeric,
  p_id_usuario integer,
  p_id_plan_pago_fk integer = NULL::integer
)
RETURNS boolean AS
$body$
DECLARE
v_registros record;
v_monto_total numeric;
v_monto_total_mb numeric;
v_cont numeric;
v_id_prorrateo integer;
v_monto  numeric;
v_monto_mb  numeric;
v_resp varchar;
v_nombre_funcion varchar;
v_factor numeric;
v_monto_ejecutar_total_mb numeric;
v_tipo_cambio numeric;
v_monto_ejecutar_total_mo_devengado numeric;
 
BEGIN

 v_nombre_funcion = 'tes.f_prorrateo_plan_pago';
 
 --obtener el tipo de cambio
     IF p_id_plan_pago_fk is NULL THEN    
      
      
        
            --------------------------------------------------
            -- Inserta prorrateo automatico para cuota de devengado
            ------------------------------------------------
             v_monto_total=0; 
             --obtengo tipo de cambio del plan de pago
             select 
               pp.tipo_cambio
             into
               v_tipo_cambio
             FROM
               tes.tplan_pago pp 
             WHERE
             pp.id_plan_pago = p_id_plan_pago;
            
            
            IF p_pago_variable = 'no' THEN
            
            --si los pagos no son variable puede hacerce un prorrateo automatico
            
                      v_cont = 0;
                      
                      v_monto_ejecutar_total_mb = round(p_monto_ejecutar_total_mo*v_tipo_cambio,2);
                     
                      FOR  v_registros in (
                                           select
                                            od.id_obligacion_det,
                                            od.factor_porcentual
                                           from tes.tobligacion_det od
                                           where  od.id_obligacion_pago = p_id_obligacion_pago) LOOP
                      
                        v_cont = v_cont +v_cont;
                        
                        --calcula el importe prorrateado segun factor
                        v_monto= round(p_monto_ejecutar_total_mo * v_registros.factor_porcentual,2);
                        v_monto_total=v_monto_total+v_monto;
                        
                        v_monto_mb= round(v_monto_ejecutar_total_mb * v_registros.factor_porcentual,2);
                        v_monto_total_mb=v_monto_total_mb+v_monto_mb;
                        
                          IF v_monto_mb != 0 THEN
                          	INSERT INTO 
                                tes.tprorrateo
                              (
                                id_usuario_reg,
                                fecha_reg,
                                estado_reg,
                                id_plan_pago,
                                id_obligacion_det,
                                monto_ejecutar_mo,
                                monto_ejecutar_mb
                              ) 
                              VALUES (
                                p_id_usuario,
                                now(),
                                'activo',
                                 p_id_plan_pago,
                                v_registros.id_obligacion_det,
                               v_monto,
                               v_monto_mb
                              
                              )RETURNING id_prorrateo into v_id_prorrateo;
                         END IF;
                        
                       
                      END LOOP;
                      
                     IF (v_monto_total_mb!=v_monto_ejecutar_total_mb) or (v_monto_total!=p_monto_ejecutar_total_mo)  THEN
                        
                       --OJO, si existe alguna diferencia por tipo de cambio podria ser aca
                       --a casusa de la condicion del IF que fuerza la igualdad
                       
                         update tes.tprorrateo p set
                         monto_ejecutar_mo =   p_monto_ejecutar_total_mo-(v_monto-monto_ejecutar_mo),
                         monto_ejecutar_mb =   v_monto_ejecutar_total_mb-(v_monto_mb-monto_ejecutar_mb)
                         where p.id_prorrateo = v_id_prorrateo;
                      
                      END IF;
                     
            
                       --actualiza el monto prorrateado para alerta en la interface cuando no cuadre
                      update  tes.tplan_pago pp set
                      total_prorrateado=p_monto_ejecutar_total_mo
                      where pp.id_plan_pago = p_id_plan_pago;
                      
                     
            
                      
              ELSE
              --si los pagos no son automatico solo insertamos la base del prorrateo con valor cero
                
                    FOR  v_registros in (
                                               select
                                                od.id_obligacion_det,
                                                od.factor_porcentual
                                               from tes.tobligacion_det od
                                               where  od.id_obligacion_pago = p_id_obligacion_pago) LOOP
                          
                            INSERT INTO 
                                  tes.tprorrateo
                                (
                                  id_usuario_reg,
                                  fecha_reg,
                                  estado_reg,
                                  id_plan_pago,
                                  id_obligacion_det,
                                  monto_ejecutar_mo,
                                  monto_ejecutar_mb
                                ) 
                                VALUES (
                                  p_id_usuario,
                                  now(),
                                  'activo',
                                  p_id_plan_pago,
                                  v_registros.id_obligacion_det,
                                  0,
                                  0
                                )RETURNING id_prorrateo into v_id_prorrateo;
                  
                    
                    
                     END LOOP;
              END IF;
      ELSE
      
      -- Si p_id_plan_pago_fk no es nulo se trata de un prorrateo de una cuota de pago
      
      
      
      select
      pp.monto_ejecutar_total_mo,
      pp.tipo_cambio
      into
      v_monto_ejecutar_total_mo_devengado,
      v_tipo_cambio
      from tes.tplan_pago pp
      where pp.id_plan_pago = p_id_plan_pago_fk;
      
      
     -- raise exception 'tipo de cambio %', v_tipo_cambio ;
      
      --calculo del factor eligual al monto a pagar entre el monto devengado
      v_factor =    p_monto_ejecutar_total_mo / v_monto_ejecutar_total_mo_devengado;
        
        v_cont = 0;
        v_monto_total=0; 
        v_monto_total_mb= 0 ;           
                      
                    FOR  v_registros in (
                      
                     select 
                          pr.monto_ejecutar_mo,
                          pr.monto_ejecutar_mb,
                          pr.id_obligacion_det                         
                         from  tes.tprorrateo pr
                         inner join tes.tobligacion_det od on od.id_obligacion_det = pr.id_obligacion_det
                         where pr.id_plan_pago = p_id_plan_pago_fk 
                         and pr.estado_reg = 'activo' and od.estado_reg = 'activo') LOOP
                     
                     
                     
                         v_cont = v_cont +v_cont;
                        
                     
                        --calcula el importe prorrateado segun factor
                        v_monto= round(v_registros.monto_ejecutar_mo * v_factor,2);
                        v_monto_total=v_monto_total+v_monto;
                        
                        v_monto_mb= round(v_registros.monto_ejecutar_mo * v_factor * v_tipo_cambio,2);
                        
                        
                        v_monto_total_mb=v_monto_total_mb+v_monto_mb;
                        
                      
                        IF v_monto_total_mb != 0 THEN
                          INSERT INTO 
                                tes.tprorrateo
                              (
                                id_usuario_reg,
                                fecha_reg,
                                estado_reg,
                                id_plan_pago,
                                id_obligacion_det,
                                monto_ejecutar_mo,
                                monto_ejecutar_mb
                                
                              ) 
                              VALUES (
                                p_id_usuario,
                                now(),
                                'activo',
                                p_id_plan_pago,
                                v_registros.id_obligacion_det,
                                v_monto,
                                v_monto_mb
                              
                              )RETURNING id_prorrateo into v_id_prorrateo;
                         END IF;
                       
                      END LOOP;
                      
                                            
                      --ajusta diferencia por redondeo
                      IF v_monto_total!=p_monto_ejecutar_total_mo  THEN
                        
                         update tes.tprorrateo p set
                         monto_ejecutar_mo =   p_monto_ejecutar_total_mo-(v_monto-monto_ejecutar_mo)
                           where p.id_prorrateo = v_id_prorrateo;
                      
                      END IF;
                     
            
                       --actualiza el monto prorrateado para alerta en la interface cuando no cuadre
                      update  tes.tplan_pago pp set
                      total_prorrateado=p_monto_ejecutar_total_mo
                      where pp.id_plan_pago = p_id_plan_pago;
      
        
      END IF;
              
              return TRUE;
                      
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