--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_gestionar_cuota_plan_pago (
    p_id_usuario integer,
    p_id_usuario_ai integer,
    p_usuario_ai varchar,
    p_id_int_comprobante integer,
    p_conexion varchar = NULL::character varying
)
    RETURNS boolean AS
$body$
/*

Autor: RAC KPLIAN
Fecha:   6 junio de 2013
Descripcion  Esta funcion gestiona los planes de pago de la siguiente manera


    Cuando un comprobante de devegado o pago es validado  ->   cambia el estado de la cuota.

   HISTORIAL DE MODIFICACIONES:

 ISSUE            FECHA:		      AUTOR                 DESCRIPCION
 #31, ETR       27/10/2017        RAC KPLIAN             Considerar si anticipos ejecutan presupeusto
 #0   ETR       28/02/2018        Jaime Rivera KPLIAN    BUG que generaba doble regitro en libro de bancos que vienen de Obligaciones de pago en regionales
 #1				16/10/2018			EGS					 Se aumento la validacion que cuando sea devengado_pago el pago  pueda estar en borrador
 #ETR-1914      02/12/2020              EGS               Se agrego fecha_documento,fecha_derivacion y dias limite
*/


DECLARE

    v_nombre_funcion   	text;
    v_resp				varchar;


    v_registros 		record;

    v_id_estado_actual  integer;


    va_id_tipo_estado integer[];
    va_codigo_estado varchar[];
    va_disparador    varchar[];
    va_regla         varchar[];
    va_prioridad     integer[];

    v_tipo_sol   varchar;

    v_nro_cuota numeric;

    v_id_proceso_wf integer;
    v_id_estado_wf integer;
    v_codigo_estado varchar;
    v_id_plan_pago integer;
    v_verficacion  boolean;
    v_verficacion2  varchar[];

    v_id_tipo_estado  integer;
    v_codigo_proceso_llave_wf   varchar;
    --gonzalo
    v_id_finalidad		integer;
    v_respuesta_libro_bancos varchar;
    v_tes_integrar_lb_pagado	varchar;
    v_id_funcionario_voboconta_dev    integer;

