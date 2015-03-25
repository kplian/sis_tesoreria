--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_trig_actualiza_informacion_estado_pp (
)
RETURNS trigger AS
$body$
DECLARE
 v_nro_cuota_dev  numeric;
BEGIN
  
  --recupera  la ultima cuota del devengado
  select
    max(pp.nro_cuota)
  into 
    v_nro_cuota_dev
  from tes.tplan_pago pp
  where pp.id_obligacion_pago = NEW.id_obligacion_pago 
  and pp.tipo in ('anticipo','devengado','devengado_pagago','devengado_pagado_1c') 
  and pp.estado_reg = 'activo';
  
 
  
  --actualiza ultimo registro del pp
  update tes.tobligacion_pago  op set 
  ultima_cuota_pp = NEW.nro_cuota,
  ultimo_estado_pp  = NEW.estado,
  ultima_cuota_dev = v_nro_cuota_dev  
  where op.id_obligacion_pago = NEW.id_obligacion_pago;

 RETURN NULL;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;