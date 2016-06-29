--------------------------SQL-----------------------

CREATE OR REPLACE FUNCTION tes.ft_finalidad_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Obligaciones de Pago
 FUNCION: 		tes.ft_finalidad_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tfinalidad'
 AUTOR: 		 (gsarmiento)
 FECHA:	        02-12-2014 13:11:02
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
	v_id_finalidad	integer;
			    
BEGIN

    v_nombre_funcion = 'tes.ft_finalidad_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_FIN_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		02-12-2014 13:11:02
	***********************************/

	if(p_transaccion='TES_FIN_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into tes.tfinalidad(
			estado,
			color,
			estado_reg,
			nombre_finalidad,
			id_usuario_ai,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.estado,
			v_parametros.color,
			'activo',
			v_parametros.nombre_finalidad,
			v_parametros._id_usuario_ai,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_finalidad into v_id_finalidad;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Finalidad almacenado(a) con exito (id_finalidad'||v_id_finalidad||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_finalidad',v_id_finalidad::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_FIN_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		02-12-2014 13:11:02
	***********************************/

	elsif(p_transaccion='TES_FIN_MOD')then

		begin
			--Sentencia de la modificacion
			update tes.tfinalidad set
			estado = v_parametros.estado,
			color = v_parametros.color,
			nombre_finalidad = v_parametros.nombre_finalidad,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_finalidad=v_parametros.id_finalidad;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Finalidad modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_finalidad',v_parametros.id_finalidad::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TES_FIN_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		02-12-2014 13:11:02
	***********************************/

	elsif(p_transaccion='TES_FIN_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from tes.tfinalidad
            where id_finalidad=v_parametros.id_finalidad;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Finalidad eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_finalidad',v_parametros.id_finalidad::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
    
    /*********************************    
 	#TRANSACCION:  'TES_EDTUI_IME'
 	#DESCRIPCION:	Permite configurar los interfaces para las finalidades (caja_chica, fondos_avance)
 	#AUTOR:		Gonzalo Sarmiento
 	#FECHA:		24-05-2016
	***********************************/

	elsif(p_transaccion='TES_EDTUI_IME')then

		begin        
        
             update tes.tfinalidad set
			  sw_tipo_interfaz = string_to_array(v_parametros.sw_tipo_interfaz,',')::varchar[]
             where id_finalidad=v_parametros.id_finalidad;
                          
             --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se modificaron las interfaces de las finalidades'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_finalidad',v_parametros.id_finalidad::varchar);
              
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