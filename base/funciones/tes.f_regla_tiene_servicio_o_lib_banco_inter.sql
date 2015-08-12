--------------- SQL ---------------

CREATE FUNCTION tes.f_regla_tiene_servicio_o_lib_banco_inter (
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
 SCRIPT: 		tes.f_regla_tiene_servicio
 DESCRIPCIÓN: 	Verifica si el proceso de obligacion de pago tiene almenos un concepto tipo servicio
 AUTOR: 		Rensi Arteaga Copari
 FECHA:			22/07/2015
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
    v_id_cotizacion   integer;
    v_cfg_pri_lb		varchar;
    v_registros			record;
    

BEGIN
     v_nombre_funcion ='tes.f_regla_tiene_servicio_o_lib_banco_inter';
  
     --recuepra datos
      select 
         pp.id_obligacion_pago,
         pp.id_depto_lb,
         dep.prioridad,
         op.tipo_obligacion
      into
       v_registros
      from tes.tplan_pago pp
      inner join tes.tobligacion_pago op on op.id_obligacion_pago = pp.id_obligacion_pago
      inner join param.tdepto dep on dep.id_depto = pp.id_depto_lb
      where pp.id_proceso_wf = p_id_proceso_wf;
  
        --recuperamos la configuraciond de prioridad de
        --libros de bancos internacioanles
       v_cfg_pri_lb = pxp.f_get_variable_global('tes_prioridad_lb_internacional');
       
       IF v_cfg_pri_lb  is NULL THEN
         raise exception 'Configure la variable global tes_prioridad_lb_internacional';
       END IF;
       
       IF  v_registros.id_depto_lb is NULL  THEN
         --raise exception 'El departamento de libro de bancos no fue especificado';
         return FALSE;
       END IF;
       -- vemos si el libro de bancos es internacional...
       IF  v_registros.prioridad  = v_cfg_pri_lb::integer THEN
          return TRUE;
       END IF;
    
      --si no es departamento de libro de bancos revisamos si tiene algun servicio
      IF exists (
                      select 1
                      from tes.tobligacion_det od
                      inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = od.id_concepto_ingas 
                      where    od.id_obligacion_pago =  v_registros.id_obligacion_pago 
                           and od.estado_reg = 'activo'
                           and lower(cig.tipo) = 'servicio'
                             
                     ) THEN
                  --personal de cosots no queire revisar los que iene de adquisiciones ....    
                 IF  v_registros.tipo_obligacion  != 'adquisiciones' THEN
                    return TRUE;
                 END IF;
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