--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_inserta_libro_bancos (
  p_administrador integer,
  p_id_usuario integer,
  p_hstore public.hstore
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Tesoreria
 FUNCION: 		tes.f_inserta_libro_bancos
 DESCRIPCION:   Inserta registro de libro_bancos
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        17-11-2014
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
    
    v_id_periodo integer;
    v_tipo_documento  varchar;
    v_parametros record;
    v_codigo_proceso_macro varchar; 
    v_num  varchar; 
    v_resp_doc     boolean;
    va_id_funcionario_gerente   INTEGER[]; 
    v_id_proceso_macro integer;
    v_codigo_tipo_proceso varchar;
    v_anho integer;
    v_id_gestion integer;
    v_id_subsistema integer; 
    v_num_tramite  varchar;
    v_id_proceso_wf integer;
    v_id_estado_wf integer;
    v_codigo_estado varchar;
    v_codigo_estado_ant varchar;   
    v_id_libro_bancos integer;   
 	v_id_funcionario	integer;
    v_id_estado_wf_anterior   integer; 
	v_id_depto		integer;
    v_codigo_tipo_pro	varchar;
    v_sistema_origen	varchar;
    g_fecha			date;
    		    
BEGIN

    v_nombre_funcion = 'f_inserta_libro_bancos';
    
    /*
    HSTORE  PARAMETERS
            (p_hstore->'tipo')::varchar
            (p_hstore->'fecha')::date  
            (p_hstore->'origen')::varchar
            (p_hstore->'a_favor')::varchar
            (p_hstore->'detalle')::varchar
            (p_hstore->'nro_cheque')::varchar
            (p_hstore->'observaciones')::varchar
            (p_hstore->'importe_cheque')::numeric
            (p_hstore->'importe_deposito')::numeric
            (p_hstore->'nro_comprobante')::varchar
            (p_hstore->'comprobante_sigma')::varchar
            (p_hstore->'nro_liquidacion')::varchar
            (p_hstore->'id_cuenta_bancaria')::integer
            (p_hstore->'id_libro_bancos_fk')::integer
            (p_hstore->'id_finalidad')::integer            
            (p_stores->'id_int_comprobante')::integer
            
            no estan estos
            (p_hstore->'id_funcionario')::integer
            (p_hstore->'_id_usuario_ai')::integer,
            (p_hstore->'_nombre_usuario_ai')::varchar,
            (p_hstore->'id_funcionario')::integer,
            (p_hstore->'id_depto')::integer
    
    */
    
    --determina la fecha del periodo
         IF(p_hstore ? 'fecha' = false)THEN
         	g_fecha = now();
         ELSE 
         	g_fecha = p_hstore->'fecha';
         END IF;
         
         select id_periodo into v_id_periodo from
                        param.tperiodo per 
                       where per.fecha_ini <= g_fecha::date 
                         and per.fecha_fin >= g_fecha::date
                         limit 1 offset 0;
        
        
        IF   (p_hstore->'tipo')::varchar not in ('cheque','debito_automatico','transferencia_carta','deposito','transf_interna_debe','transf_interna_haber') THEN
             raise exception 'Tipo de transaccion bancaria no valida';                
        ELSE              
        	
                v_tipo_documento = 'LB';
                
                  --obtener correlativo
                 v_num =   param.f_obtener_correlativo(
                          'LB', 
                           v_id_periodo,-- par_id, 
                           NULL, --id_uo 
                           (p_hstore->'id_depto')::integer,    -- id_depto
                           p_id_usuario, 
                           'TES', 
                           NULL);               
        
                v_codigo_proceso_macro = 'LIB-BAN';                        
              
        END IF;
       
       
        IF (v_num is NULL or v_num ='') THEN
        
          raise exception 'No se pudo obtener un numero correlativo para el libro de bancos';
        
        END IF;
        
        --obtener id del proceso macro
        v_sistema_origen = COALESCE(p_hstore->'sistema_origen','PXP')::varchar;

		IF( v_sistema_origen != 'KERP' OR (v_sistema_origen = 'KERP' AND (p_hstore->'tipo') in ('deposito','transferencia_carta')))THEN
        
            select 
             pm.id_proceso_macro
            into
             v_id_proceso_macro
            from wf.tproceso_macro pm
            where pm.codigo = v_codigo_proceso_macro;
            
            
            If v_id_proceso_macro is NULL THEN
            
               raise exception 'El proceso macro  de codigo % no esta configurado en el sistema WF',v_codigo_proceso_macro;  
            
            END IF;
            
            --   obtener el codigo del tipo_proceso
            select   tp.codigo 
                into v_codigo_tipo_proceso
            from  wf.ttipo_proceso tp 
            where   tp.id_proceso_macro = v_id_proceso_macro
                    and tp.estado_reg = 'activo' and tp.codigo_llave=(p_hstore->'tipo')::varchar;
                
            IF v_codigo_tipo_proceso is NULL THEN
            
               raise exception 'No existe un proceso inicial para el proceso macro indicado % (Revise la configuración)',v_codigo_proceso_macro;
            
            END IF;
      
            
            v_anho = (date_part('year', g_fecha::date))::integer;
    			
                select 
                 ges.id_gestion
                 into v_id_gestion
                from param.tgestion ges
                where ges.gestion = v_anho
                limit 1 offset 0;
            /*
            select f.id_funcionario into v_id_funcionario
                          from segu.tusuario u
                          inner join orga.tfuncionario f on f.id_persona=u.id_persona
                          where u.id_usuario=p_id_usuario;
                          
            IF (v_id_funcionario is NULL)THEN
                          
            raise exception 'El usuario no es funcionario permitido para usar el modulo de libro de bancos';
            
            END IF;*/        
                  
            -- inciar el tramite en el sistema de WF
             SELECT 
                   ps_num_tramite ,
                   ps_id_proceso_wf ,
                   ps_id_estado_wf ,
                   ps_codigo_estado 
                into
                   v_num_tramite,
                   v_id_proceso_wf,
                   v_id_estado_wf,
                   v_codigo_estado   
                    
              FROM wf.f_inicia_tramite(
                   p_id_usuario,
                   NULL, --(p_hstore->'_id_usuario_ai')::integer,
                   NULL, --(p_hstore->'_nombre_usuario_ai')::varchar,
                   v_id_gestion, 
                   v_codigo_tipo_proceso, 
                   NULL::integer,
                   (p_hstore->'id_depto')::integer,
                   'Transaccion bancaria ('||v_num||')'::varchar,
                   v_num );
                   --para depositos, transferencias, debito no genera numero de tramite por q no es proceso de inicio                     
                   raise notice 'num_tramite %, id_proceso_wf %, id_estado_wf %, codigo_estado %', v_num_tramite,
                   v_id_proceso_wf,
                   v_id_estado_wf,
                   v_codigo_estado; 
              	
            ELSE 
                select pp.id_estado_wf, op.num_tramite into v_id_estado_wf_anterior, v_num_tramite
                from tes.tplan_pago pp
                inner join tes.tobligacion_pago op on op.id_obligacion_pago=pp.id_obligacion_pago
                where pp.id_int_comprobante=(p_hstore->'id_int_comprobante')::int4 and pp.estado='pagado';  
                                
                IF v_id_estado_wf_anterior IS NULL THEN
                	raise exception 'El plan de pago no se encuentra en estado pagado';
                END IF;
                
                select id_depto into v_id_depto
                from param.tdepto
                where codigo='OP-CBB';
                
                IF v_id_depto IS NULL THEN
                	raise exception 'No existe un departamento con el codigo Obligaciones de Pago';
                END IF;
                                
            	select tp.codigo into v_codigo_tipo_pro
				from wf.ttipo_proceso tp
				inner join wf.tproceso_macro pm on pm.id_proceso_macro=tp.id_proceso_macro
				where tp.inicio='si' and pm.codigo=v_codigo_proceso_macro and tp.estado_reg='activo';
                
				IF v_codigo_tipo_pro IS NULL THEN
                	raise exception 'No existe en proceso de inicio para el proceso macro %', v_codigo_proceso_macro;
                END IF;                
                
                SELECT   ps_id_proceso_wf,
                         ps_id_estado_wf,
                         ps_codigo_estado
                   into
                         v_id_proceso_wf,
                         v_id_estado_wf,
                         v_codigo_estado
                FROM wf.f_registra_proceso_disparado_wf(
                         p_id_usuario,
                         NULL,
                         NULL,
                         v_id_estado_wf_anterior::integer, 
                         NULL::integer, 
                         v_id_depto::integer,
                         NULL,
                         v_codigo_tipo_pro,    
                         v_codigo_tipo_pro);                         
                
            END IF;    
			
            IF(p_hstore ? 'fecha' = false)THEN
            
            	insert into tes.tts_libro_bancos(
                id_cuenta_bancaria,
                a_favor,
                nro_cheque,
                importe_deposito,
                nro_liquidacion,
                detalle,
                origen,
                observaciones,
                importe_cheque,
                id_libro_bancos_fk,
                estado,
                nro_comprobante,
                estado_reg,
                tipo,
                fecha_reg,
                id_usuario_reg,
                fecha_mod,
                id_usuario_mod,
                id_estado_wf,
                id_proceso_wf,
                num_tramite,
                id_depto,
                id_finalidad,
                sistema_origen,
                comprobante_sigma,
                id_int_comprobante
                ) values(            
                (p_hstore->'id_cuenta_bancaria')::integer,
                upper(translate ((p_hstore->'a_favor')::varchar, 'áéíóúÁÉÍÓÚäëïöüÄËÏÖÜñ', 'aeiouAEIOUaeiouAEIOUÑ')),
                (p_hstore->'nro_cheque')::integer,
                (p_hstore->'importe_deposito')::numeric,
                upper(translate ((p_hstore->'nro_liquidacion')::varchar, 'áéíóúÁÉÍÓÚäëïöüÄËÏÖÜñ', 'aeiouAEIOUaeiouAEIOUÑ')),
                upper(translate ((p_hstore->'detalle')::varchar, 'áéíóúÁÉÍÓÚäëïöüÄËÏÖÜñ', 'aeiouAEIOUaeiouAEIOUÑ')),
                (p_hstore->'origen')::varchar,
                upper(translate ((p_hstore->'observaciones')::varchar, 'áéíóúÁÉÍÓÚäëïöüÄËÏÖÜñ', 'aeiouAEIOUaeiouAEIOUÑ')),
                (p_hstore->'importe_cheque')::numeric,
                (p_hstore->'id_libro_bancos_fk')::integer,
                v_codigo_estado,
                (p_hstore->'nro_comprobante')::varchar,
                'activo',
                (p_hstore->'tipo')::varchar,
                now(),
                p_id_usuario,
                null,
                null,
                v_id_estado_wf,
                v_id_proceso_wf,
                v_num_tramite,
                (p_hstore->'id_depto')::integer,				
                (p_hstore->'id_finalidad')::integer,
                (p_hstore->'sistema_origen')::varchar,
                (p_hstore->'comprobante_sigma')::varchar,
                (p_hstore->'id_int_comprobante')::integer				
                )RETURNING id_libro_bancos into v_id_libro_bancos;    		
            
            ELSE
            
              insert into tes.tts_libro_bancos(
                  id_cuenta_bancaria,
                  fecha,
                  a_favor,
                  nro_cheque,
                  importe_deposito,
                  nro_liquidacion,
                  detalle,
                  origen,
                  observaciones,
                  importe_cheque,
                  id_libro_bancos_fk,
                  estado,
                  nro_comprobante,
                  estado_reg,
                  tipo,
                  fecha_reg,
                  id_usuario_reg,
                  fecha_mod,
                  id_usuario_mod,
                  id_estado_wf,
                  id_proceso_wf,
                  num_tramite,
                  id_depto,
                  id_finalidad,
                  sistema_origen,
                  comprobante_sigma,
                  id_int_comprobante
                  ) values(            
                  (p_hstore->'id_cuenta_bancaria')::integer,
                  (p_hstore->'fecha')::date,
                  upper(translate ((p_hstore->'a_favor')::varchar, 'áéíóúÁÉÍÓÚäëïöüÄËÏÖÜñ', 'aeiouAEIOUaeiouAEIOUÑ')),
                  (p_hstore->'nro_cheque')::integer,
                  (p_hstore->'importe_deposito')::numeric,
                  upper(translate ((p_hstore->'nro_liquidacion')::varchar, 'áéíóúÁÉÍÓÚäëïöüÄËÏÖÜñ', 'aeiouAEIOUaeiouAEIOUÑ')),
                  upper(translate ((p_hstore->'detalle')::varchar, 'áéíóúÁÉÍÓÚäëïöüÄËÏÖÜñ', 'aeiouAEIOUaeiouAEIOUÑ')),
                  (p_hstore->'origen')::varchar,
                  upper(translate ((p_hstore->'observaciones')::varchar, 'áéíóúÁÉÍÓÚäëïöüÄËÏÖÜñ', 'aeiouAEIOUaeiouAEIOUÑ')),
                  (p_hstore->'importe_cheque')::numeric,
                  (p_hstore->'id_libro_bancos_fk')::integer,
                  v_codigo_estado,
                  (p_hstore->'nro_comprobante')::varchar,
                  'activo',
                  (p_hstore->'tipo')::varchar,
                  now(),
                  p_id_usuario,
                  null,
                  null,
                  v_id_estado_wf,
                  v_id_proceso_wf,
                  v_num_tramite,
                  (p_hstore->'id_depto')::integer,				
                  (p_hstore->'id_finalidad')::integer,
                  (p_hstore->'sistema_origen')::varchar,
                  (p_hstore->'comprobante_sigma')::varchar,
                  (p_hstore->'id_int_comprobante')::integer				
                  )RETURNING id_libro_bancos into v_id_libro_bancos;
    		
            END IF;
            	
                 -- inserta documentos en estado borrador si estan configurados
                v_resp_doc =  wf.f_inserta_documento_wf(p_id_usuario, v_id_proceso_wf, v_id_estado_wf);
                -- verificar documentos
                v_resp_doc = wf.f_verifica_documento(p_id_usuario, v_id_estado_wf);
                
             	v_resp = v_id_libro_bancos; 
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