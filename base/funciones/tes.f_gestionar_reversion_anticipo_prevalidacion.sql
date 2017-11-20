--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_gestionar_reversion_anticipo_prevalidacion (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_int_comprobante integer,
  p_conexion varchar = NULL::character varying
)
RETURNS boolean AS
$body$
/*

    HISTORIAL:
   	
 ISSUE            FECHA:		           AUTOR                 DESCRIPCION
 #31, ETR       01/11/2017              RAC KPLIAN            Crear la funcion  para  revertir el presupuesto anticipado antres de validar el comprobante
 
               

*/


DECLARE

	 v_nombre_funcion   				text;
	 v_resp							varchar;
     v_registros 					record;
     v_id_estado_actual  			integer;
     va_id_tipo_estado 				integer[];
     va_codigo_estado 				varchar[];
     va_disparador    				varchar[];
     va_regla        				varchar[]; 
     va_prioridad     				integer[];    
     v_tipo_sol   					varchar;    
     v_nro_cuota 					numeric;    
     v_id_proceso_wf 				integer;
     v_id_estado_wf 				integer;
     v_codigo_estado 				varchar;
     v_id_plan_pago 				integer;
     v_verficacion  				boolean;
     v_verficacion2 				varchar[];     
     v_id_tipo_estado  				integer;
     v_codigo_proceso_llave_wf   	varchar;
    
BEGIN

        v_nombre_funcion = 'tes.f_gestionar_reversion_anticipo_prevalidacion';
     
       -- 1) con el id_comprobante identificar el plan de pago
        select 
           pp.id_obligacion_pago,
           pp.id_plan_pago,
           pp.tipo,
           pp.estado
         into
          v_registros  
        from tes.tplan_pago pp
        where pp.id_int_comprobante = p_id_int_comprobante;
         
        
       --2) Validar que se tenga un pla de pagos
        
         IF  v_registros.id_plan_pago is NULL  THEN
            raise exception 'El comprobante no esta relacionado con plan de pagos';
         END IF;
    
    
       --3) -- revertir el presupuesto de las facturas rendidas
                     
       IF not  tes.f_gestionar_presupuesto_tesoreria(
                         v_registros.id_obligacion_pago, 
                         p_id_usuario, 
                         'revertir_anticipo',
                         v_registros.id_plan_pago ) THEN
                                       
           raise exception 'error al revertir presupuesto del anticipo';
        END IF;
         
        
      
  
RETURN  TRUE;



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