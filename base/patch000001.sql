/***********************************I-SCP-GSS-TES-45-01/04/2013****************************************/

--tabla tes.tobligacion_pago

CREATE TABLE tes.tobligacion_pago (
  id_obligacion_pago SERIAL, 
  id_proveedor INTEGER NOT NULL, 
  id_funcionario INTEGER, 
  id_subsistema INTEGER, 
  id_moneda INTEGER, 
  id_depto INTEGER, 
  id_estado_wf INTEGER, 
  id_proceso_wf INTEGER, 
  id_gestion integer not NULL,
  fecha DATE,
  numero VARCHAR(50),
  estado VARCHAR(255), 
  obs VARCHAR(1000), 
  porc_anticipo NUMERIC(4,2) DEFAULT 0, 
  porc_retgar NUMERIC(4,2) DEFAULT 0, 
  tipo_cambio_conv NUMERIC(19,2), 
  num_tramite VARCHAR(200), 
  tipo_obligacion VARCHAR(30), 
  comprometido VARCHAR(2) DEFAULT 'no'::character varying, 
  pago_variable VARCHAR(2) DEFAULT 'no'::character varying NOT NULL, 
  nro_cuota_vigente NUMERIC(1,0) DEFAULT 0 NOT NULL,
  total_pago NUMERIC(19,2),  
  CONSTRAINT pk_tobligacion_pago__id_obligacion_pago PRIMARY KEY(id_obligacion_pago), 
  CONSTRAINT chk_tobligacion_pago__estado CHECK ((estado)::text = ANY (ARRAY[('borrador'::character varying)::text, ('registrado'::character varying)::text,('en_pago'::character varying)::text, ('finalizado'::character varying)::text,('anulado'::character varying)::text])), 
  CONSTRAINT chk_tobligacion_pago__tipo_obligacion CHECK ((tipo_obligacion)::text = ANY ((ARRAY['adquisiciones'::character varying, 'caja_chica'::character varying, 'viaticos'::character varying, 'fondos_en_avance'::character varying])::text[]))
) INHERITS (pxp.tbase)
WITHOUT OIDS;

--------------- SQL ---------------

 -- object recreation
ALTER TABLE tes.tobligacion_pago
  DROP CONSTRAINT chk_tobligacion_pago__tipo_obligacion RESTRICT;

ALTER TABLE tes.tobligacion_pago
  ADD CONSTRAINT chk_tobligacion_pago__tipo_obligacion CHECK ((tipo_obligacion)::text = ANY (ARRAY[('adquisiciones'::character varying)::text, ('caja_chica'::character varying)::text, ('viaticos'::character varying)::text, ('fondos_en_avance'::character varying)::text, ('pago_directo'::character varying)::text]));


ALTER TABLE tes.tobligacion_pago OWNER TO postgres;

--tabla tes.tobligacion_det

