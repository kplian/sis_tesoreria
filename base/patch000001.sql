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

/***********************************I-SCP-ECR-TES-2-20/12/2013***************************************/
CREATE TABLE tes.tcajero (
  id_cajero SERIAL, 
  id_funcionario INTEGER NOT NULL, 
  tipo VARCHAR(20) NOT NULL, 
  estado VARCHAR(20) NOT NULL, 
  id_caja INTEGER, 
  CONSTRAINT pk_tcajero__id_cajero PRIMARY KEY(id_cajero)
) INHERITS (pxp.tbase)
WITHOUT OIDS;
/***********************************F-SCP-ECR-TES-2-20/12/2013***************************************/



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

/***********************************I-SCP-JRR-TES-0-01/04/2014***************************************/
ALTER TABLE tes.tcuenta_bancaria
  ADD COLUMN denominacion VARCHAR(100);

/***********************************F-SCP-JRR-TES-0-01/04/2014***************************************/


/***********************************I-SCP-RAC-TES-0-19/05/2014***************************************/

--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD COLUMN ultima_cuota_pp NUMERIC(4,2);

COMMENT ON COLUMN tes.tobligacion_pago.ultima_cuota_pp
IS 'eace referencia al numero de la ultima uocta modificada';


--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD COLUMN ultimo_estado_pp VARCHAR(150);

COMMENT ON COLUMN tes.tobligacion_pago.ultimo_estado_pp
IS 'ultimo estado del plan de pago correpondiente a la cuota indicada en ultima_cuota_pp';

/***********************************F-SCP-RAC-TES-0-19/05/2014***************************************/



/***********************************I-SCP-RAC-TES-0-08/07/2014***************************************/

