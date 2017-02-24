CREATE OR REPLACE FUNCTION informix.f_modificar_datos_web_reemision (
  p_billete varchar,
  p_billete_original varchar
)
RETURNS void AS
$body$
DECLARE
  v_consulta    		varchar;
	v_registros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    us 					varchar;
    v_fecha_texto		varchar;
    v_id_agencia		integer;
    v_detalle			record;
    v_id_boleto			integer;
    v_id_comision		integer;
    v_id_lugar			integer;
    v_id_impuesto		integer;
    v_id_forma_pago		integer;
    v_id_moneda			integer;    
    v_id_boleto_antiguo	integer;
    v_forma_pago		record;
    v_estado			varchar;
    v_fpago				varchar;
    v_error				varchar;
    v_id_alarma			integer;
    v_factura_antigua	record;
    v_marcar_procesado	varchar;
    v_agt				varchar;
    v_numero_tarjeta	varchar;
    v_tarjeta			varchar;
    
    
BEGIN
	v_marcar_procesado = 'si';
  	v_nombre_funcion = 'informix.f_modificar_datos_web_reemision';   
   DROP FOREIGN TABLE IF EXISTS informix.boletos_modificacion;
   DROP FOREIGN TABLE IF EXISTS informix.boletos_fpago_modificacion;     
    
    execute ('CREATE FOREIGN TABLE informix.boletos_modificacion (
      pais varchar(3),
	estacion varchar(3),
	tipdoc varchar(6),
	billete numeric(13),
	vendedor varchar(10),
	estado varchar(1),
	ruta varchar(1),
	fecha date,
	tcambio numeric(13,7),
	serie varchar(3),
	verifcdr varchar(1),
	cupones smallint,
	agt numeric(8),
	agtnoiata varchar(8),
	pasajero varchar(60),
	tipopax varchar(3),
	incremento numeric(5,2),
	descuento numeric(5,2),
	orden varchar(15),
	origen varchar(3),
	destino varchar(3),
	conexion varchar(1),
	moneda varchar(3),
	neto numeric(16,2),
	tarifa varchar(15),
	importe numeric(16,2),
	canje varchar(1),
	usuario varchar(12),
	diplomatico varchar(1),
	vvarcharter varchar(1),
	tourcode varchar(15),
	pnrr varchar(13),
	cpui varchar(4),
	trnc varchar(6),
	fecproc date,
	bolori varchar(100),
	horareg varchar(8),
	fechareg date,
	retbsp varchar(3),
	codgds varchar(4),
	idcenproc varchar(6),
	nomarch varchar(30),
	formap_mediopago varchar(15)
      ) SERVER sai1

    OPTIONS ( table ''boletos'',
    database ''ingresos'',
      informixdir ''/opt/informix'',
      client_locale ''en_US.utf8'',
      informixserver ''sai1'');');
    
   
    
    
    execute ('CREATE FOREIGN TABLE informix.boletos_fpago_modificacion (
      pais varchar(3),
      estacion varchar(3),
      tipdoc varchar(6),
      billete numeric(13),
      renglon smallint,
      forma varchar(4),
      tarjeta varchar(6),
      numero varchar(20),
      importe numeric(16,2),
      moneda varchar(3),
      tcambio numeric(13,7),
      agt numeric(8),
      agtnoiata varchar(8),
      grupo varchar(3),
      estado varchar(1),
      fecha date,
      usuario varchar(12),
      cuotas smallint,
      recargo numeric(16,2),
      autoriza varchar(6),
      comprbnt integer,
      fecproc date,
      ctacte varchar(15),
      nomaut varchar(30),
      pagomco numeric(15),
      observa varchar(80),
      retbsp varchar(3),
      idcenproc varchar(6),
      nomarch varchar(30)
      ) SERVER sai1

    OPTIONS ( table ''fpago'',
    database ''ingresos'',
      informixdir ''/opt/informix'',
      client_locale ''en_US.utf8'',
      informixserver ''sai1'');');
    
    select id_boleto into v_id_boleto
    from obingresos.tboleto b     
    where b.nro_boleto = p_billete and estado_reg = 'activo';
    
    select * into v_detalle
    from obingresos.tdetalle_boletos_web d
    where d.billete = p_billete_original;
    
    
    
    if (v_detalle is null) then
    	v_error = 'CONTROLADO - No se puede procesar la modificacion de ventas web porque no existe el boleto ' || p_billete_original || ' en el detalle de ventas web';
    	v_id_alarma = (select param.f_inserta_alarma_dblink (1,'Error al procesar modificaciones de venta web',v_error,'jaime.rivera@boa.bo,aldo.zeballos@boa.bo,dcamacho@boa.bo'));
        raise exception '%',v_error;    
    end if;
        
    if (v_id_boleto is null ) then
    	v_error = 'CONTROLADO - No se puede procesar la modificacion de ventas web porque no existe el boleto ' || p_billete;
    	v_id_alarma = (select param.f_inserta_alarma_dblink (1,'Error al procesar modificaciones de venta web',v_error,'jaime.rivera@boa.bo,aldo.zeballos@boa.bo,dcamacho@boa.bo'));
        raise exception '%',v_error;
    end if;
    
    select a.id_agencia into v_id_agencia
    from obingresos.tagencia a
    where a.codigo = '56999960';
    
    v_fpago = (case when v_detalle.moneda = 'USD' then 'U' else '' end);
    
    select bfp.*,m.codigo_internacional into v_forma_pago
    from obingresos.tboleto_forma_pago bfp 
    inner join obingresos.tforma_pago fp on bfp.id_forma_pago = fp.id_forma_pago
    inner join param.tmoneda m on m.id_moneda = fp.id_moneda
    where bfp.id_boleto = v_id_boleto;
    v_error = '';    
    --validar monto y moneda y moneda
    if (v_detalle.importe != v_forma_pago.importe) then
        v_error = 'CONTROLADO - El importe de la forma de pago del boleto reemitido no iguala con el importe de la venta web para el boleto original: ' || p_billete;
        v_id_alarma = (select param.f_inserta_alarma_dblink (1,'Error al procesar modificaciones de venta web',v_error,'jaime.rivera@boa.bo,aldo.zeballos@boa.bo,dcamacho@boa.bo'));
                
    end if;
                
    if (v_detalle.moneda != v_forma_pago.codigo_internacional) then
        v_error = 'CONTROLADO - La moneda de la forma de pago no iguala con la moneda de la venta web para el boleto original: ' || p_billete;
        v_id_alarma = (select param.f_inserta_alarma_dblink (1,'Error al procesar modificaciones de venta web',v_error,'jaime.rivera@boa.bo,aldo.zeballos@boa.bo,dcamacho@boa.bo'));
        raise exception '%',v_error;
    end if;           
            
                
    update
    obingresos.tboleto
    set id_agencia =v_id_agencia       
    where id_boleto = v_id_boleto;
                
    select fp.id_forma_pago into v_id_forma_pago
    from obingresos.tforma_pago fp
    inner join param.tmoneda m on m.id_moneda = fp.id_moneda
    where fp.codigo like v_detalle.entidad_pago || v_fpago; 
            
    if (v_id_forma_pago is null) then
    	v_error = 'CONTROLADO - No existe la forma de pago : ' ||v_detalle.entidad_pago || v_fpago;
        v_id_alarma = (select param.f_inserta_alarma_dblink (1,'Error al procesar modificaciones de venta web',v_error,'jaime.rivera@boa.bo,aldo.zeballos@boa.bo,dcamacho@boa.bo'));
        raise exception 'No existe la forma de pago : % % ' ,v_detalle.entidad_pago , v_fpago;
    end if;
                
    update obingresos.tboleto_forma_pago 
    set id_forma_pago = v_id_forma_pago
    where id_boleto = v_id_boleto;
        
    update informix.boletos_fpago_modificacion
    set forma = v_detalle.entidad_pago || v_fpago,
    moneda = v_detalle.moneda,
    agt = 56999960,
    ctacte='BE00001'
    where billete = p_billete::numeric; 
    
    update informix.boletos_modificacion
    set agt = 56999960,
        fechareg = now()::date,
        horareg = to_char(now()::date,'HH24:MI:SS')::varchar,
        formap_mediopago = v_detalle.entidad_pago
    where billete = p_billete::numeric;
    
    update obingresos.tventa_web_modificaciones 
    set procesado = 'si'      
    where nro_boleto = p_billete_original;    
    
  DROP FOREIGN TABLE IF EXISTS informix.boletos_modificacion;    
   DROP FOREIGN TABLE IF EXISTS informix.boletos_fpago_modificacion;
   
EXCEPTION

    WHEN others THEN BEGIN    	
    	v_error = SQLERRM;
        if (v_error not like 'CONTROLADO%') then
        	v_id_alarma = (select param.f_inserta_alarma_dblink (1,'Error al procesar modificaciones de venta web',v_error,'jaime.rivera@boa.bo,aldo.zeballos@boa.bo,dcamacho@boa.bo'));
        end if;  
    END;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;