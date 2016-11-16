--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.ft_cajero_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.ft_cajero_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tcajero'
 AUTOR: 		 (admin)
 FECHA:	        18-12-2013 19:39:02
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

	v_nombre_funcion = 'tes.ft_cajero_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_CAJERO_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		18-12-2013 19:39:02
	***********************************/

	if(p_transaccion='TES_CAJERO_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						cajero.id_cajero,
						cajero.estado_reg,
						cajero.tipo,
						cajero.estado,
						cajero.id_funcionario,
						cajero.fecha_reg,
						cajero.id_usuario_reg,
						cajero.id_usuario_mod,
						cajero.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
					 fun.desc_funcionario1 as desc_funcionario,
						cajero.id_caja,
                        cajero.fecha_inicio,
                        cajero.fecha_fin
						from tes.tcajero cajero
						inner join segu.tusuario usu1 on usu1.id_usuario = cajero.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cajero.id_usuario_mod
      inner join orga.vfuncionario fun on fun.id_funcionario = cajero.id_funcionario        
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'TES_CAJERO_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		18-12-2013 19:39:02
	***********************************/

	elsif(p_transaccion='TES_CAJERO_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_cajero)
					    from tes.tcajero cajero
					    inner join segu.tusuario usu1 on usu1.id_usuario = cajero.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cajero.id_usuario_mod
                        inner join orga.vfuncionario fun on fun.id_funcionario = cajero.id_funcionario
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