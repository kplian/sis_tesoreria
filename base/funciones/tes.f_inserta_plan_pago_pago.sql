--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_inserta_plan_pago_pago (
  p_administrador integer,
  p_id_usuario integer,
  p_hstore public.hstore
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		tes.f_inserta_plan_pago_anticipo
 DESCRIPCION:   Inserta registro de cotizacion
 AUTOR: 		Rensi Arteaga COpari
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
    
    v_registros_tpp                 record;
    v_porc_monto_retgar             numeric;
    
    v_monto_ant_parcial_descontado  numeric;
    v_saldo_x_pagar  numeric; 
    v_saldo_x_descontar   numeric; 
    
    v_resp_doc   boolean;
    v_obligacion	record;
    
    v_monto_anticipo  numeric;
    v_check_ant_mixto numeric;
    			
    
    
     v_count integer;  
     v_codigo_proceso_llave_wf varchar; 
     v_id_depto_lb  integer; 
     
 
     
			    
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
    (p_hstore->'descuento_anticipo')::numeric
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
   
   (p_hstore->'descuento_inter_serv')::numeric
   
   (p_hstore->'_id_usuario_ai')::integer, 
   (p_hstore->'_nombre_usuario_ai')::varchar, 
   
   
   (p_hstore->'obs_descuentos_anticipo')::varchar, 
   (p_hstore->'obs_monto_no_pagado')::varchar, 
   (p_hstore->'obs_otros_descuentos')::varchar, 
   (p_hstore->'nombre_pago')::varchar,
   
   (p_hstore->'id_plantilla')::integer,
   (p_hstore->'porc_monto_retgar')::numeric
   (p_hstore->'monto_ajuste_ag')::numeric
   
 */
         

           v_nombre_funcion = 'tes.f_inserta_plan_pago_pago';
            
           
               
           v_id_cuenta_bancaria = (p_hstore->'id_cuenta_bancaria')::integer;
           v_id_cuenta_bancaria_mov = (p_hstore->'id_cuenta_bancaria_mov')::integer;
           v_forma_pago =  (p_hstore->'forma_pago')::varchar;
           v_nro_cheque =  (p_hstore->'nro_cheque')::integer;
           v_nro_cuenta_bancaria =  (p_hstore->'nro_cuenta_bancaria')::varchar;
           
           v_porc_monto_excento_var = (p_hstore->'porc_monto_excento_var')::numeric;
           v_monto_excento = (p_hstore->'monto_excento')::numeric;
              
          
          
          
             --validamos que el monto a pagar sea mayor que cero
             
             IF  (p_hstore->'monto')::numeric = 0 THEN
             
                raise exception 'El monto a pagar no puede ser 0';
             
             END IF;
             
             
             IF  (p_hstore->'id_plan_pago_fk')::integer is NULL   THEN
               raise exception 'El nuevo registro debe hacer referencia a una cuota de devengado o anticipo ';
             
             END IF;
             
            --  obtiene datos de la obligacion
             
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
              op.numero,
              op.pago_variable
              
            into v_registros  
             from tes.tplan_pago pp
             inner join tes.tobligacion_pago op on op.id_obligacion_pago = pp.id_obligacion_pago
             where pp.id_plan_pago  = (p_hstore->'id_plan_pago_fk')::integer;
             
             
             -------------------------
             --CAlcular el nro de cuota
             --------------------------
             
            select 
              count(id_plan_pago)
            INTO
              v_count 
            from tes.tplan_pago pp 
            where  pp.id_plan_pago_fk =  (p_hstore->'id_plan_pago_fk')::integer 
                   and pp.estado_reg = 'activo';  
             
             --IF (p_hstore->'tipo')::varchar in('pagado_rrhh') THEN 
                  v_nro_cuota =   ((floor(COALESCE(v_registros.nro_cuota,0))::integer)::varchar ||'.'||TRIM(to_char((COALESCE(v_count,0)+1 ),'00'))::varchar)::numeric  ;
             --else
             --		v_nro_cuota =   ((floor(COALESCE(v_registros.nro_cuota,0))::integer)::varchar ||'.'||TRIM(to_char((COALESCE(v_count,0)+1 ),'00'))::varchar)::numeric  ;
             --end if;
             
             
            --valida que la fecha tentativa
            
            IF v_registros.fecha_tentativa > (p_hstore->'fecha_tentativa')::date THEN          
              raise exception 'La fecha tentativa no puede ser inferior a la fecha tentativa de la ultima cuota registrada';          
            END IF;
            
           -------------------------------------------------------------------
           --  VALIDACION DE MONTO FALTANTE, SEGUN TIPO DE CUOTA
           ------------------------------------------------------------
            
           IF (p_hstore->'tipo')::varchar in('pagado','pagado_rrhh') THEN 
            
                  -- verifica que el registro no sobrepase el total a devengado
                  v_monto_total= tes.f_determinar_total_faltante((p_hstore->'id_obligacion_pago')::integer, 'registrado_pagado',(p_hstore->'id_plan_pago_fk')::integer );
                  IF v_monto_total <  (p_hstore->'monto')::numeric  THEN
                      raise exception 'El Pago no puede exceder el total devengado, solo falta por devengar %',v_monto_total;
                  END IF;
                  
                  --valida que la retencion de anticipo no sobre pase el total anticipado
                  v_monto_ant_parcial_descontado = tes.f_determinar_total_faltante((p_hstore->'id_obligacion_pago')::integer, 'ant_parcial_descontado' );
                  IF v_monto_ant_parcial_descontado <  (p_hstore->'descuento_anticipo')::numeric  THEN
                      raise exception 'El decuento por anticipo no puede exceder el falta por descontar que es  %',v_monto_ant_parcial_descontado;
                  END IF;
                  
                  --  si es  un pago no variable  (si es una cuota de devengao_pagado, devegando_pagado_1c, pagado)
                  --  validar que no se haga el ultimo pago sin  terminar de descontar el anticipo,
                  
                  IF v_registros.pago_variable = 'no' THEN
                  
                       -- saldo_x_pagar = determinar cuanto falta por pagar (sin considerar el devengado)
                      v_saldo_x_pagar = tes.f_determinar_total_faltante((p_hstore->'id_obligacion_pago')::integer,'total_registrado_pagado');
                            
                      -- saldo_x_descontar = determinar cuanto falta por descontar del anticipo
                      v_saldo_x_descontar = tes.f_determinar_total_faltante((p_hstore->'id_obligacion_pago')::integer,'ant_parcial_descontado');
                             
                      -- saldo_x_descontar - descuento_anticipo >  sando_x_pagar
                      IF (v_saldo_x_descontar -  COALESCE((p_hstore->'descuento_anticipo')::numeric,0))  > (v_saldo_x_pagar  - COALESCE((p_hstore->'monto')::numeric,0)) THEN
                          raise exception 'El saldo a pagar no es sufuciente para recuperar el anticipo (%)',v_saldo_x_descontar;
                      END IF; 
                  
                  END IF;
                  
                 
           ELSEIF (p_hstore->'tipo')::varchar in ('ant_aplicado')  THEN
                            
                  IF  v_registros.pago_variable = 'no' THEN
                       v_monto_total= tes.f_determinar_total_faltante((p_hstore->'id_obligacion_pago')::integer, 'ant_aplicado_descontado', (p_hstore->'id_plan_pago_fk')::integer);
                       IF (v_monto_total)  <  (p_hstore->'monto')::numeric  THEN
                         raise exception 'No puede exceder el total anticipado: %',v_monto_total;
                       END IF;
                  
                  ELSE
                       v_monto_total= tes.f_determinar_total_faltante((p_hstore->'id_obligacion_pago')::integer, 'ant_aplicado_descontado_op_variable', (p_hstore->'id_plan_pago_fk')::integer);
                       
                  
                  END IF;
                  
           ELSE
              
              raise exception 'tipo no reconocido %',(p_hstore->'tipo')::varchar;
            
           END IF;
           
           --validaciond e cifras negativas
             
           IF  (p_hstore->'monto')::numeric < 0 or (p_hstore->'monto_no_pagado')::numeric < 0 or (p_hstore->'otros_descuentos')::numeric  < 0 or (p_hstore->'descuento_ley')::numeric < 0  or (p_hstore->'descuento_anticipo')::numeric < 0 THEN
              raise exception 'No se admiten cifras negativas'; 
           END IF;
          
          
           IF (p_hstore->'monto_no_pagado')::numeric !=0  THEN
             raise exception 'El monto no pagado solo puede definirce en cuotas de devengado';
           END IF;
          
           -- calcula el liquido pagable y el monto  a ejecutar presupeustaria mente
            
           v_liquido_pagable = COALESCE((p_hstore->'monto')::numeric,0)  - COALESCE((p_hstore->'otros_descuentos')::numeric,0) - COALESCE( (p_hstore->'monto_retgar_mo')::numeric,0)  - COALESCE((p_hstore->'descuento_ley')::numeric,0)- COALESCE((p_hstore->'descuento_anticipo')::numeric,0)- COALESCE((p_hstore->'descuento_inter_serv')::numeric,0);
           v_monto_ejecutar_total_mo  = COALESCE((p_hstore->'monto')::numeric,0);  -- TODO ver si es necesario el monto no pagado
                    
           
           IF v_monto_excento > 0 THEN
              v_porc_monto_excento_var  = v_monto_excento / v_monto_ejecutar_total_mo;
           ELSE
              v_porc_monto_excento_var = 0;
           END IF;
           
           
           IF   v_liquido_pagable  < 0  or v_monto_ejecutar_total_mo < 0  THEN
                raise exception ' Ni  el monto a ejecutar   ni el liquido pagable  puede ser menor a cero';
           END IF;  
            
            
            --obtiene el tipo de plan de pago para este registro
            select
             tpp.codigo_proceso_llave_wf
            into
             v_codigo_proceso_llave_wf
            from tes.ttipo_plan_pago tpp
            where tpp.codigo = (p_hstore->'tipo')::varchar;
            
           
            
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
                       (p_hstore->'_id_usuario_ai')::integer,
                       (p_hstore->'_nombre_usuario_ai')::varchar,
                       v_registros.id_estado_wf, 
                       NULL, 
                       v_registros.id_depto,
                       ('Solicutd de Pago, OP:'|| v_registros.numero||' cuota nro'||v_nro_cuota::varchar),
                       v_codigo_proceso_llave_wf,
                       v_registros.numero||'-N# '||v_nro_cuota
                       );     
          
             -- raise exception '%, %', v_codigo_proceso_llave_wf,(p_hstore->'tipo');
             
             
             
             
                
                        
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
                  porc_monto_retgar,
                  monto_ajuste_ag,
                  descuento_inter_serv,
                  monto_excento,
                  porc_monto_excento_var
              ) 
              values
              (
                'activo',
                v_nro_cuota,
                '---',    --'nro_sol_pago',
                v_id_proceso_wf,
                v_codigo_estado,
                --v_parametros.tipo_pago,
                v_monto_ejecutar_total_mo,
                (p_hstore->'obs_descuentos_anticipo')::varchar,
                (p_hstore->'id_plan_pago_fk')::integer,
                (p_hstore->'id_obligacion_pago')::integer,
                (p_hstore->'id_plantilla')::integer,
                (p_hstore->'descuento_anticipo')::numeric,
                (p_hstore->'otros_descuentos')::numeric,
                (p_hstore->'tipo')::varchar,
                (p_hstore->'obs_monto_no_pagado')::varchar,
                (p_hstore->'obs_otros_descuentos')::varchar,
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
                --v_parametros.tipo_cambio,
                (p_hstore->'monto_retgar_mo')::numeric,
                (p_hstore->'descuento_ley')::numeric,
                (p_hstore->'obs_descuentos_ley'),
                (p_hstore->'porc_descuento_ley')::numeric,
                COALESCE(v_nro_cheque,0),
                v_nro_cuenta_bancaria,
                v_id_cuenta_bancaria_mov,
                (p_hstore->'_id_usuario_ai')::integer,
                (p_hstore->'_nombre_usuario_ai')::varchar,
                (p_hstore->'porc_monto_retgar')::numeric,
                (p_hstore->'monto_ajuste_ag')::numeric,
                (p_hstore->'descuento_inter_serv')::numeric,
                v_monto_excento,
                v_porc_monto_excento_var	
          )RETURNING id_plan_pago into v_id_plan_pago;
          
          
          -- actualiza el monto pagado en el plan_pago padre
            
          update tes.tplan_pago  pp set 
             total_pagado = COALESCE(total_pagado,0) +v_monto_ejecutar_total_mo,
             fecha_mod=now()
           where pp.id_plan_pago  = (p_hstore->'id_plan_pago_fk')::integer;
          
            
          -- inserta documentos en estado borrador si estan configurados
          v_resp_doc =  wf.f_inserta_documento_wf(p_id_usuario, v_id_proceso_wf, v_id_estado_wf);
          -- verificar documentos
          v_resp_doc = wf.f_verifica_documento(p_id_usuario, v_id_estado_wf);
            
          --------------------------------------------------
          -- Inserta prorrateo automatico del pago
          ------------------------------------------------
          IF (p_hstore->'tipo')::varchar not in('pagado_rrhh') THEN 
               IF not ( SELECT * FROM tes.f_prorrateo_plan_pago( v_id_plan_pago,
                                                         (p_hstore->'id_obligacion_pago')::integer, 
                                                         v_registros.pago_variable, 
                                                         v_monto_ejecutar_total_mo,
                                                         p_id_usuario,
                                                         (p_hstore->'id_plan_pago_fk')::integer)) THEN
                                                           
                        
                  raise exception 'Error al prorratear';
                           
                END IF;
          END IF;
          
          
          
           
          
          --Definicion de la respuesta
          v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plan Pago almacenado(a) con exito (id_plan_pago'||v_id_plan_pago||')'); 
          v_resp = pxp.f_agrega_clave(v_resp,'id_plan_pago',v_id_plan_pago::varchar);
         
        
        --raise exception 'final .....';
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