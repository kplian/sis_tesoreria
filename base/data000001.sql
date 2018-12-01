/***********************************I-DAT-GSS-TES-45-02/04/2013*****************************************/

/*
*	Author: Gonzalo Sarmiento Sejas GSS
*	Date: 02/04/2013
*	Description: Build the menu definition and the composition
*/
/*

Para  definir la la metadata, menus, roles, etc

1) sincronize ls funciones y procedimientos del sistema
2)  verifique que la primera linea de los datos sea la insercion del sistema correspondiente
3)  exporte los datos a archivo SQL (desde la interface de sistema en sis_seguridad), 
    verifique que la codificacion  se mantenga en UTF8 para no distorcionar los caracteres especiales
4)  remplaze los sectores correspondientes en este archivo en su totalidad:  (el orden es importante)  
                             menu, 
                             funciones, 
                             procedimietnos
*/

INSERT INTO segu.tsubsistema ( codigo, nombre, prefijo, estado_reg, nombre_carpeta, id_subsis_orig)
VALUES ('TES', 'Sistema de Tesoreria', 'TES', 'activo', 'tesoreria', NULL);

-------------------------------------
--DEFINICION DE INTERFACES
-----------------------------------

select pxp.f_insert_tgui ('SISTEMA DE TESORERIA', '', 'TES', 'si', 6, '', 1, '', '', 'TES');
select pxp.f_insert_tgui ('Obligacion Pago', 'Obligaciones de pago', 'OBPG', 'si', 1, 'sis_tesoreria/vista/obligacion_pago/ObligacionPagoTes.php', 2, '', 'ObligacionPagoTes', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'OBPG.1', 'no', 0, 'sis_tesoreria/vista/obligacion_det/ObligacionDet.php', 3, '', '50%', 'TES');

select pxp.f_insert_testructura_gui ('TES', 'SISTEMA');
select pxp.f_insert_testructura_gui ('OBPG', 'TES');
select pxp.f_insert_testructura_gui ('OBPG.1', 'OBPG');


-----------------------------
-- DOCUMENTOS
---------------------------------


--inserta documentos de adquisiciones

SELECT * FROM param.f_inserta_documento('TES', 'PGD', 'Pago Directo', 'periodo', NULL, 'depto', NULL);
SELECT * FROM param.f_inserta_documento('TES', 'SPG', 'Solicitud de Pago', 'periodo', NULL, 'depto', NULL);


/***********************************F-DAT-GSS-TES-45-02/04/2013*******************************************************/


/********************************************I-DAT-GSS-TES-14-12/04/2013**********************************************/

----------------------------------
--COPY LINES TO data.sql FILE  
---------------------------------

select wf.f_insert_tproceso_macro ('TES-PD', 'Pago Directo', 'si', 'activo', 'Sistema de Tesoreria');
select wf.f_insert_ttipo_proceso ('', 'Obligacion de Pago', 'TOPD', 'tes.tobligacion_pago', 'id_obligacion_pago', 'activo', 'si', 'TES-PD');
select wf.f_insert_ttipo_proceso ('En pago', 'Tesoreria Plan Pago, Devengado', 'TPLAP', '', '', 'activo', 'no', 'TES-PD');
select wf.f_insert_ttipo_proceso ('devengado', 'Tesoreria Plan Pago, Pagado', 'TPLPP', '', '', 'activo', '', 'TES-PD');
select wf.f_insert_ttipo_estado ('en_pago', 'En pago', 'no', 'si', 'no', 'anterior', '', 'anterior', '', '', 'activo', 'TOPD', 'TPLAP');
select wf.f_insert_ttipo_estado ('borrador', 'Borrador', 'si', 'no', 'no', 'anterior', '', 'anterior', '', '', 'activo', 'TOPD', '');
select wf.f_insert_ttipo_estado ('registrado', 'Registrado', 'no', 'si', 'no', 'anterior', '', 'anterior', '', '', 'activo', 'TOPD', '');
select wf.f_insert_ttipo_estado ('finalizado', 'Finalizado', 'no', 'no', 'si', 'anterior', '', 'anterior', '', '', 'activo', 'TOPD', '');
select wf.f_insert_ttipo_estado ('anulado', 'Anulado', 'no', 'no', 'si', 'anterior', '', 'anterior', '', '', 'activo', 'TOPD', '');
select wf.f_insert_ttipo_estado ('borrador', 'borrador', 'si', 'no', 'no', 'anterior', '', 'anterior', '', '', 'activo', 'TPLAP', '');
select wf.f_insert_ttipo_estado ('pendiente', 'pendiente', 'no', 'no', 'no', 'anterior', '', 'anterior', '', '', 'activo', 'TPLAP', '');
select wf.f_insert_ttipo_estado ('devengado', 'devengado', 'no', 'si', 'si', 'anterior', '', 'anterior', '', '', 'activo', 'TPLAP', 'TPLPP');
select wf.f_insert_ttipo_estado ('anulado', 'Anulado', 'no', 'no', 'si', 'anterior', '', 'anterior', '', '', 'activo', 'TPLAP', '');
select wf.f_insert_ttipo_estado ('borrador', 'Borrador', 'si', 'no', 'no', 'anterior', '', 'anterior', '', '', 'activo', 'TPLPP', '');
select wf.f_insert_ttipo_estado ('pendiente', 'Pendiente', 'no', 'no', 'no', 'anterior', '', 'anterior', '', '', 'activo', 'TPLPP', '');
select wf.f_insert_ttipo_estado ('pagado', 'Pagado', 'no', 'no', 'si', 'anterior', '', 'anterior', '', '', 'activo', 'TPLPP', '');
select wf.f_insert_ttipo_estado ('anulado', 'Anulado', 'no', 'no', 'si', 'anterior', '', 'anterior', '', '', 'activo', 'TPLPP', '');
select wf.f_insert_testructura_estado ('borrador', 'TOPD', 'registrado', 'TOPD', '1', '', 'activo');
select wf.f_insert_testructura_estado ('registrado', 'TOPD', 'en_pago', 'TOPD', '1', '', 'activo');
select wf.f_insert_testructura_estado ('en_pago', 'TOPD', 'finalizado', 'TOPD', '1', '', 'activo');
select wf.f_insert_testructura_estado ('borrador', 'TPLAP', 'pendiente', 'TPLAP', '1', '', 'activo');
select wf.f_insert_testructura_estado ('pendiente', 'TPLAP', 'devengado', 'TPLAP', '1', '', 'activo');
select wf.f_insert_testructura_estado ('borrador', 'TPLPP', 'pendiente', 'TPLPP', '1', '', 'activo');
select wf.f_insert_testructura_estado ('pendiente', 'TPLPP', 'pagado', 'TPLPP', '1', '', 'activo');

/********************************************F-DAT-GSS-TES-14-12/04/2013**********************************************/


/***********************************I-DAT-GSS-TES-101-22/04/2013*****************************************/


/***********************************F-DAT-GSS-TES-101-22/04/2013*****************************************/

/***********************************I-DAT-GSS-TES-121-24/04/2013*****************************************/

select pxp.f_insert_tgui ('Cuenta Bancaria', 'cuentas bancarias de la empresa', 'CTABAN', 'si', 2, 'sis_tesoreria/vista/cuenta_bancaria/CuentaBancaria.php', 2, '', 'CuentaBancaria', 'TES');
select pxp.f_insert_testructura_gui ('CTABAN', 'TES');

/***********************************F-DAT-GSS-TES-121-24/04/2013*****************************************/

/***********************************I-DAT-ECR-TES-0-16/12/2013*****************************************/
select pxp.f_insert_tgui ('Caja', 'Caja', 'CAJA', 'si', 1, 'sis_tesoreria/vista/caja/Caja.php', 2, '', 'Caja', 'TES');
select pxp.f_insert_testructura_gui ('CAJA', 'TES');
/***********************************F-DAT-ECR-TES-0-16/12/2013*****************************************/

/***********************************I-DAT-RCM-TES-0-24/12/2013*****************************************/

select pxp.f_insert_tgui ('Cuenta Bancaria ENDESIS', 'cuentas bancarias de la empresa', 'CTABANE', 'si', 2, 'sis_tesoreria/vista/cuenta_bancaria/CuentaBancariaESIS.php', 2, '', 'CuentaBancariaESIS', 'TES');
select pxp.f_insert_testructura_gui ('CTABANE', 'TES');

/***********************************F-DAT-RCM-TES-0-24/12/2013*****************************************/


/***********************************I-RAC-RCM-TES-0-03/02/2014*****************************************/
;


/***********************************F-RAC-RCM-TES-0-03/02/2014*****************************************/

/***********************************I-DAT-JRR-TES-0-24/04/2014*****************************************/

/***********************************F-DAT-JRR-TES-0-24/04/2014*****************************************/




/***********************************I-DAT-JRR-TES-0-12/05/2014*****************************************/





/***********************************F-DAT-JRR-TES-0-12/05/2014*****************************************/


/***********************************I-DAT-RAC-TES-0-17/07/2014*****************************************/

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'politica_porcentaje_anticipo', E'0.5', E'politica de anticipo parciales, no puede ser mayor al 50%del total a pagar');

/***********************************F-DAT-RAC-TES-0-17/07/2014*****************************************/




/***********************************I-DAT-RAC-TES-0-29/07/2014*****************************************/
INSERT INTO tes.ttipo_plan_pago ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "codigo", "descripcion", "codigo_proceso_llave_wf", "codigo_plantilla_comprobante")
VALUES (1, 1, E'2014-07-15 09:32:41.069', E'2014-07-15 11:09:41.378', E'activo', NULL, E'NULL', E'pagado', E'Solo pagado, previo devengado', E'TPLPP', E'PAGTESPROV');

INSERT INTO tes.ttipo_plan_pago ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "codigo", "descripcion", "codigo_proceso_llave_wf", "codigo_plantilla_comprobante")
VALUES (1, 1, E'2014-07-15 09:30:50.178', E'2014-07-15 11:09:54.761', E'activo', NULL, E'NULL', E'devengado_pagado', E'Devngado y pagado con dos comprobantes', E'TPLAP', E'DEVTESPROV');

INSERT INTO tes.ttipo_plan_pago ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "codigo", "descripcion", "codigo_proceso_llave_wf", "codigo_plantilla_comprobante")
VALUES (1, 1, E'2014-07-15 09:32:02.788', E'2014-07-15 11:10:43.140', E'activo', NULL, E'NULL', E'devengado', E'Solo devengado', E'TPLAP', E'DEVTESPROV');

INSERT INTO tes.ttipo_plan_pago ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "codigo", "descripcion", "codigo_proceso_llave_wf", "codigo_plantilla_comprobante")
VALUES (1, 1, E'2014-07-15 10:06:28.057', E'2014-07-16 16:35:14.024', E'activo', NULL, E'NULL', E'devengado_pagado_1c', E'Devengar y pagar con un solo comprobante', E'TPLAP', E'DEVPAGTESPROV');

INSERT INTO tes.ttipo_plan_pago ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "codigo", "descripcion", "codigo_proceso_llave_wf", "codigo_plantilla_comprobante")
VALUES (1, 1, E'2014-07-17 17:38:26.901', E'2014-07-18 14:48:50.915', E'activo', NULL, E'NULL', E'ant_parcial', E'Anticipo parcial', E'PD_ANT_PAR', E'ANTICIPOPARCIAL');

INSERT INTO tes.ttipo_plan_pago ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "codigo", "descripcion", "codigo_proceso_llave_wf", "codigo_plantilla_comprobante")
VALUES (1, 1, E'2014-07-21 12:15:33.648', E'2014-07-21 15:16:26.797', E'activo', NULL, E'NULL', E'anticipo', E'Anticipo contra factura o recibo', E'PD_ANT_PAR', E'ANTICIPOTOTAL');

INSERT INTO tes.ttipo_plan_pago ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "codigo", "descripcion", "codigo_proceso_llave_wf", "codigo_plantilla_comprobante")
VALUES (1, 1, E'2014-07-22 10:41:13.580', E'2014-07-22 15:41:28.227', E'activo', NULL, E'NULL', E'ant_aplicado', E'Aplicaciond e anticipo', E'PD_AP_ANT', E'APLIC_ANTI');

INSERT INTO tes.ttipo_plan_pago ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "codigo", "descripcion", "codigo_proceso_llave_wf", "codigo_plantilla_comprobante")
VALUES (1, 1, E'2014-07-23 12:23:47.391', E'2014-07-23 14:54:16.327', E'activo', NULL, E'NULL', E'dev_garantia', E'Devolucion de garantia', E'PD_ANT_PAR', E'DEVOLGAR');
/***********************************F-DAT-RAC-TES-0-29/07/2014*****************************************/



/***********************************I-DAT-RAC-TES-0-19/02/2015*****************************************/


SELECT * FROM param.f_inserta_documento('TES', 'PU', 'Pago Único', 'periodo', NULL, 'depto', NULL);

/***********************************F-DAT-RAC-TES-0-19/02/2015*****************************************/




/***********************************I-DAT-RAC-TES-0-22/07/2015*****************************************/

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'tes_prioridad_lb_internacional', E'3', E'configura la prioridad para reconocer la prioridad delibro de bancos internacional\r\n');


/***********************************F-DAT-RAC-TES-0-22/07/2015*****************************************/





/***********************************I-DAT-RAC-TES-0-08/09/2015*****************************************/

/* Data for the 'pxp.variable_global' table  (Records 1 - 6) */

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'tes_tipo_documento_especial', E'PE', E'codigo de documento para pagos especial');

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'tes_codigo_macro_especial', E'TES-PD', E'codigo de proceso macro en WF para pagos especiales');

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'tes_tipo_documento_pago_unico', E'PU', E'codigo de documento para pagos unicos');

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'tes_codigo_macro_pago_unico', E'PU', E'codigo de proceso macro en WF para pagos unicos\r\ncodigo de proceso macro en WF para pagos unicos');

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'tes_tipo_documento_pago_directo', E'PGD', E'codigo de documento para pagos directos');

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'tes_codigo_macro_pago_directo', E'TES-PD', E'codigo de proceso macro en WF para pagos directos');


/***********************************F-DAT-RAC-TES-0-08/09/2015*****************************************/

/***********************************I-DAT-RAC-TES-0-23/11/2015*****************************************/


/* Data for the 'pxp.variable_global' table  (Records 1 - 1) */

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'tes_tipo_pago_deshabilitado', E'', E'codigo de los tipos de pago deshabilitados para la estacion');


/***********************************F-DAT-RAC-TES-0-23/11/2015*****************************************/


/***********************************I-DAT-GSS-TES-0-29/01/2016*****************************************/

SELECT * FROM param.f_inserta_documento('TES', 'CAJA', 'Caja Chica', 'gestion', NULL, 'depto', NULL);
SELECT * FROM param.f_inserta_documento('TES', 'SEFE', 'Solicitud Efectivo', 'gestion', NULL, 'tabla', 'codtabla-coddoc-correlativo-gestion');
SELECT * FROM param.f_inserta_documento('TES', 'REN', 'Rendicion', 'gestion', NULL, 'tabla', 'codtabla-coddoc-correlativo-gestion');

/***********************************F-DAT-GSS-TES-0-29/01/2016*****************************************/



/***********************************I-DAT-RAC-TES-0-4/5/2016*****************************************/



/* Data for the 'pxp.variable_global' table  (Records 1 - 1) */

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES 
  (E'pre_verificar_categoria', E'no', E'verificar presupuestaria por categoria, (por defecto no, es verificacion solo presupeusto)');



/***********************************F-DAT-RAC-TES-0-4/5/2016*****************************************/

/***********************************I-DAT-GSS-TES-0-22/06/2016*****************************************/

----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE  
---------------------------------

