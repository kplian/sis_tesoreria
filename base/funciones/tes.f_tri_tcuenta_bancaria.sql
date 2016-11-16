CREATE OR REPLACE FUNCTION tes.f_tri_tcuenta_bancaria (
)
RETURNS trigger AS
$body$
DECLARE
		 
	g_registros record;
	v_consulta varchar;
	v_res_cone  varchar;
	v_cadena_cnx varchar;
	v_cadena_con varchar;
	v_resp varchar;

	v_tabla varchar;
	v_id_uo integer;
	v_nro_cheque integer;
	v_estado_cuenta numeric;
	v_id_cuenta integer;
    v_id_gestion integer;
    v_id_auxiliar integer;
		
BEGIN

	--Funcion para obtener cadena de conexion
	v_cadena_cnx =  migra.f_obtener_cadena_conexion();
	
	--Obtiene la gestión
	select
	id_gestion
	into v_id_gestion
	from param.tgestion ges
	where ges.gestion = to_char(now(),'yyyy')::integer;

	v_nro_cheque = 0;
	v_estado_cuenta = 1;
	v_id_cuenta = NULL;
	v_id_auxiliar = NULL;
	
	if TG_OP IN ('INSERT','UPDATE') then
			
		v_consulta = 'select migracion.f_mig_tcuenta_bancaria__tts_cuenta_bancaria('''||
						TG_OP ||''',' ||
                        COALESCE(NEW.id_cuenta_bancaria::varchar,'NULL')||','||
                        COALESCE(NEW.id_institucion::varchar,'NULL')||','||
                        COALESCE(v_id_cuenta::varchar,'NULL')||','||
                        COALESCE(''''||NEW.nro_cuenta::varchar||'''','NULL')||','||
                        COALESCE(v_nro_cheque::varchar,'NULL')||','||
                        COALESCE(v_estado_cuenta::varchar,'NULL')||','||
                        COALESCE(v_id_auxiliar::varchar,'NULL')||','||
                        COALESCE(v_id_gestion::varchar,'NULL')||')';
	
	else  --DELETE
	
		
		v_consulta = 'select migracion.f_mig_tcuenta_bancaria__tts_cuenta_bancaria('''||
						TG_OP ||''',' ||
						OLD.id_cuenta_bancaria||',NULL,NULL,NULL,NULL,NULL,NULL,NULL)';
		       
	END IF;

	--Abre una conexion con dblink para ejecutar la consulta
    v_resp =  (SELECT dblink_connect(v_cadena_cnx));
		            
	if (v_resp!='OK') THEN
		--Error al abrir la conexión  
		raise exception 'FALLA CONEXION A LA BASE DE DATOS CON DBLINK';
	else
		PERFORM * FROM dblink(v_consulta,true) AS (resp varchar);
	    v_res_cone=(select dblink_disconnect());
	end if;

 
		
  RETURN NULL;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;