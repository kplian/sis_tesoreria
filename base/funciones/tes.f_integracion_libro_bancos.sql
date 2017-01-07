CREATE OR REPLACE FUNCTION tes.f_integracion_libro_bancos (
  p_id_usuario integer,
  p_id_int_comprobante integer
)
RETURNS boolean AS
$body$
DECLARE
 v_registros 		record;
 v_id_finalidad		integer;
 v_respuesta_libro_bancos varchar;
 v_resp				varchar;
 v_nombre_funcion   varchar;   
 v_centro			varchar;
BEGIN


  v_resp = 'false';
  raise notice 'integra lb id_int_comprobante %',p_id_int_comprobante; 
  --insercion de cheque en libro bancos
  select dpc.prioridad as prioridad_conta,
  		 dpl.prioridad as prioridad_libro,
         tra.forma_pago,
         pla.codigo
  into v_registros
  from conta.tint_comprobante cp
  inner join conta.tint_transaccion tra on tra.id_int_comprobante=cp.id_int_comprobante and tra.forma_pago is not null
  left join param.tdepto dpc on dpc.id_depto = cp.id_depto
  left join tes.tdepto_cuenta_bancaria dpcb on dpcb.id_cuenta_bancaria=tra.id_cuenta_bancaria
  left join param.tdepto dpl on dpl.id_depto =dpcb.id_depto
  left join conta.tplantilla_comprobante pla on pla.id_plantilla_comprobante=cp.id_plantilla_comprobante
  where cp.id_int_comprobante = p_id_int_comprobante;

  IF v_registros.prioridad_libro is null THEN
  	raise exception 'El comprobante no cuenta con id_depto libro de bancos';
  END IF;

  IF v_registros.prioridad_conta is null THEN
  	raise exception 'El comprobante no cuenta con id_depto contabilidad';
  END IF;

  select fin.id_finalidad into v_id_finalidad
  from tes.tfinalidad fin
  where fin.nombre_finalidad ilike 'proveedores';

  IF (v_registros.forma_pago = 'cheque')THEN

    if(v_registros.prioridad_conta in (0,1) and v_registros.prioridad_libro not in (2,3))then
        v_respuesta_libro_bancos = tes.f_generar_deposito_cheque(p_id_usuario,p_id_int_comprobante, v_id_finalidad,NULL,'','nacional');
        v_resp= 'true';
    elseif(v_registros.prioridad_conta = 2 and v_registros.prioridad_libro =2 )then
        v_respuesta_libro_bancos = tes.f_generar_cheque(p_id_usuario,p_id_int_comprobante, v_id_finalidad,NULL,'','nacional');
        v_resp= 'true';
    elseif(v_registros.prioridad_conta in (0,1) and v_registros.prioridad_libro =2 )then
        v_respuesta_libro_bancos = tes.f_generar_deposito_cheque(p_id_usuario,p_id_int_comprobante, v_id_finalidad,NULL,'','nacional');
        v_resp= 'true';
    elseif(v_registros.prioridad_conta = 3 and v_registros.prioridad_libro =3 )then
        --v_respuesta_libro_bancos = tes.f_generar_cheque(p_id_usuario,p_id_int_comprobante, v_id_finalidad,NULL,'','internacional');
        v_resp= 'true';
    elsif(v_registros.prioridad_conta in (0,1) and v_registros.prioridad_libro in (0,1))then

         select ctab.centro into v_centro
         from conta.tint_transaccion tra
         inner join tes.tcuenta_bancaria ctab on ctab.id_cuenta_bancaria=tra.id_cuenta_bancaria
         where tra.id_int_comprobante=p_id_int_comprobante;

         IF v_registros.codigo in ('REPOCAJA','SOLFONDAV','CIERRE_CAJA') THEN

            select fin.id_finalidad into v_id_finalidad
            from tes.tfinalidad fin
            where fin.nombre_finalidad ilike 'Fondo Rotativo';

            v_respuesta_libro_bancos = tes.f_generar_cheque(p_id_usuario,p_id_int_comprobante, v_id_finalidad,NULL,'','nacional');
         ELSE
         	select fin.id_finalidad into v_id_finalidad
            from tes.tfinalidad fin
            where fin.nombre_finalidad ilike 'Proveedores';
            IF v_centro='esp' then
    			v_respuesta_libro_bancos = tes.f_generar_deposito_cheque(p_id_usuario,p_id_int_comprobante, v_id_finalidad,NULL,'','nacional');
            END IF;

         END IF;


         
         v_resp = 'true';
        
    elsif(v_registros.prioridad_conta= 2 and v_registros.prioridad_libro in (0,1))then	--analizar este caso
    	v_resp = 'true';      
    end if;  
  ELSIF(v_registros.forma_pago = 'transferencia') THEN
  	if(v_registros.prioridad_conta in (0,1) and v_registros.prioridad_libro in (0,1))then
        v_resp= 'true';
    elsif(v_registros.prioridad_conta in (2,3) and v_registros.prioridad_libro in (2,3) )then	
    	raise exception 'No se puede realizar transferencias desde una regional';
    elsif(v_registros.prioridad_conta in (1) and v_registros.prioridad_libro in (2) )then	
    	raise exception 'No se puede realizar transferencias desde la central a una regional';
	elsif(v_registros.prioridad_conta = 3 and v_registros.prioridad_libro =3 )then	
  		--v_respuesta_libro_bancos = tes.f_generar_transferencia(p_id_usuario,p_id_int_comprobante, v_id_finalidad,NULL,'','internacional');      
        v_resp= 'true';
	elsif(v_registros.prioridad_conta = 2 and v_registros.prioridad_libro =1 )then	
    	v_resp= 'true';
    end if;    
  END IF;
  
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