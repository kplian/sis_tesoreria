--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_inserta_plan_pago_anticipo (
    p_administrador integer,
    p_id_usuario integer,
    p_hstore public.hstore
)
    RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		tes.f_inserta_plan_pago_anticipo
 DESCRIPCION:   inserta cuotas de anticipo (primer nivel sin prorrateo)
 AUTOR: 		Rensi Arteaga COpari
 FECHA:	        5-11-2014
 COMENTARIOS:
***************************************************************************
HISTORIAL DE MODIFICACIONES:
ISUUE        FECHA:             AUTOR:             DESCRIPCION:
#ETR-1914       21/11/2020      EGS             Se agregan campos de fecha_documento,fecha_derivacion,dias_limite

***************************************************************************/

DECLARE

    v_resp		            varchar;
    v_nombre_funcion        text;
    v_mensaje_error         text;

    v_id_cuenta_bancaria 			integer;
    v_id_cuenta_bancaria_mov 		integer;
    v_forma_pago 					varchar;
    v_nro_cheque 					integer;
    v_nro_cuenta_bancaria  			varchar;
    v_centro 						varchar;
    v_registros   					record;
    v_nro_cuota						numeric;
    v_fecha_tentativa				date;
    v_monto_total					numeric;
    v_liquido_pagable 				numeric;
    v_monto_ejecutar_total_mo   	numeric;
    va_id_tipo_estado_pro 			integer[];
    va_codigo_estado_pro 			varchar[];
    va_disparador_pro 				varchar[];
    va_regla_pro 					varchar[];
    va_prioridad_pro 				integer[];

    v_id_estado_actual 				integer;


    v_id_proceso_wf 				integer;
    v_id_estado_wf 					integer;
    v_codigo_estado					varchar;
    v_id_plan_pago					integer;

    v_monto_excento					numeric;
    v_porc_monto_excento_var		numeric;
    v_sw_me_plantilla               varchar;

    v_registros_tpp                 record;
    v_porc_monto_retgar             numeric;

    v_monto_ant_parcial_descontado  numeric;
    v_saldo_x_pagar  numeric;
    v_saldo_x_descontar   numeric;

    v_resp_doc   boolean;
    v_obligacion	record;

    v_monto_anticipo  numeric;
    v_check_ant_mixto numeric;



    v_count integer;
    v_codigo_proceso_llave_wf varchar;

    v_porc_ant  numeric;



