--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_gestionar_cuota_plan_pago (
  p_id_usuario integer,
  p_id_comprobante integer
)
RETURNS boolean AS
$body$
/*

Autor: RAC KPLIAN
Fecha:   6 junio de 2013
Descripcion  Esta funcion gestion los planes de pago de la siguiente manera


    Cuando un comprobante de devegado o pago es validado  ->   cambia el estado de la cuota.

    

*/


DECLARE
  
	v_nombre_funcion   	text;
	v_resp				varchar;
    
    
    v_registros 		record;
    
    v_id_estado_actual  integer;
    
    
    va_id_tipo_estado integer[];
    va_codigo_estado varchar[];
    va_disparador    varchar[];
    va_regla         varchar[]; 
    va_prioridad     integer[];
    
    v_tipo_sol   varchar;
    
BEGIN

	v_nombre_funcion = 'tes.f_gestionar_cuota_plan_pago';
    
    
    
    -- 1) con el id_comprobante identificar el plan de pago
   
      select 
      pp.id_plan_pago,
      pp.id_estado_wf,
      pp.id_proceso_wf,
      pp.tipo,
      pp.estado,
      pp.id_plan_pago_fk,
      pp.id_obligacion_pago,
      pp.nro_cuota,
      pp.id_plantilla,
      pp.monto_ejecutar_total_mo,
      pp.monto_ejecutar_total_mb,
      pp.monto_no_pagado,
      pp.monto_no_pagado_mb,
      pp.obs_descuentos_anticipo,
      pp.obs_monto_no_pagado,
      pp.obs_otros_descuentos,
      op.id_depto  
      into
      v_registros
      from  tes.tplan_pago pp
      inner join tes.tobligacion_pago  op on op.id_obligacion_pago = pp.id_obligacion_pago 
      where  pp.id_comprobante = p_id_comprobante; 
    
    
    --2) Validar que tenga un plan de pago
    
    
     IF  v_registros.id_plan_pago is NULL  THEN
     
        raise exception 'El comproante no esta relacionado con nigun plan de pagos';
     
     END IF;
    
    
    
    -- 3)  Si es devengado_pagado o   devengado, se identifica  con id_plan_pago_fk = null
    
    
    IF  v_registros.id_plan_pago_fk is NULL  THEN
    
        -- 3.1)  si es tipo es devengado_pago
           IF   v_registros.tipo = 'devengado_pago' THEN
           
                 
         	-- 3.1.1) genera la cuota de pago.
       
                   /* INSERT INTO 
                        tes.tplan_pago
                      (
                        id_usuario_reg,
                        id_usuario_mod,
                        fecha_reg,
                        fecha_mod,
                        estado_reg,
                        id_plan_pago,
                        id_obligacion_pago,
                        id_plantilla,
                        id_plan_pago_fk,
                        id_cuenta_bancaria,
                        id_comprobante,
                        id_estado_wf,
                        id_proceso_wf,
                        estado,
                        nro_sol_pago,
                        nro_cuota,
                        nombre_pago,
                        forma_pago,
                        tipo_pago,
                        tipo,
                        fecha_tentativa,
                        fecha_dev,
                        fecha_pag,
                        tipo_cambio,
                        obs_descuentos_anticipo,
                        obs_monto_no_pagado,
                        obs_otros_descuentos,
                        monto,
                        descuento_anticipo,
                        monto_no_pagado,
                        otros_descuentos,
                        monto_mb,
                        descuento_anticipo_mb,
                        monto_no_pagado_mb,
                        otros_descuentos_mb,
                        monto_ejecutar_total_mo,
                        monto_ejecutar_total_mb,
                        total_prorrateado,
                        liquido_pagable,
                        liquido_pagable_mb
                      ) 
                      VALUES (
                        :id_usuario_reg,
                        :id_usuario_mod,
                        :fecha_reg,
                        :fecha_mod,
                        :estado_reg,
                        :id_plan_pago,
                        :id_obligacion_pago,
                        :id_plantilla,
                        :id_plan_pago_fk,
                        :id_cuenta_bancaria,
                        :id_comprobante,
                        :id_estado_wf,
                        :id_proceso_wf,
                        :estado,
                        :nro_sol_pago,
                        :nro_cuota,
                        :nombre_pago,
                        :forma_pago,
                        :tipo_pago,
                        :tipo,
                        :fecha_tentativa,
                        :fecha_dev,
                        :fecha_pag,
                        :tipo_cambio,
                        :obs_descuentos_anticipo,
                        :obs_monto_no_pagado,
                        :obs_otros_descuentos,
                        :monto,
                        :descuento_anticipo,
                        :monto_no_pagado,
                        :otros_descuentos,
                        :monto_mb,
                        :descuento_anticipo_mb,
                        :monto_no_pagado_mb,
                        :otros_descuentos_mb,
                        :monto_ejecutar_total_mo,
                        :monto_ejecutar_total_mb,
                        :total_prorrateado,
                        :liquido_pagable,
                        :liquido_pagable_mb
                      );
                    */
            
            
            
            -- 3.1.2)  cambiar el estado de la cuota recien creada, lo pasa a pendiente   
              
              
            --  3.2.3) llamada a la generacion del comprobante de pago  
      
    
            END IF;
         
        
         v_tipo_sol  = 'Devengado';
         
      ELSE  
      
        v_tipo_sol  = 'Pago';    
          
      END IF;
   

     -- 4   No importa si es devengado o pago, cambia de estado la cuota, 
    
    --------------------------------------------------------
    ---  cambiar el estado de la cuota                 -----
    --------------------------------------------------------
        
        
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
              
              
              --raise exception '--  % ,  % ,% ',v_id_proceso_wf,v_id_estado_wf,va_codigo_estado;
              
              
              IF va_codigo_estado[2] is not null THEN
              
               raise exception 'El proceso de WF esta mal parametrizado,  solo admite un estado siguiente para el estado: %', v_registros.estado;
              
              END IF;
              
               IF va_codigo_estado[1] is  null THEN
              
               raise exception 'El proceso de WF esta mal parametrizado, no se encuentra el estado siguiente,  para el estado: %', v_registros.estado;           
              END IF;
              
              
            
              
              -- estado siguiente
               v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado[1], 
                                                             NULL, 
                                                             v_registros.id_estado_wf, 
                                                             v_registros.id_proceso_wf,
                                                             p_id_usuario,
                                                             v_registros.id_depto,
                                                             'Comprobante de '||v_tipo_sol||' fue validado');
              
              
              
             
          
          
              -- actualiza estado en la solicitud
              
              IF v_tipo_sol = 'Devengado' THEN
                 
                 update tes.tplan_pago pp  set 
                   id_estado_wf =  v_id_estado_actual,
                   estado = va_codigo_estado[1],
                   id_usuario_mod=p_id_usuario,
                   fecha_mod=now(),
                   fecha_dev = now()
                 where id_plan_pago  = v_registros.id_plan_pago;    
              
              ELSE
                
                update tes.tplan_pago pp  set 
                     id_estado_wf =  v_id_estado_actual,
                     estado = va_codigo_estado[1],
                     id_usuario_mod=p_id_usuario,
                     fecha_mod=now(),
                     fecha_pag = now()
                   where id_plan_pago  = v_registros.id_plan_pago;    
             
              END IF;
    
  
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