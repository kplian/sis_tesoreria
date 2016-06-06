CREATE OR REPLACE FUNCTION informix.f_migra_agencia (
  p_id_usuario integer
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
    v_id_lugar			integer;
BEGIN
  	v_nombre_funcion = 'informix.f_migra_agencia';
	
    
    v_consulta = '''select a.agt, a.nomagt,a.boaagt,a.iata,a.ctoato, a.estacion,n.agtnoiata,n.nomagt
                    from agencias a
                    left join agtnoiata n on n.agt = a.agt ''';

	select informix.f_user_mapping() into v_resp;
    
    execute ('CREATE FOREIGN TABLE informix.agencia (
      agt numeric,
      nombre_iata varchar(255),
      boaagt varchar(2),
      iata varchar(2),      
      ctoato varchar(2),      
      estacion varchar(30),
      codigo_noiata varchar(30),
      nombre_noiata varchar(255)
      ) SERVER sai1

    OPTIONS ( query ' || v_consulta || ',
    database ''ingresos'',
      informixdir ''/opt/informix'',
      client_locale ''en_US.utf8'',
      informixserver ''sai1'');');
    
    for v_registros in (select * from informix.agencia) loop
    	select id_lugar into v_id_lugar
        from param.tlugar l
        where l.tipo in ('departamento','provincia','localidad') and l.codigo = trim(both ' ' from v_registros.estacion) and l.estado_reg = 'activo';
            
        if (v_id_lugar is null) then
            raise exception 'No se tiene registrada la estacion % en la tabla lugar',v_registros.estacion;
        end if;
        if(exists (	select 1 
        			from obingresos.tagencia 
                    where codigo = v_registros.agt::integer::varchar and (codigo_noiata is null or codigo_noiata = TRIM(both ' ' from v_registros.codigo_noiata))))then
        	
            --update a la agencia
            
            UPDATE 
  				obingresos.tagencia 
            SET               
              id_usuario_mod = p_id_usuario,              
              fecha_mod = now(),              
              nombre = TRIM( both ' ' from (case when v_registros.codigo_noiata is null then
              				v_registros.nombre_iata
                        else
                        	v_registros.nombre_noiata
                        end)),
              tipo_agencia = (case when v_registros.codigo_noiata is null then
                                  'iata'
                              else
                                  'noiata'
                              end),             
              agencia_ato = trim(both ' ' from  v_registros.ctoato),  
              id_lugar = v_id_lugar,            
              codigo_noiata = TRIM(both ' ' from v_registros.codigo_noiata),
              boaagt = TRIM(both ' ' from v_registros.boaagt)
            WHERE 
              codigo = v_registros.agt::integer::varchar and (codigo_noiata is null or codigo_noiata = v_registros.codigo_noiata);
        else
        	--insert a la agencia
            INSERT INTO 
              obingresos.tagencia
            (
              id_usuario_reg,              
              codigo,
              codigo_int,
              nombre,
              tipo_agencia,
              tipo_pago,
              monto_maximo_deuda,
              depositos_moneda_boleto,
              tipo_cambio,
              id_moneda_control,
              agencia_ato,
              id_lugar,
              codigo_noiata,
              boaagt
            )
            VALUES (
              p_id_usuario,              
              v_registros.agt::integer,
              v_registros.agt::integer,
              TRIM( both ' ' from (case when v_registros.codigo_noiata is null then
              				v_registros.nombre_iata
                        else
                        	v_registros.nombre_noiata
                        end)),
              (case when v_registros.codigo_noiata is null then
                  'iata'
              else
                  'noiata'
              end),
              'postpago',
              1000000,
              'si',
              'venta',
              1,
              trim(both ' ' from  v_registros.ctoato),
              v_id_lugar,
              TRIM(both ' ' from v_registros.codigo_noiata),
              TRIM(both ' ' from v_registros.boaagt)
            );
        end if;
    
    end loop;
    
    DROP FOREIGN TABLE informix.agencia;     
     
    return 'exito';
  
EXCEPTION  				
	WHEN OTHERS THEN
    		
			--update a la tabla informix.migracion
            v_resp = 'Ha ocurrido un error en la funcion '||v_nombre_funcion || '. El mensaje es : ' || SQLERRM ||'. Agencia: '||v_registros.agt::integer;
            
            return v_resp;
            
			
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;