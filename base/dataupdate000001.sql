/********************************************I-DAUP-AUTOR-SCHEMA-0-31/02/2019********************************************/
--SHEMA : Esquema (CONTA) contabilidad         AUTHOR:Siglas del autor de los scripts' dataupdate000001.txt
/********************************************F-DAUP-AUTOR-SCHEMA-0-31/02/2019********************************************/



/********************************************I-DAUP-MGM-TES-1-06/01/2021********************************************/
--rollback
--UPDATE tes.tsolicitud_efectivo SET fecha='04/01/2021',fecha_ult_mov='06/01/2021',fecha_mod='06/01/2021 10:08:38' WHERE id_solicitud_efectivo=34242;
--commit
UPDATE tes.tsolicitud_efectivo SET fecha='31/12/2020',fecha_ult_mov='31/12/2020',fecha_mod='31/12/2020 10:08:38' WHERE id_solicitud_efectivo=34242;

/********************************************F-DAUP-MGM-TES-1-06/01/2021********************************************/


/********************************************I-DAUP-MGM-TES-ETR-3-04/01/2020********************************************/
--finalizado
--rollback
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1186135;
--commit
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1186135;

--rollback
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1159578;
--commit
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1159578;


--rollback
--UPDATE cd.tcuenta_doc SET estado='finalizado',id_estado_wf=1186135 WHERE id_cuenta_doc=30699;
--commit
UPDATE cd.tcuenta_doc SET estado='contabilizado',id_estado_wf=1159578 WHERE id_cuenta_doc=30699;

--rendido
--rollback
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1186134;
--commit
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1186134;

--rollback
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1165092;
--commit
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1165092;


--rollback
--UPDATE cd.tcuenta_doc SET estado='rendido',id_estado_wf=1186134,id_moneda_dev= 1,dev_saldo_original=371,id_int_comprobante_devrep = 104079,dev_saldo=371,dev_tipo='deposito',dev_a_favor_de='empresa' WHERE id_cuenta_doc=30860;
--commit
UPDATE cd.tcuenta_doc SET estado='vbtesoreria',id_estado_wf=1165092,id_moneda_dev= NULL,dev_saldo_original=NULL,id_int_comprobante_devrep = NULL,dev_saldo=NULL,dev_tipo=NULL,dev_a_favor_de=NULL WHERE id_cuenta_doc=30860;



/********************************************F-DAUP-MGM-TES-ETR-3-04/01/2020********************************************/



/********************************************I-DAUP-MGM-TES-ETR-3-04/01/2020********************************************/
--finalizado
--rollback
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1139373;
--commit
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1139373;

--rollback
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1106799;
--commit
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1106799;


--rollback
--UPDATE cd.tcuenta_doc SET estado='finalizado',id_estado_wf=1139373 WHERE id_cuenta_doc=28947;
--commit
UPDATE cd.tcuenta_doc SET estado='contabilizado',id_estado_wf=1106799 WHERE id_cuenta_doc=28947;

--rendido
--rollback
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1139372;
--commit
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1139372;

--rollback
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1137629;
--commit
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1137629;


--rollback
--UPDATE cd.tcuenta_doc SET estado='rendido',id_estado_wf=1139372,id_moneda_dev= 1,dev_saldo_original=271.97,id_int_comprobante_devrep = 99511,dev_saldo=271.97,dev_tipo='deposito',dev_a_favor_de='empresa',importe=2871.97 WHERE id_cuenta_doc=29953;
--commit
UPDATE cd.tcuenta_doc SET estado='vbtesoreria',id_estado_wf=1137629,id_moneda_dev= NULL,dev_saldo_original=NULL,id_int_comprobante_devrep = NULL,dev_saldo=NULL,dev_tipo=NULL,dev_a_favor_de=NULL WHERE id_cuenta_doc=29953;



/********************************************F-DAUP-MGM-TES-ETR-3-04/01/2020********************************************/


/********************************************I-DAUP-MGM-TES-ETR-1-20/01/2021********************************************/
--rollback
--UPDATE tes.tcajero SET fecha_fin=null WHERE id_funcionario=418;
--commit
UPDATE tes.tcajero SET fecha_fin='31/12/2022' WHERE id_funcionario=418;
/********************************************F-DAUP-MGM-TES-ETR-1-20/01/2021********************************************/


/********************************************I-DAUP-MGM-TES-ETR-1-20/01/2021********************************************/
--rollback
--UPDATE tes.tsolicitud_efectivo SET fecha_ult_mov='07/01/2020' WHERE id_solicitud_efectivo=34275;
--commit
UPDATE tes.tsolicitud_efectivo SET fecha_ult_mov='31/12/2022' WHERE id_solicitud_efectivo=34275;
/********************************************F-DAUP-MGM-TES-ETR-1-20/01/2021********************************************/


