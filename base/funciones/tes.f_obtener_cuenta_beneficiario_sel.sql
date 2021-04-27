-- FUNCTION: param.f_financiador_sel(integer, integer, character varying, character varying)

-- DROP FUNCTION param.f_financiador_sel(integer, integer, character varying, character varying);

CREATE OR REPLACE FUNCTION tes.f_obtener_cuenta_beneficiario_sel(
	p_administrador integer,
	p_id_usuario integer,
	p_tabla character varying,
	p_transaccion character varying)
    RETURNS character varying
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
/**************************************************************************
 SISTEMA:		TES
 FUNCION: 		tes.f_financiador_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'param.tfinanciador'
 AUTOR: 		
 FECHA:	        
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
			    
BEGIN

	v_nombre_funcion = 'tes.f_obtener_cuenta_beneficiario_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PM_fin_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		05-02-2013 22:30:22
	***********************************/

	if(p_transaccion='TS_CTABEN_SEL')then
     				
    	begin
        
            if pxp.f_existe_parametro(p_tabla , 'beneficiario')then
              if(v_parametros.beneficiario is not null) then
                  
              end if;
            end if;
        
    		--Sentencia de la consulta
			v_consulta:='
                    select cb.nro_cuenta, i.nombre, i.id_institucion, (cb.nro_cuenta||''-''|| i.nombre) as desc_cuenta,f.id_funcionario as id, ''funcionario'' as tipo from orga.vfuncionario f
                    inner join orga.tfuncionario_cuenta_bancaria cb on cb.id_funcionario=f.id_funcionario
                    inner join param.tinstitucion i on i.id_institucion=cb.id_institucion
                    where f.desc_funcionario1 like '''||v_parametros.beneficiario||''' or desc_funcionario2 like '''||v_parametros.beneficiario||'''
                    union
                    select cb.nro_cuenta, i.nombre, i.id_institucion,(cb.nro_cuenta||''-''|| i.nombre) as desc_cuenta,  p.id_proveedor as id, ''proveedor'' as tipo from param.vproveedor p inner join param.tproveedor_cta_bancaria cb on cb.id_proveedor=p.id_proveedor
                    inner join param.tinstitucion i on i.id_institucion=cb.id_banco_beneficiario
                    where p.desc_proveedor like '''||v_parametros.beneficiario||''' or p.desc_proveedor2 like '''||v_parametros.beneficiario||''' 
                    union
                    (select lb.nro_cta_bancaria, i.nombre, i.id_institucion,(lb.nro_cta_bancaria||''-''|| i.nombre) as desc_cuenta,  0 as id, ''lb'' as tipo 
                    from tes.tts_libro_bancos lb
                    inner join param.tinstitucion i on i.id_institucion=lb.id_institucion_cta_bancaria
                    where lb.a_favor like  '''||v_parametros.beneficiario||'''
                    order by lb.id_libro_bancos desc limit 1)
                    order by id desc , tipo
                    ';
			
			
			--Devuelve la respuesta
			return v_consulta;
						
		end;

	elsif(p_transaccion='TS_CTABEN_CONT')then
     				
    	begin
        v_consulta:='select (
                    (select count (*) from orga.vfuncionario f
                    inner join orga.tfuncionario_cuenta_bancaria cb on cb.id_funcionario=f.id_funcionario
                    inner join param.tinstitucion i on i.id_institucion=cb.id_institucion
                    where f.desc_funcionario1 like '''||v_parametros.beneficiario||''' or desc_funcionario2 like '''||v_parametros.beneficiario||'''
                    )+
                    (select count (*) from param.vproveedor p inner join param.tproveedor_cta_bancaria cb on cb.id_proveedor=p.id_proveedor
                    inner join param.tinstitucion i on i.id_institucion=cb.id_banco_beneficiario
                    where p.desc_proveedor like '''||v_parametros.beneficiario||''' or p.desc_proveedor2 like '''||v_parametros.beneficiario||''')
                    +
                    (select count (*) from tes.tts_libro_bancos lb
                    inner join param.tinstitucion i on i.id_institucion=lb.id_institucion_cta_bancaria
                    where lb.a_favor like  '''||v_parametros.beneficiario||''' limit 1)
                    
                    
                    ) as total ';
			
			
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
$BODY$;

ALTER FUNCTION tes.f_obtener_cuenta_beneficiario_sel(integer, integer, character varying, character varying)
    OWNER TO postgres;