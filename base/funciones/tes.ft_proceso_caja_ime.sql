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
	v_id_proceso_caja	integer;
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
    		    
BEGIN

    v_nombre_funcion = 'tes.ft_proceso_caja_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_REN_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		21-12-2015 20:15:22
	***********************************/

	if(p_transaccion='TES_REN_INS')then
					
        begin
        	select pv.codigo into v_codigo_tabla
         	from tes.tcaja pv
         	where pv.id_caja = v_parametros.id_caja;            
            
            v_num_rendicion = param.f_obtener_correlativo(
                  'REN', 
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
            
            select 
            tp.codigo
           into
           v_registros_trendicion
           from  wf.ttipo_proceso tp
           where tp.codigo_llave =  v_parametros.tipo::varchar; 
           
           IF  v_registros_trendicion.codigo is NULL or v_registros_trendicion.codigo = '' THEN
              
               raise exception 'La rendicion de tipo (%) no tiene un proceso de WF relacionado',v_parametros.tipo;
           
           END IF;           

            select caj.id_proceso_wf, caj.id_estado_wf, c.id_depto, c.codigo, caj.nro_tramite, caj.estado 
            into v_registros
            from tes.tproceso_caja caj
            inner join tes.tcaja c on c.id_caja=caj.id_caja
            where caj.id_caja = v_parametros.id_caja and caj.tipo='apertura';

            IF(v_registros.estado is null or v_registros.estado!='abierto')THEN
            	raise exception 'La caja (%) no se encuentra abierto', v_registros.codigo;
            END if;
            

            SELECT   ps_id_proceso_wf,
                     ps_id_estado_wf,
                     ps_codigo_estado
               into
                     v_id_proceso_wf,
                     v_id_estado_wf,
                     v_codigo_estado
            FROM wf.f_registra_proceso_disparado_wf(
                     p_id_usuario,
                     NULL::integer,
                     NULL::varchar,
                     v_registros.id_estado_wf, 
                     NULL, 
                     v_registros.id_depto,
                     ('Solicitud de rendicion para la CAJA:'|| v_registros.codigo||' numero de rendicion: '||v_num_rendicion::varchar),
                     v_registros_trendicion.codigo,
                     v_num_rendicion::varchar
                   );
                   
            v_monto_reposicion=0;
            
            IF(v_parametros.tipo = 'rendicion_reposicion')THEN
            	select sum(r.monto) into v_monto_reposicion
                from tes.tsolicitud_rendicion_det r
                inner join tes.tsolicitud_efectivo efe on efe.id_solicitud_efectivo=r.id_solicitud_efectivo
                inner join conta.tdoc_compra_venta d on d.id_doc_compra_venta=r.id_documento_respaldo
                where r.id_proceso_caja is null and efe.id_caja=v_parametros.id_caja
                and d.fecha BETWEEN v_parametros.fecha_inicio and v_parametros.fecha_fin
                and efe.estado='rendido';
            END IF;
                      
        	--Sentencia de la insercion
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
			id_usuario_mod
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
			null
			)RETURNING id_proceso_caja into v_id_proceso_caja;
            
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
            pc.estado
        into 
            v_id_proceso_caja,
            v_id_proceso_wf,
            v_codigo_estado
        from tes.tproceso_caja pc
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