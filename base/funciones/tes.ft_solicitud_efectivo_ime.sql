CREATE OR REPLACE FUNCTION tes.ft_solicitud_efectivo_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Obligaciones de Pago
 FUNCION: 		tes.ft_solicitud_efectivo_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tsolicitud_efectivo'
 AUTOR: 		 (gsarmiento)
 FECHA:	        24-11-2015 12:59:51
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
	v_id_solicitud_efectivo	integer;
    v_codigo_tabla			varchar;
    v_num_sol_efe			varchar;
    v_id_gestion			integer;
    v_id_proceso_macro		integer;
    v_codigo_tipo_proceso	varchar;
    v_num_tramite			varchar;
    v_id_proceso_wf			integer;
    v_id_estado_wf			integer;
    v_codigo_estado			varchar;
    v_id_tipo_estado		integer;
    v_pedir_obs				varchar;
    v_codigo_estado_siguiente	varchar;
	v_obs					varchar;
    v_acceso_directo		varchar;
    v_clase					varchar;
    v_parametros_ad			varchar;
    v_tipo_noti				varchar;
    v_titulo				varchar;
    v_id_estado_actual		integer;
    v_motivo				varchar;
    v_id_funcionario		integer;
    v_id_usuario_reg		integer;
    v_id_depto				integer;
    v_id_estado_wf_ant 		integer;
    v_tipo_ejecucion		varchar;
    		    