BEGIN


    /*
      HSTORE  PARAMETERS

      (p_hstore->'id_cuenta_bancaria')::integer;
      (p_hstore->'id_cuenta_bancaria_mov')::integer;
      (p_hstore->'forma_pago')::varchar;
      (p_hstore->'nro_cheque')::integer;
      (p_hstore->'nro_cuenta_bancaria')::varchar;
      (p_hstore->'monto')::numeric
      (p_hstore->'id_obligacion_pago')::integer;
      (p_hstore->'monto_no_pagado')::numeric
      (p_hstore->'monto_retgar_mo')::numeric
      (p_hstore->'descuento_ley')::numeric
      (p_hstore->'descuento_anticipo')::numeric
      (p_hstore->'otros_descuentos')::numeric
      (p_hstore->'monto_no_pagado')::numeric
      (p_hstore->'tipo_pago')::varchar
      (p_hstore->'fecha_tentativa')::date
      (p_hstore->'id_plan_pago_fk')::integer
      (p_hstore->'id_plantilla')::integer
      (p_hstore->'tipo')::varchar
      (p_hstore->'porc_monto_excento_var')::numeric
      (p_hstore->'monto_excento')::numeric
      (p_hstore->'tipo_cambio')::numeric,
      (p_hstore->'obs_descuentos_ley'),
      (p_hstore->'obs_monto_no_pagado')::text,
      (p_hstore->'obs_otros_descuentos')::text,
      (p_hstore->'porc_descuento_ley')::numeric,
      (p_hstore->'descuento_inter_serv')::numeric
      (p_hstore->'_id_usuario_ai')::integer,
      (p_hstore->'_nombre_usuario_ai')::varchar,
      (p_hstore->'obs_descuentos_anticipo')::varchar,
      (p_hstore->'obs_monto_no_pagado')::varchar,
      (p_hstore->'obs_otros_descuentos')::varchar,
      (p_hstore->'nombre_pago')::varchar,
      (p_hstore->'id_plantilla')::integer,
      (p_hstore->'porc_monto_retgar')::numeric
      (p_hstore->'monto_ajuste_ag')::numeric

      (p_hstore->'fecha_costo_ini')::date,
      (p_hstore->'fecha_costo_fin')::date,

   */


    v_nombre_funcion = 'tes.f_inserta_plan_pago_anticipo';


    v_id_cuenta_bancaria = (p_hstore->'id_cuenta_bancaria')::integer;
    v_id_cuenta_bancaria_mov = (p_hstore->'id_cuenta_bancaria_mov')::integer;
    v_forma_pago =  (p_hstore->'forma_pago')::varchar;
    v_nro_cheque =  (p_hstore->'nro_cheque')::integer;
    v_nro_cuenta_bancaria =  (p_hstore->'nro_cuenta_bancaria')::varchar;

    v_porc_monto_excento_var = (p_hstore->'porc_monto_excento_var')::numeric;
    v_monto_excento = (p_hstore->'monto_excento')::numeric;



    --validamos que el monto a pagar sea mayor que cero
    IF  (p_hstore->'monto')::numeric = 0 THEN
        raise exception 'El monto a pagar no puede ser 0';
    END IF;


    --obtiene datos de la obligacion

    select
        op.porc_anticipo,
        op.porc_retgar,
        op.num_tramite,
        op.id_proceso_wf,
        op.id_estado_wf,
        op.estado,
        op.id_depto,
        op.pago_variable,
        op.numero

    into v_registros
    from tes.tobligacion_pago op
    where op.id_obligacion_pago = (p_hstore->'id_obligacion_pago')::integer;



    --validaciones segun el tipo de anticipo

    IF (p_hstore->'tipo')::varchar = 'anticipo' THEN
        --si es un proceso variable, verifica que el registro no sobrepase el total a pagar
        IF v_registros.pago_variable='no' THEN
            v_monto_total= tes.f_determinar_total_faltante((p_hstore->'id_obligacion_pago')::integer, 'registrado');

            IF v_monto_total <  (p_hstore->'monto')::numeric THEN
                raise exception 'No puede exceder el total a pagar en obligaciones no variables: %',v_monto_total;
            END IF;
            ----------------------------
            --  si es  un pago no variable  (si es una cuota de devengao_pagado, devegando_pagado_1c, pagado)
            --  validar que no se haga el ultimo pago sin  terminar de descontar el anticipo,

            IF v_registros.pago_variable = 'no' THEN

                -- saldo_x_pagar = determinar cuanto falta por pagar (sin considerar el devengado)
                v_saldo_x_pagar = tes.f_determinar_total_faltante((p_hstore->'id_obligacion_pago')::integer,'total_registrado_pagado');

                -- saldo_x_descontar = determinar cuanto falta por descontar del anticipo parcial
                v_saldo_x_descontar = tes.f_determinar_total_faltante((p_hstore->'id_obligacion_pago')::integer,'ant_parcial_descontado');

                --  SI saldo_x_descontar del anticipo paricla  >  saldo_x_pagar
                IF (v_saldo_x_descontar)  > (v_saldo_x_pagar  - COALESCE((p_hstore->'monto')::numeric,0)) THEN
                    raise exception 'El saldo a pagar no es sufuciente para recuperar el anticipo (%)',v_saldo_x_descontar;
                END IF;


            END IF;

        END IF;

    ELSIF   (p_hstore->'tipo')::varchar = 'ant_parcial'   THEN

        v_monto_total= tes.f_determinar_total_faltante((p_hstore->'id_obligacion_pago')::integer, 'ant_parcial');
        v_porc_ant = pxp.f_get_variable_global('politica_porcentaje_anticipo')::numeric;

        IF v_monto_total <  (p_hstore->'monto')::numeric  AND v_registros.pago_variable = 'no' THEN
            raise exception 'No puede exceder el total a pagar segun politica de anticipos % porc', v_porc_ant*100;
        END IF;

    ELSIF   (p_hstore->'tipo')::varchar = 'dev_garantia'   THEN

        v_monto_total= tes.f_determinar_total_faltante((p_hstore->'id_obligacion_pago')::integer, 'dev_garantia');


        IF v_monto_total <  (p_hstore->'monto')::numeric  THEN
            raise exception 'No puede exceder el total de garantia por devolver que es de: %', v_monto_total;
        END IF;


    END IF;


    -------------------------
    --CAlcular el nro de cuota
    --------------------------

    select
        max(pp.nro_cuota)
    into
        v_nro_cuota
    from tes.tplan_pago pp
    where
            pp.id_obligacion_pago = (p_hstore->'id_obligacion_pago')::integer
      and pp.estado_reg='activo';


    -- define numero de cuota
    v_nro_cuota = floor(COALESCE(v_nro_cuota,0))+1;

    -- verifica que el registro no sobrepase el total a devengado


    IF  (p_hstore->'monto')::numeric < 0 or (p_hstore->'monto_no_pagado')::numeric < 0 or (p_hstore->'otros_descuentos')::numeric  < 0 or (p_hstore->'descuento_ley')::numeric < 0 THEN

        raise exception 'No se admiten cifras negativas';
    END IF;


    IF (p_hstore->'monto_no_pagado')::numeric !=0  THEN

        raise exception 'El monto no pagado solo puede definirce en cuotas de devengado';

    END IF;

    -- calcula el liquido pagable y el monto  a ejecutar presupeustaria mente
    --v_liquido_pagable = COALESCE(v_parametros.monto,0) - COALESCE(v_parametros.monto_no_pagado,0) - COALESCE(v_parametros.otros_descuentos,0) - COALESCE( v_parametros.monto_retgar_mo,0) - COALESCE(v_parametros.descuento_ley,0) - COALESCE(v_parametros.descuento_anticipo,0)- COALESCE(v_parametros.descuento_inter_serv,0);

    v_liquido_pagable = COALESCE((p_hstore->'monto')::numeric,0)  -  COALESCE((p_hstore->'otros_descuentos')::numeric,0) - COALESCE((p_hstore->'monto_retgar_mo')::numeric,0) - COALESCE((p_hstore->'descuento_ley')::numeric,0) - COALESCE((p_hstore->'descuento_anticipo')::numeric,0) - COALESCE((p_hstore->'descuento_inter_serv')::numeric,0);
    v_monto_ejecutar_total_mo  = 0;  -- el monto a ejecutar es cero los anticipo parciales no ejecutan presupeusto

    IF   v_liquido_pagable  < 0  or v_monto_ejecutar_total_mo < 0  THEN
        raise exception ' Ni  el monto a ejecutar   ni el liquido pagable  puede ser menor a cero';
    END IF;

    IF v_monto_excento > 0 THEN
        v_porc_monto_excento_var  = v_monto_excento /  COALESCE((p_hstore->'monto')::numeric,0);
    ELSE
        v_porc_monto_excento_var = 0;
    END IF;


    --obtiene el tipo de plan de pago para este registro
    select
        tpp.codigo_proceso_llave_wf
    into
        v_codigo_proceso_llave_wf
    from tes.ttipo_plan_pago tpp
    where tpp.codigo = (p_hstore->'tipo')::varchar;


    IF v_codigo_proceso_llave_wf is NULL THEN

        raise exception 'No se encontro un tipo de plan de pago para este codigo %',COALESCE(v_codigo_proceso_llave_wf,'N/I');

    END IF;

    -------------------------------------
    --  Manejo de estados con el WF
    -------------------------------------

    --cambia de estado al obligacion
    IF  v_registros.estado = 'registrado' THEN

        SELECT
            ps_id_tipo_estado,
            ps_codigo_estado,
            ps_disparador,
            ps_regla,
            ps_prioridad
        into
            va_id_tipo_estado_pro,
            va_codigo_estado_pro,
            va_disparador_pro,
            va_regla_pro,
            va_prioridad_pro

        FROM wf.f_obtener_estado_wf( v_registros.id_proceso_wf,  v_registros.id_estado_wf,NULL,'siguiente');


        IF  va_id_tipo_estado_pro[2] is not null  THEN

            raise exception 'La obligacion se encuentra mal parametrizado dentro de Work Flow,  el estado registro  solo  admite un estado siguiente,  no admitido (%)',va_codigo_estado_pro[2];

        END IF;


        IF  va_codigo_estado_pro[1] != 'en_pago'  THEN
            raise exception 'La obligacion se encuentra mal parametrizado dentro de Work Flow, el siguiente estado para el proceso de compra deberia ser "en_pago" y no % ',va_codigo_estado_sol[1];
        END IF;

        -- registra estado eactual en el WF para rl procesod e compra

        v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado_pro[1],
                                                      NULL, --id_funcionario
                                                      v_registros.id_estado_wf,
                                                      v_registros.id_proceso_wf,
                                                      p_id_usuario,
                                                      (p_hstore->'_id_usuario_ai')::integer,
                                                      (p_hstore->'_nombre_usuario_ai')::varchar,
                                                      v_registros.id_depto);

        -- actuliaza el stado en la solictud
        update tes.tobligacion_pago  p set
                                           id_estado_wf =  v_id_estado_actual,
                                           estado = va_codigo_estado_pro[1],
                                           id_usuario_mod=p_id_usuario,
                                           fecha_mod=now(),
                                           id_usuario_ai = (p_hstore->'_id_usuario_ai')::integer,
                                           usuario_ai = (p_hstore->'_nombre_usuario_ai')::varchar
        where id_obligacion_pago = (p_hstore->'id_obligacion_pago')::integer;

        -------------------------------------
        --dispara estado para plan de pagos
        --------------------------------------


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
                (p_hstore->'_id_usuario_ai')::integer,
                (p_hstore->'_nombre_usuario_ai')::varchar,
                v_id_estado_actual,
                NULL,
                v_registros.id_depto,
                ('Solicutd de devengado para la OP:'|| COALESCE(v_registros.numero,'s/n')||' cuota nro'||v_nro_cuota::varchar),
                v_codigo_proceso_llave_wf,
                COALESCE(v_registros.numero,'s/n')||'-N# '||v_nro_cuota::varchar
            );


    ELSEIF   v_registros.estado = 'en_pago' THEN

        --registra estado de cotizacion

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
                (p_hstore->'_id_usuario_ai')::integer,
                (p_hstore->'_nombre_usuario_ai')::varchar,
                v_registros.id_estado_wf,
                NULL,
                v_registros.id_depto,
                ('Solicutd de Anticipo para la OP:'|| v_registros.numero||' cuota nro'||v_nro_cuota::varchar),
                v_codigo_proceso_llave_wf,
                v_registros.numero||'-N# '||v_nro_cuota::varchar
            );
    ELSE


        raise exception 'Estado no reconocido % ',  v_registros.estado;

    END IF;


    -- Sentencia de la insercion
    insert into tes.tplan_pago(
        estado_reg,
        nro_cuota,
        nro_sol_pago,
        id_proceso_wf,
        estado,
        --tipo_pago,
        monto_ejecutar_total_mo,
        obs_descuentos_anticipo,
        id_plan_pago_fk,
        id_obligacion_pago,
        id_plantilla,
        descuento_anticipo,
        otros_descuentos,
        tipo,
        obs_monto_no_pagado,
        obs_otros_descuentos,
        monto,
        nombre_pago,
        id_estado_wf,
        id_cuenta_bancaria,
        forma_pago,
        monto_no_pagado,
        fecha_reg,
        id_usuario_reg,
        fecha_mod,
        id_usuario_mod,
        liquido_pagable,
        fecha_tentativa,
        --tipo_cambio,
        monto_retgar_mo,
        descuento_ley,
        obs_descuentos_ley,
        porc_descuento_ley,
        nro_cheque,
        nro_cuenta_bancaria,
        id_cuenta_bancaria_mov,
        id_usuario_ai,
        usuario_ai,
        porc_monto_retgar,
        porc_monto_excento_var,
        monto_excento,
        fecha_costo_ini,
        fecha_costo_fin,
        codigo_tipo_anticipo,
        fecha_documento,--##ETR-1914
        fecha_derivacion,--##ETR-1914
        dias_limite --##ETR-1914
    )
    values
    (
        'activo',
        v_nro_cuota,
        '---',--'v_parametros.nro_sol_pago',
        v_id_proceso_wf,
        v_codigo_estado,
        --v_parametros.tipo_pago,
        v_monto_ejecutar_total_mo,
        (p_hstore->'obs_descuentos_anticipo')::varchar,
        (p_hstore->'id_plan_pago_fk')::integer,
        (p_hstore->'id_obligacion_pago')::integer,
        (p_hstore->'id_plantilla')::integer,
        (p_hstore->'descuento_anticipo')::numeric,
        (p_hstore->'otros_descuentos')::numeric,
        (p_hstore->'tipo')::varchar,
        (p_hstore->'obs_monto_no_pagado')::text,
        (p_hstore->'obs_otros_descuentos')::text,
        (p_hstore->'monto')::numeric,
        (p_hstore->'nombre_pago')::varchar,
        v_id_estado_wf,
        v_id_cuenta_bancaria,
        v_forma_pago,
        (p_hstore->'monto_no_pagado')::numeric,
        now(),
        p_id_usuario,
        null,
        null,
        v_liquido_pagable,
        (p_hstore->'fecha_tentativa')::date,
        --v_parametros.tipo_cambio,
        (p_hstore->'monto_retgar_mo')::numeric,
        (p_hstore->'descuento_ley')::numeric,
        (p_hstore->'obs_descuentos_ley'),
        COALESCE((p_hstore->'porc_descuento_ley')::numeric,0),
        COALESCE(v_nro_cheque,0),
        v_nro_cuenta_bancaria,
        v_id_cuenta_bancaria_mov,
        (p_hstore->'_id_usuario_ai')::integer,
        (p_hstore->'_nombre_usuario_ai')::varchar,
        (p_hstore->'porc_monto_retgar')::numeric,
        v_porc_monto_excento_var,
        v_monto_excento,
        (p_hstore->'fecha_costo_ini')::date,
        (p_hstore->'fecha_costo_fin')::date,
        (p_hstore -> 'codigo_tipo_anticipo')::varchar,
        (p_hstore->'fecha_documento')::date,--##ETR-1914
        (p_hstore->'fecha_derivacion')::date,--##ETR-1914
        (p_hstore->'dias_limite')::integer --##ETR-1914
    )RETURNING id_plan_pago into v_id_plan_pago;


    --RAC 22/08/2017, si no tenemos cuenta bancaria  busca segun configuracion predetermianda
    -- para los centors de costos afectados
    IF v_id_cuenta_bancaria is NULL THEN
        IF  not tes.f_calcular_cuenta_bancaria_pp(v_id_plan_pago) THEN
            raise exception 'error al determinar cuentas bancarias predeterminadas';
        END IF;
    END IF;

    --actualiza la cuota vigente en la obligacion
    update tes.tobligacion_pago  p set
        nro_cuota_vigente =  v_nro_cuota
    where id_obligacion_pago =  (p_hstore->'id_obligacion_pago')::integer;

    -- chequea fechas de costos inicio y fin
    --v_resp_doc =  tes.f_validar_periodo_costo(v_id_plan_pago);

    -- inserta documentos en estado borrador si estan configurados
    v_resp_doc =  wf.f_inserta_documento_wf(p_id_usuario, v_id_proceso_wf, v_id_estado_wf);

    -- verificar documentos
    v_resp_doc = wf.f_verifica_documento(p_id_usuario, v_id_estado_wf);


    --Definicion de la respuesta
    v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plan Pago almacenado(a) con exito (id_plan_pago'||v_id_plan_pago||')');
    v_resp = pxp.f_agrega_clave(v_resp,'id_plan_pago',v_id_plan_pago::varchar);
    v_resp = pxp.f_agrega_clave(v_resp,'id_obligacion_pago',(p_hstore->'id_obligacion_pago')::varchar);
    v_resp = pxp.f_agrega_clave(v_resp,'id_estado_wf',v_id_estado_wf::varchar);
    v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_wf',v_id_proceso_wf::varchar);




    --Devuelve la respuesta
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