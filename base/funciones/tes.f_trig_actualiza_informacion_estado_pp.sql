CREATE OR REPLACE FUNCTION tes.f_trig_actualiza_informacion_estado_pp (
)
RETURNS trigger AS
$body$
DECLARE
 
BEGIN

  update tes.tobligacion_pago  op set 
  ultima_cuota_pp = NEW.nro_cuota,
  ultimo_estado_pp  = NEW.estado  
  where op.id_obligacion_pago = NEW.id_obligacion_pago;

 RETURN NULL;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;
