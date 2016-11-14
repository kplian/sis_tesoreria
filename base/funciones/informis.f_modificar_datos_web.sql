CREATE OR REPLACE FUNCTION informix.f_modificar_datos_web (
  p_billete varchar
)
  RETURNS varchar AS
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
    
BEGIN
  	v_nombre_funcion = 'informix.f_modificar_datos_web';   
   DROP FOREIGN TABLE IF EXISTS informix.boletos_modificacion;  
   DROP FOREIGN TABLE IF EXISTS informix.boletos_facturas_modificacion;  
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
	fevarchareg date,
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
    
   
    
    execute ('CREATE FOREIGN TABLE informix.boletos_facturas_modificacion (
      pais varchar(3),
	estacion varchar(3),
	tipdoc varchar(6),
	billete numeric(13),
	sucursal smallint,
	nroaut numeric(15),
	nrofac numeric(15),
	fecha date,
	agt numeric(8),
	agtnoiata varchar(8),
	razon varchar(150),
	nit numeric(16),
	monto numeric(16,2),
	exento numeric(16,2),
	moneda varchar(3),
	tcambio numeric(13,7),
	nalint varchar(1),
	canje varchar(1),
	locsai smallint,
	vendsai int,
	cajasai numeric(4),
	ususai varchar(3),
	usuario varchar(12),
	codclisai numeric(7),
	estado varchar(1),
	fecproc date,
	horareg varchar(8),
	fevarchareg date,
	retbsp varchar(3),
	tipocon varchar(6),
	contablz varchar(1),
	facmancom varchar(2),
	idcenproc varchar(6),
	nomarch varchar(30),
	observa varchar(200)
      ) SERVER sai1

    OPTIONS ( table ''facturas'',
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
    where b.nro_boleto = p_billete;
    
    select * into v_detalle
    from obingresos.tdetalle_boletos_web d
    where d.billete = p_billete;
    
    select estado into v_estado
    from obingresos.boletos_modificacion bm
    where bm.billete = p_billete::numeric;
    
    
    if (v_id_boleto is null and v_estado = '1') then
    	raise exception 'No se puede actualizar la informacion de ventas web porque no existe el boleto %',p_billete;
    end if;
    if (v_detalle.medio_pago != 'COMPLETAR-CC')  then
        if (v_estado = '1') then
        
            select bfp.*,m.codigo_internacional into v_forma_pago
            from obingresos.tboleto_forma_pago bfp 
            inner join obingresos.tforma_pago fp on bfp.id_forma_pago = fp.id_forma_pago
            inner join param.tmoneda m on m.id_moneda = fp.id_moneda
            where bfp.id_boleto = v_id_boleto;
                
            --validar monto y moneda y moneda
            if (v_detalle.importe != v_forma_pago.importe) then
                raise exception 'El importe de la forma de pago no iguala con el importe de la venta web para el boleto %',p_billete;
            end if;
                
            if (v_detalle.moneda != v_forma_pago.codigo_internacional) then
                raise exception 'La moneda de la forma de pago no iguala con la moneda de la venta web para el boleto %',p_billete;
            end if;
                
            update
            obingresos.tboleto
            set id_agencia =v_id_agencia,
            endoso = v_detalle.endoso
            where id_boleto = v_id_boleto;
                
            select fp.id_forma_pago into v_id_forma_pago
            from obingresos.tforma_pago fp
            inner join param.tmoneda m on m.id_moneda = fp.id_moneda
            where fp.codigo like v_detalle.entidad_pago || (case when v_detalle.moneda = 'USD' then 'U' else '' end); 
                
            update obingresos.tboleto_forma_pago 
            set id_forma_pago = v_id_forma_pago
            where id_boleto = v_id_boleto;
        end if;
        
        update informix.boletos_fpago_modificacion
        set forma = v_detalle.entidad_pago || (case when v_detalle.moneda = 'USD' then 'U' else '' end),
        moneda = v_detalle.moneda,
        agt = 56999960
        where billete = p_billete::numeric;
        
        
        update informix.boletos_facturas_modificacion
        set nit = v_detalle.nit,
        razon_social =  v_detalle.razon_social,
        agt = 56999960
        where billete = p_billete::numeric;
        
        update informix.boletos_modificacion
        set agt = 56999960
        where billete = p_billete::numeric;
    else
    	update informix.boletos_facturas_modificacion
        set nit = v_detalle.nit,
        razon_social =  v_detalle.razon_social
        where billete = p_billete::numeric;
    end if;
    
    update obingresos.tdetalle_boletos_web dbw
    set procesado = 'si'
    where billete = p_billete;    
       
    
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;