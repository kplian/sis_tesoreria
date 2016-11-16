CREATE OR REPLACE FUNCTION "tes"."ft_cuenta_bancaria_mov_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.ft_cuenta_bancaria_mov_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tcuenta_bancaria_mov'
 AUTOR: 		 (admin)
 FECHA:	        12-12-2013 18:01:35
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
	v_id_cuenta_bancaria_mov	integer;
			    
BEGIN

    v_nombre_funcion = 'tes.ft_cuenta_bancaria_mov_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_CBANMO_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		12-12-2013 18:01:35
	***********************************/

	if(p_transaccion='TES_CBANMO_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into tes.tcuenta_bancaria_mov(
			descripcion,
			tipo_mov,
			tipo,
			estado_reg,
			nro_doc_tipo,
			fecha,
			estado,
			id_int_comprobante,
			id_cuenta_bancaria,
			id_cuenta_bancaria_mov_fk,
			importe,
			observaciones,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.descripcion,
			v_parametros.tipo_mov,
			v_parametros.tipo,
			'activo',
			v_parametros.nro_doc_tipo,
			v_parametros.fecha,
			v_parametros.estado,
			v_parametros.id_int_comprobante,
			v_parametros.id_cuenta_bancaria,
			v_parametros.id_cuenta_bancaria_mov_fk,
			v_parametros.importe,
			v_parametros.observaciones,
			now(),
			p_id_usuario,
			null,
			null
							
			)RETURNING id_cuenta_bancaria_mov into v_id_cuenta_bancaria_mov;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Movimiento Cuentas Bancarias almacenado(a) con exito (id_cuenta_bancaria_mov'||v_id_cuenta_bancaria_mov||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_bancaria_mov',v_id_cuenta_bancaria_mov::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_CBANMO_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		12-12-2013 18:01:35
	***********************************/

	elsif(p_transaccion='TES_CBANMO_MOD')then

		begin
			--Sentencia de la modificacion
			update tes.tcuenta_bancaria_mov set
			descripcion = v_parametros.descripcion,
			tipo_mov = v_parametros.tipo_mov,
			tipo = v_parametros.tipo,
			nro_doc_tipo = v_parametros.nro_doc_tipo,
			fecha = v_parametros.fecha,
			estado = v_parametros.estado,
			id_int_comprobante = v_parametros.id_int_comprobante,
			id_cuenta_bancaria = v_parametros.id_cuenta_bancaria,
			id_cuenta_bancaria_mov_fk = v_parametros.id_cuenta_bancaria_mov_fk,
			importe = v_parametros.importe,
			observaciones = v_parametros.observaciones,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now()
			where id_cuenta_bancaria_mov=v_parametros.id_cuenta_bancaria_mov;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Movimiento Cuentas Bancarias modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_bancaria_mov',v_parametros.id_cuenta_bancaria_mov::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TES_CBANMO_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		12-12-2013 18:01:35
	***********************************/

	elsif(p_transaccion='TES_CBANMO_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from tes.tcuenta_bancaria_mov
            where id_cuenta_bancaria_mov=v_parametros.id_cuenta_bancaria_mov;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Movimiento Cuentas Bancarias eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_bancaria_mov',v_parametros.id_cuenta_bancaria_mov::varchar);
              
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
ALTER FUNCTION "tes"."ft_cuenta_bancaria_mov_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
