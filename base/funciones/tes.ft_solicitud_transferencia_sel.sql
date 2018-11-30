--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.ft_solicitud_transferencia_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.ft_solicitud_transferencia_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tsolicitud_transferencia'
 AUTOR: 		 (admin)
 FECHA:	        22-02-2018 03:43:11
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				22-02-2018 03:43:11								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tsolicitud_transferencia'	
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_filtro			varchar;
    v_id_funcionario_usuario	integer;
			    
BEGIN

	v_nombre_funcion = 'tes.ft_solicitud_transferencia_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_SOLTRA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		22-02-2018 03:43:11
	***********************************/

	if(p_transaccion='TES_SOLTRA_SEL')then
     				
    	begin
        	v_filtro = '';
            if (v_parametros.interfaz = 'solicitud' and p_administrador = 0) then
            	v_filtro = ' and soltra.id_usuario_reg = '|| p_id_usuario;
            end if;
            
            SELECT coalesce(fun.id_funcionario,-1) into v_id_funcionario_usuario
            from segu.tusuario u
            inner join orga.tfuncionario fun on fun.id_persona = u.id_persona
            where u.id_usuario = p_id_usuario;
            
            if (v_parametros.interfaz = 'aprobacion' and p_administrador = 0) then
            	v_filtro = ' and es.id_funcionario = '|| v_id_funcionario_usuario;
            end if;  
    		--Sentencia de la consulta
			v_consulta:='select
						soltra.id_solicitud_transferencia,
						soltra.id_cuenta_origen,
						soltra.id_cuenta_destino,
						soltra.id_proceso_wf,
						soltra.id_estado_wf,
						soltra.monto,
						soltra.motivo,
						soltra.num_tramite,
						soltra.estado_reg,
						soltra.id_usuario_ai,
						soltra.fecha_reg,
						soltra.usuario_ai,
						soltra.id_usuario_reg,
						soltra.fecha_mod,
						soltra.id_usuario_mod,
						soltra.estado,
						cbo.nro_cuenta as desc_cuenta_origen,
						cbd.nro_cuenta as desc_cuenta_destino,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from tes.tsolicitud_transferencia soltra
						left join tes.tcuenta_bancaria cbo on cbo.id_cuenta_bancaria = soltra.id_cuenta_origen
						inner join tes.tcuenta_bancaria cbd on cbd.id_cuenta_bancaria = soltra.id_cuenta_destino
						inner join segu.tusuario usu1 on usu1.id_usuario = soltra.id_usuario_reg
						inner join wf.testado_wf es on es.id_estado_wf = soltra.id_estado_wf
                        left join segu.tusuario usu2 on usu2.id_usuario = soltra.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||v_filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'TES_SOLTRA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		22-02-2018 03:43:11
	***********************************/

	elsif(p_transaccion='TES_SOLTRA_CONT')then

		begin
        	v_filtro = '';
            if (v_parametros.interfaz = 'solicitud' and p_administrador = 0) then
            	v_filtro = ' and soltra.id_usuario_reg = '|| p_id_usuario;
            end if;
            
            SELECT coalesce(fun.id_funcionario,-1) into v_id_funcionario_usuario
            from segu.tusuario u
            inner join orga.tfuncionario fun on fun.id_persona = u.id_persona
            where u.id_usuario = p_id_usuario;
            
            if (v_parametros.interfaz = 'aprobacion' and p_administrador = 0) then
            	v_filtro = ' and ewf.id_funcionario = '|| v_id_funcionario_usuario;
            end if;  
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_solicitud_transferencia)
					    from tes.tsolicitud_transferencia soltra
					    left join tes.tcuenta_bancaria cbo on cbo.id_cuenta_bancaria = soltra.id_cuenta_origen
						inner join tes.tcuenta_bancaria cbd on cbd.id_cuenta_bancaria = soltra.id_cuenta_destino
					    inner join segu.tusuario usu1 on usu1.id_usuario = soltra.id_usuario_reg
						inner join wf.testado_wf es on es.id_estado_wf = soltra.id_estado_wf
                        left join segu.tusuario usu2 on usu2.id_usuario = soltra.id_usuario_mod
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