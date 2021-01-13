/********************************************I-DAUP-AUTOR-SCHEMA-0-31/02/2019********************************************/
--SHEMA : Esquema (CONTA) contabilidad         AUTHOR:Siglas del autor de los scripts' dataupdate000001.txt
/********************************************F-DAUP-AUTOR-SCHEMA-0-31/02/2019********************************************/



/********************************************I-DAUP-MGM-TES-0-30/09/2020********************************************/
--rollback
--UPDATE tes.tsolicitud_efectivo SET monto=197.34 WHERE id_solicitud_efectivo =32300;
--commit
UPDATE tes.tsolicitud_efectivo SET monto=0 WHERE id_solicitud_efectivo =32300;

--rollback
---UPDATE tes.tsolicitud_efectivo SET monto=1578.76 WHERE id_solicitud_efectivo =32297;
--commit
UPDATE tes.tsolicitud_efectivo SET monto=1776.10 WHERE id_solicitud_efectivo =32297;
/********************************************F-DAUP-MGM-TES-0-30/09/2020********************************************/


/********************************************I-DAUP-MGM-TES-1-30/09/2020********************************************/
--rollback
--UPDATE tes.tsolicitud_rendicion_det SET monto=1578.76 WHERE id_solicitud_efectivo =21617;
--commit
UPDATE tes.tsolicitud_rendicion_det SET monto=1776.10 WHERE id_solicitud_efectivo =21617;

/********************************************F-DAUP-MGM-TES-1-30/09/2020********************************************/

/********************************************I-DAUP-MGM-TES-2-30/09/2020********************************************/
--rollback
--UPDATE tes.tsolicitud_rendicion_det SET monto=1578.76 WHERE id_solicitud_rendicion_det =21617;
--commit
UPDATE tes.tsolicitud_rendicion_det SET monto=1776.10 WHERE id_solicitud_rendicion_det =21617;

--rollback
--UPDATE tes.tsolicitud_rendicion_det SET monto=1776.10 WHERE id_solicitud_efectivo =21617;
--commit
UPDATE tes.tsolicitud_rendicion_det SET monto=1578.76 WHERE id_solicitud_efectivo =21617;


/********************************************F-DAUP-MGM-TES-2-30/09/2020********************************************/

/********************************************I-DAUP-EGS-TES-2-02/10/2020********************************************/
--Devengdo Rollback
-- BEGIN;
-- Update tes.tplan_pago Set
-- monto_retgar_mo = 0,
-- liquido_pagable = 29164
-- Where id_plan_pago = 16629;
-- COMMIT;
--Commit
BEGIN;
Update tes.tplan_pago Set
monto_retgar_mo = 2041.48,
liquido_pagable = 27122.52
Where id_plan_pago = 16629;
COMMIT;

--Roolback de Pago
-- BEGIN;
-- UPDATE tes.tplan_pago SET
-- otros_descuentos =  2041.48,
-- monto_retgar_mo = 0
-- WHERE id_plan_pago = 16659;
-- COMMIT;
--Commit
BEGIN;
UPDATE tes.tplan_pago SET
otros_descuentos = 0,
monto_retgar_mo = 2041.48
WHERE id_plan_pago = 16659;
COMMIT;
/********************************************F-DAUP-EGS-TES-2-02/10/2020********************************************/

/********************************************I-DAUP-MGM-TES-2-05/10/2020********************************************/
BEGIN;
--elimina los concepto, NO GENERARON REGISTRO PARTIDA-EJEC
delete from conta.tdoc_concepto where id_doc_compra_venta = 182532;
delete from conta.tdoc_concepto where id_doc_compra_venta = 182533;
delete from conta.tdoc_concepto where id_doc_compra_venta = 182534;
delete from conta.tdoc_concepto where id_doc_compra_venta = 182535;
--elimina los respaldos
delete from tes.tsolicitud_rendicion_det where id_documento_respaldo=182532;
delete from tes.tsolicitud_rendicion_det where id_documento_respaldo=182533;
delete from tes.tsolicitud_rendicion_det where id_documento_respaldo=182534;
delete from tes.tsolicitud_rendicion_det where id_documento_respaldo=182535;
--elimina los documentos creados
delete from conta.tdoc_compra_venta where id_doc_compra_venta = 182532; 
delete from conta.tdoc_compra_venta where id_doc_compra_venta = 182533;
delete from conta.tdoc_compra_venta where id_doc_compra_venta = 182534;
delete from conta.tdoc_compra_venta where id_doc_compra_venta = 182535;
--solicitud efectivo, quitan esas solicitudes
delete from tes.tsolicitud_efectivo where id_solicitud_efectivo= 32336;
delete from tes.tsolicitud_efectivo where id_solicitud_efectivo= 32249;
COMMIT;
/********************************************F-DAUP-MGM-TES-2-05/10/2020********************************************/
/********************************************I-DAUP-MGM-TES-3-12/10/2020********************************************/

