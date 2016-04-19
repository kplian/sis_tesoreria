CREATE OR REPLACE FUNCTION informix.ft_liquidevolu_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Factura 
 FUNCION: 		informix.ft_liquidevolu_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'fac.tnota'
 AUTOR: 		 favio figueroa
 FECHA:	        18-11-2014 19:30:03
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    us 					varchar;
    v_sucursales		varchar;
			    
BEGIN

	v_nombre_funcion = 'informix.ft_liquidevolu_sel';
    v_parametros = pxp.f_get_record(p_tabla);
   
	us = informix.f_user_mapping();
	
	/*********************************    
 	#TRANSACCION:  'FAC_LIQUI_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Favio Figueroa Penarrieta
 	#FECHA:		28-11-2014 15:00:03
	***********************************/

	if(p_transaccion='FAC_LIQUI_SEL')then
     				
    	begin
        
       		v_sucursales := decr.f_usuario_sucursal(p_id_usuario);
    		--Sentencia de la consulta
			v_consulta:='select
            			 li.pais,
                         li.estacion,
                         li.docmnt,
                         li.nroliqui,
                         li.fecha,
                         li.estpago,
                         li.estado
                         FROM informix.liquidevolu li
				        where  ' || v_sucursales;
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'FAC_LIQUI_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		Favio Figueroa Penarrieta
 	#FECHA:		18-11-2014 19:30:03
	***********************************/

	elsif(p_transaccion='FAC_LIQUI_CONT')then

		begin
        
        v_sucursales := decr.f_usuario_sucursal(p_id_usuario);
        
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(li.nroliqui) 
                         FROM informix.liquidevolu li 
					    where ' || v_sucursales;
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
					
	else
					     
		raise exception 'Transaccion inexistente';
					         
	end if;
					
EXCEPTION
					
	WHEN OTHERS THEN
			v_resp='';
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
			v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
			v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
			raise exception '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;