BEGIN

    v_nombre_funcion = 'tes.ft_solicitud_efectivo_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_SOLEFE_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		24-11-2015 12:59:51
	***********************************/

	if(p_transaccion='TES_SOLEFE_INS')then
					
        begin
        
         	select pv.codigo into v_codigo_tabla
         	from tes.tcaja pv
         	where pv.id_caja = v_parametros.id_caja;
            
         	-- obtener correlativo
         	v_num_sol_efe =  param.f_obtener_correlativo(
                  'SEFE', 
                   NULL,-- par_id, 
                   NULL, --id_uo 
                   NULL,    -- id_depto
                   p_id_usuario, 
                   'FONROT', 
                   NULL,
                   0,
                   0,
                   'tes.tcaja',
                   v_parametros.id_caja,
                   v_codigo_tabla                   
                   );
                   
        	--fin obtener correlativo
            IF (v_num_sol_efe is NULL or v_num_sol_efe ='') THEN
               raise exception 'No se pudo obtener un numero correlativo para la solicitud efectivo caja consulte con el administrador';
            END IF;
            --obtener id del proceso macro
        
            select 
             pm.id_proceso_macro
            into
             v_id_proceso_macro
            from wf.tproceso_macro pm
            where pm.codigo = 'FR';
                        
            If v_id_proceso_macro is NULL THEN
             raise exception 'El proceso macro  de codigo % no esta configurado en el sistema WF',v_codigo_proceso_macro;  
            END IF;
                        
            
            --   obtener el codigo del tipo_proceso
           
            select   tp.codigo 
                into v_codigo_tipo_proceso
            from  wf.ttipo_proceso tp 
            where   tp.id_proceso_macro = v_id_proceso_macro
                    and tp.estado_reg = 'activo' and tp.inicio = 'si';
                
             
            IF v_codigo_tipo_proceso is NULL THEN
               raise exception 'No existe un proceso inicial para el proceso macro indicado % (Revise la configuración)',v_codigo_proceso_macro;
            END IF;
            
            select 
             ges.id_gestion
            into 
              v_id_gestion
            from param.tgestion ges
            where ges.gestion = (date_part('year', current_date))::integer
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
                   NULL,
                   NULL,
                   v_id_gestion, 
                   v_codigo_tipo_proceso, 
                   NULL,
                   --v_parametros.id_depto,
                   NULL,
                   'Fondo Rotativo ('||v_num_sol_efe||') '::varchar,
                   v_num_sol_efe );
            
            IF(pxp.f_existe_parametro(p_tabla,'motivo'))THEN
            	v_motivo = v_parametros.motivo;
            ELSE
            	v_motivo = NULL;
            END IF;
            
        	--Sentencia de la insercion
        	insert into tes.tsolicitud_efectivo(
			id_caja,
			id_estado_wf,
			monto,
			id_proceso_wf,
			nro_tramite,
			estado,
			estado_reg,
			motivo,
			id_funcionario,
			fecha,
			id_usuario_ai,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_caja,
			v_id_estado_wf,
			v_parametros.monto,
			v_id_proceso_wf,
			v_num_sol_efe,
			v_codigo_estado,
			'activo',
			v_motivo,
			v_parametros.id_funcionario,
			v_parametros.fecha,
			v_parametros._id_usuario_ai,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			null,
			null
							
			
			
			)RETURNING id_solicitud_efectivo into v_id_solicitud_efectivo;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Solicitud Efectivo almacenado(a) con exito (id_solicitud_efectivo'||v_id_solicitud_efectivo||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud_efectivo',v_id_solicitud_efectivo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_SOLEFE_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		24-11-2015 12:59:51
	***********************************/

	elsif(p_transaccion='TES_SOLEFE_MOD')then

		begin
        
        	IF(pxp.f_existe_parametro(p_tabla,'motivo'))THEN
            	v_motivo = v_parametros.motivo;
            ELSE
            	v_motivo = NULL;
            END IF;
            
			--Sentencia de la modificacion
			update tes.tsolicitud_efectivo set
			id_caja = v_parametros.id_caja,
			monto = v_parametros.monto,
			motivo = v_motivo,
			id_funcionario = v_parametros.id_funcionario,
			fecha = v_parametros.fecha,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_solicitud_efectivo=v_parametros.id_solicitud_efectivo;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Solicitud Efectivo modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud_efectivo',v_parametros.id_solicitud_efectivo::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TES_SOLEFE_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		24-11-2015 12:59:51
	***********************************/

	elsif(p_transaccion='TES_SOLEFE_ELI')then

		begin
			--Sentencia de la eliminacion
            --eliminamos el detalle
            delete from tes.tsolicitud_efectivo_det
            where id_solicitud_efectivo=v_parametros.id_solicitud_efectivo;
            
            --eliminamos la cabecera
			delete from tes.tsolicitud_efectivo
            where id_solicitud_efectivo=v_parametros.id_solicitud_efectivo;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Solicitud Efectivo eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud_efectivo',v_parametros.id_solicitud_efectivo::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
    
    /*********************************    
 	#TRANSACCION:  'TES_SIGESOLEFE_IME'
 	#DESCRIPCION:	Transaccion utilizada  pasar a  estados siguientes en solicitud efectivo segun la operacion definida
 	#AUTOR:		GSS
 	#FECHA:		09-12-2015
	***********************************/
    
    elsif(p_transaccion='TES_SIGESOLEFE_IME')then   
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
            se.id_solicitud_efectivo,
            se.id_proceso_wf,
            se.estado--,
       		--se.tipo,
            --pc.id_caja,
            --pc.fecha
        into 
            v_id_solicitud_efectivo,
            v_id_proceso_wf,
            v_codigo_estado--,
            --v_tipo,
            --v_id_caja,
            --v_fecha
        from tes.tsolicitud_efectivo se
        where se.id_proceso_wf  = v_parametros.id_proceso_wf_act;
        
        SELECT cj.tipo_ejecucion into v_tipo_ejecucion
        from tes.tsolicitud_efectivo se
        inner join tes.tcaja cj on cj.id_caja=se.id_caja
        where se.id_solicitud_efectivo=v_id_solicitud_efectivo;
          
          select 
            ew.id_tipo_estado,
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
      	     
             /*
             IF  pxp.f_existe_parametro(p_tabla,'id_depto_wf') THEN
                 
               v_id_depto = v_parametros.id_depto_wf;
                
             END IF;
             */                   
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
             v_titulo  = '';
             
             
             IF   v_codigo_estado_siguiente in('vbcajero')   THEN
                  v_acceso_directo = '../../../sis_tesoreria/vista/solicitud_efectivo/SolicitudEfectivoVb.php';
                  v_clase = 'SolicitudEfectivoVb';
                  v_parametros_ad = '{filtro_directo:{campo:"lb.id_proceso_wf",valor:"'||v_id_proceso_wf::varchar||'"}}';
                  v_tipo_noti = 'notificacion';
                  v_titulo  = 'Visto Bueno Solicitud Efectivo';
             
             END IF;
             
             -- hay que recuperar el supervidor que seria el estado inmediato,...
             v_id_estado_actual =  wf.f_registra_estado_wf(v_parametros.id_tipo_estado, 
                                                             v_parametros.id_funcionario_wf, 
                                                             v_parametros.id_estado_wf_act, 
                                                             v_id_proceso_wf,
                                                             p_id_usuario,
                                                             v_parametros._id_usuario_ai,
                                                             v_parametros._nombre_usuario_ai,
                                                             NULL,
                                                             ' Obs:'||v_obs,
                                                             --NULL,	
                                                             v_acceso_directo,
                                                             --NULL, 	
                                                             v_clase,
                                                             --NULL, 	
                                                             v_parametros_ad,
                                                             --NULL,	
                                                             v_tipo_noti,
                                                             --NULL);	
                                                             v_titulo);
          
          IF   v_codigo_estado_siguiente in ('entregado') and v_tipo_ejecucion = 'con_detalle'  THEN                                                   
          	   IF not tes.f_gestionar_presupuesto_solicitud_efectivo(v_id_solicitud_efectivo, p_id_usuario, 'comprometer')  THEN
                   raise exception 'Error al comprometer el presupeusto';
               END IF;
          END IF;
          
          update tes.tsolicitud_efectivo  s set 
             id_estado_wf =  v_id_estado_actual,
             estado = v_codigo_estado_siguiente,
             id_usuario_mod=p_id_usuario,
             fecha_mod=now()                           
          where id_proceso_wf = v_parametros.id_proceso_wf_act;
                       
		
          -- si hay mas de un estado disponible  preguntamos al usuario
          v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado de la solicitud de efectivo)'); 
          v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');
          
          
          -- Devuelve la respuesta
          return v_resp;
        
     end;
     
 	 /*********************************    
 	#TRANSACCION:  'TES_ANTESOLEFE_IME'
 	#DESCRIPCION:	Transaccion utilizada  pasar a  estados anterior en solicitud efectivo segun la operacion definida
 	#AUTOR:		GSS
 	#FECHA:		15-12-2015
	***********************************/

	elsif(p_transaccion='TES_ANTESOLEFE_IME')then   
        BEGIN
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
          INTO
             v_id_tipo_estado,
             v_id_funcionario,
             v_id_usuario_reg,
             v_id_depto,
             v_codigo_estado,
             v_id_estado_wf_ant 
          FROM wf.f_obtener_estado_ant_log_wf(v_parametros.id_estado_wf);
          
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
             v_tipo_noti = '';
             v_titulo  = '';
             
          v_id_estado_actual = wf.f_registra_estado_wf(
              v_id_tipo_estado, 
              v_id_funcionario, 
              v_parametros.id_estado_wf, 
              v_id_proceso_wf, 
              p_id_usuario,
              v_parametros._id_usuario_ai,
              v_parametros._nombre_usuario_ai,
              v_id_depto,
              '[RETROCESO] ',
              v_acceso_directo,
              v_clase,
              v_parametros_ad,
              v_tipo_noti,
              v_titulo);
           
           IF  NOT tes.f_fun_regreso_solicitud_efectivo_wf(p_id_usuario, 
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
                        
        END;
         
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