--BEGIN;
--UPDATE tes.tsolicitud_efectivo SET fecha='07/09/2020'  WHERE id_solicitud_efectivo =32414;
--COMMIT;

BEGIN;
UPDATE tes.tsolicitud_efectivo SET fecha='07/10/2020'  WHERE id_solicitud_efectivo =32414;
COMMIT;
/********************************************F-DAUP-MGM-TES-3-12/10/2020********************************************/
/********************************************I-DAUP-EGS-TES-3-13/10/2020********************************************/
--Devengdo Rollback
-- BEGIN;
-- Update tes.tplan_pago Set
-- monto_retgar_mo = 0,
-- liquido_pagable = 27600,
-- Where id_plan_pago = 37627;
-- COMMIT;
--Commit
BEGIN;
Update tes.tplan_pago Set
       monto_retgar_mo = 1932.00,
       liquido_pagable = 25668.00
Where id_plan_pago = 37627;
COMMIT;

--pago Rollback
-- BEGIN;
-- Update tes.tplan_pago Set
-- monto_retgar_mo = 0,
-- liquido_pagable = 27600,
-- Where id_plan_pago = 37631;
-- COMMIT;
--Commit
BEGIN;
Update tes.tplan_pago Set
       monto_retgar_mo = 1932.00,
       liquido_pagable = 25668.00
Where id_plan_pago = 37631;
COMMIT;

/********************************************F-DAUP-EGS-TES-3-13/10/2020********************************************/
/********************************************I-DAUP-EGS-TES-4-16/10/2020********************************************/
-- BEGIN;
-- Update tes.tplan_pago Set
--      otros_descuentos= 0.00,
--      monto_retgar_mo = 0.00,
--      liquido_pagable = 5250.00
-- Where id_plan_pago = 32304;
-- COMMIT;
BEGIN;
Update tes.tplan_pago Set
      otros_descuentos= 126.00,
      monto_retgar_mo = 3560.00,
      liquido_pagable = 1564.00
Where id_plan_pago = 32304;
COMMIT;
/********************************************F-DAUP-EGS-TES-4-16/10/2020********************************************/

/********************************************I-DAUP-EGS-TES-5-20/10/2020********************************************/
-- BEGIN;
-- Update tes.tplan_pago Set
--      monto_retgar_mo = 0.00,
--      liquido_pagable = 5250.00
-- Where id_plan_pago = 37832;
-- COMMIT;
BEGIN;
Update tes.tplan_pago Set
      monto_retgar_mo = 3560.00,
      liquido_pagable = 1564.00
Where id_plan_pago = 37832;
COMMIT;
/********************************************F-DAUP-EGS-TES-5-20/10/2020********************************************/
/********************************************I-DAUP-EGS-TES-6-27/10/2020********************************************/
/*
---pago y devengado 2020
BEGIN;
Update tes.tplan_pago Set
      monto_retgar_mo = 0.00,
      liquido_pagable = 17715.00
Where id_plan_pago = 34317;
COMMIT;
BEGIN;
Update tes.tplan_pago Set
      monto_retgar_mo = 0.00,
      liquido_pagable = 4543.79
Where id_plan_pago = 37996;
COMMIT;
*/
--devengado 2020
BEGIN;
Update tes.tplan_pago Set
      monto_retgar_mo = 1240.05,
      liquido_pagable = 16474.95
Where id_plan_pago = 34317;
COMMIT;
--pago 2020
BEGIN;
Update tes.tplan_pago Set
      monto_retgar_mo = 1240.05,
      liquido_pagable = 3303.74
