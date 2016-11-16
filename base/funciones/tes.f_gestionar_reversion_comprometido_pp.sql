--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_gestionar_reversion_comprometido_pp (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_int_comprobante integer,
  p_conexion varchar = NULL::character varying
)
RETURNS boolean AS
$body$
/*
Autor: RAC KPLIAN
Fecha:  01 del diciembre de 2015
Descripcion:   
esta funcion revierte el presupuesto si el plan de pagos asociado al comprobantes es devegando , 
aplicacion de anticipo, o devengar y pagar 1c
revierte szolo el monto prorrateado


*/

DECLARE

	v_nombre_funcion   			text;
	v_resp						varchar;
    v_registros 				record; 
    v_registros_pro				record; 
    v_registros_aux				record; 
    va_prioridad     			integer[];
    v_tipo_sol   				varchar;
   
    v_id_plan_pago 				integer;
    v_id_tipo_estado  			integer;
    v_codigo_proceso_llave_wf   varchar;
    v_i  						integer;
    v_monto_cmp 				numeric;
   
     
    va_id_presupuesto 		integer[];
    va_id_partida     		integer[];
    va_momento				INTEGER[];
    va_monto          		numeric[];
    va_id_moneda    		integer[];
    va_id_partida_ejecucion integer[];
    va_columna_relacion     varchar[];
    va_fk_llave             integer[];
    va_resp_ges              numeric[];
    va_fecha                 date[];
    va_id_transaccion        integer[];
    va_id_int_rel_devengado  integer[];
    va_tipo_partida   			varchar[];
    
BEGIN


  

	v_nombre_funcion = 'tes."tes.f_gestionar_reversion_comprometido_pp"';
    
    
    
    -- 1) con el id_comprobante identificar el plan de pago
   
      select 
          pp.id_plan_pago,         
          pp.tipo,
          pp.estado,         
          pp.monto_ejecutar_total_mo,
          pp.monto_no_pagado,
          op.numero,
          op.id_moneda,
          c.fecha,
          c.nro_tramite
      into
         v_registros
      from  tes.tplan_pago pp
      inner join tes.tobligacion_pago  op on op.id_obligacion_pago = pp.id_obligacion_pago and op.estado_reg = 'activo'
      inner join tes.ttipo_plan_pago tpp on tpp.codigo = pp.tipo and tpp.estado_reg = 'activo'
      inner join conta.tint_comprobante  c on c.id_int_comprobante = pp.id_int_comprobante 
	  where  pp.id_int_comprobante = p_id_int_comprobante; 
    
    
    --2) Validar que tenga un plan de pago
     IF  v_registros.id_plan_pago is NULL  THEN
       raise exception 'El comprobante no esta relacionado con nigun plan de pagos';
     END IF;
    
   
    IF  v_registros.tipo = 'devengado_pagado'  THEN
       
        --   listar los prorrateos del plan de pago        
        v_i = 0;
        
        FOR v_registros_pro in (select 
                                  od.id_partida_ejecucion_com,
                                  od.id_partida,
                                  od.id_centro_costo,
                                  pr.monto_ejecutar_mo,
                                  pr.id_int_transaccion,
                                  pr.id_prorrateo                                  
                                from tes.tprorrateo pr
                                inner join tes.tobligacion_det od on od.id_obligacion_det = pr.id_obligacion_det
                                where pr.id_plan_pago = v_registros.id_plan_pago and
                                      pr.estado_reg = 'activo' and 
                                      od.estado_reg = 'activo' ) LOOP
        
               --  preparar montos a revertir 
               v_monto_cmp = v_registros_pro.monto_ejecutar_mo*(-1);
               v_i = v_i + 1;
            
               
               va_momento[v_i]	= 2;   --reversion 2 (pero el valor del monto debe ser negativo)           
               va_fecha[v_i] = v_registros.fecha; --fecha del cbte               
               va_id_presupuesto[v_i] = v_registros_pro.id_centro_costo;
               va_id_partida[v_i]= v_registros_pro.id_partida;
               
               va_monto[v_i]  = v_monto_cmp;
               va_id_moneda[v_i]  = v_registros.id_moneda;
               va_id_partida_ejecucion [v_i] = v_registros_pro.id_partida_ejecucion_com ;   
               va_columna_relacion[v_i]= 'id_int_transaccion';
               va_fk_llave[v_i] = v_registros_pro.id_prorrateo;
              
               
                 
        
        END LOOP;
        
        
        -------------------------------------------------------------------------
         --   eliminar partidas ejecucion de las transacciones en el comprobante 
         --   como el presupeusto fue revertido eliminamos los anteriores
         -----------------------------------------------------------------------
        
        FOR v_registros_aux in (
                             select 
                               t.id_int_transaccion
                             from conta.tint_transaccion t
                             where t.id_int_comprobante = p_id_int_comprobante
                                   and t.estado_reg = 'activo'
                                   and t.id_partida_ejecucion is not NULL
                             ) LOOP
                  
                  update conta.tint_transaccion t set
                  id_partida_ejecucion = NULL
                  where id_int_transaccion = v_registros_aux.id_int_transaccion;
        
        END LOOP;
       
	
        --------------------------------------------
        --   revertir el presupuesto comprometido
        ----------------------------------------------
        
        va_resp_ges =  pre.f_gestionar_presupuesto(p_id_usuario,
                                                    NULL, --tipo cambio
                                                    va_id_presupuesto, 
                                                    va_id_partida, 
                                                    va_id_moneda, 
                                                    va_monto, 
                                                    va_fecha, --p_fecha
                                                    va_momento, 
                                                    va_id_partida_ejecucion,--  p_id_partida_ejecucion 
                                                    va_columna_relacion, 
                                                    va_fk_llave,
                                                    v_registros.nro_tramite,
                                                    p_id_int_comprobante,
                                                    p_conexion);
        
         
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