CREATE TABLE tes.tobligacion_det (
  id_obligacion_det SERIAL, 
  id_obligacion_pago INTEGER NOT NULL, 
  id_concepto_ingas INTEGER NOT NULL, 
  id_centro_costo INTEGER, 
  id_partida INTEGER, 
  id_cuenta INTEGER, 
  id_auxiliar INTEGER, 
  id_partida_ejecucion_com INTEGER,
  descripcion TEXT, 
  monto_pago_mo NUMERIC(19,2), 
  monto_pago_mb NUMERIC(19,2), 
   factor_porcentual NUMERIC, 
 
  CONSTRAINT pk_tobligacion_det__id_obligacion_det PRIMARY KEY(id_obligacion_det)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

ALTER TABLE tes.tobligacion_det OWNER TO postgres;

--tabla tes.tplan_pago

CREATE TABLE tes.tplan_pago(
    id_plan_pago SERIAL NOT NULL,
    id_obligacion_pago int4 NOT NULL,
    id_plantilla int4,
    id_plan_pago_fk int4,
    id_cuenta_bancaria int4,
    id_comprobante int4,
    id_estado_wf int4,
    id_proceso_wf int4,
    estado varchar(60),
    nro_sol_pago varchar(60),
    nro_cuota numeric(4, 2) DEFAULT 0 NOT NULL,
    nombre_pago varchar(255),
    forma_pago varchar(25),
    tipo_pago varchar(20),
    tipo varchar(30),
    fecha_tentativa date,
    fecha_dev date,
    fecha_pag date,
    tipo_cambio numeric(19, 2) DEFAULT 0 NOT NULL,
    obs_descuentos_anticipo text,
    obs_monto_no_pagado text,
    obs_otros_descuentos text,
    monto numeric(19, 2) DEFAULT 0 NOT NULL,
    descuento_anticipo numeric(19, 2) DEFAULT 0 NOT NULL,
    monto_no_pagado numeric(19, 2) DEFAULT 0 NOT NULL,
    otros_descuentos numeric(19, 2) DEFAULT 0 NOT NULL,
    monto_mb numeric(19, 2) DEFAULT 0 NOT NULL,
    descuento_anticipo_mb numeric(19, 2) DEFAULT 0 NOT NULL,
    monto_no_pagado_mb numeric(19, 2) DEFAULT 0 NOT NULL,
    otros_descuentos_mb numeric(19, 2) DEFAULT 0 NOT NULL,
    monto_ejecutar_total_mo numeric(19, 2) DEFAULT 0 NOT NULL,
    monto_ejecutar_total_mb numeric(19, 2) DEFAULT 0 NOT NULL,
    total_prorrateado numeric(19, 2) DEFAULT 0 NOT NULL, 
      liquido_pagable NUMERIC(19,2) DEFAULT 0 NOT NULL, 
  liquido_pagable_mb NUMERIC(19,2) DEFAULT 0 NOT NULL, 
    PRIMARY KEY (id_plan_pago)) INHERITS (pxp.tbase);
    
  
 CREATE TABLE tes.tprorrateo(
    id_prorrateo SERIAL NOT NULL,
    id_plan_pago int4 NOT NULL,
    id_obligacion_det int4 NOT NULL,
    id_partida_ejecucion_dev int4,
    id_partida_ejecucion_pag int4,
    id_transaccion_dev int4,
    id_transaccion_pag int4,
    monto_ejecutar_mo numeric(19, 2),
    monto_ejecutar_mb numeric(19, 2),
    PRIMARY KEY (id_prorrateo))
     INHERITS (pxp.tbase); 
    

/***********************************F-SCP-GSS-TES-45-01/04/2013****************************************/

/***********************************I-SCP-GSS-TES-121-24/04/2013***************************************/
--tabla tes.tplan_pago

CREATE TABLE tes.tcuenta_bancaria (
  id_cuenta_bancaria SERIAL, 
  id_institucion INTEGER NOT NULL, 
  id_cuenta INTEGER NOT NULL, 
  id_auxiliar INTEGER, 
  nro_cuenta VARCHAR, 
  fecha_alta DATE, 
  fecha_baja DATE, 
  CONSTRAINT pk_tcuenta_bancaria_id_cuenta_bancaria PRIMARY KEY(id_cuenta_bancaria)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

--tabla tes.chequera

CREATE TABLE tes.tchequera (
  id_chequera SERIAL,  
  id_cuenta_bancaria INTEGER NOT NULL,  
  codigo VARCHAR, 
  nro_chequera INTEGER NOT NULL, 
  CONSTRAINT pk_tchequera_id_chequera PRIMARY KEY(id_chequera)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

/***********************************F-SCP-GSS-TES-121-24/04/2013***************************************/



/***********************************I-SCP-RAC-TES-0-04/06/2013***************************************/


-- object recreation
ALTER TABLE tes.tobligacion_pago
  DROP CONSTRAINT chk_tobligacion_pago__estado RESTRICT;

ALTER TABLE tes.tobligacion_pago
  ADD CONSTRAINT chk_tobligacion_pago__estado CHECK ((estado)::text = ANY (ARRAY[('borrador'::character varying)::text, ('registrado'::character varying)::text, ('en_pago'::character varying)::text, ('finalizado'::character varying)::text, ('anulado'::character varying)::text]));


ALTER TABLE tes.tplan_pago
  ADD COLUMN total_pagado NUMERIC(19,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN tes.tplan_pago.total_pagado
IS 'ESta columana acumula el total de pago registrados, solo es util para cuotas del tipo devengado o devengado_pago';
  

/***********************************F-SCP-RAC-TES-0-04/06/2013***************************************/

/***********************************I-SCP-RAC-TES-170-19/06/2013***************************************/
ALTER TABLE tes.tcuenta_bancaria
  DROP COLUMN id_cuenta;
  
  --------------- SQL ---------------

ALTER TABLE tes.tcuenta_bancaria
  DROP COLUMN id_auxiliar;
  
-------------------------------
  
  ALTER TABLE tes.tcuenta_bancaria
  ADD COLUMN id_moneda INTEGER;
  
  
/***********************************F-SCP-RAC-TES-170-19/06/2013***************************************/


/***********************************I-SCP-RAC-TES-0-04/07/2013***************************************/

ALTER TABLE tes.tobligacion_det
  ADD COLUMN revertido_mb NUMERIC(19,2) DEFAULT 0 NOT NULL;
  
ALTER TABLE tes.tplan_pago
  ALTER COLUMN tipo_cambio SET DEFAULT 1;  
  
--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ADD COLUMN sinc_presupuesto VARCHAR(2) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN tes.tplan_pago.sinc_presupuesto
IS 'este campo indica que falta presupuesto comprometido para realizar el pago, y es necesario incremetar con una sincronizacion';  

ALTER TABLE tes.tobligacion_det
  ADD COLUMN incrementado_mb NUMERIC(19,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN tes.tobligacion_det.incrementado_mb
IS 'En este campo se almacenan los incrementos acumulados en el presupeussto comprometido';

ALTER TABLE tes.tplan_pago
  ADD COLUMN monto_retgar_mo NUMERIC(19,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN tes.tplan_pago.monto_retgar_mo
IS 'Aqui se almacenea el monto qeu se retrendra por concepto de garantia';

--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ADD COLUMN monto_retgar_mb NUMERIC(19,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN tes.tplan_pago.monto_retgar_mb
IS 'conto de retencion de garantia en moneda base';


/***********************************F-SCP-RAC-TES-0-04/07/2013***************************************/


/***********************************I-SCP-RAC-TES-0-20/08/2013***************************************/

ALTER TABLE tes.tobligacion_pago
  ADD COLUMN id_depto_conta INTEGER;
  
/***********************************F-SCP-RAC-TES-0-20/08/2013***************************************/
  
  
/***********************************I-SCP-RAC-TES-0-09/09/2013***************************************/
  
ALTER TABLE tes.tplan_pago
  RENAME COLUMN id_comprobante TO id_int_comprobante;  

/***********************************F-SCP-RAC-TES-0-09/09/2013***************************************/
 
 