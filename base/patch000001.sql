/***********************************I-SCP-GSS-TES-45-01/04/2013****************************************/

--tabla tes.tobligacion_pago

CREATE TABLE tes.tobligacion_pago (
  id_obligacion_pago SERIAL, 
  id_proveedor INTEGER,
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
  tipo_cambio_conv NUMERIC, 
  num_tramite VARCHAR(200), 
  tipo_obligacion VARCHAR(30), 
  comprometido VARCHAR(2) DEFAULT 'no'::character varying, 
  pago_variable VARCHAR(2) DEFAULT 'no'::character varying NOT NULL, 
  nro_cuota_vigente NUMERIC(20,0) DEFAULT 0 NOT NULL,
  total_pago NUMERIC(19,2),  
  id_depto_conta INTEGER,
  total_nro_cuota INTEGER DEFAULT 0 NOT NULL,
  id_plantilla INTEGER,
  fecha_pp_ini DATE,
  rotacion INTEGER DEFAULT 1,
  ultima_cuota_pp NUMERIC(4,2),
  ultimo_estado_pp VARCHAR(150),
  tipo_anticipo VARCHAR(5) DEFAULT 'no' NOT NULL,
  id_categoria_compra INTEGER,
  tipo_solicitud VARCHAR(50) DEFAULT '' NOT NULL,
  tipo_concepto_solicitud VARCHAR(50) DEFAULT '' NOT NULL,
  id_funcionario_gerente INTEGER,
  ajuste_anticipo NUMERIC(19,2) DEFAULT 0 NOT NULL,
  ajuste_aplicado NUMERIC(19,2) DEFAULT 0 NOT NULL,
  monto_estimado_sg NUMERIC(19,2) DEFAULT 0 NOT NULL,
  id_obligacion_pago_extendida INTEGER,
  monto_ajuste_ret_garantia_ga NUMERIC(19,2) DEFAULT 0 ,
  monto_ajuste_ret_anticipo_par_ga NUMERIC(19,2) DEFAULT 0 ,
  id_contrato INTEGER,
  obs_presupuestos VARCHAR,
  ultima_cuota_dev NUMERIC,
  codigo_poa VARCHAR,
  obs_poa VARCHAR,
  uo_ex VARCHAR(4) DEFAULT 'no' NOT NULL,
  id_funcionario_responsable INTEGER,
  monto_total_adjudicado NUMERIC(19,2),
  total_anticipo NUMERIC(19,2),
  pedido_sap VARCHAR(100),
  fin_forzado VARCHAR(2) DEFAULT 'no' NOT NULL,
  monto_sg_mo NUMERIC(19,2) DEFAULT 0 NOT NULL,
  comprometer_iva VARCHAR(2) DEFAULT 'si' NOT NULL,
  bloqueado integer default 0,
  cod_tipo_relacion VARCHAR(50),
  id_funcionario_gestor integer,
  CONSTRAINT pk_tobligacion_pago__id_obligacion_pago PRIMARY KEY(id_obligacion_pago), 
  CONSTRAINT chk_tobligacion_pago__estado CHECK ((estado)::text = ANY (ARRAY[('liberacion'::character varying)::text, ('borrador'::character varying)::text, ('registrado'::character varying)::text, ('en_pago'::character varying)::text, ('finalizado'::character varying)::text, ('vbpoa'::character varying)::text, ('vbpresupuestos'::character varying)::text, ('anulado'::character varying)::text])),
  CONSTRAINT chk_tobligacion_pago__tipo_obligacion CHECK ((tipo_obligacion)::text = ANY (ARRAY[('adquisiciones'::character varying)::text, ('pago_unico'::character varying)::text, ('pago_especial'::character varying)::text, ('caja_chica'::character varying)::text, ('viaticos'::character varying)::text, ('fondos_en_avance'::character varying)::text, ('pago_directo'::character varying)::text, ('rrhh'::character varying)::text]))
  

) INHERITS (pxp.tbase)
WITHOUT OIDS;

