CREATE OR REPLACE FUNCTION informix.f_migra_ciudad (
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
    v_conexion			varchar;
    v_sinc				boolean;
    v_cantidad_lugares	integer;
    v_id_lugar_pais  	integer;
BEGIN
  	v_nombre_funcion = 'informix.f_migra_ciudad';
	
    
    v_consulta = '''select c.pais,c.ciudad,c.nombre
                    from ciudad c
                    where c.ciudad in (select estacion from agencias group by estacion)''';

	select informix.f_user_mapping() into v_resp;
    
    execute ('CREATE FOREIGN TABLE informix.ciudad (
      pais varchar(4),
      ciudad varchar(5),
      nombre varchar(200)
      ) SERVER sai1

    OPTIONS ( query ' || v_consulta || ',
    database ''ingresos'',
      informixdir ''/opt/informix'',
      client_locale ''en_US.utf8'',
      informixserver ''sai1'');');
   
    for v_registros in (select * from informix.ciudad) loop
    	        
        select coalesce(count(l.id_lugar),0) into v_cantidad_lugares 
        from param.tlugar l
        where l.codigo = TRIM(both ' ' from v_registros.ciudad) AND
        l.tipo in ('departamento','provincia','localidad') and l.estado_reg = 'activo';
        
        if (v_cantidad_lugares > 1) then
        	raise exception 'Existe mas de una ciudad con el mismo codigo';
        ELSIF(v_cantidad_lugares = 1) then	
        	
            --update al pais en endesis
            if (pxp.f_get_variable_global('sincronizar') = 'true') then
            	v_conexion = migra.f_crear_conexion();
                perform dblink_exec(v_conexion, 'UPDATE 
  					sss.tsg_lugar
                    SET 
                      nombre = trim(both '' '' from ''' || v_registros.nombre ||''')
                    WHERE 
                      codigo = TRIM(both '' '' from ''' || v_registros.ciudad||''');', true);
                select * FROM dblink(v_conexion, 
                'select migracion.f_sincronizacion()',TRUE)AS t1(resp boolean)
            	into v_sinc;
                v_conexion = migra.f_cerrar_conexion(v_conexion,'exito'); 
            else 
            --update al pais en pxp
                UPDATE 
                    param.tlugar
                SET               
                  id_usuario_mod = p_id_usuario,              
                  fecha_mod = now(), 
                  nombre = trim(both ' ' from  v_registros.nombre)
                WHERE 
                  codigo = TRIM(both ' ' from v_registros.ciudad) AND
                       l.tipo in ('departamento','provincia','localidad') and l.estado_reg = 'activo';
            end if;
        else     
        	select id_lugar into v_id_lugar_pais
            from param.tlugar
            where codigo = TRIM(both ' ' from v_registros.pais) and estado_reg = 'activo';
                
            if (v_id_lugar_pais is null) then
                raise exception 'No se encontro el pais para la ciudad: %',v_registros.ciudad;
            end if;   	
        	--insert al pais en endesis
            if (pxp.f_get_variable_global('sincronizar') = 'true') then
            	v_conexion = migra.f_crear_conexion();
                
                select * FROM dblink(v_conexion, 
                'select nextval(''sss.tsg_lugar_id_lugar_seq'')',TRUE)AS t1(resp integer)
            	into v_id_lugar; 
                
                perform dblink_exec(v_conexion, 'INSERT INTO  
  					sss.tsg_lugar (id_lugar, fk_id_lugar, nivel, codigo, nombre)
                    values( ' || v_id_lugar || ', ' || v_id_lugar_pais || ',1, trim(both '' '' from ''' || v_registros.ciudad ||'''), trim(both '' '' from ''' || v_registros.nombre ||'''));', true);
                select * FROM dblink(v_conexion, 
                'select migracion.f_sincronizacion()',TRUE)AS t1(resp boolean)
            	into v_sinc; 
                v_conexion = migra.f_cerrar_conexion(v_conexion,'exito');
            else 
                --insert al pais en pxp
                INSERT INTO 
                  param.tlugar
                (
                  id_usuario_reg,              
                  codigo,
                  nombre,
                  id_lugar_fk,
                  tipo
                        
                )
                VALUES (
                  p_id_usuario,              
                  TRIM(both ' ' from v_registros.ciudad),
                  trim(both ' ' from  v_registros.nombre),
                  v_id_lugar_pais,
                  'localidad'
                );
            end if;
        end if;
    
    end loop;
     
    DROP FOREIGN TABLE informix.ciudad;     
     
    return 'exito';
  
EXCEPTION  				
	WHEN OTHERS THEN
			--update a la tabla informix.migracion
            v_resp = 'Ha ocurrido un error en la funcion '||v_nombre_funcion || '. El mensaje es : ' || SQLERRM ||'. Ciudad: '||v_registros.nombre||', codigo: '||v_registros.ciudad;
            
            return v_resp;
            
			
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;