--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_integracion_libro_bancos (
  p_id_usuario integer,
  p_id_int_comprobante integer,
  p_id_int_transaccion integer
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:       Sistema de Contabilidad
 FUNCION:       tes.f_integracion_libro_bancos
 DESCRIPCION:   Gestion la generecion de registros en libro de bancos 
 AUTOR:      
 FECHA:         01-09-2013 18:10:12
 COMENTARIOS:  
***************************************************************************
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
    ISSUE          FECHA           AUTOR                 DESCRIPCION:  
    
 #60  ETR         11/03/2020       RAC                Bloquear la generación de cheques duplicados para un mismo comprobante. 
                                                     (Esta validación es necesaria debido a que desde conta se permitirá la generación de cheques de manera manual antes de la validación de comprobante).
***************************************************************************/

DECLARE
  v_registros record;
  v_id_finalidad integer;
  v_respuesta_libro_bancos varchar;
  v_resp varchar;
  v_nombre_funcion varchar;
  v_centro varchar;
  v_tes_gen_cheque_depto_conta_lb_pri_cero varchar;
  v_tmp varchar;
  v_contador  integer;
BEGIN

  v_nombre_funcion = 'tes.f_integracion_libro_bancos';

  v_resp = 'false';
  
  
  -- insercion de cheque en libro bancos

  select dpc.prioridad as prioridad_conta,
         dpl.prioridad as prioridad_libro,
         tra.forma_pago,
         pla.codigo,
         cta.centro,
         cp.manual,
         tra.banco,
         cp.c31,
         cp.cbte_reversion,
         tra.importe_debe,
         tra.importe_haber
  into v_registros
  from conta.tint_comprobante cp
  inner join conta.tint_transaccion tra on tra.id_int_comprobante =cp.id_int_comprobante and tra.forma_pago is not null
  left join param.tdepto dpc on dpc.id_depto = cp.id_depto
  left join tes.tdepto_cuenta_bancaria dpcb on dpcb.id_cuenta_bancaria = tra.id_cuenta_bancaria
  --jrr : no importa el depto libro bancos del comprobante, ya que pueden ser diferentes and dpcb.id_depto=cp.id_depto_libro
  left join param.tdepto dpl on dpl.id_depto = dpcb.id_depto
  --left join param.tdepto dpl on dpl.id_depto = cp.id_depto_libro
  inner join conta.tplantilla_comprobante pla on pla.id_plantilla_comprobante = cp.id_plantilla_comprobante
  left join tes.tcuenta_bancaria cta on cta.id_cuenta_bancaria = dpcb.id_cuenta_bancaria
  where cp.id_int_comprobante = p_id_int_comprobante and tra.id_int_transaccion = p_id_int_transaccion;
        
        
  --#60  validar que la misma trasaccion no genere dos cheques    
  -- los comprobante pueden ser o de salida o de ingeso  o de ingeso y egreso en el caso de trapasos 
  v_contador := 0;
  IF v_registros.importe_haber > 0 THEN
     -- verifica salida de bancos
     SELECT count(lb.id_libro_bancos) into v_contador
     FROM tes.tts_libro_bancos lb
     WHERE lb.id_int_comprobante = p_id_int_comprobante and lb.tipo in ('cheque', 'debito_automatico', 'transferencia_carta');
  
  ELSE
     --verifica ingreso a bancos
      SELECT count(lb.id_libro_bancos) into v_contador
      FROM tes.tts_libro_bancos lb
      WHERE lb.id_int_comprobante = p_id_int_comprobante and lb.tipo in ('deposito');
  
  END IF;
  
  IF v_contador > 0 THEN
     raise exception 'El cbte ya tiene relacionado % registros en libro de bancos', v_contador;
  END IF;
  
    
  

  v_tes_gen_cheque_depto_conta_lb_pri_cero = pxp.f_get_variable_global('tes_gen_cheque_depto_conta_lb_pri_cero');

  IF v_registros.codigo in ('SOLFONDAV','RENDICIONFONDO') THEN
    v_tmp = 'Viáticos';
  ELSEIF v_registros.codigo in ('REPOCAJA','SOLFONDAV','CIERRE_CAJA') THEN
    v_tmp = 'Fondo Rotativo';
  ELSEIF v_registros.codigo in ('TESOLTRA') THEN
    v_tmp = 'Transferencia entre Cuentas';
  ELSEIF v_registros.codigo in ('CBRSP') THEN
    v_tmp = 'Ingresos';
  ELSE
    v_tmp='proveedores';
  END IF;
  
  select fin.id_finalidad
  into v_id_finalidad
  from tes.tfinalidad fin
  where fin.nombre_finalidad ilike v_tmp;

  IF v_id_finalidad is null THEN
    raise exception 'La finalidad no puede ser nula, revise el caso %',v_tmp;
  END IF;

  IF v_registros.forma_pago is not null and v_registros.banco='si' and
    v_registros.cbte_reversion = 'no' THEN

    IF v_registros.prioridad_libro is null THEN
      raise exception 'El comprobante no cuenta con id_depto libro de bancos';
    END IF;

    IF v_registros.prioridad_conta is null THEN
      raise exception 'El comprobante no cuenta con id_depto contabilidad';
    END IF;

    IF (v_registros.forma_pago = 'cheque')THEN

      IF(v_registros.prioridad_conta in (0,1) and v_registros.prioridad_libro in (1))then
        
          IF v_registros.codigo in ('REPOCAJA','SOLFONDAV','CIERRE_CAJA') THEN

            v_resp= 'true';
            v_respuesta_libro_bancos = tes.f_generar_cheque( 
                                                             p_id_usuario,
                                                             p_id_int_comprobante, 
                                                             p_id_int_transaccion, 
                                                             v_id_finalidad,
                                                             NULL,
                                                             COALESCE(v_registros.c31,''),
                                                             'nacional');

          ELSE
            
              v_resp= 'true';
              IF v_tes_gen_cheque_depto_conta_lb_pri_cero = 'si' THEN
                  
                  v_respuesta_libro_bancos = tes.f_generar_cheque(
                                                                   p_id_usuario, 
                                                                   p_id_int_comprobante, 
                                                                   p_id_int_transaccion, 
                                                                   v_id_finalidad,
                                                                   NULL,
                                                                   '',
                                                                   'nacional');

              ELSE
                 v_respuesta_libro_bancos = tes.f_generar_deposito_cheque( 
                                                                           p_id_usuario,
                                                                           p_id_int_comprobante, 
                                                                           p_id_int_transaccion,
                                                                           v_id_finalidad,
                                                                           NULL,
                                                                           COALESCE(v_registros.c31,''),
                                                                           'nacional');
              END IF;

          END IF;
        
        
      ELSEIF(v_registros.prioridad_conta = 2 and v_registros.prioridad_libro =  2 )then
        
        v_respuesta_libro_bancos = tes.f_generar_deposito_cheque(
                                                                 p_id_usuario, 
                                                                 p_id_int_comprobante, 
                                                                 p_id_int_transaccion, 
                                                                 v_id_finalidad,
                                                                 NULL, 
                                                                 COALESCE(v_registros.c31,''),
                                                                 'nacional');
        v_resp= 'true';
      ELSEIF(v_registros.prioridad_conta in (0,1) and v_registros.prioridad_libro =2) THEN
        -- Cheque desde conta central hacia cuenta bancaria de la regional
        
        v_respuesta_libro_bancos = tes.f_generar_deposito_cheque(
                                                                 p_id_usuario, 
                                                                 p_id_int_comprobante, 
                                                                 p_id_int_transaccion, 
                                                                 v_id_finalidad,
                                                                 NULL, 
                                                                 COALESCE(v_registros.c31,''),
                                                                 'nacional');
        v_resp= 'true';
      ELSEIF (v_registros.prioridad_conta = 3 and v_registros.prioridad_libro = 3 ) THEN
        --v_respuesta_libro_bancos = tes.f_generar_cheque(p_id_usuario,p_id_int_comprobante, v_id_finalidad,NULL,'','internacional');
        v_resp= 'true';
      
      ELSEIF(v_registros.prioridad_conta in (0,1) and
          
          v_registros.prioridad_libro in (0,1))then

        --RAC, 17/08/2017, agrega varible global para que sea configurable 
        --   la genracion de cheuqes para libros de bancos con prioridad 0
        
        IF v_tes_gen_cheque_depto_conta_lb_pri_cero = 'si' THEN
           
            v_respuesta_libro_bancos = tes.f_generar_cheque(
                                                             p_id_usuario,
                                                             p_id_int_comprobante, 
                                                             p_id_int_transaccion, 
                                                             v_id_finalidad,
                                                             NULL,
                                                             '',
                                                             'nacional');
        END IF;

        v_resp = 'true';

      ELSEIF (v_registros.prioridad_conta= 2 and v_registros.prioridad_libro=1 ) THEN	--analizar este caso
        
        IF v_registros.centro = 'esp' THEN
           
            -- Cheque desde conta regional hacia cuenta bancaria 1-6024446 de la central
            v_respuesta_libro_bancos = tes.f_generar_deposito_cheque(
                                                                      p_id_usuario, 
                                                                      p_id_int_comprobante, 
                                                                      p_id_int_transaccion, 
                                                                      v_id_finalidad,
                                                                      NULL, 
                                                                      COALESCE(v_registros.c31,''),
                                                                      'nacional');
           v_resp = 'true';
           
        END IF;
        
      END IF;

    ELSIF(v_registros.forma_pago in ('transferencia','deposito')) THEN

      IF(v_registros.prioridad_conta in (0,1) and v_registros.prioridad_libro in (0,1))THEN

        v_respuesta_libro_bancos = tes.f_generar_transferencia(
                                                                p_id_usuario,
                                                                p_id_int_comprobante, 
                                                                p_id_int_transaccion, 
                                                                v_id_finalidad,
                                                                NULL,
                                                                '',
                                                                'nacional');
        v_resp= 'true';

      ELSEIF (v_registros.prioridad_conta in (2,3) and v_registros.prioridad_libro in (2,3) ) THEN
        
         v_respuesta_libro_bancos = tes.f_generar_transferencia(
                                                                p_id_usuario, 
                                                                p_id_int_comprobante, 
                                                                p_id_int_transaccion, 
                                                                v_id_finalidad,
                                                                NULL,
                                                                '',
                                                                'nacional');
        v_resp= 'true';
        
        -- No se puede realizar transferencias desde una cuenta bancaria regional
      ELSEIF (v_registros.prioridad_conta in (1) and v_registros.prioridad_libro in (2) ) THEN
        
        raise exception 'No se puede realizar transferencias desde un departamento de contabilidad central a una cuenta bancaria regional';
      
      ELSEIF (v_registros.prioridad_conta = 3 and v_registros.prioridad_libro =3 ) THEN
        --v_respuesta_libro_bancos = tes.f_generar_transferencia(p_id_usuario,p_id_int_comprobante, v_id_finalidad,NULL,'','internacional');
        v_resp= 'true';
      
      ELSEIF (v_registros.prioridad_conta = 2 and v_registros.prioridad_libro =1) THEN
        v_resp= 'true';
      END IF;

    ELSE

      raise exception 'Forma de pago no reconocida %',v_registros.forma_pago;

    END IF;

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
PARALLEL UNSAFE
COST 100;