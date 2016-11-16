CREATE OR REPLACE FUNCTION "tes"."ft_estacion_tipo_pago_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Obligaciones de Pago
 FUNCION: 		tes.ft_estacion_tipo_pago_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.testacion_tipo_pago'
 AUTOR: 		 (admin)
 FECHA:	        25-08-2015 15:36:37
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

	v_nombre_funcion = 'tes.ft_estacion_tipo_pago_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_ETP_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		25-08-2015 15:36:37
	***********************************/

	if(p_transaccion='TES_ETP_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						etp.id_estacion_tipo_pago,
						etp.estado_reg,
						etp.id_estacion,
						etp.id_tipo_plan_pago,
						etp.codigo_plantilla_comprobante,
						etp.id_usuario_reg,
						etp.fecha_reg,
						etp.id_usuario_ai,
						etp.usuario_ai,
						etp.id_usuario_mod,
						etp.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from tes.testacion_tipo_pago etp
						inner join segu.tusuario usu1 on usu1.id_usuario = etp.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = etp.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'TES_ETP_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		25-08-2015 15:36:37
	***********************************/

	elsif(p_transaccion='TES_ETP_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_estacion_tipo_pago)
					    from tes.testacion_tipo_pago etp
					    inner join segu.tusuario usu1 on usu1.id_usuario = etp.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = etp.id_usuario_mod
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
ALTER FUNCTION "tes"."ft_estacion_tipo_pago_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
