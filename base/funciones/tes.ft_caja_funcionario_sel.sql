CREATE OR REPLACE FUNCTION tes.ft_caja_funcionario_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Obligaciones de Pago
 FUNCION: 		tes.ft_caja_funcionario_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tcaja_funcionario'
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

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'tes.ft_caja_funcionario_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'TES_CAJFUN_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		gsarmiento
 	#FECHA:		15-03-2017 20:10:37
	***********************************/

	if(p_transaccion='TES_CAJFUN_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						cajusu.id_caja_funcionario,
						cajusu.estado_reg,
						cajusu.id_caja,
						cajusu.id_funcionario,
                        fun.desc_funcionario1,
						cajusu.id_usuario_reg,
						cajusu.fecha_reg,
						cajusu.id_usuario_ai,
						cajusu.usuario_ai,
						cajusu.id_usuario_mod,
						cajusu.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod
						from tes.tcaja_funcionario cajusu
						inner join segu.tusuario usu1 on usu1.id_usuario = cajusu.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cajusu.id_usuario_mod
                        inner join orga.vfuncionario fun on fun.id_funcionario=cajusu.id_funcionario
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'TES_CAJFUN_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		gsarmiento
 	#FECHA:		15-03-2017 20:10:37
	***********************************/

	elsif(p_transaccion='TES_CAJFUN_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_caja_funcionario)
					    from tes.tcaja_funcionario cajusu
					    inner join segu.tusuario usu1 on usu1.id_usuario = cajusu.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cajusu.id_usuario_mod
                        inner join orga.vfuncionario fun on fun.id_funcionario=cajusu.id_funcionario
					    where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;

	else

		raise exception 'Transaccion inexistente';

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