CREATE TABLE tes.ttipo_plan_pago (
  id_tipo_plan_pago SERIAL NOT NULL, 
  codigo VARCHAR NOT NULL, 
  descripcion VARCHAR, 
  codigo_proceso_llave_wf VARCHAR NOT NULL, 
  codigo_plantilla_comprobante VARCHAR, 
  PRIMARY KEY(id_tipo_plan_pago)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

COMMENT ON COLUMN tes.ttipo_plan_pago.codigo_proceso_llave_wf
IS 'relaciona con tipo de proocesos wf para este pago';

COMMENT ON COLUMN tes.ttipo_plan_pago.codigo_plantilla_comprobante
IS 'relaciona con la plantilla de comprobante para este tipo de pago';

--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD COLUMN tipo_anticipo VARCHAR(5) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN tes.tobligacion_pago.tipo_anticipo
IS 'tipo anticipo, si o no';

--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ADD COLUMN descuento_inter_serv NUMERIC(19,2) DEFAULT 0 NOT NULL;

--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ADD COLUMN obs_descuento_inter_serv TEXT;

--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ADD COLUMN porc_monto_retgar NUMERIC;

/***********************************F-SCP-RAC-TES-0-08/07/2014***************************************/

/***********************************I-SCP-JRR-TES-0-31/07/2014***************************************/

CREATE TABLE tes.ttipo_prorrateo (
  id_tipo_prorrateo SERIAL, 
  codigo VARCHAR (50) NOT NULL, 
  nombre VARCHAR (150) NOT NULL,
  descripcion TEXT,
  es_plantilla VARCHAR (2) NOT NULL,
  tiene_cuenta VARCHAR (2) NOT NULL,  
  CONSTRAINT ttipo_prorrateo_pkey PRIMARY KEY(id_tipo_prorrateo)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

/***********************************F-SCP-JRR-TES-0-31/07/2014***************************************/


/***********************************I-SCP-JRR-TES-0-01/08/2014***************************************/

ALTER TABLE tes.ttipo_prorrateo
  ADD COLUMN tiene_lugar VARCHAR(2);

/***********************************F-SCP-JRR-TES-0-01/08/2014***************************************/


/***********************************I-SCP-RAC-TES-0-01/08/2014***************************************/

--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD COLUMN id_categoria_compra INTEGER;

COMMENT ON COLUMN tes.tobligacion_pago.id_categoria_compra
IS 'ei la obligacion de pago es de adquisiciones para acceso mas rapido al datos copiamos la categoria dde compra que viene en la solicitud';


/***********************************F-SCP-RAC-TES-0-01/08/2014***************************************/



/***********************************I-SCP-RAC-TES-0-19/08/2014***************************************/

--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD COLUMN tipo_solicitud VARCHAR(50) DEFAULT '' NOT NULL;

COMMENT ON COLUMN tes.tobligacion_pago.tipo_solicitud
IS 'cuando viene de adquisiciones para disminuir la complekidad de las consultas copiamos el tipo de la tabla solicitud de compra';

--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD COLUMN tipo_concepto_solicitud VARCHAR(50) DEFAULT '' NOT NULL;

COMMENT ON COLUMN tes.tobligacion_pago.tipo_concepto_solicitud
IS 'cuando viene de adquisiciones para disminuir la complekidad de las consultas copiamos el tipo_concepto de la tabla solicitud de compra';
/***********************************F-SCP-RAC-TES-0-19/08/2014***************************************/







/***********************************I-SCP-RAC-TES-0-1/09/2014***************************************/

--------------- SQL ---------------

ALTER TABLE tes.tobligacion_det
  ADD COLUMN id_orden_trabajo INTEGER;

COMMENT ON COLUMN tes.tobligacion_det.id_orden_trabajo
IS 'orden de trabajo';

/***********************************F-SCP-RAC-TES-0-1/09/2014***************************************/


/***********************************I-SCP-RAC-TES-0-12/09/2014***************************************/

--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD COLUMN id_funcionario_gerente INTEGER;

COMMENT ON COLUMN tes.tobligacion_pago.id_funcionario_gerente
IS 'se campo se define en funcion del funcionario solcitante,  se asigna el gerente de menor nivel en la escala jerarquica';


/***********************************F-SCP-RAC-TES-0-12/09/2014***************************************/


/***********************************I-SCP-RAC-TES-0-18/09/2014***************************************/

--------------- SQL ---------------

 -- object recreation
ALTER TABLE tes.tobligacion_pago
  DROP CONSTRAINT chk_tobligacion_pago__estado RESTRICT;

ALTER TABLE tes.tobligacion_pago
  ADD CONSTRAINT chk_tobligacion_pago__estado CHECK ((estado)::text = ANY (ARRAY[('borrador'::character varying)::text, ('registrado'::character varying)::text, ('en_pago'::character varying)::text, ('finalizado'::character varying)::text, ('vbpresupuestos'::character varying)::text,('anulado'::character varying)::text]));

/***********************************F-SCP-RAC-TES-0-18/09/2014***************************************/


/***********************************I-SCP-RAC-TES-0-23/09/2014***************************************/

--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ADD COLUMN revisado_asistente VARCHAR(5) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN tes.tplan_pago.revisado_asistente
IS 'este campo sirve para marcar los pagos revisados por las asistente';

/***********************************F-SCP-RAC-TES-0-23/09/2014***************************************/





/***********************************I-SCP-RAC-TES-0-25/09/2014***************************************/


ALTER TABLE tes.tplan_pago
  ALTER COLUMN nro_cuenta_bancaria TYPE VARCHAR(100) COLLATE pg_catalog."default";

/***********************************F-SCP-RAC-TES-0-25/09/2014***************************************/

/***********************************I-SCP-JRR-TES-0-26/09/2014***************************************/
ALTER TABLE tes.tplan_pago
  ADD COLUMN conformidad TEXT;
  

ALTER TABLE tes.tplan_pago
  ADD COLUMN fecha_conformidad DATE;

/***********************************F-SCP-JRR-TES-0-26/09/2014***************************************/


/***********************************I-SCP-RAC-TES-0-02/10/2014***************************************/

--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ALTER COLUMN nro_cheque DROP DEFAULT;
  
/***********************************F-SCP-RAC-TES-0-02/10/2014***************************************/



/***********************************I-SCP-RAC-TES-0-21/10/2014***************************************/

--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ADD COLUMN monto_ajuste_ag NUMERIC(19,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN tes.tplan_pago.monto_ajuste_ag
IS 'monto de ajuste anterior gestion, (se usa en anticipos parciales). Si sobro dinero de un anticipo en la anterior gestion se utuliza este campo para ajustar contra ese sobrante';


--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ADD COLUMN monto_ajuste_siguiente_pago NUMERIC(19,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN tes.tplan_pago.monto_ajuste_siguiente_pago
IS 'Se utiliza par la aplicacion de anticipos totales,  si falta dinero para cubrir la aplicacion en este monto,  en este campo ponemos el monto a cubrir con el siguiente anticipo';


--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD COLUMN ajuste_anticipo NUMERIC(19,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN tes.tobligacion_pago.ajuste_anticipo
IS 'Ajuste de anticipo se utuliza para cuaadrar y poder cerrar el proceso de obligacion de pago cuando de falta en el monto anticipado. Se tiene un monto aplicado mayor que el monto aplicado';


--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD COLUMN ajuste_aplicado NUMERIC(19,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN tes.tobligacion_pago.ajuste_aplicado
IS 'Se utiliza para hacer cuadrad el monto anticipado total con el monto aplicado, se utilia cuando el monto anticipado total sobrepasa el monto aplicado';


/***********************************F-SCP-RAC-TES-0-21/10/2014***************************************/





/***********************************I-SCP-GSS-TES-0-27/10/2014***************************************/
CREATE TABLE tes.tfinalidad (
  id_finalidad SERIAL, 
  nombre_finalidad VARCHAR(200), 
  color VARCHAR(50), 
  estado VARCHAR(20), 
  CONSTRAINT pk_tfinalidad__id_finalidad PRIMARY KEY(id_finalidad)
) INHERITS (pxp.tbase)

WITH (oids = false);

/***********************************F-SCP-GSS-TES-0-27/10/2014***************************************/

/***********************************I-SCP-RAC-TES-0-27/10/2014***************************************/

--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ADD COLUMN monto_anticipo NUMERIC(19,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN tes.tplan_pago.monto_anticipo
IS 'monto anticipar que puede ser aplicado con otro comprobante  o puede ser llevado al gasto en la siguiente gestion,  si este valor es mayor a cero al cerrar la obligacion de pagos y no a sido totalmente aplicado, debe crearce una obligacion de pago extentida  para la siguiente gestion con un plan de pagos del tipo anticipo en estado anticipado por la suma de estos valores en registors activos';

--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD COLUMN monto_estimado_sg NUMERIC(19,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN tes.tobligacion_pago.monto_estimado_sg
IS 'monto estimado para ser pagado en la siguiente gestion , este campo afecta la validacion del total por pagar';

/***********************************F-SCP-RAC-TES-0-27/10/2014***************************************/


/***********************************I-SCP-RAC-TES-0-28/10/2014***************************************/
--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD COLUMN id_obligacion_pago_extendida INTEGER;

COMMENT ON COLUMN tes.tobligacion_pago.id_obligacion_pago_extendida
IS 'Este campo sirve para relacionar la obligacion que se extiende a la siguiente gestion por tener un saldo anticipado';


/***********************************F-SCP-RAC-TES-0-28/10/2014***************************************/


/***********************************I-SCP-RAC-TES-0-06/11/2014***************************************/


--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD COLUMN monto_ajuste_ret_garantia_ga NUMERIC(19,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN tes.tobligacion_pago.monto_ajuste_ret_garantia_ga
IS 'Este campo almacena en obligaciones extendidas saldo de retenciones de garantia por devolver';


--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD COLUMN monto_ajuste_ret_anticipo_par_ga NUMERIC(19,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN tes.tobligacion_pago.monto_ajuste_ret_anticipo_par_ga
IS 'este campo almacena en obligaciones entendidas el saldo de anticipo parcial por retener de la gestion anterior';
/***********************************F-SCP-RAC-TES-0-06/11/2014***************************************/




/***********************************I-SCP-RAC-TES-0-10/11/2014***************************************/

--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ALTER COLUMN porc_descuento_ley TYPE NUMERIC;
  
/***********************************F-SCP-RAC-TES-0-10/11/2014***************************************/

/***********************************I-SCP-JRR-TES-0-18/11/2014***************************************/

ALTER TABLE tes.tobligacion_pago
  ALTER COLUMN id_proveedor DROP NOT NULL;
/***********************************F-SCP-JRR-TES-0-18/11/2014***************************************/

/***********************************I-SCP-GSS-TES-0-24/11/2014***************************************/

--------------- SQL ---------------

ALTER TABLE tes.tcuenta_bancaria
  ADD COLUMN id_finalidad INTEGER[];

COMMENT ON COLUMN tes.tcuenta_bancaria.id_finalidad
IS 'arreglo que almacena los ids de la tabla finalidad al cual corresponde la cuenta bancaria';

/***********************************F-SCP-GSS-TES-0-24/11/2014***************************************/

/***********************************I-SCP-GSS-TES-0-27/11/2014***************************************/

--------------- SQL ---------------

CREATE TABLE tes.tusuario_cuenta_banc (
  id_usuario_cuenta_banc SERIAL, 
  id_usuario INTEGER NOT NULL, 
  id_cuenta_bancaria INTEGER NOT NULL, 
  tipo_permiso VARCHAR(20) DEFAULT 'todos'::character varying NOT NULL, 
  CONSTRAINT pk_tusuario_cuenta_banc__id_usuario_cuenta_banc PRIMARY KEY(id_usuario_cuenta_banc)
  
) INHERITS (pxp.tbase);

/***********************************F-SCP-GSS-TES-0-27/11/2014***************************************/


/***********************************I-SCP-RAC-TES-0-03/12/2014***************************************/

--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ADD COLUMN fecha_costo_ini DATE;

COMMENT ON COLUMN tes.tplan_pago.fecha_costo_ini
IS 'Cuando un concepto de gasto es del tipo servicio, esta fecha indica el inico del costo';

--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ADD COLUMN fecha_costo_fin DATE;

COMMENT ON COLUMN tes.tplan_pago.fecha_costo_fin
IS 'Cuando un concepto de gasto es del tipo servicio, esta fecha indica el fin del costo';

--------------- SQL ---------------

COMMENT ON COLUMN tes.tplan_pago.tipo
IS 'det_rendicion, dev_garantia, ant_aplicado , pagado_rrh, pagado, ant_parcial, anticipo, rendicion, devengado_rrhh, devengado, devengado_pagado_1c, devengado_pagado';

/***********************************F-SCP-RAC-TES-0-03/12/2014***************************************/

/***********************************I-SCP-RAC-TES-0-09/01/2015***************************************/

--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD COLUMN id_contrato INTEGER;

COMMENT ON COLUMN tes.tobligacion_pago.id_contrato
IS 'si la obligacion tiene un contrato de referencia';


/***********************************F-SCP-RAC-TES-0-09/01/2015***************************************/


/***********************************I-SCP-RAC-TES-0-14/01/2015***************************************/

--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD COLUMN obs_presupuestos VARCHAR;

COMMENT ON COLUMN tes.tobligacion_pago.obs_presupuestos
IS 'para inotrducir obs en el area de presupuestos';


/***********************************F-SCP-RAC-TES-0-14/01/2015***************************************/



/***********************************I-SCP-RAC-TES-0-19/02/2015***************************************/

 -- object recreation
ALTER TABLE tes.tobligacion_pago
  DROP CONSTRAINT chk_tobligacion_pago__tipo_obligacion RESTRICT;

ALTER TABLE tes.tobligacion_pago
  ADD CONSTRAINT chk_tobligacion_pago__tipo_obligacion CHECK ((tipo_obligacion)::text = ANY (ARRAY[('adquisiciones'::character varying)::text, ('pago_unico'::character varying)::text, ('caja_chica'::character varying)::text, ('viaticos'::character varying)::text, ('fondos_en_avance'::character varying)::text, ('pago_directo'::character varying)::text, ('rrhh'::character varying)::text]));

/***********************************F-SCP-RAC-TES-0-19/02/2015***************************************/


/***********************************I-SCP-RAC-TES-0-02/03/2015***************************************/

--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ADD COLUMN tiene_form500 VARCHAR(13) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN tes.tplan_pago.tiene_form500
IS 'esta bander indica que el formulario 500 ya ue registrado';

/***********************************F-SCP-RAC-TES-0-02/03/2015***************************************/



/***********************************I-SCP-RAC-TES-0-03/03/2015***************************************/

--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ADD COLUMN id_depto_lb INTEGER;

COMMENT ON COLUMN tes.tplan_pago.id_depto_lb
IS 'identifica el libro de pango con el que se paga el cheque, sirve apra filtrar las cuentas bancarias que se peudne seleccionar';


/***********************************F-SCP-RAC-TES-0-03/03/2015***************************************/


/***********************************I-SCP-RAC-TES-0-25/03/2015***************************************/


--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD COLUMN ultima_cuota_dev NUMERIC;

COMMENT ON COLUMN tes.tobligacion_pago.ultima_cuota_dev
IS 'identifica la ultima cuota  del tipo devengado para alertar sobre ultimo pago, sellena atravez de un triguer en la tabla de plan de pagos';

/***********************************F-SCP-RAC-TES-0-25/03/2015***************************************/

/***********************************I-SCP-GSS-TES-0-23/04/2015***************************************/

CREATE TABLE tes.tts_libro_bancos (
  id_libro_bancos SERIAL, 
  id_cuenta_bancaria INTEGER NOT NULL, 
  fecha DATE, 
  a_favor VARCHAR(200) NOT NULL, 
  detalle TEXT NOT NULL, 
  observaciones TEXT, 
  nro_liquidacion VARCHAR(20), 
  nro_comprobante VARCHAR(20), 
  nro_cheque INTEGER, 
  tipo VARCHAR(20) NOT NULL, 
  importe_deposito NUMERIC(20,2) NOT NULL, 
  importe_cheque NUMERIC(20,2) NOT NULL, 
  origen VARCHAR(20), 
  estado VARCHAR(20) DEFAULT 'borrador'::character varying NOT NULL, 
  id_libro_bancos_fk INTEGER, 
  indice NUMERIC(20,2), 
  notificado VARCHAR(2) DEFAULT 'no'::character varying, 
  id_finalidad INTEGER, 
  id_estado_wf INTEGER, 
  id_proceso_wf INTEGER, 
  num_tramite VARCHAR(200), 
  id_depto INTEGER, 
  sistema_origen VARCHAR(30), 
  comprobante_sigma VARCHAR(50), 
  CONSTRAINT tts_libro_bancos_pkey PRIMARY KEY(id_libro_bancos)
) INHERITS (pxp.tbase)
WITH (oids = false);

ALTER TABLE tes.tts_libro_bancos
  ADD COLUMN id_int_comprobante INTEGER;

COMMENT ON COLUMN tes.tts_libro_bancos.id_int_comprobante
IS 'comprobante de pago que corresponde al cheque';

CREATE TABLE tes.tdepto_cuenta_bancaria (
  id_depto_cuenta_bancaria SERIAL, 
  id_depto INTEGER NOT NULL, 
  id_cuenta_bancaria INTEGER NOT NULL, 
  CONSTRAINT pk_tdepto_cuenta_bancaria PRIMARY KEY(id_depto_cuenta_bancaria)
) INHERITS (pxp.tbase)

WITH (oids = false);

/***********************************F-SCP-GSS-TES-0-23/04/2015***************************************/

/*****************************I-SCP-RCM-TES-0-17/04/2015*************/

--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ADD COLUMN id_depto_conta INTEGER;

COMMENT ON COLUMN tes.tplan_pago.id_depto_conta
IS 'define el depto de conta que contabiliza el pago, ...  no consideramos ep, cc (antes solo lo teneiamos en la obligacion de pago)';


/*****************************F-SCP-RCM-TES-0-17/04/2015*************/





/*****************************I-SCP-RAC-TES-0-12/05/2015*************/


--------------- SQL ---------------

-- object recreation
ALTER TABLE tes.tobligacion_pago
  DROP CONSTRAINT chk_tobligacion_pago__estado RESTRICT;

ALTER TABLE tes.tobligacion_pago
  ADD CONSTRAINT chk_tobligacion_pago__estado CHECK ((estado)::text = ANY (ARRAY[('borrador'::character varying)::text, ('registrado'::character varying)::text, ('en_pago'::character varying)::text, ('finalizado'::character varying)::text, ('vbpoa'::character varying)::text, ('vbpresupuestos'::character varying)::text, ('anulado'::character varying)::text]));
 
 
--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD COLUMN codigo_poa VARCHAR;

COMMENT ON COLUMN tes.tobligacion_pago.codigo_poa
IS 'Codigo de actividad POA';

--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD COLUMN obs_poa VARCHAR;

COMMENT ON COLUMN tes.tobligacion_pago.obs_poa
IS 'par ainsertar al guna observacion de POA';

/*****************************F-SCP-RAC-TES-0-12/05/2015*************/


/*****************************I-SCP-RAC-TES-0-12/06/2015*************/

--------------- SQL ---------------

CREATE TABLE tes.tconcepto_excepcion (
  id_concepto_excepcion SERIAL,
  id_concepto_ingas INTEGER NOT NULL,
  id_uo INTEGER NOT NULL,
  PRIMARY KEY(id_concepto_excepcion)
) INHERITS (pxp.tbase)
;

ALTER TABLE tes.tconcepto_excepcion
  OWNER TO postgres;

ALTER TABLE tes.tconcepto_excepcion
  ALTER COLUMN id_uo SET STATISTICS 0;


--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD COLUMN uo_ex VARCHAR(4) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN tes.tobligacion_pago.uo_ex
IS 'cuando la uo que aprueba se selecciona de la tabla de excepcion queda marcado como si';
/*****************************F-SCP-RAC-TES-0-12/06/2015*************/

/*****************************I-SCP-RAC-TES-0-1/07/2015*************/

--------------- SQL ---------------

 -- object recreation
ALTER TABLE tes.tobligacion_pago
  DROP CONSTRAINT chk_tobligacion_pago__tipo_obligacion RESTRICT;

ALTER TABLE tes.tobligacion_pago
  ADD CONSTRAINT chk_tobligacion_pago__tipo_obligacion CHECK ((tipo_obligacion)::text = ANY (ARRAY[('adquisiciones'::character varying)::text, ('pago_unico'::character varying)::text, ('pago_especial'::character varying)::text,('caja_chica'::character varying)::text, ('viaticos'::character varying)::text, ('fondos_en_avance'::character varying)::text, ('pago_directo'::character varying)::text, ('rrhh'::character varying)::text]));
  
/*****************************F-SCP-RAC-TES-0-1/07/2015*************/




/*****************************I-SCP-JRR-TES-0-10/08/2015*************/

ALTER TABLE tes.tcajero
  ADD COLUMN fecha_inicio DATE NOT NULL;

ALTER TABLE tes.tcajero
  ADD COLUMN fecha_fin DATE;
 
ALTER TABLE tes.tcaja
  DROP COLUMN importe_maximo;
  
ALTER TABLE tes.tcaja
  DROP COLUMN porcentaje_compra;
  
ALTER TABLE tes.tcaja
  DROP COLUMN codigo;
  
ALTER TABLE tes.tcaja
  ADD COLUMN nombre VARCHAR(255) NOT NULL;
  
ALTER TABLE tes.tcaja
  ADD COLUMN monto_fondo NUMERIC(18,2) NOT NULL;
  
ALTER TABLE tes.tcaja
  ADD COLUMN monto_maximo_compra NUMERIC(18,2) NOT NULL;

ALTER TABLE tes.tcaja
  ADD COLUMN tipo_ejecucion VARCHAR(40) NOT NULL;

CREATE TABLE tes.tsolicitud_efectivo (
  id_solicitud_efectivo SERIAL, 
  id_funcionario INTEGER NOT NULL,
  id_proceso_wf INTEGER NOT NULL,
  id_estado_wf INTEGER NOT NULL,
  id_caja INTEGER NOT NULL, 
  estado VARCHAR(50) NOT NULL, 
  motivo TEXT,
  nro_tramite VARCHAR(50) NOT NULL, 
  fecha DATE NOT NULL,
  monto NUMERIC(18,2), 
  CONSTRAINT pk_tsolicitud_efectivo__id_solicitud_efectivo PRIMARY KEY(id_solicitud_efectivo)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

CREATE TABLE tes.tsolicitud_efectivo_det (
  id_solicitud_efectivo_det SERIAL, 
  id_solicitud_efectivo INTEGER,
  id_solicitud_rendicion_det INTEGER,
  id_concepto_ingas INTEGER NOT NULL,
  id_cc INTEGER NOT NULL,
  id_partida_ejecucion INTEGER NOT NULL,   
  monto NUMERIC(18,2) NOT NULL, 
  CONSTRAINT pk_tsolicitud_efectivo_det__id_solicitud_efectivo_det PRIMARY KEY(id_solicitud_efectivo_det)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

CREATE TABLE tes.tproceso_caja (
  id_proceso_caja SERIAL, 
  id_comprobante_diario INTEGER,
  id_comprobante_pago INTEGER,
  id_proceso_wf INTEGER NOT NULL,
  id_estado_wf INTEGER NOT NULL,
  id_caja INTEGER NOT NULL, 
  estado VARCHAR(50) NOT NULL, 
  motivo TEXT NOT NULL,
  nro_tramite VARCHAR(50) NOT NULL, 
  fecha DATE NOT NULL,
  monto_reposicion NUMERIC(18,2), 
  tipo VARCHAR(50) NOT NULL, 
  CONSTRAINT pk_tproceso_caja__id_proceso_caja PRIMARY KEY(id_proceso_caja)
) INHERITS (pxp.tbase)
WITHOUT OIDS;
  
/*****************************F-SCP-JRR-TES-0-10/08/2015*************/


/*****************************I-SCP-JRR-TES-0-25/08/2015*************/

CREATE TABLE tes.testacion (
  id_estacion SERIAL,
  codigo VARCHAR,
  host VARCHAR,
  puerto VARCHAR,
  dbname VARCHAR,
  usuario VARCHAR,
  password VARCHAR,  
  id_depto_lb INTEGER,
  CONSTRAINT testacion_pkey PRIMARY KEY(id_estacion)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

CREATE TABLE tes.testacion_tipo_pago (
  id_estacion_tipo_pago SERIAL,
  id_estacion INTEGER,
  id_tipo_plan_pago INTEGER,
  codigo_plantilla_comprobante VARCHAR(50),
  CONSTRAINT testacion_tipo_pago_pkey PRIMARY KEY(id_estacion_tipo_pago)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

/*****************************F-SCP-JRR-TES-0-25/08/2015*************/


/*****************************I-SCP-RAC-TES-0-11/08/2015*************/


--------------- SQL ---------------

DROP VIEW IF EXISTS tes.vcomp_devtesprov_plan_pago;
--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ALTER COLUMN tipo_cambio_conv TYPE NUMERIC;
  
  
/*****************************F-SCP-RAC-TES-0-22/08/2015*************/

/*****************************I-SCP-GSS-TES-0-20/11/2016*************/
CREATE TABLE tes.tsolicitud_rendicion_det (
  id_solicitud_rendicion_det SERIAL, 
  id_documento_respaldo INTEGER, 
  id_solicitud_efectivo INTEGER, 
  id_proceso_caja INTEGER, 
  monto NUMERIC(18,2), 
  CONSTRAINT tsolicitud_rendicion_det_pkey PRIMARY KEY(id_solicitud_rendicion_det)
) INHERITS (pxp.tbase)

WITHOUT OIDS;;

/*****************************F-SCP-GSS-TES-0-20/11/2016*************/

/*****************************I-SCP-GSS-TES-0-21/01/2016*************/
ALTER TABLE tes.tcaja
  ADD COLUMN id_cuenta_bancaria INTEGER;
  
ALTER TABLE tes.tcaja
  RENAME COLUMN nombre TO codigo;

ALTER TABLE tes.tcaja
  ALTER COLUMN codigo TYPE VARCHAR(20);
  
ALTER TABLE tes.tcaja
  ALTER COLUMN estado SET DEFAULT 'cerrado';
  
ALTER TABLE tes.tcaja
  RENAME COLUMN monto_fondo TO importe_maximo;
  
ALTER TABLE tes.tcaja
  RENAME COLUMN monto_maximo_compra TO porcentaje_compra;

ALTER TABLE tes.tcaja
  ALTER COLUMN porcentaje_compra TYPE NUMERIC(6,2);

ALTER TABLE tes.tcaja
  ALTER COLUMN tipo_ejecucion TYPE VARCHAR(25);
  
/*****************************F-SCP-GSS-TES-0-21/01/2016*************/

/*****************************I-SCP-GSS-TES-0-29/01/2016*************/

ALTER TABLE tes.tproceso_caja
  ADD COLUMN fecha_inicio DATE;

ALTER TABLE tes.tproceso_caja
  ADD COLUMN fecha_fin DATE;
  
ALTER TABLE tes.tsolicitud_efectivo_det
  ALTER COLUMN id_partida_ejecucion DROP NOT NULL;
  
/*****************************F-SCP-GSS-TES-0-29/01/2016*************/


  
/*****************************I-SCP-RAC-TES-0-22/03/2016*************/

--------------- SQL ---------------

ALTER TABLE tes.tproceso_caja
  ADD COLUMN id_depto_conta INTEGER;

COMMENT ON COLUMN tes.tproceso_caja.id_depto_conta
IS 'hace referencia donde  se contabiliza el proceso';


--------------- SQL ---------------

ALTER TABLE tes.tproceso_caja
  ADD COLUMN id_gestion INTEGER;

COMMENT ON COLUMN tes.tproceso_caja.id_gestion
IS 'gestion del proceso';


/*****************************F-SCP-RAC-TES-0-22/03/2016*************/

/*****************************I-SCP-GSS-TES-0-28/03/2016*************/

ALTER TABLE tes.tproceso_caja
  RENAME COLUMN id_comprobante_pago TO id_int_comprobante;

ALTER TABLE tes.tproceso_caja
  DROP COLUMN id_comprobante_diario;


--------------- SQL ---------------

ALTER TABLE tes.tcaja
  ADD COLUMN fecha_apertura DATE;

COMMENT ON COLUMN tes.tcaja.fecha_apertura
IS 'ultima fecha de apertura de caja';


--------------- SQL ---------------

ALTER TABLE tes.tcaja
  ADD COLUMN fecha_cierre DATE;

COMMENT ON COLUMN tes.tcaja.fecha_cierre
IS 'ultima fecha de cierre de caja';

--------------- SQL ---------------

ALTER TABLE tes.tproceso_caja
  ADD COLUMN id_tipo_proceso_caja INTEGER;

COMMENT ON COLUMN tes.tproceso_caja.id_tipo_proceso_caja
IS 'hace referencia al tipo de proceso de caja';

--------------- SQL ---------------

ALTER TABLE tes.tproceso_caja
  ADD COLUMN id_proceso_caja_fk INTEGER;

COMMENT ON COLUMN tes.tproceso_caja.id_proceso_caja_fk
IS 'hace referencia al proceso de caja origen';

-------------- SQL -------------------

ALTER TABLE tes.tcaja
  ADD UNIQUE (codigo);

--------------- SQL ------------------


ALTER TABLE tes.tsolicitud_efectivo
  ADD COLUMN id_solicitud_efectivo_fk INTEGER;
  
  --------------- SQL ---------------

ALTER TABLE tes.tproceso_caja
  ADD COLUMN id_solicitud_efectivo_rel INTEGER;

COMMENT ON COLUMN tes.tproceso_caja.id_solicitud_efectivo_rel
IS 'en lso procesos de  apertura, reposición o cierre se inserta un registro en solicitud efectivo para facilitar el arqueo de caja';
  
/*****************************F-SCP-GSS-TES-0-28/03/2016*************/


/*****************************I-SCP-GSS-TES-0-28/04/2016*************/

  --------------- SQL ---------------
ALTER TABLE tes.tsolicitud_efectivo
ADD COLUMN id_funcionario_jefe_aprobador INTEGER;

COMMENT ON COLUMN tes.tsolicitud_efectivo.id_funcionario_jefe_aprobador
IS 'id del jefe que aprobo la solicitud de efectivo del solicitante';
  
/*****************************F-SCP-GSS-TES-0-28/04/2016*************/



/*****************************I-SCP-RAC-TES-0-04/05/2016*************/
--------------- SQL ---------------

ALTER TABLE tes.tproceso_caja
  ADD COLUMN id_proceso_caja_repo INTEGER;

COMMENT ON COLUMN tes.tproceso_caja.id_proceso_caja_repo
IS 'id del proceso de caja que identifica el proceso con el que se repone la rendiciones sueltas';


/*****************************F-SCP-RAC-TES-0-04/05/2016*************/

/*****************************I-SCP-GSS-TES-0-05/05/2016*************/
---------------- SQL ---------------
CREATE TABLE tes.ttipo_solicitud (
  id_tipo_solicitud SERIAL, 
  codigo VARCHAR, 
  nombre VARCHAR, 
  codigo_proceso_llave_wf VARCHAR, 
  codigo_plantilla_comprobante VARCHAR, 
  CONSTRAINT ttipo_solicitud_pkey PRIMARY KEY(id_tipo_solicitud)
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE tes.tproceso_caja
  ADD COLUMN id_cuenta_bancaria INTEGER;

ALTER TABLE tes.tproceso_caja
  ADD COLUMN id_cuenta_bancaria_mov INTEGER;

/*****************************F-SCP-GSS-TES-0-05/05/2016*************/


/*****************************I-SCP-GSS-TES-0-24/05/2016*************/

---------------- SQL ---------------
ALTER TABLE tes.tfinalidad
  ADD COLUMN tipo VARCHAR;

COMMENT ON COLUMN tes.tfinalidad.tipo
IS 'ingreso o egreso';
 
/*****************************F-SCP-GSS-TES-0-24/05/2016*************/


/*****************************I-SCP-GSS-TES-0-30/05/2016*************/

---------------- SQL ---------------
ALTER TABLE tes.tfinalidad
  ADD COLUMN sw_tipo_interfaz VARCHAR(50)[];
 
/*****************************F-SCP-GSS-TES-0-30/05/2016*************/

/*****************************I-SCP-GSS-TES-0-08/06/2016*************/

  --------------- SQL ---------------
ALTER TABLE tes.tsolicitud_efectivo
ADD COLUMN id_gestion INTEGER;

  --------------- SQL ---------------
ALTER TABLE tes.tsolicitud_efectivo
ADD COLUMN id_tipo_solicitud INTEGER;

  --------------- SQL ---------------
ALTER TABLE tes.tsolicitud_efectivo
ADD COLUMN fecha_entrega DATE;

COMMENT ON COLUMN tes.tsolicitud_efectivo.fecha_entrega
IS 'fecha de entrega del efectivo';

  --------------- SQL ---------------
ALTER TABLE tes.tproceso_caja
ADD COLUMN num_memo VARCHAR;

--------------- SQL ---------------

ALTER TABLE tes.tcaja
  ADD COLUMN id_depto_lb INTEGER;

ALTER TABLE tes.tcaja
  RENAME COLUMN importe_maximo TO importe_maximo_caja;
 
ALTER TABLE tes.tcaja
  RENAME COLUMN porcentaje_compra TO importe_maximo_item;

/*****************************F-SCP-GSS-TES-0-08/06/2016*************/

/*****************************I-SCP-GSS-TES-0-15/06/2016*************/

  
  
CREATE TABLE tes.ttipo_proceso_caja (
  id_tipo_proceso_caja SERIAL, 
  codigo VARCHAR, 
  nombre VARCHAR, 
  codigo_plantilla_cbte VARCHAR, 
  codigo_wf VARCHAR, 
  visible_en VARCHAR, 
  CONSTRAINT ttipo_proceso_caja_pkey PRIMARY KEY(id_tipo_proceso_caja), 
  CONSTRAINT chk_ttipo_proceso_caja__visible_en CHECK (((((visible_en)::text = 'abierto'::text) OR ((visible_en)::text = 'cerrado'::text)) OR ((visible_en)::text = 'ninguno'::text)) OR ((visible_en)::text = 'todos'::text))
) INHERITS (pxp.tbase)
WITHOUT OIDS;

/*****************************F-SCP-GSS-TES-0-15/06/2016*************/

/*****************************I-SCP-GSS-TES-0-23/06/2016*************/

ALTER TABLE tes.tcaja
  ADD COLUMN dias_maximo_rendicion INTEGER;
 
ALTER TABLE tes.tts_libro_bancos
  ADD COLUMN nro_deposito INTEGER UNIQUE;
  
/*****************************F-SCP-GSS-TES-0-23/06/2016*************/


/*****************************I-SCP-GSS-TES-0-22/08/2016*************/




--------------- SQL ---------------

ALTER TABLE tes.tts_libro_bancos
  ADD COLUMN fondo_devolucion_retencion VARCHAR(2);
  
  --------------- SQL ---------------

ALTER TABLE tes.tts_libro_bancos
  ADD COLUMN columna_pk VARCHAR(100);
  
  
  --------------- SQL ---------------

ALTER TABLE tes.tts_libro_bancos
  ADD COLUMN columna_pk_valor INTEGER;



/*****************************F-SCP-GSS-TES-0-22/08/2016*************/

/*****************************I-SCP-GSS-TES-0-16/12/2016*************/

CREATE TABLE tes.tdeposito_proceso_caja (
  id_deposito_proceso_caja SERIAL,
  id_proceso_caja INTEGER,
  id_libro_bancos INTEGER,
  importe_contable_deposito NUMERIC(20,2),
  CONSTRAINT tdeposito_proceso_caja_pkey PRIMARY KEY(id_deposito_proceso_caja)
) INHERITS (pxp.tbase)

WITH (oids = false);

/*****************************F-SCP-GSS-TES-0-16/12/2016*************/

/*****************************I-SCP-GSS-TES-0-15/03/2017*************/

CREATE TABLE tes.tcaja_funcionario (
  id_caja_funcionario SERIAL,
  id_caja INTEGER NOT NULL,
  id_funcionario INTEGER NOT NULL,
  CONSTRAINT tcaja_funcionario_pkey PRIMARY KEY(id_caja_funcionario)
) INHERITS (pxp.tbase)

WITH (oids = false);

/*****************************F-SCP-GSS-TES-0-15/03/2017*************/



/*****************************I-SCP-RAC-TES-0-26/07/2017*************/

 -- object recreation
ALTER TABLE tes.tobligacion_pago
  DROP CONSTRAINT chk_tobligacion_pago__tipo_obligacion RESTRICT;

ALTER TABLE tes.tobligacion_pago
  ADD CONSTRAINT chk_tobligacion_pago__tipo_obligacion CHECK ((tipo_obligacion)::text = ANY (ARRAY[ ('adquisiciones'::character varying)::text, ('pago_unico'::character varying)::text, ('pago_especial'::character varying)::text, ('caja_chica'::character varying)::text, ('viaticos'::character varying)::text, ('fondos_en_avance'::character varying)::text, ('pago_directo'::character varying)::text, ('rrhh'::character varying)::text]));


/*****************************F-SCP-RAC-TES-0-26/07/2017*************/





/*****************************I-SCP-RAC-TES-0-09/08/2017*************/


--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD COLUMN id_funcionario_responsable INTEGER;
  
 
/*****************************F-SCP-RAC-TES-0-09/08/2017*************/




/*****************************I-SCP-RAC-TES-0-18/08/2017*************/


CREATE TABLE tes.ttipo_cc_cuenta_libro (
  id_ttipo_cc_cuenta_libro SERIAL NOT NULL,
  id_tipo_cc INTEGER,
  id_cuenta_bancaria INTEGER,
  id_depto INTEGER,
  obs VARCHAR,
  PRIMARY KEY(id_ttipo_cc_cuenta_libro)
) INHERITS (pxp.tbase)
WITH (oids = false);

COMMENT ON TABLE tes.ttipo_cc_cuenta_libro
IS 'Esta tabla permite parametriza que cuentas bacaria y que libro de bancos se utilizas por defectopara realizar los apgos';

COMMENT ON COLUMN tes.ttipo_cc_cuenta_libro.id_depto
IS 'depto de libro de bancos';



/*****************************F-SCP-RAC-TES-0-18/08/2017*************/
  
  
  
  
/*****************************I-SCP-RAC-TES-0-05/12/2017*************/
  
  --------------- SQL ---------------  esta columnas se aumenta para considerar en la reposicon los ignresos de caja extra

ALTER TABLE tes.tsolicitud_efectivo
  ADD COLUMN ingreso_extra VARCHAR(4) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN tes.tsolicitud_efectivo.ingreso_extra
IS 'indica si es un ingreso extraa la reposicion de caja, sollo valido para solicitudes de  tipo INGEFE,  cuando el valor es si, significa que viene deviaticos o cuenta docuemntada, o por ajuste';


--------------- SQL ---------------

ALTER TABLE tes.tsolicitud_efectivo
  ADD COLUMN id_proceso_caja_repo INTEGER;

COMMENT ON COLUMN tes.tsolicitud_efectivo.id_proceso_caja_repo
IS 'Indica el id_proceso_caja de tipo reposicion donde fue considerado el ingreso_extra = si, para solicitudes de  tipo INGEFE';

  
/*************************F-SCP-RAC-TES-0-05/12/2017*************/
 





/*************************I-SCP-RAC-TES-0-25/01/2018*************/

CREATE TABLE tes.tplan_pago_doc_compra (
    id_plan_pago_doc_compra serial NOT NULL,
    id_plan_pago integer NOT NULL,
    id_doc_compra_venta integer,
    CONSTRAINT tplan_pago_doc_compra_pkey PRIMARY KEY (id_plan_pago_doc_compra)
)
    INHERITS (pxp.tbase)
WITH (
    OIDS = FALSE
);

--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD COLUMN fin_forzado VARCHAR(2) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN tes.tobligacion_pago.fin_forzado
IS 'si o no, se marca como si si es que la obligacion fue forzada a finalizar con anticpos o retenciones  o pagos pendientes';



/*************************F-SCP-RAC-TES-0-25/01/2018*************/


/*************************I-SCP-JUAN-TES-0-26/01/2018*************/

--------------- SQL ---------------

ALTER TABLE tes.tts_libro_bancos
  ADD COLUMN tabla VARCHAR(255);

/*************************F-SCP-JUAN-TES-0-26/10/2018*************/ 


/*************************I-SCP-RAC-TES-0-01/12/2018*************/




 
 CREATE TABLE tes.tcuenta_bancaria_periodo (
  id_usuario_reg INTEGER,
  id_usuario_mod INTEGER,
  fecha_reg TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
  fecha_mod TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
  estado_reg VARCHAR(10) DEFAULT 'activo'::character varying,
  id_usuario_ai INTEGER,
  usuario_ai VARCHAR(300),
  id_cuenta_bancaria_periodo SERIAL,
  id_cuenta_bancaria INTEGER,
  id_periodo INTEGER,
  estado VARCHAR,
  CONSTRAINT tcuenta_bancaria_periodo_pk_tcuenta_bancaria_periodo_id_cuenta_ PRIMARY KEY(id_cuenta_bancaria_periodo)
) INHERITS (pxp.tbase)

WITH (oids = false);

CREATE TABLE tes.tsolicitud_transferencia (
  id_usuario_reg INTEGER,
  id_usuario_mod INTEGER,
  fecha_reg TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
  fecha_mod TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
  estado_reg VARCHAR(10) DEFAULT 'activo'::character varying,
  id_usuario_ai INTEGER,
  usuario_ai VARCHAR(300),
  id_solicitud_transferencia SERIAL,
  id_cuenta_origen INTEGER,
  id_cuenta_destino INTEGER NOT NULL,
  monto NUMERIC(18,2) NOT NULL,
  motivo TEXT NOT NULL,
  num_tramite VARCHAR(25) NOT NULL,
  id_proceso_wf INTEGER NOT NULL,
  id_estado_wf INTEGER NOT NULL,
  estado VARCHAR(25) NOT NULL,
  id_int_comprobante INTEGER,
  CONSTRAINT tsolicitud_transferencia_pkey PRIMARY KEY(id_solicitud_transferencia)
) INHERITS (pxp.tbase)

WITH (oids = false);


COMMENT ON COLUMN tes.tobligacion_pago.id_funcionario_responsable
IS 'Funcionario que esta a cargo del plan de pagos cuando el solicitante original designa por alguna razon deja sus funciones o esta de vacion asigna a otro funcionario para que este continue con los pagos pendientes.';


ALTER TABLE tes.tobligacion_pago
  ADD COLUMN monto_total_adjudicado NUMERIC(19,2);


ALTER TABLE tes.tobligacion_pago
  ADD COLUMN total_anticipo NUMERIC(19,2);


ALTER TABLE tes.tobligacion_pago
  ADD COLUMN pedido_sap VARCHAR(100);



ALTER TABLE tes.ttipo_plan_pago
  ADD COLUMN tipo_ejecucion VARCHAR(20);

COMMENT ON COLUMN tes.ttipo_plan_pago.tipo_ejecucion
IS 'bandera que permite marcar cuales devengan, pagan o no ejecutan para ser considerados en el reporte de gary';

ALTER TABLE tes.tcaja
  ALTER COLUMN importe_maximo_item TYPE NUMERIC(18,2);


ALTER TABLE tes.tplan_pago
  ALTER COLUMN nro_cheque SET DEFAULT 0;
  
  ALTER TABLE tes.tplan_pago
  ADD COLUMN monto_anticipar_sg NUMERIC(19,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN tes.tplan_pago.monto_anticipar_sg
IS 'monto anticipar que puede ser aplicado con otro comprobante  o puede ser llevado al gasto en la siguiente gestion,  si este valor es mayor a cero al cerrar la obligacion de pagos y no a sido totalmente aplicado, debe crearce una obligacion de pago extentida  para la siguiente gestion con un plan de pagos del tipo anticipo en estado anticipado por la suma de estos valores en registors activos';

  
ALTER TABLE tes.tplan_pago
  ADD COLUMN observaciones_pago TEXT;

ALTER TABLE tes.tplan_pago
  ADD COLUMN es_ultima_cuota BOOLEAN;

COMMENT ON COLUMN tes.tplan_pago.es_ultima_cuota
IS 'Campo que nos sirve para verificar si es la ultima cuota de pago.';

ALTER TABLE tes.tplan_pago
  ADD COLUMN pago_borrador VARCHAR(50) DEFAULT 'no'::character varying NOT NULL;



ALTER TABLE tes.tproceso_caja
  ADD COLUMN monto NUMERIC(18,2);


ALTER TABLE tes.tproceso_caja
  ADD COLUMN monto_ren_ingreso NUMERIC DEFAULT 0 NOT NULL;

COMMENT ON COLUMN tes.tproceso_caja.monto_ren_ingreso
IS 'monto acumulado de recibo de ingreso a caja que deben ser contabilizados, hecho para rendiciones de fondos o viaticos';


ALTER TABLE tes.tsolicitud_efectivo
  ADD COLUMN id_funcionario_finanzas INTEGER;

COMMENT ON COLUMN tes.tsolicitud_efectivo.id_funcionario_finanzas
IS 'id del funcionario de finanzas';

COMMENT ON COLUMN tes.tsolicitud_efectivo.id_proceso_caja_repo
IS 'Indica el id_proceso_caja de tipo reposicion donde fue considerado el ingreso_extra = si,';

ALTER TABLE tes.tsolicitud_efectivo
  ADD COLUMN observaciones VARCHAR(1000);


ALTER TABLE tes.tsolicitud_efectivo
  ADD COLUMN id_proceso_caja_rend INTEGER;

COMMENT ON COLUMN tes.tsolicitud_efectivo.id_proceso_caja_rend
IS 'SOLO para ingresos identifica el proceso de caja donde se incluye la rendicion del ingreso de efectivo';

ALTER TABLE tes.tsolicitud_efectivo
  ADD COLUMN ingreso_cd VARCHAR(4) DEFAULT 'no'::character varying NOT NULL;

COMMENT ON COLUMN tes.tsolicitud_efectivo.ingreso_cd
IS 'Para marcar las solicitudes de Ingreso generadas desde sistema de cuenta documentada';


ALTER TABLE tes.tsolicitud_efectivo
  ADD COLUMN fecha_ult_mov DATE;

COMMENT ON COLUMN tes.tsolicitud_efectivo.fecha_ult_mov
IS 'fecha de ultimo omivimeitno se carga a travez de un triguer las pasar por ciertos estados';


ALTER TABLE tes.tsolicitud_efectivo
  ADD COLUMN fecha_entregado_ult DATE;

COMMENT ON COLUMN tes.tsolicitud_efectivo.fecha_entregado_ult
IS 'fecha de ultimo entregado';


ALTER TABLE tes.tsolicitud_efectivo
  ADD COLUMN fecha_mod_bk DATE;

ALTER TABLE tes.tsolicitud_efectivo_det
  ALTER COLUMN id_partida_ejecucion SET NOT NULL;


ALTER TABLE tes.tts_libro_bancos
  ADD CONSTRAINT tts_libro_bancos_fk FOREIGN KEY (id_libro_bancos_fk)
    REFERENCES tes.tts_libro_bancos(id_libro_bancos)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

 


ALTER TABLE tes.tsolicitud_efectivo
  ADD CONSTRAINT tsolicitud_efectivo__id_proceso_caja_red_fk FOREIGN KEY (id_proceso_caja_repo)
    REFERENCES tes.tproceso_caja(id_proceso_caja)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE tes.tplan_pago
  ADD CONSTRAINT fk_tplan_pago__id_cuenta_bancaria_mov FOREIGN KEY (id_cuenta_bancaria_mov)
    REFERENCES tes.tts_libro_bancos(id_libro_bancos)
    MATCH FULL
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;



ALTER TABLE tes.tcaja_funcionario
  ADD CONSTRAINT fk_tcaja_usuario__id_caja FOREIGN KEY (id_caja)
    REFERENCES tes.tcaja(id_caja)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


-- object recreation
ALTER TABLE tes.tobligacion_pago
  DROP CONSTRAINT chk_tobligacion_pago__estado RESTRICT;

ALTER TABLE tes.tobligacion_pago
  ADD CONSTRAINT chk_tobligacion_pago__estado CHECK ((estado)::text = ANY (ARRAY[('liberacion'::character varying)::text, ('borrador'::character varying)::text, ('registrado'::character varying)::text, ('en_pago'::character varying)::text, ('finalizado'::character varying)::text, ('vbpoa'::character varying)::text, ('vbpresupuestos'::character varying)::text, ('anulado'::character varying)::text]));



ALTER TABLE tes.tobligacion_pago
  DROP CONSTRAINT chk_tobligacion_pago__tipo_obligacion RESTRICT;

ALTER TABLE tes.tobligacion_pago
  ADD CONSTRAINT chk_tobligacion_pago__tipo_obligacion CHECK ((tipo_obligacion)::text = ANY (ARRAY[('adquisiciones'::character varying)::text, ('pago_unico'::character varying)::text, ('pago_especial'::character varying)::text, ('caja_chica'::character varying)::text, ('viaticos'::character varying)::text, ('fondos_en_avance'::character varying)::text, ('pago_directo'::character varying)::text, ('rrhh'::character varying)::text]));




/*************************F-SCP-RAC-TES-0-01/12/2018*************/


/*************************I-SCP-CAP-TES-0-06/12/2018*************/

ALTER TABLE tes.tobligacion_pago
  ALTER COLUMN monto_ajuste_ret_garantia_ga DROP NOT NULL;

ALTER TABLE tes.tobligacion_pago
  ALTER COLUMN monto_ajuste_ret_anticipo_par_ga DROP NOT NULL;


/*************************F-SCP-CAP-TES-0-06/12/2018*************/



/*************************I-SCP-CAP-TES-7890-13/12/2018*************/

--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD COLUMN monto_sg_mo NUMERIC(19,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN tes.tobligacion_pago.monto_sg_mo
IS 'monto para ser pagado en la sigueinbte gestion,  este monto no sera comprometido,  se prorrate entr_monto_sg_mo en la tabla obligacion_det';

--------------- SQL ---------------

ALTER TABLE tes.tobligacion_det
  ADD COLUMN monto_pago_sg_mo NUMERIC(19,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN tes.tobligacion_det.monto_pago_sg_mo
IS 'monto a pagar siguiente gestion en moneda original, este monto no comprometera presupuesto';

--------------- SQL ---------------

ALTER TABLE tes.tobligacion_det
  ADD COLUMN monto_pago_sg_mb NUMERIC(19,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN tes.tobligacion_det.monto_pago_sg_mb
IS 'monto para la siguiente gestion en moenda base, este monto no comprometera presupuestos';

/*************************F-SCP-CAP-TES-7890-13/12/2018*************/



/*************************I-SCP-RAC-TES-12-13/12/2018*************/

--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD COLUMN comprometer_iva VARCHAR(2) DEFAULT 'si' NOT NULL;

COMMENT ON COLUMN tes.tobligacion_pago.comprometer_iva
IS 'si esta bandera esta habilita le resta el 13% del iva al momento de comproemter la obligacion de pago,   solo es validao para los que nacen en tesoreria, no considerado para lso que vienes de adquisiciones';


/*************************F-SCP-RAC-TES-12-13/12/2018*************/

/*************************I-SCP-VAN-TES-13-06/12/2019*************/
alter table tes.tplan_pago
	add codigo_tipo_anticipo varchar(50) default null;
/*************************F-SCP-VAN-TES-13-06/12/2019*************/

/*************************I-SCP-JUAN-TES-13-30/01/2020*************/
ALTER TABLE tes.tobligacion_pago--#48
  ADD COLUMN cod_tipo_relacion VARCHAR(50);--#48
/*************************F-SCP-JUAN-TES-13-30/01/2020*************/




/*************************I-SCP-RAC-TES-59-06/03/2020*************/

CREATE INDEX tobligacion_pago_idx2 ON tes.tobligacion_pago
  USING btree (num_tramite);
  

/*************************F-SCP-RAC-TES-59-06/03/2020*************/




/*************************I-SCP-RAC-TES-60-11/03/2020*************/

--------------- SQL ---------------

ALTER TABLE tes.tts_libro_bancos
  ADD CONSTRAINT tts_libro_bancos_fk1 FOREIGN KEY (id_cuenta_bancaria)
    REFERENCES tes.tcuenta_bancaria(id_cuenta_bancaria)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
 
/*************************F-SCP-RAC-TES-60-11/03/2020*************/   