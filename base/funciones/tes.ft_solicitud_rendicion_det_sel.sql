--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.ft_solicitud_rendicion_det_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Obligaciones de Pago
 FUNCION: 		tes.ft_solicitud_rendicion_det_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tsolicitud_rendicion_det'
 AUTOR: 		 (gsarmiento)
 FECHA:	        16-12-2015 15:14:01
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

	v_nombre_funcion = 'tes.ft_solicitud_rendicion_det_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_REND_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		gsarmiento	
 	#FECHA:		16-12-2015 15:14:01
	***********************************/

	if(p_transaccion='TES_REND_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						rend.id_solicitud_rendicion_det,
						rend.id_solicitud_efectivo,
						rend.id_documento_respaldo as id_doc_compra_venta,
                        pla.desc_plantilla,
       					mon.codigo as desc_moneda,
                        dc.tipo,
                        dc.id_plantilla,
                        dc.id_moneda,
                        dc.fecha,
                        dc.nit,
                        dc.razon_social,
                        dc.nro_autorizacion,
                        dc.nro_documento,
                        dc.nro_dui,
                        dc.obs,
                        dc.importe_doc,
                        dc.importe_pago_liquido,
                        dc.importe_iva,
                        dc.importe_descuento,
                        dc.importe_descuento_ley,
                        dc.importe_excento,
                        dc.importe_ice,
						rend.estado_reg,
						rend.monto,
						rend.id_usuario_reg,
						rend.fecha_reg,
						rend.usuario_ai,
						rend.id_usuario_ai,
						rend.fecha_mod,
						rend.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        solefe.nro_tramite,
                        solren.id_proceso_wf,
				        solren.id_estado_wf,
                        caja.id_depto	
						from tes.tsolicitud_rendicion_det rend
                        inner join tes.tsolicitud_efectivo solren on solren.id_solicitud_efectivo = rend.id_solicitud_efectivo
                        inner join tes.tsolicitud_efectivo solefe on solefe.id_solicitud_efectivo=solren.fk_id_solicitud_efectivo
                        inner join tes.tcaja caja on caja.id_caja=solefe.id_caja
                        left join conta.tdoc_compra_venta dc on dc.id_doc_compra_venta=rend.id_documento_respaldo
                        left join param.tplantilla pla on pla.id_plantilla = dc.id_plantilla
						left join param.tmoneda mon on mon.id_moneda = dc.id_moneda
						inner join segu.tusuario usu1 on usu1.id_usuario = rend.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = rend.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'TES_REND_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		16-12-2015 15:14:01
	***********************************/

	elsif(p_transaccion='TES_REND_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_solicitud_rendicion_det)
					    from tes.tsolicitud_rendicion_det rend
                        inner join tes.tsolicitud_efectivo solren on solren.id_solicitud_efectivo = rend.id_solicitud_efectivo
                        inner join tes.tsolicitud_efectivo solefe on solefe.id_solicitud_efectivo=solren.fk_id_solicitud_efectivo
                        inner join tes.tcaja caja on caja.id_caja=solefe.id_caja
                        left join conta.tdoc_compra_venta dc on dc.id_doc_compra_venta=rend.id_documento_respaldo
                        left join param.tplantilla pla on pla.id_plantilla = dc.id_plantilla
						left join param.tmoneda mon on mon.id_moneda = dc.id_moneda
					    inner join segu.tusuario usu1 on usu1.id_usuario = rend.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = rend.id_usuario_mod
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