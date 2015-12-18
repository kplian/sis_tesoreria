CREATE OR REPLACE FUNCTION "tes"."ft_solicitud_rendicion_det_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Obligaciones de Pago
 FUNCION: 		tes.ft_solicitud_rendicion_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tsolicitud_rendicion_det'
 AUTOR: 		 (gsarmiento)
 FECHA:	        16-12-2015 15:14:01
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
	v_id_solicitud_rendicion_det	integer;
			    
BEGIN

    v_nombre_funcion = 'tes.ft_solicitud_rendicion_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_REND_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		16-12-2015 15:14:01
	***********************************/

	if(p_transaccion='TES_REND_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into tes.tsolicitud_rendicion_det(
			id_proceso_caja,
			id_solicitud_efectivo,
			id_documento_respaldo,
			estado_reg,
			monto,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_proceso_caja,
			v_parametros.id_solicitud_efectivo,
			v_parametros.id_documento_respaldo,
			'activo',
			v_parametros.monto,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_solicitud_rendicion_det into v_id_solicitud_rendicion_det;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Rendicion almacenado(a) con exito (id_solicitud_rendicion_det'||v_id_solicitud_rendicion_det||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud_rendicion_det',v_id_solicitud_rendicion_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_REND_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		16-12-2015 15:14:01
	***********************************/

	elsif(p_transaccion='TES_REND_MOD')then

		begin
			--Sentencia de la modificacion
			update tes.tsolicitud_rendicion_det set
			id_proceso_caja = v_parametros.id_proceso_caja,
			id_solicitud_efectivo = v_parametros.id_solicitud_efectivo,
			id_documento_respaldo = v_parametros.id_documento_respaldo,
			monto = v_parametros.monto,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_solicitud_rendicion_det=v_parametros.id_solicitud_rendicion_det;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Rendicion modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud_rendicion_det',v_parametros.id_solicitud_rendicion_det::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TES_REND_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		16-12-2015 15:14:01
	***********************************/

	elsif(p_transaccion='TES_REND_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from tes.tsolicitud_rendicion_det
            where id_solicitud_rendicion_det=v_parametros.id_solicitud_rendicion_det;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Rendicion eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud_rendicion_det',v_parametros.id_solicitud_rendicion_det::varchar);
              
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
ALTER FUNCTION "tes"."ft_solicitud_rendicion_det_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
