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



/***********************************I-DEP-RAC-TES-19-20/08/2013****************************************/

--------------- SQL ---------------

--------------- SQL ---------------

 --------------- SQL ---------------

 -- object recreation


CREATE VIEW tes.vcomp_devtesprov_plan_pago(
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
    
    tipo,
    id_gestion_cuentas)
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
        
         pp.tipo,
         op.id_gestion AS id_gestion_cuentas
  FROM tes.tplan_pago pp
       JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago =
        op.id_obligacion_pago
       JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor;
       
/***********************************F-DEP-RAC-TES-19-20/08/2013****************************************/


 /***********************************I-DEP-RAC-TES-0-1/09/2013***************************************/

  CREATE OR REPLACE VIEW tes.vcomp_devtesprov_det_plan_pago(
    id_concepto_ingas,
    id_partida,
    id_partida_ejecucion_com,
    monto_pago_mb,
    monto_pago_mo,
    id_centro_costo,
    descripcion,
    id_plan_pago)
AS
  SELECT od.id_concepto_ingas,
         od.id_partida,
         od.id_partida_ejecucion_com,
         od.monto_pago_mb,
         od.monto_pago_mo,
         od.id_centro_costo,
         od.descripcion,
         pro.id_plan_pago
  FROM tes.tprorrateo pro
       JOIN tes.tobligacion_det od ON od.id_obligacion_det =
        pro.id_obligacion_det;
        
        
 /***********************************F-DEP-RAC-TES-0-1/09/2013***************************************/

 /***********************************I-DEP-RAC-TES-0-18/09/2013***************************************/

--------------- SQL ---------------

 -- object recreation
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
   
    tipo,
    id_gestion_cuentas,
    id_int_comprobante,
    liquido_pagable,
    liquido_pagable_mb)
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
      
         pp.tipo,
         op.id_gestion AS id_gestion_cuentas,
         pp.id_int_comprobante,
         pp.liquido_pagable,
         pp.liquido_pagable_mb
  FROM tes.tplan_pago pp
       JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago =
        op.id_obligacion_pago
       JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor;


--------------- SQL ---------------

--------------- SQL ---------------



CREATE OR REPLACE VIEW tes.vcomp_devtesprov_det_plan_pago(
    id_concepto_ingas,
    id_partida,
    id_partida_ejecucion_com,
    monto_pago_mb,
    monto_pago_mo,
    id_centro_costo,
    descripcion,
    id_plan_pago,
    id_prorrateo,
    id_int_transaccion)
AS
  SELECT od.id_concepto_ingas,
         od.id_partida,
         od.id_partida_ejecucion_com,
         pro.monto_ejecutar_mo AS monto_pago_mb,
         pro.monto_ejecutar_mb AS monto_pago_mo,
         od.id_centro_costo,
         od.descripcion,
         pro.id_plan_pago,
         pro.id_prorrateo,
         pro.id_int_transaccion
  FROM tes.tprorrateo pro
       JOIN tes.tobligacion_det od ON od.id_obligacion_det =
        pro.id_obligacion_det;


 /***********************************F-DEP-RAC-TES-0-18/09/2013***************************************/

 /***********************************I-DEP-RAC-TES-0-18/11/2013***************************************/

--------------- SQL ---------------

  -- object recreation
DROP VIEW tes.vcomp_devtesprov_plan_pago;

CREATE VIEW tes.vcomp_devtesprov_plan_pago(
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
    tipo,
    id_gestion_cuentas,
    id_int_comprobante,
    liquido_pagable,
    liquido_pagable_mb,
    nombre_pago,
    id_cuenta_bancaria_mov,
    nro_cheque)
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
         pp.tipo,
         op.id_gestion AS id_gestion_cuentas,
         pp.id_int_comprobante,
         pp.liquido_pagable,
         pp.liquido_pagable_mb,
         pp.nombre_pago,
         pp.id_cuenta_bancaria_mov,
         pp.nro_cheque
  FROM tes.tplan_pago pp
       JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago =
        op.id_obligacion_pago
       JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor;
       
/***********************************F-DEP-RAC-TES-0-16/12/2013***************************************/

/***********************************I-DEP-RCM-TES-0-16/01/2014***************************************/
ALTER TABLE tes.tcuenta_bancaria
  ADD CONSTRAINT fk_tcuenta_bancaria__id_moneda FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/***********************************F-DEP-RCM-TES-0-16/01/2014***************************************/




/***********************************I-DEP-RAC-TES-0-28/01/2014****************************************/

--------------- SQL ---------------

DROP VIEW tes.vcomp_devtesprov_det_plan_pago;

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
    id_int_transaccion)
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
         pro.id_int_transaccion
  FROM tes.tprorrateo pro
       JOIN tes.tobligacion_det od ON od.id_obligacion_det =
        pro.id_obligacion_det;

/***********************************F-DEP-RAC-TES-0-28/01/2014****************************************/





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


/***********************************I-DEP-RAC-TES-0-08/02/2014****************************************/

--------------- SQL ---------------

 -- object recreation
DROP VIEW tes.vcomp_devtesprov_plan_pago;

CREATE VIEW tes.vcomp_devtesprov_plan_pago (
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
    porc_monto_excento_var)
AS
SELECT pp.id_plan_pago, op.id_proveedor, p.desc_proveedor, op.id_moneda,
    op.id_depto_conta, op.numero, now() AS fecha_actual, pp.estado,
    pp.monto_ejecutar_total_mb, pp.monto_ejecutar_total_mo, pp.monto,
    pp.monto_mb, pp.monto_retgar_mb, pp.monto_retgar_mo, pp.monto_no_pagado,
    pp.monto_no_pagado_mb, pp.otros_descuentos, pp.otros_descuentos_mb,
    pp.id_plantilla, pp.id_cuenta_bancaria, pp.id_cuenta_bancaria_mov,
    pp.nro_cheque, pp.nro_cuenta_bancaria, op.num_tramite, pp.tipo,
    op.id_gestion AS id_gestion_cuentas, pp.id_int_comprobante,
    pp.liquido_pagable, pp.liquido_pagable_mb, pp.nombre_pago, pp.porc_monto_excento_var
FROM tes.tplan_pago pp
   JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago = op.id_obligacion_pago
   JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor;

/***********************************F-DEP-RAC-TES-0-08/02/2014****************************************/