/********************************************I-DAUP-MGM-TES-ETR-2-20/01/2021********************************************/
--finalizado
--rollback
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1197390;
--commit
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1197390;

--rollback
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1166098;
--commit
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1166098;


--rollback
--UPDATE cd.tcuenta_doc SET estado='finalizado',id_estado_wf=1197390 WHERE id_cuenta_doc=30819;
--commit
UPDATE cd.tcuenta_doc SET estado='contabilizado',id_estado_wf=1166098 WHERE id_cuenta_doc=30819;

--rendido
--rollback
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1197389;
--commit
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1197389;

--rollback
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1190863;
--commit
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1190863;


--rollback
--UPDATE cd.tcuenta_doc SET estado='rendido',id_estado_wf=1197389,id_moneda_dev= 1,dev_saldo_original=4124.98,id_int_comprobante_devrep = null,dev_saldo=null,dev_tipo=null,dev_a_favor_de=null',importe=2429 WHERE id_cuenta_doc=32007;
--commit
UPDATE cd.tcuenta_doc SET estado='vbtesoreria',id_estado_wf=1190863,id_moneda_dev= NULL,dev_saldo_original=NULL,id_int_comprobante_devrep = NULL,dev_saldo=NULL,dev_tipo=NULL,dev_a_favor_de=NULL WHERE id_cuenta_doc=32007;




--finalizado
--rollback
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1197231;
--commit
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1197231;

--rollback
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1139379;
--commit
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1139379;


--rollback
--UPDATE cd.tcuenta_doc SET estado='finalizado',id_estado_wf=1197231 WHERE id_cuenta_doc=29775;
--commit
UPDATE cd.tcuenta_doc SET estado='contabilizado',id_estado_wf=1139379 WHERE id_cuenta_doc=29775;

--rendido
--rollback
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1197230;
--commit
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1197230;

--rollback
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1174678;
--commit
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1174678;


--rollback
--UPDATE cd.tcuenta_doc SET estado='rendido',id_estado_wf=1197230,id_moneda_dev= 1,dev_saldo_original=401.45,id_int_comprobante_devrep = null,dev_saldo=null,dev_tipo=null,dev_a_favor_de=null',importe=784.54 WHERE id_cuenta_doc=31357;
--commit
UPDATE cd.tcuenta_doc SET estado='vbtesoreria',id_estado_wf=1174678,id_moneda_dev= NULL,dev_saldo_original=NULL,id_int_comprobante_devrep = NULL,dev_saldo=NULL,dev_tipo=NULL,dev_a_favor_de=NULL WHERE id_cuenta_doc=31357;


/********************************************F-DAUP-MGM-TES-ETR-2-20/01/2021********************************************/
/********************************************I-DAUP-EGS-TES-ETR-2618-20/01/2021********************************************/
-- BEGIN;
-- Update tes.tobligacion_pago Set
--     id_obligacion_pago_extendida = 13204
-- Where id_obligacion_pago = 10935;
-- COMMIT;
BEGIN;
Update tes.tobligacion_pago Set
    id_obligacion_pago_extendida = null
Where id_obligacion_pago = 10935;
COMMIT;
/********************************************F-DAUP-EGS-TES-ETR-2618-20/01/2021********************************************/




/********************************************I-DAUP-MGM-TES-ETR-1-21/01/2021********************************************/
--rollback
--UPDATE tes.tsolicitud_efectivo SET fecha='07/01/2021',fecha_ult_mov='07/01/2021',fecha_mod='07/01/2021' WHERE id_solicitud_efectivo=34275;
--commit
UPDATE tes.tsolicitud_efectivo SET fecha='31/12/2020',fecha_ult_mov='31/12/2020',fecha_mod='31/12/2020' WHERE id_solicitud_efectivo=34275;
/********************************************F-DAUP-MGM-TES-ETR-1-21/01/2021********************************************/
/********************************************I-DAUP-EGS-TES-ETR-2674-25/01/2021********************************************/
--rollback
--UPDATE tes.tobligacion_pago SET
-- monto_ajuste_ret_anticipo_par_ga = 6926590.40
-- WHERE id_obligacion_pago = 14597;
--commit
UPDATE tes.tobligacion_pago SET
    monto_ajuste_ret_anticipo_par_ga = 674398.09
