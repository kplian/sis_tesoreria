CREATE OR REPLACE FUNCTION tes.ft_ts_libro_bancos_extracto_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Tesoreria
 FUNCION: 		tes.ft_ts_libro_bancos_ime_extracto
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'migra.tts_libro_bancos'
 AUTOR: 		 (admin)
 FECHA:	        01-12-2013 09:10:17
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

	v_parametros           	record;
    v_nombre_funcion		varchar;
    g_fecha					date;
    v_resp					varchar;
BEGIN
    v_nombre_funcion = 'tes.ft_ts_libro_bancos_ime_extracto';
    v_parametros = pxp.f_get_record(p_tabla);

	IF pxp.f_existe_parametro(p_tabla,'fecha')THEN
    	g_fecha = v_parametros.fecha;
    ELSE
    	g_fecha = now();
    END IF;

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