/***********************************I-DEP-JRR-TES-0-24/04/2014*****************************************/

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
select pxp.f_insert_testructura_gui ('VBDP', 'TES');
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
select pxp.f_insert_tprocedimiento_gui ('WF_GATNREP_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_INS', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_MOD', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_ELI', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPGSEL_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAOB_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_OBTTCB_GET', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_FINREG_IME', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_ANTEOB_IME', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_IDSEXT_GET', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTOC_REP', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTREP_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROCPED_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTRPC_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPGSEL_SEL', 'OBPG.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_SEL', 'OBPG.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_COMEJEPAG_SEL', 'OBPG.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'OBPG.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIG_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPP_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_ARB_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_ARB_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_AUXCTA_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_INS', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_MOD', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_ELI', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PAFPP_IME', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PLT_SEL', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_SEL', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAPA_INS', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_INS', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_MOD', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_ELI', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_SEL', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SINPRE_IME', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SIGEPP_IME', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_ANTEPP_IME', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAREP_SEL', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_MOD', 'OBPG.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'OBPG.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'OBPG.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'OBPG.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'OBPG.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'OBPG.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'OBPG.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'OBPG.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'OBPG.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'OBPG.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'OBPG.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'OBPG.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'OBPG.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_INS', 'OBPG.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_MOD', 'OBPG.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_ELI', 'OBPG.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_SEL', 'OBPG.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'OBPG.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'OBPG.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPG.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'OBPG.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEM_SEL', 'OBPG.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'OBPG.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMALM_SEL', 'OBPG.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'OBPG.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_INS', 'OBPG.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_MOD', 'OBPG.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_ELI', 'OBPG.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_SEL', 'OBPG.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'OBPG.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'OBPG.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'OBPG.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPG.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'OBPG.6.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'OBPG.6.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'OBPG.6.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'OBPG.6.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'OBPG.6.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'OBPG.6.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPG.6.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'OBPG.6.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'OBPG.6.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'OBPG.6.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPG.6.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_INS', 'OBPG.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_MOD', 'OBPG.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_ELI', 'OBPG.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_SEL', 'OBPG.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'OBPG.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'OBPG.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPG.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_INS', 'OBPG.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_MOD', 'OBPG.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_ELI', 'OBPG.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_SEL', 'OBPG.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'OBPG.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'OBPG.7.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'OBPG.7.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'OBPG.7.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'OBPG.7.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'OBPG.7.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPG.7.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'OBPG.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'OBPG.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'OBPG.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPG.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_INS', 'CTABAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_MOD', 'CTABAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_ELI', 'CTABAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_SEL', 'CTABAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'CTABAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'CTABAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CHQ_INS', 'CTABAN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CHQ_MOD', 'CTABAN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CHQ_ELI', 'CTABAN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CHQ_SEL', 'CTABAN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'CTABAN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'CTABAN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'CTABAN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'CTABAN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'CTABAN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'CTABAN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'CTABAN.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'CTABAN.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'CTABAN.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'CTABAN.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'CTABAN.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'CAJA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPPTO_SEL', 'CAJA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'CAJA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILUSU_SEL', 'CAJA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILEPUO_SEL', 'CAJA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CAJA_INS', 'CAJA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CAJA_MOD', 'CAJA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CAJA_ELI', 'CAJA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CAJA_SEL', 'CAJA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CAJERO_INS', 'CAJA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CAJERO_MOD', 'CAJA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CAJERO_ELI', 'CAJA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CAJERO_SEL', 'CAJA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'CAJA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_INS', 'CTABANE', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_MOD', 'CTABANE', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_ELI', 'CTABANE', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_SEL', 'CTABANE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'CTABANE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'CTABANE', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CHQ_INS', 'CTABANE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CHQ_MOD', 'CTABANE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CHQ_ELI', 'CTABANE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CHQ_SEL', 'CTABANE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'CTABANE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'CTABANE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'CTABANE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'CTABANE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'CTABANE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'CTABANE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'CTABANE.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'CTABANE.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'CTABANE.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'CTABANE.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'CTABANE.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_IME', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTPROC_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_GETDEC_IME', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_SEL', 'OBPG.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_SEL', 'OBPG.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_GATNREP_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBEPUO_IME', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILEPUO_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SOLDEVPAG_IME', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_IDSEXT_GET', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTOC_REP', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTREP_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_IME', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROCPED_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTPROC_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTRPC_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PLT_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAPA_INS', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_INS', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_MOD', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_ELI', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SINPRE_IME', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SIGEPP_IME', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_ANTEPP_IME', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAREP_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_MOD', 'VBDP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'VBDP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_SEL', 'VBDP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOLAR_SEL', 'VBDP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_INS', 'VBDP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_MOD', 'VBDP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_ELI', 'VBDP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'VBDP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOLAR_MOD', 'VBDP.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'VBDP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'VBDP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'VBDP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'VBDP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_INS', 'VBDP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_MOD', 'VBDP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_ELI', 'VBDP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_SEL', 'VBDP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'VBDP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'VBDP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBDP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'VBDP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEM_SEL', 'VBDP.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'VBDP.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMALM_SEL', 'VBDP.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'VBDP.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_INS', 'VBDP.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_MOD', 'VBDP.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_ELI', 'VBDP.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_SEL', 'VBDP.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'VBDP.2.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'VBDP.2.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'VBDP.2.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBDP.2.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'VBDP.2.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'VBDP.2.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'VBDP.2.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'VBDP.2.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'VBDP.2.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'VBDP.2.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBDP.2.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'VBDP.2.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'VBDP.2.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'VBDP.2.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBDP.2.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'VBDP.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'VBDP.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'VBDP.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'VBDP.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PLT_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CABMOM_IME', 'OBPG.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPPROC_SEL', 'OBPG.3.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'OBPG.3.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_INS', 'OBPG.3.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_MOD', 'OBPG.3.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_ELI', 'OBPG.3.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_SEL', 'OBPG.3.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CABMOM_IME', 'OBPG.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'OBPG.4.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPPROC_SEL', 'OBPG.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'OBPG.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_INS', 'OBPG.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_MOD', 'OBPG.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_ELI', 'OBPG.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_SEL', 'OBPG.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'OBPG.6.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'OBPG.7.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'OBPG.7.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'OBPG.7.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPG.7.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'OBPG.7.1.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'OBPG.7.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_GETDEC_IME', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'VBDP.2.2.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CABMOM_IME', 'VBDP.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPPROC_SEL', 'VBDP.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'VBDP.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_INS', 'VBDP.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_MOD', 'VBDP.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_ELI', 'VBDP.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_SEL', 'VBDP.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAREP_SEL', 'OBPG.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'OBPG.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PAFPP_IME', 'OBPG.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_GETDEC_IME', 'OBPG.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PLT_SEL', 'OBPG.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_SEL', 'OBPG.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAPA_INS', 'OBPG.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_INS', 'OBPG.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_MOD', 'OBPG.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_ELI', 'OBPG.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_SEL', 'OBPG.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'OBPG.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'OBPG.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SINPRE_IME', 'OBPG.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SIGEPP_IME', 'OBPG.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_ANTEPP_IME', 'OBPG.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_SEL', 'OBPG.8.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_MOD', 'OBPG.8.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'OBPG.8.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'OBPG.8.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'OBPG.8.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'OBPG.8.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CABMOM_IME', 'OBPG.8.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'OBPG.8.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPPROC_SEL', 'OBPG.8.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'OBPG.8.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_INS', 'OBPG.8.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_MOD', 'OBPG.8.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_ELI', 'OBPG.8.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_SEL', 'OBPG.8.3.2', 'no');
select pxp.f_insert_tgui_rol ('VBDP', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('TES', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('SISTEMA', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('VBDP.3', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('VBDP.3.1', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('VBDP.2', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('VBDP.2.2', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('VBDP.2.2.3', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('VBDP.2.2.3.1', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('VBDP.2.2.2', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('VBDP.2.2.2.1', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('VBDP.2.2.1', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('VBDP.2.1', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('VBDP.1', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('OBPG', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('TES', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('SISTEMA', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.1', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.2', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.3', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.3.1', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.3.2', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.3.3', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.3.3.1', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.4', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.5', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.6', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.6.1', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.6.2', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.6.2.1', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.6.3', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.6.3.1', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.7', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.7.2', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.7.1', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.7.1.1', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG', 'OP - Pagos Directos de Servicios');
select pxp.f_insert_tgui_rol ('TES', 'OP - Pagos Directos de Servicios');
select pxp.f_insert_tgui_rol ('SISTEMA', 'OP - Pagos Directos de Servicios');
select pxp.f_insert_tgui_rol ('OBPG.1', 'OP - Pagos Directos de Servicios');
select pxp.f_insert_tgui_rol ('OBPG.2', 'OP - Pagos Directos de Servicios');
select pxp.f_insert_tgui_rol ('OBPG.3', 'OP - Pagos Directos de Servicios');
select pxp.f_insert_tgui_rol ('OBPG.3.1', 'OP - Pagos Directos de Servicios');
select pxp.f_insert_tgui_rol ('OBPG.3.2', 'OP - Pagos Directos de Servicios');
select pxp.f_insert_tgui_rol ('OBPG.3.3', 'OP - Pagos Directos de Servicios');
select pxp.f_insert_tgui_rol ('OBPG.3.3.1', 'OP - Pagos Directos de Servicios');
select pxp.f_insert_tgui_rol ('OBPG.4', 'OP - Pagos Directos de Servicios');
select pxp.f_insert_tgui_rol ('OBPG.5', 'OP - Pagos Directos de Servicios');
select pxp.f_insert_tgui_rol ('OBPG.6', 'OP - Pagos Directos de Servicios');
select pxp.f_insert_tgui_rol ('OBPG.6.1', 'OP - Pagos Directos de Servicios');
select pxp.f_insert_tgui_rol ('OBPG.6.2', 'OP - Pagos Directos de Servicios');
select pxp.f_insert_tgui_rol ('OBPG.6.2.1', 'OP - Pagos Directos de Servicios');
select pxp.f_insert_tgui_rol ('OBPG.6.3', 'OP - Pagos Directos de Servicios');
select pxp.f_insert_tgui_rol ('OBPG.6.3.1', 'OP - Pagos Directos de Servicios');
select pxp.f_insert_tgui_rol ('OBPG.7', 'OP - Pagos Directos de Servicios');
select pxp.f_insert_tgui_rol ('OBPG.7.2', 'OP - Pagos Directos de Servicios');
select pxp.f_insert_tgui_rol ('OBPG.7.1', 'OP - Pagos Directos de Servicios');
select pxp.f_insert_tgui_rol ('OBPG.7.1.1', 'OP - Pagos Directos de Servicios');
select pxp.f_insert_tgui_rol ('OBPG.4.2', 'OP - Pagos Directos de Servicios');
select pxp.f_insert_tgui_rol ('SISTEMA', 'OP - Cierre de Proceso');
select pxp.f_insert_tgui_rol ('OBPG.1', 'OP - Cierre de Proceso');
select pxp.f_insert_tgui_rol ('OBPG', 'OP - Cierre de Proceso');
select pxp.f_insert_tgui_rol ('TES', 'OP - Cierre de Proceso');
select pxp.f_insert_tgui_rol ('OBPG.3.2', 'OP - Cierre de Proceso');
select pxp.f_insert_tgui_rol ('OBPG.3', 'OP - Cierre de Proceso');
select pxp.f_insert_tgui_rol ('OBPG.3.3.2', 'OP - Cierre de Proceso');
select pxp.f_insert_tgui_rol ('OBPG.3.3', 'OP - Cierre de Proceso');
select pxp.f_insert_tgui_rol ('OBPG.4.2', 'OP - Cierre de Proceso');
select pxp.f_insert_tgui_rol ('OBPG.4', 'OP - Cierre de Proceso');
select pxp.f_insert_tgui_rol ('OBPG.4.1', 'OP - Cierre de Proceso');
select pxp.f_insert_tgui_rol ('OBPG.3.3.2', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.4.2', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('VBDP.3.2', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('OBPG.8.3', 'OP - Cierre de Proceso');
select pxp.f_insert_tgui_rol ('OBPG.8', 'OP - Cierre de Proceso');
select pxp.f_insert_tgui_rol ('OBPG.8.3.2', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.8.3', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.8', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('OBPG.2', 'OP - Cierre de Proceso');
select pxp.f_insert_tgui_rol ('CTABAN', 'OP - Cuenta Bancaria');
select pxp.f_insert_tgui_rol ('TES', 'OP - Cuenta Bancaria');
select pxp.f_insert_tgui_rol ('SISTEMA', 'OP - Cuenta Bancaria');
select pxp.f_insert_tgui_rol ('CTABAN.2', 'OP - Cuenta Bancaria');
select pxp.f_insert_tgui_rol ('CTABAN.2.1', 'OP - Cuenta Bancaria');
select pxp.f_insert_tgui_rol ('CTABAN.2.1.1', 'OP - Cuenta Bancaria');
select pxp.f_insert_tgui_rol ('CTABAN.1', 'OP - Cuenta Bancaria');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_GATNREP_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_OBEPUO_IME', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_DEPFILEPUO_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_SOLDEVPAG_IME', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_IDSEXT_GET', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_COTOC_REP', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_CTD_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_COTREP_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_SOLREP_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_SOLD_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_SOLDETCOT_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PRE_VERPRE_IME', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_PROCPED_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_COT_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_COTPROC_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_COTRPC_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_PLT_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_CTABAN_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_PLAPAPA_INS', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_PLAPA_INS', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_PLAPA_MOD', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_PLAPA_ELI', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_PLAPA_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_TIPES_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_FUNTIPES_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_SINPRE_IME', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_SIGEPP_IME', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_ANTEPP_IME', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_PLAPAREP_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_PRO_SEL', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_DWF_MOD', 'VBDP.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_DWF_ELI', 'VBDP.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_DWF_SEL', 'VBDP.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_DOCWFAR_MOD', 'VBDP.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_DOCSOL_SEL', 'VBDP.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_DOCSOLAR_SEL', 'VBDP.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_DOCSOL_INS', 'VBDP.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_DOCSOL_MOD', 'VBDP.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_DOCSOL_ELI', 'VBDP.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_PROVEEV_SEL', 'VBDP.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_SERVIC_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SAL_ITEMNOTBASE_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_LUG_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_LUG_ARB_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_PROVEE_INS', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_PROVEE_MOD', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_PROVEE_ELI', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_PROVEE_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_PROVEEV_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SEG_PERSON_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SEG_PERSONMIN_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_INSTIT_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_INSTIT_INS', 'VBDP.2.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_INSTIT_MOD', 'VBDP.2.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_INSTIT_ELI', 'VBDP.2.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_INSTIT_SEL', 'VBDP.2.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SEG_PERSON_SEL', 'VBDP.2.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SEG_PERSONMIN_SEL', 'VBDP.2.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SEG_PERSON_INS', 'VBDP.2.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SEG_PERSON_MOD', 'VBDP.2.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SEG_PERSON_ELI', 'VBDP.2.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SEG_PERSONMIN_SEL', 'VBDP.2.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SEG_PERSON_INS', 'VBDP.2.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SEG_PERSON_MOD', 'VBDP.2.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SEG_PERSON_ELI', 'VBDP.2.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SEG_PERSONMIN_SEL', 'VBDP.2.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SEG_UPFOTOPER_MOD', 'VBDP.2.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SAL_ITEM_SEL', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SAL_ITEMNOTBASE_SEL', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'SAL_ITMALM_SEL', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_SERVIC_SEL', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_PRITSE_INS', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_PRITSE_MOD', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_PRITSE_ELI', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'PM_PRITSE_SEL', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'ADQ_DOCSOLAR_MOD', 'VBDP.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_PRO_MOD', 'VBDP.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_PRO_SEL', 'VBDP.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'WF_GATNREP_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_OBPG_INS', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_OBPG_MOD', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_OBPG_ELI', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_OBPG_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_OBPGSEL_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_PLAPAOB_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_OBTTCB_GET', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_FINREG_IME', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_ANTEOB_IME', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_IDSEXT_GET', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'ADQ_COTOC_REP', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'ADQ_CTD_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'ADQ_COTREP_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'ADQ_SOLREP_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'ADQ_SOLD_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'ADQ_SOLDETCOT_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'ADQ_PROCPED_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'ADQ_COT_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'ADQ_COTRPC_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_DEPUSUCOMB_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_MONEDA_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_PROVEEV_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'RH_FUNCIO_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'RH_FUNCIOCAR_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PRE_VERPRE_IME', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'ADQ_COTPROC_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_CCFILDEP_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_CONIG_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_CONIGPP_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'CONTA_CTA_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'CONTA_CTA_ARB_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PRE_PAR_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PRE_PAR_ARB_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'CONTA_AUXCTA_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_OBDET_INS', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_OBDET_MOD', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_OBDET_ELI', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_OBDET_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_CEC_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_CECCOM_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_CECCOMFU_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_OBPGSEL_SEL', 'OBPG.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_OBPG_SEL', 'OBPG.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_COMEJEPAG_SEL', 'OBPG.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_MONEDA_SEL', 'OBPG.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_PAFPP_IME', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_PLT_SEL', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_CTABAN_SEL', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_PLAPAPA_INS', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_PLAPA_INS', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_PLAPA_MOD', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_PLAPA_ELI', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_PLAPA_SEL', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'WF_TIPES_SEL', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'WF_FUNTIPES_SEL', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_SINPRE_IME', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_SIGEPP_IME', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_ANTEPP_IME', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_PLAPAREP_SEL', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_PRO_SEL', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'CONTA_GETDEC_IME', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PRE_VERPRE_SEL', 'OBPG.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_PRO_MOD', 'OBPG.3.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_PRO_SEL', 'OBPG.3.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'WF_DWF_MOD', 'OBPG.3.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'WF_DWF_ELI', 'OBPG.3.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'WF_DWF_SEL', 'OBPG.3.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'WF_DOCWFAR_MOD', 'OBPG.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'WF_DWF_MOD', 'OBPG.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'WF_DWF_ELI', 'OBPG.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'WF_DWF_SEL', 'OBPG.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PRE_VERPRE_SEL', 'OBPG.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_SERVIC_SEL', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SAL_ITEMNOTBASE_SEL', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_LUG_SEL', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_LUG_ARB_SEL', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_PROVEE_INS', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_PROVEE_MOD', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_PROVEE_ELI', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_PROVEE_SEL', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_PROVEEV_SEL', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSON_SEL', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSONMIN_SEL', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_INSTIT_SEL', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SAL_ITEM_SEL', 'OBPG.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SAL_ITEMNOTBASE_SEL', 'OBPG.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SAL_ITMALM_SEL', 'OBPG.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_SERVIC_SEL', 'OBPG.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_PRITSE_INS', 'OBPG.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_PRITSE_MOD', 'OBPG.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_PRITSE_ELI', 'OBPG.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_PRITSE_SEL', 'OBPG.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSON_INS', 'OBPG.6.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSON_MOD', 'OBPG.6.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSON_ELI', 'OBPG.6.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSONMIN_SEL', 'OBPG.6.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_UPFOTOPER_MOD', 'OBPG.6.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_INSTIT_INS', 'OBPG.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_INSTIT_MOD', 'OBPG.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_INSTIT_ELI', 'OBPG.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_INSTIT_SEL', 'OBPG.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSON_SEL', 'OBPG.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSONMIN_SEL', 'OBPG.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSON_INS', 'OBPG.6.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSON_MOD', 'OBPG.6.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSON_ELI', 'OBPG.6.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSONMIN_SEL', 'OBPG.6.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'RH_FUNCIO_INS', 'OBPG.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'RH_FUNCIO_MOD', 'OBPG.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'RH_FUNCIO_ELI', 'OBPG.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'RH_FUNCIO_SEL', 'OBPG.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'RH_FUNCIOCAR_SEL', 'OBPG.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSON_SEL', 'OBPG.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSONMIN_SEL', 'OBPG.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSON_INS', 'OBPG.7.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSON_MOD', 'OBPG.7.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSON_ELI', 'OBPG.7.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSONMIN_SEL', 'OBPG.7.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'OR_FUNCUE_INS', 'OBPG.7.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'OR_FUNCUE_MOD', 'OBPG.7.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'OR_FUNCUE_ELI', 'OBPG.7.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'OR_FUNCUE_SEL', 'OBPG.7.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_INSTIT_SEL', 'OBPG.7.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_INSTIT_INS', 'OBPG.7.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_INSTIT_MOD', 'OBPG.7.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_INSTIT_ELI', 'OBPG.7.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_INSTIT_SEL', 'OBPG.7.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSON_SEL', 'OBPG.7.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'SEG_PERSONMIN_SEL', 'OBPG.7.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_GATNREP_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_OBPG_INS', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_OBPG_MOD', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_OBPG_ELI', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_OBPG_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_OBPGSEL_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_PLAPAOB_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_OBTTCB_GET', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_FINREG_IME', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_ANTEOB_IME', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_IDSEXT_GET', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'ADQ_COTOC_REP', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'ADQ_CTD_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'ADQ_COTREP_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'ADQ_SOLREP_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'ADQ_SOLD_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'ADQ_SOLDETCOT_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'ADQ_PROCPED_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'ADQ_COT_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'ADQ_COTRPC_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_DEPUSUCOMB_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_MONEDA_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_PROVEEV_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'RH_FUNCIO_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'RH_FUNCIOCAR_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PRE_VERPRE_IME', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'ADQ_COTPROC_SEL', 'OBPG');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_PLT_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_CCFILDEP_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_CONIG_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_CONIGPP_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'CONTA_CTA_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'CONTA_CTA_ARB_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PRE_PAR_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PRE_PAR_ARB_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'CONTA_AUXCTA_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_OBDET_INS', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_OBDET_MOD', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_OBDET_ELI', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_OBDET_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_CEC_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_CECCOM_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_CECCOMFU_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_MONEDA_SEL', 'OBPG.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_OBPG_SEL', 'OBPG.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_OBPGSEL_SEL', 'OBPG.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_COMEJEPAG_SEL', 'OBPG.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_PAFPP_IME', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_PLT_SEL', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_CTABAN_SEL', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_PLAPAPA_INS', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_PLAPA_INS', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_PLAPA_MOD', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_PLAPA_ELI', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_PLAPA_SEL', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_TIPES_SEL', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_FUNTIPES_SEL', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_SINPRE_IME', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_SIGEPP_IME', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_ANTEPP_IME', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_PLAPAREP_SEL', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_PRO_SEL', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'CONTA_GETDEC_IME', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PRE_VERPRE_SEL', 'OBPG.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_PRO_MOD', 'OBPG.3.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'TES_PRO_SEL', 'OBPG.3.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DWF_MOD', 'OBPG.3.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DWF_ELI', 'OBPG.3.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DWF_SEL', 'OBPG.3.3');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_CABMOM_IME', 'OBPG.3.3');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_TIPES_SEL', 'OBPG.3.3.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_TIPPROC_SEL', 'OBPG.3.3.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_INS', 'OBPG.3.3.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_MOD', 'OBPG.3.3.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_ELI', 'OBPG.3.3.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_SEL', 'OBPG.3.3.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DOCWFAR_MOD', 'OBPG.3.3.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DWF_MOD', 'OBPG.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DWF_ELI', 'OBPG.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DWF_SEL', 'OBPG.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_CABMOM_IME', 'OBPG.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_TIPES_SEL', 'OBPG.4.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_TIPPROC_SEL', 'OBPG.4.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_INS', 'OBPG.4.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_MOD', 'OBPG.4.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_ELI', 'OBPG.4.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_SEL', 'OBPG.4.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DOCWFAR_MOD', 'OBPG.4.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PRE_VERPRE_SEL', 'OBPG.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_SERVIC_SEL', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SAL_ITEMNOTBASE_SEL', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_LUG_SEL', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_LUG_ARB_SEL', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_PROVEE_INS', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_PROVEE_MOD', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_PROVEE_ELI', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_PROVEE_SEL', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_PROVEEV_SEL', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSON_SEL', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSONMIN_SEL', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_INSTIT_SEL', 'OBPG.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SAL_ITEM_SEL', 'OBPG.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SAL_ITEMNOTBASE_SEL', 'OBPG.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SAL_ITMALM_SEL', 'OBPG.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_SERVIC_SEL', 'OBPG.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_PRITSE_INS', 'OBPG.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_PRITSE_MOD', 'OBPG.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_PRITSE_ELI', 'OBPG.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_PRITSE_SEL', 'OBPG.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSONMIN_SEL', 'OBPG.6.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSON_ELI', 'OBPG.6.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSON_MOD', 'OBPG.6.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSON_INS', 'OBPG.6.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_UPFOTOPER_MOD', 'OBPG.6.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSONMIN_SEL', 'OBPG.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSON_SEL', 'OBPG.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_INSTIT_INS', 'OBPG.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_INSTIT_MOD', 'OBPG.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_INSTIT_ELI', 'OBPG.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_INSTIT_SEL', 'OBPG.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSONMIN_SEL', 'OBPG.6.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSON_ELI', 'OBPG.6.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSON_MOD', 'OBPG.6.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSON_INS', 'OBPG.6.3.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_UPFOTOPER_MOD', 'OBPG.6.3.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSONMIN_SEL', 'OBPG.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSON_SEL', 'OBPG.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'RH_FUNCIOCAR_SEL', 'OBPG.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'RH_FUNCIO_SEL', 'OBPG.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'RH_FUNCIO_ELI', 'OBPG.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'RH_FUNCIO_MOD', 'OBPG.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'RH_FUNCIO_INS', 'OBPG.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSONMIN_SEL', 'OBPG.7.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSON_ELI', 'OBPG.7.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSON_MOD', 'OBPG.7.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSON_INS', 'OBPG.7.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_UPFOTOPER_MOD', 'OBPG.7.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_INSTIT_SEL', 'OBPG.7.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'OR_FUNCUE_SEL', 'OBPG.7.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'OR_FUNCUE_INS', 'OBPG.7.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'OR_FUNCUE_MOD', 'OBPG.7.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'OR_FUNCUE_ELI', 'OBPG.7.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSONMIN_SEL', 'OBPG.7.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSON_SEL', 'OBPG.7.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_INSTIT_INS', 'OBPG.7.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_INSTIT_MOD', 'OBPG.7.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_INSTIT_ELI', 'OBPG.7.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_INSTIT_SEL', 'OBPG.7.1.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSONMIN_SEL', 'OBPG.7.1.1.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSON_ELI', 'OBPG.7.1.1.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSON_MOD', 'OBPG.7.1.1.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSON_INS', 'OBPG.7.1.1.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_UPFOTOPER_MOD', 'OBPG.7.1.1.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_SEL', 'OBPG.4.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cierre de Proceso', 'TES_OBDET_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cierre de Proceso', 'TES_PRO_SEL', 'OBPG.3.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cierre de Proceso', 'WF_DES_SEL', 'OBPG.3.3.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cierre de Proceso', 'TES_PLAPA_SEL', 'OBPG.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cierre de Proceso', 'WF_DES_SEL', 'OBPG.4.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cierre de Proceso', 'WF_DOCWFAR_MOD', 'OBPG.4.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cierre de Proceso', 'WF_GATNREP_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cierre de Proceso', 'TES_OBPG_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cierre de Proceso', 'TES_FINREG_IME', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'WF_DES_SEL', 'OBPG.3.3.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'WF_DES_SEL', 'OBPG.4.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_TIPES_SEL', 'VBDP.3.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_TIPPROC_SEL', 'VBDP.3.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_DES_INS', 'VBDP.3.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_DES_MOD', 'VBDP.3.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_DES_ELI', 'VBDP.3.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_DES_SEL', 'VBDP.3.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cierre de Proceso', 'WF_DWF_MOD', 'OBPG.8.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'WF_DES_SEL', 'OBPG.8.3.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cierre de Proceso', 'TES_IDSEXT_GET', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cierre de Proceso', 'PM_MONEDA_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cierre de Proceso', 'TES_OBPGSEL_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cierre de Proceso', 'TES_COMEJEPAG_SEL', 'OBPG.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cuenta Bancaria', 'PM_MONEDA_SEL', 'CTABAN');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cuenta Bancaria', 'PM_INSTIT_SEL', 'CTABAN');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cuenta Bancaria', 'TES_CTABAN_INS', 'CTABAN');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cuenta Bancaria', 'TES_CTABAN_MOD', 'CTABAN');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cuenta Bancaria', 'TES_CTABAN_ELI', 'CTABAN');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cuenta Bancaria', 'TES_CTABAN_SEL', 'CTABAN');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cuenta Bancaria', 'SEG_PERSONMIN_SEL', 'CTABAN.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cuenta Bancaria', 'SEG_PERSON_SEL', 'CTABAN.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cuenta Bancaria', 'PM_INSTIT_INS', 'CTABAN.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cuenta Bancaria', 'PM_INSTIT_MOD', 'CTABAN.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cuenta Bancaria', 'PM_INSTIT_ELI', 'CTABAN.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cuenta Bancaria', 'PM_INSTIT_SEL', 'CTABAN.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cuenta Bancaria', 'SEG_PERSONMIN_SEL', 'CTABAN.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cuenta Bancaria', 'SEG_PERSON_ELI', 'CTABAN.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cuenta Bancaria', 'SEG_PERSON_MOD', 'CTABAN.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cuenta Bancaria', 'SEG_PERSON_INS', 'CTABAN.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cuenta Bancaria', 'SEG_UPFOTOPER_MOD', 'CTABAN.2.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cuenta Bancaria', 'TES_CHQ_SEL', 'CTABAN.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cuenta Bancaria', 'TES_CHQ_INS', 'CTABAN.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cuenta Bancaria', 'TES_CHQ_MOD', 'CTABAN.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Cuenta Bancaria', 'TES_CHQ_ELI', 'CTABAN.1');

/***********************************F-DEP-JRR-TES-0-24/04/2014*****************************************/




/***********************************I-DEP-RAC-TES-0-19/05/2014*****************************************/

CREATE TRIGGER trig_actualiza_informacion_estado_pp
  AFTER INSERT OR UPDATE OF estado, nro_cuota 
  ON tes.tplan_pago FOR EACH ROW 
  EXECUTE PROCEDURE tes.f_trig_actualiza_informacion_estado_pp();

/***********************************F-DEP-RAC-TES-0-19/05/2014*****************************************/



/***********************************I-DEP-RAC-TES-0-11/06/2014*****************************************/

--------------- SQL ---------------
--------------- SQL ---------------

--------------- SQL ---------------

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
    obs_pp)
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
         ((COALESCE(op.numero, '' ::character varying) ::text || ' ' ::text) ||
          COALESCE(pp.obs_monto_no_pagado, '' ::text)) ::character varying AS
           obs_pp
  FROM tes.tplan_pago pp
       JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago =
        op.id_obligacion_pago
       JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor;


select pxp.f_insert_testructura_gui ('SOLPD', 'TES');
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
select pxp.f_insert_tprocedimiento_gui ('TES_OBPGSOL_SEL', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('MIG_CBANESIS_SEL', 'OBPG.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'OBPG.8.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'OBPG.8.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_VERSIGPRO_IME', 'OBPG.8.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CHKSTA_IME', 'OBPG.8.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'OBPG.8.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'OBPG.8.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DEPTIPES_SEL', 'OBPG.8.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPGSOL_SEL', 'OBPG.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('MIG_CBANESIS_SEL', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'OBPG.3.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'OBPG.3.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_VERSIGPRO_IME', 'OBPG.3.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CHKSTA_IME', 'OBPG.3.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'OBPG.3.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'OBPG.3.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DEPTIPES_SEL', 'OBPG.3.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('MIG_LBAN_INS', 'CTABANE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('MIG_LBAN_MOD', 'CTABANE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('MIG_LBAN_ELI', 'CTABANE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('MIG_LBAN_SEL', 'CTABANE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('MIG_CBANESIS_SEL', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'VBDP.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'VBDP.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_VERSIGPRO_IME', 'VBDP.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CHKSTA_IME', 'VBDP.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'VBDP.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'VBDP.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DEPTIPES_SEL', 'VBDP.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_GATNREP_SEL', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PLT_SEL', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_INS', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_MOD', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_ELI', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_SEL', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPGSOL_SEL', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPGSEL_SEL', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAOB_SEL', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_OBTTCB_GET', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_FINREG_IME', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_ANTEOB_IME', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_IDSEXT_GET', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTOC_REP', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_SEL', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTREP_SEL', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_IME', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROCPED_SEL', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_SEL', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTPROC_SEL', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTRPC_SEL', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'SOLPD.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIG_SEL', 'SOLPD.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPP_SEL', 'SOLPD.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_SEL', 'SOLPD.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_ARB_SEL', 'SOLPD.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_SEL', 'SOLPD.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_ARB_SEL', 'SOLPD.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_AUXCTA_SEL', 'SOLPD.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_INS', 'SOLPD.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_MOD', 'SOLPD.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_ELI', 'SOLPD.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_SEL', 'SOLPD.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'SOLPD.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'SOLPD.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'SOLPD.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAREP_SEL', 'SOLPD.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'SOLPD.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PAFPP_IME', 'SOLPD.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_GETDEC_IME', 'SOLPD.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PLT_SEL', 'SOLPD.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_SEL', 'SOLPD.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('MIG_CBANESIS_SEL', 'SOLPD.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAPA_INS', 'SOLPD.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_INS', 'SOLPD.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_MOD', 'SOLPD.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_ELI', 'SOLPD.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_SEL', 'SOLPD.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SINPRE_IME', 'SOLPD.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_ANTEPP_IME', 'SOLPD.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SIGEPP_IME', 'SOLPD.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_SEL', 'SOLPD.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_MOD', 'SOLPD.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'SOLPD.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'SOLPD.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'SOLPD.2.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_VERSIGPRO_IME', 'SOLPD.2.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CHKSTA_IME', 'SOLPD.2.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'SOLPD.2.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'SOLPD.2.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DEPTIPES_SEL', 'SOLPD.2.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'SOLPD.2.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'SOLPD.2.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'SOLPD.2.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CABMOM_IME', 'SOLPD.2.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'SOLPD.2.5.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPPROC_SEL', 'SOLPD.2.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'SOLPD.2.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_INS', 'SOLPD.2.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_MOD', 'SOLPD.2.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_ELI', 'SOLPD.2.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_SEL', 'SOLPD.2.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPGSEL_SEL', 'SOLPD.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_SEL', 'SOLPD.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPGSOL_SEL', 'SOLPD.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_COMEJEPAG_SEL', 'SOLPD.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'SOLPD.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PAFPP_IME', 'SOLPD.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_GETDEC_IME', 'SOLPD.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PLT_SEL', 'SOLPD.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_SEL', 'SOLPD.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('MIG_CBANESIS_SEL', 'SOLPD.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAPA_INS', 'SOLPD.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_INS', 'SOLPD.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_MOD', 'SOLPD.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_ELI', 'SOLPD.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_SEL', 'SOLPD.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SINPRE_IME', 'SOLPD.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_ANTEPP_IME', 'SOLPD.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SIGEPP_IME', 'SOLPD.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAREP_SEL', 'SOLPD.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'SOLPD.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_SEL', 'SOLPD.4.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_MOD', 'SOLPD.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'SOLPD.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'SOLPD.4.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'SOLPD.4.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_VERSIGPRO_IME', 'SOLPD.4.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CHKSTA_IME', 'SOLPD.4.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'SOLPD.4.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'SOLPD.4.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DEPTIPES_SEL', 'SOLPD.4.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'SOLPD.4.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'SOLPD.4.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'SOLPD.4.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CABMOM_IME', 'SOLPD.4.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'SOLPD.4.5.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPPROC_SEL', 'SOLPD.4.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'SOLPD.4.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_INS', 'SOLPD.4.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_MOD', 'SOLPD.4.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_ELI', 'SOLPD.4.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_SEL', 'SOLPD.4.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'SOLPD.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'SOLPD.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'SOLPD.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CABMOM_IME', 'SOLPD.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'SOLPD.5.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPPROC_SEL', 'SOLPD.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'SOLPD.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_INS', 'SOLPD.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_MOD', 'SOLPD.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_ELI', 'SOLPD.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_SEL', 'SOLPD.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_SEL', 'SOLPD.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'SOLPD.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'SOLPD.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'SOLPD.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'SOLPD.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_INS', 'SOLPD.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_MOD', 'SOLPD.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_ELI', 'SOLPD.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_SEL', 'SOLPD.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'SOLPD.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'SOLPD.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'SOLPD.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'SOLPD.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEM_SEL', 'SOLPD.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'SOLPD.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMALM_SEL', 'SOLPD.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'SOLPD.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_INS', 'SOLPD.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_MOD', 'SOLPD.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_ELI', 'SOLPD.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_SEL', 'SOLPD.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'SOLPD.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'SOLPD.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'SOLPD.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'SOLPD.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'SOLPD.7.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'SOLPD.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'SOLPD.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'SOLPD.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'SOLPD.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'SOLPD.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'SOLPD.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'SOLPD.7.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'SOLPD.7.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'SOLPD.7.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'SOLPD.7.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'SOLPD.7.3.1.1', 'no');
select pxp.f_insert_tgui_rol ('SOLPD', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('TES', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SISTEMA', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.7', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.7.3', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.7.3.1', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.7.3.1.1', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.7.2', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.7.2.1', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.7.1', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.6', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.5', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.5.2', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.5.1', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.4', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.4.5', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.4.5.2', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.4.5.1', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.4.4', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.4.3', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.4.2', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.4.1', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.3', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.2', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.2.5', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.2.5.2', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.2.5.1', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.2.4', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.2.3', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.2.2', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.2.1', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('SOLPD.1', 'OP - Solicitudes de Pago Directas');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_DWF_MOD', 'VBDP.3');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_DWF_ELI', 'VBDP.3');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_PLT_SEL', 'OBPG');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DWF_MOD', 'OBPG.3.3');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_CABMOM_IME', 'OBPG.3.3');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_TIPES_SEL', 'OBPG.3.3.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_TIPPROC_SEL', 'OBPG.3.3.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_INS', 'OBPG.3.3.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_MOD', 'OBPG.3.3.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_ELI', 'OBPG.3.3.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_SEL', 'OBPG.3.3.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DWF_MOD', 'OBPG.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_CABMOM_IME', 'OBPG.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_TIPES_SEL', 'OBPG.4.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_TIPPROC_SEL', 'OBPG.4.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_INS', 'OBPG.4.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_MOD', 'OBPG.4.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_ELI', 'OBPG.4.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_SEL', 'OBPG.4.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DOCWFAR_MOD', 'OBPG.4.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_UPFOTOPER_MOD', 'OBPG.6.3.1.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_UPFOTOPER_MOD', 'OBPG.7.2.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSONMIN_SEL', 'OBPG.7.1.1.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSON_ELI', 'OBPG.7.1.1.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSON_MOD', 'OBPG.7.1.1.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSON_INS', 'OBPG.7.1.1.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_UPFOTOPER_MOD', 'OBPG.7.1.1.1.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_SEL', 'OBPG.4.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_DES_INS', 'VBDP.3.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_DES_MOD', 'VBDP.3.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_DES_ELI', 'VBDP.3.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_SEL', 'OBPG.4.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_GATNREP_SEL', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_PLT_SEL', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_OBPG_INS', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_OBPG_MOD', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_OBPG_ELI', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_OBPG_SEL', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_OBPGSOL_SEL', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_OBPGSEL_SEL', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_PLAPAOB_SEL', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_OBTTCB_GET', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_FINREG_IME', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_ANTEOB_IME', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_IDSEXT_GET', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'ADQ_COTOC_REP', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'ADQ_CTD_SEL', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'ADQ_COTREP_SEL', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'ADQ_SOLREP_SEL', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'ADQ_SOLD_SEL', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'ADQ_SOLDETCOT_SEL', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PRE_VERPRE_IME', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'ADQ_PROCPED_SEL', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'ADQ_COT_SEL', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'ADQ_COTPROC_SEL', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'ADQ_COTRPC_SEL', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_DEPUSUCOMB_SEL', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'RH_FUNCIOCAR_SEL', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_MONEDA_SEL', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_PROVEEV_SEL', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_SERVIC_SEL', 'SOLPD.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'SAL_ITEMNOTBASE_SEL', 'SOLPD.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_LUG_SEL', 'SOLPD.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_LUG_ARB_SEL', 'SOLPD.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_PROVEE_INS', 'SOLPD.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_PROVEE_MOD', 'SOLPD.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_PROVEE_ELI', 'SOLPD.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_PROVEE_SEL', 'SOLPD.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_PROVEEV_SEL', 'SOLPD.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'SEG_PERSON_SEL', 'SOLPD.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'SEG_PERSONMIN_SEL', 'SOLPD.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_INSTIT_SEL', 'SOLPD.7');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_INSTIT_INS', 'SOLPD.7.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_INSTIT_MOD', 'SOLPD.7.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_INSTIT_ELI', 'SOLPD.7.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_INSTIT_SEL', 'SOLPD.7.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'SEG_PERSON_SEL', 'SOLPD.7.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'SEG_PERSONMIN_SEL', 'SOLPD.7.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'SEG_PERSON_INS', 'SOLPD.7.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'SEG_PERSON_MOD', 'SOLPD.7.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'SEG_PERSON_ELI', 'SOLPD.7.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'SEG_PERSONMIN_SEL', 'SOLPD.7.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'SEG_UPFOTOPER_MOD', 'SOLPD.7.3.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'SEG_PERSON_INS', 'SOLPD.7.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'SEG_PERSON_MOD', 'SOLPD.7.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'SEG_PERSON_ELI', 'SOLPD.7.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'SEG_PERSONMIN_SEL', 'SOLPD.7.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'SEG_UPFOTOPER_MOD', 'SOLPD.7.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'SAL_ITEM_SEL', 'SOLPD.7.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'SAL_ITEMNOTBASE_SEL', 'SOLPD.7.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'SAL_ITMALM_SEL', 'SOLPD.7.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_SERVIC_SEL', 'SOLPD.7.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_PRITSE_INS', 'SOLPD.7.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_PRITSE_MOD', 'SOLPD.7.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_PRITSE_ELI', 'SOLPD.7.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_PRITSE_SEL', 'SOLPD.7.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PRE_VERPRE_SEL', 'SOLPD.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DWF_MOD', 'SOLPD.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DWF_ELI', 'SOLPD.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DWF_SEL', 'SOLPD.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_CABMOM_IME', 'SOLPD.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_TIPPROC_SEL', 'SOLPD.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_TIPES_SEL', 'SOLPD.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DES_INS', 'SOLPD.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DES_MOD', 'SOLPD.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DES_ELI', 'SOLPD.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DES_SEL', 'SOLPD.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DOCWFAR_MOD', 'SOLPD.5.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_PAFPP_IME', 'SOLPD.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'CONTA_GETDEC_IME', 'SOLPD.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_PLT_SEL', 'SOLPD.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_CTABAN_SEL', 'SOLPD.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'MIG_CBANESIS_SEL', 'SOLPD.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_PLAPAPA_INS', 'SOLPD.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_PLAPA_INS', 'SOLPD.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_PLAPA_MOD', 'SOLPD.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_PLAPA_ELI', 'SOLPD.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_PLAPA_SEL', 'SOLPD.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_SINPRE_IME', 'SOLPD.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_ANTEPP_IME', 'SOLPD.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_SIGEPP_IME', 'SOLPD.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_PLAPAREP_SEL', 'SOLPD.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_PRO_SEL', 'SOLPD.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DWF_MOD', 'SOLPD.4.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DWF_ELI', 'SOLPD.4.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DWF_SEL', 'SOLPD.4.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_CABMOM_IME', 'SOLPD.4.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_TIPPROC_SEL', 'SOLPD.4.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_TIPES_SEL', 'SOLPD.4.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DES_INS', 'SOLPD.4.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DES_MOD', 'SOLPD.4.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DES_ELI', 'SOLPD.4.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DES_SEL', 'SOLPD.4.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DOCWFAR_MOD', 'SOLPD.4.5.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DOCWFAR_MOD', 'SOLPD.4.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_VERSIGPRO_IME', 'SOLPD.4.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_CHKSTA_IME', 'SOLPD.4.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_TIPES_SEL', 'SOLPD.4.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_FUNTIPES_SEL', 'SOLPD.4.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DEPTIPES_SEL', 'SOLPD.4.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DOCWFAR_MOD', 'SOLPD.4.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_PRO_MOD', 'SOLPD.4.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_PRO_SEL', 'SOLPD.4.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PRE_VERPRE_SEL', 'SOLPD.4.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_OBPGSEL_SEL', 'SOLPD.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_OBPG_SEL', 'SOLPD.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_OBPGSOL_SEL', 'SOLPD.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_COMEJEPAG_SEL', 'SOLPD.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_MONEDA_SEL', 'SOLPD.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_PLAPAREP_SEL', 'SOLPD.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_PRO_SEL', 'SOLPD.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_PAFPP_IME', 'SOLPD.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'CONTA_GETDEC_IME', 'SOLPD.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_PLT_SEL', 'SOLPD.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_CTABAN_SEL', 'SOLPD.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'MIG_CBANESIS_SEL', 'SOLPD.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_PLAPAPA_INS', 'SOLPD.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_PLAPA_INS', 'SOLPD.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_PLAPA_MOD', 'SOLPD.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_PLAPA_ELI', 'SOLPD.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_PLAPA_SEL', 'SOLPD.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_SINPRE_IME', 'SOLPD.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_ANTEPP_IME', 'SOLPD.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_SIGEPP_IME', 'SOLPD.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DWF_MOD', 'SOLPD.2.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DWF_ELI', 'SOLPD.2.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DWF_SEL', 'SOLPD.2.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_CABMOM_IME', 'SOLPD.2.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_TIPPROC_SEL', 'SOLPD.2.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_TIPES_SEL', 'SOLPD.2.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DES_INS', 'SOLPD.2.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DES_MOD', 'SOLPD.2.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DES_ELI', 'SOLPD.2.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DES_SEL', 'SOLPD.2.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DOCWFAR_MOD', 'SOLPD.2.5.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DOCWFAR_MOD', 'SOLPD.2.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_VERSIGPRO_IME', 'SOLPD.2.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_CHKSTA_IME', 'SOLPD.2.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_TIPES_SEL', 'SOLPD.2.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_FUNTIPES_SEL', 'SOLPD.2.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DEPTIPES_SEL', 'SOLPD.2.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'WF_DOCWFAR_MOD', 'SOLPD.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_PRO_MOD', 'SOLPD.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_PRO_SEL', 'SOLPD.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PRE_VERPRE_SEL', 'SOLPD.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_CCFILDEP_SEL', 'SOLPD.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_CONIG_SEL', 'SOLPD.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_CONIGPP_SEL', 'SOLPD.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'CONTA_CTA_SEL', 'SOLPD.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'CONTA_CTA_ARB_SEL', 'SOLPD.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PRE_PAR_SEL', 'SOLPD.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PRE_PAR_ARB_SEL', 'SOLPD.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'CONTA_AUXCTA_SEL', 'SOLPD.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_OBDET_INS', 'SOLPD.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_OBDET_MOD', 'SOLPD.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_OBDET_ELI', 'SOLPD.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_OBDET_SEL', 'SOLPD.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_CEC_SEL', 'SOLPD.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_CECCOM_SEL', 'SOLPD.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_CECCOMFU_SEL', 'SOLPD.1');


/***********************************F-DEP-RAC-TES-0-11/06/2014*****************************************/


/***********************************I-DEP-RAC-TES-0-16/07/2014*****************************************/

--------------- SQL ---------------

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
    obs_pp)
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
         ((COALESCE(op.numero, '' ::character varying) ::text || ' ' ::text) ||
          COALESCE(pp.obs_monto_no_pagado, '' ::text)) ::character varying AS  obs_pp,
         pp.descuento_anticipo,
         pp.descuento_inter_serv 
  FROM tes.tplan_pago pp
       JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago =
        op.id_obligacion_pago
       JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor;

/***********************************F-DEP-RAC-TES-0-16/07/2014*****************************************/



/***********************************I-DEP-RAC-TES-0-01/08/2014*****************************************/

--------------- SQL ---------------

 --------------- SQL ---------------

 -- object recreation
DROP VIEW tes.vcomp_devtesprov_plan_pago;

CREATE VIEW tes.vcomp_devtesprov_plan_pago
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
         ((COALESCE(op.numero, '' ::character varying) ::text || ' ' ::text) ||
          COALESCE(pp.obs_monto_no_pagado, '' ::text)) ::character varying AS
           obs_pp,
         pp.descuento_anticipo,
         pp.descuento_inter_serv,
         op.tipo_obligacion,
         op.id_categoria_compra,
         COALESCE(cac.codigo, '' ::character varying) AS codigo_categoria,
         COALESCE(cac.nombre, '' ::character varying) AS nombre_categoria,
         pp.id_proceso_wf
  FROM tes.tplan_pago pp
       JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago =
        op.id_obligacion_pago
       JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor
       LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
        op.id_categoria_compra;

ALTER TABLE tes.vcomp_devtesprov_plan_pago
  OWNER TO postgres;
  
/***********************************F-DEP-RAC-TES-0-01/08/2014*****************************************/


/***********************************I-DEP-RAC-TES-0-19/08/2014*****************************************/

DROP VIEW tes.vcomp_devtesprov_plan_pago_2;

--------------- SQL ---------------
--------------- SQL ---------------

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
    total_pago)
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
         ((COALESCE(op.numero, '' ::character varying) ::text || ' ' ::text) ||
          COALESCE(pp.obs_monto_no_pagado, '' ::text)) ::character varying AS
           obs_pp,
         pp.descuento_anticipo,
         pp.descuento_inter_serv,
         op.tipo_obligacion,
         op.id_categoria_compra,
         COALESCE(cac.codigo, '' ::character varying) AS codigo_categoria,
         COALESCE(cac.nombre, '' ::character varying) AS nombre_categoria,
         pp.id_proceso_wf,
         ('<table>' ::text || pxp.html_rows((((('<td>' ::text ||
          ci.desc_ingas::text) || '<br/>' ::text) || od.descripcion) || '</td>'
           ::text) ::character varying) ::text) || '</table>' ::text AS detalle,
         mon.codigo AS codigo_moneda,
         pp.nro_cuota,
         pp.tipo_pago,
         op.tipo_solicitud,
         op.tipo_concepto_solicitud,
         sum(od.monto_pago_mb) AS total_monto_op_mb,
         sum(od.monto_pago_mo) AS total_monto_op_mo,
         op.total_pago
  FROM tes.tplan_pago pp
       JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago =
        op.id_obligacion_pago
       JOIN param.tmoneda mon ON mon.id_moneda = op.id_moneda
       JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor
       LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
        op.id_categoria_compra
       JOIN tes.tobligacion_det od ON od.id_obligacion_pago =
        op.id_obligacion_pago
       JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas =
        od.id_concepto_ingas
  GROUP BY pp.id_plan_pago,
           op.id_proveedor,
           p.desc_proveedor,
           op.id_moneda,
           op.id_depto_conta,
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
           op.tipo_concepto_solicitud;


/***********************************F-DEP-RAC-TES-0-19/08/2014*****************************************/



/***********************************I-DEP-RAC-TES-0-01/09/2014*****************************************/

--------------- SQL ---------------

ALTER TABLE tes.tobligacion_det
  ADD CONSTRAINT fk_tobligacion_det__id_orden_trabajo FOREIGN KEY (id_orden_trabajo)
    REFERENCES conta.torden_trabajo(id_orden_trabajo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/***********************************F-DEP-RAC-TES-0-01/09/2014*****************************************/


/***********************************I-DEP-RAC-TES-0-04/09/2014*****************************************/


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
         
/***********************************F-DEP-RAC-TES-0-04/09/2014*****************************************/


/***********************************I-DEP-JRR-TES-1-10/09/2014*****************************************/
--RAC, le pongo left join al vbfuncionario_Cargo, ...por que no siempre se tiene este dato

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
    desc_usuario)
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
         ((COALESCE(op.numero, '' ::character varying) ::text || ' ' ::text) ||
          COALESCE(pp.obs_monto_no_pagado, '' ::text)) ::character varying AS
           obs_pp,
         pp.descuento_anticipo,
         pp.descuento_inter_serv,
         op.tipo_obligacion,
         op.id_categoria_compra,
         COALESCE(cac.codigo, '' ::character varying) AS codigo_categoria,
         COALESCE(cac.nombre, '' ::character varying) AS nombre_categoria,
         pp.id_proceso_wf,
         ('<table>' ::text || pxp.html_rows((((('<td>' ::text ||
          ci.desc_ingas::text) || '<br/>' ::text) || od.descripcion) || '</td>'
           ::text) ::character varying) ::text) || '</table>' ::text AS detalle,
         mon.codigo AS codigo_moneda,
         pp.nro_cuota,
         pp.tipo_pago,
         op.tipo_solicitud,
         op.tipo_concepto_solicitud,
         sum(od.monto_pago_mb) AS total_monto_op_mb,
         sum(od.monto_pago_mo) AS total_monto_op_mo,
         op.total_pago,
         pp.fecha_tentativa,
         fun.desc_funcionario1 AS desc_funcionario,
         fun.email_empresa,
         usu.desc_persona AS desc_usuario
  FROM tes.tplan_pago pp
       JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago =
        op.id_obligacion_pago
       JOIN param.tmoneda mon ON mon.id_moneda = op.id_moneda
       JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor
       LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
        op.id_categoria_compra
       JOIN tes.tobligacion_det od ON od.id_obligacion_pago =
        op.id_obligacion_pago
       JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas =
        od.id_concepto_ingas
       JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario =
        op.id_funcionario AND fun.estado_reg_asi::text = 'activo' ::text
       JOIN segu.vusuario usu ON usu.id_usuario = op.id_usuario_reg
  GROUP BY pp.id_plan_pago,
           op.id_proveedor,
           p.desc_proveedor,
           op.id_moneda,
           op.id_depto_conta,
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
           usu.desc_persona;


/***********************************F-DEP-JRR-TES-1-10/09/2014*****************************************/



/***********************************I-DEP-RAC-TES-0-12/09/2014*****************************************/

DROP VIEW tes.vcomp_devtesprov_plan_pago_2;

CREATE VIEW tes.vcomp_devtesprov_plan_pago_2 (
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
    id_funcionario_gerente)
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
        COALESCE(pp.obs_monto_no_pagado, ''::text))::character varying AS obs_pp,
    pp.descuento_anticipo,
    pp.descuento_inter_serv,
    op.tipo_obligacion,
    op.id_categoria_compra,
    COALESCE(cac.codigo, ''::character varying) AS codigo_categoria,
    COALESCE(cac.nombre, ''::character varying) AS nombre_categoria,
    pp.id_proceso_wf,
    ('<table>'::text || pxp.html_rows((((('<td>'::text || ci.desc_ingas::text)
        || '<br/>'::text) || od.descripcion) || '</td>'::text)::character varying)::text) || '</table>'::text AS detalle,
    mon.codigo AS codigo_moneda,
    pp.nro_cuota,
    pp.tipo_pago,
    op.tipo_solicitud,
    op.tipo_concepto_solicitud,
    sum(od.monto_pago_mb) AS total_monto_op_mb,
    sum(od.monto_pago_mo) AS total_monto_op_mo,
    op.total_pago,
    pp.fecha_tentativa,
    fun.desc_funcionario1 AS desc_funcionario,
    fun.email_empresa,
    usu.desc_persona AS desc_usuario,
    COALESCE(op.id_funcionario_gerente, 0) AS id_funcionario_gerente
FROM tes.tplan_pago pp
   JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago = op.id_obligacion_pago
   JOIN param.tmoneda mon ON mon.id_moneda = op.id_moneda
   JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor
   LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
       op.id_categoria_compra
   JOIN tes.tobligacion_det od ON od.id_obligacion_pago = op.id_obligacion_pago
   JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas = od.id_concepto_ingas
   JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario = op.id_funcionario
       AND fun.estado_reg_asi::text = 'activo'::text
   JOIN segu.vusuario usu ON usu.id_usuario = op.id_usuario_reg
GROUP BY pp.id_plan_pago, op.id_proveedor, p.desc_proveedor, op.id_moneda,
    op.id_depto_conta, op.numero, pp.estado, pp.monto_ejecutar_total_mb, pp.monto_ejecutar_total_mo, pp.monto, pp.monto_mb, pp.monto_retgar_mb, pp.monto_retgar_mo, pp.monto_no_pagado, pp.monto_no_pagado_mb, pp.otros_descuentos, pp.otros_descuentos_mb, pp.id_plantilla, pp.id_cuenta_bancaria, pp.id_cuenta_bancaria_mov, pp.nro_cheque, pp.nro_cuenta_bancaria, op.num_tramite, pp.tipo, op.id_gestion, pp.id_int_comprobante, pp.liquido_pagable, pp.liquido_pagable_mb, pp.nombre_pago, pp.porc_monto_excento_var, pp.obs_monto_no_pagado, pp.descuento_anticipo, pp.descuento_inter_serv, op.tipo_obligacion, op.id_categoria_compra, cac.codigo, cac.nombre, pp.id_proceso_wf, mon.codigo, pp.nro_cuota, pp.tipo_pago, op.total_pago, op.tipo_solicitud, op.tipo_concepto_solicitud, pp.fecha_tentativa, fun.desc_funcionario1, fun.email_empresa, usu.desc_persona, op.id_funcionario_gerente;


/***********************************F-DEP-RAC-TES-0-12/09/2014*****************************************/




/***********************************I-DEP-RAC-TES-0-16/09/2014*****************************************/



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
    id_funcionario_gerente)
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
         ('<table>'::text || pxp.html_rows((((('<td>'::text || ci.desc_ingas::
           text) || '<br/>'::text) || od.descripcion) || '</td>'::text)::
           character varying)::text) || '</table>'::text AS detalle,
         mon.codigo AS codigo_moneda,
         pp.nro_cuota,
         pp.tipo_pago,
         op.tipo_solicitud,
         op.tipo_concepto_solicitud,
         sum(od.monto_pago_mb) AS total_monto_op_mb,
         sum(od.monto_pago_mo) AS total_monto_op_mo,
         op.total_pago,
         pp.fecha_tentativa,
         fun.desc_funcionario1 AS desc_funcionario,
         fun.email_empresa,
         usu.desc_persona AS desc_usuario,
         COALESCE(op.id_funcionario_gerente, 0) AS id_funcionario_gerente
  FROM tes.tplan_pago pp
       JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago =
         op.id_obligacion_pago
       JOIN param.tmoneda mon ON mon.id_moneda = op.id_moneda
       JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor
       LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
         op.id_categoria_compra
       JOIN tes.tobligacion_det od ON od.id_obligacion_pago =
         op.id_obligacion_pago
       JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas =
         od.id_concepto_ingas
       LEFT JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario =
         op.id_funcionario AND fun.estado_reg_asi::text = 'activo'::text
       JOIN segu.vusuario usu ON usu.id_usuario = op.id_usuario_reg
  GROUP BY pp.id_plan_pago,
           op.id_proveedor,
           p.desc_proveedor,
           op.id_moneda,
           op.id_depto_conta,
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
           op.id_funcionario_gerente;


/***********************************F-DEP-RAC-TES-0-16/09/2014*****************************************/


/***********************************I-DEP-RAC-TES-0-25/09/2014*****************************************/




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
    id_funcionario_gerente)
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
         ('<table>'::text || pxp.html_rows((((('<td>'::text || ci.desc_ingas::
           text) || '<br/>'::text) || od.descripcion) || '</td>'::text)::
           character varying)::text) || '</table>'::text AS detalle,
         mon.codigo AS codigo_moneda,
         pp.nro_cuota,
         pp.tipo_pago,
         op.tipo_solicitud,
         op.tipo_concepto_solicitud,
         sum(od.monto_pago_mb) AS total_monto_op_mb,
         sum(od.monto_pago_mo) AS total_monto_op_mo,
         op.total_pago,
         pp.fecha_tentativa,
         fun.desc_funcionario1 AS desc_funcionario,
         fun.email_empresa,
         usu.desc_persona AS desc_usuario,
         COALESCE(op.id_funcionario_gerente, 0) AS id_funcionario_gerente
  FROM tes.tplan_pago pp
       JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago =
         op.id_obligacion_pago
       JOIN param.tmoneda mon ON mon.id_moneda = op.id_moneda
       JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor
       LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
         op.id_categoria_compra
       JOIN tes.tobligacion_det od ON od.id_obligacion_pago =
         op.id_obligacion_pago
       JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas =
         od.id_concepto_ingas
       JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario =
         op.id_funcionario AND fun.estado_reg_asi::text = 'activo'::text
       JOIN segu.vusuario usu ON usu.id_usuario = op.id_usuario_reg
  GROUP BY pp.id_plan_pago,
           op.id_proveedor,
           p.desc_proveedor,
           op.id_moneda,
           op.id_depto_conta,
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
           op.id_funcionario_gerente;



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
    id_proceso_wf)
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
         pp.id_proceso_wf
  FROM tes.tplan_pago pp
       JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago =
         op.id_obligacion_pago
       JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor
       LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
         op.id_categoria_compra;


/***********************************F-DEP-RAC-TES-0-25/09/2014*****************************************/


/***********************************I-DEP-RAC-TES-0-02/10/2014*****************************************/

--------------- SQL ---------------

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
    id_proceso_wf)
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
         pp.forma_pago
  FROM tes.tplan_pago pp
       JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago =
         op.id_obligacion_pago
       JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor
       LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
         op.id_categoria_compra;


/***********************************F-DEP-RAC-TES-0-02/10/2014*****************************************/



/***********************************I-DEP-RAC-TES-0-03/10/2014*****************************************/

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
    id_funcionario_gerente)
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
         ('<table>'::text || pxp.html_rows((((('<td>'::text || ci.desc_ingas::
           text) || '<br/>'::text) || od.descripcion) || '</td>'::text)::
           character varying)::text) || '</table>'::text AS detalle,
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
         COALESCE(op.id_funcionario_gerente, 0) AS id_funcionario_gerente
  FROM tes.tplan_pago pp
       JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago =
         op.id_obligacion_pago
       JOIN param.tmoneda mon ON mon.id_moneda = op.id_moneda
       JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor
       LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
         op.id_categoria_compra
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
           op.id_depto_conta,
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
           op.id_funcionario_gerente;
           
/**********************************F-DEP-RAC-TES-0-03/10/2014*****************************************/


/**********************************I-DEP-RAC-TES-0-10/10/2014*****************************************/

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
    list,
    list_unique,
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
    estado_reg)
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
         pxp.list(od.id_obligacion_det::text) AS list,
         pxp.list_unique(cig.pago_automatico::text) AS list_unique,
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
         pp.estado_reg
  FROM tes.tplan_pago pp
       JOIN tes.tobligacion_pago op ON op.id_obligacion_pago =
         pp.id_obligacion_pago
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
           op.tipo_anticipo;
           
/**********************************F-DEP-RAC-TES-0-10/10/2014*****************************************/


/**********************************I-DEP-RAC-TES-0-13/10/2014*****************************************/


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
/**********************************F-DEP-RAC-TES-0-13/10/2014*****************************************/





/**********************************I-DEP-RAC-TES-0-28/10/2014*****************************************/

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
    monto_anticipo)
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
         pp.monto_anticipo
  FROM tes.tplan_pago pp
       JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago =
         op.id_obligacion_pago
       JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor
       LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
         op.id_categoria_compra;
         
/**********************************F-DEP-RAC-TES-0-28/10/2014*****************************************/

/**********************************I-DEP-JRR-TES-0-18/11/2014*****************************************/

ALTER TABLE tes.tobligacion_pago
  DROP CONSTRAINT chk_tobligacion_pago__tipo_obligacion RESTRICT;

ALTER TABLE tes.tobligacion_pago
  ADD CONSTRAINT chk_tobligacion_pago__tipo_obligacion CHECK ((tipo_obligacion)::text = ANY (ARRAY[('adquisiciones'::character varying)::text, ('caja_chica'::character varying)::text, ('viaticos'::character varying)::text, ('fondos_en_avance'::character varying)::text, ('pago_directo'::character varying)::text, ('rrhh'::character varying)::text]));

/**********************************F-DEP-JRR-TES-0-18/11/2014*****************************************/

/**********************************I-DEP-JRR-TES-0-24/11/2014*****************************************/

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
    id_funcionario_gerente)
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
         ((COALESCE(op.numero, '' ::character varying) ::text || ' ' ::text) ||
          COALESCE(pp.obs_monto_no_pagado, '' ::text)) ::character varying AS
           obs_pp,
         pp.descuento_anticipo,
         pp.descuento_inter_serv,
         op.tipo_obligacion,
         op.id_categoria_compra,
         COALESCE(cac.codigo, '' ::character varying) AS codigo_categoria,
         COALESCE(cac.nombre, '' ::character varying) AS nombre_categoria,
         pp.id_proceso_wf,
         ('<table>' ::text || pxp.html_rows((((('<td>' ::text ||
          ci.desc_ingas::text) || '<br/>' ::text) || od.descripcion) || '</td>'
           ::text) ::character varying) ::text) || '</table>' ::text AS detalle,
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
         COALESCE(op.id_funcionario_gerente, 0) AS id_funcionario_gerente
  FROM tes.tplan_pago pp
       JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago =
        op.id_obligacion_pago
       JOIN param.tmoneda mon ON mon.id_moneda = op.id_moneda
       LEFT JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor
       LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
        op.id_categoria_compra
       JOIN tes.tobligacion_det od ON od.id_obligacion_pago =
        op.id_obligacion_pago AND od.estado_reg::text = 'activo' ::text
       JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas =
        od.id_concepto_ingas
       JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario =
        op.id_funcionario AND fun.estado_reg_asi::text = 'activo' ::text
       JOIN segu.vusuario usu ON usu.id_usuario = op.id_usuario_reg
  GROUP BY pp.id_plan_pago,
           op.id_proveedor,
           p.desc_proveedor,
           op.id_moneda,
           op.id_depto_conta,
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
           op.id_funcionario_gerente;
           
/**********************************F-DEP-JRR-TES-0-24/11/2014*****************************************/

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


/***********************************I-DEP-RAC-TES-0-27/11/2014****************************************/

select pxp.f_insert_testructura_gui ('OBPG.1.1', 'OBPG.1');
select pxp.f_insert_testructura_gui ('SOLPD.1.1', 'SOLPD.1');
select pxp.f_insert_testructura_gui ('REVBPP', 'TES');
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
select pxp.f_insert_testructura_gui ('VBOP', 'TES');
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
select pxp.f_insert_testructura_gui ('TIPPRO', 'TES');
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
select pxp.f_insert_testructura_gui ('REPOP', 'TES');
select pxp.f_insert_testructura_gui ('REPPAGCON', 'REPOP');
select pxp.f_insert_testructura_gui ('REPPAGCON.1', 'REPPAGCON');
select pxp.f_insert_testructura_gui ('OPCONTA', 'TES');
select pxp.f_insert_testructura_gui ('CONOP', 'TES');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPAR_SEL', 'OBPG.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_TIPO_SEL', 'OBPG.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPAR_SEL', 'OBPG.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_OFCU_SEL', 'OBPG.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'OBPG.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'OBPG.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_TIPOEJE_UPD', 'OBPG.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GES_SEL', 'OBPG.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PER_SEL', 'OBPG.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPAR_SEL', 'SOLPD.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_TIPO_SEL', 'SOLPD.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPAR_SEL', 'SOLPD.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_OFCU_SEL', 'SOLPD.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'SOLPD.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'SOLPD.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_TIPOEJE_UPD', 'SOLPD.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GES_SEL', 'SOLPD.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PER_SEL', 'SOLPD.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_GATNREP_SEL', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_IDSEXT_GET', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTOC_REP', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_SEL', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTREP_SEL', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_IME', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROCPED_SEL', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_SEL', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTPROC_SEL', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTRPC_SEL', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PLT_SEL', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_SEL', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('MIG_CBANESIS_SEL', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_INS', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAPA_INS', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PPANTPAR_INS', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_MOD', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_ELI', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_SEL', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SINPRE_IME', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_ANTEPP_IME', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SIGEPP_IME', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAREP_SEL', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_MOD', 'REVBPP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'REVBPP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_SEL', 'REVBPP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOLAR_SEL', 'REVBPP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_INS', 'REVBPP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_MOD', 'REVBPP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_ELI', 'REVBPP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'REVBPP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOLAR_MOD', 'REVBPP.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'REVBPP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'REVBPP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'REVBPP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'REVBPP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_INS', 'REVBPP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_MOD', 'REVBPP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_ELI', 'REVBPP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_SEL', 'REVBPP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'REVBPP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'REVBPP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'REVBPP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'REVBPP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEM_SEL', 'REVBPP.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'REVBPP.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMALM_SEL', 'REVBPP.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'REVBPP.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_INS', 'REVBPP.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_MOD', 'REVBPP.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_ELI', 'REVBPP.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_SEL', 'REVBPP.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'REVBPP.2.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'REVBPP.2.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'REVBPP.2.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'REVBPP.2.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'REVBPP.2.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'REVBPP.2.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'REVBPP.2.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'REVBPP.2.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'REVBPP.2.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'REVBPP.2.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'REVBPP.2.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'REVBPP.2.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'REVBPP.2.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'REVBPP.2.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'REVBPP.2.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'REVBPP.2.2.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'REVBPP.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'REVBPP.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_VERSIGPRO_IME', 'REVBPP.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CHKSTA_IME', 'REVBPP.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'REVBPP.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'REVBPP.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DEPTIPES_SEL', 'REVBPP.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'REVBPP.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'REVBPP.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'REVBPP.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CABMOM_IME', 'REVBPP.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'REVBPP.5.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPPROC_SEL', 'REVBPP.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'REVBPP.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_INS', 'REVBPP.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_MOD', 'REVBPP.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_ELI', 'REVBPP.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_SEL', 'REVBPP.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_ANTEOB_IME', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_GATNREP_SEL', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PLT_SEL', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_INS', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_MOD', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_ELI', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_SEL', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPGSOL_SEL', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPGSEL_SEL', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAOB_SEL', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_OBTTCB_GET', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_FINREG_IME', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_IDSEXT_GET', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTOC_REP', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_SEL', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTREP_SEL', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_IME', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROCPED_SEL', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_SEL', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTPROC_SEL', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTRPC_SEL', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'VBOP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPAR_SEL', 'VBOP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_SEL', 'VBOP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_ARB_SEL', 'VBOP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_SEL', 'VBOP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_ARB_SEL', 'VBOP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_AUXCTA_SEL', 'VBOP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_INS', 'VBOP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_MOD', 'VBOP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_ELI', 'VBOP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_SEL', 'VBOP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'VBOP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'VBOP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'VBOP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_TIPO_SEL', 'VBOP.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPAR_SEL', 'VBOP.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_OFCU_SEL', 'VBOP.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'VBOP.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'VBOP.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_TIPOEJE_UPD', 'VBOP.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GES_SEL', 'VBOP.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PER_SEL', 'VBOP.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAREP_SEL', 'VBOP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'VBOP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PAFPP_IME', 'VBOP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_GETDEC_IME', 'VBOP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PLT_SEL', 'VBOP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_SEL', 'VBOP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('MIG_CBANESIS_SEL', 'VBOP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_INS', 'VBOP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAPA_INS', 'VBOP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PPANTPAR_INS', 'VBOP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_MOD', 'VBOP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_ELI', 'VBOP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_SEL', 'VBOP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SINPRE_IME', 'VBOP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_ANTEPP_IME', 'VBOP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SIGEPP_IME', 'VBOP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_SEL', 'VBOP.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_MOD', 'VBOP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'VBOP.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'VBOP.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'VBOP.2.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_VERSIGPRO_IME', 'VBOP.2.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CHKSTA_IME', 'VBOP.2.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'VBOP.2.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'VBOP.2.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DEPTIPES_SEL', 'VBOP.2.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'VBOP.2.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'VBOP.2.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'VBOP.2.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CABMOM_IME', 'VBOP.2.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'VBOP.2.5.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPPROC_SEL', 'VBOP.2.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'VBOP.2.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_INS', 'VBOP.2.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_MOD', 'VBOP.2.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_ELI', 'VBOP.2.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_SEL', 'VBOP.2.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPGSEL_SEL', 'VBOP.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_SEL', 'VBOP.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPGSOL_SEL', 'VBOP.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_COMEJEPAG_SEL', 'VBOP.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'VBOP.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PAFPP_IME', 'VBOP.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_GETDEC_IME', 'VBOP.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PLT_SEL', 'VBOP.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_SEL', 'VBOP.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('MIG_CBANESIS_SEL', 'VBOP.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_INS', 'VBOP.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAPA_INS', 'VBOP.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PPANTPAR_INS', 'VBOP.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_MOD', 'VBOP.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_ELI', 'VBOP.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_SEL', 'VBOP.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SINPRE_IME', 'VBOP.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_ANTEPP_IME', 'VBOP.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SIGEPP_IME', 'VBOP.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAREP_SEL', 'VBOP.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'VBOP.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_SEL', 'VBOP.4.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_MOD', 'VBOP.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'VBOP.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'VBOP.4.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'VBOP.4.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_VERSIGPRO_IME', 'VBOP.4.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CHKSTA_IME', 'VBOP.4.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'VBOP.4.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'VBOP.4.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DEPTIPES_SEL', 'VBOP.4.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'VBOP.4.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'VBOP.4.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'VBOP.4.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CABMOM_IME', 'VBOP.4.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'VBOP.4.5.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPPROC_SEL', 'VBOP.4.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'VBOP.4.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_INS', 'VBOP.4.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_MOD', 'VBOP.4.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_ELI', 'VBOP.4.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_SEL', 'VBOP.4.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'VBOP.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'VBOP.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'VBOP.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CABMOM_IME', 'VBOP.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'VBOP.5.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPPROC_SEL', 'VBOP.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'VBOP.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_INS', 'VBOP.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_MOD', 'VBOP.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_ELI', 'VBOP.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_SEL', 'VBOP.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_SEL', 'VBOP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'VBOP.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'VBOP.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'VBOP.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'VBOP.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_INS', 'VBOP.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_MOD', 'VBOP.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_ELI', 'VBOP.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_SEL', 'VBOP.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'VBOP.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'VBOP.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBOP.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'VBOP.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEM_SEL', 'VBOP.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'VBOP.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMALM_SEL', 'VBOP.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'VBOP.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_INS', 'VBOP.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_MOD', 'VBOP.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_ELI', 'VBOP.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_SEL', 'VBOP.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'VBOP.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'VBOP.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'VBOP.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBOP.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'VBOP.7.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'VBOP.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'VBOP.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'VBOP.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'VBOP.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'VBOP.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBOP.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'VBOP.7.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'VBOP.7.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'VBOP.7.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBOP.7.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'VBOP.7.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_REVPP_IME', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_TIPO_INS', 'TIPPRO', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_TIPO_MOD', 'TIPPRO', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_TIPO_ELI', 'TIPPRO', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_TIPO_SEL', 'TIPPRO', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_GENCONF_IME', 'OBPG.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_GENCONF_IME', 'OBPG.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_GENCONF_IME', 'VBDP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_GENCONF_IME', 'SOLPD.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_GENCONF_IME', 'SOLPD.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_GENCONF_IME', 'REVBPP', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_GENCONF_IME', 'VBOP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_GENCONF_IME', 'VBOP.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_GATNREP_SEL', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PLT_SEL', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_INS', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_MOD', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_ELI', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_SEL', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPGSOL_SEL', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPGSEL_SEL', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAOB_SEL', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_OBTTCB_GET', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_FINREG_IME', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_ANTEOB_IME', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_IDSEXT_GET', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTOC_REP', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_SEL', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTREP_SEL', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_IME', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROCPED_SEL', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_SEL', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTPROC_SEL', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTRPC_SEL', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDETAPRO_MOD', 'VBDP.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'VBDP.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPAR_SEL', 'VBDP.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_SEL', 'VBDP.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_ARB_SEL', 'VBDP.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_SEL', 'VBDP.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_ARB_SEL', 'VBDP.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_AUXCTA_SEL', 'VBDP.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_INS', 'VBDP.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_MOD', 'VBDP.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_ELI', 'VBDP.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_SEL', 'VBDP.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'VBDP.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'VBDP.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'VBDP.6.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_TIPO_SEL', 'VBDP.6.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPAR_SEL', 'VBDP.6.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_OFCU_SEL', 'VBDP.6.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'VBDP.6.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'VBDP.6.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_TIPOEJE_UPD', 'VBDP.6.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GES_SEL', 'VBDP.6.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PER_SEL', 'VBDP.6.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPGSEL_SEL', 'VBDP.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_SEL', 'VBDP.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPGSOL_SEL', 'VBDP.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_COMEJEPAG_SEL', 'VBDP.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'VBDP.6.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'VBDP.6.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPAR_SEL', 'VBDP.6.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_SEL', 'VBDP.6.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_ARB_SEL', 'VBDP.6.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_SEL', 'VBDP.6.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_ARB_SEL', 'VBDP.6.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_AUXCTA_SEL', 'VBDP.6.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_INS', 'VBDP.6.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_MOD', 'VBDP.6.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_ELI', 'VBDP.6.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_SEL', 'VBDP.6.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'VBDP.6.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'VBDP.6.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'VBDP.6.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_TIPO_SEL', 'VBDP.6.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPAR_SEL', 'VBDP.6.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_OFCU_SEL', 'VBDP.6.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'VBDP.6.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'VBDP.6.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_TIPOEJE_UPD', 'VBDP.6.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GES_SEL', 'VBDP.6.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PER_SEL', 'VBDP.6.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PAFPP_IME', 'VBDP.6.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_GETDEC_IME', 'VBDP.6.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PLT_SEL', 'VBDP.6.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_SEL', 'VBDP.6.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('MIG_CBANESIS_SEL', 'VBDP.6.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_INS', 'VBDP.6.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAPA_INS', 'VBDP.6.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PPANTPAR_INS', 'VBDP.6.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_MOD', 'VBDP.6.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_ELI', 'VBDP.6.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_SEL', 'VBDP.6.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SINPRE_IME', 'VBDP.6.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_ANTEPP_IME', 'VBDP.6.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SIGEPP_IME', 'VBDP.6.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAREP_SEL', 'VBDP.6.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'VBDP.6.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_GENCONF_IME', 'VBDP.6.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_SEL', 'VBDP.6.4.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_MOD', 'VBDP.6.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'VBDP.6.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'VBDP.6.4.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'VBDP.6.4.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_VERSIGPRO_IME', 'VBDP.6.4.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CHKSTA_IME', 'VBDP.6.4.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'VBDP.6.4.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'VBDP.6.4.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DEPTIPES_SEL', 'VBDP.6.4.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'VBDP.6.4.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'VBDP.6.4.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'VBDP.6.4.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CABMOM_IME', 'VBDP.6.4.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'VBDP.6.4.5.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPPROC_SEL', 'VBDP.6.4.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'VBDP.6.4.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_INS', 'VBDP.6.4.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_MOD', 'VBDP.6.4.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_ELI', 'VBDP.6.4.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_SEL', 'VBDP.6.4.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'VBDP.6.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'VBDP.6.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'VBDP.6.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CABMOM_IME', 'VBDP.6.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'VBDP.6.5.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPPROC_SEL', 'VBDP.6.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'VBDP.6.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_INS', 'VBDP.6.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_MOD', 'VBDP.6.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_ELI', 'VBDP.6.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_SEL', 'VBDP.6.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_SEL', 'VBDP.6.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'VBDP.6.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'VBDP.6.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'VBDP.6.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'VBDP.6.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_INS', 'VBDP.6.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_MOD', 'VBDP.6.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_ELI', 'VBDP.6.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_SEL', 'VBDP.6.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'VBDP.6.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'VBDP.6.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBDP.6.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'VBDP.6.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEM_SEL', 'VBDP.6.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'VBDP.6.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMALM_SEL', 'VBDP.6.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'VBDP.6.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_INS', 'VBDP.6.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_MOD', 'VBDP.6.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_ELI', 'VBDP.6.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_SEL', 'VBDP.6.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'VBDP.6.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'VBDP.6.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'VBDP.6.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBDP.6.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'VBDP.6.7.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'VBDP.6.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'VBDP.6.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'VBDP.6.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'VBDP.6.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'VBDP.6.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBDP.6.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'VBDP.6.7.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'VBDP.6.7.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'VBDP.6.7.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBDP.6.7.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'VBDP.6.7.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_ODT_SEL', 'SOLPD.1', 'si');
select pxp.f_insert_tprocedimiento_gui ('CONTA_ODT_SEL', 'OBPG', 'si');
select pxp.f_insert_tprocedimiento_gui ('TES_OBLAJUS_IME', 'OBPG', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBLAJUS_IME', 'VBDP.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBLAJUS_IME', 'SOLPD', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBLAJUS_IME', 'VBOP', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPAR_SEL', 'REPPAGCON', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GES_SEL', 'REPPAGCON', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PAXCIG_SEL', 'REPPAGCON.1', 'no');
select pxp.f_insert_tgui_rol ('VBDP', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('TES', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('SISTEMA', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('VBDP.4', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('VBDP.5', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('VBDP.1', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('VBDP.2', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('VBDP.2.1', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('VBDP.2.2', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('VBDP.2.2.1', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('VBDP.2.2.2', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('VBDP.2.2.2.1', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('VBDP.2.2.3', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('VBDP.2.2.3.1', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('VBDP.2.2.3.1.1', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('VBDP.3', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('VBDP.3.1', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('VBDP.3.2', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('APFAENDE', 'OP -VoBo Fondos en Avance');
select pxp.f_insert_tgui_rol ('TES', 'OP -VoBo Fondos en Avance');
select pxp.f_insert_tgui_rol ('SISTEMA', 'OP -VoBo Fondos en Avance');
select pxp.f_insert_tgui_rol ('REVBPP', 'OP - VoBo Ppagos (Asistentes)');
select pxp.f_insert_tgui_rol ('TES', 'OP - VoBo Ppagos (Asistentes)');
select pxp.f_insert_tgui_rol ('SISTEMA', 'OP - VoBo Ppagos (Asistentes)');
select pxp.f_insert_tgui_rol ('REVBPP.5', 'OP - VoBo Ppagos (Asistentes)');
select pxp.f_insert_tgui_rol ('REVBPP.5.2', 'OP - VoBo Ppagos (Asistentes)');
select pxp.f_insert_tgui_rol ('REVBPP.5.1', 'OP - VoBo Ppagos (Asistentes)');
select pxp.f_insert_tgui_rol ('REVBPP.4', 'OP - VoBo Ppagos (Asistentes)');
select pxp.f_insert_tgui_rol ('REVBPP.3', 'OP - VoBo Ppagos (Asistentes)');
select pxp.f_insert_tgui_rol ('REVBPP.2', 'OP - VoBo Ppagos (Asistentes)');
select pxp.f_insert_tgui_rol ('REVBPP.2.2', 'OP - VoBo Ppagos (Asistentes)');
select pxp.f_insert_tgui_rol ('REVBPP.2.2.3', 'OP - VoBo Ppagos (Asistentes)');
select pxp.f_insert_tgui_rol ('REVBPP.2.2.3.1', 'OP - VoBo Ppagos (Asistentes)');
select pxp.f_insert_tgui_rol ('REVBPP.2.2.3.1.1', 'OP - VoBo Ppagos (Asistentes)');
select pxp.f_insert_tgui_rol ('REVBPP.2.2.2', 'OP - VoBo Ppagos (Asistentes)');
select pxp.f_insert_tgui_rol ('REVBPP.2.2.2.1', 'OP - VoBo Ppagos (Asistentes)');
select pxp.f_insert_tgui_rol ('REVBPP.2.2.1', 'OP - VoBo Ppagos (Asistentes)');
select pxp.f_insert_tgui_rol ('REVBPP.2.1', 'OP - VoBo Ppagos (Asistentes)');
select pxp.f_insert_tgui_rol ('REVBPP.1', 'OP - VoBo Ppagos (Asistentes)');
select pxp.f_insert_tgui_rol ('VBDP.1', 'OP - Plan de Pagos Consulta');
select pxp.f_insert_tgui_rol ('VBDP', 'OP - Plan de Pagos Consulta');
select pxp.f_insert_tgui_rol ('TES', 'OP - Plan de Pagos Consulta');
select pxp.f_insert_tgui_rol ('SISTEMA', 'OP - Plan de Pagos Consulta');
select pxp.f_insert_tgui_rol ('VBDP.2.2.1', 'OP - Plan de Pagos Consulta');
select pxp.f_insert_tgui_rol ('VBDP.2.2', 'OP - Plan de Pagos Consulta');
select pxp.f_insert_tgui_rol ('VBDP.2', 'OP - Plan de Pagos Consulta');
select pxp.f_insert_tgui_rol ('VBDP.2.2.2', 'OP - Plan de Pagos Consulta');
select pxp.f_insert_tgui_rol ('VBDP.2.2.3.1', 'OP - Plan de Pagos Consulta');
select pxp.f_insert_tgui_rol ('VBDP.2.2.3', 'OP - Plan de Pagos Consulta');
select pxp.f_insert_tgui_rol ('VBDP.3.2', 'OP - Plan de Pagos Consulta');
select pxp.f_insert_tgui_rol ('VBDP.3', 'OP - Plan de Pagos Consulta');
select pxp.f_insert_tgui_rol ('OBPG.1.1', 'OP - Obligaciones de PAgo');
select pxp.f_insert_tgui_rol ('SOLPD.1.1', 'OP - Solicitudes de Pago Directas');
select pxp.f_insert_tgui_rol ('VBDP.5', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('VBDP.4', 'OP - VoBo Plan de Pagos');
select pxp.f_insert_tgui_rol ('VBDP.6', 'OP - VoBo Pago Contabilidad');
select pxp.f_delete_tgui_rol ('VBDP.6.7', 'OP - VoBo Pago Contabilidad');
select pxp.f_delete_tgui_rol ('VBDP.6.7.3', 'OP - VoBo Pago Contabilidad');
select pxp.f_delete_tgui_rol ('VBDP.6.7.3.1', 'OP - VoBo Pago Contabilidad');
select pxp.f_delete_tgui_rol ('VBDP.6.7.3.1.1', 'OP - VoBo Pago Contabilidad');
select pxp.f_delete_tgui_rol ('VBDP.6.7.2', 'OP - VoBo Pago Contabilidad');
select pxp.f_delete_tgui_rol ('VBDP.6.7.2.1', 'OP - VoBo Pago Contabilidad');
select pxp.f_delete_tgui_rol ('VBDP.6.7.1', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('VBDP.6.6', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('VBDP.6.5', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('VBDP.6.5.2', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('VBDP.6.5.1', 'OP - VoBo Pago Contabilidad');
select pxp.f_delete_tgui_rol ('VBDP.6.4', 'OP - VoBo Pago Contabilidad');
select pxp.f_delete_tgui_rol ('VBDP.6.4.5', 'OP - VoBo Pago Contabilidad');
select pxp.f_delete_tgui_rol ('VBDP.6.4.5.2', 'OP - VoBo Pago Contabilidad');
select pxp.f_delete_tgui_rol ('VBDP.6.4.5.1', 'OP - VoBo Pago Contabilidad');
select pxp.f_delete_tgui_rol ('VBDP.6.4.4', 'OP - VoBo Pago Contabilidad');
select pxp.f_delete_tgui_rol ('VBDP.6.4.3', 'OP - VoBo Pago Contabilidad');
select pxp.f_delete_tgui_rol ('VBDP.6.4.2', 'OP - VoBo Pago Contabilidad');
select pxp.f_delete_tgui_rol ('VBDP.6.4.1', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('VBDP.6.3', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('VBDP.6.3.1', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('VBDP.6.2', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('VBDP.6.1', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('VBDP.6.1.1', 'OP - VoBo Pago Contabilidad');
select pxp.f_insert_tgui_rol ('REPPAGCON', 'OP - Reporte Pagos X Concepto');
select pxp.f_insert_tgui_rol ('REPOP', 'OP - Reporte Pagos X Concepto');
select pxp.f_insert_tgui_rol ('TES', 'OP - Reporte Pagos X Concepto');
select pxp.f_insert_tgui_rol ('SISTEMA', 'OP - Reporte Pagos X Concepto');
select pxp.f_insert_tgui_rol ('REPPAGCON.1', 'OP - Reporte Pagos X Concepto');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_DWF_MOD', 'VBDP.3');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_DWF_ELI', 'VBDP.3');
select pxp.f_delete_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'WF_DWF_MOD', 'OBPG.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'WF_DWF_ELI', 'OBPG.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'PM_PLT_SEL', 'OBPG');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DWF_MOD', 'OBPG.3.3');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_CABMOM_IME', 'OBPG.3.3');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_TIPES_SEL', 'OBPG.3.3.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_TIPPROC_SEL', 'OBPG.3.3.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_INS', 'OBPG.3.3.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_MOD', 'OBPG.3.3.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_ELI', 'OBPG.3.3.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_SEL', 'OBPG.3.3.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DWF_MOD', 'OBPG.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_CABMOM_IME', 'OBPG.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_TIPES_SEL', 'OBPG.4.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_TIPPROC_SEL', 'OBPG.4.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_INS', 'OBPG.4.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_MOD', 'OBPG.4.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_ELI', 'OBPG.4.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_SEL', 'OBPG.4.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DOCWFAR_MOD', 'OBPG.4.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_UPFOTOPER_MOD', 'OBPG.6.3.1.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_UPFOTOPER_MOD', 'OBPG.7.2.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSONMIN_SEL', 'OBPG.7.1.1.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSON_ELI', 'OBPG.7.1.1.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSON_MOD', 'OBPG.7.1.1.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_PERSON_INS', 'OBPG.7.1.1.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'SEG_UPFOTOPER_MOD', 'OBPG.7.1.1.1.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_SEL', 'OBPG.4.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_DES_INS', 'VBDP.3.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_DES_MOD', 'VBDP.3.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_DES_ELI', 'VBDP.3.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_SEL', 'OBPG.4.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - Pagos Directos de Servicios', 'WF_DES_SEL', 'OBPG.4.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'TES_PPANTPAR_INS', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'MIG_CBANESIS_SEL', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_TIPES_SEL', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_FUNTIPES_SEL', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'TES_SINPRE_IME', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'TES_SIGEPP_IME', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'TES_ANTEPP_IME', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'TES_PLAPAREP_SEL', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'TES_PRO_SEL', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_GATNREP_SEL', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'TES_OBEPUO_IME', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_DEPFILEPUO_SEL', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'TES_SOLDEVPAG_IME', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'TES_IDSEXT_GET', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_COTOC_REP', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_CTD_SEL', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_COTREP_SEL', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOLREP_SEL', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOLD_SEL', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOLDETCOT_SEL', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PRE_VERPRE_IME', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_PROCPED_SEL', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_COT_SEL', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_COTPROC_SEL', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_COTRPC_SEL', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PLT_SEL', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'TES_CTABAN_SEL', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'TES_PLAPAPA_INS', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'TES_PLAPA_INS', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'TES_PLAPA_MOD', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'TES_PLAPA_ELI', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'TES_PLAPA_SEL', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'CONTA_GETDEC_IME', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_DOCWFAR_MOD', 'VBDP.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_DOCWFAR_MOD', 'VBDP.5');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_VERSIGPRO_IME', 'VBDP.5');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_CHKSTA_IME', 'VBDP.5');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_TIPES_SEL', 'VBDP.5');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_FUNTIPES_SEL', 'VBDP.5');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_DEPTIPES_SEL', 'VBDP.5');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'TES_PRO_MOD', 'VBDP.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'TES_PRO_SEL', 'VBDP.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_DOCSOL_SEL', 'VBDP.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_DOCSOLAR_SEL', 'VBDP.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_DOCSOL_INS', 'VBDP.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_DOCSOL_MOD', 'VBDP.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_DOCSOL_ELI', 'VBDP.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PROVEEV_SEL', 'VBDP.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_DOCSOLAR_MOD', 'VBDP.2.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_SERVIC_SEL', 'VBDP.2.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SAL_ITEMNOTBASE_SEL', 'VBDP.2.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_LUG_SEL', 'VBDP.2.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_LUG_ARB_SEL', 'VBDP.2.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PROVEE_INS', 'VBDP.2.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PROVEE_MOD', 'VBDP.2.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PROVEE_ELI', 'VBDP.2.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PROVEE_SEL', 'VBDP.2.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PROVEEV_SEL', 'VBDP.2.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSON_SEL', 'VBDP.2.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSONMIN_SEL', 'VBDP.2.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_INSTIT_SEL', 'VBDP.2.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SAL_ITEM_SEL', 'VBDP.2.2.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SAL_ITEMNOTBASE_SEL', 'VBDP.2.2.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SAL_ITMALM_SEL', 'VBDP.2.2.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_SERVIC_SEL', 'VBDP.2.2.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PRITSE_INS', 'VBDP.2.2.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PRITSE_MOD', 'VBDP.2.2.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PRITSE_ELI', 'VBDP.2.2.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PRITSE_SEL', 'VBDP.2.2.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSON_INS', 'VBDP.2.2.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSON_MOD', 'VBDP.2.2.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSON_ELI', 'VBDP.2.2.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSONMIN_SEL', 'VBDP.2.2.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_UPFOTOPER_MOD', 'VBDP.2.2.2.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_INSTIT_INS', 'VBDP.2.2.3');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_INSTIT_MOD', 'VBDP.2.2.3');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_INSTIT_ELI', 'VBDP.2.2.3');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_INSTIT_SEL', 'VBDP.2.2.3');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSON_SEL', 'VBDP.2.2.3');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSONMIN_SEL', 'VBDP.2.2.3');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSON_INS', 'VBDP.2.2.3.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSON_MOD', 'VBDP.2.2.3.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSON_ELI', 'VBDP.2.2.3.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSONMIN_SEL', 'VBDP.2.2.3.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_UPFOTOPER_MOD', 'VBDP.2.2.3.1.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_DWF_MOD', 'VBDP.3');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_DWF_ELI', 'VBDP.3');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_DWF_SEL', 'VBDP.3');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_CABMOM_IME', 'VBDP.3');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_DOCWFAR_MOD', 'VBDP.3.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_TIPPROC_SEL', 'VBDP.3.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_TIPES_SEL', 'VBDP.3.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_DES_INS', 'VBDP.3.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_DES_MOD', 'VBDP.3.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_DES_ELI', 'VBDP.3.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_DES_SEL', 'VBDP.3.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_PPANTPAR_INS', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'MIG_CBANESIS_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_TIPES_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_FUNTIPES_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_SINPRE_IME', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_SIGEPP_IME', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_ANTEPP_IME', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_PLAPAREP_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_PRO_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_GATNREP_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_OBEPUO_IME', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_DEPFILEPUO_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_SOLDEVPAG_IME', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_IDSEXT_GET', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'ADQ_COTOC_REP', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'ADQ_CTD_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'ADQ_COTREP_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'ADQ_SOLREP_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'ADQ_SOLD_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'ADQ_SOLDETCOT_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PRE_VERPRE_IME', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'ADQ_PROCPED_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'ADQ_COT_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'ADQ_COTPROC_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'ADQ_COTRPC_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_PLT_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_CTABAN_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_PLAPAPA_INS', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_PLAPA_INS', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_PLAPA_MOD', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_PLAPA_ELI', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_PLAPA_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'CONTA_GETDEC_IME', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DOCWFAR_MOD', 'VBDP.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DOCWFAR_MOD', 'VBDP.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_VERSIGPRO_IME', 'VBDP.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_CHKSTA_IME', 'VBDP.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_TIPES_SEL', 'VBDP.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_FUNTIPES_SEL', 'VBDP.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DEPTIPES_SEL', 'VBDP.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_PRO_MOD', 'VBDP.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_PRO_SEL', 'VBDP.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'ADQ_DOCSOL_SEL', 'VBDP.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'ADQ_DOCSOLAR_SEL', 'VBDP.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'ADQ_DOCSOL_INS', 'VBDP.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'ADQ_DOCSOL_MOD', 'VBDP.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'ADQ_DOCSOL_ELI', 'VBDP.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_PROVEEV_SEL', 'VBDP.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'ADQ_DOCSOLAR_MOD', 'VBDP.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_SERVIC_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SAL_ITEMNOTBASE_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_LUG_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_LUG_ARB_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_PROVEE_INS', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_PROVEE_MOD', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_PROVEE_ELI', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_PROVEE_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_PROVEEV_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_PERSON_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_PERSONMIN_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_INSTIT_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SAL_ITEM_SEL', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SAL_ITEMNOTBASE_SEL', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SAL_ITMALM_SEL', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_SERVIC_SEL', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_PRITSE_INS', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_PRITSE_MOD', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_PRITSE_ELI', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_PRITSE_SEL', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_PERSON_INS', 'VBDP.2.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_PERSON_MOD', 'VBDP.2.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_PERSON_ELI', 'VBDP.2.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_PERSONMIN_SEL', 'VBDP.2.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_UPFOTOPER_MOD', 'VBDP.2.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_INSTIT_INS', 'VBDP.2.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_INSTIT_MOD', 'VBDP.2.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_INSTIT_ELI', 'VBDP.2.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_INSTIT_SEL', 'VBDP.2.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_PERSON_SEL', 'VBDP.2.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_PERSONMIN_SEL', 'VBDP.2.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_PERSON_INS', 'VBDP.2.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_PERSON_MOD', 'VBDP.2.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_PERSON_ELI', 'VBDP.2.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_PERSONMIN_SEL', 'VBDP.2.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_UPFOTOPER_MOD', 'VBDP.2.2.3.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DWF_MOD', 'VBDP.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DWF_ELI', 'VBDP.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DWF_SEL', 'VBDP.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_CABMOM_IME', 'VBDP.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DOCWFAR_MOD', 'VBDP.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_TIPPROC_SEL', 'VBDP.3.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_TIPES_SEL', 'VBDP.3.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DES_INS', 'VBDP.3.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DES_MOD', 'VBDP.3.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DES_ELI', 'VBDP.3.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DES_SEL', 'VBDP.3.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_DEPFILUSU_SEL', 'SOLPD');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'WF_GATNREP_SEL', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'TES_IDSEXT_GET', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'ADQ_COTOC_REP', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'ADQ_CTD_SEL', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'ADQ_COTREP_SEL', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'ADQ_SOLREP_SEL', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'ADQ_SOLD_SEL', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'ADQ_SOLDETCOT_SEL', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'PRE_VERPRE_IME', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'ADQ_PROCPED_SEL', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'ADQ_COT_SEL', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'ADQ_COTPROC_SEL', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'ADQ_COTRPC_SEL', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'PM_PLT_SEL', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'TES_CTABAN_SEL', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'MIG_CBANESIS_SEL', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'TES_PLAPA_INS', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'TES_PLAPAPA_INS', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'TES_PPANTPAR_INS', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'TES_PLAPA_MOD', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'TES_PLAPA_ELI', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'TES_PLAPA_SEL', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'TES_SINPRE_IME', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'TES_ANTEPP_IME', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'TES_SIGEPP_IME', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'TES_PLAPAREP_SEL', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'TES_PRO_SEL', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'WF_DWF_MOD', 'REVBPP.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'WF_DWF_ELI', 'REVBPP.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'WF_DWF_SEL', 'REVBPP.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'WF_CABMOM_IME', 'REVBPP.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'WF_TIPPROC_SEL', 'REVBPP.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'WF_TIPES_SEL', 'REVBPP.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'WF_DES_INS', 'REVBPP.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'WF_DES_MOD', 'REVBPP.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'WF_DES_ELI', 'REVBPP.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'WF_DES_SEL', 'REVBPP.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'WF_DOCWFAR_MOD', 'REVBPP.5.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'WF_DOCWFAR_MOD', 'REVBPP.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'WF_VERSIGPRO_IME', 'REVBPP.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'WF_CHKSTA_IME', 'REVBPP.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'WF_TIPES_SEL', 'REVBPP.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'WF_FUNTIPES_SEL', 'REVBPP.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'WF_DEPTIPES_SEL', 'REVBPP.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'WF_DOCWFAR_MOD', 'REVBPP.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'PM_PROVEEV_SEL', 'REVBPP.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'ADQ_DOCSOL_SEL', 'REVBPP.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'ADQ_DOCSOLAR_SEL', 'REVBPP.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'ADQ_DOCSOL_INS', 'REVBPP.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'ADQ_DOCSOL_MOD', 'REVBPP.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'ADQ_DOCSOL_ELI', 'REVBPP.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'PM_SERVIC_SEL', 'REVBPP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'SAL_ITEMNOTBASE_SEL', 'REVBPP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'PM_LUG_SEL', 'REVBPP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'PM_LUG_ARB_SEL', 'REVBPP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'PM_PROVEE_INS', 'REVBPP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'PM_PROVEE_MOD', 'REVBPP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'PM_PROVEE_ELI', 'REVBPP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'PM_PROVEE_SEL', 'REVBPP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'PM_PROVEEV_SEL', 'REVBPP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'SEG_PERSON_SEL', 'REVBPP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'SEG_PERSONMIN_SEL', 'REVBPP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'PM_INSTIT_SEL', 'REVBPP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'PM_INSTIT_INS', 'REVBPP.2.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'PM_INSTIT_MOD', 'REVBPP.2.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'PM_INSTIT_ELI', 'REVBPP.2.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'PM_INSTIT_SEL', 'REVBPP.2.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'SEG_PERSON_SEL', 'REVBPP.2.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'SEG_PERSONMIN_SEL', 'REVBPP.2.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'SEG_PERSON_INS', 'REVBPP.2.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'SEG_PERSON_MOD', 'REVBPP.2.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'SEG_PERSON_ELI', 'REVBPP.2.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'SEG_PERSONMIN_SEL', 'REVBPP.2.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'SEG_UPFOTOPER_MOD', 'REVBPP.2.2.3.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'SEG_PERSON_INS', 'REVBPP.2.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'SEG_PERSON_MOD', 'REVBPP.2.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'SEG_PERSON_ELI', 'REVBPP.2.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'SEG_PERSONMIN_SEL', 'REVBPP.2.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'SEG_UPFOTOPER_MOD', 'REVBPP.2.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'SAL_ITEM_SEL', 'REVBPP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'SAL_ITEMNOTBASE_SEL', 'REVBPP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'SAL_ITMALM_SEL', 'REVBPP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'PM_SERVIC_SEL', 'REVBPP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'PM_PRITSE_INS', 'REVBPP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'PM_PRITSE_MOD', 'REVBPP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'PM_PRITSE_ELI', 'REVBPP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'PM_PRITSE_SEL', 'REVBPP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'ADQ_DOCSOLAR_MOD', 'REVBPP.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'TES_PRO_MOD', 'REVBPP.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'TES_PRO_SEL', 'REVBPP.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'ADQ_COTREP_SEL', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'ADQ_SOLREP_SEL', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'ADQ_SOLD_SEL', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'ADQ_SOLDETCOT_SEL', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PRE_VERPRE_IME', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'ADQ_PROCPED_SEL', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'ADQ_COT_SEL', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'ADQ_COTPROC_SEL', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'ADQ_COTRPC_SEL', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_DEPUSUCOMB_SEL', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'RH_FUNCIOCAR_SEL', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_MONEDA_SEL', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_PROVEEV_SEL', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_ANTEOB_IME', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_GATNREP_SEL', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_PLT_SEL', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_OBPG_INS', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_OBPG_MOD', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_OBPG_ELI', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_OBPG_SEL', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_OBPGSOL_SEL', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_OBPGSEL_SEL', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_PLAPAOB_SEL', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_OBTTCB_GET', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_FINREG_IME', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_IDSEXT_GET', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'ADQ_COTOC_REP', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'ADQ_CTD_SEL', 'VBOP');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_SERVIC_SEL', 'VBOP.7');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'SAL_ITEMNOTBASE_SEL', 'VBOP.7');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_LUG_SEL', 'VBOP.7');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_LUG_ARB_SEL', 'VBOP.7');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_PROVEE_INS', 'VBOP.7');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_PROVEE_MOD', 'VBOP.7');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_PROVEE_ELI', 'VBOP.7');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_PROVEE_SEL', 'VBOP.7');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_PROVEEV_SEL', 'VBOP.7');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'SEG_PERSON_SEL', 'VBOP.7');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'SEG_PERSONMIN_SEL', 'VBOP.7');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_INSTIT_SEL', 'VBOP.7');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_INSTIT_INS', 'VBOP.7.3');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_INSTIT_MOD', 'VBOP.7.3');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_INSTIT_ELI', 'VBOP.7.3');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_INSTIT_SEL', 'VBOP.7.3');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'SEG_PERSON_SEL', 'VBOP.7.3');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'SEG_PERSONMIN_SEL', 'VBOP.7.3');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'SEG_PERSON_INS', 'VBOP.7.3.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'SEG_PERSON_MOD', 'VBOP.7.3.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'SEG_PERSON_ELI', 'VBOP.7.3.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'SEG_PERSONMIN_SEL', 'VBOP.7.3.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'SEG_UPFOTOPER_MOD', 'VBOP.7.3.1.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'SEG_PERSON_INS', 'VBOP.7.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'SEG_PERSON_MOD', 'VBOP.7.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'SEG_PERSON_ELI', 'VBOP.7.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'SEG_PERSONMIN_SEL', 'VBOP.7.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'SEG_UPFOTOPER_MOD', 'VBOP.7.2.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_PRITSE_ELI', 'VBOP.7.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_PRITSE_SEL', 'VBOP.7.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'SAL_ITEM_SEL', 'VBOP.7.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'SAL_ITEMNOTBASE_SEL', 'VBOP.7.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'SAL_ITMALM_SEL', 'VBOP.7.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_SERVIC_SEL', 'VBOP.7.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_PRITSE_INS', 'VBOP.7.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_PRITSE_MOD', 'VBOP.7.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PRE_VERPRE_SEL', 'VBOP.6');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DWF_MOD', 'VBOP.5');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DWF_ELI', 'VBOP.5');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DWF_SEL', 'VBOP.5');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_CABMOM_IME', 'VBOP.5');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_TIPPROC_SEL', 'VBOP.5.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_TIPES_SEL', 'VBOP.5.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DES_INS', 'VBOP.5.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DES_MOD', 'VBOP.5.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DES_ELI', 'VBOP.5.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DES_SEL', 'VBOP.5.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DOCWFAR_MOD', 'VBOP.5.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_PAFPP_IME', 'VBOP.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'CONTA_GETDEC_IME', 'VBOP.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_PLT_SEL', 'VBOP.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_CTABAN_SEL', 'VBOP.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'MIG_CBANESIS_SEL', 'VBOP.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_PLAPA_INS', 'VBOP.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_PLAPAPA_INS', 'VBOP.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_PPANTPAR_INS', 'VBOP.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_PLAPA_MOD', 'VBOP.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_PLAPA_ELI', 'VBOP.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_PLAPA_SEL', 'VBOP.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_SINPRE_IME', 'VBOP.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_ANTEPP_IME', 'VBOP.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_SIGEPP_IME', 'VBOP.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_PLAPAREP_SEL', 'VBOP.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_PRO_SEL', 'VBOP.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DWF_MOD', 'VBOP.4.5');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DWF_ELI', 'VBOP.4.5');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DWF_SEL', 'VBOP.4.5');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_CABMOM_IME', 'VBOP.4.5');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_TIPPROC_SEL', 'VBOP.4.5.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_TIPES_SEL', 'VBOP.4.5.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DES_INS', 'VBOP.4.5.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DES_MOD', 'VBOP.4.5.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DES_ELI', 'VBOP.4.5.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DES_SEL', 'VBOP.4.5.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DOCWFAR_MOD', 'VBOP.4.5.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DOCWFAR_MOD', 'VBOP.4.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_VERSIGPRO_IME', 'VBOP.4.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_CHKSTA_IME', 'VBOP.4.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_TIPES_SEL', 'VBOP.4.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_FUNTIPES_SEL', 'VBOP.4.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DEPTIPES_SEL', 'VBOP.4.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DOCWFAR_MOD', 'VBOP.4.3');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_PRO_MOD', 'VBOP.4.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_PRO_SEL', 'VBOP.4.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PRE_VERPRE_SEL', 'VBOP.4.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_OBPGSEL_SEL', 'VBOP.3');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_OBPG_SEL', 'VBOP.3');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_OBPGSOL_SEL', 'VBOP.3');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_COMEJEPAG_SEL', 'VBOP.3');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_MONEDA_SEL', 'VBOP.3');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_PRO_SEL', 'VBOP.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_PAFPP_IME', 'VBOP.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'CONTA_GETDEC_IME', 'VBOP.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_PLT_SEL', 'VBOP.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_CTABAN_SEL', 'VBOP.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'MIG_CBANESIS_SEL', 'VBOP.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_PLAPA_INS', 'VBOP.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_PLAPAPA_INS', 'VBOP.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_PPANTPAR_INS', 'VBOP.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_PLAPA_MOD', 'VBOP.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_PLAPA_ELI', 'VBOP.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_PLAPA_SEL', 'VBOP.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_SINPRE_IME', 'VBOP.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_ANTEPP_IME', 'VBOP.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_SIGEPP_IME', 'VBOP.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_PLAPAREP_SEL', 'VBOP.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DWF_MOD', 'VBOP.2.5');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DWF_ELI', 'VBOP.2.5');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DWF_SEL', 'VBOP.2.5');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_CABMOM_IME', 'VBOP.2.5');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_TIPPROC_SEL', 'VBOP.2.5.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_TIPES_SEL', 'VBOP.2.5.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DES_INS', 'VBOP.2.5.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DES_MOD', 'VBOP.2.5.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DES_ELI', 'VBOP.2.5.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DES_SEL', 'VBOP.2.5.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DOCWFAR_MOD', 'VBOP.2.5.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DOCWFAR_MOD', 'VBOP.2.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_VERSIGPRO_IME', 'VBOP.2.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_CHKSTA_IME', 'VBOP.2.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_TIPES_SEL', 'VBOP.2.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_FUNTIPES_SEL', 'VBOP.2.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DEPTIPES_SEL', 'VBOP.2.4');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'WF_DOCWFAR_MOD', 'VBOP.2.3');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_PRO_MOD', 'VBOP.2.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_PRO_SEL', 'VBOP.2.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PRE_VERPRE_SEL', 'VBOP.2.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_CCFILDEP_SEL', 'VBOP.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_CONIGPAR_SEL', 'VBOP.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'CONTA_CTA_SEL', 'VBOP.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'CONTA_CTA_ARB_SEL', 'VBOP.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PRE_PAR_SEL', 'VBOP.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PRE_PAR_ARB_SEL', 'VBOP.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'CONTA_AUXCTA_SEL', 'VBOP.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_OBDET_INS', 'VBOP.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_OBDET_MOD', 'VBOP.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_OBDET_ELI', 'VBOP.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_OBDET_SEL', 'VBOP.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_CEC_SEL', 'VBOP.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_CECCOM_SEL', 'VBOP.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_CECCOMFU_SEL', 'VBOP.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_TIPO_SEL', 'VBOP.1.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_CONIGPAR_SEL', 'VBOP.1.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'OR_OFCU_SEL', 'VBOP.1.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_LUG_SEL', 'VBOP.1.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_LUG_ARB_SEL', 'VBOP.1.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'TES_TIPOEJE_UPD', 'VBOP.1.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_GES_SEL', 'VBOP.1.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - VoBo Presupuestos', 'PM_PER_SEL', 'VBOP.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'TES_PRO_SEL', 'VBDP.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'SAL_ITEM_SEL', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'SAL_ITEMNOTBASE_SEL', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'SAL_ITMALM_SEL', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'PM_SERVIC_SEL', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'PM_PRITSE_SEL', 'VBDP.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'SEG_PERSONMIN_SEL', 'VBDP.2.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'SEG_PERSONMIN_SEL', 'VBDP.2.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'PM_INSTIT_SEL', 'VBDP.2.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'SEG_PERSON_SEL', 'VBDP.2.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'SEG_PERSONMIN_SEL', 'VBDP.2.2.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'PM_SERVIC_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'SAL_ITEMNOTBASE_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'PM_LUG_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'PM_LUG_ARB_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'PM_PROVEE_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'PM_PROVEEV_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'SEG_PERSON_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'SEG_PERSONMIN_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'PM_INSTIT_SEL', 'VBDP.2.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'ADQ_DOCSOL_SEL', 'VBDP.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'ADQ_DOCSOLAR_SEL', 'VBDP.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'PM_PROVEEV_SEL', 'VBDP.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'WF_TIPPROC_SEL', 'VBDP.3.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'WF_TIPES_SEL', 'VBDP.3.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'WF_DES_SEL', 'VBDP.3.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'WF_DWF_SEL', 'VBDP.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'MIG_CBANESIS_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'WF_TIPES_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'WF_FUNTIPES_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'TES_PLAPAREP_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'TES_PRO_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'WF_GATNREP_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'PM_DEPFILEPUO_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'ADQ_CTD_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'TES_IDSEXT_GET', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'ADQ_COTOC_REP', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'ADQ_COTREP_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'ADQ_SOLREP_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'ADQ_SOLD_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'ADQ_SOLDETCOT_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'ADQ_PROCPED_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'ADQ_COT_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'ADQ_COTPROC_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'ADQ_COTRPC_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'PM_PLT_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'TES_CTABAN_SEL', 'VBDP');
select pxp.f_delete_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'TES_PLAPAPA_INS', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - Plan de Pagos Consulta', 'TES_PLAPA_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'TES_REVPP_IME', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_PLT_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_OBPGSOL_SEL', 'OBPG');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_TIPO_SEL', 'OBPG.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_CONIGPAR_SEL', 'OBPG.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'OR_OFCU_SEL', 'OBPG.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_LUG_SEL', 'OBPG.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_LUG_ARB_SEL', 'OBPG.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'TES_TIPOEJE_UPD', 'OBPG.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_GES_SEL', 'OBPG.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_PER_SEL', 'OBPG.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Obligaciones de PAgo', 'PM_CONIGPAR_SEL', 'OBPG.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_LUG_ARB_SEL', 'SOLPD.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_TIPOEJE_UPD', 'SOLPD.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_GES_SEL', 'SOLPD.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_PER_SEL', 'SOLPD.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_TIPO_SEL', 'SOLPD.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_CONIGPAR_SEL', 'SOLPD.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'OR_OFCU_SEL', 'SOLPD.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_LUG_SEL', 'SOLPD.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'PM_CONIGPAR_SEL', 'SOLPD.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_GENCONF_IME', 'SOLPD.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'TES_PPANTPAR_INS', 'SOLPD.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'MIG_CBANESIS_SEL', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_PPANTPAR_INS', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'TES_GENCONF_IME', 'VBDP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Ppagos (Asistentes)', 'TES_GENCONF_IME', 'REVBPP');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_VERSIGPRO_IME', 'VBDP.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_DOCWFAR_MOD', 'VBDP.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_CHKSTA_IME', 'VBDP.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_TIPES_SEL', 'VBDP.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_FUNTIPES_SEL', 'VBDP.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_DEPTIPES_SEL', 'VBDP.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Plan de Pagos', 'WF_DOCWFAR_MOD', 'VBDP.4');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_GATNREP_SEL', 'VBDP.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_PLT_SEL', 'VBDP.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_OBPG_INS', 'VBDP.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_OBPG_MOD', 'VBDP.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_OBPG_ELI', 'VBDP.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_OBPG_SEL', 'VBDP.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_OBPGSOL_SEL', 'VBDP.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_OBPGSEL_SEL', 'VBDP.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_PLAPAOB_SEL', 'VBDP.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_OBTTCB_GET', 'VBDP.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_FINREG_IME', 'VBDP.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_ANTEOB_IME', 'VBDP.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_IDSEXT_GET', 'VBDP.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'ADQ_COTOC_REP', 'VBDP.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'ADQ_CTD_SEL', 'VBDP.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'ADQ_COTREP_SEL', 'VBDP.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'ADQ_SOLREP_SEL', 'VBDP.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'ADQ_SOLD_SEL', 'VBDP.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'ADQ_SOLDETCOT_SEL', 'VBDP.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PRE_VERPRE_IME', 'VBDP.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'ADQ_PROCPED_SEL', 'VBDP.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'ADQ_COT_SEL', 'VBDP.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'ADQ_COTPROC_SEL', 'VBDP.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'ADQ_COTRPC_SEL', 'VBDP.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_DEPUSUCOMB_SEL', 'VBDP.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'RH_FUNCIOCAR_SEL', 'VBDP.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_MONEDA_SEL', 'VBDP.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_PROVEEV_SEL', 'VBDP.6');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_SERVIC_SEL', 'VBDP.6.7');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SAL_ITEMNOTBASE_SEL', 'VBDP.6.7');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_LUG_SEL', 'VBDP.6.7');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_LUG_ARB_SEL', 'VBDP.6.7');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_PROVEE_INS', 'VBDP.6.7');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_PROVEE_MOD', 'VBDP.6.7');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_PROVEE_ELI', 'VBDP.6.7');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_PROVEE_SEL', 'VBDP.6.7');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_PROVEEV_SEL', 'VBDP.6.7');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_PERSON_SEL', 'VBDP.6.7');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_PERSONMIN_SEL', 'VBDP.6.7');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_INSTIT_SEL', 'VBDP.6.7');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_INSTIT_INS', 'VBDP.6.7.3');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_INSTIT_MOD', 'VBDP.6.7.3');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_INSTIT_ELI', 'VBDP.6.7.3');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_INSTIT_SEL', 'VBDP.6.7.3');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_PERSON_SEL', 'VBDP.6.7.3');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_PERSONMIN_SEL', 'VBDP.6.7.3');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_PERSON_INS', 'VBDP.6.7.3.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_PERSON_MOD', 'VBDP.6.7.3.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_PERSON_ELI', 'VBDP.6.7.3.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_PERSONMIN_SEL', 'VBDP.6.7.3.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_UPFOTOPER_MOD', 'VBDP.6.7.3.1.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_PERSON_ELI', 'VBDP.6.7.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_PERSONMIN_SEL', 'VBDP.6.7.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_PERSON_INS', 'VBDP.6.7.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_PERSON_MOD', 'VBDP.6.7.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SEG_UPFOTOPER_MOD', 'VBDP.6.7.2.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SAL_ITEM_SEL', 'VBDP.6.7.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SAL_ITEMNOTBASE_SEL', 'VBDP.6.7.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'SAL_ITMALM_SEL', 'VBDP.6.7.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_SERVIC_SEL', 'VBDP.6.7.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_PRITSE_INS', 'VBDP.6.7.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_PRITSE_MOD', 'VBDP.6.7.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_PRITSE_ELI', 'VBDP.6.7.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_PRITSE_SEL', 'VBDP.6.7.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PRE_VERPRE_SEL', 'VBDP.6.6');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DWF_MOD', 'VBDP.6.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DWF_ELI', 'VBDP.6.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DWF_SEL', 'VBDP.6.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_CABMOM_IME', 'VBDP.6.5');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DES_ELI', 'VBDP.6.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DES_SEL', 'VBDP.6.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_TIPPROC_SEL', 'VBDP.6.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_TIPES_SEL', 'VBDP.6.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DES_INS', 'VBDP.6.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DES_MOD', 'VBDP.6.5.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DOCWFAR_MOD', 'VBDP.6.5.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_PAFPP_IME', 'VBDP.6.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'CONTA_GETDEC_IME', 'VBDP.6.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_PLT_SEL', 'VBDP.6.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_CTABAN_SEL', 'VBDP.6.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'MIG_CBANESIS_SEL', 'VBDP.6.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_PLAPA_INS', 'VBDP.6.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_PLAPAPA_INS', 'VBDP.6.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_PPANTPAR_INS', 'VBDP.6.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_PLAPA_MOD', 'VBDP.6.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_PLAPA_ELI', 'VBDP.6.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_PLAPA_SEL', 'VBDP.6.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_SINPRE_IME', 'VBDP.6.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_ANTEPP_IME', 'VBDP.6.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_SIGEPP_IME', 'VBDP.6.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_PLAPAREP_SEL', 'VBDP.6.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_PRO_SEL', 'VBDP.6.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_GENCONF_IME', 'VBDP.6.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DWF_MOD', 'VBDP.6.4.5');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DWF_ELI', 'VBDP.6.4.5');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DWF_SEL', 'VBDP.6.4.5');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_CABMOM_IME', 'VBDP.6.4.5');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_TIPPROC_SEL', 'VBDP.6.4.5.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_TIPES_SEL', 'VBDP.6.4.5.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DES_INS', 'VBDP.6.4.5.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DES_MOD', 'VBDP.6.4.5.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DES_ELI', 'VBDP.6.4.5.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DES_SEL', 'VBDP.6.4.5.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DOCWFAR_MOD', 'VBDP.6.4.5.1');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DOCWFAR_MOD', 'VBDP.6.4.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_VERSIGPRO_IME', 'VBDP.6.4.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_CHKSTA_IME', 'VBDP.6.4.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_TIPES_SEL', 'VBDP.6.4.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_FUNTIPES_SEL', 'VBDP.6.4.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DEPTIPES_SEL', 'VBDP.6.4.4');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'WF_DOCWFAR_MOD', 'VBDP.6.4.3');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_PRO_SEL', 'VBDP.6.4.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_PRO_MOD', 'VBDP.6.4.2');
select pxp.f_delete_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PRE_VERPRE_SEL', 'VBDP.6.4.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_CECCOM_SEL', 'VBDP.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_CECCOMFU_SEL', 'VBDP.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_CCFILDEP_SEL', 'VBDP.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_CONIGPAR_SEL', 'VBDP.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'CONTA_CTA_SEL', 'VBDP.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'CONTA_CTA_ARB_SEL', 'VBDP.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PRE_PAR_SEL', 'VBDP.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PRE_PAR_ARB_SEL', 'VBDP.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'CONTA_AUXCTA_SEL', 'VBDP.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_OBDET_INS', 'VBDP.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_OBDET_MOD', 'VBDP.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_OBDET_ELI', 'VBDP.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_OBDET_SEL', 'VBDP.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_CEC_SEL', 'VBDP.6.3');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_TIPO_SEL', 'VBDP.6.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_CONIGPAR_SEL', 'VBDP.6.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'OR_OFCU_SEL', 'VBDP.6.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_LUG_SEL', 'VBDP.6.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_LUG_ARB_SEL', 'VBDP.6.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_TIPOEJE_UPD', 'VBDP.6.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_GES_SEL', 'VBDP.6.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_PER_SEL', 'VBDP.6.3.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_OBPGSEL_SEL', 'VBDP.6.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_OBPG_SEL', 'VBDP.6.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_OBPGSOL_SEL', 'VBDP.6.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_COMEJEPAG_SEL', 'VBDP.6.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_MONEDA_SEL', 'VBDP.6.2');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_OBDET_ELI', 'VBDP.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_OBDET_SEL', 'VBDP.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_CEC_SEL', 'VBDP.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_CECCOM_SEL', 'VBDP.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_CECCOMFU_SEL', 'VBDP.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_OBDETAPRO_MOD', 'VBDP.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_CCFILDEP_SEL', 'VBDP.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_CONIGPAR_SEL', 'VBDP.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'CONTA_CTA_SEL', 'VBDP.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'CONTA_CTA_ARB_SEL', 'VBDP.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PRE_PAR_SEL', 'VBDP.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PRE_PAR_ARB_SEL', 'VBDP.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'CONTA_AUXCTA_SEL', 'VBDP.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_OBDET_INS', 'VBDP.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_OBDET_MOD', 'VBDP.6.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_TIPO_SEL', 'VBDP.6.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_CONIGPAR_SEL', 'VBDP.6.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'OR_OFCU_SEL', 'VBDP.6.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_LUG_SEL', 'VBDP.6.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_LUG_ARB_SEL', 'VBDP.6.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'TES_TIPOEJE_UPD', 'VBDP.6.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_GES_SEL', 'VBDP.6.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - VoBo Pago Contabilidad', 'PM_PER_SEL', 'VBDP.6.1.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Solicitudes de Pago Directas', 'CONTA_ODT_SEL', 'SOLPD.1');
select pxp.f_insert_trol_procedimiento_gui ('OP - Reporte Pagos X Concepto', 'PM_CONIGPAR_SEL', 'REPPAGCON');
select pxp.f_insert_trol_procedimiento_gui ('OP - Reporte Pagos X Concepto', 'PM_GES_SEL', 'REPPAGCON');
select pxp.f_insert_trol_procedimiento_gui ('OP - Reporte Pagos X Concepto', 'TES_PAXCIG_SEL', 'REPPAGCON.1');

