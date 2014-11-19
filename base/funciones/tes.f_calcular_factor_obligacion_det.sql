CREATE OR REPLACE FUNCTION tes.f_calcular_factor_obligacion_det (
  p_id_obligacion integer
)
RETURNS varchar AS
$body$
DECLARE
  v_total_detalle 		numeric;
  v_factor				numeric;
  v_id_obligacion_det	integer;
  v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
BEGIN
	v_nombre_funcion = 'tes.f_calcular_factor_obligacion_det';
       select 
        sum(od.monto_pago_mo)
       into
        v_total_detalle
       from tes.tobligacion_det od
       where od.id_obligacion_pago = p_id_obligacion and od.estado_reg ='activo'; 
                         
       IF v_total_detalle = 0 or v_total_detalle is null THEN
                         
           raise exception 'No existe el detalle de obligacion...';
                         
       END IF; 
                         
                  
      ------------------------------------------------------------
      --calcula el factor de prorrateo de la obligacion  detalle
      -----------------------------------------------------------
                        
      update tes.tobligacion_det set
      factor_porcentual = (monto_pago_mo/v_total_detalle)
      where estado_reg = 'activo' and id_obligacion_pago=p_id_obligacion;
                        
      --testeo
      select sum(od.factor_porcentual) into v_factor
      from tes.tobligacion_det od
      where od.id_obligacion_pago = p_id_obligacion and od.estado_reg='activo';
                        
                        
      v_factor = v_factor - 1;
                        
                        
      select od.id_obligacion_det into v_id_obligacion_det
      from tes.tobligacion_det od
      where od.id_obligacion_pago = p_id_obligacion
      and od.estado_reg = 'activo'
      limit 1 offset 0; 
                        
                        
      --actualiza el factor del primer registro  para que la suma de siempre 1
      update tes.tobligacion_det  set
      factor_porcentual=  factor_porcentual - v_factor
      where estado_reg = 'activo'
      and id_obligacion_det= v_id_obligacion_det;
      
      return 'exito';
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