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




/***********************************I-DEP-RAC-TES-1-19/08/2014***************************************/

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
           op.tipo_concepto_solicitud;

/***********************************F-DEP-RAC-TES-1-19/08/2014***************************************/



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



DROP VIEW  IF EXISTS tes.vcuenta_bancaria;

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
DROP VIEW  IF EXISTS tes.vpago_pendientes_al_dia;
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

DROP VIEW  IF EXISTS tes.vcomp_devtesprov_plan_pago_2;
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
DROP VIEW IF EXISTS tes.vpagos_relacionados;
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
DROP VIEW IF EXISTS tes.vproceso_caja;
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
DROP VIEW IF EXISTS tes.vsrd_doc_compra_venta;
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
/*
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
*/

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
    
    
 
select pxp.f_insert_testructura_gui ('TES', 'SISTEMA');
select pxp.f_insert_testructura_gui ('REPPP', 'REPOP');
select pxp.f_insert_testructura_gui ('REPPPBA', 'REPOP');
select pxp.f_insert_testructura_gui ('REPPAGCON', 'REPOP');
select pxp.f_insert_testructura_gui ('CAROP', 'TES');
select pxp.f_insert_testructura_gui ('CARLB', 'TES');
select pxp.f_insert_testructura_gui ('CARFR', 'TES');
select pxp.f_insert_testructura_gui ('CTABAN', 'CARLB');
select pxp.f_insert_testructura_gui ('CTABANE', 'CARLB');
select pxp.f_insert_testructura_gui ('CTABANCEND', 'CARLB');
select pxp.f_insert_testructura_gui ('CAJA', 'CARFR');
select pxp.f_insert_testructura_gui ('SOLCAJA', 'CARFR');
select pxp.f_insert_testructura_gui ('VBCAJA', 'CARFR');
select pxp.f_insert_testructura_gui ('SOLEFE', 'CARFR');
select pxp.f_insert_testructura_gui ('SOLEFESD', 'CARFR');
select pxp.f_insert_testructura_gui ('VBSOLEFE', 'CARFR');
select pxp.f_insert_testructura_gui ('VBRENCJ', 'CARFR');
select pxp.f_insert_testructura_gui ('REPOP', 'CAROP');
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
select pxp.f_insert_testructura_gui ('FINCUE', 'CARLB');
select pxp.f_insert_testructura_gui ('VBCJ', 'CARFR');
select pxp.f_insert_testructura_gui ('VBCP', 'CARFR');
select pxp.f_insert_testructura_gui ('VBFACREN', 'CARFR');
select pxp.f_insert_testructura_gui ('VBRENCJA', 'CARFR');
select pxp.f_insert_testructura_gui ('COFCAJA', 'CARFR');
select pxp.f_insert_testructura_gui ('TPSOL', 'COFCAJA');
select pxp.f_insert_testructura_gui ('TPC', 'COFCAJA');
select pxp.f_insert_testructura_gui ('INGCAJ', 'CARFR');
select pxp.f_insert_testructura_gui ('TESREPFR', 'CARFR');
select pxp.f_insert_testructura_gui ('REPMOVCA', 'TESREPFR');
select pxp.f_insert_testructura_gui ('TESOLTRA', 'CARLB');
select pxp.f_insert_testructura_gui ('TEAPROTRA', 'CARLB');
select pxp.f_insert_testructura_gui ('REPLIB', 'CARLB');
select pxp.f_insert_testructura_gui ('REPLB', 'CARLB');
select pxp.f_insert_testructura_gui ('PAGESP', 'CAROPSOL');
select pxp.f_insert_testructura_gui ('RCRF', 'TESREPFR');


/**********************************F-DEP-RAC-TES-0-01/12/2018****************************************/


/**********************************I-DEP-CAP-TES-0-04/12/2018****************************************/

DROP VIEW tes.vcomp_devtesprov_plan_pago;

