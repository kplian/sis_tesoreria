/***********************************I-DEP-GSS-TES-45-02/04/2013****************************************/

--tabla tes.tobligacion_pago

ALTER TABLE tes.tobligacion_pago
  ADD CONSTRAINT fk_tobligacion_pago__id_proveedor FOREIGN KEY (id_proveedor)
    REFERENCES param.tproveedor(id_proveedor)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--tabla tes.obligacion_det

ALTER TABLE tes.tobligacion_det
  ADD CONSTRAINT fk_tobligacion_det__id_obligacion_pago FOREIGN KEY (id_obligacion_pago)
    REFERENCES tes.tobligacion_pago(id_obligacion_pago)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE tes.tobligacion_det
  ADD CONSTRAINT fk_tobligacion_det__id_concepto_ingas FOREIGN KEY (id_concepto_ingas)
    REFERENCES param.tconcepto_ingas(id_concepto_ingas)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--tabla tes.tplan_pago

ALTER TABLE tes.tplan_pago
  ADD CONSTRAINT fk_tplan_pago__id_obligacion_pago FOREIGN KEY (id_obligacion_pago)
    REFERENCES tes.tobligacion_pago(id_obligacion_pago)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE tes.tplan_pago
  ADD CONSTRAINT fk_tplan_pago__id_plan_pago_fk FOREIGN KEY (id_plan_pago_fk)
    REFERENCES tes.tplan_pago(id_plan_pago)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/***********************************F-DEP-GSS-TES-45-02/04/2013****************************************/

/***********************************I-DEP-GSS-TES-121-24/04/2013****************************************/
--tabla tes.tcuenta_bancaria
    
