--------------- SQL ---------------

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
 v_tes_gen_cheque_depto_conta_lb_pri_cero		varchar;
BEGIN


  v_resp = 'false';
  raise notice 'integra lb id_int_comprobante %',p_id_int_comprobante;
  --gonzalo insercion de cheque en libro bancos
  select dpc.prioridad as prioridad_conta,
  		 dpl.prioridad as prioridad_libro,
         tra.forma_pago,
         pla.codigo,
         cta.centro,
         cp.manual,
         cp.c31
  into v_registros
  from conta.tint_comprobante cp
  inner join conta.tint_transaccion tra on tra.id_int_comprobante=cp.id_int_comprobante and tra.forma_pago is not null
  left join param.tdepto dpc on dpc.id_depto = cp.id_depto
  left join tes.tdepto_cuenta_bancaria dpcb on dpcb.id_cuenta_bancaria=tra.id_cuenta_bancaria and dpcb.id_depto=cp.id_depto_libro
  left join param.tdepto dpl on dpl.id_depto =dpcb.id_depto
  --left join param.tdepto dpl on dpl.id_depto = cp.id_depto_libro
  inner join conta.tplantilla_comprobante pla on pla.id_plantilla_comprobante=cp.id_plantilla_comprobante
  left join tes.tcuenta_bancaria cta on cta.id_cuenta_bancaria=dpcb.id_cuenta_bancaria
  where cp.id_int_comprobante = p_id_int_comprobante;

  select fin.id_finalidad into v_id_finalidad
  from tes.tfinalidad fin
  where fin.nombre_finalidad ilike 'proveedores';

  IF v_registros.forma_pago is not null THEN

  	IF v_registros.manual !='si' THEN	-- inicio verifica cuenta bancaria
  --IF v_registros.centro != 'otro' AND v_registros.manual !='si' THEN	-- inicio verifica cuenta bancaria

    IF v_registros.prioridad_libro is null THEN
      raise exception 'El comprobante no cuenta con id_depto libro de bancos';
    END IF;

    IF v_registros.prioridad_conta is null THEN
      raise exception 'El comprobante no cuenta con id_depto contabilidad';
    END IF;

    IF (v_registros.forma_pago = 'cheque')THEN

      if(v_registros.prioridad_conta in (0,1) and v_registros.prioridad_libro in (1))then
          IF v_registros.codigo in ('REPOCAJA','SOLFONDAV','CIERRE_CAJA') THEN

              select fin.id_finalidad into v_id_finalidad
              from tes.tfinalidad fin
              where fin.nombre_finalidad ilike 'Fondo Rotativo';

              v_respuesta_libro_bancos = tes.f_generar_cheque(p_id_usuario,p_id_int_comprobante, v_id_finalidad,NULL,COALESCE(v_registros.c31,''),'nacional');
           ELSE
              v_respuesta_libro_bancos = tes.f_generar_deposito_cheque(p_id_usuario,p_id_int_comprobante, v_id_finalidad,NULL,COALESCE(v_registros.c31,''),'nacional');
          	v_resp= 'true';
          END IF;
      elseif(v_registros.prioridad_conta = 2 and v_registros.prioridad_libro =2 )then
          raise notice 'Cheque desde conta regional hacia cuenta bancaria de la regional';
          v_respuesta_libro_bancos = tes.f_generar_deposito_cheque(p_id_usuario,p_id_int_comprobante, v_id_finalidad,NULL,COALESCE(v_registros.c31,''),'nacional');
          v_resp= 'true';
      elseif(v_registros.prioridad_conta in (0,1) and v_registros.prioridad_libro =2)then
          raise notice 'Cheque desde conta central hacia cuenta bancaria de la regional';
          v_respuesta_libro_bancos = tes.f_generar_deposito_cheque(p_id_usuario,p_id_int_comprobante, v_id_finalidad,NULL,COALESCE(v_registros.c31,''),'nacional');
          v_resp= 'true';
      elseif(v_registros.prioridad_conta = 3 and v_registros.prioridad_libro =3 )then
          --v_respuesta_libro_bancos = tes.f_generar_cheque(p_id_usuario,p_id_int_comprobante, v_id_finalidad,NULL,'','internacional');
          v_resp= 'true';
      elsif(v_registros.prioridad_conta in (0,1) and v_registros.prioridad_libro in (0,1))then
         
           --RAC, 17/08/2017, agega varible global para que sea configurable 
           --   la genracion de cheuqes para libros de bancos con prioridad 0 
           v_tes_gen_cheque_depto_conta_lb_pri_cero = pxp.f_get_variable_global('tes_gen_cheque_depto_conta_lb_pri_cero');
      
           IF v_tes_gen_cheque_depto_conta_lb_pri_cero = 'si' THEN
               v_respuesta_libro_bancos = tes.f_generar_cheque(p_id_usuario,p_id_int_comprobante, v_id_finalidad,NULL,'','nacional');
           END IF;
           

           v_resp = 'true';

      elsif(v_registros.prioridad_conta= 2 and v_registros.prioridad_libro=1 )then	--analizar este caso
      	  IF v_registros.centro = 'esp' THEN
              raise notice 'Cheque desde conta regional hacia cuenta bancaria 1-6024446 de la central';
              v_respuesta_libro_bancos = tes.f_generar_deposito_cheque(p_id_usuario,p_id_int_comprobante, v_id_finalidad,NULL,COALESCE(v_registros.c31,''),'nacional');
              v_resp = 'true';
          END IF;
      end if;
    ELSIF(v_registros.forma_pago = 'transferencia') THEN
      if(v_registros.prioridad_conta in (0,1) and v_registros.prioridad_libro in (0,1))then
          v_respuesta_libro_bancos = tes.f_generar_transferencia(p_id_usuario,p_id_int_comprobante, v_id_finalidad,NULL,'','nacional');
          v_resp= 'true';
      elsif(v_registros.prioridad_conta in (2,3) and v_registros.prioridad_libro in (2,3) )then
          v_respuesta_libro_bancos = tes.f_generar_transferencia(p_id_usuario,p_id_int_comprobante, v_id_finalidad,NULL,'','nacional');
          v_resp= 'true';
          --raise exception 'No se puede realizar transferencias desde una cuenta bancaria regional';
      elsif(v_registros.prioridad_conta in (1) and v_registros.prioridad_libro in (2) )then
          raise exception 'No se puede realizar transferencias desde un departamento de contabilidad central a una
          					cuenta bancaria regional';
      elsif(v_registros.prioridad_conta = 3 and v_registros.prioridad_libro =3 )then
          --v_respuesta_libro_bancos = tes.f_generar_transferencia(p_id_usuario,p_id_int_comprobante, v_id_finalidad,NULL,'','internacional');
          v_resp= 'true';
      elsif(v_registros.prioridad_conta = 2 and v_registros.prioridad_libro =1 )then
          v_resp= 'true';
      end if;
    END IF;

  END IF;			--fin verifica cuenta bancaria

  END IF; 		-- fin forma de pago

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