--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.ft_usuario_cuenta_banc_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Tesoreria
 FUNCION: 		tes.ft_usuario_cuenta_banc_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tusuario_cuenta_banc'
 AUTOR: 		 (admin)
 FECHA:	        24-03-2017 15:30:36
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

	v_nombre_funcion = 'tes.ft_usuario_cuenta_banc_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_UCU_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		24-03-2017 15:30:36
	***********************************/

	if(p_transaccion='TES_UCU_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select ucu.id_usuario_cuenta_banc,
                               ucu.id_usuario,
                               ucu.estado_reg,
                               ucu.id_cuenta_bancaria,
                               ucu.tipo_permiso,
                               ucu.id_usuario_reg,
                               ucu.usuario_ai,
                               ucu.fecha_reg,
                               ucu.id_usuario_ai,
                               ucu.fecha_mod,
                               ucu.id_usuario_mod,
                               usu1.cuenta as usr_reg,
                               usu2.cuenta as usr_mod,
                               per.nombre_completo1 as desc_persona
                        from tes.tusuario_cuenta_banc ucu
                        inner join segu.tusuario u on u.id_usuario = ucu.id_usuario
                        inner join segu.vpersona per on per.id_persona = u.id_persona
                             inner join segu.tusuario usu1 on usu1.id_usuario = ucu.id_usuario_reg
                             left join segu.tusuario usu2 on usu2.id_usuario = ucu.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'TES_UCU_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		24-03-2017 15:30:36
	***********************************/

	elsif(p_transaccion='TES_UCU_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_usuario_cuenta_banc)
					      from tes.tusuario_cuenta_banc ucu
                            inner join segu.tusuario u on u.id_usuario = ucu.id_usuario
                            inner join segu.vpersona per on per.id_persona = u.id_persona
                            inner join segu.tusuario usu1 on usu1.id_usuario = ucu.id_usuario_reg
                            left join segu.tusuario usu2 on usu2.id_usuario = ucu.id_usuario_mod
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