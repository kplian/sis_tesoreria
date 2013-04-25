-------------------------------------------
-- DEPARTAMENTOS DE TESORERIA
-----------------------------------------------

INSERT INTO param.tdepto ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_subsistema", "codigo", "nombre", "nombre_corto")
VALUES (1, NULL, E'2013-04-05 00:00:00', E'2013-04-05 06:20:20.098', E'activo', 11, E'TES-CEN', E'TEsoreria Central', E'');

INSERT INTO param.tdepto ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_subsistema", "codigo", "nombre", "nombre_corto")
VALUES (1, NULL, E'2013-04-05 00:00:00', E'2013-04-05 06:20:49.279', E'activo', 11, E'TES-ARG', E'Tesoreria Argentina', E'');

-------------------------------------------
-- INICIO ROLES 
-- Autor Gonzalo Sarmiento Sejas
------------------------------------------

--roles--

select pxp.f_insert_trol ('responsable de dar curso a la obligacion de pago', 'Responsable Obligacion de Pago', 'TES');

--roles_gui

select pxp.f_insert_tgui_rol ('OBPG', 'Responsable Obligacion de Pago');
select pxp.f_insert_tgui_rol ('TES', 'Responsable Obligacion de Pago');
select pxp.f_insert_tgui_rol ('OBPG.1', 'Responsable Obligacion de Pago');

--procedimientos_gui

select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_INS', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_MOD', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_ELI', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_FINREG_IME', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_ANTEOB_IME', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIG_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_ARB_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_ARB_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_AUXCTA_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_INS', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_MOD', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_ELI', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPPTO_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PAFPP_IME', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PLT_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_INS', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_MOD', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_ELI', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_MOD', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_INS', 'CTABAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_MOD', 'CTABAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_ELI', 'CTABAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_SEL', 'CTABAN', 'no');

--rol_procedimiento_gui

select pxp.f_insert_trol_procedimiento_gui ('Responsable Obligacion de Pago', 'TES_OBPG_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('Responsable Obligacion de Pago', 'TES_OBDET_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('Responsable Obligacion de Pago', 'PM_DEPPTO_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('Responsable Obligacion de Pago', 'PM_MONEDA_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('Responsable Obligacion de Pago', 'TES_OBPG_MOD', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('Responsable Obligacion de Pago', 'TES_OBDET_MOD', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('Responsable Obligacion de Pago', 'PM_PROVEEV_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('Responsable Obligacion de Pago', 'CONTA_CTA_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('Responsable Obligacion de Pago', 'PRE_PAR_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('Responsable Obligacion de Pago', 'CONTA_AUXCTA_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('Responsable Obligacion de Pago', 'TES_FINREG_IME', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('Responsable Obligacion de Pago', 'TES_PLAPA_SEL', 'OBPG');
select pxp.f_delete_trol_procedimiento_gui ('Responsable Obligacion de Pago', 'TES_PAFPP_IME', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('Responsable Obligacion de Pago', 'TES_PAFPP_IME', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('Responsable Obligacion de Pago', 'TES_PLAPA_INS', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('Responsable Obligacion de Pago', 'PM_PLT_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('Responsable Obligacion de Pago', 'TES_PRO_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('Responsable Obligacion de Pago', 'TES_PLAPA_MOD', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('Responsable Obligacion de Pago', 'TES_PLAPA_ELI', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('Responsable Obligacion de Pago', 'TES_PRO_MOD', 'OBPG');

-------------------------------------------
-- FIN ROLES 
-- Autor Gonzalo Sarmiento Sejas
------------------------------------------
