create or replace function tes.f_consulta_cbte_sel(p_administrador integer, p_id_usuario integer, p_tabla character varying,
                                    p_transaccion character varying) returns character varying
    language plpgsql
as
$$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.f_consulta_cbte_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tcajero'
 AUTOR: 		 (admin)
 FECHA:	        18-12-2013 19:39:02
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE


    v_consulta        varchar;
    v_parametros      record;
    v_nombre_funcion  text;
    v_resp            varchar;
    v_id_moneda_base  integer;
    v_filtro          varchar;
    v_id_funcionarios integer[];
    v_codigo          varchar;
    v_id_uos          integer;
    v_registro_moneda record;

BEGIN

    v_nombre_funcion = 'tes.f_consulta_cbte_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'TES_CXCO_SEL'
     #DESCRIPCION:	Consulta de datos
     #AUTOR:		MMV
     #FECHA:		03-03-2021
    ***********************************/

    if
        (p_transaccion = 'TES_CXCO_SEL') then

        begin
            v_id_moneda_base
                = param.f_get_moneda_base();

            select *
            into
                v_registro_moneda
            from param.tmoneda m
            where m.id_moneda = v_id_moneda_base;

            SELECT uo.codigo, uo.id_uo
            INTO v_codigo,v_id_uos
            FROM orga.tuo uo
                     JOIN orga.tuo_funcionario uof ON uof.id_uo = uo.id_uo
                     JOIN orga.tfuncionario fun on fun.id_funcionario = uof.id_funcionario
                     JOIN segu.tusuario usu on usu.id_persona = fun.id_persona
            WHERE uof.fecha_asignacion <= now()::date
              and (uof.fecha_finalizacion is null or uof.fecha_finalizacion >= now()::date)
              and usu.id_usuario = p_id_usuario;
            IF
                        v_codigo = 'DTE' or v_codigo = 'GAF' THEN
                WITH RECURSIVE uo_centro(
                                         ids,
                                         id_uo,
                                         id_uo_padre
                    ) AS
                                   (
                                       SELECT ARRAY [ c_1.id_uo ] AS "array",
                                              c_1.id_uo,
                                              NULL::integer       AS id_uo_padre
                                       FROM orga.tuo c_1
                                       WHERE c_1.centro::text = 'si'::text
                                         AND c_1.estado_reg::text = 'activo'::text
                                       UNION
                                       SELECT pc.ids || c2.id_uo,
                                              c2.id_uo,
                                              euo.id_uo_padre
                                       FROM orga.tuo c2
                                                JOIN orga.testructura_uo euo ON euo.id_uo_hijo = c2.id_uo
                                                JOIN uo_centro pc ON pc.id_uo = euo.id_uo_padre
                                       WHERE c2.centro::text = 'no'::text
                                         AND c2.estado_reg::text = 'activo'::text
                                   )
                SELECT array_agg(uof.id_funcionario::INTEGER)
                INTO v_id_funcionarios
                FROM uo_centro c
                         JOIN orga.tuo cl ON cl.id_uo = c.ids[1]
                         JOIN orga.tuo_funcionario uof ON uof.id_uo = c.id_uo
                where c.id_uo_padre = v_id_uos;
            END IF;

            IF
                    p_administrador != 1 THEN
                --#74
                IF v_id_funcionarios IS NOT NULL THEN
                    v_filtro = ' (lower(cbte.estado_reg)!=''borrador'') and (lower(cbte.estado_reg)!=''validado'' ) ';
                ELSE
                    v_filtro =
                            ' (lower(cbte.estado_reg)!=''anulado'') and (lower(cbte.estado_reg)!=''borrador'') and (lower(cbte.estado_reg)!=''validado'' ) ';
                END IF;
            ELSE
                v_filtro = '(lower(cbte.estado_reg)!=''borrador'') and (lower(cbte.estado_reg)!=''validado'' ) ';
            END IF;

            --Sentencia de la consulta
            v_consulta
                := 'select          incbte.manual,
                                    incbte.estado_reg,
                                    incbte.id_int_comprobante,
                                    incbte.fecha,
                                    incbte.nro_tramite,
                                    incbte.beneficiario,
                                    incbte.tipo_cambio,
                                    incbte.liquido_pagable,
                                    incbte.glosa,
                                    incbte.fecha_documento,
                                    incbte.cento_consto,
                                    incbte.codigo,
                                    incbte.temporal,
                                    incbte.vbregional,' ||
                   '  incbte.id_depto,
                      incbte.id_gestion
      from (
      select cbte.manual,
              cbte.estado_reg,
              cbte.id_int_comprobante,
              cbte.fecha,
              cbte.nro_tramite,
              cbte.beneficiario,
              cbte.tipo_cambio,
              cbte.liquido_pagable,
              cbte.glosa1 as glosa,
              cbte.temporal, cbte.vbregional,
              pan.fecha_documento,
              cbte.id_depto,
              cbte.id_gestion,
              (select pxp.list(distinct cc.codigo_cc)
               from tes.tobligacion_det od
                        inner join param.vcentro_costo cc on cc.id_centro_costo = od.id_centro_costo
               where od.id_obligacion_pago = pan.id_obligacion_pago) as cento_consto,
              mo.codigo
       from conta.vint_comprobante cbte
                join param.tmoneda mo on mo.id_moneda = cbte.id_moneda
                inner join wf.tproceso_wf pwf on pwf.id_proceso_wf = cbte.id_proceso_wf
                inner join wf.testado_wf ew on ew.id_estado_wf = cbte.id_estado_wf
                left join tes.tplan_pago pan on pan.id_int_comprobante = cbte.id_int_comprobante
       where ' || v_filtro || ' ) incbte
                     where ';

            --Definicion de la respuesta
            v_consulta := v_consulta || v_parametros.filtro;
            v_consulta := v_consulta || ' order by ' || v_parametros.ordenacion || ' ' || v_parametros.dir_ordenacion ||
                          ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            --Devuelve la respuesta
            raise notice '%',v_consulta;
            return v_consulta;

        end;

        /*********************************
         #TRANSACCION:  'TES_CXCO_CONT'
         #DESCRIPCION:	Conteo de registros
         #AUTOR:		MMV
         #FECHA:		03-03-2021
        ***********************************/

    elsif
        (p_transaccion = 'TES_CXCO_CONT') then

        begin
            v_id_moneda_base
                = param.f_get_moneda_base();

            select *
            into
                v_registro_moneda
            from param.tmoneda m
            where m.id_moneda = v_id_moneda_base;

            SELECT uo.codigo, uo.id_uo
            INTO v_codigo,v_id_uos
            FROM orga.tuo uo
                     JOIN orga.tuo_funcionario uof ON uof.id_uo = uo.id_uo
                     JOIN orga.tfuncionario fun on fun.id_funcionario = uof.id_funcionario
                     JOIN segu.tusuario usu on usu.id_persona = fun.id_persona
            WHERE uof.fecha_asignacion <= now()::date
              and (uof.fecha_finalizacion is null or uof.fecha_finalizacion >= now()::date)
              and usu.id_usuario = p_id_usuario;
            IF
                        v_codigo = 'DTE' or v_codigo = 'GAF' THEN
                WITH RECURSIVE uo_centro(
                                         ids,
                                         id_uo,
                                         id_uo_padre
                    ) AS
                                   (
                                       SELECT ARRAY [ c_1.id_uo ] AS "array",
                                              c_1.id_uo,
                                              NULL::integer       AS id_uo_padre
                                       FROM orga.tuo c_1
                                       WHERE c_1.centro::text = 'si'::text
                                         AND c_1.estado_reg::text = 'activo'::text
                                       UNION
                                       SELECT pc.ids || c2.id_uo,
                                              c2.id_uo,
                                              euo.id_uo_padre
                                       FROM orga.tuo c2
                                                JOIN orga.testructura_uo euo ON euo.id_uo_hijo = c2.id_uo
                                                JOIN uo_centro pc ON pc.id_uo = euo.id_uo_padre
                                       WHERE c2.centro::text = 'no'::text
                                         AND c2.estado_reg::text = 'activo'::text
                                   )
                SELECT array_agg(uof.id_funcionario::INTEGER)
                INTO v_id_funcionarios
                FROM uo_centro c
                         JOIN orga.tuo cl ON cl.id_uo = c.ids[1]
                         JOIN orga.tuo_funcionario uof ON uof.id_uo = c.id_uo
                where c.id_uo_padre = v_id_uos;
            END IF;

            IF
                    p_administrador != 1 THEN
                --#74
                IF v_id_funcionarios IS NOT NULL THEN
                    v_filtro = ' (lower(cbte.estado_reg)!=''borrador'') and (lower(cbte.estado_reg)!=''validado'' ) ';
                ELSE
                    v_filtro =
                            ' (lower(cbte.estado_reg)!=''anulado'') and (lower(cbte.estado_reg)!=''borrador'') and (lower(cbte.estado_reg)!=''validado'' ) ';
                END IF;
            ELSE
                v_filtro = '(lower(cbte.estado_reg)!=''borrador'') and (lower(cbte.estado_reg)!=''validado'' ) ';
            END IF;
            --Sentencia de la consulta de conteo de registros
            v_consulta
                := 'select  count(incbte.id_int_comprobante)
                    from (
                    select cbte.manual,
                            cbte.estado_reg,
                            cbte.id_int_comprobante,
                            cbte.fecha,
                            cbte.nro_tramite,
                            cbte.beneficiario,
                            cbte.tipo_cambio,
                            cbte.liquido_pagable,
                            cbte.glosa1 as glosa,
                            cbte.temporal, cbte.vbregional,
                            pan.fecha_documento,
                            cbte.id_depto,
                            cbte.id_gestion,
                            (select pxp.list(distinct cc.codigo_cc)
                             from tes.tobligacion_det od
                                      inner join param.vcentro_costo cc on cc.id_centro_costo = od.id_centro_costo
                             where od.id_obligacion_pago = pan.id_obligacion_pago) as cento_consto,
                            mo.codigo
                     from conta.vint_comprobante cbte
                              inner join param.tmoneda mo on mo.id_moneda = cbte.id_moneda
                              inner join wf.tproceso_wf pwf on pwf.id_proceso_wf = cbte.id_proceso_wf
                              inner join wf.testado_wf ew on ew.id_estado_wf = cbte.id_estado_wf
                              left join tes.tplan_pago pan on pan.id_int_comprobante = cbte.id_int_comprobante
                     where ' || v_filtro || ' ) incbte
                     where ';
            --Definicion de la respuesta
            v_consulta
                := v_consulta || v_parametros.filtro;

            --Devuelve la respuesta
            return v_consulta;

        end;

    else

        raise exception 'Transaccion inexistente';

    end if;

EXCEPTION

    WHEN OTHERS THEN
        v_resp = '';
        v_resp
            = pxp.f_agrega_clave(v_resp, 'mensaje', SQLERRM);
        v_resp
            = pxp.f_agrega_clave(v_resp, 'codigo_error', SQLSTATE);
        v_resp
            = pxp.f_agrega_clave(v_resp, 'procedimientos', v_nombre_funcion);
        raise
            exception '%',v_resp;
END;
$$;