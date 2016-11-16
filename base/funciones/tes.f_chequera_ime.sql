CREATE OR REPLACE FUNCTION "tes"."f_chequera_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.f_chequera_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tchequera'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        24-04-2013 18:54:03
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
	v_id_chequera	integer;
			    
BEGIN

    v_nombre_funcion = 'tes.f_chequera_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_CHQ_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		24-04-2013 18:54:03
	***********************************/

	if(p_transaccion='TES_CHQ_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into tes.tchequera(
			estado_reg,
			nro_chequera,
			codigo,
			id_cuenta_bancaria,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			'activo',
			v_parametros.nro_chequera,
			v_parametros.codigo,
			v_parametros.id_cuenta_bancaria,
			now(),
			p_id_usuario,
			null,
			null
							
			)RETURNING id_chequera into v_id_chequera;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cheques almacenado(a) con exito (id_chequera'||v_id_chequera||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_chequera',v_id_chequera::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_CHQ_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		24-04-2013 18:54:03
	***********************************/

	elsif(p_transaccion='TES_CHQ_MOD')then

		begin
			--Sentencia de la modificacion
			update tes.tchequera set
			nro_chequera = v_parametros.nro_chequera,
			codigo = v_parametros.codigo,
			id_cuenta_bancaria = v_parametros.id_cuenta_bancaria,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario
			where id_chequera=v_parametros.id_chequera;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cheques modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_chequera',v_parametros.id_chequera::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TES_CHQ_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		24-04-2013 18:54:03
	***********************************/

	elsif(p_transaccion='TES_CHQ_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from tes.tchequera
            where id_chequera=v_parametros.id_chequera;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cheques eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_chequera',v_parametros.id_chequera::varchar);
              
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
ALTER FUNCTION "tes"."f_chequera_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
