--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_finalizar_obligacion (
  p_id_obligacion_pago integer,
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_forzar_fin varchar = 'no'::character varying
)
RETURNS varchar [] AS
$body$
/*
  Autor:   RAC
  DESC:     Finaliza la obligacion de pago
  Fecha:   10/06/2013

    
     HISTORIAL DE MODIFICACIONES:
       
 ISSUE            FECHA:              AUTOR                                DESCRIPCION
 #0         10/06/2013             RAC (KPLIAN)            Creacion
 #46        30/01/2020             RAC                     Al finalizar Obligaciones  permitir cbtes en estado pendiente issue. (Vamos asumir que los planes  de pago con cbte generado están finalizados para permitir la extension de la obligación de pago) #46
 #49 ETR    05/02/2020             RAC KPLIAN              BUG, permitia finalizar ofligaciones con pago en estado borrador 
*/
DECLARE

    v_nombre_funcion       text;
    v_resp                varchar;
    v_registros           record;
    v_registros_obli       record;
    v_ejecutado         numeric;
    v_comprometido        numeric;
    v_tipo_sol            varchar;
    v_monto_ejecutar_mo    numeric;
    
    va_id_tipo_estado   integer[];
    va_codigo_estado    varchar[];
    va_disparador       varchar[];
    va_regla            varchar[];
    va_prioridad        integer[];
    
    v_id_estado_actual    integer;
    v_id_moneda_base   integer;
    
    v_sw_verificacion  boolean;
    v_mensaje_verificacion varchar;
    v_desc_ingas varchar;
    v_cont integer;
    v_respuesta varchar[];
    v_mensaje varchar;
    v_id_cotizacion integer;
    v_monto_total  numeric;
    v_saldo_x_pagar   numeric;
    v_mensaje_cuotas varchar;
    v_mensaje_error  varchar;
    v_pre_integrar_presupuestos        varchar;
    
    