COMMENT ON COLUMN tes.tobligacion_pago.id_plantilla
IS 'rAra registra el documento por defecto para los planes de pago';

COMMENT ON COLUMN tes.tobligacion_pago.fecha_pp_ini
IS 'Fecha tentativa inicial para los planes de pago';

COMMENT ON COLUMN tes.tobligacion_pago.rotacion
IS 'Cada cuantos meses se registrar las fechas tentaivas a partir de la inicial';

COMMENT ON COLUMN tes.tobligacion_pago.ultima_cuota_pp
IS 'eace referencia al numero de la ultima uocta modificada';

COMMENT ON COLUMN tes.tobligacion_pago.ultimo_estado_pp
IS 'ultimo estado del plan de pago correpondiente a la cuota indicada en ultima_cuota_pp';

COMMENT ON COLUMN tes.tobligacion_pago.tipo_anticipo
IS 'tipo anticipo, si o no';

COMMENT ON COLUMN tes.tobligacion_pago.id_categoria_compra
IS 'ei la obligacion de pago es de adquisiciones para acceso mas rapido al datos copiamos la categoria dde compra que viene en la solicitud';

COMMENT ON COLUMN tes.tobligacion_pago.tipo_solicitud
IS 'cuando viene de adquisiciones para disminuir la complekidad de las consultas copiamos el tipo de la tabla solicitud de compra';

COMMENT ON COLUMN tes.tobligacion_pago.tipo_concepto_solicitud
IS 'cuando viene de adquisiciones para disminuir la complekidad de las consultas copiamos el tipo_concepto de la tabla solicitud de compra';

COMMENT ON COLUMN tes.tobligacion_pago.id_funcionario_gerente
IS 'se campo se define en funcion del funcionario solcitante,  se asigna el gerente de menor nivel en la escala jerarquica';

COMMENT ON COLUMN tes.tobligacion_pago.ajuste_anticipo
IS 'Ajuste de anticipo se utuliza para cuaadrar y poder cerrar el proceso de obligacion de pago cuando de falta en el monto anticipado. Se tiene un monto aplicado mayor que el monto aplicado';

COMMENT ON COLUMN tes.tobligacion_pago.ajuste_aplicado
IS 'Se utiliza para hacer cuadrad el monto anticipado total con el monto aplicado, se utilia cuando el monto anticipado total sobrepasa el monto aplicado';

COMMENT ON COLUMN tes.tobligacion_pago.monto_estimado_sg
IS 'monto estimado para ser pagado en la siguiente gestion , este campo afecta la validacion del total por pagar';

COMMENT ON COLUMN tes.tobligacion_pago.id_obligacion_pago_extendida
IS 'Este campo sirve para relacionar la obligacion que se extiende a la siguiente gestion por tener un saldo anticipado';

COMMENT ON COLUMN tes.tobligacion_pago.monto_ajuste_ret_garantia_ga
IS 'Este campo almacena en obligaciones extendidas saldo de retenciones de garantia por devolver';

COMMENT ON COLUMN tes.tobligacion_pago.monto_ajuste_ret_anticipo_par_ga
IS 'este campo almacena en obligaciones entendidas el saldo de anticipo parcial por retener de la gestion anterior';

COMMENT ON COLUMN tes.tobligacion_pago.id_contrato
IS 'si la obligacion tiene un contrato de referencia';

COMMENT ON COLUMN tes.tobligacion_pago.obs_presupuestos
IS 'para inotrducir obs en el area de presupuestos';

COMMENT ON COLUMN tes.tobligacion_pago.ultima_cuota_dev
IS 'identifica la ultima cuota  del tipo devengado para alertar sobre ultimo pago, sellena atravez de un triguer en la tabla de plan de pagos';

