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
                

    HISTORIAL DE MODIFICACIONES:
   	
 ISSUE              FECHA:		      AUTOR                 DESCRIPCION
 #0               04-07-2013         RAC KPLIAN        validaciones
 #31,   ETR       27/10/2017        RAC KPLIAN        agregar operacion para ejecutar anticipos y para revertir anticipos en proporcion    
 #32    ETR       05/02/2018        RAC KPLIAN        agregar informacion de anticipo a partida ejecucion  
 #33    ETR		  15/05/2018		RAC KPLIAN        no cnsiderar el desceutno de anticipos para  el compromiso  de presupeusto al sincronizar
 #34    ETR       17/05/2018        RAC KPLIAN        Considerar nuevo metodo de sincrnoziacion con TIPO_CC
 #100   ETR       30/05/2018        RAC KPLIAN        Nueva funcion de sincronizacion que considere si el IVA de amnera opcional v_conta_revertir_iva_comprometido
 #101   ETR       02/07/2018        RAC KPLIAN        Considera facturas con monto excento al sicronizar presupuestos
 #7777  ETR       13/12/2018        RAC KPLIAN        Determinar si el anticipo es de la misma gestion que la obligacion de pago y si es necesario realizar la conversion 
 #7890  ETR       13/12/2018        RAC KPLIAN        Al aprobacion una olbigacion de pago colo comprometer el monto previsto para la gestion actual  (restar monto_sg_mo)
 #12    ETR       10/01/2018        RAC KPLIAN        Si la obigacion de la bandera comprometer_iva = no, le restamso el 13% a total que se tiene que comprometer  
 #34    ETR       02/10/2019        RAC KPLIAN        BUG al sincronizar presupuesto en procesos de adquisiciones con varias lineas pero mismos presupuestos y partida 
 #37   ETR        10/10/2019        RAC KPLIAN        retroceder cambio de agrupación por partida y centro , al sincronizar presupuestos
 #38   ETR        26/11/2019        RAC KPLIAN        BUG caso no considerado al anticipo y factor de prorrateo 
 #44   ETR        15/01/2019        RAC KPLIAN        Mejora de mensajes de error para centros de costos bloqueados 
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
  v_total_op_mo			numeric;
  v_monto_ejecutar		numeric;
  v_monto_ejecutar_mb	numeric;
  v_resultado_ges					numeric[];
  v_mensaje_error					varchar;
  v_sw_revertir_ant					boolean;
  v_monto_a_revertir_mb				numeric;
  v_tes_anticipo_ejecuta_pres    	varchar;    --#31, ++ 
  v_descuento_anticipo numeric;
  v_conta_revertir_iva_comprometido  varchar;   --#100, ++ 
  v_id_plantilla                     integer;   --#100 ++
  v_total_iva                        numeric;   --#100 ++
  v_monto_ejecutar_total_mo          numeric;   --#100 ++
  v_desc_iva                         numeric;   --#100 ++
  v_monto_excento                    numeric;   --#101 ++
  v_monto_det_comprometer            numeric;   --#7890
  v_id_centro_costo_ant              integer;   --#7777
  v_id_partida_ant                   integer;   --#7777
  v_id_gestion_cbte                  integer;   --#7777
  v_registros_det                    record;    --#37
  v_desc_iva_det                     numeric;   --#37
  v_descuento_anticipo_det           numeric;   --#37
  v_comprometido_det                 numeric;   --#37
  v_ejecutado_det                    numeric;   --#37
  v_aux_det				             numeric;   --#37
  v_aux_mb_det			             numeric;   --#37
  v_monto_a_comprometer              numeric;   --#37
  		
  

  

  
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
           v_tes_anticipo_ejecuta_pres = pxp.f_get_variable_global('tes_anticipo_ejecuta_pres');
           
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
                                    tp.movimiento,
                                    opd.monto_pago_sg_mo,   --7890
                                    opd.monto_pago_sg_mb,   --7890
                                    opd.factor_porcentual,   --7890
                                    op.monto_ajuste_ret_anticipo_par_ga, --7890
                                    opd.factor_porcentual,  --7890
                                    op.comprometer_iva     --#12
                              
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
                         
                       --#7890 se resta el monto previsto para la siguiente gestion
                       IF v_tes_anticipo_ejecuta_pres = 'si' and COALESCE(v_registros.monto_ajuste_ret_anticipo_par_ga,0) > 0 THEN
                        --si los anticipos ejecutan presupuesto arrastramos un anticopo por retener de la gestion anterior, no necesario volverlo a comprometer                        
                        v_monto_det_comprometer = v_registros.monto_pago_mo - COALESCE(v_registros.monto_pago_sg_mo,0) - (v_registros.factor_porcentual*COALESCE(v_registros.monto_ajuste_ret_anticipo_par_ga,0));  
                       ELSE
                         v_monto_det_comprometer = v_registros.monto_pago_mo - COALESCE(v_registros.monto_pago_sg_mo,0) ; 
                       END IF;
                       
                       --#12 si comproemter el iva es igual  a NO restamos el 13 % 
                       IF  v_registros.comprometer_iva = 'no'  THEN
                           v_monto_det_comprometer = v_monto_det_comprometer * 0.87;  --#12 solo compromete el 87%
                       END IF;
                         
                         
                       v_i = v_i +1; 
                       --armamos los array para enviar a presupuestos 
                       va_id_presupuesto[v_i] = v_registros.id_presupuesto;
                       va_id_partida[v_i]= v_registros.id_partida;
                       va_momento[v_i]	= 1; --el momento 1 es el comprometido
                       va_monto[v_i]  = v_monto_det_comprometer;     --#7890 monto a comprometer
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
      
         
        ELSEIF p_operacion = 'revertir_old' THEN
       
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
               
        --02/02/2018 --AJSUTE PARA REVERTIR PRESUPUESTO,        
               
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
                              
                               va_resp_ges = pre.f_gestionar_presupuesto_individual(
                                              p_id_usuario, 
                                              NULL::NUMERIC, --tipo cambio
                                              v_registros.id_presupuesto, 
                                              v_registros.id_partida, 
                                              v_registros.id_moneda, --  RAC Cambio por moneda de la solicitud , v_id_moneda_base;
                                              ((v_comprometido  - v_ejecutado)*-1)::NUMERIC, --RAC Cambio por moneda de la solicitud , v_registros.precio_ga_mb;
                                              v_fecha, 
                                              'comprometido'::Varchar, --traducido a varchar
                                               v_registros.id_partida_ejecucion_com::INTEGER, 
                                              'id_obligacion_pago'::VARCHAR, 
                                               v_registros.id_obligacion_pago, 
                                               v_reg_op.num_tramite::VARCHAR 
                                              );
                               
                                  v_i = v_i +1;                
                                 
                                
                              END IF;
                            
                    
                    END IF;
             
             END LOOP;
             
            
      
       ELSEIF p_operacion = 'sincronizar_presupuesto_old' THEN
       
               v_tes_anticipo_ejecuta_pres = pxp.f_get_variable_global('tes_anticipo_ejecuta_pres');
       
           
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
                                       tp.movimiento,
                                       pp.monto_ejecutar_total_mo,
                                       pro.monto_ejecutar_mo / pp.monto_ejecutar_total_mo as  factor_pro,
                                       pp.descuento_anticipo
                                     from  tes.tprorrateo pro
                                     INNER JOIN tes.tobligacion_det od on od.id_obligacion_det = pro.id_obligacion_det   and od.estado_reg = 'activo'
                                     INNER JOIN tes.tobligacion_pago op on op.id_obligacion_pago = od.id_obligacion_pago
                                     INNER JOIN pre.tpresupuesto   p  on p.id_centro_costo = od.id_centro_costo  
                                     INNER JOIN pre.ttipo_presupuesto tp on tp.codigo = p.tipo_pres
   									 INNER JOIN pre.tpartida par on par.id_partida  = od.id_partida
                                     INNER JOIN tes.tplan_pago pp on pp.id_plan_pago = pro.id_plan_pago
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
                              
                          --#39 calcular el decuento de anticipo,   y no comprometerlo
                         
                          IF v_tes_anticipo_ejecuta_pres = 'si' THEN
                               v_descuento_anticipo = v_registros_pro.factor_pro * v_registros_pro.descuento_anticipo;
                          ELSE
                               v_descuento_anticipo = 0;
                          END IF;     
                              
                       
                          --verifica si el presupuesto comprometido sobrante alcanza para devengar
                          IF  ( v_comprometido - v_ejecutado)  <  (v_registros_pro.monto_ejecutar_mo - v_descuento_anticipo) and  v_registros_pro.sw_movimiento != 'flujo' THEN
                          
                            --considerar el descuento de anticipo 
                            v_aux =  (v_registros_pro.monto_ejecutar_mo - v_descuento_anticipo) -  (v_comprometido-v_ejecutado);
                         
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
       ------------------------------------------------------------
       --   #100, nueva funcion de sincronizacion que aprovecha 
       --   las ventajas de trasaccion en mismo sistema de presupuesto 
       --   y que considera si el iva compromete o no presupeusto
       --   #101  considera monto excento
       --   #34  considerar agrupacion de presupeustos y partidas
       --   #37 OJO no es necesairo agrupar por partda y presupesuto
       --       esta agrupacion solo es necesari al llevar de forulario a comprometido
       --       ya no es necesario de compmetido a ejecutado
       --   Existe un bug, ejempo
       --   si tenemos dos detalle mismo centro de costo y partida
       --   el presupuesto formualdo es suficiente para ambos por separado pero
       --   no para os dos sumados,.... no fue encontrada una solucion        
       -------------------------------------------------------------------------------------
              
      ELSEIF p_operacion = 'sincronizar_presupuesto' THEN
       
               v_tes_anticipo_ejecuta_pres = pxp.f_get_variable_global('tes_anticipo_ejecuta_pres');
               v_conta_revertir_iva_comprometido = pxp.f_get_variable_global('conta_revertir_iva_comprometido');
               
               ----------------------------------------------------------------------------
               --  #100 SI no revertimos  presupeusto tampaco tenemos que comprometerlo
               ------------------------------------------------------------------------------
               
               select
                 pp.id_plantilla,
                 pp.monto_ejecutar_total_mo,
                 pp.monto_excento
                
               into
                 v_id_plantilla,
                 v_monto_ejecutar_total_mo,
                 v_monto_excento
                 
               from tes.tplan_pago pp
               where pp.id_plan_pago = p_id_plan_pago;
               
               select  
                 ps_monto_porc,
                 ps_observaciones
               into
                v_registros
               FROM  conta.f_get_detalle_plantilla_calculo(v_id_plantilla, 'IVA-CF');
               
               v_total_iva = (v_monto_ejecutar_total_mo -  COALESCE(v_monto_excento,0) )*  COALESCE(v_registros.ps_monto_porc, 0);
               
               --raise exception 'monto % ', v_monto_ejecutar_total_mo;
           
               v_i = 0;
               --1) determinar cuanto es el faltante para la cuota en moneda base, si sobra no hacer nada
               FOR  v_registros_pro in ( 
                                     select                                        
                                             sum(pro.monto_ejecutar_mb) as monto_ejecutar_mb,
                                             sum(pro.monto_ejecutar_mo) as monto_ejecutar_mo,                                      
                                             max(od.id_partida_ejecucion_com) as id_partida_ejecucion_com,                                            
                                             od.id_obligacion_pago,                                      
                                             op.id_moneda,
                                             op.fecha,
                                             op.num_tramite,
                                             op.tipo_cambio_conv,     
                                             par.sw_movimiento,
                                             tp.movimiento,
                                             pp.monto_ejecutar_total_mo,
                                             sum(pro.monto_ejecutar_mo) / sum(pp.monto_ejecutar_total_mo) as  factor_pro,
                                             pp.descuento_anticipo,                                             
                                             tct.id_tipo_cc_techo  
                                             --,od.id_partida --TODO                                           
                                         from  tes.tprorrateo pro
                                         INNER JOIN tes.tobligacion_det od on od.id_obligacion_det = pro.id_obligacion_det   and od.estado_reg = 'activo'
                                         INNER JOIN tes.tobligacion_pago op on op.id_obligacion_pago = od.id_obligacion_pago
                                         INNER JOIN pre.tpresupuesto   p  on p.id_centro_costo = od.id_centro_costo  
                                         INNER JOIN pre.ttipo_presupuesto tp on tp.codigo = p.tipo_pres
                                         INNER JOIN pre.tpartida par on par.id_partida  = od.id_partida
                                         INNER JOIN tes.tplan_pago pp on pp.id_plan_pago = pro.id_plan_pago
                                         INNER JOIN  param.tcentro_costo cc ON cc.id_centro_costo = p.id_centro_costo
                                         INNER JOIN param.vtipo_cc_techo tct ON tct.id_tipo_cc = cc.id_tipo_cc
                                         WHERE  pro.id_plan_pago = p_id_plan_pago  and pro.estado_reg = 'activo'
                                         GROUP BY                                      
                                           od.id_obligacion_pago,
                                           op.id_moneda,
                                           op.fecha,
                                           op.num_tramite,
                                           op.tipo_cambio_conv,
                                           pp.monto_ejecutar_total_mo,
                                           pp.descuento_anticipo,
                                           par.sw_movimiento,                                           
                                           tp.movimiento,
                                           tct.id_tipo_cc_techo
                                           --,od.id_partida
                                     ) LOOP 
                               
                             
                               --Revisar el tipo de documento y ver si tiene IVA
                               
                               -- si tine IVA reducir el porcenta correpondiente al comprometido faltante  
                               --(tambiend eberia prorratearce con la mayor cantidad de decimales)  
                               v_desc_iva = 0;
                               
                               IF v_conta_revertir_iva_comprometido = 'no' THEN
                                 v_desc_iva = v_total_iva * v_registros_pro.factor_pro;                               
                               END IF;      
                             
                             
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
                                  FROM pre.f_verificar_com_eje_pag_tipo_cc(v_registros_pro.id_partida_ejecucion_com, v_registros_pro.id_moneda);
                                 -- FROM pre.f_verificar_com_eje_pag(v_registros_pro.id_partida_ejecucion_com, v_registros_pro.id_moneda);
                              END IF;
                              
                          --#39 calcular el decuento de anticipo,   y no comprometerlo
                         
                          IF v_tes_anticipo_ejecuta_pres = 'si' THEN
                               v_descuento_anticipo = v_registros_pro.factor_pro * v_registros_pro.descuento_anticipo;
                          ELSE
                               v_descuento_anticipo = 0;
                          END IF;   
                          
                          v_aux =  (v_registros_pro.monto_ejecutar_mo - v_descuento_anticipo - v_desc_iva) -  (v_comprometido - v_ejecutado);
                                 
                           
                          --IF v_registros_pro.id_partida_ejecucion_com not in (817360,817359)  THEN 
                          -- raise exception 'id_partida_ejecucion_com %, v_comprometido %, v_ejecutado  % < monto_ejecutar_mo % - v_descuento_anticipo % - v_desc_iva %', v_registros_pro.id_partida_ejecucion_com, v_comprometido, v_ejecutado,v_registros_pro.monto_ejecutar_mo , v_descuento_anticipo  , v_desc_iva;
                          --END IF;         
                         
                           ----------------------------------------------------------------------------
                           -- incremetamos presupuesto por cada detalle
                           -----------------------------------------------------------------------------
                            
                            FOR v_registros_det IN (
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
                                       tp.movimiento,
                                       pp.monto_ejecutar_total_mo,
                                       pro.monto_ejecutar_mo / pp.monto_ejecutar_total_mo as  factor_pro,
                                       pp.descuento_anticipo,
                                       par.codigo as codigo_partida
                                     from  tes.tprorrateo pro
                                     INNER JOIN tes.tobligacion_det od on od.id_obligacion_det = pro.id_obligacion_det   and od.estado_reg = 'activo'
                                     INNER JOIN tes.tobligacion_pago op on op.id_obligacion_pago = od.id_obligacion_pago
                                     INNER JOIN pre.tpresupuesto   p  on p.id_centro_costo = od.id_centro_costo  
                                     INNER JOIN pre.ttipo_presupuesto tp on tp.codigo = p.tipo_pres
   									 INNER JOIN pre.tpartida par on par.id_partida  = od.id_partida
                                     INNER JOIN tes.tplan_pago pp on pp.id_plan_pago = pro.id_plan_pago
                                     INNER JOIN  param.tcentro_costo cc ON cc.id_centro_costo = p.id_centro_costo
                                     INNER JOIN param.vtipo_cc_techo tct ON tct.id_tipo_cc = cc.id_tipo_cc
                                     where  tct.id_tipo_cc_techo = v_registros_pro.id_tipo_cc_techo
                                            and pro.estado_reg = 'activo'
                                            and pro.id_plan_pago = p_id_plan_pago 
                            
                            )LOOP
                                             
                                      v_desc_iva_det = 0;
                                           
                                      IF v_conta_revertir_iva_comprometido = 'no' THEN
                                           v_desc_iva_det = v_total_iva * v_registros_det.factor_pro;                               
                                      END IF;
                                        
                                      IF v_registros_det.sw_movimiento = 'flujo'  THEN                              
                                                 IF v_registros_det.movimiento != 'administrativo'  THEN
                                                       raise exception 'partida de flujo solo son admitidas con presupuestos administrativos';
                                                 END IF;
                                      ELSE 
                                              
                                              v_comprometido_det=0;
                                              v_ejecutado_det=0;   
                                                   				        
                                              SELECT 
                                                   ps_comprometido, 
                                                   COALESCE(ps_ejecutado,0)  
                                               into 
                                                   v_comprometido_det,
                                                   v_ejecutado_det
                                              FROM pre.f_verificar_com_eje_pag(v_registros_det.id_partida_ejecucion_com, v_registros_det.id_moneda);
                                      END IF;
                                        
                                      IF v_tes_anticipo_ejecuta_pres = 'si' THEN
                                           v_descuento_anticipo_det = v_registros_det.factor_pro * v_registros_det.descuento_anticipo;
                                      ELSE
                                           v_descuento_anticipo_det = 0;
                                      END IF;
                                        
                                        --considerar el descuento de anticipo 
                                       v_aux_det =  (v_registros_det.monto_ejecutar_mo - v_descuento_anticipo_det - v_desc_iva_det) -  (v_comprometido_det - v_ejecutado_det);
                                     
                                       --raise exception '%-%-%-%-%',v_registros_det.monto_ejecutar_mo, v_descuento_anticipo_det , v_desc_iva_det,v_comprometido_det, v_ejecutado_det;
                                        
                                     --  raise exception 'nn  %', v_aux_det;
                                       
                                      v_monto_a_comprometer = 0;
                                       
                                      IF (v_registros_det.monto_ejecutar_mo - v_descuento_anticipo_det - v_desc_iva_det) < v_aux_det THEN
                                          v_monto_a_comprometer = v_registros_det.monto_ejecutar_mo - v_descuento_anticipo_det - v_desc_iva_det;
                                      ELSE 
                                          v_monto_a_comprometer = v_aux_det;
                                      END IF;
                                                                              
                                      IF (v_monto_a_comprometer) > 0 THEN
                                       
                                          v_i = v_i +1; 
                                          --si la el año de pago es mayor que el año del devengado , el pago va con fecha de 31 de diciembre del año del devengado
                                          va_fecha[v_i]=now()::date;
                                          v_ano_1 =  EXTRACT(YEAR FROM  va_fecha[v_i]::date);
                                          v_ano_2 =  EXTRACT(YEAR FROM  v_registros_det.fecha::date);
                                                         
                                          IF  v_ano_1  >  v_ano_2 THEN
                                             va_fecha[v_i] = ('31-12-'|| v_ano_2::varchar)::date;
                                          END IF;
                                          
                                     
                                          v_aux_mb_det = param.f_convertir_moneda(
                                                    v_registros_det.id_moneda, 
                                                    NULL,   --por defecto moenda base
                                                    v_aux_det, 
                                                    va_fecha[v_i], 
                                                    'O',-- tipo oficial, venta, compra 
                                                    NULL);
                                   
                                   
                                        --1.2) actualizar el incremento en obligacion det 
                                      
                                        update tes.tobligacion_det od set
                                        incrementado_mb = COALESCE(incrementado_mb,0) + v_aux_mb_det,
                                        incrementado_mo = COALESCE(incrementado_mo,0) + v_aux_det
                                        where  od.id_obligacion_det= v_registros_det.id_obligacion_det;
                                        
                                       -- raise exception '... mb %, usd %, % ----anticipo %', v_aux_mb , v_aux , v_registros_pro.id_moneda, v_descuento_anticipo;
                                                                       
                                             v_resultado_ges = pre.f_gestionar_presupuesto_individual(
                                                                p_id_usuario,
                                                                NULL, --.tipo_cambio,
                                                                v_registros_det.id_presupuesto ,                                                          
                                                                v_registros_det.id_partida,
                                                                v_registros_det.id_moneda,
                                                                v_monto_a_comprometer,
                                                                va_fecha[v_i],                                                         
                                                                'comprometido'::varchar, --traducido a varchar  
                                                                v_registros_det.id_partida_ejecucion_com,   --partida ejecucion
                                                                'id_obligacion_pago',
                                                                v_registros_det.id_obligacion_pago ,
                                                                v_registros_det.num_tramite,                                                          
                                                                NULL, --id_int_comprobante,                                                          
                                                                NULL,
                                                                'Sincroniza monto faltante para el pago'); 
                                                                
                                                             
                                                                
                                            --  analizamos respuesta y retornamos error
                                           IF v_resultado_ges[1] = 0 THEN
                                                                     
                                                     --  recuperamos datos del presupuesto
                                                     v_mensaje_error = COALESCE(v_mensaje_error,'') ||COALESCE( conta.f_armar_error_presupuesto(
                                                                                           v_resultado_ges, 
                                                                                           v_registros_det.id_presupuesto, 
                                                                                           v_registros_det.codigo_partida, 
                                                                                           v_registros_det.id_moneda, 
                                                                                           v_id_moneda_base, 
                                                                                           'comprometer', 
                                                                                           v_aux),'' );
                                                     v_sw_error = true;
                                                                           
                                           END IF; --fin id de error                               
                                                                       
                                        v_aux = v_aux - v_monto_a_comprometer;
                                      END IF;
                                      
                                      
                                  END LOOP;
                       END LOOP;
             
             --2)  llamar a la funcion de incremeto presupuestario
             
                 IF v_i > 0 THEN 
                    
                         -- quitamos la bandera de sincronizacion del plan de pago
                         update tes.tplan_pago pp set
                          sinc_presupuesto = 'no'
                         where  pp.id_plan_pago =  p_id_plan_pago;
                 
                 END IF;
                 
                 IF v_sw_error THEN
                    raise exception 'Error al procesar presupuesto: %', v_mensaje_error;
                 END IF;
       
      
      
       ELSEIF p_operacion = 'verificar' THEN
       
       
        
          --compromete al finalizar el registro de la obligacion
           v_i = 0;  
           v_sw_error = FALSE;
           v_mensage_error =''; 
           v_tes_anticipo_ejecuta_pres = pxp.f_get_variable_global('tes_anticipo_ejecuta_pres');      
           -- verifica que solicitud
        
          FOR v_registros in (
          						SELECT
                                        opd.id_centro_costo,
                                        op.id_gestion,
                                        op.id_obligacion_pago,
                                        opd.id_partida,
                                        --sum(opd.monto_pago_mb - opd.monto_pago_sg_mb - factor_porcentual*COALESCE(monto_ajuste_ret_anticipo_par_ga,0)) as monto_pago_mb,
                                        sum(opd.monto_pago_mo - opd.monto_pago_sg_mo - factor_porcentual*COALESCE(monto_ajuste_ret_anticipo_par_ga,0)) as monto_pago_mo,
                                        p.id_presupuesto,
                                        op.id_moneda,
                                        op.fecha,
                                        op.num_tramite,
                                        op.tipo_cambio_conv,
                                        par.codigo,
                                        par.nombre_partida,
                                        p.codigo_cc,
                                        par.sw_movimiento,
                                        tp.movimiento,
                                        op.monto_ajuste_ret_anticipo_par_ga,
                                        op,comprometer_iva
                                                              
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
      										  tp.movimiento,
                                              op.monto_ajuste_ret_anticipo_par_ga,
                                              op,comprometer_iva) LOOP
                                              
                                              
                       
                               v_monto_det_comprometer = v_registros.monto_pago_mo ;
                               --#12 si comproemter el iva es igual  a NO restamos el 13 % 
                               IF  v_registros.comprometer_iva = 'no'  THEN
                                   v_monto_det_comprometer = v_monto_det_comprometer * 0.87;  --#12 solo compromete el 87%
                               END IF;              
                                              
                                     
                              IF v_registros.sw_movimiento = 'flujo'  THEN
                              
                                   IF v_registros.movimiento != 'administrativo'  THEN
                                     raise exception 'partida de flujo solo son admitidas con presupeustos administrativos (% - % - %)', v_registros.codigo_cc, v_registros.codigo,v_registros.nombre_partida;
                                   END IF;
                              ELSE
                                    v_resp_pre = pre.f_verificar_presupuesto_partida ( v_registros.id_presupuesto,
                                                                        v_registros.id_partida,
                                                                        v_registros.id_moneda,
                                                                        v_monto_det_comprometer); --#12
                                                                        
                                   IF   v_resp_pre = 'false' THEN                                   
                                      v_mensage_error = v_mensage_error||format('Presupuesto:  %s, partida (%s) %s <BR/>', v_registros.codigo_cc, v_registros.codigo,v_registros.nombre_partida);    
                                      v_sw_error = true;
                                   END IF; 
                              END IF;
          
          END LOOP;
          
        
            
         IF v_sw_error THEN
             raise exception 'No se tiene suficiente presupeusto para; <BR/>%', v_mensage_error;
         END IF;
             
       --------------------------------------------------------------------------------------------
       -- #31,  ejecutar anticipos 
       --   Ejecuta el presupeusta (debe estar comprometido previamente en las partidas correpondecientes)
       -----------------------------------------------------------------------------------------------------------
       ELSEIF p_operacion = 'ejecutar_anticipo' THEN
       
       
             
           
           v_tes_anticipo_ejecuta_pres = pxp.f_get_variable_global('tes_anticipo_ejecuta_pres');
          
           IF v_tes_anticipo_ejecuta_pres = 'si' THEN
                  --recueprar el total del monto que se va anticipiar, es el total a ejecutar
                   select 
                     pp.monto_mb,
                     pp.monto,               
                     pp.estado,
                     op.num_tramite,
                     pp.id_int_comprobante,
                     cbte.tipo_cambio,
                     cbte.id_moneda,
                     cbte.fecha,
                     cbte.id_int_comprobante,
                     op.id_gestion,
                     cbte.id_periodo
                     
                   into
                     v_registros
                   from tes.tplan_pago pp 
                   inner join tes.tobligacion_pago op on op.id_obligacion_pago = pp.id_obligacion_pago
                   inner join conta.tint_comprobante cbte on cbte.id_int_comprobante = pp.id_int_comprobante
                   where pp.id_plan_pago = p_id_plan_pago;
                   
                   
                   --------------------------------------------------------------
                   -- 7777  Determinar la gestion de ejecucion presupeustaria    TODO
                   --------------------------------------------------------------
                   select  
                      per.id_gestion 
                    into 
                      v_id_gestion_cbte
                   from param.tperiodo per
                   where per.id_periodo = v_registros.id_periodo;
                 
                   
                  --recuperar el total de la obligacion
                   select 
                     sum(od.monto_pago_mo)
                    into
                     v_total_op_mo
                  from tes.tobligacion_det od
                  where      od.id_obligacion_pago = p_id_obligacion_pago
                         AND OD.estado_reg = 'activo' ; 
                   
                  IF v_total_op_mo <= 0 THEN
                     raise exception 'El total de la obligacion es menor o igual a cero';
                  END IF;
                  --determianr el factor por centro de costo y por aprtida
                  
                  
                 FOR v_registros_pro in (  
                                        select 
                                           od.id_centro_costo,
                                           od.id_partida,
                                           od.monto_pago_mo,
                                           od.monto_pago_mb,
                                           (od.monto_pago_mo / v_total_op_mo) as factor,
                                           par.codigo as codigo_partida
                                        from tes.tobligacion_det od
                                        inner join pre.tpartida par on par.id_partida = od.id_partida
                                        where      od.id_obligacion_pago = p_id_obligacion_pago
                                               AND OD.estado_reg = 'activo') LOOP
                                               
                           
                           -- ejecutar presupuesto en la proporcion determianda 
                           v_monto_ejecutar =   v_registros.monto *  v_registros_pro.factor;
                           v_monto_ejecutar_mb =   v_registros.monto_mb *  v_registros_pro.factor; 
                           
                           -- #7777  determinar la gestion de ejecucion 
                           IF v_id_gestion_cbte  = v_registros.id_gestion  THEN
                              v_id_centro_costo_ant = v_registros_pro.id_centro_costo;
                              v_id_partida_ant =  v_registros_pro.id_partida;
                           ELSE
                              raise exception 'La obligación de pago es de otra gestión .... <BR> esto generaría inconsistencia, antes de solicitar el anticipo  extienda la obligación de pago';
                           END IF;
                           
                           
                           -- #32  0/02/2018  se adicionan campo apra especificar el monto anticipado que se ejecuta y la glosa
                           v_resultado_ges = pre.f_gestionar_presupuesto_individual(
                                                    p_id_usuario,
                                                    v_registros.tipo_cambio,
                                                    v_id_centro_costo_ant , --  #7777
                                                    v_id_partida_ant,  --  #7777
                                                    v_registros.id_moneda,
                                                    v_monto_ejecutar,
                                                    v_registros.fecha,
                                                    'ejecutado'::varchar, --traducido a varchar
                                                    NULL,   --partida ejecucion
                                                    'id_plan_pago',
                                                    p_id_plan_pago,
                                                    v_registros.num_tramite,
                                                    v_registros.id_int_comprobante,
                                                    NULL,
                                                    'Ejecución de anticipo',
                                                    v_monto_ejecutar --monto que correponde al anticipo
                                                    
                                                    
                                                    ); 
                                                    
                                                    
                             --  analizamos respuesta y retornamos error
                               IF v_resultado_ges[1] = 0 THEN
                                                         
                                         --  recuperamos datos del presupuesto
                                         v_mensaje_error = COALESCE(v_mensaje_error, '') || conta.f_armar_error_presupuesto(v_resultado_ges, 
                                                                               v_registros_pro.id_centro_costo, 
                                                                               v_registros_pro.codigo_partida, 
                                                                               v_registros.id_moneda, 
                                                                               v_id_moneda_base, 
                                                                               'ejecutado', 
                                                                               v_monto_ejecutar_mb);
                                         v_sw_error = true;
                                                               
                               END IF; --fin id de error  
                                              
                                               
                  END LOOP; 
                  
                  
                  
                  IF p_id_usuario =  429 THEN
                     -- raise exception 'llega ... % - %',v_monto_ejecutar, v_registros_pro.id_partida;
                  END IF;
                  
                  IF v_sw_error THEN
                     raise exception 'Error al procesar presupuesto: %', v_mensaje_error;
                  END IF;
                  
                  
                  
            END IF;
       -----------------------------------------------------------------------    
       -- #31, revertir anticipos en proporcion 
       --      revierte en proporcion del  decuento por anticipo an las partidas y centros correpodencientes
       --      esta pensado para ejcutarce en la prevalizacion del comprobante de aplicacion
       ---------------------------------------------------------------------------------------------
       ELSEIF p_operacion = 'revertir_anticipo' THEN
        
          --OJO ANALIZAR SI ESTO SE EJECUTA
          
          raise exception 'entra para revertir...';
       
           v_tes_anticipo_ejecuta_pres = pxp.f_get_variable_global('tes_anticipo_ejecuta_pres');
           IF v_tes_anticipo_ejecuta_pres = 'si' THEN
                  --recuperar el total del monto que se va anticipiar, es el total a ejecutar
                   select 
                     pp.monto_mb,
                     pp.monto,               
                     pp.estado,
                     op.num_tramite,
                     pp.id_int_comprobante,
                     cbte.tipo_cambio,
                     cbte.id_moneda,
                     cbte.fecha,
                     cbte.id_int_comprobante,
                     pp.descuento_anticipo,
                     pp.descuento_anticipo_mb,
                     pp.tipo
                     
                   into
                     v_registros
                   from tes.tplan_pago pp 
                   inner join tes.tobligacion_pago op on op.id_obligacion_pago = pp.id_obligacion_pago
                   inner join conta.tint_comprobante cbte on cbte.id_int_comprobante = pp.id_int_comprobante
                   where pp.id_plan_pago = p_id_plan_pago;
                   
                  --recuperar el total de la obligacion
                   select 
                     sum(od.monto_pago_mo)
                    into
                     v_total_op_mo
                  from tes.tobligacion_det od
                  where      od.id_obligacion_pago = p_id_obligacion_pago
                         AND OD.estado_reg = 'activo' ; 
             
               
             
                --  indetifica el monto del anticipo a ser aplicado
                 IF v_registros.tipo in('ant_aplicado','devengado_pagado','devengado_pagado_1c','devengado')  THEN
                    v_sw_revertir_ant = true;
                    
                    --tenemos dos casos retencioanes parciales o plaicacion de anticopo segun el tipo de cuota
                    IF v_registros.tipo in('ant_aplicado') THEN
                       v_monto_a_revertir = v_registros.monto;
                       v_monto_a_revertir_mb = v_registros.monto_mb;
                    ELSE
                       v_monto_a_revertir = v_registros.descuento_anticipo;
                       v_monto_a_revertir_mb = v_registros.descuento_anticipo_mb;
                    END IF;
               
                 ELSE
                   v_sw_revertir_ant = false;
                 END IF;
               
               
               IF v_sw_revertir_ant THEN
                     -- recuperar de la tabla prorrateo los factores
                      FOR v_registros_pro in (  
                                              select 
                                                 od.id_centro_costo,
                                                 od.id_partida,
                                                 od.monto_pago_mo,
                                                 od.monto_pago_mb,
                                                 (od.monto_pago_mo / v_total_op_mo) as factor,
                                                 par.codigo as codigo_partida
                                              from tes.tobligacion_det od
                                              inner join pre.tpartida par on par.id_partida = od.id_partida
                                              where      od.id_obligacion_pago = p_id_obligacion_pago
                                                     AND OD.estado_reg = 'activo') LOOP
                                                     
                                                     
                                    -- ejecutar presupuesto en la proporcion determianda 
                                    v_monto_ejecutar =   v_monto_a_revertir *  v_registros_pro.factor;
                                    v_monto_ejecutar_mb =   v_monto_a_revertir_mb *  v_registros_pro.factor; 
                                    
                                    -- llamada para revertir presupuesto ejecutado                    
                                                     
                                    v_resultado_ges = pre.f_gestionar_presupuesto_individual(
                                                          p_id_usuario,
                                                          v_registros.tipo_cambio,
                                                          v_registros_pro.id_centro_costo ,
                                                          v_registros_pro.id_partida,
                                                          v_registros.id_moneda,
                                                          v_monto_ejecutar*-1,
                                                          v_registros.fecha,
                                                          'ejecutado'::varchar, --traducido a varchar
                                                          NULL,   --partida ejecucion
                                                          'id_plan_pago',
                                                          p_id_plan_pago,
                                                          v_registros.num_tramite,
                                                          v_registros.id_int_comprobante,
                                                          NULL); 
                                                          
                                                          
                                     --  analizamos respuesta y retornamos error
                                     IF v_resultado_ges[1] = 0 THEN
                                                               
                                               --  recuperamos datos del presupuesto
                                               v_mensaje_error = COALESCE(v_mensaje_error, '') || conta.f_armar_error_presupuesto(v_resultado_ges, 
                                                                                     v_registros_pro.id_centro_costo, 
                                                                                     v_registros_pro.codigo_partida, 
                                                                                     v_registros.id_moneda, 
                                                                                     v_id_moneda_base, 
                                                                                     'ejecutado', 
                                                                                     v_monto_ejecutar_mb);
                                               v_sw_error = true;
                                                                     
                                     END IF; --fin id de error                   
                     
                     
                     
                     END LOOP;
                     
                     IF v_sw_error THEN
                       raise exception 'Error al procesar presupuesto: %', v_mensaje_error;
                     END IF;
                     
                END IF;
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