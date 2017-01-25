CREATE OR REPLACE FUNCTION informix.f_migra_boleto_retweb (
  p_id_usuario integer,
  p_fecha date
)
  RETURNS varchar AS
  $body$
DECLARE
  v_consulta    		varchar;
	v_registros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    us 					varchar;
    v_fecha_texto		varchar;
    v_id_agencia		integer;
    v_detalle			record;
    v_id_boleto			integer;
    v_id_comision		integer;
    v_id_lugar			integer;
    v_id_impuesto		integer;
    v_id_forma_pago		integer;
    v_id_moneda			integer;
    v_id_boleto_antiguo	integer;
    v_estado_antiguo	varchar;
    v_fecha_vuelo		date;
    v_id_boleto_conjuncion	integer;
    v_hora_vuelo		time;
BEGIN
  	v_nombre_funcion = 'informix.f_migra_boleto_retweb';

    v_fecha_texto = to_char(p_fecha,'DD-MM-YYYY');
        v_consulta = '''select b.billete,b.pasajero,b.importe,b.moneda,b.fecha,fp.tarjeta,fp.numero,b.estado
                        from boletos b
                        inner join fpago fp on fp.billete = b.billete
                        where b.fecha = ''''' || v_fecha_texto || '''''  and fp.tarjeta = ''''VI'''' and fp.numero like ''''%000000005555''''

                        ''';

	select informix.f_user_mapping() into v_resp;

    execute ('CREATE FOREIGN TABLE informix.boletos (

      billete numeric(18,0),
      pasajero varchar,
      importe numeric(18,2),--total
      moneda varchar(5),
      fecha date,
      tarjeta varchar(10),
      numero_tarjeta varchar(20),
      estado varchar(1)

      ) SERVER sai1

    OPTIONS ( query ' || v_consulta || ',
    database ''ingret'',
      informixdir ''/opt/informix'',
      client_locale ''en_US.utf8'',
      informixserver ''sai1'');');


    for v_registros in (select b.*
    					from informix.boletos b
                          ) loop

            INSERT INTO
                obingresos.tboleto_retweb
              (

                id_usuario_reg,
                nro_boleto,
                pasajero,
                fecha_emision,
                total,
                moneda,
                tarjeta,
                numero_tarjeta,
                estado
              )
              VALUES (
                p_id_usuario,
                v_registros.billete::varchar,
                trim (both ' ' from v_registros.pasajero),
                v_registros.fecha,
                v_registros.importe,
                 trim (both ' ' from v_registros.moneda),
                 trim (both ' ' from v_registros.tarjeta),
                 trim (both ' ' from v_registros.numero_tarjeta),
                 v_registros.estado
              );
    end loop;



    DROP FOREIGN TABLE informix.boletos;

    return 'exito';

EXCEPTION
	WHEN OTHERS THEN
			--update a la tabla informix.migracion

            return 'Ha ocurrido un error en la funcion ' || v_nombre_funcion || '. El mensaje es : ' || SQLERRM || '. Billete: ' || v_registros.billete;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;