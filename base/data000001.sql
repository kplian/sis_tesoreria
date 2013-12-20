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
select pxp.f_insert_tgui ('Obligacion Pago', 'Obligaciones de pago', 'OBPG', 'si', 1, 'sis_tesoreria/vista/obligacion_pago/ObligacionPago.php', 2, '', 'ObligacionPago', 'TES');
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

select pxp.f_insert_tfuncion ('tes.f_plan_pago_ime', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_determinar_total_prorrateo_faltante', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_prorrateo_ime', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.ft_obligacion_det_ime', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.ft_obligacion_pago_ime', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_determinar_total_faltante', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.ft_obligacion_pago_sel', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_plan_pago_sel', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_prorrateo_sel', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.ft_obligacion_det_sel', 'Funcion para tabla     ', 'TES');


select pxp.f_insert_tprocedimiento ('TES_PLAPA_INS', 'Insercion de registros', 'si', '', '', 'tes.f_plan_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_PLAPA_MOD', 'Modificacion de registros', 'si', '', '', 'tes.f_plan_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_PLAPA_ELI', 'Eliminacion de registros', 'si', '', '', 'tes.f_plan_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_PRO_MOD', 'Modificacion de registros', 'si', '', '', 'tes.f_prorrateo_ime');
select pxp.f_insert_tprocedimiento ('TES_OBDET_INS', 'Insercion de registros', 'si', '', '', 'tes.ft_obligacion_det_ime');
select pxp.f_insert_tprocedimiento ('TES_OBDET_MOD', 'Modificacion de registros', 'si', '', '', 'tes.ft_obligacion_det_ime');
select pxp.f_insert_tprocedimiento ('TES_OBDET_ELI', 'Eliminacion de registros', 'si', '', '', 'tes.ft_obligacion_det_ime');
select pxp.f_insert_tprocedimiento ('TES_OBPG_INS', 'Insercion de registros', 'si', '', '', 'tes.ft_obligacion_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_OBPG_MOD', 'Modificacion de registros', 'si', '', '', 'tes.ft_obligacion_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_OBPG_ELI', 'Eliminacion de registros', 'si', '', '', 'tes.ft_obligacion_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_FINREG_IME', 'Finaliza el registro de obligacion de pago', 'si', '', '', 'tes.ft_obligacion_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_ANTEOB_IME', 'Retrocede estado de la obligacion', 'si', '', '', 'tes.ft_obligacion_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_PAFPP_IME', 'Calcula el restante por registrar, devengar o pagar  segun filtro', 'si', '', '', 'tes.ft_obligacion_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_OBPG_SEL', 'Consulta de datos', 'si', '', '', 'tes.ft_obligacion_pago_sel');
select pxp.f_insert_tprocedimiento ('TES_OBPG_CONT', 'Conteo de registros', 'si', '', '', 'tes.ft_obligacion_pago_sel');
select pxp.f_insert_tprocedimiento ('TES_PLAPA_SEL', 'Consulta de datos', 'si', '', '', 'tes.f_plan_pago_sel');
select pxp.f_insert_tprocedimiento ('TES_PLAPA_CONT', 'Conteo de registros', 'si', '', '', 'tes.f_plan_pago_sel');
select pxp.f_insert_tprocedimiento ('TES_PRO_SEL', 'Consulta de datos', 'si', '', '', 'tes.f_prorrateo_sel');
select pxp.f_insert_tprocedimiento ('TES_PRO_CONT', 'Conteo de registros', 'si', '', '', 'tes.f_prorrateo_sel');
select pxp.f_insert_tprocedimiento ('TES_OBDET_SEL', 'Consulta de datos', 'si', '', '', 'tes.ft_obligacion_det_sel');
select pxp.f_insert_tprocedimiento ('TES_OBDET_CONT', 'Conteo de registros', 'si', '', '', 'tes.ft_obligacion_det_sel');

/***********************************F-DAT-GSS-TES-101-22/04/2013*****************************************/

/***********************************I-DAT-GSS-TES-121-24/04/2013*****************************************/

select pxp.f_insert_tgui ('Cuenta Bancaria', 'cuentas bancarias de la empresa', 'CTABAN', 'si', 2, 'sis_tesoreria/vista/cuenta_bancaria/CuentaBancaria.php', 2, '', 'CuentaBancaria', 'TES');
select pxp.f_insert_tfuncion ('tes.f_cuenta_bancaria_ime', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_cuenta_bancaria_sel', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tprocedimiento ('TES_CTABAN_INS', 'Insercion de registros', 'si', '', '', 'tes.f_cuenta_bancaria_ime');
select pxp.f_insert_tprocedimiento ('TES_CTABAN_MOD', 'Modificacion de registros', 'si', '', '', 'tes.f_cuenta_bancaria_ime');
select pxp.f_insert_tprocedimiento ('TES_CTABAN_ELI', 'Eliminacion de registros', 'si', '', '', 'tes.f_cuenta_bancaria_ime');
select pxp.f_insert_tprocedimiento ('TES_CTABAN_SEL', 'Consulta de datos', 'si', '', '', 'tes.f_cuenta_bancaria_sel');
select pxp.f_insert_tprocedimiento ('TES_CTABAN_CONT', 'Conteo de registros', 'si', '', '', 'tes.f_cuenta_bancaria_sel');

select pxp.f_insert_testructura_gui ('CTABAN', 'TES');

/***********************************F-DAT-GSS-TES-121-24/04/2013*****************************************/



/***********************************I-DAT-ECR-TES-0-16/12/2013*****************************************/
select pxp.f_insert_tgui ('Caja', 'Caja', 'CAJA', 'si', 1, 'sis_tesoreria/vista/caja/Caja.php', 2, '', 'Caja', 'TES');
select pxp.f_insert_testructura_gui ('CAJA', 'TES');
/***********************************F-DAT-ECR-TES-0-16/12/2013*****************************************/
