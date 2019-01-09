--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_trig_solicitud_efectivo_before (
)
RETURNS trigger AS
$body$
/***************************************************************************
     HISTORIAL DE MODIFICACIONES:
    
 ISSUE    FORK        FECHA:          AUTOR                 DESCRIPCION

 #10    ENDEETR      03/01/2019        Manu Guerra     		la fecha de reposicion o devolucion afectara segun la gestion, para cierre de gestion 
 #11    ENDEETR      03/01/2019        Manu Guerra     		correccion de bug,  de gestion pasada
***************************************************************************/
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
    /*IF  new.estado in ( 'entregado','finalizado','repuesto','ingresado','devuelto','aperturado','rendido')  and NEW.fecha_ult_mov is null THEN
        if EXTRACT (year from old.fecha)= EXTRACT (year from now()) then
        	NEW.fecha_ult_mov = now();
        else	
        	NEW.fecha_ult_mov = '31/12/2018'::date;
        end if;  
        
    END IF;*/
    
   RETURN NEW;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;