CREATE OR REPLACE FUNCTION informix.ft_boletoori_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Factura 
 FUNCION: 		informix.ft_liquitra_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'fac.tnota'
 AUTOR: 		 favio figueroa
 FECHA:	        29-12-2014 11:14:03
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			favio figueroa
 FECHA:		
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    us 					varchar;
			    
BEGIN


	
	v_nombre_funcion = 'informix.ft_boletoori_sel';
    v_parametros = pxp.f_get_record(p_tabla);
    

   
	--us = informix.f_user_mapping();
	
	/*********************************    
 	#TRANSACCION:  'FAC_BOLEORI_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Favio Figueroa Penarrieta
 	#FECHA:		29-12-2014 15:00:03
	***********************************/

	if(p_transaccion='FAC_BOLEORI_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
            			ori.bolori,
                        ori.billete,
                        ori.fecha,
                        ori.importe
                        
                         FROM informix.boletoori ori
				        where ori.billete = '|| v_parametros.billete;
                        
                        
            
                   
		
			
			--Definicion de la respuesta
        	  --v_consulta:= v_consulta || ' and ori.fecha >= '||v_parametros.fecha||' ';
          	v_consulta:= v_consulta || ' and ori.fecha >= ''2014-01-01'' ';
			--v_consulta:=v_consulta||v_parametros.filtro;
          
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			
            
			--Devuelve la respuesta
            
            
			return v_consulta;
						
		end;
        
        
        /*********************************    
 	#TRANSACCION:  'FAC_BOLEORI_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Favio Figueroa Penarrieta
 	#FECHA:		29-12-2014 15:00:03
	***********************************/

	elsif(p_transaccion='FAC_BOLEORIS_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select 
                          ori.bolori,
                          ori.fecha as fecha_ori,
                          factu.nit,
                          factu.razon,
                          factu.monto,
                          factu.exento,
                          factu.moneda,
                          factu.tcambio,
                          factu.fecha as fecha_fac
                        from informix.boletoori ori
                        inner join informix.facturas factu on factu.billete = ori.bolori
				        where ori.bolori = '|| v_parametros.bolori;
                        
                        
           
			
			--Definicion de la respuesta
        	  --v_consulta:= v_consulta || ' and ori.fecha >= '||v_parametros.fecha||' ';
          	--v_consulta:= v_consulta || ' and ori.fecha >= ''2014-01-01'' ';
			--v_consulta:=v_consulta||v_parametros.filtro;
          
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' offset ' || v_parametros.puntero;
			
         
			--Devuelve la respuesta
            
            
			return v_consulta;
						
		end;
        

	/*********************************    
 	#TRANSACCION:  'FAC_BOLEORI_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		Favio Figueroa Penarrieta
 	#FECHA:		18-11-2014 19:30:03
	***********************************/

	elsif(p_transaccion='FAC_BOLEORI_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(ori.billete) 
                         FROM informix.boletoori ori
					    where ';
			
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