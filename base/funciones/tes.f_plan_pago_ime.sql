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
    v_registros_tpp 	    record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_plan_pago	integer;
    
    v_otros_descuentos_mb numeric;
    v_monto_no_pagado_mb numeric;
    v_descuento_anticipo_mb numeric;
    v_monto_total numeric;
    v_resp_doc   boolean;
    
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
    
    v_monto_ejecutar_mo 	numeric;
    
    v_count 				integer;
    v_registros_pp 			record;
    
    v_verficacion 			varchar[];
    
    v_perdir_obs 			varchar;
    v_num_estados 			integer;
    v_num_funcionarios  	integer;
    v_num_deptos  			integer;
    
    v_id_funcionario_estado integer;
    v_id_depto_estado 		integer;
    
    v_num_obliacion_pago 	varchar;
    v_codigo_estado_siguiente  varchar;
    v_id_depto  			INTEGER;
    v_obs 					varchar;
    
    v_id_funcionario     	integer;
    v_id_usuario_reg        integer;
    v_id_estado_wf_ant 		integer;
    
    v_id_cuenta_bancaria 		integer;
    v_id_cuenta_bancaria_mov integer;
    
    
    v_forma_pago 			varchar;
    
    v_nro_cheque 			integer;
    
    v_nro_cuenta_bancaria  	varchar;
    
    v_centro 				varchar;
    
    v_sw_me_plantilla   	varchar;
    
    v_porc_monto_excento_var numeric;
    v_monto_excento 		 numeric;
    
    v_total_prorrateo        numeric;
    v_registros_proc        record;
    v_codigo_tipo_pro       varchar;
    
    
    v_acceso_directo  	varchar;
    v_clase   			varchar;
    v_parametros_ad   	varchar;
    v_tipo_noti  		varchar;
    v_titulo   			varchar;
    v_codigo_proceso_llave_wf  varchar;
    v_porc_monto_retgar        numeric;
    v_porc_ant   numeric;
    v_monto_ant_parcial_descontado  numeric;
    v_saldo_x_descontar numeric;
    v_saldo_x_pagar numeric;
    
    
			    
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
        
           
            v_resp = tes.f_inserta_plan_pago_dev(p_administrador, p_id_usuario,hstore(v_parametros));

            --Devuelve la respuesta
            return v_resp;

		end;

   	/*********************************    
 	#TRANSACCION:  'TES_PLAPAPA_INS'
 	#DESCRIPCION:	Insercion de cuotas de CUOTAS DE SEGUNDO NIVEL,  PAGO o APLICAION DE ANTICIPO , en el plan de pago
 	#AUTOR:		RAC KPLIAN	
 	#FECHA:	7062013   15:43:23
	***********************************/

	elsif(p_transaccion='TES_PLAPAPA_INS')then
					
        begin
        
        
             IF  pxp.f_existe_parametro(p_tabla,'id_cuenta_bancaria') THEN
             
             v_id_cuenta_bancaria =  v_parametros.id_cuenta_bancaria;
             
             END IF;
             
             IF  pxp.f_existe_parametro(p_tabla,'id_cuenta_bancaria_mov') THEN
             
             v_id_cuenta_bancaria_mov =  v_parametros.id_cuenta_bancaria_mov;
             
             END IF;
             
            IF  pxp.f_existe_parametro(p_tabla,'forma_pago') THEN
             
                 v_forma_pago =  v_parametros.forma_pago;
             
             END IF;
             
             
             IF  pxp.f_existe_parametro(p_tabla,'nro_cheque') THEN
             
                 v_nro_cheque =  v_parametros.nro_cheque;
             
             END IF;
             
             
             IF  pxp.f_existe_parametro(p_tabla,'nro_cuenta_bancaria') THEN
             
                 v_nro_cuenta_bancaria =  v_parametros.nro_cuenta_bancaria;
             
             END IF;
        
        
        
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
            op.pago_variable,
            pp.id_plantilla,
            pp.monto,
            pp.descuento_ley,
            pp.monto_retgar_mo,
            op.numero 
            
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
          
         -------------------------------------------------------------------
         --  VALIDACION DE MONTO FALTANTE, SEGUN TIPO DE CUOTA
         ------------------------------------------------------------
          
         IF v_parametros.tipo in('pagado') THEN 
          
                -- verifica que el registro no sobrepase el total a devengado
                v_monto_total= tes.f_determinar_total_faltante(v_parametros.id_obligacion_pago, 'registrado_pagado',v_parametros.id_plan_pago_fk );
                IF v_monto_total <  v_parametros.monto  THEN
                    raise exception 'El Pago no puede exceder el total devengado, solo falta por devengar %',v_monto_total;
                END IF;
                
                --valida que la retencion de anticipo no sobre pase el total anticipado
                v_monto_ant_parcial_descontado = tes.f_determinar_total_faltante(v_parametros.id_obligacion_pago, 'ant_parcial_descontado' );
                IF v_monto_ant_parcial_descontado <  v_parametros.descuento_anticipo  THEN
                    raise exception 'El decuento por anticipo no puede exceder el falta por descontar que es  %',v_monto_ant_parcial_descontado;
                END IF;
                
                --  si es  un pago no variable  (si es una cuota de devengao_pagado, devegando_pagado_1c, pagado)
                --  validar que no se haga el ultimo pago sin  terminar de descontar el anticipo,
                
                IF v_registros.pago_variable = 'no' THEN
                
                     -- saldo_x_pagar = determinar cuanto falta por pagar (sin considerar el devengado)
                    v_saldo_x_pagar = tes.f_determinar_total_faltante(v_parametros.id_obligacion_pago,'total_registrado_pagado');
                          
                    -- saldo_x_descontar = determinar cuanto falta por descontar del anticipo
                    v_saldo_x_descontar = tes.f_determinar_total_faltante(v_parametros.id_obligacion_pago,'ant_parcial_descontado');
                           
                    -- saldo_x_descontar - descuento_anticipo >  sando_x_pagar
                    IF (v_saldo_x_descontar -  COALESCE(v_parametros.descuento_anticipo,0))  > (v_saldo_x_pagar  - COALESCE(v_parametros.monto,0)) THEN
                        raise exception 'El saldo a pagar no es sufuciente para recuperar el anticipo (%)',v_saldo_x_descontar;
                    END IF; 
                
                END IF;
                
               
         ELSEIF v_parametros.tipo in ('ant_aplicado')  THEN
                          
                v_monto_total= tes.f_determinar_total_faltante(v_parametros.id_obligacion_pago, 'ant_aplicado_descontado', v_parametros.id_plan_pago_fk);
                IF (v_monto_total)  <  v_parametros.monto::numeric  THEN
                   raise exception 'No puede exceder el total anticipado: %',v_monto_total;
                END IF;
                  
         ELSE
            
            raise exception 'tipo no reconocido %',v_parametros.tipo;
          
         END IF;
         
         --validaciond e cifras negativas
           
         IF  v_parametros.monto < 0 or v_parametros.monto_no_pagado < 0 or v_parametros.otros_descuentos  < 0 or v_parametros.descuento_ley < 0  or v_parametros.descuento_anticipo < 0 THEN
            raise exception 'No se admiten cifras negativas'; 
         END IF;
        
        
         IF v_parametros.monto_no_pagado !=0  THEN
           raise exception 'El monto no pagado solo puede definirce en cuotas de devengado';
         END IF;
        
         -- calcula el liquido pagable y el monto  a ejecutar presupeustaria mente
          
         v_liquido_pagable = COALESCE(v_parametros.monto,0)  - COALESCE(v_parametros.otros_descuentos,0) - COALESCE( v_parametros.monto_retgar_mo,0)  - COALESCE(v_parametros.descuento_ley,0)- COALESCE(v_parametros.descuento_anticipo,0)- COALESCE(v_parametros.descuento_inter_serv,0);
         v_monto_ejecutar_total_mo  = COALESCE(v_parametros.monto,0);  -- TODO ver si es necesario el monto no pagado
                  
         IF   v_liquido_pagable  < 0  or v_monto_ejecutar_total_mo < 0  THEN
              raise exception ' Ni  el monto a ejecutar   ni el liquido pagable  puede ser menor a cero';
         END IF;  
          
          
          --obtiene el tipo de plan de pago para este registro
          select
           tpp.codigo_proceso_llave_wf
          into
           v_codigo_proceso_llave_wf
          from tes.ttipo_plan_pago tpp
          where tpp.codigo = v_parametros.tipo;
          
          IF v_codigo_proceso_llave_wf is NULL THEN
          
           raise exception 'No se encontro un tipo de plan de pago para este codigo %',COALESCE(v_codigo_proceso_llave_wf,'N/I');
          
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
                     v_parametros._id_usuario_ai,
                     v_parametros._nombre_usuario_ai,
                     v_registros.id_estado_wf, 
                     NULL, 
                     v_registros.id_depto,
                     ('Solicutd de Pago, OP:'|| v_registros.numero||' cuota nro'||v_nro_cuota::varchar),
                     v_codigo_proceso_llave_wf,
                     v_registros.numero||'-N# '||v_nro_cuota
                     );     
        
                     
            --Sentencia de la insercion
        	insert into tes.tplan_pago(
			estado_reg,
			nro_cuota,
		    nro_sol_pago,
            id_proceso_wf,
		    estado,
			--tipo_pago,
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
            id_usuario_ai,
            usuario_ai,
            porc_monto_retgar
          	) values(
			'activo',
			v_nro_cuota,
			'---',--'v_parametros.nro_sol_pago',
			v_id_proceso_wf,
			v_codigo_estado,
			--v_parametros.tipo_pago,
			v_monto_ejecutar_total_mo,
			v_parametros.obs_descuentos_anticipo,
			v_parametros.id_plan_pago_fk,
			v_parametros.id_obligacion_pago,
			v_parametros.id_plantilla,
			v_parametros.descuento_anticipo,
			v_parametros.otros_descuentos,
			v_parametros.tipo,
			v_parametros.obs_monto_no_pagado,
			v_parametros.obs_otros_descuentos,
			v_parametros.monto,
			v_parametros.nombre_pago,
		    v_id_estado_wf,
			v_id_cuenta_bancaria,
			v_forma_pago,
			v_parametros.monto_no_pagado,
			now(),
			p_id_usuario,
			null,
			null,
            v_liquido_pagable,
            v_parametros.fecha_tentativa,
            --v_parametros.tipo_cambio,
            v_parametros.monto_retgar_mo,
            v_parametros.descuento_ley,
            v_parametros.obs_descuentos_ley,
            v_parametros.porc_descuento_ley,
            COALESCE(v_nro_cheque,0),
            v_nro_cuenta_bancaria,
			v_id_cuenta_bancaria_mov,
            v_parametros._id_usuario_ai,
            v_parametros._nombre_usuario_ai,
            v_parametros.porc_monto_retgar				
		)RETURNING id_plan_pago into v_id_plan_pago;
            
            -- actualiza el monto pagado en el plan_pago padre
            
              update tes.tplan_pago  pp set 
                 total_pagado = COALESCE(total_pagado,0) +v_monto_ejecutar_total_mo,
                 fecha_mod=now()
               where pp.id_plan_pago  = v_parametros.id_plan_pago_fk;
          
            
            -- inserta documentos en estado borrador si estan configurados
            v_resp_doc =  wf.f_inserta_documento_wf(p_id_usuario, v_id_proceso_wf, v_id_estado_wf);
            -- verificar documentos
            v_resp_doc = wf.f_verifica_documento(p_id_usuario, v_id_estado_wf);
            
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
 	#TRANSACCION:  'TES_PPANTPAR_INS'
 	#DESCRIPCION:	Inserta cuotas del tipo anticipo parcial , o
                    anticipo total  o dev_garantia (todas no  tienen prorrateo por que no ejecutan presupuesto)
 	#AUTOR:		RAC KPLIAN	
 	#FECHA: 17/07/2014   15:43:23
	***********************************/

	elsif(p_transaccion='TES_PPANTPAR_INS')then
					
        begin
        
        
             IF  pxp.f_existe_parametro(p_tabla,'id_cuenta_bancaria') THEN
                v_id_cuenta_bancaria =  v_parametros.id_cuenta_bancaria;
             END IF;
             
             IF  pxp.f_existe_parametro(p_tabla,'id_cuenta_bancaria_mov') THEN
                v_id_cuenta_bancaria_mov =  v_parametros.id_cuenta_bancaria_mov;
             END IF;
             
             IF  pxp.f_existe_parametro(p_tabla,'forma_pago') THEN
                v_forma_pago =  v_parametros.forma_pago;
             END IF;
             
             IF  pxp.f_existe_parametro(p_tabla,'nro_cheque') THEN
               v_nro_cheque =  v_parametros.nro_cheque;
             END IF;
             
             IF  pxp.f_existe_parametro(p_tabla,'nro_cuenta_bancaria') THEN
                v_nro_cuenta_bancaria =  v_parametros.nro_cuenta_bancaria;
             END IF;
        
        
        
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
            op.pago_variable,
            op.numero
            
          into v_registros  
           from tes.tobligacion_pago op
           where op.id_obligacion_pago = v_parametros.id_obligacion_pago;
           
          
          
           --validaciones segun el tipo de anticipo
           
           IF v_parametros.tipo = 'anticipo' THEN
                --si es un proceso variable, verifica que el registro no sobrepase el total a pagar
                IF v_registros.pago_variable='no' THEN
                      v_monto_total= tes.f_determinar_total_faltante(v_parametros.id_obligacion_pago, 'registrado');
                   
                      IF v_monto_total <  v_parametros.monto THEN
                         raise exception 'No puede exceder el total a pagar en obligaciones no variables: %',v_monto_total;
                      END IF;
                     ---------------------------- 
                     --  si es  un pago no variable  (si es una cuota de devengao_pagado, devegando_pagado_1c, pagado)
                     --  validar que no se haga el ultimo pago sin  terminar de descontar el anticipo,
                     
                    IF v_registros.pago_variable = 'no' THEN
                  
                        -- saldo_x_pagar = determinar cuanto falta por pagar (sin considerar el devengado)
                        v_saldo_x_pagar = tes.f_determinar_total_faltante(v_parametros.id_obligacion_pago,'total_registrado_pagado');
                              
                        -- saldo_x_descontar = determinar cuanto falta por descontar del anticipo parcial
                        v_saldo_x_descontar = tes.f_determinar_total_faltante(v_parametros.id_obligacion_pago,'ant_parcial_descontado');
                               
                        --  SI saldo_x_descontar del anticipo paricla  >  saldo_x_pagar
                        IF (v_saldo_x_descontar)  > (v_saldo_x_pagar  - COALESCE(v_parametros.monto,0)) THEN
                                raise exception 'El saldo a pagar no es sufuciente para recuperar el anticipo (%)',v_saldo_x_descontar;
                        END IF;
                        
                  
                    END IF; 
                    
               END IF;
           
           ELSIF   v_parametros.tipo = 'ant_parcial'   THEN
           
               v_monto_total= tes.f_determinar_total_faltante(v_parametros.id_obligacion_pago, 'ant_parcial');
               v_porc_ant = pxp.f_get_variable_global('politica_porcentaje_anticipo')::numeric;
               
               IF v_monto_total <  v_parametros.monto  THEN
                  raise exception 'No puede exceder el total a pagar segun politica de anticipos % porc', v_porc_ant*100;
               END IF;
           
           ELSIF   v_parametros.tipo = 'dev_garantia'   THEN
           
               v_monto_total= tes.f_determinar_total_faltante(v_parametros.id_obligacion_pago, 'dev_garantia');
              
               
               IF v_monto_total <  v_parametros.monto  THEN
                  raise exception 'No puede exceder el total de garantia por devolver que es de: %', v_monto_total;
               END IF;
           
           
           END IF;
           
           
           -------------------------
           --CAlcular el nro de cuota
           --------------------------
           
           select   
             max(pp.nro_cuota)
           into
             v_nro_cuota
           from tes.tplan_pago pp 
           where 
               pp.id_obligacion_pago = v_parametros.id_obligacion_pago
           and pp.estado_reg='activo';
           
           
          -- define numero de cuota
          v_nro_cuota = floor(COALESCE(v_nro_cuota,0))+1; 
        
          -- verifica que el registro no sobrepase el total a devengado
           
        
          IF  v_parametros.monto < 0 or v_parametros.monto_no_pagado < 0 or v_parametros.otros_descuentos  < 0 or v_parametros.descuento_ley < 0 THEN
          
             raise exception 'No se admiten cifras negativas'; 
          END IF;
        
        
          IF v_parametros.monto_no_pagado !=0  THEN
          
               raise exception 'El monto no pagado solo puede definirce en cuotas de devengado';
          
          END IF;
           
          -- calcula el liquido pagable y el monto  a ejecutar presupeustaria mente
          
          v_liquido_pagable = COALESCE(v_parametros.monto,0) - v_parametros.descuento_ley; --en anticipo el monto es el liquido pagable
          v_monto_ejecutar_total_mo  = 0;  -- el monto a ejecutar es cero los anticipo parciales no ejecutan presupeusto
                  
          IF   v_liquido_pagable  < 0  or v_monto_ejecutar_total_mo < 0  THEN
              raise exception ' Ni  el monto a ejecutar   ni el liquido pagable  puede ser menor a cero';
          END IF;  
          
          
          --obtiene el tipo de plan de pago para este registro
          select
           tpp.codigo_proceso_llave_wf
          into
           v_codigo_proceso_llave_wf
          from tes.ttipo_plan_pago tpp
          where tpp.codigo = v_parametros.tipo;
          
          
          IF v_codigo_proceso_llave_wf is NULL THEN
          
           raise exception 'No se encontro un tipo de plan de pago para este codigo %',COALESCE(v_codigo_proceso_llave_wf,'N/I');
          
          END IF;
         
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
                                                                    v_parametros._id_usuario_ai,
                                                                    v_parametros._nombre_usuario_ai,
                                                                    v_registros.id_depto);
                    
                    -- actuliaza el stado en la solictud
                     update tes.tobligacion_pago  p set 
                       id_estado_wf =  v_id_estado_actual,
                       estado = va_codigo_estado_pro[1],
                       id_usuario_mod=p_id_usuario,
                       fecha_mod=now(),
                       id_usuario_ai = v_parametros._id_usuario_ai,
                       usuario_ai = v_parametros._nombre_usuario_ai
                     where id_obligacion_pago = v_parametros.id_obligacion_pago;
                     
                     -------------------------------------
                     --dispara estado para plan de pagos 
                     --------------------------------------
                   
                    
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
                               v_parametros._id_usuario_ai,
                               v_parametros._nombre_usuario_ai,
                               v_id_estado_actual, 
                               NULL, 
                               v_registros.id_depto,
                              ('Solicutd de devengado para la OP:'|| COALESCE(v_registros.numero,'s/n')||' cuota nro'||v_nro_cuota::varchar),
                               v_codigo_proceso_llave_wf,
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
                           v_parametros._id_usuario_ai,
                           v_parametros._nombre_usuario_ai,
                           v_registros.id_estado_wf, 
                           NULL, 
                           v_registros.id_depto,
                           ('Solicutd de Anticipo para la OP:'|| v_registros.numero||' cuota nro'||v_nro_cuota::varchar),
                           v_codigo_proceso_llave_wf,
                           v_registros.numero||'-N# '||v_nro_cuota::varchar
                         );
          ELSE
        
          
           		 raise exception 'Estado no reconocido % ',  v_registros.estado;
          
          END IF;
          
          
          
       
                      
            --Sentencia de la insercion
        	insert into tes.tplan_pago(
			estado_reg,
			nro_cuota,
		    nro_sol_pago,
            id_proceso_wf,
		    estado,
			--tipo_pago,
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
            id_usuario_ai,
            usuario_ai,
            porc_monto_retgar
          	) values(
			'activo',
			v_nro_cuota,
			'---',--'v_parametros.nro_sol_pago',
			v_id_proceso_wf,
			v_codigo_estado,
			--v_parametros.tipo_pago,
			v_monto_ejecutar_total_mo,
			v_parametros.obs_descuentos_anticipo,
			v_parametros.id_plan_pago_fk,
			v_parametros.id_obligacion_pago,
			v_parametros.id_plantilla,
			v_parametros.descuento_anticipo,
			v_parametros.otros_descuentos,
			v_parametros.tipo,
			v_parametros.obs_monto_no_pagado,
			v_parametros.obs_otros_descuentos,
			v_parametros.monto,
			v_parametros.nombre_pago,
		    v_id_estado_wf,
			v_id_cuenta_bancaria,
			v_forma_pago,
			v_parametros.monto_no_pagado,
			now(),
			p_id_usuario,
			null,
			null,
            v_liquido_pagable,
            v_parametros.fecha_tentativa,
            --v_parametros.tipo_cambio,
            v_parametros.monto_retgar_mo,
            v_parametros.descuento_ley,
            v_parametros.obs_descuentos_ley,
             COALESCE(v_parametros.porc_descuento_ley,0),
            COALESCE(v_nro_cheque,0),
            v_nro_cuenta_bancaria,
			v_id_cuenta_bancaria_mov,
            v_parametros._id_usuario_ai,
            v_parametros._nombre_usuario_ai,
            v_parametros.porc_monto_retgar				
		  )RETURNING id_plan_pago into v_id_plan_pago;
          
          --actualiza la cuota vigente en la obligacion
           update tes.tobligacion_pago  p set 
                  nro_cuota_vigente =  v_nro_cuota
           where id_obligacion_pago =  v_parametros.id_obligacion_pago::integer; 
           
           
           -- inserta documentos en estado borrador si estan configurados
           v_resp_doc =  wf.f_inserta_documento_wf(p_id_usuario, v_id_proceso_wf, v_id_estado_wf);
           -- verificar documentos
           v_resp_doc = wf.f_verifica_documento(p_id_usuario, v_id_estado_wf);
            
            
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plan Pago almacenado(a) con exito (id_plan_pago'||v_id_plan_pago||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_plan_pago',v_id_plan_pago::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;
         
        

	/*********************************    
 	#TRANSACCION:  'TES_PLAPA_MOD'
 	#DESCRIPCION:	Modificacion de cuotas de devegando y pago
 	#AUTOR:		admin	
 	#FECHA:		10-04-2013 15:43:23
	***********************************/

	elsif(p_transaccion='TES_PLAPA_MOD')then

		begin
        
           --determinar exixtencia de parametros dinamicos para registro  
           -- (Interface de obligacions de adquisocines o interface de obligaciones tesoeria)
           -- la adquisiciones tiene menos parametros presentes
           
           -- raise exception '%, %, %,%,%', COALESCE(v_parametros.id_cuenta_bancaria,0), COALESCE(v_parametros.id_cuenta_bancaria_mov,0),  COALESCE(v_parametros.forma_pago,''),  COALESCE(v_parametros.nro_cheque,0),  COALESCE(v_parametros.nro_cuenta_bancaria,'');
        
           
             IF  pxp.f_existe_parametro(p_tabla,'id_cuenta_bancaria') THEN
               v_id_cuenta_bancaria =  v_parametros.id_cuenta_bancaria;
             END IF;
             
             IF  pxp.f_existe_parametro(p_tabla,'id_cuenta_bancaria_mov') THEN
               v_id_cuenta_bancaria_mov =  v_parametros.id_cuenta_bancaria_mov;
             END IF;
             
             IF  pxp.f_existe_parametro(p_tabla,'forma_pago') THEN
               v_forma_pago =  v_parametros.forma_pago;
             END IF;
             
             IF  pxp.f_existe_parametro(p_tabla,'nro_cheque') THEN
               v_nro_cheque =  v_parametros.nro_cheque;
             END IF;
             
             IF  pxp.f_existe_parametro(p_tabla,'nro_cuenta_bancaria') THEN
                v_nro_cuenta_bancaria =  v_parametros.nro_cuenta_bancaria;
             END IF;
             
             IF  pxp.f_existe_parametro(p_tabla,'porc_monto_excento_var') THEN
                v_porc_monto_excento_var =  v_parametros.porc_monto_excento_var;
             END IF;
             
             IF  pxp.f_existe_parametro(p_tabla,'monto_excento') THEN
                v_monto_excento =  v_parametros.monto_excento;
             END IF;
        
            --validamos que el monto a pagar sea mayor que cero
           IF  v_parametros.monto = 0 THEN
              raise exception 'El monto a pagar no puede ser 0';
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
            op.pago_variable
          into v_registros  
           from tes.tobligacion_pago op
           where op.id_obligacion_pago = v_parametros.id_obligacion_pago;
           
           
          select   
            pp.monto,
            pp.estado,
            pp.tipo,
            pp.id_plan_pago_fk,
            pp.porc_monto_retgar,
            pp.descuento_anticipo
           into
             v_registros_pp
           from tes.tplan_pago pp 
           where pp.estado_reg='activo'
           and  pp.id_plan_pago= v_parametros.id_plan_pago ;
           
           
           IF v_codigo_estado = 'borrador' or v_codigo_estado = 'pagado'  or v_codigo_estado = 'pendiente' or v_codigo_estado = 'devengado' or v_codigo_estado = 'anulado' THEN
             raise exception 'Solo puede modificar pagos en estado borrador';  
           END IF;
           
          
           --valida que los valores no sean negativos
           IF  v_parametros.monto <0 or v_parametros.monto_no_pagado <0 or v_parametros.otros_descuentos  <0 THEN
               raise exception 'No se admiten cifras negativas'; 
           END IF;
           
           
           -------------------------------------
           -- Si es una cuota de devengado
           -- Segun el tipo de cuota
           ------------------------------------
           
           -----------------------------------------------------------------------------------------------
           -- EDICION DE CUOTAS QUE TIENEN DEVENGADO   ('devengado_pagado','devengado','devengado_pagado_1c')
           -------------------------------------------------------------------------------------------------- 
           
           IF v_registros_pp.tipo in ('devengado_pagado','devengado','devengado_pagado_1c') THEN
            
                     -- si no es un proceso variable, verifica que el registro no sobrepase el total a pagar
                     IF v_registros.pago_variable='no' THEN
                        v_monto_total = tes.f_determinar_total_faltante(v_parametros.id_obligacion_pago, 'registrado');
                        IF (v_monto_total + v_registros_pp.monto)  <  v_parametros.monto  THEN
                          raise exception 'No puede exceder el total a pagar en obligaciones no variables';
                        END IF;
                        
                        --   si es  un pago no variable  (si es una cuota de devengao_pagado, devegando_pagado_1c, pagado)
                        --  validar que no se haga el ultimo pago sin  terminar de descontar el anticipo,
                            
                        IF   v_registros_pp.tipo in('devengado_pagado','devengado_pagado_1c')  THEN
                            -- saldo_x_pagar = determinar cuanto falta por pagar (sin considerar el devengado)
                            v_saldo_x_pagar = tes.f_determinar_total_faltante(v_parametros.id_obligacion_pago,'total_registrado_pagado');
                                  
                            -- saldo_x_descontar = determinar cuanto falta por descontar del anticipo
                            v_saldo_x_descontar = v_monto_ant_parcial_descontado;
                                   
                             -- saldo_x_descontar - descuento_anticipo >  sando_x_pagar
                            IF (v_saldo_x_descontar + v_registros_pp.descuento_anticipo -  COALESCE(v_parametros.descuento_anticipo,0))  > (v_saldo_x_pagar + v_registros_pp.monto - COALESCE(v_parametros.monto,0)) THEN
                               raise exception 'El saldo a pagar no es sufuciente para recuperar el anticipo (%)',v_saldo_x_descontar;
                            END IF;
                      
                        END IF;
                     
                     END IF;
                     
                     -- si el descuento anticipo es mayor a cero verificar que nose sobrepase el total anticipado
                     v_monto_ant_parcial_descontado = tes.f_determinar_total_faltante(v_parametros.id_obligacion_pago, 'ant_parcial_descontado' );
                     IF v_monto_ant_parcial_descontado + v_registros_pp.descuento_anticipo <  v_parametros.descuento_anticipo  THEN
                     
                          raise exception 'El decuento por anticipo no puede exceder el faltante por descontar que es  %',v_monto_ant_parcial_descontado;
         
                     END IF;
                  
                     -- calcula el liquido pagable y el monto a ejecutar presupeustaria mente
                     v_liquido_pagable = COALESCE(v_parametros.monto,0) - COALESCE(v_parametros.monto_no_pagado,0) - COALESCE(v_parametros.otros_descuentos,0) - COALESCE( v_parametros.monto_retgar_mo,0) - COALESCE(v_parametros.descuento_ley,0) - COALESCE(v_parametros.descuento_anticipo,0)- COALESCE(v_parametros.descuento_inter_serv,0);
                     v_monto_ejecutar_total_mo  = COALESCE(v_parametros.monto,0) -  COALESCE(v_parametros.monto_no_pagado,0);
                     v_porc_monto_retgar = COALESCE(v_parametros.monto_retgar_mo,0)/COALESCE(v_parametros.monto,0);
                     
                     IF   v_liquido_pagable  < 0  or v_monto_ejecutar_total_mo < 0  THEN
                          raise exception ' Ni el  monto a ejecutar   ni el liquido pagable  puede ser menor a cero';
                     END IF;
                     
                    
                    
                     
                     
           -------------------------------------------------------------
           -- EDICION DE CUOTAS DEL ANTICIPO   (ant_parcial,anticipo)
           --------------------------------------------------------------           
           
           ELSIF v_registros_pp.tipo in  ('ant_parcial','anticipo','dev_garantia') THEN
           
           
           
                   --  si es un proceso variable, verifica que el registro no sobrepase el total a pagar
                  IF v_registros_pp.tipo in  ('ant_parcial') THEN
                         v_monto_total= tes.f_determinar_total_faltante(v_parametros.id_obligacion_pago, 'ant_parcial');
                         v_porc_ant = pxp.f_get_variable_global('politica_porcentaje_anticipo')::numeric;
                         
                         IF v_monto_total <  COALESCE(v_parametros.monto,0)  THEN
                            raise exception 'No puede exceder el total a pagar segun politica de anticipos % porc', v_porc_ant*100;
                         END IF;
                  
                  ELSIF v_registros_pp.tipo in  ('anticipo') THEN
                  
                      -- validaciones segun el tipo de anticipo
                      IF v_registros.pago_variable='no' THEN
                            v_monto_total= tes.f_determinar_total_faltante(v_parametros.id_obligacion_pago, 'registrado');
                         
                            IF (v_monto_total + v_registros_pp.monto)  <  v_parametros.monto  THEN
                               raise exception 'No puede exceder el total a pagar en obligaciones no variables: %',v_monto_total;
                            END IF;                          
                         
                          ---------------------------- 
                          --  si es  un pago no variable  (si es una cuota de devengao_pagado, devegando_pagado_1c, pagado)
                          --  validar que no se haga el ultimo pago sin  terminar de descontar el anticipo,
                          ------------------------------------------------
                          
                          -- saldo_x_pagar = determinar cuanto falta por pagar (sin considerar el devengado)
                          
                          v_saldo_x_pagar = tes.f_determinar_total_faltante(v_parametros.id_obligacion_pago,'total_registrado_pagado');
                                
                          -- saldo_x_descontar = determinar cuanto falta por descontar del anticipo parcial
                          v_saldo_x_descontar = tes.f_determinar_total_faltante(v_parametros.id_obligacion_pago,'ant_parcial_descontado');
                                 
                          -- saldo_x_descontar - descuento_anticipo >  sando_x_pagar
                          IF (v_saldo_x_descontar + v_registros_pp.descuento_anticipo)  > (v_saldo_x_pagar + v_registros_pp.monto - COALESCE(v_parametros.monto,0)) THEN
                               raise exception 'El saldo a pagar no es sufuciente para recuperar el anticipo (%)',v_saldo_x_descontar;
                          END IF; 
                    
                      END IF;
                      
                  
                  ELSIF v_registros_pp.tipo in  ('dev_garantia') THEN    
                      
                         v_monto_total= tes.f_determinar_total_faltante(v_parametros.id_obligacion_pago, 'dev_garantia');
                         IF v_monto_total + v_registros_pp.monto <  v_parametros.monto  THEN
                            raise exception 'No puede exceder el total de retencion de garantia devuelto: %', v_monto_total;
                         END IF;
                         
                         --raise exception '% , %',v_monto_total,v_parametros.monto;
                       
                  END IF;
                 
                 
                  v_liquido_pagable = COALESCE(v_parametros.monto,0) -  COALESCE(v_parametros.descuento_anticipo,0); --en anticipo el monto es el liquido pagable
                  v_monto_ejecutar_total_mo  = 0;  -- el monto a ejecutar es cero los anticipo parciales no ejecutan presupeusto
                          
                  IF   v_liquido_pagable  < 0  or v_monto_ejecutar_total_mo < 0  THEN
                      raise exception ' Ni  el monto a ejecutar   ni el liquido pagable  puede ser menor a cero';
                  END IF; 
                  
            -------------------------------------------------------------
            -- EDICION DE CUOTAS DEL ANTICIPO APLCIADO  (ant_aplicado)
            --------------------------------------------------------------
            
            ELSIF v_registros_pp.tipo = 'ant_aplicado' THEN 
            
                    v_monto_total= tes.f_determinar_total_faltante(v_parametros.id_obligacion_pago, 'ant_aplicado_descontado', v_registros_pp.id_plan_pago_fk);
                   
                    IF (v_monto_total + v_registros_pp.monto)  <  v_parametros.monto  THEN
                      raise exception 'No puede exceder el total anticipado';
                    END IF;
                    
                   --  calcula el liquido pagable y el monto a ejecutar presupeustaria mente
                   --  en cuota de pago el monoto no pagado no se considera
                    
                   v_liquido_pagable = COALESCE(v_parametros.monto,0)  - COALESCE(v_parametros.otros_descuentos,0) - COALESCE( v_parametros.monto_retgar_mo,0)  - COALESCE(v_parametros.descuento_ley,0)- COALESCE(v_parametros.descuento_anticipo,0)- COALESCE(v_parametros.descuento_inter_serv,0);
                   v_monto_ejecutar_total_mo  = COALESCE(v_parametros.monto,0);  -- TODO ver si es necesario el monto no pagado
                   v_porc_monto_retgar= COALESCE(v_registros_pp.porc_monto_retgar,0);
                   
                   IF   v_liquido_pagable  < 0  or v_monto_ejecutar_total_mo < 0  THEN
                        raise exception ' Ni el  monto a ejecutar   ni el liquido pagable  puede ser menor a cero';
                   END IF;
           
                  --modificamos el total pagado en la cuota padre
                  
                  update tes.tplan_pago pp set
                  total_pagado = total_pagado - v_registros_pp.monto + COALESCE(v_parametros.monto,0)
                  where id_plan_pago=v_registros_pp.id_plan_pago_fk;
                 
            -------------------------------------
            -- EDICION DE CUOTAS DEL TIPO PAGADO
            -------------------------------------
            
            
            ELSIF v_registros_pp.tipo = 'pagado' THEN
                    
                    --verifica el el registro que falta por pagar
                    v_monto_total= tes.f_determinar_total_faltante(v_parametros.id_obligacion_pago, 'registrado_pagado', v_registros_pp.id_plan_pago_fk);
                    IF (v_monto_total + v_registros_pp.monto)  <  v_parametros.monto  THEN
                      raise exception 'No puede exceder el total a pagar en obligaciones no variables';
                     END IF;
                    
                    --valida que la retencion de anticipo no sobre pase el total anticipado          
                    v_monto_ant_parcial_descontado = tes.f_determinar_total_faltante(v_parametros.id_obligacion_pago, 'ant_parcial_descontado' );
                    -- si el descuento anticipo es mayor a cero verificar que nose sobrepase el total anticipado
                    IF v_monto_ant_parcial_descontado + v_registros_pp.descuento_anticipo <  v_parametros.descuento_anticipo  THEN
                        raise exception 'El decuento por anticipo no puede exceder el falta por descontar que es  %',v_monto_ant_parcial_descontado+descuento_anticipo;
                     END IF;
                     
                   ------------------------------------------------------------  
                   --   si es  un pago no variable  (si es una cuota de devengao_pagado, devegando_pagado_1c, pagado)
                   --  validar que no se haga el ultimo pago sin  terminar de descontar el anticipo,
                   --------------------------------------------------------  
                   IF v_registros.pago_variable='no' THEN   
                         -- saldo_x_pagar = determinar cuanto falta por pagar (sin considerar el devengado)
                         v_saldo_x_pagar = tes.f_determinar_total_faltante(v_parametros.id_obligacion_pago,'total_registrado_pagado');
                                    
                         -- saldo_x_descontar = determinar cuanto falta por descontar del anticipo
                         v_saldo_x_descontar = v_monto_ant_parcial_descontado;
                                     
                         -- saldo_x_descontar - descuento_anticipo >  sando_x_pagar
                         IF (v_saldo_x_descontar + v_registros_pp.descuento_anticipo -  COALESCE(v_parametros.descuento_anticipo,0))  > (v_saldo_x_pagar + v_registros_pp.monto - COALESCE(v_parametros.monto,0)) THEN
                               raise exception 'El saldo a pagar no es sufuciente para recuperar el anticipo (%)',v_saldo_x_descontar;
                         END IF;  
                    END IF;
                     
                    
                    -- calcula el liquido pagable y el monto a ejecutar presupeustaria mente
                    --  en cuota de pago el monoto no pagado no se considera
                    
                   v_liquido_pagable = COALESCE(v_parametros.monto,0)  - COALESCE(v_parametros.otros_descuentos,0) - COALESCE( v_parametros.monto_retgar_mo,0)  - COALESCE(v_parametros.descuento_ley,0)- COALESCE(v_parametros.descuento_anticipo,0)- COALESCE(v_parametros.descuento_inter_serv,0);
                   v_monto_ejecutar_total_mo  = COALESCE(v_parametros.monto,0);  -- TODO ver si es necesario el monto no pagado
                   v_porc_monto_retgar= COALESCE(v_registros_pp.porc_monto_retgar,0);
                   
                   IF   v_liquido_pagable  < 0  or v_monto_ejecutar_total_mo < 0  THEN
                        raise exception ' Ni el  monto a ejecutar   ni el liquido pagable  puede ser menor a cero';
                   END IF;
           
                  --modificamos el total pagado en la cuota padre
                  
                  update tes.tplan_pago pp set
                  total_pagado = total_pagado - v_registros_pp.monto + COALESCE(v_parametros.monto,0)
                  where id_plan_pago=v_registros_pp.id_plan_pago_fk;
            
            ELSE
            
               raise exception 'Tipo no reconocido %',v_registros_pp.tipo;
           
            END IF;
            
           --RAC 11/02/2014 
           --calculo porcentaje monto excento
           
           Select  
           p.sw_monto_excento
           into
           v_sw_me_plantilla
           from param.tplantilla p 
           where p.id_plantilla =  v_parametros.id_plantilla;    
           
           IF v_sw_me_plantilla = 'si' and  v_monto_excento <= 0 THEN
              raise exception  'Este documento necesita especificar un monto excento mayor a cero';
           END IF;
           
           IF COALESCE(v_monto_excento,0) >= COALESCE(v_monto_ejecutar_total_mo,0) and v_registros_pp.tipo not in ('ant_parcial','anticipo','dev_garantia') THEN
             raise exception 'El monto excento (%) debe ser menr que el total a ejecutar(%)',v_monto_excento, v_monto_ejecutar_total_mo  ;
           END IF;
           
           IF  COALESCE(v_monto_excento,0) > 0 THEN
              v_porc_monto_excento_var  = v_monto_excento / v_monto_ejecutar_total_mo;
           ELSE
              v_porc_monto_excento_var = 0;
           END IF;
            
           
        
			--Sentencia de la modificacion
			update tes.tplan_pago set
			monto_ejecutar_total_mo = v_monto_ejecutar_total_mo,
			obs_descuentos_anticipo = v_parametros.obs_descuentos_anticipo,
			id_plantilla = v_parametros.id_plantilla,
			descuento_anticipo = COALESCE(v_parametros.descuento_anticipo,0),
            descuento_inter_serv = COALESCE(v_parametros.descuento_inter_serv,0),
            obs_descuento_inter_serv = v_parametros.obs_descuento_inter_serv,
			otros_descuentos = COALESCE( v_parametros.otros_descuentos,0),
			obs_monto_no_pagado = v_parametros.obs_monto_no_pagado,
			obs_otros_descuentos = v_parametros.obs_otros_descuentos,
			monto = v_parametros.monto,
			nombre_pago = v_parametros.nombre_pago,
			id_cuenta_bancaria = v_id_cuenta_bancaria,
			forma_pago = v_forma_pago,
			monto_no_pagado = v_parametros.monto_no_pagado,
            liquido_pagable=v_liquido_pagable,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
            --tipo_cambio= v_parametros.tipo_cambio,
            monto_retgar_mo= v_parametros.monto_retgar_mo,
            descuento_ley=v_parametros.descuento_ley,
            obs_descuentos_ley=v_parametros.obs_descuentos_ley,
            porc_descuento_ley=v_parametros.porc_descuento_ley,
            nro_cheque =  COALESCE(v_nro_cheque,0),
            fecha_tentativa = v_parametros.fecha_tentativa,
            nro_cuenta_bancaria = v_nro_cuenta_bancaria,
            id_cuenta_bancaria_mov = v_id_cuenta_bancaria_mov,
            porc_monto_excento_var = v_porc_monto_excento_var,
            monto_excento = COALESCE(v_monto_excento,0),
            id_usuario_ai = v_parametros._id_usuario_ai,
            usuario_ai = v_parametros._nombre_usuario_ai,
            porc_monto_retgar = v_porc_monto_retgar
            
            
            where id_plan_pago=v_parametros.id_plan_pago;
           
            IF v_registros_pp.tipo not in ('ant_parcial','anticipo','dev_garantia') THEN
            
                   ----------------------------------------------------------------------
                   -- Inserta prorrateo automatico  si no es algun tipo decuota sin prorrateo (sin presupeustos)
                   ----------------------------------------------------------------------
                   
                   --si el monto del pago y el total de prorrateo no son iguales, reiniciamos el prorrateo
                   
                    select 
                      sum(pr.monto_ejecutar_mo)
                    into
                      v_total_prorrateo
                    from  tes.tprorrateo pr
                    inner join tes.tobligacion_det od on od.id_obligacion_det = pr.id_obligacion_det
                    where pr.id_plan_pago = v_parametros.id_plan_pago 
                    and pr.estado_reg = 'activo' and od.estado_reg = 'activo';
                   
                   
                   IF v_total_prorrateo != v_monto_ejecutar_total_mo THEN 
                   
                        --elimina el prorrateo si es automatico
                         delete from tes.tprorrateo pro where pro.id_plan_pago = v_parametros.id_plan_pago;
                     
                        IF not ( SELECT * FROM tes.f_prorrateo_plan_pago( v_parametros.id_plan_pago,
                                                                   v_parametros.id_obligacion_pago, 
                                                                   v_registros.pago_variable, 
                                                                   v_monto_ejecutar_total_mo,
                                                                   p_id_usuario,
                                                                   v_registros_pp.id_plan_pago_fk
                                                                   
                                                                   )) THEN
                                                                   
                                
                            raise exception 'Error al prorratear';
                                                            
                         END IF;
                    END IF;
            
            END IF;   
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plan Pago modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_plan_pago',v_parametros.id_plan_pago::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TES_PLAPA_ELI'
 	#DESCRIPCION:	Eliminacion de registros de plan de pagos
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
           
           -------------------------------------------------
           --  Eliminacion de cuentas de primer nivel
           ------------------------------------------------
           IF  v_registros.tipo in  ('devengado_pagado','devengado','devengado_pagado_1c','ant_parcial','anticipo','dev_garantia')   THEN
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
                     
                     
                     IF  v_id_tipo_estado is NULL THEN
                    
                         raise exception 'no existe el estado enulado en la cofiguacion de WF para este tipo de proceso';
                     
                     END IF;
                     -- pasamos la cotizacion al siguiente estado
                 
                     v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado, 
                                                                 NULL, 
                                                                 v_registros.id_estado_wf, 
                                                                 v_registros.id_proceso_wf,
                                                                 p_id_usuario,
                                                                 v_parametros._id_usuario_ai,
                                                                 v_parametros._nombre_usuario_ai,
                                                                 v_registros.id_depto,
                                                                 'Se elimina la cuota');
                  
                  
                     -- actualiza estado en la cotizacion
                    
                     update tes.tplan_pago  pp set 
                       id_estado_wf =  v_id_estado_actual,
                       estado = 'anulado',
                       id_usuario_mod=p_id_usuario,
                       fecha_mod=now(),
                       estado_reg='inactivo',
                       id_usuario_ai = v_parametros._id_usuario_ai,
                       usuario_ai = v_parametros._nombre_usuario_ai
                     where pp.id_plan_pago  = v_parametros.id_plan_pago;
                
                    --actulizamos el nro_cuota actual actual en obligacion_pago
                
                
                    update tes.tobligacion_pago op set
                       nro_cuota_vigente = v_nro_cuota - 1
                     where   op.id_obligacion_pago = v_registros.id_obligacion_pago;
                     
                     
                   --elimina los prorrateos
                    update  tes.tprorrateo pro  set 
                     estado_reg='inactivo'
                    where pro.id_plan_pago =  v_parametros.id_plan_pago; 
      ------------------------------------------------------------------------------------
      --  Eliminacion de cuotas de segundo nivel (que dependen de otro plan de pagos)
      -------------------------------------------------------------------------------------         
          
      ELSIF  v_registros.tipo in ('pagado','ant_aplicado')   THEN
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
                                                           v_parametros._id_usuario_ai,
                                                           v_parametros._nombre_usuario_ai,
                                                           v_registros.id_depto,
                                                           'Elimina la cuota de pago');
            
            
                 -- actualiza estado en la cotizacion
              
                 update tes.tplan_pago  pp set 
                   id_estado_wf =  v_id_estado_actual,
                   estado = 'anulado',
                   id_usuario_mod=p_id_usuario,
                   fecha_mod=now(),
                   estado_reg='inactivo',
                   id_usuario_ai = v_parametros._id_usuario_ai,
                   usuario_ai = v_parametros._nombre_usuario_ai
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
 	#AUTOR:		RAC	
 	#FECHA:		10-04-2013 15:43:23
	***********************************/

	elsif(p_transaccion='TES_SOLDEVPAG_IME')then

		begin
        
           --validacion de la cuota
           
           select  
             * 
           into
             v_registros
           from tes.tplan_pago pp 
           where pp.id_plan_pago = v_parametros.id_plan_pago;
           
           
            
            IF  v_registros.tipo  in ('pagado' ,'devengado_pagado','devengado_pagado_1c','anticipo','ant_parcial') THEN
                
                  IF v_registros.forma_pago = 'cheque' THEN
                
                      IF  v_registros.nro_cheque is NULL THEN
                      
                         raise exception  'Tiene que especificar el  nro de cheque';
                      
                      END IF;
                   ELSE 
                
                 		IF  v_registros.nro_cuenta_bancaria  = '' or  v_registros.nro_cuenta_bancaria is NULL THEN
                      
                         raise exception  'Tiene que especificar el nro de cuenta destino, para la transferencia bancaria';
                      
                      END IF;  
                  
               
                  END IF; 
               
               
                  IF v_registros.id_cuenta_bancaria is NULL THEN
                     raise exception  'Tiene que especificar la cuenta bancaria origen de los fondos';
                  END IF ;    
                  
                
               
                   --validacion de deposito, (solo BOA, puede retirarse)
                   IF v_registros.id_cuenta_bancaria_mov is NULL THEN
                   
                        --TODO verificar si la cuenta es de centro
                        
                       select 
                           cb.centro
                       into 
                           v_centro 
                       from tes.tcuenta_bancaria cb
                       where cb.id_cuenta_bancaria = v_registros.id_cuenta_bancaria;
                        
                        
                        
                        IF  v_registros.nro_cuenta_bancaria  = '' or  v_registros.nro_cuenta_bancaria is NULL THEN
                          
                             IF  v_centro = 'no' THEN
                              
                              raise exception  'Tiene que especificar el deposito  origen de los fondos';
                             
                             END IF;
                             
                          
                        END IF;
                   
                   END IF ;
            
           END IF;
           
         
           
           v_verficacion = tes.f_generar_comprobante(
                                                      p_id_usuario,
                                                      v_parametros._id_usuario_ai,
                                                      v_parametros._nombre_usuario_ai,
                                                      v_parametros.id_plan_pago, 
                                                      v_parametros.id_depto_conta);
           
          IF  v_verficacion[1]= 'TRUE'   THEN
            
                  --Definicion de la respuesta
                v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Solitud de generacion de comprobante desde interface de plan de pagos'); 
                v_resp = pxp.f_agrega_clave(v_resp,'id_plan_pago',v_parametros.id_plan_pago::varchar);
                  
                --Devuelve la respuesta
                return v_resp;
            
            ELSE
            
                --Definicion de la respuesta
              
              
                v_resp = pxp.f_agrega_clave(v_resp,'id_plan_pago',v_parametros.id_plan_pago::varchar);
                v_resp = pxp.f_agrega_clave(v_resp,'resultado','falla'); 
                v_resp = pxp.f_agrega_clave(v_resp,'qwe','123');
                v_resp = pxp.f_agrega_clave(v_resp,'mensaje',v_verficacion[2]);
                  
                --Devuelve la respuesta
                return v_resp;
            
            
            END IF;
        end;
        
      
    /*********************************    
 	#TRANSACCION:  'TES_ANTEPP_IME'
 	#DESCRIPCION:	Trasaacion utilizada  pasar a  estados anterior en el plan de pagos
                    segun la operacion definida
 	#AUTOR:		RAC	
 	#FECHA:		19-02-2013 12:12:51
	***********************************/

	elseif(p_transaccion='TES_ANTEPP_IME')then   
        begin
        
        --------------------------------------------------
        --Retrocede al estado inmediatamente anterior
        -------------------------------------------------
       --recuperaq estado anterior segun Log del WF
          SELECT  
         
             ps_id_tipo_estado,
             ps_id_funcionario,
             ps_id_usuario_reg,
             ps_id_depto,
             ps_codigo_estado,
             ps_id_estado_wf_ant
          into
             v_id_tipo_estado,
             v_id_funcionario,
             v_id_usuario_reg,
             v_id_depto,
             v_codigo_estado,
             v_id_estado_wf_ant 
          FROM wf.f_obtener_estado_ant_log_wf(v_parametros.id_estado_wf);
                        
                        
           --
          select 
               ew.id_proceso_wf 
            into 
               v_id_proceso_wf
          from wf.testado_wf ew
          where ew.id_estado_wf= v_id_estado_wf_ant;
          
          
         --configurar acceso directo para la alarma   
             v_acceso_directo = '';
             v_clase = '';
             v_parametros_ad = '';
             v_tipo_noti = 'notificacion';
             v_titulo  = 'Visto Bueno';
             
           
           IF   v_codigo_estado_siguiente not in('borrador','pendiente','pagado','devengado','anulado')   THEN
                  v_acceso_directo = '../../../sis_tesoreria/vista/plan_pago/PlanPagoVb.php';
                 v_clase = 'PlanPagoVb';
                 v_parametros_ad = '{filtro_directo:{campo:"plapa.id_proceso_wf",valor:"'||v_id_proceso_wf::varchar||'"}}';
                 v_tipo_noti = 'notificacion';
                 v_titulo  = 'Visto Bueno';
             
           END IF;
             
          
          -- registra nuevo estado
                      
          v_id_estado_actual = wf.f_registra_estado_wf(
              v_id_tipo_estado, 
              v_id_funcionario, 
              v_parametros.id_estado_wf, 
              v_id_proceso_wf, 
              p_id_usuario,
              v_parametros._id_usuario_ai,
              v_parametros._nombre_usuario_ai,
              v_id_depto,
              '[RETROCESO] '|| v_parametros.obs,
              v_acceso_directo,
              v_clase,
              v_parametros_ad,
              v_tipo_noti,
              v_titulo);
                      
         
          
                         
            IF  not tes.f_fun_regreso_plan_pago_wf(p_id_usuario, 
                                                   v_parametros._id_usuario_ai, 
                                                   v_parametros._nombre_usuario_ai, 
                                                   v_id_estado_actual, 
                                                   v_parametros.id_proceso_wf, 
                                                   v_codigo_estado) THEN
            
               raise exception 'Error al retroceder estado';
            
            END IF;              
                         
                         
         -- si hay mas de un estado disponible  preguntamos al usuario
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');
                        
                              
          --Devuelve la respuesta
            return v_resp;
                        
           
        
        
        
        end;
        
     /*********************************    
 	#TRANSACCION:  'TES_SIGEPP_IME'
 	#DESCRIPCION:	funcion que controla el cambio al Siguiente estado de los planes de pago, integrado  con el EF
 	#AUTOR:		RAC	
 	#FECHA:		17-12-2013 12:12:51
	***********************************/

	elseif(p_transaccion='TES_SIGEPP_IME')then   
        begin
        
         /*   PARAMETROS
         
        $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
        $this->setParametro('id_depto_wf','id_depto_wf','int4');
        $this->setParametro('obs','obs','text');
        $this->setParametro('json_procesos','json_procesos','text');
        */
        
        --obtenermos datos basicos
        select
            pp.id_plan_pago,
            pp.id_proceso_wf,
            pp.estado,
            pp.fecha_tentativa,
            op.numero,
            pp.total_prorrateado ,
            pp.monto_ejecutar_total_mo
        into 
            v_id_plan_pago,
            v_id_proceso_wf,
            v_codigo_estado,
            v_fecha_tentativa,
            v_num_obliacion_pago,
            v_total_prorrateo,
            v_monto_ejecutar_total_mo
            
        from tes.tplan_pago  pp
        inner  join tes.tobligacion_pago op on op.id_obligacion_pago = pp.id_obligacion_pago
        where pp.id_proceso_wf  = v_parametros.id_proceso_wf_act;
        
       
          
          
          select 
            ew.id_tipo_estado ,
            te.pedir_obs,
            ew.id_estado_wf
           into 
            v_id_tipo_estado,
            v_perdir_obs,
            v_id_estado_wf
            
          from wf.testado_wf ew
          inner join wf.ttipo_estado te on te.id_tipo_estado = ew.id_tipo_estado
          where ew.id_estado_wf =  v_parametros.id_estado_wf_act;
          
         
           -- obtener datos tipo estado
                
                select
                 te.codigo
                into
                 v_codigo_estado_siguiente
                from wf.ttipo_estado te
                where te.id_tipo_estado = v_parametros.id_tipo_estado;
                
             IF  pxp.f_existe_parametro(p_tabla,'id_depto_wf') THEN
                 
               v_id_depto = v_parametros.id_depto_wf;
                
             END IF;
                
                
                
             IF  pxp.f_existe_parametro(p_tabla,'obs') THEN
                  v_obs=v_parametros.obs;
             ELSE
                   v_obs='---';
                
             END IF;
               
             --configurar acceso directo para la alarma   
             v_acceso_directo = '';
             v_clase = '';
             v_parametros_ad = '';
             v_tipo_noti = 'notificacion';
             v_titulo  = 'Visto Bueno';
             
           
             IF   v_codigo_estado_siguiente not in('borrador','pendiente','pagado','devengado','anulado')   THEN
                  v_acceso_directo = '../../../sis_tesoreria/vista/plan_pago/PlanPagoVb.php';
                  v_clase = 'PlanPagoVb';
                  v_parametros_ad = '{filtro_directo:{campo:"plapa.id_proceso_wf",valor:"'||v_id_proceso_wf::varchar||'"}}';
                  v_tipo_noti = 'notificacion';
                  v_titulo  = 'Visto Bueno';
             
             END IF;
             
             
             -- hay que recuperar el supervidor que seria el estado inmediato,...
             v_id_estado_actual =  wf.f_registra_estado_wf(v_parametros.id_tipo_estado, 
                                                             v_parametros.id_funcionario_wf, 
                                                             v_parametros.id_estado_wf_act, 
                                                             v_id_proceso_wf,
                                                             p_id_usuario,
                                                             v_parametros._id_usuario_ai,
                                                             v_parametros._nombre_usuario_ai,
                                                             v_id_depto,
                                                             COALESCE(v_num_obliacion_pago,'--')||' Obs:'||v_obs,
                                                             v_acceso_directo ,
                                                             v_clase,
                                                             v_parametros_ad,
                                                             v_tipo_noti,
                                                             v_titulo);
                
          --------------------------------------
          -- registra los procesos disparados
          --------------------------------------
         
          FOR v_registros_proc in ( select * from json_populate_recordset(null::wf.proceso_disparado_wf, v_parametros.json_procesos::json)) LOOP
    
               --get cdigo tipo proceso
               select   
                  tp.codigo 
               into 
                  v_codigo_tipo_pro   
               from wf.ttipo_proceso tp 
               where  tp.id_tipo_proceso =  v_registros_proc.id_tipo_proceso_pro;
          
          
               -- disparar creacion de procesos seleccionados
              
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
                       v_parametros._id_usuario_ai,
                       v_parametros._nombre_usuario_ai,
                       v_id_estado_actual, 
                       v_registros_proc.id_funcionario_wf_pro, 
                       v_registros_proc.id_depto_wf_pro,
                       v_registros_proc.obs_pro,
                       v_codigo_tipo_pro,    
                       v_codigo_tipo_pro);
                       
                       
           END LOOP; 
           
           -- actualiza estado en la solicitud
           -- funcion para cambio de estado     
           
          IF  tes.f_fun_inicio_plan_pago_wf(p_id_usuario, 
           									v_parametros._id_usuario_ai, 
                                            v_parametros._nombre_usuario_ai, 
                                            v_id_estado_actual, 
                                            v_parametros.id_proceso_wf_act, 
                                            v_codigo_estado_siguiente) THEN
                                            
          END IF;
          
          
          -- si hay mas de un estado disponible  preguntamos al usuario
          v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado del plan de pagos)'); 
          v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');
          
          
          -- Devuelve la respuesta
          return v_resp;
        
     end;        
        
        
    /*********************************    
 	#TRANSACCION:  'TES_SINPRE_IME'
 	#DESCRIPCION:	Incremeta el  presupuesto faltante para la cuota indicada del plan de pagos
 	#AUTOR:		rac
 	#FECHA:		08-07-2013 15:43:23
	***********************************/

	elsif(p_transaccion='TES_SINPRE_IME')then

		begin
         
           -- verficar presupuesto y comprometer
           IF not tes.f_gestionar_presupuesto_tesoreria(NULL, p_id_usuario, 'sincronizar_presupuesto',v_parametros.id_plan_pago)  THEN
                   
                 raise exception 'Error al comprometer el presupeusto';
                   
           END IF;
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','El presupuesto de la cuota del plan de pago fue incrementado exitosamente'); 
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