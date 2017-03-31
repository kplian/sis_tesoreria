CREATE OR REPLACE FUNCTION tes.ft_caja_funcionario_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Obligaciones de Pago
 FUNCION: 		tes.ft_caja_funcionario_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tcaja_funcionario'
 AUTOR: 		 (gsarmiento)
 FECHA:	        15-03-2017 20:10:37
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
	v_id_caja_funcionario	integer;

BEGIN

    v_nombre_funcion = 'tes.ft_caja_funcionario_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'TES_CAJFUN_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		gsarmiento
 	#FECHA:		15-03-2017 20:10:37
	***********************************/

	if(p_transaccion='TES_CAJFUN_INS')then

        begin
        	--Sentencia de la insercion
        	insert into tes.tcaja_funcionario(
			estado_reg,
			id_caja,
			id_funcionario,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.id_caja,
			v_parametros.id_funcionario,
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null



			)RETURNING id_caja_funcionario into v_id_caja_funcionario;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Funcionario almacenado(a) con exito (id_caja_funcionario'||v_id_caja_funcionario||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_caja_funcionario',v_id_caja_funcionario::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'TES_CAJFUN_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		gsarmiento
 	#FECHA:		15-03-2017 20:10:37
	***********************************/

	elsif(p_transaccion='TES_CAJFUN_MOD')then

		begin
			--Sentencia de la modificacion
			update tes.tcaja_funcionario set
			id_caja = v_parametros.id_caja,
			id_funcionario = v_parametros.id_funcionario,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_caja_funcionario=v_parametros.id_caja_funcionario;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Funcionario modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_caja_funcionario',v_parametros.id_caja_funcionario::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'TES_CAJFUN_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		gsarmiento
 	#FECHA:		15-03-2017 20:10:37
	***********************************/

	elsif(p_transaccion='TES_CAJFUN_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from tes.tcaja_funcionario
            where id_caja_funcionario=v_parametros.id_caja_funcionario;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Funcionario eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_caja_funcionario',v_parametros.id_caja_funcionario::varchar);

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