CREATE OR REPLACE VIEW tes.vcomp_devtesprov_plan_pago (
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
    ((COALESCE(op.numero, ''::character varying)::text || ' '::text) || COALESCE(pp.obs_monto_no_pagado, ''::text))::character varying AS obs_pp,
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
     JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago = op.id_obligacion_pago
     JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor
     LEFT JOIN tes.tplan_pago pr ON pr.id_plan_pago = pp.id_plan_pago_fk
     LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra = op.id_categoria_compra;

DROP VIEW tes.vcomp_devtesprov_plan_pago_2;

CREATE OR REPLACE VIEW tes.vcomp_devtesprov_plan_pago_2 (
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
    ((COALESCE(op.numero, ''::character varying)::text || ' '::text) || COALESCE(pp.obs_monto_no_pagado, ''::text))::character varying AS obs_pp,
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
   <TH>Importe ('::text || mon.codigo::text) || ')</TH>'::text) || pxp.html_rows(((((((((('<td>'::text || ci.desc_ingas::text) || '</td>
       <td>'::text) || '<font hdden=true>'::text) || od.id_obligacion_det::character varying::text) || '</font>'::text) || od.descripcion) || '</td> <td>'::text) || od.monto_pago_mo::text) || '</td>'::text)::character varying)::text) || '</table>'::text AS detalle,
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
    COALESCE(deplb.prioridad, '-1'::integer) AS prioridad_lb,
    pp.id_depto_lb
   FROM tes.tplan_pago pp
     JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago = op.id_obligacion_pago
     JOIN param.tmoneda mon ON mon.id_moneda = op.id_moneda
     JOIN param.tdepto dep ON dep.id_depto = op.id_depto
     LEFT JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor
     LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra = op.id_categoria_compra
     LEFT JOIN adq.tcotizacion cot ON op.id_obligacion_pago = cot.id_obligacion_pago
     LEFT JOIN adq.tproceso_compra pro ON pro.id_proceso_compra = cot.id_proceso_compra
     LEFT JOIN adq.tsolicitud sol ON sol.id_solicitud = pro.id_solicitud
     LEFT JOIN segu.vusuario ususol ON ususol.id_usuario = sol.id_usuario_reg
     LEFT JOIN param.tdepto deplb ON deplb.id_depto = pp.id_depto_lb
     JOIN tes.tobligacion_det od ON od.id_obligacion_pago = op.id_obligacion_pago AND od.estado_reg::text = 'activo'::text
     JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas = od.id_concepto_ingas
     JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario = op.id_funcionario AND fun.estado_reg_asi::text = 'activo'::text
     JOIN segu.vusuario usu ON usu.id_usuario = op.id_usuario_reg
  GROUP BY pp.id_plan_pago, op.id_proveedor, p.desc_proveedor, op.id_moneda, pp.id_depto_conta, op.numero, pp.estado, pp.monto_ejecutar_total_mb, pp.monto_ejecutar_total_mo, pp.monto, pp.monto_mb, pp.monto_retgar_mb, pp.monto_retgar_mo, pp.monto_no_pagado, pp.monto_no_pagado_mb, pp.otros_descuentos, pp.otros_descuentos_mb, pp.id_plantilla, pp.id_cuenta_bancaria, pp.id_cuenta_bancaria_mov, pp.nro_cheque, pp.nro_cuenta_bancaria, op.num_tramite, pp.tipo, op.id_gestion, pp.id_int_comprobante, pp.liquido_pagable, pp.liquido_pagable_mb, pp.nombre_pago, pp.porc_monto_excento_var, pp.obs_monto_no_pagado, pp.descuento_anticipo, pp.descuento_inter_serv, op.tipo_obligacion, op.id_categoria_compra, cac.codigo, cac.nombre, pp.id_proceso_wf, mon.codigo, pp.nro_cuota, pp.tipo_pago, op.total_pago, op.tipo_solicitud, op.tipo_concepto_solicitud, pp.fecha_tentativa, fun.desc_funcionario1, fun.email_empresa, usu.desc_persona, op.id_funcionario_gerente, ususol.correo, op.ultima_cuota_pp, op.ultima_cuota_dev, pp.tiene_form500, dep.prioridad, deplb.prioridad;


DROP VIEW tes.vobligacion_pago;

CREATE OR REPLACE VIEW tes.vobligacion_pago (
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
   <TH>Importe ('::text || mon.codigo::text) || ')</TH>'::text) || pxp.html_rows(((((((((('<td>'::text || ci.desc_ingas::text) || '</td>
       <td>'::text) || '<font hdden=true>'::text) || od.id_obligacion_det::character varying::text) || '</font>'::text) || od.descripcion) || '</td> <td>'::text) || od.monto_pago_mo::text) || '</td>'::text)::character varying)::text) || '</table>'::text AS detalle
   FROM tes.tobligacion_pago op
     JOIN param.tmoneda mon ON mon.id_moneda = op.id_moneda
     JOIN param.tdepto dep ON dep.id_depto = op.id_depto
     LEFT JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor
     LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra = op.id_categoria_compra
     LEFT JOIN adq.tcotizacion cot ON op.id_obligacion_pago = cot.id_obligacion_pago
     LEFT JOIN adq.tproceso_compra pro ON pro.id_proceso_compra = cot.id_proceso_compra
     LEFT JOIN adq.tsolicitud sol ON sol.id_solicitud = pro.id_solicitud
     LEFT JOIN segu.vusuario ususol ON ususol.id_usuario = sol.id_usuario_reg
     JOIN tes.tobligacion_det od ON od.id_obligacion_pago = op.id_obligacion_pago AND od.estado_reg::text = 'activo'::text
     JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas = od.id_concepto_ingas
     JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario = op.id_funcionario AND fun.estado_reg_asi::text = 'activo'::text
     JOIN segu.vusuario usu ON usu.id_usuario = op.id_usuario_reg
  GROUP BY op.id_usuario_reg, op.id_usuario_mod, op.fecha_reg, op.fecha_mod, op.estado_reg, op.id_usuario_ai, op.usuario_ai, op.id_obligacion_pago, op.id_proveedor, op.id_funcionario, op.id_subsistema, op.id_moneda, op.id_depto, op.id_estado_wf, op.id_proceso_wf, op.id_gestion, op.fecha, op.numero, op.estado, op.obs, op.porc_anticipo, op.porc_retgar, op.tipo_cambio_conv, op.num_tramite, op.tipo_obligacion, op.comprometido, op.pago_variable, op.nro_cuota_vigente, op.total_pago, op.id_depto_conta, op.total_nro_cuota, op.id_plantilla, op.fecha_pp_ini, op.rotacion, op.ultima_cuota_pp, op.ultimo_estado_pp, op.tipo_anticipo, op.id_categoria_compra, op.tipo_solicitud, op.tipo_concepto_solicitud, op.id_funcionario_gerente, op.ajuste_anticipo, op.ajuste_aplicado, op.id_obligacion_pago_extendida, op.monto_estimado_sg, op.monto_ajuste_ret_garantia_ga, op.monto_ajuste_ret_anticipo_par_ga, op.id_contrato, op.obs_presupuestos, op.ultima_cuota_dev, op.codigo_poa, op.obs_poa, op.uo_ex, mon.codigo;


DROP VIEW tes.vpagos_relacionados;

CREATE OR REPLACE VIEW tes.vpagos_relacionados (
    desc_proveedor,
    num_tramite,
    estado,
    fecha_tentativa,
    nro_cuota,
    monto,
    monto_mb,
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
 WITH detalle AS (
         SELECT op_1.id_obligacion_pago,
            pxp.list(cig.desc_ingas::text) AS conceptos,
            pxp.list(ot.desc_orden::text) AS ordenes,
            pxp.aggarray(od.id_orden_trabajo::text) AS id_orden_trabajos,
            pxp.aggarray(od.id_concepto_ingas::text) AS id_concepto_ingas
           FROM tes.tobligacion_pago op_1
             JOIN tes.tobligacion_det od ON od.id_obligacion_pago = op_1.id_obligacion_pago
             JOIN param.tconcepto_ingas cig ON cig.id_concepto_ingas = od.id_concepto_ingas
             LEFT JOIN conta.torden_trabajo ot ON ot.id_orden_trabajo = od.id_orden_trabajo
          GROUP BY op_1.id_obligacion_pago
        )
 SELECT prov.desc_proveedor,
    op.num_tramite,
    pp.estado,
    COALESCE(pp.fecha_tentativa, op.fecha) AS fecha_tentativa,
    pp.nro_cuota,
    pp.monto,
    param.f_convertir_moneda(op.id_moneda, 1, pp.monto, op.fecha, 'O'::character varying, 2) AS monto_mb,
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

DROP VIEW tes.vproceso_caja;

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
    id_depto_lb,
    monto_ren_ingreso)
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
    pc.monto AS monto_reposicion,
    pc.nro_tramite,
    f.desc_funcionario1 AS nombre_cajero,
    ca.id_depto_lb,
    pc.monto_ren_ingreso
   FROM tes.tproceso_caja pc
     JOIN tes.tcaja ca ON pc.id_caja = ca.id_caja
     JOIN tes.tcajero c ON c.id_caja = ca.id_caja AND c.tipo::text = 'responsable'::text
     JOIN orga.vfuncionario f ON f.id_funcionario = c.id_funcionario
  WHERE pc.fecha >= c.fecha_inicio AND pc.fecha <= c.fecha_fin OR pc.fecha >= c.fecha_inicio AND c.fecha_fin IS NULL;

DROP VIEW tes.vsrd_doc_compra_venta_det;

CREATE OR REPLACE VIEW tes.vsrd_doc_compra_venta_det (
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
    porc_monto_excento_var,
    nro_tramite_se)
AS
 SELECT srd.id_solicitud_rendicion_det,
    srd.id_proceso_caja,
    dcv.id_moneda,
    dcv.id_int_comprobante,
    dcv.id_plantilla,
    dcv.importe_doc,
    dcv.importe_excento,
    COALESCE(dcv.importe_excento, 0::numeric) + COALESCE(dcv.importe_ice, 0::numeric) AS importe_total_excento,
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
    (((((((dcv.razon_social::text || ' - '::text) || cig.desc_ingas::text) || ' ( '::text) || dco.descripcion) || ' ) Nro Doc: '::text) || COALESCE(dcv.nro_documento)::text) || ' Nt: '::text) || COALESCE(se.nro_tramite, ''::character varying)::text AS descripcion,
    dcv.importe_neto,
    dcv.importe_anticipo,
    dcv.importe_pendiente,
    dcv.importe_retgar,
    dco.precio_total_final,
    (COALESCE(dcv.importe_excento, 0::numeric) + COALESCE(dcv.importe_ice, 0::numeric)) / dcv.importe_neto AS porc_monto_excento_var,
    se.nro_tramite AS nro_tramite_se
   FROM tes.tsolicitud_rendicion_det srd
     JOIN tes.tsolicitud_efectivo se ON se.id_solicitud_efectivo = srd.id_solicitud_efectivo
     JOIN conta.tdoc_compra_venta dcv ON srd.id_documento_respaldo = dcv.id_doc_compra_venta
     JOIN conta.tdoc_concepto dco ON dco.id_doc_compra_venta = dcv.id_doc_compra_venta
     JOIN param.tconcepto_ingas cig ON cig.id_concepto_ingas = dco.id_concepto_ingas;


ALTER TABLE tes.tobligacion_pago
  DROP CONSTRAINT chk_tobligacion_pago__tipo_obligacion RESTRICT;
/*
ALTER TABLE tes.tobligacion_pago
  ADD CONSTRAINT tobligacion_pago_fk FOREIGN KEY (id_contrato)
    REFERENCES leg.tcontrato(id_contrato)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
*/
ALTER TABLE tes.tobligacion_pago
  ADD CONSTRAINT chk_tobligacion_pago__tipo_obligacion CHECK ((tipo_obligacion)::text = ANY (ARRAY[('adquisiciones'::character varying)::text, ('pago_unico'::character varying)::text, ('pago_especial'::character varying)::text, ('caja_chica'::character varying)::text, ('viaticos'::character varying)::text, ('fondos_en_avance'::character varying)::text, ('pago_directo'::character varying)::text, ('rrhh'::character varying)::text]));

CREATE TRIGGER f_trig_tsolicitud_efectivo_before
  BEFORE INSERT OR UPDATE 
  ON tes.tsolicitud_efectivo
  
FOR EACH ROW 
  EXECUTE PROCEDURE tes.f_trig_solicitud_efectivo_before();

CREATE INDEX tts_libro_bancos_idx__tipo ON tes.tts_libro_bancos
  USING btree (tipo COLLATE pg_catalog."default");

CREATE INDEX tts_libro_bancos_idx__origen ON tes.tts_libro_bancos
  USING btree (origen COLLATE pg_catalog."default");

CREATE INDEX tts_libro_bancos_idx__id_libro_bancos_fk ON tes.tts_libro_bancos
  USING btree (id_libro_bancos_fk);

CREATE INDEX tts_libro_bancos_idx__id_finalidad ON tes.tts_libro_bancos
  USING btree (id_finalidad);

CREATE INDEX tts_libro_bancos_idx__id_depto ON tes.tts_libro_bancos
  USING btree (id_depto);

CREATE INDEX tts_libro_bancos_idx__fecha ON tes.tts_libro_bancos
  USING btree (fecha, id_libro_bancos_fk, id_cuenta_bancaria);

CREATE UNIQUE INDEX tts_libro_bancos_idx ON tes.tts_libro_bancos
  USING btree (id_cuenta_bancaria, nro_cheque);

CREATE INDEX idx_tts_libro_bancos__id_libro_bancos_fk ON tes.tts_libro_bancos
  USING btree (id_libro_bancos_fk);

CREATE INDEX idx_tts_libro_bancos__id_finalidad ON tes.tts_libro_bancos
  USING btree (id_finalidad);


/**********************************F-DEP-CAP-TES-0-04/12/2018****************************************/

/***********************************I-DEP-JJA-TES-0-05/12/2018****************************************/
select pxp.f_insert_testructura_gui ('CONPLAPAG', 'REPOP');
/***********************************F-DEP-JJA-TES-0-05/12/2018****************************************/


/**********************************I-DEP-EGS-TES-0-28/03/2019****************************************/
---se agrego campo descuento de ley----------
CREATE OR REPLACE VIEW tes.vcomp_devtesprov_plan_pago (
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
    id_int_comprobante_rel,
    descuento_ley)
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
    ((COALESCE(op.numero, ''::character varying)::text || ' '::text) || COALESCE(pp.obs_monto_no_pagado, ''::text))::character varying AS obs_pp,
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
    pr.id_int_comprobante AS id_int_comprobante_rel,
    pp.descuento_ley
   FROM tes.tplan_pago pp
     JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago = op.id_obligacion_pago
     JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor
     LEFT JOIN tes.tplan_pago pr ON pr.id_plan_pago = pp.id_plan_pago_fk
     LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra = op.id_categoria_compra;

/**********************************F-DEP-EGS-TES-0-28/03/2019****************************************/



/**********************************I-DEP-RAC-TES-0-25/07/2019****************************************/

--------------- SQL ---------------

 -- object recreation
DROP VIEW tes.vcomp_devtesprov_det_plan_pago;

CREATE VIEW tes.vcomp_devtesprov_det_plan_pago
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
         od.id_orden_trabajo,
         ci.id_taza_impuesto
  FROM tes.tprorrateo pro
  JOIN tes.tobligacion_det od ON od.id_obligacion_det = pro.id_obligacion_det
  JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas = od.id_concepto_ingas;

ALTER TABLE tes.vcomp_devtesprov_det_plan_pago
  OWNER TO postgres;

GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES, TRIGGER, TRUNCATE
  ON tes.vcomp_devtesprov_det_plan_pago TO postgres;
GRANT SELECT
  ON tes.vcomp_devtesprov_det_plan_pago TO lectura;
  
  
/**********************************F-DEP-RAC-TES-0-25/07/2019****************************************/




/**********************************I-DEP-RAC-TES-45-27/01/2020****************************************/

CREATE OR REPLACE VIEW tes.vsrd_doc_compra_venta_efectivo_provisorio_det_v2(
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
    nro_tramite_auxiliar,
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
         COALESCE(dcv.importe_excento, 0::NUMERIC) + COALESCE(dcv.importe_ice, 0
           ::NUMERIC) AS importe_total_excento,
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
         (((dcv.razon_social::TEXT || ' - '::TEXT) || ' ( '::TEXT) ||
           ' ) Nro Doc: '::TEXT) || COALESCE(dcv.nro_documento)::TEXT AS
           descripcion,
         sol.nro_tramite AS nro_tramite_auxiliar,
         dcv.importe_neto,
         dcv.id_auxiliar
  FROM tes.tsolicitud_rendicion_det srd
       JOIN conta.tdoc_compra_venta dcv ON srd.id_documento_respaldo =
         dcv.id_doc_compra_venta
       JOIN param.tplantilla pl ON pl.id_plantilla = dcv.id_plantilla
       JOIN tes.tsolicitud_efectivo sol ON sol.id_solicitud_efectivo =
         srd.id_solicitud_efectivo
  WHERE pl.tipo_informe::TEXT = 'efectivo'::TEXT;
 

/**********************************F-DEP-RAC-TES-45-27/01/2020****************************************/


/**********************************I-DEP-RAC-TES-59-10/03/2020****************************************/


with plan_pago_proveedor as (
  select
    op.id_proveedor,
    op.id_obligacion_pago,
    pp.id_plan_pago,
    pp.id_int_comprobante,
    prov.nombre as nombre_proveedor,
    cbt.beneficiario,
    cbt.glosa1
  from tes.tobligacion_pago op
  join param.vproveedor prov on prov.id_proveedor = op.id_proveedor 
  join tes.tplan_pago pp on pp.id_obligacion_pago = op.id_obligacion_pago
  join conta.tint_comprobante cbt on cbt.id_int_comprobante = pp.id_int_comprobante


),
cbte_relacionado as (
  select 
   cbo.id_int_comprobante,
   cbo.id_tipo_relacion_comprobante,
   cbo.glosa1,
   unnest(cbo.id_int_comprobante_fks) as id_int_comprobate_rel
  from  conta.tint_comprobante  cbo
  where cbo.estado_reg = 'validado'
) 

select
  
  ppp.id_proveedor,
  pe.nro_tramite,
  pe.id_partida_ejecucion,
  pe.id_moneda,
  pe.descripcion,
  pe.obs,
  pe.obs_dba,
  pe.tipo_movimiento,
  pe.monto,
  pe.monto_anticipo,
  pe.monto_anticipo_mb,
  pe.monto_desc_anticipo,
  pe.monto_desc_anticipo_mb,
  pe.monto_iva_revertido,
  pe.monto_iva_revertido_mb,
  pe.monto_mb,
  ppp.id_int_comprobante,
  ppp.nombre_proveedor,
  ppp.glosa1,
  pe.id_presupuesto,
  pe.id_partida
from plan_pago_proveedor ppp
join pre.tpartida_ejecucion pe on pe.valor_id_origen = ppp.id_plan_pago and pe.columna_origen = 'id_plan_pago'
UNION
select 
  ppp.id_proveedor,
  pe.nro_tramite,
  pe.id_partida_ejecucion,
  pe.id_moneda,
  pe.descripcion,
  pe.obs,
  pe.obs_dba,
  pe.tipo_movimiento,
  pe.monto,
  pe.monto_anticipo,
  pe.monto_anticipo_mb,
  pe.monto_desc_anticipo,
  pe.monto_desc_anticipo_mb,
  pe.monto_iva_revertido,
  pe.monto_iva_revertido_mb,
  pe.monto_mb,
  ppp.id_int_comprobante,
  ppp.nombre_proveedor,
  ppp.glosa1,
  pe.id_presupuesto,
  pe.id_partida
from plan_pago_proveedor ppp
join conta.tint_transaccion tr on tr.id_int_comprobante = ppp.id_int_comprobante
join pre.tpartida_ejecucion pe on pe.valor_id_origen = tr.id_int_transaccion and pe.columna_origen = 'id_int_transaccion' and pe.tipo_movimiento = 'ejecutado'
UNION 

select
  ppp.id_proveedor,
  pe.nro_tramite,
  pe.id_partida_ejecucion,
  pe.id_moneda,
  pe.descripcion,
  pe.obs,
  pe.obs_dba,
  pe.tipo_movimiento,
  pe.monto,
  pe.monto_anticipo,
  pe.monto_anticipo_mb,
  pe.monto_desc_anticipo,
  pe.monto_desc_anticipo_mb,
  pe.monto_iva_revertido,
  pe.monto_iva_revertido_mb,
  pe.monto_mb, 
  ppp.id_int_comprobante,
  ppp.nombre_proveedor,
  cbo.glosa1,
  pe.id_presupuesto,
  pe.id_partida
from plan_pago_proveedor ppp
join cbte_relacionado cbo ON ppp.id_int_comprobante = id_int_comprobate_rel
join conta.ttipo_relacion_comprobante trc on cbo.id_tipo_relacion_comprobante = trc.id_tipo_relacion_comprobante --and trc.codigo in ('REVERSION')
join conta.tint_transaccion tr on tr.id_int_comprobante = cbo.id_int_comprobante
join pre.tpartida_ejecucion pe on pe.valor_id_origen = tr.id_int_transaccion and pe.columna_origen = 'id_int_transaccion' and pe.tipo_movimiento = 'ejecutado'
UNION
select
  NULL::integer id_proveedor,
  pe.nro_tramite,
  pe.id_partida_ejecucion,
  pe.id_moneda,
  pe.descripcion,
  pe.obs,
  pe.obs_dba,
  pe.tipo_movimiento,
  pe.monto,
  pe.monto_anticipo,
  pe.monto_anticipo_mb,
  pe.monto_desc_anticipo,
  pe.monto_desc_anticipo_mb,
  pe.monto_iva_revertido,
  pe.monto_iva_revertido_mb,
  pe.monto_mb, 
  pe.id_int_comprobante,
  cbt.beneficiario as nombre_proveedor,
  cbt.glosa1,
  pe.id_presupuesto,
  pe.id_partida
  
from pre.tpartida_ejecucion pe
join conta.tint_comprobante cbt on cbt.id_int_comprobante = pe.id_int_comprobante
where pe.columna_origen = 'pre.tpartida_ejecucion_tmp' and pe.tipo_movimiento = 'ejecutado'

/**********************************F-DEP-RAC-TES-59-10/03/2020****************************************/




/**********************************I-DEP-RAC-TES-60-11/03/2020****************************************/

--------------- SQL ---------------

ALTER TABLE tes.tts_libro_bancos
  ADD CONSTRAINT tts_libro_bancos_fk2 FOREIGN KEY (id_usuario_reg)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
 
 --------------- SQL ---------------

ALTER TABLE tes.tts_libro_bancos
  ADD CONSTRAINT tts_libro_bancos_fk3 FOREIGN KEY (id_estado_wf)
    REFERENCES wf.testado_wf(id_estado_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE tes.tts_libro_bancos
  ADD CONSTRAINT tts_libro_bancos_fk4 FOREIGN KEY (id_proceso_wf)
    REFERENCES wf.tproceso_wf(id_proceso_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE tes.tts_libro_bancos
  ADD CONSTRAINT tts_libro_bancos_fk5 FOREIGN KEY (id_int_comprobante)
    REFERENCES conta.tint_comprobante(id_int_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE tes.tts_libro_bancos
  ADD CONSTRAINT tts_libro_bancos_fk6 FOREIGN KEY (id_depto)
    REFERENCES param.tdepto(id_depto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
            
/**********************************F-DEP-RAC-TES-60-11/03/2020****************************************/    

 