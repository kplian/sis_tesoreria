CREATE OR REPLACE FUNCTION tes.f_consolidar_depositos_cheque (
  p_id_usuario integer,
  p_c31 varchar,
  p_tramites varchar
)
RETURNS varchar AS
$body$
DECLARE
  v_resp				varchar;
  v_nombre_funcion		varchar;
  v_datos_deposito_cheque			record;
  v_datos_cheque		record;
  v_respuesta			varchar;
  v_posicion_inicial	integer;
  v_posicion_final		integer;
  v_id_deposito			integer;
  v_ids_depositos		INTEGER[];
  v_id_cheque			integer;
  v_ids_cheques			integer[];
  v_cont				integer;
BEGIN
  v_cont = 1;
  FOR v_datos_deposito_cheque IN (select t.id_libro_bancos
  	from tes.tts_libro_bancos t
  	where t.sistema_origen='KERP' and t.comprobante_sigma=p_c31
  	and t.tipo='deposito')LOOP
  	
    v_ids_depositos[v_cont] = v_datos_deposito_cheque.id_libro_bancos;
    v_cont = v_cont + 1;
  END LOOP;  

  select t.a_favor, t.comprobante_sigma, t.detalle,t.id_cuenta_bancaria,
  t.id_depto,t.id_finalidad,t.nro_comprobante,t.nro_liquidacion,
  t.origen,t.sistema_origen,
  t.tipo,sum(t.importe_deposito) as importe_deposito into v_datos_deposito_cheque
  from tes.tts_libro_bancos t
  where t.sistema_origen='KERP' and t.comprobante_sigma=p_c31
  and t.tipo='deposito'
  group by t.a_favor, t.comprobante_sigma, t.detalle,t.id_cuenta_bancaria,
  t.id_depto,t.id_finalidad,t.nro_comprobante,t.nro_liquidacion,
  t.origen,t.sistema_origen,t.tipo;
    
  v_resp = pxp.f_intermediario_ime(p_id_usuario::int4,NULL,NULL::varchar,'v58gc566o75102428i2usu08i4',13313,'172.17.45.229','99:99:99:99:99:99','tes.ft_ts_libro_bancos_ime','TES_LBAN_INS',NULL,'no',NULL,
  array['filtro','ordenacion','dir_ordenacion','puntero','cantidad','_id_usuario_ai','_nombre_usuario_ai','id_cuenta_bancaria','id_depto','fecha','a_favor','nro_cheque','importe_deposito','nro_liquidacion','detalle','origen','observaciones','importe_cheque','id_libro_bancos_fk','nro_comprobante','comprobante_sigma','tipo','id_finalidad','sistema_origen'],
  array[' 0 = 0 ','','','','','NULL','NULL',v_datos_deposito_cheque.id_cuenta_bancaria::varchar,v_datos_deposito_cheque.id_depto::varchar,''||current_date::varchar||'',v_datos_deposito_cheque.a_favor::varchar,'',v_datos_deposito_cheque.importe_deposito::varchar,''::varchar,v_datos_deposito_cheque.detalle::varchar,v_datos_deposito_cheque.origen::varchar,p_tramites::varchar,'0','NULL','',v_datos_deposito_cheque.comprobante_sigma::varchar,'deposito',v_datos_deposito_cheque.id_finalidad::varchar,v_datos_deposito_cheque.sistema_origen::varchar],
  array['varchar','varchar','varchar','integer','integer','int4','varchar','int4','int4','date','varchar','int4','numeric','varchar','text','varchar','text','numeric','int4','varchar','varchar','varchar','int4','varchar']
                    ,'',NULL,NULL);    
                     
  raise notice 'v_resp %', v_resp;                       
  v_respuesta = substring(v_resp from '%#"tipo_respuesta":"_____"#"%' for '#');
  raise notice 'v_respuesta %', v_respuesta;                              
  IF v_respuesta = 'tipo_respuesta":"ERROR"' THEN
      v_posicion_inicial = position('"mensaje":"' in v_resp) + 11;	
      v_posicion_final = position('"codigo_error":' in v_resp) - 2;	
      RAISE EXCEPTION 'No se pudo ingresar el deposito en libro de bancos ERP-BOA: mensaje: %',substring(v_resp from v_posicion_inicial for (v_posicion_final-v_posicion_inicial));
  ELSE 
      v_posicion_inicial = position('"id_libro_bancos":"' in v_resp) + 19;
      v_posicion_final = position('"}' in v_resp);
      v_id_deposito=substring(v_resp from v_posicion_inicial for (v_posicion_final-v_posicion_inicial));
                                            
  END IF;--fin error respuesta 
    
  v_cont = 1;
  FOR v_datos_cheque IN (select t.id_libro_bancos
  	from tes.tts_libro_bancos t
  	where t.sistema_origen='KERP' and t.comprobante_sigma=p_c31
  	and t.tipo='cheque')LOOP
  	
    v_ids_cheques[v_cont] = v_datos_cheque.id_libro_bancos;
    v_cont = v_cont + 1;
  END LOOP; 
  
  v_resp = pxp.f_intermediario_ime(p_id_usuario::int4,NULL,NULL::varchar,'v58gc566o75102428i2usu08i4',13313,'172.17.45.202','99:99:99:99:99:99','tes.ft_ts_libro_bancos_ime','TES_LBAN_INS',NULL,'no',NULL,
        			array['filtro','ordenacion','dir_ordenacion','puntero','cantidad','_id_usuario_ai','_nombre_usuario_ai','id_cuenta_bancaria','id_depto','a_favor','nro_cheque','importe_deposito','nro_liquidacion','detalle','origen','observaciones','importe_cheque','id_libro_bancos_fk','nro_comprobante','comprobante_sigma','tipo','id_finalidad','sistema_origen'],
                    array[' 0 = 0 ','','','','','NULL','NULL',v_datos_deposito_cheque.id_cuenta_bancaria::varchar,v_datos_deposito_cheque.id_depto::varchar,v_datos_deposito_cheque.a_favor::varchar,'NULL','0','',v_datos_deposito_cheque.detalle::varchar,v_datos_deposito_cheque.origen::varchar,p_tramites::varchar,'0',v_id_deposito::varchar,'',v_datos_deposito_cheque.comprobante_sigma::varchar,'cheque',v_datos_deposito_cheque.id_finalidad::varchar,''::varchar],
                    array['varchar','varchar','varchar','integer','integer','int4','varchar','int4','int4','varchar','int4','numeric','varchar','text','varchar','text','numeric','int4','varchar','varchar','varchar','int4','varchar']
                    ,'',NULL,NULL);

  v_respuesta = substring(v_resp from '%#"tipo_respuesta":"_____"#"%' for '#');

  IF v_respuesta = 'tipo_respuesta":"ERROR"' THEN
      v_posicion_inicial = position('"mensaje":"' in v_resp) + 11;	
      v_posicion_final = position('"codigo_error":' in v_resp) - 2;	
      RAISE EXCEPTION 'No se pudo ingresar el cheque en libro de bancos ERP-BOA: mensaje: %',substring(v_resp from v_posicion_inicial for (v_posicion_final-v_posicion_inicial));
  ELSE 
      v_posicion_inicial = position('"id_libro_bancos":"' in v_resp) + 19;
      v_posicion_final = position('"}' in v_resp);
      v_id_cheque=substring(v_resp from v_posicion_inicial for (v_posicion_final-v_posicion_inicial));
                                     
  END IF;--fin error respuesta   
  
  --actualiza relacion con cheques de referencia
  UPDATE tes.tts_libro_bancos
  SET id_libro_bancos_fk=v_id_cheque
  where id_libro_bancos= any(v_ids_cheques);
  
  --elimina referencias de los depositos   
  DELETE FROM tes.tts_libro_bancos
  where id_libro_bancos = ANY(v_ids_depositos); 
    	
  v_resp = pxp.f_agrega_clave(v_respuesta,'mensaje','Consolidacion generada'); 
  v_resp = pxp.f_agrega_clave(v_respuesta,'operacion','cambio_exitoso');            
  return v_resp;
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