Where id_plan_pago = 37996;
COMMIT;
--obligacion de pago 2020 añadiendo saldo retencion de garantia 2019
-- BEGIN;
-- Update tes.tobligacion_pago Set
--     monto_ajuste_ret_garantia_ga = 0.00
-- Where id_obligacion_pago = 12699;
-- COMMIT;
BEGIN;
Update tes.tobligacion_pago Set
    monto_ajuste_ret_garantia_ga = 4568.48
Where id_obligacion_pago = 12699;
COMMIT;

--ajustando devengado y pago en 2019
-- --devengado
-- BEGIN;
-- Update tes.tplan_pago Set
--       monto_retgar_mo = 0.00,
--       otros_descuentos= 0.00,
--       liquido_pagable = 65264
-- Where id_plan_pago = 31530;
-- COMMIT;
-- --pago 2020
-- BEGIN;
-- Update tes.tplan_pago Set
--           monto_retgar_mo = 0.00,
--           otros_descuentos= 0.00,
--           liquido_pagable = 65264
-- Where id_plan_pago = 32550;
-- COMMIT;
--devengado
BEGIN;
Update tes.tplan_pago Set
      monto_retgar_mo = 4568.48,
      otros_descuentos= 5351.65,
      liquido_pagable = 55343.87
Where id_plan_pago = 31530;
COMMIT;
--pago 2020
BEGIN;
Update tes.tplan_pago Set
      monto_retgar_mo = 4568.48,
      otros_descuentos= 5351.65,
      liquido_pagable = 55343.87
Where id_plan_pago = 32550;
COMMIT;

/********************************************F-DAUP-EGS-TES-6-27/10/2020********************************************/
/********************************************I-DAUP-EGS-TES-7-04/11/2020********************************************/
/*
UPDATE tes.tobligacion_pago SET
total_anticipo = 658800.00,
monto_ajuste_ret_anticipo_par_ga = 658800.00
WHERE id_obligacion_pago = 12302;
*/
BEGIN;
UPDATE tes.tobligacion_pago SET
    total_anticipo = 219600.00,
    monto_ajuste_ret_anticipo_par_ga = 219600.00
WHERE id_obligacion_pago = 12302;
COMMIT;
/********************************************F-DAUP-EGS-TES-7-04/11/2020********************************************/
/********************************************I-DAUP-EGS-TES-8-04/11/2020********************************************/
--Devengdo Rollback
-- BEGIN;
-- Update tes.tplan_pago Set
-- monto_retgar_mo = 0,
-- liquido_pagable = 71330.00,
-- Where id_plan_pago = 37082;
-- COMMIT;
--Commit
BEGIN;
Update tes.tplan_pago Set
      monto_retgar_mo = 4993.10,
      liquido_pagable = 66336.90
Where id_plan_pago = 37082;
COMMIT;

--pago Rollback
-- BEGIN;
-- Update tes.tplan_pago Set
-- monto_retgar_mo = 0,
-- liquido_pagable = 71330.00,
-- Where id_plan_pago = 37084;
-- COMMIT;
--Commit
BEGIN;
Update tes.tplan_pago Set
      monto_retgar_mo = 4993.10,
      liquido_pagable = 66336.90
Where id_plan_pago = 37084;
COMMIT;

/********************************************F-DAUP-EGS-TES-8-04/11/2020********************************************/
/********************************************I-DAUP-EGS-TES-9-05/11/2020********************************************/
/*
UPDATE tes.tplan_pago SET
id_plantilla =8
WHERE id_plan_pago = 37395;
*/
BEGIN;
UPDATE tes.tplan_pago SET
    id_plantilla =1
WHERE id_plan_pago = 37395;
COMMIT;
/********************************************F-DAUP-EGS-TES-9-05/11/2020********************************************/
/********************************************I-DAUP-EGS-TES-ETR-2155-11/12/2020********************************************/
/*
UPDATE tes.tplan_pago SET
id_plantilla =1
WHERE id_plan_pago = 36472;
*/
BEGIN;
UPDATE tes.tplan_pago SET
    id_plantilla =48