BEGIN




    v_nombre_funcion = 'tes.f_gestionar_cuota_plan_pago';



    -- 1) con el id_comprobante identificar el plan de pago

    select
        pp.id_plan_pago,
        pp.id_estado_wf,
        pp.id_proceso_wf,
        pp.tipo,
        pp.estado,
        pp.id_plan_pago_fk,
        pp.id_obligacion_pago,
        pp.nro_cuota,
        pp.id_plantilla,
        pp.monto_ejecutar_total_mo,
        pp.monto_no_pagado,
        pp.liquido_pagable,

        op.id_depto ,
        op.pago_variable,
        pp.id_cuenta_bancaria ,
        pp.nombre_pago,
        pp.forma_pago,
        pp.tipo_cambio,
        pp.tipo_pago,
        pp.fecha_tentativa,
        pp.otros_descuentos,
        pp.monto_retgar_mo,

        pp.descuento_ley,
        pp.obs_descuentos_ley,
        pp.porc_descuento_ley,
        op.id_depto_conta,
        pp.id_cuenta_bancaria_mov,
        pp.nro_cheque,
        pp.nro_cuenta_bancaria,
        op.numero,
        pp.obs_descuentos_anticipo,
        pp.obs_descuentos_ley,
        pp.obs_monto_no_pagado,
        pp.obs_otros_descuentos,
        tpp.codigo_plantilla_comprobante,
        pp.descuento_inter_serv,             --descuento por intercambio de servicios
        pp.obs_descuento_inter_serv,
        pp.porc_monto_retgar,
        pp.descuento_anticipo,
        pp.monto_anticipo,
        pp.id_depto_lb,
        pp.id_depto_conta,
        dpc.prioridad as prioridad_conta,
        dpl.prioridad as prioridad_libro,
        c.temporal,
        pp.pago_borrador, ---#1				16/10/2018			EGS
        pp.fecha_documento,
        pp.fecha_derivacion,
        pp.dias_limite
    into
        v_registros
    from  tes.tplan_pago pp
              inner join tes.tobligacion_pago  op on op.id_obligacion_pago = pp.id_obligacion_pago and op.estado_reg = 'activo'
              inner join tes.ttipo_plan_pago tpp on tpp.codigo = pp.tipo and tpp.estado_reg = 'activo'
              inner join conta.tint_comprobante  c on c.id_int_comprobante = pp.id_int_comprobante
              left join param.tdepto dpc on dpc.id_depto=pp.id_depto_conta
              left join param.tdepto dpl on dpl.id_depto=pp.id_depto_lb
    where  pp.id_int_comprobante = p_id_int_comprobante;





    --2) Validar que tenga un plan de pago


    IF  v_registros.id_plan_pago is NULL  THEN
        raise exception 'El comprobante no esta relacionado con nigun plan de pagos';
    END IF;


    --#31   RAC 27/10/2017
    --SI es del tipo anticopo
    --  Verificamos configuracion si Anticipo ejecuta presupuesto
    --  llamaos a funcion de presupeustos apra ejecucion de anticipo
    IF   v_registros.tipo in ('ant_parcial') THEN
        IF not  tes.f_gestionar_presupuesto_tesoreria(
                v_registros.id_obligacion_pago,
                p_id_usuario,
                'ejecutar_anticipo',
                v_registros.id_plan_pago,
                NULL ) THEN
            raise exception 'error ejecutando presupuesto del anticipo';
        END IF;
        --NOTA, el presupeusto retenido no ejecutra presupesuto
    END IF;


    -- 3)  Si es devengado_pagado o   devengado, se identifica  con id_plan_pago_fk = null



    --v_tipo_sol  = 'Devengado';



    -- 4   No importa si es devengado o pago, cambia de estado la cuota,

    --------------------------------------------------------
    ---  cambiar el estado de la cuota                 -----
    --------------------------------------------------------


    -- obtiene el siguiente estado del flujo
    SELECT
        *
    into
        va_id_tipo_estado,
        va_codigo_estado,
        va_disparador,
        va_regla,
        va_prioridad

    FROM wf.f_obtener_estado_wf(v_registros.id_proceso_wf, v_registros.id_estado_wf,NULL,'siguiente');


    --raise exception '--  % ,  % ,% ',v_id_proceso_wf,v_id_estado_wf,va_codigo_estado;


    IF va_codigo_estado[2] is not null THEN

        raise exception 'El proceso de WF esta mal parametrizado,  solo admite un estado siguiente para el estado: %', v_registros.estado;

    END IF;

    IF va_codigo_estado[1] is  null THEN

        raise exception 'El proceso de WF esta mal parametrizado, no se encuentra el estado siguiente,  para el estado: %', v_registros.estado;
    END IF;




    -- estado siguiente
    v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado[1],
                                                  NULL,
                                                  v_registros.id_estado_wf,
                                                  v_registros.id_proceso_wf,
                                                  p_id_usuario,
                                                  p_id_usuario_ai, -- id_usuario_ai
                                                  p_usuario_ai, -- usuario_ai
                                                  v_registros.id_depto,
                                                  'Comprobante con tpp codigo:('||v_registros.tipo||') fue validado');






    -- actualiza estado en la solicitud


    update tes.tplan_pago pp  set
                                  id_estado_wf =  v_id_estado_actual,
                                  estado = va_codigo_estado[1],
                                  id_usuario_mod=p_id_usuario,
                                  fecha_mod=now(),
                                  fecha_dev = now(),
                                  fecha_pag = now(),
                                  id_usuario_ai = p_id_usuario_ai,
                                  usuario_ai = p_usuario_ai
    where id_plan_pago  = v_registros.id_plan_pago;


    ---------------------------------------------------------
    -- 3.1)  si es tipo es devengado_pago  , se genera automaticamente un plan de PAGO relacionado por el total
    --------------------------------------------

    IF   v_registros.tipo = 'devengado_rrhh' THEN
        IF NOT plani.f_valida_devengado(p_id_usuario,p_id_usuario_ai,p_usuario_ai,
                                        v_registros.id_plan_pago) THEN
            raise exception 'Error al generar el pago de devengado';
        END IF;
    ELSIF v_registros.tipo = 'pagado_rrhh' THEN
        IF NOT plani.f_valida_pagado(p_id_usuario,p_id_usuario_ai,p_usuario_ai,
                                     v_registros.id_plan_pago) THEN
            raise exception 'Error al validar el pagado';
        END IF;
    END IF;

    IF   (v_registros.tipo = 'devengado_pagado' and v_registros.temporal = 'no' ) THEN

        --determinar el numero de cuota

        v_nro_cuota = (((v_registros.nro_cuota::INTEGER)::varchar)||'.01'):: numeric;

        --recupera el tipo plan pago para el codigo = pagado

        select
            tpp.codigo_proceso_llave_wf
        into
            v_codigo_proceso_llave_wf
        from tes.ttipo_plan_pago tpp
        where tpp.codigo = 'pagado';


        IF  v_codigo_proceso_llave_wf is NULL THEN

            raise exception 'No se encontro codigo TPP para el pagado';

        END IF;


        -------------------------------------
        --  Manejo de estados con el WF
        -------------------------------------


        SELECT
            ps_id_proceso_wf,
            ps_id_estado_wf,
            ps_codigo_estado
        into
            v_id_proceso_wf,
            v_id_estado_wf,
            v_codigo_estado
        FROM wf.f_registra_proceso_disparado_wf(
                p_id_usuario,
                p_id_usuario_ai, --id_usuario_ai
                p_usuario_ai, --usuario_ai
                v_id_estado_actual,
                NULL,
                v_registros.id_depto,
                ('Solicutd de pago,  OP:'|| v_registros.numero||' cuota nro'||v_nro_cuota::varchar),
                v_codigo_proceso_llave_wf,
                v_registros.numero||'-'||v_nro_cuota::varchar
            );


        -- 3.1.1) genera la cuota de pago.

        INSERT INTO
            tes.tplan_pago
        (
            id_usuario_reg,
            fecha_reg,
            estado_reg,
            id_obligacion_pago,
            id_plan_pago_fk,
            id_cuenta_bancaria,

            id_estado_wf,
            id_proceso_wf,
            estado,

            nro_cuota,
            nombre_pago,
            forma_pago,
            tipo,
            fecha_tentativa,
            fecha_pag,
            tipo_cambio,
            monto,
            otros_descuentos,
            monto_ejecutar_total_mo,           -- monto total
            liquido_pagable,                   -- liquido pagable
            monto_retgar_mo,                   -- retencion degarantia

            descuento_ley,                     -- descuentos de ley
            obs_descuentos_ley,
            porc_descuento_ley,

            id_cuenta_bancaria_mov,
            nro_cheque,
            nro_cuenta_bancaria,
            id_usuario_ai,
            usuario_ai,
            obs_descuentos_anticipo,

            obs_monto_no_pagado,
            obs_otros_descuentos,

            descuento_inter_serv,             --descuento por intercambio de servicios
            obs_descuento_inter_serv,

            descuento_anticipo,
            id_plantilla,
            porc_monto_retgar,
            monto_anticipo,
            id_depto_lb,
            id_depto_conta,
            fecha_documento,--#ETR-1914
            fecha_derivacion,--#ETR-1914
            dias_limite--#ETR-1914
        )
        VALUES (
                   p_id_usuario,
                   now(),
                   'activo',
                   v_registros.id_obligacion_pago,
                   v_registros.id_plan_pago, --id_plan_pago_fk  hace referencia al plan de pago del devengado
                   v_registros.id_cuenta_bancaria,

                   v_id_estado_wf,
                   v_id_proceso_wf,
                   v_codigo_estado,

                   v_nro_cuota,
                   v_registros.nombre_pago,
                   v_registros.forma_pago,
                   'pagado',
                   v_registros.fecha_tentativa,
                   now(),
                   v_registros.tipo_cambio,
                   v_registros.monto_ejecutar_total_mo,  --monto
                   v_registros.otros_descuentos,
                   v_registros.monto_ejecutar_total_mo,
                   v_registros.liquido_pagable,
                   v_registros.monto_retgar_mo,
                   v_registros.descuento_ley,
                   v_registros.obs_descuentos_ley,
                   v_registros.porc_descuento_ley,
                   v_registros.id_cuenta_bancaria_mov,
                   COALESCE(v_registros.nro_cheque,0),
                   v_registros.nro_cuenta_bancaria,
                   p_id_usuario_ai,
                   p_usuario_ai,
                   v_registros.obs_descuentos_anticipo,

                   v_registros.obs_monto_no_pagado,
                   v_registros.obs_otros_descuentos,

                   v_registros.descuento_inter_serv,             --descuento por intercambio de servicios
                   v_registros.obs_descuento_inter_serv,
                   v_registros.descuento_anticipo,
                   v_registros.id_plantilla,
                   v_registros.porc_monto_retgar,
                   v_registros.monto_anticipo,
                   v_registros.id_depto_lb,
                   v_registros.id_depto_conta,
                   v_registros.fecha_documento,--#ETR-1914
                   v_registros.fecha_derivacion,--#ETR-1914
                   v_registros.dias_limite --#ETR-1914
               )RETURNING id_plan_pago into v_id_plan_pago;


        --------------------------------------------------
        -- Inserta prorrateo automatico del pago
        ------------------------------------------------


        v_verficacion =  tes.f_prorrateo_plan_pago( v_id_plan_pago,
                                                    v_registros.id_obligacion_pago,
                                                    v_registros.pago_variable,
                                                    v_registros.monto_ejecutar_total_mo,
                                                    p_id_usuario,
                                                    v_registros.id_plan_pago);



        --actualiza el total de pagos registrados en el plan de pago padre
        update tes.tplan_pago  pp set
                                      total_pagado = COALESCE(total_pagado,0) + v_registros.monto_ejecutar_total_mo,
                                      fecha_mod=now()
        where pp.id_plan_pago  = v_registros.id_plan_pago;




        --RAC 13-02-2013
        ----------------------------------------------------------
        --antes de generar el comprobante pasa al estado vbconta
        ----------------------------------------------------------
        --#1				16/10/2018			EGS
        IF(v_registros.pago_borrador = 'no')then
            select
                te.id_tipo_estado
            into
                v_id_tipo_estado
            from wf.ttipo_estado te
                     inner join wf.tproceso_wf  pw on pw.id_tipo_proceso = te.id_tipo_proceso
                and pw.id_proceso_wf = v_id_proceso_wf
            where te.codigo = 'vbconta';

            --recuperando el funcionario que tuvo voboconta del devengado
            SELECT
                es.id_funcionario
            into
                v_id_funcionario_voboconta_dev
            FROM tes.tplan_pago p
                     left join wf.testado_wf es on es.id_proceso_wf = p.id_proceso_wf
                     left join wf.ttipo_estado te on te.id_tipo_estado = es.id_tipo_estado
            WHERE p.id_plan_pago =  v_registros.id_plan_pago
              and te.codigo = 'vbconta'
              and es.fecha_reg = (
                SELECT
                    max(ess.fecha_reg)
                FROM tes.tplan_pago pp
                         left join wf.testado_wf ess on ess.id_proceso_wf = pp.id_proceso_wf
                         left join wf.ttipo_estado tee on tee.id_tipo_estado = ess.id_tipo_estado
                WHERE pp.id_plan_pago =  v_registros.id_plan_pago
                  and tee.codigo = 'vbconta'
            );




            IF v_id_tipo_estado is  null THEN

                raise exception 'El proceso de WF esta mal parametrizado, no tiene el estado Visto bueno contabilidad (vbconta) ';

            END IF;

            --registrar el siguiente estado detectado  (vbconta)
            v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado,
                                                          v_id_funcionario_voboconta_dev, --#ETR-1914
                                                          v_id_estado_wf,
                                                          v_id_proceso_wf,
                                                          p_id_usuario,
                                                          p_id_usuario_ai,
                                                          p_usuario_ai,
                                                          v_registros.id_depto,
                                                          '(generacion de comprobante de pago directo para la OP:'|| COALESCE(v_registros.numero,'NAN')||',   cuota nro: '||COALESCE(v_registros.nro_cuota,'NAN')||' ) La solicitud de  Pago pasa a Contabilidad');


            --actualiza el nuevo estado para el nuevo pago
            update tes.tplan_pago pp  set
                                          id_estado_wf =  v_id_estado_actual,
                                          estado = 'vbconta'
            where id_plan_pago  = v_id_plan_pago;


            -- raise exception 'xxxxxx';

            --------------------------------------------------
            -- solicitar negeracion de comprobantes de pago
            ---------------------------------------------------
            v_verficacion2 = tes.f_generar_comprobante(
                    p_id_usuario,
                    p_id_usuario_ai,
                    p_usuario_ai,
                    v_id_plan_pago,
                    v_registros.id_depto_conta,
                    p_conexion);

            IF v_verficacion2[1]='FALSE'  THEN

                raise exception 'Error al generar el comprobante de pago';

            END IF;
        end if;-- #1				16/10/2018			EGS

    END IF;


    /*jrr:comentado por duplicidad en libro bancos
    v_tes_integrar_lb_pagado = pxp.f_get_variable_global('tes_integrar_lb_pagado');


    IF v_tes_integrar_lb_pagado = 'si' THEN
        --gonzalo insercion de cheque en libro bancos
        IF v_registros.tipo = 'pagado' THEN
            select fin.id_finalidad into v_id_finalidad
            from tes.tfinalidad fin
            where fin.nombre_finalidad ilike 'proveedores';

            if(v_registros.prioridad_conta =0 and v_registros.prioridad_libro != 0)then
                v_respuesta_libro_bancos = tes.f_generar_deposito_cheque(p_id_usuario,p_id_int_comprobante, v_id_finalidad,NULL,'','endesis');
            elseif(v_registros.prioridad_conta!=0 and v_registros.prioridad_libro!=0)then
                v_respuesta_libro_bancos = tes.f_generar_cheque(p_id_usuario,p_id_int_comprobante, v_id_finalidad,NULL,'','endesis');
            end if;

        END IF;
    END IF;
    */

--raise exception '123';

    RETURN  TRUE;



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