COMMENT ON COLUMN tes.tobligacion_pago.codigo_poa
IS 'Codigo de actividad POA';

COMMENT ON COLUMN tes.tobligacion_pago.obs_poa
IS 'par ainsertar al guna observacion de POA';

COMMENT ON COLUMN tes.tobligacion_pago.uo_ex
IS 'cuando la uo que aprueba se selecciona de la tabla de excepcion queda marcado como si';

COMMENT ON COLUMN tes.tobligacion_pago.fin_forzado
IS 'si o no, se marca como si si es que la obligacion fue forzada a finalizar con anticpos o retenciones  o pagos pendientes';

COMMENT ON COLUMN tes.tobligacion_pago.id_funcionario_responsable
IS 'Funcionario que esta a cargo del plan de pagos cuando el solicitante original designa por alguna razon deja sus funciones o esta de vacion asigna a otro funcionario para que este continue con los pagos pendientes.';

COMMENT ON COLUMN tes.tobligacion_pago.monto_sg_mo
IS 'monto para ser pagado en la sigueinbte gestion,  este monto no sera comprometido,  se prorrate entr_monto_sg_mo en la tabla obligacion_det';

COMMENT ON COLUMN tes.tobligacion_pago.comprometer_iva
IS 'si esta bandera esta habilita le resta el 13% del iva al momento de comproemter la obligacion de pago,   solo es validao para los que nacen en tesoreria, no considerado para lso que vienes de adquisiciones';

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
  revertido_mb NUMERIC(19,2) DEFAULT 0 NOT NULL,
  incrementado_mb NUMERIC(19,2) DEFAULT 0 NOT NULL,
  incrementado_mo NUMERIC(19,2) DEFAULT 0 NOT NULL,
  revertido_mo NUMERIC(19,2) DEFAULT 0 NOT NULL,
  id_orden_trabajo INTEGER,
  monto_pago_sg_mo NUMERIC(19,2) DEFAULT 0 NOT NULL,
  monto_pago_sg_mb NUMERIC(19,2) DEFAULT 0 NOT NULL,
 
  CONSTRAINT pk_tobligacion_det__id_obligacion_det PRIMARY KEY(id_obligacion_det)
) INHERITS (pxp.tbase)
WITHOUT OIDS;
COMMENT ON COLUMN tes.tobligacion_det.incrementado_mb
IS 'En este campo se almacenan los incrementos acumulados en el presupeussto comprometido';

COMMENT ON COLUMN tes.tobligacion_det.id_orden_trabajo
IS 'orden de trabajo';

COMMENT ON COLUMN tes.tobligacion_det.monto_pago_sg_mo
IS 'monto a pagar siguiente gestion en moneda original, este monto no comprometera presupuesto';

COMMENT ON COLUMN tes.tobligacion_det.monto_pago_sg_mb
IS 'monto para la siguiente gestion en moenda base, este monto no comprometera presupuestos';

ALTER TABLE tes.tobligacion_det OWNER TO postgres;

--tabla tes.tplan_pago

