--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_plan_pago_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.f_plan_pago_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tplan_pago'
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
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_plan_pago	integer;
    
    v_otros_descuentos_mb numeric;
    v_monto_no_pagado_mb numeric;
    v_descuento_anticipo_mb numeric;
    v_monto_total numeric;
    
    v_nro_cuota numeric;
    
    v_registros record;
     va_id_tipo_estado_pro integer[];
    va_codigo_estado_pro varchar[];
    va_disparador_pro varchar[];
    va_regla_pro varchar[];
    va_prioridad_pro integer[];
    
    v_id_estado_actual integer;
    
    
    v_id_proceso_wf integer;
    v_id_estado_wf integer;
    v_codigo_estado varchar;
    
    v_monto_mb numeric;
    v_liquido_pagable numeric;
    
    v_liquido_pagable_mb numeric;
    
    v_monto_ejecutar_total_mo numeric;
    v_monto_ejecutar_total_mb numeric;
    
    v_tipo varchar;
    v_id_tipo_estado integer;
    v_fecha_tentativa date;
    v_monto numeric;
    v_cont integer;  
    v_id_prorrateo integer;
    
    v_tipo_sol varchar;
    
    va_id_tipo_estado integer[];
    va_codigo_estado varchar[];
    va_disparador    varchar[];
    va_regla         varchar[]; 
    va_prioridad     integer[];
    
    v_monto_ejecutar_mo numeric;
    
    v_count integer;
  
    
    
			    
