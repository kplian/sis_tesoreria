--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_inserta_plan_pago_dev (
  p_administrador integer,
  p_id_usuario integer,
  p_hstore public.hstore
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

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
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
    
    
    
    
    */


          v_nombre_funcion = 'tes.f_inserta_plan_pago_dev';
          
        
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
             
             
             
             
            
           
           --validamos que el monto a pagar sea mayor que cero
           
           IF  (p_hstore->'monto')::numeric = 0 THEN
           
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
           
           
           
            --si es un proceso variable, verifica que el registro no sobrepase el total a pagar
           
           IF v_registros.pago_variable='no' THEN
              v_monto_total= tes.f_determinar_total_faltante((p_hstore->'id_obligacion_pago')::integer, 'registrado');
           
              IF v_monto_total <  (p_hstore->'monto')::numeric  THEN
              
                  raise exception 'No puede exceder el total a pagar en obligaciones no variables';
              
              END IF;
           
           END IF;
           
         
          IF  (p_hstore->'monto')::numeric < 0 or (p_hstore->'monto_no_pagado')::numeric < 0 or (p_hstore->'otros_descuentos')::numeric  < 0 THEN
          
             raise exception 'No se admiten cifras negativas'; 
          END IF;
        
           
          -- calcula el liquido pagable y el monsto a ejecutar presupeustaria mente
           
           v_liquido_pagable = COALESCE((p_hstore->'monto')::numeric,0) - COALESCE((p_hstore->'monto_no_pagado')::numeric,0) - COALESCE((p_hstore->'otros_descuentos')::numeric,0) - COALESCE((p_hstore->'monto_retgar_mo')::numeric,0) - COALESCE((p_hstore->'descuento_ley')::numeric,0);
          
           v_monto_ejecutar_total_mo  = COALESCE((p_hstore->'monto')::numeric,0) -  COALESCE((p_hstore->'monto_no_pagado')::numeric,0);
          
          
          
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
         
         IF v_sw_me_plantilla = 'si' and  v_monto_excento <= 0 THEN
         
            raise exception  'Este documento necesita especificar un monto excento mayor a cero';
         
         END IF;
         
         
         IF v_monto_excento >=  v_monto_ejecutar_total_mo THEN
           raise exception 'El monto excento (%) debe ser menr que el total a ejecutar(%)',v_monto_excento, v_monto_ejecutar_total_mo  ;
         END IF;
         
         IF v_monto_excento > 0 THEN
            v_porc_monto_excento_var  = v_monto_excento / v_monto_ejecutar_total_mo;
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
                                                                    v_registros.id_depto);
                    
                    --actualiza el proceso
                    
                    -- actuliaza el stado en la solictud
                     update tes.tobligacion_pago  p set 
                       id_estado_wf =  v_id_estado_actual,
                       estado = va_codigo_estado_pro[1],
                       id_usuario_mod=p_id_usuario,
                       fecha_mod=now()
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
                               v_id_estado_actual, 
                               NULL, 
                               v_registros.id_depto,
                              ('Solicutd de devengado para la OP:'|| COALESCE(v_registros.numero,'s/n')||' cuota nro'||v_nro_cuota::varchar),
                               '',
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
                           v_registros.id_estado_wf, 
                           NULL, 
                           v_registros.id_depto,
                           ('Solicutd de devengado para la OP:'|| v_registros.numero||' cuota nro'||v_nro_cuota::varchar),
                           '',
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
        
           
           -------------------------------------------
           -- valida tipo_pago anticipo o adelanto solo en la primera cuota
           ----------------------------------------------
            
            IF  (p_hstore->'tipo_pago')::varchar in ('anticipo','adelanto') and  v_nro_cuota!=1 THEN
            
              raise exception 'Los anticipos y andelantos tienen que ser la primera cuota';
            
            ELSIF  (p_hstore->'tipo_pago')::varchar in ('anticipo') and  v_nro_cuota=1 THEN
            
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
            fecha_tentativa,
            tipo_cambio,
            monto_retgar_mo,
            descuento_ley,
            obs_descuentos_ley,
            porc_descuento_ley,
            nro_cheque,
            nro_cuenta_bancaria,
            id_cuenta_bancaria_mov,
            porc_monto_excento_var,
            monto_excento
          	) values(
			'activo',
			v_nro_cuota,
			'---',--'nro_sol_pago',
			v_id_proceso_wf,
			v_codigo_estado,
			(p_hstore->'tipo_pago')::varchar,
			v_monto_ejecutar_total_mo,
			--obs_descuentos_anticipo,
			(p_hstore->'id_plan_pago_fk')::integer,
			(p_hstore->'id_obligacion_pago')::integer,
			(p_hstore->'id_plantilla')::integer,
			--descuento_anticipo,
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
            (p_hstore->'tipo_cambio')::numeric,
            (p_hstore->'monto_retgar_mo')::numeric,
            (p_hstore->'descuento_ley')::numeric,
            (p_hstore->'obs_descuentos_ley'),
            (p_hstore->'porc_descuento_ley')::numeric,
			v_nro_cheque,
			v_nro_cuenta_bancaria,
            v_id_cuenta_bancaria_mov,
            v_porc_monto_excento_var,
            v_monto_excento		
			)RETURNING id_plan_pago into v_id_plan_pago;
            
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
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plan Pago almacenado(a) con exito (id_plan_pago'||v_id_plan_pago||')'); 
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