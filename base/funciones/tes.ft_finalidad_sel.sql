------------------SQL----------------------

CREATE OR REPLACE FUNCTION tes.ft_finalidad_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Obligaciones de Pago
 FUNCION: 		tes.ft_finalidad_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tfinalidad'
 AUTOR: 		 (gsarmiento)
 FECHA:	        02-12-2014 13:11:02
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

	v_nombre_funcion = 'tes.ft_finalidad_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_FIN_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		gsarmiento	
 	#FECHA:		02-12-2014 13:11:02
	***********************************/

	if(p_transaccion='TES_FIN_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						fin.id_finalidad,
						fin.estado,
						fin.color,
						fin.estado_reg,
						fin.nombre_finalidad,
						fin.id_usuario_ai,
						fin.id_usuario_reg,
						fin.fecha_reg,
						fin.usuario_ai,
						fin.id_usuario_mod,
						fin.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from tes.tfinalidad fin
						left join segu.tusuario usu1 on usu1.id_usuario = fin.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = fin.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'TES_FIN_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		02-12-2014 13:11:02
	***********************************/

	elsif(p_transaccion='TES_FIN_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_finalidad)
					    from tes.tfinalidad fin
					    left join segu.tusuario usu1 on usu1.id_usuario = fin.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = fin.id_usuario_mod
					    where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
            
    /*********************************    
 	#TRANSACCION:  'TES_FINCTABAN_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		03-12-2014 15:19:30
	***********************************/

	elsif(p_transaccion='TES_FINCTABAN_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select fin.id_finalidad,
                                                fin.estado,
                                                fin.color,
                                                fin.estado_reg,
                                                fin.nombre_finalidad,
                        array_to_string(fin.sw_tipo_interfaz, '','',''null'')::varchar                                                  
                        from tes.tcuenta_bancaria cb
                        inner join tes.tfinalidad fin on cb.id_finalidad @> ARRAY[fin.id_finalidad]
                        where ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
            if(v_parametros.vista = 'reporte')then
              v_consulta:=v_consulta||'UNION
                                      SELECT 0 as id_finalidad,
                                             ''activo'' as estado,
                                             ''#FFFFFF'' as color,
                                             ''activo'' as estado_reg,
                                             ''Todos'' as nombre_finalidad';
        	end if;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'TES_FINCTABAN_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		24-04-2013 15:19:30
	***********************************/

	elsif(p_transaccion='TES_FINCTABAN_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(fin.id_finalidad)
                        from tes.tcuenta_bancaria cb
                        inner join tes.tfinalidad fin on cb.id_finalidad @> ARRAY[fin.id_finalidad]
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