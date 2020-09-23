--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_cuenta_bancaria_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.f_cuenta_bancaria_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tcuenta_bancaria'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        24-04-2013 15:19:30
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

#ISSUE          FECHA        AUTOR        			DESCRIPCION
#ETR-1074           23/09/2020      manuel guerrra       muestra el listado de cuentas de bancos que crea el usuario
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    --v_id_usuario		integer;
    v_filtro 			varchar;
			    
BEGIN

	v_nombre_funcion = 'tes.f_cuenta_bancaria_sel';
    v_parametros = pxp.f_get_record(p_tabla);
    
    /*if(pxp.f_existe_parametro('p_tabla','id_usuario')='true')then
        v_id_usuario = v_parametros.id_usuario;
    else
        v_id_usuario = p_id_usuario;
    end if;*/
    
	/*********************************    
 	#TRANSACCION:  'TES_CTABAN_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		24-04-2013 15:19:30
	***********************************/

	if(p_transaccion='TES_CTABAN_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select DISTINCT
                          ctaban.id_cuenta_bancaria,
                          ctaban.estado_reg,
                          ctaban.fecha_baja,
                          ctaban.nro_cuenta,
                          ctaban.fecha_alta,
                          ctaban.id_institucion,
                          inst.nombre as nombre_institucion,
                          inst.doc_id,
                          ctaban.fecha_reg,
                          ctaban.id_usuario_reg,
                          ctaban.fecha_mod,
                          ctaban.id_usuario_mod,
                          usu1.cuenta as usr_reg,
                          usu2.cuenta as usr_mod,
                          mon.id_moneda,	
                          mon.codigo as codigo_moneda,
                          ctaban.denominacion,
                          ctaban.centro
						from tes.tcuenta_bancaria ctaban
                        inner join param.tinstitucion inst on inst.id_institucion = ctaban.id_institucion
                        left join param.tmoneda mon on mon.id_moneda =  ctaban.id_moneda
						inner join segu.tusuario usu1 on usu1.id_usuario = ctaban.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ctaban.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'TES_CTABAN_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		24-04-2013 15:19:30
	***********************************/

	elsif(p_transaccion='TES_CTABAN_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(DISTINCT id_cuenta_bancaria)
					    from tes.tcuenta_bancaria ctaban
                        inner join param.tinstitucion inst on inst.id_institucion = ctaban.id_institucion                        
                        left join param.tmoneda mon on mon.id_moneda =  ctaban.id_moneda
                        inner join segu.tusuario usu1 on usu1.id_usuario = ctaban.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ctaban.id_usuario_mod
					    where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
        
    /*********************************    
 	#TRANSACCION:  'TES_USRCTABAN_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		27-11-2014 15:19:30
	***********************************/

	elsif(p_transaccion='TES_USRCTABAN_SEL')then
     				
    	begin
            raise notice 'id_usuario_otro %', v_parametros.permiso;
    		--Sentencia de la consulta

            v_filtro = '';
            IF p_administrador !=1 THEN
               v_filtro = 'usrbanc.id_usuario='||p_id_usuario||' and ' ;
            END IF;
                           
            --if(v_id_usuario!=1)then
				v_consulta:='select DISTINCT
                                ctaban.id_cuenta_bancaria,
                                ctaban.estado_reg,
                                ctaban.fecha_baja,
                                ctaban.nro_cuenta,
                                ctaban.fecha_alta,
                                ctaban.id_institucion,
                                inst.nombre as nombre_institucion,
                                ctaban.fecha_reg,
                                ctaban.id_usuario_reg,
                                ctaban.fecha_mod,
                                ctaban.id_usuario_mod,
                                usu1.cuenta as usr_reg,
                                usu2.cuenta as usr_mod,
                                mon.id_moneda,	
                                mon.codigo as codigo_moneda,
                                ctaban.denominacion,
                                ctaban.centro,
                                array_to_string( ctaban.id_finalidad,'','',''null'')::varchar as id_finalidads
						from tes.tcuenta_bancaria ctaban
                        inner join param.tinstitucion inst on inst.id_institucion = ctaban.id_institucion
                        inner join tes.tdepto_cuenta_bancaria deptctab on deptctab.id_cuenta_bancaria=ctaban.id_cuenta_bancaria
                        left join param.tmoneda mon on mon.id_moneda =  ctaban.id_moneda                        
                        left join tes.tfinalidad fin on fin.id_finalidad=ANY(ctaban.id_finalidad) ';
                IF p_administrador !=1 THEN
                	--#ETR-1074 
               		v_consulta = v_consulta || 'inner join tes.tusuario_cuenta_banc usrbanc on usrbanc.id_cuenta_bancaria=ctaban.id_cuenta_bancaria or usrbanc.id_usuario='||p_id_usuario||'';
            	END IF;                        
                    v_consulta = v_consulta || 'inner join segu.tusuario usu1 on usu1.id_usuario = ctaban.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ctaban.id_usuario_mod
				        where ' ||v_filtro||'';
                        
                IF p_administrador !=1 THEN
                	IF (v_parametros.permiso = 'libro_bancos')THEN
               			v_consulta = v_consulta || ' usrbanc.tipo_permiso in (''todos'',''libro_bancos'') and ';
                    END IF;
            	END IF;                                
                        
				raise notice 'sarmiento %', v_parametros.filtro;
				--Definicion de la respuesta
				v_consulta:=v_consulta||v_parametros.filtro;                
           		v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
                
			raise notice 'notice %', v_consulta;
			--Devuelve la respuesta
			return v_consulta;
						
		end;
    
    /*********************************    
 	#TRANSACCION:  'TES_USRCTABAN_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		27-11-2014 15:19:30
	***********************************/

	elsif(p_transaccion='TES_USRCTABAN_CONT')then

		begin
        	v_filtro = '';
            IF p_administrador !=1 THEN
               v_filtro = 'usrbanc.id_usuario='||p_id_usuario|| ' and ' ;
            END IF;
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(DISTINCT ctaban.id_cuenta_bancaria)
					    from tes.tcuenta_bancaria ctaban
                        inner join param.tinstitucion inst on inst.id_institucion = ctaban.id_institucion
                        inner join tes.tdepto_cuenta_bancaria deptctab on deptctab.id_cuenta_bancaria=ctaban.id_cuenta_bancaria
                        left join param.tmoneda mon on mon.id_moneda =  ctaban.id_moneda
                        left join tes.tfinalidad fin on fin.id_finalidad=ANY(ctaban.id_finalidad) ';
            
            IF p_administrador !=1 THEN
            	v_consulta = v_consulta || 'inner join tes.tusuario_cuenta_banc usrbanc on usrbanc.id_cuenta_bancaria=ctaban.id_cuenta_bancaria or usrbanc.id_usuario='||p_id_usuario||'';
            END IF; 
            
            v_consulta = v_consulta || 'inner join segu.tusuario usu1 on usu1.id_usuario = ctaban.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ctaban.id_usuario_mod
					    where '||v_filtro||'';
			
            IF p_administrador !=1 THEN
                IF (v_parametros.permiso = 'libro_bancos')THEN
                    v_consulta = v_consulta || ' usrbanc.tipo_permiso in (''todos'',''libro_bancos'') and ';
                END IF;
            END IF; 
                
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;
			raise notice '%', v_consulta;
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
PARALLEL UNSAFE
COST 100;