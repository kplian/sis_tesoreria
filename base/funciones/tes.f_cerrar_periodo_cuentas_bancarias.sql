CREATE OR REPLACE FUNCTION tes.f_cerrar_periodo_cuentas_bancarias (
)
RETURNS varchar AS
$body$
DECLARE
	res				varchar;
    g_mes			integer;
    g_anio			integer;
    g_id_periodo	integer;
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
   
   UPDATE tes.tcuenta_bancaria_periodo 
   set estado='cerrado'
   where id_periodo=g_id_periodo;
   
   IF EXISTS(SELECT 1 FROM tes.tcuenta_bancaria_periodo ctaper
   where ctaper.id_periodo=g_id_periodo and (ctaper.estado!='cerrado' or ctaper.estado is null))THEN
   		res:='fallo, no se cerro el periodo para las cuentas bancarias';
   ELSE 
   		res:='exito, se cerro el periodo para las cuentas bancarias';
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