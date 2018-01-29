CREATE OR REPLACE FUNCTION tes.ft_plan_pago_doc_compra_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.ft_plan_pago_doc_compra_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tplan_pago_doc_compra'
 AUTOR: 		 (admin)
 FECHA:	        25-01-2018 15:16:48
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				25-01-2018 15:16:48								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tplan_pago_doc_compra'	
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_plan_pago_doc_compra	integer;
	v_id_tipo_doc_compra_venta	integer;
	v_rec 						record;
	v_tipo_informe      		varchar;
	v_razon_social      		varchar;
	v_nit           			varchar;
	v_id_moneda       			integer;
	v_nomeda          			varchar;
	v_nro_tramite       		varchar;
	v_reg_periodo       		record;
	v_id_funcionario      		integer;
	v_sw_pgs          			varchar;
	v_tmp_resp        			boolean;
	v_id_int_comprobante    	integer;
	v_registros					record;
	v_id_proveedor				integer;
	v_id_cliente				integer;
	v_importe_ice     			numeric;
	v_id_doc_compra_venta 		integer;

			    
BEGIN

    v_nombre_funcion = 'tes.ft_plan_pago_doc_compra_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_OPDCOMP_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		25-01-2018 15:16:48
	***********************************/

	if(p_transaccion='TES_DCV_INS')then
					
        begin
        	--calcula valores pode defecto para el tipo de doc compra venta
    		IF v_parametros.id_moneda is null THEN
          		raise EXCEPTION 'Es necesario indicar la Moneda del documento, revise los datos.';
      		END IF;

      		IF v_parametros.tipo = 'compra' THEN
		        -- paracompras por defecto es
		        -- Compras para mercado interno con destino a actividades gravadas
		        select
		          td.id_tipo_doc_compra_venta
		        into
		          v_id_tipo_doc_compra_venta
		        from conta.ttipo_doc_compra_venta td
		        where td.codigo = '1';

	      	ELSE
		        -- para ventas por defecto es
		        -- facturas valida
		        select
		          td.id_tipo_doc_compra_venta
		        into
		          v_id_tipo_doc_compra_venta
		        from conta.ttipo_doc_compra_venta td
		        where td.codigo = 'V';

      		END IF;

		    IF v_parametros.id_moneda is null THEN
		        raise EXCEPTION 'Es necesario indicar la Moneda del documento, revise los datos.';
		    END IF;

			-- recuepra el periodo de la fecha ...
			--Obtiene el periodo a partir de la fecha
			v_rec = param.f_get_periodo_gestion(v_parametros.fecha);

			select tipo_informe into v_tipo_informe
			from param.tplantilla
			where id_plantilla = v_parametros.id_plantilla;

			IF v_tipo_informe = 'lcv' THEN
				-- valida que periodO de libro de compras y ventas este abierto
				v_tmp_resp = conta.f_revisa_periodo_compra_venta(p_id_usuario, v_parametros.id_depto_conta, v_rec.po_id_periodo);
			END IF;

			--TODO
			--validar que no exsita un documento con el mismo nro y misma razon social  ...?
			--validar que no exista un documento con el mismo nro_autorizacion, nro_factura , y nit y razon social

			IF v_parametros.importe_pendiente > 0 or v_parametros.importe_anticipo > 0 or v_parametros.importe_retgar > 0 THEN
				IF v_parametros.id_auxiliar is null THEN
					raise EXCEPTION 'Es necesario indicar una cuenta corriente, revise los datos.';
				END IF;
			END IF;

			if (pxp.f_existe_parametro(p_tabla,'id_int_comprobante')) then
				v_id_int_comprobante = v_parametros.id_int_comprobante;          
				--#14,  se recupera el nro_tramite del comprobante si es que existe
				select
				c.nro_tramite
				into
				v_nro_tramite
				from conta.tint_comprobante c
				where c.id_int_comprobante = v_id_int_comprobante;
			  
			end if;
      
			--RAC 05/01/2018 nuevos para emtros para registro de pagos simplificados 
			if (pxp.f_existe_parametro(p_tabla,'id_funcionario')) then
				v_id_funcionario = v_parametros.id_funcionario;
			end if;
      
			if (pxp.f_existe_parametro(p_tabla,'sw_pgs')) then
				v_sw_pgs = v_parametros.sw_pgs;
			else
				v_sw_pgs = 'no';
			end if;
      
			--FIN RAC

			--recupera parametrizacion de la plantilla
			select
			*
			into
			v_registros
			from param.tplantilla pla
			where pla.id_plantilla = v_parametros.id_plantilla;

      		--PARA COMPRAS
      		IF v_parametros.tipo = 'compra' THEN

		        IF EXISTS(select
						1
						from conta.tdoc_compra_venta dcv
						inner join param.tplantilla pla on pla.id_plantilla=dcv.id_plantilla
						where    dcv.estado_reg = 'activo' and  dcv.nit = v_parametros.nit
						and dcv.nro_autorizacion = v_parametros.nro_autorizacion
						and dcv.nro_documento = v_parametros.nro_documento
						and dcv.nro_dui = v_parametros.nro_dui
						and pla.tipo_informe='lcv') then

		          raise exception 'Ya existe un documento registrado con el mismo nro,  nit y nro de autorizacion';

		        END IF;

		        -- chequear si el proveedor esta registrado
		        v_id_proveedor = param.f_check_proveedor(p_id_usuario, v_parametros.nit, upper(trim(v_parametros.razon_social)));

      		ELSE
				--TODO  chequear que la factura de venta no este duplicada
				--chequear el el cliente esta registrado
				v_id_cliente = vef.f_check_cliente(p_id_usuario, v_parametros.nit, upper(trim(v_parametros.razon_social)));
			END IF;


			--si tiene habilitado el ic copiamos el monto excento
			-- OJO considerar que todos los calculos con el monto excento ya estaran
			-- considerando el ice, par ano hacer mayores cambios
			v_importe_ice = NULL;
			IF v_registros.sw_ic = 'si' then
				v_importe_ice = v_parametros.importe_excento;
			END IF;


      		--Sentencia de la insercion
      		insert into conta.tdoc_compra_venta(
	        tipo,
	        importe_excento,
	        id_plantilla,
	        fecha,
	        nro_documento,
	        nit,
	        importe_ice,
	        nro_autorizacion,
	        importe_iva,
	        importe_descuento,
	        importe_descuento_ley,
	        importe_pago_liquido,
	        importe_doc,
	        sw_contabilizar,
	        estado,
	        id_depto_conta,
	        obs,
	        estado_reg,
	        codigo_control,
	        importe_it,
	        razon_social,
	        id_usuario_ai,
	        id_usuario_reg,
	        fecha_reg,
	        usuario_ai,
	        manual,
	        id_periodo,
	        nro_dui,
	        id_moneda,
	        importe_pendiente,
	        importe_anticipo,
	        importe_retgar,
	        importe_neto,
	        id_proveedor,
	        id_cliente,
	        id_auxiliar,
	        id_tipo_doc_compra_venta,
	        id_int_comprobante,
	        nro_tramite,
	        id_funcionario,
	        sw_pgs
      		) values(
	        v_parametros.tipo,
	        v_parametros.importe_excento,
	        v_parametros.id_plantilla,
	        v_parametros.fecha,
	        v_parametros.nro_documento,
	        v_parametros.nit,
	        v_importe_ice,
	        v_parametros.nro_autorizacion,
	        v_parametros.importe_iva,
	        v_parametros.importe_descuento,
	        v_parametros.importe_descuento_ley,
	        v_parametros.importe_pago_liquido,
	        v_parametros.importe_doc,
	        'si', --sw_contabilizar,
	        'registrado', --estado
	        v_parametros.id_depto_conta,
	        v_parametros.obs,
	        'activo',
	        upper(COALESCE(v_parametros.codigo_control,'0')),
	        v_parametros.importe_it,
	        upper(trim(v_parametros.razon_social)),
	        v_parametros._id_usuario_ai,
	        p_id_usuario,
	        now(),
	        v_parametros._nombre_usuario_ai,
	        'si',
	        v_rec.po_id_periodo,
	        v_parametros.nro_dui,
	        v_parametros.id_moneda,
	        COALESCE(v_parametros.importe_pendiente,0),
	        COALESCE(v_parametros.importe_anticipo,0),
	        COALESCE(v_parametros.importe_retgar,0),
	        v_parametros.importe_neto,
	        v_id_proveedor,
	        v_id_cliente,
	        v_parametros.id_auxiliar,
	        v_id_tipo_doc_compra_venta,
	        v_id_int_comprobante,
	        v_nro_tramite,
	        v_id_funcionario,
	        v_sw_pgs
	      	)RETURNING id_doc_compra_venta into v_id_doc_compra_venta;

			if (pxp.f_existe_parametro(p_tabla,'id_origen')) then
				update conta.tdoc_compra_venta
				set id_origen = v_parametros.id_origen,
				tabla_origen = v_parametros.tabla_origen
				where id_doc_compra_venta = v_id_doc_compra_venta;
			end if;

			if (pxp.f_existe_parametro(p_tabla,'id_tipo_compra_venta')) then
				if(v_parametros.id_tipo_compra_venta is not null) then
					update conta.tdoc_compra_venta
					set id_tipo_doc_compra_venta = v_parametros.id_tipo_compra_venta
					where id_doc_compra_venta = v_id_doc_compra_venta;
				end if;
			end if;

			if (pxp.f_existe_parametro(p_tabla,'estacion')) then
				if(v_parametros.estacion is not null) then
					update conta.tdoc_compra_venta
					set estacion = v_parametros.estacion
					where id_doc_compra_venta = v_id_doc_compra_venta;
				end if;
			end if;

			if (pxp.f_existe_parametro(p_tabla,'id_agencia')) then
				if(v_parametros.id_agencia is not null) then
					update conta.tdoc_compra_venta
					set id_agencia = v_parametros.id_agencia
					where id_doc_compra_venta = v_id_doc_compra_venta;
				end if;
			end if;

			--Relaciona la factura con el plan de pagos
			--Sentencia de la insercion
        	insert into tes.tplan_pago_doc_compra(
			id_doc_compra_venta,
			estado_reg,
			id_plan_pago,
			id_usuario_ai,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_id_doc_compra_venta,
			'activo',
			v_parametros.id_plan_pago,
			v_parametros._id_usuario_ai,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			null,
			null
			) RETURNING id_plan_pago_doc_compra into v_id_plan_pago_doc_compra;



			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Documentos Compra/Venta almacenado(a) con exito (id_doc_compra_venta'||v_id_doc_compra_venta||')');
			v_resp = pxp.f_agrega_clave(v_resp,'id_doc_compra_venta',v_id_doc_compra_venta::varchar);
			v_resp = pxp.f_agrega_clave(v_resp,'id_plan_pago_doc_compra',v_id_plan_pago_doc_compra::varchar);

			--Devuelve la respuesta
			return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_OPDCOMP_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		25-01-2018 15:16:48
	***********************************/

	elsif(p_transaccion='TES_OPDCOMP_MOD')then

		begin
			--Sentencia de la modificacion
			update tes.tplan_pago_doc_compra set
			id_doc_compra_venta = v_parametros.id_doc_compra_venta,
			id_plan_pago = v_parametros.id_plan_pago,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_plan_pago_doc_compra=v_parametros.id_plan_pago_doc_compra;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Facturas/Recibos modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_plan_pago_doc_compra',v_parametros.id_plan_pago_doc_compra::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'DCV_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		25-01-2018 15:16:48
	***********************************/

	elsif(p_transaccion='DCV_ELI')then

		begin
			--revisa si el documento no esta marcado como revisado
			select
			dcv.revisado,
			dcv.id_int_comprobante,
			dcv.tabla_origen,
			dcv.id_origen,
			dcv.id_depto_conta,
			dcv.fecha,
			dcv.id_plantilla
			into
			v_registros
			from conta.tdoc_compra_venta dcv where dcv.id_doc_compra_venta =v_parametros.id_doc_compra_venta;

			IF  v_registros.revisado = 'si' THEN
				raise exception 'los documentos revisados no pueden eliminarse';
			END IF;

			-- revisar si el archivo es manual o no

			IF v_registros.id_origen is not null THEN
				raise exception 'Solo puede eliminar los documentos insertados manualmente';
			END IF;

			--Obtiene el id del plan de pago a partir del documento ed compra
			select id_plan_pago_doc_compra
			into v_id_plan_pago_doc_compra
			from tes.tplan_pago_doc_compra
			where id_doc_compra_venta = v_parametros.id_doc_compra_venta;

			if v_id_plan_pago_doc_compra is null then
				raise exception 'Pago no encontrado';
			end if;

			--validar si el periodo de conta esta cerrado o abierto
			-- recuepra el periodo de la fecha ...
			--Obtiene el periodo a partir de la fecha
			v_rec = param.f_get_periodo_gestion(v_registros.fecha);

			select tipo_informe into v_tipo_informe
			from param.tplantilla
			where id_plantilla = v_registros.id_plantilla;

			-- valida que period de libro de compras y ventas este abierto
			IF v_tipo_informe = 'lcv' THEN
			v_tmp_resp = conta.f_revisa_periodo_compra_venta(p_id_usuario, v_registros.id_depto_conta, v_rec.po_id_periodo);
			END IF;


			--validar que no tenga un comprobante asociado

			IF  v_registros.id_int_comprobante is not NULL THEN
			raise exception 'No puede elimiar por que el documento esta acociado al cbte id(%), primero quite esta relacion', v_registros.id_int_comprobante;
			END IF;


			--Sentencia de la eliminacion
			delete from conta.tdoc_concepto
			where id_doc_compra_venta=v_parametros.id_doc_compra_venta;


			--Sentencia de la eliminacion
			delete from conta.tdoc_compra_venta
			where id_doc_compra_venta=v_parametros.id_doc_compra_venta;

			delete from tes.tplan_pago_doc_compra where id_plan_pago_doc_compra = v_id_plan_pago_doc_compra;



			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Documentos Compra/Venta eliminado(a)');
			v_resp = pxp.f_agrega_clave(v_resp,'id_doc_compra_venta',v_parametros.id_doc_compra_venta::varchar);

			--Devuelve la respuesta
			return v_resp;

		end;
         
	else
     
    	raise exception 'Transaccion inexistente: %',p_transaccion;

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