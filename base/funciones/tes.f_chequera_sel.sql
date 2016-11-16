CREATE OR REPLACE FUNCTION "tes"."f_chequera_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.f_chequera_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tchequera'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        24-04-2013 18:54:03
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

	v_nombre_funcion = 'tes.f_chequera_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_CHQ_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		24-04-2013 18:54:03
	***********************************/

	if(p_transaccion='TES_CHQ_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						chq.id_chequera,
						chq.estado_reg,
						chq.nro_chequera,
						chq.codigo,
						chq.id_cuenta_bancaria,
						chq.fecha_reg,
						chq.id_usuario_reg,
						chq.fecha_mod,
						chq.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from tes.tchequera chq
						inner join segu.tusuario usu1 on usu1.id_usuario = chq.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = chq.id_usuario_mod
				        where chq.id_cuenta_bancaria='||v_parametros.id_cuenta_bancaria||' and ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'TES_CHQ_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		24-04-2013 18:54:03
	***********************************/

	elsif(p_transaccion='TES_CHQ_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_chequera)
					    from tes.tchequera chq
					    inner join segu.tusuario usu1 on usu1.id_usuario = chq.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = chq.id_usuario_mod
					    where chq.id_cuenta_bancaria='||v_parametros.id_cuenta_bancaria||' and ';
			
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
ALTER FUNCTION "tes"."f_chequera_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
