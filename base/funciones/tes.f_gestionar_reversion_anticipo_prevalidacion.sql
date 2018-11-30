--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_gestionar_reversion_anticipo_prevalidacion (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_int_comprobante integer,
  p_conexion varchar = NULL::character varying
)
RETURNS boolean AS
$body$
/*

    HISTORIAL:
   	
 ISSUE            FECHA:		           AUTOR                 DESCRIPCION
 #31, ETR       01/11/2017              RAC KPLIAN            Crear la funcion  para  revertir el presupuesto anticipado antres de validar el comprobante
 
               

*/


DECLARE

	 v_nombre_funcion   				text;
	 v_resp							varchar;
     v_registros 					record;
     v_registros_cbte				record;
     v_id_estado_actual  			integer;
     va_id_tipo_estado 				integer[];
     va_codigo_estado 				varchar[];
     va_disparador    				varchar[];
     va_regla        				varchar[]; 
     va_prioridad     				integer[];    
     v_tipo_sol   					varchar;    
     v_nro_cuota 					numeric;    
     v_id_proceso_wf 				integer;
     v_id_estado_wf 				integer;
     v_codigo_estado 				varchar;
     v_id_plan_pago 				integer;
     v_verficacion  				boolean;
     v_verficacion2 				varchar[];     
     v_id_tipo_estado  				integer;
     v_codigo_proceso_llave_wf   	varchar;
     v_tes_anticipo_ejecuta_pres   	varchar;
     
     v_importe						numeric;
     v_importe_mb				    numeric;
     v_total_importe_gasto 	        numeric;
     v_total_importe_recurso 	    numeric;
     v_factor	                    numeric;
     v_factor_mb                    numeric;
     v_total_importe_gasto_mb       numeric;
     v_total_importe_recurso_mb     numeric;
    
BEGIN

        v_nombre_funcion = 'tes.f_gestionar_reversion_anticipo_prevalidacion';
        v_tes_anticipo_ejecuta_pres = pxp.f_get_variable_global('tes_anticipo_ejecuta_pres');
     
       -- 1) con el id_comprobante identificar el plan de pago
        select 
           pp.id_obligacion_pago,
           pp.id_plan_pago,
           pp.tipo,
           pp.estado,
           pp.descuento_anticipo,
           pp.descuento_anticipo_mb
           
         into
          v_registros_cbte  
        from tes.tplan_pago pp
        where pp.id_int_comprobante = p_id_int_comprobante;
         
        
       --2) Validar que se tenga un pla de pagos
        
         IF  v_registros_cbte.id_plan_pago is NULL  THEN
            raise exception 'El comprobante no esta relacionado con plan de pagos';
         END IF;
         
        --  llenar los datos de presupeusto no ejecutado        
        IF v_tes_anticipo_ejecuta_pres = 'si' and  COALESCE(v_registros_cbte.descuento_anticipo  ,0) > 0 THEN
        
                
                --calculat el total a ejecutar
                   select
                             sum(COALESCE(it.importe_gasto,0)) as total_importe_gasto,
                             sum(COALESCE(it.importe_recurso,0)) as total_importe_recurso,
                             sum(COALESCE(it.importe_gasto_mb,0)) as total_importe_gasto_mb,
                             sum(COALESCE(it.importe_recurso_mb,0)) as total_importe_recurso_mb
                    into 
                       v_total_importe_gasto ,
                       v_total_importe_recurso,
                       v_total_importe_gasto_mb ,
                       v_total_importe_recurso_mb                     
                  from conta.tint_transaccion it
                  inner join pre.tpartida par on par.id_partida = it.id_partida
                  inner join pre.tpresupuesto pr on pr.id_centro_costo = 
                  it.id_centro_costo
                  where it.id_int_comprobante = p_id_int_comprobante
                        and it.estado_reg = 'activo'
                        and par.sw_movimiento = 'presupuestaria';
                        
                        
                IF  v_total_importe_gasto > 0 THEN
                     v_factor = v_registros_cbte.descuento_anticipo/v_total_importe_gasto;
                     v_factor_mb = v_registros_cbte.descuento_anticipo_mb/v_total_importe_gasto_mb;
                ELSE 
                    v_factor = v_registros_cbte.descuento_anticipo/v_total_importe_recurso;
                    v_factor_mb = v_registros_cbte.descuento_anticipo_mb/v_total_importe_recurso_mb;
                END IF;
                
                IF p_id_int_comprobante = 9330   THEN
                 
                     --raise exception 'mensaje de error factor % =  % / %', v_factor,  v_registros_cbte.descuento_anticipo  , v_total_importe_gasto ;
                 
                 
                 END IF;
      
                
                
        
                --listado de las transacciones con partidas presupuestaria
                FOR v_registros in (
                                      select
                                         it.id_int_transaccion,
                                         it.id_partida,
                                         it.id_partida_ejecucion,
                                         it.id_partida_ejecucion_dev,
                                         
                                         it.importe_gasto,
                                         it.importe_recurso,                                         
                                         it.importe_gasto_mb,
                                         it.importe_recurso_mb,
                                         it.id_centro_costo,
                                         par.sw_movimiento,  --  presupuestaria o  flujo
                                         par.sw_transaccional,  --titular o movimiento
                                         par.tipo,                -- recurso o gasto
                                         pr.id_presupuesto,
                                         it.importe_reversion,
                                         it.factor_reversion,
                                         par.codigo as codigo_partida,
                                         it.actualizacion
                                      from conta.tint_transaccion it
                                      inner join pre.tpartida par on par.id_partida = it.id_partida
                                      inner join pre.tpresupuesto pr on pr.id_centro_costo =  it.id_centro_costo
                                      where it.id_int_comprobante = p_id_int_comprobante
                                            and it.estado_reg = 'activo'
                                            and par.sw_movimiento = 'presupuestaria' )  LOOP
                                            
                            --selecciona la moneda de trabajo
                            IF v_registros.importe_gasto > 0 THEN 
                               v_importe = v_registros.importe_gasto;
                               v_importe_mb =  v_registros.importe_gasto_mb;
                            ELSE
                               v_importe = v_registros.importe_recurso;
                               v_importe_mb =  v_registros.importe_recurso_mb;
                            END IF;
                            
                            --cacular monto no ejecutado
                            
                            --el monto no ejecutado no puede ser mayor que el monto a eejcutar 
                            
                            IF  v_factor   <= 1 THEN
                            
                                update conta.tint_transaccion tr set
                                  monto_no_ejecutado =   v_importe*v_factor,
                                  monto_no_ejecutado_mb = v_importe_mb*v_factor
                                where tr.id_int_transaccion   = v_registros.id_int_transaccion ;
                                
                            ELSE 
                            
                                update conta.tint_transaccion tr set
                                   monto_no_ejecutado =   v_importe,
                                   monto_no_ejecutado_mb = v_importe_mb
                                where tr.id_int_transaccion   = v_registros.id_int_transaccion ;  
                            
                            
                            END IF;
                            
                                   
                  END LOOP;
                     
                     
                
         END IF;
         
         IF p_id_int_comprobante = 9330   THEN
         
            --raise exception  'LLEga ';  
         
         
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