/***********************************F-DEP-RAC-TES-0-27/11/2014****************************************/





/***********************************I-DEP-RAC-TES-0-22/12/2014****************************************/
CREATE VIEW tes.vpago_x_proveedor (
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
    monto_presupuestado)
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
    ) AS monto_presupuestado
FROM tes.tobligacion_pago op
   JOIN param.tgestion ges ON ges.id_gestion = op.id_gestion
   LEFT JOIN adq.tcotizacion cot ON cot.id_obligacion_pago = op.id_obligacion_pago
   JOIN param.vproveedor pro ON pro.id_proveedor = op.id_proveedor
   JOIN segu.tusuario usu ON usu.id_usuario = op.id_usuario_reg
   JOIN param.tmoneda mon ON mon.id_moneda = op.id_moneda
   JOIN tes.tplan_pago ppp ON ppp.id_obligacion_pago = op.id_obligacion_pago
       AND ppp.estado_reg::text = 'activo'::text;
       
/***********************************F-DEP-RAC-TES-0-22/12/2014****************************************/

/***********************************I-DEP-GSS-TES-0-19/01/2015****************************************/
CREATE VIEW tes.vlibro_bancos (
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
    sistema_origen)
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
            WHEN lban.tipo::text = 'deposito'::text THEN lban.importe_deposito
                - COALESCE((
    SELECT COALESCE(sum(lb.importe_cheque), 0::numeric) AS "coalesce"
    FROM tes.tts_libro_bancos lb
    WHERE lb.id_libro_bancos_fk = lban.id_libro_bancos AND lb.tipo::text <>
        'deposito'::text
    ), 0::numeric) + COALESCE((
    SELECT COALESCE(sum(lb.importe_deposito), 0::numeric) AS "coalesce"
    FROM tes.tts_libro_bancos lb
    WHERE lb.id_libro_bancos_fk = lban.id_libro_bancos AND lb.tipo::text =
        'deposito'::text
    ), 0::numeric)
            WHEN (lban.tipo::text = ANY (ARRAY['cheque'::character varying,
                'debito_automatico'::character varying, 'transferencia_carta'::character varying]::text[])) AND lban.id_libro_bancos_fk IS NOT NULL THEN ((
    SELECT COALESCE(lb.importe_deposito, 0::numeric) AS "coalesce"
    FROM tes.tts_libro_bancos lb
    WHERE lb.id_libro_bancos = lban.id_libro_bancos_fk
    )) + ((
    SELECT COALESCE(sum(lb.importe_deposito), 0::numeric) AS "coalesce"
    FROM tes.tts_libro_bancos lb
    WHERE lb.id_libro_bancos_fk = lban.id_libro_bancos_fk AND lb.tipo::text =
        'deposito'::text
    )) - ((
    SELECT sum(lb2.importe_cheque) AS sum
    FROM tes.tts_libro_bancos lb2
    WHERE lb2.id_libro_bancos <= lban.id_libro_bancos AND
        lb2.id_libro_bancos_fk = lban.id_libro_bancos_fk AND lb2.tipo::text <> 'deposito'::text
    ))
            ELSE 0::numeric
        END AS saldo_deposito,
    reg.nombre_regional,
    lban.sistema_origen
