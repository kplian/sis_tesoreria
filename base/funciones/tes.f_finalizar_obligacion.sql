--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_finalizar_obligacion (
  p_id_obligacion_pago integer,
  p_id_usuario integer
)
RETURNS boolean AS
$body$
/*
*
*  Autor:   RAC
*  DESC:     Generar comprobantes de devengado o pago segun correponda al tipo de plan de pago
*            y pasa al siguiente estado
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
    
    
    
     --  verificamos que el total de los pagos esten devengados o pagado
         IF EXISTS( select 
                 1
               from tes.tplan_pago pp
               where pp.id_obligacion_pago =  p_id_obligacion_pago  
                    and pp.estado_reg = 'activo'
                    and pp.estado not in ('devengado','pagado')) THEN
          
          
          raise exception 'existen cuotas pendientes de finanización';
          
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
                 
                 
                 IF not adq.f_finalizar_cotizacion(v_id_cotizacion, p_id_usuario)  THEN
                                     
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