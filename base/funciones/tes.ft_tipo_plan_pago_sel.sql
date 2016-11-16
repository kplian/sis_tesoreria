--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.ft_tipo_plan_pago_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.ft_tipo_plan_pago_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.ttipo_plan_pago'
 AUTOR: 		 (admin)
 FECHA:	        08-07-2014 13:12:03
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

	v_nombre_funcion = 'tes.ft_tipo_plan_pago_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_TPP_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		08-07-2014 13:12:03
	***********************************/

	if(p_transaccion='TES_TPP_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						tpp.id_tipo_plan_pago,
						tpp.codigo_proceso_llave_wf,
						tpp.descripcion,
						tpp.codigo_plantilla_comprobante,
						tpp.estado_reg,
						tpp.codigo,
						tpp.id_usuario_ai,
						tpp.fecha_reg,
						tpp.usuario_ai,
						tpp.id_usuario_reg,
						tpp.id_usuario_mod,
						tpp.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from tes.ttipo_plan_pago tpp
						inner join segu.tusuario usu1 on usu1.id_usuario = tpp.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = tpp.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'TES_TPP_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		08-07-2014 13:12:03
	***********************************/

	elsif(p_transaccion='TES_TPP_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_tipo_plan_pago)
					    from tes.ttipo_plan_pago tpp
					    inner join segu.tusuario usu1 on usu1.id_usuario = tpp.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = tpp.id_usuario_mod
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