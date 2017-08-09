--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.ft_usuario_cuenta_banc_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Tesoreria
 FUNCION: 		tes.ft_usuario_cuenta_banc_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tusuario_cuenta_banc'
 AUTOR: 		 (admin)
 FECHA:	        24-03-2017 15:30:36
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
	v_id_usuario_cuenta_banc	integer;
			    
BEGIN

    v_nombre_funcion = 'tes.ft_usuario_cuenta_banc_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_UCU_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		24-03-2017 15:30:36
	***********************************/

	if(p_transaccion='TES_UCU_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into tes.tusuario_cuenta_banc(
			id_usuario,
			estado_reg,
			id_cuenta_bancaria,
			tipo_permiso,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_usuario,
			'activo',
			v_parametros.id_cuenta_bancaria,
			v_parametros.tipo_permiso,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_usuario_cuenta_banc into v_id_usuario_cuenta_banc;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Permisos almacenado(a) con exito (id_usuario_cuenta_banc'||v_id_usuario_cuenta_banc||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_usuario_cuenta_banc',v_id_usuario_cuenta_banc::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_UCU_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		24-03-2017 15:30:36
	***********************************/

	elsif(p_transaccion='TES_UCU_MOD')then

		begin
			--Sentencia de la modificacion
			update tes.tusuario_cuenta_banc set
			id_usuario = v_parametros.id_usuario,
			id_cuenta_bancaria = v_parametros.id_cuenta_bancaria,
			tipo_permiso = v_parametros.tipo_permiso,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_usuario_cuenta_banc=v_parametros.id_usuario_cuenta_banc;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Permisos modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_usuario_cuenta_banc',v_parametros.id_usuario_cuenta_banc::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TES_UCU_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		24-03-2017 15:30:36
	***********************************/

	elsif(p_transaccion='TES_UCU_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from tes.tusuario_cuenta_banc
            where id_usuario_cuenta_banc=v_parametros.id_usuario_cuenta_banc;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Permisos eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_usuario_cuenta_banc',v_parametros.id_usuario_cuenta_banc::varchar);
              
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
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;