--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_movimiento_caja_fecha (
  p_id_caja integer,
  p_fecha_desde date,
  p_fecha_hasta date
)
RETURNS TABLE (
  tipo_solicitud varchar,
  id_solicitud_efectivo integer,
  nro_tramite varchar,
  monto numeric,
  fecha date,
  monto_contable numeric,
  id_int_comprobante integer,
  fecha_cbte date,
  observacion varchar
) AS
$body$
DECLARE

	v_fecha date;
	v_saldo_anterior numeric;

BEGIN

	---------------------------------
    -- OBTENCIÓN DEL SALDO ANTERIOR
    ---------------------------------
	--Calcula la fecha a la cual generar el saldo anterior
    v_fecha = p_fecha_desde - CAST('1 days' AS INTERVAL);
    
    v_saldo_anterior = tes.f_calcular_saldo_caja_periodo(p_id_caja, v_fecha);

	/*select sum(movimiento.monto)
    into v_saldo_anterior
    from (
        --Apertura (ingreso)
        select
        se.id_solicitud_efectivo, se.nro_tramite, se.monto, se.fecha_ult_mov as fecha --coalesce(se.fecha_entrega,se.fecha)
        from tes.tsolicitud_efectivo se
        inner join tes.ttipo_solicitud ts
        on ts.id_tipo_solicitud = se.id_tipo_solicitud
        and ts.codigo = 'APECAJ'
        and se.estado = 'aperturado'
        where id_solicitud_efectivo_fk is null
        and se.id_caja = p_id_caja
--        and coalesce(se.fecha_entrega, se.fecha) <= v_fecha
        and se.fecha_ult_mov <= v_fecha
        union
        --Ajuste apertura
        select 
        se.id_solicitud_efectivo, se.nro_tramite, se.monto, se.fecha_ult_mov as fecha
        from tes.tsolicitud_efectivo se
        inner join tes.ttipo_solicitud ts
        on ts.id_tipo_solicitud = se.id_tipo_solicitud
        and ts.codigo='INGEFE'
        where se.id_caja = p_id_caja
        and se.estado in ('ingresado') 
        and se.motivo = 'apertura'
        and se.fecha_ult_mov <= v_fecha
    	union
        --Entregado (egreso)
        select
        se.id_solicitud_efectivo, se.nro_tramite, se.monto*(-1) as monto, se.fecha_ult_mov as fecha--coalesce(se.fecha_entrega,se.fecha)
        from tes.tsolicitud_efectivo se
        inner join tes.ttipo_solicitud ts
        on ts.id_tipo_solicitud = se.id_tipo_solicitud
        and ts.codigo = 'SOLEFE'
        and se.estado in ('entregado','finalizado')
        where id_solicitud_efectivo_fk is null
        and se.id_caja = p_id_caja
        --and coalesce(se.fecha_entrega, se.fecha) <= v_fecha
        and se.fecha_ult_mov <= v_fecha
        union
        --Repuesto a solicitante por rendición (egreso)
        select
        se.id_solicitud_efectivo, se.nro_tramite, se.monto*(-1) as monto, se.fecha_ult_mov as fecha--coalesce(se.fecha_entrega,se.fecha)
        from tes.tsolicitud_efectivo se
        inner join tes.ttipo_solicitud ts
        on ts.id_tipo_solicitud = se.id_tipo_solicitud
        and ts.codigo in ('REPEFE')
        where id_solicitud_efectivo_fk is not null
        and se.estado in ('repuesto')
        and se.id_caja = p_id_caja
        --and coalesce(se.fecha_entrega, se.fecha) <= v_fecha
        and se.fecha_ult_mov <= v_fecha
        union
        --Devuelto por el funcionario por rendición (ingreso)
        select
        se.id_solicitud_efectivo, se.nro_tramite, se.monto, se.fecha_ult_mov as fecha--coalesce(se.fecha_entrega,se.fecha)
        from tes.tsolicitud_efectivo se
        inner join tes.ttipo_solicitud ts
        on ts.id_tipo_solicitud = se.id_tipo_solicitud
        and ts.codigo in ('DEVEFE')
        where id_solicitud_efectivo_fk is not null
        and se.estado in ('devuelto')
        and se.id_caja = p_id_caja
        --and coalesce(se.fecha_entrega, se.fecha) <= v_fecha
        and se.fecha_ult_mov <= v_fecha
        union
        --Ingreso (ingreso)
        select
        se.id_solicitud_efectivo, se.nro_tramite, se.monto, se.fecha_ult_mov as fecha--coalesce(se.fecha_entrega,se.fecha)
        from tes.tsolicitud_efectivo se
        inner join tes.ttipo_solicitud ts
        on ts.id_tipo_solicitud = se.id_tipo_solicitud
        and ts.codigo = 'INGEFE'
        and se.estado = 'ingresado'
        where id_solicitud_efectivo_fk is null
        and se.motivo != 'apertura'
        and se.id_caja = p_id_caja
        --and coalesce(se.fecha_entrega, se.fecha) <= v_fecha
        and se.fecha_ult_mov <= v_fecha
        /*union
        --Documentos compra venta
        select 
        null as id_solicitud_efectivo, null as nro_tramite, sum(dc.importe_pago_liquido::numeric)*(-1) as monto, v_fecha as fecha
        from tes.tsolicitud_rendicion_det rend
        inner join tes.tsolicitud_efectivo solren on solren.id_solicitud_efectivo = rend.id_solicitud_efectivo
        inner join tes.tsolicitud_efectivo solefe on solefe.id_solicitud_efectivo = solren.id_solicitud_efectivo_fk
        inner join tes.tcaja caja on caja.id_caja = solefe.id_caja
        inner join conta.tdoc_compra_venta dc on dc.id_doc_compra_venta = rend.id_documento_respaldo
        inner join param.tplantilla pla on pla.id_plantilla = dc.id_plantilla
        inner join tes.tproceso_caja pro on pro.id_proceso_caja = rend.id_proceso_caja
        where caja.id_caja = p_id_caja
        and solren.estado='rendido' 
        and pro.fecha <= v_fecha and pro.fecha >= '01-01-2018'::date*/
	) movimiento;*/
    
    ------------------------------
    -- MOVIMIENTO DE LA CAJA
    ------------------------------
    RETURN QUERY
    --Saldo Anterior
    select
    'Saldo anterior'::varchar,null,null,v_saldo_anterior,v_fecha, v_saldo_anterior,null::integer as id_int_comprobante, null::date as fecha_cbte, 'Saldo anterior'::varchar
    union
    --Apertura (ingreso)
    select
    'ingreso'::varchar as tipo_solicitud,se.id_solicitud_efectivo, se.nro_tramite, se.monto, se.fecha_ult_mov as fecha, 0, null as id_int_comprobante, null as fecha_cbte,--coalesce(se.fecha_entrega,se.fecha)
    'Apertura'
    from tes.tsolicitud_efectivo se
    inner join tes.ttipo_solicitud ts
    on ts.id_tipo_solicitud = se.id_tipo_solicitud
    and ts.codigo = 'APECAJ'
    and se.estado = 'aperturado'
    where id_solicitud_efectivo_fk is null
    and se.id_caja = p_id_caja
    --and coalesce(se.fecha_entrega, se.fecha) between p_fecha_desde and p_fecha_hasta
    and se.fecha_ult_mov  between p_fecha_desde and p_fecha_hasta
    union
    --Ajuste apertura
    select 
    case
    	when se.monto < 0 then 'egreso'::varchar	
        else 'ingreso'::varchar
    end as tipo_solicitud,
    se.id_solicitud_efectivo, se.nro_tramite, se.monto, se.fecha_ult_mov as fecha,0, null as id_int_comprobante, null as fecha_cbte,
    'Ajuste apertura'
    from tes.tsolicitud_efectivo se
    inner join tes.ttipo_solicitud ts
    on ts.id_tipo_solicitud = se.id_tipo_solicitud
    and ts.codigo='INGEFE'
    where se.id_caja = p_id_caja
    and se.estado in ('ingresado') 
    and se.motivo = 'apertura'
    and se.fecha_ult_mov  between p_fecha_desde and p_fecha_hasta
    union
    --Entregado (egreso)
    select
    'egreso'::varchar as tipo_solicitud,se.id_solicitud_efectivo, se.nro_tramite, se.monto*(-1), se.fecha_ult_mov as fecha,0, null as id_int_comprobante, null as fecha_cbte,--coalesce(se.fecha_entrega,se.fecha)
    'Entregado'
    from tes.tsolicitud_efectivo se
    inner join tes.ttipo_solicitud ts
    on ts.id_tipo_solicitud = se.id_tipo_solicitud
    and ts.codigo = 'SOLEFE'
    and se.estado in ('entregado','finalizado')
    where id_solicitud_efectivo_fk is null
    and se.id_caja = p_id_caja
    --and coalesce(se.fecha_entrega, se.fecha) between p_fecha_desde and p_fecha_hasta
    and se.fecha_ult_mov  between p_fecha_desde and p_fecha_hasta
    union
    --Rendido
    select
    'egreso'::varchar as tipo_solicitud,se.id_solicitud_efectivo, se.nro_tramite, 0, se.fecha_ult_mov as fecha,dcv.importe_pago_liquido*(-1),
    cb.id_int_comprobante as id_int_comprobante, cb.fecha as fecha_cbte,
    'Rendido'--coalesce(se.fecha_entrega,se.fecha)
    from tes.tsolicitud_efectivo se
    inner join tes.ttipo_solicitud ts
    on ts.id_tipo_solicitud = se.id_tipo_solicitud
    and ts.codigo = 'RENEFE'
    inner join tes.tsolicitud_rendicion_det rd
    on rd.id_solicitud_efectivo = se.id_solicitud_efectivo
    left join tes.tproceso_caja pc
    on pc.id_proceso_caja = rd.id_proceso_caja
    left join conta.tint_comprobante cb
    on cb.id_int_comprobante = pc.id_int_comprobante
    left join conta.tdoc_compra_venta dcv
    on dcv.id_doc_compra_venta = rd.id_documento_respaldo
    where id_solicitud_efectivo_fk is not null
    and se.estado = 'rendido' 
    and se.id_caja = p_id_caja
    and se.fecha_ult_mov  between p_fecha_desde and p_fecha_hasta
    union
    --Repuesto a solicitante por rendición (egreso)
    select
    'egreso'::varchar as tipo_solicitud,se.id_solicitud_efectivo, se.nro_tramite, se.monto*(-1), se.fecha_ult_mov as fecha, 0, null as id_int_comprobante, null as fecha_cbte,--coalesce(se.fecha_entrega,se.fecha)
    'Repuesto a solicitante'
    from tes.tsolicitud_efectivo se
    inner join tes.ttipo_solicitud ts
    on ts.id_tipo_solicitud = se.id_tipo_solicitud
    and ts.codigo in ('REPEFE')
    where id_solicitud_efectivo_fk is not null
    and se.estado in ('repuesto')
    and se.id_caja = p_id_caja
    --and coalesce(se.fecha_entrega, se.fecha) between p_fecha_desde and p_fecha_hasta
    and se.fecha_ult_mov  between p_fecha_desde and p_fecha_hasta
    union
    --Devuelto por el funcionario por rendición (ingreso)
    select
    'ingreso'::varchar as tipo_solicitud,se.id_solicitud_efectivo, se.nro_tramite, se.monto, se.fecha_ult_mov as fecha, 0, null as id_int_comprobante, null as fecha_cbte,--coalesce(se.fecha_entrega,se.fecha)
    'Devuelto por el funcionario'
    from tes.tsolicitud_efectivo se
    inner join tes.ttipo_solicitud ts
    on ts.id_tipo_solicitud = se.id_tipo_solicitud
    and ts.codigo in ('DEVEFE')
    where id_solicitud_efectivo_fk is not null
    and se.estado in ('devuelto')
    and se.id_caja = p_id_caja
    --and coalesce(se.fecha_entrega, se.fecha) between p_fecha_desde and p_fecha_hasta
    and se.fecha_ult_mov  between p_fecha_desde and p_fecha_hasta
    union
    --Ingreso (ingreso)
    select
    'ingreso'::varchar as tipo_solicitud,se.id_solicitud_efectivo, se.nro_tramite, 0, se.fecha_ult_mov as fecha, se.monto, null as id_int_comprobante, null as fecha_cbte,--coalesce(se.fecha_entrega,se.fecha)
    'Ingreso'
    from tes.tsolicitud_efectivo se
    inner join tes.ttipo_solicitud ts
    on ts.id_tipo_solicitud = se.id_tipo_solicitud
    and ts.codigo = 'INGEFE'
    and se.estado = 'ingresado'
    where id_solicitud_efectivo_fk is null
    and se.id_caja = p_id_caja
    and se.motivo != 'apertura'
    --and coalesce(se.fecha_entrega, se.fecha) between p_fecha_desde and p_fecha_hasta
    and se.fecha_ult_mov  between p_fecha_desde and p_fecha_hasta
    order by 5;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100 ROWS 1000;