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





