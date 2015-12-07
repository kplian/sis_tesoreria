CREATE OR REPLACE FUNCTION "tes"."ft_solicitud_efectivo_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

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
			v_parametros.id_estado_wf,
			v_parametros.monto,
			v_parametros.id_proceso_wf,
			v_parametros.nro_tramite,
			v_parametros.estado,
			'activo',
			v_parametros.motivo,
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
			--Sentencia de la modificacion
			update tes.tsolicitud_efectivo set
			id_caja = v_parametros.id_caja,
			id_estado_wf = v_parametros.id_estado_wf,
			monto = v_parametros.monto,
			id_proceso_wf = v_parametros.id_proceso_wf,
			nro_tramite = v_parametros.nro_tramite,
			estado = v_parametros.estado,
			motivo = v_parametros.motivo,
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
			delete from tes.tsolicitud_efectivo
            where id_solicitud_efectivo=v_parametros.id_solicitud_efectivo;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Solicitud Efectivo eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud_efectivo',v_parametros.id_solicitud_efectivo::varchar);
              
            --Devuelve la respuesta
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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "tes"."ft_solicitud_efectivo_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
