--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_generar_deposito_cheque (
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
    Fecha: 11-06-2015
    Descripción: Función que se encarga de generar cheque.
*/
DECLARE

    v_resp							varchar;
    v_nombre_funcion   				varchar;
    v_datos_deposito_cheque			record;
	v_posicion_inicial				integer;
    v_posicion_final				integer;
    v_id_deposito					varchar;
    v_respuesta						varchar;
BEGIN

 

     v_nombre_funcion:='tes.f_generar_deposito_cheque';
     
     --si el origen es endesis 
    if p_origen  = 'endesis' then
		
        select cbte.id_depto, cbte.beneficiario, cbte.momento_pagado,cbte.manual, cbte.nro_tramite,
        cbte.id_depto_libro, op.numero || ' - INGRESO PARA PAGO A ' || pp.nombre_pago || ',' || COALESCE(op.obs,'')  as glosa,
        tra.importe_haber,tra.id_cuenta_bancaria, 
        tra.nro_cheque, tra.nombre_cheque_trans, tra.forma_pago, substr(depto.codigo,4) as origen
        into v_datos_deposito_cheque
        from conta.tint_comprobante cbte
        inner join conta.tint_transaccion tra on tra.id_int_comprobante=cbte.id_int_comprobante
        left join param.tdepto depto on depto.id_depto=cbte.id_depto_libro
        inner join tes.tplan_pago pp on pp.id_int_comprobante=cbte.id_int_comprobante
		inner join tes.tobligacion_pago op on op.id_obligacion_pago=pp.id_obligacion_pago
        where cbte.id_int_comprobante=p_id_int_comprobante and tra.forma_pago='cheque';    
		
        if(v_datos_deposito_cheque.id_depto_libro is null)then
        	raise exception 'El comprobante % no cuenta con el id_depto_libro ',p_id_cbte_endesis;
        end if;
        
        v_resp = pxp.f_intermediario_ime(p_id_usuario::int4,NULL,NULL::varchar,'v58gc566o75102428i2usu08i4',13313,'172.17.45.202','99:99:99:99:99:99','tes.ft_ts_libro_bancos_ime','TES_LBAN_INS',NULL,'no',NULL,
        			array['filtro','ordenacion','dir_ordenacion','puntero','cantidad','_id_usuario_ai','_nombre_usuario_ai','id_cuenta_bancaria','id_depto','fecha','a_favor','nro_cheque','importe_deposito','nro_liquidacion','detalle','origen','observaciones','importe_cheque','id_libro_bancos_fk','nro_comprobante','comprobante_sigma','tipo','id_finalidad','id_int_comprobante','sistema_origen'],
                    array[' 0 = 0 ','','','','','NULL','NULL',v_datos_deposito_cheque.id_cuenta_bancaria::varchar,v_datos_deposito_cheque.id_depto_libro::varchar,''||current_date::varchar||'',v_datos_deposito_cheque.beneficiario::varchar,'',v_datos_deposito_cheque.importe_haber::varchar,'',v_datos_deposito_cheque.glosa::varchar,v_datos_deposito_cheque.origen::varchar,v_datos_deposito_cheque.nro_tramite::varchar,'0','','','C31-'||p_c31,'deposito',p_id_finalidad::varchar,''||p_id_int_comprobante::varchar||'','KERP'],
                    array['varchar','varchar','varchar','integer','integer','int4','varchar','int4','int4','date','varchar','int4','numeric','varchar','text','varchar','text','numeric','int4','varchar','varchar','varchar','int4','varchar','varchar']
                    ,'',NULL,NULL);
        raise notice 'v_respuesta_deposito %', v_resp;
        v_respuesta = substring(v_resp from '%#"tipo_respuesta":"_____"#"%' for '#');
                                
        IF v_respuesta = 'tipo_respuesta":"ERROR"' THEN
            v_posicion_inicial = position('"mensaje":"' in v_resp) + 11;	
            v_posicion_final = position('"codigo_error":' in v_resp) - 2;	
            RAISE EXCEPTION 'No se pudo ingresar el deposito en libro de bancos ERP-BOA: mensaje: %',substring(v_resp from v_posicion_inicial for (v_posicion_final-v_posicion_inicial));
        ELSE 
            v_posicion_inicial = position('"id_libro_bancos":"' in v_resp) + 19;
            v_posicion_final = position('"}' in v_resp);
            v_id_deposito=substring(v_resp from v_posicion_inicial for (v_posicion_final-v_posicion_inicial));
                                            
        END IF;--fin error respuesta 
                
        v_resp = pxp.f_intermediario_ime(p_id_usuario::int4,NULL,NULL::varchar,'v58gc566o75102428i2usu08i4',13313,'172.17.45.202','99:99:99:99:99:99','tes.ft_ts_libro_bancos_ime','TES_LBAN_INS',NULL,'no',NULL,
        			array['filtro','ordenacion','dir_ordenacion','puntero','cantidad','_id_usuario_ai','_nombre_usuario_ai','id_cuenta_bancaria','id_depto','a_favor','nro_cheque','importe_deposito','nro_liquidacion','detalle','origen','observaciones','importe_cheque','id_libro_bancos_fk','nro_comprobante','comprobante_sigma','tipo','id_finalidad','sistema_origen','id_int_comprobante'],
                    array[' 0 = 0 ','','','','','NULL','NULL',v_datos_deposito_cheque.id_cuenta_bancaria::varchar,v_datos_deposito_cheque.id_depto_libro::varchar,v_datos_deposito_cheque.beneficiario::varchar,'NULL','0','',v_datos_deposito_cheque.glosa::varchar,v_datos_deposito_cheque.origen::varchar,v_datos_deposito_cheque.nro_tramite::varchar,'0',v_id_deposito::varchar,'','C31-'||p_c31,'cheque',p_id_finalidad::varchar,'KERP',''||p_id_int_comprobante::varchar||''],
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
    
    end if;
	
    v_respuesta = pxp.f_agrega_clave(v_respuesta,'mensaje','Deposito y cheque generado'); 
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