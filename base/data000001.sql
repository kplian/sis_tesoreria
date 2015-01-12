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

/***********************************I-DAT-RCM-TES-0-24/12/2013*****************************************/

select pxp.f_insert_tgui ('Cuenta Bancaria ENDESIS', 'cuentas bancarias de la empresa', 'CTABANE', 'si', 2, 'sis_tesoreria/vista/cuenta_bancaria/CuentaBancariaESIS.php', 2, '', 'CuentaBancariaESIS', 'TES');
select pxp.f_insert_testructura_gui ('CTABANE', 'TES');

/***********************************F-DAT-RCM-TES-0-24/12/2013*****************************************/


/***********************************I-RAC-RCM-TES-0-03/02/2014*****************************************/

----------------------------------
--COPY LINES TO data.sql FILE  
---------------------------------

select pxp.f_insert_tgui ('MOD OLIGACIONES DE PAGO', '', 'TES', 'si', 6, '', 1, '', '', 'TES');
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
select pxp.f_insert_tgui ('Visto Bueno Dev/Pag', 'Visto bueno de Devengaso y/o Pagos', 'VBDP', 'si', 4, 'sis_tesoreria/vista/plan_pago/PlanPagoVb.php', 2, '', 'PlanPagoVb', 'TES');
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
select pxp.f_insert_tfuncion ('tes.f_conta_act_tran_plan_pago_dev', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_gestionar_cuota_plan_pago_eliminacion', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_gestionar_presupuesto_tesoreria', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_chequera_sel', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_prorrateo_plan_pago', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.ft_cajero_sel', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_finalizar_obligacion', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_chequera_ime', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.ft_cuenta_bancaria_mov_sel', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.ft_cuenta_bancaria_mov_ime', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_gestionar_cuota_plan_pago', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_tri_tcuenta_bancaria', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.ft_caja_sel', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.ft_cajero_ime', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_verificar_disponibilidad_presup_oblig_pago', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.ft_caja_ime', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_generar_comprobante', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tprocedimiento ('TES_PLAPA_INS', 'Insercion de cuotas de devengado en el plan de pago', 'si', '', '', 'tes.f_plan_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_PLAPA_MOD', 'Modificacion de cuotas de devegando y pago', 'si', '', '', 'tes.f_plan_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_PLAPAOB_SEL', 'Consulta de datos', 'si', '', '', 'tes.f_plan_pago_sel');
select pxp.f_insert_tprocedimiento ('TES_PLAPAREP_SEL', 'Consulta para reporte plan de pagos', 'si', '', '', 'tes.f_plan_pago_sel');
select pxp.f_insert_tprocedimiento ('TES_VERDIS_SEL', 'Consulta para verificar la disponibilidad presupuestaria de toda la cuota', 'si', '', '', 'tes.f_plan_pago_sel');
select pxp.f_insert_tprocedimiento ('TES_VERDIS_CONT', 'Conteo de registros', 'si', '', '', 'tes.f_plan_pago_sel');
select pxp.f_insert_tprocedimiento ('TES_CHQ_SEL', 'Consulta de datos', 'si', '', '', 'tes.f_chequera_sel');
select pxp.f_insert_tprocedimiento ('TES_CHQ_CONT', 'Conteo de registros', 'si', '', '', 'tes.f_chequera_sel');
select pxp.f_insert_tprocedimiento ('TES_CAJERO_SEL', 'Consulta de datos', 'si', '', '', 'tes.ft_cajero_sel');
select pxp.f_insert_tprocedimiento ('TES_CAJERO_CONT', 'Conteo de registros', 'si', '', '', 'tes.ft_cajero_sel');
select pxp.f_insert_tprocedimiento ('TES_CHQ_INS', 'Insercion de registros', 'si', '', '', 'tes.f_chequera_ime');
select pxp.f_insert_tprocedimiento ('TES_CHQ_MOD', 'Modificacion de registros', 'si', '', '', 'tes.f_chequera_ime');
select pxp.f_insert_tprocedimiento ('TES_CHQ_ELI', 'Eliminacion de registros', 'si', '', '', 'tes.f_chequera_ime');
select pxp.f_insert_tprocedimiento ('TES_CBANMO_SEL', 'Consulta de datos', 'si', '', '', 'tes.ft_cuenta_bancaria_mov_sel');
select pxp.f_insert_tprocedimiento ('TES_CBANMO_CONT', 'Conteo de registros', 'si', '', '', 'tes.ft_cuenta_bancaria_mov_sel');
select pxp.f_insert_tprocedimiento ('TES_CBANMO_INS', 'Insercion de registros', 'si', '', '', 'tes.ft_cuenta_bancaria_mov_ime');
select pxp.f_insert_tprocedimiento ('TES_CBANMO_MOD', 'Modificacion de registros', 'si', '', '', 'tes.ft_cuenta_bancaria_mov_ime');
select pxp.f_insert_tprocedimiento ('TES_CBANMO_ELI', 'Eliminacion de registros', 'si', '', '', 'tes.ft_cuenta_bancaria_mov_ime');
select pxp.f_insert_tprocedimiento ('TES_ESTOBPG_SEL', 'Consulta de registros para los reportes', 'si', '', '', 'tes.ft_obligacion_pago_sel');
select pxp.f_insert_tprocedimiento ('TES_OBPGSEL_SEL', 'Reporte de Obligacion Seleccionado', 'si', '', '', 'tes.ft_obligacion_pago_sel');
select pxp.f_insert_tprocedimiento ('TES_COMEJEPAG_SEL', 'Reporte de Comprometido Ejecutado Pagado', 'si', '', '', 'tes.ft_obligacion_pago_sel');
select pxp.f_insert_tprocedimiento ('TES_OBEPUO_IME', 'Obtener listado de up y ep correspondientes a los centros de costo
                    del detalle de la obligacion de pago', 'si', '', '', 'tes.ft_obligacion_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_IDSEXT_GET', 'Devuelve los IDS de otros sistemas (adquisiciones, etc.) a partir de la obligacion de pago', 'si', '', '', 'tes.ft_obligacion_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_CAJA_SEL', 'Consulta de datos', 'si', '', '', 'tes.ft_caja_sel');
select pxp.f_insert_tprocedimiento ('TES_CAJA_CONT', 'Conteo de registros', 'si', '', '', 'tes.ft_caja_sel');
select pxp.f_insert_tprocedimiento ('TES_CAJERO_INS', 'Insercion de registros', 'si', '', '', 'tes.ft_cajero_ime');
select pxp.f_insert_tprocedimiento ('TES_CAJERO_MOD', 'Modificacion de registros', 'si', '', '', 'tes.ft_cajero_ime');
select pxp.f_insert_tprocedimiento ('TES_CAJERO_ELI', 'Eliminacion de registros', 'si', '', '', 'tes.ft_cajero_ime');
select pxp.f_insert_tprocedimiento ('TES_PLAPAPA_INS', 'Insercion de cuotas de pagos en el plan de pago', 'si', '', '', 'tes.f_plan_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_SOLDEVPAG_IME', 'Solicitud de devengado o pago', 'si', '', '', 'tes.f_plan_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_SIGEPP_IME', 'funcion que controla el cambio al Siguiente esado de los planes de pago, integrado  con el EF', 'si', '', '', 'tes.f_plan_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_ANTEPP_IME', 'Trasaacion utilizada  pasar a  estados anterior en el plan de pagos
                    segun la operacion definida', 'si', '', '', 'tes.f_plan_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_SINPRE_IME', 'Incremeta el  presupuesto faltante para la cuota indicada del plan de pagos', 'si', '', '', 'tes.f_plan_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_CAJA_INS', 'Insercion de registros', 'si', '', '', 'tes.ft_caja_ime');
select pxp.f_insert_tprocedimiento ('TES_CAJA_MOD', 'Modificacion de registros', 'si', '', '', 'tes.ft_caja_ime');
select pxp.f_insert_tprocedimiento ('TES_CAJA_ELI', 'Eliminacion de registros', 'si', '', '', 'tes.ft_caja_ime');
select pxp.f_insert_trol ('Visto Bueno plan de pagos', 'OP - VoBo Plan de Pagos', 'TES');
select pxp.f_insert_trol ('Interface de Obligaciones de Pago, directamente sobre la interface de tesoreria', 'OP - Obligaciones de PAgo', 'TES');
select pxp.f_insert_testructura_gui ('OBPG.2', 'OBPG');
select pxp.f_insert_testructura_gui ('OBPG.3', 'OBPG');
select pxp.f_insert_testructura_gui ('OBPG.4', 'OBPG');
select pxp.f_insert_testructura_gui ('OBPG.5', 'OBPG');
select pxp.f_insert_testructura_gui ('OBPG.6', 'OBPG');
select pxp.f_insert_testructura_gui ('OBPG.7', 'OBPG');
select pxp.f_insert_testructura_gui ('OBPG.3.1', 'OBPG.3');
select pxp.f_insert_testructura_gui ('OBPG.3.2', 'OBPG.3');
select pxp.f_insert_testructura_gui ('OBPG.3.3', 'OBPG.3');
select pxp.f_insert_testructura_gui ('OBPG.3.3.1', 'OBPG.3.3');
select pxp.f_insert_testructura_gui ('OBPG.6.1', 'OBPG.6');
select pxp.f_insert_testructura_gui ('OBPG.6.2', 'OBPG.6');
select pxp.f_insert_testructura_gui ('OBPG.6.3', 'OBPG.6');
select pxp.f_insert_testructura_gui ('OBPG.6.2.1', 'OBPG.6.2');
select pxp.f_insert_testructura_gui ('OBPG.6.3.1', 'OBPG.6.3');
select pxp.f_insert_testructura_gui ('OBPG.7.1', 'OBPG.7');
select pxp.f_insert_testructura_gui ('OBPG.7.2', 'OBPG.7');
select pxp.f_insert_testructura_gui ('OBPG.7.1.1', 'OBPG.7.1');
select pxp.f_insert_testructura_gui ('CTABAN.1', 'CTABAN');
select pxp.f_insert_testructura_gui ('CTABAN.2', 'CTABAN');
select pxp.f_insert_testructura_gui ('CTABAN.2.1', 'CTABAN.2');
select pxp.f_insert_testructura_gui ('CTABAN.2.1.1', 'CTABAN.2.1');
select pxp.f_insert_testructura_gui ('CAJA.1', 'CAJA');
select pxp.f_insert_testructura_gui ('CTABANE.1', 'CTABANE');
select pxp.f_insert_testructura_gui ('CTABANE.2', 'CTABANE');
select pxp.f_insert_testructura_gui ('CTABANE.3', 'CTABANE');
select pxp.f_insert_testructura_gui ('CTABANE.3.1', 'CTABANE.3');
select pxp.f_insert_testructura_gui ('CTABANE.3.1.1', 'CTABANE.3.1');
select pxp.f_insert_testructura_gui ('VBDP', 'TES');
select pxp.f_insert_testructura_gui ('VBDP.1', 'VBDP');
select pxp.f_insert_testructura_gui ('VBDP.2', 'VBDP');
select pxp.f_insert_testructura_gui ('VBDP.3', 'VBDP');
select pxp.f_insert_testructura_gui ('VBDP.2.1', 'VBDP.2');
select pxp.f_insert_testructura_gui ('VBDP.2.2', 'VBDP.2');
select pxp.f_insert_testructura_gui ('VBDP.2.2.1', 'VBDP.2.2');
select pxp.f_insert_testructura_gui ('VBDP.2.2.2', 'VBDP.2.2');
select pxp.f_insert_testructura_gui ('VBDP.2.2.3', 'VBDP.2.2');
select pxp.f_insert_testructura_gui ('VBDP.2.2.2.1', 'VBDP.2.2.2');
select pxp.f_insert_testructura_gui ('VBDP.2.2.3.1', 'VBDP.2.2.3');
select pxp.f_insert_testructura_gui ('VBDP.3.1', 'VBDP.3');
select pxp.f_insert_tprocedimiento_gui ('WF_GATNREP_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_INS', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_MOD', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_ELI', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPGSEL_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAOB_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_OBTTCB_GET', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_FINREG_IME', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_ANTEOB_IME', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_IDSEXT_GET', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTOC_REP', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTREP_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROCPED_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTRPC_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPGSEL_SEL', 'OBPG.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_SEL', 'OBPG.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_COMEJEPAG_SEL', 'OBPG.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'OBPG.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIG_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPP_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_ARB_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_ARB_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_AUXCTA_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_INS', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_MOD', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_ELI', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PAFPP_IME', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PLT_SEL', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_SEL', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAPA_INS', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_INS', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_MOD', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_ELI', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_SEL', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SINPRE_IME', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SIGEPP_IME', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_ANTEPP_IME', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAREP_SEL', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_MOD', 'OBPG.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'OBPG.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'OBPG.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'OBPG.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'OBPG.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'OBPG.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'OBPG.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'OBPG.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'OBPG.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'OBPG.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'OBPG.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'OBPG.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'OBPG.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_INS', 'OBPG.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_MOD', 'OBPG.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_ELI', 'OBPG.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_SEL', 'OBPG.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'OBPG.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'OBPG.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPG.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'OBPG.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEM_SEL', 'OBPG.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'OBPG.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMALM_SEL', 'OBPG.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'OBPG.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_INS', 'OBPG.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_MOD', 'OBPG.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_ELI', 'OBPG.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_SEL', 'OBPG.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'OBPG.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'OBPG.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'OBPG.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPG.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'OBPG.6.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'OBPG.6.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'OBPG.6.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'OBPG.6.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'OBPG.6.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'OBPG.6.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPG.6.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'OBPG.6.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'OBPG.6.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'OBPG.6.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPG.6.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_INS', 'OBPG.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_MOD', 'OBPG.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_ELI', 'OBPG.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_SEL', 'OBPG.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'OBPG.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'OBPG.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPG.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_INS', 'OBPG.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_MOD', 'OBPG.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_ELI', 'OBPG.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_SEL', 'OBPG.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'OBPG.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'OBPG.7.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'OBPG.7.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'OBPG.7.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'OBPG.7.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'OBPG.7.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPG.7.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'OBPG.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'OBPG.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'OBPG.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPG.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_INS', 'CTABAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_MOD', 'CTABAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_ELI', 'CTABAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_SEL', 'CTABAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'CTABAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'CTABAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CHQ_INS', 'CTABAN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CHQ_MOD', 'CTABAN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CHQ_ELI', 'CTABAN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CHQ_SEL', 'CTABAN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'CTABAN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'CTABAN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'CTABAN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'CTABAN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'CTABAN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'CTABAN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'CTABAN.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'CTABAN.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'CTABAN.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'CTABAN.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'CTABAN.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'CAJA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPPTO_SEL', 'CAJA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'CAJA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILUSU_SEL', 'CAJA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILEPUO_SEL', 'CAJA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CAJA_INS', 'CAJA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CAJA_MOD', 'CAJA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CAJA_ELI', 'CAJA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CAJA_SEL', 'CAJA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CAJERO_INS', 'CAJA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CAJERO_MOD', 'CAJA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CAJERO_ELI', 'CAJA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CAJERO_SEL', 'CAJA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'CAJA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_INS', 'CTABANE', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_MOD', 'CTABANE', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_ELI', 'CTABANE', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_SEL', 'CTABANE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'CTABANE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'CTABANE', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CHQ_INS', 'CTABANE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CHQ_MOD', 'CTABANE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CHQ_ELI', 'CTABANE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CHQ_SEL', 'CTABANE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'CTABANE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'CTABANE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'CTABANE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'CTABANE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'CTABANE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'CTABANE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'CTABANE.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'CTABANE.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'CTABANE.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'CTABANE.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'CTABANE.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_IME', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTPROC_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_GETDEC_IME', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_SEL', 'OBPG.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_SEL', 'OBPG.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_GATNREP_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBEPUO_IME', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILEPUO_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SOLDEVPAG_IME', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_IDSEXT_GET', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTOC_REP', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTREP_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_IME', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROCPED_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTPROC_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTRPC_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PLT_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAPA_INS', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_INS', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_MOD', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_ELI', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SINPRE_IME', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SIGEPP_IME', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_ANTEPP_IME', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAREP_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_MOD', 'VBDP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'VBDP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_SEL', 'VBDP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOLAR_SEL', 'VBDP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_INS', 'VBDP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_MOD', 'VBDP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_ELI', 'VBDP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'VBDP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOLAR_MOD', 'VBDP.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'VBDP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'VBDP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'VBDP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'VBDP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_INS', 'VBDP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_MOD', 'VBDP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_ELI', 'VBDP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_SEL', 'VBDP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'VBDP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'VBDP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBDP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'VBDP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEM_SEL', 'VBDP.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'VBDP.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMALM_SEL', 'VBDP.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'VBDP.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_INS', 'VBDP.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_MOD', 'VBDP.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_ELI', 'VBDP.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_SEL', 'VBDP.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'VBDP.2.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'VBDP.2.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'VBDP.2.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBDP.2.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'VBDP.2.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'VBDP.2.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'VBDP.2.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'VBDP.2.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'VBDP.2.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'VBDP.2.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBDP.2.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'VBDP.2.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'VBDP.2.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'VBDP.2.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBDP.2.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'VBDP.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'VBDP.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'VBDP.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'VBDP.3.1', 'no');
select pxp.f_insert_tgui_rol ('VBDP', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('TES', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('VBDP.3', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('VBDP.3.1', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('VBDP.2', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('VBDP.2.2', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('VBDP.2.2.3', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('VBDP.2.2.3.1', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('VBDP.2.2.2', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('VBDP.2.2.2.1', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('VBDP.2.2.1', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('VBDP.2.1', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('VBDP.1', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('OBPG', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('TES', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.1', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.2', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.3', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.3.1', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.3.2', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.3.3', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.3.3.1', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.4', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.5', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.6', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.6.1', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.6.2', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.6.2.1', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.6.3', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.6.3.1', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.7', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.7.2', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.7.1', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.7.1.1', 'OP - Obligaciones de PAgo');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_GATNREP_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_OBEPUO_IME', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_DEPFILEPUO_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_SOLDEVPAG_IME', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_IDSEXT_GET', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_COTOC_REP', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_CTD_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_COTREP_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_SOLREP_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_SOLD_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_SOLDETCOT_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PRE_VERPRE_IME', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_PROCPED_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_COT_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_COTPROC_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_COTRPC_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_PLT_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_CTABAN_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_PLAPAPA_INS', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_PLAPA_INS', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_PLAPA_MOD', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_PLAPA_ELI', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_PLAPA_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_TIPES_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_FUNTIPES_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_SINPRE_IME', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_SIGEPP_IME', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_ANTEPP_IME', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_PLAPAREP_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_PRO_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_DWF_MOD', 'VBDP.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_DWF_ELI', 'VBDP.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_DWF_SEL', 'VBDP.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_DOCWFAR_MOD', 'VBDP.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_DOCSOL_SEL', 'VBDP.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_DOCSOLAR_SEL', 'VBDP.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_DOCSOL_INS', 'VBDP.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_DOCSOL_MOD', 'VBDP.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_DOCSOL_ELI', 'VBDP.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_PROVEEV_SEL', 'VBDP.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_SERVIC_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SAL_ITEMNOTBASE_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_LUG_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_LUG_ARB_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_PROVEE_INS', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_PROVEE_MOD', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_PROVEE_ELI', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_PROVEE_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_PROVEEV_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SEG_PERSON_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SEG_PERSONMIN_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_INSTIT_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_INSTIT_INS', 'VBDP.2.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_INSTIT_MOD', 'VBDP.2.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_INSTIT_ELI', 'VBDP.2.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_INSTIT_SEL', 'VBDP.2.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SEG_PERSON_SEL', 'VBDP.2.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SEG_PERSONMIN_SEL', 'VBDP.2.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SEG_PERSON_INS', 'VBDP.2.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SEG_PERSON_MOD', 'VBDP.2.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SEG_PERSON_ELI', 'VBDP.2.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SEG_PERSONMIN_SEL', 'VBDP.2.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SEG_PERSON_INS', 'VBDP.2.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SEG_PERSON_MOD', 'VBDP.2.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SEG_PERSON_ELI', 'VBDP.2.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SEG_PERSONMIN_SEL', 'VBDP.2.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SEG_UPFOTOPER_MOD', 'VBDP.2.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SAL_ITEM_SEL', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SAL_ITEMNOTBASE_SEL', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SAL_ITMALM_SEL', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_SERVIC_SEL', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_PRITSE_INS', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_PRITSE_MOD', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_PRITSE_ELI', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_PRITSE_SEL', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_DOCSOLAR_MOD', 'VBDP.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_PRO_MOD', 'VBDP.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_PRO_SEL', 'VBDP.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'WF_GATNREP_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_OBPG_INS', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_OBPG_MOD', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_OBPG_ELI', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_OBPG_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_OBPGSEL_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_PLAPAOB_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_OBTTCB_GET', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_FINREG_IME', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_ANTEOB_IME', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_IDSEXT_GET', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'ADQ_COTOC_REP', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'ADQ_CTD_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'ADQ_COTREP_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'ADQ_SOLREP_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'ADQ_SOLD_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'ADQ_SOLDETCOT_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'ADQ_PROCPED_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'ADQ_COT_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'ADQ_COTRPC_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_DEPUSUCOMB_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_MONEDA_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_PROVEEV_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'RH_FUNCIO_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'RH_FUNCIOCAR_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PRE_VERPRE_IME', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'ADQ_COTPROC_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_CCFILDEP_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_CONIG_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_CONIGPP_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'CONTA_CTA_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'CONTA_CTA_ARB_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PRE_PAR_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PRE_PAR_ARB_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'CONTA_AUXCTA_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_OBDET_INS', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_OBDET_MOD', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_OBDET_ELI', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_OBDET_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_CEC_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_CECCOM_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_CECCOMFU_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_OBPGSEL_SEL', 'OBPG.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_OBPG_SEL', 'OBPG.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_COMEJEPAG_SEL', 'OBPG.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_MONEDA_SEL', 'OBPG.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_PAFPP_IME', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_PLT_SEL', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_CTABAN_SEL', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_PLAPAPA_INS', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_PLAPA_INS', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_PLAPA_MOD', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_PLAPA_ELI', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_PLAPA_SEL', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'WF_TIPES_SEL', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'WF_FUNTIPES_SEL', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_SINPRE_IME', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_SIGEPP_IME', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_ANTEPP_IME', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_PLAPAREP_SEL', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_PRO_SEL', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'CONTA_GETDEC_IME', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PRE_VERPRE_SEL', 'OBPG.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_PRO_MOD', 'OBPG.3.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_PRO_SEL', 'OBPG.3.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'WF_DWF_MOD', 'OBPG.3.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'WF_DWF_ELI', 'OBPG.3.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'WF_DWF_SEL', 'OBPG.3.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'WF_DOCWFAR_MOD', 'OBPG.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'WF_DWF_MOD', 'OBPG.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'WF_DWF_ELI', 'OBPG.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'WF_DWF_SEL', 'OBPG.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PRE_VERPRE_SEL', 'OBPG.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_SERVIC_SEL', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SAL_ITEMNOTBASE_SEL', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_LUG_SEL', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_LUG_ARB_SEL', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_PROVEE_INS', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_PROVEE_MOD', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_PROVEE_ELI', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_PROVEE_SEL', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_PROVEEV_SEL', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSON_SEL', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSONMIN_SEL', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_INSTIT_SEL', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SAL_ITEM_SEL', 'OBPG.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SAL_ITEMNOTBASE_SEL', 'OBPG.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SAL_ITMALM_SEL', 'OBPG.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_SERVIC_SEL', 'OBPG.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_PRITSE_INS', 'OBPG.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_PRITSE_MOD', 'OBPG.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_PRITSE_ELI', 'OBPG.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_PRITSE_SEL', 'OBPG.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSON_INS', 'OBPG.6.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSON_MOD', 'OBPG.6.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSON_ELI', 'OBPG.6.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSONMIN_SEL', 'OBPG.6.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_UPFOTOPER_MOD', 'OBPG.6.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_INSTIT_INS', 'OBPG.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_INSTIT_MOD', 'OBPG.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_INSTIT_ELI', 'OBPG.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_INSTIT_SEL', 'OBPG.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSON_SEL', 'OBPG.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSONMIN_SEL', 'OBPG.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSON_INS', 'OBPG.6.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSON_MOD', 'OBPG.6.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSON_ELI', 'OBPG.6.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSONMIN_SEL', 'OBPG.6.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'RH_FUNCIO_INS', 'OBPG.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'RH_FUNCIO_MOD', 'OBPG.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'RH_FUNCIO_ELI', 'OBPG.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'RH_FUNCIO_SEL', 'OBPG.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'RH_FUNCIOCAR_SEL', 'OBPG.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSON_SEL', 'OBPG.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSONMIN_SEL', 'OBPG.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSON_INS', 'OBPG.7.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSON_MOD', 'OBPG.7.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSON_ELI', 'OBPG.7.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSONMIN_SEL', 'OBPG.7.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'OR_FUNCUE_INS', 'OBPG.7.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'OR_FUNCUE_MOD', 'OBPG.7.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'OR_FUNCUE_ELI', 'OBPG.7.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'OR_FUNCUE_SEL', 'OBPG.7.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_INSTIT_SEL', 'OBPG.7.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_INSTIT_INS', 'OBPG.7.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_INSTIT_MOD', 'OBPG.7.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_INSTIT_ELI', 'OBPG.7.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_INSTIT_SEL', 'OBPG.7.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSON_SEL', 'OBPG.7.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSONMIN_SEL', 'OBPG.7.1.1');


/***********************************F-RAC-RCM-TES-0-03/02/2014*****************************************/

/***********************************I-DAT-JRR-TES-0-24/04/2014*****************************************/
select pxp.f_insert_tgui ('MOD OLIGACIONES DE PAGO', '', 'TES', 'si', 6, '', 1, '', '', 'TES');
select pxp.f_insert_tgui ('Obligacion Pago', 'Obligaciones de pago', 'OBPG', 'si', 1, 'sis_tesoreria/vista/obligacion_pago/ObligacionPagoTes.php', 2, '', 'ObligacionPagoTes', 'TES');
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
select pxp.f_insert_tgui ('Visto Bueno Dev/Pag', 'Visto bueno de Devengaso y/o Pagos', 'VBDP', 'si', 4, 'sis_tesoreria/vista/plan_pago/PlanPagoVb.php', 2, '', 'PlanPagoVb', 'TES');
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
select pxp.f_insert_tfuncion ('tes.f_conta_act_tran_plan_pago_dev', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_gestionar_cuota_plan_pago_eliminacion', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_gestionar_presupuesto_tesoreria', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_chequera_sel', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_prorrateo_plan_pago', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.ft_cajero_sel', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_finalizar_obligacion', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_chequera_ime', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.ft_cuenta_bancaria_mov_sel', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.ft_cuenta_bancaria_mov_ime', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_gestionar_cuota_plan_pago', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_tri_tcuenta_bancaria', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.ft_caja_sel', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.ft_cajero_ime', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_verificar_disponibilidad_presup_oblig_pago', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.ft_caja_ime', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_generar_comprobante', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_inserta_plan_pago_dev', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tprocedimiento ('TES_PLAPA_INS', 'Insercion de cuotas de devengado en el plan de pago', 'si', '', '', 'tes.f_plan_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_PLAPA_MOD', 'Modificacion de cuotas de devegando y pago', 'si', '', '', 'tes.f_plan_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_PLAPAOB_SEL', 'Consulta de datos', 'si', '', '', 'tes.f_plan_pago_sel');
select pxp.f_insert_tprocedimiento ('TES_PLAPAREP_SEL', 'Consulta para reporte plan de pagos', 'si', '', '', 'tes.f_plan_pago_sel');
select pxp.f_insert_tprocedimiento ('TES_VERDIS_SEL', 'Consulta para verificar la disponibilidad presupuestaria de toda la cuota', 'si', '', '', 'tes.f_plan_pago_sel');
select pxp.f_insert_tprocedimiento ('TES_VERDIS_CONT', 'Conteo de registros', 'si', '', '', 'tes.f_plan_pago_sel');
select pxp.f_insert_tprocedimiento ('TES_CHQ_SEL', 'Consulta de datos', 'si', '', '', 'tes.f_chequera_sel');
select pxp.f_insert_tprocedimiento ('TES_CHQ_CONT', 'Conteo de registros', 'si', '', '', 'tes.f_chequera_sel');
select pxp.f_insert_tprocedimiento ('TES_CAJERO_SEL', 'Consulta de datos', 'si', '', '', 'tes.ft_cajero_sel');
select pxp.f_insert_tprocedimiento ('TES_CAJERO_CONT', 'Conteo de registros', 'si', '', '', 'tes.ft_cajero_sel');
select pxp.f_insert_tprocedimiento ('TES_CHQ_INS', 'Insercion de registros', 'si', '', '', 'tes.f_chequera_ime');
select pxp.f_insert_tprocedimiento ('TES_CHQ_MOD', 'Modificacion de registros', 'si', '', '', 'tes.f_chequera_ime');
select pxp.f_insert_tprocedimiento ('TES_CHQ_ELI', 'Eliminacion de registros', 'si', '', '', 'tes.f_chequera_ime');
select pxp.f_insert_tprocedimiento ('TES_CBANMO_SEL', 'Consulta de datos', 'si', '', '', 'tes.ft_cuenta_bancaria_mov_sel');
select pxp.f_insert_tprocedimiento ('TES_CBANMO_CONT', 'Conteo de registros', 'si', '', '', 'tes.ft_cuenta_bancaria_mov_sel');
select pxp.f_insert_tprocedimiento ('TES_CBANMO_INS', 'Insercion de registros', 'si', '', '', 'tes.ft_cuenta_bancaria_mov_ime');
select pxp.f_insert_tprocedimiento ('TES_CBANMO_MOD', 'Modificacion de registros', 'si', '', '', 'tes.ft_cuenta_bancaria_mov_ime');
select pxp.f_insert_tprocedimiento ('TES_CBANMO_ELI', 'Eliminacion de registros', 'si', '', '', 'tes.ft_cuenta_bancaria_mov_ime');
select pxp.f_insert_tprocedimiento ('TES_ESTOBPG_SEL', 'Consulta de registros para los reportes', 'si', '', '', 'tes.ft_obligacion_pago_sel');
select pxp.f_insert_tprocedimiento ('TES_OBPGSEL_SEL', 'Reporte de Obligacion Seleccionado', 'si', '', '', 'tes.ft_obligacion_pago_sel');
select pxp.f_insert_tprocedimiento ('TES_COMEJEPAG_SEL', 'Reporte de Comprometido Ejecutado Pagado', 'si', '', '', 'tes.ft_obligacion_pago_sel');
select pxp.f_insert_tprocedimiento ('TES_OBEPUO_IME', 'Obtener listado de up y ep correspondientes a los centros de costo
                    del detalle de la obligacion de pago', 'si', '', '', 'tes.ft_obligacion_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_IDSEXT_GET', 'Devuelve los IDS de otros sistemas (adquisiciones, etc.) a partir de la obligacion de pago', 'si', '', '', 'tes.ft_obligacion_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_CAJA_SEL', 'Consulta de datos', 'si', '', '', 'tes.ft_caja_sel');
select pxp.f_insert_tprocedimiento ('TES_CAJA_CONT', 'Conteo de registros', 'si', '', '', 'tes.ft_caja_sel');
select pxp.f_insert_tprocedimiento ('TES_CAJERO_INS', 'Insercion de registros', 'si', '', '', 'tes.ft_cajero_ime');
select pxp.f_insert_tprocedimiento ('TES_CAJERO_MOD', 'Modificacion de registros', 'si', '', '', 'tes.ft_cajero_ime');
select pxp.f_insert_tprocedimiento ('TES_CAJERO_ELI', 'Eliminacion de registros', 'si', '', '', 'tes.ft_cajero_ime');
select pxp.f_insert_tprocedimiento ('TES_PLAPAPA_INS', 'Insercion de cuotas de pagos en el plan de pago', 'si', '', '', 'tes.f_plan_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_SOLDEVPAG_IME', 'Solicitud de devengado o pago', 'si', '', '', 'tes.f_plan_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_SIGEPP_IME', 'funcion que controla el cambio al Siguiente esado de los planes de pago, integrado  con el EF', 'si', '', '', 'tes.f_plan_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_ANTEPP_IME', 'Trasaacion utilizada  pasar a  estados anterior en el plan de pagos
                    segun la operacion definida', 'si', '', '', 'tes.f_plan_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_SINPRE_IME', 'Incremeta el  presupuesto faltante para la cuota indicada del plan de pagos', 'si', '', '', 'tes.f_plan_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_CAJA_INS', 'Insercion de registros', 'si', '', '', 'tes.ft_caja_ime');
select pxp.f_insert_tprocedimiento ('TES_CAJA_MOD', 'Modificacion de registros', 'si', '', '', 'tes.ft_caja_ime');
select pxp.f_insert_tprocedimiento ('TES_CAJA_ELI', 'Eliminacion de registros', 'si', '', '', 'tes.ft_caja_ime');
select pxp.f_insert_tprocedimiento ('TES_SIGEPP_IME__bk', 'funcion que controla el cambio al Siguiente esado de los planes de pago, integrado  con el EF', 'si', '', '', 'tes.f_plan_pago_ime');
select pxp.f_insert_trol ('Visto Bueno plan de pagos', 'OP - VoBo Plan de Pagos', 'TES');
select pxp.f_insert_trol ('Interface de Obligaciones de Pago, directamente sobre la interface de tesoreria', 'OP - Obligaciones de PAgo', 'TES');
select pxp.f_insert_trol ('Pagos de servicios que no requieren proceso', 'OP - Pagos Directos de Servicios', 'TES');
select pxp.f_insert_trol ('Cierre de proceso con finalizacion de documentos', 'OP - Cierre de Proceso', 'TES');
select pxp.f_insert_trol ('Registro de Cuenta Bancaria', 'OP - Cuenta Bancaria', 'TES');

/***********************************F-DAT-JRR-TES-0-24/04/2014*****************************************/




/***********************************I-DAT-JRR-TES-0-12/05/2014*****************************************/




----------------------------------
--COPY LINES TO data.sql FILE  
---------------------------------

select pxp.f_insert_tgui ('Solicitudes de Obligaciones de pago', 'Solicitud de Pago Directos', 'SOLPD', 'si', 5, 'sis_tesoreria/vista/obligacion_pago/ObligacionPagoSol.php', 2, '', 'ObligacionPagoSol', 'TES');
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
select pxp.f_insert_tfuncion ('tes.f_trig_actualiza_informacion_estado_pp', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tprocedimiento ('TES_OBPGSOL_SEL', 'Consulta de obligaciones de pagos por solicitante', 'si', '', '', 'tes.ft_obligacion_pago_sel');
select pxp.f_insert_tprocedimiento ('TES_OBPGSOL_CONT', 'Conteo de registros', 'si', '', '', 'tes.ft_obligacion_pago_sel');
select pxp.f_insert_trol ('Solicitudes de Pago Directas', 'OP - Solicitudes de Pago Directas', 'TES');


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



/***********************************I-DAT-RAC-TES-0-1/08/2014*****************************************/
select pxp.f_insert_tgui ('Tipo Plan Pago', 'Configuracion de  tipos de Plan de Pago', 'TIPP', 'si', 6, 'sis_tesoreria/vista/tipo_plan_pago/TipoPlanPago.php', 2, '', 'TipoPlanPago', 'TES');
select pxp.f_insert_testructura_gui ('TIPP', 'TES');

/***********************************F-DAT-RAC-TES-0-1/08/2014*****************************************/


/***********************************I-DAT-GSS-TES-0-30/10/2014*****************************************/

select pxp.f_insert_tgui ('Libro Bancos', 'cuenta bancaria endesis', 'CTABANCEND', 'si', 4, 'sis_tesoreria/vista/cuenta_bancaria/CuentaBancariaENDESIS.php', 2, '', 'CuentaBancariaENDESIS', 'TES');
select pxp.f_insert_testructura_gui ('CTABANCEND', 'TES');

/***********************************F-DAT-GSS-TES-0-30/10/2014*****************************************/





/***********************************I-DAT-RAC-TES-0-27/11/2014*****************************************/

select pxp.f_insert_tgui ('Visto Bueno de Pagos', 'Visto bueno de Devengaso y/o Pagos', 'VBDP', 'si', 3, 'sis_tesoreria/vista/plan_pago/PlanPagoVb.php', 2, '', 'PlanPagoVb', 'TES');
select pxp.f_insert_tgui ('Aprobación de Fondos en Avance', 'Aprobación de Fondos en Avance', 'APFAENDE', 'no', 10, 'sis_tesoreria/vista/aprobacion_fondo_avance_endesis/AprobacionFondoAvanceEndesis.php', 2, '', 'AprobacionFondoAvanceEndesis', 'TES');
select pxp.f_insert_tgui ('Prorrateo ...', 'Prorrateo ...', 'OBPG.1.1', 'no', 0, 'sis_tesoreria/vista/tipo_prorrateo/WizardProrrateo.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Prorrateo ...', 'Prorrateo ...', 'SOLPD.1.1', 'no', 0, 'sis_tesoreria/vista/tipo_prorrateo/WizardProrrateo.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Revision de VoBo Pago (Asistentes)', 'Revision de VoBo Pago (Asistentes)', 'REVBPP', 'si', 3, 'sis_tesoreria/vista/plan_pago/PlanPagoVbAsistente.php', 2, '', 'PlanPagoVbAsistente', 'TES');
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
select pxp.f_insert_tgui ('VoBo Obligacion de Pago (Presupuestos)', 'VoBo Obligacion de Pago (Presupuestos)', 'VBOP', 'si', 2, 'sis_tesoreria/vista/obligacion_pago/ObligacionPagoVb.php', 2, '', 'ObligacionPagoVb', 'TES');
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
select pxp.f_insert_tgui ('Tipo Prorrateo', 'Tipo Prorrateo', 'TIPPRO', 'si', 5, 'sis_tesoreria/vista/tipo_prorrateo/TipoProrrateo.php', 2, '', 'TipoProrrateo', 'TES');
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
select pxp.f_insert_tgui ('Reportes', 'Reportes', 'REPOP', 'si', 10, '', 2, '', '', 'TES');
select pxp.f_insert_tgui ('Reporte Pagos X Concepto', 'Reporte Pagos X Concepto', 'REPPAGCON', 'si', 1, 'sis_tesoreria/reportes/formularios/PagosConcepto.php', 3, '', 'PagosConcepto', 'TES');
select pxp.f_insert_tgui ('Kardex por Item: ', 'Kardex por Item: ', 'REPPAGCON.1', 'no', 0, 'sis_tesoreria/reportes/grillas/PagosConceptoVista.php', 4, '', '90%', 'TES');
select pxp.f_insert_tgui ('Obligaciones de pago (Contabilidad)', 'Obligaciones de pago (Contabilidad)', 'OPCONTA', 'si', 8, 'sis_tesoreria/vista/obligacion_pago/ObligacionPagoConta.php', 2, '', 'ObligacionPagoConta', 'TES');
select pxp.f_insert_tgui ('Consulta Obligacion de Pago', 'Consulta Obligacion de Pago', 'CONOP', 'si', 7, 'sis_tesoreria/vista/obligacion_pago/ObligacionPagoConsulta.php', 2, '', 'ObligacionPagoConsulta', 'TES');
select pxp.f_insert_tfuncion ('tes.f_lista_funcionario_gerente_op_wf_sel', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_fun_inicio_plan_pago_wf', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_fun_regreso_plan_pago_wf', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_pagos_pendientes_ime', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tfuncion ('tes.f_pagos_pendientes_sel', 'Funcion para tabla     ', 'TES');
select pxp.f_insert_tprocedimiento ('TES_SIGEPP_IME', 'funcion que controla el cambio al Siguiente estado de los planes de pago, integrado  con el EF', 'si', '', '', 'tes.f_plan_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_TIPOEJE_UPD', 'Generación de algun tipo de prorrateo', 'si', '', '', 'tes.ft_tipo_prorrateo_ime');
select pxp.f_insert_tprocedimiento ('TES_REVPP_IME', 'Sirve cpara marcar como revisado o no revisado, sirve como un indicador  de que la documentacion fue revisada por el asistente', 'si', '', '', 'tes.f_plan_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_ACTCONFPP_SEL', 'Acta de Conformidad Maestro Plan de Pago', 'si', '', '', 'tes.f_plan_pago_sel');
select pxp.f_insert_tprocedimiento ('TES_GENCONF_IME', 'Actualiza los Datos del Acta de Conformidad', 'si', '', '', 'tes.f_plan_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_OBDETAPRO_MOD', 'Cambio en la apropacion de un detalle de obligacion', 'si', '', '', 'tes.ft_obligacion_det_ime');
select pxp.f_insert_tprocedimiento ('TES_PPPREV_INS', 'corre atravez de un crom que diariamente se lanza.  esta funcion busca los  pagos pendientes e inserta un alarma al funcionario correpondientes', 'si', '', '', 'tes.f_pagos_pendientes_ime');
select pxp.f_insert_tprocedimiento ('TES_PAGOPEN_SEL', 'Consulta de pagos pendientes a la fecha para envio de alertas y solicitudes automatica', 'si', '', '', 'tes.f_pagos_pendientes_sel');
select pxp.f_insert_tprocedimiento ('TES_OBLAJUS_IME', 'Inserta ajustes en la obligacion de pagos variables', 'si', '', '', 'tes.ft_obligacion_pago_ime');
select pxp.f_insert_tprocedimiento ('TES_PAXCIG_SEL', 'Listado de pagos por concepto', 'si', '', '', 'tes.f_plan_pago_sel');
select pxp.f_insert_tprocedimiento ('TES_PAXCIG_CONT', 'Conteo de pagos por concepto', 'si', '', '', 'tes.f_plan_pago_sel');
select pxp.f_insert_trol ('OP - VoBo Pago Contabilidad', 'OP - VoBo Pago Contabilidad', 'TES');
select pxp.f_insert_trol ('Visto buenos fondos en avances', 'OP -VoBo Fondos en Avance', 'TES');
select pxp.f_insert_trol ('OP - VoBo Ppagos (Asistentes)', 'OP - VoBo Ppagos (Asistentes)', 'TES');
select pxp.f_insert_trol ('Rol para consulta de obligacionens de pago, necesita estar en el departamento de contabilidad', 'OP - Plan de Pagos Consulta', 'TES');
select pxp.f_insert_trol ('OP - Reporte Pagos X Concepto', 'OP - Reporte Pagos X Concepto', 'TES');



/***********************************F-DAT-RAC-TES-0-27/11/2014*****************************************/


/***********************************I-DAT-RAC-TES-0-12/01/2015*****************************************/


select pxp.f_insert_tgui ('Visto Bueno de Pagos (Conta)', 'Visto Bueno de Pagos (Conta)', 'VBPDC', 'si', 3, 'sis_tesoreria/vista/plan_pago/PlanPagoVbConta.php', 2, '', 'PlanPagoVbConta', 'TES');
select pxp.f_insert_testructura_gui ('VBPDC', 'TES');


/***********************************F-DAT-RAC-TES-0-12/01/2015*****************************************/



