--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_pagos_pendientes_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.f_pagos_pendientes_ime
 DESCRIPCION:   gestion de pagos pendientes
 AUTOR: 		 (admin)
 FECHA:	        10-04-2013 15:43:23
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
    v_registros  	    	record;
    v_registros_cot			record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_plan_pago	integer;
    
    v_id_alarma  integer[];
    v_asunto  varchar;
    v_template varchar;
    v_destinatorio varchar;
    
    va_id_tipo_estado integer[];
    va_codigo_estado varchar[];
    va_disparador varchar[];
    va_regla varchar[];
    va_prioridad INTEGER[];
    
    v_num_estados   integer;
    v_num_funcionarios  integer;
    v_id_funcionario_estado integer;
    v_num_deptos  integer;
    v_id_depto_estado integer;
    va_pagos_automaticos varchar[];
    v_sw_siguiente_estado  boolean;
    v_id_estado_wf_tmp integer;
    
    v_registros_pp   record;
    v_codigo_estado_siguiente  varchar;
    v_acceso_directo  varchar;
    v_clase  varchar;
    v_parametros_ad  varchar;
    v_tipo_noti  varchar;
    v_titulo  varchar;
    v_ps   varchar;
    
    v_acceso_directo_reg varchar;
    v_clase_reg varchar;
    v_parametros_ad_reg varchar;
    v_titulo_reg  varchar;
    v_sw_acceso_directo boolean;
    v_id_depto	integer;
    v_id_usuario_depto  integer;
    
    
    
			    