WHERE id_plan_pago = 36472;
COMMIT;
/********************************************F-DAUP-EGS-TES-ETR-2155-11/12/2020********************************************/
/********************************************I-DAUP-EGS-TES-ETR-2169-14/12/2020********************************************/
/*
UPDATE tes.tplan_pago SET
id_plantilla =48
WHERE id_plan_pago = 36472;
*/
BEGIN;
UPDATE tes.tplan_pago SET
    id_plantilla =8
WHERE id_plan_pago = 36472;
COMMIT;
/********************************************F-DAUP-EGS-TES-ETR-2169-14/12/2020********************************************/

/********************************************I-DAUP-MGM-TES-ETR-1-22/12/2020********************************************/

--DELETE FROM tes.tsolicitud_rendicion_det ren WHERE ren.id_solicitud_efectivo=33744;
--DELETE FROM tes.tsolicitud_efectivo sol WHERE sol.id_solicitud_efectivo=33744;

--DELETE FROM conta.tdoc_concepto c WHERE c.id_doc_compra_venta = 199947;
--DELETE FROM conta.tdoc_compra_venta doc WHERE doc.id_doc_compra_venta = 199947;

--DELETE FROM conta.tdoc_concepto c WHERE c.id_doc_compra_venta = 199949;
--DELETE FROM conta.tdoc_compra_venta doc WHERE doc.id_doc_compra_venta = 199949;

--DELETE FROM conta.tdoc_concepto c WHERE c.id_doc_compra_venta = 199952;
--DELETE FROM conta.tdoc_compra_venta doc WHERE doc.id_doc_compra_venta = 199952;


BEGIN;
DELETE FROM tes.tsolicitud_rendicion_det ren WHERE ren.id_solicitud_efectivo=33744;
DELETE FROM tes.tsolicitud_efectivo sol WHERE sol.id_solicitud_efectivo=33744;

DELETE FROM conta.tdoc_concepto c WHERE c.id_doc_compra_venta = 199947;
DELETE FROM conta.tdoc_compra_venta doc WHERE doc.id_doc_compra_venta = 199947;

DELETE FROM conta.tdoc_concepto c WHERE c.id_doc_compra_venta = 199949;
DELETE FROM conta.tdoc_compra_venta doc WHERE doc.id_doc_compra_venta = 199949;

DELETE FROM conta.tdoc_concepto c WHERE c.id_doc_compra_venta = 199952;
DELETE FROM conta.tdoc_compra_venta doc WHERE doc.id_doc_compra_venta = 199952;
COMMIT;
/********************************************F-DAUP-MGM-TES-ETR-1-22/12/2020********************************************/


/********************************************I-DAUP-MGM-TES-ETR-1-31/12/2020********************************************/
--rollback
--UPDATE tes.tsolicitud_efectivo SET monto=3812.51 WHERE id_solicitud_efectivo =34081;
--commit
UPDATE tes.tsolicitud_efectivo SET monto=2252.51 WHERE id_solicitud_efectivo =34081;
/********************************************F-DAUP-MGM-TES-ETR-1-31/12/2020********************************************/


/********************************************I-DAUP-MGM-TES-ETR-1-04/01/2020********************************************/
--rollback
--UPDATE tes.tcajero SET fecha_fin='31/12/2020' WHERE fecha_fin='31/12/2020';
--commit
UPDATE tes.tcajero SET fecha_fin='31/12/2022' WHERE fecha_fin='31/12/2020';
/********************************************F-DAUP-MGM-TES-ETR-1-04/01/2020********************************************/


/********************************************I-DAUP-MGM-TES-ETR-2-04/01/2020********************************************/
--rollback
--UPDATE tes.tcaja SET importe_maximo_item=2000 WHERE id_caja=128;
--commit
UPDATE tes.tcaja SET importe_maximo_item=50000 WHERE id_caja=128;
/********************************************F-DAUP-MGM-TES-ETR-2-04/01/2020********************************************/


/********************************************I-DAUP-MGM-TES-ETR-3-04/01/2020********************************************/
--rollback
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1186135;
--commit
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1186135;

--rollback
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1159578;
--commit
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1159578;


--rollback
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1186134;
--commit
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1186134;

--rollback
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1165092;
--commit
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1165092;


--rollback
--UPDATE cd.tcuenta_doc SET estado='finalizado',id_estado_wf=1186135 WHERE id_cuenta_doc=30699;
--commit
UPDATE cd.tcuenta_doc SET estado='contabilizado',id_estado_wf=1159578 WHERE id_cuenta_doc=30699;

