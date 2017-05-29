CREATE OR REPLACE FUNCTION tes.f_regla_tiene_fecha_inicio (
  p_id_usuario integer,
  p_id_proceso_wf integer,
  p_id_estado_anterior integer,
  p_id_tipo_estado_actual integer
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA ENDESIS - SISTEMA DE ...
***************************************************************************
 SCRIPT: 		tes.f_regla_tiene_fecha_inicio
 DESCRIPCIÓN: 	Verifica si el proceso de caja es de tipo reposicion y tiene fecha de inicio
 AUTOR: 		Gonzalo Sarmiento
 FECHA:			18/04/2016
 COMENTARIOS:
***************************************************************************
 HISTORIA DE MODIFICACIONES:

 DESCRIPCIÓN:
 AUTOR:
 FECHA:

***************************************************************************/

-------------------------
-- CUERPO DE LA FUNCIÓN --
--------------------------

-- PARÁMETROS FIJOS


DECLARE
	v_resp            varchar;
    v_nombre_funcion  varchar;
    v_registros			record;


BEGIN
     v_nombre_funcion ='tes.f_regla_tiene_fecha_inicio';

     --recuepra datos
      select
         tpc.codigo,
         pc.fecha_inicio
      into
       v_registros
      from tes.tproceso_caja pc
      inner join tes.ttipo_proceso_caja tpc on tpc.id_tipo_proceso_caja=pc.id_tipo_proceso_caja
      where pc.id_proceso_wf = p_id_proceso_wf;


       IF  (v_registros.codigo = 'REPO' and v_registros.fecha_inicio is not NULL)  THEN
         return TRUE;
       END IF;

     return FALSE;


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