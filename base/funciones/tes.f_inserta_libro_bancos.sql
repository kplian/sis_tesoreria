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

 ISSUE            FECHA:		      AUTOR                 DESCRIPCION

 #67        		14-08-2020        MZM KPLIAN        		insertar id_proveedor en libro bancos para cheques a proveedores
 #67				03.09.2020		  MZM KPLIAN        		ampliar y generalizar el registro de correo para todos los origenes de LB
 #ETR-1294			12/10/2020	  	  manuel guerra				cambiar el tipo bigint al campo nro_deposito
 #ETR-1396			15/10/2020		  MANUEL GUERRA				AGREGAR VALIDACION DE VALORES NULOS
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
    v_id_proveedor	integer;
    v_detalle record;
    v_tabla varchar;
    v_campo	varchar;
    v_id	integer;
    v_correo varchar;
    v_nro_deposito_aux BIGINT;
    		    
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
						 and per.id_gestion is not null
                         limit 1 offset 0;
		
		if(v_id_periodo is null)then
        	raise exception 'No existe periodo para la fecha %', g_fecha;
        end if;        
        
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
		--si es un ingreso independiente de otros sistemas
        -- 28 /04/2018  RAC - KPLIAN
        --Modificamos esta condiciones, siempre que tenga comprobante el proceso se generara de maneras disparada
        -- 
         
		IF (p_hstore->'id_int_comprobante')::int4 is null THEN
        
        
           --RAC  04/05/2018
            --raise exception 'Todo registro de libro de bancos  tiene que originarce desde un comprobante, ya no son permitidos los registros manuales';
        
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
            	--si es un registro disparado por otros sistemas
            	/*
                select pp.id_estado_wf, op.num_tramite into v_id_estado_wf_anterior, v_num_tramite
                from tes.tplan_pago pp
                inner join tes.tobligacion_pago op on op.id_obligacion_pago=pp.id_obligacion_pago
                where pp.id_int_comprobante=(p_hstore->'id_int_comprobante')::int4 and pp.estado in ('pagado','contabilizado','devengado','devuelto');  
                */
                select cp.id_estado_wf, cp.nro_tramite into v_id_estado_wf_anterior, v_num_tramite
                from conta.tint_comprobante cp
                --inner join tes.tobligacion_pago op on op.id_obligacion_pago=pp.id_obligacion_pago
                where cp.id_int_comprobante=(p_hstore->'id_int_comprobante')::int4;  
                                
                IF v_id_estado_wf_anterior IS NULL THEN
                	raise exception 'No existe estado wf para ejecutar el disparador en el workflow';
                END IF;
                
                select id_depto into v_id_depto
				from tes.tdepto_cuenta_bancaria
				where id_cuenta_bancaria=(p_hstore->'id_cuenta_bancaria')::int4;
                
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

			--14.08.2020
/*			select ob.id_proveedor 
            into v_id_proveedor
            from  conta.tint_comprobante cbte 
            inner join tes.tplan_pago pp on pp.id_int_comprobante=cbte.id_int_comprobante
            inner join tes.tobligacion_pago ob on ob.id_obligacion_pago=pp.id_obligacion_pago
            inner join param.vproveedor prov on prov.id_proveedor=ob.id_proveedor
            where cbte.id_int_comprobante=(p_hstore->'id_int_comprobante')::integer;*/
            

            
         select a.* into v_detalle from ( (select distinct   t.id_auxiliar ,0 as id_proveedor, a.codigo_auxiliar,
            t.id_int_comprobante, 1 as orden
            from conta.tint_transaccion t 
            inner join conta.tauxiliar a on t.id_auxiliar=a.id_auxiliar  and t.id_int_comprobante=(p_hstore->'id_int_comprobante')::integer
            and ( a.codigo_auxiliar like 'FUN%' 
            or a.codigo_auxiliar like 'ODT%'))
		    union            
            ( select distinct   t.id_auxiliar , p.id_proveedor, a.codigo_auxiliar,
            t.id_int_comprobante, 2 as orden
            from conta.tint_transaccion t 
            inner join conta.tauxiliar a on t.id_auxiliar=a.id_auxiliar  and t.id_int_comprobante=(p_hstore->'id_int_comprobante')::integer
            inner join param.tproveedor p on p.id_auxiliar = a.id_auxiliar 
             )) as a  order by a.orden limit 1;
            
			--if (v_detalle.codigo_auxiliar is not null) then
                if (v_detalle.codigo_auxiliar like 'FUN%' 
                    or v_detalle.codigo_auxiliar like 'ODT%') then  -- es funcionario
                    --validamos q este activo
                    select id_funcionario , email_empresa
                    into v_id_proveedor,v_correo
                    from orga.tfuncionario where codigo=v_detalle.codigo_auxiliar;

                    if (v_id_proveedor is not null) then
                        if (plani.f_es_funcionario_vigente(v_id_proveedor, now()::date)) then
                        	v_tabla='orga.tfuncionario' ;
	    					v_campo='id_funcionario'	;
    						v_id=v_id_proveedor	;
                        end if;
                    else
                    	raise exception 'el auxiliar es de un funcionario pero el mismo no existe';
                    end if;
                else
                	if(v_detalle.id_proveedor is not null) then
                      select email,  id_proveedor
                      into v_correo, v_id
                      from param.vproveedor  where id_proveedor=v_detalle.id_proveedor;
                      
                      v_tabla='param.tproveedor' ;
                      v_campo='id_proveedor'	;
    				
					end if;
                end if;                    
            
            if (p_hstore->'correo_proveedor' is not null and length(p_hstore->'correo_proveedor')!=0 ) then
               v_correo:=p_hstore->'correo_proveedor';
            end if;
            
            --si no encontro nada es q no es funcionario ni proveedor, intentamos ubicar de los registros historicos de libro_bancos
            if (v_correo is null ) then
            
            	select correo into v_correo from tes.tts_libro_bancos where 
                upper(a_favor)= upper(translate ((rtrim(p_hstore->'a_favor'))::varchar, 'áéíóúÁÉÍÓÚäëïöüÄËÏÖÜñ', 'aeiouAEIOUaeiouAEIOUÑ'))
                order by id_libro_bancos desc limit 1;
             end if;
			--#ETR-1396
			if (p_hstore->'nro_deposito' is null or length(p_hstore->'nro_deposito')=0 ) then
               	v_nro_deposito_aux=null;
            ELSE
            	v_nro_deposito_aux=(p_hstore->'nro_deposito');
            end if;
            
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
                id_int_comprobante,
                nro_deposito  --#ETR-1294
                --,id_proveedor --14.08.2020
                ,tabla_correo,
                columna_correo,
                id_columna_correo,
                correo
                
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
                (p_hstore->'id_int_comprobante')::integer,				
                v_nro_deposito_aux--(p_hstore->'nro_deposito')::bigint  --#ETR-1294
                --,v_id_proveedor --14082020
                ,v_tabla,
                v_campo,
                v_id,
                v_correo
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
                  id_int_comprobante,
                  nro_deposito     --#ETR-1294
                  --,id_proveedor --14082020
                  ,tabla_correo,
                  columna_correo,
                  id_columna_correo,
                  correo
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
                  (p_hstore->'id_int_comprobante')::integer,
                  v_nro_deposito_aux--(p_hstore->'nro_deposito')::bigint	 --#ETR-1294
                  --,v_id_proveedor --14082020			
                   ,v_tabla,
                  v_campo,
                  v_id,
                  v_correo
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
PARALLEL UNSAFE
COST 100;