CREATE TABLE tes.tplan_pago(
    id_plan_pago SERIAL NOT NULL,
    id_obligacion_pago int4 NOT NULL,
    id_plantilla int4,
    id_plan_pago_fk int4,
    id_cuenta_bancaria int4,
    id_int_comprobante int4,
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
    tipo_cambio numeric(19, 2) DEFAULT 1 NOT NULL ,
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
    total_pagado NUMERIC(19,2) DEFAULT 0 NOT NULL,
    sinc_presupuesto VARCHAR(2) DEFAULT 'no' NOT NULL,
    monto_retgar_mo NUMERIC(19,2) DEFAULT 0 NOT NULL,
    monto_retgar_mb NUMERIC(19,2) DEFAULT 0 NOT NULL,
    descuento_ley NUMERIC(18,2) DEFAULT 0 NOT NULL,
    obs_descuentos_ley TEXT,
    descuento_ley_mb NUMERIC(18,2) DEFAULT 0 NOT NULL,
    porc_descuento_ley NUMERIC DEFAULT 0 NOT NULL,
    nro_cheque INTEGER NOT NULL DEFAULT 0,
    nro_cuenta_bancaria VARCHAR(100) ,
    id_cuenta_bancaria_mov integer,
    monto_excento NUMERIC(12,2) DEFAULT 0 NOT NULL,
    porc_monto_excento_var NUMERIC DEFAULT 0 NOT NULL,
    descuento_inter_serv NUMERIC(19,2) DEFAULT 0 NOT NULL,
    obs_descuento_inter_serv TEXT,
    porc_monto_retgar NUMERIC,
    revisado_asistente VARCHAR(5) DEFAULT 'no' NOT NULL,
    conformidad TEXT,
    fecha_conformidad DATE,
    monto_ajuste_ag NUMERIC(19,2) DEFAULT 0 NOT NULL,
    monto_ajuste_siguiente_pago NUMERIC(19,2) DEFAULT 0 NOT NULL,
    monto_anticipo NUMERIC(19,2) DEFAULT 0 NOT NULL,
    fecha_costo_ini DATE,
    fecha_costo_fin DATE,
    tiene_form500 VARCHAR(13) DEFAULT 'no' NOT NULL,
    id_depto_lb INTEGER,
    id_depto_conta INTEGER,
    monto_anticipar_sg NUMERIC(19,2) DEFAULT 0 NOT NULL,
    observaciones_pago TEXT,
    es_ultima_cuota BOOLEAN,
    pago_borrador VARCHAR(50) DEFAULT 'no'::character varying NOT NULL,
    codigo_tipo_anticipo varchar(50) default null,
    fecha_documento DATE,
    fecha_derivacion DATE,
    dias_limite INTEGER,
    fecha_vencimiento DATE,
    PRIMARY KEY (id_plan_pago)) INHERITS (pxp.tbase);
    
COMMENT ON COLUMN tes.tplan_pago.total_pagado
IS 'ESta columana acumula el total de pago registrados, solo es util para cuotas del tipo devengado o devengado_pago';
  
COMMENT ON COLUMN tes.tplan_pago.sinc_presupuesto
IS 'este campo indica que falta presupuesto comprometido para realizar el pago, y es necesario incremetar con una sincronizacion';  

COMMENT ON COLUMN tes.tplan_pago.monto_retgar_mo
IS 'Aqui se almacenea el monto qeu se retrendra por concepto de garantia';

COMMENT ON COLUMN tes.tplan_pago.monto_retgar_mb
IS 'conto de retencion de garantia en moneda base';

COMMENT ON COLUMN tes.tplan_pago.descuento_ley
IS 'en este campo se registran los decuento asociados al tipo de documentos, por ejemplo si es recibo con retencion de bienes, se retiene 3% del IT y 5%del IUE';

COMMENT ON COLUMN tes.tplan_pago.obs_descuentos_ley
IS 'este campo espeficia los porcentajes aplicado a los decuentos, es solo descriptivo';

COMMENT ON COLUMN tes.tplan_pago.descuento_ley_mb
IS 'descuentos de ley en moneda base';

COMMENT ON COLUMN tes.tplan_pago.porc_descuento_ley
IS 'cste campo almacena el porcentaje de descuentos de ley, se utiliza para las cuotas de tipo pago';

COMMENT ON COLUMN tes.tplan_pago.nro_cheque
IS 'Número de cheque que se utilizará para realizar el pago';

COMMENT ON COLUMN tes.tplan_pago.nro_cuenta_bancaria
IS 'Número de cuenta bancaria para realizar el pago cuando es Transferencia';

COMMENT ON COLUMN tes.tplan_pago.revisado_asistente
IS 'este campo sirve para marcar los pagos revisados por las asistente';