FROM tes.tts_libro_bancos lban
   JOIN segu.tusuario usu1 ON usu1.id_usuario = lban.id_usuario_reg
   LEFT JOIN param.tdepto depto ON depto.id_depto = lban.id_depto
   LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = lban.id_usuario_mod
   JOIN tes.tfinalidad fin ON fin.id_finalidad = lban.id_finalidad
   LEFT JOIN param.tregional reg ON reg.codigo_regional::text = lban.origen::text;
  
/***********************************F-DEP-GSS-TES-0-19/01/2015****************************************/

/***********************************I-DEP-JRR-TES-0-23/01/2015****************************************/

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
    id_funcionario_gerente)
AS
  SELECT pp.id_plan_pago,
         op.id_proveedor,
         COALESCE(p.desc_proveedor, '' ::character varying) AS desc_proveedor,
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
         ((COALESCE(op.numero, '' ::character varying) ::text || ' ' ::text) ||
          COALESCE(pp.obs_monto_no_pagado, '' ::text)) ::character varying AS
           obs_pp,
         pp.descuento_anticipo,
         pp.descuento_inter_serv,
         op.tipo_obligacion,
         op.id_categoria_compra,
         COALESCE(cac.codigo, '' ::character varying) AS codigo_categoria,
         COALESCE(cac.nombre, '' ::character varying) AS nombre_categoria,
         pp.id_proceso_wf,
         ('<table>' ::text || pxp.html_rows((((('<td>' ::text ||
          ci.desc_ingas::text) || '<br/>' ::text) || od.descripcion) || '</td>'
           ::text) ::character varying) ::text) || '</table>' ::text AS detalle,
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
         COALESCE(op.id_funcionario_gerente, 0) AS id_funcionario_gerente
  FROM tes.tplan_pago pp
       JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago =
        op.id_obligacion_pago
       JOIN param.tmoneda mon ON mon.id_moneda = op.id_moneda
       LEFT JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor
       LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
        op.id_categoria_compra
       JOIN tes.tobligacion_det od ON od.id_obligacion_pago =
        op.id_obligacion_pago AND od.estado_reg::text = 'activo' ::text
       JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas =
        od.id_concepto_ingas
       JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario =
        op.id_funcionario AND fun.estado_reg_asi::text = 'activo' ::text
       JOIN segu.vusuario usu ON usu.id_usuario = op.id_usuario_reg
  GROUP BY pp.id_plan_pago,
           op.id_proveedor,
           p.desc_proveedor,
           op.id_moneda,
           op.id_depto_conta,
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
           op.id_funcionario_gerente;  

