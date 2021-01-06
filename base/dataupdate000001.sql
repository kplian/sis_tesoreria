/********************************************I-DAUP-AUTOR-SCHEMA-0-31/02/2019********************************************/
--SHEMA : Esquema (CONTA) contabilidad         AUTHOR:Siglas del autor de los scripts' dataupdate000001.txt
/********************************************F-DAUP-AUTOR-SCHEMA-0-31/02/2019********************************************/



/********************************************I-DAUP-MGM-TES-1-06/01/2021********************************************/
--rollback
--UPDATE tes.tsolicitud_efectivo SET fecha='04/01/2021',fecha_ult_mov='06/01/2021',fecha_mod='06/01/2021 10:08:38' WHERE id_solicitud_efectivo=34242
--commit
UPDATE tes.tsolicitud_efectivo SET fecha='31/12/2020',fecha_ult_mov='31/12/2020',fecha_mod='31/12/2020 10:08:38' WHERE id_solicitud_efectivo=34242

/********************************************F-DAUP-MGM-TES-1-06/01/2021********************************************/

