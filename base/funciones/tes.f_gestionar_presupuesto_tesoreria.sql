--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_gestionar_presupuesto_tesoreria (
  p_id_obligacion_pago integer,
  p_id_usuario integer,
  p_operacion varchar,
  p_id_plan_pago integer = NULL::integer,
  p_conexion varchar = NULL::character varying
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
  
  v_comprometido 		numeric;
  v_ejecutado    		numeric;
  v_registros_pro 		record;
  v_aux_mb 				numeric;
  v_fecha 				date;
  v_ano_1 				integer;
  v_ano_2 				integer;
  v_reg_op				record;
  va_nro_tramite		varchar[];
  v_resp_pre			varchar;
  v_mensage_error 		varchar;
  v_sw_error 			boolean;
  

  

  
BEGIN
 
  v_nombre_funcion = 'tes.f_gestionar_presupuesto_tesoreria';
   
  v_id_moneda_base =  param.f_get_moneda_base();
  
  
  SELECT
   *
  into
   v_reg_op
  FROM  tes.tobligacion_pago  op
  where op.id_obligacion_pago = p_id_obligacion_pago;
 
  
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
                                    opd.monto_pago_mo,
                                    p.id_presupuesto,
                                    op.comprometido,
                                    op.id_moneda,
                                    op.fecha,
                                    op.num_tramite,
                                    op.tipo_cambio_conv,
                                    par.sw_movimiento,
                                    tp.movimiento
                              
                              FROM  tes.tobligacion_pago  op
                              INNER JOIN tes.tobligacion_det opd  on  opd.id_obligacion_pago = op.id_obligacion_pago and opd.estado_reg = 'activo'
                              INNER JOIN pre.tpresupuesto   p  on p.id_centro_costo = opd.id_centro_costo 
                              INNER JOIN pre.tpartida par on par.id_partida  = opd.id_partida
                              INNER JOIN pre.ttipo_presupuesto tp on tp.codigo = p.tipo_pres
                              
                              
                              WHERE  
                                     op.id_obligacion_pago = p_id_obligacion_pago
                                     and opd.estado_reg = 'activo' 
                                     and opd.monto_pago_mo > 0 ) LOOP
                                     
                                
                     IF(v_registros.comprometido='si') THEN                     
                        raise exception 'El presupuesto ya se encuentra comprometido';                     
                     END IF;
                     
                     IF v_registros.sw_movimiento = 'flujo'  THEN                              
                           IF v_registros.movimiento != 'administrativo'  THEN
                                 raise exception 'partida de flujo solo son admitidas con presupuestos administrativos';
                           END IF;
                     ELSE
                     
                         v_i = v_i +1; 
                       --armamos los array para enviar a presupuestos 
                        va_id_presupuesto[v_i] = v_registros.id_presupuesto;
                        va_id_partida[v_i]= v_registros.id_partida;
                        va_momento[v_i]	= 1; --el momento 1 es el comprometido
                        va_monto[v_i]  = v_registros.monto_pago_mo; --v_registros.monto_pago_mb;
                        va_id_moneda[v_i]  = v_registros.id_moneda; --v_id_moneda_base;                      
                        va_columna_relacion[v_i]= 'id_obligacion_pago';
                        va_fk_llave[v_i] = v_registros.id_obligacion_pago;
                        va_id_obligacion_det[v_i]= v_registros.id_obligacion_det;
                        va_fecha[v_i]= v_registros.fecha::date;
                        va_nro_tramite[v_i]=v_reg_op.num_tramite;
                   
                   END IF;  
             
             
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
                                                               va_nro_tramite,
                                                               NULL,
                                                               p_conexion);
                 
                
                 
                 --actualizacion de los id_partida_ejecucion en el detalle de solicitud
               
                 
                   FOR v_cont IN 1..v_i LOOP
                   
                      
                      update tes.tobligacion_det opd set
                         id_partida_ejecucion_com = va_resp_ges[v_cont],
                         fecha_mod = now(),
                         id_usuario_mod = p_id_usuario,
                         revertido_mb = 0,     -- inicializa el monto de reversion 
                         revertido_mo = 0     -- inicializa el monto de reversion 
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
                              opd.monto_pago_mo,
                              p.id_presupuesto,
                              op.comprometido,
                              opd.revertido_mb,
                              opd.revertido_mo,
                              opd.id_partida_ejecucion_com,
                              op.id_moneda,
                              op.fecha,
                              op.num_tramite,
                              op.tipo_cambio_conv
                              
                              FROM  tes.tobligacion_pago  op
                              INNER JOIN tes.tobligacion_det opd  on  opd.id_obligacion_pago = op.id_obligacion_pago and opd.estado_reg = 'activo'
                              INNER JOIN pre.tpresupuesto   p  on p.id_centro_costo = opd.id_centro_costo 
                              WHERE  
                                     op.id_obligacion_pago = p_id_obligacion_pago
                                     and opd.estado_reg = 'activo' 
                                     and opd.monto_pago_mo > 0  ) LOOP
                                     
                     IF(v_registros.id_partida_ejecucion_com is not  NULL) THEN                     
                    
                              SELECT 
                                       COALESCE(ps_comprometido,0), 
                                       COALESCE(ps_ejecutado,0)  
                                   into 
                                       v_comprometido,
                                       v_ejecutado
                               FROM pre.f_verificar_com_eje_pag(v_registros.id_partida_ejecucion_com,v_registros.id_moneda);
                          
                              --la fecha de reversion no puede ser anterior a la fecha de la solictud
                              -- la fecha de solictud es la fecha de compromiso 
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
                              
                              --armamos los array para enviar a presupuestos          
                              IF v_comprometido - v_ejecutado > 0 THEN
                               
                                  v_i = v_i +1;                
                                 
                                  va_id_presupuesto[v_i] = v_registros.id_presupuesto;
                                  va_id_partida[v_i]= v_registros.id_partida;
                                  va_momento[v_i]	= 2; --el momento 2 con signo negativo  es revertir
                                  va_monto[v_i]  = (v_comprometido  - v_ejecutado)*-1;  -- considera la posibilidad de que a este item se le aya revertido algun monto
                                  va_id_moneda[v_i]  = v_registros.id_moneda;
                                  va_id_partida_ejecucion[v_i]= v_registros.id_partida_ejecucion_com;
                                  va_columna_relacion[v_i]= 'id_obligacion_pago';
                                  va_fk_llave[v_i] = v_registros.id_obligacion_pago;
                                  va_id_obligacion_det[v_i]= v_registros.id_obligacion_det;
                                  va_fecha[v_i]=v_fecha;
                                  va_nro_tramite[v_i]=v_reg_op.num_tramite;
                              END IF;
                    
                    END IF;
             
             END LOOP;
             
           
             
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
                                       od.id_obligacion_det,
                                       op.id_moneda,
                                       op.fecha,
                                       op.num_tramite,
                                       op.tipo_cambio_conv,     
                                       par.sw_movimiento,
                                       tp.movimiento
                                     from  tes.tprorrateo pro
                                     INNER JOIN tes.tobligacion_det od on od.id_obligacion_det = pro.id_obligacion_det   and od.estado_reg = 'activo'
                                     INNER JOIN tes.tobligacion_pago op on op.id_obligacion_pago = od.id_obligacion_pago
                                     INNER JOIN pre.tpresupuesto   p  on p.id_centro_costo = od.id_centro_costo  
                                     INNER JOIN pre.ttipo_presupuesto tp on tp.codigo = p.tipo_pres
   									 INNER JOIN pre.tpartida par on par.id_partida  = od.id_partida
                                     where  pro.id_plan_pago = p_id_plan_pago
                                       and pro.estado_reg = 'activo') LOOP
                             
                             
                              IF v_registros_pro.sw_movimiento = 'flujo'  THEN                              
                                     IF v_registros_pro.movimiento != 'administrativo'  THEN
                                           raise exception 'partida de flujo solo son admitidas con presupuestos administrativos';
                                     END IF;
                               ELSE 
                                  v_comprometido=0;
                                  v_ejecutado=0;        				        
                                  SELECT 
                                       ps_comprometido, 
                                       COALESCE(ps_ejecutado,0)  
                                   into 
                                       v_comprometido,
                                       v_ejecutado
                                  FROM pre.f_verificar_com_eje_pag(v_registros_pro.id_partida_ejecucion_com, v_registros_pro.id_moneda);
                              END IF;
                       
                          --verifica si el presupuesto comprometido sobrante alcanza para devengar
                          IF  ( v_comprometido - v_ejecutado)  <  v_registros_pro.monto_ejecutar_mo and  v_registros_pro.sw_movimiento != 'flujo' THEN
                             
                             v_aux =  v_registros_pro.monto_ejecutar_mo -  (v_comprometido-v_ejecutado);
                         
                             --armamos los array para enviar a presupuestos          
                                IF v_aux > 0 THEN
                                 
                                    v_i = v_i +1;                
                                    --1.1) armar el array de llamada para comprometer
                                    va_id_presupuesto[v_i] = v_registros_pro.id_presupuesto;
                                    va_id_partida[v_i]= v_registros_pro.id_partida;
                                    va_momento[v_i]	= 2; --el momento 2 con signo positivo es revertir
                                    va_monto[v_i]  = v_aux;  --  con signo positivo significa incremento presupuestario 
                                    va_id_moneda[v_i]  = v_registros_pro.id_moneda;
                                    va_id_partida_ejecucion[v_i]= v_registros_pro.id_partida_ejecucion_com;
                                    va_columna_relacion[v_i]= 'id_obligacion_pago';
                                    va_fk_llave[v_i] = v_registros_pro.id_obligacion_pago;
                                    va_id_obligacion_det[v_i]= v_registros_pro.id_obligacion_det;
                                    va_nro_tramite[v_i]=v_registros_pro.num_tramite;
                                    
                                    --si la el año de pago es mayor que el año del devengado , el pago va con fecha de 31 de diciembre del año del devengado
                                    va_fecha[v_i]=now()::date;
                                    v_ano_1 =  EXTRACT(YEAR FROM  va_fecha[v_i]::date);
                                    v_ano_2 =  EXTRACT(YEAR FROM  v_registros_pro.fecha::date);
                                                   
                                    IF  v_ano_1  >  v_ano_2 THEN
                                       va_fecha[v_i] = ('31-12-'|| v_ano_2::varchar)::date;
                                    END IF;
                                    
                               
                                    v_aux_mb = param.f_convertir_moneda(
                                              v_registros_pro.id_moneda, 
                                              NULL,   --por defecto moenda base
                                              v_aux, 
                                              va_fecha[v_i], 
                                              'O',-- tipo oficial, venta, compra 
                                              NULL);
                             
                             
                                  --1.2) actualizar el incremento en obligacion det 
                                
                                  update tes.tobligacion_det od set
                                  incrementado_mb = COALESCE(incrementado_mb,0) + v_aux_mb,
                                  incrementado_mo = COALESCE(incrementado_mo,0) + v_aux
                                  where  od.id_obligacion_det= v_registros_pro.id_obligacion_det;
                                
                                END IF;
                          
                          END IF;
                       END LOOP;
             
             --2)  llamar a la funcion de incremeto presupuestario
             
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
                                                                 p_conexion);
                
                         
                         -- quitamos la bandera de sincronizacion del plan de pago
                         update tes.tplan_pago pp set
                          sinc_presupuesto = 'no'
                         where  pp.id_plan_pago =  p_id_plan_pago;
                 
                 END IF;
      
       
       ELSEIF p_operacion = 'verificar' THEN
        
          --compromete al finalizar el registro de la obligacion
           v_i = 0;  
           v_sw_error = FALSE;
           v_mensage_error ='';       
           -- verifica que solicitud
       
          FOR v_registros in (
          						SELECT
                                        opd.id_centro_costo,
                                        op.id_gestion,
                                        op.id_obligacion_pago,
                                        opd.id_partida,
                                        sum(opd.monto_pago_mb) as monto_pago_mb,
                                        sum(opd.monto_pago_mo) as monto_pago_mo,
                                        p.id_presupuesto,
                                        op.id_moneda,
                                        op.fecha,
                                        op.num_tramite,
                                        op.tipo_cambio_conv,
                                        par.codigo,
                                        par.nombre_partida,
                                        p.codigo_cc,
                                        par.sw_movimiento,
                                        tp.movimiento
                                                              
                                    FROM  tes.tobligacion_pago  op
                                    INNER JOIN tes.tobligacion_det opd  on  opd.id_obligacion_pago = op.id_obligacion_pago and opd.estado_reg = 'activo'
                                    inner join pre.tpartida par on par.id_partida  = opd.id_partida
                                    INNER JOIN pre.vpresupuesto_cc   p  on p.id_centro_costo = opd.id_centro_costo
                                    INNER JOIN pre.ttipo_presupuesto tp on tp.codigo = p.tipo_pres 
                                    WHERE  
                                           op.id_obligacion_pago = p_id_obligacion_pago
                                           and opd.estado_reg = 'activo' 
                                           and opd.monto_pago_mo > 0
                                    group by
                                              opd.id_centro_costo,
                                              op.id_gestion,
                                              op.id_obligacion_pago,
                                              opd.id_partida,
                                              p.id_presupuesto,
                                              op.id_moneda,
                                              op.fecha,
                                              op.num_tramite,
                                              op.tipo_cambio_conv,
                                              par.codigo,
                                              par.nombre_partida,
                                              p.codigo_cc,
                                              par.sw_movimiento,
      										  tp.movimiento) LOOP
                                     
                              IF v_registros.sw_movimiento = 'flujo'  THEN
                              
                                   IF v_registros.movimiento != 'administrativo'  THEN
                                     raise exception 'partida de flujo solo son admitidas con presupeustos administrativos (% - % - %)', v_registros.codigo_cc, v_registros.codigo,v_registros.nombre_partida;
                                   END IF;
                              
                              
                              ELSE
                                  v_resp_pre = pre.f_verificar_presupuesto_partida ( v_registros.id_presupuesto,
                                                                        v_registros.id_partida,
                                                                        v_registros.id_moneda,
                                                                        v_registros.monto_pago_mo);
                                                                        
                                   IF   v_resp_pre = 'false' THEN                                   
                                      v_mensage_error = v_mensage_error||format('Presupuesto:  %s, partida (%s) %s <BR/>', v_registros.codigo_cc, v_registros.codigo,v_registros.nombre_partida);    
                                      v_sw_error = true;
                                   END IF;                                      
                                                                        
                              
                              END IF;
          
                              
                                                        
                                                        
                             
             
          
         
          
          END LOOP;
          
          
            
         IF v_sw_error THEN
             raise exception 'No se tiene suficiente presupeusto para; <BR/>%', v_mensage_error;
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