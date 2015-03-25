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







/***********************************I-SCP-RAC-TES-0-19/08/2014***************************************/

CREATE OR REPLACE VIEW tes.vcomp_devtesprov_plan_pago_2(
    id_plan_pago,
    id_proveedor,
    desc_proveedor,
    id_moneda,
    id_depto_conta,
    numero,
    fecha_actual,
    estado,
    monto_ejecutar_total_mb,
    monto_ejecutar_total_mo,
    monto,
    monto_mb,
    monto_retgar_mb,
    monto_retgar_mo,
    monto_no_pagado,
    monto_no_pagado_mb,
    otros_descuentos,
    otros_descuentos_mb,
    id_plantilla,
    id_cuenta_bancaria,
    id_cuenta_bancaria_mov,
    nro_cheque,
    nro_cuenta_bancaria,
    num_tramite,
    tipo,
    id_gestion_cuentas,
    id_int_comprobante,
    liquido_pagable,
    liquido_pagable_mb,
    nombre_pago,
    porc_monto_excento_var,
    obs_pp,
    descuento_anticipo,
    descuento_inter_serv,
    tipo_obligacion,
    id_categoria_compra,
    codigo_categoria,
    nombre_categoria,
    id_proceso_wf,
    detalle,
    codigo_moneda,
    nro_cuota,
    tipo_pago,
    tipo_solicitud,
    tipo_concepto_solicitud,
    total_monto_op_mb,
    total_monto_op_mo,
    total_pago)
AS
  SELECT pp.id_plan_pago,
         op.id_proveedor,
         p.desc_proveedor,
         op.id_moneda,
         op.id_depto_conta,
         op.numero,
         now() AS fecha_actual,
         pp.estado,
         pp.monto_ejecutar_total_mb,
         pp.monto_ejecutar_total_mo,
         pp.monto,
         pp.monto_mb,
         pp.monto_retgar_mb,
         pp.monto_retgar_mo,
         pp.monto_no_pagado,
         pp.monto_no_pagado_mb,
         pp.otros_descuentos,
         pp.otros_descuentos_mb,
         pp.id_plantilla,
         pp.id_cuenta_bancaria,
         pp.id_cuenta_bancaria_mov,
         pp.nro_cheque,
         pp.nro_cuenta_bancaria,
         op.num_tramite,
         pp.tipo,
         op.id_gestion AS id_gestion_cuentas,
         pp.id_int_comprobante,
         pp.liquido_pagable,
         pp.liquido_pagable_mb,
         pp.nombre_pago,
         pp.porc_monto_excento_var,
         ((COALESCE(op.numero, '' ::character varying) ::text || ' ' ::text) ||
          COALESCE(pp.obs_monto_no_pagado, '' ::text)) ::character varying AS
           obs_pp,
         pp.descuento_anticipo,
         pp.descuento_inter_serv,
         op.tipo_obligacion,
         op.id_categoria_compra,
         COALESCE(cac.codigo, '' ::character varying) AS codigo_categoria,
         COALESCE(cac.nombre, '' ::character varying) AS nombre_categoria,
         pp.id_proceso_wf,
         ('<table>' ::text || pxp.html_rows((((('<td>' ::text ||
          ci.desc_ingas::text) || '<br/>' ::text) || od.descripcion) || '</td>'
           ::text) ::character varying) ::text) || '</table>' ::text AS detalle,
         mon.codigo AS codigo_moneda,
         pp.nro_cuota,
         pp.tipo_pago,
         op.tipo_solicitud,
         op.tipo_concepto_solicitud,
         sum(od.monto_pago_mb) AS total_monto_op_mb,
         sum(od.monto_pago_mo) AS total_monto_op_mo,
         op.total_pago
  FROM tes.tplan_pago pp
       JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago =
        op.id_obligacion_pago
       JOIN param.tmoneda mon ON mon.id_moneda = op.id_moneda
       JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor
       LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
        op.id_categoria_compra
       JOIN tes.tobligacion_det od ON od.id_obligacion_pago =
        op.id_obligacion_pago
       JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas =
        od.id_concepto_ingas
  GROUP BY pp.id_plan_pago,
           op.id_proveedor,
           p.desc_proveedor,
           op.id_moneda,
           op.id_depto_conta,
           op.numero,
           pp.estado,
           pp.monto_ejecutar_total_mb,
           pp.monto_ejecutar_total_mo,
           pp.monto,
           pp.monto_mb,
           pp.monto_retgar_mb,
           pp.monto_retgar_mo,
           pp.monto_no_pagado,
           pp.monto_no_pagado_mb,
           pp.otros_descuentos,
           pp.otros_descuentos_mb,
           pp.id_plantilla,
           pp.id_cuenta_bancaria,
           pp.id_cuenta_bancaria_mov,
           pp.nro_cheque,
           pp.nro_cuenta_bancaria,
           op.num_tramite,
           pp.tipo,
           op.id_gestion,
           pp.id_int_comprobante,
           pp.liquido_pagable,
           pp.liquido_pagable_mb,
           pp.nombre_pago,
           pp.porc_monto_excento_var,
           pp.obs_monto_no_pagado,
           pp.descuento_anticipo,
           pp.descuento_inter_serv,
           op.tipo_obligacion,
           op.id_categoria_compra,
           cac.codigo,
           cac.nombre,
           pp.id_proceso_wf,
           mon.codigo,
           pp.nro_cuota,
           pp.tipo_pago,
           op.total_pago,
           op.tipo_solicitud,
           op.tipo_concepto_solicitud;

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


--------------- SQL ---------------

DROP VIEW tes.vcomp_devtesprov_plan_pago;

--------------- SQL ---------------

DROP VIEW tes.vcomp_devtesprov_plan_pago_2;
--------------- SQL ---------------

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
