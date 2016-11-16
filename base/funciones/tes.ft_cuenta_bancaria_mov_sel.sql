CREATE OR REPLACE FUNCTION "tes"."ft_cuenta_bancaria_mov_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.ft_cuenta_bancaria_mov_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tcuenta_bancaria_mov'
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

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'tes.ft_cuenta_bancaria_mov_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_CBANMO_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		12-12-2013 18:01:35
	***********************************/

	if(p_transaccion='TES_CBANMO_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						cbanmo.id_cuenta_bancaria_mov,
						cbanmo.descripcion,
						cbanmo.tipo_mov,
						cbanmo.tipo,
						cbanmo.estado_reg,
						cbanmo.nro_doc_tipo,
						cbanmo.fecha,
						cbanmo.estado,
						cbanmo.id_int_comprobante,
						cbanmo.id_cuenta_bancaria,
						cbanmo.id_cuenta_bancaria_mov_fk,
						cbanmo.importe,
						cbanmo.observaciones,
						cbanmo.fecha_reg,
						cbanmo.id_usuario_reg,
						cbanmo.id_usuario_mod,
						cbanmo.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from tes.tcuenta_bancaria_mov cbanmo
						inner join segu.tusuario usu1 on usu1.id_usuario = cbanmo.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cbanmo.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'TES_CBANMO_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		12-12-2013 18:01:35
	***********************************/

	elsif(p_transaccion='TES_CBANMO_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_cuenta_bancaria_mov)
					    from tes.tcuenta_bancaria_mov cbanmo
					    inner join segu.tusuario usu1 on usu1.id_usuario = cbanmo.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cbanmo.id_usuario_mod
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
ALTER FUNCTION "tes"."ft_cuenta_bancaria_mov_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