BEGIN

    v_nombre_funcion = 'tes.f_pagos_pendientes_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_PPPREV_INS'
 	#DESCRIPCION:	  corre atravez de un crom que diariamente se lanza.  esta funcion busca los  pagos pendientes e inserta un alarma al funcionario correpondientes
 	#AUTOR:		RAC KPLIAN	
 	#FECHA:		14-10-2014 15:43:23
	***********************************/

	if(p_transaccion='TES_PPPREV_INS')then
					
       begin
             
             --listado de pagos pendientes
            
             FOR v_registros in (
                 			SELECT 
                                  id_plan_pago,
                                  fecha_tentativa,
                                  id_estado_wf,
                                  id_proceso_wf,
                                  monto,
                                  liquido_pagable,
                                  monto_retgar_mo,
                                  monto_ejecutar_total_mo,
                                  estado,
                                  id_obligacion_dets,
                                  pagos_automaticos,
                                  desc_funcionario_solicitante,
                                  email_empresa_fun_sol,
                                  email_empresa_usu_reg,
                                  desc_funcionario_usu_reg,
                                  tipo,
                                  tipo_pago,
                                  tipo_obligacion,
                                  tipo_solicitud,
                                  tipo_concepto_solicitud,
                                  pago_variable,
                                  tipo_anticipo,
                                  estado_reg,
                                  num_tramite,
                                  nro_cuota,
                                  nombre_pago,
                                  obs,
                                  codigo_moneda,
                                  id_funcionario_solicitante,
                                  id_funcionario_registro,
                                  id_proceso_wf_op,
                                  estado_op
                                FROM 
                                  tes.vpago_pendientes_al_dia) LOOP 
                
                v_sw_siguiente_estado = FALSE;
                v_id_estado_wf_tmp = v_registros.id_estado_wf;                 
                va_pagos_automaticos =  string_to_array(v_registros.pagos_automaticos,',');
               
                ---------------------------------------------------------------
                -- verifica si es un pago automatico de un pago no variable,  
                -- si es automatico obtiene los datos del siguiente estado 
                ---------------------------------------------------------
               
                
                IF  'si' = ANY(va_pagos_automaticos)  and v_registros.pago_variable = 'no' THEN
                         
                         
                         --obtiene los estados siguientes
                         
                         SELECT 
                             *
                          into
                            va_id_tipo_estado,
                            va_codigo_estado,
                            va_disparador,
                            va_regla,
                            va_prioridad
                        
                        FROM wf.f_obtener_estado_wf(v_registros.id_proceso_wf, v_registros.id_estado_wf,NULL,'siguiente');
                        
                        --  verifica cuantos estados siguientes tiene el plan de pagos
                        
                         v_num_estados= array_length(va_id_tipo_estado, 1);
                         
                         v_sw_siguiente_estado  = FALSE;
                         
                        
                         --si solo tenemos un estado destino disposbile , buscamos si solo se tiene un funcionario destino
                         IF v_num_estados = 1 then
                                       
                                       -- si solo hay un estado,  verificamos si tiene mas de un funcionario por este estado
                                       SELECT 
                                       *
                                        into
                                       v_num_funcionarios 
                                       FROM wf.f_funcionario_wf_sel(
                                           p_id_usuario, 
                                           va_id_tipo_estado[1], 
                                           now()::date,
                                           v_registros.id_estado_wf,
                                           TRUE) AS (total bigint);
                                           
                                       IF v_num_funcionarios = 1 THEN
                                               -- si solo es un funcionario, recuperamos el funcionario correspondiente
                                               SELECT 
                                                   id_funcionario
                                                     into
                                                   v_id_funcionario_estado
                                               FROM wf.f_funcionario_wf_sel(
                                                   p_id_usuario, 
                                                   va_id_tipo_estado[1], 
                                                   now()::date ,
                                                   v_registros.id_estado_wf,
                                                   FALSE) 
                                                   AS (id_funcionario integer,
                                                     desc_funcionario text,
                                                     desc_funcionario_cargo text,
                                                     prioridad integer);
                                                     
                                            v_sw_siguiente_estado  = TRUE;
                                      END IF; 
                                     
                                      
                                      --verificamos el numero de deptos
                                    
                                        SELECT 
                                        *
                                        into
                                          v_num_deptos 
                                       FROM wf.f_depto_wf_sel(
                                           p_id_usuario, 
                                           va_id_tipo_estado[1], 
                                           now()::date,
                                           v_registros.id_estado_wf,
                                           TRUE) AS (total bigint);
                                                     
                                      IF v_num_deptos = 1 THEN
                                      -- si solo es un funcionario, recuperamos el funcionario correspondiente
                                                 SELECT 
                                                     id_depto
                                                       into
                                                     v_id_depto_estado
                                                FROM wf.f_depto_wf_sel(
                                                     p_id_usuario, 
                                                     va_id_tipo_estado[1], 
                                                     now()::date,
                                                     v_registros.id_estado_wf,
                                                     FALSE) 
                                                     AS (id_depto integer,
                                                     codigo_depto varchar,
                                                     nombre_corto_depto varchar,
                                                     nombre_depto varchar,
                                                     prioridad integer,
                                                     subsistema varchar);
                                                     
                                                 v_sw_siguiente_estado  = TRUE;
                                      END IF;  
                                      
                                       
                        END IF;
                       
                         ----------------------------------------------------------------
                         --  si tiene solo un camino posible pasa al siguiente estado
                         --  un solode funcionario o un solo depto destino
                         --------------------------------------------------------------
                       
                        
                        IF   v_sw_siguiente_estado  THEN
                           
                        
                        
                                    --obtenermos datos basicos del pago
                                    select
                                        pp.id_plan_pago,
                                        pp.id_proceso_wf,
                                        pp.id_estado_wf,
                                        pp.estado,
                                        pp.fecha_tentativa,
                                        op.numero,
                                        pp.total_prorrateado ,
                                        pp.monto_ejecutar_total_mo
                                    into 
                                        v_registros_pp
                                        
                                    from tes.tplan_pago  pp
                                    inner  join tes.tobligacion_pago op on op.id_obligacion_pago = pp.id_obligacion_pago
                                    where pp.id_proceso_wf  = v_registros.id_proceso_wf;
                                  
                                    -- obtener datos tipo estado
                          
                                    select
                                     te.codigo
                                    into
                                     v_codigo_estado_siguiente
                                    from wf.ttipo_estado te
                                    where te.id_tipo_estado = va_id_tipo_estado[1];
                        
                                   
                                    
                                    --configurar acceso directo para la alarma   
                                     v_acceso_directo = '';
                                     v_clase = '';
                                     v_parametros_ad = '';
                                     v_tipo_noti = 'notificacion';
                                     v_titulo  = 'Visto Bueno';
                                     
                                   
                                     IF   v_codigo_estado_siguiente not in('borrador','pendiente','pagado','devengado','anulado')   THEN
                                          v_acceso_directo = '../../../sis_tesoreria/vista/plan_pago/PlanPagoVb.php';
                                          v_clase = 'PlanPagoVb';
                                          v_parametros_ad = '{filtro_directo:{campo:"plapa.id_proceso_wf",valor:"'||v_registros_pp.id_proceso_wf::varchar||'"}}';
                                          v_tipo_noti = 'notificacion';
                                          v_titulo  = 'Visto Bueno';
                                     
                                     END IF;
                                   
                                   
                                   
                                   v_id_estado_wf_tmp = wf.f_registra_estado_wf(
                                                             va_id_tipo_estado[1], 
                                                             v_id_funcionario_estado, 
                                                             v_registros_pp.id_estado_wf, 
                                                             v_registros_pp.id_proceso_wf,
                                                             p_id_usuario,
                                                             v_parametros._id_usuario_ai,
                                                             v_parametros._nombre_usuario_ai,
                                                             v_id_depto_estado,
                                                             'Solicitud automatica de pago',
                                                             v_acceso_directo ,
                                                             v_clase,
                                                             v_parametros_ad,
                                                             v_tipo_noti,
                                                             v_titulo);
                                                             
                                                             
                                 IF  tes.f_fun_inicio_plan_pago_wf(p_id_usuario, 
           									v_parametros._id_usuario_ai, 
                                            v_parametros._nombre_usuario_ai, 
                                            v_id_estado_wf_tmp, 
                                            v_registros_pp.id_proceso_wf, 
                                            v_codigo_estado_siguiente) THEN
                                            
                                 END IF;
                       
                
                         END IF;
                
                END IF;
                
                
                ----------------------------
                -- arma template de correo
                -----------------------------
                
                
                v_asunto = 'Pago al proveedor :  '||v_registros.nombre_pago;
                v_destinatorio = '<br>Estimad@: '||COALESCE(v_registros.desc_funcionario_solicitante,'NAN');
                v_template = '<br>A la fecha se cumple el plazo previsto para iniciar el  pago Nº '||v_registros.nro_cuota::varchar||'
                              <br>del proveedor '||v_registros.nombre_pago||' con el tramite <b>'||v_registros.num_tramite||'</b>
                              <br>por el monto de '||v_registros.monto::varchar||' '||v_registros.codigo_moneda::varchar||'
                              '||(pxp.f_iif( v_registros.obs != '', '<br>Observaciones:<br><p>'||COALESCE(v_registros.obs,'---')||'</p>',''))||'
                              <br>
                              <br> Atentamente  
                              <br> &nbsp;&nbsp;&nbsp;&nbsp;Control de pagos del Sistema ERP BOA';
                             
               IF  v_sw_siguiente_estado  THEN
                        v_ps = '<br><br> PS: El pago paso al estado '||COALESCE(v_codigo_estado_siguiente,'NAN');
               ELSE
                        v_ps = '<br><br> PS: Este mensaje le llegara cada día hasta que sea iniciado el pago'; 
               END IF;
                
                -------------------------------------------------------------
                -- inserta alarmas  para el funcionario 
                -- solicitante y para el funcionario que registro el plan de pagos
                -----------------------------------------------------------
                
                -- preapra acceso directo  si no tu vo saltos
                IF  not v_sw_siguiente_estado THEN  
                
                
                    v_sw_acceso_directo = FALSE;    
                
                    -------------------------------------------------------------------------------------------------
                    -->  1) si el pago esta en borador, para el usuario que registra y no es de adquisiciones el acceso directo es la interface de solictud de pagos
                    -->  2) ei el pago esta en borrador, para usuario que registra y es de aduqiisiones el acceso directo es la interface de obligacion de pago
                    -->  3) si el pago es borrador para el soclitante y es de aduiqiciones no tiene acceso directo
                    
                    -->  5) si el estado es vbsolicitante, para el usario que registra no hay acceso directo
                    --> 6) si el estado es vbsolicitante, para el usuario que solicita el acceso directo en la interface de VoBo solicitud de pago
                    ----------------------------------------------------------------------------------------------------
                     
                    
                    --> 1) si el pago esta en borrador, para el usuario que registra y no es de adquisiciones el acceso directo es la interface de solictud de pagos
                    
                    IF v_registros.estado  in('borrador') and v_registros.tipo_obligacion = 'pago_directo'  THEN
                      
                          v_acceso_directo_reg = '../../../sis_tesoreria/vista/obligacion_pago/ObligacionPagoSol.php';
                          v_clase_reg = 'ObligacionPagoSol';
                          v_parametros_ad_reg = '{filtro_directo:{campo:"obpg.id_proceso_wf",valor:"'||v_registros.id_proceso_wf_op::varchar||'"}}';
                          v_titulo_reg  = 'Obligacion de pago';
                          
                          v_sw_acceso_directo = TRUE; 
                          
                     END IF;
                     
                     --> 2) si el pago esta en borrador, para usuario que registra y es de aduqiisiones el acceso directo es la interface de obligacion de pago
                     
                      IF v_registros.estado  in ('borrador') and v_registros.tipo_obligacion = 'adquisiciones'  THEN
                      
                          v_acceso_directo_reg = '../../../sis_tesoreria/vista/obligacion_pago/ObligacionPagoAdq.php';
                          v_clase_reg = 'ObligacionPagoAdq';
                          v_parametros_ad_reg = '{filtro_directo:{campo:"obpg.id_proceso_wf",valor:"'||v_registros.id_proceso_wf_op::varchar||'"}}';
                          v_titulo_reg  = 'Obligacion de pago';
                          
                           v_sw_acceso_directo = TRUE; 
                          
                     END IF;
                     
                     -->  3) si el pago es borrador para el solicitante y es de aduiqiciones no tiene acceso directo
                     IF v_registros.estado  in ('borrador') and v_registros.tipo_obligacion = 'adquisiciones'  THEN
                      
                          v_acceso_directo = '';
                          v_clase = '';
                          v_parametros_ad = '{}';
                          v_titulo  = 'Recordatorio de pago';
                          
                           v_sw_acceso_directo = TRUE; 
                          
                     END IF;
                    
                    
                     --> 5) si el estado es vbsolicitante, para el usario que registra no hay acceso directo
                     --> 6) si el estado es vbsolicitante, para el usuario que solicita el acceso directo en la interface de VoBo solicitud de pago
                     IF v_registros.estado in('vbsolicitante')   THEN
                      
                          --para el solicitante
                          v_acceso_directo = '../../../sis_tesoreria/vista/plan_pago/PlanPagoVb.php';
                          v_clase = 'PlanPagoVb';
                          v_parametros_ad = '{filtro_directo:{campo:"plapa.id_proceso_wf",valor:"'||v_registros.id_proceso_wf::varchar||'"}}';
                          v_titulo  = 'Visto Bueno de pago para el Solicitante';
                          
                          
                          -- para el usuario que registra
                           v_acceso_directo_reg = '';
                           v_clase_reg = '';
                           v_parametros_ad_reg = '{}';
                           v_titulo_reg  = 'Recordatorio de pago';
                            v_sw_acceso_directo = TRUE; 
                          
                     END IF;
                     
                     --si no se detecto una configuracion para accesos directo por defecto opnemos ninguno
                     IF  not v_sw_acceso_directo  THEN
                     
                           -- para el usuario que registra
                           v_acceso_directo_reg = '';
                           v_clase_reg = '';
                           v_parametros_ad_reg = '{}';
                           v_titulo_reg  = 'Recordatorio de pago';
                           
                           
                            v_acceso_directo = '';
                            v_clase = '';
                            v_parametros_ad = '{}';
                            v_titulo  = 'Recordatorio de pago';
                     
                     END IF; 
                                     
                ELSE
                
                    v_acceso_directo = '';
                    v_clase = '';
                    v_parametros_ad = '{}';
                    v_titulo  = 'Recordatorio de pago';
                    
                    -- para el usuario que registra
                     v_acceso_directo_reg = '';
                     v_clase_reg = '';
                     v_parametros_ad_reg = '{}';
                     v_titulo_reg  = 'Recordatorio de pago';
                
                END IF;
                
                
                
                
                -- inserta registros de alarmas
                v_id_alarma[1]:=param.f_inserta_alarma(v_registros.id_funcionario_solicitante,
                                                    v_destinatorio||v_template||v_ps ,    --descripcion alarmce
                                                    COALESCE(v_acceso_directo,''),--acceso directo
                                                    now()::date,
                                                    'notificacion',
                                                    '',   -->
                                                    p_id_usuario,
                                                    v_clase,
                                                    v_titulo,--titulo
                                                    COALESCE(v_parametros_ad,''),
                                                    NULL::integer,
                                                    v_asunto);
                
                
                -- validacion para no madar alerta a los usarios de adquisiciones, yno mandar doble si el usario que registras es el mismo que solicita
                
                IF  v_registros.id_funcionario_registro is not null AND v_registros.id_funcionario_registro != v_registros.id_funcionario_solicitante  and  v_registros.tipo_obligacion  != 'adquisiciones' THEN
                    
                    v_destinatorio = '<br>Estimad@: '||COALESCE(v_registros.desc_funcionario_usu_reg,'NAN');
                    v_id_alarma[2]:=param.f_inserta_alarma(v_registros.id_funcionario_registro,
                                                        v_destinatorio||v_template||v_ps,    --descripcion alarmce
                                                        COALESCE(v_acceso_directo_reg,''),--acceso directo
                                                        now()::date,
                                                        'notificacion',
                                                        '',   -->
                                                        p_id_usuario,
                                                        v_clase_reg,
                                                        v_titulo_reg,--titulo
                                                        COALESCE(v_parametros_ad_reg,''),
                                                        NULL::integer,
                                                        v_asunto);
                END IF;
                --anade alarma en el array de estado wf
                update wf.testado_wf   set
                  id_alarma =  id_alarma||v_id_alarma
                where id_Estado_wf = v_id_estado_wf_tmp;
       
            END LOOP;
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','cheqoe de pagos pedientes  y envio de alarmas'); 
            
            
            --Devuelve la respuesta
            return v_resp;        
        end;
    
    /*********************************    
 	#TRANSACCION:  'TES_FORM500_INS'
 	#DESCRIPCION:	  Registra alertas apra formulario 500 en procesos de adquisiciones
 	#AUTOR:		RAC KPLIAN	
 	#FECHA:		02-03-2015 15:43:23
	***********************************/

	ELSEIF (p_transaccion='TES_FORM500_INS')then
					
       begin
       
        -- seleccionar los ulitmos registros de planes de pagos de adquisiciones que reuqieren alerta
         FOR v_registros in (
         			with pagos as(
                            select op.num_tramite,
                                   op.id_obligacion_pago,
                                   max(pp.id_plan_pago) as id_plan_pago,
                                   max(pp.nro_cuota) as ultima_cuota,
                                   op.id_proveedor,
                                   pro.desc_proveedor,
                                   op.total_pago,
                                   mon.codigo as codigo_moneda,
                                   cot.tiene_form500,
                                   cot.id_cotizacion,
                                   max(pp.fecha_tentativa) as fecha_tentativa
                            from tes.tplan_pago pp
                                 inner join tes.tobligacion_pago op on op.id_obligacion_pago =
                                   pp.id_obligacion_pago and op.tipo_obligacion = 'adquisiciones' and (
                                   op.total_pago * op.tipo_cambio_conv) > 20000
                                 inner join adq.tcotizacion cot on cot.id_obligacion_pago =
                                   op.id_obligacion_pago
                                 inner join param.vproveedor pro on pro.id_proveedor = op.id_proveedor
                                 inner join param.tmoneda mon on mon.id_moneda = op.id_moneda
                            where pp.tipo in ('devengado_pagado', 'devengado_pagado_1c') and
                                  pp.estado_reg = 'activo' and
                                  pp.estado not in ('devengado', 'anulado', 'pagado') and
                                  cot.tiene_form500 in ('no', 'requiere')
                            group by op.id_obligacion_pago,
                                     op.num_tramite,
                                     op.id_proveedor,
                                     pro.desc_proveedor,
                                     op.total_pago,
                                     mon.codigo,
                                     cot.tiene_form500,
                                     cot.id_cotizacion)
                            select *
                            from pagos
                            where fecha_tentativa::date <= now() ::date)  LOOP
                        
                -- identifica a que usarios se mandan las alertas             
                select  
                    du.id_usuario as id_usuario_depto,
                    op.id_usuario_reg,
                    op.ultima_cuota_dev
                into
                    v_registros_cot 
                from adq.tcotizacion cot 
                inner join tes.tobligacion_pago op  on  op.id_obligacion_pago = cot.id_obligacion_pago
                inner join adq.tproceso_compra pro on pro.id_proceso_compra = cot.id_proceso_compra
                
                inner join param.tdepto_usuario du on du.id_depto = pro.id_depto and du.cargo = 'responsable'
                where cot.id_obligacion_pago = v_registros.id_obligacion_pago
                limit 1 offset 0;
            
               
               
           
                ----------------------------
                -- arma template de correo
                -----------------------------
                
                
                v_asunto = 'Formulario 500 :  '||v_registros.desc_proveedor;
                v_destinatorio = '<br>Estimad@';
                v_template = '<br>
                			  <br>A la fecha se cumple el plazo previsto para iniciar el  pago Nº '||v_registros.ultima_cuota::varchar||'
                              <br>del proveedor '||v_registros.desc_proveedor||' con el tramite <b>'||v_registros.num_tramite||'</b>
                              <br>por el monto de '||v_registros.total_pago::varchar||' '||v_registros.codigo_moneda::varchar||'
                              <br>
                              <br>Es necesario registrar el formulario 500 correspondiente.
                              <br>
                              <br> Atentamente  
                              <br> &nbsp;&nbsp;&nbsp;&nbsp;Control de pagos del Sistema ERP BOA';
           
           
                -- inserta registros de alarmas par ael usario que creo la obligacion
                v_id_alarma[1]:=param.f_inserta_alarma(NULL,
                                                    v_destinatorio||v_template ,    --descripcion alarmce
                                                    COALESCE(v_acceso_directo,''),--acceso directo
                                                    now()::date,
                                                    'notificacion',
                                                    '',   -->
                                                    p_id_usuario,
                                                    v_clase,
                                                    v_titulo,--titulo
                                                    COALESCE(v_parametros_ad,''),
                                                    v_registros_cot.id_usuario_reg::integer,  --destino de la alarma
                                                    v_asunto);
                
                
                --inserta la alrma para le usario responsable del depto de adquisiciones
                
                IF v_registros_cot.id_usuario_depto is not NULL and v_registros_cot.id_usuario_depto != v_registros_cot.id_usuario_reg THEN
                  v_id_alarma[1]:=param.f_inserta_alarma(NULL,
                                                      v_destinatorio||v_template ,    --descripcion alarmce
                                                      COALESCE(v_acceso_directo,''),--acceso directo
                                                      now()::date,
                                                      'notificacion',
                                                      '',   -->
                                                      p_id_usuario,
                                                      v_clase,
                                                      v_titulo,--titulo
                                                      COALESCE(v_parametros_ad,''),
                                                      v_registros_cot.id_usuario_depto::integer,  --destino de la alarma
                                                      v_asunto);
                
                END IF;
               -- actualiza la  marca del plan de pagos
               update  tes.tplan_pago set
               tiene_form500 = 'requiere'
               where id_plan_pago = v_registros.id_plan_pago;
               
               -- actualiza la  marca del de cotizacion para que ya no lelguen alertas
               update  adq.tcotizacion set
               tiene_form500 = 'requiere'
               where id_cotizacion = v_registros.id_cotizacion;
      
       END LOOP;
        
        
        
       
        
        
       
        --Devuelve la respuesta
        return v_resp;  
       
       end;
	    
    else
     
    	raise exception 'Transaccion inexistente: %',p_transaccion;

	end if;

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