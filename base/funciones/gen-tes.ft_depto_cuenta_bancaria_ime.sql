CREATE OR REPLACE FUNCTION "tes"."ft_depto_cuenta_bancaria_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Obligaciones de Pago
 FUNCION: 		tes.ft_depto_cuenta_bancaria_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tdepto_cuenta_bancaria'
 AUTOR: 		 (admin)
 FECHA:	        25-03-2015 13:11:53
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
	v_id_depto_cuenta_bancaria	integer;
			    
BEGIN

    v_nombre_funcion = 'tes.ft_depto_cuenta_bancaria_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_DCB_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		25-03-2015 13:11:53
	***********************************/

	if(p_transaccion='TES_DCB_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into tes.tdepto_cuenta_bancaria(
			estado_reg,
			id_cuenta_bancaria,
			id_depto,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.id_cuenta_bancaria,
			v_parametros.id_depto,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_depto_cuenta_bancaria into v_id_depto_cuenta_bancaria;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cuenta Bancaria almacenado(a) con exito (id_depto_cuenta_bancaria'||v_id_depto_cuenta_bancaria||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_depto_cuenta_bancaria',v_id_depto_cuenta_bancaria::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_DCB_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		25-03-2015 13:11:53
	***********************************/

	elsif(p_transaccion='TES_DCB_MOD')then

		begin
			--Sentencia de la modificacion
			update tes.tdepto_cuenta_bancaria set
			id_cuenta_bancaria = v_parametros.id_cuenta_bancaria,
			id_depto = v_parametros.id_depto,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_depto_cuenta_bancaria=v_parametros.id_depto_cuenta_bancaria;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cuenta Bancaria modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_depto_cuenta_bancaria',v_parametros.id_depto_cuenta_bancaria::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TES_DCB_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		25-03-2015 13:11:53
	***********************************/

	elsif(p_transaccion='TES_DCB_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from tes.tdepto_cuenta_bancaria
            where id_depto_cuenta_bancaria=v_parametros.id_depto_cuenta_bancaria;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cuenta Bancaria eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_depto_cuenta_bancaria',v_parametros.id_depto_cuenta_bancaria::varchar);
              
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
ALTER FUNCTION "tes"."ft_depto_cuenta_bancaria_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
