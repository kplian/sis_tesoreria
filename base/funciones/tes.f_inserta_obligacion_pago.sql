CREATE OR REPLACE FUNCTION tes.f_inserta_obligacion_pago (
  p_administrador integer,
  p_id_usuario integer,
  p_hstore public.hstore
)
RETURNS varchar AS'
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		tes.f_inserta_obligacion_pago
 DESCRIPCION:   Inserta registro de cotizacionf
 AUTOR: 		Rensi Arteaga COpar
 FECHA:	        31-10-2014
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

    
    v_resp		            	varchar;
	v_nombre_funcion        	text;
	v_mensaje_error         	text;
    
    v_id_periodo 				integer;
    v_tipo_documento  			varchar;
    v_parametros record;
    v_codigo_proceso_macro 		varchar; 
    v_num  						varchar; 
    v_resp_doc     				boolean;
    va_id_funcionario_gerente   INTEGER[]; 
    v_id_proceso_macro 			integer;
    v_codigo_tipo_proceso 		varchar;
    v_anho 						integer;
    v_id_gestion 				integer;
    v_id_subsistema 			integer; 
    v_num_tramite  				varchar;
    v_id_proceso_wf 			integer;
    v_id_estado_wf 				integer;
    v_codigo_estado 			varchar;
    v_codigo_estado_ant 		varchar;   
    v_id_obligacion_pago 		integer; 
    v_registros_documento 		record;
    v_registros_con 			record; 
    v_id_documento_wf_op 		integer;
    
  
 
     
			    
