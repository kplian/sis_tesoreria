CREATE OR REPLACE FUNCTION informix.f_migra_boleto (
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
  BEGIN
    v_nombre_funcion = 'informix.f_migra_boleto';

    v_fecha_texto = to_char(p_fecha,'DD-MM-YYYY');
    v_consulta = '''SELECT b.pais,b.billete, b.pasajero, b.fecha, b.importe, b.neto,
                        b.moneda, b.agt, b.agtnoiata,b.codgds,b.tipdoc,b.retbsp,b.fechareg,b.horareg,
                        b.ruta,b.cupones,b.origen,b.destino,b.tipopax,
                        sum(CASE 
                           WHEN c.importe > 0 THEN (c.importe *-1)
                           WHEN c.importe is null then 0
                          ELSE c.importe
                        END)  as comision, b.estado
                        FROM boletos b
                        left join bcomision c on c.billete = b.billete
                        where estado in (1,9) and fechareg = ''''' || v_fecha_texto || ''''' 
                        group by b.pais,b.billete, b.pasajero, b.fecha, b.importe, b.neto, 
						b.moneda, b.agt, b.agtnoiata,b.codgds,b.tipdoc,b.retbsp,b.fechareg,b.horareg,
                        b.ruta,b.cupones,b.origen,b.destino,b.tipopax 
                        ''';

    select informix.f_user_mapping() into v_resp;

    execute ('CREATE FOREIGN TABLE informix.boletos (
      pais VARCHAR(5),
      billete numeric(18,0),
      pasajero varchar,
      fecha date,
      importe numeric(18,2),--total      
      neto numeric(18,2),      
      moneda varchar(5),
      agt numeric,
      agtnoiata varchar(15),
      codgds varchar(5),
      tipodoc varchar(5),
      retbsp varchar(5),
      fechareg date,
      horareg varchar,      
      ruta varchar(1),
      cupones integer,
      origen varchar(3),
      destino varchar(3),
      tipopax varchar(3),
      comision numeric(18,2),
      estado varchar(1)
      ) SERVER sai1

    OPTIONS ( query ' || v_consulta || ',
    database ''ingresos'',
      informixdir ''/opt/informix'',
      client_locale ''en_US.utf8'',
      informixserver ''sai1'');');

    v_consulta = '''select c.*
                    from boletos b
                    inner join bcomision c on c.billete = b.billete 
                        where b.estado in (1) and b.fechareg = ''''' || v_fecha_texto || ''''' ''';


    execute ('CREATE FOREIGN TABLE informix.boletos_comision (
      pais varchar(5),
      estacion varchar(5),
      tipdoc varchar(6),
      billete numeric(18,0),--total      
      comision varchar(50),      
      importe numeric(18,2),
      porcomis numeric(18,2)
      ) SERVER sai1

    OPTIONS ( query ' || v_consulta || ',
    database ''ingresos'',
      informixdir ''/opt/informix'',
      client_locale ''en_US.utf8'',
      informixserver ''sai1'');');

    v_consulta = '''select i.*
                    from boletos b
                    inner join bimpuesto i on i.billete = b.billete and i.pais = b.pais and i.estacion=b.estacion and i.tipdoc=b.tipdoc
                        where b.estado in (1) and b.fechareg = ''''' || v_fecha_texto || ''''' ''';


    execute ('CREATE FOREIGN TABLE informix.boletos_impuesto (
      pais varchar(5),
      estacion varchar(5),
      tipdoc varchar(6),
      billete numeric(18,0),--total      
      impuesto varchar(50),      
      importe numeric(18,2)
      ) SERVER sai1

    OPTIONS ( query ' || v_consulta || ',
    database ''ingresos'',
      informixdir ''/opt/informix'',
      client_locale ''en_US.utf8'',
      informixserver ''sai1'');');

    v_consulta = '''select f.pais,f.estacion,f.tipdoc,f.forma,f.billete,f.tarjeta,f.numero,f.importe,f.moneda,f.ctacte
                    from boletos b
                    inner join fpago f on f.billete = b.billete and f.pais = b.pais and f.estacion=b.estacion and f.tipdoc=b.tipdoc
                    where b.estado in (1) and b.fechareg = ''''' || v_fecha_texto || ''''' ''';


    execute ('CREATE FOREIGN TABLE informix.boletos_fpago (
      pais varchar(5),
      estacion varchar(5),
      tipdoc varchar(6),
      forma varchar(50),
      billete numeric(18,0),  
      tarjeta varchar(10),      
      numero_tarjeta varchar(20),
      importe numeric(18,2),
      moneda VARCHAR(5),
      ctacte VARCHAR(20)
      ) SERVER sai1

    OPTIONS ( query ' || v_consulta || ',
    database ''ingresos'',
      informixdir ''/opt/informix'',
      client_locale ''en_US.utf8'',
      informixserver ''sai1'');');

    update obingresos.tdetalle_boletos_web
    set void = 'si',
      procesado = 'si'
    from informix.boletos b
    where b.billete::varchar = obingresos.tdetalle_boletos_web.billete and
          b.estado = '9';

    for v_registros in (select b.*,a.id_agencia,l.id_lugar,m.id_moneda
                        from informix.boletos b
                          left join obingresos.tagencia a
                            on a.codigo = b.agt::integer::varchar and
                               (b.agtnoiata is null or
                                trim (both ' ' from b.agtnoiata) = a.codigo_noiata)
                          left join param.tlugar l
                            on l.codigo = trim(both ' ' from b.pais) and l.estado_reg = 'activo'
                          left join param.tmoneda m
                            on m.codigo_internacional = trim(both ' ' from b.moneda) and m.estado_reg = 'activo'
                        where b.estado = '1'
    ) loop

      if (v_registros.id_agencia is null) then
        raise exception 'No se tiene registrada la agencia % en la tabla agencia',v_registros.agt;
      end if;

      if (v_registros.id_lugar is null) then
        raise exception 'No se tiene registrada el pais % en la tabla lugar',v_registros.pais;
      end if;

      if (v_registros.id_moneda is null) then
        raise exception 'No se tiene registrada la moneda % en la tabla moneda',v_registros.moneda;
      end if;
      v_id_boleto_antiguo = NULL;

      select id_boleto into v_id_boleto_antiguo
      from obingresos.tboleto b
      where nro_boleto=v_registros.billete::varchar and b.estado_reg = 'activo';
      --Si el boleto ya existe guardamos el historico y lo insertamos nuevamente
      IF(v_id_boleto_antiguo is not null) then
        update obingresos.tboleto
        set estado_reg = 'inactivo',
          fecha_mod = now()::date
        where id_boleto = v_id_boleto_antiguo and estado_reg = 'activo';

        update obingresos.tboleto_impuesto
        set estado_reg = 'inactivo',
          fecha_mod = now()::date
        where id_boleto = v_id_boleto_antiguo and estado_reg = 'activo';

        update obingresos.tboleto_comision
        set estado_reg = 'inactivo',
          fecha_mod = now()::date
        where id_boleto = v_id_boleto_antiguo and estado_reg = 'activo';

        update obingresos.tboleto_forma_pago
        set estado_reg = 'inactivo',
          fecha_mod = now()::date
        where id_boleto = v_id_boleto_antiguo and estado_reg = 'activo';

      end if;

      select nextval('obingresos.tboleto_id_boleto_seq'::regclass) into v_id_boleto;
      INSERT INTO
        obingresos.tboleto
        (
          id_boleto,
          id_usuario_reg,
          fecha_reg,
          estado_reg,
          nro_boleto,
          pasajero,
          fecha_emision,
          total,
          neto,
          moneda,
          agt,
          agtnoiata,
          gds,
          tipdoc,
          retbsp,
          liquido,
          id_agencia,
          id_moneda_boleto,
          comision,
          ruta,
          cupones,
          origen,
          destino,
          tipopax
        )
      VALUES (
        v_id_boleto,
        p_id_usuario,
        (to_char(v_registros.fechareg,'DD/MM/YYYY') || ' ' || v_registros.horareg)::timestamp,
        (case when v_registros.estado = '1' then 'activo' else 'inactivo' END),
        v_registros.billete::varchar,
        trim (both ' ' from v_registros.pasajero),
        v_registros.fecha,
        v_registros.importe,
        v_registros.neto,
        trim (both ' ' from v_registros.moneda),
        v_registros.agt::integer,
        trim (both ' ' from v_registros.agtnoiata),
        trim (both ' ' from v_registros.codgds),
        trim (both ' ' from v_registros.tipodoc),
        trim (both ' ' from v_registros.retbsp),
        v_registros.neto + v_registros.comision,
        v_registros.id_agencia,
        v_registros.id_moneda,
        v_registros.comision,
        trim (both ' ' from v_registros.ruta),
        v_registros.cupones,
        trim (both ' ' from v_registros.origen),
        trim (both ' ' from v_registros.destino),
        trim (both ' ' from v_registros.tipopax)
      );


      /*


       */
    end loop;

    --SE INSERTAN COMISIONES
    for v_detalle  in (	select bc.*,c.id_comision,b.id_boleto
                         from informix.boletos_comision bc
                           inner join obingresos.tboleto b
                             on b.nro_boleto = bc.billete::varchar
                           inner join param.tlugar l
                             on l.codigo = trim(both ' ' from bc.pais) and l.estado_reg = 'activo'
                           inner join obingresos.tcomision c
                             on c.codigo = TRIM(both ' ' from bc.comision) AND
                                c.id_lugar = l.id_lugar) loop



      INSERT INTO
        obingresos.tboleto_comision
        (
          id_usuario_reg,
          importe,
          id_comision,
          id_boleto
        )
      VALUES (
        p_id_usuario,
        v_detalle.importe,
        v_detalle.id_comision,
        v_detalle.id_boleto
      );

    end loop;

    --SE INSERTAN IMPUESTOS
    for v_detalle  in (	select bi.* ,i.id_impuesto,b.id_boleto
                         from informix.boletos_impuesto bi
                           inner join obingresos.tboleto b
                             on b.nro_boleto = bi.billete::varchar
                           inner join param.tlugar l
                             on l.codigo = trim(both ' ' from bi.pais) and l.estado_reg = 'activo'
                           inner join obingresos.timpuesto i
                             on i.codigo = TRIM(both ' ' from bi.impuesto) AND
                                i.tipodoc = TRIM(both ' ' from bi.tipdoc) AND
                                i.id_lugar = l.id_lugar
    ) loop


      INSERT INTO
        obingresos.tboleto_impuesto
        (
          id_usuario_reg,
          importe,
          id_impuesto,
          id_boleto
        )
      VALUES (
        p_id_usuario,
        v_detalle.importe,
        v_detalle.id_impuesto,
        v_detalle.id_boleto
      );

    end loop;

    --SE INSERTAN FORMAS DE PAGO
    for v_detalle  in (	select bf.*,fp.id_forma_pago,b.id_boleto,b.fecha_emision
                         from informix.boletos_fpago bf
                           inner join obingresos.tboleto b
                             on b.nro_boleto = bf.billete::varchar
                           inner join param.tmoneda m
                             on m.codigo_internacional = trim(both ' ' from bf.moneda) and m.estado_reg = 'activo'
                           inner join param.tlugar l
                             on l.codigo = trim(both ' ' from bf.pais) and l.estado_reg = 'activo'
                           inner join obingresos.tforma_pago fp
                             on  fp.codigo = TRIM(both ' ' from bf.forma) AND
                                 fp.id_moneda = m.id_moneda AND
                                 fp.id_lugar = l.id_lugar) loop


      INSERT INTO
        obingresos.tboleto_forma_pago
        (
          id_usuario_reg,
          importe,
          id_forma_pago,
          id_boleto,
          tarjeta,
          numero_tarjeta,
          ctacte
        )
      VALUES (
        p_id_usuario,
        v_detalle.importe,
        v_detalle.id_forma_pago,
        v_detalle.id_boleto,
        TRIM(both ' ' from v_detalle.tarjeta),
        TRIM(both ' ' from v_detalle.numero_tarjeta),
        TRIM(both ' ' from v_detalle.ctacte)
      );

      --si es una venta web actualizamos datos
      if (exists (	select 1
                    from obingresos.tdetalle_boletos_web
                    where billete = v_detalle.billete)) THEN
        select informix.f_modificar_datos_web(v_detalle.billete);
      else
        --si no es una venta web pero esta con tarjeta 5555000000055555
        --lo insertamos en la tabla detalle_boletos_web como no procesado
        if (TRIM(both ' ' from v_detalle.tarjeta) = 'VI' and
            TRIM(both ' ' from v_detalle.numero_tarjeta) = '5555000000005555') then
          INSERT INTO
            obingresos.tdetalle_boletos_web
            (
              id_usuario_reg,
              id_usuario_mod,
              fecha_reg,
              fecha_mod,
              estado_reg,
              id_usuario_ai,
              usuario_ai,
              billete,
              conjuncion,
              medio_pago,
              entidad_pago,
              moneda,
              importe,
              endoso,
              procesado,
              origen,
              fecha,
              nit,
              razon_social
            )
          VALUES (
            p_id_usuario,
            v_detalle.billete::varchar,
            NULL,
            'NAN',
            'NAN',
            'NAN',
            v_detalle.importe,
            'NAN',
            'no',
            'ingresos',
            v_registros.fecha_emision,
            'NAN',
            'NAN'
          );
        end if;
      end if;


    end loop;

    DROP FOREIGN TABLE informix.boletos;
    DROP FOREIGN TABLE informix.boletos_comision;
    DROP FOREIGN TABLE informix.boletos_impuesto;
    DROP FOREIGN TABLE informix.boletos_fpago;
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