CREATE OR REPLACE FUNCTION "tes"."ft_caja_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.ft_caja_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tcaja'
 AUTOR: 		 (admin)
 FECHA:	        16-12-2013 20:43:44
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
	v_id_caja	integer;
			    
BEGIN

    v_nombre_funcion = 'tes.ft_caja_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_CAJA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		16-12-2013 20:43:44
	***********************************/

	if(p_transaccion='TES_CAJA_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into tes.tcaja(
			estado,
			importe_maximo,
			tipo,
			estado_reg,
			porcentaje_compra,
			id_moneda,
			id_depto,
			codigo,
			id_usuario_reg,
			fecha_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.estado,
			v_parametros.importe_maximo,
			v_parametros.tipo,
			'activo',
			v_parametros.porcentaje_compra,
			v_parametros.id_moneda,
			v_parametros.id_depto,
			v_parametros.codigo,
			p_id_usuario,
			now(),
			null,
			null
							
			)RETURNING id_caja into v_id_caja;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Caja almacenado(a) con exito (id_caja'||v_id_caja||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_caja',v_id_caja::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_CAJA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		16-12-2013 20:43:44
	***********************************/

	elsif(p_transaccion='TES_CAJA_MOD')then

		begin
			--Sentencia de la modificacion
			update tes.tcaja set
			estado = v_parametros.estado,
			importe_maximo = v_parametros.importe_maximo,
			tipo = v_parametros.tipo,
			porcentaje_compra = v_parametros.porcentaje_compra,
			id_moneda = v_parametros.id_moneda,
			id_depto = v_parametros.id_depto,
			codigo = v_parametros.codigo,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now()
			where id_caja=v_parametros.id_caja;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Caja modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_caja',v_parametros.id_caja::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TES_CAJA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		16-12-2013 20:43:44
	***********************************/

	elsif(p_transaccion='TES_CAJA_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from tes.tcaja
            where id_caja=v_parametros.id_caja;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Caja eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_caja',v_parametros.id_caja::varchar);
              
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
ALTER FUNCTION "tes"."ft_caja_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