WHERE id_obligacion_pago = 14597;
/********************************************F-DAUP-MGM-TES-ETR-2674-25/01/2021********************************************/
/********************************************I-DAUP-EGS-TES-ETR-2830-04/02/2021********************************************/
--rollback
--UPDATE tes.tobligacion_pago SET
-- tipo_anticipo = 'si
-- WHERE id_obligacion_pago = 14806;
--commit
UPDATE tes.tobligacion_pago SET
    tipo_anticipo = 'no'
WHERE id_obligacion_pago = 14806;
/********************************************F-DAUP-MGM-TES-ETR-2830-04/02/2021********************************************/
/********************************************I-DAUP-EGS-TES-ETR-2829-04/02/2021********************************************/
--rollback
--UPDATE tes.tobligacion_pago SET
-- tipo_anticipo = 'si
-- WHERE id_obligacion_pago = 14812;
--commit
UPDATE tes.tobligacion_pago SET
    tipo_anticipo = 'no'
WHERE id_obligacion_pago = 14812;
/********************************************F-DAUP-EGS-TES-ETR-2829-04/02/2021********************************************/
/********************************************I-DAUP-EGS-TES-ETR-2956-12/02/2021********************************************/
--rollback
--UPDATE tes.tobligacion_pago SET
-- monto_ajuste_ret_anticipo_par_ga = 1984565.76
-- WHERE id_obligacion_pago = 14878;
--commit
UPDATE tes.tobligacion_pago SET
    monto_ajuste_ret_anticipo_par_ga = 319202.59
WHERE id_obligacion_pago = 14878;
/********************************************F-DAUP-EGS-TES-ETR-2956-12/02/2021********************************************/



/********************************************I-DAUP-MGM-TES-25/02/2021********************************************/
--rollback
--UPDATE tes.tsolicitud_rendicion_det SET id_proceso_caja=3020 WHERE id_solicitud_rendicion_det=23492;
--UPDATE tes.tsolicitud_rendicion_det SET id_proceso_caja=3020 WHERE id_solicitud_rendicion_det=23493;
--commit


UPDATE tes.tsolicitud_rendicion_det SET id_proceso_caja=3024 WHERE id_solicitud_rendicion_det=23492;
UPDATE tes.tsolicitud_rendicion_det SET id_proceso_caja=3024 WHERE id_solicitud_rendicion_det=23493;

--rollback
--UPDATE tes.tproceso_caja SET monto=1379.13 WHERE id_proceso_caja=3024;
--UPDATE tes.tproceso_caja SET monto=1980.9  WHERE id_proceso_caja=3020;
--commit

UPDATE tes.tproceso_caja SET monto=1733.03 WHERE id_proceso_caja=3024;
UPDATE tes.tproceso_caja SET monto=1627  WHERE id_proceso_caja=3020;

/********************************************F-DAUP-MGM-TES-25/02/2021********************************************/


/********************************************I-DAUP-MGM-TES-26/02/2021********************************************/

--rollback
--UPDATE cd.tcuenta_doc SET dev_saldo_original=34,dev_saldo=34,dev_nombre_cheque='JUAN GABRIEL AQUINO MERINO',dev_a_favor_de='funcionario',dev_tipo='cheque' WHERE id_cuenta_doc=32654;
--commit
UPDATE cd.tcuenta_doc SET dev_saldo_original=NULL,dev_saldo=null,dev_nombre_cheque=null,dev_a_favor_de=null,dev_tipo=null WHERE id_cuenta_doc=32654;

--rollback
--UPDATE cd.tcuenta_doc SET dev_saldo_original=34,dev_saldo=34,dev_nombre_cheque='JUAN VILLARROEL ZAMBRANA',dev_a_favor_de='funcionario',dev_tipo='cheque' WHERE id_cuenta_doc=32787;
--commit
UPDATE cd.tcuenta_doc SET dev_saldo_original=NULL,dev_saldo=null,dev_nombre_cheque=null,dev_a_favor_de=null,dev_tipo=null WHERE id_cuenta_doc=32787;

--rollback
--UPDATE cd.tcuenta_doc SET dev_saldo_original=1095.4,dev_saldo=1095.4,dev_nombre_cheque='DANIELA ROSSIO VALLEJOS',dev_a_favor_de='funcionario',dev_tipo='cheque' WHERE id_cuenta_doc=32792;
--commit
UPDATE cd.tcuenta_doc SET dev_saldo_original=NULL,dev_saldo=null,dev_nombre_cheque=null,dev_a_favor_de=null,dev_tipo=null WHERE id_cuenta_doc=32792;

