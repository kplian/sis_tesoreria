--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_gestionar_presupuesto_doc_compra_venta (
  p_id_doc_compra_venta integer,
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
  v_ano_1 integer;
  v_ano_2 integer;
  v_reg_sol				record;
  

  
BEGIN
 
  v_nombre_funcion = 'tes.f_gestionar_presupuesto_doc_compra_venta';
   
  v_id_moneda_base =  param.f_get_moneda_base();
  /*
  select 
    s.nro_tramite
  into
   v_reg_sol
  from tes.tsolicitud_efectivo s
  where s.id_solicitud_efectivo = p_id_solicitud_efectivo;
  */
  
  
      IF p_operacion = 'comprometer' THEN
        
          --compromete al aprobar la solicitud de efectivo
           v_i = 0;
           
           -- verifica que solicitud
       
          FOR v_registros in ( 
                                  SELECT dc.id_doc_compra_venta,
                                         dc.id_centro_costo,
                                         cp.id_partida,
                                         p.id_presupuesto,
                                         cv.id_moneda,
                                         dc.precio_total_final,
                                         sol.nro_tramite,
                                         dc.id_concepto_ingas,
                                         dc.id_doc_concepto,
                                         dc.id_partida_ejecucion
                                  FROM conta.tdoc_compra_venta cv
                                  INNER JOIN conta.tdoc_concepto dc on dc.id_doc_compra_venta = cv.id_doc_compra_venta
                                  inner join pre.tpresupuesto p on p.id_centro_costo = dc.id_centro_costo
                                  inner join pre.tconcepto_partida cp on cp.id_concepto_ingas = dc.id_concepto_ingas
                                  INNER JOIN tes.tsolicitud_rendicion_det rd on rd.id_documento_respaldo=cv.id_doc_compra_venta
                                  inner join tes.tsolicitud_efectivo sol on sol.id_solicitud_efectivo=rd.id_solicitud_efectivo
                                  inner join pre.tpartida par on par.id_partida = cp.id_partida and par.id_gestion in (select id_gestion 
                                                                                                                       from param.tperiodo
                                                                                                                       where cv.fecha between fecha_ini and
                                                                                                                             fecha_fin)

                                  WHERE dc.id_doc_compra_venta = p_id_doc_compra_venta and
                                        dc.estado_reg = 'activo') LOOP
                                     
                     
                     IF (v_registros.id_partida_ejecucion IS NOT NULL) THEN                     
                        raise exception 'El presupuesto ya se encuentra comprometido';                     
                     END IF;
                                          
                     
                     v_i = v_i +1;                
                   
                   --armamos los array para enviar a presupuestos          
           
                    va_id_presupuesto[v_i] = v_registros.id_presupuesto;
                    va_id_partida[v_i]= v_registros.id_partida;
                    va_momento[v_i]	= 1; --el momento 1 es el comprometido
                    va_monto[v_i]  = v_registros.precio_total_final; 
                    va_id_moneda[v_i]  = v_registros.id_moneda;                   
                    va_columna_relacion[v_i]= 'id_doc_concepto';
                    va_fk_llave[v_i] = v_registros.id_doc_concepto;
                    va_nro_tramite[v_i] = v_registros.nro_tramite;
                    va_id_doc_concepto[v_i] = v_registros.id_doc_concepto;
                                        
                   
                    -- la fecha de solictud es la fecha de compromiso 
                    /*IF  now()  < v_registros.fecha THEN
                      va_fecha[v_i] = v_registros.fecha::date;
                    ELSE*/
                       -- la fecha de reversion como maximo puede ser el 31 de diciembre   
                       va_fecha[v_i] = now()::date;
                       v_ano_1 =  EXTRACT(YEAR FROM  now()::date);
                       v_ano_2 =  EXTRACT(YEAR FROM  now()::date);
                       
                       IF  v_ano_1  >  v_ano_2 THEN
                         va_fecha[v_i] = ('31-12-'|| v_ano_2::varchar)::date;
                       END IF;
                    --END IF;
                    
                   
             
             
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
  
       ELSE
       
          raise exception 'Oepracion no implementada';
       
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