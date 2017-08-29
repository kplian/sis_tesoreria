CREATE OR REPLACE FUNCTION tes.f_calcular_cuenta_bancaria_pp ( 
  p_id_plan_pago integer
)
RETURNS boolean AS
$body$
DECLARE
  
  v_total_detalle 		numeric;
  v_factor				numeric;
  v_id_obligacion_det	integer;
  v_resp		        varchar;
  v_nombre_funcion      text;
  v_mensaje_error       text;
  v_registros			record;
  va_id_tcc				integer[];
  v_reg_pp				record;
  
BEGIN
	
    v_nombre_funcion = 'tes.f_calcular_cuenta_bancaria_pp';
    
    --validar que el plan de pago no estado finalizado
    
    select
       pp.id_plan_pago ,
       pp.estado
     into
       v_reg_pp
    from tes.tplan_pago pp
    where pp.id_plan_pago = p_id_plan_pago;
    
    IF v_reg_pp.estado in ('pendiente','devengado','pagado','anticipado','devuelto') THEN
      raise exception 'el plan de pago  ya fue contabilizado no se peude modificar las cuentas bancarias';
    END IF;
    
    
    select 
       pxp.aggarray(tcc.id_tipo_cc_techo)
     into
       va_id_tcc  
    from tes.tplan_pago pp
    inner join tes.tobligacion_pago op on op.id_obligacion_pago = pp.id_obligacion_pago
    inner join tes.tobligacion_det od on od.id_obligacion_pago = op.id_obligacion_pago
    inner join param.tcentro_costo cc on cc.id_centro_costo = od.id_centro_costo
    inner join param.vtipo_cc_techo tcc on tcc.id_tipo_cc = cc.id_tipo_cc
    where pp.id_plan_pago = p_id_plan_pago
          and od.estado_reg = 'activo';
    
    
    select 
      tcl.id_cuenta_bancaria,
      tcl.id_depto
    into
      v_registros
    from tes.ttipo_cc_cuenta_libro tcl
    where      tcl.id_tipo_cc =ANY(va_id_tcc) 
          and  tcl.estado_reg = 'activo'
          OFFSET 0 limit 1 ;
    
    
    --modificar plan de pagos
    
    update tes.tplan_pago set
       id_depto_lb = v_registros.id_depto,
       id_cuenta_bancaria = v_registros.id_cuenta_bancaria
     where id_plan_pago = p_id_plan_pago;
       
      
    return TRUE;
    
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