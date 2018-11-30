--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_inserta_plan_pago_dev (
  p_administrador integer,
  p_id_usuario integer,
  p_hstore public.hstore,
  p_salta boolean = false
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		tes.f_inserta_plan_pago_dev
 DESCRIPCION:   Inserta registro de cotizacion
 AUTOR: 		Rensi Arteaga COpar
 FECHA:	        26-1-2014
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
ISSUE 			FECHA: 			AUTOR:						DESCRIPCION:
 #1				16/10/2018		EGS							se aumento el campo pago_borrador en la sentencia de insercion y una validacion	
	
***************************************************************************/

DECLARE

    v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
 
    v_id_cuenta_bancaria 			integer;
    v_id_cuenta_bancaria_mov 		integer;
    v_forma_pago 					varchar;
    v_nro_cheque 					integer;
    v_nro_cuenta_bancaria  			varchar;
    v_centro 						varchar;
    v_registros   					record;
    v_nro_cuota						numeric;
    v_fecha_tentativa				date;
    v_monto_total					numeric;
    v_liquido_pagable 				numeric;
    v_monto_ejecutar_total_mo   	numeric;
    va_id_tipo_estado_pro 			integer[];
    va_codigo_estado_pro 			varchar[];
    va_disparador_pro 				varchar[];
    va_regla_pro 					varchar[];
    va_prioridad_pro 				integer[];
    
    v_id_estado_actual 				integer;
    
    
    v_id_proceso_wf 				integer;
    v_id_estado_wf 					integer;
    v_codigo_estado					varchar;
    v_id_plan_pago					integer;
    
    v_monto_excento					numeric;
    v_porc_monto_excento_var		numeric;
    v_sw_me_plantilla               varchar;
    
    v_registros_tpp                 record;
    v_porc_monto_retgar             numeric;
    
    v_monto_ant_parcial_descontado  numeric;
    v_saldo_x_pagar  numeric; 
    v_saldo_x_descontar   numeric; 
    
    v_resp_doc   boolean;
    v_obligacion	record;
    
    v_monto_anticipo  numeric;
    v_check_ant_mixto numeric;
    
 v_pago_borrador  varchar; --#1				16/10/2018		EGS	
    			
    
    
               
 
     
			    
BEGIN

    /*
    HSTORE  PARAMETERS
    
    (p_hstore->'id_cuenta_bancaria')::integer;
    (p_hstore->'id_cuenta_bancaria_mov')::integer;
    (p_hstore->'forma_pago')::varchar;
    (p_hstore->'nro_cheque')::integer;
    (p_hstore->'nro_cuenta_bancaria')::varchar;
    (p_hstore->'monto')::numeric
    (p_hstore->'id_obligacion_pago')::integer;
    (p_hstore->'monto_no_pagado')::numeric
    (p_hstore->'monto_retgar_mo')::numeric
    (p_hstore->'descuento_ley')::numeric
    (p_hstore->'otros_descuentos')::numeric
    (p_hstore->'monto_no_pagado')::numeric
    (p_hstore->'tipo_pago')::varchar
    (p_hstore->'fecha_tentativa')::date
    (p_hstore->'id_plan_pago_fk')::integer
    (p_hstore->'id_plantilla')::integer
    (p_hstore->'tipo')::varchar
    
    (p_hstore->'porc_monto_excento_var')::numeric
    (p_hstore->'monto_excento')::numeric
    
   
   (p_hstore->'tipo_cambio')::numeric,
   (p_hstore->'obs_descuentos_ley'),
   (p_hstore->'obs_monto_no_pagado')::text,
   (p_hstore->'obs_otros_descuentos')::text,
   (p_hstore->'porc_descuento_ley')::numeric,
   
   (p_hstore->'_id_usuario_ai')::integer, 
   (p_hstore->'_nombre_usuario_ai')::varchar,
    
   (p_hstore->'fecha_costo_ini')::date, 
   (p_hstore->'fecha_costo_fin')::date,   
    
    
    
    
    */
         

          v_nombre_funcion = 'tes.f_inserta_plan_pago_dev';
          
          select * into v_obligacion
          from tes.tobligacion_pago op
          where id_obligacion_pago = (p_hstore->'id_obligacion_pago')::integer;
          
         --determinar exixtencia de parametros dinamicos para registro  
         -- (Interface de obligacions de adquisocines o interface de obligaciones tesoeria)
         -- la adquisiciones tiene menos parametros presentes
           
           
             v_id_cuenta_bancaria =  (p_hstore->'id_cuenta_bancaria')::integer;
             v_id_cuenta_bancaria_mov =  (p_hstore->'id_cuenta_bancaria_mov')::integer;
             v_forma_pago =  (p_hstore->'forma_pago')::varchar;
             v_nro_cheque =  (p_hstore->'nro_cheque')::integer;
             v_nro_cuenta_bancaria =  (p_hstore->'nro_cuenta_bancaria')::varchar;
             v_porc_monto_excento_var = (p_hstore->'porc_monto_excento_var')::numeric;
             v_monto_excento = (p_hstore->'monto_excento')::numeric;
             v_monto_anticipo = COALESCE((p_hstore->'monto_anticipo')::numeric, 0);
             
             
           -- segun el tipo  recuepramos el tipo_plan_pago, determinamos el flujos para el WF
           select 
            tpp.id_tipo_plan_pago,
            tpp.codigo_proceso_llave_wf
           into
           v_registros_tpp
           from  tes.ttipo_plan_pago  tpp
           where tpp.codigo =  (p_hstore->'tipo')::varchar; 
           
           
           IF  v_registros_tpp.codigo_proceso_llave_wf is NULL or v_registros_tpp.codigo_proceso_llave_wf = '' THEN
              
               raise exception 'El tipo de plan de pago (%) no tiene un proceso de WF relacionado',(p_hstore->'tipo');
           
           END IF;
             
            
           
           --validamos que el monto a pagar sea mayor que cero
           /*jrr(10/10/2014): El monto puede ser 0 en pagos variables*/ 
           IF  (p_hstore->'monto')::numeric = 0 and v_obligacion.pago_variable = 'no' THEN
           
              raise exception 'El monto a pagar no puede ser 0';
           
           END IF;
           
           IF  v_monto_anticipo  < 0 THEN
              raise exception 'El monto para anticipo no puede ser menor a cero';
           END IF;
           
           
           
          --  obtiene datos de la obligacion
           
          select
            op.porc_anticipo,
            op.porc_retgar,
            op.num_tramite,
            op.id_proceso_wf,
            op.id_estado_wf,
            op.estado,
            op.id_depto,
            op.pago_variable,
            op.numero
            
          into v_registros  
           from tes.tobligacion_pago op
           where op.id_obligacion_pago = (p_hstore->'id_obligacion_pago')::integer;
           
           
           select   
             max(pp.nro_cuota),
             max(pp.fecha_tentativa)
           into
             v_nro_cuota,
             v_fecha_tentativa
           from tes.tplan_pago pp 
           where 
               pp.id_obligacion_pago = (p_hstore->'id_obligacion_pago')::integer
           and pp.estado_reg='activo';
           
          -------------------------------------------------------------------
          --  VALIDACION DE MONTO FALTANTE, SEGUN TIPO DE CUOTA
          ------------------------------------------------------------
          
          IF (p_hstore->'tipo') in('devengado_rrhh','devengado','devengado_pagado','devengado_pagado_1c','especial') THEN 
           
                --si es un proceso variable, verifica que el registro no sobrepase el total a pagar
                IF v_registros.pago_variable='no' THEN                
                
                        v_monto_total= tes.f_determinar_total_faltante((p_hstore->'id_obligacion_pago')::integer, 'registrado');
                        IF v_monto_total  <  (p_hstore->'monto')::numeric  THEN
                           raise exception 'No puede exceder el total a pagar en obligaciones no variables.  Si tiene gasto para la siguiente gestión incremente el monto estimado en la obligacion de pago';
                        END IF;
                        
                                                
                        --   si es  un pago no variable  (si es una cuota de devengao_pagado, devegando_pagado_1c, pagado)
                        --  validar que no se haga el ultimo pago sin  terminar de descontar el anticipo,
                        
                        IF   (p_hstore->'tipo') in('devengado_pagado','devengado_pagado_1c')  THEN
                            -- saldo_x_pagar = determinar cuanto falta por pagar (sin considerar el devengado)
                            v_saldo_x_pagar = tes.f_determinar_total_faltante((p_hstore->'id_obligacion_pago')::integer,'total_registrado_pagado');
                              
                            -- saldo_x_descontar = determinar cuanto falta por descontar del anticipo
                            v_saldo_x_descontar = tes.f_determinar_total_faltante((p_hstore->'id_obligacion_pago')::integer,'ant_parcial_descontado');
                               
                            -- saldo_x_descontar - descuento_anticipo >  sando_x_pagar
                            IF (v_saldo_x_descontar -  COALESCE((p_hstore->'descuento_anticipo')::numeric,0))  > (v_saldo_x_pagar  - COALESCE((p_hstore->'monto')::numeric,0)) THEN
                                raise exception 'El saldo a pagar no es sufuciente para recuperar el anticipo (%)',v_saldo_x_descontar;
                            END IF;
                            
                         END IF;
                 
                END IF;
          
          ELSE
            
            raise exception 'tipo no reconocido %',(p_hstore->'tipo');
          
          END IF; 
          
           
          -- valida que la retencion de anticipo no sobrepase el total del anticipo parcial
                 
          v_monto_ant_parcial_descontado = tes.f_determinar_total_faltante((p_hstore->'id_obligacion_pago')::integer, 'ant_parcial_descontado' );
          IF v_monto_ant_parcial_descontado <  COALESCE((p_hstore->'descuento_anticipo')::numeric,0)  THEN
              raise exception 'El decuento por anticipo no puede exceder el faltante por descontar que es  %',v_monto_ant_parcial_descontado;
          END IF;
          
          
          IF  (p_hstore->'monto')::numeric < 0 or (p_hstore->'monto_no_pagado')::numeric < 0 or (p_hstore->'otros_descuentos')::numeric  < 0 or COALESCE((p_hstore->'descuento_anticipo')::numeric,0)  < 0 THEN
               raise exception 'No se admiten cifras negativas'; 
          END IF;
          
          
          -- calcula el liquido pagable y el monto a ejecutar presupeustariamente
           
          v_liquido_pagable = COALESCE((p_hstore->'monto')::numeric,0)  - COALESCE((p_hstore->'monto_no_pagado')::numeric,0) - COALESCE((p_hstore->'otros_descuentos')::numeric,0) - COALESCE((p_hstore->'monto_retgar_mo')::numeric,0) - COALESCE((p_hstore->'descuento_ley')::numeric,0) - COALESCE((p_hstore->'descuento_anticipo')::numeric,0) - COALESCE((p_hstore->'descuento_inter_serv')::numeric,0);
          v_monto_ejecutar_total_mo  = COALESCE((p_hstore->'monto')::numeric,0) -  COALESCE((p_hstore->'monto_no_pagado')::numeric,0) - v_monto_anticipo;
          
          --revision de anticipo
          IF (p_hstore->'tipo') in('devengado','devengado_pagado','devengado_pagado_1c') THEN 
               --si es un proceso variable, verifica que el registro no sobrepase el total a pagar
               IF v_registros.pago_variable='no' THEN                
                        -- Validamos anticipos mistos
                        -- total a ejecutar + total_anticipo (mixto) <= total a pagar (presupuestado) +(total a pagar siguiente gestion)
                        v_check_ant_mixto = tes.f_determinar_total_faltante((p_hstore->'id_obligacion_pago')::integer, 'registrado_monto_ejecutar');
                        IF v_check_ant_mixto - v_monto_ejecutar_total_mo - v_monto_anticipo  < 0 THEN
                             raise exception 'El monto del anticipo sobre pasa lo previsto para la siguiente gestion, ajuste el monto a ejecutarpara la siguiente gestión';
                        END IF;
               END IF;
          END IF;
          
          /*jrr(10/10/2014): El monto puede ser 0 en pagos variables*/ 
          if (COALESCE((p_hstore->'monto')::numeric,0) > 0) then
          	v_porc_monto_retgar = COALESCE((p_hstore->'monto_retgar_mo')::numeric,0)/COALESCE((p_hstore->'monto')::numeric,0);
          end if;
          
          
          
          IF   v_liquido_pagable  < 0  or v_monto_ejecutar_total_mo < 0  THEN
              raise exception ' Ni  el monto a ejecutar   ni el liquido pagable  puede ser menor a cero';
          END IF;  
           
          
         --RAC 11/02/2014 
         --calculo porcentaje monto excento
         
         Select  
         p.sw_monto_excento
         into
         v_sw_me_plantilla
         from param.tplantilla p 
         where p.id_plantilla =  (p_hstore->'id_plantilla')::integer;    
         
         --si es una plantilla de monto excento
         IF v_sw_me_plantilla = 'si' and  v_monto_excento < 0 THEN
         
            raise exception  'Este documento necesita especificar un monto excento mayor a cero';
         
         END IF;
         
         /*jrr(10/10/2014): El monto puede ser 0 en pagos variables*/ 
         IF v_monto_excento >  v_monto_ejecutar_total_mo and v_monto_ejecutar_total_mo != 0 THEN
           raise exception 'El monto excento (%) debe ser menor que el total a ejecutar(%)',v_monto_excento, v_monto_ejecutar_total_mo  ;
         END IF;
         
         IF v_monto_excento > 0 THEN
            v_porc_monto_excento_var  = v_monto_excento / COALESCE((p_hstore->'monto')::numeric,0);
         ELSE
            v_porc_monto_excento_var = 0;
         END IF;
         
         
         -- define numero de cuota
          
         v_nro_cuota = floor(COALESCE(v_nro_cuota,0))+1; 
            
         -- raise exception 'xxx %',v_registros;
           
          -------------------------------------
          --  Manejo de estados con el WF
          -------------------------------------
           
         
           
          --cambia de estado al obligacion
          IF  v_registros.estado = 'registrado' THEN
          
          
          
               SELECT 
                     ps_id_tipo_estado,
                     ps_codigo_estado,
                     ps_disparador,
                     ps_regla,
                     ps_prioridad
                  into
                    va_id_tipo_estado_pro,
                    va_codigo_estado_pro,
                    va_disparador_pro,
                    va_regla_pro,
                    va_prioridad_pro
                          
                FROM wf.f_obtener_estado_wf( v_registros.id_proceso_wf,  v_registros.id_estado_wf,NULL,'siguiente');   
          
        
                IF  va_id_tipo_estado_pro[2] is not null  THEN
                           
                     raise exception 'La obligacion se encuentra mal parametrizado dentro de Work Flow,  el estado registro  solo  admite un estado siguiente,  no admitido (%)',va_codigo_estado_pro[2];
                           
                END IF;
                
                
                          
                     
                IF  va_codigo_estado_pro[1] != 'en_pago'  THEN
                  raise exception 'La obligacion se encuentra mal parametrizado dentro de Work Flow, el siguiente estado para el proceso de compra deberia ser "en_pago" y no % ',va_codigo_estado_sol[1];
                END IF; 
                
                 -- registra estado eactual en el WF para rl procesod e compra
                     
                    
                 
                  v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado_pro[1], 
                                                                   NULL, --id_funcionario
                                                                    v_registros.id_estado_wf, 
                                                                    v_registros.id_proceso_wf,
                                                                    p_id_usuario,
                                                                    (p_hstore->'_id_usuario_ai')::integer,
                                                                    (p_hstore->'_nombre_usuario_ai')::varchar,
                                                                    v_registros.id_depto);
                    
                    --actualiza el proceso
                    
                    -- actuliaza el stado en la solictud
                     update tes.tobligacion_pago  p set 
                       id_estado_wf =  v_id_estado_actual,
                       estado = va_codigo_estado_pro[1],
                       id_usuario_mod=p_id_usuario,
                       fecha_mod=now(),
                       id_usuario_ai = (p_hstore->'_id_usuario_ai')::integer,
                       usuario_ai = (p_hstore->'_nombre_usuario_ai')::varchar
                     where id_obligacion_pago = (p_hstore->'id_obligacion_pago')::integer;
                     
                      -- raise exception 'xxxxxxxxxxxxx  %', v_id_estado_actual ;
                     --dispara estado para plan de pagos 
                    
                   
                    
                     SELECT
                               ps_id_proceso_wf,
                               ps_id_estado_wf,
                               ps_codigo_estado
                         into
                               v_id_proceso_wf,
                               v_id_estado_wf,
                               v_codigo_estado
                      FROM wf.f_registra_proceso_disparado_wf(
                               p_id_usuario,
                               (p_hstore->'_id_usuario_ai')::integer,
                               (p_hstore->'_nombre_usuario_ai')::varchar,
                               v_id_estado_actual, 
                               NULL, 
                               v_registros.id_depto,
                              ('Solicutd de devengado para la OP:'|| COALESCE(v_registros.numero,'s/n')||' cuota nro'||v_nro_cuota::varchar),
                               v_registros_tpp.codigo_proceso_llave_wf,
                               COALESCE(v_registros.numero,'s/n')||'-N# '||v_nro_cuota::varchar
                           );
                  
      
                    
      
          ELSEIF   v_registros.estado = 'en_pago' THEN
          
          
          
                 --registra estado de cotizacion
                 
                  SELECT
                           ps_id_proceso_wf,
                           ps_id_estado_wf,
                           ps_codigo_estado
                     into
                           v_id_proceso_wf,
                           v_id_estado_wf,
                           v_codigo_estado
                  FROM wf.f_registra_proceso_disparado_wf(
                           p_id_usuario,
                           (p_hstore->'_id_usuario_ai')::integer,
                           (p_hstore->'_nombre_usuario_ai')::varchar,
                           v_registros.id_estado_wf, 
                           NULL, 
                           v_registros.id_depto,
                           ('Solicutd de devengado para la OP:'|| v_registros.numero||' cuota nro'||v_nro_cuota::varchar),
                           v_registros_tpp.codigo_proceso_llave_wf,
                           v_registros.numero||'-N# '||v_nro_cuota::varchar
                         );
                          
          
          
          ELSE
        
          
           		 raise exception 'Estado no reconocido % ',  v_registros.estado;
          
          END IF;
        
        
      
          --actualiza la cuota vigente en la obligacion
           update tes.tobligacion_pago  p set 
                  nro_cuota_vigente =  v_nro_cuota
           where id_obligacion_pago = (p_hstore->'id_obligacion_pago')::integer; 
        
          
          --valida que la fecha tentativa
          
          IF v_fecha_tentativa > (p_hstore->'fecha_tentativa')::date THEN
          
            raise exception 'La fecha tentativa no puede ser inferior a la fecha tentativa de la ultima cuota registrada';
          
          END IF;
        
           -- TODO este bloque ya no se utuliza  hay que quitarlo
           -------------------------------------------
           -- valida tipo_pago anticipo o adelanto solo en la primera cuota
           ----------------------------------------------
            
            IF  (p_hstore->'tipo_pago')::varchar in ('anticipo','adelanto') and  v_nro_cuota!=1 THEN
            
              raise exception 'Los anticipos y andelantos tienen que ser la primera cuota';
            
            ELSIF  (p_hstore->'tipo_pago')::varchar in ('anticipo') and  v_nro_cuota=1 THEN
            
               -- validamos que la obligacion tenga definido el  porceentaje por descuento de anticipo
               IF v_registros.porc_anticipo = 0 THEN
                 raise exception 'para registrar una ciota de anticipo tiene que definir un porcentaje de retención en la boligación';
               END IF;
            
            END IF;
            
            --- #1				16/10/2018		EGS	 
           if p_hstore->'pago_borrador' is null then
           		v_pago_borrador = 'no';
           ELSE
           		v_pago_borrador =p_hstore->'pago_borrador';
           end if ;
          
        
            --Sentencia de la insercion
        	insert into tes.tplan_pago(
			estado_reg,
			nro_cuota,
		    nro_sol_pago,
            id_proceso_wf,
		    estado,
			tipo_pago,
			monto_ejecutar_total_mo,
			obs_descuentos_anticipo,
			id_plan_pago_fk,
			id_obligacion_pago,
			id_plantilla,
			descuento_anticipo,
			otros_descuentos,
			tipo,
			obs_monto_no_pagado,
			obs_otros_descuentos,
			monto,
		    nombre_pago,
            id_estado_wf,
		    id_cuenta_bancaria,
			forma_pago,
			monto_no_pagado,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod,
            liquido_pagable,
            fecha_tentativa,
            --tipo_cambio,
            monto_retgar_mo,
            descuento_ley,
            obs_descuentos_ley,
            porc_descuento_ley,
            nro_cheque,
            nro_cuenta_bancaria,
            id_cuenta_bancaria_mov,
            porc_monto_excento_var,
            monto_excento,
            id_usuario_ai,
            usuario_ai,
            descuento_inter_serv,
            obs_descuento_inter_serv,
            porc_monto_retgar,
            monto_anticipo,
            fecha_costo_ini,
            fecha_costo_fin,
            pago_borrador  -- #1				16/10/2018		EGS	
          	) values(
			'activo',
			v_nro_cuota,
			'---',--'nro_sol_pago',
			v_id_proceso_wf,
			v_codigo_estado,
			(p_hstore->'tipo_pago')::varchar,
			v_monto_ejecutar_total_mo,
            (p_hstore->'obs_descuentos_anticipo'),
			(p_hstore->'id_plan_pago_fk')::integer,
			(p_hstore->'id_obligacion_pago')::integer,
			(p_hstore->'id_plantilla')::integer,
			COALESCE((p_hstore->'descuento_anticipo')::numeric,0),
			(p_hstore->'otros_descuentos')::numeric,
			(p_hstore->'tipo')::varchar,
			(p_hstore->'obs_monto_no_pagado')::text,
			(p_hstore->'obs_otros_descuentos')::text,
			(p_hstore->'monto')::numeric,
			(p_hstore->'nombre_pago')::varchar,
		    v_id_estado_wf,
			v_id_cuenta_bancaria,
			v_forma_pago,
			(p_hstore->'monto_no_pagado')::numeric,
			now(),
			p_id_usuario,
			null,
			null,
            v_liquido_pagable,
            (p_hstore->'fecha_tentativa')::date,
            --(p_hstore->'tipo_cambio')::numeric,
            (p_hstore->'monto_retgar_mo')::numeric,
            (p_hstore->'descuento_ley')::numeric,
            (p_hstore->'obs_descuentos_ley'),
            (p_hstore->'porc_descuento_ley')::numeric,
			COALESCE(v_nro_cheque,0),
			v_nro_cuenta_bancaria,
            v_id_cuenta_bancaria_mov,
            v_porc_monto_excento_var,
            COALESCE(v_monto_excento,0)	,
            (p_hstore->'_id_usuario_ai')::integer,
            (p_hstore->'_nombre_usuario_ai')::varchar,
             COALESCE((p_hstore->'descuento_inter_serv')::numeric,0),
            (p_hstore->'obs_descuento_inter_serv'),
            v_porc_monto_retgar,
            v_monto_anticipo,
            (p_hstore->'fecha_costo_ini')::date, 
            (p_hstore->'fecha_costo_fin')::date,
            v_pago_borrador::varchar  -- #1				16/10/2018		EGS
           )RETURNING id_plan_pago into v_id_plan_pago;
            
            
            -- chequea fechas de costos inicio y fin
            
            --RAC 19/06/2015, se comenta la linea por que no permite la cracion automatica del plan de pagos
            -- v_resp_doc =  tes.f_validar_periodo_costo(v_id_plan_pago);
           
           
            -- inserta documentos en estado borrador si estan configurados
            v_resp_doc =  wf.f_inserta_documento_wf(p_id_usuario, v_id_proceso_wf, v_id_estado_wf);
            
            -- verificar documentos
            v_resp_doc = wf.f_verifica_documento(p_id_usuario, v_id_estado_wf);
            
            --------------------------------------------------
            -- Inserta prorrateo automatico
            ------------------------------------------------
           IF not ( SELECT * FROM tes.f_prorrateo_plan_pago( v_id_plan_pago,
               										 (p_hstore->'id_obligacion_pago')::integer, 
                                                     v_registros.pago_variable, 
                                                     v_monto_ejecutar_total_mo,
                                                     p_id_usuario)) THEN
                                                     
                  
              raise exception 'Error al prorratear';
                     
			END IF;
            
            
            --RAC 22/08/2017, si no tenemos cuenta bancaria  busca segun configuracion predetermianda
            -- para los centors de costos afectados
            IF v_id_cuenta_bancaria is NULL THEN
               IF  not tes.f_calcular_cuenta_bancaria_pp(v_id_plan_pago) THEN
                  raise exception 'error al determinar cuentas bancarias predeterminadas';
               END IF;
            END IF;
            
            --si el salto esta habilitado cambiamos la cuota al siguiente estado 
            IF p_salta  and v_registros.pago_variable = 'no' THEN
                  IF not tes.f_cambio_estado_plan_pago(p_id_usuario, v_id_plan_pago) THEN
                    raise exception 'error al cambiar de estado';
                  END IF;
            END IF;
            
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plan Pago almacenado(a) con exito (id_plan_pago'||v_id_plan_pago::varchar||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_plan_pago',v_id_plan_pago::varchar);
    
            --Devuelve la respuesta
          return v_resp;




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