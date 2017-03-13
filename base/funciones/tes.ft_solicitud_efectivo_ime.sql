--------------- SQL ---------------

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
    v_caja					record;
    v_registros_solicitud_efectivo	record;
    v_tipo					varchar;
    v_id_tipo_solicitud		integer;
    v_id_solicitud_efectivo_fk	integer;
    v_solicitud_efectivo	record;
    v_monto_solicitado		numeric;
	v_monto_rendido			numeric;
    v_monto_devuelto		numeric;
    v_monto_repuesto		numeric;
    v_saldo					numeric;
    v_doc_compra_venta		record;
    v_saldo_caja			numeric;
    v_importe_maximo_solicitud	numeric;
    		    
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
            IF EXISTS (select 1
					 from tes.tproceso_caja
					 where tipo='CIERRE' and id_caja=v_parametros.id_caja)  THEN
            	raise exception 'No puede realizar solicitudes ni rendiciones, la caja se encuentra en proceso de cierre';
            END IF;
            
        	v_id_solicitud_efectivo=tes.f_inserta_solicitud_efectivo(p_administrador,p_id_usuario,hstore(v_parametros));
        	
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
            
            IF v_parametros.tipo_solicitud = 'solicitud' THEN
            	v_saldo_caja = tes.f_calcular_saldo_caja(v_parametros.id_caja);
                
                IF v_saldo_caja < v_parametros.monto THEN
					raise exception 'El monto que esta intentando solicitar excede el saldo de la caja';
                END IF;
                
                select importe_maximo_item into v_importe_maximo_solicitud
                from tes.tcaja
                where id_caja=v_parametros.id_caja;
                
                IF v_importe_maximo_solicitud < v_parametros.monto THEN
                	raise exception 'El monto que esta intentando solicitar excede el importe maximo de gasto';
                END IF;
                
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
        	select s.estado,
			       s.id_proceso_wf,
                   --pc.id_proceso_caja,
                   c.id_depto,
                   s.id_estado_wf
            into v_registros_solicitud_efectivo
            from tes.tsolicitud_efectivo s
            inner join tes.tcaja c on c.id_caja=s.id_caja
			where id_solicitud_efectivo=v_parametros.id_solicitud_efectivo;
            
            IF v_registros_solicitud_efectivo.estado ='revision' THEN
            	IF EXISTS (select 1 from tes.tsolicitud_rendicion_det where id_solicitud_efectivo=v_parametros.id_solicitud_efectivo)THEN
                	raise exception 'No es posible eliminar la rendicion de efectivo, esta contiene facturas rendidas,
                    devuelva las facturas al solicitante';
                END IF;
            END IF; 
                        
            IF v_registros_solicitud_efectivo.estado not in ('borrador','revision') THEN
            	raise exception 'No es posible eliminar la solicitud de efectivo, no se encuentra en estado borrador';
            END IF;
                        
           --recuperamos el id_tipo_proceso en el WF para el estado anulado
           --este es un estado especial que no tiene padres definidos
                              
           select 
            te.id_tipo_estado
           into
            v_id_tipo_estado
           from wf.tproceso_wf pw 
           inner join wf.ttipo_proceso tp on pw.id_tipo_proceso = tp.id_tipo_proceso
           inner join wf.ttipo_estado te on te.id_tipo_proceso = tp.id_tipo_proceso and te.codigo = 'anulado'               
           where pw.id_proceso_wf = v_registros_solicitud_efectivo.id_proceso_wf;
               
               
           IF v_id_tipo_estado is NULL THEN
               
              raise exception 'El estado anulado para la solicitud de efectivo no esta parametrizado en el workflow';  
               
           END IF;
              
           -- pasamos la obligacion al estado anulado
           
           v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado, 
                                                       NULL, 
                                                       v_registros_solicitud_efectivo.id_estado_wf, 
                                                       v_registros_solicitud_efectivo.id_proceso_wf,
                                                       p_id_usuario,
                                                       v_parametros._id_usuario_ai,
                                                       v_parametros._nombre_usuario_ai,
                                                       v_registros_solicitud_efectivo.id_depto,
                                                       'Solicitud de Caja Anulada');
            
            
               -- actualiza estado en solicitud de efectivo               
            update tes.tsolicitud_efectivo set
			     id_estado_wf =  v_id_estado_actual,
                 estado = 'anulado',
                 estado_reg = 'inactivo',
                 id_usuario_mod=p_id_usuario,
                 fecha_mod=now(),
                 id_usuario_ai = v_parametros._id_usuario_ai,
                 usuario_ai = v_parametros._nombre_usuario_ai
            where id_solicitud_efectivo  = v_parametros.id_solicitud_efectivo;
            
			--Sentencia de la eliminacion
            --inactivamos el detalle
            update tes.tsolicitud_efectivo_det
            set estado_reg = 'inactivo' 
            where id_solicitud_efectivo=v_parametros.id_solicitud_efectivo;
                          
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Solicitud Efectivo anulado'); 
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
        
        SELECT cj.tipo_ejecucion, cj.id_depto into v_caja
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
                  v_parametros_ad = '{filtro_directo:{campo:"solefe.id_proceso_wf",valor:"'||v_id_proceso_wf::varchar||'"}}';
                  v_tipo_noti = 'notificacion';
                  v_titulo  = 'Visto Bueno Solicitud Efectivo';
             
             END IF;
             
             
            --verifica saldo de caja
            IF v_codigo_estado_siguiente = 'entregado' THEN
            	select id_caja, monto
                into v_solicitud_efectivo
                from tes.tsolicitud_efectivo
                where id_solicitud_efectivo=v_id_solicitud_efectivo;
                
                v_saldo_caja = tes.f_calcular_saldo_caja(v_solicitud_efectivo.id_caja::integer)::numeric;
                
                IF v_saldo_caja < v_solicitud_efectivo.monto THEN
					raise exception 'El monto que esta intentando entregar excede el saldo de la caja, SALDO CAJA: %', v_saldo_caja;
                END IF;
                
                UPDATE tes.tsolicitud_efectivo
                SET fecha_entrega=current_date
                where id_solicitud_efectivo=v_id_solicitud_efectivo;
                
            END IF;

            --registra id_funcionario_jefe
            IF v_codigo_estado_siguiente = 'vbjefe' THEN

            	UPDATE tes.tsolicitud_efectivo
                SET id_funcionario_jefe_aprobador = v_parametros.id_funcionario_wf
                WHERE id_solicitud_efectivo=v_id_solicitud_efectivo;
                                
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
          
          update tes.tsolicitud_efectivo  s set 
             id_estado_wf =  v_id_estado_actual,
             estado = v_codigo_estado_siguiente,
             id_usuario_mod=p_id_usuario,
             fecha_mod=now()                           
          where id_proceso_wf = v_parametros.id_proceso_wf_act;
                         
          	--solo en caso de rendicion se compromete presupuesto
            IF v_codigo_estado_siguiente='rendido' THEN
              FOR v_doc_compra_venta IN (select doc.id_doc_compra_venta
                                       from tes.tsolicitud_rendicion_det rendet
                                       inner join conta.tdoc_compra_venta doc on doc.id_doc_compra_venta=rendet.id_documento_respaldo
                                       where rendet.id_solicitud_efectivo= v_id_solicitud_efectivo)LOOP
                    --to do comprometer presupuesto
                    IF not tes.f_gestionar_presupuesto_doc_compra_venta(
                            v_doc_compra_venta.id_doc_compra_venta::integer,
                            NULL, -- id_proceso_caja 
                            p_id_usuario, 
                            'comprometer')  THEN
                            
                        raise exception 'Error al comprometer el presupeusto';
                        
                    END IF;   
              END LOOP;
              
            IF pxp.f_existe_parametro(p_tabla,'devolucion_dinero') and pxp.f_existe_parametro(p_tabla,'saldo')THEN
            	IF v_parametros.devolucion_dinero = 'si' THEN
                  select id_caja, id_funcionario, current_date as fecha, 
                  case when v_parametros.saldo > 0 then 'devolucion' else 'reposicion' end as tipo_solicitud,
                  case when v_parametros.saldo > 0 then v_parametros.saldo else v_parametros.saldo * (-1) end as monto,
                  id_solicitud_efectivo_fk as id_solicitud_efectivo_fk,
                  id_estado_wf
                  into v_solicitud_efectivo
                  from tes.tsolicitud_efectivo
                  where id_solicitud_efectivo=v_id_solicitud_efectivo;
                     
                  --crear devolucion o ampliacion
                  v_id_solicitud_efectivo=tes.f_inserta_solicitud_efectivo(p_administrador,p_id_usuario,hstore(v_parametros)||hstore(v_solicitud_efectivo));
                  --finalizar solicitud efectivo---------------------------
                  
                  /*
                  IF tes.f_finalizar_solicitud_efectivo(p_id_usuario,v_solicitud_efectivo.id_solicitud_efectivo) = false THEN
                  	raise exception 'No se pudo finalizar la solicitud de efectivo automaticamente';
                  END IF;
                  */ 
			    END IF;
            ELSE
            	--finalizar solicitud efectivo--------------------
                /*
                IF tes.f_finalizar_solicitud_efectivo(p_id_usuario,v_solicitud_efectivo.id_solicitud_efectivo) = false THEN
                	raise exception 'No se pudo finalizar la solicitud de efectivo automaticamente';
                END IF;
                */
            END IF;
            
          END IF;
          
          IF v_codigo_estado_siguiente='finalizado' THEN
          	select sum(sol.monto) into v_monto_rendido
            from tes.tsolicitud_efectivo sol
            where sol.id_solicitud_efectivo_fk=v_id_solicitud_efectivo and sol.estado='rendido';
            
            select sum(sol.monto) into v_monto_devuelto
            from tes.tsolicitud_efectivo sol
            where sol.id_solicitud_efectivo_fk=v_id_solicitud_efectivo and sol.estado='devuelto';
            
            select sum(sol.monto) into v_monto_repuesto
            from tes.tsolicitud_efectivo sol
            where sol.id_solicitud_efectivo_fk=v_id_solicitud_efectivo and sol.estado='repuesto';
            
            select sum(sol.monto) into v_monto_solicitado
            from tes.tsolicitud_efectivo sol
            where sol.id_solicitud_efectivo=v_id_solicitud_efectivo;
			--calcular saldo solicitud efectivo
            v_saldo = v_monto_solicitado - COALESCE(v_monto_rendido,0) - COALESCE(v_monto_devuelto,0) + COALESCE(v_monto_repuesto,0);

            IF v_saldo != 0 THEN
              select id_caja, id_funcionario, current_date as fecha,
					 'devolucion' as tipo_solicitud,
                     v_saldo as monto,
                     id_solicitud_efectivo as id_solicitud_efectivo_fk,
                     nro_tramite
              into v_solicitud_efectivo
              from tes.tsolicitud_efectivo
              where id_solicitud_efectivo=v_id_solicitud_efectivo;
              --crear devolucion
              v_id_solicitud_efectivo=tes.f_inserta_solicitud_efectivo(p_administrador,p_id_usuario,hstore(v_parametros)||hstore(v_solicitud_efectivo)||hstore(v_caja));
            END IF;
          END IF;
                    
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