/***********************************F-DEP-JRR-TES-0-23/01/2015****************************************/

/***********************************I-DEP-JRR-TES-0-04/02/2015****************************************/
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
    fecha_conformidad,
    conformidad,
    sw_conformidad)
AS
  SELECT pp.id_plan_pago,
         op.id_proveedor,
         COALESCE(p.desc_proveedor, '' ::character varying) AS desc_proveedor,
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
         ((COALESCE(op.numero, '' ::character varying) ::text || ' ' ::text) ||
          COALESCE(pp.obs_monto_no_pagado, '' ::text)) ::character varying AS
           obs_pp,
         pp.descuento_anticipo,
         pp.descuento_inter_serv,
         op.tipo_obligacion,
         op.id_categoria_compra,
         COALESCE(cac.codigo, '' ::character varying) AS codigo_categoria,
         COALESCE(cac.nombre, '' ::character varying) AS nombre_categoria,
         pp.id_proceso_wf,
         ('<table>' ::text || pxp.html_rows((((('<td>' ::text ||
          ci.desc_ingas::text) || '<br/>' ::text) || od.descripcion) || '</td>'
           ::text) ::character varying) ::text) || '</table>' ::text AS detalle,
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
         pp.fecha_conformidad,
         pp.conformidad,
         CASE
           WHEN pp.fecha_conformidad IS NOT NULL THEN 'si' ::character varying
           ELSE 'no' ::character varying
         END AS sw_conformidad
  FROM tes.tplan_pago pp
       JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago =
        op.id_obligacion_pago
       JOIN param.tmoneda mon ON mon.id_moneda = op.id_moneda
       LEFT JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor
       LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
        op.id_categoria_compra
       JOIN tes.tobligacion_det od ON od.id_obligacion_pago =
        op.id_obligacion_pago AND od.estado_reg::text = 'activo' ::text
       JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas =
        od.id_concepto_ingas
       JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario =
        op.id_funcionario AND fun.estado_reg_asi::text = 'activo' ::text
       JOIN segu.vusuario usu ON usu.id_usuario = op.id_usuario_reg
  GROUP BY pp.id_plan_pago,
           op.id_proveedor,
           p.desc_proveedor,
           op.id_moneda,
           op.id_depto_conta,
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
           pp.fecha_conformidad,
           pp.conformidad;
           
/***********************************F-DEP-JRR-TES-0-04/02/2015****************************************/