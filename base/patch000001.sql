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
 
/***********************************I-SCP-RAC-TES-0-18/09/2013***************************************/

ALTER TABLE tes.tprorrateo
  ADD COLUMN id_int_transaccion INTEGER;

COMMENT ON COLUMN tes.tprorrateo.id_int_transaccion
IS 'relaciona el prorrateo del devengado con la transaccion don de se ejecuta el presupuesto'; 

ALTER TABLE tes.tprorrateo
  ADD COLUMN id_prorrateo_fk INTEGER;

COMMENT ON COLUMN tes.tprorrateo.id_prorrateo_fk
IS 'solo sirve para prorrateos de pago, referencia el prorrateo del devengado';

ALTER TABLE tes.tplan_pago
  ADD COLUMN descuento_ley NUMERIC(18,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN tes.tplan_pago.descuento_ley
IS 'en este campo se registran los decuento asociados al tipo de documentos, por ejemplo si es recibo con retencion de bienes, se retiene 3% del IT y 5%del IUE';

ALTER TABLE tes.tplan_pago
  ADD COLUMN obs_descuentos_ley TEXT;

COMMENT ON COLUMN tes.tplan_pago.obs_descuentos_ley
IS 'este campo espeficia los porcentajes aplicado a los decuentos, es solo descriptivo';

ALTER TABLE tes.tplan_pago
  ADD COLUMN descuento_ley_mb NUMERIC(18,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN tes.tplan_pago.descuento_ley_mb
IS 'descuentos de ley en moneda base';


--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ADD COLUMN porc_descuento_ley NUMERIC(4,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN tes.tplan_pago.porc_descuento_ley
IS 'cste campo almacena el porcentaje de descuentos de ley, se utiliza para las cuotas de tipo pago';

/***********************************F-SCP-RAC-TES-0-18/09/2013***************************************/

/***********************************I-SCP-RCM-TES-0-05/12/2013***************************************/ 
 
ALTER TABLE tes.tplan_pago
  ADD COLUMN nro_cheque INTEGER;

COMMENT ON COLUMN tes.tplan_pago.nro_cheque
IS 'Número de cheque que se utilizará para realizar el pago';

ALTER TABLE tes.tplan_pago
  ADD COLUMN nro_cuenta_bancaria VARCHAR(50);

COMMENT ON COLUMN tes.tplan_pago.nro_cuenta_bancaria
IS 'Número de cuenta bancaria para realizar el pago cuando es Transferencia';

ALTER TABLE tes.tplan_pago
  ADD COLUMN id_cuenta_bancaria_mov integer;

/***********************************F-SCP-RCM-TES-0-05/12/2013***************************************/


/***********************************I-SCP-RCM-TES-0-12/12/2013***************************************/

CREATE TABLE tes.tcuenta_bancaria_mov (
  id_cuenta_bancaria_mov SERIAL, 
  id_cuenta_bancaria INTEGER NOT NULL, 
  id_int_comprobante INTEGER, 
  id_cuenta_bancaria_mov_fk INTEGER, 
  tipo_mov VARCHAR(15) NOT NULL, 
  tipo varchar(15) NOT NULL, 
  descripcion VARCHAR(2000) NOT NULL, 
  nro_doc_tipo VARCHAR(50), 
  importe NUMERIC(18,2) NOT NULL,
  fecha date, 
  estado VARCHAR(20) NOT NULL, 
  observaciones VARCHAR(2000), 
  CONSTRAINT pk_tcuenta_bancaria_mov__id_cuenta_bancaria_mov PRIMARY KEY(id_cuenta_bancaria_mov)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

COMMENT ON COLUMN tes.tcuenta_bancaria_mov.id_cuenta_bancaria_mov_fk
IS 'Relacion para determinar en un Egreso a que ingreso corresponde';

COMMENT ON COLUMN tes.tcuenta_bancaria_mov.tipo_mov
IS 'tipo_mov in (''ingreso'',''egreso'')';

COMMENT ON COLUMN tes.tcuenta_bancaria_mov.tipo
IS 'tipo in (''cheque'',''transferencia'')';

/***********************************F-SCP-RCM-TES-0-12/12/2013***************************************/

/***********************************I-SCP-ECR-TES-0-20/12/2013***************************************/
CREATE TABLE tes.tcaja (
  id_caja SERIAL, 
  id_depto INTEGER NOT NULL, 
  id_moneda INTEGER NOT NULL, 
  codigo VARCHAR(20) NOT NULL, 
  tipo VARCHAR(20) NOT NULL, 
  estado VARCHAR(20) NOT NULL, 
  importe_maximo NUMERIC(18,2) NOT NULL, 
  porcentaje_compra NUMERIC(6,2) NOT NULL, 
  CONSTRAINT pk_tcaja__id_caja PRIMARY KEY(id_caja)
) INHERITS (pxp.tbase)
WITHOUT OIDS;
/***********************************F-SCP-ECR-TES-0-20/12/2013***************************************/

/***********************************I-SCP-ECR-TES-0-20/12/2013***************************************/
CREATE TABLE tes.tcajero (
  id_cajero SERIAL, 
  id_funcionario INTEGER NOT NULL, 
  tipo VARCHAR(20) NOT NULL, 
  estado VARCHAR(20) NOT NULL, 
  id_caja INTEGER, 
  CONSTRAINT pk_tcajero__id_cajero PRIMARY KEY(id_cajero)
) INHERITS (pxp.tbase)
WITHOUT OIDS;
/***********************************F-SCP-ECR-TES-0-20/12/2013***************************************/



/***********************************I-SCP-RAC-TES-0-17/12/2014***************************************/

--------------- SQL ---------------

ALTER TABLE tes.tcuenta_bancaria
  ADD COLUMN centro VARCHAR(4) DEFAULT 'si' NOT NULL;

COMMENT ON COLUMN tes.tcuenta_bancaria.centro
IS 'Identifica si es de la regional central o no. Viene por la integracionde cuenta bancaria endesis';


/***********************************F-SCP-RAC-TES-0-17/12/2014***************************************/



/***********************************I-SCP-RAC-TES-0-29/01/2014***************************************/

--------------- SQL ---------------

ALTER TABLE tes.tobligacion_det
  ADD COLUMN revertido_mo NUMERIC(19,2) DEFAULT 0 NOT NULL;

--------------- SQL ---------------

ALTER TABLE tes.tobligacion_det
  ADD COLUMN incrementado_mo NUMERIC(19,2) DEFAULT 0 NOT NULL;

ALTER TABLE tes.tplan_pago
  ALTER COLUMN nro_cheque SET DEFAULT 0;

ALTER TABLE tes.tplan_pago
  ALTER COLUMN nro_cheque SET NOT NULL;


/***********************************F-SCP-RAC-TES-0-29/01/2014***************************************/




/***********************************I-SCP-RAC-TES-0-05/02/2014***************************************/
--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD COLUMN total_nro_cuota INTEGER DEFAULT 0 NOT NULL;



ALTER TABLE tes.tobligacion_pago
  ADD COLUMN id_plantilla INTEGER;

COMMENT ON COLUMN tes.tobligacion_pago.id_plantilla
IS 'rAra registra el documento por defecto para los planes de pago';

--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD COLUMN fecha_pp_ini DATE;

COMMENT ON COLUMN tes.tobligacion_pago.fecha_pp_ini
IS 'Fecha tentativa inicial para los planes de pago';


--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD COLUMN rotacion INTEGER;

ALTER TABLE tes.tobligacion_pago
  ALTER COLUMN rotacion SET DEFAULT 1;

COMMENT ON COLUMN tes.tobligacion_pago.rotacion
IS 'Cada cuantos meses se registrar las fechas tentaivas a partir de la inicial';



/***********************************F-SCP-RAC-TES-0-05/02/2014***************************************/



/***********************************I-SCP-RAC-TES-0-08/02/2014***************************************/

--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ADD COLUMN monto_excento NUMERIC(12,2) DEFAULT 0 NOT NULL;
  
  
ALTER TABLE tes.tplan_pago
  ADD COLUMN porc_monto_excento_var NUMERIC DEFAULT 0 NOT NULL;
/***********************************F-SCP-RAC-TES-0-08/02/2014***************************************/



/***********************************I-SCP-RAC-TES-0-05/03/2014***************************************/

--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ALTER COLUMN nro_cuota_vigente TYPE NUMERIC(20,0);
  
/***********************************F-SCP-RAC-TES-0-05/03/2014***************************************/
  