--rollback
--UPDATE cd.tcuenta_doc SET dev_saldo_original=4283.42,dev_saldo=4283.42,dev_nombre_cheque='IVAN CRUZ MAMANI',dev_a_favor_de='funcionario',dev_tipo='cheque' WHERE id_cuenta_doc=33088;
--commit
UPDATE cd.tcuenta_doc SET dev_saldo_original=NULL,dev_saldo=null,dev_nombre_cheque=null,dev_a_favor_de=null,dev_tipo=null WHERE id_cuenta_doc=33088;

/********************************************F-DAUP-MGM-TES-26/02/2021********************************************/


/********************************************I-DAUP-MGM-TES-1-26/02/2021********************************************/

--rollback
--UPDATE tes.tsolicitud_efectivo SET monto=4011.02 WHERE id_solicitud_efectivo=35502; 
--commit

UPDATE tes.tsolicitud_efectivo SET monto=3761.02 WHERE id_solicitud_efectivo=35502;

/********************************************F-DAUP-MGM-TES-1-26/02/2021********************************************/
/********************************************I-DAUP-EGS-TES-ETR-5158-04/03/2021********************************************/
--Devengdo Rollback
-- BEGIN;
-- Update tes.tplan_pago Set
--       tipo = 'anticipo'
--       Where id_plan_pago = 40760;
-- COMMIT;
BEGIN;
Update tes.tplan_pago Set
      tipo = 'ant_parcial'
      Where id_plan_pago = 40760;
COMMIT;

--Devengdo Rollback
-- BEGIN;
-- Update tes.tplan_pago Set
--       tipo = 'anticipo'
--       Where id_plan_pago = 40752;
-- COMMIT;
BEGIN;
Update tes.tplan_pago Set
      tipo = 'ant_parcial'
      Where id_plan_pago = 40752;
COMMIT;
--Devengdo Rollback
-- BEGIN;
-- Update tes.tplan_pago Set
--       tipo = 'anticipo'
--       Where id_plan_pago = 40218;
-- COMMIT;
BEGIN;
Update tes.tplan_pago Set
      tipo = 'ant_parcial'
      Where id_plan_pago = 40218;
COMMIT;


/********************************************F-DAUP-EGS-TES-ETR-5158-04/03/2021********************************************/

/********************************************I-DAUP-EGS-TES-ETR-3195-05/03/2021********************************************/
--rollback
--UPDATE tes.tobligacion_pago SET
-- monto_ajuste_ret_anticipo_par_ga = 76547.18
-- WHERE id_obligacion_pago = 14820;
--commit
UPDATE tes.tobligacion_pago SET
    monto_ajuste_ret_anticipo_par_ga = 123966.62
WHERE id_obligacion_pago = 14820;
/********************************************F-DAUP-EGS-TES-ETR-3195-05/03/2021********************************************/
/********************************************I-DAUP-EGS-TES-ETR-3320-17/03/2021********************************************/
--pago Rollback
-- BEGIN;
-- Update tes.tplan_pago Set
-- descuento_anticipo = 548712.98,
-- liquido_pagable = 290812.95,
-- Where id_plan_pago = 41418;
-- COMMIT;
--Commit
BEGIN;
Update tes.tplan_pago Set
      descuento_anticipo = 167905.19,
      liquido_pagable = 671620.74
Where id_plan_pago = 41418;
COMMIT;
/********************************************F-DAUP-EGS-TES-ETR-3320-17/03/2021********************************************/

/********************************************I-DAUP-EGS-TES-ETR-3619-09/04/2021********************************************/

-- UPDATE tes.tplan_pago SET
-- id_plantilla =1
-- WHERE id_plan_pago = 42144;

BEGIN;
UPDATE tes.tplan_pago SET
    id_plantilla =49
WHERE id_plan_pago = 42144;
COMMIT;
/********************************************F-DAUP-EGS-TES-ETR-3619-09/04/2021********************************************/
/********************************************I-DAUP-EGS-TES-ETR-3619-01-09/04/2021********************************************/

-- UPDATE tes.tplan_pago SET
-- id_plantilla =1
-- WHERE id_plan_pago = 39438;

BEGIN;
UPDATE tes.tplan_pago SET
    id_plantilla =49
WHERE id_plan_pago = 39438;
COMMIT;
/********************************************F-DAUP-EGS-TES-ETR-3619-01-09/04/2021********************************************/
/********************************************I-DAUP-EGS-TES-ETR-3654-14/04/2021********************************************/
--rollback
--UPDATE tes.tobligacion_pago SET
-- monto_ajuste_ret_anticipo_par_ga = 1809502.3
-- WHERE id_obligacion_pago = 14754;
--commit
UPDATE tes.tobligacion_pago SET
    monto_ajuste_ret_anticipo_par_ga = 1558579.89
