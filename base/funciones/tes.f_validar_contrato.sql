--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_validar_contrato (
  p_id_obligacion_pago integer
)
RETURNS boolean AS
$body$
DECLARE
   
    v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
    v_registros_op			record;
    v_count 				integer;
    
BEGIN
	v_nombre_funcion = 'tes.f_validar_contrato';
    
    -- verificamso si tiene por lo menos un concepto de gasto que requeire contrato
    select 
      op.id_contrato,
      op.tipo_obligacion
    into 
      v_registros_op
    from tes.tobligacion_pago op
    where op.id_obligacion_pago = p_id_obligacion_pago;
    
    select
     count(od.id_obligacion_det) 
    into
     v_count
    from tes.tobligacion_det od
    inner join  param.tconcepto_ingas ci on ci.id_concepto_ingas =  od.id_concepto_ingas
    where od.id_obligacion_pago = p_id_obligacion_pago and  'contrato' = ANY(ci.sw_autorizacion);
    
    --TODO, validaciones  adiconales sobre el  contrtao, fecha, montos  etc....
    --TODO validar que obligacione de adquisicioens deberian tener contrato 
    
    IF v_count > 0  and v_registros_op.tipo_obligacion = 'pago_directo' THEN
       IF v_registros_op.id_contrato is null then
              raise exception 'Para esta obligacion de pago es requerido un contrato de referencia';
       END IF;
    END IF;
    
     
     
     
    return True;
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