ALTER TABLE tes.tcuenta_bancaria
  ADD CONSTRAINT fk_tcuenta_bancaria__id_institucion FOREIGN KEY (id_institucion)
    REFERENCES param.tinstitucion(id_institucion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
  
ALTER TABLE tes.tchequera
  ADD CONSTRAINT fk_tchequera__id_cuenta_bancaria FOREIGN KEY (id_cuenta_bancaria)
    REFERENCES tes.tcuenta_bancaria(id_cuenta_bancaria)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    

/***********************************F-DEP-GSS-TES-121-24/04/2013****************************************/


/***********************************I-DEP-RAC-TES-19-24/06/2013****************************************/

--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD CONSTRAINT fk_tobligacion_pago__id_funcionario FOREIGN KEY (id_funcionario)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
  --------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD CONSTRAINT fk_tobligacion_pago__id_gestion FOREIGN KEY (id_gestion)
    REFERENCES param.tgestion(id_gestion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;  
    
--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD CONSTRAINT fk_tobligacion_pago__id_proceso_wf FOREIGN KEY (id_proceso_wf)
    REFERENCES wf.tproceso_wf(id_proceso_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD CONSTRAINT fk_tobligacion_pago__id_estado_wf FOREIGN KEY (id_estado_wf)
    REFERENCES wf.testado_wf(id_estado_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD CONSTRAINT fk_tobligacion_pago__id_usuario_reg FOREIGN KEY (id_usuario_reg)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD CONSTRAINT fk_tobligacion_pago__id_usuario_mod FOREIGN KEY (id_usuario_mod)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD CONSTRAINT fk_tobligacion_pago__id_depto FOREIGN KEY (id_depto)
    REFERENCES param.tdepto(id_depto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    --------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD CONSTRAINT fk_tobligacion_pago__id_subsistema FOREIGN KEY (id_subsistema)
    REFERENCES segu.tsubsistema(id_subsistema)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    
    --------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD CONSTRAINT fk_tobligacion_pago__id_moenda FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    --------------- SQL ---------------

CREATE INDEX tobligacion_pago_idx ON tes.tobligacion_pago
  USING btree (id_depto);
  
  --------------- SQL ---------------

CREATE INDEX tobligacion_pago_idx1 ON tes.tobligacion_pago
  USING btree (id_estado_wf);
  
  --------------- SQL ---------------


/***********************************F-DEP-RAC-TES-19-24/06/2013****************************************/






 
 
 

/***********************************I-DEP-RCM-TES-0-16/01/2014***************************************/
ALTER TABLE tes.tcuenta_bancaria
  ADD CONSTRAINT fk_tcuenta_bancaria__id_moneda FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/***********************************F-DEP-RCM-TES-0-16/01/2014***************************************/








/***********************************I-DEP-RAC-TES-0-04/02/2014****************************************/

--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ADD CONSTRAINT tplan_pago__id_usuario_reg FOREIGN KEY (id_usuario_reg)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ADD CONSTRAINT tplan_pago__id_usuairo_mod FOREIGN KEY (id_usuario_mod)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ADD CONSTRAINT tplan_pago__id_obligacion_apgo FOREIGN KEY (id_obligacion_pago)
    REFERENCES tes.tobligacion_pago(id_obligacion_pago)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ADD CONSTRAINT tplan_pago__id_plantilla FOREIGN KEY (id_plantilla)
    REFERENCES param.tplantilla(id_plantilla)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    
    
--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ADD CONSTRAINT tplan_pago_id_plan_pago_fk FOREIGN KEY (id_plan_pago_fk)
    REFERENCES tes.tplan_pago(id_plan_pago)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    
--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ADD CONSTRAINT tplan_pago__id_cuenta_bancaria FOREIGN KEY (id_cuenta_bancaria)
    REFERENCES tes.tcuenta_bancaria(id_cuenta_bancaria)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;    
        

--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ADD CONSTRAINT tplan_pago__id_int_comprobante FOREIGN KEY (id_int_comprobante)
    REFERENCES conta.tint_comprobante(id_int_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ADD CONSTRAINT tplan_pago__id_estado_wf FOREIGN KEY (id_estado_wf)
    REFERENCES wf.testado_wf(id_estado_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ADD CONSTRAINT tplan_pago__id_proceso_wf FOREIGN KEY (id_proceso_wf)
    REFERENCES wf.tproceso_wf(id_proceso_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;



--------------- SQL ---------------

ALTER TABLE tes.tplan_pago
  ADD CONSTRAINT tplan_pago__id_cuenta_bancaria_mov FOREIGN KEY (id_cuenta_bancaria_mov)
    REFERENCES tes.tcuenta_bancaria_mov(id_cuenta_bancaria_mov)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


--------------- SQL ---------------

ALTER TABLE tes.tobligacion_pago
  ADD CONSTRAINT tobligacion_pago__id_depto_conta FOREIGN KEY (id_depto_conta)
    REFERENCES param.tdepto(id_depto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;



--------------- SQL ---------------

ALTER TABLE tes.tprorrateo
  ADD CONSTRAINT tprorrateo__id_usuario_mod FOREIGN KEY (id_usuario_mod)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    
 --------------- SQL ---------------

ALTER TABLE tes.tprorrateo
  ADD CONSTRAINT tprorrateo__id_paln_pago FOREIGN KEY (id_plan_pago)
    REFERENCES tes.tplan_pago(id_plan_pago)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;   
    
 
 --------------- SQL ---------------

ALTER TABLE tes.tprorrateo
  ADD CONSTRAINT tprorrateo__id_obigacion_det FOREIGN KEY (id_obligacion_det)
    REFERENCES tes.tobligacion_det(id_obligacion_det)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
 
 
    
ALTER TABLE tes.tprorrateo
  ADD CONSTRAINT tprorrateo__id_int_transaccion FOREIGN KEY (id_int_transaccion)
    REFERENCES conta.tint_transaccion(id_int_transaccion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;    
--------------- SQL ---------------

ALTER TABLE tes.tprorrateo
  ADD CONSTRAINT tprorrateo__id_prorrateo_fk FOREIGN KEY (id_prorrateo_fk)
    REFERENCES tes.tprorrateo(id_prorrateo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

 ALTER TABLE tes.tobligacion_det
  ADD CONSTRAINT tobligacion_det__id_partida FOREIGN KEY (id_partida)
    REFERENCES pre.tpartida(id_partida)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE tes.tobligacion_det
  ADD CONSTRAINT tobligacion_det__id_obligacion_pago FOREIGN KEY (id_obligacion_pago)
    REFERENCES tes.tobligacion_pago(id_obligacion_pago)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;    
 
 
 --------------- SQL ---------------

ALTER TABLE tes.tobligacion_det
  ADD CONSTRAINT tobligacion_det__id_concepto_ingas FOREIGN KEY (id_concepto_ingas)
    REFERENCES param.tconcepto_ingas(id_concepto_ingas)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    
 --------------- SQL ---------------

ALTER TABLE tes.tobligacion_det
  ADD CONSTRAINT tobligacion_det__id_centro_costo FOREIGN KEY (id_centro_costo)
    REFERENCES param.tcentro_costo(id_centro_costo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;   
    
--------------- SQL ---------------

ALTER TABLE tes.tobligacion_det
  ADD CONSTRAINT tobligacion_det__id_cuenta FOREIGN KEY (id_cuenta)
    REFERENCES conta.tcuenta(id_cuenta)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE; 


--------------- SQL ---------------

ALTER TABLE tes.tobligacion_det
  ADD CONSTRAINT tobligacion_det__id_auxiliar FOREIGN KEY (id_auxiliar)
    REFERENCES conta.tauxiliar(id_auxiliar)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;  
/***********************************F-DEP-RAC-TES-0-04/02/2014****************************************/



/***********************************I-DEP-RAC-TES-0-05/02/2014****************************************/
ALTER TABLE tes.tobligacion_pago
  ADD CONSTRAINT tobligacion_pago__id_palntilla FOREIGN KEY (id_plantilla)
    REFERENCES param.tplantilla(id_plantilla)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
/***********************************F-DEP-RAC-TES-0-05/02/2014****************************************/






/***********************************I-DEP-RAC-TES-0-19/05/2014*****************************************/

CREATE TRIGGER trig_actualiza_informacion_estado_pp
  AFTER INSERT OR UPDATE OF estado, nro_cuota 
  ON tes.tplan_pago FOR EACH ROW 
  EXECUTE PROCEDURE tes.f_trig_actualiza_informacion_estado_pp();

/***********************************F-DEP-RAC-TES-0-19/05/2014*****************************************/



/***********************************I-DEP-RAC-TES-0-01/09/2014*****************************************/

--------------- SQL ---------------

ALTER TABLE tes.tobligacion_det
  ADD CONSTRAINT fk_tobligacion_det__id_orden_trabajo FOREIGN KEY (id_orden_trabajo)
    REFERENCES conta.torden_trabajo(id_orden_trabajo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/***********************************F-DEP-RAC-TES-0-01/09/2014*****************************************/






/**********************************I-DEP-JRR-TES-0-18/11/2014*****************************************/

ALTER TABLE tes.tobligacion_pago
  DROP CONSTRAINT chk_tobligacion_pago__tipo_obligacion RESTRICT;

ALTER TABLE tes.tobligacion_pago
  ADD CONSTRAINT chk_tobligacion_pago__tipo_obligacion CHECK ((tipo_obligacion)::text = ANY (ARRAY[('adquisiciones'::character varying)::text, ('caja_chica'::character varying)::text, ('viaticos'::character varying)::text, ('fondos_en_avance'::character varying)::text, ('pago_directo'::character varying)::text, ('rrhh'::character varying)::text]));

/**********************************F-DEP-JRR-TES-0-18/11/2014*****************************************/



/***********************************I-DEP-GSS-TES-0-27/11/2014****************************************/

/*
 --tabla tes.tusuario_cuenta_banc
    
ALTER TABLE	tes.tusuario_cuenta_banc
  ADD CONSTRAINT fk_tusuario_cuenta_banc__id_cuenta_bancaria FOREIGN KEY (id_cuenta_bancaria)
    REFERENCES tes.tcuenta_bancaria(id_cuenta_bancaria)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 

ALTER TABLE	tes.tusuario_cuenta_banc
  ADD CONSTRAINT fk_tusuario_cuenta_banc__id_usuario FOREIGN KEY (id_usuario)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
*/
/***********************************F-DEP-GSS-TES-0-27/11/2014****************************************/




/***********************************I-DEP-JRR-TES-10/08/2015****************************************/

ALTER TABLE tes.tcaja
  ADD CONSTRAINT tcaja__id_depto FOREIGN KEY (id_depto)
    REFERENCES param.tdepto(id_depto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE tes.tcaja
  ADD CONSTRAINT tcaja__id_moneda FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE tes.tcajero
  ADD CONSTRAINT tcaja__id_caja FOREIGN KEY (id_caja)
    REFERENCES tes.tcaja(id_caja)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE tes.tcajero
  ADD CONSTRAINT tcaja__id_funcionario FOREIGN KEY (id_funcionario)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
/***********************************F-DEP-JRR-TES-10/08/2015****************************************/  



/***********************************I-DEP-JRR-TES-0-25/08/2015****************************************/

ALTER TABLE tes.testacion
  ADD CONSTRAINT testacion__id_depto_lb FOREIGN KEY (id_depto_lb)
    REFERENCES param.tdepto(id_depto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE tes.testacion_tipo_pago
  ADD CONSTRAINT testacion_tipo_pago__id_estacion FOREIGN KEY (id_estacion)
    REFERENCES tes.testacion(id_estacion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE tes.testacion_tipo_pago
  ADD CONSTRAINT testacion_tipo_pago__id_tipo_plan_pago FOREIGN KEY (id_tipo_plan_pago)
    REFERENCES tes.ttipo_plan_pago(id_tipo_plan_pago)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


/***********************************F-DEP-JRR-TES-0-25/08/2015****************************************/ 





/***********************************I-DEP-GSS-TES-0-20/01/2016****************************************/ 
ALTER TABLE tes.tsolicitud_rendicion_det
  ADD CONSTRAINT fk_tsolicitud_rendicion_det__id_proceso_caja FOREIGN KEY (id_proceso_caja)
    REFERENCES tes.tproceso_caja(id_proceso_caja)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE; 
	
ALTER TABLE tes.tsolicitud_rendicion_det
	ADD CONSTRAINT fk_tsolicitud_rendicion_det__id_solicitud_efectivo FOREIGN KEY (id_solicitud_efectivo)
    REFERENCES tes.tsolicitud_efectivo(id_solicitud_efectivo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
	
ALTER TABLE tes.tproceso_caja
  ADD CONSTRAINT tproceso_caja__id_caja FOREIGN KEY (id_caja)
    REFERENCES tes.tcaja(id_caja)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE tes.tproceso_caja
  ADD CONSTRAINT tproceso_caja__id_proceso_wf FOREIGN KEY (id_proceso_wf)
    REFERENCES wf.tproceso_wf(id_proceso_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
/***********************************F-DEP-GSS-TES-0-20/01/2016****************************************/ 

/***********************************I-DEP-GSS-TES-0-08/03/2016****************************************/ 

ALTER TABLE tes.tsolicitud_efectivo_det
  ADD CONSTRAINT fk_tsolicitud_efectivo_det__id_solicitud_efectivo FOREIGN KEY (id_solicitud_efectivo)
    REFERENCES tes.tsolicitud_efectivo(id_solicitud_efectivo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE tes.tsolicitud_efectivo_det
  ADD CONSTRAINT fk_tsolicitud_efectivo_det__id_concepto_ingas FOREIGN KEY (id_concepto_ingas)
    REFERENCES param.tconcepto_ingas(id_concepto_ingas)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE tes.tsolicitud_efectivo_det
  ADD CONSTRAINT fk_tsolicitud_efectivo_det__id_cc FOREIGN KEY (id_cc)
    REFERENCES param.tcentro_costo(id_centro_costo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE tes.tsolicitud_efectivo
  ADD CONSTRAINT fk_tsolicitud_efectivo__id_solicitud_efectiivo FOREIGN KEY (id_solicitud_efectivo_fk)
    REFERENCES tes.tsolicitud_efectivo(id_solicitud_efectivo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE tes.tsolicitud_efectivo
  ADD CONSTRAINT fk_tsolicitud_efectivo__id_caja FOREIGN KEY (id_caja)
    REFERENCES tes.tcaja(id_caja)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE tes.tsolicitud_efectivo
  ADD CONSTRAINT fk_tsolicitud_efectivo__id_tipo_solicitud FOREIGN KEY (id_tipo_solicitud)
    REFERENCES tes.ttipo_solicitud(id_tipo_solicitud)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE tes.tsolicitud_efectivo
  ADD CONSTRAINT fk_tsolicitud_efectivo__id_gestion FOREIGN KEY (id_gestion)
    REFERENCES param.tgestion(id_gestion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE tes.tcaja
  ADD CONSTRAINT fk_tcaja__id_cuenta_bancaria FOREIGN KEY (id_cuenta_bancaria)
    REFERENCES tes.tcuenta_bancaria(id_cuenta_bancaria)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE tes.tsolicitud_rendicion_det
  ADD CONSTRAINT fk_tsolicitud_rendicion_det__id_documento_respaldo FOREIGN KEY (id_documento_respaldo)
    REFERENCES conta.tdoc_compra_venta(id_doc_compra_venta)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
	
/***********************************F-DEP-GSS-TES-0-08/03/2016****************************************/




/***********************************I-DEP-RAC-TES-0-23/03/2016****************************************/


--------------- SQL ---------------

CREATE INDEX tplan_pago_idx ON tes.tplan_pago
  USING btree (id_plan_pago_fk);


--------------- SQL ---------------

CREATE INDEX tplan_pago_idx1 ON tes.tplan_pago
  USING btree (id_plantilla);
  
  
--------------- SQL ---------------

CREATE INDEX tplan_pago_id_obligacion_pago ON tes.tplan_pago
  USING btree (id_obligacion_pago);
  
--------------- SQL ---------------

CREATE INDEX tplan_pago_id_int_comprobante ON tes.tplan_pago
  USING btree (id_int_comprobante);
  
--------------- SQL ---------------

CREATE INDEX tobligacion_pago_id_contrato ON tes.tobligacion_pago
  USING btree (id_contrato);


--------------- SQL ---------------

CREATE INDEX tobligacion_pago_id_moneda ON tes.tobligacion_pago
  USING btree (id_moneda);
  
--------------- SQL ---------------

CREATE INDEX tobligacion_pago_id_gestion ON tes.tobligacion_pago
  USING btree (id_gestion);
  
   

/***********************************F-DEP-RAC-TES-0-23/03/2016****************************************/





/***********************************I-DEP-JRR-TES-0-08/11/2016****************************************/




CREATE OR REPLACE VIEW tes.vcuenta_bancaria(
    id_cuenta_bancaria,
    estado_reg,
    fecha_baja,
    nro_cuenta,
    fecha_alta,
    id_institucion,
    nombre_institucion,
    fecha_reg,
    id_usuario_reg,
    fecha_mod,
    id_usuario_mod,
    id_moneda,
    codigo_moneda)
AS
  SELECT ctaban.id_cuenta_bancaria,
         ctaban.estado_reg,
         ctaban.fecha_baja,
         ctaban.nro_cuenta,
         ctaban.fecha_alta,
         ctaban.id_institucion,
         inst.nombre AS nombre_institucion,
         ctaban.fecha_reg,
         ctaban.id_usuario_reg,
         ctaban.fecha_mod,
         ctaban.id_usuario_mod,
         mon.id_moneda,
         mon.codigo AS codigo_moneda
  FROM tes.tcuenta_bancaria ctaban
       JOIN param.tinstitucion inst ON inst.id_institucion =
        ctaban.id_institucion
       JOIN param.tmoneda mon ON mon.id_moneda = ctaban.id_moneda;

---------------

CREATE OR REPLACE VIEW tes.vcomp_devtesprov_det_plan_pago(
	    id_concepto_ingas,
	    id_partida,
	    id_partida_ejecucion_com,
	    monto_pago_mo,
	    monto_pago_mb,
	    id_centro_costo,
	    descripcion,
	    id_plan_pago,
	    id_prorrateo,
	    id_int_transaccion,
	    id_orden_trabajo)
	AS
	  SELECT od.id_concepto_ingas,
	         od.id_partida,
	         od.id_partida_ejecucion_com,
	         pro.monto_ejecutar_mo AS monto_pago_mo,
	         pro.monto_ejecutar_mb AS monto_pago_mb,
	         od.id_centro_costo,
	         od.descripcion,
	         pro.id_plan_pago,
	         pro.id_prorrateo,
	         pro.id_int_transaccion,
	         od.id_orden_trabajo
	  FROM tes.tprorrateo pro
	       JOIN tes.tobligacion_det od ON od.id_obligacion_det =
	         pro.id_obligacion_det;



--------------- SQL ---------------

CREATE OR REPLACE VIEW tes.vpago_pendientes_al_dia(
    id_plan_pago,
    fecha_tentativa,
    id_estado_wf,
    id_proceso_wf,
    monto,
    liquido_pagable,
    monto_retgar_mo,
    monto_ejecutar_total_mo,
    estado,
    id_obligacion_dets,
    pagos_automaticos,
    desc_funcionario_solicitante,
    email_empresa_fun_sol,
    email_empresa_usu_reg,
    desc_funcionario_usu_reg,
    tipo,
    tipo_pago,
    tipo_obligacion,
    tipo_solicitud,
    tipo_concepto_solicitud,
    pago_variable,
    tipo_anticipo,
    estado_reg,
    num_tramite,
    nro_cuota,
    nombre_pago,
    obs,
    codigo_moneda,
    id_funcionario_solicitante,
    id_funcionario_registro,
    id_proceso_wf_op,
    estado_op)
AS
  SELECT pp.id_plan_pago,
         pp.fecha_tentativa,
         pp.id_estado_wf,
         pp.id_proceso_wf,
         pp.monto,
         pp.liquido_pagable,
         pp.monto_retgar_mo,
         pp.monto_ejecutar_total_mo,
         pp.estado,
         pxp.list(od.id_obligacion_det::text) AS id_obligacion_dets,
         pxp.list_unique(cig.pago_automatico::text) AS pagos_automaticos,
         fun.desc_funcionario1 AS desc_funcionario_solicitante,
         fun.email_empresa AS email_empresa_fun_sol,
         freg.email_empresa AS email_empresa_usu_reg,
         freg.desc_funcionario1 AS desc_funcionario_usu_reg,
         pp.tipo,
         pp.tipo_pago,
         op.tipo_obligacion,
         op.tipo_solicitud,
         op.tipo_concepto_solicitud,
         op.pago_variable,
         op.tipo_anticipo,
         pp.estado_reg,
         op.num_tramite,
         pp.nro_cuota,
         pp.nombre_pago,
         op.obs,
         mon.codigo AS codigo_moneda,
         fun.id_funcionario AS id_funcionario_solicitante,
         freg.id_funcionario AS id_funcionario_registro,
         op.id_proceso_wf AS id_proceso_wf_op,
         op.estado AS estado_op
  FROM tes.tplan_pago pp
       JOIN tes.tobligacion_pago op ON op.id_obligacion_pago =
         pp.id_obligacion_pago
       JOIN param.tmoneda mon ON mon.id_moneda = op.id_moneda
       JOIN tes.tobligacion_det od ON od.id_obligacion_pago =
         op.id_obligacion_pago
       JOIN param.tconcepto_ingas cig ON cig.id_concepto_ingas =
         od.id_concepto_ingas
       JOIN segu.tusuario usu ON usu.id_usuario = pp.id_usuario_reg
       JOIN orga.vfuncionario_persona freg ON freg.id_persona = usu.id_persona
       LEFT JOIN orga.vfuncionario_persona fun ON op.id_funcionario =
         fun.id_funcionario
  WHERE (pp.estado::text = ANY (ARRAY [ 'borrador'::character varying::text,
    'vbsolicitante'::character varying::text ])) AND
        pp.fecha_tentativa <= now()::date AND
        pp.monto_ejecutar_total_mo > 0::numeric AND
        (pp.tipo::text = ANY (ARRAY [ 'devengado_pagado'::character varying::
          text, 'devengado_pagado_1c'::character varying::text, 'ant_aplicado'::
          character varying::text ])) AND
        (op.tipo_obligacion::text = ANY (ARRAY [ 'adquisiciones'::character
          varying::text, 'pago_directo'::character varying::text ])) AND
        pp.estado_reg::text = 'activo'::text 
  GROUP BY pp.id_plan_pago,
           pp.fecha_tentativa,
           pp.id_estado_wf,
           pp.id_proceso_wf,
           pp.monto,
           pp.liquido_pagable,
           pp.monto_retgar_mo,
           pp.monto_ejecutar_total_mo,
           pp.estado,
           fun.desc_funcionario1,
           fun.email_empresa,
           freg.email_empresa,
           freg.desc_funcionario1,
           pp.tipo,
           pp.tipo_pago,
           op.tipo_obligacion,
           op.tipo_solicitud,
           op.tipo_concepto_solicitud,
           op.pago_variable,
           op.tipo_anticipo,
           op.num_tramite,
           pp.nro_cuota,
           pp.nombre_pago,
           op.obs,
           mon.codigo,
           fun.id_funcionario,
           freg.id_funcionario,
           op.id_proceso_wf,
           op.estado;
-------
CREATE OR REPLACE VIEW tes.vobligaciones_contrato_20000(
    fecha,
    num_tramite,
    desc_proveedor,
    estado,
    ultimo_estado_pp,
    total,
    codigo,
    total_bs,
    codigo_mb,
    obs,
    numero,
    objeto,
    gestion)
AS
  SELECT op.fecha,
         op.num_tramite,
         pr.desc_proveedor,
         op.estado,
         op.ultimo_estado_pp,
         sum(od.monto_pago_mo) AS total,
         mo.codigo,
         sum(od.monto_pago_mb) AS total_bs,
         'BS'         AS codigo_mb,
         op.obs,
         con.numero,
         con.objeto,
         ges.gestion
  FROM tes.tobligacion_pago op
       JOIN tes.tobligacion_det od ON od.id_obligacion_pago =
         op.id_obligacion_pago AND od.estado_reg::text = 'activo'::text
       JOIN param.vproveedor pr ON pr.id_proveedor = op.id_proveedor
       JOIN param.tmoneda mo ON mo.id_moneda = op.id_moneda
       JOIN param.tgestion ges ON ges.id_gestion = op.id_gestion
       LEFT JOIN leg.tcontrato con ON con.id_contrato = op.id_contrato
  WHERE op.tipo_obligacion::text <> ALL (ARRAY [ 'adquisiciones'::character
    varying, 'rrhh'::character varying ]::text [ ])
  GROUP BY op.fecha,
           op.num_tramite,
           pr.desc_proveedor,
           mo.codigo,
           op.obs,
           con.numero,
           con.objeto,
           op.total_pago,
           op.estado,
           op.ultimo_estado_pp,
           ges.gestion
  HAVING sum(od.monto_pago_mb) >= 20000::numeric
  ORDER BY op.fecha DESC;

---------------------
CREATE OR REPLACE VIEW tes.vcomp_devtesprov_plan_pago_2(
    id_plan_pago,
    id_proveedor,
    desc_proveedor,
    id_moneda,
    id_depto_conta,
    numero,
    fecha_actual,
    estado,
    monto_ejecutar_total_mb,
    monto_ejecutar_total_mo,
    monto,
    monto_mb,
    monto_retgar_mb,
    monto_retgar_mo,
    monto_no_pagado,
    monto_no_pagado_mb,
    otros_descuentos,
    otros_descuentos_mb,
    id_plantilla,
    id_cuenta_bancaria,
    id_cuenta_bancaria_mov,
    nro_cheque,
    nro_cuenta_bancaria,
    num_tramite,
    tipo,
    id_gestion_cuentas,
    id_int_comprobante,
    liquido_pagable,
    liquido_pagable_mb,
    nombre_pago,
    porc_monto_excento_var,
    obs_pp,
    descuento_anticipo,
    descuento_inter_serv,
    tipo_obligacion,
    id_categoria_compra,
    codigo_categoria,
    nombre_categoria,
    id_proceso_wf,
    detalle,
    codigo_moneda,
    nro_cuota,
    tipo_pago,
    tipo_solicitud,
    tipo_concepto_solicitud,
    total_monto_op_mb,
    total_monto_op_mo,
    total_pago,
    fecha_tentativa,
    desc_funcionario,
    email_empresa,
    desc_usuario,
    id_funcionario_gerente,
    correo_usuario,
    sw_conformidad,
    ultima_cuota_pp,
    ultima_cuota_dev,
    tiene_form500,
    prioridad_op,
    prioridad_lb,
    id_depto_lb)
AS
  SELECT pp.id_plan_pago,
         op.id_proveedor,
         COALESCE(p.desc_proveedor, ''::character varying) AS desc_proveedor,
         op.id_moneda,
         pp.id_depto_conta,
         op.numero,
         now() AS fecha_actual,
         pp.estado,
         pp.monto_ejecutar_total_mb,
         pp.monto_ejecutar_total_mo,
         pp.monto,
         pp.monto_mb,
         pp.monto_retgar_mb,
         pp.monto_retgar_mo,
         pp.monto_no_pagado,
         pp.monto_no_pagado_mb,
         pp.otros_descuentos,
         pp.otros_descuentos_mb,
         pp.id_plantilla,
         pp.id_cuenta_bancaria,
         pp.id_cuenta_bancaria_mov,
         pp.nro_cheque,
         pp.nro_cuenta_bancaria,
         op.num_tramite,
         pp.tipo,
         op.id_gestion AS id_gestion_cuentas,
         pp.id_int_comprobante,
         pp.liquido_pagable,
         pp.liquido_pagable_mb,
         pp.nombre_pago,
         pp.porc_monto_excento_var,
         ((COALESCE(op.numero, ''::character varying)::text || ' '::text) ||
           COALESCE(pp.obs_monto_no_pagado, ''::text))::character varying AS
           obs_pp,
         pp.descuento_anticipo,
         pp.descuento_inter_serv,
         op.tipo_obligacion,
         op.id_categoria_compra,
         COALESCE(cac.codigo, ''::character varying) AS codigo_categoria,
         COALESCE(cac.nombre, ''::character varying) AS nombre_categoria,
         pp.id_proceso_wf,
         ((('<table border="1"><TR> 
   <TH>Concepto</TH> 
   <TH>Detalle</TH> 
   <TH>Importe ('::text || mon.codigo::text) || ')</TH>'::text) || pxp.html_rows
     (((((((((('<td>'::text || ci.desc_ingas::text) || '</td> <td>'::text) ||
     '<font hdden=true>'::text) || od.id_obligacion_det::character varying::text
     ) || '</font>'::text) || od.descripcion) || '</td> <td>'::text) ||
     od.monto_pago_mo::text) || '</td>'::text)::character varying)::text) ||
     '</table>'::text AS detalle,
         mon.codigo AS codigo_moneda,
         pp.nro_cuota,
         pp.tipo_pago,
         op.tipo_solicitud,
         op.tipo_concepto_solicitud,
         COALESCE(sum(od.monto_pago_mb), 0::numeric) AS total_monto_op_mb,
         COALESCE(sum(od.monto_pago_mo), 0::numeric) AS total_monto_op_mo,
         op.total_pago,
         pp.fecha_tentativa,
         fun.desc_funcionario1 AS desc_funcionario,
         fun.email_empresa,
         usu.desc_persona AS desc_usuario,
         COALESCE(op.id_funcionario_gerente, 0) AS id_funcionario_gerente,
         ususol.correo AS correo_usuario,
         CASE
           WHEN pp.fecha_conformidad IS NULL THEN 'no'::text
           ELSE 'si'::text
         END AS sw_conformidad,
         op.ultima_cuota_pp,
         op.ultima_cuota_dev,
         pp.tiene_form500,
         dep.prioridad AS prioridad_op,
         COALESCE(deplb.prioridad, (- 1)) AS prioridad_lb,
         pp.id_depto_lb
  FROM tes.tplan_pago pp
       JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago =
         op.id_obligacion_pago
       JOIN param.tmoneda mon ON mon.id_moneda = op.id_moneda
       JOIN param.tdepto dep ON dep.id_depto = op.id_depto
       LEFT JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor
       LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
         op.id_categoria_compra
       LEFT JOIN adq.tcotizacion cot ON op.id_obligacion_pago =
         cot.id_obligacion_pago
       LEFT JOIN adq.tproceso_compra pro ON pro.id_proceso_compra =
         cot.id_proceso_compra
       LEFT JOIN adq.tsolicitud sol ON sol.id_solicitud = pro.id_solicitud
       LEFT JOIN segu.vusuario ususol ON ususol.id_usuario = sol.id_usuario_reg
       LEFT JOIN param.tdepto deplb ON deplb.id_depto = pp.id_depto_lb
       JOIN tes.tobligacion_det od ON od.id_obligacion_pago =
         op.id_obligacion_pago AND od.estado_reg::text = 'activo'::text
       JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas =
         od.id_concepto_ingas
       JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario =
         op.id_funcionario AND fun.estado_reg_asi::text = 'activo'::text
       JOIN segu.vusuario usu ON usu.id_usuario = op.id_usuario_reg
  GROUP BY pp.id_plan_pago,
           op.id_proveedor,
           p.desc_proveedor,
           op.id_moneda,
           pp.id_depto_conta,
           op.numero,
           pp.estado,
           pp.monto_ejecutar_total_mb,
           pp.monto_ejecutar_total_mo,
           pp.monto,
           pp.monto_mb,
           pp.monto_retgar_mb,
           pp.monto_retgar_mo,
           pp.monto_no_pagado,
           pp.monto_no_pagado_mb,
           pp.otros_descuentos,
           pp.otros_descuentos_mb,
           pp.id_plantilla,
           pp.id_cuenta_bancaria,
           pp.id_cuenta_bancaria_mov,
           pp.nro_cheque,
           pp.nro_cuenta_bancaria,
           op.num_tramite,
           pp.tipo,
           op.id_gestion,
           pp.id_int_comprobante,
           pp.liquido_pagable,
           pp.liquido_pagable_mb,
           pp.nombre_pago,
           pp.porc_monto_excento_var,
           pp.obs_monto_no_pagado,
           pp.descuento_anticipo,
           pp.descuento_inter_serv,
           op.tipo_obligacion,
           op.id_categoria_compra,
           cac.codigo,
           cac.nombre,
           pp.id_proceso_wf,
           mon.codigo,
           pp.nro_cuota,
           pp.tipo_pago,
           op.total_pago,
           op.tipo_solicitud,
           op.tipo_concepto_solicitud,
           pp.fecha_tentativa,
           fun.desc_funcionario1,
           fun.email_empresa,
           usu.desc_persona,
           op.id_funcionario_gerente,
           ususol.correo,
           op.ultima_cuota_pp,
           op.ultima_cuota_dev,
           pp.tiene_form500,
           dep.prioridad,
           deplb.prioridad;

---------

CREATE OR REPLACE VIEW tes.vpago_x_proveedor (
    id_plan_pago,
    id_gestion,
    gestion,
    id_obligacion_pago,
    num_tramite,
    orden_compra,
    tipo_obligacion,
    pago_variable,
    desc_proveedor,
    estado,
    usuario_reg,
    fecha,
    fecha_reg,
    ob_obligacion_pago,
    fecha_tentativa_de_pago,
    nro_cuota,
    tipo_plan_pago,
    estado_plan_pago,
    obs_descuento_inter_serv,
    obs_descuentos_anticipo,
    obs_descuentos_ley,
    obs_monto_no_pagado,
    obs_otros_descuentos,
    codigo,
    monto_cuota,
    monto_anticipo,
    monto_excento,
    monto_retgar_mo,
    monto_ajuste_ag,
    monto_ajuste_siguiente_pago,
    liquido_pagable,
    monto_presupuestado,
    id_contrato,
    desc_contrato,
    desc_funcionario1)
AS
SELECT ppp.id_plan_pago,
    op.id_gestion,
    ges.gestion,
    op.id_obligacion_pago,
    op.num_tramite,
    cot.numero_oc AS orden_compra,
    op.tipo_obligacion,
    op.pago_variable,
    pro.desc_proveedor,
    op.estado,
    usu.cuenta AS usuario_reg,
    op.fecha,
    op.fecha_reg,
    op.obs AS ob_obligacion_pago,
    ppp.fecha_tentativa AS fecha_tentativa_de_pago,
    ppp.nro_cuota,
    ppp.tipo AS tipo_plan_pago,
    ppp.estado AS estado_plan_pago,
    ppp.obs_descuento_inter_serv,
    ppp.obs_descuentos_anticipo,
    ppp.obs_descuentos_ley,
    ppp.obs_monto_no_pagado,
    ppp.obs_otros_descuentos,
    mon.codigo,
    ppp.monto AS monto_cuota,
    ppp.monto_anticipo,
    ppp.monto_excento,
    ppp.monto_retgar_mo,
    ppp.monto_ajuste_ag,
    ppp.monto_ajuste_siguiente_pago,
    ppp.liquido_pagable,
    (
    SELECT sum(od.monto_pago_mo) AS monto_presupuestado
    FROM tes.tobligacion_det od
    WHERE od.id_obligacion_pago = op.id_obligacion_pago AND od.estado_reg::text
        = 'activo'::text
    ) AS monto_presupuestado,
    con.id_contrato,
    (('(id:'::text || con.id_contrato) || ') Nro: '::text) || con.numero::text
        AS desc_contrato,
    fun.desc_funcionario1
FROM tes.tobligacion_pago op
   JOIN param.tgestion ges ON ges.id_gestion = op.id_gestion
   JOIN param.vproveedor pro ON pro.id_proveedor = op.id_proveedor
   JOIN segu.tusuario usu ON usu.id_usuario = op.id_usuario_reg
   JOIN param.tmoneda mon ON mon.id_moneda = op.id_moneda
   JOIN tes.tplan_pago ppp ON ppp.id_obligacion_pago = op.id_obligacion_pago
       AND ppp.estado_reg::text = 'activo'::text
   LEFT JOIN adq.tcotizacion cot ON cot.id_obligacion_pago = op.id_obligacion_pago
   LEFT JOIN leg.tcontrato con ON con.id_contrato = op.id_contrato
   JOIN orga.vfuncionario fun ON fun.id_funcionario = op.id_funcionario;

--------------- SQL ---------------

CREATE VIEW tes.vplan_pago 
AS 
SELECT   ppp.id_plan_pago,
         op.id_gestion,
         ges.gestion,
         op.id_obligacion_pago,
         op.num_tramite,
         cot.numero_oc AS orden_compra,
         op.tipo_obligacion,
         op.pago_variable,
         pro.desc_proveedor,
         op.estado,
         usu.cuenta AS usuario_reg,
         op.fecha,
         op.fecha_reg,
         op.obs AS ob_obligacion_pago,
         ppp.fecha_tentativa AS fecha_tentativa_de_pago,
         ppp.nro_cuota,
         ppp.tipo AS tipo_plan_pago,
         ppp.estado AS estado_plan_pago,
         ppp.obs_descuento_inter_serv,
         ppp.obs_descuentos_anticipo,
         ppp.obs_descuentos_ley,
         ppp.obs_monto_no_pagado,
         ppp.obs_otros_descuentos,
         mon.codigo,
         ppp.monto AS monto_cuota,
         ppp.monto_anticipo,
         ppp.monto_excento,
         ppp.monto_retgar_mo,
         ppp.monto_ajuste_ag,
         ppp.monto_ajuste_siguiente_pago,
         ppp.liquido_pagable,
         con.id_contrato,
         (('(id:'::text || con.id_contrato) || ') Nro: '::text) || con.numero::
           text AS desc_contrato,
         fun.desc_funcionario1,
         op.obs,
         op.id_proveedor,
         pxp.aggarray(od.id_concepto_ingas) as ids_conceptos_ingas,
         pxp.aggarray(od.id_orden_trabajo) as ids_ordene_trabajo
  FROM tes.tobligacion_pago op
       JOIN tes.tobligacion_det od on od.id_obligacion_pago = op.id_obligacion_pago and od.estado_reg = 'activo'
       JOIN param.tgestion ges ON ges.id_gestion = op.id_gestion
       JOIN param.vproveedor pro ON pro.id_proveedor = op.id_proveedor
       JOIN segu.tusuario usu ON usu.id_usuario = op.id_usuario_reg
       JOIN param.tmoneda mon ON mon.id_moneda = op.id_moneda
       JOIN tes.tplan_pago ppp ON ppp.id_obligacion_pago = op.id_obligacion_pago
         AND ppp.estado_reg::text = 'activo'::text
       LEFT JOIN adq.tcotizacion cot ON cot.id_obligacion_pago =
         op.id_obligacion_pago
       LEFT JOIN leg.tcontrato con ON con.id_contrato = op.id_contrato
       JOIN orga.vfuncionario fun ON fun.id_funcionario = op.id_funcionario

group by 
         ppp.id_plan_pago,
         op.id_gestion,
         ges.gestion,
         op.id_obligacion_pago,
         op.num_tramite,
         cot.numero_oc,
         op.tipo_obligacion,
         op.pago_variable,
         pro.desc_proveedor,
         op.estado,
         usu.cuenta,
         op.fecha,
         op.fecha_reg,
         op.obs,
         ppp.fecha_tentativa,
         ppp.nro_cuota,
         ppp.tipo,
         ppp.estado,
         ppp.obs_descuento_inter_serv,
         ppp.obs_descuentos_anticipo,
         ppp.obs_descuentos_ley,
         ppp.obs_monto_no_pagado,
         ppp.obs_otros_descuentos,
         mon.codigo,
         ppp.monto,
         ppp.monto_anticipo,
         ppp.monto_excento,
         ppp.monto_retgar_mo,
         ppp.monto_ajuste_ag,
         ppp.monto_ajuste_siguiente_pago,
         ppp.liquido_pagable,
         con.id_contrato,
         con.numero,
         fun.desc_funcionario1,
         op.obs,
         con.id_contrato ;



--------

--------------- SQL ---------------

DROP VIEW tes.vpagos_relacionados;

CREATE OR REPLACE VIEW tes.vpagos_relacionados(
    desc_proveedor,
    num_tramite,
    estado,
    fecha_tentativa,
    nro_cuota,
    monto,
    codigo,
    conceptos,
    ordenes,
    id_orden_trabajos,
    id_concepto_ingas,
    id_plan_pago,
    id_proceso_wf,
    id_estado_wf,
    id_proveedor,
    obs,
    tipo)
AS
WITH detalle AS(
  SELECT op_1.id_obligacion_pago,
         pxp.list(cig.desc_ingas::text) AS conceptos,
         pxp.list(ot.desc_orden::text) AS ordenes,
         pxp.aggarray(od.id_orden_trabajo::text) AS id_orden_trabajos,
         pxp.aggarray(od.id_concepto_ingas::text) AS id_concepto_ingas
  FROM tes.tobligacion_pago op_1
       JOIN tes.tobligacion_det od ON od.id_obligacion_pago =
         op_1.id_obligacion_pago
       JOIN param.tconcepto_ingas cig ON cig.id_concepto_ingas =
         od.id_concepto_ingas
       LEFT JOIN conta.torden_trabajo ot ON ot.id_orden_trabajo =
         od.id_orden_trabajo
  GROUP BY op_1.id_obligacion_pago)
    SELECT prov.desc_proveedor,
           op.num_tramite,
           pp.estado,
           pp.fecha_tentativa,
           pp.nro_cuota,
           pp.monto,
           mon.codigo,
           det.conceptos,
           det.ordenes,
           det.id_orden_trabajos,
           det.id_concepto_ingas,
           pp.id_plan_pago,
           pp.id_proceso_wf,
           pp.id_estado_wf,
           op.id_proveedor,
           op.obs,
           pp.tipo
    FROM tes.tobligacion_pago op
         JOIN param.vproveedor prov ON prov.id_proveedor = op.id_proveedor
         JOIN tes.tplan_pago pp ON pp.id_obligacion_pago = op.id_obligacion_pago
         JOIN param.tmoneda mon ON mon.id_moneda = op.id_moneda
         JOIN detalle det ON det.id_obligacion_pago = op.id_obligacion_pago
    WHERE (pp.tipo::text = ANY (ARRAY [ 'devengado'::character varying::text,
      'devengado_pagado'::character varying::text, 'devengado_pagado_1c'::
      character varying::text, 'ant_parcial'::character varying::text,
      'anticipo'::character varying::text, 'especial'::character varying::text ]
      )) AND
          (pp.estado::text <> ALL (ARRAY [ 'borrador'::character varying::text,
            'anulado'::character varying::text, 'vbsolicitante'::character
            varying::text ]));
-----

CREATE OR REPLACE VIEW tes.vproceso_caja (
    id_proceso_caja,
    id_cajero,
    id_caja,
    id_depto_conta,
    fecha_cbte,
    id_moneda,
    id_gestion,
    codigo,
    fecha_inicio,
    fecha_fin,
    id_funcionario,
    id_cuenta_bancaria,
    monto_reposicion,
    nro_tramite,
    nombre_cajero,
    id_depto_lb)
AS
 SELECT pc.id_proceso_caja,
    c.id_cajero,
    ca.id_caja,
    pc.id_depto_conta,
    pc.fecha AS fecha_cbte,
    ca.id_moneda,
    pc.id_gestion,
    ca.codigo,
    c.fecha_inicio,
    c.fecha_fin,
    c.id_funcionario,
    pc.id_cuenta_bancaria,
    pc.monto_reposicion,
    pc.nro_tramite,
    f.desc_funcionario1 AS nombre_cajero,
    ca.id_depto_lb
   FROM tes.tproceso_caja pc
   JOIN tes.tcaja ca ON pc.id_caja = ca.id_caja
   JOIN tes.tcajero c ON c.id_caja = ca.id_caja AND c.tipo::text = 'responsable'::text
   JOIN orga.vfuncionario f ON f.id_funcionario = c.id_funcionario
  WHERE pc.fecha >= c.fecha_inicio AND pc.fecha <= c.fecha_fin OR pc.fecha >= c.fecha_inicio AND c.fecha_fin IS NULL;
  

-----

CREATE OR REPLACE VIEW tes.vsrd_doc_compra_venta(
    id_solicitud_rendicion_det,
    id_solicitud_efectivo,
    id_moneda,
    id_int_comprobante,
    id_plantilla,
    importe_doc,
    importe_excento,
    importe_total_excento,
    importe_descuento,
    importe_descuento_ley,
    importe_ice,
    importe_it,
    importe_iva,
    importe_pago_liquido,
    nro_documento,
    nro_dui,
    nro_autorizacion,
    razon_social,
    revisado,
    manual,
    obs,
    nit,
    fecha,
    codigo_control,
    sw_contabilizar,
    tipo,
    id_proceso_caja,
    id_documento_respaldo,
    id_doc_compra_venta,
    descripcion,
    importe_neto,
    importe_anticipo,
    importe_pendiente,
    importe_retgar,
    id_auxiliar)
AS
  SELECT srd.id_solicitud_rendicion_det,
         srd.id_solicitud_efectivo,
         dcv.id_moneda,
         dcv.id_int_comprobante,
         dcv.id_plantilla,
         dcv.importe_doc,
         dcv.importe_excento,
         COALESCE(dcv.importe_excento, 0::numeric) + COALESCE(dcv.importe_ice, 0
           ::numeric) AS importe_total_excento,
         dcv.importe_descuento,
         dcv.importe_descuento_ley,
         dcv.importe_ice,
         dcv.importe_it,
         dcv.importe_iva,
         dcv.importe_pago_liquido,
         dcv.nro_documento,
         dcv.nro_dui,
         dcv.nro_autorizacion,
         dcv.razon_social,
         dcv.revisado,
         dcv.manual,
         dcv.obs,
         dcv.nit,
         dcv.fecha,
         dcv.codigo_control,
         dcv.sw_contabilizar,
         dcv.tipo,
         srd.id_proceso_caja,
         srd.id_documento_respaldo,
         dcv.id_doc_compra_venta,
         (((dcv.razon_social::text || ' - '::text) || ' ( '::text) ||
           ' ) Nro Doc: '::text) || COALESCE(dcv.nro_documento)::text AS
           descripcion,
         dcv.importe_neto,
         dcv.importe_anticipo,
         dcv.importe_pendiente,
         dcv.importe_retgar,
         dcv.id_auxiliar
  FROM tes.tsolicitud_rendicion_det srd
       JOIN conta.tdoc_compra_venta dcv ON srd.id_documento_respaldo =
         dcv.id_doc_compra_venta;



---------
CREATE OR REPLACE VIEW tes.vpagos(
    id_plan_pago,
    id_gestion,
    gestion,
    id_obligacion_pago,
    num_tramite,
    tipo_obligacion,
    pago_variable,
    desc_proveedor,
    estado,
    usuario_reg,
    fecha,
    fecha_reg,
    ob_obligacion_pago,
    fecha_tentativa_de_pago,
    nro_cuota,
    tipo_plan_pago,
    estado_plan_pago,
    obs_descuento_inter_serv,
    obs_descuentos_anticipo,
    obs_descuentos_ley,
    obs_monto_no_pagado,
    obs_otros_descuentos,
    codigo,
    monto_cuota,
    monto_anticipo,
    monto_excento,
    monto_retgar_mo,
    monto_ajuste_ag,
    monto_ajuste_siguiente_pago,
    liquido_pagable,
    id_contrato,
    desc_contrato,
    desc_funcionario1,
    bancarizacion,
    id_proceso_wf,
    id_plantilla,
    desc_plantilla,
    tipo_informe)
AS
  SELECT ppp.id_plan_pago,
         op.id_gestion,
         ges.gestion,
         op.id_obligacion_pago,
         op.num_tramite,
         op.tipo_obligacion,
         op.pago_variable,
         pro.desc_proveedor,
         op.estado,
         usu.cuenta AS usuario_reg,
         op.fecha,
         op.fecha_reg,
         op.obs AS ob_obligacion_pago,
         ppp.fecha_tentativa AS fecha_tentativa_de_pago,
         ppp.nro_cuota,
         ppp.tipo AS tipo_plan_pago,
         ppp.estado AS estado_plan_pago,
         ppp.obs_descuento_inter_serv,
         ppp.obs_descuentos_anticipo,
         ppp.obs_descuentos_ley,
         ppp.obs_monto_no_pagado,
         ppp.obs_otros_descuentos,
         mon.codigo,
         ppp.monto AS monto_cuota,
         ppp.monto_anticipo,
         ppp.monto_excento,
         ppp.monto_retgar_mo,
         ppp.monto_ajuste_ag,
         ppp.monto_ajuste_siguiente_pago,
         ppp.liquido_pagable,
         con.id_contrato,
         (((('(id:'::text || con.id_contrato) || ') Nro: '::text) || con.numero
           ::text) || ' BAN: '::text) || con.bancarizacion::text AS
           desc_contrato,
         fun.desc_funcionario1,
         con.bancarizacion,
         ppp.id_proceso_wf,
         plt.id_plantilla,
         plt.desc_plantilla,
         plt.tipo_informe
  FROM tes.tobligacion_pago op
       JOIN param.tgestion ges ON ges.id_gestion = op.id_gestion
       JOIN param.vproveedor pro ON pro.id_proveedor = op.id_proveedor
       JOIN segu.tusuario usu ON usu.id_usuario = op.id_usuario_reg
       JOIN param.tmoneda mon ON mon.id_moneda = op.id_moneda
       JOIN tes.tplan_pago ppp ON ppp.id_obligacion_pago = op.id_obligacion_pago
         AND ppp.estado_reg::text = 'activo'::text
       JOIN param.tplantilla plt ON plt.id_plantilla = ppp.id_plantilla
       LEFT JOIN leg.tcontrato con ON con.id_contrato = op.id_contrato AND
         con.id_gestion = ges.id_gestion
       JOIN orga.vfuncionario fun ON fun.id_funcionario = op.id_funcionario;     

-----------


DROP VIEW tes.vcomp_devtesprov_plan_pago;

CREATE OR REPLACE VIEW tes.vcomp_devtesprov_plan_pago(
    id_plan_pago,
    id_proveedor,
    desc_proveedor,
    id_moneda,
    id_depto_conta,
    numero,
    fecha_actual,
    estado,
    monto_ejecutar_total_mb,
    monto_ejecutar_total_mo,
    monto,
    monto_mb,
    monto_retgar_mb,
    monto_retgar_mo,
    monto_no_pagado,
    monto_no_pagado_mb,
    otros_descuentos,
    otros_descuentos_mb,
    id_plantilla,
    id_cuenta_bancaria,
    id_cuenta_bancaria_mov,
    nro_cheque,
    nro_cuenta_bancaria,
    num_tramite,
    tipo,
    id_gestion_cuentas,
    id_int_comprobante,
    liquido_pagable,
    liquido_pagable_mb,
    nombre_pago,
    porc_monto_excento_var,
    obs_pp,
    descuento_anticipo,
    descuento_inter_serv,
    tipo_obligacion,
    id_categoria_compra,
    codigo_categoria,
    nombre_categoria,
    id_proceso_wf,
    forma_pago,
    monto_ajuste_ag,
    monto_ajuste_siguiente_pago,
    monto_anticipo,
    tipo_cambio_conv,
    id_depto_libro,
    fecha_costo_ini,
    fecha_costo_fin,
    id_obligacion_pago,
    fecha_tentativa)
AS
  SELECT pp.id_plan_pago,
         op.id_proveedor,
         p.desc_proveedor,
         op.id_moneda,
         op.id_depto_conta,
         op.numero,
         now() AS fecha_actual,
         pp.estado,
         pp.monto_ejecutar_total_mb,
         pp.monto_ejecutar_total_mo,
         pp.monto,
         pp.monto_mb,
         pp.monto_retgar_mb,
         pp.monto_retgar_mo,
         pp.monto_no_pagado,
         pp.monto_no_pagado_mb,
         pp.otros_descuentos,
         pp.otros_descuentos_mb,
         pp.id_plantilla,
         pp.id_cuenta_bancaria,
         pp.id_cuenta_bancaria_mov,
         pp.nro_cheque,
         pp.nro_cuenta_bancaria,
         op.num_tramite,
         pp.tipo,
         op.id_gestion AS id_gestion_cuentas,
         pp.id_int_comprobante,
         pp.liquido_pagable,
         pp.liquido_pagable_mb,
         pp.nombre_pago,
         pp.porc_monto_excento_var,
         ((COALESCE(op.numero, ''::character varying)::text || ' '::text) || COALESCE(
           pp.obs_monto_no_pagado, ''::text))::character varying AS obs_pp,
         pp.descuento_anticipo,
         pp.descuento_inter_serv,
         op.tipo_obligacion,
         op.id_categoria_compra,
         COALESCE(cac.codigo, ''::character varying) AS codigo_categoria,
         COALESCE(cac.nombre, ''::character varying) AS nombre_categoria,
         pp.id_proceso_wf,
         pp.forma_pago,
         pp.monto_ajuste_ag,
         pp.monto_ajuste_siguiente_pago,
         pp.monto_anticipo,
         op.tipo_cambio_conv,
         pp.id_depto_lb AS id_depto_libro,
         CASE
           WHEN pp.fecha_costo_ini IS NULL THEN now()::date
           WHEN pp.fecha_costo_ini > now() THEN now()::date
           ELSE pp.fecha_costo_ini
         END AS fecha_costo_ini,
         COALESCE(pp.fecha_costo_fin, now()::date) AS fecha_costo_fin,
         op.id_obligacion_pago,
         pp.fecha_tentativa
  FROM tes.tplan_pago pp
       JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago =
         op.id_obligacion_pago
       JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor
       LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
         op.id_categoria_compra;

----------

CREATE OR REPLACE VIEW tes.vsrd_doc_compra_venta_det(
    id_solicitud_rendicion_det,
    id_proceso_caja,
    id_moneda,
    id_int_comprobante,
    id_plantilla,
    importe_doc,
    importe_excento,
    importe_total_excento,
    importe_descuento,
    importe_descuento_ley,
    importe_ice,
    importe_it,
    importe_iva,
    importe_pago_liquido,
    nro_documento,
    nro_dui,
    nro_autorizacion,
    razon_social,
    revisado,
    manual,
    obs,
    nit,
    fecha,
    codigo_control,
    sw_contabilizar,
    tipo,
    id_doc_compra_venta,
    id_concepto_ingas,
    id_centro_costo,
    id_orden_trabajo,
    precio_total,
    id_doc_concepto,
    desc_ingas,
    descripcion,
    importe_neto,
    importe_anticipo,
    importe_pendiente,
    importe_retgar,
    precio_total_final,
    porc_monto_excento_var)
AS
  SELECT srd.id_solicitud_rendicion_det,
         srd.id_proceso_caja,
         dcv.id_moneda,
         dcv.id_int_comprobante,
         dcv.id_plantilla,
         dcv.importe_doc,
         dcv.importe_excento,
         COALESCE(dcv.importe_excento, 0::numeric) + COALESCE(dcv.importe_ice, 0
           ::numeric) AS importe_total_excento,
         dcv.importe_descuento,
         dcv.importe_descuento_ley,
         dcv.importe_ice,
         dcv.importe_it,
         dcv.importe_iva,
         dcv.importe_pago_liquido,
         dcv.nro_documento,
         dcv.nro_dui,
         dcv.nro_autorizacion,
         dcv.razon_social,
         dcv.revisado,
         dcv.manual,
         dcv.obs,
         dcv.nit,
         dcv.fecha,
         dcv.codigo_control,
         dcv.sw_contabilizar,
         dcv.tipo,
         dcv.id_doc_compra_venta,
         dco.id_concepto_ingas,
         dco.id_centro_costo,
         dco.id_orden_trabajo,
         dco.precio_total,
         dco.id_doc_concepto,
         cig.desc_ingas,
         (((((dcv.razon_social::text || ' - '::text) || cig.desc_ingas::text) ||
           ' ( '::text) || dco.descripcion) || ' ) Nro Doc: '::text) || COALESCE
           (dcv.nro_documento)::text AS descripcion,
         dcv.importe_neto,
         dcv.importe_anticipo,
         dcv.importe_pendiente,
         dcv.importe_retgar,
         dco.precio_total_final,
         (COALESCE(dcv.importe_excento, 0::numeric) + COALESCE(dcv.importe_ice,
           0::numeric)) / dcv.importe_neto AS porc_monto_excento_var
  FROM tes.tsolicitud_rendicion_det srd
       JOIN conta.tdoc_compra_venta dcv ON srd.id_documento_respaldo =
         dcv.id_doc_compra_venta
       JOIN conta.tdoc_concepto dco ON dco.id_doc_compra_venta =
         dcv.id_doc_compra_venta
       JOIN param.tconcepto_ingas cig ON cig.id_concepto_ingas =
         dco.id_concepto_ingas;


-----------

DROP VIEW tes.vlibro_bancos;

CREATE OR REPLACE VIEW tes.vlibro_bancos(
    id_libro_bancos,
    num_tramite,
    id_cuenta_bancaria,
    fecha,
    a_favor,
    nro_cheque,
    importe_deposito,
    nro_liquidacion,
    detalle,
    origen,
    observaciones,
    importe_cheque,
    id_libro_bancos_fk,
    estado,
    nro_comprobante,
    indice,
    estado_reg,
    tipo,
    nro_deposito,
    fecha_reg,
    id_usuario_reg,
    fecha_mod,
    id_usuario_mod,
    usr_reg,
    usr_mod,
    id_depto,
    nombre_depto,
    id_proceso_wf,
    id_estado_wf,
    fecha_cheque_literal,
    id_finalidad,
    nombre_finalidad,
    color,
    saldo_deposito,
    nombre_regional,
    sistema_origen,
    comprobante_sigma,
    notificado,
    fondo_devolucion_retencion,
	columna_pk,
    id_int_comprobante)
AS
  SELECT lban.id_libro_bancos,
         lban.num_tramite,
         lban.id_cuenta_bancaria,
         lban.fecha,
         lban.a_favor,
         lban.nro_cheque,
         lban.importe_deposito,
         lban.nro_liquidacion,
         lban.detalle,
         lban.origen,
         lban.observaciones,
         lban.importe_cheque,
         lban.id_libro_bancos_fk,
         lban.estado,
         lban.nro_comprobante,
         lban.indice,
         lban.estado_reg,
         lban.tipo,
         lban.nro_deposito,
         lban.fecha_reg,
         lban.id_usuario_reg,
         lban.fecha_mod,
         lban.id_usuario_mod,
         usu1.cuenta AS usr_reg,
         usu2.cuenta AS usr_mod,
         lban.id_depto,
         depto.nombre AS nombre_depto,
         lban.id_proceso_wf,
         lban.id_estado_wf,
         upper(pxp.f_fecha_literal(lban.fecha)) AS fecha_cheque_literal,
         lban.id_finalidad,
         fin.nombre_finalidad,
         fin.color,
         CASE
           WHEN lban.tipo::text = 'deposito' ::text THEN lban.importe_deposito -
             COALESCE((
                        SELECT COALESCE(sum(lb.importe_cheque), 0::numeric) AS
                          "coalesce"
                        FROM tes.tts_libro_bancos lb
                        WHERE lb.id_libro_bancos_fk = lban.id_libro_bancos AND
                              (lb.tipo::text <> ALL (ARRAY [ 'deposito'
                                ::character varying::text,
                                'transf_interna_haber' ::character varying::text
                                ]))
         ), 0::numeric) + COALESCE((
                                     SELECT COALESCE(sum(lb.importe_deposito),
                                       0::numeric) AS "coalesce"
                                     FROM tes.tts_libro_bancos lb
                                     WHERE lb.id_libro_bancos_fk =
                                       lban.id_libro_bancos AND
                                           (lb.tipo::text = ANY (ARRAY [
                                             'deposito' ::character
                                             varying::text,
                                             'transf_interna_haber' ::character
                                             varying::text ]))
         ), 0::numeric)
           WHEN (lban.tipo::text = ANY (ARRAY [ 'cheque' ::character
             varying::text, 'debito_automatico' ::character varying::text,
             'transferencia_carta' ::character varying::text,
             'transf_interna_debe' ::character varying::text ])) AND
             lban.id_libro_bancos_fk IS NOT NULL THEN ((
                                                         SELECT COALESCE(
                                                           lb.importe_deposito,
                                                           0::numeric) AS
                                                           "coalesce"
                                                         FROM
                                                           tes.tts_libro_bancos
                                                           lb
                                                         WHERE
                                                           lb.id_libro_bancos =
                                                           lban.id_libro_bancos_fk
         )) +((
                SELECT COALESCE(sum(lb.importe_deposito), 0::numeric) AS
                  "coalesce"
                FROM tes.tts_libro_bancos lb
                WHERE lb.id_libro_bancos_fk = lban.id_libro_bancos_fk AND
                      (lb.tipo::text = ANY (ARRAY [ 'deposito' ::character
                        varying::text, 'transf_interna_haber' ::character
                        varying::text ]))
         )) -((
                SELECT sum(lb2.importe_cheque) AS sum
                FROM tes.tts_libro_bancos lb2
                WHERE lb2.id_libro_bancos <= lban.id_libro_bancos AND
                      lb2.id_libro_bancos_fk = lban.id_libro_bancos_fk AND
                      (lb2.tipo::text <> ALL (ARRAY [ 'deposito' ::character
                        varying::text, 'transf_interna_haber' ::character
                        varying::text ]))
         ))
           ELSE 0::numeric
         END AS saldo_deposito,
         reg.nombre_regional,
         lban.sistema_origen,
         lban.comprobante_sigma,
         lban.notificado,
         lban.fondo_devolucion_retencion,
		 lban.columna_pk,
         lban.id_int_comprobante
  FROM tes.tts_libro_bancos lban
       JOIN segu.tusuario usu1 ON usu1.id_usuario = lban.id_usuario_reg
       LEFT JOIN param.tdepto depto ON depto.id_depto = lban.id_depto
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = lban.id_usuario_mod
       JOIN tes.tfinalidad fin ON fin.id_finalidad = lban.id_finalidad
       LEFT JOIN param.tregional reg ON reg.codigo_regional::text =
         lban.origen::text
  ORDER BY lban.fecha DESC;


---------------------------------------------



CREATE OR REPLACE VIEW tes.vobligacion_pago(
    id_usuario_reg,
    id_usuario_mod,
    fecha_reg,
    fecha_mod,
    estado_reg,
    id_usuario_ai,
    usuario_ai,
    id_obligacion_pago,
    id_proveedor,
    id_funcionario,
    id_subsistema,
    id_moneda,
    id_depto,
    id_estado_wf,
    id_proceso_wf,
    id_gestion,
    fecha,
    numero,
    estado,
    obs,
    porc_anticipo,
    porc_retgar,
    tipo_cambio_conv,
    num_tramite,
    tipo_obligacion,
    comprometido,
    pago_variable,
    nro_cuota_vigente,
    total_pago,
    id_depto_conta,
    total_nro_cuota,
    id_plantilla,
    fecha_pp_ini,
    rotacion,
    ultima_cuota_pp,
    ultimo_estado_pp,
    tipo_anticipo,
    id_categoria_compra,
    tipo_solicitud,
    tipo_concepto_solicitud,
    id_funcionario_gerente,
    ajuste_anticipo,
    ajuste_aplicado,
    id_obligacion_pago_extendida,
    monto_estimado_sg,
    monto_ajuste_ret_garantia_ga,
    monto_ajuste_ret_anticipo_par_ga,
    id_contrato,
    obs_presupuestos,
    ultima_cuota_dev,
    codigo_poa,
    obs_poa,
    uo_ex,
    detalle)
AS
  SELECT op.id_usuario_reg,
    op.id_usuario_mod,
    op.fecha_reg,
    op.fecha_mod,
    op.estado_reg,
    op.id_usuario_ai,
    op.usuario_ai,
    op.id_obligacion_pago,
    op.id_proveedor,
    op.id_funcionario,
    op.id_subsistema,
    op.id_moneda,
    op.id_depto,
    op.id_estado_wf,
    op.id_proceso_wf,
    op.id_gestion,
    op.fecha,
    op.numero,
    op.estado,
    op.obs,
    op.porc_anticipo,
    op.porc_retgar,
    op.tipo_cambio_conv,
    op.num_tramite,
    op.tipo_obligacion,
    op.comprometido,
    op.pago_variable,
    op.nro_cuota_vigente,
    op.total_pago,
    op.id_depto_conta,
    op.total_nro_cuota,
    op.id_plantilla,
    op.fecha_pp_ini,
    op.rotacion,
    op.ultima_cuota_pp,
    op.ultimo_estado_pp,
    op.tipo_anticipo,
    op.id_categoria_compra,
    op.tipo_solicitud,
    op.tipo_concepto_solicitud,
    op.id_funcionario_gerente,
    op.ajuste_anticipo,
    op.ajuste_aplicado,
    op.id_obligacion_pago_extendida,
    op.monto_estimado_sg,
    op.monto_ajuste_ret_garantia_ga,
    op.monto_ajuste_ret_anticipo_par_ga,
    op.id_contrato,
    op.obs_presupuestos,
    op.ultima_cuota_dev,
    op.codigo_poa,
    op.obs_poa,
    op.uo_ex,
    ((('<table border="1"><TR>
   <TH>Concepto</TH>
   <TH>Detalle</TH>
   <TH>Importe ('::text || mon.codigo::text) || ')</TH>'::text) || pxp.html_rows
    (((((((((('<td>'::text || ci.desc_ingas::text) || '</td> <td>'::text) ||
            '<font hdden=true>'::text) || od.id_obligacion_det::character varying::text
          ) || '</font>'::text) || od.descripcion) || '</td> <td>'::text) ||
       od.monto_pago_mo::text) || '</td>'::text)::character varying)::text) ||
    '</table>'::text AS detalle
  FROM tes.tobligacion_pago op
    JOIN param.tmoneda mon ON mon.id_moneda = op.id_moneda
    JOIN param.tdepto dep ON dep.id_depto = op.id_depto
    LEFT JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor
    LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
                                           op.id_categoria_compra
    LEFT JOIN adq.tcotizacion cot ON op.id_obligacion_pago =
                                     cot.id_obligacion_pago
    LEFT JOIN adq.tproceso_compra pro ON pro.id_proceso_compra =
                                         cot.id_proceso_compra
    LEFT JOIN adq.tsolicitud sol ON sol.id_solicitud = pro.id_solicitud
    LEFT JOIN segu.vusuario ususol ON ususol.id_usuario = sol.id_usuario_reg
    JOIN tes.tobligacion_det od ON od.id_obligacion_pago =
                                   op.id_obligacion_pago AND od.estado_reg::text = 'activo'::text
    JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas =
                                     od.id_concepto_ingas
    JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario =
                                        op.id_funcionario AND fun.estado_reg_asi::text = 'activo'::text
    JOIN segu.vusuario usu ON usu.id_usuario = op.id_usuario_reg
  GROUP BY op.id_usuario_reg,
    op.id_usuario_mod,
    op.fecha_reg,
    op.fecha_mod,
    op.estado_reg,
    op.id_usuario_ai,
    op.usuario_ai,
    op.id_obligacion_pago,
    op.id_proveedor,
    op.id_funcionario,
    op.id_subsistema,
    op.id_moneda,
    op.id_depto,
    op.id_estado_wf,
    op.id_proceso_wf,
    op.id_gestion,
    op.fecha,
    op.numero,
    op.estado,
    op.obs,
    op.porc_anticipo,
    op.porc_retgar,
    op.tipo_cambio_conv,
    op.num_tramite,
    op.tipo_obligacion,
    op.comprometido,
    op.pago_variable,
    op.nro_cuota_vigente,
    op.total_pago,
    op.id_depto_conta,
    op.total_nro_cuota,
    op.id_plantilla,
    op.fecha_pp_ini,
    op.rotacion,
    op.ultima_cuota_pp,
    op.ultimo_estado_pp,
    op.tipo_anticipo,
    op.id_categoria_compra,
    op.tipo_solicitud,
    op.tipo_concepto_solicitud,
    op.id_funcionario_gerente,
    op.ajuste_anticipo,
    op.ajuste_aplicado,
    op.id_obligacion_pago_extendida,
    op.monto_estimado_sg,
    op.monto_ajuste_ret_garantia_ga,
    op.monto_ajuste_ret_anticipo_par_ga,
    op.id_contrato,
    op.obs_presupuestos,
    op.ultima_cuota_dev,
    op.codigo_poa,
    op.obs_poa,
    op.uo_ex,
    mon.codigo;



/***********************************F-DEP-JRR-TES-0-08/11/2016****************************************/

/***********************************I-DEP-GSS-TES-0-15/12/2016****************************************/

CREATE VIEW tes.vlibro_bancos_deposito_pc (
    id_proceso_caja,
    importe_deposito,
    id_cuenta_bancaria,
    id_depto_conta,
    id_libro_bancos)
AS
SELECT pc.id_proceso_caja,
    COALESCE(dppc.importe_contable_deposito, lb.importe_deposito,
        0::numeric(20,2)) AS importe_deposito,
    lb.id_cuenta_bancaria,
    pc.id_depto_conta,
    lb.id_libro_bancos
FROM tes.tts_libro_bancos lb
     LEFT JOIN tes.tdeposito_proceso_caja dppc ON dppc.id_libro_bancos =
         lb.id_libro_bancos
     JOIN tes.tproceso_caja pc ON pc.id_proceso_caja = lb.columna_pk_valor AND
         lb.tabla::text = 'tes.tproceso_caja'::text AND lb.columna_pk::text = 'id_proceso_caja'::text;

/***********************************F-DEP-GSS-TES-0-15/12/2016****************************************/

/***********************************I-DEP-GSS-TES-0-13/03/2017****************************************/

ALTER TABLE tes.tcaja_funcionario
  ADD CONSTRAINT fk_tcaja_funcionario__id_caja FOREIGN KEY (id_caja)
    REFERENCES tes.tcaja(id_caja)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE tes.tcaja_funcionario
  ADD CONSTRAINT fk_tcaja_funcionario__id_funcionario FOREIGN KEY (id_funcionario)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/***********************************F-DEP-GSS-TES-0-13/03/2017****************************************/




/***********************************I-DEP-RAC-TES-0-25/07/2017****************************************/

CREATE OR REPLACE VIEW tes.vcomp_devtesprov_plan_pago(
    id_plan_pago,
    id_proveedor,
    desc_proveedor,
    id_moneda,
    id_depto_conta,
    numero,
    fecha_actual,
    estado,
    monto_ejecutar_total_mb,
    monto_ejecutar_total_mo,
    monto,
    monto_mb,
    monto_retgar_mb,
    monto_retgar_mo,
    monto_no_pagado,
    monto_no_pagado_mb,
    otros_descuentos,
    otros_descuentos_mb,
    id_plantilla,
    id_cuenta_bancaria,
    id_cuenta_bancaria_mov,
    nro_cheque,
    nro_cuenta_bancaria,
    num_tramite,
    tipo,
    id_gestion_cuentas,
    id_int_comprobante,
    liquido_pagable,
    liquido_pagable_mb,
    nombre_pago,
    porc_monto_excento_var,
    obs_pp,
    descuento_anticipo,
    descuento_inter_serv,
    tipo_obligacion,
    id_categoria_compra,
    codigo_categoria,
    nombre_categoria,
    id_proceso_wf,
    forma_pago,
    monto_ajuste_ag,
    monto_ajuste_siguiente_pago,
    monto_anticipo,
    tipo_cambio_conv,
    id_depto_libro,
    fecha_costo_ini,
    fecha_costo_fin,
    id_obligacion_pago,
    fecha_tentativa,
    id_int_comprobante_rel)
AS
  SELECT pp.id_plan_pago,
         op.id_proveedor,
         p.desc_proveedor,
         op.id_moneda,
         op.id_depto_conta,
         op.numero,
         now() AS fecha_actual,
         pp.estado,
         pp.monto_ejecutar_total_mb,
         pp.monto_ejecutar_total_mo,
         pp.monto,
         pp.monto_mb,
         pp.monto_retgar_mb,
         pp.monto_retgar_mo,
         pp.monto_no_pagado,
         pp.monto_no_pagado_mb,
         pp.otros_descuentos,
         pp.otros_descuentos_mb,
         pp.id_plantilla,
         pp.id_cuenta_bancaria,
         pp.id_cuenta_bancaria_mov,
         pp.nro_cheque,
         pp.nro_cuenta_bancaria,
         op.num_tramite,
         pp.tipo,
         op.id_gestion AS id_gestion_cuentas,
         pp.id_int_comprobante,
         pp.liquido_pagable,
         pp.liquido_pagable_mb,
         pp.nombre_pago,
         pp.porc_monto_excento_var,
         ((COALESCE(op.numero, ''::character varying)::text || ' '::text) ||
           COALESCE(pp.obs_monto_no_pagado, ''::text))::character varying AS
           obs_pp,
         pp.descuento_anticipo,
         pp.descuento_inter_serv,
         op.tipo_obligacion,
         op.id_categoria_compra,
         COALESCE(cac.codigo, ''::character varying) AS codigo_categoria,
         COALESCE(cac.nombre, ''::character varying) AS nombre_categoria,
         pp.id_proceso_wf,
         pp.forma_pago,
         pp.monto_ajuste_ag,
         pp.monto_ajuste_siguiente_pago,
         pp.monto_anticipo,
         op.tipo_cambio_conv,
         pp.id_depto_lb AS id_depto_libro,
         CASE
           WHEN pp.fecha_costo_ini IS NULL THEN now()::date
           WHEN pp.fecha_costo_ini > now() THEN now()::date
           ELSE pp.fecha_costo_ini
         END AS fecha_costo_ini,
         COALESCE(pp.fecha_costo_fin, now()::date) AS fecha_costo_fin,
         op.id_obligacion_pago,
         pp.fecha_tentativa,
         pr.id_int_comprobante AS id_int_comprobante_rel
  FROM tes.tplan_pago pp
       JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago =
         op.id_obligacion_pago
       JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor
       LEFT JOIN tes.tplan_pago pr ON pr.id_plan_pago = pp.id_plan_pago_fk
       LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
         op.id_categoria_compra;
/***********************************F-DEP-RAC-TES-0-25/07/2017****************************************/



/***********************************I-DEP-RAC-TES-0-31/07/2017****************************************/

CREATE OR REPLACE VIEW tes.vpagos_relacionados(
    desc_proveedor,
    num_tramite,
    estado,
    fecha_tentativa,
    nro_cuota,
    monto,
    codigo,
    conceptos,
    ordenes,
    id_orden_trabajos,
    id_concepto_ingas,
    id_plan_pago,
    id_proceso_wf,
    id_estado_wf,
    id_proveedor,
    obs,
    tipo)
AS
WITH detalle AS(
  SELECT op_1.id_obligacion_pago,
         pxp.list(cig.desc_ingas::text) AS conceptos,
         pxp.list(ot.desc_orden::text) AS ordenes,
         pxp.aggarray(od.id_orden_trabajo::text) AS id_orden_trabajos,
         pxp.aggarray(od.id_concepto_ingas::text) AS id_concepto_ingas
  FROM tes.tobligacion_pago op_1
       JOIN tes.tobligacion_det od ON od.id_obligacion_pago =
         op_1.id_obligacion_pago
       JOIN param.tconcepto_ingas cig ON cig.id_concepto_ingas =
         od.id_concepto_ingas
       LEFT JOIN conta.torden_trabajo ot ON ot.id_orden_trabajo =
         od.id_orden_trabajo
  GROUP BY op_1.id_obligacion_pago)
    SELECT prov.desc_proveedor,
           op.num_tramite,
           pp.estado,
           pp.fecha_tentativa,
           pp.nro_cuota,
           pp.monto,
           mon.codigo,
           det.conceptos,
           det.ordenes,
           det.id_orden_trabajos,
           det.id_concepto_ingas,
           pp.id_plan_pago,
           pp.id_proceso_wf,
           pp.id_estado_wf,
           op.id_proveedor,
           op.obs,
           pp.tipo
    FROM tes.tobligacion_pago op
         JOIN param.vproveedor prov ON prov.id_proveedor = op.id_proveedor
         JOIN tes.tplan_pago pp ON pp.id_obligacion_pago = op.id_obligacion_pago
         JOIN param.tmoneda mon ON mon.id_moneda = op.id_moneda
         JOIN detalle det ON det.id_obligacion_pago = op.id_obligacion_pago;


/***********************************F-DEP-RAC-TES-0-31/07/2017****************************************/



/***********************************I-DEP-RAC-TES-0-29/08/2017****************************************/



--------------- SQL ---------------

 -- object recreation
DROP VIEW tes.vpagos_relacionados;

CREATE VIEW tes.vpagos_relacionados
AS
WITH detalle AS(
  SELECT op_1.id_obligacion_pago,
         pxp.list(cig.desc_ingas::text) AS conceptos,
         pxp.list(ot.desc_orden::text) AS ordenes,
         pxp.aggarray(od.id_orden_trabajo::text) AS id_orden_trabajos,
         pxp.aggarray(od.id_concepto_ingas::text) AS id_concepto_ingas
  FROM tes.tobligacion_pago op_1
       JOIN tes.tobligacion_det od ON od.id_obligacion_pago =
         op_1.id_obligacion_pago
       JOIN param.tconcepto_ingas cig ON cig.id_concepto_ingas =
         od.id_concepto_ingas
       LEFT JOIN conta.torden_trabajo ot ON ot.id_orden_trabajo =
         od.id_orden_trabajo
  GROUP BY op_1.id_obligacion_pago)
    SELECT prov.desc_proveedor,
           op.num_tramite,
           pp.estado,
           COALESCE(pp.fecha_tentativa, op.fecha) AS fecha_tentativa,
           pp.nro_cuota,
           pp.monto,
           param.f_convertir_moneda(op.id_moneda, 1, pp.monto, op.fecha,'O',2) as monto_mb,

           mon.codigo,
           det.conceptos,
           det.ordenes,
           det.id_orden_trabajos,
           det.id_concepto_ingas,
           pp.id_plan_pago,
           pp.id_proceso_wf,
           pp.id_estado_wf,
           op.id_proveedor,
           op.obs,
           pp.tipo
    FROM tes.tobligacion_pago op
         JOIN param.vproveedor prov ON prov.id_proveedor = op.id_proveedor
         JOIN tes.tplan_pago pp ON pp.id_obligacion_pago = op.id_obligacion_pago
         JOIN param.tmoneda mon ON mon.id_moneda = op.id_moneda
         JOIN detalle det ON det.id_obligacion_pago = op.id_obligacion_pago;


/***********************************F-DEP-RAC-TES-0-29/08/2017****************************************/



/***********************************I-DEP-RAC-TES-0-27/11/2017****************************************/

CREATE OR REPLACE VIEW tes.vcontratos_det(
    desc_proveedor,
    id_proveedor,
    id_moenda_contrato,
    id_contrato,
    numero,
    objeto,
    monto_contrato,
    monto_devengado,
    monto_anticipo,
    liquido_pagable_total,
    anticipo_iquido_pagable,
    descuento_anticipo,
    anticipo_aplicado,
    monto_retgar_mo,
    dev_garantia_iquido_pagable)
AS
WITH contrato_lst AS(
  SELECT con.id_contrato,
         con.numero,
         con.objeto,
         con.monto AS monto_contrato,
         con.id_moneda,
         sum(pp.monto) AS monto,
         sum(pp.monto_anticipo) AS monto_anticipo,
         sum(pp.monto_retgar_mo) AS monto_retgar_mo,
         sum(pp.liquido_pagable) AS liquido_pagable,
         sum(pp.descuento_anticipo) AS descuento_anticipo,
         pp.tipo
  FROM leg.tcontrato con
       JOIN tes.tobligacion_pago op ON op.id_contrato = con.id_contrato
       JOIN tes.tplan_pago pp ON pp.id_obligacion_pago = op.id_obligacion_pago
         AND pp.estado_reg::text = 'activo'::text
  WHERE (pp.estado::text = ANY (ARRAY [ 'anticipado'::character varying::text,
    'devengado'::character varying::text, 'pagado'::character varying::text,
    'devuelto'::character varying::text, 'contabilizado'::character varying::
    text, 'aplicado'::character varying::text ])) AND
        pp.estado::text <> 'anulado'::text
  GROUP BY con.id_contrato,
           con.numero,
           con.objeto,
           con.monto,
           con.id_moneda,
           pp.tipo)
    SELECT pro.desc_proveedor,
           pro.id_proveedor,
           c.id_moneda AS id_moenda_contrato,
           c.id_contrato,
           c.numero,
           c.objeto,
           c.monto AS monto_contrato,
           sum(COALESCE(devengado_pagado.monto, 0::numeric)) + sum(COALESCE(
             devengado.monto, 0::numeric)) + sum(COALESCE(
             devengado_pagado_1c.monto, 0::numeric)) + sum(COALESCE(
             ant_aplicado.monto, 0::numeric)) AS monto_devengado,
           sum(COALESCE(devengado_pagado.monto_anticipo, 0::numeric)) + sum(
             COALESCE(devengado.monto_anticipo, 0::numeric)) + sum(COALESCE(
             devengado_pagado_1c.monto_anticipo, 0::numeric)) AS monto_anticipo,
           sum(COALESCE(pagado.liquido_pagable, 0::numeric)) + sum(COALESCE(
             devengado_pagado_1c.liquido_pagable, 0::numeric)) + sum(COALESCE(
             anticipo.liquido_pagable, 0::numeric)) + sum(COALESCE(
             ant_parcial.liquido_pagable, 0::numeric)) + sum(COALESCE(
             dev_garantia.liquido_pagable, 0::numeric)) AS liquido_pagable_total
  ,
           sum(COALESCE(anticipo.liquido_pagable, 0::numeric)) + sum(COALESCE(
             ant_parcial.liquido_pagable, 0::numeric)) AS
             anticipo_iquido_pagable,
           sum(COALESCE(devengado_pagado.descuento_anticipo, 0::numeric)) + sum(
             COALESCE(devengado.descuento_anticipo, 0::numeric)) + sum(COALESCE(
             devengado_pagado_1c.descuento_anticipo, 0::numeric)) AS
             descuento_anticipo,
           sum(COALESCE(ant_aplicado.monto, 0::numeric)) AS anticipo_aplicado,
           sum(COALESCE(devengado_pagado.monto_retgar_mo, 0::numeric)) + sum(
             COALESCE(devengado.monto_retgar_mo, 0::numeric)) + sum(COALESCE(
             devengado_pagado_1c.monto_retgar_mo, 0::numeric)) AS
             monto_retgar_mo,
           sum(COALESCE(dev_garantia.liquido_pagable, 0::numeric)) AS
             dev_garantia_iquido_pagable
    FROM leg.tcontrato c
         JOIN param.vproveedor pro ON pro.id_proveedor = c.id_proveedor
         LEFT JOIN contrato_lst devengado_pagado ON devengado_pagado.id_contrato
           = c.id_contrato AND devengado_pagado.tipo::text = 'devengado_pagado'
           ::text
         LEFT JOIN contrato_lst devengado ON devengado.id_contrato =
           c.id_contrato AND devengado.tipo::text = 'devengado'::text
         LEFT JOIN contrato_lst devengado_pagado_1c ON
           devengado_pagado_1c.id_contrato = c.id_contrato AND
           devengado_pagado_1c.tipo::text = 'devengado_pagado_1c'::text
         LEFT JOIN contrato_lst anticipo ON anticipo.id_contrato = c.id_contrato
           AND anticipo.tipo::text = 'anticipo'::text
         LEFT JOIN contrato_lst ant_parcial ON ant_parcial.id_contrato =
           c.id_contrato AND ant_parcial.tipo::text = 'ant_parcial'::text
         LEFT JOIN contrato_lst dev_garantia ON dev_garantia.id_contrato =
           c.id_contrato AND dev_garantia.tipo::text = 'dev_garantia'::text
         LEFT JOIN contrato_lst ant_aplicado ON ant_aplicado.id_contrato =
           c.id_contrato AND ant_aplicado.tipo::text = 'ant_aplicado'::text
         LEFT JOIN contrato_lst pagado ON pagado.id_contrato = c.id_contrato AND
           pagado.tipo::text = 'pagado'::text
    GROUP BY pro.desc_proveedor,
             pro.id_proveedor,
             c.id_moneda,
             c.id_contrato,
             c.numero,
             c.objeto,
             c.monto;


/***********************************F-DEP-RAC-TES-0-27/11/2017****************************************/



/***********************************I-DEP-RAC-TES-0-29/11/2017****************************************/

-- vista apra incluir vales provisorios en el cbte de rendicion de caja 

CREATE OR REPLACE VIEW tes.vsrd_doc_compra_venta_efectivo_provisorio_det(
    id_solicitud_rendicion_det,
    id_proceso_caja,
    id_moneda,
    id_int_comprobante,
    id_plantilla,
    importe_doc,
    importe_excento,
    importe_total_excento,
    importe_descuento,
    importe_descuento_ley,
    importe_ice,
    importe_it,
    importe_iva,
    importe_pago_liquido,
    nro_documento,
    nro_dui,
    nro_autorizacion,
    razon_social,
    revisado,
    manual,
    obs,
    nit,
    fecha,
    codigo_control,
    sw_contabilizar,
    tipo,
    id_doc_compra_venta,
    descripcion,
    importe_neto,
    id_auxiliar)
AS
  SELECT srd.id_solicitud_rendicion_det,
         srd.id_proceso_caja,
         dcv.id_moneda,
         dcv.id_int_comprobante,
         dcv.id_plantilla,
         dcv.importe_doc,
         dcv.importe_excento,
         COALESCE(dcv.importe_excento, 0::numeric) + COALESCE(dcv.importe_ice, 0
           ::numeric) AS importe_total_excento,
         dcv.importe_descuento,
         dcv.importe_descuento_ley,
         dcv.importe_ice,
         dcv.importe_it,
         dcv.importe_iva,
         dcv.importe_pago_liquido,
         dcv.nro_documento,
         dcv.nro_dui,
         dcv.nro_autorizacion,
         dcv.razon_social,
         dcv.revisado,
         dcv.manual,
         dcv.obs,
         dcv.nit,
         dcv.fecha,
         dcv.codigo_control,
         dcv.sw_contabilizar,
         dcv.tipo,
         dcv.id_doc_compra_venta,
         (((dcv.razon_social::text || ' - '::text) || ' ( '::text) ||
           ' ) Nro Doc: '::text) || COALESCE(dcv.nro_documento)::text AS
           descripcion,
         dcv.importe_neto,
         dcv.id_auxiliar
  FROM tes.tsolicitud_rendicion_det srd
       JOIN conta.tdoc_compra_venta dcv ON srd.id_documento_respaldo =
         dcv.id_doc_compra_venta
       JOIN param.tplantilla pl ON pl.id_plantilla = dcv.id_plantilla
  WHERE pl.tipo_informe::text = 'efectivo'::text;
  
  
  
/***********************************F-DEP-RAC-TES-0-29/11/2017****************************************/
  
  
   
/***********************************I-DEP-RAC-TES-0-24/02/2018****************************************/
  
   
  
  CREATE OR REPLACE VIEW tes.vlibro_bancos(
    id_libro_bancos,
    num_tramite,
    id_cuenta_bancaria,
    fecha,
    a_favor,
    nro_cheque,
    importe_deposito,
    nro_liquidacion,
    detalle,
    origen,
    observaciones,
    importe_cheque,
    id_libro_bancos_fk,
    estado,
    nro_comprobante,
    indice,
    estado_reg,
    tipo,
    nro_deposito,
    fecha_reg,
    id_usuario_reg,
    fecha_mod,
    id_usuario_mod,
    usr_reg,
    usr_mod,
    id_depto,
    nombre_depto,
    id_proceso_wf,
    id_estado_wf,
    fecha_cheque_literal,
    id_finalidad,
    nombre_finalidad,
    color,
    saldo_deposito,
    nombre_regional,
    sistema_origen,
    comprobante_sigma,
    notificado,
    fondo_devolucion_retencion,
    columna_pk,
    id_int_comprobante)
AS
  SELECT lban.id_libro_bancos,
         lban.num_tramite,
         lban.id_cuenta_bancaria,
         lban.fecha,
         lban.a_favor,
         lban.nro_cheque,
         lban.importe_deposito,
         lban.nro_liquidacion,
         lban.detalle,
         lban.origen,
         lban.observaciones,
         lban.importe_cheque,
         lban.id_libro_bancos_fk,
         lban.estado,
         ((lban.id_int_comprobante::character varying::text || ' - '::text) ||
           lban.nro_comprobante::text)::character varying AS nro_comprobante,
         lban.indice,
         lban.estado_reg,
         lban.tipo,
         lban.nro_deposito,
         lban.fecha_reg,
         lban.id_usuario_reg,
         lban.fecha_mod,
         lban.id_usuario_mod,
         usu1.cuenta AS usr_reg,
         usu2.cuenta AS usr_mod,
         lban.id_depto,
         depto.nombre AS nombre_depto,
         lban.id_proceso_wf,
         lban.id_estado_wf,
         upper(pxp.f_fecha_literal(lban.fecha)) AS fecha_cheque_literal,
         lban.id_finalidad,
         fin.nombre_finalidad,
         fin.color,
         CASE
           WHEN lban.tipo::text = 'deposito'::text THEN lban.importe_deposito -
             COALESCE((
                        SELECT COALESCE(sum(lb.importe_cheque), 0::numeric) AS
                          "coalesce"
                        FROM tes.tts_libro_bancos lb
                        WHERE lb.id_libro_bancos_fk = lban.id_libro_bancos AND
                              (lb.tipo::text <> ALL (ARRAY [ 'deposito'::
                                character varying::text, 'transf_interna_haber'
                                ::character varying::text ]))
         ), 0::numeric) + COALESCE((
                                     SELECT COALESCE(sum(lb.importe_deposito), 0
                                       ::numeric) AS "coalesce"
                                     FROM tes.tts_libro_bancos lb
                                     WHERE lb.id_libro_bancos_fk =
                                       lban.id_libro_bancos AND
                                           (lb.tipo::text = ANY (ARRAY [
                                             'deposito'::character varying::
                                             text, 'transf_interna_haber'::
                                             character varying::text ]))
         ), 0::numeric)
           WHEN (lban.tipo::text = ANY (ARRAY [ 'cheque'::character varying::
             text, 'debito_automatico'::character varying::text,
             'transferencia_carta'::character varying::text,
             'transf_interna_debe'::character varying::text ])) AND
             lban.id_libro_bancos_fk IS NOT NULL THEN ((
                                                         SELECT COALESCE(
                                                           lb.importe_deposito,
                                                           0::numeric) AS
                                                           "coalesce"
                                                         FROM
                                                           tes.tts_libro_bancos
                                                           lb
                                                         WHERE
                                                           lb.id_libro_bancos =
                                                           lban.id_libro_bancos_fk
         )) +((
                SELECT COALESCE(sum(lb.importe_deposito), 0::numeric) AS
                  "coalesce"
                FROM tes.tts_libro_bancos lb
                WHERE lb.id_libro_bancos_fk = lban.id_libro_bancos_fk AND
                      (lb.tipo::text = ANY (ARRAY [ 'deposito'::character
                        varying::text, 'transf_interna_haber'::character varying
                        ::text ]))
         )) -((
                SELECT sum(lb2.importe_cheque) AS sum
                FROM tes.tts_libro_bancos lb2
                WHERE lb2.id_libro_bancos <= lban.id_libro_bancos AND
                      lb2.id_libro_bancos_fk = lban.id_libro_bancos_fk AND
                      (lb2.tipo::text <> ALL (ARRAY [ 'deposito'::character
                        varying::text, 'transf_interna_haber'::character varying
                        ::text ]))
         ))
           ELSE 0::numeric
         END AS saldo_deposito,
         reg.nombre_regional,
         lban.sistema_origen,
         lban.comprobante_sigma,
         lban.notificado,
         lban.fondo_devolucion_retencion,
         lban.columna_pk,
         lban.id_int_comprobante
  FROM tes.tts_libro_bancos lban
       JOIN segu.tusuario usu1 ON usu1.id_usuario = lban.id_usuario_reg
       LEFT JOIN param.tdepto depto ON depto.id_depto = lban.id_depto
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = lban.id_usuario_mod
       JOIN tes.tfinalidad fin ON fin.id_finalidad = lban.id_finalidad
       LEFT JOIN param.tregional reg ON reg.codigo_regional::text = lban.origen
         ::text
  ORDER BY lban.fecha DESC;


-----------------------------------------------------------------------

-------------------

select pxp.f_insert_testructura_gui ('TES', 'SISTEMA');
select pxp.f_delete_testructura_gui ('OBPG', 'TES');
select pxp.f_insert_testructura_gui ('OBPG.1', 'OBPG');
select pxp.f_delete_testructura_gui ('CTABAN', 'TES');
select pxp.f_delete_testructura_gui ('CAJA', 'TES');
select pxp.f_delete_testructura_gui ('CTABANE', 'TES');
select pxp.f_delete_testructura_gui ('TIPP', 'TES');
select pxp.f_delete_testructura_gui ('CTABANCEND', 'TES');
select pxp.f_delete_testructura_gui ('VBPDC', 'TES');
select pxp.f_delete_testructura_gui ('OPUNI', 'TES');
select pxp.f_delete_testructura_gui ('VBOPOA', 'TES');
select pxp.f_insert_testructura_gui ('REPPP', 'REPOP');
select pxp.f_delete_testructura_gui ('SOLEFE', 'TES');
select pxp.f_delete_testructura_gui ('VBCAJA', 'TES');
select pxp.f_insert_testructura_gui ('CAJA.2', 'CAJA');
select pxp.f_insert_testructura_gui ('CAJA.2.1', 'CAJA.2');
select pxp.f_insert_testructura_gui ('CAJA.2.1.1', 'CAJA.2.1');
select pxp.f_insert_testructura_gui ('CAJA.2.1.2', 'CAJA.2.1');
select pxp.f_insert_testructura_gui ('CAJA.2.1.3', 'CAJA.2.1');
select pxp.f_insert_testructura_gui ('CAJA.2.1.4', 'CAJA.2.1');
select pxp.f_insert_testructura_gui ('CAJA.2.1.5', 'CAJA.2.1');
select pxp.f_insert_testructura_gui ('CAJA.2.1.5.1', 'CAJA.2.1.5');
select pxp.f_insert_testructura_gui ('CAJA.2.1.5.1.1', 'CAJA.2.1.5.1');
select pxp.f_insert_testructura_gui ('SOLEFE.1', 'SOLEFE');
select pxp.f_insert_testructura_gui ('VBCAJA.1', 'VBCAJA');
select pxp.f_insert_testructura_gui ('VBCAJA.2', 'VBCAJA');
select pxp.f_insert_testructura_gui ('VBCAJA.1.1', 'VBCAJA.1');
select pxp.f_insert_testructura_gui ('VBCAJA.1.1.1', 'VBCAJA.1.1');
select pxp.f_insert_testructura_gui ('VBCAJA.1.1.2', 'VBCAJA.1.1');
select pxp.f_insert_testructura_gui ('VBCAJA.1.1.3', 'VBCAJA.1.1');
select pxp.f_insert_testructura_gui ('VBCAJA.1.1.4', 'VBCAJA.1.1');
select pxp.f_insert_testructura_gui ('VBCAJA.1.1.5', 'VBCAJA.1.1');
select pxp.f_insert_testructura_gui ('VBCAJA.1.1.5.1', 'VBCAJA.1.1.5');
select pxp.f_insert_testructura_gui ('VBCAJA.1.1.5.1.1', 'VBCAJA.1.1.5.1');
select pxp.f_delete_testructura_gui ('SOLEFESD', 'TES');
select pxp.f_delete_testructura_gui ('VBSOLEFE', 'TES');
select pxp.f_delete_testructura_gui ('VBRENCJ', 'TES');
select pxp.f_insert_testructura_gui ('CAJA.3', 'CAJA');
select pxp.f_insert_testructura_gui ('CAJA.3.1', 'CAJA.3');
select pxp.f_insert_testructura_gui ('CAJA.3.2', 'CAJA.3');
select pxp.f_insert_testructura_gui ('SOLEFE.2', 'SOLEFE');
select pxp.f_insert_testructura_gui ('SOLEFE.3', 'SOLEFE');
select pxp.f_insert_testructura_gui ('SOLEFE.4', 'SOLEFE');
select pxp.f_insert_testructura_gui ('SOLEFE.2.1', 'SOLEFE.2');
select pxp.f_insert_testructura_gui ('SOLEFE.2.1.1', 'SOLEFE.2.1');
select pxp.f_insert_testructura_gui ('SOLEFE.2.1.2', 'SOLEFE.2.1');
select pxp.f_insert_testructura_gui ('SOLEFE.2.1.3', 'SOLEFE.2.1');
select pxp.f_insert_testructura_gui ('SOLEFE.2.1.4', 'SOLEFE.2.1');
select pxp.f_insert_testructura_gui ('SOLEFE.2.1.5', 'SOLEFE.2.1');
select pxp.f_insert_testructura_gui ('SOLEFE.2.1.5.1', 'SOLEFE.2.1.5');
select pxp.f_insert_testructura_gui ('SOLEFE.2.1.5.1.1', 'SOLEFE.2.1.5.1');
select pxp.f_insert_testructura_gui ('SOLEFE.3.1', 'SOLEFE.3');
select pxp.f_insert_testructura_gui ('SOLEFE.4.1', 'SOLEFE.4');
select pxp.f_insert_testructura_gui ('VBCAJA.3', 'VBCAJA');
select pxp.f_insert_testructura_gui ('VBCAJA.4', 'VBCAJA');
select pxp.f_insert_testructura_gui ('VBCAJA.4.1', 'VBCAJA.4');
select pxp.f_insert_testructura_gui ('VBCAJA.4.2', 'VBCAJA.4');
select pxp.f_insert_testructura_gui ('SOLEFESD.1', 'SOLEFESD');
select pxp.f_insert_testructura_gui ('SOLEFESD.2', 'SOLEFESD');
select pxp.f_insert_testructura_gui ('SOLEFESD.1.1', 'SOLEFESD.1');
select pxp.f_insert_testructura_gui ('SOLEFESD.2.1', 'SOLEFESD.2');
select pxp.f_insert_testructura_gui ('SOLEFESD.2.1.1', 'SOLEFESD.2.1');
select pxp.f_insert_testructura_gui ('SOLEFESD.2.1.2', 'SOLEFESD.2.1');
select pxp.f_insert_testructura_gui ('SOLEFESD.2.1.3', 'SOLEFESD.2.1');
select pxp.f_insert_testructura_gui ('SOLEFESD.2.1.4', 'SOLEFESD.2.1');
select pxp.f_insert_testructura_gui ('SOLEFESD.2.1.5', 'SOLEFESD.2.1');
select pxp.f_insert_testructura_gui ('SOLEFESD.2.1.5.1', 'SOLEFESD.2.1.5');
select pxp.f_insert_testructura_gui ('SOLEFESD.2.1.5.1.1', 'SOLEFESD.2.1.5.1');
select pxp.f_insert_testructura_gui ('VBSOLEFE.1', 'VBSOLEFE');
select pxp.f_insert_testructura_gui ('VBSOLEFE.2', 'VBSOLEFE');
select pxp.f_insert_testructura_gui ('VBSOLEFE.3', 'VBSOLEFE');
select pxp.f_insert_testructura_gui ('VBSOLEFE.2.1', 'VBSOLEFE.2');
select pxp.f_insert_testructura_gui ('VBSOLEFE.2.1.1', 'VBSOLEFE.2.1');
select pxp.f_insert_testructura_gui ('VBSOLEFE.2.1.2', 'VBSOLEFE.2.1');
select pxp.f_insert_testructura_gui ('VBSOLEFE.2.1.3', 'VBSOLEFE.2.1');
select pxp.f_insert_testructura_gui ('VBSOLEFE.2.1.4', 'VBSOLEFE.2.1');
select pxp.f_insert_testructura_gui ('VBSOLEFE.2.1.5', 'VBSOLEFE.2.1');
select pxp.f_insert_testructura_gui ('VBSOLEFE.2.1.5.1', 'VBSOLEFE.2.1.5');
select pxp.f_insert_testructura_gui ('VBSOLEFE.2.1.5.1.1', 'VBSOLEFE.2.1.5.1');
select pxp.f_insert_testructura_gui ('VBRENCJ.1', 'VBRENCJ');
select pxp.f_insert_testructura_gui ('VBRENCJ.2', 'VBRENCJ');
select pxp.f_insert_testructura_gui ('VBRENCJ.3', 'VBRENCJ');
select pxp.f_insert_testructura_gui ('VBRENCJ.2.1', 'VBRENCJ.2');
select pxp.f_insert_testructura_gui ('VBRENCJ.2.1.1', 'VBRENCJ.2.1');
select pxp.f_insert_testructura_gui ('VBRENCJ.2.1.2', 'VBRENCJ.2.1');
select pxp.f_insert_testructura_gui ('VBRENCJ.2.1.3', 'VBRENCJ.2.1');
select pxp.f_insert_testructura_gui ('VBRENCJ.2.1.4', 'VBRENCJ.2.1');
select pxp.f_insert_testructura_gui ('VBRENCJ.2.1.5', 'VBRENCJ.2.1');
select pxp.f_insert_testructura_gui ('VBRENCJ.2.1.5.1', 'VBRENCJ.2.1.5');
select pxp.f_insert_testructura_gui ('VBRENCJ.2.1.5.1.1', 'VBRENCJ.2.1.5.1');
select pxp.f_delete_testructura_gui ('SOLCAJA', 'TES');
select pxp.f_insert_testructura_gui ('CAJA.3.1.1', 'CAJA.3.1');
select pxp.f_insert_testructura_gui ('CAJA.3.1.1.1', 'CAJA.3.1.1');
select pxp.f_insert_testructura_gui ('CAJA.3.1.1.2', 'CAJA.3.1.1');
select pxp.f_insert_testructura_gui ('CAJA.3.1.1.3', 'CAJA.3.1.1');
select pxp.f_insert_testructura_gui ('CAJA.3.1.1.4', 'CAJA.3.1.1');
select pxp.f_insert_testructura_gui ('CAJA.3.1.1.5', 'CAJA.3.1.1');
select pxp.f_insert_testructura_gui ('CAJA.3.1.1.5.1', 'CAJA.3.1.1.5');
select pxp.f_insert_testructura_gui ('CAJA.3.1.1.5.1.1', 'CAJA.3.1.1.5.1');
select pxp.f_insert_testructura_gui ('SOLCAJA.1', 'SOLCAJA');
select pxp.f_insert_testructura_gui ('SOLCAJA.2', 'SOLCAJA');
select pxp.f_insert_testructura_gui ('SOLCAJA.1.1', 'SOLCAJA.1');
select pxp.f_insert_testructura_gui ('SOLCAJA.1.1.1', 'SOLCAJA.1.1');
select pxp.f_insert_testructura_gui ('SOLCAJA.1.1.2', 'SOLCAJA.1.1');
select pxp.f_insert_testructura_gui ('SOLCAJA.1.1.3', 'SOLCAJA.1.1');
select pxp.f_insert_testructura_gui ('SOLCAJA.1.1.4', 'SOLCAJA.1.1');
select pxp.f_insert_testructura_gui ('SOLCAJA.1.1.5', 'SOLCAJA.1.1');
select pxp.f_insert_testructura_gui ('SOLCAJA.1.1.5.1', 'SOLCAJA.1.1.5');
select pxp.f_insert_testructura_gui ('SOLCAJA.1.1.5.1.1', 'SOLCAJA.1.1.5.1');
select pxp.f_insert_testructura_gui ('REPPPBA', 'REPOP');
select pxp.f_delete_testructura_gui ('PRCRE', 'TES');
select pxp.f_delete_testructura_gui ('PP', 'TES');
select pxp.f_delete_testructura_gui ('PPC', 'TES');
select pxp.f_delete_testructura_gui ('VBPCOS', 'TES');
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
select pxp.f_delete_testructura_gui ('VBDP', 'TES');
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
select pxp.f_insert_testructura_gui ('OBPG.3.3.2', 'OBPG.3.3');
select pxp.f_insert_testructura_gui ('OBPG.4.1', 'OBPG.4');
select pxp.f_insert_testructura_gui ('OBPG.4.2', 'OBPG.4');
select pxp.f_insert_testructura_gui ('OBPG.6.3.1.1', 'OBPG.6.3.1');
select pxp.f_insert_testructura_gui ('OBPG.7.1.1.1', 'OBPG.7.1.1');
select pxp.f_insert_testructura_gui ('OBPG.7.1.1.1.1', 'OBPG.7.1.1.1');
select pxp.f_insert_testructura_gui ('OBPG.7.2.1', 'OBPG.7.2');
select pxp.f_insert_testructura_gui ('VBDP.2.2.3.1.1', 'VBDP.2.2.3.1');
select pxp.f_insert_testructura_gui ('VBDP.3.2', 'VBDP.3');
select pxp.f_insert_testructura_gui ('OBPG.8', 'OBPG');
select pxp.f_insert_testructura_gui ('OBPG.8.1', 'OBPG.8');
select pxp.f_insert_testructura_gui ('OBPG.8.2', 'OBPG.8');
select pxp.f_insert_testructura_gui ('OBPG.8.3', 'OBPG.8');
select pxp.f_insert_testructura_gui ('OBPG.8.3.1', 'OBPG.8.3');
select pxp.f_insert_testructura_gui ('OBPG.8.3.2', 'OBPG.8.3');
select pxp.f_delete_testructura_gui ('CONEX', 'TES');
select pxp.f_delete_testructura_gui ('SOLPD', 'TES');
select pxp.f_insert_testructura_gui ('OBPG.8.4', 'OBPG.8');
select pxp.f_insert_testructura_gui ('OBPG.8.5', 'OBPG.8');
select pxp.f_insert_testructura_gui ('OBPG.3.4', 'OBPG.3');
select pxp.f_insert_testructura_gui ('OBPG.3.5', 'OBPG.3');
select pxp.f_insert_testructura_gui ('VBDP.4', 'VBDP');
select pxp.f_insert_testructura_gui ('VBDP.5', 'VBDP');
select pxp.f_insert_testructura_gui ('SOLPD.1', 'SOLPD');
select pxp.f_insert_testructura_gui ('SOLPD.2', 'SOLPD');
select pxp.f_insert_testructura_gui ('SOLPD.3', 'SOLPD');
select pxp.f_insert_testructura_gui ('SOLPD.4', 'SOLPD');
select pxp.f_insert_testructura_gui ('SOLPD.5', 'SOLPD');
select pxp.f_insert_testructura_gui ('SOLPD.6', 'SOLPD');
select pxp.f_insert_testructura_gui ('SOLPD.7', 'SOLPD');
select pxp.f_insert_testructura_gui ('SOLPD.2.1', 'SOLPD.2');
select pxp.f_insert_testructura_gui ('SOLPD.2.2', 'SOLPD.2');
select pxp.f_insert_testructura_gui ('SOLPD.2.3', 'SOLPD.2');
select pxp.f_insert_testructura_gui ('SOLPD.2.4', 'SOLPD.2');
select pxp.f_insert_testructura_gui ('SOLPD.2.5', 'SOLPD.2');
select pxp.f_insert_testructura_gui ('SOLPD.2.5.1', 'SOLPD.2.5');
select pxp.f_insert_testructura_gui ('SOLPD.2.5.2', 'SOLPD.2.5');
select pxp.f_insert_testructura_gui ('SOLPD.4.1', 'SOLPD.4');
select pxp.f_insert_testructura_gui ('SOLPD.4.2', 'SOLPD.4');
select pxp.f_insert_testructura_gui ('SOLPD.4.3', 'SOLPD.4');
select pxp.f_insert_testructura_gui ('SOLPD.4.4', 'SOLPD.4');
select pxp.f_insert_testructura_gui ('SOLPD.4.5', 'SOLPD.4');
select pxp.f_insert_testructura_gui ('SOLPD.4.5.1', 'SOLPD.4.5');
select pxp.f_insert_testructura_gui ('SOLPD.4.5.2', 'SOLPD.4.5');
select pxp.f_insert_testructura_gui ('SOLPD.5.1', 'SOLPD.5');
select pxp.f_insert_testructura_gui ('SOLPD.5.2', 'SOLPD.5');
select pxp.f_insert_testructura_gui ('SOLPD.7.1', 'SOLPD.7');
select pxp.f_insert_testructura_gui ('SOLPD.7.2', 'SOLPD.7');
select pxp.f_insert_testructura_gui ('SOLPD.7.3', 'SOLPD.7');
select pxp.f_insert_testructura_gui ('SOLPD.7.2.1', 'SOLPD.7.2');
select pxp.f_insert_testructura_gui ('SOLPD.7.3.1', 'SOLPD.7.3');
select pxp.f_insert_testructura_gui ('SOLPD.7.3.1.1', 'SOLPD.7.3.1');
select pxp.f_insert_testructura_gui ('OBPG.1.1', 'OBPG.1');
select pxp.f_insert_testructura_gui ('SOLPD.1.1', 'SOLPD.1');
select pxp.f_delete_testructura_gui ('REVBPP', 'TES');
select pxp.f_insert_testructura_gui ('REVBPP.1', 'REVBPP');
select pxp.f_insert_testructura_gui ('REVBPP.2', 'REVBPP');
select pxp.f_insert_testructura_gui ('REVBPP.3', 'REVBPP');
select pxp.f_insert_testructura_gui ('REVBPP.4', 'REVBPP');
select pxp.f_insert_testructura_gui ('REVBPP.5', 'REVBPP');
select pxp.f_insert_testructura_gui ('REVBPP.2.1', 'REVBPP.2');
select pxp.f_insert_testructura_gui ('REVBPP.2.2', 'REVBPP.2');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.1', 'REVBPP.2.2');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.2', 'REVBPP.2.2');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.3', 'REVBPP.2.2');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.2.1', 'REVBPP.2.2.2');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.3.1', 'REVBPP.2.2.3');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.3.1.1', 'REVBPP.2.2.3.1');
select pxp.f_insert_testructura_gui ('REVBPP.5.1', 'REVBPP.5');
select pxp.f_insert_testructura_gui ('REVBPP.5.2', 'REVBPP.5');
select pxp.f_delete_testructura_gui ('VBOP', 'TES');
select pxp.f_insert_testructura_gui ('VBOP.1', 'VBOP');
select pxp.f_insert_testructura_gui ('VBOP.2', 'VBOP');
select pxp.f_insert_testructura_gui ('VBOP.3', 'VBOP');
select pxp.f_insert_testructura_gui ('VBOP.4', 'VBOP');
select pxp.f_insert_testructura_gui ('VBOP.5', 'VBOP');
select pxp.f_insert_testructura_gui ('VBOP.6', 'VBOP');
select pxp.f_insert_testructura_gui ('VBOP.7', 'VBOP');
select pxp.f_insert_testructura_gui ('VBOP.1.1', 'VBOP.1');
select pxp.f_insert_testructura_gui ('VBOP.2.1', 'VBOP.2');
select pxp.f_insert_testructura_gui ('VBOP.2.2', 'VBOP.2');
select pxp.f_insert_testructura_gui ('VBOP.2.3', 'VBOP.2');
select pxp.f_insert_testructura_gui ('VBOP.2.4', 'VBOP.2');
select pxp.f_insert_testructura_gui ('VBOP.2.5', 'VBOP.2');
select pxp.f_insert_testructura_gui ('VBOP.2.5.1', 'VBOP.2.5');
select pxp.f_insert_testructura_gui ('VBOP.2.5.2', 'VBOP.2.5');
select pxp.f_insert_testructura_gui ('VBOP.4.1', 'VBOP.4');
select pxp.f_insert_testructura_gui ('VBOP.4.2', 'VBOP.4');
select pxp.f_insert_testructura_gui ('VBOP.4.3', 'VBOP.4');
select pxp.f_insert_testructura_gui ('VBOP.4.4', 'VBOP.4');
select pxp.f_insert_testructura_gui ('VBOP.4.5', 'VBOP.4');
select pxp.f_insert_testructura_gui ('VBOP.4.5.1', 'VBOP.4.5');
select pxp.f_insert_testructura_gui ('VBOP.4.5.2', 'VBOP.4.5');
select pxp.f_insert_testructura_gui ('VBOP.5.1', 'VBOP.5');
select pxp.f_insert_testructura_gui ('VBOP.5.2', 'VBOP.5');
select pxp.f_insert_testructura_gui ('VBOP.7.1', 'VBOP.7');
select pxp.f_insert_testructura_gui ('VBOP.7.2', 'VBOP.7');
select pxp.f_insert_testructura_gui ('VBOP.7.3', 'VBOP.7');
select pxp.f_insert_testructura_gui ('VBOP.7.2.1', 'VBOP.7.2');
select pxp.f_insert_testructura_gui ('VBOP.7.3.1', 'VBOP.7.3');
select pxp.f_insert_testructura_gui ('VBOP.7.3.1.1', 'VBOP.7.3.1');
select pxp.f_delete_testructura_gui ('TIPPRO', 'TES');
select pxp.f_insert_testructura_gui ('VBDP.6', 'VBDP');
select pxp.f_insert_testructura_gui ('VBDP.6.1', 'VBDP.6');
select pxp.f_insert_testructura_gui ('VBDP.6.2', 'VBDP.6');
select pxp.f_insert_testructura_gui ('VBDP.6.3', 'VBDP.6');
select pxp.f_insert_testructura_gui ('VBDP.6.4', 'VBDP.6');
select pxp.f_insert_testructura_gui ('VBDP.6.5', 'VBDP.6');
select pxp.f_insert_testructura_gui ('VBDP.6.6', 'VBDP.6');
select pxp.f_insert_testructura_gui ('VBDP.6.7', 'VBDP.6');
select pxp.f_insert_testructura_gui ('VBDP.6.1.1', 'VBDP.6.1');
select pxp.f_insert_testructura_gui ('VBDP.6.3.1', 'VBDP.6.3');
select pxp.f_insert_testructura_gui ('VBDP.6.4.1', 'VBDP.6.4');
select pxp.f_insert_testructura_gui ('VBDP.6.4.2', 'VBDP.6.4');
select pxp.f_insert_testructura_gui ('VBDP.6.4.3', 'VBDP.6.4');
select pxp.f_insert_testructura_gui ('VBDP.6.4.4', 'VBDP.6.4');
select pxp.f_insert_testructura_gui ('VBDP.6.4.5', 'VBDP.6.4');
select pxp.f_insert_testructura_gui ('VBDP.6.4.5.1', 'VBDP.6.4.5');
select pxp.f_insert_testructura_gui ('VBDP.6.4.5.2', 'VBDP.6.4.5');
select pxp.f_insert_testructura_gui ('VBDP.6.5.1', 'VBDP.6.5');
select pxp.f_insert_testructura_gui ('VBDP.6.5.2', 'VBDP.6.5');
select pxp.f_insert_testructura_gui ('VBDP.6.7.1', 'VBDP.6.7');
select pxp.f_insert_testructura_gui ('VBDP.6.7.2', 'VBDP.6.7');
select pxp.f_insert_testructura_gui ('VBDP.6.7.3', 'VBDP.6.7');
select pxp.f_insert_testructura_gui ('VBDP.6.7.2.1', 'VBDP.6.7.2');
select pxp.f_insert_testructura_gui ('VBDP.6.7.3.1', 'VBDP.6.7.3');
select pxp.f_insert_testructura_gui ('VBDP.6.7.3.1.1', 'VBDP.6.7.3.1');
select pxp.f_delete_testructura_gui ('REPOP', 'TES');
select pxp.f_insert_testructura_gui ('REPPAGCON', 'REPOP');
select pxp.f_insert_testructura_gui ('REPPAGCON.1', 'REPPAGCON');
select pxp.f_delete_testructura_gui ('OPCONTA', 'TES');
select pxp.f_delete_testructura_gui ('CONOP', 'TES');
select pxp.f_insert_testructura_gui ('CAROP', 'TES');
select pxp.f_insert_testructura_gui ('CARLB', 'TES');
select pxp.f_insert_testructura_gui ('CARFR', 'TES');
select pxp.f_delete_testructura_gui ('SOLPD', 'CAROP');
select pxp.f_delete_testructura_gui ('OPUNI', 'CAROP');
select pxp.f_delete_testructura_gui ('OBPG', 'CAROP');
select pxp.f_insert_testructura_gui ('CTABAN', 'CARLB');
select pxp.f_delete_testructura_gui ('VBOPOA', 'CAROP');
select pxp.f_delete_testructura_gui ('VBOP', 'CAROP');
select pxp.f_insert_testructura_gui ('CTABANE', 'CARLB');
select pxp.f_delete_testructura_gui ('VBDP', 'CAROP');
select pxp.f_delete_testructura_gui ('VBPDC', 'CAROP');
select pxp.f_insert_testructura_gui ('CTABANCEND', 'CARLB');
select pxp.f_delete_testructura_gui ('VBPCOS', 'CAROP');
select pxp.f_delete_testructura_gui ('REVBPP', 'CAROP');
select pxp.f_delete_testructura_gui ('TIPP', 'CAROP');
select pxp.f_insert_testructura_gui ('CAJA', 'CARFR');
select pxp.f_delete_testructura_gui ('CONOP', 'CAROP');
select pxp.f_insert_testructura_gui ('SOLCAJA', 'CARFR');
select pxp.f_insert_testructura_gui ('VBCAJA', 'CARFR');
select pxp.f_insert_testructura_gui ('SOLEFE', 'CARFR');
select pxp.f_insert_testructura_gui ('SOLEFESD', 'CARFR');
select pxp.f_insert_testructura_gui ('VBSOLEFE', 'CARFR');
select pxp.f_insert_testructura_gui ('VBRENCJ', 'CARFR');
select pxp.f_delete_testructura_gui ('OPCONTA', 'CAROP');
select pxp.f_delete_testructura_gui ('TIPPRO', 'CAROP');
select pxp.f_delete_testructura_gui ('CONEX', 'CAROP');
select pxp.f_insert_testructura_gui ('REPOP', 'CAROP');
select pxp.f_delete_testructura_gui ('PRCRE', 'CAROP');
select pxp.f_delete_testructura_gui ('PP', 'CAROP');
select pxp.f_delete_testructura_gui ('PPC', 'CAROP');
select pxp.f_insert_testructura_gui ('CAOPCOFG', 'CAROP');
select pxp.f_insert_testructura_gui ('TIPPRO', 'CAOPCOFG');
select pxp.f_insert_testructura_gui ('TIPP', 'CAOPCOFG');
select pxp.f_insert_testructura_gui ('CONEX', 'CAOPCOFG');
select pxp.f_insert_testructura_gui ('PRCRE', 'REPOP');
select pxp.f_insert_testructura_gui ('CAROPSOL', 'CAROP');
select pxp.f_insert_testructura_gui ('OPUNI', 'CAROPSOL');
select pxp.f_insert_testructura_gui ('SOLPD', 'CAROPSOL');
select pxp.f_insert_testructura_gui ('OBPG', 'CAROPSOL');
select pxp.f_insert_testructura_gui ('PP', 'REPOP');
select pxp.f_insert_testructura_gui ('CAROPVB', 'CAROP');
select pxp.f_insert_testructura_gui ('VBOPOA', 'CAROPVB');
select pxp.f_insert_testructura_gui ('VBOP', 'CAROPVB');
select pxp.f_insert_testructura_gui ('VBDP', 'CAROPVB');
select pxp.f_insert_testructura_gui ('VBPCOS', 'CAROPVB');
select pxp.f_insert_testructura_gui ('PPC', 'REPOP');
select pxp.f_insert_testructura_gui ('VBPDC', 'CAROPVB');
select pxp.f_insert_testructura_gui ('REVBPP', 'CAROPVB');
select pxp.f_insert_testructura_gui ('OPCONTA', 'REPOP');
select pxp.f_insert_testructura_gui ('CONOP', 'REPOP');
select pxp.f_delete_testructura_gui ('REPLB', 'CARLB');
select pxp.f_insert_testructura_gui ('FINCUE', 'CARLB');
select pxp.f_delete_testructura_gui ('TPC', 'CARFR');
select pxp.f_insert_testructura_gui ('VBCJ', 'CARFR');
select pxp.f_insert_testructura_gui ('VBCP', 'CARFR');
select pxp.f_delete_testructura_gui ('TPSOL', 'CARFR');
select pxp.f_insert_testructura_gui ('VBFACREN', 'CARFR');
select pxp.f_insert_testructura_gui ('VBRENCJA', 'CARFR');
select pxp.f_insert_testructura_gui ('OBPG.9', 'OBPG');
select pxp.f_insert_testructura_gui ('OBPG.10', 'OBPG');
select pxp.f_insert_testructura_gui ('OBPG.11', 'OBPG');
select pxp.f_insert_testructura_gui ('OBPG.8.6', 'OBPG.8');
select pxp.f_insert_testructura_gui ('OBPG.8.7', 'OBPG.8');
select pxp.f_insert_testructura_gui ('OBPG.8.5.1', 'OBPG.8.5');
select pxp.f_insert_testructura_gui ('OBPG.8.5.1.1', 'OBPG.8.5.1');
select pxp.f_insert_testructura_gui ('OBPG.8.5.1.2', 'OBPG.8.5.1');
select pxp.f_insert_testructura_gui ('OBPG.8.5.1.3', 'OBPG.8.5.1');
select pxp.f_insert_testructura_gui ('OBPG.8.5.1.4', 'OBPG.8.5.1');
select pxp.f_insert_testructura_gui ('OBPG.8.5.1.5', 'OBPG.8.5.1');
select pxp.f_insert_testructura_gui ('OBPG.8.5.1.5.1', 'OBPG.8.5.1.5');
select pxp.f_insert_testructura_gui ('OBPG.8.5.1.5.1.1', 'OBPG.8.5.1.5.1');
select pxp.f_insert_testructura_gui ('OBPG.8.7.1', 'OBPG.8.7');
select pxp.f_insert_testructura_gui ('OBPG.8.7.1.1', 'OBPG.8.7.1');
select pxp.f_insert_testructura_gui ('OBPG.8.7.1.2', 'OBPG.8.7.1');
select pxp.f_insert_testructura_gui ('OBPG.8.7.1.3', 'OBPG.8.7.1');
select pxp.f_insert_testructura_gui ('OBPG.8.7.1.4', 'OBPG.8.7.1');
select pxp.f_insert_testructura_gui ('OBPG.8.7.1.1.1', 'OBPG.8.7.1.1');
select pxp.f_insert_testructura_gui ('OBPG.8.7.1.1.1.1', 'OBPG.8.7.1.1.1');
select pxp.f_insert_testructura_gui ('OBPG.8.7.1.1.1.1.1', 'OBPG.8.7.1.1.1.1');
select pxp.f_insert_testructura_gui ('OBPG.8.7.1.1.1.1.2', 'OBPG.8.7.1.1.1.1');
select pxp.f_insert_testructura_gui ('OBPG.8.7.1.1.1.1.2.1', 'OBPG.8.7.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('OBPG.8.7.1.1.1.1.2.2', 'OBPG.8.7.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('OBPG.3.6', 'OBPG.3');
select pxp.f_insert_testructura_gui ('OBPG.3.7', 'OBPG.3');
select pxp.f_insert_testructura_gui ('OBPG.6.4', 'OBPG.6');
select pxp.f_insert_testructura_gui ('OBPG.6.5', 'OBPG.6');
select pxp.f_insert_testructura_gui ('OBPG.6.6', 'OBPG.6');
select pxp.f_insert_testructura_gui ('OBPG.6.7', 'OBPG.6');
select pxp.f_insert_testructura_gui ('OBPG.6.8', 'OBPG.6');
select pxp.f_insert_testructura_gui ('OBPG.6.4.1', 'OBPG.6.4');
select pxp.f_insert_testructura_gui ('CTABAN.3', 'CTABAN');
select pxp.f_insert_testructura_gui ('CTABAN.4', 'CTABAN');
select pxp.f_insert_testructura_gui ('CTABAN.5', 'CTABAN');
select pxp.f_insert_testructura_gui ('CTABAN.4.1', 'CTABAN.4');
select pxp.f_insert_testructura_gui ('CTABAN.4.1.1', 'CTABAN.4.1');
select pxp.f_insert_testructura_gui ('CTABAN.4.1.2', 'CTABAN.4.1');
select pxp.f_insert_testructura_gui ('CTABAN.4.1.3', 'CTABAN.4.1');
select pxp.f_insert_testructura_gui ('CTABAN.4.1.4', 'CTABAN.4.1');
select pxp.f_insert_testructura_gui ('CTABAN.4.1.1.1', 'CTABAN.4.1.1');
select pxp.f_insert_testructura_gui ('CTABAN.4.1.1.2', 'CTABAN.4.1.1');
select pxp.f_insert_testructura_gui ('CTABAN.4.1.1.2.1', 'CTABAN.4.1.1.2');
select pxp.f_insert_testructura_gui ('CTABAN.4.1.1.2.2', 'CTABAN.4.1.1.2');
select pxp.f_insert_testructura_gui ('CTABAN.4.1.4.1', 'CTABAN.4.1.4');
select pxp.f_insert_testructura_gui ('CAJA.4', 'CAJA');
select pxp.f_insert_testructura_gui ('CAJA.5', 'CAJA');
select pxp.f_insert_testructura_gui ('CAJA.6', 'CAJA');
select pxp.f_insert_testructura_gui ('CAJA.4.1', 'CAJA.4');
select pxp.f_insert_testructura_gui ('CAJA.4.2', 'CAJA.4');
select pxp.f_insert_testructura_gui ('CAJA.4.3', 'CAJA.4');
select pxp.f_insert_testructura_gui ('CAJA.4.4', 'CAJA.4');
select pxp.f_insert_testructura_gui ('CAJA.4.1.1', 'CAJA.4.1');
select pxp.f_insert_testructura_gui ('CAJA.4.1.1.1', 'CAJA.4.1.1');
select pxp.f_insert_testructura_gui ('CAJA.4.1.1.2', 'CAJA.4.1.1');
select pxp.f_insert_testructura_gui ('CAJA.4.1.1.3', 'CAJA.4.1.1');
select pxp.f_insert_testructura_gui ('CAJA.4.1.1.4', 'CAJA.4.1.1');
select pxp.f_insert_testructura_gui ('CAJA.4.1.1.5', 'CAJA.4.1.1');
select pxp.f_insert_testructura_gui ('CAJA.4.1.1.5.1', 'CAJA.4.1.1.5');
select pxp.f_insert_testructura_gui ('CAJA.4.1.1.5.1.1', 'CAJA.4.1.1.5.1');
select pxp.f_insert_testructura_gui ('CAJA.4.4.1', 'CAJA.4.4');
select pxp.f_insert_testructura_gui ('CAJA.4.4.2', 'CAJA.4.4');
select pxp.f_insert_testructura_gui ('CAJA.5.1', 'CAJA.5');
select pxp.f_insert_testructura_gui ('CAJA.5.1.1', 'CAJA.5.1');
select pxp.f_insert_testructura_gui ('CAJA.5.1.2', 'CAJA.5.1');
select pxp.f_insert_testructura_gui ('CAJA.5.1.3', 'CAJA.5.1');
select pxp.f_insert_testructura_gui ('CAJA.5.1.4', 'CAJA.5.1');
select pxp.f_insert_testructura_gui ('CAJA.5.1.1.1', 'CAJA.5.1.1');
select pxp.f_insert_testructura_gui ('CAJA.5.1.1.1.1', 'CAJA.5.1.1.1');
select pxp.f_insert_testructura_gui ('CAJA.5.1.1.1.1.1', 'CAJA.5.1.1.1.1');
select pxp.f_insert_testructura_gui ('CAJA.5.1.1.1.1.2', 'CAJA.5.1.1.1.1');
select pxp.f_insert_testructura_gui ('CAJA.5.1.1.1.1.2.1', 'CAJA.5.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('CAJA.5.1.1.1.1.2.2', 'CAJA.5.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('CAJA.6.1', 'CAJA.6');
select pxp.f_insert_testructura_gui ('CTABANE.4', 'CTABANE');
select pxp.f_insert_testructura_gui ('CTABANE.5', 'CTABANE');
select pxp.f_insert_testructura_gui ('CTABANE.6', 'CTABANE');
select pxp.f_insert_testructura_gui ('CTABANE.7', 'CTABANE');
select pxp.f_insert_testructura_gui ('CTABANE.8', 'CTABANE');
select pxp.f_insert_testructura_gui ('CTABANE.5.1', 'CTABANE.5');
select pxp.f_insert_testructura_gui ('CTABANE.5.2', 'CTABANE.5');
select pxp.f_insert_testructura_gui ('CTABANE.5.3', 'CTABANE.5');
select pxp.f_insert_testructura_gui ('CTABANE.5.1.1', 'CTABANE.5.1');
select pxp.f_insert_testructura_gui ('CTABANE.5.1.1.1', 'CTABANE.5.1.1');
select pxp.f_insert_testructura_gui ('CTABANE.5.1.1.2', 'CTABANE.5.1.1');
select pxp.f_insert_testructura_gui ('CTABANE.5.1.1.3', 'CTABANE.5.1.1');
select pxp.f_insert_testructura_gui ('CTABANE.5.1.1.4', 'CTABANE.5.1.1');
select pxp.f_insert_testructura_gui ('CTABANE.5.1.1.5', 'CTABANE.5.1.1');
select pxp.f_insert_testructura_gui ('CTABANE.5.1.1.5.1', 'CTABANE.5.1.1.5');
select pxp.f_insert_testructura_gui ('CTABANE.5.1.1.5.1.1', 'CTABANE.5.1.1.5.1');
select pxp.f_insert_testructura_gui ('CTABANE.5.3.1', 'CTABANE.5.3');
select pxp.f_insert_testructura_gui ('CTABANE.7.1', 'CTABANE.7');
select pxp.f_insert_testructura_gui ('CTABANE.7.1.1', 'CTABANE.7.1');
select pxp.f_insert_testructura_gui ('CTABANE.7.1.2', 'CTABANE.7.1');
select pxp.f_insert_testructura_gui ('CTABANE.7.1.3', 'CTABANE.7.1');
select pxp.f_insert_testructura_gui ('CTABANE.7.1.4', 'CTABANE.7.1');
select pxp.f_insert_testructura_gui ('CTABANE.7.1.1.1', 'CTABANE.7.1.1');
select pxp.f_insert_testructura_gui ('CTABANE.7.1.1.2', 'CTABANE.7.1.1');
select pxp.f_insert_testructura_gui ('CTABANE.7.1.1.2.1', 'CTABANE.7.1.1.2');
select pxp.f_insert_testructura_gui ('CTABANE.7.1.1.2.2', 'CTABANE.7.1.1.2');
select pxp.f_insert_testructura_gui ('CTABANE.7.1.4.1', 'CTABANE.7.1.4');
select pxp.f_insert_testructura_gui ('VBDP.7', 'VBDP');
select pxp.f_insert_testructura_gui ('VBDP.8', 'VBDP');
select pxp.f_insert_testructura_gui ('VBDP.6.8', 'VBDP.6');
select pxp.f_insert_testructura_gui ('VBDP.6.9', 'VBDP.6');
select pxp.f_insert_testructura_gui ('VBDP.6.10', 'VBDP.6');
select pxp.f_insert_testructura_gui ('VBDP.6.4.6', 'VBDP.6.4');
select pxp.f_insert_testructura_gui ('VBDP.6.4.7', 'VBDP.6.4');
select pxp.f_insert_testructura_gui ('VBDP.6.4.4.1', 'VBDP.6.4.4');
select pxp.f_insert_testructura_gui ('VBDP.6.4.4.1.1', 'VBDP.6.4.4.1');
select pxp.f_insert_testructura_gui ('VBDP.6.4.4.1.2', 'VBDP.6.4.4.1');
select pxp.f_insert_testructura_gui ('VBDP.6.4.4.1.3', 'VBDP.6.4.4.1');
select pxp.f_insert_testructura_gui ('VBDP.6.4.4.1.4', 'VBDP.6.4.4.1');
select pxp.f_insert_testructura_gui ('VBDP.6.4.4.1.5', 'VBDP.6.4.4.1');
select pxp.f_insert_testructura_gui ('VBDP.6.4.4.1.5.1', 'VBDP.6.4.4.1.5');
select pxp.f_insert_testructura_gui ('VBDP.6.4.4.1.5.1.1', 'VBDP.6.4.4.1.5.1');
select pxp.f_insert_testructura_gui ('VBDP.6.4.7.1', 'VBDP.6.4.7');
select pxp.f_insert_testructura_gui ('VBDP.6.4.7.1.1', 'VBDP.6.4.7.1');
select pxp.f_insert_testructura_gui ('VBDP.6.4.7.1.2', 'VBDP.6.4.7.1');
select pxp.f_insert_testructura_gui ('VBDP.6.4.7.1.3', 'VBDP.6.4.7.1');
select pxp.f_insert_testructura_gui ('VBDP.6.4.7.1.4', 'VBDP.6.4.7.1');
select pxp.f_insert_testructura_gui ('VBDP.6.4.7.1.1.1', 'VBDP.6.4.7.1.1');
select pxp.f_insert_testructura_gui ('VBDP.6.4.7.1.1.1.1', 'VBDP.6.4.7.1.1.1');
select pxp.f_insert_testructura_gui ('VBDP.6.4.7.1.1.1.1.1', 'VBDP.6.4.7.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBDP.6.4.7.1.1.1.1.2', 'VBDP.6.4.7.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBDP.6.4.7.1.1.1.1.2.1', 'VBDP.6.4.7.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('VBDP.6.4.7.1.1.1.1.2.2', 'VBDP.6.4.7.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('VBDP.6.7.4', 'VBDP.6.7');
select pxp.f_insert_testructura_gui ('VBDP.6.7.5', 'VBDP.6.7');
select pxp.f_insert_testructura_gui ('VBDP.6.7.6', 'VBDP.6.7');
select pxp.f_insert_testructura_gui ('VBDP.6.7.7', 'VBDP.6.7');
select pxp.f_insert_testructura_gui ('VBDP.6.7.8', 'VBDP.6.7');
select pxp.f_insert_testructura_gui ('VBDP.6.7.4.1', 'VBDP.6.7.4');
select pxp.f_insert_testructura_gui ('SOLPD.8', 'SOLPD');
select pxp.f_insert_testructura_gui ('SOLPD.9', 'SOLPD');
select pxp.f_insert_testructura_gui ('SOLPD.10', 'SOLPD');
select pxp.f_insert_testructura_gui ('SOLPD.2.6', 'SOLPD.2');
select pxp.f_insert_testructura_gui ('SOLPD.2.7', 'SOLPD.2');
select pxp.f_insert_testructura_gui ('SOLPD.2.4.1', 'SOLPD.2.4');
select pxp.f_insert_testructura_gui ('SOLPD.2.4.1.1', 'SOLPD.2.4.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.4.1.2', 'SOLPD.2.4.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.4.1.3', 'SOLPD.2.4.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.4.1.4', 'SOLPD.2.4.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.4.1.5', 'SOLPD.2.4.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.4.1.5.1', 'SOLPD.2.4.1.5');
select pxp.f_insert_testructura_gui ('SOLPD.2.4.1.5.1.1', 'SOLPD.2.4.1.5.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.7.1', 'SOLPD.2.7');
select pxp.f_insert_testructura_gui ('SOLPD.2.7.1.1', 'SOLPD.2.7.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.7.1.2', 'SOLPD.2.7.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.7.1.3', 'SOLPD.2.7.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.7.1.4', 'SOLPD.2.7.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.7.1.1.1', 'SOLPD.2.7.1.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.7.1.1.1.1', 'SOLPD.2.7.1.1.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.7.1.1.1.1.1', 'SOLPD.2.7.1.1.1.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.7.1.1.1.1.2', 'SOLPD.2.7.1.1.1.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.7.1.1.1.1.2.1', 'SOLPD.2.7.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('SOLPD.2.7.1.1.1.1.2.2', 'SOLPD.2.7.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('SOLPD.4.6', 'SOLPD.4');
select pxp.f_insert_testructura_gui ('SOLPD.4.7', 'SOLPD.4');
select pxp.f_insert_testructura_gui ('SOLPD.7.4', 'SOLPD.7');
select pxp.f_insert_testructura_gui ('SOLPD.7.5', 'SOLPD.7');
select pxp.f_insert_testructura_gui ('SOLPD.7.6', 'SOLPD.7');
select pxp.f_insert_testructura_gui ('SOLPD.7.7', 'SOLPD.7');
select pxp.f_insert_testructura_gui ('SOLPD.7.8', 'SOLPD.7');
select pxp.f_insert_testructura_gui ('SOLPD.7.4.1', 'SOLPD.7.4');
select pxp.f_insert_testructura_gui ('CTABANCEND.1', 'CTABANCEND');
select pxp.f_insert_testructura_gui ('CTABANCEND.2', 'CTABANCEND');
select pxp.f_insert_testructura_gui ('CTABANCEND.1.1', 'CTABANCEND.1');
select pxp.f_insert_testructura_gui ('CTABANCEND.1.2', 'CTABANCEND.1');
select pxp.f_insert_testructura_gui ('CTABANCEND.1.3', 'CTABANCEND.1');
select pxp.f_insert_testructura_gui ('CTABANCEND.1.4', 'CTABANCEND.1');
select pxp.f_insert_testructura_gui ('CTABANCEND.1.1.1', 'CTABANCEND.1.1');
select pxp.f_insert_testructura_gui ('CTABANCEND.1.1.1.1', 'CTABANCEND.1.1.1');
select pxp.f_insert_testructura_gui ('CTABANCEND.1.1.1.2', 'CTABANCEND.1.1.1');
select pxp.f_insert_testructura_gui ('CTABANCEND.1.1.1.3', 'CTABANCEND.1.1.1');
select pxp.f_insert_testructura_gui ('CTABANCEND.1.1.1.4', 'CTABANCEND.1.1.1');
select pxp.f_insert_testructura_gui ('CTABANCEND.1.1.1.5', 'CTABANCEND.1.1.1');
select pxp.f_insert_testructura_gui ('CTABANCEND.1.1.1.5.1', 'CTABANCEND.1.1.1.5');
select pxp.f_insert_testructura_gui ('CTABANCEND.1.1.1.5.1.1', 'CTABANCEND.1.1.1.5.1');
select pxp.f_insert_testructura_gui ('CTABANCEND.1.3.1', 'CTABANCEND.1.3');
select pxp.f_insert_testructura_gui ('CTABANCEND.1.3.2', 'CTABANCEND.1.3');
select pxp.f_insert_testructura_gui ('CTABANCEND.1.3.3', 'CTABANCEND.1.3');
select pxp.f_insert_testructura_gui ('CTABANCEND.1.3.4', 'CTABANCEND.1.3');
select pxp.f_insert_testructura_gui ('CTABANCEND.1.3.4.1', 'CTABANCEND.1.3.4');
select pxp.f_insert_testructura_gui ('CTABANCEND.1.4.1', 'CTABANCEND.1.4');
select pxp.f_insert_testructura_gui ('CTABANCEND.1.4.2', 'CTABANCEND.1.4');
select pxp.f_insert_testructura_gui ('CTABANCEND.2.1', 'CTABANCEND.2');
select pxp.f_insert_testructura_gui ('CTABANCEND.2.1.1', 'CTABANCEND.2.1');
select pxp.f_insert_testructura_gui ('CTABANCEND.2.1.2', 'CTABANCEND.2.1');
select pxp.f_insert_testructura_gui ('CTABANCEND.2.1.2.1', 'CTABANCEND.2.1.2');
select pxp.f_insert_testructura_gui ('CTABANCEND.2.1.2.2', 'CTABANCEND.2.1.2');
select pxp.f_insert_testructura_gui ('REVBPP.6', 'REVBPP');
select pxp.f_insert_testructura_gui ('REVBPP.7', 'REVBPP');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.4', 'REVBPP.2.2');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.5', 'REVBPP.2.2');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.6', 'REVBPP.2.2');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.7', 'REVBPP.2.2');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.8', 'REVBPP.2.2');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.4.1', 'REVBPP.2.2.4');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.4.1.1', 'REVBPP.2.2.4.1');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.4.1.1.1', 'REVBPP.2.2.4.1.1');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.4.1.1.2', 'REVBPP.2.2.4.1.1');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.4.1.1.2.1', 'REVBPP.2.2.4.1.1.2');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.4.1.1.2.2', 'REVBPP.2.2.4.1.1.2');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.6.1', 'REVBPP.2.2.6');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.6.1.1', 'REVBPP.2.2.6.1');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.6.1.2', 'REVBPP.2.2.6.1');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.6.1.3', 'REVBPP.2.2.6.1');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.6.1.4', 'REVBPP.2.2.6.1');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.6.1.5', 'REVBPP.2.2.6.1');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.6.1.5.1', 'REVBPP.2.2.6.1.5');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.6.1.5.1.1', 'REVBPP.2.2.6.1.5.1');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.8.1', 'REVBPP.2.2.8');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.8.1.1', 'REVBPP.2.2.8.1');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.8.1.2', 'REVBPP.2.2.8.1');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.8.1.3', 'REVBPP.2.2.8.1');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.8.1.4', 'REVBPP.2.2.8.1');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.8.1.1.1', 'REVBPP.2.2.8.1.1');
select pxp.f_insert_testructura_gui ('VBOP.8', 'VBOP');
select pxp.f_insert_testructura_gui ('VBOP.9', 'VBOP');
select pxp.f_insert_testructura_gui ('VBOP.10', 'VBOP');
select pxp.f_insert_testructura_gui ('VBOP.2.6', 'VBOP.2');
select pxp.f_insert_testructura_gui ('VBOP.2.7', 'VBOP.2');
select pxp.f_insert_testructura_gui ('VBOP.2.4.1', 'VBOP.2.4');
select pxp.f_insert_testructura_gui ('VBOP.2.4.1.1', 'VBOP.2.4.1');
select pxp.f_insert_testructura_gui ('VBOP.2.4.1.2', 'VBOP.2.4.1');
select pxp.f_insert_testructura_gui ('VBOP.2.4.1.3', 'VBOP.2.4.1');
select pxp.f_insert_testructura_gui ('VBOP.2.4.1.4', 'VBOP.2.4.1');
select pxp.f_insert_testructura_gui ('VBOP.2.4.1.5', 'VBOP.2.4.1');
select pxp.f_insert_testructura_gui ('VBOP.2.4.1.5.1', 'VBOP.2.4.1.5');
select pxp.f_insert_testructura_gui ('VBOP.2.4.1.5.1.1', 'VBOP.2.4.1.5.1');
select pxp.f_insert_testructura_gui ('VBOP.2.7.1', 'VBOP.2.7');
select pxp.f_insert_testructura_gui ('VBOP.2.7.1.1', 'VBOP.2.7.1');
select pxp.f_insert_testructura_gui ('VBOP.2.7.1.2', 'VBOP.2.7.1');
select pxp.f_insert_testructura_gui ('VBOP.2.7.1.3', 'VBOP.2.7.1');
select pxp.f_insert_testructura_gui ('VBOP.2.7.1.4', 'VBOP.2.7.1');
select pxp.f_insert_testructura_gui ('VBOP.2.7.1.1.1', 'VBOP.2.7.1.1');
select pxp.f_insert_testructura_gui ('VBOP.2.7.1.1.1.1', 'VBOP.2.7.1.1.1');
select pxp.f_insert_testructura_gui ('VBOP.2.7.1.1.1.1.1', 'VBOP.2.7.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBOP.2.7.1.1.1.1.2', 'VBOP.2.7.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBOP.2.7.1.1.1.1.2.1', 'VBOP.2.7.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('VBOP.2.7.1.1.1.1.2.2', 'VBOP.2.7.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('VBOP.4.6', 'VBOP.4');
select pxp.f_insert_testructura_gui ('VBOP.4.7', 'VBOP.4');
select pxp.f_insert_testructura_gui ('VBOP.7.4', 'VBOP.7');
select pxp.f_insert_testructura_gui ('VBOP.7.5', 'VBOP.7');
select pxp.f_insert_testructura_gui ('VBOP.7.6', 'VBOP.7');
select pxp.f_insert_testructura_gui ('VBOP.7.7', 'VBOP.7');
select pxp.f_insert_testructura_gui ('VBOP.7.8', 'VBOP.7');
select pxp.f_insert_testructura_gui ('VBOP.7.4.1', 'VBOP.7.4');
select pxp.f_insert_testructura_gui ('OPCONTA.1', 'OPCONTA');
select pxp.f_insert_testructura_gui ('OPCONTA.2', 'OPCONTA');
select pxp.f_insert_testructura_gui ('OPCONTA.3', 'OPCONTA');
select pxp.f_insert_testructura_gui ('OPCONTA.4', 'OPCONTA');
select pxp.f_insert_testructura_gui ('OPCONTA.5', 'OPCONTA');
select pxp.f_insert_testructura_gui ('OPCONTA.6', 'OPCONTA');
select pxp.f_insert_testructura_gui ('OPCONTA.7', 'OPCONTA');
select pxp.f_insert_testructura_gui ('OPCONTA.8', 'OPCONTA');
select pxp.f_insert_testructura_gui ('OPCONTA.9', 'OPCONTA');
select pxp.f_insert_testructura_gui ('OPCONTA.10', 'OPCONTA');
select pxp.f_insert_testructura_gui ('OPCONTA.1.1', 'OPCONTA.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.1', 'OPCONTA.2');
select pxp.f_insert_testructura_gui ('OPCONTA.2.2', 'OPCONTA.2');
select pxp.f_insert_testructura_gui ('OPCONTA.2.3', 'OPCONTA.2');
select pxp.f_insert_testructura_gui ('OPCONTA.2.4', 'OPCONTA.2');
select pxp.f_insert_testructura_gui ('OPCONTA.2.5', 'OPCONTA.2');
select pxp.f_insert_testructura_gui ('OPCONTA.2.6', 'OPCONTA.2');
select pxp.f_insert_testructura_gui ('OPCONTA.2.7', 'OPCONTA.2');
select pxp.f_insert_testructura_gui ('OPCONTA.2.4.1', 'OPCONTA.2.4');
select pxp.f_insert_testructura_gui ('OPCONTA.2.4.1.1', 'OPCONTA.2.4.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.4.1.2', 'OPCONTA.2.4.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.4.1.3', 'OPCONTA.2.4.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.4.1.4', 'OPCONTA.2.4.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.4.1.5', 'OPCONTA.2.4.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.4.1.5.1', 'OPCONTA.2.4.1.5');
select pxp.f_insert_testructura_gui ('OPCONTA.2.4.1.5.1.1', 'OPCONTA.2.4.1.5.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.7.1', 'OPCONTA.2.7');
select pxp.f_insert_testructura_gui ('OPCONTA.2.7.1.1', 'OPCONTA.2.7.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.7.1.2', 'OPCONTA.2.7.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.7.1.3', 'OPCONTA.2.7.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.7.1.4', 'OPCONTA.2.7.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.7.1.1.1', 'OPCONTA.2.7.1.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.7.1.1.1.1', 'OPCONTA.2.7.1.1.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.7.1.1.1.1.1', 'OPCONTA.2.7.1.1.1.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.7.1.1.1.1.2', 'OPCONTA.2.7.1.1.1.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.7.1.1.1.1.2.1', 'OPCONTA.2.7.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('OPCONTA.2.7.1.1.1.1.2.2', 'OPCONTA.2.7.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('OPCONTA.4.1', 'OPCONTA.4');
select pxp.f_insert_testructura_gui ('OPCONTA.4.2', 'OPCONTA.4');
select pxp.f_insert_testructura_gui ('OPCONTA.4.3', 'OPCONTA.4');
select pxp.f_insert_testructura_gui ('OPCONTA.4.4', 'OPCONTA.4');
select pxp.f_insert_testructura_gui ('OPCONTA.4.5', 'OPCONTA.4');
select pxp.f_insert_testructura_gui ('OPCONTA.4.6', 'OPCONTA.4');
select pxp.f_insert_testructura_gui ('OPCONTA.4.7', 'OPCONTA.4');
select pxp.f_insert_testructura_gui ('OPCONTA.10.1', 'OPCONTA.10');
select pxp.f_insert_testructura_gui ('OPCONTA.10.2', 'OPCONTA.10');
select pxp.f_insert_testructura_gui ('OPCONTA.10.3', 'OPCONTA.10');
select pxp.f_insert_testructura_gui ('OPCONTA.10.4', 'OPCONTA.10');
select pxp.f_insert_testructura_gui ('OPCONTA.10.5', 'OPCONTA.10');
select pxp.f_insert_testructura_gui ('OPCONTA.10.6', 'OPCONTA.10');
select pxp.f_insert_testructura_gui ('OPCONTA.10.7', 'OPCONTA.10');
select pxp.f_insert_testructura_gui ('OPCONTA.10.1.1', 'OPCONTA.10.1');
select pxp.f_insert_testructura_gui ('CONOP.1', 'CONOP');
select pxp.f_insert_testructura_gui ('CONOP.2', 'CONOP');
select pxp.f_insert_testructura_gui ('CONOP.3', 'CONOP');
select pxp.f_insert_testructura_gui ('CONOP.4', 'CONOP');
select pxp.f_insert_testructura_gui ('CONOP.5', 'CONOP');
select pxp.f_insert_testructura_gui ('CONOP.6', 'CONOP');
select pxp.f_insert_testructura_gui ('CONOP.7', 'CONOP');
select pxp.f_insert_testructura_gui ('CONOP.8', 'CONOP');
select pxp.f_insert_testructura_gui ('CONOP.9', 'CONOP');
select pxp.f_insert_testructura_gui ('CONOP.10', 'CONOP');
select pxp.f_insert_testructura_gui ('CONOP.11', 'CONOP');
select pxp.f_insert_testructura_gui ('CONOP.1.1', 'CONOP.1');
select pxp.f_insert_testructura_gui ('CONOP.2.1', 'CONOP.2');
select pxp.f_insert_testructura_gui ('CONOP.2.2', 'CONOP.2');
select pxp.f_insert_testructura_gui ('CONOP.2.3', 'CONOP.2');
select pxp.f_insert_testructura_gui ('CONOP.2.4', 'CONOP.2');
select pxp.f_insert_testructura_gui ('CONOP.2.5', 'CONOP.2');
select pxp.f_insert_testructura_gui ('CONOP.2.6', 'CONOP.2');
select pxp.f_insert_testructura_gui ('CONOP.2.3.1', 'CONOP.2.3');
select pxp.f_insert_testructura_gui ('CONOP.2.3.1.1', 'CONOP.2.3.1');
select pxp.f_insert_testructura_gui ('CONOP.2.3.1.2', 'CONOP.2.3.1');
select pxp.f_insert_testructura_gui ('CONOP.2.3.1.3', 'CONOP.2.3.1');
select pxp.f_insert_testructura_gui ('CONOP.2.3.1.4', 'CONOP.2.3.1');
select pxp.f_insert_testructura_gui ('CONOP.2.3.1.5', 'CONOP.2.3.1');
select pxp.f_insert_testructura_gui ('CONOP.2.3.1.5.1', 'CONOP.2.3.1.5');
select pxp.f_insert_testructura_gui ('CONOP.2.3.1.5.1.1', 'CONOP.2.3.1.5.1');
select pxp.f_insert_testructura_gui ('CONOP.2.6.1', 'CONOP.2.6');
select pxp.f_insert_testructura_gui ('CONOP.2.6.1.1', 'CONOP.2.6.1');
select pxp.f_insert_testructura_gui ('CONOP.2.6.1.2', 'CONOP.2.6.1');
select pxp.f_insert_testructura_gui ('CONOP.2.6.1.3', 'CONOP.2.6.1');
select pxp.f_insert_testructura_gui ('CONOP.2.6.1.4', 'CONOP.2.6.1');
select pxp.f_insert_testructura_gui ('CONOP.2.6.1.1.1', 'CONOP.2.6.1.1');
select pxp.f_insert_testructura_gui ('CONOP.2.6.1.1.1.1', 'CONOP.2.6.1.1.1');
select pxp.f_insert_testructura_gui ('CONOP.2.6.1.1.1.1.1', 'CONOP.2.6.1.1.1.1');
select pxp.f_insert_testructura_gui ('CONOP.2.6.1.1.1.1.2', 'CONOP.2.6.1.1.1.1');
select pxp.f_insert_testructura_gui ('CONOP.2.6.1.1.1.1.2.1', 'CONOP.2.6.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('CONOP.2.6.1.1.1.1.2.2', 'CONOP.2.6.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('CONOP.4.1', 'CONOP.4');
select pxp.f_insert_testructura_gui ('CONOP.5.1', 'CONOP.5');
select pxp.f_insert_testructura_gui ('CONOP.5.2', 'CONOP.5');
select pxp.f_insert_testructura_gui ('CONOP.5.3', 'CONOP.5');
select pxp.f_insert_testructura_gui ('CONOP.5.4', 'CONOP.5');
select pxp.f_insert_testructura_gui ('CONOP.5.5', 'CONOP.5');
select pxp.f_insert_testructura_gui ('CONOP.5.6', 'CONOP.5');
select pxp.f_insert_testructura_gui ('CONOP.5.7', 'CONOP.5');
select pxp.f_insert_testructura_gui ('CONOP.11.1', 'CONOP.11');
select pxp.f_insert_testructura_gui ('CONOP.11.2', 'CONOP.11');
select pxp.f_insert_testructura_gui ('CONOP.11.3', 'CONOP.11');
select pxp.f_insert_testructura_gui ('CONOP.11.4', 'CONOP.11');
select pxp.f_insert_testructura_gui ('CONOP.11.5', 'CONOP.11');
select pxp.f_insert_testructura_gui ('CONOP.11.6', 'CONOP.11');
select pxp.f_insert_testructura_gui ('CONOP.11.7', 'CONOP.11');
select pxp.f_insert_testructura_gui ('CONOP.11.1.1', 'CONOP.11.1');
select pxp.f_insert_testructura_gui ('VBPDC.1', 'VBPDC');
select pxp.f_insert_testructura_gui ('VBPDC.2', 'VBPDC');
select pxp.f_insert_testructura_gui ('VBPDC.3', 'VBPDC');
select pxp.f_insert_testructura_gui ('VBPDC.4', 'VBPDC');
select pxp.f_insert_testructura_gui ('VBPDC.5', 'VBPDC');
select pxp.f_insert_testructura_gui ('VBPDC.6', 'VBPDC');
select pxp.f_insert_testructura_gui ('VBPDC.7', 'VBPDC');
select pxp.f_insert_testructura_gui ('VBPDC.8', 'VBPDC');
select pxp.f_insert_testructura_gui ('VBPDC.1.1', 'VBPDC.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.2', 'VBPDC.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.3', 'VBPDC.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.4', 'VBPDC.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.5', 'VBPDC.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.6', 'VBPDC.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.7', 'VBPDC.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.8', 'VBPDC.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.9', 'VBPDC.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.10', 'VBPDC.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.1.1', 'VBPDC.1.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.3.1', 'VBPDC.1.3');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.1', 'VBPDC.1.4');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.2', 'VBPDC.1.4');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.3', 'VBPDC.1.4');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.4', 'VBPDC.1.4');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.5', 'VBPDC.1.4');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.6', 'VBPDC.1.4');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.7', 'VBPDC.1.4');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.4.1', 'VBPDC.1.4.4');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.4.1.1', 'VBPDC.1.4.4.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.4.1.2', 'VBPDC.1.4.4.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.4.1.3', 'VBPDC.1.4.4.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.4.1.4', 'VBPDC.1.4.4.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.4.1.5', 'VBPDC.1.4.4.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.4.1.5.1', 'VBPDC.1.4.4.1.5');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.4.1.5.1.1', 'VBPDC.1.4.4.1.5.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.7.1', 'VBPDC.1.4.7');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.7.1.1', 'VBPDC.1.4.7.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.7.1.2', 'VBPDC.1.4.7.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.7.1.3', 'VBPDC.1.4.7.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.7.1.4', 'VBPDC.1.4.7.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.7.1.1.1', 'VBPDC.1.4.7.1.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.7.1.1.1.1', 'VBPDC.1.4.7.1.1.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.7.1.1.1.1.1', 'VBPDC.1.4.7.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.7.1.1.1.1.2', 'VBPDC.1.4.7.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.7.1.1.1.1.2.1', 'VBPDC.1.4.7.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.7.1.1.1.1.2.2', 'VBPDC.1.4.7.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('VBPDC.1.10.1', 'VBPDC.1.10');
select pxp.f_insert_testructura_gui ('VBPDC.1.10.2', 'VBPDC.1.10');
select pxp.f_insert_testructura_gui ('VBPDC.1.10.3', 'VBPDC.1.10');
select pxp.f_insert_testructura_gui ('VBPDC.1.10.4', 'VBPDC.1.10');
select pxp.f_insert_testructura_gui ('VBPDC.1.10.5', 'VBPDC.1.10');
select pxp.f_insert_testructura_gui ('VBPDC.1.10.6', 'VBPDC.1.10');
select pxp.f_insert_testructura_gui ('VBPDC.1.10.7', 'VBPDC.1.10');
select pxp.f_insert_testructura_gui ('VBPDC.1.10.1.1', 'VBPDC.1.10.1');
select pxp.f_insert_testructura_gui ('VBPDC.3.1', 'VBPDC.3');
select pxp.f_insert_testructura_gui ('VBPDC.3.2', 'VBPDC.3');
select pxp.f_insert_testructura_gui ('OPUNI.1', 'OPUNI');
select pxp.f_insert_testructura_gui ('OPUNI.2', 'OPUNI');
select pxp.f_insert_testructura_gui ('OPUNI.3', 'OPUNI');
select pxp.f_insert_testructura_gui ('OPUNI.4', 'OPUNI');
select pxp.f_insert_testructura_gui ('OPUNI.5', 'OPUNI');
select pxp.f_insert_testructura_gui ('OPUNI.6', 'OPUNI');
select pxp.f_insert_testructura_gui ('OPUNI.7', 'OPUNI');
select pxp.f_insert_testructura_gui ('OPUNI.8', 'OPUNI');
select pxp.f_insert_testructura_gui ('OPUNI.9', 'OPUNI');
select pxp.f_insert_testructura_gui ('OPUNI.10', 'OPUNI');
select pxp.f_insert_testructura_gui ('OPUNI.11', 'OPUNI');
select pxp.f_insert_testructura_gui ('OPUNI.1.1', 'OPUNI.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.1', 'OPUNI.2');
select pxp.f_insert_testructura_gui ('OPUNI.2.2', 'OPUNI.2');
select pxp.f_insert_testructura_gui ('OPUNI.2.3', 'OPUNI.2');
select pxp.f_insert_testructura_gui ('OPUNI.2.4', 'OPUNI.2');
select pxp.f_insert_testructura_gui ('OPUNI.2.5', 'OPUNI.2');
select pxp.f_insert_testructura_gui ('OPUNI.2.6', 'OPUNI.2');
select pxp.f_insert_testructura_gui ('OPUNI.2.7', 'OPUNI.2');
select pxp.f_insert_testructura_gui ('OPUNI.2.4.1', 'OPUNI.2.4');
select pxp.f_insert_testructura_gui ('OPUNI.2.4.1.1', 'OPUNI.2.4.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.4.1.2', 'OPUNI.2.4.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.4.1.3', 'OPUNI.2.4.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.4.1.4', 'OPUNI.2.4.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.4.1.5', 'OPUNI.2.4.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.4.1.5.1', 'OPUNI.2.4.1.5');
select pxp.f_insert_testructura_gui ('OPUNI.2.4.1.5.1.1', 'OPUNI.2.4.1.5.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.7.1', 'OPUNI.2.7');
select pxp.f_insert_testructura_gui ('OPUNI.2.7.1.1', 'OPUNI.2.7.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.7.1.2', 'OPUNI.2.7.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.7.1.3', 'OPUNI.2.7.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.7.1.4', 'OPUNI.2.7.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.7.1.1.1', 'OPUNI.2.7.1.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.7.1.1.1.1', 'OPUNI.2.7.1.1.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.7.1.1.1.1.1', 'OPUNI.2.7.1.1.1.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.7.1.1.1.1.2', 'OPUNI.2.7.1.1.1.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.7.1.1.1.1.2.1', 'OPUNI.2.7.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('OPUNI.2.7.1.1.1.1.2.2', 'OPUNI.2.7.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('OPUNI.3.1', 'OPUNI.3');
select pxp.f_insert_testructura_gui ('OPUNI.3.2', 'OPUNI.3');
select pxp.f_insert_testructura_gui ('OPUNI.3.2.1', 'OPUNI.3.2');
select pxp.f_insert_testructura_gui ('OPUNI.3.2.2', 'OPUNI.3.2');
select pxp.f_insert_testructura_gui ('OPUNI.3.2.3', 'OPUNI.3.2');
select pxp.f_insert_testructura_gui ('OPUNI.3.2.4', 'OPUNI.3.2');
select pxp.f_insert_testructura_gui ('OPUNI.3.2.5', 'OPUNI.3.2');
select pxp.f_insert_testructura_gui ('OPUNI.3.2.6', 'OPUNI.3.2');
select pxp.f_insert_testructura_gui ('OPUNI.3.2.7', 'OPUNI.3.2');
select pxp.f_insert_testructura_gui ('OPUNI.3.2.1.1', 'OPUNI.3.2.1');
select pxp.f_insert_testructura_gui ('OPUNI.6.1', 'OPUNI.6');
select pxp.f_insert_testructura_gui ('OPUNI.6.2', 'OPUNI.6');
select pxp.f_insert_testructura_gui ('OPUNI.6.3', 'OPUNI.6');
select pxp.f_insert_testructura_gui ('OPUNI.6.4', 'OPUNI.6');
select pxp.f_insert_testructura_gui ('OPUNI.6.5', 'OPUNI.6');
select pxp.f_insert_testructura_gui ('OPUNI.6.6', 'OPUNI.6');
select pxp.f_insert_testructura_gui ('OPUNI.6.7', 'OPUNI.6');
select pxp.f_insert_testructura_gui ('VBOPOA.1', 'VBOPOA');
select pxp.f_insert_testructura_gui ('VBOPOA.2', 'VBOPOA');
select pxp.f_insert_testructura_gui ('VBOPOA.3', 'VBOPOA');
select pxp.f_insert_testructura_gui ('VBOPOA.4', 'VBOPOA');
select pxp.f_insert_testructura_gui ('VBOPOA.5', 'VBOPOA');
select pxp.f_insert_testructura_gui ('VBOPOA.6', 'VBOPOA');
select pxp.f_insert_testructura_gui ('VBOPOA.7', 'VBOPOA');
select pxp.f_insert_testructura_gui ('VBOPOA.8', 'VBOPOA');
select pxp.f_insert_testructura_gui ('VBOPOA.9', 'VBOPOA');
select pxp.f_insert_testructura_gui ('VBOPOA.10', 'VBOPOA');
select pxp.f_insert_testructura_gui ('VBOPOA.1.1', 'VBOPOA.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.1', 'VBOPOA.2');
select pxp.f_insert_testructura_gui ('VBOPOA.2.2', 'VBOPOA.2');
select pxp.f_insert_testructura_gui ('VBOPOA.2.3', 'VBOPOA.2');
select pxp.f_insert_testructura_gui ('VBOPOA.2.4', 'VBOPOA.2');
select pxp.f_insert_testructura_gui ('VBOPOA.2.5', 'VBOPOA.2');
select pxp.f_insert_testructura_gui ('VBOPOA.2.6', 'VBOPOA.2');
select pxp.f_insert_testructura_gui ('VBOPOA.2.7', 'VBOPOA.2');
select pxp.f_insert_testructura_gui ('VBOPOA.2.4.1', 'VBOPOA.2.4');
select pxp.f_insert_testructura_gui ('VBOPOA.2.4.1.1', 'VBOPOA.2.4.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.4.1.2', 'VBOPOA.2.4.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.4.1.3', 'VBOPOA.2.4.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.4.1.4', 'VBOPOA.2.4.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.4.1.5', 'VBOPOA.2.4.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.4.1.5.1', 'VBOPOA.2.4.1.5');
select pxp.f_insert_testructura_gui ('VBOPOA.2.4.1.5.1.1', 'VBOPOA.2.4.1.5.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.7.1', 'VBOPOA.2.7');
select pxp.f_insert_testructura_gui ('VBOPOA.2.7.1.1', 'VBOPOA.2.7.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.7.1.2', 'VBOPOA.2.7.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.7.1.3', 'VBOPOA.2.7.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.7.1.4', 'VBOPOA.2.7.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.7.1.1.1', 'VBOPOA.2.7.1.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.7.1.1.1.1', 'VBOPOA.2.7.1.1.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.7.1.1.1.1.1', 'VBOPOA.2.7.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.7.1.1.1.1.2', 'VBOPOA.2.7.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.7.1.1.1.1.2.1', 'VBOPOA.2.7.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('VBOPOA.2.7.1.1.1.1.2.2', 'VBOPOA.2.7.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('VBOPOA.4.1', 'VBOPOA.4');
select pxp.f_insert_testructura_gui ('VBOPOA.4.2', 'VBOPOA.4');
select pxp.f_insert_testructura_gui ('VBOPOA.4.3', 'VBOPOA.4');
select pxp.f_insert_testructura_gui ('VBOPOA.4.4', 'VBOPOA.4');
select pxp.f_insert_testructura_gui ('VBOPOA.4.5', 'VBOPOA.4');
select pxp.f_insert_testructura_gui ('VBOPOA.4.6', 'VBOPOA.4');
select pxp.f_insert_testructura_gui ('VBOPOA.4.7', 'VBOPOA.4');
select pxp.f_insert_testructura_gui ('VBOPOA.10.1', 'VBOPOA.10');
select pxp.f_insert_testructura_gui ('VBOPOA.10.2', 'VBOPOA.10');
select pxp.f_insert_testructura_gui ('VBOPOA.10.3', 'VBOPOA.10');
select pxp.f_insert_testructura_gui ('VBOPOA.10.4', 'VBOPOA.10');
select pxp.f_insert_testructura_gui ('VBOPOA.10.5', 'VBOPOA.10');
select pxp.f_insert_testructura_gui ('VBOPOA.10.6', 'VBOPOA.10');
select pxp.f_insert_testructura_gui ('VBOPOA.10.7', 'VBOPOA.10');
select pxp.f_insert_testructura_gui ('VBOPOA.10.1.1', 'VBOPOA.10.1');
select pxp.f_insert_testructura_gui ('REPPP.1', 'REPPP');
select pxp.f_insert_testructura_gui ('REPPP.1.1', 'REPPP.1');
select pxp.f_insert_testructura_gui ('REPPP.1.1.1', 'REPPP.1.1');
select pxp.f_insert_testructura_gui ('REPPP.1.1.2', 'REPPP.1.1');
select pxp.f_insert_testructura_gui ('REPPP.1.1.3', 'REPPP.1.1');
select pxp.f_insert_testructura_gui ('REPPP.1.1.4', 'REPPP.1.1');
select pxp.f_insert_testructura_gui ('REPPP.1.1.5', 'REPPP.1.1');
select pxp.f_insert_testructura_gui ('SOLCAJA.3', 'SOLCAJA');
select pxp.f_insert_testructura_gui ('SOLCAJA.4', 'SOLCAJA');
select pxp.f_insert_testructura_gui ('SOLCAJA.3.1', 'SOLCAJA.3');
select pxp.f_insert_testructura_gui ('SOLCAJA.3.1.1', 'SOLCAJA.3.1');
select pxp.f_insert_testructura_gui ('SOLCAJA.3.1.2', 'SOLCAJA.3.1');
select pxp.f_insert_testructura_gui ('SOLCAJA.3.1.3', 'SOLCAJA.3.1');
select pxp.f_insert_testructura_gui ('SOLCAJA.3.1.4', 'SOLCAJA.3.1');
select pxp.f_insert_testructura_gui ('SOLCAJA.3.1.1.1', 'SOLCAJA.3.1.1');
select pxp.f_insert_testructura_gui ('SOLCAJA.3.1.1.1.1', 'SOLCAJA.3.1.1.1');
select pxp.f_insert_testructura_gui ('SOLCAJA.3.1.1.1.1.1', 'SOLCAJA.3.1.1.1.1');
select pxp.f_insert_testructura_gui ('SOLCAJA.3.1.1.1.1.2', 'SOLCAJA.3.1.1.1.1');
select pxp.f_insert_testructura_gui ('SOLCAJA.3.1.1.1.1.2.1', 'SOLCAJA.3.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('SOLCAJA.3.1.1.1.1.2.2', 'SOLCAJA.3.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('SOLCAJA.4.1', 'SOLCAJA.4');
select pxp.f_insert_testructura_gui ('VBCAJA.5', 'VBCAJA');
select pxp.f_insert_testructura_gui ('VBCAJA.6', 'VBCAJA');
select pxp.f_insert_testructura_gui ('VBCAJA.5.1', 'VBCAJA.5');
select pxp.f_insert_testructura_gui ('VBCAJA.5.1.1', 'VBCAJA.5.1');
select pxp.f_insert_testructura_gui ('VBCAJA.5.1.2', 'VBCAJA.5.1');
select pxp.f_insert_testructura_gui ('VBCAJA.5.1.3', 'VBCAJA.5.1');
select pxp.f_insert_testructura_gui ('VBCAJA.5.1.4', 'VBCAJA.5.1');
select pxp.f_insert_testructura_gui ('VBCAJA.5.1.1.1', 'VBCAJA.5.1.1');
select pxp.f_insert_testructura_gui ('VBCAJA.5.1.1.1.1', 'VBCAJA.5.1.1.1');
select pxp.f_insert_testructura_gui ('VBCAJA.5.1.1.1.1.1', 'VBCAJA.5.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBCAJA.5.1.1.1.1.2', 'VBCAJA.5.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBCAJA.5.1.1.1.1.2.1', 'VBCAJA.5.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('VBCAJA.5.1.1.1.1.2.2', 'VBCAJA.5.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('VBCAJA.6.1', 'VBCAJA.6');
select pxp.f_insert_testructura_gui ('SOLEFE.5', 'SOLEFE');
select pxp.f_insert_testructura_gui ('SOLEFE.6', 'SOLEFE');
select pxp.f_insert_testructura_gui ('SOLEFE.3.2', 'SOLEFE.3');
select pxp.f_insert_testructura_gui ('SOLEFE.3.2.1', 'SOLEFE.3.2');
select pxp.f_insert_testructura_gui ('SOLEFESD.3', 'SOLEFESD');
select pxp.f_insert_testructura_gui ('SOLEFESD.4', 'SOLEFESD');
select pxp.f_insert_testructura_gui ('SOLEFESD.5', 'SOLEFESD');
select pxp.f_insert_testructura_gui ('SOLEFESD.1.2', 'SOLEFESD.1');
select pxp.f_insert_testructura_gui ('SOLEFESD.1.2.1', 'SOLEFESD.1.2');
select pxp.f_insert_testructura_gui ('SOLEFESD.1.2.1.1', 'SOLEFESD.1.2.1');
select pxp.f_insert_testructura_gui ('SOLEFESD.1.2.1.2', 'SOLEFESD.1.2.1');
select pxp.f_insert_testructura_gui ('SOLEFESD.1.2.1.3', 'SOLEFESD.1.2.1');
select pxp.f_insert_testructura_gui ('SOLEFESD.1.2.1.4', 'SOLEFESD.1.2.1');
select pxp.f_insert_testructura_gui ('SOLEFESD.1.2.1.5', 'SOLEFESD.1.2.1');
select pxp.f_insert_testructura_gui ('SOLEFESD.1.2.1.5.1', 'SOLEFESD.1.2.1.5');
select pxp.f_insert_testructura_gui ('SOLEFESD.1.2.1.5.1.1', 'SOLEFESD.1.2.1.5.1');
select pxp.f_insert_testructura_gui ('SOLEFESD.3.1', 'SOLEFESD.3');
select pxp.f_insert_testructura_gui ('SOLEFESD.3.2', 'SOLEFESD.3');
select pxp.f_insert_testructura_gui ('SOLEFESD.3.3', 'SOLEFESD.3');
select pxp.f_insert_testructura_gui ('SOLEFESD.3.4', 'SOLEFESD.3');
select pxp.f_insert_testructura_gui ('SOLEFESD.3.2.1', 'SOLEFESD.3.2');
select pxp.f_insert_testructura_gui ('SOLEFESD.3.2.2', 'SOLEFESD.3.2');
select pxp.f_insert_testructura_gui ('SOLEFESD.3.2.2.1', 'SOLEFESD.3.2.2');
select pxp.f_insert_testructura_gui ('SOLEFESD.3.4.1', 'SOLEFESD.3.4');
select pxp.f_insert_testructura_gui ('SOLEFESD.3.4.2', 'SOLEFESD.3.4');
select pxp.f_insert_testructura_gui ('VBSOLEFE.4', 'VBSOLEFE');
select pxp.f_insert_testructura_gui ('VBRENCJ.4', 'VBRENCJ');
select pxp.f_insert_testructura_gui ('VBRENCJ.4.1', 'VBRENCJ.4');
select pxp.f_insert_testructura_gui ('VBRENCJ.4.2', 'VBRENCJ.4');
select pxp.f_insert_testructura_gui ('REPPPBA.1', 'REPPPBA');
select pxp.f_insert_testructura_gui ('REPPPBA.1.1', 'REPPPBA.1');
select pxp.f_insert_testructura_gui ('REPPPBA.1.2', 'REPPPBA.1');
select pxp.f_insert_testructura_gui ('REPPPBA.1.3', 'REPPPBA.1');
select pxp.f_insert_testructura_gui ('REPPPBA.1.4', 'REPPPBA.1');
select pxp.f_insert_testructura_gui ('REPPPBA.1.5', 'REPPPBA.1');
select pxp.f_insert_testructura_gui ('REPPPBA.1.5.1', 'REPPPBA.1.5');
select pxp.f_insert_testructura_gui ('REPPPBA.1.5.1.1', 'REPPPBA.1.5.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1', 'VBPCOS');
select pxp.f_insert_testructura_gui ('VBPCOS.2', 'VBPCOS');
select pxp.f_insert_testructura_gui ('VBPCOS.3', 'VBPCOS');
select pxp.f_insert_testructura_gui ('VBPCOS.4', 'VBPCOS');
select pxp.f_insert_testructura_gui ('VBPCOS.5', 'VBPCOS');
select pxp.f_insert_testructura_gui ('VBPCOS.6', 'VBPCOS');
select pxp.f_insert_testructura_gui ('VBPCOS.7', 'VBPCOS');
select pxp.f_insert_testructura_gui ('VBPCOS.8', 'VBPCOS');
select pxp.f_insert_testructura_gui ('VBPCOS.1.1', 'VBPCOS.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.2', 'VBPCOS.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.3', 'VBPCOS.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4', 'VBPCOS.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.5', 'VBPCOS.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.6', 'VBPCOS.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.7', 'VBPCOS.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.8', 'VBPCOS.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.9', 'VBPCOS.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.10', 'VBPCOS.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.1.1', 'VBPCOS.1.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.3.1', 'VBPCOS.1.3');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.1', 'VBPCOS.1.4');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.2', 'VBPCOS.1.4');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.3', 'VBPCOS.1.4');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.4', 'VBPCOS.1.4');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.5', 'VBPCOS.1.4');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.6', 'VBPCOS.1.4');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.7', 'VBPCOS.1.4');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.4.1', 'VBPCOS.1.4.4');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.4.1.1', 'VBPCOS.1.4.4.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.4.1.2', 'VBPCOS.1.4.4.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.4.1.3', 'VBPCOS.1.4.4.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.4.1.4', 'VBPCOS.1.4.4.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.4.1.5', 'VBPCOS.1.4.4.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.4.1.5.1', 'VBPCOS.1.4.4.1.5');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.4.1.5.1.1', 'VBPCOS.1.4.4.1.5.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.7.1', 'VBPCOS.1.4.7');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.7.1.1', 'VBPCOS.1.4.7.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.7.1.2', 'VBPCOS.1.4.7.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.7.1.3', 'VBPCOS.1.4.7.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.7.1.4', 'VBPCOS.1.4.7.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.7.1.1.1', 'VBPCOS.1.4.7.1.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.7.1.1.1.1', 'VBPCOS.1.4.7.1.1.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.7.1.1.1.1.1', 'VBPCOS.1.4.7.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.7.1.1.1.1.2', 'VBPCOS.1.4.7.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.7.1.1.1.1.2.1', 'VBPCOS.1.4.7.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.7.1.1.1.1.2.2', 'VBPCOS.1.4.7.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('VBPCOS.1.10.1', 'VBPCOS.1.10');
select pxp.f_insert_testructura_gui ('VBPCOS.1.10.2', 'VBPCOS.1.10');
select pxp.f_insert_testructura_gui ('VBPCOS.1.10.3', 'VBPCOS.1.10');
select pxp.f_insert_testructura_gui ('VBPCOS.1.10.4', 'VBPCOS.1.10');
select pxp.f_insert_testructura_gui ('VBPCOS.1.10.5', 'VBPCOS.1.10');
select pxp.f_insert_testructura_gui ('VBPCOS.1.10.6', 'VBPCOS.1.10');
select pxp.f_insert_testructura_gui ('VBPCOS.1.10.7', 'VBPCOS.1.10');
select pxp.f_insert_testructura_gui ('VBPCOS.1.10.1.1', 'VBPCOS.1.10.1');
select pxp.f_insert_testructura_gui ('VBPCOS.3.1', 'VBPCOS.3');
select pxp.f_insert_testructura_gui ('VBPCOS.3.2', 'VBPCOS.3');
select pxp.f_insert_testructura_gui ('VBCJ.1', 'VBCJ');
select pxp.f_insert_testructura_gui ('VBCJ.2', 'VBCJ');
select pxp.f_insert_testructura_gui ('VBCJ.3', 'VBCJ');
select pxp.f_insert_testructura_gui ('VBCJ.4', 'VBCJ');
select pxp.f_insert_testructura_gui ('VBCJ.2.1', 'VBCJ.2');
select pxp.f_insert_testructura_gui ('VBCJ.2.1.1', 'VBCJ.2.1');
select pxp.f_insert_testructura_gui ('VBCJ.2.1.2', 'VBCJ.2.1');
select pxp.f_insert_testructura_gui ('VBCJ.2.1.3', 'VBCJ.2.1');
select pxp.f_insert_testructura_gui ('VBCJ.2.1.4', 'VBCJ.2.1');
select pxp.f_insert_testructura_gui ('VBCJ.2.1.5', 'VBCJ.2.1');
select pxp.f_insert_testructura_gui ('VBCJ.2.1.5.1', 'VBCJ.2.1.5');
select pxp.f_insert_testructura_gui ('VBCJ.2.1.5.1.1', 'VBCJ.2.1.5.1');
select pxp.f_insert_testructura_gui ('VBCJ.4.1', 'VBCJ.4');
select pxp.f_insert_testructura_gui ('VBCJ.4.2', 'VBCJ.4');
select pxp.f_insert_testructura_gui ('VBCP.1', 'VBCP');
select pxp.f_insert_testructura_gui ('VBCP.2', 'VBCP');
select pxp.f_insert_testructura_gui ('VBCP.3', 'VBCP');
select pxp.f_insert_testructura_gui ('VBCP.4', 'VBCP');
select pxp.f_insert_testructura_gui ('VBCP.5', 'VBCP');
select pxp.f_insert_testructura_gui ('VBCP.3.1', 'VBCP.3');
select pxp.f_insert_testructura_gui ('VBCP.3.1.1', 'VBCP.3.1');
select pxp.f_insert_testructura_gui ('VBCP.3.1.2', 'VBCP.3.1');
select pxp.f_insert_testructura_gui ('VBCP.3.1.3', 'VBCP.3.1');
select pxp.f_insert_testructura_gui ('VBCP.3.1.4', 'VBCP.3.1');
select pxp.f_insert_testructura_gui ('VBCP.3.1.5', 'VBCP.3.1');
select pxp.f_insert_testructura_gui ('VBCP.3.1.5.1', 'VBCP.3.1.5');
select pxp.f_insert_testructura_gui ('VBCP.3.1.5.1.1', 'VBCP.3.1.5.1');
select pxp.f_insert_testructura_gui ('VBCP.5.1', 'VBCP.5');
select pxp.f_insert_testructura_gui ('VBCP.5.2', 'VBCP.5');
select pxp.f_insert_testructura_gui ('VBFACREN.1', 'VBFACREN');
select pxp.f_insert_testructura_gui ('VBFACREN.2', 'VBFACREN');
select pxp.f_insert_testructura_gui ('VBFACREN.1.1', 'VBFACREN.1');
select pxp.f_insert_testructura_gui ('VBFACREN.1.1.1', 'VBFACREN.1.1');
select pxp.f_insert_testructura_gui ('VBFACREN.1.1.2', 'VBFACREN.1.1');
select pxp.f_insert_testructura_gui ('VBFACREN.1.1.3', 'VBFACREN.1.1');
select pxp.f_insert_testructura_gui ('VBFACREN.1.1.4', 'VBFACREN.1.1');
select pxp.f_insert_testructura_gui ('VBFACREN.1.1.5', 'VBFACREN.1.1');
select pxp.f_insert_testructura_gui ('VBFACREN.1.1.5.1', 'VBFACREN.1.1.5');
select pxp.f_insert_testructura_gui ('VBFACREN.1.1.5.1.1', 'VBFACREN.1.1.5.1');
select pxp.f_insert_testructura_gui ('VBFACREN.2.1', 'VBFACREN.2');
select pxp.f_insert_testructura_gui ('VBFACREN.2.2', 'VBFACREN.2');
select pxp.f_insert_testructura_gui ('VBFACREN.2.2.1', 'VBFACREN.2.2');
select pxp.f_insert_testructura_gui ('VBRENCJA.1', 'VBRENCJA');
select pxp.f_insert_testructura_gui ('VBRENCJA.2', 'VBRENCJA');
select pxp.f_insert_testructura_gui ('VBRENCJA.3', 'VBRENCJA');
select pxp.f_insert_testructura_gui ('VBRENCJA.4', 'VBRENCJA');
select pxp.f_insert_testructura_gui ('VBRENCJA.5', 'VBRENCJA');
select pxp.f_insert_testructura_gui ('VBRENCJA.6', 'VBRENCJA');
select pxp.f_insert_testructura_gui ('VBRENCJA.4.1', 'VBRENCJA.4');
select pxp.f_insert_testructura_gui ('VBRENCJA.4.1.1', 'VBRENCJA.4.1');
select pxp.f_insert_testructura_gui ('VBRENCJA.4.1.2', 'VBRENCJA.4.1');
select pxp.f_insert_testructura_gui ('VBRENCJA.4.1.3', 'VBRENCJA.4.1');
select pxp.f_insert_testructura_gui ('VBRENCJA.4.1.4', 'VBRENCJA.4.1');
select pxp.f_insert_testructura_gui ('VBRENCJA.4.1.5', 'VBRENCJA.4.1');
select pxp.f_insert_testructura_gui ('VBRENCJA.4.1.5.1', 'VBRENCJA.4.1.5');
select pxp.f_insert_testructura_gui ('VBRENCJA.4.1.5.1.1', 'VBRENCJA.4.1.5.1');
select pxp.f_insert_testructura_gui ('VBRENCJA.6.1', 'VBRENCJA.6');
select pxp.f_insert_testructura_gui ('VBRENCJA.6.2', 'VBRENCJA.6');
select pxp.f_insert_testructura_gui ('COFCAJA', 'CARFR');
select pxp.f_insert_testructura_gui ('TPSOL', 'COFCAJA');
select pxp.f_insert_testructura_gui ('TPC', 'COFCAJA');
select pxp.f_insert_testructura_gui ('INGCAJ', 'CARFR');
select pxp.f_insert_testructura_gui ('OBPG.12', 'OBPG');
select pxp.f_insert_testructura_gui ('OBPG.8.7.1.1.1.2', 'OBPG.8.7.1.1.1');
select pxp.f_insert_testructura_gui ('OBPG.8.7.1.1.1.2.1', 'OBPG.8.7.1.1.1.2');
select pxp.f_insert_testructura_gui ('OBPG.8.7.1.1.1.2.1.1', 'OBPG.8.7.1.1.1.2.1');
select pxp.f_insert_testructura_gui ('OBPG.8.7.1.1.1.2.1.2', 'OBPG.8.7.1.1.1.2.1');
select pxp.f_insert_testructura_gui ('OBPG.8.7.1.1.1.2.1.2.1', 'OBPG.8.7.1.1.1.2.1.2');
select pxp.f_insert_testructura_gui ('OBPG.8.7.1.1.1.2.1.2.2', 'OBPG.8.7.1.1.1.2.1.2');
select pxp.f_insert_testructura_gui ('CTABAN.2.2', 'CTABAN.2');
select pxp.f_insert_testructura_gui ('CTABAN.2.2.1', 'CTABAN.2.2');
select pxp.f_insert_testructura_gui ('CAJA.5.1.1.1.2', 'CAJA.5.1.1.1');
select pxp.f_insert_testructura_gui ('CAJA.5.1.1.1.2.1', 'CAJA.5.1.1.1.2');
select pxp.f_insert_testructura_gui ('CAJA.5.1.1.1.2.1.1', 'CAJA.5.1.1.1.2.1');
select pxp.f_insert_testructura_gui ('CAJA.5.1.1.1.2.1.2', 'CAJA.5.1.1.1.2.1');
select pxp.f_insert_testructura_gui ('CAJA.5.1.1.1.2.1.2.1', 'CAJA.5.1.1.1.2.1.2');
select pxp.f_insert_testructura_gui ('CAJA.5.1.1.1.2.1.2.2', 'CAJA.5.1.1.1.2.1.2');
select pxp.f_insert_testructura_gui ('CAJA.6.2', 'CAJA.6');
select pxp.f_insert_testructura_gui ('CTABANE.3.2', 'CTABANE.3');
select pxp.f_insert_testructura_gui ('CTABANE.3.2.1', 'CTABANE.3.2');
select pxp.f_insert_testructura_gui ('VBDP.6.11', 'VBDP.6');
select pxp.f_insert_testructura_gui ('VBDP.6.4.7.1.1.1.2', 'VBDP.6.4.7.1.1.1');
select pxp.f_insert_testructura_gui ('VBDP.6.4.7.1.1.1.2.1', 'VBDP.6.4.7.1.1.1.2');
select pxp.f_insert_testructura_gui ('VBDP.6.4.7.1.1.1.2.1.1', 'VBDP.6.4.7.1.1.1.2.1');
select pxp.f_insert_testructura_gui ('VBDP.6.4.7.1.1.1.2.1.2', 'VBDP.6.4.7.1.1.1.2.1');
select pxp.f_insert_testructura_gui ('VBDP.6.4.7.1.1.1.2.1.2.1', 'VBDP.6.4.7.1.1.1.2.1.2');
select pxp.f_insert_testructura_gui ('VBDP.6.4.7.1.1.1.2.1.2.2', 'VBDP.6.4.7.1.1.1.2.1.2');
select pxp.f_insert_testructura_gui ('SOLPD.11', 'SOLPD');
select pxp.f_insert_testructura_gui ('SOLPD.2.7.1.1.1.2', 'SOLPD.2.7.1.1.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.7.1.1.1.2.1', 'SOLPD.2.7.1.1.1.2');
select pxp.f_insert_testructura_gui ('SOLPD.2.7.1.1.1.2.1.1', 'SOLPD.2.7.1.1.1.2.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.7.1.1.1.2.1.2', 'SOLPD.2.7.1.1.1.2.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.7.1.1.1.2.1.2.1', 'SOLPD.2.7.1.1.1.2.1.2');
select pxp.f_insert_testructura_gui ('SOLPD.2.7.1.1.1.2.1.2.2', 'SOLPD.2.7.1.1.1.2.1.2');
select pxp.f_insert_testructura_gui ('CTABANCEND.2.2', 'CTABANCEND.2');
select pxp.f_insert_testructura_gui ('CTABANCEND.2.2.1', 'CTABANCEND.2.2');
select pxp.f_insert_testructura_gui ('CTABANCEND.2.2.1.1', 'CTABANCEND.2.2.1');
select pxp.f_insert_testructura_gui ('CTABANCEND.2.2.1.2', 'CTABANCEND.2.2.1');
select pxp.f_insert_testructura_gui ('CTABANCEND.2.2.1.2.1', 'CTABANCEND.2.2.1.2');
select pxp.f_insert_testructura_gui ('CTABANCEND.2.2.1.2.2', 'CTABANCEND.2.2.1.2');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.4.1.2', 'REVBPP.2.2.4.1');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.4.1.2.1', 'REVBPP.2.2.4.1.2');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.4.1.2.1.1', 'REVBPP.2.2.4.1.2.1');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.4.1.2.1.2', 'REVBPP.2.2.4.1.2.1');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.4.1.2.1.2.1', 'REVBPP.2.2.4.1.2.1.2');
select pxp.f_insert_testructura_gui ('REVBPP.2.2.4.1.2.1.2.2', 'REVBPP.2.2.4.1.2.1.2');
select pxp.f_insert_testructura_gui ('VBOP.11', 'VBOP');
select pxp.f_insert_testructura_gui ('VBOP.2.7.1.1.1.2', 'VBOP.2.7.1.1.1');
select pxp.f_insert_testructura_gui ('VBOP.2.7.1.1.1.2.1', 'VBOP.2.7.1.1.1.2');
select pxp.f_insert_testructura_gui ('VBOP.2.7.1.1.1.2.1.1', 'VBOP.2.7.1.1.1.2.1');
select pxp.f_insert_testructura_gui ('VBOP.2.7.1.1.1.2.1.2', 'VBOP.2.7.1.1.1.2.1');
select pxp.f_insert_testructura_gui ('VBOP.2.7.1.1.1.2.1.2.1', 'VBOP.2.7.1.1.1.2.1.2');
select pxp.f_insert_testructura_gui ('VBOP.2.7.1.1.1.2.1.2.2', 'VBOP.2.7.1.1.1.2.1.2');
select pxp.f_insert_testructura_gui ('OPCONTA.11', 'OPCONTA');
select pxp.f_insert_testructura_gui ('OPCONTA.2.7.1.1.1.2', 'OPCONTA.2.7.1.1.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.7.1.1.1.2.1', 'OPCONTA.2.7.1.1.1.2');
select pxp.f_insert_testructura_gui ('OPCONTA.2.7.1.1.1.2.1.1', 'OPCONTA.2.7.1.1.1.2.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.7.1.1.1.2.1.2', 'OPCONTA.2.7.1.1.1.2.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.7.1.1.1.2.1.2.1', 'OPCONTA.2.7.1.1.1.2.1.2');
select pxp.f_insert_testructura_gui ('OPCONTA.2.7.1.1.1.2.1.2.2', 'OPCONTA.2.7.1.1.1.2.1.2');
select pxp.f_insert_testructura_gui ('CONOP.12', 'CONOP');
select pxp.f_insert_testructura_gui ('CONOP.2.6.1.1.1.2', 'CONOP.2.6.1.1.1');
select pxp.f_insert_testructura_gui ('CONOP.2.6.1.1.1.2.1', 'CONOP.2.6.1.1.1.2');
select pxp.f_insert_testructura_gui ('CONOP.2.6.1.1.1.2.1.1', 'CONOP.2.6.1.1.1.2.1');
select pxp.f_insert_testructura_gui ('CONOP.2.6.1.1.1.2.1.2', 'CONOP.2.6.1.1.1.2.1');
select pxp.f_insert_testructura_gui ('CONOP.2.6.1.1.1.2.1.2.1', 'CONOP.2.6.1.1.1.2.1.2');
select pxp.f_insert_testructura_gui ('CONOP.2.6.1.1.1.2.1.2.2', 'CONOP.2.6.1.1.1.2.1.2');
select pxp.f_insert_testructura_gui ('VBPDC.1.11', 'VBPDC.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.7.1.1.1.2', 'VBPDC.1.4.7.1.1.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.7.1.1.1.2.1', 'VBPDC.1.4.7.1.1.1.2');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.7.1.1.1.2.1.1', 'VBPDC.1.4.7.1.1.1.2.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.7.1.1.1.2.1.2', 'VBPDC.1.4.7.1.1.1.2.1');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.7.1.1.1.2.1.2.1', 'VBPDC.1.4.7.1.1.1.2.1.2');
select pxp.f_insert_testructura_gui ('VBPDC.1.4.7.1.1.1.2.1.2.2', 'VBPDC.1.4.7.1.1.1.2.1.2');
select pxp.f_insert_testructura_gui ('OPUNI.12', 'OPUNI');
select pxp.f_insert_testructura_gui ('OPUNI.2.7.1.1.1.2', 'OPUNI.2.7.1.1.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.7.1.1.1.2.1', 'OPUNI.2.7.1.1.1.2');
select pxp.f_insert_testructura_gui ('OPUNI.2.7.1.1.1.2.1.1', 'OPUNI.2.7.1.1.1.2.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.7.1.1.1.2.1.2', 'OPUNI.2.7.1.1.1.2.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.7.1.1.1.2.1.2.1', 'OPUNI.2.7.1.1.1.2.1.2');
select pxp.f_insert_testructura_gui ('OPUNI.2.7.1.1.1.2.1.2.2', 'OPUNI.2.7.1.1.1.2.1.2');
select pxp.f_insert_testructura_gui ('VBOPOA.11', 'VBOPOA');
select pxp.f_insert_testructura_gui ('VBOPOA.2.7.1.1.1.2', 'VBOPOA.2.7.1.1.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.7.1.1.1.2.1', 'VBOPOA.2.7.1.1.1.2');
select pxp.f_insert_testructura_gui ('VBOPOA.2.7.1.1.1.2.1.1', 'VBOPOA.2.7.1.1.1.2.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.7.1.1.1.2.1.2', 'VBOPOA.2.7.1.1.1.2.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.7.1.1.1.2.1.2.1', 'VBOPOA.2.7.1.1.1.2.1.2');
select pxp.f_insert_testructura_gui ('VBOPOA.2.7.1.1.1.2.1.2.2', 'VBOPOA.2.7.1.1.1.2.1.2');
select pxp.f_insert_testructura_gui ('SOLCAJA.3.1.1.1.2', 'SOLCAJA.3.1.1.1');
select pxp.f_insert_testructura_gui ('SOLCAJA.3.1.1.1.2.1', 'SOLCAJA.3.1.1.1.2');
select pxp.f_insert_testructura_gui ('SOLCAJA.3.1.1.1.2.1.1', 'SOLCAJA.3.1.1.1.2.1');
select pxp.f_insert_testructura_gui ('SOLCAJA.3.1.1.1.2.1.2', 'SOLCAJA.3.1.1.1.2.1');
select pxp.f_insert_testructura_gui ('SOLCAJA.3.1.1.1.2.1.2.1', 'SOLCAJA.3.1.1.1.2.1.2');
select pxp.f_insert_testructura_gui ('SOLCAJA.3.1.1.1.2.1.2.2', 'SOLCAJA.3.1.1.1.2.1.2');
select pxp.f_insert_testructura_gui ('SOLCAJA.4.2', 'SOLCAJA.4');
select pxp.f_insert_testructura_gui ('VBCAJA.5.1.1.1.2', 'VBCAJA.5.1.1.1');
select pxp.f_insert_testructura_gui ('VBCAJA.5.1.1.1.2.1', 'VBCAJA.5.1.1.1.2');
select pxp.f_insert_testructura_gui ('VBCAJA.5.1.1.1.2.1.1', 'VBCAJA.5.1.1.1.2.1');
select pxp.f_insert_testructura_gui ('VBCAJA.5.1.1.1.2.1.2', 'VBCAJA.5.1.1.1.2.1');
select pxp.f_insert_testructura_gui ('VBCAJA.5.1.1.1.2.1.2.1', 'VBCAJA.5.1.1.1.2.1.2');
select pxp.f_insert_testructura_gui ('VBCAJA.5.1.1.1.2.1.2.2', 'VBCAJA.5.1.1.1.2.1.2');
select pxp.f_insert_testructura_gui ('VBCAJA.6.2', 'VBCAJA.6');
select pxp.f_insert_testructura_gui ('VBPCOS.1.11', 'VBPCOS.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.7.1.1.1.2', 'VBPCOS.1.4.7.1.1.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.7.1.1.1.2.1', 'VBPCOS.1.4.7.1.1.1.2');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.7.1.1.1.2.1.1', 'VBPCOS.1.4.7.1.1.1.2.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.7.1.1.1.2.1.2', 'VBPCOS.1.4.7.1.1.1.2.1');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.7.1.1.1.2.1.2.1', 'VBPCOS.1.4.7.1.1.1.2.1.2');
select pxp.f_insert_testructura_gui ('VBPCOS.1.4.7.1.1.1.2.1.2.2', 'VBPCOS.1.4.7.1.1.1.2.1.2');
select pxp.f_insert_testructura_gui ('INGCAJ.1', 'INGCAJ');
select pxp.f_insert_testructura_gui ('INGCAJ.2', 'INGCAJ');
select pxp.f_insert_testructura_gui ('INGCAJ.3', 'INGCAJ');
select pxp.f_insert_testructura_gui ('INGCAJ.4', 'INGCAJ');
select pxp.f_insert_testructura_gui ('INGCAJ.1.1', 'INGCAJ.1');
select pxp.f_insert_testructura_gui ('INGCAJ.1.2', 'INGCAJ.1');
select pxp.f_insert_testructura_gui ('INGCAJ.1.2.1', 'INGCAJ.1.2');
select pxp.f_insert_testructura_gui ('INGCAJ.1.2.1.1', 'INGCAJ.1.2.1');
select pxp.f_insert_testructura_gui ('INGCAJ.1.2.1.2', 'INGCAJ.1.2.1');
select pxp.f_insert_testructura_gui ('INGCAJ.1.2.1.3', 'INGCAJ.1.2.1');
select pxp.f_insert_testructura_gui ('INGCAJ.1.2.1.4', 'INGCAJ.1.2.1');
select pxp.f_insert_testructura_gui ('INGCAJ.1.2.1.5', 'INGCAJ.1.2.1');
select pxp.f_insert_testructura_gui ('INGCAJ.1.2.1.5.1', 'INGCAJ.1.2.1.5');
select pxp.f_insert_testructura_gui ('INGCAJ.1.2.1.5.1.1', 'INGCAJ.1.2.1.5.1');
select pxp.f_insert_testructura_gui ('SOLEFESD.3.5', 'SOLEFESD.3');
select pxp.f_insert_testructura_gui ('VBFACREN.3', 'VBFACREN');
select pxp.f_insert_testructura_gui ('SOLEFE.3.1.1', 'SOLEFE.3.1');
select pxp.f_insert_testructura_gui ('SOLEFE.3.1.1.1', 'SOLEFE.3.1.1');
select pxp.f_insert_testructura_gui ('SOLEFE.3.1.1.2', 'SOLEFE.3.1.1');
select pxp.f_insert_testructura_gui ('SOLEFE.3.1.1.3', 'SOLEFE.3.1.1');
select pxp.f_insert_testructura_gui ('SOLEFE.3.1.1.4', 'SOLEFE.3.1.1');
select pxp.f_insert_testructura_gui ('SOLEFE.3.1.1.1.1', 'SOLEFE.3.1.1.1');
select pxp.f_insert_testructura_gui ('SOLEFE.3.1.1.1.1.1', 'SOLEFE.3.1.1.1.1');
select pxp.f_insert_testructura_gui ('SOLEFE.3.1.1.1.1.2', 'SOLEFE.3.1.1.1.1');
select pxp.f_insert_testructura_gui ('SOLEFE.3.1.1.1.1.1.1', 'SOLEFE.3.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('SOLEFE.3.1.1.1.1.1.1.1', 'SOLEFE.3.1.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('SOLEFE.3.1.1.1.1.1.1.2', 'SOLEFE.3.1.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('SOLEFE.3.1.1.1.1.1.1.2.1', 'SOLEFE.3.1.1.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('SOLEFE.3.1.1.1.1.1.1.2.2', 'SOLEFE.3.1.1.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('SOLEFESD.1.1.1', 'SOLEFESD.1.1');
select pxp.f_insert_testructura_gui ('SOLEFESD.1.1.1.1', 'SOLEFESD.1.1.1');
select pxp.f_insert_testructura_gui ('SOLEFESD.1.1.1.2', 'SOLEFESD.1.1.1');
select pxp.f_insert_testructura_gui ('SOLEFESD.1.1.1.3', 'SOLEFESD.1.1.1');
select pxp.f_insert_testructura_gui ('SOLEFESD.1.1.1.4', 'SOLEFESD.1.1.1');
select pxp.f_insert_testructura_gui ('SOLEFESD.1.1.1.1.1', 'SOLEFESD.1.1.1.1');
select pxp.f_insert_testructura_gui ('SOLEFESD.1.1.1.1.1.1', 'SOLEFESD.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('SOLEFESD.1.1.1.1.1.2', 'SOLEFESD.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('SOLEFESD.1.1.1.1.1.1.1', 'SOLEFESD.1.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('SOLEFESD.1.1.1.1.1.1.1.1', 'SOLEFESD.1.1.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('SOLEFESD.1.1.1.1.1.1.1.2', 'SOLEFESD.1.1.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('SOLEFESD.1.1.1.1.1.1.1.2.1', 'SOLEFESD.1.1.1.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('SOLEFESD.1.1.1.1.1.1.1.2.2', 'SOLEFESD.1.1.1.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('VBFACREN.2.1.1', 'VBFACREN.2.1');
select pxp.f_insert_testructura_gui ('VBFACREN.2.1.1.1', 'VBFACREN.2.1.1');
select pxp.f_insert_testructura_gui ('VBFACREN.2.1.1.2', 'VBFACREN.2.1.1');
select pxp.f_insert_testructura_gui ('VBFACREN.2.1.1.3', 'VBFACREN.2.1.1');
select pxp.f_insert_testructura_gui ('VBFACREN.2.1.1.4', 'VBFACREN.2.1.1');
select pxp.f_insert_testructura_gui ('VBFACREN.2.1.1.1.1', 'VBFACREN.2.1.1.1');
select pxp.f_insert_testructura_gui ('VBFACREN.2.1.1.1.1.1', 'VBFACREN.2.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBFACREN.2.1.1.1.1.2', 'VBFACREN.2.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBFACREN.2.1.1.1.1.1.1', 'VBFACREN.2.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBFACREN.2.1.1.1.1.1.1.1', 'VBFACREN.2.1.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBFACREN.2.1.1.1.1.1.1.2', 'VBFACREN.2.1.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBFACREN.2.1.1.1.1.1.1.2.1', 'VBFACREN.2.1.1.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('VBFACREN.2.1.1.1.1.1.1.2.2', 'VBFACREN.2.1.1.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('INGCAJ.1.1.1', 'INGCAJ.1.1');
select pxp.f_insert_testructura_gui ('INGCAJ.1.1.1.1', 'INGCAJ.1.1.1');
select pxp.f_insert_testructura_gui ('INGCAJ.1.1.1.2', 'INGCAJ.1.1.1');
select pxp.f_insert_testructura_gui ('INGCAJ.1.1.1.3', 'INGCAJ.1.1.1');
select pxp.f_insert_testructura_gui ('INGCAJ.1.1.1.4', 'INGCAJ.1.1.1');
select pxp.f_insert_testructura_gui ('INGCAJ.1.1.1.1.1', 'INGCAJ.1.1.1.1');
select pxp.f_insert_testructura_gui ('INGCAJ.1.1.1.1.1.1', 'INGCAJ.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('INGCAJ.1.1.1.1.1.2', 'INGCAJ.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('INGCAJ.1.1.1.1.1.1.1', 'INGCAJ.1.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('INGCAJ.1.1.1.1.1.1.1.1', 'INGCAJ.1.1.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('INGCAJ.1.1.1.1.1.1.1.2', 'INGCAJ.1.1.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('INGCAJ.1.1.1.1.1.1.1.2.1', 'INGCAJ.1.1.1.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('INGCAJ.1.1.1.1.1.1.1.2.2', 'INGCAJ.1.1.1.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('OBPG.8.8', 'OBPG.8');
select pxp.f_insert_testructura_gui ('OBPG.8.8.1', 'OBPG.8.8');
select pxp.f_insert_testructura_gui ('OBPG.8.8.2', 'OBPG.8.8');
select pxp.f_insert_testructura_gui ('OBPG.8.8.3', 'OBPG.8.8');
select pxp.f_insert_testructura_gui ('OBPG.8.8.1.1', 'OBPG.8.8.1');
select pxp.f_insert_testructura_gui ('OBPG.8.8.1.1.1', 'OBPG.8.8.1.1');
select pxp.f_insert_testructura_gui ('OBPG.8.8.1.1.2', 'OBPG.8.8.1.1');
select pxp.f_insert_testructura_gui ('OBPG.8.8.1.1.3', 'OBPG.8.8.1.1');
select pxp.f_insert_testructura_gui ('OBPG.8.8.1.1.4', 'OBPG.8.8.1.1');
select pxp.f_insert_testructura_gui ('OBPG.8.8.1.1.1.1', 'OBPG.8.8.1.1.1');
select pxp.f_insert_testructura_gui ('OBPG.8.8.1.1.1.1.1', 'OBPG.8.8.1.1.1.1');
select pxp.f_insert_testructura_gui ('OBPG.8.8.1.1.1.1.2', 'OBPG.8.8.1.1.1.1');
select pxp.f_insert_testructura_gui ('OBPG.8.8.1.1.1.1.1.1', 'OBPG.8.8.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('OBPG.8.8.1.1.1.1.1.1.1', 'OBPG.8.8.1.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('OBPG.8.8.1.1.1.1.1.1.2', 'OBPG.8.8.1.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('OBPG.8.8.1.1.1.1.1.1.2.1', 'OBPG.8.8.1.1.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('OBPG.8.8.1.1.1.1.1.1.2.2', 'OBPG.8.8.1.1.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('OBPG.8.8.2.1', 'OBPG.8.8.2');
select pxp.f_insert_testructura_gui ('OBPG.8.8.3.1', 'OBPG.8.8.3');
select pxp.f_insert_testructura_gui ('SOLPD.2.8', 'SOLPD.2');
select pxp.f_insert_testructura_gui ('SOLPD.2.8.1', 'SOLPD.2.8');
select pxp.f_insert_testructura_gui ('SOLPD.2.8.2', 'SOLPD.2.8');
select pxp.f_insert_testructura_gui ('SOLPD.2.8.3', 'SOLPD.2.8');
select pxp.f_insert_testructura_gui ('SOLPD.2.8.1.1', 'SOLPD.2.8.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.8.1.1.1', 'SOLPD.2.8.1.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.8.1.1.2', 'SOLPD.2.8.1.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.8.1.1.3', 'SOLPD.2.8.1.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.8.1.1.4', 'SOLPD.2.8.1.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.8.1.1.1.1', 'SOLPD.2.8.1.1.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.8.1.1.1.1.1', 'SOLPD.2.8.1.1.1.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.8.1.1.1.1.2', 'SOLPD.2.8.1.1.1.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.8.1.1.1.1.1.1', 'SOLPD.2.8.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.8.1.1.1.1.1.1.1', 'SOLPD.2.8.1.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.8.1.1.1.1.1.1.2', 'SOLPD.2.8.1.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('SOLPD.2.8.1.1.1.1.1.1.2.1', 'SOLPD.2.8.1.1.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('SOLPD.2.8.1.1.1.1.1.1.2.2', 'SOLPD.2.8.1.1.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('SOLPD.2.8.2.1', 'SOLPD.2.8.2');
select pxp.f_insert_testructura_gui ('SOLPD.2.8.3.1', 'SOLPD.2.8.3');
select pxp.f_insert_testructura_gui ('VBOP.2.8', 'VBOP.2');
select pxp.f_insert_testructura_gui ('VBOP.2.8.1', 'VBOP.2.8');
select pxp.f_insert_testructura_gui ('VBOP.2.8.2', 'VBOP.2.8');
select pxp.f_insert_testructura_gui ('VBOP.2.8.3', 'VBOP.2.8');
select pxp.f_insert_testructura_gui ('VBOP.2.8.1.1', 'VBOP.2.8.1');
select pxp.f_insert_testructura_gui ('VBOP.2.8.1.1.1', 'VBOP.2.8.1.1');
select pxp.f_insert_testructura_gui ('VBOP.2.8.1.1.2', 'VBOP.2.8.1.1');
select pxp.f_insert_testructura_gui ('VBOP.2.8.1.1.3', 'VBOP.2.8.1.1');
select pxp.f_insert_testructura_gui ('VBOP.2.8.1.1.4', 'VBOP.2.8.1.1');
select pxp.f_insert_testructura_gui ('VBOP.2.8.1.1.1.1', 'VBOP.2.8.1.1.1');
select pxp.f_insert_testructura_gui ('VBOP.2.8.1.1.1.1.1', 'VBOP.2.8.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBOP.2.8.1.1.1.1.2', 'VBOP.2.8.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBOP.2.8.1.1.1.1.1.1', 'VBOP.2.8.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBOP.2.8.1.1.1.1.1.1.1', 'VBOP.2.8.1.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBOP.2.8.1.1.1.1.1.1.2', 'VBOP.2.8.1.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBOP.2.8.1.1.1.1.1.1.2.1', 'VBOP.2.8.1.1.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('VBOP.2.8.1.1.1.1.1.1.2.2', 'VBOP.2.8.1.1.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('VBOP.2.8.2.1', 'VBOP.2.8.2');
select pxp.f_insert_testructura_gui ('VBOP.2.8.3.1', 'VBOP.2.8.3');
select pxp.f_insert_testructura_gui ('OPCONTA.2.8', 'OPCONTA.2');
select pxp.f_insert_testructura_gui ('OPCONTA.2.8.1', 'OPCONTA.2.8');
select pxp.f_insert_testructura_gui ('OPCONTA.2.8.2', 'OPCONTA.2.8');
select pxp.f_insert_testructura_gui ('OPCONTA.2.8.3', 'OPCONTA.2.8');
select pxp.f_insert_testructura_gui ('OPCONTA.2.8.1.1', 'OPCONTA.2.8.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.8.1.1.1', 'OPCONTA.2.8.1.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.8.1.1.2', 'OPCONTA.2.8.1.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.8.1.1.3', 'OPCONTA.2.8.1.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.8.1.1.4', 'OPCONTA.2.8.1.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.8.1.1.1.1', 'OPCONTA.2.8.1.1.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.8.1.1.1.1.1', 'OPCONTA.2.8.1.1.1.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.8.1.1.1.1.2', 'OPCONTA.2.8.1.1.1.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.8.1.1.1.1.1.1', 'OPCONTA.2.8.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.8.1.1.1.1.1.1.1', 'OPCONTA.2.8.1.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.8.1.1.1.1.1.1.2', 'OPCONTA.2.8.1.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('OPCONTA.2.8.1.1.1.1.1.1.2.1', 'OPCONTA.2.8.1.1.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('OPCONTA.2.8.1.1.1.1.1.1.2.2', 'OPCONTA.2.8.1.1.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('OPCONTA.2.8.2.1', 'OPCONTA.2.8.2');
select pxp.f_insert_testructura_gui ('OPCONTA.2.8.3.1', 'OPCONTA.2.8.3');
select pxp.f_insert_testructura_gui ('OPUNI.2.8', 'OPUNI.2');
select pxp.f_insert_testructura_gui ('OPUNI.2.8.1', 'OPUNI.2.8');
select pxp.f_insert_testructura_gui ('OPUNI.2.8.2', 'OPUNI.2.8');
select pxp.f_insert_testructura_gui ('OPUNI.2.8.3', 'OPUNI.2.8');
select pxp.f_insert_testructura_gui ('OPUNI.2.8.1.1', 'OPUNI.2.8.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.8.1.1.1', 'OPUNI.2.8.1.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.8.1.1.2', 'OPUNI.2.8.1.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.8.1.1.3', 'OPUNI.2.8.1.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.8.1.1.4', 'OPUNI.2.8.1.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.8.1.1.1.1', 'OPUNI.2.8.1.1.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.8.1.1.1.1.1', 'OPUNI.2.8.1.1.1.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.8.1.1.1.1.2', 'OPUNI.2.8.1.1.1.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.8.1.1.1.1.1.1', 'OPUNI.2.8.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.8.1.1.1.1.1.1.1', 'OPUNI.2.8.1.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.8.1.1.1.1.1.1.2', 'OPUNI.2.8.1.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('OPUNI.2.8.1.1.1.1.1.1.2.1', 'OPUNI.2.8.1.1.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('OPUNI.2.8.1.1.1.1.1.1.2.2', 'OPUNI.2.8.1.1.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('OPUNI.2.8.2.1', 'OPUNI.2.8.2');
select pxp.f_insert_testructura_gui ('OPUNI.2.8.3.1', 'OPUNI.2.8.3');
select pxp.f_insert_testructura_gui ('VBOPOA.2.8', 'VBOPOA.2');
select pxp.f_insert_testructura_gui ('VBOPOA.2.8.1', 'VBOPOA.2.8');
select pxp.f_insert_testructura_gui ('VBOPOA.2.8.2', 'VBOPOA.2.8');
select pxp.f_insert_testructura_gui ('VBOPOA.2.8.3', 'VBOPOA.2.8');
select pxp.f_insert_testructura_gui ('VBOPOA.2.8.1.1', 'VBOPOA.2.8.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.8.1.1.1', 'VBOPOA.2.8.1.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.8.1.1.2', 'VBOPOA.2.8.1.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.8.1.1.3', 'VBOPOA.2.8.1.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.8.1.1.4', 'VBOPOA.2.8.1.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.8.1.1.1.1', 'VBOPOA.2.8.1.1.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.8.1.1.1.1.1', 'VBOPOA.2.8.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.8.1.1.1.1.2', 'VBOPOA.2.8.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.8.1.1.1.1.1.1', 'VBOPOA.2.8.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.8.1.1.1.1.1.1.1', 'VBOPOA.2.8.1.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.8.1.1.1.1.1.1.2', 'VBOPOA.2.8.1.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBOPOA.2.8.1.1.1.1.1.1.2.1', 'VBOPOA.2.8.1.1.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('VBOPOA.2.8.1.1.1.1.1.1.2.2', 'VBOPOA.2.8.1.1.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('VBOPOA.2.8.2.1', 'VBOPOA.2.8.2');
select pxp.f_insert_testructura_gui ('VBOPOA.2.8.3.1', 'VBOPOA.2.8.3');
select pxp.f_delete_testructura_gui ('CONOPT', 'CAROPSOL');
select pxp.f_insert_testructura_gui ('CAJA.4.5', 'CAJA.4');
select pxp.f_insert_testructura_gui ('VBRENCJ.5', 'VBRENCJ');
select pxp.f_insert_testructura_gui ('VBCJ.5', 'VBCJ');
select pxp.f_insert_testructura_gui ('VBCP.6', 'VBCP');
select pxp.f_insert_testructura_gui ('VBRENCJA.7', 'VBRENCJA');
select pxp.f_insert_testructura_gui ('TESREPFR', 'CARFR');
select pxp.f_insert_testructura_gui ('REPMOVCA', 'TESREPFR');
select pxp.f_insert_testructura_gui ('CAJA.4.6', 'CAJA.4');
select pxp.f_insert_testructura_gui ('VBRENCJ.6', 'VBRENCJ');
select pxp.f_insert_testructura_gui ('VBCJ.6', 'VBCJ');
select pxp.f_insert_testructura_gui ('VBCP.7', 'VBCP');
select pxp.f_insert_testructura_gui ('VBRENCJA.8', 'VBRENCJA');
select pxp.f_insert_testructura_gui ('REPMOVCA.1', 'REPMOVCA');
select pxp.f_insert_testructura_gui ('TESOLTRA', 'CARLB');
select pxp.f_insert_testructura_gui ('TEAPROTRA', 'CARLB');
select pxp.f_insert_testructura_gui ('TESOLTRA.1', 'TESOLTRA');
select pxp.f_insert_testructura_gui ('TESOLTRA.1.1', 'TESOLTRA.1');
select pxp.f_insert_testructura_gui ('TESOLTRA.1.1.1', 'TESOLTRA.1.1');
select pxp.f_insert_testructura_gui ('TESOLTRA.1.1.2', 'TESOLTRA.1.1');
select pxp.f_insert_testructura_gui ('TESOLTRA.1.1.3', 'TESOLTRA.1.1');
select pxp.f_insert_testructura_gui ('TESOLTRA.1.1.4', 'TESOLTRA.1.1');
select pxp.f_insert_testructura_gui ('TESOLTRA.1.1.5', 'TESOLTRA.1.1');
select pxp.f_insert_testructura_gui ('TESOLTRA.1.1.5.1', 'TESOLTRA.1.1.5');
select pxp.f_insert_testructura_gui ('TESOLTRA.1.1.5.1.1', 'TESOLTRA.1.1.5.1');
select pxp.f_insert_testructura_gui ('TEAPROTRA.1', 'TEAPROTRA');
select pxp.f_insert_testructura_gui ('TEAPROTRA.1.1', 'TEAPROTRA.1');
select pxp.f_insert_testructura_gui ('TEAPROTRA.1.1.1', 'TEAPROTRA.1.1');
select pxp.f_insert_testructura_gui ('TEAPROTRA.1.1.2', 'TEAPROTRA.1.1');
select pxp.f_insert_testructura_gui ('TEAPROTRA.1.1.3', 'TEAPROTRA.1.1');
select pxp.f_insert_testructura_gui ('TEAPROTRA.1.1.4', 'TEAPROTRA.1.1');
select pxp.f_insert_testructura_gui ('TEAPROTRA.1.1.5', 'TEAPROTRA.1.1');
select pxp.f_insert_testructura_gui ('TEAPROTRA.1.1.5.1', 'TEAPROTRA.1.1.5');
select pxp.f_insert_testructura_gui ('TEAPROTRA.1.1.5.1.1', 'TEAPROTRA.1.1.5.1');
select pxp.f_insert_testructura_gui ('REPLIB', 'CARLB');
select pxp.f_delete_testructura_gui ('REPLB', 'TESOLTRA');
select pxp.f_insert_testructura_gui ('REPLB', 'CARLB');
select pxp.f_insert_testructura_gui ('PAGESP', 'CAROPSOL');
select pxp.f_insert_testructura_gui ('RCRF', 'TESREPFR');
select pxp.f_insert_testructura_gui ('PAGESP.1', 'PAGESP');
select pxp.f_insert_testructura_gui ('PAGESP.2', 'PAGESP');
select pxp.f_insert_testructura_gui ('PAGESP.3', 'PAGESP');
select pxp.f_insert_testructura_gui ('PAGESP.4', 'PAGESP');
select pxp.f_insert_testructura_gui ('PAGESP.5', 'PAGESP');
select pxp.f_insert_testructura_gui ('PAGESP.6', 'PAGESP');
select pxp.f_insert_testructura_gui ('PAGESP.7', 'PAGESP');
select pxp.f_insert_testructura_gui ('PAGESP.8', 'PAGESP');
select pxp.f_insert_testructura_gui ('PAGESP.9', 'PAGESP');
select pxp.f_insert_testructura_gui ('PAGESP.10', 'PAGESP');
select pxp.f_insert_testructura_gui ('PAGESP.11', 'PAGESP');
select pxp.f_insert_testructura_gui ('PAGESP.12', 'PAGESP');
select pxp.f_insert_testructura_gui ('PAGESP.1.1', 'PAGESP.1');
select pxp.f_insert_testructura_gui ('PAGESP.2.1', 'PAGESP.2');
select pxp.f_insert_testructura_gui ('PAGESP.2.2', 'PAGESP.2');
select pxp.f_insert_testructura_gui ('PAGESP.2.3', 'PAGESP.2');
select pxp.f_insert_testructura_gui ('PAGESP.2.4', 'PAGESP.2');
select pxp.f_insert_testructura_gui ('PAGESP.2.5', 'PAGESP.2');
select pxp.f_insert_testructura_gui ('PAGESP.2.6', 'PAGESP.2');
select pxp.f_insert_testructura_gui ('PAGESP.2.7', 'PAGESP.2');
select pxp.f_insert_testructura_gui ('PAGESP.2.8', 'PAGESP.2');
select pxp.f_insert_testructura_gui ('PAGESP.2.3.1', 'PAGESP.2.3');
select pxp.f_insert_testructura_gui ('PAGESP.2.3.2', 'PAGESP.2.3');
select pxp.f_insert_testructura_gui ('PAGESP.2.3.3', 'PAGESP.2.3');
select pxp.f_insert_testructura_gui ('PAGESP.2.3.1.1', 'PAGESP.2.3.1');
select pxp.f_insert_testructura_gui ('PAGESP.2.3.1.1.1', 'PAGESP.2.3.1.1');
select pxp.f_insert_testructura_gui ('PAGESP.2.3.1.1.2', 'PAGESP.2.3.1.1');
select pxp.f_insert_testructura_gui ('PAGESP.2.3.1.1.3', 'PAGESP.2.3.1.1');
select pxp.f_insert_testructura_gui ('PAGESP.2.3.1.1.4', 'PAGESP.2.3.1.1');
select pxp.f_insert_testructura_gui ('PAGESP.2.3.1.1.1.1', 'PAGESP.2.3.1.1.1');
select pxp.f_insert_testructura_gui ('PAGESP.2.3.1.1.1.1.1', 'PAGESP.2.3.1.1.1.1');
select pxp.f_insert_testructura_gui ('PAGESP.2.3.1.1.1.1.2', 'PAGESP.2.3.1.1.1.1');
select pxp.f_insert_testructura_gui ('PAGESP.2.3.1.1.1.1.1.1', 'PAGESP.2.3.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('PAGESP.2.3.1.1.1.1.1.1.1', 'PAGESP.2.3.1.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('PAGESP.2.3.1.1.1.1.1.1.2', 'PAGESP.2.3.1.1.1.1.1.1');
select pxp.f_insert_testructura_gui ('PAGESP.2.3.1.1.1.1.1.1.2.1', 'PAGESP.2.3.1.1.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('PAGESP.2.3.1.1.1.1.1.1.2.2', 'PAGESP.2.3.1.1.1.1.1.1.2');
select pxp.f_insert_testructura_gui ('PAGESP.2.3.2.1', 'PAGESP.2.3.2');
select pxp.f_insert_testructura_gui ('PAGESP.2.3.3.1', 'PAGESP.2.3.3');
select pxp.f_insert_testructura_gui ('PAGESP.2.5.1', 'PAGESP.2.5');
select pxp.f_insert_testructura_gui ('PAGESP.2.5.1.1', 'PAGESP.2.5.1');
select pxp.f_insert_testructura_gui ('PAGESP.2.5.1.2', 'PAGESP.2.5.1');
select pxp.f_insert_testructura_gui ('PAGESP.2.5.1.3', 'PAGESP.2.5.1');
select pxp.f_insert_testructura_gui ('PAGESP.2.5.1.4', 'PAGESP.2.5.1');
select pxp.f_insert_testructura_gui ('PAGESP.2.5.1.5', 'PAGESP.2.5.1');
select pxp.f_insert_testructura_gui ('PAGESP.2.5.1.5.1', 'PAGESP.2.5.1.5');
select pxp.f_insert_testructura_gui ('PAGESP.2.5.1.5.1.1', 'PAGESP.2.5.1.5.1');
select pxp.f_insert_testructura_gui ('PAGESP.2.8.1', 'PAGESP.2.8');
select pxp.f_insert_testructura_gui ('PAGESP.3.1', 'PAGESP.3');
select pxp.f_insert_testructura_gui ('PAGESP.3.2', 'PAGESP.3');
select pxp.f_insert_testructura_gui ('PAGESP.3.2.1', 'PAGESP.3.2');
select pxp.f_insert_testructura_gui ('PAGESP.3.2.2', 'PAGESP.3.2');
select pxp.f_insert_testructura_gui ('PAGESP.3.2.3', 'PAGESP.3.2');
select pxp.f_insert_testructura_gui ('PAGESP.3.2.4', 'PAGESP.3.2');
select pxp.f_insert_testructura_gui ('PAGESP.3.2.5', 'PAGESP.3.2');
select pxp.f_insert_testructura_gui ('PAGESP.3.2.6', 'PAGESP.3.2');
select pxp.f_insert_testructura_gui ('PAGESP.3.2.7', 'PAGESP.3.2');
select pxp.f_insert_testructura_gui ('PAGESP.3.2.1.1', 'PAGESP.3.2.1');
select pxp.f_insert_testructura_gui ('PAGESP.6.1', 'PAGESP.6');
select pxp.f_insert_testructura_gui ('PAGESP.6.2', 'PAGESP.6');
select pxp.f_insert_testructura_gui ('PAGESP.6.3', 'PAGESP.6');
select pxp.f_insert_testructura_gui ('PAGESP.6.4', 'PAGESP.6');
select pxp.f_insert_testructura_gui ('PAGESP.6.5', 'PAGESP.6');
select pxp.f_insert_testructura_gui ('PAGESP.6.6', 'PAGESP.6');
select pxp.f_insert_testructura_gui ('PAGESP.6.7', 'PAGESP.6');
select pxp.f_insert_testructura_gui ('RERANFEC', 'TESREPFR');
  
    
/***********************************F-DEP-RAC-TES-0-24/02/2018****************************************/



/**********************************I-DEP-RAC-TES-0-01/12/2018****************************************/




--DROP VIEW tes.vsolicitud_transferencia;
CREATE OR REPLACE VIEW tes.vsolicitud_transferencia (
    id_depto_conta,
    num_tramite,
    acreedor,
    id_moneda,
    fecha,
    id_gestion,
    id_cuenta_origen,
    id_cuenta_destino,
    monto,
    motivo,
    id_solicitud_transferencia,
    id_proceso_wf,
    id_estado_wf,
    estado,
    forma_pago,
    banco,
    id_depto_lb)
AS
 SELECT dd.id_depto_destino AS id_depto_conta,
    st.num_tramite,
    cbd.denominacion AS acreedor,
    cb.id_moneda,
    now()::date AS fecha,
    g.id_gestion,
    st.id_cuenta_origen,
    st.id_cuenta_destino,
    st.monto,
    st.motivo,
    st.id_solicitud_transferencia,
    st.id_proceso_wf,
    st.id_estado_wf,
    st.estado,
    'transferencia' AS forma_pago,
    'si' AS banco,
    dc.id_depto AS id_depto_lb
   FROM tes.tsolicitud_transferencia st
     JOIN tes.tdepto_cuenta_bancaria dc ON st.id_cuenta_origen = dc.id_cuenta_bancaria AND dc.estado_reg::text = 'activo'::text
     JOIN param.tdepto_depto dd ON dc.id_depto = dd.id_depto_origen AND dd.estado_reg::text = 'activo'::text
     JOIN tes.tcuenta_bancaria cb ON st.id_cuenta_origen = cb.id_cuenta_bancaria
     JOIN tes.tcuenta_bancaria cbd ON st.id_cuenta_destino = cbd.id_cuenta_bancaria
     JOIN tes.tdepto_cuenta_bancaria dcd ON st.id_cuenta_destino = dcd.id_cuenta_bancaria AND dc.estado_reg::text = 'activo'::text
     JOIN param.tdepto ddes ON ddes.id_depto = dcd.id_depto
     JOIN param.tgestion g ON g.gestion::numeric = to_char(now()::date::timestamp with time zone, 'YYYY'::text)::numeric;





CREATE OR REPLACE VIEW tes.vdevoluciones_caja_cd (
    id_solicitud_efectivo,
    id_funcionario,
    nro_tramite,
    monto,
    estado,
    fecha,
    ingreso_cd,
    observaciones,
    motivo,
    codigo,
    nombre,
    id_proceso_caja_rend,
    glosa,
    desc_funcionario1)
AS
 SELECT se.id_solicitud_efectivo,
    se.id_funcionario,
    se.nro_tramite,
    se.monto,
    se.estado,
    se.fecha,
    se.ingreso_cd,
    se.observaciones,
    se.motivo,
    ts.codigo,
    ts.nombre,
    se.id_proceso_caja_rend,
    (se.nro_tramite::text || ' - '::text) || se.motivo AS glosa,
    f.desc_funcionario1
   FROM tes.tsolicitud_efectivo se
     JOIN tes.ttipo_solicitud ts ON ts.id_tipo_solicitud = se.id_tipo_solicitud
     JOIN orga.vfuncionario f ON f.id_funcionario = se.id_funcionario
  WHERE se.id_proceso_caja_rend IS NOT NULL;



CREATE OR REPLACE VIEW tes.vsolicitud_efectivo_entregado (
    id_solicitud_efectivo,
    id_caja,
    codigo,
    id_depto,
    id_moneda,
    id_estado_wf,
    monto,
    monto_rendido,
    monto_devuelto,
    monto_repuesto,
    id_proceso_wf,
    nro_tramite,
    estado,
    estado_reg,
    motivo,
    id_funcionario,
    desc_funcionario,
    fecha,
    fecha_entrega,
    dias_maximo_rendicion,
    dias_no_rendidos,
    id_usuario_ai,
    fecha_reg,
    usuario_ai,
    id_usuario_reg,
    id_usuario_mod,
    fecha_mod,
    usr_reg,
    usr_mod,
    fecha_entregado_ult,
    fecha_ult_mov,
    solicitud_efectivo_padre,
    saldo)
AS
 SELECT solefe.id_solicitud_efectivo,
    solefe.id_caja,
    caja.codigo,
    caja.id_depto,
    caja.id_moneda,
    solefe.id_estado_wf,
    solefe.monto,
    COALESCE(( SELECT sum(tsolicitud_efectivo.monto) AS sum
           FROM tes.tsolicitud_efectivo
          WHERE tsolicitud_efectivo.id_solicitud_efectivo_fk = solefe.id_solicitud_efectivo AND tsolicitud_efectivo.estado::text = 'rendido'::text), 0.00) AS monto_rendido,
    COALESCE(( SELECT sum(tsolicitud_efectivo.monto) AS sum
           FROM tes.tsolicitud_efectivo
          WHERE tsolicitud_efectivo.id_solicitud_efectivo_fk = solefe.id_solicitud_efectivo AND tsolicitud_efectivo.estado::text = 'devuelto'::text), 0.00) AS monto_devuelto,
    COALESCE(( SELECT sum(tsolicitud_efectivo.monto) AS sum
           FROM tes.tsolicitud_efectivo
          WHERE tsolicitud_efectivo.id_solicitud_efectivo_fk = solefe.id_solicitud_efectivo AND tsolicitud_efectivo.estado::text = 'repuesto'::text), 0.00) AS monto_repuesto,
    solefe.id_proceso_wf,
    solefe.nro_tramite,
    solefe.estado,
    solefe.estado_reg,
    solefe.motivo,
    solefe.id_funcionario,
    fun.desc_funcionario1 AS desc_funcionario,
    solefe.fecha,
    solefe.fecha_entrega,
    caja.dias_maximo_rendicion,
        CASE
            WHEN solefe.estado::text = 'finalizado'::text THEN caja.dias_maximo_rendicion
            ELSE caja.dias_maximo_rendicion - ('now'::text::date - COALESCE(solefe.fecha_entrega, 'now'::text::date) - pxp.f_get_weekend_days(COALESCE(solefe.fecha_entrega, 'now'::text::date), 'now'::text::date))
        END AS dias_no_rendidos,
    solefe.id_usuario_ai,
    solefe.fecha_reg,
    solefe.usuario_ai,
    solefe.id_usuario_reg,
    solefe.id_usuario_mod,
    solefe.fecha_mod,
    usu1.cuenta AS usr_reg,
    usu2.cuenta AS usr_mod,
    solefe.fecha_entregado_ult,
    solefe.fecha_ult_mov,
    solpri.nro_tramite AS solicitud_efectivo_padre,
        CASE
            WHEN solefe.estado::text = ANY (ARRAY['entregado'::character varying::text, 'finalizado'::character varying::text]) THEN solefe.monto - COALESCE(( SELECT sum(tsolicitud_efectivo.monto) AS sum
               FROM tes.tsolicitud_efectivo
              WHERE tsolicitud_efectivo.id_solicitud_efectivo_fk = solefe.id_solicitud_efectivo AND tsolicitud_efectivo.estado::text = 'rendido'::text), 0.00) - COALESCE(( SELECT sum(tsolicitud_efectivo.monto) AS sum
               FROM tes.tsolicitud_efectivo
              WHERE tsolicitud_efectivo.id_solicitud_efectivo_fk = solefe.id_solicitud_efectivo AND tsolicitud_efectivo.estado::text = 'devuelto'::text), 0.00) + COALESCE(( SELECT sum(tsolicitud_efectivo.monto) AS sum
               FROM tes.tsolicitud_efectivo
              WHERE tsolicitud_efectivo.id_solicitud_efectivo_fk = solefe.id_solicitud_efectivo AND tsolicitud_efectivo.estado::text = 'repuesto'::text), 0.00)
            ELSE 0.00
        END AS saldo
   FROM tes.tsolicitud_efectivo solefe
     JOIN segu.tusuario usu1 ON usu1.id_usuario = solefe.id_usuario_reg
     JOIN tes.tcaja caja ON caja.id_caja = solefe.id_caja
     JOIN orga.vfuncionario fun ON fun.id_funcionario = solefe.id_funcionario
     LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = solefe.id_usuario_mod
     LEFT JOIN tes.tsolicitud_efectivo solpri ON solpri.id_solicitud_efectivo = solefe.id_solicitud_efectivo_fk
  WHERE solefe.id_tipo_solicitud = 1 AND 0 = 0 AND caja.tipo_ejecucion::text = 'sin_detalle'::text AND solefe.estado::text = 'entregado'::text;




CREATE OR REPLACE VIEW tes.vsolicitud_efectivo_finalizada (
    id_solicitud_efectivo,
    id_caja,
    codigo,
    id_depto,
    id_moneda,
    id_estado_wf,
    monto,
    monto_rendido,
    monto_rendido_sin_cbte,
    monto_rendido_con_cbte,
    monto_devuelto,
    monto_repuesto,
    id_proceso_wf,
    nro_tramite,
    estado,
    estado_reg,
    motivo,
    id_funcionario,
    desc_funcionario,
    fecha,
    fecha_entrega,
    dias_maximo_rendicion,
    dias_no_rendidos,
    id_usuario_ai,
    fecha_reg,
    usuario_ai,
    id_usuario_reg,
    id_usuario_mod,
    fecha_mod,
    usr_reg,
    usr_mod,
    fecha_entregado_ult,
    fecha_ult_mov,
    saldo)
AS
 SELECT solefe.id_solicitud_efectivo,
    solefe.id_caja,
    caja.codigo,
    caja.id_depto,
    caja.id_moneda,
    solefe.id_estado_wf,
    solefe.monto,
    COALESCE(( SELECT sum(tsolicitud_efectivo.monto) AS sum
           FROM tes.tsolicitud_efectivo
          WHERE tsolicitud_efectivo.id_solicitud_efectivo_fk = solefe.id_solicitud_efectivo AND tsolicitud_efectivo.estado::text = 'rendido'::text), 0.00) AS monto_rendido,
    COALESCE(( SELECT sum(sr1.monto) AS sum
           FROM tes.tsolicitud_efectivo s1
             JOIN tes.tsolicitud_rendicion_det sr1 ON sr1.id_solicitud_efectivo = s1.id_solicitud_efectivo
             JOIN tes.tproceso_caja p1 ON p1.id_proceso_caja = sr1.id_proceso_caja AND p1.estado::text <> 'rendido'::text
          WHERE s1.id_solicitud_efectivo_fk = solefe.id_solicitud_efectivo AND s1.estado::text = 'rendido'::text), 0.00) AS monto_rendido_sin_cbte,
    COALESCE(( SELECT sum(sr2.monto) AS sum
           FROM tes.tsolicitud_efectivo s2
             JOIN tes.tsolicitud_rendicion_det sr2 ON sr2.id_solicitud_efectivo = s2.id_solicitud_efectivo
             JOIN tes.tproceso_caja p2 ON p2.id_proceso_caja = sr2.id_proceso_caja AND p2.estado::text = 'rendido'::text
          WHERE s2.id_solicitud_efectivo_fk = solefe.id_solicitud_efectivo AND s2.estado::text = 'rendido'::text), 0.00) AS monto_rendido_con_cbte,
    COALESCE(( SELECT sum(tsolicitud_efectivo.monto) AS sum
           FROM tes.tsolicitud_efectivo
          WHERE tsolicitud_efectivo.id_solicitud_efectivo_fk = solefe.id_solicitud_efectivo AND tsolicitud_efectivo.estado::text = 'devuelto'::text), 0.00) AS monto_devuelto,
    COALESCE(( SELECT sum(tsolicitud_efectivo.monto) AS sum
           FROM tes.tsolicitud_efectivo
          WHERE tsolicitud_efectivo.id_solicitud_efectivo_fk = solefe.id_solicitud_efectivo AND tsolicitud_efectivo.estado::text = 'repuesto'::text), 0.00) AS monto_repuesto,
    solefe.id_proceso_wf,
    solefe.nro_tramite,
    solefe.estado,
    solefe.estado_reg,
    solefe.motivo,
    solefe.id_funcionario,
    fun.desc_funcionario1 AS desc_funcionario,
    solefe.fecha,
    solefe.fecha_entrega,
    caja.dias_maximo_rendicion,
        CASE
            WHEN solefe.estado::text = 'finalizado'::text THEN caja.dias_maximo_rendicion
            ELSE caja.dias_maximo_rendicion - ('now'::text::date - COALESCE(solefe.fecha_entrega, 'now'::text::date) - pxp.f_get_weekend_days(COALESCE(solefe.fecha_entrega, 'now'::text::date), 'now'::text::date))
        END AS dias_no_rendidos,
    solefe.id_usuario_ai,
    solefe.fecha_reg,
    solefe.usuario_ai,
    solefe.id_usuario_reg,
    solefe.id_usuario_mod,
    solefe.fecha_mod,
    usu1.cuenta AS usr_reg,
    usu2.cuenta AS usr_mod,
    solefe.fecha_entregado_ult,
    solefe.fecha_ult_mov,
        CASE
            WHEN solefe.estado::text = ANY (ARRAY['entregado'::character varying::text, 'finalizado'::character varying::text]) THEN solefe.monto - COALESCE(( SELECT sum(tsolicitud_efectivo.monto) AS sum
               FROM tes.tsolicitud_efectivo
              WHERE tsolicitud_efectivo.id_solicitud_efectivo_fk = solefe.id_solicitud_efectivo AND tsolicitud_efectivo.estado::text = 'rendido'::text), 0.00) - COALESCE(( SELECT sum(tsolicitud_efectivo.monto) AS sum
               FROM tes.tsolicitud_efectivo
              WHERE tsolicitud_efectivo.id_solicitud_efectivo_fk = solefe.id_solicitud_efectivo AND tsolicitud_efectivo.estado::text = 'devuelto'::text), 0.00) + COALESCE(( SELECT sum(tsolicitud_efectivo.monto) AS sum
               FROM tes.tsolicitud_efectivo
              WHERE tsolicitud_efectivo.id_solicitud_efectivo_fk = solefe.id_solicitud_efectivo AND tsolicitud_efectivo.estado::text = 'repuesto'::text), 0.00)
            ELSE 0.00
        END AS saldo
   FROM tes.tsolicitud_efectivo solefe
     JOIN segu.tusuario usu1 ON usu1.id_usuario = solefe.id_usuario_reg
     JOIN tes.tcaja caja ON caja.id_caja = solefe.id_caja
     JOIN orga.vfuncionario fun ON fun.id_funcionario = solefe.id_funcionario
     LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = solefe.id_usuario_mod
  WHERE solefe.id_tipo_solicitud = 1 AND caja.tipo_ejecucion::text = 'sin_detalle'::text AND solefe.estado::text = 'finalizado'::text;



ALTER TABLE tes.tsolicitud_transferencia
  ADD CONSTRAINT fk_tsolicitud_transferencia__id_cuenta_destino FOREIGN KEY (id_cuenta_destino)
    REFERENCES tes.tcuenta_bancaria(id_cuenta_bancaria)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE tes.tsolicitud_transferencia
  ADD CONSTRAINT fk_tsolicitud_transferencia__id_cuenta_origen FOREIGN KEY (id_cuenta_origen)
    REFERENCES tes.tcuenta_bancaria(id_cuenta_bancaria)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE tes.tsolicitud_transferencia
  ADD CONSTRAINT fk_tsolicitud_transferencia__id_estado_wf FOREIGN KEY (id_estado_wf)
    REFERENCES wf.testado_wf(id_estado_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE tes.tsolicitud_transferencia
  ADD CONSTRAINT fk_tsolicitud_transferencia__id_int_comprobante FOREIGN KEY (id_int_comprobante)
    REFERENCES conta.tint_comprobante(id_int_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE tes.tsolicitud_transferencia
  ADD CONSTRAINT fk_tsolicitud_transferencia__id_proceso_wf FOREIGN KEY (id_proceso_wf)
    REFERENCES wf.tproceso_wf(id_proceso_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


ALTER TABLE tes.tcuenta_bancaria_periodo
  ADD CONSTRAINT tcuenta_bancaria_periodo_fk FOREIGN KEY (id_cuenta_bancaria)
    REFERENCES tes.tcuenta_bancaria(id_cuenta_bancaria)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE tes.tcuenta_bancaria_periodo
  ADD CONSTRAINT tcuenta_bancaria_periodo_fk1 FOREIGN KEY (id_periodo)
    REFERENCES param.tperiodo(id_periodo)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
    NOT DEFERRABLE;


/**********************************F-DEP-RAC-TES-0-01/12/2018****************************************/



   
  
  