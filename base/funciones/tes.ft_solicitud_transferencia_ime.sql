--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.ft_solicitud_transferencia_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.ft_solicitud_transferencia_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tsolicitud_transferencia'
 AUTOR: 		 (admin)
 FECHA:	        22-02-2018 03:43:11
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				22-02-2018 03:43:11								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tsolicitud_transferencia'	
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_solicitud_transferencia	integer;
	v_codigo_tipo_proceso	varchar;
	v_id_proceso_macro		integer;
	v_num_tramite			varchar;
	v_id_proceso_wf			integer;
	v_id_estado_wf			integer;
	v_codigo_estado			varchar;
	v_id_gestion			integer;
    v_id_tipo_estado		integer;
    v_id_funcionario		integer;
    v_id_usuario_reg		integer;
    v_id_depto				integer; 
    v_id_estado_wf_ant		integer; 
    v_acceso_directo		varchar; 
    v_clase					varchar;
    v_parametros_ad			varchar;
    v_tipo_noti				varchar;
    v_titulo				varchar;
    v_id_estado_actual		integer;
    v_solicitud				record;
	v_pedir_obs				varchar;
    v_codigo_estado_siguiente	varchar;
    v_obs					varchar;
    v_id_int_comprobante	integer;
			    
BEGIN

    v_nombre_funcion = 'tes.ft_solicitud_transferencia_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_SOLTRA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-02-2018 03:43:11
	***********************************/

	if(p_transaccion='TES_SOLTRA_INS')then
					
        begin
        	select   tp.codigo, pm.id_proceso_macro 
            into v_codigo_tipo_proceso, v_id_proceso_macro
	        from  wf.tproceso_macro pm
	        inner join wf.ttipo_proceso tp
	        	on tp.id_proceso_macro = pm.id_proceso_macro
	        where   tp.codigo = 'SOLTRA'
	                and tp.estado_reg = 'activo' and tp.inicio = 'si';
	                
	        
	        IF v_codigo_tipo_proceso is NULL THEN
        
	           raise exception 'No existe un proceso inicial para el proceso macro indicado (Revise la configuración)';
	        
	        END IF;
	        
	        select nextval('tes.tsolicitud_transferencia_id_solicitud_transferencia_seq') into v_id_solicitud_transferencia;
	        
	        select id_gestion into v_id_gestion
	        from param.tgestion
	        where gestion = to_char(now(),'YYYY')::numeric;
	        
	        -- inciiar el tramite en el sistema de WF
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
	             v_parametros._id_usuario_ai,
	             v_parametros._nombre_usuario_ai,
	             v_id_gestion, 
	             v_codigo_tipo_proceso, 
	             NULL,
	             NULL,
	             'Solicitud '||v_id_solicitud_transferencia,
	             v_id_solicitud_transferencia::varchar);
                
                
        	--Sentencia de la insercion
        	insert into tes.tsolicitud_transferencia(
        	id_solicitud_transferencia,
			id_cuenta_origen,
			id_cuenta_destino,
			id_proceso_wf,
			id_estado_wf,
			monto,
			motivo,
			num_tramite,
			estado_reg,
			estado,
			id_usuario_ai,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
          	v_id_solicitud_transferencia,
			v_parametros.id_cuenta_origen,
			v_parametros.id_cuenta_destino,
			v_id_proceso_wf,
			v_id_estado_wf,
			v_parametros.monto,
			v_parametros.motivo,
			v_num_tramite,
			'activo',
			v_codigo_estado,
			v_parametros._id_usuario_ai,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			null,
			null
							
			
			
			);
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Solicitud Transferencia almacenado(a) con exito (id_solicitud_transferencia'||v_id_solicitud_transferencia||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud_transferencia',v_id_solicitud_transferencia::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_SOLTRA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-02-2018 03:43:11
	***********************************/

	elsif(p_transaccion='TES_SOLTRA_MOD')then

		begin
			--Sentencia de la modificacion
			update tes.tsolicitud_transferencia set
			id_cuenta_origen = v_parametros.id_cuenta_origen,
			id_cuenta_destino = v_parametros.id_cuenta_destino,			
			monto = v_parametros.monto,
			motivo = v_parametros.motivo,			
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_solicitud_transferencia=v_parametros.id_solicitud_transferencia;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Solicitud Transferencia modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud_transferencia',v_parametros.id_solicitud_transferencia::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TES_SOLTRA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-02-2018 03:43:11
	***********************************/

	elsif(p_transaccion='TES_SOLTRA_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from tes.tsolicitud_transferencia
            where id_solicitud_transferencia=v_parametros.id_solicitud_transferencia;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Solicitud Transferencia eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud_transferencia',v_parametros.id_solicitud_transferencia::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
	
	/*********************************    
 	#TRANSACCION:  'TES_ANTSOLTRA_IME'
 	#DESCRIPCION:	Transaccion utilizada  pasar a  estados anterior en la solicitud
                    segun la operacion definida
 	#AUTOR:		JRR	
 	#FECHA:		17-10-2014 12:12:51
	***********************************/

	elseif(p_transaccion='TES_ANTSOLTRA_IME')then   
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
             v_titulo  = 'Notificacion'; 
          
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
                      
         
          --actualizar estado solicitud
          update tes.tsolicitud_transferencia
          set estado = v_codigo_estado,
          id_estado_wf = v_id_estado_actual
          where id_proceso_wf = v_id_proceso_wf;
                         
                       
                         
                         
         -- si hay mas de un estado disponible  preguntamos al usuario
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');
                        
                              
          --Devuelve la respuesta
            return v_resp;
                        
           
        
        
        
        end;	
    
     /*********************************    
 	#TRANSACCION:  'TES_SIGSOLTRA_IME'
 	#DESCRIPCION:	funcion que controla el cambio al Siguiente estado de las solicitudes, integrado  con el WF
 	#AUTOR:		JRR	
 	#FECHA:		17-10-2014 12:12:51
	***********************************/

	elseif(p_transaccion='TES_SIGSOLTRA_IME')then   
        begin
        	
              
            select sol.*
            into v_solicitud
            from tes.tsolicitud_transferencia sol     
            where id_proceso_wf = v_parametros.id_proceso_wf_act;
            
            
      
              select 
                ew.id_tipo_estado ,
                te.pedir_obs,
                ew.id_estado_wf
               into 
                v_id_tipo_estado,
                v_pedir_obs,
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
             
           
             
             
             
             -- hay que recuperar el supervidor que seria el estado inmediato,...
             v_id_estado_actual =  wf.f_registra_estado_wf(v_parametros.id_tipo_estado, 
                                                             v_parametros.id_funcionario_wf, 
                                                             v_parametros.id_estado_wf_act, 
                                                             v_parametros.id_proceso_wf_act,
                                                             p_id_usuario,
                                                             v_parametros._id_usuario_ai,
                                                             v_parametros._nombre_usuario_ai,
                                                             v_id_depto,
                                                             COALESCE(v_solicitud.num_tramite,'--')||' Obs:'||v_obs,
                                                             v_acceso_directo ,
                                                             v_clase,
                                                             v_parametros_ad,
                                                             v_tipo_noti,
                                                             v_titulo);
          
         
          
           -- funcion para generar comprobante si corresponde
           if (v_codigo_estado_siguiente = 'validado') then
              if (v_solicitud.id_cuenta_origen is null) then
                  raise exception 'Debe registrar la cuenta origen antes de aprobar la solicitud';
              end if;  
              v_id_int_comprobante =   conta.f_gen_comprobante (v_solicitud.id_solicitud_transferencia,'TESOLTRA',v_id_estado_actual,p_id_usuario,v_solicitud.id_usuario_ai,v_solicitud.usuario_ai, NULL); 
           end if;     
          -- actualiza estado en la solicitud
          update tes.tsolicitud_transferencia
          set estado = v_codigo_estado_siguiente,
          id_estado_wf = v_id_estado_actual,
          id_int_comprobante = v_id_int_comprobante
          where id_proceso_wf = v_parametros.id_proceso_wf_act; 
          
          -- si hay mas de un estado disponible  preguntamos al usuario
          v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado de la planilla)'); 
          v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');
          
          
          -- Devuelve la respuesta
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