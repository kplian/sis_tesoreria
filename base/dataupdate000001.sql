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
/*
DELETE FROM tes.tsolicitud_rendicion_det ren WHERE ren.id_solicitud_efectivo=33744;
DELETE FROM tes.tsolicitud_efectivo sol WHERE sol.id_solicitud_efectivo=33744;

DELETE FROM conta.tdoc_concepto c WHERE c.id_doc_compra_venta = 199947;
DELETE FROM conta.tdoc_compra_venta doc WHERE doc.id_doc_compra_venta = 199947;

DELETE FROM conta.tdoc_concepto c WHERE c.id_doc_compra_venta = 199949;
DELETE FROM conta.tdoc_compra_venta doc WHERE doc.id_doc_compra_venta = 199949;

DELETE FROM conta.tdoc_concepto c WHERE c.id_doc_compra_venta = 199952;
DELETE FROM conta.tdoc_compra_venta doc WHERE doc.id_doc_compra_venta = 199952;
*/

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