WHERE id_obligacion_pago = 14754;
/********************************************F-DAUP-EGS-TES-ETR-3654-14/04/2021********************************************/


/********************************************I-DAUP-MGM-TES-ETR-3612-15/04/2021********************************************/
--rollback
--UPDATE tes.tcajero SET estado='activo' WHERE id_caja=133;
--commit
UPDATE tes.tcajero SET estado='inactivo' WHERE id_caja=133;
/********************************************F-DAUP-MGM-TES-ETR-3612-15/04/2021********************************************/
/********************************************I-DAUP-MGM-TES-ETR-3761-02-26/04/2021********************************************/
--INSERT INTO tes.tsolicitud_rendicion_det ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "obs_dba", "id_solicitud_rendicion_det", "id_documento_respaldo", "id_solicitud_efectivo", "id_proceso_caja", "monto")VALUES (376, NULL, E'2021-04-23 13:26:49.050', NULL, E'activo', NULL, E'NULL', NULL, 24711, 224754, 37297, NULL, '1142');
DELETE FROM tes.tsolicitud_rendicion_det WHERE id_solicitud_rendicion_det=24711;
---
--UPDATE tes.tsolicitud_efectivo SET monto=1142 WHERE id_solicitud_efectivo= 37297;
UPDATE tes.tsolicitud_efectivo SET monto=0 WHERE id_solicitud_efectivo=37297;
---
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1325535;
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1325535;

--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1324676;
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1324676;

--UPDATE tes.tsolicitud_efectivo SET estado_reg='finalizado',id_estado_wf= 1325535 WHERE id_solicitud_efectivo=37271;
UPDATE tes.tsolicitud_efectivo SET estado_reg='activo',estado='vbcajero',id_estado_wf= 1324676 WHERE id_solicitud_efectivo=37271;
/********************************************F-DAUP-MGM-TES-ETR-3761-02-26/04/2021********************************************/
/********************************************I-DAUP-MGM-TES-ETR-3607-01-26/04/2021********************************************/
--vi383-2021
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf= 1311439;
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf= 1311439;
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf= 1280550;
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf= 1280550;
--UPDATE tes.tsolicitud_efectivo SET estado_reg='anulado',id_estado_wf= 1311439 WHERE id_solicitud_efectivo=35859;
UPDATE tes.tsolicitud_efectivo SET estado='vbcajero',id_estado_wf= 1280550 WHERE id_solicitud_efectivo=35859;
--vi804-2021
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf= 1311435;
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf= 1311435;
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf= 1309421;
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf= 1309421;
--UPDATE tes.tsolicitud_efectivo SET estado='anulado',id_estado_wf= 1311435 WHERE id_solicitud_efectivo=35859;
UPDATE tes.tsolicitud_efectivo SET estado='vbcajero',id_estado_wf= 1309421 WHERE id_solicitud_efectivo=36659;
/********************************************F-DAUP-MGM-TES-ETR-3607-01-26/04/2021********************************************/
/********************************************I-DAUP-MGM-TES-ETR-3607-02-26/04/2021********************************************/
--UPDATE wf.testado_wf SET id_funcionario=523 WHERE id_estado_wf=1324676;
UPDATE wf.testado_wf SET id_funcionario=350 WHERE id_estado_wf=1324676;
/********************************************F-DAUP-MGM-TES-ETR-3607-02-26/04/2021********************************************/
/********************************************I-DAUP-MGM-TES-ETR-3607-03-29/04/2021********************************************/
--UPDATE tes.tsolicitud_efectivo SET fecha_entregado_ult='23/04/2021' WHERE id_solicitud_efectivo=37271;
UPDATE tes.tsolicitud_efectivo
SET fecha_entregado_ult='26/04/2021'
WHERE id_solicitud_efectivo = 37271;
/********************************************F-DAUP-MGM-TES-ETR-3607-03-29/04/2021********************************************/
/********************************************I-DAUP-MGM-TES-ETR-3607-04-29/04/2021********************************************/
--UPDATE tes.tsolicitud_efectivo SET fecha_ult_mov='23/04/2021' WHERE id_solicitud_efectivo=37271;
UPDATE tes.tsolicitud_efectivo
SET fecha_ult_mov='26/04/2021'
WHERE id_solicitud_efectivo = 37271;
/********************************************F-DAUP-MGM-TES-ETR-3607-04-29/04/2021********************************************/


