CREATE OR REPLACE FUNCTION "tes"."ft_tipo_prorrateo_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.ft_tipo_prorrateo_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.ttipo_prorrateo'
 AUTOR: 		 (jrivera)
 FECHA:	        31-07-2014 23:29:22
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
	v_id_tipo_prorrateo	integer;
			    
BEGIN

    v_nombre_funcion = 'tes.ft_tipo_prorrateo_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_TIPO_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		jrivera	
 	#FECHA:		31-07-2014 23:29:22
	***********************************/

	if(p_transaccion='TES_TIPO_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into tes.ttipo_prorrateo(
			estado_reg,
			descripcion,
			es_plantilla,
			nombre,
			codigo,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod,
			tiene_cuenta
          	) values(
			'activo',
			v_parametros.descripcion,
			v_parametros.es_plantilla,
			v_parametros.nombre,
			v_parametros.codigo,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null,
			v_parametros.tiene_cuenta
							
			
			
			)RETURNING id_tipo_prorrateo into v_id_tipo_prorrateo;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Prorrateo almacenado(a) con exito (id_tipo_prorrateo'||v_id_tipo_prorrateo||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_prorrateo',v_id_tipo_prorrateo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_TIPO_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		jrivera	
 	#FECHA:		31-07-2014 23:29:22
	***********************************/

	elsif(p_transaccion='TES_TIPO_MOD')then

		begin
			--Sentencia de la modificacion
			update tes.ttipo_prorrateo set
			descripcion = v_parametros.descripcion,
			es_plantilla = v_parametros.es_plantilla,
			nombre = v_parametros.nombre,
			codigo = v_parametros.codigo,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
			tiene_cuenta = v_parametros.tiene_cuenta
			where id_tipo_prorrateo=v_parametros.id_tipo_prorrateo;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Prorrateo modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_prorrateo',v_parametros.id_tipo_prorrateo::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TES_TIPO_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		jrivera	
 	#FECHA:		31-07-2014 23:29:22
	***********************************/

	elsif(p_transaccion='TES_TIPO_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from tes.ttipo_prorrateo
            where id_tipo_prorrateo=v_parametros.id_tipo_prorrateo;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Prorrateo eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_prorrateo',v_parametros.id_tipo_prorrateo::varchar);
              
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
ALTER FUNCTION "tes"."ft_tipo_prorrateo_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
