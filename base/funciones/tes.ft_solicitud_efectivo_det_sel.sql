CREATE OR REPLACE FUNCTION tes.ft_solicitud_efectivo_det_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Obligaciones de Pago
 FUNCION: 		tes.ft_solicitud_efectivo_det_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tsolicitud_efectivo_det'
 AUTOR: 		 (gsarmiento)
 FECHA:	        24-11-2015 14:14:27
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

	v_nombre_funcion = 'tes.ft_solicitud_efectivo_det_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_SOLDET_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		gsarmiento	
 	#FECHA:		24-11-2015 14:14:27
	***********************************/

	if(p_transaccion='TES_SOLDET_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						soldet.id_solicitud_efectivo_det,
						soldet.id_solicitud_efectivo,
						soldet.id_cc,
            			cc.codigo_cc,
						soldet.id_concepto_ingas,
                        cingas.desc_ingas,
						soldet.id_partida_ejecucion,
						soldet.estado_reg,
						soldet.monto,
						soldet.id_usuario_ai,
						soldet.id_usuario_reg,
						soldet.usuario_ai,
						soldet.fecha_reg,
						soldet.id_usuario_mod,
						soldet.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from tes.tsolicitud_efectivo_det soldet
                        inner join param.vcentro_costo cc on cc.id_centro_costo=soldet.id_cc
						inner join param.tconcepto_ingas cingas on cingas.id_concepto_ingas=soldet.id_concepto_ingas
						inner join segu.tusuario usu1 on usu1.id_usuario = soldet.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = soldet.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'TES_SOLDET_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		24-11-2015 14:14:27
	***********************************/

	elsif(p_transaccion='TES_SOLDET_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_solicitud_efectivo_det)
					    from tes.tsolicitud_efectivo_det soldet
                        inner join param.vcentro_costo cc on cc.id_centro_costo=soldet.id_cc
						inner join param.tconcepto_ingas cingas on cingas.id_concepto_ingas=soldet.id_concepto_ingas
					    inner join segu.tusuario usu1 on usu1.id_usuario = soldet.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = soldet.id_usuario_mod
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