CREATE OR REPLACE FUNCTION tes.f_get_uo_presupuesta_prorrateo (
  p_id_concepto_ingas integer,
  p_id_cc integer,
  p_nivel integer = 0
)
RETURNS integer AS
$body$
DECLARE
	v_id_centro_costo		integer;
    v_id_partida			integer;
    v_id_gestion			integer;

BEGIN

	select id_gestion into v_id_gestion
    from pre.vpresupuesto_cc
    where id_centro_costo = p_id_cc;

 	select p.id_partida into v_id_partida
    from pre.tpartida p
    inner join pre.tconcepto_partida cp on cp.id_partida = p.id_partida
    where  p.id_gestion = v_id_gestion and cp.id_concepto_ingas = p_id_concepto_ingas
    and cp.estado_reg = 'activo';

    if (v_id_partida is null) then
        raise exception 'No existe partida para el concepto de gasto para el concepto: % y el presupuesto: %',p_id_concepto_ingas,p_id_cc;
    end if;

    SELECT prenuevo.id_centro_costo into v_id_centro_costo
    from pre.vpresupuesto_cc pre
    inner join orga.testructura_uo euo on euo.id_uo_hijo = pre.id_uo
    inner join orga.tuo uo on uo.id_uo = orga.f_get_uo_presupuesta(euo.id_uo_padre,NULL,now()::date)
    inner join pre.vpresupuesto_cc prenuevo on prenuevo.id_uo = uo.id_uo and pre.tipo_pres = '2'
    where pre.id_centro_costo = p_id_cc and prenuevo.id_gestion = v_id_gestion;

    if (v_id_centro_costo is null) then
    	raise exception 'no hay padre para: %',p_id_cc;
    end if;


    select p.id_partida into v_id_partida
    from pre.tpartida p
    inner join pre.tconcepto_partida cp on cp.id_partida = p.id_partida
    inner join pre.tpresup_partida pp on pp.id_partida = p.id_partida
    where  p.id_gestion = v_id_gestion and cp.id_concepto_ingas = p_id_concepto_ingas
    and pp.id_presupuesto = v_id_centro_costo and pp.estado_reg = 'activo';

    if (v_id_partida is null) then
    	if (p_nivel > 4) then
        	return null;
        else
        	return tes.f_get_uo_presupuesta_prorrateo(p_id_concepto_ingas,v_id_centro_costo,p_nivel +1);
        end if;


    else
    	return v_id_centro_costo;
    end if;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;