--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_gestionar_presupuesto_tesoreria (
  p_id_obligacion_pago integer,
  p_id_usuario integer,
  p_operacion varchar,
  p_id_plan_pago integer = NULL::integer
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.f_gestionar_presupuesto_tesoreria
                
 DESCRIPCION:   Esta funcion a partir del las obligaciones se encarga de gestionar el presupuesto,
                compromenter
                revertir
                adcionar comprometido
                revertir sobrante
                
 AUTOR: 		Rensi Arteaga Copari
 FECHA:	        04-07-2013
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
  v_i   				  integer;
  v_cont				  integer;
  va_id_obligacion_det	  integer[];
  v_id_moneda_base		  integer;
  va_resp_ges              numeric[];
  
  va_fecha                date[];
  
  v_monto_a_revertir 	numeric;
  v_total_adjudicado  	numeric;
  v_aux 				numeric;
  
  v_comprometido numeric;
  v_ejecutado    numeric;
  v_registros_pro record;

  

  
BEGIN
 
  v_nombre_funcion = 'tes.f_gestionar_presupuesto_tesoreria';
   
  v_id_moneda_base =  param.f_get_moneda_base();
  
      IF p_operacion = 'comprometer' THEN
        
          --compromete al finalizar el registro de la obligacion
           v_i = 0;
           
           -- verifica que solicitud
       
          FOR v_registros in ( 
                            SELECT
                              opd.id_obligacion_det,
                              opd.id_centro_costo,
                              op.id_gestion,
                              op.id_obligacion_pago,
                              opd.id_partida,
                              opd.monto_pago_mb,
                              p.id_presupuesto,
                              op.comprometido
                              
                              FROM  tes.tobligacion_pago  op
                              INNER JOIN tes.tobligacion_det opd  on  opd.id_obligacion_pago = op.id_obligacion_pago and opd.estado_reg = 'activo'
                              INNER JOIN pre.tpresupuesto   p  on p.id_centro_costo = opd.id_centro_costo 
                              WHERE  
                                     op.id_obligacion_pago = p_id_obligacion_pago
                                     and opd.estado_reg = 'activo' 
                                     and opd.monto_pago_mo > 0 ) LOOP
                                     
                                
                     IF(v_registros.comprometido='si') THEN
                     
                        raise exception 'El presupuesto ya se encuentra comprometido';
                     
                     END IF;
                     
                     v_i = v_i +1;                
                   
                   --armamos los array para enviar a presupuestos          
           
                    va_id_presupuesto[v_i] = v_registros.id_presupuesto;
                    va_id_partida[v_i]= v_registros.id_partida;
                    va_momento[v_i]	= 1; --el momento 1 es el comprometido
                    va_monto[v_i]  = v_registros.monto_pago_mb;
                    va_id_moneda[v_i]  = v_id_moneda_base;
                  
                    va_columna_relacion[v_i]= 'id_obligacion_pago';
                    va_fk_llave[v_i] = v_registros.id_obligacion_pago;
                    va_id_obligacion_det[v_i]= v_registros.id_obligacion_det;
                    va_fecha[v_i]=now()::date;
             
             
             END LOOP;
             
              IF v_i > 0 THEN 
              
                    --llamada a la funcion de compromiso
                    va_resp_ges =  pre.f_gestionar_presupuesto(va_id_presupuesto, 
                                                               va_id_partida, 
                                                               va_id_moneda, 
                                                               va_monto, 
                                                               va_fecha, --p_fecha
                                                               va_momento, 
                                                               NULL,--  p_id_partida_ejecucion 
                                                               va_columna_relacion, 
                                                               va_fk_llave);
                 
                
                 
                 --actualizacion de los id_partida_ejecucion en el detalle de solicitud
               
                 
                   FOR v_cont IN 1..v_i LOOP
                   
                      
                      update tes.tobligacion_det opd set
                         id_partida_ejecucion_com = va_resp_ges[v_cont],
                         fecha_mod = now(),
                         id_usuario_mod = p_id_usuario,
                         revertido_mb = 0     -- inicializa el monto de reversion 
                      where opd.id_obligacion_det  =  va_id_obligacion_det[v_cont];
                   
                     
                   END LOOP;
             END IF;
      
      
      
        ELSEIF p_operacion = 'revertir' THEN
       
       -- revierte el presupuesto total que se encuentre comprometido
        
       
           v_i = 0;
          
           FOR v_registros in ( 
                            SELECT
                              opd.id_obligacion_det,
                              opd.id_centro_costo,
                              op.id_gestion,
                              op.id_obligacion_pago,
                              opd.id_partida,
                              opd.monto_pago_mb,
                              p.id_presupuesto,
                              op.comprometido,
                              opd.revertido_mb,
                              opd.id_partida_ejecucion_com
                              
                              FROM  tes.tobligacion_pago  op
                              INNER JOIN tes.tobligacion_det opd  on  opd.id_obligacion_pago = op.id_obligacion_pago and opd.estado_reg = 'activo'
                              INNER JOIN pre.tpresupuesto   p  on p.id_centro_costo = opd.id_centro_costo 
                              WHERE  
                                     op.id_obligacion_pago = p_id_obligacion_pago
                                     and opd.estado_reg = 'activo' 
                                     and opd.monto_pago_mo > 0  ) LOOP
                                     
                     IF(v_registros.id_partida_ejecucion_com is NULL) THEN
                     
                        raise exception 'El presupuesto del detalle con el identificador (%)  no se encuntra comprometido',v_registros.id_obligacion_det;
                     
                     END IF;
                     
                     
                     SELECT 
                             COALESCE(ps_comprometido,0), 
                             COALESCE(ps_ejecutado,0)  
                         into 
                             v_comprometido,
                             v_ejecutado
                     FROM pre.f_verificar_com_eje_pag(v_registros.id_partida_ejecucion_com, v_id_moneda_base);
                
                     
                      --armamos los array para enviar a presupuestos          
                    IF v_comprometido != 0 THEN
                     
                       	v_i = v_i +1;                
                       
                        va_id_presupuesto[v_i] = v_registros.id_presupuesto;
                        va_id_partida[v_i]= v_registros.id_partida;
                        va_momento[v_i]	= 2; --el momento 2 con signo positivo es revertir
                        va_monto[v_i]  = v_comprometido*-1;  -- considera la posibilidad de que a este item se le aya revertido algun monto
                        va_id_moneda[v_i]  = v_id_moneda_base;
                        va_id_partida_ejecucion[v_i]= v_registros.id_partida_ejecucion_com;
                        va_columna_relacion[v_i]= 'id_obligacion_pago';
                        va_fk_llave[v_i] = v_registros.id_obligacion_pago;
                        va_id_obligacion_det[v_i]= v_registros.id_obligacion_det;
                        va_fecha[v_i]=now()::date;
                    END IF;
             
             END LOOP;
             
             --llamada a la funcion de  reversion
               IF v_i > 0 THEN 
                  va_resp_ges =  pre.f_gestionar_presupuesto(va_id_presupuesto, 
                                                             va_id_partida, 
                                                             va_id_moneda, 
                                                             va_monto, 
                                                             va_fecha, --p_fecha
                                                             va_momento, 
                                                             va_id_partida_ejecucion,--  p_id_partida_ejecucion 
                                                             va_columna_relacion, 
                                                             va_fk_llave);
               END IF;
                     
      
       ELSEIF p_operacion = 'sincronizar_presupuesto' THEN
       
          v_i =0;
           --1) determinar cuanto es el faltante para la cuota ee moneda base, si sobra no hacer nada
           FOR  v_registros_pro in ( 
                                 select  
                                   pro.id_prorrateo,
                                   pro.monto_ejecutar_mb,
                                   pro.monto_ejecutar_mo,
                                   od.id_partida_ejecucion_com,
                                   od.descripcion,
                                   od.id_concepto_ingas,
                                   od.id_partida,
                                   p.id_presupuesto,
                                   od.id_obligacion_pago,
                                   od.id_obligacion_det
                                 from  tes.tprorrateo pro
                                 inner join tes.tobligacion_det od on od.id_obligacion_det = pro.id_obligacion_det   and od.estado_reg = 'activo'
                                 INNER JOIN pre.tpresupuesto   p  on p.id_centro_costo = od.id_centro_costo  
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
                        FROM pre.f_verificar_com_eje_pag(v_registros_pro.id_partida_ejecucion_com, v_id_moneda_base);
                
                   
                      --verifica si el presupuesto comprometido sobrante alcanza para devengar
                      IF  ( v_comprometido - v_ejecutado)  <  v_registros_pro.monto_ejecutar_mb   THEN
                         
                         v_aux =  v_registros_pro.monto_ejecutar_mb -  (v_comprometido-v_ejecutado);
                     
                         --armamos los array para enviar a presupuestos          
                            IF v_aux > 0 THEN
                             
                                v_i = v_i +1;                
                                --1.1) armar el array de llamada para comprometer
                                va_id_presupuesto[v_i] = v_registros_pro.id_presupuesto;
                                va_id_partida[v_i]= v_registros_pro.id_partida;
                                va_momento[v_i]	= 2; --el momento 2 con signo positivo es revertir
                                va_monto[v_i]  = v_aux;  --  con signo positivo significa incremento presupuestario 
                                va_id_moneda[v_i]  = v_id_moneda_base;
                                va_id_partida_ejecucion[v_i]= v_registros_pro.id_partida_ejecucion_com;
                                va_columna_relacion[v_i]= 'id_obligacion_pago';
                                va_fk_llave[v_i] = v_registros_pro.id_obligacion_pago;
                                va_id_obligacion_det[v_i]= v_registros_pro.id_obligacion_det;
                                va_fecha[v_i]=now()::date;
                           
                               --1.2) actualizar el incremento en obligacion det 
                            
                              update tes.tobligacion_det od set
                              incrementado_mb = COALESCE(incrementado_mb,0) + v_aux
                              where  od.id_obligacion_det= v_registros_pro.id_obligacion_det;
                            
                            END IF;
                      
                      END IF;
                   END LOOP;
           
           --2)  llamar a la funcion de incremeto presupuestario
           
               IF v_i > 0 THEN 
                  
                  va_resp_ges =  pre.f_gestionar_presupuesto(va_id_presupuesto, 
                                                             va_id_partida, 
                                                             va_id_moneda, 
                                                             va_monto, 
                                                             va_fecha, --p_fecha
                                                             va_momento, 
                                                             va_id_partida_ejecucion,--  p_id_partida_ejecucion 
                                                             va_columna_relacion, 
                                                             va_fk_llave);
              
                       --quitamos la bandera de sincronizacion del plan de pago
                       update tes.tplan_pago pp set
                        sinc_presupuesto = 'no'
                       where  pp.id_plan_pago =  p_id_plan_pago;
               
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