select wf.f_import_tproceso_macro ('insert','TES-CAJA', 'TES', 'Caja','si');
select wf.f_import_tcategoria_documento ('insert','legales', 'Legales');
select wf.f_import_tcategoria_documento ('insert','proceso', 'Proceso');
select wf.f_import_ttipo_proceso ('insert','CRE',NULL,NULL,'TES-CAJA','Creacion de Caja','tes.tproceso_caja','id_proceso_caja','si','','','','CRE',NULL);
select wf.f_import_ttipo_proceso ('delete','RENP',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
select wf.f_import_ttipo_proceso ('delete','RENR',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
select wf.f_import_ttipo_estado ('insert','borrador','CRE','Borrador','si','no','no','ninguno','','ninguno','','','si','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','solicitado','CRE','Solicitado','no','no','no','listado','','anterior','','','si','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','aprobado','CRE','Aprobado','no','si','si','ninguno','','ninguno','','','si','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('delete','borrador','RENP',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
select wf.f_import_ttipo_estado ('delete','revision','RENP',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
select wf.f_import_ttipo_estado ('delete','rendido','RENP',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
select wf.f_import_ttipo_estado ('delete','borrador','RENR',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
select wf.f_import_ttipo_estado ('delete','revision','RENR',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
select wf.f_import_ttipo_estado ('delete','repuesto','RENR',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
select wf.f_import_ttipo_estado ('insert','rechazado','CRE','Rechazado','no','no','si','ninguno','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','obligaciones','CRE','Obligaciones','no','si','no','ninguno','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','anulado','CRE','Anulado','no','no','si','anterior','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('delete','pendiente','RENR',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
select wf.f_import_ttipo_estado ('delete','rendido','RENR',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
select wf.f_import_ttipo_estado ('delete','cbte_respo','RENR',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
select wf.f_import_ttipo_estado ('delete','pendiente_repo','RENR',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
select wf.f_import_ttipo_estado ('delete','contabilizado','RENR',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
select wf.f_import_testructura_estado ('delete','borrador','solicitado','CRE',NULL,NULL);
select wf.f_import_testructura_estado ('delete','borrador','revision','RENP',NULL,NULL);
select wf.f_import_testructura_estado ('delete','revision','rendido','RENP',NULL,NULL);
select wf.f_import_testructura_estado ('delete','borrador','revision','RENR',NULL,NULL);
select wf.f_import_testructura_estado ('delete','revision','repuesto','RENR',NULL,NULL);
select wf.f_import_testructura_estado ('insert','aprobado','rechazado','CRE',1,'');
select wf.f_import_testructura_estado ('delete','solicitado','obligaciones','CRE',NULL,NULL);
select wf.f_import_testructura_estado ('insert','obligaciones','aprobado','CRE',1,'');
select wf.f_import_testructura_estado ('delete','borrador','rechazado','CRE',NULL,NULL);
select wf.f_import_testructura_estado ('delete','borrador','aprobado','CRE',NULL,NULL);
select wf.f_import_testructura_estado ('insert','borrador','solicitado','CRE',1,'');
select wf.f_import_testructura_estado ('insert','solicitado','aprobado','CRE',1,'');
select wf.f_import_testructura_estado ('insert','solicitado','rechazado','CRE',1,'');
select wf.f_import_testructura_estado ('delete','revision','pendiente','RENR',NULL,NULL);
select wf.f_import_testructura_estado ('delete','pendiente','rendido','RENR',NULL,NULL);
select wf.f_import_testructura_estado ('delete','rendido','pendiente_repo','RENR',NULL,NULL);
select wf.f_import_testructura_estado ('delete','pendiente_repo','contabilizado','RENR',NULL,NULL);
select wf.f_import_tfuncionario_tipo_estado ('insert','solicitado','CRE','3027798',NULL,'');

----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE  
---------------------------------

select wf.f_import_tproceso_macro ('insert','TES-REND', 'TES', 'Proceso Caja','si');
select wf.f_import_tcategoria_documento ('insert','legales', 'Legales');
select wf.f_import_tcategoria_documento ('insert','proceso', 'Proceso');
select wf.f_import_ttipo_proceso ('insert','REN',NULL,NULL,'TES-REND','Rendicion','tes.tproceso_caja','id_proceso_caja','si','','null','','REN',NULL);
select wf.f_import_ttipo_proceso ('insert','CIERRE','rendido','REN','TES-REND','Cierre de Caja','','','no','','opcional','','CIERRE',NULL);
select wf.f_import_ttipo_proceso ('insert','REPO','rendido','REN','TES-REND','Reposición de Caja','tes.tproceso_caja','id_proceso_caja','no','','opcional','','REPO',NULL);
select wf.f_import_ttipo_estado ('insert','borrador','REN','Borrador','si','no','no','ninguno','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','vbconta','REN','VoBo Conta','no','no','no','segun_depto','','anterior','','','si','si',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','rendido','REN','Rendido','no','si','si','ninguno','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','pendiente','REN','Pendiente','no','si','no','ninguno','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','borrador','CIERRE','Borrador','si','no','no','anterior','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','pendiente','CIERRE','Pendiente','no','no','no','anterior','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','cerrado','CIERRE','Cerrado','no','no','si','anterior','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','borrador','REPO','Borrador','si','no','no','anterior','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','vbconta','REPO','VoBo contabilidad','no','no','no','segun_depto','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','pendiente','REPO','Pendiente','no','si','no','anterior','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','contabilizado','REPO','Contabilizado','no','si','si','anterior','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','supconta','REN','Sup Contabilidad','no','no','no','ninguno','','depto_func_list','tes.f_lista_depto_conta_x_op_wf_sel','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','supconta','REPO','Sup Contabilidad','no','no','no','ninguno','','depto_func_list','tes.f_lista_depto_conta_x_op_wf_sel','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','vbconta','CIERRE','VoBo contabilidad','no','no','no','listado','','anterior','','','no','si',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('delete','supconta','REN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
select wf.f_import_ttipo_estado ('insert','supconta','CIERRE','Sup Contabilidad','no','no','no','ninguno','','depto_listado','tes.f_lista_depto_conta_x_op_wf_sel','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('delete','vbfondos','REN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
select wf.f_import_ttipo_estado ('insert','vbfondos','REPO','VoBo Asignacion Fondos','no','no','no','listado','','depto_func_list','tes.f_lista_depto_conta_x_op_wf_sel','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','vbpresup','REN','VoBo Presupuestos','no','no','no','listado','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_testructura_estado ('delete','borrador','vbconta','REN',NULL,NULL);
select wf.f_import_testructura_estado ('delete','vbconta','rendido','REN',NULL,NULL);
select wf.f_import_testructura_estado ('insert','vbconta','pendiente','REN',1,'');
select wf.f_import_testructura_estado ('insert','pendiente','rendido','REN',1,'');
select wf.f_import_testructura_estado ('delete','borrador','pendiente','CIERRE',NULL,NULL);
select wf.f_import_testructura_estado ('insert','pendiente','cerrado','CIERRE',1,'');
select wf.f_import_testructura_estado ('delete','borrador','vbconta','REPO',NULL,NULL);
select wf.f_import_testructura_estado ('insert','vbconta','pendiente','REPO',1,'');
select wf.f_import_testructura_estado ('insert','pendiente','contabilizado','REPO',1,'');
select wf.f_import_testructura_estado ('delete','borrador','supconta','REN',NULL,NULL);
select wf.f_import_testructura_estado ('insert','supconta','vbconta','REN',1,'');
select wf.f_import_testructura_estado ('insert','borrador','supconta','REPO',1,'tes.f_regla_tiene_fecha_inicio');
select wf.f_import_testructura_estado ('insert','supconta','vbconta','REPO',1,'');
select wf.f_import_testructura_estado ('insert','borrador','supconta','CIERRE',1,'');
select wf.f_import_testructura_estado ('insert','supconta','vbconta','CIERRE',1,'');
select wf.f_import_testructura_estado ('insert','vbconta','pendiente','CIERRE',1,'');
select wf.f_import_testructura_estado ('delete','vbfondos','pendiente','REN',NULL,NULL);
select wf.f_import_testructura_estado ('delete','borrador','vbfondos','REN',NULL,NULL);
select wf.f_import_testructura_estado ('insert','borrador','vbfondos','REPO',1,'NOT! tes.f_regla_tiene_fecha_inicio');
select wf.f_import_testructura_estado ('insert','vbfondos','pendiente','REPO',1,'');
select wf.f_import_testructura_estado ('insert','borrador','vbpresup','REN',1,'');
select wf.f_import_testructura_estado ('insert','vbpresup','supconta','REN',1,'');
select wf.f_import_tfuncionario_tipo_estado ('insert','vbfondos','REPO','3805559',NULL,'');
select wf.f_import_tfuncionario_tipo_estado ('insert','vbpresup','REN','5150185',NULL,'');

----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE  
---------------------------------

select wf.f_import_tproceso_macro ('insert','FR', 'TES', 'Fondo Rotativo','si');
select wf.f_import_tcategoria_documento ('insert','legales', 'Legales');
select wf.f_import_tcategoria_documento ('insert','proceso', 'Proceso');
select wf.f_import_ttipo_proceso ('insert','SOLEFE',NULL,NULL,'FR','Solicitud de Efectivo','tes.tsolicitud_efectivo','id_solicitud_efectivo','si','','','','SOLICITUD EFECTIVO',NULL);
select wf.f_import_ttipo_proceso ('insert','EFEREND',NULL,NULL,'FR','Rendicion Efectivo','tes.vsolicitud_efectivo','id_solicitud_efectivo','no','','opcional','','RENDICION EFECTIVO',NULL);
select wf.f_import_ttipo_proceso ('insert','DEVEFE',NULL,NULL,'FR','Devolucion Efectivo','','','no','','opcional','','DEVOLUCION EFECTIVO',NULL);
select wf.f_import_ttipo_proceso ('insert','REPEFE',NULL,NULL,'FR','Reposicion Efectivo','','','no','','opcional','','REPOSICION EFECTIVO',NULL);
select wf.f_import_ttipo_proceso ('insert','INGEFE',NULL,NULL,'FR','Ingreso Efectivo','','','no','','','','INGRESO EFECTIVO',NULL);
select wf.f_import_ttipo_proceso ('insert','SALEFE',NULL,NULL,'FR','Salida Efectivo','','','no','','','','SALIDA EFECTIVO',NULL);
select wf.f_import_ttipo_proceso ('insert','APECAJ',NULL,NULL,'FR','Apertura Caja','','','no','','','','APERTURA CAJA',NULL);
select wf.f_import_ttipo_estado ('insert','borrador','SOLEFE','Borrador','si','no','no','ninguno','','ninguno','','','si','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','vbcajero','SOLEFE','VoboCajero','no','no','no','funcion_listado','tes.f_lista_funcionario_cajero_caja_chica_wf_sel','ninguno','','','si','si',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','entregado','SOLEFE','Entregado','no','si','no','ninguno','','ninguno','','','si','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','anulado','SOLEFE','Anulado','no','no','si','anterior','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','borrador','EFEREND','Borrador','si','no','no','ninguno','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','revision','EFEREND','Revision','no','no','no','anterior','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('delete','devolucion','EFEREND',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
select wf.f_import_ttipo_estado ('delete','reposicion','EFEREND',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
select wf.f_import_ttipo_estado ('insert','rendido','EFEREND','Rendido','no','no','si','ninguno','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('delete','borrador','DEVEFE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
select wf.f_import_ttipo_estado ('delete','vbcajero','DEVEFE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
select wf.f_import_ttipo_estado ('insert','devuelto','DEVEFE','Devuelto','si','no','si','ninguno','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('delete','borrador','REPEFE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
select wf.f_import_ttipo_estado ('delete','vbcajero','REPEFE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
select wf.f_import_ttipo_estado ('insert','repuesto','REPEFE','Repuesto','si','no','si','ninguno','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','anulado','EFEREND','Anulado','no','no','si','anterior','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','finalizado','SOLEFE','Finalizado','no','si','si','ninguno','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','ingresado','INGEFE','Ingresado','si','no','si','ninguno','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','salida','SALEFE','Salida','si','no','si','ninguno','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','aperturado','APECAJ','Aperturado','si','no','si','ninguno','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Nuevo tramite {NUM_TRAMITE} en estado "{ESTADO_ACTUAL}"','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','vbjefe','SOLEFE','VoBo Jefe Superior','no','no','no','funcion_listado','tes.f_lista_funcionario_jefe_superior_wf_sel','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','vbjefedevsol','EFEREND','Visto Bueno Jefe Devolucion Solicitante','no','no','no','funcion_listado','tes.f_lista_funcionario_jefe_efectivo_wf_sel','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_documento ('delete','MEMOCAJA','SOLEFE',NULL,NULL,NULL,NULL,NULL,NULL);
select wf.f_import_ttipo_documento ('insert','SOLEFE','SOLEFE','Solicitud de Efectivo','Solicitud de Efectivo','sis_tesoreria/control/SolicitudEfectivo/reporteSolicitudEfectivo','generado',1.00,'{proceso}');
select wf.f_import_ttipo_documento ('insert','ENTEFE','SOLEFE','Recibo Entrega Efectivo','Recibo Entrega Efectivo','sis_tesoreria/control/SolicitudEfectivo/reporteReciboEntrega','generado',1.00,'{proceso}');
select wf.f_import_ttipo_documento ('delete','RENEFE','EFEREND',NULL,NULL,NULL,NULL,NULL,NULL);
select wf.f_import_ttipo_documento ('insert','RENEFE','SOLEFE','Reporte Rendicion de Efectivo','Reporte Rendicion de Efectivo','sis_tesoreria/control/SolicitudEfectivo/reporteRendicionEfectivo','generado',1.00,'{proceso}');
select wf.f_import_testructura_estado ('delete','borrador','vbcajero','SOLEFE',NULL,NULL);
select wf.f_import_testructura_estado ('insert','vbcajero','entregado','SOLEFE',1,'');
select wf.f_import_testructura_estado ('insert','borrador','revision','EFEREND',1,'');
select wf.f_import_testructura_estado ('delete','revision','devolucion','EFEREND',NULL,NULL);
select wf.f_import_testructura_estado ('delete','revision','reposicion','EFEREND',NULL,NULL);
select wf.f_import_testructura_estado ('insert','revision','rendido','EFEREND',1,'');
select wf.f_import_testructura_estado ('delete','devolucion','rendido','EFEREND',NULL,NULL);
select wf.f_import_testructura_estado ('delete','reposicion','rendido','EFEREND',NULL,NULL);
select wf.f_import_testructura_estado ('delete','borrador','vbcajero','DEVEFE',NULL,NULL);
select wf.f_import_testructura_estado ('delete','vbcajero','devuelto','DEVEFE',NULL,NULL);
select wf.f_import_testructura_estado ('delete','borrador','vbcajero','REPEFE',NULL,NULL);
select wf.f_import_testructura_estado ('delete','vbcajero','repuesto','REPEFE',NULL,NULL);
select wf.f_import_testructura_estado ('insert','entregado','finalizado','SOLEFE',1,'');
select wf.f_import_testructura_estado ('insert','vbjefe','vbcajero','SOLEFE',1,'');
select wf.f_import_testructura_estado ('insert','borrador','vbjefe','SOLEFE',1,'');
select wf.f_import_testructura_estado ('insert','vbjefedevsol','rendido','EFEREND',1,'');
select wf.f_import_testructura_estado ('insert','revision','vbjefedevsol','EFEREND',1,'');


select wf.f_import_ttipo_documento_estado ('delete','ENTEFE','SOLEFE','borrador','SOLEFE',NULL,NULL,NULL);
select wf.f_import_ttipo_documento_estado ('insert','ENTEFE','SOLEFE','entregado','SOLEFE','crear','superior','');
select wf.f_import_ttipo_documento_estado ('insert','SOLEFE','SOLEFE','borrador','SOLEFE','crear','superior','');





/***********************************F-DAT-GSS-TES-0-22/06/2016*****************************************/

/***********************************I-DAT-GSS-TES-0-30/06/2016*****************************************/

select param.f_import_tdocumento ('insert','REP','Reposicion Caja','TES','tabla','gestion','','codtabla-coddoc-correlativo-gestion');
select param.f_import_tdocumento ('insert','REN','Rendicion Caja','TES','tabla','gestion','','codtabla-coddoc-correlativo-gestion');
select param.f_import_tdocumento ('insert','CIER','Cierre Caja','TES','tabla','gestion','','codtabla-coddoc-correlativo-gestion');
select param.f_import_tdocumento ('insert','MEMO','Memorandum de Asginacion de Fondos','TES','depto','gestion','','OB.AA.depto.ME correlativo.gestion');
select param.f_import_tdocumento ('insert','SOLEFE','Solicitud Efectivo','TES','tabla','gestion',NULL,'codtabla-coddoc-correlativo-gestion');

/***********************************F-DAT-GSS-TES-0-30/06/2016*****************************************/


/***********************************I-DAT-RAC-TES-0-20/02/2017*****************************************/

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES 
  (E'tes_integrar_lb_pagado', E'no', E'por defecto no, al validar un pago inserta un cheque, si o no');
 
  
 /***********************************F-DAT-RAC-TES-0-20/02/2017*****************************************/
  


/***********************************I-DAT-RAC-TES-0-17/08/2017*****************************************/
  
INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES 
  (E'tes_gen_cheque_depto_conta_lb_pri_cero', E'no', E'si o no, generar cheque cuando libro de bancos y ldepto de conta tengan prioridad cero');
  

/***********************************F-DAT-RAC-TES-0-17/08/2017*****************************************/
  


/***********************************I-DAT-RAC-TES-31-07/11/2017*****************************************/
  

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES 
  (E'tes_anticipo_ejecuta_pres', E'no', E'si o no, anticipos ejecutan presupeusto, mismo sin ejecucion contable');


/***********************************F-DAT-RAC-TES-31-07/11/2017*****************************************/



/***********************************I-DAT-RCM-TES-0-17/04/2018*****************************************/

select pxp.f_insert_tgui ('<i class="fa fa-money fa-2x"></i> TESORERIA', '', 'TES', 'si', 9, '', 1, '', '', 'TES');
select pxp.f_insert_tgui ('Obligacion Pago', 'Obligaciones de pago', 'OBPG', 'si', 0, 'sis_tesoreria/vista/obligacion_pago/ObligacionPagoTes.php', 2, '', 'ObligacionPagoTes', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'OBPG.1', 'no', 0, 'sis_tesoreria/vista/obligacion_det/ObligacionDet.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Cuenta Bancaria', 'cuentas bancarias de la empresa', 'CTABAN', 'si', 0, 'sis_tesoreria/vista/cuenta_bancaria/CuentaBancaria.php', 2, '', 'CuentaBancaria', 'TES');
select pxp.f_insert_tgui ('Caja', 'Caja', 'CAJA', 'si', 13, 'sis_tesoreria/vista/caja/CajaCajero.php', 2, '', 'CajaCajero', 'TES');
select pxp.f_insert_tgui ('Libro de Bancos', 'cuentas bancarias de la empresa', 'CTABANE', 'si', 1, 'sis_tesoreria/vista/cuenta_bancaria/CuentaBancariaESIS.php', 2, '', 'CuentaBancariaESIS', 'TES');
select pxp.f_insert_tgui ('Reporte de Obligacion', 'Reporte de Obligacion', 'OBPG.2', 'no', 0, 'sis_tesoreria/vista/obligacion_pago/ReporteComEjePag.php', 3, '', 'ReporteComEjePag', 'TES');
select pxp.f_insert_tgui ('Plan de Pagos', 'Plan de Pagos', 'OBPG.3', 'no', 0, 'sis_tesoreria/vista/plan_pago/PlanPagoReq.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'OBPG.4', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', 'DocumentoWf', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'OBPG.5', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 3, '', '80%', 'TES');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'OBPG.6', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 3, '', 'proveedor', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'OBPG.7', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 3, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'OBPG.3.1', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Prorrateo', 'Prorrateo', 'OBPG.3.2', 'no', 0, 'sis_tesoreria/vista/prorrateo/Prorrateo.php', 4, '', 'Prorrateo', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'OBPG.3.3', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', 'DocumentoWf', 'TES');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'OBPG.3.3.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 5, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Items/Servicios ofertados', 'Items/Servicios ofertados', 'OBPG.6.1', 'no', 0, 'sis_parametros/vista/proveedor_item_servicio/ProveedorItemServicio.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OBPG.6.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'OBPG.6.3', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 4, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'OBPG.6.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 5, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OBPG.6.3.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'OBPG.7.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 4, '', 'FuncionarioCuentaBancaria', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OBPG.7.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'OBPG.7.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 5, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Chequeras', 'Chequeras', 'CTABAN.1', 'no', 0, 'sis_tesoreria/vista/chequera/Chequera.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'CTABAN.2', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 3, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CTABAN.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'CTABAN.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 5, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Cajero', 'Cajero', 'CAJA.1', 'no', 0, 'sis_tesoreria/vista/cajero/Cajero.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'CTABANE.1', 'no', 0, 'sis_migracion/vista/ts_libro_bancos/TsLibroBancos.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Chequeras', 'Chequeras', 'CTABANE.2', 'no', 0, 'sis_tesoreria/vista/chequera/Chequera.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'CTABANE.3', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 3, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CTABANE.3.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'CTABANE.3.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 5, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Visto Bueno de Pagos', 'Visto bueno de Devengaso y/o Pagos', 'VBDP', 'si', 0, 'sis_tesoreria/vista/plan_pago/PlanPagoVb.php', 2, '', 'PlanPagoVb', 'TES');
select pxp.f_insert_tgui ('Prorrateo', 'Prorrateo', 'VBDP.1', 'no', 0, 'sis_tesoreria/vista/prorrateo/Prorrateo.php', 3, '', '40%', 'TES');
select pxp.f_insert_tgui ('Chequeo de documentos de la solicitud', 'Chequeo de documentos de la solicitud', 'VBDP.2', 'no', 0, 'sis_adquisiciones/vista/documento_sol/ChequeoDocumentoSol.php', 3, '', 'id_solicitud', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBDP.3', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', 'DocumentoWf', 'TES');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'VBDP.2.1', 'no', 0, 'sis_adquisiciones/vista/documento_sol/SubirArchivo.php', 4, '', 'SubirArchivo', 'TES');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'VBDP.2.2', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 4, '', 'proveedor', 'TES');
select pxp.f_insert_tgui ('Items/Servicios ofertados', 'Items/Servicios ofertados', 'VBDP.2.2.1', 'no', 0, 'sis_parametros/vista/proveedor_item_servicio/ProveedorItemServicio.php', 5, '', '50%', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBDP.2.2.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBDP.2.2.3', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 5, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBDP.2.2.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 6, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBDP.2.2.3.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'VBDP.3.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 4, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'OBPG.3.3.2', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 5, '', 'TipoDocumentoEstadoWF', 'TES');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'OBPG.4.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 4, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'OBPG.4.2', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 4, '', 'TipoDocumentoEstadoWF', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'OBPG.6.3.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 6, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OBPG.7.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'OBPG.7.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 7, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'OBPG.7.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 5, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBDP.2.2.3.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 7, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'VBDP.3.2', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 4, '', 'TipoDocumentoEstadoWF', 'TES');
select pxp.f_insert_tgui ('Plan de Pagos (Reg. Adq.)', 'Plan de Pagos (Reg. Adq.)', 'OBPG.8', 'no', 0, 'sis_tesoreria/vista/plan_pago/PlanPagoRegIni.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'OBPG.8.1', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Prorrateo', 'Prorrateo', 'OBPG.8.2', 'no', 0, 'sis_tesoreria/vista/prorrateo/Prorrateo.php', 4, '', 'Prorrateo', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'OBPG.8.3', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'OBPG.8.3.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 5, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'OBPG.8.3.2', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 5, '', 'TipoDocumentoEstadoWF', 'TES');
select pxp.f_insert_tgui ('Solicitud de Obligacion de Pago  (Con Contrato)', 'Solicitud de Pago Directos', 'SOLPD', 'si', 0, 'sis_tesoreria/vista/obligacion_pago/ObligacionPagoSol.php', 2, '', 'ObligacionPagoSol', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OBPG.8.4', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OBPG.8.5', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', '../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OBPG.3.4', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OBPG.3.5', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', '../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBDP.4', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 3, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBDP.5', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 3, '', '../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'SOLPD.1', 'no', 0, 'sis_tesoreria/vista/obligacion_det/ObligacionDet.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Plan de Pagos (Reg. Adq.)', 'Plan de Pagos (Reg. Adq.)', 'SOLPD.2', 'no', 0, 'sis_tesoreria/vista/plan_pago/PlanPagoRegIni.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Reporte de Obligacion', 'Reporte de Obligacion', 'SOLPD.3', 'no', 0, 'sis_tesoreria/vista/obligacion_pago/ReporteComEjePag.php', 3, '', 'ReporteComEjePag', 'TES');
select pxp.f_insert_tgui ('Plan de Pagos', 'Plan de Pagos', 'SOLPD.4', 'no', 0, 'sis_tesoreria/vista/plan_pago/PlanPagoReq.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'SOLPD.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', '90%', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'SOLPD.6', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 3, '', '80%', 'TES');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'SOLPD.7', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 3, '', 'proveedor', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'SOLPD.2.1', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Prorrateo', 'Prorrateo', 'SOLPD.2.2', 'no', 0, 'sis_tesoreria/vista/prorrateo/Prorrateo.php', 4, '', 'Prorrateo', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'SOLPD.2.3', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'SOLPD.2.4', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', '../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'SOLPD.2.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'SOLPD.2.5.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 5, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'SOLPD.2.5.2', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 5, '', 'TipoDocumentoEstadoWF', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'SOLPD.4.1', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Prorrateo', 'Prorrateo', 'SOLPD.4.2', 'no', 0, 'sis_tesoreria/vista/prorrateo/Prorrateo.php', 4, '', 'Prorrateo', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'SOLPD.4.3', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'SOLPD.4.4', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', '../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'SOLPD.4.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'SOLPD.4.5.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 5, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'SOLPD.4.5.2', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 5, '', 'TipoDocumentoEstadoWF', 'TES');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'SOLPD.5.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 4, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'SOLPD.5.2', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 4, '', 'TipoDocumentoEstadoWF', 'TES');
select pxp.f_insert_tgui ('Items/Servicios ofertados', 'Items/Servicios ofertados', 'SOLPD.7.1', 'no', 0, 'sis_parametros/vista/proveedor_item_servicio/ProveedorItemServicio.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLPD.7.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'SOLPD.7.3', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 4, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'SOLPD.7.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 5, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLPD.7.3.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'SOLPD.7.3.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 6, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Tipo Plan Pago', 'Configuracion de  tipos de Plan de Pago', 'TIPP', 'si', 0, 'sis_tesoreria/vista/tipo_plan_pago/TipoPlanPago.php', 2, '', 'TipoPlanPago', 'TES');
select pxp.f_insert_tgui ('Depósitos y Cheques', 'cuenta bancaria endesis', 'CTABANCEND', 'si', 1, 'sis_tesoreria/vista/cuenta_bancaria/CuentaBancariaENDESIS.php', 2, '', 'CuentaBancariaENDESIS', 'TES');
select pxp.f_insert_tgui ('Aprobación de Fondos en Avance', 'Aprobación de Fondos en Avance', 'APFAENDE', 'no', 10, 'sis_tesoreria/vista/aprobacion_fondo_avance_endesis/AprobacionFondoAvanceEndesis.php', 2, '', 'AprobacionFondoAvanceEndesis', 'TES');
select pxp.f_insert_tgui ('Prorrateo ...', 'Prorrateo ...', 'OBPG.1.1', 'no', 0, 'sis_tesoreria/vista/tipo_prorrateo/WizardProrrateo.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Prorrateo ...', 'Prorrateo ...', 'SOLPD.1.1', 'no', 0, 'sis_tesoreria/vista/tipo_prorrateo/WizardProrrateo.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Revision de VoBo Pago (Asistentes)', 'Revision de VoBo Pago (Asistentes)', 'REVBPP', 'si', 0, 'sis_tesoreria/vista/plan_pago/PlanPagoVbAsistente.php', 2, '', 'PlanPagoVbAsistente', 'TES');
select pxp.f_insert_tgui ('Prorrateo', 'Prorrateo', 'REVBPP.1', 'no', 0, 'sis_tesoreria/vista/prorrateo/Prorrateo.php', 3, '', '40%', 'TES');
select pxp.f_insert_tgui ('Chequeo de documentos de la solicitud', 'Chequeo de documentos de la solicitud', 'REVBPP.2', 'no', 0, 'sis_adquisiciones/vista/documento_sol/ChequeoDocumentoSol.php', 3, '', 'id_solicitud', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'REVBPP.3', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 3, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'REVBPP.4', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 3, '', '../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'REVBPP.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'REVBPP.2.1', 'no', 0, 'sis_adquisiciones/vista/documento_sol/SubirArchivo.php', 4, '', 'SubirArchivo', 'TES');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'REVBPP.2.2', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 4, '', 'proveedor', 'TES');
select pxp.f_insert_tgui ('Items/Servicios ofertados', 'Items/Servicios ofertados', 'REVBPP.2.2.1', 'no', 0, 'sis_parametros/vista/proveedor_item_servicio/ProveedorItemServicio.php', 5, '', '50%', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'REVBPP.2.2.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'REVBPP.2.2.3', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 5, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'REVBPP.2.2.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 6, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'REVBPP.2.2.3.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'REVBPP.2.2.3.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 7, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'REVBPP.5.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 4, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'REVBPP.5.2', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 4, '', '40%', 'TES');
select pxp.f_insert_tgui ('VoBo Obligacion de Pago (Liberación Obli)', 'VoBo Obligacion de Pago (Presupuestos)', 'VBOP', 'si', 4, 'sis_tesoreria/vista/obligacion_pago/ObligacionPagoVb.php', 2, '', 'ObligacionPagoVb', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'VBOP.1', 'no', 0, 'sis_tesoreria/vista/obligacion_det/ObligacionDet.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Plan de Pagos (Reg. Adq.)', 'Plan de Pagos (Reg. Adq.)', 'VBOP.2', 'no', 0, 'sis_tesoreria/vista/plan_pago/PlanPagoRegIni.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Reporte de Obligacion', 'Reporte de Obligacion', 'VBOP.3', 'no', 0, 'sis_tesoreria/vista/obligacion_pago/ReporteComEjePag.php', 3, '', 'ReporteComEjePag', 'TES');
select pxp.f_insert_tgui ('Plan de Pagos', 'Plan de Pagos', 'VBOP.4', 'no', 0, 'sis_tesoreria/vista/plan_pago/PlanPagoReq.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBOP.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', '90%', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'VBOP.6', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 3, '', '80%', 'TES');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'VBOP.7', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 3, '', 'proveedor', 'TES');
select pxp.f_insert_tgui ('Prorrateo ...', 'Prorrateo ...', 'VBOP.1.1', 'no', 0, 'sis_tesoreria/vista/tipo_prorrateo/WizardProrrateo.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'VBOP.2.1', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Prorrateo', 'Prorrateo', 'VBOP.2.2', 'no', 0, 'sis_tesoreria/vista/prorrateo/Prorrateo.php', 4, '', 'Prorrateo', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBOP.2.3', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBOP.2.4', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', '../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBOP.2.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'VBOP.2.5.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 5, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'VBOP.2.5.2', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 5, '', '40%', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'VBOP.4.1', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Prorrateo', 'Prorrateo', 'VBOP.4.2', 'no', 0, 'sis_tesoreria/vista/prorrateo/Prorrateo.php', 4, '', 'Prorrateo', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBOP.4.3', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBOP.4.4', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', '../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBOP.4.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'VBOP.4.5.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 5, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'VBOP.4.5.2', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 5, '', '40%', 'TES');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'VBOP.5.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 4, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'VBOP.5.2', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 4, '', '40%', 'TES');
select pxp.f_insert_tgui ('Items/Servicios ofertados', 'Items/Servicios ofertados', 'VBOP.7.1', 'no', 0, 'sis_parametros/vista/proveedor_item_servicio/ProveedorItemServicio.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBOP.7.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBOP.7.3', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 4, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBOP.7.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 5, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBOP.7.3.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBOP.7.3.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 6, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Tipo Prorrateo', 'Tipo Prorrateo', 'TIPPRO', 'si', 0, 'sis_tesoreria/vista/tipo_prorrateo/TipoProrrateo.php', 2, '', 'TipoProrrateo', 'TES');
select pxp.f_insert_tgui ('Cambio de Apropiación', 'Cambio de Apropiación', 'VBDP.6', 'no', 0, 'sis_tesoreria/vista/obligacion_pago/ObligacionPagoApropiacion.php', 3, '', '90%', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'VBDP.6.1', 'no', 0, 'sis_tesoreria/vista/obligacion_det/ObligacionDetApropiacion.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Reporte de Obligacion', 'Reporte de Obligacion', 'VBDP.6.2', 'no', 0, 'sis_tesoreria/vista/obligacion_pago/ReporteComEjePag.php', 4, '', 'ReporteComEjePag', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'VBDP.6.3', 'no', 0, 'sis_tesoreria/vista/obligacion_det/ObligacionDet.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Plan de Pagos', 'Plan de Pagos', 'VBDP.6.4', 'no', 0, 'sis_tesoreria/vista/plan_pago/PlanPagoReq.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBDP.6.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'VBDP.6.6', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'VBDP.6.7', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 4, '', 'proveedor', 'TES');
select pxp.f_insert_tgui ('Prorrateo ...', 'Prorrateo ...', 'VBDP.6.1.1', 'no', 0, 'sis_tesoreria/vista/tipo_prorrateo/WizardProrrateo.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Prorrateo ...', 'Prorrateo ...', 'VBDP.6.3.1', 'no', 0, 'sis_tesoreria/vista/tipo_prorrateo/WizardProrrateo.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'VBDP.6.4.1', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 5, '', '80%', 'TES');
select pxp.f_insert_tgui ('Prorrateo', 'Prorrateo', 'VBDP.6.4.2', 'no', 0, 'sis_tesoreria/vista/prorrateo/Prorrateo.php', 5, '', 'Prorrateo', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBDP.6.4.3', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 5, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBDP.6.4.4', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 5, '', '../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBDP.6.4.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'VBDP.6.4.5.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'VBDP.6.4.5.2', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'TES');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'VBDP.6.5.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 5, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'VBDP.6.5.2', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 5, '', '40%', 'TES');
select pxp.f_insert_tgui ('Items/Servicios ofertados', 'Items/Servicios ofertados', 'VBDP.6.7.1', 'no', 0, 'sis_parametros/vista/proveedor_item_servicio/ProveedorItemServicio.php', 5, '', '50%', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBDP.6.7.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBDP.6.7.3', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 5, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBDP.6.7.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 6, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBDP.6.7.3.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBDP.6.7.3.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 7, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Reportes', 'Reportes', 'REPOP', 'si', 0, '', 2, '', '', 'TES');
select pxp.f_insert_tgui ('Reporte Pagos X Concepto', 'Reporte Pagos X Concepto', 'REPPAGCON', 'si', 1, 'sis_tesoreria/reportes/formularios/PagosConcepto.php', 3, '', 'PagosConcepto', 'TES');
select pxp.f_insert_tgui ('Kardex por Item: ', 'Kardex por Item: ', 'REPPAGCON.1', 'no', 0, 'sis_tesoreria/reportes/grillas/PagosConceptoVista.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Obligaciones de pago (Contabilidad)', 'Obligaciones de pago (Contabilidad)', 'OPCONTA', 'si', 10, 'sis_tesoreria/vista/obligacion_pago/ObligacionPagoConta.php', 2, '', 'ObligacionPagoConta', 'TES');
select pxp.f_insert_tgui ('Consulta Obligacion de Pago', 'Consulta Obligacion de Pago', 'CONOP', 'si', 11, 'sis_tesoreria/vista/obligacion_pago/ObligacionPagoConsulta.php', 2, '', 'ObligacionPagoConsulta', 'TES');
select pxp.f_insert_tgui ('Visto Bueno de Pagos (Conta)', 'Visto Bueno de Pagos (Conta)', 'VBPDC', 'si', 0, 'sis_tesoreria/vista/plan_pago/PlanPagoVbConta.php', 2, '', 'PlanPagoVbConta', 'TES');
select pxp.f_insert_tgui ('Solicitud de Pago Único  (Sin contrato)', 'Solicitud de Pago Único  (Sin contrato)', 'OPUNI', 'si', 0, 'sis_tesoreria/vista/obligacion_pago/ObligacionPagoUnico.php', 2, '', 'ObligacionPagoUnico', 'TES');
select pxp.f_insert_tgui ('VoBo Obligaciones de Pago (POA)', '', 'VBOPOA', 'si', 0, 'sis_tesoreria/vista/obligacion_pago/ObligacionPagoVbPoa.php', 3, '', 'ObligacionPagoVbPoa', 'TES');
select pxp.f_insert_tgui ('Reporte de Pagos', 'Reporte de pagos', 'REPPP', 'si', 4, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 3, '', 'RepFilPlanPago', 'TES');
select pxp.f_insert_tgui ('Solicitud Apertura/Cierre Caja', 'Solicitud Apertura/Cierre Caja', 'SOLCAJA', 'si', 1, 'sis_tesoreria/vista/caja/CajaSolicitud.php', 2, '', 'CajaSolicitud', 'TES');
select pxp.f_insert_tgui ('Visto Bueno Apertura Cajas', 'Visto bueno apertura cajas', 'VBCAJA', 'si', 2, 'sis_tesoreria/vista/caja/CajaVB.php', 2, '', 'CajaVb', 'TES');
select pxp.f_insert_tgui ('Solicitud Efectivo Con Detalle', 'Solicitud Efectivo', 'SOLEFE', 'si', 6, 'sis_tesoreria/vista/solicitud_efectivo/SolicitudEfectivo.php', 2, '', 'SolicitudEfectivo', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'CAJA.2', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 3, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'CAJA.2.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'CAJA.2.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 5, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'CAJA.2.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'CAJA.2.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 5, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'CAJA.2.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 5, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'CAJA.2.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'CAJA.2.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 6, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'CAJA.2.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 7, '', '90%', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'SOLEFE.1', 'no', 0, 'sis_tesoreria/vista/solicitud_efectivo_det/SolicitudEfectivoDet.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBCAJA.1', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 3, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Cajero', 'Cajero', 'VBCAJA.2', 'no', 0, 'sis_tesoreria/vista/cajero/Cajero.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBCAJA.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'VBCAJA.1.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 5, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'VBCAJA.1.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'VBCAJA.1.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 5, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'VBCAJA.1.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 5, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBCAJA.1.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'VBCAJA.1.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 6, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBCAJA.1.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 7, '', '90%', 'TES');
select pxp.f_insert_tgui ('Solicitud Efectivo Simple', 'Solicitud Efectivo Simple', 'SOLEFESD', 'si', 5, 'sis_tesoreria/vista/solicitud_efectivo/SolicitudEfectivoSinDet.php', 2, '', 'SolicitudEfectivoSinDet', 'TES');
select pxp.f_insert_tgui ('Visto Bueno Solicitud Efectivo', 'Visto Bueno Solicitud Efectivo', 'VBSOLEFE', 'si', 7, 'sis_tesoreria/vista/solicitud_efectivo/SolicitudEfectivoVb.php', 2, '', 'SolicitudEfectivoVb', 'TES');
select pxp.f_insert_tgui ('Visto Bueno Cajas Rendiciones', 'Visto Bueno Cajas Rendiciones', 'VBRENCJ', 'si', 9, 'sis_tesoreria/vista/proceso_caja/ProcesoCajaVb.php', 2, '', 'ProcesoCajaVb', 'TES');
select pxp.f_insert_tgui ('Rendicion Caja', 'Rendicion Caja', 'CAJA.3', 'no', 0, 'sis_tesoreria/vista/proceso_caja/ProcesoCaja.php', 3, '', '95%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'CAJA.3.1', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'CAJA.3.2', 'no', 0, 'sis_tesoreria/vista/solicitud_rendicion_det/RendicionProcesoCaja.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Formulario de solicitud efectivo', 'Formulario de solicitud efectivo', 'SOLEFE.2', 'no', 0, 'sis_tesoreria/vista/solicitud_efectivo/FormSolicitudEfectivo.php', 3, '', '90%', 'TES');
select pxp.f_insert_tgui ('Rendicion', 'Rendicion', 'SOLEFE.3', 'no', 0, 'sis_tesoreria/vista/solicitud_rendicion_det/SolicitudRendicionDet.php', 3, '', '95%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'SOLEFE.4', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 3, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de la solicitu de compra', 'Documentos de la solicitu de compra', 'SOLEFE.2.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'SOLEFE.2.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 5, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'SOLEFE.2.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'SOLEFE.2.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 5, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'SOLEFE.2.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 5, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'SOLEFE.2.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'SOLEFE.2.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 6, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'SOLEFE.2.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 7, '', '90%', 'TES');
select pxp.f_insert_tgui ('Formulario de rendicion', 'Formulario de rendicion', 'SOLEFE.3.1', 'no', 0, 'sis_tesoreria/vista/solicitud_rendicion_det/FormRendicion.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'SOLEFE.4.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBCAJA.3', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 3, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Rendicion Caja', 'Rendicion Caja', 'VBCAJA.4', 'no', 0, 'sis_tesoreria/vista/proceso_caja/ProcesoCaja.php', 3, '', '95%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBCAJA.4.1', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'VBCAJA.4.2', 'no', 0, 'sis_tesoreria/vista/solicitud_rendicion_det/RendicionProcesoCaja.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Rendicion', 'Rendicion', 'SOLEFESD.1', 'no', 0, 'sis_tesoreria/vista/solicitud_rendicion_det/SolicitudRendicionDet.php', 3, '', '95%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'SOLEFESD.2', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 3, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Formulario de rendicion', 'Formulario de rendicion', 'SOLEFESD.1.1', 'no', 0, 'sis_tesoreria/vista/solicitud_rendicion_det/FormRendicion.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'SOLEFESD.2.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'SOLEFESD.2.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 5, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'SOLEFESD.2.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'SOLEFESD.2.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 5, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'SOLEFESD.2.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 5, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'SOLEFESD.2.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'SOLEFESD.2.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 6, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'SOLEFESD.2.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 7, '', '90%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBSOLEFE.1', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 3, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBSOLEFE.2', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 3, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'VBSOLEFE.3', 'no', 0, 'sis_tesoreria/vista/solicitud_efectivo_det/SolicitudEfectivoDetVb.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBSOLEFE.2.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'VBSOLEFE.2.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 5, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'VBSOLEFE.2.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'VBSOLEFE.2.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 5, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'VBSOLEFE.2.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 5, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBSOLEFE.2.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'VBSOLEFE.2.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 6, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBSOLEFE.2.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 7, '', '90%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBRENCJ.1', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 3, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBRENCJ.2', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 3, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'VBRENCJ.3', 'no', 0, 'sis_tesoreria/vista/solicitud_rendicion_det/RendicionProcesoCaja.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBRENCJ.2.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'VBRENCJ.2.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 5, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'VBRENCJ.2.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'VBRENCJ.2.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 5, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'VBRENCJ.2.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 5, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBRENCJ.2.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'VBRENCJ.2.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 6, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBRENCJ.2.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 7, '', '90%', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'CAJA.3.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'CAJA.3.1.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'CAJA.3.1.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'CAJA.3.1.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'CAJA.3.1.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'CAJA.3.1.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'CAJA.3.1.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'CAJA.3.1.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'SOLCAJA.1', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 3, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Cajero', 'Cajero', 'SOLCAJA.2', 'no', 0, 'sis_tesoreria/vista/cajero/Cajero.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'SOLCAJA.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'SOLCAJA.1.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 5, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'SOLCAJA.1.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'SOLCAJA.1.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 5, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'SOLCAJA.1.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 5, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'SOLCAJA.1.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'SOLCAJA.1.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 6, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'SOLCAJA.1.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 7, '', '90%', 'TES');
select pxp.f_insert_tgui ('Reporte de Pagos Basico', 'RPB', 'REPPPBA', 'si', 6, 'sis_tesoreria/vista/plan_pago/ReportePagosSimple.php', 3, '', 'ReportePagosSimple', 'TES');
select pxp.f_insert_tgui ('Proceso Con Retencion 7%', 'Proceso Con Retencion 7%', 'PRCRE', 'si', 7, 'sis_tesoreria/vista/reporte_proceso_con_retencion/ProcesoConRetencion.php', 3, '', 'ProcesoConRetencion', 'TES');
select pxp.f_insert_tgui ('Procesos Pendientes', 'PP', 'PP', 'si', 8, 'sis_tesoreria/vista/reporte_procesos_pendientes/ProcesosPendientes.php', 3, '', 'ProcesosPendientes', 'TES');
select pxp.f_insert_tgui ('Procesos Pendientes Contabilidad', 'Procesos Pendientes Contabilidad', 'PPC', 'si', 9, 'sis_tesoreria/vista/reporte_procesos_pendientes/ProcesoPendienteContabilidad.php', 3, '', 'ProcesoPendienteContabilidad', 'TES');
select pxp.f_insert_tgui ('Victo bueno de Pagos (Costos)', 'Visto bueno de pagos costos', 'VBPCOS', 'si', 0, 'sis_tesoreria/vista/plan_pago/PlanPagoVbCostos.php', 2, '', 'PlanPagoVbCostos', 'TES');
select pxp.f_insert_tgui ('Excepciones de conceptos', 'Ecepciones de concepto de gasto', 'CONEX', 'si', 0, 'sis_tesoreria/vista/concepto_excepcion/ConceptoExcepcion.php', 3, '', 'ConceptoExcepcion', 'TES');
select pxp.f_insert_tgui ('Obligaciones de Pago', 'Obligaciones de Pago', 'CAROP', 'si', 2, '', 2, '', '', 'TES');
select pxp.f_insert_tgui ('Libro de Bancos', 'Libro de Bancos', 'CARLB', 'si', 5, '', 2, '', '', 'TES');
select pxp.f_insert_tgui ('Fondos Rotatorios', 'Fondos Rotatorios', 'CARFR', 'si', 3, '', 2, '', '', 'TES');
select pxp.f_insert_tgui ('Configuraciones', 'Configuraciones', 'CAOPCOFG', 'si', 1, '', 3, '', '', 'TES');
select pxp.f_insert_tgui ('Solicitudes', 'Solucitudes de pago', 'CAROPSOL', 'si', 2, '', 3, '', '', 'TES');
select pxp.f_insert_tgui ('VoBo', 'VoBo', 'CAROPVB', 'si', 3, '', 3, '', '', 'TES');
select pxp.f_insert_tgui ('Reporte Libro Bancos', 'reporte libro bancos', 'REPLB', 'si', 0, 'sis_tesoreria/reportes/formularios/LibroBancos.php', 3, '', 'ReporteLibroBancos', 'TES');
select pxp.f_insert_tgui ('Finalidad', 'Finalidad de cuentas bancarias', 'FINCUE', 'si', 1, 'sis_tesoreria/vista/finalidad/Finalidad.php', 3, '', 'Finalidad', 'TES');
select pxp.f_insert_tgui ('Tipo Proceso Caja', 'Tipo Proceso Caja', 'TPC', 'si', 0, 'sis_tesoreria/vista/tipo_proceso_caja/TipoProcesoCaja.php', 3, '', 'TipoProcesoCaja', 'TES');
select pxp.f_insert_tgui ('VoBo Repo Cajas (Fondos)', 'VoBo Repo Cajas (Fondos)', 'VBCJ', 'si', 3, 'sis_tesoreria/vista/proceso_caja/ProcesoCajaVbFondos.php', 3, '', 'ProcesoCajaVbFondos', 'TES');
select pxp.f_insert_tgui ('VoBo Rend Caja (Presup)', 'VoBo Rend Caja (Presup)', 'VBCP', 'si', 3, 'sis_tesoreria/vista/proceso_caja/ProcesoCajaVbPresup.php', 3, '', 'ProcesoCajaVbPresup', 'TES');
select pxp.f_insert_tgui ('Tipo Solicitud', 'Tipo Solicitud', 'TPSOL', 'si', 0, 'sis_tesoreria/vista/tipo_solicitud/TipoSolicitud.php', 3, '', 'TipoSolicitud', 'TES');
select pxp.f_insert_tgui ('Visto Bueno Facturas Rendicion', 'Visto Bueno Facturas Rendicion', 'VBFACREN', 'si', 8, 'sis_tesoreria/vista/rendicion_efectivo/RendicionEfectivo.php', 3, '', 'RendicionEfectivo', 'TES');
select pxp.f_insert_tgui ('VoBo Rend/Repo Cajas (Conta)', 'VoBo Rend/Repo Cajas (Conta)', 'VBRENCJA', 'si', 12, 'sis_tesoreria/vista/proceso_caja/ProcesoCajaVbConta.php', 3, '', 'ProcesoCajaVbConta', 'TES');
select pxp.f_insert_tgui ('Evolución presupuestaria (', 'Evolución presupuestaria (', 'OBPG.9', 'no', 0, 'sis_tesoreria/vista/presupuesto/CheckPresupuesto.php', 3, '', ')', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OBPG.10', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 3, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'OBPG.11', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 3, '', '80%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'OBPG.8.6', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'OBPG.8.7', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'OBPG.8.5.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'OBPG.8.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'OBPG.8.5.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'OBPG.8.5.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'OBPG.8.5.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'OBPG.8.5.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'OBPG.8.5.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'OBPG.8.5.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'OBPG.8.7.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 5, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'OBPG.8.7.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 6, '', 'FuncionarioCuentaBancaria', 'TES');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'OBPG.8.7.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 6, '', 'FuncionarioEspecialidad', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'OBPG.8.7.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 6, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OBPG.8.7.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'OBPG.8.7.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 7, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OBPG.8.7.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'OBPG.8.7.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'OBPG.8.7.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'OBPG.8.7.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 10, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'OBPG.8.7.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 10, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'OBPG.3.6', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'OBPG.3.7', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Cta Bancaria', 'Cta Bancaria', 'OBPG.6.4', 'no', 0, 'sis_parametros/vista/proveedor_cta_bancaria/ProveedorCtaBancaria.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OBPG.6.5', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OBPG.6.6', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'OBPG.6.7', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'OBPG.6.8', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'OBPG.6.4.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 5, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Periodos por Cuenta Bancaria', 'Periodos por Cuenta Bancaria', 'CTABAN.3', 'no', 0, 'sis_tesoreria/vista/cuenta_bancaria_periodo/CuentaBancariaPeriodo.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Usuarios', 'Usuarios', 'CTABAN.4', 'no', 0, 'sis_tesoreria/vista/usuario_cuenta_banc/UsuarioCuentaBanc.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Tipo de Centros Permitidos', 'Tipo de Centros Permitidos', 'CTABAN.5', 'no', 0, 'sis_tesoreria/vista/tipo_cc_cuenta_libro/TipoCcCuentaLibro.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Usuarios', 'Usuarios', 'CTABAN.4.1', 'no', 0, 'sis_seguridad/vista/usuario/Usuario.php', 4, '', 'usuario', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CTABAN.4.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Roles', 'Roles', 'CTABAN.4.1.2', 'no', 0, 'sis_seguridad/vista/usuario_rol/UsuarioRol.php', 5, '', 'usuario_rol', 'TES');
select pxp.f_insert_tgui ('EP\', 'EP\', 'CTABAN.4.1.3', 'no', 0, 'sis_seguridad/vista/usuario_grupo_ep/UsuarioGrupoEp.php', 5, '', ', 
          width:400,
          cls:', 'TES');
select pxp.f_insert_tgui ('Usuario Externo', 'Usuario Externo', 'CTABAN.4.1.4', 'no', 0, 'sis_seguridad/vista/usuario_externo/UsuarioExterno.php', 5, '', 'UsuarioExterno', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'CTABAN.4.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 6, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'CTABAN.4.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 6, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'CTABAN.4.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 7, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'CTABAN.4.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 7, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'CTABAN.4.1.4.1', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 6, '', 'Catalogo', 'TES');
select pxp.f_insert_tgui ('Proceso Caja', 'Proceso Caja', 'CAJA.4', 'no', 0, 'sis_tesoreria/vista/proceso_caja/ProcesoCajaCajero.php', 3, '', '95%', 'TES');
select pxp.f_insert_tgui ('Funcionario', 'Funcionario', 'CAJA.5', 'no', 0, 'sis_tesoreria/vista/caja_funcionario/CajaFuncionario.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Solicitud Efectivo', 'Solicitud Efectivo', 'CAJA.6', 'no', 0, 'sis_tesoreria/vista/solicitud_efectivo/SolicitudEfectivoCaja.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'CAJA.4.1', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'CAJA.4.2', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'CAJA.4.3', 'no', 0, 'sis_tesoreria/vista/solicitud_rendicion_det/RendicionProcesoCaja.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Depositos', 'Depositos', 'CAJA.4.4', 'no', 0, 'sis_tesoreria/vista/caja/CajaDeposito.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'CAJA.4.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'CAJA.4.1.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'CAJA.4.1.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'CAJA.4.1.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'CAJA.4.1.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'CAJA.4.1.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'CAJA.4.1.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'CAJA.4.1.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'TES');
select pxp.f_insert_tgui ('Corregir Importe Contable Deposito', 'Corregir Importe Contable Deposito', 'CAJA.4.4.1', 'no', 0, 'sis_tesoreria/vista/deposito/FormImporteContableDeposito.php', 5, '', 'FormImporteContableDeposito', 'TES');
select pxp.f_insert_tgui ('Relacionar Deposito', 'Relacionar Deposito', 'CAJA.4.4.2', 'no', 0, 'sis_tesoreria/vista/deposito/FormRelacionarDeposito.php', 5, '', 'FormRelacionarDeposito', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'CAJA.5.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 4, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'CAJA.5.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 5, '', 'FuncionarioCuentaBancaria', 'TES');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'CAJA.5.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 5, '', 'FuncionarioEspecialidad', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'CAJA.5.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 5, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CAJA.5.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'CAJA.5.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 6, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CAJA.5.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'CAJA.5.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 8, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'CAJA.5.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 8, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'CAJA.5.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 9, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'CAJA.5.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 9, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'CAJA.6.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Transferencia Cuenta', 'Transferencia Cuenta', 'CTABANE.4', 'no', 0, 'sis_tesoreria/vista/transferencia_cuenta/FormTransferenciaCuenta.php', 3, '', 'FormTransferenciaCuenta', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'CTABANE.5', 'no', 0, 'sis_tesoreria/vista/ts_libro_bancos/TsLibroBancos.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Periodos por Cuenta Bancaria', 'Periodos por Cuenta Bancaria', 'CTABANE.6', 'no', 0, 'sis_tesoreria/vista/cuenta_bancaria_periodo/CuentaBancariaPeriodo.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Usuarios', 'Usuarios', 'CTABANE.7', 'no', 0, 'sis_tesoreria/vista/usuario_cuenta_banc/UsuarioCuentaBanc.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Tipo de Centros Permitidos', 'Tipo de Centros Permitidos', 'CTABANE.8', 'no', 0, 'sis_tesoreria/vista/tipo_cc_cuenta_libro/TipoCcCuentaLibro.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'CTABANE.5.1', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'CTABANE.5.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Cheques Asociados', 'Cheques Asociados', 'CTABANE.5.3', 'no', 0, 'sis_tesoreria/vista/ts_libro_bancos_cheques_asociados/TsLibroBancosChequesAsociados.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'CTABANE.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'CTABANE.5.1.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'CTABANE.5.1.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'CTABANE.5.1.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'CTABANE.5.1.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'CTABANE.5.1.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'CTABANE.5.1.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'CTABANE.5.1.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'CTABANE.5.3.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Usuarios', 'Usuarios', 'CTABANE.7.1', 'no', 0, 'sis_seguridad/vista/usuario/Usuario.php', 4, '', 'usuario', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CTABANE.7.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Roles', 'Roles', 'CTABANE.7.1.2', 'no', 0, 'sis_seguridad/vista/usuario_rol/UsuarioRol.php', 5, '', 'usuario_rol', 'TES');
select pxp.f_insert_tgui ('EP\', 'EP\', 'CTABANE.7.1.3', 'no', 0, 'sis_seguridad/vista/usuario_grupo_ep/UsuarioGrupoEp.php', 5, '', ', 
          width:400,
          cls:', 'TES');
select pxp.f_insert_tgui ('Usuario Externo', 'Usuario Externo', 'CTABANE.7.1.4', 'no', 0, 'sis_seguridad/vista/usuario_externo/UsuarioExterno.php', 5, '', 'UsuarioExterno', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'CTABANE.7.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 6, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'CTABANE.7.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 6, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'CTABANE.7.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 7, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'CTABANE.7.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 7, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'CTABANE.7.1.4.1', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 6, '', 'Catalogo', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBDP.7', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 3, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBDP.8', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 3, '', '80%', 'TES');
select pxp.f_insert_tgui ('Evolución presupuestaria (', 'Evolución presupuestaria (', 'VBDP.6.8', 'no', 0, 'sis_tesoreria/vista/presupuesto/CheckPresupuesto.php', 4, '', ')', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBDP.6.9', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBDP.6.10', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBDP.6.4.6', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBDP.6.4.7', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 5, '', '80%', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBDP.6.4.4.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'VBDP.6.4.4.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 7, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'VBDP.6.4.4.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 7, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'VBDP.6.4.4.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 7, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'VBDP.6.4.4.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 7, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBDP.6.4.4.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 7, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'VBDP.6.4.4.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 8, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBDP.6.4.4.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 9, '', '90%', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'VBDP.6.4.7.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 6, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'VBDP.6.4.7.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 7, '', 'FuncionarioCuentaBancaria', 'TES');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'VBDP.6.4.7.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 7, '', 'FuncionarioEspecialidad', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBDP.6.4.7.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 7, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBDP.6.4.7.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBDP.6.4.7.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 8, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBDP.6.4.7.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBDP.6.4.7.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBDP.6.4.7.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 10, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'VBDP.6.4.7.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 11, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'VBDP.6.4.7.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 11, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Cta Bancaria', 'Cta Bancaria', 'VBDP.6.7.4', 'no', 0, 'sis_parametros/vista/proveedor_cta_bancaria/ProveedorCtaBancaria.php', 5, '', '50%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBDP.6.7.5', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 5, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBDP.6.7.6', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 5, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBDP.6.7.7', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBDP.6.7.8', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 5, '', '80%', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBDP.6.7.4.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 6, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Evolución presupuestaria (', 'Evolución presupuestaria (', 'SOLPD.8', 'no', 0, 'sis_tesoreria/vista/presupuesto/CheckPresupuesto.php', 3, '', ')', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'SOLPD.9', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 3, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'SOLPD.10', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 3, '', '80%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'SOLPD.2.6', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'SOLPD.2.7', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'SOLPD.2.4.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'SOLPD.2.4.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'SOLPD.2.4.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'SOLPD.2.4.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'SOLPD.2.4.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'SOLPD.2.4.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'SOLPD.2.4.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'SOLPD.2.4.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'SOLPD.2.7.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 5, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'SOLPD.2.7.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 6, '', 'FuncionarioCuentaBancaria', 'TES');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'SOLPD.2.7.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 6, '', 'FuncionarioEspecialidad', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'SOLPD.2.7.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 6, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLPD.2.7.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'SOLPD.2.7.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 7, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLPD.2.7.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'SOLPD.2.7.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'SOLPD.2.7.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'SOLPD.2.7.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 10, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'SOLPD.2.7.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 10, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'SOLPD.4.6', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'SOLPD.4.7', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Cta Bancaria', 'Cta Bancaria', 'SOLPD.7.4', 'no', 0, 'sis_parametros/vista/proveedor_cta_bancaria/ProveedorCtaBancaria.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'SOLPD.7.5', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'SOLPD.7.6', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'SOLPD.7.7', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'SOLPD.7.8', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'SOLPD.7.4.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 5, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Depositos', 'Depositos', 'CTABANCEND.1', 'no', 0, 'sis_tesoreria/vista/ts_libro_bancos_depositos/TsLibroBancosDeposito.php', 3, '', '95%', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'CTABANCEND.2', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 3, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'CTABANCEND.1.1', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Transferencia Deposito', 'Transferencia Deposito', 'CTABANCEND.1.2', 'no', 0, 'sis_tesoreria/vista/transferencia/FormTransferencia.php', 4, '', 'FormTransferencia', 'TES');
select pxp.f_insert_tgui ('Cheques', 'Cheques', 'CTABANCEND.1.3', 'no', 0, 'sis_tesoreria/vista/ts_libro_bancos_cheques/TsLibroBancosCheque.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Depositos Extra', 'Depositos Extra', 'CTABANCEND.1.4', 'no', 0, 'sis_tesoreria/vista/ts_libro_bancos_depositos_extra/TsLibroBancosDepositoExtra.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'CTABANCEND.1.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'CTABANCEND.1.1.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'CTABANCEND.1.1.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'CTABANCEND.1.1.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'CTABANCEND.1.1.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'CTABANCEND.1.1.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'CTABANCEND.1.1.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'CTABANCEND.1.1.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'TES');
select pxp.f_insert_tgui ('Relacionar Cheque a Tramite', 'Relacionar Cheque a Tramite', 'CTABANCEND.1.3.1', 'no', 0, 'sis_tesoreria/vista/ts_libro_bancos_cheques/FormRelacionarCheque.php', 5, '', 'FormRelacionarCheque', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'CTABANCEND.1.3.2', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 5, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'CTABANCEND.1.3.3', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Cheques Asociados', 'Cheques Asociados', 'CTABANCEND.1.3.4', 'no', 0, 'sis_tesoreria/vista/ts_libro_bancos_cheques_asociados/TsLibroBancosChequesAsociados.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'CTABANCEND.1.3.4.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'CTABANCEND.1.4.1', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 5, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Transferencia Deposito', 'Transferencia Deposito', 'CTABANCEND.1.4.2', 'no', 0, 'sis_tesoreria/vista/transferencia/FormTransferencia.php', 5, '', 'FormTransferencia', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CTABANCEND.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'CTABANCEND.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 5, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'CTABANCEND.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 5, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'CTABANCEND.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 6, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'CTABANCEND.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 6, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'REVBPP.6', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 3, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'REVBPP.7', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 3, '', '80%', 'TES');
select pxp.f_insert_tgui ('Cta Bancaria', 'Cta Bancaria', 'REVBPP.2.2.4', 'no', 0, 'sis_parametros/vista/proveedor_cta_bancaria/ProveedorCtaBancaria.php', 5, '', '50%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'REVBPP.2.2.5', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 5, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'REVBPP.2.2.6', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 5, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'REVBPP.2.2.7', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'REVBPP.2.2.8', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 5, '', '80%', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'REVBPP.2.2.4.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 6, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'REVBPP.2.2.4.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'REVBPP.2.2.4.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 8, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'REVBPP.2.2.4.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 8, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'REVBPP.2.2.4.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 9, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'REVBPP.2.2.4.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 9, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'REVBPP.2.2.6.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'REVBPP.2.2.6.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 7, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'REVBPP.2.2.6.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 7, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'REVBPP.2.2.6.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 7, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'REVBPP.2.2.6.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 7, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'REVBPP.2.2.6.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 7, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'REVBPP.2.2.6.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 8, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'REVBPP.2.2.6.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 9, '', '90%', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'REVBPP.2.2.8.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 6, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'REVBPP.2.2.8.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 7, '', 'FuncionarioCuentaBancaria', 'TES');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'REVBPP.2.2.8.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 7, '', 'FuncionarioEspecialidad', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'REVBPP.2.2.8.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 7, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'REVBPP.2.2.8.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'REVBPP.2.2.8.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 8, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Evolución presupuestaria (', 'Evolución presupuestaria (', 'VBOP.8', 'no', 0, 'sis_tesoreria/vista/presupuesto/CheckPresupuesto.php', 3, '', ')', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBOP.9', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 3, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBOP.10', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 3, '', '80%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBOP.2.6', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBOP.2.7', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBOP.2.4.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'VBOP.2.4.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'VBOP.2.4.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'VBOP.2.4.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'VBOP.2.4.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBOP.2.4.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'VBOP.2.4.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBOP.2.4.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'VBOP.2.7.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 5, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'VBOP.2.7.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 6, '', 'FuncionarioCuentaBancaria', 'TES');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'VBOP.2.7.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 6, '', 'FuncionarioEspecialidad', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBOP.2.7.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 6, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBOP.2.7.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBOP.2.7.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 7, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBOP.2.7.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBOP.2.7.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBOP.2.7.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'VBOP.2.7.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 10, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'VBOP.2.7.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 10, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBOP.4.6', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBOP.4.7', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Cta Bancaria', 'Cta Bancaria', 'VBOP.7.4', 'no', 0, 'sis_parametros/vista/proveedor_cta_bancaria/ProveedorCtaBancaria.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBOP.7.5', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBOP.7.6', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBOP.7.7', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBOP.7.8', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBOP.7.4.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 5, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'OPCONTA.1', 'no', 0, 'sis_tesoreria/vista/obligacion_det/ObligacionDet.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Plan de Pagos (Reg. Adq.)', 'Plan de Pagos (Reg. Adq.)', 'OPCONTA.2', 'no', 0, 'sis_tesoreria/vista/plan_pago/PlanPagoRegIni.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Reporte de Obligacion', 'Reporte de Obligacion', 'OPCONTA.3', 'no', 0, 'sis_tesoreria/vista/obligacion_pago/ReporteComEjePag.php', 3, '', 'ReporteComEjePag', 'TES');
select pxp.f_insert_tgui ('Plan de Pagos', 'Plan de Pagos', 'OPCONTA.4', 'no', 0, 'sis_tesoreria/vista/plan_pago/PlanPagoReq.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'OPCONTA.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', '90%', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'OPCONTA.6', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 3, '', '80%', 'TES');
select pxp.f_insert_tgui ('Evolución presupuestaria (', 'Evolución presupuestaria (', 'OPCONTA.7', 'no', 0, 'sis_tesoreria/vista/presupuesto/CheckPresupuesto.php', 3, '', ')', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OPCONTA.8', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 3, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'OPCONTA.9', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 3, '', '80%', 'TES');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'OPCONTA.10', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 3, '', 'proveedor', 'TES');
select pxp.f_insert_tgui ('Prorrateo ...', 'Prorrateo ...', 'OPCONTA.1.1', 'no', 0, 'sis_tesoreria/vista/tipo_prorrateo/WizardProrrateo.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'OPCONTA.2.1', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Prorrateo', 'Prorrateo', 'OPCONTA.2.2', 'no', 0, 'sis_tesoreria/vista/prorrateo/Prorrateo.php', 4, '', 'Prorrateo', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OPCONTA.2.3', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OPCONTA.2.4', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', '../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'OPCONTA.2.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'OPCONTA.2.6', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'OPCONTA.2.7', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'OPCONTA.2.4.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'OPCONTA.2.4.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'OPCONTA.2.4.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'OPCONTA.2.4.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'OPCONTA.2.4.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'OPCONTA.2.4.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'OPCONTA.2.4.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'OPCONTA.2.4.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'OPCONTA.2.7.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 5, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'OPCONTA.2.7.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 6, '', 'FuncionarioCuentaBancaria', 'TES');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'OPCONTA.2.7.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 6, '', 'FuncionarioEspecialidad', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'OPCONTA.2.7.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 6, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OPCONTA.2.7.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'OPCONTA.2.7.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 7, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OPCONTA.2.7.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'OPCONTA.2.7.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'OPCONTA.2.7.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'OPCONTA.2.7.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 10, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'OPCONTA.2.7.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 10, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'OPCONTA.4.1', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Prorrateo', 'Prorrateo', 'OPCONTA.4.2', 'no', 0, 'sis_tesoreria/vista/prorrateo/Prorrateo.php', 4, '', 'Prorrateo', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OPCONTA.4.3', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OPCONTA.4.4', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', '../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'OPCONTA.4.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'OPCONTA.4.6', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'OPCONTA.4.7', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Cta Bancaria', 'Cta Bancaria', 'OPCONTA.10.1', 'no', 0, 'sis_parametros/vista/proveedor_cta_bancaria/ProveedorCtaBancaria.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OPCONTA.10.2', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OPCONTA.10.3', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'OPCONTA.10.4', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'OPCONTA.10.5', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OPCONTA.10.6', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'OPCONTA.10.7', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 4, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'OPCONTA.10.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 5, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'CONOP.1', 'no', 0, 'sis_tesoreria/vista/obligacion_det/ObligacionDetConsulta.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Plan de Pagos (Consulta)', 'Plan de Pagos (Consulta)', 'CONOP.2', 'no', 0, 'sis_tesoreria/vista/plan_pago/PlanPagoConsulta.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Reporte de Obligacion', 'Reporte de Obligacion', 'CONOP.3', 'no', 0, 'sis_tesoreria/vista/obligacion_pago/ReporteComEjePag.php', 3, '', 'ReporteComEjePag', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'CONOP.4', 'no', 0, 'sis_tesoreria/vista/obligacion_det/ObligacionDet.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Plan de Pagos', 'Plan de Pagos', 'CONOP.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/PlanPagoReq.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'CONOP.6', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', '90%', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'CONOP.7', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 3, '', '80%', 'TES');
select pxp.f_insert_tgui ('Evolución presupuestaria (', 'Evolución presupuestaria (', 'CONOP.8', 'no', 0, 'sis_tesoreria/vista/presupuesto/CheckPresupuesto.php', 3, '', ')', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'CONOP.9', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 3, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'CONOP.10', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 3, '', '80%', 'TES');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'CONOP.11', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 3, '', 'proveedor', 'TES');
select pxp.f_insert_tgui ('Prorrateo ...', 'Prorrateo ...', 'CONOP.1.1', 'no', 0, 'sis_tesoreria/vista/tipo_prorrateo/WizardProrrateo.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Prorrateo', 'Prorrateo', 'CONOP.2.1', 'no', 0, 'sis_tesoreria/vista/prorrateo/ProrrateoConsulta.php', 4, '', 'ProrrateoConsulta', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'CONOP.2.2', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'CONOP.2.3', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', '../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'CONOP.2.4', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'CONOP.2.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'CONOP.2.6', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'CONOP.2.3.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'CONOP.2.3.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'CONOP.2.3.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'CONOP.2.3.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'CONOP.2.3.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'CONOP.2.3.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'CONOP.2.3.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'CONOP.2.3.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'CONOP.2.6.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 5, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'CONOP.2.6.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 6, '', 'FuncionarioCuentaBancaria', 'TES');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'CONOP.2.6.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 6, '', 'FuncionarioEspecialidad', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'CONOP.2.6.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 6, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CONOP.2.6.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'CONOP.2.6.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 7, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CONOP.2.6.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'CONOP.2.6.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'CONOP.2.6.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'CONOP.2.6.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 10, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'CONOP.2.6.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 10, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Prorrateo ...', 'Prorrateo ...', 'CONOP.4.1', 'no', 0, 'sis_tesoreria/vista/tipo_prorrateo/WizardProrrateo.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'CONOP.5.1', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Prorrateo', 'Prorrateo', 'CONOP.5.2', 'no', 0, 'sis_tesoreria/vista/prorrateo/Prorrateo.php', 4, '', 'Prorrateo', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'CONOP.5.3', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'CONOP.5.4', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', '../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'CONOP.5.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'CONOP.5.6', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'CONOP.5.7', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Cta Bancaria', 'Cta Bancaria', 'CONOP.11.1', 'no', 0, 'sis_parametros/vista/proveedor_cta_bancaria/ProveedorCtaBancaria.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'CONOP.11.2', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'CONOP.11.3', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'CONOP.11.4', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'CONOP.11.5', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CONOP.11.6', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'CONOP.11.7', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 4, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'CONOP.11.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 5, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Cambio de Apropiación', 'Cambio de Apropiación', 'VBPDC.1', 'no', 0, 'sis_tesoreria/vista/obligacion_pago/ObligacionPagoApropiacion.php', 3, '', '90%', 'TES');
select pxp.f_insert_tgui ('Prorrateo', 'Prorrateo', 'VBPDC.2', 'no', 0, 'sis_tesoreria/vista/prorrateo/Prorrateo.php', 3, '', '40%', 'TES');
select pxp.f_insert_tgui ('Chequeo de documentos de la solicitud', 'Chequeo de documentos de la solicitud', 'VBPDC.3', 'no', 0, 'sis_adquisiciones/vista/documento_sol/ChequeoDocumentoSol.php', 3, '', 'id_solicitud', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBPDC.4', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 3, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBPDC.5', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 3, '', '../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBPDC.6', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', '90%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBPDC.7', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 3, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBPDC.8', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 3, '', '80%', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'VBPDC.1.1', 'no', 0, 'sis_tesoreria/vista/obligacion_det/ObligacionDetApropiacion.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Reporte de Obligacion', 'Reporte de Obligacion', 'VBPDC.1.2', 'no', 0, 'sis_tesoreria/vista/obligacion_pago/ReporteComEjePag.php', 4, '', 'ReporteComEjePag', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'VBPDC.1.3', 'no', 0, 'sis_tesoreria/vista/obligacion_det/ObligacionDet.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Plan de Pagos', 'Plan de Pagos', 'VBPDC.1.4', 'no', 0, 'sis_tesoreria/vista/plan_pago/PlanPagoReq.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBPDC.1.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'VBPDC.1.6', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Evolución presupuestaria (', 'Evolución presupuestaria (', 'VBPDC.1.7', 'no', 0, 'sis_tesoreria/vista/presupuesto/CheckPresupuesto.php', 4, '', ')', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBPDC.1.8', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBPDC.1.9', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'VBPDC.1.10', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 4, '', 'proveedor', 'TES');
select pxp.f_insert_tgui ('Prorrateo ...', 'Prorrateo ...', 'VBPDC.1.1.1', 'no', 0, 'sis_tesoreria/vista/tipo_prorrateo/WizardProrrateo.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Prorrateo ...', 'Prorrateo ...', 'VBPDC.1.3.1', 'no', 0, 'sis_tesoreria/vista/tipo_prorrateo/WizardProrrateo.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'VBPDC.1.4.1', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 5, '', '80%', 'TES');
select pxp.f_insert_tgui ('Prorrateo', 'Prorrateo', 'VBPDC.1.4.2', 'no', 0, 'sis_tesoreria/vista/prorrateo/Prorrateo.php', 5, '', 'Prorrateo', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBPDC.1.4.3', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 5, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBPDC.1.4.4', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 5, '', '../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBPDC.1.4.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBPDC.1.4.6', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBPDC.1.4.7', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 5, '', '80%', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBPDC.1.4.4.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'VBPDC.1.4.4.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 7, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'VBPDC.1.4.4.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 7, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'VBPDC.1.4.4.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 7, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'VBPDC.1.4.4.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 7, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBPDC.1.4.4.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 7, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'VBPDC.1.4.4.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 8, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBPDC.1.4.4.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 9, '', '90%', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'VBPDC.1.4.7.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 6, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'VBPDC.1.4.7.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 7, '', 'FuncionarioCuentaBancaria', 'TES');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'VBPDC.1.4.7.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 7, '', 'FuncionarioEspecialidad', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBPDC.1.4.7.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 7, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBPDC.1.4.7.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBPDC.1.4.7.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 8, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBPDC.1.4.7.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBPDC.1.4.7.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBPDC.1.4.7.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 10, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'VBPDC.1.4.7.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 11, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'VBPDC.1.4.7.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 11, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Cta Bancaria', 'Cta Bancaria', 'VBPDC.1.10.1', 'no', 0, 'sis_parametros/vista/proveedor_cta_bancaria/ProveedorCtaBancaria.php', 5, '', '50%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBPDC.1.10.2', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 5, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBPDC.1.10.3', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 5, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBPDC.1.10.4', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBPDC.1.10.5', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 5, '', '80%', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBPDC.1.10.6', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBPDC.1.10.7', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 5, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBPDC.1.10.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 6, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'VBPDC.3.1', 'no', 0, 'sis_adquisiciones/vista/documento_sol/SubirArchivo.php', 4, '', 'SubirArchivo', 'TES');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'VBPDC.3.2', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 4, '', 'proveedor', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'OPUNI.1', 'no', 0, 'sis_tesoreria/vista/obligacion_det/ObligacionDet.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Plan de Pagos (Reg. Adq.)', 'Plan de Pagos (Reg. Adq.)', 'OPUNI.2', 'no', 0, 'sis_tesoreria/vista/plan_pago/PlanPagoRegIni.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Formulario de obligacion de pago único', 'Formulario de obligacion de pago único', 'OPUNI.3', 'no', 0, 'sis_tesoreria/vista/obligacion_pago/FormObligacion.php', 3, '', '90%', 'TES');
select pxp.f_insert_tgui ('Documentos del pago único', 'Documentos del pago único', 'OPUNI.4', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', '90%', 'TES');
select pxp.f_insert_tgui ('Reporte de Obligacion', 'Reporte de Obligacion', 'OPUNI.5', 'no', 0, 'sis_tesoreria/vista/obligacion_pago/ReporteComEjePag.php', 3, '', 'ReporteComEjePag', 'TES');
select pxp.f_insert_tgui ('Plan de Pagos', 'Plan de Pagos', 'OPUNI.6', 'no', 0, 'sis_tesoreria/vista/plan_pago/PlanPagoReq.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'OPUNI.7', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 3, '', '80%', 'TES');
select pxp.f_insert_tgui ('Evolución presupuestaria (', 'Evolución presupuestaria (', 'OPUNI.8', 'no', 0, 'sis_tesoreria/vista/presupuesto/CheckPresupuesto.php', 3, '', ')', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OPUNI.9', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 3, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'OPUNI.10', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 3, '', '80%', 'TES');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'OPUNI.11', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 3, '', 'proveedor', 'TES');
select pxp.f_insert_tgui ('Prorrateo ...', 'Prorrateo ...', 'OPUNI.1.1', 'no', 0, 'sis_tesoreria/vista/tipo_prorrateo/WizardProrrateo.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'OPUNI.2.1', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Prorrateo', 'Prorrateo', 'OPUNI.2.2', 'no', 0, 'sis_tesoreria/vista/prorrateo/Prorrateo.php', 4, '', 'Prorrateo', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OPUNI.2.3', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OPUNI.2.4', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', '../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'OPUNI.2.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'OPUNI.2.6', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'OPUNI.2.7', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'OPUNI.2.4.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'OPUNI.2.4.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'OPUNI.2.4.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'OPUNI.2.4.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'OPUNI.2.4.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'OPUNI.2.4.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'OPUNI.2.4.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'OPUNI.2.4.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'OPUNI.2.7.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 5, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'OPUNI.2.7.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 6, '', 'FuncionarioCuentaBancaria', 'TES');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'OPUNI.2.7.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 6, '', 'FuncionarioEspecialidad', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'OPUNI.2.7.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 6, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OPUNI.2.7.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'OPUNI.2.7.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 7, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OPUNI.2.7.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'OPUNI.2.7.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'OPUNI.2.7.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'OPUNI.2.7.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 10, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'OPUNI.2.7.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 10, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Documentos de la solicitu de compra', 'Documentos de la solicitu de compra', 'OPUNI.3.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'OPUNI.3.2', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 4, '', 'proveedor', 'TES');
select pxp.f_insert_tgui ('Cta Bancaria', 'Cta Bancaria', 'OPUNI.3.2.1', 'no', 0, 'sis_parametros/vista/proveedor_cta_bancaria/ProveedorCtaBancaria.php', 5, '', '50%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OPUNI.3.2.2', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 5, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OPUNI.3.2.3', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 5, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'OPUNI.3.2.4', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'OPUNI.3.2.5', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 5, '', '80%', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OPUNI.3.2.6', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'OPUNI.3.2.7', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 5, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'OPUNI.3.2.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 6, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'OPUNI.6.1', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Prorrateo', 'Prorrateo', 'OPUNI.6.2', 'no', 0, 'sis_tesoreria/vista/prorrateo/Prorrateo.php', 4, '', 'Prorrateo', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OPUNI.6.3', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OPUNI.6.4', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', '../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'OPUNI.6.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'OPUNI.6.6', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'OPUNI.6.7', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'VBOPOA.1', 'no', 0, 'sis_tesoreria/vista/obligacion_det/ObligacionDet.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Plan de Pagos (Reg. Adq.)', 'Plan de Pagos (Reg. Adq.)', 'VBOPOA.2', 'no', 0, 'sis_tesoreria/vista/plan_pago/PlanPagoRegIni.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Reporte de Obligacion', 'Reporte de Obligacion', 'VBOPOA.3', 'no', 0, 'sis_tesoreria/vista/obligacion_pago/ReporteComEjePag.php', 4, '', 'ReporteComEjePag', 'TES');
select pxp.f_insert_tgui ('Plan de Pagos', 'Plan de Pagos', 'VBOPOA.4', 'no', 0, 'sis_tesoreria/vista/plan_pago/PlanPagoReq.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBOPOA.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'VBOPOA.6', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Evolución presupuestaria (', 'Evolución presupuestaria (', 'VBOPOA.7', 'no', 0, 'sis_tesoreria/vista/presupuesto/CheckPresupuesto.php', 4, '', ')', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBOPOA.8', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBOPOA.9', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'VBOPOA.10', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 4, '', 'proveedor', 'TES');
select pxp.f_insert_tgui ('Prorrateo ...', 'Prorrateo ...', 'VBOPOA.1.1', 'no', 0, 'sis_tesoreria/vista/tipo_prorrateo/WizardProrrateo.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'VBOPOA.2.1', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 5, '', '80%', 'TES');
select pxp.f_insert_tgui ('Prorrateo', 'Prorrateo', 'VBOPOA.2.2', 'no', 0, 'sis_tesoreria/vista/prorrateo/Prorrateo.php', 5, '', 'Prorrateo', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBOPOA.2.3', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 5, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBOPOA.2.4', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 5, '', '../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBOPOA.2.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBOPOA.2.6', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBOPOA.2.7', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 5, '', '80%', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBOPOA.2.4.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'VBOPOA.2.4.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 7, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'VBOPOA.2.4.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 7, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'VBOPOA.2.4.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 7, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'VBOPOA.2.4.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 7, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBOPOA.2.4.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 7, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'VBOPOA.2.4.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 8, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBOPOA.2.4.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 9, '', '90%', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'VBOPOA.2.7.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 6, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'VBOPOA.2.7.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 7, '', 'FuncionarioCuentaBancaria', 'TES');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'VBOPOA.2.7.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 7, '', 'FuncionarioEspecialidad', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBOPOA.2.7.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 7, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBOPOA.2.7.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBOPOA.2.7.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 8, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBOPOA.2.7.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBOPOA.2.7.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBOPOA.2.7.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 10, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'VBOPOA.2.7.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 11, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'VBOPOA.2.7.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 11, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'VBOPOA.4.1', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 5, '', '80%', 'TES');
select pxp.f_insert_tgui ('Prorrateo', 'Prorrateo', 'VBOPOA.4.2', 'no', 0, 'sis_tesoreria/vista/prorrateo/Prorrateo.php', 5, '', 'Prorrateo', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBOPOA.4.3', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 5, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBOPOA.4.4', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 5, '', '../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBOPOA.4.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBOPOA.4.6', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBOPOA.4.7', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 5, '', '80%', 'TES');
select pxp.f_insert_tgui ('Cta Bancaria', 'Cta Bancaria', 'VBOPOA.10.1', 'no', 0, 'sis_parametros/vista/proveedor_cta_bancaria/ProveedorCtaBancaria.php', 5, '', '50%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBOPOA.10.2', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 5, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBOPOA.10.3', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 5, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBOPOA.10.4', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBOPOA.10.5', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 5, '', '80%', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBOPOA.10.6', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBOPOA.10.7', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 5, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBOPOA.10.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 6, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'REPPP.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 4, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'REPPP.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'REPPP.1.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'REPPP.1.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'REPPP.1.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'REPPP.1.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'REPPP.1.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Funcionario', 'Funcionario', 'SOLCAJA.3', 'no', 0, 'sis_tesoreria/vista/caja_funcionario/CajaFuncionario.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Solicitud Efectivo', 'Solicitud Efectivo', 'SOLCAJA.4', 'no', 0, 'sis_tesoreria/vista/solicitud_efectivo/SolicitudEfectivoCaja.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'SOLCAJA.3.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 4, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'SOLCAJA.3.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 5, '', 'FuncionarioCuentaBancaria', 'TES');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'SOLCAJA.3.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 5, '', 'FuncionarioEspecialidad', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'SOLCAJA.3.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 5, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLCAJA.3.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'SOLCAJA.3.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 6, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLCAJA.3.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'SOLCAJA.3.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 8, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'SOLCAJA.3.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 8, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'SOLCAJA.3.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 9, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'SOLCAJA.3.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 9, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'SOLCAJA.4.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Funcionario', 'Funcionario', 'VBCAJA.5', 'no', 0, 'sis_tesoreria/vista/caja_funcionario/CajaFuncionario.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Solicitud Efectivo', 'Solicitud Efectivo', 'VBCAJA.6', 'no', 0, 'sis_tesoreria/vista/solicitud_efectivo/SolicitudEfectivoCaja.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'VBCAJA.5.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 4, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'VBCAJA.5.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 5, '', 'FuncionarioCuentaBancaria', 'TES');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'VBCAJA.5.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 5, '', 'FuncionarioEspecialidad', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBCAJA.5.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 5, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBCAJA.5.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBCAJA.5.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 6, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBCAJA.5.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBCAJA.5.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 8, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBCAJA.5.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 8, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'VBCAJA.5.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 9, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'VBCAJA.5.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 9, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBCAJA.6.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'SOLEFE.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', '90%', 'TES');
select pxp.f_insert_tgui ('Facturas Rendidas', 'Facturas Rendidas', 'SOLEFE.6', 'no', 0, 'sis_tesoreria/vista/solicitud_rendicion_det/FacturasRendicion.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'SOLEFE.3.2', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'SOLEFE.3.2.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('RendicionEfectivoSolicitante', 'RendicionEfectivoSolicitante', 'SOLEFESD.3', 'no', 0, 'sis_tesoreria/vista/rendicion_efectivo/RendicionEfectivoSolicitante.php', 3, '', '95%', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'SOLEFESD.4', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', '90%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'SOLEFESD.5', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 3, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'SOLEFESD.1.2', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'SOLEFESD.1.2.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'SOLEFESD.1.2.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'SOLEFESD.1.2.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'SOLEFESD.1.2.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'SOLEFESD.1.2.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'SOLEFESD.1.2.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'SOLEFESD.1.2.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'SOLEFESD.1.2.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'TES');
select pxp.f_insert_tgui ('dev_factura', 'dev_factura', 'SOLEFESD.3.1', 'no', 0, '-south-0', 4, '', 'revision', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'SOLEFESD.3.2', 'no', 0, 'sis_tesoreria/vista/solicitud_rendicion_det/AprobacionFacturasSolicitante.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'SOLEFESD.3.3', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'SOLEFESD.3.4', 'no', 0, 'sis_tesoreria/vista/solicitud_rendicion_det/AprobacionFacturas.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Formulario de rendicion', 'Formulario de rendicion', 'SOLEFESD.3.2.1', 'no', 0, 'sis_tesoreria/vista/solicitud_rendicion_det/FormRendicion.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('DocConceptoCtaDoc', 'DocConceptoCtaDoc', 'SOLEFESD.3.2.2', 'no', 0, 'sis_contabilidad/vista/doc_concepto/DocConceptoCtaDoc.php', 5, '', '95%', 'TES');
select pxp.f_insert_tgui ('DocConceptoCtaDoc', 'DocConceptoCtaDoc', 'SOLEFESD.3.2.2.1', 'no', 0, 'sis_contabilidad/vista/doc_concepto/DocConceptoCtaDoc.php', 6, '', '95%', 'TES');
select pxp.f_insert_tgui ('Formulario de rendicion', 'Formulario de rendicion', 'SOLEFESD.3.4.1', 'no', 0, 'sis_tesoreria/vista/solicitud_rendicion_det/FormRendicion.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('DocConceptoCtaDoc', 'DocConceptoCtaDoc', 'SOLEFESD.3.4.2', 'no', 0, 'sis_contabilidad/vista/doc_concepto/DocConceptoCtaDoc.php', 5, '', '95%', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBSOLEFE.4', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', '90%', 'TES');
select pxp.f_insert_tgui ('Depositos', 'Depositos', 'VBRENCJ.4', 'no', 0, 'sis_tesoreria/vista/caja/CajaDeposito.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Corregir Importe Contable Deposito', 'Corregir Importe Contable Deposito', 'VBRENCJ.4.1', 'no', 0, 'sis_tesoreria/vista/deposito/FormImporteContableDeposito.php', 4, '', 'FormImporteContableDeposito', 'TES');
select pxp.f_insert_tgui ('Relacionar Deposito', 'Relacionar Deposito', 'VBRENCJ.4.2', 'no', 0, 'sis_tesoreria/vista/deposito/FormRelacionarDeposito.php', 4, '', 'FormRelacionarDeposito', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'REPPPBA.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'REPPPBA.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 5, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'REPPPBA.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'REPPPBA.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 5, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'REPPPBA.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 5, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'REPPPBA.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'REPPPBA.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 6, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'REPPPBA.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 7, '', '90%', 'TES');
select pxp.f_insert_tgui ('Cambio de Apropiación', 'Cambio de Apropiación', 'VBPCOS.1', 'no', 0, 'sis_tesoreria/vista/obligacion_pago/ObligacionPagoApropiacion.php', 3, '', '90%', 'TES');
select pxp.f_insert_tgui ('Prorrateo', 'Prorrateo', 'VBPCOS.2', 'no', 0, 'sis_tesoreria/vista/prorrateo/Prorrateo.php', 3, '', '40%', 'TES');
select pxp.f_insert_tgui ('Chequeo de documentos de la solicitud', 'Chequeo de documentos de la solicitud', 'VBPCOS.3', 'no', 0, 'sis_adquisiciones/vista/documento_sol/ChequeoDocumentoSol.php', 3, '', 'id_solicitud', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBPCOS.4', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 3, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBPCOS.5', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 3, '', '../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBPCOS.6', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', '90%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBPCOS.7', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 3, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBPCOS.8', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 3, '', '80%', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'VBPCOS.1.1', 'no', 0, 'sis_tesoreria/vista/obligacion_det/ObligacionDetApropiacion.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Reporte de Obligacion', 'Reporte de Obligacion', 'VBPCOS.1.2', 'no', 0, 'sis_tesoreria/vista/obligacion_pago/ReporteComEjePag.php', 4, '', 'ReporteComEjePag', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'VBPCOS.1.3', 'no', 0, 'sis_tesoreria/vista/obligacion_det/ObligacionDet.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Plan de Pagos', 'Plan de Pagos', 'VBPCOS.1.4', 'no', 0, 'sis_tesoreria/vista/plan_pago/PlanPagoReq.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBPCOS.1.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'VBPCOS.1.6', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Evolución presupuestaria (', 'Evolución presupuestaria (', 'VBPCOS.1.7', 'no', 0, 'sis_tesoreria/vista/presupuesto/CheckPresupuesto.php', 4, '', ')', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBPCOS.1.8', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBPCOS.1.9', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'TES');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'VBPCOS.1.10', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 4, '', 'proveedor', 'TES');
select pxp.f_insert_tgui ('Prorrateo ...', 'Prorrateo ...', 'VBPCOS.1.1.1', 'no', 0, 'sis_tesoreria/vista/tipo_prorrateo/WizardProrrateo.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Prorrateo ...', 'Prorrateo ...', 'VBPCOS.1.3.1', 'no', 0, 'sis_tesoreria/vista/tipo_prorrateo/WizardProrrateo.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'VBPCOS.1.4.1', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 5, '', '80%', 'TES');
select pxp.f_insert_tgui ('Prorrateo', 'Prorrateo', 'VBPCOS.1.4.2', 'no', 0, 'sis_tesoreria/vista/prorrateo/Prorrateo.php', 5, '', 'Prorrateo', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBPCOS.1.4.3', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 5, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBPCOS.1.4.4', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 5, '', '../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBPCOS.1.4.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBPCOS.1.4.6', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBPCOS.1.4.7', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 5, '', '80%', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBPCOS.1.4.4.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'VBPCOS.1.4.4.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 7, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'VBPCOS.1.4.4.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 7, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'VBPCOS.1.4.4.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 7, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'VBPCOS.1.4.4.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 7, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBPCOS.1.4.4.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 7, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'VBPCOS.1.4.4.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 8, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBPCOS.1.4.4.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 9, '', '90%', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'VBPCOS.1.4.7.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 6, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'VBPCOS.1.4.7.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 7, '', 'FuncionarioCuentaBancaria', 'TES');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'VBPCOS.1.4.7.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 7, '', 'FuncionarioEspecialidad', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBPCOS.1.4.7.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 7, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBPCOS.1.4.7.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBPCOS.1.4.7.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 8, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBPCOS.1.4.7.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBPCOS.1.4.7.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBPCOS.1.4.7.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 10, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'VBPCOS.1.4.7.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 11, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'VBPCOS.1.4.7.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 11, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Cta Bancaria', 'Cta Bancaria', 'VBPCOS.1.10.1', 'no', 0, 'sis_parametros/vista/proveedor_cta_bancaria/ProveedorCtaBancaria.php', 5, '', '50%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBPCOS.1.10.2', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 5, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBPCOS.1.10.3', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 5, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBPCOS.1.10.4', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBPCOS.1.10.5', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 5, '', '80%', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBPCOS.1.10.6', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBPCOS.1.10.7', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 5, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBPCOS.1.10.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 6, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'VBPCOS.3.1', 'no', 0, 'sis_adquisiciones/vista/documento_sol/SubirArchivo.php', 4, '', 'SubirArchivo', 'TES');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'VBPCOS.3.2', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 4, '', 'proveedor', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBCJ.1', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBCJ.2', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'VBCJ.3', 'no', 0, 'sis_tesoreria/vista/solicitud_rendicion_det/RendicionProcesoCaja.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Depositos', 'Depositos', 'VBCJ.4', 'no', 0, 'sis_tesoreria/vista/caja/CajaDeposito.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBCJ.2.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'VBCJ.2.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'VBCJ.2.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'VBCJ.2.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'VBCJ.2.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBCJ.2.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'VBCJ.2.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBCJ.2.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'TES');
select pxp.f_insert_tgui ('Corregir Importe Contable Deposito', 'Corregir Importe Contable Deposito', 'VBCJ.4.1', 'no', 0, 'sis_tesoreria/vista/deposito/FormImporteContableDeposito.php', 5, '', 'FormImporteContableDeposito', 'TES');
select pxp.f_insert_tgui ('Relacionar Deposito', 'Relacionar Deposito', 'VBCJ.4.2', 'no', 0, 'sis_tesoreria/vista/deposito/FormRelacionarDeposito.php', 5, '', 'FormRelacionarDeposito', 'TES');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'VBCP.1', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuestoRendicion.php', 4, '', 'ChkPresupuesto', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBCP.2', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBCP.3', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'VBCP.4', 'no', 0, 'sis_tesoreria/vista/solicitud_rendicion_det/RendicionProcesoCaja.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Depositos', 'Depositos', 'VBCP.5', 'no', 0, 'sis_tesoreria/vista/caja/CajaDeposito.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBCP.3.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'VBCP.3.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'VBCP.3.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'VBCP.3.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'VBCP.3.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBCP.3.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'VBCP.3.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBCP.3.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'TES');
select pxp.f_insert_tgui ('Corregir Importe Contable Deposito', 'Corregir Importe Contable Deposito', 'VBCP.5.1', 'no', 0, 'sis_tesoreria/vista/deposito/FormImporteContableDeposito.php', 5, '', 'FormImporteContableDeposito', 'TES');
select pxp.f_insert_tgui ('Relacionar Deposito', 'Relacionar Deposito', 'VBCP.5.2', 'no', 0, 'sis_tesoreria/vista/deposito/FormRelacionarDeposito.php', 5, '', 'FormRelacionarDeposito', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBFACREN.1', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'VBFACREN.2', 'no', 0, 'sis_tesoreria/vista/solicitud_rendicion_det/AprobacionFacturas.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBFACREN.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'VBFACREN.1.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'VBFACREN.1.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'VBFACREN.1.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'VBFACREN.1.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBFACREN.1.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'VBFACREN.1.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBFACREN.1.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'TES');
select pxp.f_insert_tgui ('Formulario de rendicion', 'Formulario de rendicion', 'VBFACREN.2.1', 'no', 0, 'sis_tesoreria/vista/solicitud_rendicion_det/FormRendicion.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('DocConceptoCtaDoc', 'DocConceptoCtaDoc', 'VBFACREN.2.2', 'no', 0, 'sis_contabilidad/vista/doc_concepto/DocConceptoCtaDoc.php', 5, '', '95%', 'TES');
select pxp.f_insert_tgui ('DocConceptoCtaDoc', 'DocConceptoCtaDoc', 'VBFACREN.2.2.1', 'no', 0, 'sis_contabilidad/vista/doc_concepto/DocConceptoCtaDoc.php', 6, '', '95%', 'TES');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'VBRENCJA.1', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 4, '', 'ChkPresupuesto', 'TES');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'VBRENCJA.2', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuestoRendicion.php', 4, '', 'ChkPresupuesto', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBRENCJA.3', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBRENCJA.4', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'VBRENCJA.5', 'no', 0, 'sis_tesoreria/vista/solicitud_rendicion_det/RendicionProcesoCaja.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Depositos', 'Depositos', 'VBRENCJA.6', 'no', 0, 'sis_tesoreria/vista/caja/CajaDeposito.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBRENCJA.4.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'VBRENCJA.4.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'VBRENCJA.4.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'VBRENCJA.4.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'VBRENCJA.4.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBRENCJA.4.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'VBRENCJA.4.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBRENCJA.4.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'TES');
select pxp.f_insert_tgui ('Corregir Importe Contable Deposito', 'Corregir Importe Contable Deposito', 'VBRENCJA.6.1', 'no', 0, 'sis_tesoreria/vista/deposito/FormImporteContableDeposito.php', 5, '', 'FormImporteContableDeposito', 'TES');
select pxp.f_insert_tgui ('Relacionar Deposito', 'Relacionar Deposito', 'VBRENCJA.6.2', 'no', 0, 'sis_tesoreria/vista/deposito/FormRelacionarDeposito.php', 5, '', 'FormRelacionarDeposito', 'TES');
select pxp.f_insert_tgui ('Configuraciones', 'Configuraciones', 'COFCAJA', 'si', 1, '', 3, '', '', 'TES');
select pxp.f_insert_tgui ('Ingresos de Caja', 'Ingreso de Caja', 'INGCAJ', 'si', 14, 'sis_tesoreria/vista/solicitud_efectivo/SolicitudIngreso.php', 3, '', 'SolicitudIngreso', 'TES');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'OBPG.12', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 3, '', 'ChkPresupuesto', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'OBPG.8.7.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 8, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OBPG.8.7.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'OBPG.8.7.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'OBPG.8.7.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 10, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'OBPG.8.7.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 11, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'OBPG.8.7.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 11, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'CTABAN.2.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 4, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CTABAN.2.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'CAJA.5.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 7, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CAJA.5.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'CAJA.5.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'CAJA.5.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'CAJA.5.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 10, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'CAJA.5.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 10, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'CAJA.6.2', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 4, '', 'ChkPresupuesto', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'CTABANE.3.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 4, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CTABANE.3.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'VBDP.6.11', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 4, '', 'ChkPresupuesto', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'VBDP.6.4.7.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 9, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBDP.6.4.7.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 10, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBDP.6.4.7.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 11, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBDP.6.4.7.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 11, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'VBDP.6.4.7.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 12, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'VBDP.6.4.7.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 12, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'SOLPD.11', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 3, '', 'ChkPresupuesto', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'SOLPD.2.7.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 8, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLPD.2.7.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'SOLPD.2.7.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'SOLPD.2.7.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 10, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'SOLPD.2.7.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 11, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'SOLPD.2.7.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 11, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'CTABANCEND.2.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 4, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CTABANCEND.2.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'CTABANCEND.2.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 6, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'CTABANCEND.2.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 6, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'CTABANCEND.2.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 7, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'CTABANCEND.2.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 7, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'REVBPP.2.2.4.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 7, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'REVBPP.2.2.4.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'REVBPP.2.2.4.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'REVBPP.2.2.4.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'REVBPP.2.2.4.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 10, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'REVBPP.2.2.4.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 10, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'VBOP.11', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 3, '', 'ChkPresupuesto', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'VBOP.2.7.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 8, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBOP.2.7.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBOP.2.7.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBOP.2.7.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 10, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'VBOP.2.7.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 11, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'VBOP.2.7.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 11, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'OPCONTA.11', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 3, '', 'ChkPresupuesto', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'OPCONTA.2.7.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 8, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OPCONTA.2.7.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'OPCONTA.2.7.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'OPCONTA.2.7.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 10, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'OPCONTA.2.7.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 11, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'OPCONTA.2.7.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 11, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'CONOP.12', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 3, '', 'ChkPresupuesto', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'CONOP.2.6.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 8, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CONOP.2.6.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'CONOP.2.6.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'CONOP.2.6.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 10, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'CONOP.2.6.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 11, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'CONOP.2.6.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 11, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'VBPDC.1.11', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 4, '', 'ChkPresupuesto', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'VBPDC.1.4.7.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 9, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBPDC.1.4.7.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 10, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBPDC.1.4.7.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 11, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBPDC.1.4.7.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 11, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'VBPDC.1.4.7.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 12, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'VBPDC.1.4.7.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 12, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'OPUNI.12', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 3, '', 'ChkPresupuesto', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'OPUNI.2.7.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 8, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OPUNI.2.7.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'OPUNI.2.7.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'OPUNI.2.7.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 10, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'OPUNI.2.7.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 11, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'OPUNI.2.7.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 11, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'VBOPOA.11', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 4, '', 'ChkPresupuesto', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'VBOPOA.2.7.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 9, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBOPOA.2.7.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 10, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBOPOA.2.7.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 11, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBOPOA.2.7.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 11, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'VBOPOA.2.7.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 12, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'VBOPOA.2.7.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 12, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'SOLCAJA.3.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 7, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLCAJA.3.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'SOLCAJA.3.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'SOLCAJA.3.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'SOLCAJA.3.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 10, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'SOLCAJA.3.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 10, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'SOLCAJA.4.2', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 4, '', 'ChkPresupuesto', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'VBCAJA.5.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 7, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBCAJA.5.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBCAJA.5.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBCAJA.5.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'VBCAJA.5.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 10, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'VBCAJA.5.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 10, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'VBCAJA.6.2', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 4, '', 'ChkPresupuesto', 'TES');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'VBPCOS.1.11', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 4, '', 'ChkPresupuesto', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'VBPCOS.1.4.7.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 9, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBPCOS.1.4.7.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 10, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBPCOS.1.4.7.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 11, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBPCOS.1.4.7.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 11, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'VBPCOS.1.4.7.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 12, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'VBPCOS.1.4.7.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 12, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Rendicion', 'Rendicion', 'INGCAJ.1', 'no', 0, 'sis_tesoreria/vista/solicitud_rendicion_det/SolicitudRendicionDet.php', 4, '', '95%', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'INGCAJ.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'INGCAJ.3', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'INGCAJ.4', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Formulario de rendicion', 'Formulario de rendicion', 'INGCAJ.1.1', 'no', 0, 'sis_tesoreria/vista/solicitud_rendicion_det/FormRendicion.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'INGCAJ.1.2', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 5, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'INGCAJ.1.2.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'INGCAJ.1.2.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 7, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'INGCAJ.1.2.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 7, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'INGCAJ.1.2.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 7, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'INGCAJ.1.2.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 7, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'INGCAJ.1.2.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 7, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'INGCAJ.1.2.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 8, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'INGCAJ.1.2.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 9, '', '90%', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'SOLEFESD.3.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBFACREN.3', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'SOLEFE.3.1.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 5, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'SOLEFE.3.1.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 6, '', 'FuncionarioCuentaBancaria', 'TES');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'SOLEFE.3.1.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 6, '', 'FuncionarioEspecialidad', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'SOLEFE.3.1.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 6, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLEFE.3.1.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'SOLEFE.3.1.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 7, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'SOLEFE.3.1.1.1.1.1', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 8, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLEFE.3.1.1.1.1.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLEFE.3.1.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'SOLEFE.3.1.1.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'SOLEFE.3.1.1.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 10, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'SOLEFE.3.1.1.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 11, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'SOLEFE.3.1.1.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 11, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'SOLEFESD.1.1.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 5, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'SOLEFESD.1.1.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 6, '', 'FuncionarioCuentaBancaria', 'TES');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'SOLEFESD.1.1.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 6, '', 'FuncionarioEspecialidad', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'SOLEFESD.1.1.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 6, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLEFESD.1.1.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'SOLEFESD.1.1.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 7, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'SOLEFESD.1.1.1.1.1.1', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 8, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLEFESD.1.1.1.1.1.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLEFESD.1.1.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'SOLEFESD.1.1.1.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'SOLEFESD.1.1.1.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 10, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'SOLEFESD.1.1.1.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 11, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'SOLEFESD.1.1.1.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 11, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'VBFACREN.2.1.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 6, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'VBFACREN.2.1.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 7, '', 'FuncionarioCuentaBancaria', 'TES');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'VBFACREN.2.1.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 7, '', 'FuncionarioEspecialidad', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBFACREN.2.1.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 7, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBFACREN.2.1.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBFACREN.2.1.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 8, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'VBFACREN.2.1.1.1.1.1', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 9, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBFACREN.2.1.1.1.1.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBFACREN.2.1.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 10, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBFACREN.2.1.1.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 11, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBFACREN.2.1.1.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 11, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'VBFACREN.2.1.1.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 12, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'VBFACREN.2.1.1.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 12, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'INGCAJ.1.1.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 6, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'INGCAJ.1.1.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 7, '', 'FuncionarioCuentaBancaria', 'TES');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'INGCAJ.1.1.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 7, '', 'FuncionarioEspecialidad', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'INGCAJ.1.1.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 7, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'INGCAJ.1.1.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'INGCAJ.1.1.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 8, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'INGCAJ.1.1.1.1.1.1', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 9, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'INGCAJ.1.1.1.1.1.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'INGCAJ.1.1.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 10, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'INGCAJ.1.1.1.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 11, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'INGCAJ.1.1.1.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 11, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'INGCAJ.1.1.1.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 12, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'INGCAJ.1.1.1.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 12, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Facturas/Recibos', 'Facturas/Recibos', 'OBPG.8.8', 'no', 0, 'sis_tesoreria/vista/plan_pago_doc_compra/PlanPagoDocCompra.php', 4, '', 'PlanPagoDocCompra', 'TES');
select pxp.f_insert_tgui ('90%', '90%', 'OBPG.8.8.1', 'no', 0, 'sis_contabilidad/vista/doc_compra_venta/FormCompraVentaCustom.php', 5, '', 'si', 'TES');
select pxp.f_insert_tgui ('90%', '90%', 'OBPG.8.8.2', 'no', 0, 'sis_contabilidad/vista/doc_compra_venta/FormCompraVenta.php', 5, '', 'si', 'TES');
select pxp.f_insert_tgui ('Generar comprobante', 'Generar comprobante', 'OBPG.8.8.3', 'no', 0, 'sis_contabilidad/vista/agrupador/WizardAgrupador.php', 5, '', '40%', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'OBPG.8.8.1.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 6, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'OBPG.8.8.1.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 7, '', 'FuncionarioCuentaBancaria', 'TES');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'OBPG.8.8.1.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 7, '', 'FuncionarioEspecialidad', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'OBPG.8.8.1.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 7, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OBPG.8.8.1.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'OBPG.8.8.1.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 8, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'OBPG.8.8.1.1.1.1.1', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 9, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OBPG.8.8.1.1.1.1.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OBPG.8.8.1.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 10, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'OBPG.8.8.1.1.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 11, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'OBPG.8.8.1.1.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 11, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'OBPG.8.8.1.1.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 12, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'OBPG.8.8.1.1.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 12, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'OBPG.8.8.2.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 6, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Generar comprobante', 'Generar comprobante', 'OBPG.8.8.3.1', 'no', 0, 'sis_contabilidad/vista/agrupador_doc/AgrupadorDoc.php', 6, '', '80%', 'TES');
select pxp.f_insert_tgui ('Facturas/Recibos', 'Facturas/Recibos', 'SOLPD.2.8', 'no', 0, 'sis_tesoreria/vista/plan_pago_doc_compra/PlanPagoDocCompra.php', 4, '', 'PlanPagoDocCompra', 'TES');
select pxp.f_insert_tgui ('90%', '90%', 'SOLPD.2.8.1', 'no', 0, 'sis_contabilidad/vista/doc_compra_venta/FormCompraVentaCustom.php', 5, '', 'si', 'TES');
select pxp.f_insert_tgui ('90%', '90%', 'SOLPD.2.8.2', 'no', 0, 'sis_contabilidad/vista/doc_compra_venta/FormCompraVenta.php', 5, '', 'si', 'TES');
select pxp.f_insert_tgui ('Generar comprobante', 'Generar comprobante', 'SOLPD.2.8.3', 'no', 0, 'sis_contabilidad/vista/agrupador/WizardAgrupador.php', 5, '', '40%', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'SOLPD.2.8.1.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 6, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'SOLPD.2.8.1.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 7, '', 'FuncionarioCuentaBancaria', 'TES');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'SOLPD.2.8.1.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 7, '', 'FuncionarioEspecialidad', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'SOLPD.2.8.1.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 7, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLPD.2.8.1.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'SOLPD.2.8.1.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 8, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'SOLPD.2.8.1.1.1.1.1', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 9, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLPD.2.8.1.1.1.1.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLPD.2.8.1.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 10, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'SOLPD.2.8.1.1.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 11, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'SOLPD.2.8.1.1.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 11, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'SOLPD.2.8.1.1.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 12, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'SOLPD.2.8.1.1.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 12, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'SOLPD.2.8.2.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 6, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Generar comprobante', 'Generar comprobante', 'SOLPD.2.8.3.1', 'no', 0, 'sis_contabilidad/vista/agrupador_doc/AgrupadorDoc.php', 6, '', '80%', 'TES');
select pxp.f_insert_tgui ('Facturas/Recibos', 'Facturas/Recibos', 'VBOP.2.8', 'no', 0, 'sis_tesoreria/vista/plan_pago_doc_compra/PlanPagoDocCompra.php', 4, '', 'PlanPagoDocCompra', 'TES');
select pxp.f_insert_tgui ('90%', '90%', 'VBOP.2.8.1', 'no', 0, 'sis_contabilidad/vista/doc_compra_venta/FormCompraVentaCustom.php', 5, '', 'si', 'TES');
select pxp.f_insert_tgui ('90%', '90%', 'VBOP.2.8.2', 'no', 0, 'sis_contabilidad/vista/doc_compra_venta/FormCompraVenta.php', 5, '', 'si', 'TES');
select pxp.f_insert_tgui ('Generar comprobante', 'Generar comprobante', 'VBOP.2.8.3', 'no', 0, 'sis_contabilidad/vista/agrupador/WizardAgrupador.php', 5, '', '40%', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'VBOP.2.8.1.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 6, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'VBOP.2.8.1.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 7, '', 'FuncionarioCuentaBancaria', 'TES');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'VBOP.2.8.1.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 7, '', 'FuncionarioEspecialidad', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBOP.2.8.1.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 7, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBOP.2.8.1.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBOP.2.8.1.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 8, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'VBOP.2.8.1.1.1.1.1', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 9, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBOP.2.8.1.1.1.1.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBOP.2.8.1.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 10, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBOP.2.8.1.1.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 11, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBOP.2.8.1.1.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 11, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'VBOP.2.8.1.1.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 12, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'VBOP.2.8.1.1.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 12, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'VBOP.2.8.2.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 6, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Generar comprobante', 'Generar comprobante', 'VBOP.2.8.3.1', 'no', 0, 'sis_contabilidad/vista/agrupador_doc/AgrupadorDoc.php', 6, '', '80%', 'TES');
select pxp.f_insert_tgui ('Facturas/Recibos', 'Facturas/Recibos', 'OPCONTA.2.8', 'no', 0, 'sis_tesoreria/vista/plan_pago_doc_compra/PlanPagoDocCompra.php', 4, '', 'PlanPagoDocCompra', 'TES');
select pxp.f_insert_tgui ('90%', '90%', 'OPCONTA.2.8.1', 'no', 0, 'sis_contabilidad/vista/doc_compra_venta/FormCompraVentaCustom.php', 5, '', 'si', 'TES');
select pxp.f_insert_tgui ('90%', '90%', 'OPCONTA.2.8.2', 'no', 0, 'sis_contabilidad/vista/doc_compra_venta/FormCompraVenta.php', 5, '', 'si', 'TES');
select pxp.f_insert_tgui ('Generar comprobante', 'Generar comprobante', 'OPCONTA.2.8.3', 'no', 0, 'sis_contabilidad/vista/agrupador/WizardAgrupador.php', 5, '', '40%', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'OPCONTA.2.8.1.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 6, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'OPCONTA.2.8.1.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 7, '', 'FuncionarioCuentaBancaria', 'TES');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'OPCONTA.2.8.1.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 7, '', 'FuncionarioEspecialidad', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'OPCONTA.2.8.1.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 7, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OPCONTA.2.8.1.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'OPCONTA.2.8.1.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 8, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'OPCONTA.2.8.1.1.1.1.1', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 9, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OPCONTA.2.8.1.1.1.1.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OPCONTA.2.8.1.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 10, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'OPCONTA.2.8.1.1.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 11, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'OPCONTA.2.8.1.1.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 11, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'OPCONTA.2.8.1.1.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 12, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'OPCONTA.2.8.1.1.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 12, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'OPCONTA.2.8.2.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 6, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Generar comprobante', 'Generar comprobante', 'OPCONTA.2.8.3.1', 'no', 0, 'sis_contabilidad/vista/agrupador_doc/AgrupadorDoc.php', 6, '', '80%', 'TES');
select pxp.f_insert_tgui ('Facturas/Recibos', 'Facturas/Recibos', 'OPUNI.2.8', 'no', 0, 'sis_tesoreria/vista/plan_pago_doc_compra/PlanPagoDocCompra.php', 4, '', 'PlanPagoDocCompra', 'TES');
select pxp.f_insert_tgui ('90%', '90%', 'OPUNI.2.8.1', 'no', 0, 'sis_contabilidad/vista/doc_compra_venta/FormCompraVentaCustom.php', 5, '', 'si', 'TES');
select pxp.f_insert_tgui ('90%', '90%', 'OPUNI.2.8.2', 'no', 0, 'sis_contabilidad/vista/doc_compra_venta/FormCompraVenta.php', 5, '', 'si', 'TES');
select pxp.f_insert_tgui ('Generar comprobante', 'Generar comprobante', 'OPUNI.2.8.3', 'no', 0, 'sis_contabilidad/vista/agrupador/WizardAgrupador.php', 5, '', '40%', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'OPUNI.2.8.1.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 6, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'OPUNI.2.8.1.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 7, '', 'FuncionarioCuentaBancaria', 'TES');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'OPUNI.2.8.1.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 7, '', 'FuncionarioEspecialidad', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'OPUNI.2.8.1.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 7, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OPUNI.2.8.1.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'OPUNI.2.8.1.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 8, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'OPUNI.2.8.1.1.1.1.1', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 9, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OPUNI.2.8.1.1.1.1.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OPUNI.2.8.1.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 10, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'OPUNI.2.8.1.1.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 11, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'OPUNI.2.8.1.1.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 11, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'OPUNI.2.8.1.1.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 12, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'OPUNI.2.8.1.1.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 12, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'OPUNI.2.8.2.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 6, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Generar comprobante', 'Generar comprobante', 'OPUNI.2.8.3.1', 'no', 0, 'sis_contabilidad/vista/agrupador_doc/AgrupadorDoc.php', 6, '', '80%', 'TES');
select pxp.f_insert_tgui ('Facturas/Recibos', 'Facturas/Recibos', 'VBOPOA.2.8', 'no', 0, 'sis_tesoreria/vista/plan_pago_doc_compra/PlanPagoDocCompra.php', 5, '', 'PlanPagoDocCompra', 'TES');
select pxp.f_insert_tgui ('90%', '90%', 'VBOPOA.2.8.1', 'no', 0, 'sis_contabilidad/vista/doc_compra_venta/FormCompraVentaCustom.php', 6, '', 'si', 'TES');
select pxp.f_insert_tgui ('90%', '90%', 'VBOPOA.2.8.2', 'no', 0, 'sis_contabilidad/vista/doc_compra_venta/FormCompraVenta.php', 6, '', 'si', 'TES');
select pxp.f_insert_tgui ('Generar comprobante', 'Generar comprobante', 'VBOPOA.2.8.3', 'no', 0, 'sis_contabilidad/vista/agrupador/WizardAgrupador.php', 6, '', '40%', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'VBOPOA.2.8.1.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 7, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'VBOPOA.2.8.1.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 8, '', 'FuncionarioCuentaBancaria', 'TES');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'VBOPOA.2.8.1.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 8, '', 'FuncionarioEspecialidad', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBOPOA.2.8.1.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 8, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBOPOA.2.8.1.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBOPOA.2.8.1.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 9, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'VBOPOA.2.8.1.1.1.1.1', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 10, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBOPOA.2.8.1.1.1.1.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 10, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBOPOA.2.8.1.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 11, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBOPOA.2.8.1.1.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 12, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBOPOA.2.8.1.1.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 12, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'VBOPOA.2.8.1.1.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 13, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'VBOPOA.2.8.1.1.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 13, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'VBOPOA.2.8.2.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 7, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Generar comprobante', 'Generar comprobante', 'VBOPOA.2.8.3.1', 'no', 0, 'sis_contabilidad/vista/agrupador_doc/AgrupadorDoc.php', 7, '', '80%', 'TES');
select pxp.f_delete_tgui ('CONOPT');
select pxp.f_insert_tgui ('Mes', 'Mes', 'CAJA.4.5', 'no', 0, 'sis_tesoreria/vista/proceso_caja/FormReporteCaja.php', 4, '', 'FormReporteCaja', 'TES');
select pxp.f_insert_tgui ('Mes', 'Mes', 'VBRENCJ.5', 'no', 0, 'sis_tesoreria/vista/proceso_caja/FormReporteCaja.php', 3, '', 'FormReporteCaja', 'TES');
select pxp.f_insert_tgui ('Mes', 'Mes', 'VBCJ.5', 'no', 0, 'sis_tesoreria/vista/proceso_caja/FormReporteCaja.php', 4, '', 'FormReporteCaja', 'TES');
select pxp.f_insert_tgui ('Mes', 'Mes', 'VBCP.6', 'no', 0, 'sis_tesoreria/vista/proceso_caja/FormReporteCaja.php', 4, '', 'FormReporteCaja', 'TES');
select pxp.f_insert_tgui ('Mes', 'Mes', 'VBRENCJA.7', 'no', 0, 'sis_tesoreria/vista/proceso_caja/FormReporteCaja.php', 4, '', 'FormReporteCaja', 'TES');
select pxp.f_insert_tgui ('Reportes', 'Reportes varios Caja', 'TESREPFR', 'si', 1, '', 2, '', '', 'TES');
select pxp.f_insert_tgui ('Movimiento de Caja', 'Reporte Movimiento de Caja', 'REPMOVCA', 'si', 14, 'sis_tesoreria/vista/reportes/RepMovimientoCaja.php', 2, '', 'RepMovimientoCaja', 'TES');
select pxp.f_insert_tgui ('Ingresos', 'Ingresos', 'CAJA.4.6', 'no', 0, 'sis_tesoreria/vista/solicitud_rendicion_det/Ingreso.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Ingresos', 'Ingresos', 'VBRENCJ.6', 'no', 0, 'sis_tesoreria/vista/solicitud_rendicion_det/Ingreso.php', 3, '', '50%', 'TES');
select pxp.f_insert_tgui ('Ingresos', 'Ingresos', 'VBCJ.6', 'no', 0, 'sis_tesoreria/vista/solicitud_rendicion_det/Ingreso.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Ingresos', 'Ingresos', 'VBCP.7', 'no', 0, 'sis_tesoreria/vista/solicitud_rendicion_det/Ingreso.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('Ingresos', 'Ingresos', 'VBRENCJA.8', 'no', 0, 'sis_tesoreria/vista/solicitud_rendicion_det/Ingreso.php', 4, '', '50%', 'TES');
select pxp.f_insert_tgui ('70%', '70%', 'REPMOVCA.1', 'no', 0, 'west', 3, '', 'Parámetros', 'TES');
select pxp.f_insert_tgui ('Solicitud de Transferencia', 'Solicitud de Transferencia', 'TESOLTRA', 'si', 4, 'sis_tesoreria/vista/solicitud_transferencia/SolicitudTransferencia.php', 3, '', 'SolicitudTransferencia', 'TES');
select pxp.f_insert_tgui ('Aprobacion Transferencia', 'Aprobacion Transferencia', 'TEAPROTRA', 'si', 0, 'sis_tesoreria/vista/solicitud_transferencia/SolicitudTransferenciaAprobacion.php', 4, '', 'SolicitudTransferenciaAprobacion', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'TESOLTRA.1', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'TESOLTRA.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'TESOLTRA.1.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'TESOLTRA.1.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'TESOLTRA.1.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'TESOLTRA.1.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'TESOLTRA.1.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'TESOLTRA.1.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'TESOLTRA.1.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'TEAPROTRA.1', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 5, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'TEAPROTRA.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'TEAPROTRA.1.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 7, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'TEAPROTRA.1.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 7, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'TEAPROTRA.1.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 7, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'TEAPROTRA.1.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 7, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'TEAPROTRA.1.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 7, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'TEAPROTRA.1.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 8, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'TEAPROTRA.1.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 9, '', '90%', 'TES');
select pxp.f_insert_tgui ('Reporte Libro Banco', 'Reporte Libro Banco', 'REPLIB', 'si', 9, 'sis_tesoreria/reportes/formularios/RepLibroBanco.php', 3, '', 'RepLibroBanco', 'TES');
select pxp.f_insert_tgui ('Solicitud de Pago (Sin presupuesto)', 'Pagos sin presupeusto', 'PAGESP', 'si', 5, 'sis_tesoreria/vista/obligacion_pago/ObligacionPagoEspecial.php', 4, '', 'ObligacionPagoEspecial', 'TES');
select pxp.f_insert_tgui ('Reporte de Caja Rango Fechas', 'Reporte de caja Rango Fechas', 'RCRF', 'si', 12, 'sis_tesoreria/reportes/formularios/RepCajaRango.php', 3, '', 'RepCajaRango', 'TES');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'PAGESP.1', 'no', 0, 'sis_tesoreria/vista/obligacion_det/ObligacionDet.php', 5, '', '50%', 'TES');
select pxp.f_insert_tgui ('Plan de Pagos (Reg. Adq.)', 'Plan de Pagos (Reg. Adq.)', 'PAGESP.2', 'no', 0, 'sis_tesoreria/vista/plan_pago/PlanPagoRegIni.php', 5, '', '50%', 'TES');
select pxp.f_insert_tgui ('Formulario de pagos especiales sin efecto presupuestario', 'Formulario de pagos especiales sin efecto presupuestario', 'PAGESP.3', 'no', 0, 'sis_tesoreria/vista/obligacion_pago/FormObligacionEspecial.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Documentos del pago especial', 'Documentos del pago especial', 'PAGESP.4', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'TES');
select pxp.f_insert_tgui ('Reporte de Obligacion', 'Reporte de Obligacion', 'PAGESP.5', 'no', 0, 'sis_tesoreria/vista/obligacion_pago/ReporteComEjePag.php', 5, '', 'ReporteComEjePag', 'TES');
select pxp.f_insert_tgui ('Plan de Pagos', 'Plan de Pagos', 'PAGESP.6', 'no', 0, 'sis_tesoreria/vista/plan_pago/PlanPagoReq.php', 5, '', '50%', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'PAGESP.7', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 5, '', '80%', 'TES');
select pxp.f_insert_tgui ('Evolución presupuestaria (', 'Evolución presupuestaria (', 'PAGESP.8', 'no', 0, 'sis_tesoreria/vista/presupuesto/CheckPresupuesto.php', 5, '', ')', 'TES');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'PAGESP.9', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 5, '', 'ChkPresupuesto', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'PAGESP.10', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 5, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'PAGESP.11', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 5, '', '80%', 'TES');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'PAGESP.12', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 5, '', 'proveedor', 'TES');
select pxp.f_insert_tgui ('Prorrateo ...', 'Prorrateo ...', 'PAGESP.1.1', 'no', 0, 'sis_tesoreria/vista/tipo_prorrateo/WizardProrrateo.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'PAGESP.2.1', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 6, '', '80%', 'TES');
select pxp.f_insert_tgui ('Prorrateo', 'Prorrateo', 'PAGESP.2.2', 'no', 0, 'sis_tesoreria/vista/prorrateo/Prorrateo.php', 6, '', 'Prorrateo', 'TES');
select pxp.f_insert_tgui ('Facturas/Recibos', 'Facturas/Recibos', 'PAGESP.2.3', 'no', 0, 'sis_tesoreria/vista/plan_pago_doc_compra/PlanPagoDocCompra.php', 6, '', 'PlanPagoDocCompra', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'PAGESP.2.4', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 6, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'PAGESP.2.5', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 6, '', '../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'PAGESP.2.6', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'PAGESP.2.7', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'PAGESP.2.8', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 6, '', '80%', 'TES');
select pxp.f_insert_tgui ('90%', '90%', 'PAGESP.2.3.1', 'no', 0, 'sis_contabilidad/vista/doc_compra_venta/FormCompraVentaCustom.php', 7, '', 'si', 'TES');
select pxp.f_insert_tgui ('90%', '90%', 'PAGESP.2.3.2', 'no', 0, 'sis_contabilidad/vista/doc_compra_venta/FormCompraVenta.php', 7, '', 'si', 'TES');
select pxp.f_insert_tgui ('Generar comprobante', 'Generar comprobante', 'PAGESP.2.3.3', 'no', 0, 'sis_contabilidad/vista/agrupador/WizardAgrupador.php', 7, '', '40%', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'PAGESP.2.3.1.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 8, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'PAGESP.2.3.1.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 9, '', 'FuncionarioCuentaBancaria', 'TES');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'PAGESP.2.3.1.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 9, '', 'FuncionarioEspecialidad', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'PAGESP.2.3.1.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'PAGESP.2.3.1.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'PAGESP.2.3.1.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 10, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'PAGESP.2.3.1.1.1.1.1', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 11, '', 'Persona Institucion', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'PAGESP.2.3.1.1.1.1.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 11, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'PAGESP.2.3.1.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 12, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'PAGESP.2.3.1.1.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 13, '', 'subirFotoPersona', 'TES');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'PAGESP.2.3.1.1.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 13, '', 'Archivo', 'TES');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'PAGESP.2.3.1.1.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 14, '', 'subirArchivo', 'TES');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'PAGESP.2.3.1.1.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 14, '', 'ArchivoHistorico', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'PAGESP.2.3.2.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 8, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Generar comprobante', 'Generar comprobante', 'PAGESP.2.3.3.1', 'no', 0, 'sis_contabilidad/vista/agrupador_doc/AgrupadorDoc.php', 8, '', '80%', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'PAGESP.2.5.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 7, '', '90%', 'TES');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'PAGESP.2.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 8, '', 'SubirArchivoWf', 'TES');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'PAGESP.2.5.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'TES');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'PAGESP.2.5.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 8, '', '30%', 'TES');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'PAGESP.2.5.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 8, '', '40%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'PAGESP.2.5.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 8, '', '90%', 'TES');
select pxp.f_insert_tgui ('73%', '73%', 'PAGESP.2.5.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 9, '', 'RepPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'PAGESP.2.5.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 10, '', '90%', 'TES');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'PAGESP.2.8.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 7, '', 'funcionario', 'TES');
select pxp.f_insert_tgui ('Documentos de la solicitu de compra', 'Documentos de la solicitu de compra', 'PAGESP.3.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'PAGESP.3.2', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 6, '', 'proveedor', 'TES');
select pxp.f_insert_tgui ('Cta Bancaria', 'Cta Bancaria', 'PAGESP.3.2.1', 'no', 0, 'sis_parametros/vista/proveedor_cta_bancaria/ProveedorCtaBancaria.php', 7, '', '50%', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'PAGESP.3.2.2', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 7, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'PAGESP.3.2.3', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 7, '', 'FormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'PAGESP.3.2.4', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 7, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'PAGESP.3.2.5', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 7, '', '80%', 'TES');
select pxp.f_insert_tgui ('Personas', 'Personas', 'PAGESP.3.2.6', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'PAGESP.3.2.7', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 7, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'PAGESP.3.2.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 8, '', 'Institucion', 'TES');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'PAGESP.6.1', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 6, '', '80%', 'TES');
select pxp.f_insert_tgui ('Prorrateo', 'Prorrateo', 'PAGESP.6.2', 'no', 0, 'sis_tesoreria/vista/prorrateo/Prorrateo.php', 6, '', 'Prorrateo', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'PAGESP.6.3', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 6, '', 'AntFormEstadoWf', 'TES');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'PAGESP.6.4', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 6, '', '../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago', 'TES');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'PAGESP.6.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'PAGESP.6.6', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'TES');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'PAGESP.6.7', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 6, '', '80%', 'TES');
select pxp.f_insert_tgui ('Rango de Fechas', 'Rango de Fechas', 'RERANFEC', 'no', 13, 'sis_tesoreria/reportes/formularios/RepMensualFechas.php', 3, '', 'RepMensualFechas', 'TES');




/***********************************F-DAT-RCM-TES-0-17/04/2018*****************************************/



