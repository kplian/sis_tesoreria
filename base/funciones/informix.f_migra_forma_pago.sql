CREATE OR REPLACE FUNCTION informix.f_migra_forma_pago (
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
    v_id_moneda			integer;
BEGIN
  	v_nombre_funcion = 'informix.f_migra_forma_pago';
	
    
    v_consulta = '''select f.pais,f.forma,f.nombre,f.moneda,f.ctacte
                    from formap f''';

	select informix.f_user_mapping() into v_resp;
    
    execute ('CREATE FOREIGN TABLE informix.forma_pago (
      pais varchar(3),
      forma varchar(50),
      nombre varchar(255),
      moneda varchar(5),
      ctacte varchar(2)
      ) SERVER sai1

    OPTIONS ( query ' || v_consulta || ',
    database ''ingresos'',
      informixdir ''/opt/informix'',
      client_locale ''en_US.utf8'',
      informixserver ''sai1'');');
   
    for v_registros in (select * from informix.forma_pago) loop
    	select id_lugar into v_id_lugar
        from param.tlugar l
        where l.tipo = 'pais' and l.codigo = trim(both ' ' from v_registros.pais) and l.estado_reg = 'activo';
        
        if (v_id_lugar is null) then
            raise exception 'No se tiene registrada el pais % en la tabla lugar',v_registros.pais;
        end if;
        
        select id_moneda into v_id_moneda
        from param.tmoneda m
        where m.codigo_internacional = trim(both ' ' from v_registros.moneda) and m.estado_reg = 'activo';
            
        if (v_id_moneda is null) then
            raise exception 'No se tiene registrada la moneda % en la tabla moneda',v_registros.moneda;
        end if;
        
        if(exists (	select 1 
        			from obingresos.tforma_pago 
                    where codigo = TRIM(both ' ' from v_registros.forma) AND
                    id_moneda = v_id_moneda AND
                    	id_lugar = v_id_lugar))then
        	
            --update a la  forma de pago
            
            UPDATE 
  				obingresos.tforma_pago 
            SET               
              id_usuario_mod = p_id_usuario,              
              fecha_mod = now(), 
              nombre = trim(both ' ' from  v_registros.nombre),                                     
              ctacte = v_registros.ctacte
            WHERE 
              codigo = TRIM(both ' ' from v_registros.forma) AND
                    id_moneda = v_id_moneda AND
                    	id_lugar = v_id_lugar;
        else
        	
        	--insert a la forma de pago
            INSERT INTO 
              obingresos.tforma_pago
            (
              id_usuario_reg,              
              codigo,
              nombre,
              id_lugar,
              id_moneda,
              ctacte           
            )
            VALUES (
              p_id_usuario,              
              TRIM(both ' ' from v_registros.forma),
              trim(both ' ' from  v_registros.nombre),
              v_id_lugar,   
              v_id_moneda ,
              v_registros.ctacte
            );
        end if;
    
    end loop;
     
    DROP FOREIGN TABLE informix.forma_pago;     
     
    return 'exito';
  
EXCEPTION  				
	WHEN OTHERS THEN
			--update a la tabla informix.migracion
            v_resp = 'Ha ocurrido un error en la funcion '||v_nombre_funcion || '. El mensaje es : ' || SQLERRM ||'. forma_pago: '||v_registros.nombre;
            
            return v_resp;
            
			
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;