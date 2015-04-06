CREATE OR REPLACE FUNCTION tes.f_cerrar_subsistema_obligacion_pago (
)
RETURNS varchar AS
$body$
DECLARE
	res				varchar;
    g_mes			integer;
    g_anio			integer;
    g_id_periodo	integer;
    g_id_subsistema	integer;
BEGIN

   g_mes:=extract(MONTH FROM CURRENT_DATE);
   g_anio:=extract(YEAR FROM CURRENT_DATE);
   
   IF(g_mes = 1)THEN   
     select per.id_periodo into g_id_periodo
     from param.tperiodo per
     inner join param.tgestion ges on ges.id_gestion=per.id_gestion
     where per.periodo=12 and ges.gestion=g_anio-1;     
   ELSE
     select per.id_periodo into g_id_periodo
     from param.tperiodo per
     inner join param.tgestion ges on ges.id_gestion=per.id_gestion     
     where per.periodo=g_mes-1 and ges.gestion=g_anio;
   END IF;
   	 
   	 select s.id_subsistema into g_id_subsistema
     from segu.tsubsistema s
     where s.codigo='TES';
   
   UPDATE param.tperiodo_subsistema 
   set estado='cerrado'
   where id_periodo=g_id_periodo and id_subsistema=g_id_subsistema; 
   
   IF EXISTS(SELECT 1 FROM param.tperiodo_subsistema persub
   where persub.id_periodo=g_id_periodo and id_subsistema=g_id_subsistema 
   and persub.estado!='cerrado')THEN
   		res:='fallo, no se cerro el periodo para el subsistema obligacion de pago';
   ELSE 
   		res:='exito, se cerro el periodo para el subsistema obligacion de pago';
   END IF;
   return res;
   
   EXCEPTION
	WHEN others THEN    
	res:='exception, revisar permisos sobre tablas, funciones y secuencias para el dbuser';
    return res;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;