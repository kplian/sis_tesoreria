CREATE OR REPLACE FUNCTION "tes"."ft_estacion_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Obligaciones de Pago
 FUNCION: 		tes.ft_estacion_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.testacion'
 AUTOR: 		 (admin)
 FECHA:	        25-08-2015 15:36:34
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
	v_id_estacion	integer;
			    
BEGIN

    v_nombre_funcion = 'tes.ft_estacion_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_EST_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		25-08-2015 15:36:34
	***********************************/

	if(p_transaccion='TES_EST_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into tes.testacion(
			estado_reg,
			codigo,
			host,
			puerto,
			dbname,
			usuario,
			password,
			id_depto_lb,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.codigo,
			v_parametros.host,
			v_parametros.puerto,
			v_parametros.dbname,
			v_parametros.usuario,
			v_parametros.password,
			v_parametros.id_depto_lb,
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_estacion into v_id_estacion;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Estación almacenado(a) con exito (id_estacion'||v_id_estacion||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_estacion',v_id_estacion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_EST_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		25-08-2015 15:36:34
	***********************************/

	elsif(p_transaccion='TES_EST_MOD')then

		begin
			--Sentencia de la modificacion
			update tes.testacion set
			codigo = v_parametros.codigo,
			host = v_parametros.host,
			puerto = v_parametros.puerto,
			dbname = v_parametros.dbname,
			usuario = v_parametros.usuario,
			password = v_parametros.password,
			id_depto_lb = v_parametros.id_depto_lb,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_estacion=v_parametros.id_estacion;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Estación modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_estacion',v_parametros.id_estacion::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TES_EST_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		25-08-2015 15:36:34
	***********************************/

	elsif(p_transaccion='TES_EST_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from tes.testacion
            where id_estacion=v_parametros.id_estacion;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Estación eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_estacion',v_parametros.id_estacion::varchar);
              
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
ALTER FUNCTION "tes"."ft_estacion_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
