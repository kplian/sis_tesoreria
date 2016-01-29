CREATE OR REPLACE FUNCTION tes.ft_solicitud_efectivo_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Obligaciones de Pago
 FUNCION: 		tes.ft_solicitud_efectivo_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tsolicitud_efectivo'
 AUTOR: 		 (gsarmiento)
 FECHA:	        24-11-2015 12:59:51
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

	v_nombre_funcion = 'tes.ft_solicitud_efectivo_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_SOLEFE_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		gsarmiento	
 	#FECHA:		24-11-2015 12:59:51
	***********************************/

	if(p_transaccion='TES_SOLEFE_SEL')then
     				
    	begin
        	v_filtro='';
            v_inner='';
            
            IF (v_parametros.id_funcionario_usu is null) then
              	
                v_parametros.id_funcionario_usu = -1;
            
            END IF;                        
            
            IF  lower(v_parametros.tipo_interfaz) in ('condetalle','sindetalle') THEN
                
                IF p_administrador !=1 THEN
                   v_filtro = '(solefe.id_funcionario='||v_parametros.id_funcionario_usu::varchar||'  or solefe.id_usuario_reg='||p_id_usuario||' ) and ';
                -- ELSE
                  --   v_filtro = '(pc.estado = ''solicitado'') and ';
                END IF;                
                
            END IF;
            IF lower(v_parametros.tipo_interfaz) = 'vbsolicitudefectivo' THEN
            	v_inner =  'inner join wf.testado_wf ew on ew.id_proceso_wf = solefe.id_proceso_wf';
            	IF p_administrador !=1 THEN
                   v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (solefe.estado = ''vbcajero'') and  ';
                 ELSE
                     v_filtro = '(solefe.estado = ''vbcajero'') and ';
                END IF;                
            END IF;
            /*
            IF  lower(v_parametros.tipo_interfaz) = 'cajaabierto' THEN
                
                IF p_administrador !=1 THEN
                   v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (pc.estado = ''abierto'') and  ';
                 ELSE
                     v_filtro = '(pc.estado = ''abierto'') and ';
                END IF;                
                
            END IF;
            
            IF  lower(v_parametros.tipo_interfaz) = 'caja' THEN
                
                IF p_administrador !=1 THEN
                   v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (pc.estado = ''borrador'') and  ';
                 ELSE
                     v_filtro = '(pc.estado = ''borrador'') and ';
                END IF;                
                
            END IF;*/
            
    		--Sentencia de la consulta
			v_consulta:='select
						solefe.id_solicitud_efectivo,
						solefe.id_caja,
                        caja.codigo,
                        caja.id_depto,
						solefe.id_estado_wf,
						solefe.monto,
						solefe.id_proceso_wf,
						solefe.nro_tramite,
						solefe.estado,
						solefe.estado_reg,
						solefe.motivo,
						solefe.id_funcionario,
                        fun.desc_funcionario1 as desc_funcionario,
						solefe.fecha,
						solefe.id_usuario_ai,
						solefe.fecha_reg,
						solefe.usuario_ai,
						solefe.id_usuario_reg,
						solefe.id_usuario_mod,
						solefe.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from tes.tsolicitud_efectivo solefe
						inner join segu.tusuario usu1 on usu1.id_usuario = solefe.id_usuario_reg
                        inner join tes.tcaja caja on caja.id_caja=solefe.id_caja
                        inner join orga.vfuncionario fun on fun.id_funcionario = solefe.id_funcionario
						left join segu.tusuario usu2 on usu2.id_usuario = solefe.id_usuario_mod
                        '||v_inner||'                      
				        where  ' || v_filtro;
			
			--Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'TES_SOLEFE_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		24-11-2015 12:59:51
	***********************************/

	elsif(p_transaccion='TES_SOLEFE_CONT')then

		begin
        	v_filtro='';
            v_inner='';
        	IF  lower(v_parametros.tipo_interfaz) in ('condetalle','sindetalle')THEN
                
                IF p_administrador !=1 THEN
                   v_filtro = '(solefe.id_funcionario='||v_parametros.id_funcionario_usu::varchar||'  or solefe.id_usuario_reg='||p_id_usuario||' ) and ';
                -- ELSE
                  --   v_filtro = '(pc.estado = ''solicitado'') and ';
                END IF;                
                
            END IF;
            
            IF lower(v_parametros.tipo_interfaz) = 'vbsolicitudefectivo' THEN
            	v_inner =  'inner join wf.testado_wf ew on ew.id_proceso_wf = solefe.id_proceso_wf';
            	IF p_administrador !=1 THEN
                   v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (solefe.estado = ''vbcajero'') and  ';
                 ELSE
                     v_filtro = '(solefe.estado = ''vbcajero'') and ';
                END IF;                
            END IF;
            
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_solicitud_efectivo)
					    from tes.tsolicitud_efectivo solefe
					    inner join segu.tusuario usu1 on usu1.id_usuario = solefe.id_usuario_reg
						inner join tes.tcaja caja on caja.id_caja=solefe.id_caja
                        inner join orga.vfuncionario fun on fun.id_funcionario = solefe.id_funcionario
						left join segu.tusuario usu2 on usu2.id_usuario = solefe.id_usuario_mod
                        '||v_inner||'
					    where '||v_filtro;
			
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