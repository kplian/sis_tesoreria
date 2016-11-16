--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.ft_concepto_excepcion_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Obligaciones de Pago
 FUNCION: 		tes.ft_concepto_excepcion_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tconcepto_excepcion'
 AUTOR: 		 (admin)
 FECHA:	        12-06-2015 13:02:07
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

	v_nombre_funcion = 'tes.ft_concepto_excepcion_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_conex_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		12-06-2015 13:02:07
	***********************************/

	if(p_transaccion='TES_conex_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						conex.id_concepto_excepcion,
						conex.id_uo,
						conex.estado_reg,
						conex.id_concepto_ingas,
						conex.id_usuario_ai,
						conex.usuario_ai,
						conex.fecha_reg,
						conex.id_usuario_reg,
						conex.id_usuario_mod,
						conex.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        uo.nombre_unidad as desc_uo,
                        cig.desc_ingas
						from tes.tconcepto_excepcion conex
                        inner join orga.tuo uo on uo.id_uo = conex.id_uo
                        inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = conex.id_concepto_ingas
						inner join segu.tusuario usu1 on usu1.id_usuario = conex.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = conex.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'TES_conex_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		12-06-2015 13:02:07
	***********************************/

	elsif(p_transaccion='TES_conex_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_concepto_excepcion)
					    from tes.tconcepto_excepcion conex
                        inner join orga.tuo uo on uo.id_uo = conex.id_uo
                        inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = conex.id_concepto_ingas
						inner join segu.tusuario usu1 on usu1.id_usuario = conex.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = conex.id_usuario_mod
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