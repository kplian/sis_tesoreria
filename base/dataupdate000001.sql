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

<<<<<<< HEAD
=======

>>>>>>> remotes/origin/test
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
