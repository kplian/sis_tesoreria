CREATE OR REPLACE FUNCTION "tes"."ft_cajero_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.ft_cajero_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tcajero'
 AUTOR: 		 (admin)
 FECHA:	        18-12-2013 19:39:02
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
	v_id_cajero	integer;
	v_id_caja integer;
			    
BEGIN

    v_nombre_funcion = 'tes.ft_cajero_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_CAJERO_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		18-12-2013 19:39:02
	***********************************/

	if(p_transaccion='TES_CAJERO_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into tes.tcajero(
			estado_reg,
			tipo,
			estado,
			id_funcionario,
			id_caja,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.tipo,
			v_parametros.estado,
			v_parametros.id_funcionario,
			v_parametros.id_caja,
			now(),
			p_id_usuario,
			null,
			null
							
			)RETURNING id_cajero into v_id_cajero;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cajero almacenado(a) con exito (id_cajero'||v_id_cajero||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cajero',v_id_cajero::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_CAJERO_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		18-12-2013 19:39:02
	***********************************/

	elsif(p_transaccion='TES_CAJERO_MOD')then

		begin
			--Sentencia de la modificacion
			update tes.tcajero set
			tipo = v_parametros.tipo,
			estado = v_parametros.estado,
			id_funcionario = v_parametros.id_funcionario,
			id_caja = v_parametros.id_caja,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now()
			where id_cajero=v_parametros.id_cajero;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cajero modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cajero',v_parametros.id_cajero::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TES_CAJERO_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		18-12-2013 19:39:02
	***********************************/

	elsif(p_transaccion='TES_CAJERO_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from tes.tcajero
            where id_cajero=v_parametros.id_cajero;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cajero eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cajero',v_parametros.id_cajero::varchar);
              
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
ALTER FUNCTION "tes"."ft_cajero_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
