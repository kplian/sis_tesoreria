--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_generar_transferencia (
  p_id_usuario integer,
  p_id_int_comprobante integer,
  p_id_finalidad integer,
  p_id_cbte_endesis integer = NULL::integer,
  p_c31 varchar = ''::character varying,
  p_origen varchar = 'endesis'::character varying
)
RETURNS varchar AS
$body$
/*
	Autor: GSS
    Fecha: 08-06-2015
    Descripción: Función que se encarga de generar transferencia carta a la cuenta en dolares.
*/
DECLARE

    v_resp							varchar;
    v_nombre_funcion   				varchar;
    v_datos_transferencia			record;
	v_posicion_inicial				integer;
    v_posicion_final				integer;
    v_id_deposito					varchar;
    v_respuesta						varchar;
	v_nro_cuotas					record;
    v_leyenda_cuota					varchar;
    v_sistema_origen				varchar;
BEGIN


     v_nombre_funcion:='tes.f_generar_transferencia';
     
     --si el origen es endesis 
    if p_origen  = 'nacional' then
    	v_sistema_origen = 'KERP';
    ELSE
    	v_sistema_origen = 'KERP_INT';
    end if;
    
    	/*v_leyenda_cuota = '';
		FOR v_nro_cuotas in (select round(pp.nro_cuota) as cuota, cbte.id_depto_libro, cbte.id_int_comprobante
			from conta.tint_comprobante cbte
     		inner join tes.tplan_pago pp on pp.id_int_comprobante = cbte.id_int_comprobante
			where cbte.id_int_comprobante = any(p_id_int_comprobante))LOOP
        	    
            v_leyenda_cuota =  v_leyenda_cuota || ' Cuota Nro ' || v_nro_cuotas.cuota;
            
            
            if(v_nro_cuotas.id_depto_libro is null)then
                raise exception 'El comprobante % no cuenta con el id_depto_libro', v_nro_cuotas.id_int_comprobante;
            end if;
            
      	END LOOP;*/
		/*
        select cbte.id_depto, cbte.beneficiario, cbte.momento_pagado,cbte.manual, cbte.nro_tramite,
        cbte.id_depto_libro, tra.glosa, tra.importe_haber,tra.id_cuenta_bancaria, 
        tra.nro_cheque, tra.nombre_cheque_trans, tra.forma_pago, substr(depto.codigo,4) as origen,
        cbte.id_cuenta_bancaria_mov as id_libro_bancos_deposito
        into v_datos_transferencia
        from conta.tint_comprobante cbte
        inner join conta.tint_transaccion tra on tra.id_int_comprobante=cbte.id_int_comprobante
        left join param.tdepto depto on depto.id_depto=cbte.id_depto_libro
        where cbte.id_int_comprobante = any (p_id_int_comprobante) and tra.forma_pago='transferencia';    
		*/
        /*select cbte.beneficiario, cbte.id_depto_libro, op.numero || ' - INGRESO PARA PAGO A ' || pp.nombre_pago || ',' ||
                 COALESCE(op.obs, '') as glosa, sum(tra.importe_haber) as importe_haber, tra.id_cuenta_bancaria,
               substr(depto.codigo, 4) as origen, cbte.nro_tramite, cbte.id_cuenta_bancaria_mov as id_libro_bancos_deposito
		into v_datos_transferencia
        from conta.tint_comprobante cbte
             inner join conta.tint_transaccion tra on tra.id_int_comprobante =
               cbte.id_int_comprobante
             left join param.tdepto depto on depto.id_depto = cbte.id_depto_libro
             inner join tes.tplan_pago pp on pp.id_int_comprobante =
               cbte.id_int_comprobante
             inner join tes.tobligacion_pago op on op.id_obligacion_pago =
               pp.id_obligacion_pago
        where cbte.id_int_comprobante = any(p_id_int_comprobante) and
              tra.forma_pago = 'transferencia'
        group by cbte.beneficiario,cbte.id_depto_libro,
               op.numero, pp.nombre_pago,op.obs,
               tra.importe_haber, tra.id_cuenta_bancaria,
               depto.codigo,cbte.nro_tramite,
               cbte.id_cuenta_bancaria_mov;*/
         select cbte.beneficiario,
                cbte.id_depto_libro,
                cbte.glosa1 as glosa,
                tra.importe_haber,
                tra.id_cuenta_bancaria,
                substr(depto.codigo, 4) as origen,
                cbte.nro_tramite,
                tra.id_cuenta_bancaria_mov as id_libro_bancos_deposito,
				tra.forma_pago
         into v_datos_transferencia
         from conta.tint_comprobante cbte
		 inner join conta.tint_transaccion tra on tra.id_int_comprobante = cbte.id_int_comprobante
		 left join param.tdepto depto on depto.id_depto = cbte.id_depto_libro
         where cbte.id_int_comprobante = p_id_int_comprobante and tra.forma_pago = 'transferencia';

		IF(v_datos_transferencia.forma_pago is null) THEN
         	raise exception 'El comprobante % no tiene como forma de pago transferencia',p_id_int_comprobante; 
         END IF;
		 
        IF(v_datos_transferencia.id_libro_bancos_deposito is null)THEN
            v_resp = pxp.f_intermediario_ime(p_id_usuario::int4,NULL,NULL::varchar,'v58gc566o75102428i2usu08i4',13313,'172.17.45.202','99:99:99:99:99:99','tes.ft_ts_libro_bancos_ime','TES_LBAN_INS',NULL,'no',NULL,
                        array['filtro','ordenacion','dir_ordenacion','puntero','cantidad','_id_usuario_ai','_nombre_usuario_ai','id_cuenta_bancaria','id_depto','a_favor','nro_cheque','importe_deposito','nro_liquidacion','detalle','origen','observaciones','importe_cheque','id_libro_bancos_fk','nro_comprobante','comprobante_sigma','tipo','id_finalidad','sistema_origen','id_int_comprobante'],
                        array[' 0 = 0 ','','','','','NULL','NULL',v_datos_transferencia.id_cuenta_bancaria::varchar,v_datos_transferencia.id_depto_libro::varchar,v_datos_transferencia.beneficiario::varchar,'NULL','0','','PAGO A '||v_datos_transferencia.glosa::varchar,v_datos_transferencia.origen::varchar,v_datos_transferencia.nro_tramite::varchar,v_datos_transferencia.importe_haber::varchar,'NULL','','C31-'||p_c31,'transferencia_carta',p_id_finalidad::varchar,'KERP',p_id_int_comprobante::varchar],
                        array['varchar','varchar','varchar','integer','integer','int4','varchar','int4','int4','varchar','int4','numeric','varchar','text','varchar','text','numeric','int4','varchar','varchar','varchar','int4','varchar','varchar']
                        ,'',NULL,NULL);            
            
            v_respuesta = substring(v_resp from '%#"tipo_respuesta":"_____"#"%' for '#');

            IF v_respuesta = 'tipo_respuesta":"ERROR"' THEN
                v_posicion_inicial = position('"mensaje":"' in v_resp) + 11;	
                v_posicion_final = position('"codigo_error":' in v_resp) - 2;	
                RAISE EXCEPTION 'No se pudo ingresar el cheque en libro de bancos ERP-BOA: mensaje: %',substring(v_resp from v_posicion_inicial for (v_posicion_final-v_posicion_inicial));
            ELSE 
                v_posicion_inicial = position('"id_libro_bancos":"' in v_resp) + 19;
                v_posicion_final = position('"}' in v_resp);
                v_id_deposito=substring(v_resp from v_posicion_inicial for (v_posicion_final-v_posicion_inicial));
                                         
            END IF;--fin error respuesta   
                    
        END IF;
        
    
	
    v_respuesta = pxp.f_agrega_clave(v_respuesta,'mensaje','Transferencia generada'); 
    v_respuesta = pxp.f_agrega_clave(v_respuesta,'operacion','cambio_exitoso');
    v_respuesta = pxp.f_agrega_clave(v_respuesta,'id_libro_bancos',v_id_deposito);            
    return v_respuesta;

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