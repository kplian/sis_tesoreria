--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.ft_obligacion_det_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.ft_obligacion_det_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tobligacion_det'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        02-04-2013 20:27:35
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

	v_nombre_funcion = 'tes.ft_obligacion_det_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_OBDET_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		02-04-2013 20:27:35
	***********************************/

	if(p_transaccion='TES_OBDET_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						obdet.id_obligacion_det,
						obdet.estado_reg,
						obdet.id_cuenta,
                        cta.nombre_cuenta,
						obdet.id_partida,
                        par.nombre_partida||''-(''||par.codigo||'')'' as nombre_partida,
						obdet.id_auxiliar,
                        aux.nombre_auxiliar||''-(''||aux.codigo_auxiliar||'')'' as nombre_auxiliar,
						obdet.id_concepto_ingas,
                        cig.desc_ingas||''-(''||cig.movimiento||'')'' as nombre_ingas,
						obdet.monto_pago_mo,
						obdet.id_obligacion_pago,
						obdet.id_centro_costo,
                        cc.codigo_cc,
						obdet.monto_pago_mb,
						obdet.factor_porcentual,
						obdet.id_partida_ejecucion_com,
						obdet.fecha_reg,
						obdet.id_usuario_reg,
						obdet.fecha_mod,
						obdet.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        obdet.descripcion	
						from tes.tobligacion_det obdet
						inner join segu.tusuario usu1 on usu1.id_usuario = obdet.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = obdet.id_usuario_mod
				        left join conta.tcuenta cta on cta.id_cuenta=obdet.id_cuenta
                        left join pre.tpartida par on par.id_partida=obdet.id_partida
                        left join conta.tauxiliar aux on aux.id_auxiliar=obdet.id_auxiliar
                        left join param.tconcepto_ingas cig on cig.id_concepto_ingas=obdet.id_concepto_ingas
                        left join param.vcentro_costo cc on cc.id_centro_costo=obdet.id_centro_costo
                        where obdet.id_obligacion_pago='||v_parametros.id_obligacion_pago|| ' and ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'TES_OBDET_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		02-04-2013 20:27:35
	***********************************/

	elsif(p_transaccion='TES_OBDET_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_obligacion_det)
					    from tes.tobligacion_det obdet
					    inner join segu.tusuario usu1 on usu1.id_usuario = obdet.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = obdet.id_usuario_mod
					    left join conta.tcuenta cta on cta.id_cuenta=obdet.id_cuenta
                        left join pre.tpartida par on par.id_partida=obdet.id_partida
                        left join conta.tauxiliar aux on aux.id_auxiliar=obdet.id_auxiliar
                        left join param.tconcepto_ingas cig on cig.id_concepto_ingas=obdet.id_concepto_ingas
                        left join param.vcentro_costo cc on cc.id_centro_costo=obdet.id_centro_costo
                        where obdet.id_obligacion_pago='||v_parametros.id_obligacion_pago|| ' and ';
			
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