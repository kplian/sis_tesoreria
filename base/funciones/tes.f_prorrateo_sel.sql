--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_prorrateo_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.f_prorrateo_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tprorrateo'
 AUTOR: 		 (admin)
 FECHA:	        16-04-2013 01:45:48
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

	v_nombre_funcion = 'tes.f_prorrateo_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_PRO_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		16-04-2013 01:45:48
	***********************************/

	if(p_transaccion='TES_PRO_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						pro.id_prorrateo,
						pro.id_obligacion_det,
						pro.monto_ejecutar_mb,
						pro.id_partida_ejecucion_dev,
						pro.id_plan_pago,
						pro.id_transaccion_dev,
						pro.id_transaccion_pag,
						pro.id_partida_ejecucion_pag,
						pro.monto_ejecutar_mo,
						pro.estado_reg,
						pro.fecha_reg,
						pro.id_usuario_reg,
						pro.fecha_mod,
						pro.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        cc.codigo_cc,
                        cig.desc_ingas,
                        od.descripcion	
						from tes.tprorrateo pro
						inner join tes.tobligacion_det od on od.id_obligacion_det = pro.id_obligacion_det
                        inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = od.id_concepto_ingas
                        inner join segu.tusuario usu1 on usu1.id_usuario = pro.id_usuario_reg
                        inner join param.vcentro_costo cc on cc.id_centro_costo=od.id_centro_costo
                        left join segu.tusuario usu2 on usu2.id_usuario = pro.id_usuario_mod
                        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'TES_PRO_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		16-04-2013 01:45:48
	***********************************/

	elsif(p_transaccion='TES_PRO_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_prorrateo)
					    from tes.tprorrateo pro
						inner join tes.tobligacion_det od on od.id_obligacion_det = pro.id_obligacion_det
                        inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = od.id_concepto_ingas
                        inner join segu.tusuario usu1 on usu1.id_usuario = pro.id_usuario_reg
                        inner join param.vcentro_costo cc on cc.id_centro_costo=od.id_centro_costo
                        
						left join segu.tusuario usu2 on usu2.id_usuario = pro.id_usuario_mod
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