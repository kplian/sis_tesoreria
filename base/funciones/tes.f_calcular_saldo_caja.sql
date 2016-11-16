CREATE OR REPLACE FUNCTION tes.f_calcular_saldo_caja (
  p_id_caja integer
)
RETURNS numeric AS
$body$
DECLARE
	v_fecha_apertura		timestamp;
    v_monto_apertura		numeric;
    v_monto_entregado		numeric;
    v_monto_percibido		numeric;
    v_monto_reintegrado		numeric; 
    v_monto_reposicion_caja	numeric;
    v_monto_cierre_caja		numeric;
    v_saldo_caja			numeric;
    v_resp					varchar;    
  
BEGIN
  --calculo de fecha de apertura de caja	
  select max(efe.fecha_reg) into v_fecha_apertura
  from tes.tsolicitud_efectivo efe
  where efe.id_caja=p_id_caja
  and (efe.id_tipo_solicitud=(SELECT id_tipo_solicitud 
  							  FROM tes.ttipo_solicitud
                              WHERE codigo='APECAJ')
       and efe.estado in ('aperturado'));
  
  --monto de apertura
  select efe.monto into v_monto_apertura
  from tes.tsolicitud_efectivo efe
  where efe.id_caja=p_id_caja
  and efe.fecha_reg = v_fecha_apertura
  and (efe.id_tipo_solicitud=(SELECT id_tipo_solicitud 
  							  FROM tes.ttipo_solicitud
                              WHERE codigo='APECAJ')
       and efe.estado in ('aperturado'));
            
  --monto de entregas de efectivo
  select sum(efe.monto) into v_monto_entregado
  from tes.tsolicitud_efectivo efe
  where efe.id_caja=p_id_caja
  and efe.fecha_reg >= v_fecha_apertura
  and (efe.id_tipo_solicitud=(SELECT id_tipo_solicitud 
  							  FROM tes.ttipo_solicitud
                              WHERE codigo='SOLEFE')
       and efe.estado in ('entregado','finalizado'));

  --monto de devoluciones de efectivo
  select sum(efe.monto) into v_monto_percibido
  from tes.tsolicitud_efectivo efe
  where efe.id_caja=p_id_caja
  and efe.fecha_reg >= v_fecha_apertura
  and (efe.id_tipo_solicitud=(SELECT id_tipo_solicitud 
  							  FROM tes.ttipo_solicitud
                              WHERE codigo='DEVEFE')
       and efe.estado in ('devuelto'));

  --monto de reintegro de efectivo
  select sum(efe.monto) into v_monto_reintegrado
  from tes.tsolicitud_efectivo efe
  where efe.id_caja=p_id_caja
  and efe.fecha_reg >= v_fecha_apertura
  and (efe.id_tipo_solicitud=(SELECT id_tipo_solicitud 
  							  FROM tes.ttipo_solicitud
                              WHERE codigo='REPEFE')
       and efe.estado in ('repuesto'));
  
  --monto de reposicion de caja
  select sum(efe.monto) into v_monto_reposicion_caja
  from tes.tsolicitud_efectivo efe
  where efe.id_caja=p_id_caja
  and efe.fecha_reg >= v_fecha_apertura
  and (efe.id_tipo_solicitud=(SELECT id_tipo_solicitud 
  							  FROM tes.ttipo_solicitud
                              WHERE codigo='INGEFE')
       and efe.estado in ('ingresado'));
  
  --monto de cierre caja
  select sum(efe.monto) into v_monto_cierre_caja
  from tes.tsolicitud_efectivo efe
  where efe.id_caja=p_id_caja
  and efe.fecha_reg >= v_fecha_apertura
  and (efe.id_tipo_solicitud=(SELECT id_tipo_solicitud 
  							  FROM tes.ttipo_solicitud
                              WHERE codigo='SALEFE')
       and efe.estado in ('salida'));
  
  raise notice 'v_monto_apertura %', v_monto_apertura;
  raise notice 'v_monto_entregado %', v_monto_entregado;
  raise notice 'v_monto_percibido %', v_monto_percibido;
  raise notice 'v_monto_reintegrado %', v_monto_reintegrado;
  raise notice 'v_monto_reposicion_caja %', v_monto_reposicion_caja;
      raise notice 'v_monto_cierre_caja %', v_monto_cierre_caja;
       
  v_saldo_caja = COALESCE(v_monto_apertura,0) - COALESCE(v_monto_entregado,0) + COALESCE(v_monto_percibido,0) 
  				- COALESCE(v_monto_reintegrado,0) + COALESCE(v_monto_reposicion_caja,0) - COALESCE(v_monto_cierre_caja,0);
                
  return v_saldo_caja;
  
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;