BEGIN

    v_nombre_funcion = 'tes.f_finalizar_obligacion';
    v_id_moneda_base =  param.f_get_moneda_base();
    v_pre_integrar_presupuestos = pxp.f_get_variable_global('pre_integrar_presupuestos');
      
    
      --obtiene datos de la obligacion
      
       select
       op.id_obligacion_pago,
       op.tipo_obligacion,
       op.estado,
       op.pago_variable,
       op.id_obligacion_pago_extendida,
       op.monto_estimado_sg,
       op.ajuste_anticipo,
       op.ajuste_aplicado
       into
       v_registros_obli
       from tes.tobligacion_pago op
       where op.id_obligacion_pago = p_id_obligacion_pago;
       
       
       
    
    
       --  verificamos que el total de cuotas esten en su estado final
         IF EXISTS( select 
                         1
                   from tes.tplan_pago pp
                   where pp.id_obligacion_pago =  p_id_obligacion_pago  
                        and pp.estado_reg = 'activo'
                        and pp.estado not in ('devengado','pagado', 'anticipado', 'aplicado', 'devuelto','contabilizado')
                        
                        ) THEN
                    
                
                -- #46, #49 solo admitira planes del tipo pagado (pagos) que esten en estado pendiente (con cbte generaod, estos cbte no podra eliminarse si la obligacion es finalizada)
                
                IF  EXISTS( 
                           
                             select 
                                    1
                               from tes.tplan_pago pp
                               where pp.id_obligacion_pago =  p_id_obligacion_pago  
                                    and pp.estado_reg = 'activo'
                                    and  pp.estado = 'pendiente'
                                    and pp.tipo = 'pagado'
                                  
                                  ) THEN
                                  
                                  
                 ELSE
                         raise exception 'existen cuotas pendientes de finanización';
                 END IF;
          
          END IF;
          
          -----------------
          -- VALIDACIONES
          -----------------
          
          v_mensaje_error = '';
          
          --raise exception 'pasa la validacion';
           
          -- validar que  si tiene anticipo parciales exista retenciones por el total
          v_monto_total= tes.f_determinar_total_faltante(p_id_obligacion_pago, 'ant_parcial_descontado');
          IF v_monto_total > 0   and p_forzar_fin = 'no' THEN
            v_mensaje_error  =  'Tiene pendiente la recuperacion del anticipo por un monto de: '|| v_monto_total::varchar ||'
            ';
          END IF;
          
         --validamos que si tiene retencion de garantia esten devueltas 
      
         v_monto_total = tes.f_determinar_total_faltante(p_id_obligacion_pago, 'dev_garantia');
         IF v_monto_total > 0  and p_forzar_fin = 'no' THEN
            v_mensaje_error  =  v_mensaje_error||' Tiene devoluciones de garantia pendiente por un monto de : '|| v_monto_total;
         END IF;
         
         
         IF v_mensaje_error != '' and  p_forzar_fin = 'no' THEN
         
               v_respuesta[1] = 'false';
               v_respuesta[2] = v_mensaje_error; 
               
               RETURN   v_respuesta;
         END IF;
         
         --monto_estimado_sg,
         --op.ajuste_anticipo,
         --op.ajuste_aplicado
      
      
         -- validamos que si tienes anticipos totales   el total este aplicado para procesos no variables
         IF  v_registros_obli.pago_variable = 'no'   THEN
         
                
                v_saldo_x_pagar = tes.f_determinar_total_faltante(v_registros_obli.id_obligacion_pago,'anticipo_sin_aplicar');
                
                v_mensaje = '';
                IF  v_saldo_x_pagar  > 0 THEN
                
                    IF  v_registros_obli.monto_estimado_sg  > v_saldo_x_pagar THEN
                         v_mensaje =  'Tiene saldo anticipado por aplicar ('||v_saldo_x_pagar::varchar||'),  reduzca el monto de ampliación en ('||(v_registros_obli.monto_estimado_sg  - v_saldo_x_pagar)::varchar||')';
                    
                    ELSEIF v_registros_obli.monto_estimado_sg  < v_saldo_x_pagar THEN
                        v_mensaje =  'Tiene saldo anticipado por aplicar ('||v_saldo_x_pagar::varchar||'), Puede incrementar el monto de ampliación ('||(v_saldo_x_pagar - v_registros_obli.monto_estimado_sg)::varchar||') o aplicar el anticipo si tiene presupuesto suficiente';
                    END IF;
                    
                  
                    
                    v_mensaje_cuotas= '';
                    --revisa cuota de anticipo ...
                    FOR v_registros in ( select 
                                         pp.monto,
                                         pp.total_pagado,
                                         pp.nro_cuota
                                         from tes.tplan_pago pp
                                         where pp.id_obligacion_pago =  p_id_obligacion_pago  
                                              and pp.estado_reg = 'activo'
                                              and pp.tipo = 'anticipo'
                                              and pp.monto != pp.total_pagado
                                              and pp.estado = 'anticipado') LOOP
                                        
                                 IF v_mensaje_cuotas = '' THEN
                                    v_mensaje_cuotas = 'Revise las cuotas: <br>';
                                 END IF;       
                                 v_mensaje_cuotas = v_mensaje_cuotas||'La cuota '|| COALESCE(v_registros.nro_cuota::varchar,'NAN')||'  le falta aplicar '|| (COALESCE(v_registros.monto,0) - COALESCE(v_registros.total_pagado,0))::varchar||' </br>';
                            
                    END LOOP;
                    --revisa cuota de devengado con monto anticipado
                    FOR v_registros in ( 
                                         select 
                                           pp.monto,
                                           pp.total_pagado,
                                           pp.nro_cuota
                                         from tes.tplan_pago pp
                                         where pp.id_obligacion_pago =  p_id_obligacion_pago  
                                              and pp.estado_reg = 'activo'
                                              and pp.tipo in ('devengado','devengado_pagado','devengado_pagado_1c')
                                              and pp.monto_anticipo > 0
                                              and pp.monto != pp.total_pagado
                                              and pp.estado = 'devengado') LOOP
                                        
                                 IF v_mensaje_cuotas = '' THEN
                                    v_mensaje_cuotas = 'Revise las cuotas: <br>';
                                 END IF;       
                                 v_mensaje_cuotas = v_mensaje_cuotas||'La cuota '|| COALESCE(v_registros.nro_cuota::varchar,'NAN')||'  le falta aplicar '|| (COALESCE(v_registros.monto,0) - COALESCE(v_registros.total_pagado,0))::varchar||' </br>';
                            
                    END LOOP;
                    
                    IF v_mensaje!='' THEN
                         raise exception ' % <br>  %',v_mensaje, v_mensaje_cuotas;
                    END IF;
                    
                    
                ELSEIF  v_saldo_x_pagar < 0 THEN
                   raise exception 'El monto de  ampliacion se excede en (%). Reduzaca el monto de ampliacion', v_saldo_x_pagar;
                END IF;
             
                
                
         
         ELSE
             --  Si es un proceso variable validamos 
             v_saldo_x_pagar = tes.f_determinar_total_faltante(v_registros_obli.id_obligacion_pago,'ant_aplicado_descontado_op_variable');
             
             IF v_saldo_x_pagar > 0  THEN
             
             
                raise exception 'Tiene un anticipo total que no ha sido aplicado (%),  si desesa continuar de todas formas, primero ajuste el monto aplicado para la obligación',v_saldo_x_pagar;
             END IF; 
             
             IF v_saldo_x_pagar < 0  THEN
                raise exception 'Sus aplicaciones sobre pasan el monto anticipado, de un anticipo por el faltante (%) o haga un ajuste al monto anticipado en la obligacion',v_saldo_x_pagar*-1;
             END IF;
             
        END IF;
        
       
        --  verificamos que el total de los devengados esten pagados
        v_mensaje = '';
        FOR v_registros in ( select 
                               pp.monto_ejecutar_total_mo,
                               pp.total_pagado,
                               pp.nro_cuota
                               from tes.tplan_pago pp
                               where pp.id_obligacion_pago =  p_id_obligacion_pago  
                                    and pp.estado_reg = 'activo'
                                    and pp.tipo in ('devengado','devengado_pagado')
                                    and pp.monto_ejecutar_total_mo > (pp.total_pagado)
                                    and pp.estado = 'devengado') LOOP
                      
                      
                       v_mensaje = v_mensaje||'La cuota '||v_registros.nro_cuota::varchar||'  le fatal devengar '|| (COALESCE(v_registros.monto_ejecutar_total_mo,0)-COALESCE(v_registros.total_pagado,0))::varchar||' </br>';
          
          END LOOP;
          
          IF v_mensaje!='' THEN
          
             raise exception 'Existen devengados incompletos % ',v_mensaje;
          
          END IF;
          
         
       
          --  si tiene relacionado una cotizacion, se llama a la funcion de finalizar cotizacion              
          IF v_registros_obli.tipo_obligacion ='adquisiciones' THEN      
           
                 select 
                     co.id_cotizacion
                 into
                     v_id_cotizacion
                 from adq.tcotizacion co
                 where co.id_obligacion_pago = p_id_obligacion_pago;
                 
                 IF v_id_cotizacion is NULL THEN
                 
                    raise exception  'No existe relacion con ninguna cotizacion en adquisiciones.';
                 
                 END IF;
                 
                 --v_parametros.forzar
                 
                 
                 IF not adq.f_finalizar_cotizacion(v_id_cotizacion, 
                                                    p_id_usuario,
                                                    p_id_usuario_ai,
                                                    p_usuario_ai)  THEN
                                     
                    raise exception 'Error al finalizar la cotización';
                                     
                 END IF;
                 
                 /*
                 Si es un pago de adquisiciciones el presupuesto se revierte al finalizar el proceso
                 esto debido a que un mismo id_partida ejecucion puede pertenecer a diferentes cotizaciones
                 al revertir el presupuesto de una desde tesoreria,  afectaria al presupuesto del otro
                 */
             
      
         ELSE
               --si no es de adquisiciones y no es un paso sin presupeustos (pago_especial)
               
               IF  v_registros_obli.tipo_obligacion  !=  'pago_especial' THEN
                   --se revierte el presupeusto  sobrante si existe
                    IF v_pre_integrar_presupuestos = 'true' THEN 
                       IF not tes.f_gestionar_presupuesto_tesoreria(p_id_obligacion_pago, p_id_usuario, 'revertir')  THEN
                                               
                           raise exception 'Error al revertir el presupuesto';
                                               
                       END IF;
                   END IF;
              END IF;
       END IF;
      
      --raise 'llega al final';
      
     v_respuesta[1] = 'true'; 

RETURN   v_respuesta;



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
PARALLEL UNSAFE
COST 100;