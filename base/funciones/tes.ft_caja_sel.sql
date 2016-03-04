CREATE OR REPLACE FUNCTION tes.ft_caja_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.ft_caja_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tcaja'
 AUTOR: 		 (admin)
 FECHA:	        16-12-2013 20:43:44
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
			    
BEGIN

	v_nombre_funcion = 'tes.ft_caja_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_CAJA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		16-12-2013 20:43:44
	***********************************/

	if(p_transaccion='TES_CAJA_SEL')then
     				
    	begin
        
        	v_filtro='';
            v_inner='';
            
            IF (v_parametros.id_funcionario_usu is null) then
              	
                v_parametros.id_funcionario_usu = -1;
            
            END IF;
             
            
            IF  lower(v_parametros.tipo_interfaz) = 'caja' THEN
                
                IF p_administrador !=1 THEN
                   v_filtro = '(caja.id_usuario_reg='||p_id_usuario||' ) and  pc.estado in (''borrador'',''abierto'',''cerrado'',''anulado'') and  ';
                 ELSE
                     v_filtro = 'pc.estado in (''borrador'',''abierto'',''cerrado'',''anulado'') and ';
                END IF;                
                
            END IF;                       
            
            IF  lower(v_parametros.tipo_interfaz) = 'cajavb' THEN
                
				v_inner =  'inner join wf.testado_wf ew on ew.id_proceso_wf = pc.id_proceso_wf';
                
                IF p_administrador !=1 THEN
                   v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||') and  (pc.estado = ''solicitado'') and  ';
                 ELSE
                     v_filtro = '(pc.estado = ''solicitado'') and ';
                END IF;                
                
            END IF;
            
            IF  lower(v_parametros.tipo_interfaz) = 'cajaabierto' THEN
                
                --IF p_administrador !=1 THEN
                --   v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (pc.estado = ''abierto'') and  ';
                -- ELSE
                     v_filtro = '(caja.estado = ''abierto'') and ';
               -- END IF;                
                
            END IF;
            
            IF  lower(v_parametros.tipo_interfaz) = 'cajacajero' THEN
                
                IF p_administrador !=1 THEN
                   v_filtro = '(caje.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (pc.estado = ''abierto'') and  ';
                 ELSE
                     v_filtro = '(pc.estado in (''abierto'',''cerrado'')) and ';
                END IF;                
                
            END IF;
                        
    		--Sentencia de la consulta
			v_consulta:='select
						caja.id_caja,
						caja.estado,
						caja.importe_maximo,
                        caja.importe_maximo -(select sum(monto) from tes.tsolicitud_efectivo where id_caja=caja.id_caja and estado=''entregado'') as saldo,
						caja.tipo,
						caja.estado_reg,
                        pc.estado as estado_proceso,
						caja.porcentaje_compra,
						caja.id_moneda,
						caja.id_depto,
                        caja.id_cuenta_bancaria,
                        ctab.nro_cuenta ||''-'' ||ctab.denominacion as id_cuenta_bancaria,
						caja.codigo,
                        fun.desc_funcionario1 as cajero,
						caja.id_usuario_reg,
						caja.fecha_reg,
						caja.id_usuario_mod,
						caja.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						mon.moneda as desc_moneda,	
						depto.nombre as desc_depto,
                        caja.tipo_ejecucion,
                        pc.id_proceso_wf,
				        pc.id_estado_wf,
       					pc.nro_tramite
						from tes.tcaja caja
						inner join segu.tusuario usu1 on usu1.id_usuario = caja.id_usuario_reg
                        inner join tes.tproceso_caja pc on pc.id_caja= caja.id_caja
						left join segu.tusuario usu2 on usu2.id_usuario = caja.id_usuario_mod
						inner join param.tmoneda mon on mon.id_moneda= caja.id_moneda
						inner join param.tdepto depto on depto.id_depto=caja.id_depto
                        left join tes.tcuenta_bancaria ctab on ctab.id_cuenta_bancaria=caja.id_cuenta_bancaria
                        left join tes.tcajero caje on caje.id_caja=caja.id_caja and caje.tipo=''responsable''
						left join orga.vfuncionario fun on fun.id_funcionario=caje.id_funcionario
                        '||v_inner||'   
                        where  '||v_filtro;
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			raise notice '%', v_consulta;
			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'TES_CAJA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		16-12-2013 20:43:44
	***********************************/

	elsif(p_transaccion='TES_CAJA_CONT')then

		begin
        	v_filtro='';
            v_inner='';
            
            IF (v_parametros.id_funcionario_usu is null) then
              	
                v_parametros.id_funcionario_usu = -1;
            
            END IF;                        
            
            IF  lower(v_parametros.tipo_interfaz) = 'cajavb' THEN
            
                v_inner =  'inner join wf.testado_wf ew on ew.id_proceso_wf = pc.id_proceso_wf';
                
                IF p_administrador !=1 THEN
                   v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||') and  (pc.estado = ''solicitado'') and  ';
                 ELSE
                     v_filtro = '(pc.estado = ''solicitado'') and ';
                END IF;                
                
            END IF;
            
            IF  lower(v_parametros.tipo_interfaz) = 'cajaabierto' THEN
                
               -- IF p_administrador !=1 THEN
               --    v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (pc.estado = ''abierto'') and  ';
               --  ELSE
                     v_filtro = '(pc.estado = ''abierto'') and ';
               -- END IF;                
                
            END IF;
            
            IF  lower(v_parametros.tipo_interfaz) = 'caja' THEN
                
                IF p_administrador !=1 THEN
                   v_filtro = '(caja.id_usuario_reg='||p_id_usuario||' ) and  pc.estado in (''borrador'',''abierto'',''cerrado'',''anulado'') and  ';
                 ELSE
                     v_filtro = 'pc.estado in (''borrador'',''abierto'',''cerrado'',''anulado'') and ';
                END IF;                
                
            END IF;
            
            IF  lower(v_parametros.tipo_interfaz) = 'cajacajero' THEN
                
                IF p_administrador !=1 THEN
                   v_filtro = '(caje.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (pc.estado = ''abierto'') and  ';
                 ELSE
                     v_filtro = '(pc.estado in (''abierto'',''cerrado'')) and ';
                END IF;                
                
            END IF;
            
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(caja.id_caja)
					    from tes.tcaja caja
					    inner join segu.tusuario usu1 on usu1.id_usuario = caja.id_usuario_reg
            			inner join tes.tproceso_caja pc on pc.id_caja= caja.id_caja
						left join segu.tusuario usu2 on usu2.id_usuario = caja.id_usuario_mod
						inner join param.tmoneda mon on mon.id_moneda= caja.id_moneda
                        inner join param.tdepto depto on depto.id_depto=caja.id_depto
                        left join tes.tcuenta_bancaria ctab on ctab.id_cuenta_bancaria=caja.id_cuenta_bancaria
                        left join tes.tcajero caje on caje.id_caja=caja.id_caja and caje.tipo=''responsable''
						left join orga.vfuncionario fun on fun.id_funcionario=caje.id_funcionario
					    '||v_inner||'   
                        where  '||v_filtro;
			
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