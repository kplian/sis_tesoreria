--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_generar_comprobante (
  p_id_usuario integer,
  p_id_plan_pago integer
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
    v_tipo_sol			varchar;
    v_monto_ejecutar_mo	numeric;
    
    va_id_tipo_estado   integer[];
    va_codigo_estado    varchar[];
    va_disparador       varchar[];
    va_regla            varchar[];
    va_prioridad        integer[];
    
    v_id_estado_actual	integer;
	
    
BEGIN

	v_nombre_funcion = 'tes.f_generar_comprobante';

    --  obtinen datos del plan de pagos
           
           SELECT
           pp.id_plan_pago,
           pp.id_plan_pago_fk,
           pp.id_plantilla,
           pp.id_estado_wf,
           pp.estado,
           pp.id_proceso_wf,
           op.id_depto,
           pp.tipo_pago,
           pp.monto_ejecutar_total_mo,
           pp.total_prorrateado,
           pp.nro_cuota,
           pp.id_obligacion_pago
           into
           v_registros
           FROM tes.tplan_pago pp
           inner join tes.tobligacion_pago op on op.id_obligacion_pago = pp.id_obligacion_pago
           where pp.id_plan_pago = p_id_plan_pago;
        
        
          IF  v_registros.estado != 'borrador' THEN
          
          
             raise exception 'Solo puede solicitarce el devengado o pago de registros en borrador';
          
          
          END IF;
          
          
          
          
          -- obtener el estado de la cuota anterior
          --validar que no se salte el orden de los devengados
                
                IF  EXISTS (SELECT 1 
                FROM tes.tplan_pago pp 
                WHERE pp.id_obligacion_pago = v_registros.id_obligacion_pago
                      and (pp.estado != 'devengado' and pp.estado != 'pagado' and pp.estado != 'anulado')
                      and pp.estado_reg = 'activo'
                      and  pp.nro_cuota < v_registros.nro_cuota ) THEN
                      
                      
                    raise exception 'Antes de Finalizar la cuotas anteriores tienes que estar finalizadas';
                 
                 
                 END IF;
                 
                 
            
          
               
          
          
          
          
          IF v_registros.id_plan_pago_fk is NULL THEN
           
           		v_tipo_sol = 'devengado';
                
                --verifica si el presupuesto comprometido sobrante alcanza para pagar el monto de la cuota prorrateada corepondiente al pago
                
               /*   --for  v_registro_pro in ( 
                                 select  * 
                                 from  tes.tprorrateo 
                                 where 
                
                
                
				SELECT * FROM pre.f_verificar_com_eje_pag(145088, 1);*/
                
                
                
                
                --TO DO, generar numero de devengado
                
                
           
           
           
           
           
           
           
           ELSE
               --VALIDAR QUE nose se salte el orden de los pagos
           
           		v_tipo_sol = 'pago';
                
                --TO DO,  generar numero de pago
           
           END IF;
          
          
          
          
          ------------------------------------
          -- validacion del prorrateo--    no estoy seguro si funciona la misma idea para el pago
          ------------------------------------
            select
              sum( pro.monto_ejecutar_mo)
           into
              v_monto_ejecutar_mo
            from tes.tprorrateo pro
            where pro.estado_reg = 'activo' and  
              pro.id_plan_pago  = p_id_plan_pago;
              
          
            IF v_registros.monto_ejecutar_total_mo != v_registros.total_prorrateado THEN
                      
              raise exception 'El total prorrateado no iguala con el monto total a ejecutar';
            
            END IF;
            
            
             
          
          ---------------------------------------
          ----  Generacion del Comprobante  -----
          ---------------------------------------
        
            IF v_tipo_sol ='devengado' THEN
            
                -- TO DO llamda a la generaciond e comprobante de devengado 
                  
                 
           
            ELSIF v_tipo_sol ='pago' THEN
                 --TO DO,  llamada a la generacion de comprobante de pago
            
            
            
                      
            END IF;
            
            
            --  TO DO, actualiza el id_comprobante en el registro del plan de pago
            
            
            
            
                  
            --------------------------------------------------------
            ---cambio al siguiente estado de borrador a Pendiente----
            ---------------------------------------------------------
            
             
             -- obtiene el siguiente estado del flujo 
             SELECT 
                 *
              into
                va_id_tipo_estado,
                va_codigo_estado,
                va_disparador,
                va_regla,
                va_prioridad
            
            FROM wf.f_obtener_estado_wf(v_registros.id_proceso_wf, v_registros.id_estado_wf,NULL,'siguiente');
            
            
            IF va_codigo_estado[2] is not null THEN
            
             raise exception 'El proceso de WF esta mal parametrizado, el estado borrador de la obligacion solo admite un estado ';
            
            END IF;
            
             IF va_codigo_estado[1] is  null THEN
            
             raise exception 'El proceso de WF esta mal parametrizado, no se encuentra el estado siguiente ';
            
            END IF;
            
            
          
            
            -- hay que recuperar el supervidor que seria el estado inmediato,...
             v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado[1], 
                                                           NULL, 
                                                           v_registros.id_estado_wf, 
                                                           v_registros.id_proceso_wf,
                                                           p_id_usuario,
                                                           v_registros.id_depto,
                                                           'La solicitud de '||v_tipo_sol ||'pasa a Contabilidad');
            
            
            
             -- actualiza estado en la solicitud
            
             update tes.tplan_pago  set 
               id_estado_wf =  v_id_estado_actual,
               estado = va_codigo_estado[1],
               id_usuario_mod=p_id_usuario,
               fecha_mod=now()
             where id_plan_pago  = p_id_plan_pago;
  


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