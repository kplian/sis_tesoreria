CREATE OR REPLACE FUNCTION tes.f_modificar_c31_libro_bancos (
  p_id_usuario integer,
  p_id_int_comprobante integer,
  p_c31 varchar
)
RETURNS varchar AS
$body$
/*
	Autor: GSS
    Fecha: 06-05-2016
    Descripción: Función que se encarga de cambiar numero de c31.
*/
DECLARE
	v_nombre_funcion 		varchar;
    v_respuesta				varchar;
	v_resp					varchar;
BEGIN

     v_nombre_funcion:='tes.f_modificar_c31_libro_bancos';

     UPDATE tes.tts_libro_bancos
     SET comprobante_sigma = p_c31,
     id_usuario_mod = p_id_usuario,
     fecha_mod = now()
     WHERE id_int_comprobante = p_id_int_comprobante;
     
    v_respuesta = pxp.f_agrega_clave(v_respuesta,'mensaje','C31 modificado'); 
    v_respuesta = pxp.f_agrega_clave(v_respuesta,'operacion','cambio_exitoso');
    return v_respuesta;

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