BEGIN

    v_nombre_funcion = 'tes.f_plan_pago_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_PLAPA_INS'
 	#DESCRIPCION:	Insercion de cuotas de devengado en el plan de pago
 	#AUTOR:		RAC KPLIAN	
 	#FECHA:		10-04-2013 15:43:23
	***********************************/

	if(p_transaccion='TES_PLAPA_INS')then
					
        begin
        
           --validamos que el monto a pagar sea mayor que cero
           
           IF  v_parametros.monto = 0 THEN
           
              raise exception 'El monto a pagar no puede ser 0';
           
           END IF;
           
           
           --obtiene datos de la obligacion
           
          select
            op.porc_anticipo,
            op.porc_retgar,
            op.num_tramite,
            op.id_proceso_wf,
            op.id_estado_wf,
            op.estado,
            op.id_depto,
            op.pago_variable
            
          into v_registros  
           from tes.tobligacion_pago op
           where op.id_obligacion_pago = v_parametros.id_obligacion_pago;
           
           
           select   
             max(pp.nro_cuota),
             max(pp.fecha_tentativa)
           into
             v_nro_cuota,
             v_fecha_tentativa
           from tes.tplan_pago pp 
           where 
               pp.id_obligacion_pago = v_parametros.id_obligacion_pago 
           and pp.estado_reg='activo';
           
           
           
            --si es un proceso variable, verifica que el registro no sobrepase el total a pagar
           
           IF v_registros.pago_variable='no' THEN
              v_monto_total= tes.f_determinar_total_faltante(v_parametros.id_obligacion_pago, 'registrado');
           
              IF v_monto_total <  v_parametros.monto  THEN
              
                  raise exception 'No puede exceder el total a pagar en obligaciones no variables';
              
              END IF;
           
           END IF;
           
         
          IF  v_parametros.monto < 0 or v_parametros.monto_no_pagado < 0 or v_parametros.otros_descuentos  < 0 THEN
          
             raise exception 'No se admiten cifras negativas'; 
          END IF;
        
           
          -- calcula el liquido pagable y el monsto a ejecutar presupeustaria mente
           
           v_liquido_pagable = COALESCE(v_parametros.monto,0) - COALESCE(v_parametros.monto_no_pagado,0) - COALESCE(v_parametros.otros_descuentos,0); -- - COALESCE(v_parametros.descuento_anticipo,0);
           v_monto_ejecutar_total_mo  = COALESCE(v_parametros.monto,0) -  COALESCE(v_parametros.monto_no_pagado,0);
          
          
          
          IF   v_liquido_pagable  < 0  or v_monto_ejecutar_total_mo < 0  THEN
              raise exception ' Ni  el monto a ejecutar   ni el liquido pagable  puede ser menor a cero';
          END IF;  
           
            
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
                                                                    v_registros.id_depto);
                    
                    --actualiza el proceso
                    
                    -- actuliaza el stado en la solictud
                     update tes.tobligacion_pago  p set 
                       id_estado_wf =  v_id_estado_actual,
                       estado = va_codigo_estado_pro[1],
                       id_usuario_mod=p_id_usuario,
                       fecha_mod=now()
                     where id_obligacion_pago = v_parametros.id_obligacion_pago; 
                     
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
                               v_id_estado_actual, 
                               NULL, 
                               v_registros.id_depto);
                  
      
                    
      
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
                           v_registros.id_estado_wf, 
                           NULL, 
                           v_registros.id_depto);
          
          
          ELSE
        
          
           		 raise exception 'Estado no reconocido % ',  v_registros.estado;
          
          END IF;
        
        
        
         
           
           -- define numero de cuota
          
           v_nro_cuota = floor(COALESCE(v_nro_cuota,0))+1;
           
           --actualiza la cuota vigente en la obligacion
           update tes.tobligacion_pago  p set 
                  nro_cuota_vigente =  v_nro_cuota
           where id_obligacion_pago = v_parametros.id_obligacion_pago; 
        
          
          --valida que la fecha tentativa
          
          IF v_fecha_tentativa > v_parametros.fecha_tentativa THEN
          
            raise exception 'La fecha tentativa no puede ser inferior a la fecha tentativa de la ultima cuota registrada';
          
          END IF;
        
           
           -------------------------------------------
           -- valida tipo_pago anticipo o adelanto solo en la primera cuota
           ----------------------------------------------
            
            IF  v_parametros.tipo_pago in ('anticipo','adelanto') and  v_nro_cuota!=1 THEN
            
              raise exception 'Los anticipos y andelantos tienen que ser la primera cuota';
            
            ELSIF  v_parametros.tipo_pago in ('anticipo') and  v_nro_cuota=1 THEN
            
            --validamos que la obligacion tenga definido el  porceentaje por descuento de anticipo
               IF v_registros.porc_anticipo = 0 THEN
                 raise exception 'para registrar una ciota de anticipo tiene que definir un porcentaje de retención en la boligación';
               END IF;
            
            END IF;
            
            
            
                      
            --Sentencia de la insercion
        	insert into tes.tplan_pago(
			estado_reg,
			nro_cuota,
		    nro_sol_pago,
            id_proceso_wf,
		    estado,
			tipo_pago,
			monto_ejecutar_total_mo,
			--obs_descuentos_anticipo,
			id_plan_pago_fk,
			id_obligacion_pago,
			id_plantilla,
			--descuento_anticipo,
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
            fecha_tentativa
          	) values(
			'activo',
			v_nro_cuota,
			'---',--'v_parametros.nro_sol_pago',
			v_id_proceso_wf,
			v_codigo_estado,
			v_parametros.tipo_pago,
			v_monto_ejecutar_total_mo,
			--v_parametros.obs_descuentos_anticipo,
			v_parametros.id_plan_pago_fk,
			v_parametros.id_obligacion_pago,
			v_parametros.id_plantilla,
			--v_parametros.descuento_anticipo,
			v_parametros.otros_descuentos,
			v_parametros.tipo,
			v_parametros.obs_monto_no_pagado,
			v_parametros.obs_otros_descuentos,
			v_parametros.monto,
			v_parametros.nombre_pago,
		    v_id_estado_wf,
			v_parametros.id_cuenta_bancaria,
			v_parametros.forma_pago,
			v_parametros.monto_no_pagado,
			now(),
			p_id_usuario,
			null,
			null,
            v_liquido_pagable,
            v_parametros.fecha_tentativa
							
			)RETURNING id_plan_pago into v_id_plan_pago;
            
            
            --------------------------------------------------
            -- Inserta prorrateo automatico
            ------------------------------------------------
           IF not ( SELECT * FROM tes.f_prorrateo_plan_pago( v_id_plan_pago,
               										 v_parametros.id_obligacion_pago, 
                                                     v_registros.pago_variable, 
                                                     v_monto_ejecutar_total_mo,
                                                     p_id_usuario)) THEN
                                                     
                  
              raise exception 'Error al prorratear';
                     
			END IF;
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plan Pago almacenado(a) con exito (id_plan_pago'||v_id_plan_pago||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_plan_pago',v_id_plan_pago::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

   	/*********************************    
 	#TRANSACCION:  'TES_PLAPAPA_INS'
 	#DESCRIPCION:	Insercion de cuotas de pagos en el plan de pago
 	#AUTOR:		RAC KPLIAN	
 	#FECHA:	7062013   15:43:23
	***********************************/

	elsif(p_transaccion='TES_PLAPAPA_INS')then
					
        begin
        
           --validamos que el monto a pagar sea mayor que cero
           
           IF  v_parametros.monto = 0 THEN
           
              raise exception 'El monto a pagar no puede ser 0';
           
           END IF;
           
           
           IF  v_parametros.id_plan_pago_fk is NULL   THEN
             raise exception 'El nuevo registro debe hacer referencia a una cuota devengada debe hacer referencia ';
           
           END IF;
           
           --obtiene datos de la obligacion
           
          select
            op.porc_anticipo,
            op.porc_retgar,
            op.num_tramite,
            pp.id_proceso_wf,
            pp.id_estado_wf,
            pp.estado,
            pp.nro_cuota,
            pp.fecha_tentativa,
            op.id_depto,
            op.pago_variable
            
          into v_registros  
           from tes.tplan_pago pp
           inner join tes.tobligacion_pago op on op.id_obligacion_pago = pp.id_obligacion_pago
           where pp.id_plan_pago  = v_parametros.id_plan_pago_fk;
           
           
           -------------------------
           --CAlcular el nro de cuota
           --------------------------
           
           
           
          select 
            count(id_plan_pago)
          INTO
            v_count 
          from tes.tplan_pago pp 
          where  pp.id_plan_pago_fk =  v_parametros.id_plan_pago_fk 
                 and pp.estado_reg = 'activo';  
           
           v_nro_cuota =   ((floor(COALESCE(v_registros.nro_cuota,0))::integer)::varchar ||'.'||TRIM(to_char((COALESCE(v_count,0)+1 ),'00'))::varchar)::numeric  ;
           
           
          --valida que la fecha tentativa
          
          IF v_registros.fecha_tentativa > v_parametros.fecha_tentativa THEN
          
            raise exception 'La fecha tentativa no puede ser inferior a la fecha tentativa de la ultima cuota registrada';
          
          END IF;
           
            -- verifica que el registro no sobrepase el total a devengado
           
        
          v_monto_total= tes.f_determinar_total_faltante(v_parametros.id_obligacion_pago, 'registrado_pagado',v_parametros.id_plan_pago_fk );
           
          IF v_monto_total <  v_parametros.monto  THEN
              
              raise exception 'El Pago no puede exceder el total devengado, solo falta por devengar %',v_monto_total;
              
          END IF;
          
           
         
          IF  v_parametros.monto < 0 or v_parametros.monto_no_pagado < 0 or v_parametros.otros_descuentos  < 0 THEN
          
             raise exception 'No se admiten cifras negativas'; 
          END IF;
        
        
          IF v_parametros.monto_no_pagado !=0  THEN
          
               raise exception 'El mmonto no pagado solo puede definirce en cuotas de devengado';
          
          END IF;
        
           
          -- calcula el liquido pagable y el monto  a ejecutar presupeustaria mente
          
          --TO DO, agregar monto por retencion de garantia, agregar el monto por retencion de anticipo
           
           v_liquido_pagable = COALESCE(v_parametros.monto,0)  - COALESCE(v_parametros.otros_descuentos,0)   ; -- - COALESCE(v_parametros.descuento_anticipo,0);
           v_monto_ejecutar_total_mo  = COALESCE(v_parametros.monto,0);
          
          
          
          IF   v_liquido_pagable  < 0  or v_monto_ejecutar_total_mo < 0  THEN
              raise exception ' Ni  el monto a ejecutar   ni el liquido pagable  puede ser menor a cero';
          END IF;  
           
          -------------------------------------
          --  Manejo de estados con el WF
          -------------------------------------
            
         
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
                     v_registros.id_estado_wf, 
                     NULL, 
                     v_registros.id_depto);
          
        
            
            
            
                      
            --Sentencia de la insercion
        	insert into tes.tplan_pago(
			estado_reg,
			nro_cuota,
		    nro_sol_pago,
            id_proceso_wf,
		    estado,
			tipo_pago,
			monto_ejecutar_total_mo,
			--obs_descuentos_anticipo,
			id_plan_pago_fk,
			id_obligacion_pago,
			id_plantilla,
			--descuento_anticipo,
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
            fecha_tentativa
          	) values(
			'activo',
			v_nro_cuota,
			'---',--'v_parametros.nro_sol_pago',
			v_id_proceso_wf,
			v_codigo_estado,
			v_parametros.tipo_pago,
			v_monto_ejecutar_total_mo,
			--v_parametros.obs_descuentos_anticipo,
			v_parametros.id_plan_pago_fk,
			v_parametros.id_obligacion_pago,
			v_parametros.id_plantilla,
			--v_parametros.descuento_anticipo,
			v_parametros.otros_descuentos,
			'pagado',
			v_parametros.obs_monto_no_pagado,
			v_parametros.obs_otros_descuentos,
			v_parametros.monto,
			v_parametros.nombre_pago,
		    v_id_estado_wf,
			v_parametros.id_cuenta_bancaria,
			v_parametros.forma_pago,
			v_parametros.monto_no_pagado,
			now(),
			p_id_usuario,
			null,
			null,
            v_liquido_pagable,
            v_parametros.fecha_tentativa
							
			)RETURNING id_plan_pago into v_id_plan_pago;
            
            -- actualiza el monto pagado en el plan_pago padre
            
              update tes.tplan_pago  pp set 
                 total_pagado = COALESCE(total_pagado,0) +v_monto_ejecutar_total_mo,
                 fecha_mod=now()
               where pp.id_plan_pago  = v_parametros.id_plan_pago_fk;
          
            
            
            
            --------------------------------------------------
            -- Inserta prorrateo automatico del pago
            ------------------------------------------------
           IF not ( SELECT * FROM tes.f_prorrateo_plan_pago( v_id_plan_pago,
               										 v_parametros.id_obligacion_pago, 
                                                     v_registros.pago_variable, 
                                                     v_monto_ejecutar_total_mo,
                                                     p_id_usuario,
                                                     v_parametros.id_plan_pago_fk)) THEN
                                                     
                  
              raise exception 'Error al prorratear';
                     
			END IF;
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plan Pago almacenado(a) con exito (id_plan_pago'||v_id_plan_pago||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_plan_pago',v_id_plan_pago::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_PLAPA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		10-04-2013 15:43:23
	***********************************/

	elsif(p_transaccion='TES_PLAPA_MOD')then

		begin
        
        
            --validamos que el monto a pagar sea mayor que cero
           
           IF  v_parametros.monto = 0 THEN
           
              raise exception 'El monto a pagar no puede ser 0';
           
           END IF;
           
           
           --obtiene datos de la obligacion
           
          select
            op.porc_anticipo,
            op.porc_retgar,
            op.num_tramite,
            op.id_proceso_wf,
            op.id_estado_wf,
            op.estado,
            op.id_depto,
            op.pago_variable
            
          into v_registros  
           from tes.tobligacion_pago op
           where op.id_obligacion_pago = v_parametros.id_obligacion_pago;
           
           
           select   
            pp.monto,
            pp.estado
           into
             v_monto,
             v_codigo_estado
           from tes.tplan_pago pp 
           where pp.estado_reg='activo'
           and  pp.id_plan_pago= v_parametros.id_plan_pago ;
           
           
           IF v_codigo_estado != 'borrador' THEN
           
             raise exception 'Solo puede modificar pagos en estado borrador';  
           
           END IF;
           
           
           
            --si es un proceso variable, verifica que el registro no sobrepase el total a pagar
           
           IF v_registros.pago_variable='no' THEN
              v_monto_total= tes.f_determinar_total_faltante(v_parametros.id_obligacion_pago, 'registrado');
           
              IF (v_monto_total + v_monto)  <  v_parametros.monto  THEN
              
                  raise exception 'No puede exceder el total a pagar en obligaciones no variables';
              
              END IF;
           
           END IF;
        
        
            -- calcula el liquido pagable y el monto a ejecutar presupeustaria mente
           
           IF  v_parametros.monto <0 or v_parametros.monto_no_pagado <0 or v_parametros.otros_descuentos  <0 THEN
          
               raise exception 'No se admiten cifras negativas'; 
           END IF;
           
           v_liquido_pagable = COALESCE(v_parametros.monto,0) - COALESCE(v_parametros.monto_no_pagado,0) - COALESCE(v_parametros.otros_descuentos,0);-- - COALESCE(v_parametros.descuento_anticipo,0);
           v_monto_ejecutar_total_mo  = COALESCE(v_parametros.monto,0) -  COALESCE(v_parametros.monto_no_pagado,0);
           
           IF   v_liquido_pagable  < 0  or v_monto_ejecutar_total_mo < 0  THEN
                raise exception ' Ni el  monto a ejecutar   ni el liquido pagable  puede ser menor a cero';
           END IF;
           
           
        
        
			--Sentencia de la modificacion
			update tes.tplan_pago set
			monto_ejecutar_total_mo = v_monto_ejecutar_total_mo,
			--obs_descuentos_anticipo = v_parametros.obs_descuentos_anticipo,
			id_plantilla = v_parametros.id_plantilla,
			--descuento_anticipo = COALESCE(v_parametros.descuento_anticipo,0),
			otros_descuentos = COALESCE( v_parametros.otros_descuentos,0),
			obs_monto_no_pagado = v_parametros.obs_monto_no_pagado,
			obs_otros_descuentos = v_parametros.obs_otros_descuentos,
			monto = v_parametros.monto,
			nombre_pago = v_parametros.nombre_pago,
			id_cuenta_bancaria = v_parametros.id_cuenta_bancaria,
			forma_pago = v_parametros.forma_pago,
			monto_no_pagado = v_parametros.monto_no_pagado,
            liquido_pagable=v_liquido_pagable,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario
			where id_plan_pago=v_parametros.id_plan_pago;
            
            --elimina el prorrateo si es automatico
            
            delete from tes.tprorrateo pro where pro.id_plan_pago = v_parametros.id_plan_pago;
            
            
             --------------------------------------------------
            -- Inserta prorrateo automatico
            ------------------------------------------------
           IF not ( SELECT * FROM tes.f_prorrateo_plan_pago( v_parametros.id_plan_pago,
               										 v_parametros.id_obligacion_pago, 
                                                     v_registros.pago_variable, 
                                                     v_monto_ejecutar_total_mo,
                                                     p_id_usuario)) THEN
                                                     
                  
              raise exception 'Error al prorratear';
                                              
           END IF;
            
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plan Pago modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_plan_pago',v_parametros.id_plan_pago::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TES_PLAPA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		10-04-2013 15:43:23
	***********************************/

	elsif(p_transaccion='TES_PLAPA_ELI')then

		begin
			
                
          --obtiene datos de plan de pago
          select
            pp.estado,
            pp.nro_cuota,
            pp.tipo_pago ,
            pp.tipo,
            pp.id_proceso_wf,
            pp.id_obligacion_pago,
            op.id_depto,
            pp.id_estado_wf,
            pp.id_plan_pago_fk,
            pp.monto_ejecutar_total_mo
          into v_registros  
           from tes.tplan_pago pp
           inner join tes.tobligacion_pago op on op.id_obligacion_pago = pp.id_obligacion_pago
           where pp.id_plan_pago = v_parametros.id_plan_pago;
           
          
          
           
           IF  v_registros.estado != 'borrador' THEN
           
             raise exception 'No puede elimiar cuotas  que no esten en estado borrador';
           
           END IF;
           
           
           --si es una cuota de devengao_pago o devengado validamos que elimine
           --primero la ultima cuota
           
          
           IF  v_registros.tipo in  ('devengado_pagado','devengado')   THEN
               select 
                max(pp.nro_cuota)
               into
                v_nro_cuota
               from tes.tplan_pago pp 
               where 
                  pp.id_obligacion_pago = v_registros.id_obligacion_pago 
                   and   pp.estado_reg = 'activo';
               
               v_nro_cuota = floor(COALESCE(v_nro_cuota,0));
               
               IF v_nro_cuota != v_registros.nro_cuota THEN
               
                 raise exception 'Elimine primero la ultima cuota';
               
               END IF;
                
             
           
            
               
               
               --recuperamos el id_tipo_proceso en el WF para el estado anulado
               --ya que este es un estado especial que no tiene padres definidos
               
               
               select 
               	te.id_tipo_estado
               into
               	v_id_tipo_estado
               from wf.tproceso_wf pw 
               inner join wf.ttipo_proceso tp on pw.id_tipo_proceso = tp.id_tipo_proceso
               inner join wf.ttipo_estado te on te.id_tipo_proceso = tp.id_tipo_proceso and te.codigo = 'anulado'               
               where pw.id_proceso_wf = v_registros.id_proceso_wf;
               
              
              
               -- pasamos la cotizacion al siguiente estado
           
               v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado, 
                                                           NULL, 
                                                           v_registros.id_estado_wf, 
                                                           v_registros.id_proceso_wf,
                                                           p_id_usuario,
                                                           v_registros.id_depto,
                                                           'Se elimina la cuota de devengado');
            
            
               -- actualiza estado en la cotizacion
              
               update tes.tplan_pago  pp set 
                 id_estado_wf =  v_id_estado_actual,
                 estado = 'anulado',
                 id_usuario_mod=p_id_usuario,
                 fecha_mod=now(),
                 estado_reg='inactivo'
               where pp.id_plan_pago  = v_parametros.id_plan_pago;
          
              --actulizamos el nro_cuota actual actual en obligacion_pago
          
          
              update tes.tobligacion_pago op set
                 nro_cuota_vigente = v_nro_cuota - 1
               where   op.id_obligacion_pago = v_registros.id_obligacion_pago;
               
               
             --elimina los prorrateos
              update  tes.tprorrateo pro  set 
               estado_reg='inactivo'
              where pro.id_plan_pago =  v_parametros.id_plan_pago; 
               
          
           
            ELSIF  v_registros.tipo in ('pagado')   THEN
             -- eliminacion de cuotas de pago
             
                     
                    select 
                      max(pp.nro_cuota)
                    into
                      v_nro_cuota
                    from tes.tplan_pago pp 
                    where 
                      pp.id_plan_pago_fk = v_registros.id_plan_pago_fk 
                      and   pp.estado_reg = 'activo';
                   
                              
                   
                   IF v_nro_cuota != v_registros.nro_cuota THEN
                   
                     raise exception 'Elimine primero la ultima cuota';
                   
                   END IF;
                   
                    select 
                    te.id_tipo_estado
                   into
                    v_id_tipo_estado
                   from wf.tproceso_wf pw 
                   inner join wf.ttipo_proceso tp on pw.id_tipo_proceso = tp.id_tipo_proceso
                   inner join wf.ttipo_estado te on te.id_tipo_proceso = tp.id_tipo_proceso and te.codigo = 'anulado'               
                   where pw.id_proceso_wf = v_registros.id_proceso_wf;
                   
              
              
               -- pasamos la cotizacion al siguiente estado
           
               v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado, 
                                                           NULL, 
                                                           v_registros.id_estado_wf, 
                                                           v_registros.id_proceso_wf,
                                                           p_id_usuario,
                                                           v_registros.id_depto,
                                                           'Elimina la cuota de pago');
            
            
                 -- actualiza estado en la cotizacion
              
                 update tes.tplan_pago  pp set 
                   id_estado_wf =  v_id_estado_actual,
                   estado = 'anulado',
                   id_usuario_mod=p_id_usuario,
                   fecha_mod=now(),
                   estado_reg='inactivo'
                 where pp.id_plan_pago  = v_parametros.id_plan_pago;
                     
                 
                  --elimina los prorrateos
                  update  tes.tprorrateo pro  set 
                   estado_reg='inactivo'
                  where pro.id_plan_pago =  v_parametros.id_plan_pago; 
                  
                  
                    update tes.tplan_pago  pp set 
                     total_pagado = total_pagado - v_registros.monto_ejecutar_total_mo,
                     fecha_mod=now()
                   where pp.id_plan_pago  = v_registros.id_plan_pago_fk;
          
                 
             
             
            
            ELSE
            
                raise exception 'Tipo no reconocido';
            
            END IF;
           
            
            
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plan Pago eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_plan_pago',v_parametros.id_plan_pago::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
        
	/*********************************    
 	#TRANSACCION:  'TES_SOLDEVPAG_IME'
 	#DESCRIPCION:	Solicitud de devengado o pago
 	#AUTOR:		admin	
 	#FECHA:		10-04-2013 15:43:23
	***********************************/

	elsif(p_transaccion='TES_SOLDEVPAG_IME')then

		begin
        
           
        
        
           --  obtinen datos del plan de pagos
           
           SELECT
           pp.id_plan_pago,
           pp.id_plan_pago_fk,
           pp.id_plantilla,
           pp.id_estado_wf,
           pp.estado,
           pp.id_proceso_wf,
           op.id_depto,
           pp.tipo_pago,
           pp.monto_ejecutar_total_mo,
           pp.total_prorrateado,
           pp.nro_cuota,
           pp.id_obligacion_pago
           into
           v_registros
           FROM tes.tplan_pago pp
           inner join tes.tobligacion_pago op on op.id_obligacion_pago = pp.id_obligacion_pago
           where pp.id_plan_pago = v_parametros.id_plan_pago;
        
        
          IF  v_registros.estado != 'borrador' THEN
          
          
             raise exception 'Solo puede solicitarce el devengado o pago de registros en borrador';
          
          
          END IF;
          
          
          
          
          -- obtener el estado de la cuota anterior
          --validar que no se salte el orden de los devengados
                
                IF  EXISTS (SELECT 1 
                FROM tes.tplan_pago pp 
                WHERE pp.id_obligacion_pago = v_registros.id_obligacion_pago
                      and (pp.estado != 'devengado' and pp.estado != 'pagado' and pp.estado != 'anulado')
                      and pp.estado_reg = 'activo'
                      and  pp.nro_cuota < v_registros.nro_cuota ) THEN
                      
                      
                    raise exception 'Antes de Finalizar la cuotas anteriores tienes que estar finalizadas';
                 
                 
                 END IF;
          
          
          
          
          IF v_registros.id_plan_pago_fk is NULL THEN
           
           		v_tipo_sol = 'devengado';
                
                --TO DO, generar numero de devengado
                
                
           ELSE
               --VALIDAR QUE nose se salte el orden de los pagos
           
           		v_tipo_sol = 'pago';
                
                --TO DO,  generar numero de pago
           
           END IF;
          
          
          
          
          ------------------------------------
          -- validacion del prorrateo--    no estoy seguro si funciona la misma idea para el pago
          ------------------------------------
            select
              sum( pro.monto_ejecutar_mo)
           into
              v_monto_ejecutar_mo
            from tes.tprorrateo pro
            where pro.estado_reg = 'activo' and  
              pro.id_plan_pago  = v_parametros.id_plan_pago;
              
              
            raise notice 'deberian igualar  ,%,% y %', v_monto_ejecutar_mo ,v_registros.monto_ejecutar_total_mo ,v_registros.total_prorrateado;
            
            
            IF v_registros.monto_ejecutar_total_mo != v_registros.total_prorrateado THEN
                      
              raise exception 'El total prorrateado no iguala con el monto total a ejecutar';
            
            END IF;
            
            
             
          
          ---------------------------------------
          ----  Generacion del Comprobante  -----
          ---------------------------------------
        
            IF v_tipo_sol ='devengado' THEN
            
                -- TO DO llamda a la generaciond e comprobante de devengado 
                  
                 
           
            ELSIF v_tipo_sol ='pago' THEN
                 --TO DO,  llamada a la generacion de comprobante de pago
            
            
            
                      
            END IF;
            
            
            --  TO DO, actualiza el id_comprobante en el registro del plan de pago
            
            
            
            
                  
            --------------------------------------------------------
            ---cambio al siguiente estado de borrador a Pendiente----
            ---------------------------------------------------------
            
             
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
            
             raise exception 'El proceso de WF esta mal parametrizado, el estado borrador de la obligacion solo admite un estado ';
            
            END IF;
            
             IF va_codigo_estado[1] is  null THEN
            
             raise exception 'El proceso de WF esta mal parametrizado, no se encuentra el estado siguiente ';
            
            END IF;
            
            
          
            
            -- hay que recuperar el supervidor que seria el estado inmediato,...
             v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado[1], 
                                                           NULL, 
                                                           v_registros.id_estado_wf, 
                                                           v_registros.id_proceso_wf,
                                                           p_id_usuario,
                                                           v_registros.id_depto,
                                                           'La solicitud de '||v_tipo_sol ||'pasa a Contabilidad');
            
            
            
             -- actualiza estado en la solicitud
            
             update tes.tplan_pago  set 
               id_estado_wf =  v_id_estado_actual,
               estado = va_codigo_estado[1],
               id_usuario_mod=p_id_usuario,
               fecha_mod=now()
             where id_plan_pago  = v_parametros.id_plan_pago;
            
            
          
           --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Solitud de generacion de comprobante ('||v_tipo_sol||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_plan_pago',v_parametros.id_plan_pago::varchar);
              
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