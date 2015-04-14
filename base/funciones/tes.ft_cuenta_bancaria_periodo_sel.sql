CREATE OR REPLACE FUNCTION "tes"."ft_cuenta_bancaria_periodo_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Obligaciones de Pago
 FUNCION: 		tes.ft_cuenta_bancaria_periodo_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tcuenta_bancaria_periodo'
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

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'tes.ft_cuenta_bancaria_periodo_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_PERCTAB_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		gsarmiento	
 	#FECHA:		09-04-2015 18:40:04
	***********************************/

	if(p_transaccion='TES_PERCTAB_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						perctab.id_cuenta_bancaria_periodo,
						perctab.id_cuenta_bancaria,
						perctab.estado,
						perctab.id_periodo,
						perctab.estado_reg,
						perctab.id_usuario_ai,
						perctab.fecha_reg,
						perctab.usuario_ai,
						perctab.id_usuario_reg,
						perctab.id_usuario_mod,
						perctab.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from tes.tcuenta_bancaria_periodo perctab
						inner join segu.tusuario usu1 on usu1.id_usuario = perctab.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = perctab.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'TES_PERCTAB_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		09-04-2015 18:40:04
	***********************************/

	elsif(p_transaccion='TES_PERCTAB_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_cuenta_bancaria_periodo)
					    from tes.tcuenta_bancaria_periodo perctab
					    inner join segu.tusuario usu1 on usu1.id_usuario = perctab.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = perctab.id_usuario_mod
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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "tes"."ft_cuenta_bancaria_periodo_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
