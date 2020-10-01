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