COMMENT ON COLUMN tes.tplan_pago.monto_ajuste_ag
IS 'monto de ajuste anterior gestion, (se usa en anticipos parciales). Si sobro dinero de un anticipo en la anterior gestion se utuliza este campo para ajustar contra ese sobrante';

COMMENT ON COLUMN tes.tplan_pago.monto_ajuste_siguiente_pago
IS 'Se utiliza par la aplicacion de anticipos totales,  si falta dinero para cubrir la aplicacion en este monto,  en este campo ponemos el monto a cubrir con el siguiente anticipo';

COMMENT ON COLUMN tes.tplan_pago.monto_anticipo
IS 'monto anticipar que puede ser aplicado con otro comprobante  o puede ser llevado al gasto en la siguiente gestion,  si este valor es mayor a cero al cerrar la obligacion de pagos y no a sido totalmente aplicado, debe crearce una obligacion de pago extentida  para la siguiente gestion con un plan de pagos del tipo anticipo en estado anticipado por la suma de estos valores en registors activos';

COMMENT ON COLUMN tes.tplan_pago.fecha_costo_ini
IS 'Cuando un concepto de gasto es del tipo servicio, esta fecha indica el inico del costo';

COMMENT ON COLUMN tes.tplan_pago.fecha_costo_fin
IS 'Cuando un concepto de gasto es del tipo servicio, esta fecha indica el fin del costo';

COMMENT ON COLUMN tes.tplan_pago.tipo
IS 'det_rendicion, dev_garantia, ant_aplicado , pagado_rrh, pagado, ant_parcial, anticipo, rendicion, devengado_rrhh, devengado, devengado_pagado_1c, devengado_pagado';

COMMENT ON COLUMN tes.tplan_pago.tiene_form500
IS 'esta bander indica que el formulario 500 ya ue registrado';

COMMENT ON COLUMN tes.tplan_pago.id_depto_lb
IS 'identifica el libro de pango con el que se paga el cheque, sirve apra filtrar las cuentas bancarias que se peudne seleccionar';

COMMENT ON COLUMN tes.tplan_pago.id_depto_conta
IS 'define el depto de conta que contabiliza el pago, ...  no consideramos ep, cc (antes solo lo teneiamos en la obligacion de pago)';

COMMENT ON COLUMN tes.tplan_pago.monto_anticipar_sg
IS 'monto anticipar que puede ser aplicado con otro comprobante  o puede ser llevado al gasto en la siguiente gestion,  si este valor es mayor a cero al cerrar la obligacion de pagos y no a sido totalmente aplicado, debe crearce una obligacion de pago extentida  para la siguiente gestion con un plan de pagos del tipo anticipo en estado anticipado por la suma de estos valores en registors activos';

COMMENT ON COLUMN tes.tplan_pago.es_ultima_cuota
IS 'Campo que nos sirve para verificar si es la ultima cuota de pago.';

COMMENT ON COLUMN tes.tplan_pago."dias_limite"
    IS 'Dias habiles limite para el pago contractual';
-----------------------------------------


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
    id_int_transaccion INTEGER,
    id_prorrateo_fk INTEGER,
    PRIMARY KEY (id_prorrateo))
    INHERITS (pxp.tbase); 
    
    COMMENT ON COLUMN tes.tprorrateo.id_int_transaccion
    IS 'relaciona el prorrateo del devengado con la transaccion don de se ejecuta el presupuesto'; 

    COMMENT ON COLUMN tes.tprorrateo.id_prorrateo_fk
    IS 'solo sirve para prorrateos de pago, referencia el prorrateo del devengado';


/***********************************F-SCP-GSS-TES-45-01/04/2013****************************************/

/***********************************I-SCP-GSS-TES-121-24/04/2013***************************************/
--tabla tes.tplan_pago

