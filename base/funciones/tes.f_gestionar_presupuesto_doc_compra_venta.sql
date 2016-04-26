--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_gestionar_presupuesto_doc_compra_venta (
  p_id_doc_compra_venta integer,
  p_id_proceso_caja integer,
  p_id_usuario integer,
  p_operacion varchar,
  p_conexion varchar = NULL::character varying
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION 		tes.f_gestionar_presupuesto_doc_compra_venta(p_id_solicitud_efectivo integer, p_id_usuario integer, p_operacion varchar)
                
 DESCRIPCION:   Esta funcion a partir del id Documento Compra Venta se encarga de gestionar el presupuesto,
                comprometer
                revertir
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        09-03-2016
 COMENTARIOS:	
***************************************************************************/

DECLARE
  v_registros record;
  v_nombre_funcion varchar;
  v_resp varchar;
 
  va_id_presupuesto integer[];
  va_id_partida     integer[];
  va_momento		INTEGER[];
  va_monto          numeric[];
  va_id_moneda    	integer[];
  va_id_partida_ejecucion integer[];
  va_columna_relacion     varchar[];
  va_fk_llave             integer[];
  va_nro_tramite		  varchar[];
  v_i   				  integer;
  v_cont				  integer;
  va_id_solicitud_efectivo_det	  integer[];
  va_id_doc_concepto		INTEGER[];
  v_id_moneda_base		  integer;
  va_resp_ges              numeric[];
  
  va_fecha                date[];
  
  v_monto_a_revertir 	numeric;
  v_aux 				numeric;
  v_comprometido  	    numeric;
  v_comprometido_ga     numeric;
  v_ejecutado     	    numeric;
  
  v_monto_a_revertir_mb  numeric;
  v_ano_1 				integer;
  v_ano_2 				integer;
  v_reg_sol				record;
  v_fecha 				date;
  v_id_partida			integer;
  

  
BEGIN
 
  v_nombre_funcion = 'tes.f_gestionar_presupuesto_doc_compra_venta';
   
  v_id_moneda_base =  param.f_get_moneda_base();

  
  
      IF p_operacion = 'comprometer' THEN
        
          --compromete al aprobar la solicitud de efectivo
           v_i = 0;
           
          -- verifica que solicitud
          FOR v_registros in ( 
                                  SELECT dc.id_doc_compra_venta,
                                         dc.id_centro_costo,
                                         dc.id_centro_costo as id_presupuesto,
                                         cv.id_moneda,
                                         dc.precio_total_final,
                                         sol.nro_tramite,
                                         sol.fecha,
                                         dc.id_concepto_ingas,
                                         dc.id_doc_concepto,
                                         dc.id_partida_ejecucion,
                                         cig.desc_ingas,
                                         sol.id_gestion
                                         
                                  FROM conta.tdoc_compra_venta cv
                                  INNER JOIN conta.tdoc_concepto dc on dc.id_doc_compra_venta = cv.id_doc_compra_venta
                                  INNER JOIN tes.tsolicitud_rendicion_det rd on rd.id_documento_respaldo=cv.id_doc_compra_venta
                                  inner join tes.tsolicitud_efectivo sol on sol.id_solicitud_efectivo=rd.id_solicitud_efectivo
                                  inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = dc.id_concepto_ingas
                                  WHERE dc.id_doc_compra_venta = p_id_doc_compra_venta and
                                        dc.estado_reg = 'activo') LOOP
                                     
                     
                     IF (v_registros.id_partida_ejecucion IS NOT NULL) THEN                     
                        raise exception 'El presupuesto ya se encuentra comprometido';                     
                     END IF;
                                          
                     
                     v_i = v_i +1;     
                     
                    -- recuperar la partida de la relacion contable de compras
                    SELECT 
                        ps_id_partida
                     into 
                        v_id_partida
                    FROM conta.f_get_config_relacion_contable('CUECOMP', v_registros.id_gestion, v_registros.id_concepto_ingas, v_registros.id_centro_costo,  'No se encontro relación contable para el conceto de gasto: '||v_registros.desc_ingas||'. <br> Mensaje: ');
                    
                    IF  v_id_partida  is NULL  THEN
                      raise exception 'No se encontro partida para el concepto de gasto y el centro de costos solicitados';
                    END IF;
                     
                    --  armamos los array para enviar a presupuestos     
           
                    va_id_presupuesto[v_i] = v_registros.id_presupuesto;
                    va_id_partida[v_i]= v_id_partida;
                    va_momento[v_i]	= 1; --el momento 1 es el comprometido
                    va_monto[v_i]  = v_registros.precio_total_final; 
                    va_id_moneda[v_i]  = v_registros.id_moneda;                   
                    va_columna_relacion[v_i]= 'id_doc_concepto';
                    va_fk_llave[v_i] = v_registros.id_doc_concepto;
                    va_nro_tramite[v_i] = v_registros.nro_tramite;
                    va_id_doc_concepto[v_i] = v_registros.id_doc_concepto;
                                        
                    -- la fecha de reversion como maximo puede ser el 31 de diciembre   
                  
                      
                       
                    IF  now()  < v_registros.fecha THEN
                      v_fecha = v_registros.fecha::date;
                    ELSE
                       -- la fecha de reversion como maximo puede ser el 31 de diciembre   
                       v_fecha = now()::date;
                       v_ano_1 =  EXTRACT(YEAR FROM  now()::date);
                       v_ano_2 =  EXTRACT(YEAR FROM  v_registros.fecha::date);
                       
                       IF  v_ano_1  >  v_ano_2 THEN
                         v_fecha = ('31-12-'|| v_ano_2::varchar)::date;
                       END IF;
                    END IF;      
                  
                   va_fecha[v_i] = v_registros.fecha::date;
                   
             
             
             END LOOP;
             
              IF v_i > 0 THEN 
              
                    --llamada a la funcion de compromiso
                    va_resp_ges =  pre.f_gestionar_presupuesto(p_id_usuario,
                    										   NULL, --tipo cambio
                                                               va_id_presupuesto, 
                                                               va_id_partida, 
                                                               va_id_moneda, 
                                                               va_monto, 
                                                               va_fecha, --p_fecha
                                                               va_momento, 
                                                               NULL,--  p_id_partida_ejecucion 
                                                               va_columna_relacion, 
                                                               va_fk_llave,
                                                               va_nro_tramite,--nro_tramite
                                                               NULL,
                                                               p_conexion);
                 
                
                 
                 --actualizacion de los id_partida_ejecucion en el detalle de solicitud
                             
                 
                   FOR v_cont IN 1..v_i LOOP
                       update conta.tdoc_concepto  s set
                         id_partida_ejecucion = va_resp_ges[v_cont],
                         fecha_mod = now(),
                         id_usuario_mod = p_id_usuario
                      where s.id_doc_concepto =  va_id_doc_concepto[v_cont];
                   END LOOP;
             END IF;
  
        ELSIF p_operacion = 'revertir' THEN
            
            v_i = 0;
            
         
           -- raise exception 'p_id_proceso_caja %',p_id_proceso_caja;
            
            FOR v_registros in ( 
                                  SELECT dc.id_doc_compra_venta,
                                         dc.id_centro_costo,
                                         dc.id_partida_ejecucion ,
                                         cv.id_moneda,
                                         dc.precio_total_final,
                                         sol.nro_tramite,
                                         dc.id_concepto_ingas,
                                         dc.id_doc_concepto,
                                         dc.id_partida_ejecucion,
                                         pc.fecha as fecha_reversion
                                  FROM conta.tdoc_compra_venta cv
                                  INNER JOIN conta.tdoc_concepto dc on dc.id_doc_compra_venta = cv.id_doc_compra_venta
                                 
                                 
                                  INNER JOIN tes.tsolicitud_rendicion_det rd on rd.id_documento_respaldo=cv.id_doc_compra_venta
                                  inner join tes.tsolicitud_efectivo sol on sol.id_solicitud_efectivo=rd.id_solicitud_efectivo
                                  inner join tes.tproceso_caja pc on pc.id_proceso_caja = rd.id_proceso_caja
                                   WHERE rd.id_proceso_caja = p_id_proceso_caja
                                          and  dc.estado_reg = 'activo') LOOP
                                        
                      IF(v_registros.id_partida_ejecucion is NULL) THEN
                         raise exception 'El presupuesto del detalle con el identificador (%)  no se encuntra comprometido',v_registros.id_doc_concepto;
                      END IF;
                      
                      SELECT 
                             COALESCE(ps_comprometido,0), 
                             COALESCE(ps_ejecutado,0)  
                         into 
                             v_comprometido,
                             v_ejecutado
                      FROM pre.f_verificar_com_eje_pag(v_registros.id_partida_ejecucion,v_registros.id_moneda);
                                        
                     
                     --la fecha de reversion no puede ser anterior a la fecha de la solictud
                    -- la fecha de solictud es la fecha de compromiso 
                    IF  now()  < v_registros.fecha_reversion THEN
                      v_fecha = v_registros.fecha_reversion::date;
                    ELSE
                       -- la fecha de reversion como maximo puede ser el 31 de diciembre   
                       v_fecha = now()::date;
                       v_ano_1 =  EXTRACT(YEAR FROM  now()::date);
                       v_ano_2 =  EXTRACT(YEAR FROM  v_registros.fecha_reversion::date);
                       
                       IF  v_ano_1  >  v_ano_2 THEN
                         v_fecha = ('31-12-'|| v_ano_2::varchar)::date;
                       END IF;
                    END IF; 
                    
                     --armamos los array para enviar a presupuestos          
                    IF v_comprometido - v_ejecutado > 0 THEN
                     
                       	v_i = v_i +1;             
                        va_id_presupuesto[v_i] = NULL;--v_registros.id_presupuesto;
                        va_id_partida[v_i] = NULL;--v_registros.id_partida;
                        va_momento[v_i]	= 2; --el momento 2 con signo negativo  es revertir
                        va_monto[v_i]  =  (v_comprometido  - v_ejecutado)*-1;  -- considera la posibilidad de que a este item se le aya revertido algun monto
                        va_id_moneda[v_i]  = v_registros.id_moneda;
                        va_id_partida_ejecucion[v_i] = v_registros.id_partida_ejecucion;
                        va_columna_relacion[v_i] = 'id_doc_concepto';
                        va_fk_llave[v_i] = v_registros.id_doc_concepto;
                        va_nro_tramite[v_i] = v_registros.nro_tramite;
                        va_fecha[v_i] = v_fecha;
                        
                    END IF;                    
                                        
                                        
           END LOOP; 
           
         
         --raise exception '>>  %',va_monto;
           
            --llamada a la funcion de  reversion
           IF v_i > 0 THEN 
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
                                                             va_nro_tramite,
                                                             NULL,
                                                             p_conexion
                                                             );
          END IF;
             
             
          
        ELSE  
          raise exception 'Operación no implementada';
        END IF;
   

  
  return  TRUE;


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