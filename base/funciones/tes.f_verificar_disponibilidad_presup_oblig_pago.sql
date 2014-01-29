--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_verificar_disponibilidad_presup_oblig_pago (
  p_id_plan_pago integer
)
RETURNS SETOF record AS
$body$
/*
Autor: RCM
Fecha: 14/12/2013
Descripción: Verificación de disponibilidad presupuestaria de obligaciones de pago. Puede ser de Endesis o locamente
*/
DECLARE

	v_cadena_cnx varchar;
    v_resp varchar;
    v_sql varchar;
    v_rec record;
    v_dat record;
    v_cont integer;
    
    va_id_centro_costo integer[];
    va_id_partida integer[];
    va_id_moneda integer[];
    va_importe numeric[];
    
    v_sincronizar varchar;
    v_nombre_funcion varchar;

BEGIN

	v_nombre_funcion = 'f_verificar_disponibilidad_presup_oblig_pago';
    
    --Verificación de existencia del plan de pago
    if not exists(select 1 from tes.tplan_pago
    			where id_plan_pago = p_id_plan_pago) then
    	raise exception 'Cuota inexistente';
    end if;

	--Verificación de bandera de sincronización
    v_sincronizar=pxp.f_get_variable_global('sincronizar');    
    
    if v_sincronizar='true' then
    
    	--Obtiene los datos de la transacción
        v_cont = 1;
        for v_dat in (
                      select
                        obl.id_partida,
                        obl.id_centro_costo,
                        op.id_moneda,
                        sum(pro.monto_ejecutar_mo) as importe
                      from tes.tplan_pago pla
                      inner join tes.tprorrateo pro on pro.id_plan_pago = pla.id_plan_pago
                      inner join tes.tobligacion_pago op on op.id_obligacion_pago = pla.id_obligacion_pago
                      inner join tes.tobligacion_det obl on obl.id_obligacion_det = pro.id_obligacion_det
                      where pla.id_plan_pago = p_id_plan_pago
                      group by obl.id_partida,obl.id_centro_costo) loop
                        
            va_id_partida[v_cont]=v_dat.id_partida;
            va_id_centro_costo[v_cont]=v_dat.id_centro_costo;
            va_id_moneda[v_cont]=v_dat.id_moneda;
            va_importe[v_cont]=v_dat.importe;
            v_cont = v_cont + 1;
              
        end loop;
          
        --Forma la llamada para enviar los datos al servidor destino
        v_sql:='select 
        		id_partida,
                id_presupuesto,
                id_moneda,
                importe,
                disponibilidad
                from migracion.f_verificar_presup_obli_pago('||
                    COALESCE(('array['|| array_to_string(va_id_partida, ',')||']::integer[]')::varchar,'NULL::integer[]')||',
                    '||COALESCE(('array['|| array_to_string(va_id_centro_costo, ',')||']::integer[]')::varchar,'NULL::integer[]')||',
                    '||COALESCE(('array['|| array_to_string(va_id_moneda, ',')||']::integer[]')::varchar,'NULL::integer[]')||',
                    '||COALESCE(('array['|| array_to_string(va_importe, ',')||']::numeric[]')::varchar,'NULL::numeric[]')||')
				as (id_partida integer,
                id_presupuesto integer,
                id_moneda integer,
                importe numeric,
                disponibilidad varchar)';
                      

        --Obtención de cadana de conexión
        v_cadena_cnx =  migra.f_obtener_cadena_conexion();
          
        --Abrir conexión
        v_resp = dblink_connect(v_cadena_cnx);

        IF v_resp!='OK' THEN
            raise exception 'FALLO LA CONEXION A LA BASE DE DATOS CON DBLINK';
        END IF;
        
        --Crear una tabla temporal
        create temp table tt_result_verif(
            id_partida integer,
            id_presupuesto integer,
            id_moneda integer,
            importe numeric,
            disponibilidad varchar
        ) on commit drop;
        
                

        --Ejecuta la función remotamente e inserta en la tabla temporal
        insert into tt_result_verif
        select
        id_partida,
        id_presupuesto,
        id_moneda,
        importe,
        disponibilidad
        from dblink(v_sql, true)
        as (id_partida integer,id_presupuesto integer,id_moneda integer,importe numeric,disponibilidad varchar);
                        
        
        for v_rec in (select
        			rv.id_partida, rv.id_presupuesto,rv.id_moneda,
                    rv.importe,rv.disponibilidad,
                    pa.codigo || ' - ' || pa.nombre_partida as desc_partida,
                    cc.codigo_cc || ' - ' || cc.nombre_uo as desc_cc
        			from tt_result_verif rv
                    inner join pre.tpartida pa on pa.id_partida = rv.id_partida
                    inner join param.vcentro_costo cc on cc.id_centro_costo = rv.id_presupuesto) loop        
            return next v_rec;
        end loop;
        
        --Cierra la conexión abierta
        perform dblink_disconnect();
    
    else
    
    	--TODO, implementar verificacion presupuestaria en PXP
        raise exception 'Gestion  presupuestaria en PXP no implementada';
    
    end if;

    --Devuelve la respuesta
    return ;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100 ROWS 1000;