CREATE TABLE tes.tcuenta_bancaria (
  id_cuenta_bancaria SERIAL, 
  id_institucion INTEGER NOT NULL, 
  nro_cuenta VARCHAR, 
  fecha_alta DATE, 
  fecha_baja DATE, 
  id_moneda INTEGER,
  centro VARCHAR(4) DEFAULT 'si' NOT NULL,
  denominacion VARCHAR(100),
  id_finalidad INTEGER[],
  CONSTRAINT pk_tcuenta_bancaria_id_cuenta_bancaria PRIMARY KEY(id_cuenta_bancaria)
) INHERITS (pxp.tbase)
WITHOUT OIDS;
COMMENT ON COLUMN tes.tcuenta_bancaria.centro
IS 'Identifica si es de la regional central o no. Viene por la integracionde cuenta bancaria endesis';

COMMENT ON COLUMN tes.tcuenta_bancaria.id_finalidad
IS 'arreglo que almacena los ids de la tabla finalidad al cual corresponde la cuenta bancaria';


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
  tipo VARCHAR(20) NOT NULL, 
  estado VARCHAR(20) NOT NULL DEFAULT 'cerrado', 
  codigo varchar(20) NOT NULL,
  importe_maximo_caja NUMERIC(18,2) NOT NULL,
  importe_maximo_item NUMERIC(18,2) NOT NULL,
  tipo_ejecucion VARCHAR(25) NOT NULL,
  id_cuenta_bancaria INTEGER,
  fecha_apertura DATE,
  fecha_cierre DATE,
  id_depto_lb INTEGER,
  dias_maximo_rendicion INTEGER,
  CONSTRAINT pk_tcaja__id_caja PRIMARY KEY(id_caja),
  CONSTRAINT tcaja_codigo_key UNIQUE (codigo)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

COMMENT ON COLUMN tes.tcaja.fecha_apertura
IS 'ultima fecha de apertura de caja';


COMMENT ON COLUMN tes.tcaja.fecha_cierre
IS 'ultima fecha de cierre de caja';
/***********************************F-SCP-ECR-TES-0-20/12/2013***************************************/

/***********************************I-SCP-ECR-TES-2-20/12/2013***************************************/
CREATE TABLE tes.tcajero (
  id_cajero SERIAL, 
  id_funcionario INTEGER NOT NULL, 
  tipo VARCHAR(20) NOT NULL, 
  estado VARCHAR(20) NOT NULL, 
  id_caja INTEGER, 
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE,
  CONSTRAINT pk_tcajero__id_cajero PRIMARY KEY(id_cajero)
) INHERITS (pxp.tbase)
WITHOUT OIDS;
/***********************************F-SCP-ECR-TES-2-20/12/2013***************************************/


/***********************************I-SCP-RAC-TES-0-08/07/2014***************************************/

