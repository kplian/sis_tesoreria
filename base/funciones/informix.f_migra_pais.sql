CREATE OR REPLACE FUNCTION informix.f_migra_pais (
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
BEGIN
  	v_nombre_funcion = 'informix.f_migra_pais';
	
    
    v_consulta = '''select p.pais,p.nombre
                    from pais p
                    where p.pais in (select pais from agencias group by pais)''';

	select informix.f_user_mapping() into v_resp;
    
    execute ('CREATE FOREIGN TABLE informix.pais (
      pais varchar(3),
      nombre varchar(200)
      ) SERVER sai1

    OPTIONS ( query ' || v_consulta || ',
    database ''ingresos'',
      informixdir ''/opt/informix'',
      client_locale ''en_US.utf8'',
      informixserver ''sai1'');');
   
    for v_registros in (select * from informix.pais) loop
    	        
        select count(l.id_lugar) into v_cantidad_lugares 
        from param.tlugar l
        where l.codigo = TRIM(both ' ' from v_registros.pais) AND
        l.tipo = 'pais' and l.estado_reg = 'activo';
        
        if (v_cantidad_lugares > 1) then
        	raise exception 'Existe mas de un pais con el mismo codigo';
        ELSIF(v_cantidad_lugares = 1) then	
            --update al pais en endesis
            if (pxp.f_get_variable_global('sincronizar') = 'true') then
            	v_conexion = migra.f_crear_conexion();
                perform dblink_exec(v_conexion, 'UPDATE 
  					sss.tsg_lugar
                    SET 
                      nombre = trim(both '' '' from ''' || v_registros.nombre ||''')
                    WHERE 
                      codigo = TRIM(both '' '' from ''' || v_registros.pais||''') AND
                    nivel = 0;', true);
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
                  codigo = TRIM(both ' ' from v_registros.pais) AND
                        l.tipo in ('pais') and l.estado_reg = 'activo';
            end if;
        else        	
        	--insert al pais en endesis
            if (pxp.f_get_variable_global('sincronizar') = 'true') then
            	v_conexion = migra.f_crear_conexion();
                select * FROM dblink(v_conexion, 
                'select nextval(''sss.tsg_lugar_id_lugar_seq'')',TRUE)AS t1(resp integer)
            	into v_id_lugar; 
                
                perform dblink_exec(v_conexion, 'INSERT INTO  
  					sss.tsg_lugar (id_lugar, fk_id_lugar, nivel, codigo, nombre)
                    values( ' || v_id_lugar || ', ' || v_id_lugar || ',0, trim(both '' '' from ''' || v_registros.pais ||'''), trim(both '' '' from ''' || v_registros.nombre ||'''));', true);
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
                  tipo
                        
                )
                VALUES (
                  p_id_usuario,              
                  TRIM(both ' ' from v_registros.pais),
                  trim(both ' ' from  v_registros.nombre),
                  'pais'
                );
            end if;
        end if;
    
    end loop;
     
    DROP FOREIGN TABLE informix.pais;     
     
    return 'exito';
  
EXCEPTION  				
	WHEN OTHERS THEN
			--update a la tabla informix.migracion
            v_resp = 'Ha ocurrido un error en la funcion '||v_nombre_funcion || '. El mensaje es : ' || SQLERRM ||'. Pais: '||v_registros.nombre;
            
            return v_resp;
            
			
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;