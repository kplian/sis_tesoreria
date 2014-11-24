--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.ft_ts_libro_bancos_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Tesoreria
 FUNCION: 		tes.ft_ts_libro_bancos_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'migra.tts_libro_bancos'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        17-11-2014 09:10:17
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

	v_nombre_funcion = 'tes.ft_ts_libro_bancos_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_LBAN_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		17-11-2014
	***********************************/

	if(p_transaccion='TES_LBAN_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						lban.id_libro_bancos,
                        lban.num_tramite,
						lban.id_cuenta_bancaria,
						lban.fecha,
						lban.a_favor,
						lban.nro_cheque,
						lban.importe_deposito,
						lban.nro_liquidacion,
						lban.detalle,
						lban.origen,
						lban.observaciones,
						lban.importe_cheque,
						lban.id_libro_bancos_fk,
						lban.estado,
						lban.nro_comprobante,
						lban.indice,
						lban.estado_reg,
						lban.tipo,
						lban.fecha_reg,
						lban.id_usuario_reg,
						lban.fecha_mod,
						lban.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        lban.id_depto,
                        depto.nombre,
                        lban.id_proceso_wf,
                        lban.id_estado_wf,
                        pxp.f_fecha_literal(lban.fecha) as fecha_cheque_literal	
						from tes.tts_libro_bancos lban
						inner join segu.tusuario usu1 on usu1.id_usuario = lban.id_usuario_reg
                        left join param.tdepto depto on depto.id_depto=lban.id_depto
						left join segu.tusuario usu2 on usu2.id_usuario = lban.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'TES_LBAN_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		17-11-2014
	***********************************/

	elsif(p_transaccion='TES_LBAN_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_libro_bancos)
					    from tes.tts_libro_bancos lban
					    inner join segu.tusuario usu1 on usu1.id_usuario = lban.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = lban.id_usuario_mod
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