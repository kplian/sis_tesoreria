CREATE OR REPLACE FUNCTION informix.f_migra_aeropuerto (
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
  	v_nombre_funcion = 'informix.f_migra_aeropuerto';
	
    
    v_consulta = '''
                    select aeropuerto, nombre, ciudad,nalint
                    from aeropuerto''';

	select informix.f_user_mapping() into v_resp;
    
    execute ('CREATE FOREIGN TABLE informix.aeropuerto (
      aeropuerto varchar(5),
      nombre varchar(100),
      ciudad varchar(3),
      nalint varchar(2)
      ) SERVER sai1

    OPTIONS ( query ' || v_consulta || ',
    database ''ingresos'',
      informixdir ''/opt/informix'',
      client_locale ''en_US.utf8'',
      informixserver ''sai1'');');
    
    for v_registros in (select * from informix.aeropuerto) loop
    	select id_lugar into v_id_lugar
        from param.tlugar l
        where l.tipo in ('departamento','provincia','localidad') and l.codigo = trim(both ' ' from v_registros.ciudad) and l.estado_reg = 'activo';
            
        if (v_id_lugar is null) then
            raise exception 'No se tiene registrada la ciudad % en la tabla lugar',v_registros.ciudad;
        end if;
        if(exists (	select 1 
        			from obingresos.taeropuerto 
                    where codigo = TRIM(both ' ' from v_registros.aeropuerto) AND
                    	id_lugar = v_id_lugar))then
        	
            --update a la comision
            
            UPDATE 
  				obingresos.taeropuerto 
            SET               
              id_usuario_mod = p_id_usuario,              
              fecha_mod = now(), 
              nombre = trim(both ' ' from  v_registros.nombre),                                     
              tipo_nalint = trim(both ' ' from  v_registros.nalint)
            WHERE 
              codigo = TRIM(both ' ' from v_registros.aeropuerto) AND
                    	id_lugar = v_id_lugar;
        else
        	--insert a la comision
            INSERT INTO 
              obingresos.taeropuerto
            (
              id_usuario_reg,              
              codigo,
              nombre,
              id_lugar,
              tipo_nalint              
            )
            VALUES (
              p_id_usuario,              
              TRIM(both ' ' from v_registros.aeropuerto),
              trim(both ' ' from  v_registros.nombre),
              v_id_lugar,   
              trim(both ' ' from  v_registros.nalint)
            );
        end if;
    
    end loop;
    
    DROP FOREIGN TABLE informix.aeropuerto;     
     
    return 'exito';
  
EXCEPTION  				
	WHEN OTHERS THEN
			--update a la tabla informix.migracion
            v_resp = 'Ha ocurrido un error en la funcion '||v_nombre_funcion || '. El mensaje es : ' || SQLERRM ||'. aeropuerto: '||v_registros.aeropuerto;
            
            return v_resp;
            
			
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;