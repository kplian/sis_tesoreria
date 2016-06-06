CREATE OR REPLACE FUNCTION informix.f_migra_comision (
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
  	v_nombre_funcion = 'informix.f_migra_comision';
	
    
    v_consulta = '''select c.pais,c.comision,c.boaagt,c.ruta,c.tipreng,c.porcomis
                    from comision c''';

	select informix.f_user_mapping() into v_resp;
    
    execute ('CREATE FOREIGN TABLE informix.comision (
      pais varchar(3),
      comision varchar(50),
      boaagt varchar(2),
      ruta varchar(2),      
      tipreng varchar(2),      
      porcomis numeric
      ) SERVER sai1

    OPTIONS ( query ' || v_consulta || ',
    database ''ingresos'',
      informixdir ''/opt/informix'',
      client_locale ''en_US.utf8'',
      informixserver ''sai1'');');
    
    for v_registros in (select * from informix.comision) loop
    	select id_lugar into v_id_lugar
        from param.tlugar l
        where l.tipo = 'pais' and l.codigo = trim(both ' ' from v_registros.pais) and l.estado_reg = 'activo';
            
        if (v_id_lugar is null) then
            raise exception 'No se tiene registrada el pais % en la tabla lugar',v_registros.pais;
        end if;
        if(exists (	select 1 
        			from obingresos.tcomision 
                    where codigo = TRIM(both ' ' from v_registros.comision) AND
                    	id_lugar = v_id_lugar))then
        	
            --update a la comision
            
            UPDATE 
  				obingresos.tcomision 
            SET               
              id_usuario_mod = p_id_usuario,              
              fecha_mod = now(), 
              tipodoc = trim(both ' ' from  v_registros.ruta),                                     
              porcentaje = v_registros.porcomis 
            WHERE 
              codigo = TRIM(both ' ' from v_registros.comision) AND
                    	id_lugar = v_id_lugar;
        else
        	--insert a la comision
            INSERT INTO 
              obingresos.tcomision
            (
              id_usuario_reg,              
              codigo,
              tipodoc,
              id_lugar,
              porcentaje              
            )
            VALUES (
              p_id_usuario,              
              TRIM(both ' ' from v_registros.comision),
              trim(both ' ' from  v_registros.ruta),
              v_id_lugar,   
              v_registros.porcomis 
            );
        end if;
    
    end loop;
    
    DROP FOREIGN TABLE informix.comision;     
     
    return 'exito';
  
EXCEPTION  				
	WHEN OTHERS THEN
			--update a la tabla informix.migracion
            v_resp = 'Ha ocurrido un error en la funcion '||v_nombre_funcion || '. El mensaje es : ' || SQLERRM ||'. comision: '||v_registros.comision;
            
            return v_resp;
            
			
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;