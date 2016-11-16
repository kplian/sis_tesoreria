CREATE OR REPLACE FUNCTION tes.f_fun_rechaza_pago_wf (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_estado_wf integer,
  p_id_proceso_wf integer,
  p_codigo_estado varchar
)
RETURNS boolean AS
$body$
/*
*
*  Autor:   GSS
*  DESC:    funcion que actualiza los estados despues del registro de un retroceso 
            en el libro de bancos
*  Fecha:   08/04/2015
*
*/

DECLARE

	v_nombre_funcion   	text;
    v_resp    			varchar;
    v_mensaje varchar;
    v_registros record;
   
	
    
BEGIN

	v_nombre_funcion = 'tes.f_fun_rechaza_pago_wf';
    
        SELECT
              lb.id_libro_bancos,
              lb.id_estado_wf,
              pw.id_tipo_proceso,
              pw.id_proceso_wf,
              lb.num_tramite
             into
              v_registros
               
         FROM tes.tts_libro_bancos lb
         inner join wf.tproceso_wf pw on pw.id_proceso_wf = lb.id_proceso_wf
         WHERE  sol.id_proceso_wf = p_id_proceso_wf;
    
         -- actualiza estado en el libro de bancos
         update tes.tts_libro_bancos  lb set 
           id_estado_wf =  p_id_estado_wf,
           estado = p_codigo_estado,
           id_usuario_mod=p_id_usuario,
           fecha_mod=now()
         where id_solicitud = v_registros.id_libro_bancos;
                 

          RETURN   TRUE;



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