BEGIN

    v_nombre_funcion = ''f_inserta_obligacion_pago'';

    /*
    HSTORE  PARAMETERS
            (p_hstore->''fecha'')::date
            (p_hstore->''tipo_obligacion'')::varchar
            (p_hstore->''id_funcionario'')::integer
            (p_hstore->''_id_usuario_ai'')::integer,
            (p_hstore->''_nombre_usuario_ai'')::varchar,
            (p_hstore->''id_funcionario'')::integer,
            (p_hstore->''id_depto'')::integer,
            (p_hstore->''obs'')::varchar,
            (p_hstore->''id_proveedor'')::integer,
			(p_hstore->''tipo_obligacion'')::varchar,
			(p_hstore->''id_moneda'')::integer,
			(p_hstore->''obs'')::varchar,
			(p_hstore->''id_funcionario'')::integer,
			(p_hstore->''id_depto'')::integer,
			(p_hstore->''tipo_cambio_conv'')::numeric,
            (p_hstore->''pago_variable'')::varchar,
            (p_hstore->''total_nro_cuota'')::integer,
            (p_hstore->''fecha_pp_ini'')::date,
            (p_hstore->''rotacion'')::integer,
            (p_hstore->''id_plantilla'')::integer,
            (p_hstore->''_id_usuario_ai'')::integer,
            (p_hstore->''_nombre_usuario_ai'')::varchar,
            (p_hstore->''tipo_anticipo'')::varchar,
    
    */
    
    if ((p_hstore->''fecha'')::date < ''01-01-2015'' and p_administrador = 0) then
    	raise exception ''No se puede hacer una solicitud con gestion 2014, porfavor consulte con el administrador'';
    end if;

    --determina la fecha del periodo
        
         select id_periodo into v_id_periodo from
                        param.tperiodo per 
                       where per.fecha_ini <= (p_hstore->''fecha'')::date 
                         and per.fecha_fin >= (p_hstore->''fecha'')::date
                         limit 1 offset 0;
        
        
        IF   (p_hstore->''tipo_obligacion'')::varchar = ''adquisiciones''    THEN
             raise exception ''Los pagos de adquisiciones tienen que ser habilitados desde el sistema de adquisiciones'';   
       
        ELSIF   (p_hstore->''tipo_obligacion'')::varchar =''pago_directo''    THEN
              
                v_tipo_documento = ''PGD'';
                
                  --obtener correlativo
                 v_num =   param.f_obtener_correlativo(
                          ''PGD'', 
                           v_id_periodo,-- par_id, 
                           NULL, --id_uo 
                           (p_hstore->''id_depto'')::integer,    -- id_depto
                           p_id_usuario, 
                           ''TES'', 
                           NULL);
                           
        
                v_codigo_proceso_macro = ''TES-PD''; 
                
                --si el funcionario que solicita es un gerente .... es el mimso encargado de aprobar
                
                 IF exists(select 1 from orga.tuo_funcionario uof 
                           inner join orga.tuo uo on uo.id_uo = uof.id_uo and uo.estado_reg = ''activo''
                           inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional and no.numero_nivel in (1,2)
                           where  uof.estado_reg = ''activo'' and  uof.id_funcionario = (p_hstore->''id_funcionario'')::integer ) THEN
                  
                      va_id_funcionario_gerente[1] = (p_hstore->''id_funcionario'')::integer;
                 
                 ELSE
                    --si tiene funcionario identificar el gerente correspondientes
                    IF (p_hstore->''id_funcionario'')::integer  is not NULL THEN
                    
                        SELECT  
                           pxp.aggarray(id_funcionario) 
                         into
                           va_id_funcionario_gerente
                         FROM orga.f_get_aprobadores_x_funcionario((p_hstore->''fecha'')::date,  (p_hstore->''id_funcionario'')::integer , ''todos'', ''si'', ''todos'', ''ninguno'') AS (id_funcionario integer);      
                        --NOTA el valor en la primera posicion del array es el genre de menor nivel
                    END IF;  
                END IF;
                       
              
        ELSE
          
          raise exception ''falta agregar la funcionalidad''; 
              
        END IF;
       
       
        IF (v_num is NULL or v_num ='''') THEN
        
          raise exception ''No se pudo obtener un numero correlativo para la obligación'';
        
        END IF;
        
        --obtener id del proceso macro
        
        select 
         pm.id_proceso_macro
        into
         v_id_proceso_macro
        from wf.tproceso_macro pm
        where pm.codigo = v_codigo_proceso_macro;
        
        
        If v_id_proceso_macro is NULL THEN
        
           raise exception ''El proceso macro  de codigo % no esta configurado en el sistema WF'',v_codigo_proceso_macro;  
        
        END IF;
        
        
        
        
        
        
        
        --   obtener el codigo del tipo_proceso
       
        select   tp.codigo 
            into v_codigo_tipo_proceso
        from  wf.ttipo_proceso tp 
        where   tp.id_proceso_macro = v_id_proceso_macro
                and tp.estado_reg = ''activo'' and tp.inicio = ''si'';
            
         
        IF v_codigo_tipo_proceso is NULL THEN
        
           raise exception ''No existe un proceso inicial para el proceso macro indicado % (Revise la configuración)'',v_codigo_proceso_macro;
        
        END IF;
        
        
        v_anho = (date_part(''year'', (p_hstore->''fecha'')::date))::integer;
			
            select 
             ges.id_gestion
             into v_id_gestion
            from param.tgestion ges
            where ges.gestion = v_anho
            limit 1 offset 0;
       
       --id_subsistema
       
       select
       s.id_subsistema
       into 
       v_id_subsistema
       from segu.tsubsistema s where s.codigo = ''ADQ'';
    
        
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
               (p_hstore->''_id_usuario_ai'')::integer,
               (p_hstore->''_nombre_usuario_ai'')::varchar,
               v_id_gestion, 
               v_codigo_tipo_proceso, 
               (p_hstore->''id_funcionario'')::integer,
               (p_hstore->''id_depto'')::integer,
               ''Obligacion de pago (''||v_num||'') ''||(p_hstore->''obs'')::varchar,
               v_num );
            
           
            -- raise exception ''estado %'',v_codigo_estado;
             
      
        	--Sentencia de la insercion
        	insert into tes.tobligacion_pago(
			id_proveedor,
			estado,
			tipo_obligacion,
			id_moneda,
			obs,
			--porc_retgar,
			id_subsistema,
			id_funcionario,
			estado_reg,
			--porc_anticipo,
			id_estado_wf,
			id_depto,
			num_tramite,
			id_proceso_wf,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod,
            numero,
            fecha,
            id_gestion,
            tipo_cambio_conv,
            pago_variable,
            total_nro_cuota,
            fecha_pp_ini,
            rotacion,
            id_plantilla,
            id_usuario_ai,
            usuario_ai,
            tipo_anticipo,
            id_funcionario_gerente,
            id_contrato
            
          	) values(
			(p_hstore->''id_proveedor'')::integer,
			v_codigo_estado,
			(p_hstore->''tipo_obligacion'')::varchar,
			(p_hstore->''id_moneda'')::integer,
			(p_hstore->''obs'')::varchar,
			--v_parametros.porc_retgar,
			v_id_subsistema,
			(p_hstore->''id_funcionario'')::integer,
			''activo'',
			--v_parametros.porc_anticipo,
			v_id_estado_wf,
			(p_hstore->''id_depto'')::integer,
			v_num_tramite,
			v_id_proceso_wf,
			now(),
			p_id_usuario,
			null,
			null,
            v_num,
            (p_hstore->''fecha'')::date,
            v_id_gestion,
            (p_hstore->''tipo_cambio_conv'')::numeric,
            (p_hstore->''pago_variable'')::varchar,
            (p_hstore->''total_nro_cuota'')::integer,
            (p_hstore->''fecha_pp_ini'')::date,
            (p_hstore->''rotacion'')::integer,
            (p_hstore->''id_plantilla'')::integer,
            (p_hstore->''_id_usuario_ai'')::integer,
            (p_hstore->''_nombre_usuario_ai'')::varchar,
            (p_hstore->''tipo_anticipo'')::varchar,
             va_id_funcionario_gerente[1],
            (p_hstore->''id_contrato'')::integer
							
			)RETURNING id_obligacion_pago into v_id_obligacion_pago;
            
            
             -- inserta documentos en estado borrador si estan configurados
            v_resp_doc =  wf.f_inserta_documento_wf(p_id_usuario, v_id_proceso_wf, v_id_estado_wf);
            -- verificar documentos
            v_resp_doc = wf.f_verifica_documento(p_id_usuario, v_id_estado_wf);
            
            -------------------------------------
            -- COPIA CONTRATOS
            -------------------------------------
            
            --  Si el la referencia al contrato esta presente ..  copiar el documento de contrato
            IF (p_hstore->''id_contrato'')::integer  is not  NULL THEN
                 --con el ide de contrato obtenet el id_proceso_wf
                 SELECT
                   con.id_proceso_wf,
                   con.numero,
                   con.estado,
                   pwf.nro_tramite
                 INTO
                  v_registros_con
                 FROM leg.tcontrato con
                 INNER JOIN wf.tproceso_wf pwf on pwf.id_proceso_wf = con.id_proceso_wf
                 WHERE con.id_contrato = (p_hstore->''id_contrato'')::integer;
                
                  -- octenemos el documentos constro del origen
               
                  SELECT
                    *
                  into
                   v_registros_documento
                  FROM wf.tdocumento_wf d
                  INNER JOIN wf.ttipo_documento td on td.id_tipo_documento = d.id_tipo_documento
                  WHERE td.codigo = ''CONTRATO'' and 
                        d.id_proceso_wf = v_registros_con.id_proceso_wf;
                 
                   -- copiamos el link de referencia del contrato de la obligacion de pago
                     select
                     dwf.id_documento_wf
                    into
                     v_id_documento_wf_op
                    from wf.tdocumento_wf dwf
                    inner  join  wf.ttipo_documento td on td.id_tipo_documento = dwf.id_tipo_documento
                    where td.codigo = ''CONTRATO''  and dwf.id_proceso_wf = v_id_proceso_wf;
                 
                    UPDATE 
                      wf.tdocumento_wf  
                    SET 
                       id_usuario_mod = p_id_usuario,
                       fecha_mod = now(),
                       chequeado = v_registros_documento.chequeado,
                       url = v_registros_documento.url,
                       extension = v_registros_documento.extension,
                       obs = v_registros_documento.obs,
                       chequeado_fisico = v_registros_documento.chequeado_fisico,
                       id_usuario_upload = v_registros_documento.id_usuario_upload,
                       fecha_upload = v_registros_documento.fecha_upload,
                       id_proceso_wf_ori = v_registros_documento.id_proceso_wf,
                       id_documento_wf_ori = v_registros_documento.id_documento_wf,
                       nro_tramite_ori = v_registros_con.nro_tramite
                    WHERE 
                      id_documento_wf = v_id_documento_wf_op;    
                
            
            END IF;
            
             --Definicion de la respuesta
			 v_resp = pxp.f_agrega_clave(v_resp,''mensaje'',''Obligaciones de Pago almacenado(a) con exito (id_obligacion_pago''||v_id_obligacion_pago||'')''); 
             v_resp = pxp.f_agrega_clave(v_resp,''id_obligacion_pago'',v_id_obligacion_pago::varchar);
             v_resp = pxp.f_agrega_clave(v_resp,''id_gestion'',v_id_gestion::varchar);

            --Devuelve la respuesta
            return v_resp;
			
			




EXCEPTION
				
	WHEN OTHERS THEN
		v_resp='''';
		v_resp = pxp.f_agrega_clave(v_resp,''mensaje'',SQLERRM);
		v_resp = pxp.f_agrega_clave(v_resp,''codigo_error'',SQLSTATE);
		v_resp = pxp.f_agrega_clave(v_resp,''procedimientos'',v_nombre_funcion);
		raise exception ''%'',v_resp;
				        
END;
'LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;