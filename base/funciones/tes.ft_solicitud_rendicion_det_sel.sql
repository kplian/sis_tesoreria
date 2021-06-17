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
    v_valor				varchar;
    v_aux  record;
			    
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
                        dc.codigo_control,
                        dc.nro_dui,
                        dc.obs,
                        dc.importe_doc,
                        dc.importe_pago_liquido,
                        dc.importe_iva,
                        COALESCE(dc.importe_descuento,0.00),
                        dc.importe_descuento_ley,
                        dc.importe_excento,
                        COALESCE(dc.importe_ice,0.00),
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
                        inner join tes.tsolicitud_efectivo solefe on solefe.id_solicitud_efectivo=solren.id_solicitud_efectivo_fk
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
            
            raise notice '.. % ..',v_consulta;
            --raise exception '.. % ..',v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;
	
    /*********************************    
 	#TRANSACCION:  'TES_GET_MONTO'
 	#DESCRIPCION:	Obtener monto maximo de item
 	#AUTOR:		manuel guerra	
 	#FECHA:		05-12-2017 19:08:39
	***********************************/

	elsif(p_transaccion='TES_GET_MONTO')then

		begin
			--Sentencia de la consulta de conteo de registros
			SELECT c.importe_maximo_item
            INTO
            v_aux
            FROM tes.tsolicitud_efectivo s
            JOIN tes.tcaja c on c.id_caja=s.id_caja
            WHERE s.id_proceso_wf = v_parametros.id_proceso_workflow;
             
            v_consulta='select c.importe_maximo_item                        
                        FROM tes.tsolicitud_efectivo s
                        JOIN tes.tcaja c on c.id_caja=s.id_caja
                        WHERE s.id_proceso_wf ='|| v_parametros.id_proceso_workflow;
                          	
            IF (v_parametros.monto > v_aux.importe_maximo_item)THen
            	v_valor = pxp.f_get_variable_global('tes_verificar_importe_max');          	
		        v_resp = pxp.f_agrega_clave(v_resp,'v_valor',COALESCE(v_valor,'si')::varchar);
            END IF;
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
			v_consulta:='select count(id_solicitud_rendicion_det),
            			sum(rend.monto) as monto_total
					    from tes.tsolicitud_rendicion_det rend
                        inner join tes.tsolicitud_efectivo solren on solren.id_solicitud_efectivo = rend.id_solicitud_efectivo
                        inner join tes.tsolicitud_efectivo solefe on solefe.id_solicitud_efectivo=solren.id_solicitud_efectivo_fk
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
	
    
    
    /*********************************
 	#TRANSACCION:  'TES_ING_SEL'
 	#DESCRIPCION:	Lista de Ingresos para rendicion
 	#AUTOR:		manu
 	#FECHA:		04/04/2018
	***********************************/

	ELSEIF(p_transaccion='TES_ING_SEL')then
    	begin
    		--Sentencia de la consulta            
			v_consulta:='select
             			tesa.id_solicitud_efectivo,               
                        tesa.monto,
                        tesa.fecha,
                        tesa.nro_tramite,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod,
                        a.nombre as estado                                       
                        from tes.tsolicitud_efectivo tesa
                        inner join segu.tusuario usu1 on usu1.id_usuario = tesa.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = tesa.id_usuario_mod
                        join tes.tcaja caja on caja.id_caja=tesa.id_caja
                        join tes.ttipo_solicitud a on a.id_tipo_solicitud=tesa.id_tipo_solicitud
                        join tes.tproceso_caja tp on tp.id_proceso_caja=tesa.id_proceso_caja_rend 
                        where 
                        tesa.ingreso_cd=''si'' and                        
                        tesa.estado=''ingresado'' and                   
                        a.id_tipo_solicitud=5 and' ;
            v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			return v_consulta;

		end;

    /*********************************
 	#TRANSACCION:  'TES_ING_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		gsarmiento
 	#FECHA:		24-11-2015 12:59:51
	***********************************/

	elsif(p_transaccion='TES_ING_CONT')then

		begin       	
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select 
                        count(tesa.id_solicitud_efectivo)
                        from tes.tsolicitud_efectivo tesa
                        inner join segu.tusuario usu1 on usu1.id_usuario = tesa.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = tesa.id_usuario_mod
                        join tes.tcaja caja on caja.id_caja=tesa.id_caja
                        join tes.ttipo_solicitud a on a.id_tipo_solicitud=tesa.id_tipo_solicitud
                        join tes.tproceso_caja tp on tp.id_proceso_caja=tesa.id_proceso_caja_rend 
                        where 
                        tesa.ingreso_cd=''si'' and                         
                        tesa.estado=''ingresado'' and                        
                        a.id_tipo_solicitud=5 and';
                                    v_consulta:=v_consulta||v_parametros.filtro;
 			raise notice   '%', v_consulta;
			--Definicion de la respuesta			
			--Devuelve la respuesta
			return v_consulta;

		end; 
    
    
    /*********************************    
 	#TRANSACCION:  'TES_LISREND_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		gsarmiento	
 	#FECHA:		16-12-2015 15:14:01
	***********************************/

	ELSIF(p_transaccion='TES_LISREND_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select 
                        r.id_solicitud_rendicion_det,
                        efe.nro_tramite,
                        d.nro_documento,
                        pla.desc_plantilla,
                        d.fecha,
                        d.razon_social,
                        d.importe_doc as monto
                        from tes.tsolicitud_rendicion_det r
                        join tes.tsolicitud_efectivo efe on efe.id_solicitud_efectivo=r.id_solicitud_efectivo
                        join conta.tdoc_compra_venta d on d.id_doc_compra_venta=r.id_documento_respaldo
                        left join param.tplantilla pla on pla.id_plantilla = d.id_plantilla
                        where r.id_proceso_caja is null 
                        and efe.estado=''rendido''
				        and';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
            raise notice '%',v_consulta;
            --raise exception '%',v_consulta;
			
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            --Devuelve la respuesta
			return v_consulta;

		end;
	
        /*********************************
        #TRANSACCION:  'TES_LISREND_CONT'
        #DESCRIPCION:	Conteo de registros
        #AUTOR:		gsarmiento
        #FECHA:		16-12-2015 15:14:01
        ***********************************/

		elsif(p_transaccion='TES_LISREND_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_solicitud_rendicion_det)
                 	    from tes.tsolicitud_rendicion_det r
                        join tes.tsolicitud_efectivo efe on efe.id_solicitud_efectivo=r.id_solicitud_efectivo
                        join conta.tdoc_compra_venta d on d.id_doc_compra_venta=r.id_documento_respaldo
                        left join param.tplantilla pla on pla.id_plantilla = d.id_plantilla
                        where r.id_proceso_caja is null 
                        and efe.estado=''rendido''
                        and ';
			
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
PARALLEL UNSAFE
COST 100;