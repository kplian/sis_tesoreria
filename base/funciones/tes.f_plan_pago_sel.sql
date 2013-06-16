--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_plan_pago_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.f_plan_pago_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tplan_pago'
 AUTOR: 		 (admin)
 FECHA:	        10-04-2013 15:43:23
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

	v_nombre_funcion = 'tes.f_plan_pago_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_PLAPA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		10-04-2013 15:43:23
	***********************************/

	if(p_transaccion='TES_PLAPA_SEL')then
     				
    	begin
        
          
        
        
    		--Sentencia de la consulta
			v_consulta:='select
						plapa.id_plan_pago,
						plapa.estado_reg,
						plapa.nro_cuota,
						plapa.monto_ejecutar_total_mb,
						plapa.nro_sol_pago,
						plapa.tipo_cambio,
						plapa.fecha_pag,
						plapa.id_proceso_wf,
						plapa.fecha_dev,
						plapa.estado,
						plapa.tipo_pago,
						plapa.monto_ejecutar_total_mo,
						plapa.descuento_anticipo_mb,
						plapa.obs_descuentos_anticipo,
						plapa.id_plan_pago_fk,
						plapa.id_obligacion_pago,
						plapa.id_plantilla,
						plapa.descuento_anticipo,
						plapa.otros_descuentos,
						plapa.tipo,
						plapa.obs_monto_no_pagado,
						plapa.obs_otros_descuentos,
						plapa.monto,
						plapa.id_comprobante,
						plapa.nombre_pago,
						plapa.monto_no_pagado_mb,
						plapa.monto_mb,
						plapa.id_estado_wf,
						plapa.id_cuenta_bancaria,
						plapa.otros_descuentos_mb,
						plapa.forma_pago,
						plapa.monto_no_pagado,
						plapa.fecha_reg,
						plapa.id_usuario_reg,
						plapa.fecha_mod,
						plapa.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        plapa.fecha_tentativa,
                        pla.desc_plantilla,
                        plapa.liquido_pagable,
                        plapa.total_prorrateado,
                        plapa.total_pagado ,                       
						cb.nombre_institucion ||'' (''||cb.nro_cuenta||'')'' as desc_cuenta_bancaria                        
						from tes.tplan_pago plapa
                        left join param.tplantilla pla on pla.id_plantilla = plapa.id_plantilla
						inner join segu.tusuario usu1 on usu1.id_usuario = plapa.id_usuario_reg
                        left join tes.vcuenta_bancaria cb on cb.id_cuenta_bancaria = plapa.id_cuenta_bancaria
                        left join segu.tusuario usu2 on usu2.id_usuario = plapa.id_usuario_mod
                       where  plapa.estado_reg=''activo''  and ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

             raise notice '%',v_consulta;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'TES_PLAPA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		10-04-2013 15:43:23
	***********************************/

	elsif(p_transaccion='TES_PLAPA_CONT')then

		begin
        
         
        
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_plan_pago)
						from tes.tplan_pago plapa
                        left join param.tplantilla pla on pla.id_plantilla = plapa.id_plantilla
						inner join segu.tusuario usu1 on usu1.id_usuario = plapa.id_usuario_reg
                        left join tes.vcuenta_bancaria cb on cb.id_cuenta_bancaria = plapa.id_cuenta_bancaria
                        left join segu.tusuario usu2 on usu2.id_usuario = plapa.id_usuario_mod
                        where  plapa.estado_reg=''activo''   and ';
			
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