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
  ADD CONSTRAINT fk_tcuenta_bancaria_id_auxiliar FOREIGN KEY (id_auxiliar)
    REFERENCES conta.tauxiliar(id_auxiliar)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE; 

ALTER TABLE tes.tcuenta_bancaria
  ADD CONSTRAINT fk_tcuenta_bancaria_id_cuenta FOREIGN KEY (id_cuenta)
    REFERENCES conta.tcuenta(id_cuenta)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE tes.tcuenta_bancaria
  ADD CONSTRAINT fk_tcuenta_bancaria_id_institucion FOREIGN KEY (id_institucion)
    REFERENCES param.tinstitucion(id_institucion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
  
ALTER TABLE tes.tchequera
  ADD CONSTRAINT fk_tchequera_id_cuenta_bancaria FOREIGN KEY (id_cuenta_bancaria)
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
/***********************************F-DEP-RAC-TES-19-24/06/2013****************************************/
