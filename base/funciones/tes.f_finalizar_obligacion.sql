--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_finalizar_obligacion (
  p_id_obligacion_pago integer,
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar
)
RETURNS boolean AS
$body$
/*
*
*  Autor:   RAC
*  DESC:     Finaliza la obligacion de pago
*  Fecha:   10/06/2013
*
*/

DECLARE

	v_nombre_funcion   	text;
    v_resp    			varchar;
    v_registros   		record;
    v_registros_obli   	record;
    v_ejecutado 		numeric;
    v_comprometido		numeric;
    v_tipo_sol			varchar;
    v_monto_ejecutar_mo	numeric;
    
    va_id_tipo_estado   integer[];
    va_codigo_estado    varchar[];
    va_disparador       varchar[];
    va_regla            varchar[];
    va_prioridad        integer[];
    
    v_id_estado_actual	integer;
    v_id_moneda_base   integer;
    
    v_sw_verificacion  boolean;
    v_mensaje_verificacion varchar;
    v_desc_ingas varchar;
    v_cont integer;
    v_respuesta varchar[];
    v_mensaje varchar;
    v_id_cotizacion integer;
    v_monto_total  numeric;
	
    
BEGIN

	v_nombre_funcion = 'tes.f_finalizar_obligacion';
    v_id_moneda_base =  param.f_get_moneda_base();
      
    
      --obtiene datos de la obligacion
      
       select
       op.id_obligacion_pago,
       op.tipo_obligacion,
       op.estado
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
                     and pp.estado not in ('devengado','pagado', 'anticipado', 'aplicado', 'devuelto')) THEN
          
          
          raise exception 'existen cuotas pendientes de finanización';
          
          END IF;
          
          -----------------
          -- VALIDACIONES
          -----------------
           
          -- validar que  si tiene anticipo parciales exista retenciones por el total
          v_monto_total= tes.f_determinar_total_faltante(p_id_obligacion_pago, 'ant_parcial_descontado');
          IF v_monto_total > 0 THEN
            raise exception 'Tiene pendiente la recuperacion del anticipo por un monto de: %', v_monto_total;
          END IF;
          
         --validamos que si tiene retencion de garantia esten devueltas 
      
         v_monto_total= tes.f_determinar_total_faltante(p_id_obligacion_pago, 'dev_garantia');
         IF v_monto_total > 0 THEN
            raise exception 'Tiene devoluciones de garantia pendiente por un monto de : %', v_monto_total;
         END IF;
      
      
          -- validamos que si tienes anticipos totales   el total este aplicado
      
          v_mensaje = '';
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
                      
                      
                       v_mensaje = v_mensaje||'La cuota '||v_registros.nro_cuota::varchar||'  le fatal aplicar '|| (COALESCE(v_registros.monto,0)-COALESCE(v_registros.total_pagado,0))::varchar||' </br>';
          
          END LOOP;
          
          IF v_mensaje!='' THEN
          
             raise exception 'Existen anticipos no aplicados, % ',v_mensaje;
          
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
                                    and pp.monto_ejecutar_total_mo != pp.total_pagado
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
               --si no es de adquisiciones
               --se revierte el presupeusto  sobrante si existe
               IF not tes.f_gestionar_presupuesto_tesoreria(p_id_obligacion_pago, p_id_usuario, 'revertir')  THEN
                                       
                   raise exception 'Error al revertir el presupuesto';
                                       
               END IF;
       END IF;
      

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
COST 100;