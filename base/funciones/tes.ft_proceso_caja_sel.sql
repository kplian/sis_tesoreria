--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.ft_proceso_caja_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Obligaciones de Pago
 FUNCION: 		tes.ft_proceso_caja_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tproceso_caja'
 AUTOR: 		 (gsarmiento)
 FECHA:	        21-12-2015 20:15:22
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
    v_filtro			varchar;
    v_inner				varchar;
    va_id_depto			integer[];
			    
BEGIN

	v_nombre_funcion = 'tes.ft_proceso_caja_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_REN_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		gsarmiento	
 	#FECHA:		21-12-2015 20:15:22
	***********************************/

	if(p_transaccion='TES_REN_SEL')then
     				
    	begin
        	v_filtro='';
            v_inner='';
            
            -- obtiene los departamentos del usuario
            select  
                pxp.aggarray(depu.id_depto)
            into 
                va_id_depto
            from param.tdepto_usuario depu 
            where depu.id_usuario =  p_id_usuario; 
            
            IF (v_parametros.id_funcionario_usu is null) then
              	
                v_parametros.id_funcionario_usu = -1;
            
            END IF;
            
            IF  lower(v_parametros.tipo_interfaz) = 'procesocajavbfondos' THEN
                
                IF p_administrador !=1 THEN
                   v_inner =  ' inner join wf.testado_wf ew on ew.id_estado_wf = ren.id_estado_wf ';
                   v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||') and  (lower(ren.estado) in (''vbfondos'')) and ';
                 ELSE
                     v_filtro = ' (lower(ren.estado) in (''vbfondos'')) and ';
                END IF;                
                
            END IF; 

            IF  lower(v_parametros.tipo_interfaz) = 'procesocajavbconta' THEN
                
                IF p_administrador !=1 THEN
                   v_inner =  ' inner join wf.testado_wf ew on ew.id_estado_wf = ren.id_estado_wf ';
                   v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' or (ew.id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||'))  ) and  (lower(ren.estado) in (''supconta'',''vbconta'',''pendiente'',''contabilizado'',''rendido'')) and ';
                 ELSE
                     v_filtro = ' (lower(ren.estado) in (''supconta'',''vbconta'',''pendiente'',''contabilizado'',''rendido'')) and ';
                END IF;
                
                
            END IF; 
            
            IF  lower(v_parametros.tipo_interfaz) = 'procesocajavbpresup' THEN
                
                IF p_administrador !=1 THEN
                   v_inner =  ' inner join wf.testado_wf ew on ew.id_estado_wf = ren.id_estado_wf ';
                   v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||') and  (lower(ren.estado)=''vbpresup'') and ';
                 ELSE
                     v_filtro = ' (lower(ren.estado)=''vbpresup'') and ';
                END IF;
                
                
            END IF; 
            
    		--Sentencia de la consulta
			v_consulta:='select
						ren.id_proceso_caja,
						ren.estado,
						ren.id_int_comprobante,
						ren.nro_tramite,
						ren.tipo,
						ren.motivo,
						ren.estado_reg,
						ren.fecha_fin,
						ren.id_caja,
                        cj.id_depto_lb,
						ren.fecha,
						ren.id_proceso_wf,
						ren.monto_reposicion,
						ren.id_estado_wf,
						ren.fecha_inicio,
						ren.fecha_reg,
						ren.usuario_ai,
						ren.id_usuario_reg,
						ren.id_usuario_ai,
						ren.fecha_mod,
						ren.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        tpc.nombre,
                        cj.id_moneda	
						from tes.tproceso_caja ren
						inner join segu.tusuario usu1 on usu1.id_usuario = ren.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ren.id_usuario_mod
                        left join tes.ttipo_proceso_caja tpc on tpc.id_tipo_proceso_caja=ren.id_tipo_proceso_caja 
                        left join tes.tcaja cj on cj.id_caja=ren.id_caja
                        '||v_inner||' 
				        where ' ||v_filtro;
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			raise notice '%', v_consulta;
			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'TES_REN_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		21-12-2015 20:15:22
	***********************************/

	elsif(p_transaccion='TES_REN_CONT')then

		begin
        	v_filtro='';
            v_inner='';
            
            -- obtiene los departamentos del usuario
            select  
                pxp.aggarray(depu.id_depto)
            into 
                va_id_depto
            from param.tdepto_usuario depu 
            where depu.id_usuario =  p_id_usuario; 
            
            IF (v_parametros.id_funcionario_usu is null) then
              	
                v_parametros.id_funcionario_usu = -1;
            
            END IF;
            
            IF  lower(v_parametros.tipo_interfaz) = 'procesocajavb' THEN
                
                IF p_administrador !=1 THEN
                   v_inner =  ' inner join wf.testado_wf ew on ew.id_estado_wf = ren.id_estado_wf ';
                   v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' or (ew.id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||'))  ) and  (lower(ren.estado)!=''borrador'') and ';
                 ELSE
                     v_filtro = ' (lower(ren.estado)!=''borrador'') and ';
                END IF;
                
                
            END IF; 
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_proceso_caja)
					    from tes.tproceso_caja ren
					    inner join segu.tusuario usu1 on usu1.id_usuario = ren.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ren.id_usuario_mod
                        left join tes.ttipo_proceso_caja tpc on tpc.id_tipo_proceso_caja=ren.id_tipo_proceso_caja 
                        left join tes.tcaja cj on cj.id_caja=ren.id_caja
                        '||v_inner||'
					    where '||v_filtro;
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
    
	/*********************************    
 	#TRANSACCION:  'TES_DEPCAJ_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		gsarmiento	
 	#FECHA:		17-05-2016 20:15:22
	***********************************/

	elsif(p_transaccion='TES_DEPCAJ_SEL')then

    	v_consulta:='select cb.id_cuenta_bancaria, cb.denominacion ||'' ''||cb.nro_cuenta as desc_cuenta_bancaria, t.fecha, t.tipo, t.nro_deposito,
        			 t.importe_deposito, t.origen, f.nombre_finalidad,t.id_libro_bancos, t.observaciones, t.detalle, t.sistema_origen,
                     COALESCE(dcd.importe_contable_deposito,t.importe_deposito)::numeric as importe_contable_deposito
					 from tes.tts_libro_bancos t
					 inner join tes.tcuenta_bancaria cb on cb.id_cuenta_bancaria=t.id_cuenta_bancaria
					 inner join tes.tfinalidad f on f.id_finalidad=t.id_finalidad
                     left join cd.tdeposito_cd dcd on dcd.id_cuenta_doc='|| v_parametros.columna_pk_valor || 'and dcd.id_libro_bancos=t.id_libro_bancos
					 where t.tabla='''||v_parametros.tabla||'''
					 and t.columna_pk = '''||v_parametros.columna_pk||''' 
                     and t.columna_pk_valor='||v_parametros.columna_pk_valor||' and ';
        
		v_consulta:=v_consulta||v_parametros.filtro;
        
        v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
		raise notice 'v_consulta %',v_consulta;
        return v_consulta;
    
    /*********************************    
 	#TRANSACCION:  'TES_DEPCAJ_CONT'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		gsarmiento	
 	#FECHA:		29-05-2016 20:15:22
	***********************************/

	elsif(p_transaccion='TES_DEPCAJ_CONT')then
		
    	v_consulta:='select count(cb.id_cuenta_bancaria)
					 from tes.tts_libro_bancos t
					 inner join tes.tcuenta_bancaria cb on cb.id_cuenta_bancaria=t.id_cuenta_bancaria
					 inner join tes.tfinalidad f on f.id_finalidad=t.id_finalidad
					 where t.tabla='''||v_parametros.tabla||'''
					 and t.columna_pk = '''||v_parametros.columna_pk||''' 
                     and t.columna_pk_valor='||v_parametros.columna_pk_valor|| ' and ';
        
		v_consulta:=v_consulta||v_parametros.filtro;
        
        return v_consulta;
    
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