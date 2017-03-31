CREATE OR REPLACE FUNCTION tes.ft_ts_libro_bancos_extracto_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Tesoreria
 FUNCION: 		tes.ft_ts_libro_bancos_sel_extracto
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'migra.tts_libro_bancos'
 AUTOR: 		Grover Velasquez Colque
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
    v_filtro_saldo		varchar;
    v_fecha_anterior	date;
    v_cnx 				varchar;
BEGIN

	v_nombre_funcion = 'tes.ft_ts_libro_bancos_extracto_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'TES_LBAN_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Grover Velasquez Colque
 	#FECHA:		17-11-2014
	***********************************/

	if(p_transaccion='TES_LBANEX_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select id_libro_bancos,
                        num_tramite,
                        id_cuenta_bancaria,
                        fecha as fecha,
                        a_favor,
                        nro_cheque,
                        importe_deposito,
                        nro_liquidacion,
                        detalle,
                        origen,
                        observaciones,
                        importe_cheque,
                        id_libro_bancos_fk,
                        estado,
                        nro_comprobante,
                        comprobante_sigma,
                        indice,
                        estado_reg,
                        tipo,
                        nro_deposito,
                        fecha_reg,
                        id_usuario_reg,
                        fecha_mod,
                        id_usuario_mod,
                        usr_reg,
                        usr_mod,
                        id_depto,
                        nombre_depto,
                        id_proceso_wf,
                        id_estado_wf,
                        fecha_cheque_literal,
                        id_finalidad,
                        nombre_finalidad,
                        color,
                        saldo_deposito,
                        nombre_regional,
                        sistema_origen,
                        notificado,
                        fondo_devolucion_retencion
                        from tes.vlibro_bancos_extracto lban
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			raise notice 'consulta %', v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;


	/*********************************
 	#TRANSACCION:  'TES_LBANEX_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		17-11-2014
	***********************************/

	elsif(p_transaccion='TES_LBANEX_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_libro_bancos)
					    from tes.vlibro_bancos_extracto lban
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