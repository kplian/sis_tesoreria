--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_generar_comprobante (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_plan_pago integer,
  p_id_depto_conta integer
)
RETURNS varchar [] AS
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
    v_registros_pro   	record;
    v_ejecutado 		numeric;
    v_comprometido		numeric;
   
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
    v_id_int_comprobante integer;
    
    v_id_tipo_estado integer;
	
    
BEGIN

	v_nombre_funcion = 'tes.f_generar_comprobante';
    v_id_moneda_base =  param.f_get_moneda_base();
    
  
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
           pp.id_obligacion_pago,
           op.id_depto_conta,
           op.id_obligacion_pago,
           op.id_moneda,
           pp.tipo,
           tpp.codigo_plantilla_comprobante
           into
           v_registros
           FROM tes.tplan_pago pp
           inner join tes.tobligacion_pago op on op.id_obligacion_pago = pp.id_obligacion_pago and op.estado_reg = 'activo'
           inner join tes.ttipo_plan_pago tpp on tpp.codigo = pp.tipo and tpp.estado_reg = 'activo'
           where pp.id_plan_pago = p_id_plan_pago;
        
        
                    
          -- verifica el depto de conta, si no tiene lo modifica
          
         
          
          
          IF v_registros.id_depto_conta is NULL THEN
             --registra el depto de conta
             
             IF p_id_depto_conta is not null THEN
          
                 update tes.tobligacion_pago set
                   id_depto_conta =  p_id_depto_conta
                 where id_obligacion_pago = v_registros.id_obligacion_pago;
             ELSE 
             
             raise exception 'no eligio un depto de contabilidad';
             
             END IF;
          
          ELSE
          
              IF v_registros.id_depto_conta != p_id_depto_conta THEN
              
                 raise exception 'El departamento de contabilidad no coincide con el registrado para  las anteriores cuotas del plan de pago';
                        
              END IF;
          
          
          
          END IF;
          
          
          
          -- obtener el estado de la cuota anterior
          --validar que no se salte el orden de los devengados
                
                IF  EXISTS (SELECT 1 
                FROM tes.tplan_pago pp 
                WHERE pp.id_obligacion_pago = v_registros.id_obligacion_pago
                      and (pp.estado != 'devengado' and pp.estado != 'pagado' and pp.estado != 'anulado' and pp.estado != 'anticipado')
                      and pp.estado_reg = 'activo'
                      and  pp.nro_cuota < v_registros.nro_cuota ) THEN
                      
                      
                    raise exception 'Antes de Continuar,  la cuotas anteriores tienes que estar finalizadas';
                 
                 
                 END IF;
                 
                 
            
          
               
          
          v_sw_verificacion = true;
          v_mensaje_verificacion ='';
          v_cont =1;
          
          
          IF v_registros.tipo in ('devengado_pagado','devengado_pagado_1c','devengado_pagado_1c','ant_aplicado','rendicion') THEN
                 
           
           		--verifica si el presupuesto comprometido sobrante alcanza para pagar el monto de la cuota prorrateada correspondiente al pago
                
                  FOR  v_registros_pro in ( 
                                 select  
                                   pro.id_prorrateo,
                                   pro.monto_ejecutar_mb,
                                   pro.monto_ejecutar_mo,
                                   od.id_partida_ejecucion_com,
                                   od.descripcion,
                                   od.id_concepto_ingas
                                 from  tes.tprorrateo pro
                                 inner join tes.tobligacion_det od on od.id_obligacion_det = pro.id_obligacion_det   
                                 where  pro.id_plan_pago = p_id_plan_pago
                                   and pro.estado_reg = 'activo') LOOP
                
                
                        v_comprometido=0;
                        v_ejecutado=0;
				        SELECT 
                               ps_comprometido, 
                               COALESCE(ps_ejecutado,0)  
                           into 
                               v_comprometido,
                               v_ejecutado
                        FROM pre.f_verificar_com_eje_pag(v_registros_pro.id_partida_ejecucion_com, v_registros.id_moneda);
                
                   
                      --verifica si el presupuesto comprometido sobrante alcanza para devengar
                      IF  ( v_comprometido - v_ejecutado)  <  v_registros_pro.monto_ejecutar_mo   THEN
                         
                         -- raise EXCEPTION  '% - % = % < %',v_comprometido,v_ejecutado,v_comprometido - v_ejecutado, v_registros_pro.monto_ejecutar_mb;
                    
                         select 
                          cig.desc_ingas
                         into
                          v_desc_ingas
                         from  param.tconcepto_ingas cig 
                         where cig.id_concepto_ingas  = v_registros_pro.id_concepto_ingas;
                         
                          --sinc_presupuesto
                          v_mensaje_verificacion =v_mensaje_verificacion ||v_cont::varchar||') '||v_desc_ingas||'('||  substr(v_registros_pro.descripcion, 0, 15)   ||'...)'||' monto faltante ' || (v_registros_pro.monto_ejecutar_mo - (v_comprometido - v_ejecutado))::varchar||' \n';
                          v_sw_verificacion=false;
                          v_cont = v_cont +1;
                     
                      END IF;
                      
                     
                
                   END LOOP;
                  
                  IF not v_sw_verificacion THEN
                  
                     
                      UPDATE  tes.tplan_pago pp set
                       sinc_presupuesto = 'si'
                      where  pp.id_plan_pago=p_id_plan_pago;  
                      
                      
                     v_respuesta[1]='FALSE'; 
                     v_respuesta[2]='Falta Presupuesto según el siguiente detalle :\n '||v_mensaje_verificacion;
                     RETURN v_respuesta;
                  ELSE
                  
                  
                  
                  END IF;
           
           
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
              
          
            IF v_registros.monto_ejecutar_total_mo != v_registros.total_prorrateado  or  v_monto_ejecutar_mo != v_registros.monto_ejecutar_total_mo THEN
                      
              raise exception 'El total prorrateado no iguala con el monto total a ejecutar';
            
            END IF;
            
            
             
          
           ---------------------------------------
           ----  Generacion del Comprobante  -----
           ---------------------------------------
        
            v_id_int_comprobante =   conta.f_gen_comprobante (v_registros.id_plan_pago,v_registros.codigo_plantilla_comprobante,p_id_usuario,p_id_usuario_ai,p_usuario_ai);
            
            --  actualiza el id_comprobante en el registro del plan de pago
            
            update tes.tplan_pago set
              id_int_comprobante = v_id_int_comprobante
            where id_plan_pago = v_registros.id_plan_pago;
            
                  
            --------------------------------------------------------
            ---cambio al siguiente estado de borrador a Pendiente----
            ---------------------------------------------------------
            
             
             -- obtiene el siguiente estado del flujo
              
            -- pasar la solicitud a estado pendiente, que quiere decir que el comprobante esta generado a espera de validacion
           
             
            
            select   
              te.id_tipo_estado
            into
              v_id_tipo_estado
            from wf.ttipo_estado te 
            inner join wf.tproceso_wf  pw on pw.id_tipo_proceso = te.id_tipo_proceso 
                  and pw.id_proceso_wf = v_registros.id_proceso_wf
            where te.codigo = 'pendiente'; 
              
            
            
            
            IF v_id_tipo_estado is  null THEN
            
             raise exception 'El proceso de WF esta mal parametrizado, no tiene el estado pendiente';
            
            END IF;
            
            
        
            
            --registrar el siguiente estado detectado
             v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado, 
                                                           NULL, 
                                                           v_registros.id_estado_wf, 
                                                           v_registros.id_proceso_wf,
                                                           p_id_usuario,
                                                           p_id_usuario_ai,
                                                           p_usuario_ai,
                                                           v_registros.id_depto,
                                                           'La solicitud de '||v_registros.tipo ||'pasa a Contabilidad');
            
            
            
             -- actualiza estado en la solicitud
            
             update tes.tplan_pago  set 
               id_estado_wf =  v_id_estado_actual,
               estado = 'pendiente',
               id_usuario_mod=p_id_usuario,
               fecha_mod=now(),
               id_usuario_ai = p_id_usuario_ai,
               usuario_ai = p_usuario_ai
             where id_plan_pago  = p_id_plan_pago;
  

 v_respuesta[1]= 'TRUE';
 
  

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