CREATE OR REPLACE FUNCTION informix.f_migra_impuesto (
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
  	v_nombre_funcion = 'informix.f_migra_impuesto';
	
    
    v_consulta = '''select i.pais,i.impuesto,i.tipdoc,i.porcntj,i.monto,i.tipreng,i.tipo,i.nombre
                    from timpuesto i''';

	select informix.f_user_mapping() into v_resp;
    
    execute ('CREATE FOREIGN TABLE informix.impuesto (
      pais varchar(3),
      impuesto varchar(50),
      tipdoc varchar(5),
      porcentaje numeric,      
      monto numeric,      
      tipreng VARCHAR(2),
      tipo VARCHAR(2),
      nombre VARCHAR(255)
      ) SERVER sai1

    OPTIONS ( query ' || v_consulta || ',
    database ''ingresos'',
      informixdir ''/opt/informix'',
      client_locale ''en_US.utf8'',
      informixserver ''sai1'');');
    
    for v_registros in (select * from informix.impuesto) loop
    	select id_lugar into v_id_lugar
        from param.tlugar l
        where l.tipo = 'pais' and l.codigo = trim(both ' ' from v_registros.pais) and l.estado_reg = 'activo';
            
        if (v_id_lugar is null) then
            raise exception 'No se tiene registrada el pais % en la tabla lugar',v_registros.pais;
        end if;
        if(exists (	select 1 
        			from obingresos.timpuesto 
                    where codigo = TRIM(both ' ' from v_registros.impuesto) AND
                    tipodoc = TRIM(both ' ' from v_registros.tipdoc) AND
                    	id_lugar = v_id_lugar))then
        	
            --update a la comision
            
            UPDATE 
  				obingresos.timpuesto 
            SET               
              id_usuario_mod = p_id_usuario,              
              fecha_mod = now(), 
              nombre = trim(both ' ' from  v_registros.nombre),                                     
              porcentaje = v_registros.porcentaje,
              monto = v_registros.monto,
              tipo =  trim(both ' ' from  v_registros.tipo)
            WHERE 
              codigo = TRIM(both ' ' from v_registros.impuesto) AND
                    tipodoc = TRIM(both ' ' from v_registros.tipdoc) AND
                    	id_lugar = v_id_lugar;
        else
        	--insert a la comision
            INSERT INTO 
              obingresos.timpuesto
            (
              id_usuario_reg,              
              codigo,
              tipodoc,
              id_lugar,
              porcentaje,
              monto,
              nombre,
              tipo            
            )
            VALUES (
              p_id_usuario,              
              TRIM(both ' ' from v_registros.impuesto),
              trim(both ' ' from  v_registros.tipdoc),
              v_id_lugar,   
              v_registros.porcentaje ,
              v_registros.monto,
              trim(both ' ' from  v_registros.nombre),
              trim(both ' ' from  v_registros.tipo)
            );
        end if;
    
    end loop;
    
    DROP FOREIGN TABLE informix.impuesto;     
     
    return 'exito';
  
EXCEPTION  				
	WHEN OTHERS THEN
			--update a la tabla informix.migracion
            v_resp = 'Ha ocurrido un error en la funcion '||v_nombre_funcion || '. El mensaje es : ' || SQLERRM ||'. impuesto: '||v_registros.impuesto;
            
            return v_resp;
            
			
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;