CREATE TABLE tes.ttipo_plan_pago (
  id_tipo_plan_pago SERIAL NOT NULL, 
  codigo VARCHAR NOT NULL, 
  descripcion VARCHAR, 
  codigo_proceso_llave_wf VARCHAR NOT NULL, 
  codigo_plantilla_comprobante VARCHAR, 
  tipo_ejecucion VARCHAR(20),
  PRIMARY KEY(id_tipo_plan_pago)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

COMMENT ON COLUMN tes.ttipo_plan_pago.codigo_proceso_llave_wf
IS 'relaciona con tipo de proocesos wf para este pago';

COMMENT ON COLUMN tes.ttipo_plan_pago.codigo_plantilla_comprobante
IS 'relaciona con la plantilla de comprobante para este tipo de pago';

COMMENT ON COLUMN tes.ttipo_plan_pago.tipo_ejecucion
IS 'bandera que permite marcar cuales devengan, pagan o no ejecutan para ser considerados en el reporte de gary';


/***********************************F-SCP-RAC-TES-0-08/07/2014***************************************/

/***********************************I-SCP-JRR-TES-0-31/07/2014***************************************/

CREATE TABLE tes.ttipo_prorrateo (
  id_tipo_prorrateo SERIAL, 
  codigo VARCHAR (50) NOT NULL, 
  nombre VARCHAR (150) NOT NULL,
  descripcion TEXT,
  es_plantilla VARCHAR (2) NOT NULL,
  tiene_cuenta VARCHAR (2) NOT NULL,  
  tiene_lugar VARCHAR(2),
  CONSTRAINT ttipo_prorrateo_pkey PRIMARY KEY(id_tipo_prorrateo)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

/***********************************F-SCP-JRR-TES-0-31/07/2014***************************************/



/***********************************I-SCP-GSS-TES-0-27/10/2014***************************************/
CREATE TABLE tes.tfinalidad (
  id_finalidad SERIAL, 
  nombre_finalidad VARCHAR(200), 
  color VARCHAR(50), 
  estado VARCHAR(20), 
  tipo VARCHAR,
  sw_tipo_interfaz VARCHAR(50)[],
  CONSTRAINT pk_tfinalidad__id_finalidad PRIMARY KEY(id_finalidad)
) INHERITS (pxp.tbase)

WITH (oids = false);


COMMENT ON COLUMN tes.tfinalidad.tipo
IS 'ingreso o egreso';
/***********************************F-SCP-GSS-TES-0-27/10/2014***************************************/

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
  id_int_comprobante INTEGER,
  nro_deposito BIGINT NULL,
  fondo_devolucion_retencion VARCHAR(2),
  columna_pk VARCHAR(100),
  columna_pk_valor INTEGER,
  tabla VARCHAR(255),
  id_proveedor INTEGER,
  correo VARCHAR(100),
  tabla_correo VARCHAR(200),
  columna_correo VARCHAR(100),
  id_columna_correo INTEGER,
  CONSTRAINT tts_libro_bancos_pkey PRIMARY KEY(id_libro_bancos),
  CONSTRAINT tts_libro_bancos_nro_deposito_key UNIQUE (nro_deposito)
) INHERITS (pxp.tbase)
WITH (oids = false);
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

/*****************************F-SCP-RAC-TES-0-12/06/2015*************/


/*****************************I-SCP-JRR-TES-0-10/08/2015*************/

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
  id_solicitud_efectivo_fk INTEGER,
  id_funcionario_jefe_aprobador INTEGER,
  id_gestion INTEGER,
  fecha_entrega DATE,
  ingreso_extra VARCHAR(4) DEFAULT 'no' NOT NULL,
  id_tipo_solicitud INTEGER,
  id_proceso_caja_repo INTEGER,
  id_funcionario_finanzas INTEGER,
  observaciones VARCHAR(1000),
  id_proceso_caja_rend INTEGER,
  ingreso_cd VARCHAR(4) DEFAULT 'no'::character varying NOT NULL,
  fecha_ult_mov DATE,
  fecha_entregado_ult DATE,
  fecha_mod_bk DATE,
  CONSTRAINT pk_tsolicitud_efectivo__id_solicitud_efectivo PRIMARY KEY(id_solicitud_efectivo)
) INHERITS (pxp.tbase)
WITHOUT OIDS;
COMMENT ON COLUMN tes.tsolicitud_efectivo.id_funcionario_jefe_aprobador
IS 'id del jefe que aprobo la solicitud de efectivo del solicitante';

COMMENT ON COLUMN tes.tsolicitud_efectivo.fecha_entrega
IS 'fecha de entrega del efectivo';

COMMENT ON COLUMN tes.tsolicitud_efectivo.ingreso_extra
IS 'indica si es un ingreso extraa la reposicion de caja, sollo valido para solicitudes de  tipo INGEFE,  cuando el valor es si, significa que viene deviaticos o cuenta docuemntada, o por ajuste';

COMMENT ON COLUMN tes.tsolicitud_efectivo.id_proceso_caja_repo
IS 'Indica el id_proceso_caja de tipo reposicion donde fue considerado el ingreso_extra = si, para solicitudes de  tipo INGEFE';

