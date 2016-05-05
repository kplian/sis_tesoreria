--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.ft_proceso_caja_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Obligaciones de Pago
 FUNCION: 		tes.ft_proceso_caja_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tproceso_caja'
 AUTOR: 		 (gsarmiento)
 FECHA:	        21-12-2015 20:15:22
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
	v_id_proceso_caja		integer;
    v_codigo_tabla			varchar;
    v_num_rendicion			varchar;
    v_registros_trendicion	record;
    v_registros				record;
    v_id_estado_wf			integer;
    v_id_proceso_wf			integer;
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
    v_id_funcionario		integer;
    v_id_usuario_reg		integer;
    v_id_depto				integer;
    v_id_estado_wf_ant		integer;
    v_monto_reposicion		numeric;
    v_codigo_plantilla_cbte		varchar;
    
    v_nombre_conexion			varchar;
    v_id_int_comprobante 		integer;
    v_anho						integer;
    v_id_gestion 				integer;
    v_codigo_documento			varchar;
    v_proceso_pendiente			varchar;
    v_sincronizar				varchar;
    v_num_tramite				varchar;
    		    
BEGIN

    v_nombre_funcion = 'tes.ft_proceso_caja_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#	TRANSACCION:  'TES_REN_INS'
 	#	DESCRIPCION:	Insercion de registros
 	#	AUTOR:		gsarmiento	
 	#	FECHA:		21-12-2015 20:15:22
	***********************************/

	if(p_transaccion='TES_REN_INS')then
					
        begin
        	
             --obtener gestion
             v_anho = (date_part('year', v_parametros.fecha::date))::integer;
        			
              select 
               ges.id_gestion
              into 
                v_id_gestion
              from param.tgestion ges
              where ges.gestion = v_anho
              limit 1 offset 0;
                
              IF  v_id_gestion is null  THEN
                raise exception 'no se encontro una gestion parametrizada para el año %',v_anho;
              END IF;
              
        	--verificar que no existen procesos pendientes de finalizacion por rendicion o reposicion solo deberia existir un proceso
            select pc.nro_tramite into v_proceso_pendiente
            from tes.tproceso_caja pc
            where pc.id_caja=v_parametros.id_caja and pc.tipo in ('RENYREP','RENCYCER','REPO')
            and pc.estado not in ('contabilizado','rendido','cerrado');
        	
            IF v_proceso_pendiente is not null THEN               
               raise exception 'No se puede registra un nuevo proceso caja, existe el proceso % pendiente de finalizacion', v_proceso_pendiente;            
            END IF;
                        
        	select 
               pv.codigo 
            into 
              v_codigo_tabla
         	from tes.tcaja pv
         	where pv.id_caja = v_parametros.id_caja;            
                        
            IF v_parametros.tipo = 'REPO' THEN
            	v_codigo_documento = 'REP';
            ELSIF v_parametros.tipo = 'RENYREP' or  v_parametros.tipo = 'RENYCER' THEN
            	v_codigo_documento = 'REN';
            /*ELSIF v_parametros.tipo = 'REPINI' THEN
            	v_codigo_documento = 'REPINI';*/
            ELSE
                raise exception 'Tipo inexistente %', v_codigo_documento;
            END IF;
            
            v_num_rendicion = param.f_obtener_correlativo(
                   v_codigo_documento, 
                   NULL,-- par_id, 
                   NULL, --id_uo 
                   NULL,    -- id_depto
                   p_id_usuario, 
                   'TES', 
                   NULL,
                   0,
                   0,
                   'tes.tcaja',
                   v_parametros.id_caja,
                   v_codigo_tabla                   
                   );
            
            --fin obtener correlativo
            IF (v_num_rendicion is NULL or v_num_rendicion ='') THEN
               raise exception 'No se pudo obtener un numero correlativo para la rendicion de caja consulte con el administrador';
            END IF;
            
           select tp.codigo, tpc.id_tipo_proceso_caja into v_registros_trendicion
           from  wf.ttipo_proceso tp
           inner join tes.ttipo_proceso_caja tpc on tpc.codigo_wf=tp.codigo
           where tpc.codigo =  v_parametros.tipo::varchar;
           
           IF  v_registros_trendicion.codigo is NULL or v_registros_trendicion.codigo = '' THEN
              
               raise exception 'La rendicion de tipo (%) no tiene un proceso de WF relacionado',v_parametros.tipo;
           
           END IF;           
			--recupera datos de la caja y de su proceso caja de apertura
            select caj.id_proceso_wf, caj.id_estado_wf, c.id_depto, c.codigo, caj.nro_tramite, caj.estado, c.importe_maximo_caja 
            into v_registros
            from tes.tproceso_caja caj
            inner join tes.tcaja c on c.id_caja=caj.id_caja
            where caj.id_caja = v_parametros.id_caja and caj.tipo='apertura';
            
            IF v_parametros.tipo = 'REPO' THEN 
            	v_num_tramite = COALESCE(v_registros.nro_tramite,'');
            END IF;
            
			
            -- inciar el tramite en el sistema de WF
             SELECT 
                   ps_num_tramite ,
                   ps_id_proceso_wf ,
                   ps_id_estado_wf ,
                   ps_codigo_estado 
                into
                   v_num_rendicion,
                   v_id_proceso_wf,
                   v_id_estado_wf,
                   v_codigo_estado   
                      
              FROM wf.f_inicia_tramite(
                   p_id_usuario,
                   NULL,
                   NULL,
                   v_id_gestion, 
                   v_registros_trendicion.codigo, 
                   NULL,
                   v_registros.id_depto,
                   'Solicitud de rendicion para la CAJA: ('||v_num_rendicion||') '::varchar,
                   v_num_rendicion,
                   v_num_rendicion);
            --END IF;  
            v_monto_reposicion=0;
            
            IF(v_parametros.tipo = 'RENYREP')THEN
            	select sum(r.monto) into v_monto_reposicion
                from tes.tsolicitud_rendicion_det r
                inner join tes.tsolicitud_efectivo efe on efe.id_solicitud_efectivo=r.id_solicitud_efectivo
                inner join conta.tdoc_compra_venta d on d.id_doc_compra_venta=r.id_documento_respaldo
                where r.id_proceso_caja is null and efe.id_caja=v_parametros.id_caja
                and d.fecha BETWEEN v_parametros.fecha_inicio and v_parametros.fecha_fin
                and efe.estado='rendido';
            END IF;
            
            IF (v_parametros.tipo = 'REPO') THEN
            	v_monto_reposicion =v_registros.importe_maximo_caja;
            END IF; 
                      
        	--Sentencia de la insercion de la rendicion o reposicion de caja
        	insert into tes.tproceso_caja(
                estado,
                --id_comprobante_diario,
                nro_tramite,
                tipo,
                motivo,
                estado_reg,
                fecha_fin,
                id_caja,
                fecha,
                id_proceso_wf,
                monto_reposicion,
                --id_comprobante_pago,
                id_estado_wf,
                fecha_inicio,
                fecha_reg,
                usuario_ai,
                id_usuario_reg,
                id_usuario_ai,
                fecha_mod,
                id_usuario_mod,
                id_tipo_proceso_caja,
                id_gestion
          	) values(
			v_codigo_estado,
			--v_parametros.id_comprobante_diario,
			v_num_rendicion,
			v_parametros.tipo,
			v_parametros.motivo,
			'activo',
			v_parametros.fecha_fin,
			v_parametros.id_caja,
			v_parametros.fecha,
			v_id_proceso_wf,
			v_monto_reposicion,
			--v_parametros.id_comprobante_pago,
			v_id_estado_wf,
			v_parametros.fecha_inicio,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null,
            v_registros_trendicion.id_tipo_proceso_caja,
            v_id_gestion
			)RETURNING id_proceso_caja into v_id_proceso_caja;
          	
            --asocia las facturas con el proceso caja de la rendicion de caja  
            UPDATE tes.tsolicitud_rendicion_det
            SET id_proceso_caja = v_id_proceso_caja
            WHERE id_solicitud_rendicion_det in (select r.id_solicitud_rendicion_det
                                                from tes.tsolicitud_rendicion_det r
                                                inner join tes.tsolicitud_efectivo efe on efe.id_solicitud_efectivo=r.id_solicitud_efectivo
                                                inner join conta.tdoc_compra_venta d on d.id_doc_compra_venta=r.id_documento_respaldo
                                                where r.id_proceso_caja is null and efe.id_caja=v_parametros.id_caja
                                                and d.fecha BETWEEN v_parametros.fecha_inicio and v_parametros.fecha_fin
                                                and efe.estado='rendido');
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Rendicion Caja almacenado(a) con exito (id_proceso_caja'||v_id_proceso_caja||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_caja',v_id_proceso_caja::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_REN_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		21-12-2015 20:15:22
	***********************************/

	elsif(p_transaccion='TES_REN_MOD')then

		begin
			
            --Sentencia de la modificacion
			update tes.tproceso_caja set
              estado = v_parametros.estado,
              --id_comprobante_diario = v_parametros.id_comprobante_diario,
              nro_tramite = v_parametros.nro_tramite,
              tipo = v_parametros.tipo,
              motivo = v_parametros.motivo,
              fecha_fin = v_parametros.fecha_fin,
              id_caja = v_parametros.id_caja,
              fecha = v_parametros.fecha,
              --id_proceso_wf = v_parametros.id_proceso_wf,
              monto_reposicion = v_parametros.monto_reposicion,
              --id_comprobante_pago = v_parametros.id_comprobante_pago,
              --id_estado_wf = v_parametros.id_estado_wf,
              fecha_inicio = v_parametros.fecha_inicio,
              fecha_mod = now(),
              id_usuario_mod = p_id_usuario,
              id_usuario_ai = v_parametros._id_usuario_ai,
              usuario_ai = v_parametros._nombre_usuario_ai
			where id_proceso_caja=v_parametros.id_proceso_caja;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Rendicion Caja modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_caja',v_parametros.id_proceso_caja::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TES_REN_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		21-12-2015 20:15:22
	***********************************/

	elsif(p_transaccion='TES_REN_ELI')then

		begin
			--Sentencia de la eliminacion			
            UPDATE tes.tsolicitud_rendicion_det
            SET id_proceso_caja = NULL
            WHERE id_proceso_caja = v_parametros.id_proceso_caja;
            
            delete from tes.tproceso_caja
            where id_proceso_caja=v_parametros.id_proceso_caja;
              
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Rendicion Caja eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_caja',v_parametros.id_proceso_caja::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
    
    /*********************************    
 	#TRANSACCION:  'TES_SIGEREN_IME'
 	#DESCRIPCION:	Transaccion utilizada  pasar a  estados siguientes en proceso caja segun la rendicion definida
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		23-12-2015
	***********************************/
    
    elsif(p_transaccion='TES_SIGEREN_IME')then   
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
            pc.id_proceso_caja,
            pc.id_proceso_wf,
            pc.estado,
            tpc.codigo_plantilla_cbte
        into 
            v_id_proceso_caja,
            v_id_proceso_wf,
            v_codigo_estado,
            v_codigo_plantilla_cbte
            
        from tes.tproceso_caja pc
        inner join tes.ttipo_proceso_caja tpc on tpc.id_tipo_proceso_caja = pc.id_tipo_proceso_caja
        where pc.id_proceso_wf = v_parametros.id_proceso_wf_act;
        
        
       
        
        
          
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
             v_titulo  = '';
             
             /*
             IF   v_codigo_estado_siguiente in('vbpagosindocumento')   THEN
                  v_acceso_directo = '../../../sis_workflow/vista/proceso_wf/VoBoProceso.php';
                  v_clase = 'VoBoProceso';
                  v_parametros_ad = '{filtro_directo:{campo:"lb.id_proceso_wf",valor:"'||v_id_proceso_wf::varchar||'"}}';
                  v_tipo_noti = 'notificacion';
                  v_titulo  = 'Visto Bueno';
             
             END IF;
             */
             
             -- hay que recuperar el supervidor que seria el estado inmediato,...
             v_id_estado_actual =  wf.f_registra_estado_wf(v_parametros.id_tipo_estado, 
                                                             v_parametros.id_funcionario_wf, 
                                                             v_parametros.id_estado_wf_act, 
                                                             v_id_proceso_wf,
                                                             p_id_usuario,
                                                             v_parametros._id_usuario_ai,
                                                             v_parametros._nombre_usuario_ai,
                                                             v_id_depto,
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
          
          update tes.tproceso_caja  p set 
             id_estado_wf =  v_id_estado_actual,
             estado = v_codigo_estado_siguiente,
             id_usuario_mod=p_id_usuario,
             fecha_mod=now()                           
          where id_proceso_wf = v_parametros.id_proceso_wf_act;
          
           IF v_codigo_estado_siguiente in ('supconta','vbfondos') THEN
                
                update tes.tproceso_caja  p set 
                 id_depto_conta = v_id_depto           
                where id_proceso_wf = v_parametros.id_proceso_wf_act;  
                        
          END IF;	
                       
		  IF v_codigo_estado_siguiente = 'pendiente' THEN
                
                update tes.tproceso_caja  p set 
                 id_cuenta_bancaria=v_parametros.id_cuenta_bancaria           
                where id_proceso_wf = v_parametros.id_proceso_wf_act;          
          	
            
                --TODO
                 v_sincronizar = pxp.f_get_variable_global('sincronizar');
                 --  generacion de comprobante
                IF (v_sincronizar = 'true') THEN  
                  select * into v_nombre_conexion from migra.f_crear_conexion();     
                END IF;
                
                 
                --  Si NO  se contabiliza nacionalmente
                v_id_int_comprobante =   conta.f_gen_comprobante ( 
                                                     v_id_proceso_caja , 
                                                     v_codigo_plantilla_cbte ,
                                                     p_id_usuario,
                                                     v_parametros._id_usuario_ai, 
                                                     v_parametros._nombre_usuario_ai, 
                                                     v_nombre_conexion);
            
          
                 
                
                update tes.tproceso_caja  p set 
                    id_int_comprobante = v_id_int_comprobante          
                where id_proceso_wf = v_parametros.id_proceso_wf_act;          
                    	
                IF (v_sincronizar = 'true') THEN  
                  select * into v_resp from migra.f_cerrar_conexion(v_nombre_conexion,'exito'); 
                 END IF;
            
          END IF;
          -- si hay mas de un estado disponible  preguntamos al usuario
          v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado del proceso caja)'); 
          v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');
          
          
          -- Devuelve la respuesta
          return v_resp;
        
     end;
     
    /*********************************    
 	#TRANSACCION:  'TES_ANTEREN_IME'
 	#DESCRIPCION:	Transaccion utilizada  pasar a  estados anterior en proceso caja segun la operacion definida
 	#AUTOR:		GSS
 	#FECHA:		28-12-2015
	***********************************/

	elsif(p_transaccion='TES_ANTEREN_IME')then   
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
          
          -- configurar acceso directo para la alarma   
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
           
           IF  NOT tes.f_fun_regreso_proceso_caja_wf(p_id_usuario, 
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
                              
           -- Devuelve la respuesta
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