--rollback
--UPDATE cd.tcuenta_doc SET estado='rendido',id_estado_wf=1186134,id_moneda_dev= 1,dev_saldo_original=371,id_int_comprobante_devrep = 104079,dev_saldo=371,dev_tipo='deposito',dev_a_favor_de='empresa' WHERE id_cuenta_doc=30860;
--commit
UPDATE cd.tcuenta_doc SET estado='vbtesoreria',id_estado_wf=1165092,id_moneda_dev= NULL,dev_saldo_original=NULL,id_int_comprobante_devrep = NULL,dev_saldo=NULL,dev_tipo=NULL,dev_a_favor_de=NULL WHERE id_cuenta_doc=30860;



/********************************************F-DAUP-MGM-TES-ETR-3-04/01/2020********************************************/



/********************************************I-DAUP-MGM-TES-ETR-1-05/01/2020********************************************/
--finalizado
--rollback
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1197350;
--commit
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1197350;

--rollback
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1166126;
--commit
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1166126;


--rollback
--UPDATE cd.tcuenta_doc SET estado='finalizado',id_estado_wf=1197350 WHERE id_cuenta_doc=30821;
--commit
UPDATE cd.tcuenta_doc SET estado='contabilizado',id_estado_wf=1166126 WHERE id_cuenta_doc=30821;


--rendido
--rollback
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1197349;
--commit
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1197349;

--rollback
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1193139;
--commit
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1193139;



--rollback
--UPDATE cd.tcuenta_doc SET estado='rendido',id_estado_wf=1197349,id_moneda_dev= 1,dev_saldo_original=4400,id_int_comprobante_devrep = NULL,dev_saldo=NULL,dev_tipo=NULL,dev_a_favor_de=NULL WHERE id_cuenta_doc=31998;
--commit
UPDATE cd.tcuenta_doc SET estado='vbtesoreria',id_estado_wf=1193139,id_moneda_dev= NULL,dev_saldo_original=NULL,id_int_comprobante_devrep = NULL,dev_saldo=NULL,dev_tipo=NULL,dev_a_favor_de=NULL WHERE id_cuenta_doc=31998;



--fa
--finalizado
--rollback
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1197467;
--commit
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1197467;

--rollback
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1181260;
--commit
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1181260;


--rollback
--UPDATE cd.tcuenta_doc SET estado='finalizado',id_estado_wf=1197467 WHERE id_cuenta_doc=31603;
--commit
UPDATE cd.tcuenta_doc SET estado='contabilizado',id_estado_wf=1181260 WHERE id_cuenta_doc=31603;


--rendido
--rollback
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1197466;
--commit
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1197466;

--rollback
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1193424;
--commit
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1193424;



--rollback
--UPDATE cd.tcuenta_doc SET estado='rendido',id_estado_wf=1197466,id_moneda_dev= 1,dev_saldo_original=354.17,id_int_comprobante_devrep = NULL,dev_saldo=NULL,dev_tipo=NULL,dev_a_favor_de='empresa' WHERE id_cuenta_doc=32079;
--commit
UPDATE cd.tcuenta_doc SET estado='vbtesoreria',id_estado_wf=1193424,id_moneda_dev= NULL,dev_saldo_original=NULL,id_int_comprobante_devrep = NULL,dev_saldo=NULL,dev_tipo=NULL,dev_a_favor_de=NULL WHERE id_cuenta_doc=32079;

/********************************************F-DAUP-MGM-TES-ETR-1-05/01/2020********************************************/

/********************************************I-DAUP-MGM-TES-ETR-1-06/01/2020********************************************/
--rollback
--UPDATE tes.tsolicitud_efectivo SET fecha='04/01/2021',fecha_ult_mov='04/01/2021',fecha_mod='04/01/2021 10:56:06' WHERE id_solicitud_efectivo=34208;
--commit
UPDATE tes.tsolicitud_efectivo SET fecha='31/12/2020',fecha_ult_mov='31/12/2020',fecha_mod='31/12/2020' WHERE id_solicitud_efectivo=34208;
/********************************************F-DAUP-MGM-TES-ETR-1-06/01/2020********************************************/