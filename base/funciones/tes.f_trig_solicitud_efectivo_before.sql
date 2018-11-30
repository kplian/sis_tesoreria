--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_trig_solicitud_efectivo_before (
)
RETURNS trigger AS
$body$
DECLARE
  v_registros_con 	 record;
  v_registros		 record;
BEGIN

    IF  new.estado in ( 'entregado','repuesto','ingresado','devuelto','aperturado','rendido')  THEN
         NEW.fecha_entregado_ult = now();
    END IF;
 
    
    IF  new.estado in ( 'entregado','finalizado','repuesto','ingresado','devuelto','aperturado','rendido')  and NEW.fecha_ult_mov is null THEN
         NEW.fecha_ult_mov = now();
    END IF;
    
   RETURN NEW;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;