COMMENT ON COLUMN tes.tsolicitud_efectivo.id_funcionario_finanzas
IS 'id del funcionario de finanzas';

COMMENT ON COLUMN tes.tsolicitud_efectivo.id_proceso_caja_repo
IS 'Indica el id_proceso_caja de tipo reposicion donde fue considerado el ingreso_extra = si,';

COMMENT ON COLUMN tes.tsolicitud_efectivo.id_proceso_caja_rend
IS 'SOLO para ingresos identifica el proceso de caja donde se incluye la rendicion del ingreso de efectivo';

COMMENT ON COLUMN tes.tsolicitud_efectivo.ingreso_cd
IS 'Para marcar las solicitudes de Ingreso generadas desde sistema de cuenta documentada';

COMMENT ON COLUMN tes.tsolicitud_efectivo.fecha_ult_mov
IS 'fecha de ultimo omivimeitno se carga a travez de un triguer las pasar por ciertos estados';

COMMENT ON COLUMN tes.tsolicitud_efectivo.fecha_entregado_ult
IS 'fecha de ultimo entregado';

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
  id_int_comprobante INTEGER,
  id_proceso_wf INTEGER NOT NULL,
  id_estado_wf INTEGER NOT NULL,
  id_caja INTEGER NOT NULL, 
  estado VARCHAR(50) NOT NULL, 
  motivo TEXT NOT NULL,
  nro_tramite VARCHAR(50) NOT NULL, 
  fecha DATE NOT NULL,
  monto_reposicion NUMERIC(18,2), 
  tipo VARCHAR(50) NOT NULL, 
  fecha_inicio DATE,
  fecha_fin DATE,
  id_depto_conta INTEGER,
  id_gestion INTEGER,
  id_tipo_proceso_caja INTEGER,
  id_proceso_caja_fk INTEGER,
  id_solicitud_efectivo_rel INTEGER,
  id_proceso_caja_repo INTEGER,
  id_cuenta_bancaria INTEGER,
  id_cuenta_bancaria_mov INTEGER,
  num_memo VARCHAR,
  monto NUMERIC(18,2),
  monto_ren_ingreso NUMERIC DEFAULT 0 NOT NULL,
  CONSTRAINT pk_tproceso_caja__id_proceso_caja PRIMARY KEY(id_proceso_caja)
) INHERITS (pxp.tbase)
WITHOUT OIDS;
  
  COMMENT ON COLUMN tes.tproceso_caja.id_depto_conta
IS 'hace referencia donde  se contabiliza el proceso';

COMMENT ON COLUMN tes.tproceso_caja.id_gestion
IS 'gestion del proceso';

COMMENT ON COLUMN tes.tproceso_caja.id_tipo_proceso_caja
IS 'hace referencia al tipo de proceso de caja';

COMMENT ON COLUMN tes.tproceso_caja.id_proceso_caja_fk
IS 'hace referencia al proceso de caja origen';

COMMENT ON COLUMN tes.tproceso_caja.id_solicitud_efectivo_rel
IS 'en lso procesos de  apertura, reposición o cierre se inserta un registro en solicitud efectivo para facilitar el arqueo de caja';

COMMENT ON COLUMN tes.tproceso_caja.id_proceso_caja_repo
IS 'id del proceso de caja que identifica el proceso con el que se repone la rendiciones sueltas';

COMMENT ON COLUMN tes.tproceso_caja.monto_ren_ingreso
IS 'monto acumulado de recibo de ingreso a caja que deben ser contabilizados, hecho para rendiciones de fondos o viaticos';
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



/*****************************F-SCP-GSS-TES-0-05/05/2016*************/


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

/*************************F-SCP-RAC-TES-0-25/01/2018*************/


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





/*************************F-SCP-RAC-TES-0-01/12/2018*************/

