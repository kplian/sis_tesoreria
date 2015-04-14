CREATE OR REPLACE FUNCTION "tes"."ft_cuenta_bancaria_periodo_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Obligaciones de Pago
 FUNCION: 		tes.ft_cuenta_bancaria_periodo_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tcuenta_bancaria_periodo'
 AUTOR: 		 (gsarmiento)
 FECHA:	        09-04-2015 18:40:04
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
	v_id_cuenta_bancaria_periodo	integer;
			    
BEGIN

    v_nombre_funcion = 'tes.ft_cuenta_bancaria_periodo_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_PERCTAB_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		09-04-2015 18:40:04
	***********************************/

	if(p_transaccion='TES_PERCTAB_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into tes.tcuenta_bancaria_periodo(
			id_cuenta_bancaria,
			estado,
			id_periodo,
			estado_reg,
			id_usuario_ai,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_cuenta_bancaria,
			v_parametros.estado,
			v_parametros.id_periodo,
			'activo',
			v_parametros._id_usuario_ai,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			null,
			null
							
			
			
			)RETURNING id_cuenta_bancaria_periodo into v_id_cuenta_bancaria_periodo;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Periodos por Cuenta Bancaria almacenado(a) con exito (id_cuenta_bancaria_periodo'||v_id_cuenta_bancaria_periodo||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_bancaria_periodo',v_id_cuenta_bancaria_periodo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_PERCTAB_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		09-04-2015 18:40:04
	***********************************/

	elsif(p_transaccion='TES_PERCTAB_MOD')then

		begin
			--Sentencia de la modificacion
			update tes.tcuenta_bancaria_periodo set
			id_cuenta_bancaria = v_parametros.id_cuenta_bancaria,
			estado = v_parametros.estado,
			id_periodo = v_parametros.id_periodo,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_cuenta_bancaria_periodo=v_parametros.id_cuenta_bancaria_periodo;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Periodos por Cuenta Bancaria modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_bancaria_periodo',v_parametros.id_cuenta_bancaria_periodo::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TES_PERCTAB_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		09-04-2015 18:40:04
	***********************************/

	elsif(p_transaccion='TES_PERCTAB_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from tes.tcuenta_bancaria_periodo
            where id_cuenta_bancaria_periodo=v_parametros.id_cuenta_bancaria_periodo;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Periodos por Cuenta Bancaria eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_bancaria_periodo',v_parametros.id_cuenta_bancaria_periodo::varchar);
              
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
ALTER FUNCTION "tes"."ft_cuenta_bancaria_periodo_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
