CREATE OR REPLACE FUNCTION tes.ft_solicitud_efectivo_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:       Sistema de Obligaciones de Pago
 FUNCION:       tes.ft_solicitud_efectivo_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tsolicitud_efectivo'
 AUTOR:          (gsarmiento)
 FECHA:         24-11-2015 12:59:51
 COMENTARIOS:   
***************************************************************************


    HISTORIAL DE MODIFICACIONES:
    
 ISSUE            FECHA:              AUTOR                 DESCRIPCION
   
 #0              24-11-2015        Gonzalo Sarmiento        Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tsolicitud_efectivo'
 #146 IC         04/12/2017        RAC                      Listado de solcitudes de tipo ingreso para interface de ajsutes
***************************************************************************/

DECLARE

    v_consulta          varchar;
    v_parametros        record;
    v_nombre_funcion    text;
    v_resp              varchar;
    v_filtro            varchar;
    v_inner             varchar;
    v_id_tipo_solicitud integer;
    v_saldo             varchar;
    v_id_tipos_solicitudes  INTEGER[];
    
    v_num               varchar;
    v_id_depto          integer;
    v_id_gestion        integer;
    v_id_proceso_caja   integer;
    v_historico         varchar;
    v_cajas             record;
    v_id_caja           integer[];
    v_i                 integer;

BEGIN

    v_nombre_funcion = 'tes.ft_solicitud_efectivo_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
    #TRANSACCION:  'TES_SOLEFE_SEL'
    #DESCRIPCION:   Consulta de datos
    #AUTOR:     gsarmiento
    #FECHA:     24-11-2015 12:59:51
    ***********************************/

    if(p_transaccion='TES_SOLEFE_SEL')then

        begin
            v_filtro='';
            v_inner='';

            IF (v_parametros.id_funcionario_usu is null) then
                v_parametros.id_funcionario_usu = -1;
            END IF;
            
            v_saldo = 'solefe.monto';

            IF  pxp.f_existe_parametro(p_tabla,'historico') THEN
               v_historico =  v_parametros.historico;
            ELSE
               v_historico = 'no';
            END IF;

            IF  lower(v_parametros.tipo_interfaz) in ('condetalle','sindetalle','efectivocaja') THEN

                    select id_tipo_solicitud into v_id_tipo_solicitud
                    from tes.ttipo_solicitud
                    where codigo='SOLEFE';

                     v_saldo = 'case when solefe.estado in (''entregado'',''finalizado'') then solefe.monto - COALESCE((select sum(monto)
                                            from tes.tsolicitud_efectivo
                                            where id_solicitud_efectivo_fk = solefe.id_solicitud_efectivo
                                            and estado=''rendido''), 0.00)
                                            - COALESCE((select sum(monto)
                                            from tes.tsolicitud_efectivo
                                            where id_solicitud_efectivo_fk = solefe.id_solicitud_efectivo
                                            and estado=''devuelto''), 0.00)
                                            + COALESCE((select sum(monto)
                                            from tes.tsolicitud_efectivo
                                            where id_solicitud_efectivo_fk = solefe.id_solicitud_efectivo
                                            and estado=''repuesto''), 0.00)
                                else 0.00 end as saldo';

                    IF p_administrador !=1 THEN
                        v_i = 1;
                        FOR v_cajas in (select id_caja
                                        from tes.tcajero c
                                        where id_funcionario=v_parametros.id_funcionario_usu
                                        and tipo='responsable'  and c.estado_Reg = 'activo')LOOP
                            v_id_caja[v_i] = v_cajas.id_caja;
                            v_i = v_i + 1;
                        END LOOP;

                        IF v_i > 1 THEN
                            v_filtro = '(solefe.id_caja in ('|| array_to_string(v_id_caja,',') ||') 
                            
                                       OR (solefe.id_funcionario = '||v_parametros.id_funcionario_usu::varchar||' or  solefe.id_usuario_reg = '||p_id_usuario||')) and solefe.id_tipo_solicitud = '||v_id_tipo_solicitud||' and ';
                        ELSE
                            v_filtro = '(solefe.id_funcionario='||v_parametros.id_funcionario_usu::varchar||'  or solefe.id_usuario_reg='||p_id_usuario||' or solefe.id_usuario_mod='||p_id_usuario||') and solefe.id_tipo_solicitud = '||v_id_tipo_solicitud||' and ';
                        END IF;

                    ELSE
                      --   v_filtro = '(pc.estado = ''solicitado'') and ';
                       v_filtro = 'solefe.id_tipo_solicitud = '||v_id_tipo_solicitud||' and ';
                    END IF;

            END IF;
            
           
            
            
            IF lower(v_parametros.tipo_interfaz) in ('vbsolicitudefectivo') THEN
                

                v_saldo = 'solefe.monto - COALESCE((select sum(monto)
                                        from tes.tsolicitud_efectivo
                                        where id_solicitud_efectivo_fk = solefe.id_solicitud_efectivo
                                        and estado=''finalizado''), 0) as saldo';

                v_inner =  'inner join wf.testado_wf ew on ew.id_estado_wf = solefe.id_estado_wf';
                IF p_administrador !=1 THEN
                   v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (solefe.estado in (''vbjefe'',''vbcajero'',''vbfin'')) and  solefe.id_tipo_solicitud in (select id_tipo_solicitud from tes.ttipo_solicitud where codigo in (''SOLEFE'',''INGEFE'')) and ';
                 ELSE
                     v_filtro = '(solefe.estado in (''vbjefe'',''vbcajero'',''vbfin'')) and
                     solefe.id_tipo_solicitud in (select id_tipo_solicitud from tes.ttipo_solicitud where codigo in (''SOLEFE'',''INGEFE'')) and ';
                END IF;
            END IF;

            IF lower(v_parametros.tipo_interfaz) in ('devolucionreposicionefectivovb') THEN
                

                v_saldo = 'solefe.monto - COALESCE((select sum(monto)
                                        from tes.tsolicitud_efectivo
                                        where id_solicitud_efectivo_fk = solefe.id_solicitud_efectivo
                                        and estado=''finalizado''), 0) as saldo';

                v_inner =  'inner join wf.testado_wf ew on ew.id_estado_wf = solefe.id_estado_wf';
                IF p_administrador !=1 THEN
                   v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (solefe.estado = ''vbcajero'') and  solefe.id_tipo_solicitud in (select id_tipo_solicitud from tes.ttipo_solicitud where codigo in (''DEVEFE'',''REPEFE'')) and ';
                 ELSE
                     v_filtro = '(solefe.estado = ''vbcajero'') and
                     solefe.id_tipo_solicitud in (select id_tipo_solicitud from tes.ttipo_solicitud where codigo in (''DEVEFE'',''REPEFE'')) and ';
                END IF;
            END IF;
            

            IF lower(v_parametros.tipo_interfaz) in ('rendicionefectivo') THEN
                select id_tipo_solicitud into v_id_tipo_solicitud
                from tes.ttipo_solicitud
                where codigo='RENEFE';

                v_saldo = 'solpri.monto - COALESCE((
                                 select sum(monto)
                                 from tes.tsolicitud_efectivo
                                 where id_solicitud_efectivo_fk =
                                   solpri.id_solicitud_efectivo and
                                       estado in  (''rendido'',''devuelto'')
                                 ), 0) + COALESCE((
                                                           select sum(monto)
                                                           from tes.tsolicitud_efectivo
                                                           where id_solicitud_efectivo_fk =
                                                             solpri.id_solicitud_efectivo and
                                                                 estado in  (''repuesto'')
                                 ), 0) - solefe.monto as saldo';

                IF v_historico = 'si' THEN
                    v_inner =  'inner join wf.testado_wf ew on ew.id_proceso_wf = solefe.id_proceso_wf ';

                    IF p_administrador !=1 THEN
                       v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (solefe.estado in (''rendido'')) and  solefe.id_tipo_solicitud = ' || v_id_tipo_solicitud|| ' and ';
                    ELSE
                         v_filtro = '(solefe.estado in (''rendido'')) and solefe.id_tipo_solicitud=' ||v_id_tipo_solicitud||' and ';
                    END IF;
                ELSE
                    v_inner =  'inner join wf.testado_wf ew on ew.id_estado_wf = solefe.id_estado_wf';

                    IF p_administrador !=1 THEN
                       v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (solefe.estado in (''revision'',''vbjefedevsol'')) and  solefe.id_tipo_solicitud = ' || v_id_tipo_solicitud|| ' and ';
                    ELSE
                         v_filtro = '(solefe.estado in (''revision'',''vbjefedevsol'')) and solefe.id_tipo_solicitud=' ||v_id_tipo_solicitud||' and ';
                    END IF;

                END IF;

            END IF;

            IF lower(v_parametros.tipo_interfaz) in ('devolucionreposicion') THEN
                v_inner =  'inner join wf.testado_wf ew on ew.id_estado_wf = solefe.id_estado_wf';
                IF p_administrador !=1 THEN
                   v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (solefe.estado != ''vbcajero'') and
                   solefe.id_tipo_solicitud in (select id_tipo_solicitud from tes.ttipo_solicitud where codigo in (''DEVEFE'',''REPEFE'')) and ';
                 ELSE
                     v_filtro = '(solefe.estado !=''vbcajero'') and
                     solefe.id_tipo_solicitud in (select id_tipo_solicitud from tes.ttipo_solicitud where codigo in (''DEVEFE'',''REPEFE'')) and ';
                END IF;
            END IF;
            --Sentencia de la consulta
            v_consulta:='select
                        solefe.id_solicitud_efectivo,
                        solefe.id_caja,
                        caja.codigo,
                        caja.id_depto,
                        caja.id_moneda,
                        solefe.id_estado_wf,
                        solefe.monto,
                        COALESCE((select sum(monto) from tes.tsolicitud_efectivo where id_solicitud_efectivo_fk=solefe.id_solicitud_efectivo and estado=''rendido''),0.00) as monto_rendido,
                        COALESCE((select sum(monto) from tes.tsolicitud_efectivo where id_solicitud_efectivo_fk=solefe.id_solicitud_efectivo and estado=''devuelto''),0.00) as monto_devuelto,
                        COALESCE((select sum(monto) from tes.tsolicitud_efectivo where id_solicitud_efectivo_fk=solefe.id_solicitud_efectivo and estado=''repuesto''),0.00) as monto_repuesto,
                        solefe.id_proceso_wf,
                        solefe.nro_tramite,
                        solefe.estado,
                        solefe.estado_reg,
                        solefe.motivo,
                        solefe.id_funcionario,
                        fun.desc_funcionario1 as desc_funcionario,
                        solefe.fecha,
                        solefe.fecha_entrega,
                        caja.dias_maximo_rendicion,
                        case when solefe.estado=''finalizado'' then caja.dias_maximo_rendicion
                        else caja.dias_maximo_rendicion - (CURRENT_DATE -COALESCE(solefe.fecha_entrega,current_date) - pxp.f_get_weekend_days(COALESCE(solefe.fecha_entrega::date,current_date),current_date))::integer end as dias_no_rendidos,
                        solefe.id_usuario_ai,
                        solefe.fecha_reg,
                        solefe.usuario_ai,
                        solefe.id_usuario_reg,
                        solefe.id_usuario_mod,
                        solefe.fecha_mod,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod,
                        solpri.nro_tramite as solicitud_efectivo_padre,'
                        ||v_saldo||'
                        from tes.tsolicitud_efectivo solefe
                        inner join segu.tusuario usu1 on usu1.id_usuario = solefe.id_usuario_reg
                        inner join tes.tcaja caja on caja.id_caja=solefe.id_caja
                        inner join orga.vfuncionario fun on fun.id_funcionario = solefe.id_funcionario
                        left join segu.tusuario usu2 on usu2.id_usuario = solefe.id_usuario_mod
                        left join tes.tsolicitud_efectivo solpri on solpri.id_solicitud_efectivo=solefe.id_solicitud_efectivo_fk
                        '||v_inner||'
                        where  ' || v_filtro;

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            --Devuelve la respuesta
            raise notice   '%', v_consulta;
           
            return v_consulta;

        end;

    /*********************************
    #TRANSACCION:  'TES_RNDEFE_CONT'
    #DESCRIPCION:   Consulta de datos para solicitudes entregadas
    #AUTOR:     gsarmiento
    #FECHA:     10-06-2016
    ***********************************/

    elsif(p_transaccion='TES_RNDEFE_CONT')then

        begin

            --Sentencia de la consulta
            v_consulta:='select count (distinct sol.nro_tramite)
                         from tes.tsolicitud_efectivo sol
                         inner join tes.tcaja cj on cj.id_caja=sol.id_caja
                         inner join tes.tcajero cjr on cjr.id_caja=cj.id_caja
                         and cjr.tipo=''responsable'' and current_date between cjr.fecha_inicio and cjr.fecha_fin
                         inner join orga.vfuncionario fun on fun.id_funcionario=cjr.id_funcionario
                         inner join param.tmoneda m on m.id_moneda=cj.id_moneda
                         inner join orga.vfuncionario_cargo slct on slct.id_funcionario=sol.id_funcionario
                         where ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            --v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            raise notice '%', v_consulta;
            return v_consulta;

        end;

    /*********************************
    #TRANSACCION:  'TES_REPEFE_SEL'
    #DESCRIPCION:   Consulta de datos para reporte
    #AUTOR:     gsarmiento
    #FECHA:     04-04-2016
    ***********************************/

    elsif(p_transaccion='TES_REPEFE_SEL')then

        begin

            --Sentencia de la consulta
            v_consulta:='select caja.codigo,
                         solefe.monto,
                         mon.moneda,
                         mon.codigo as codigo_moneda,
                         pxp.f_convertir_num_a_letra(monto) as monto_literal,
                         solefe.nro_tramite,
                         solefe.estado,
                         solefe.motivo,
                         fun.desc_funcionario1 as desc_funcionario,
                         solefe.fecha,
                         jef.desc_funcionario1 as vbjefe,
                         fin.desc_funcionario1 as vbfinanzas
                  from tes.tsolicitud_efectivo solefe
                       inner join tes.tcaja caja on caja.id_caja = solefe.id_caja
                       inner join param.tmoneda mon on mon.id_moneda = caja.id_moneda
                       inner join orga.vfuncionario fun on fun.id_funcionario = solefe.id_funcionario
                       left join orga.vfuncionario jef on jef.id_funcionario=solefe.id_funcionario_jefe_aprobador
                       left join orga.vfuncionario fin on fin.id_funcionario=solefe.id_funcionario_finanzas
                  where ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            --Devuelve la respuesta
            raise notice '%', v_consulta;
            return v_consulta;

        end;

    /*********************************
    #TRANSACCION:  'TES_SOLENT_SEL'
    #DESCRIPCION:   Consulta de datos para solicitudes entregadas
    #AUTOR:     gsarmiento
    #FECHA:     10-06-2016
    ***********************************/

    elsif(p_transaccion='TES_SOLENT_SEL')then

        begin

            --Sentencia de la consulta
            v_consulta:='select 
                          sol.fecha_entrega, m.moneda, sol.nro_tramite, cj.codigo,
                         fun.desc_funcionario1 as cajero, slct.nombre_unidad, slct.desc_funcionario1 as solicitante,
                         sol.motivo, sol.monto, ren.fecha as fecha_rendicion
                         from tes.tsolicitud_efectivo sol
                         left join tes.tsolicitud_efectivo ren on ren.id_solicitud_efectivo_fk = sol.id_solicitud_efectivo
                         and ren.estado = ''rendido''
                         inner join tes.tcaja cj on cj.id_caja=sol.id_caja
                         inner join tes.tcajero cjr on cjr.id_caja=cj.id_caja
                           and cjr.tipo=''responsable'' 
                           and   (  sol.fecha_entrega between cjr.fecha_inicio and COALESCE   (cjr.fecha_fin, current_date)  or (sol.fecha_entrega is null and sol.estado = ''vbcajero'' and sol.fecha between cjr.fecha_inicio and COALESCE   (cjr.fecha_fin, current_date)))
                         inner join orga.vfuncionario fun on fun.id_funcionario=cjr.id_funcionario
                         inner join param.tmoneda m on m.id_moneda=cj.id_moneda
                         inner join orga.vfuncionario_cargo slct on slct.id_funcionario=sol.id_funcionario
                         and current_date between slct.fecha_asignacion and COALESCE(slct.fecha_finalizacion,current_date)
                         where ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            raise notice '%', v_consulta;
            return v_consulta;

        end;

    /*********************************
    #TRANSACCION:  'TES_RNDEFE_SEL'
    #DESCRIPCION:   Consulta de datos para rendiciones de efectivo
    #AUTOR:     gsarmiento
    #FECHA:     10-06-2016
    ***********************************/

    elsif(p_transaccion='TES_RNDEFE_SEL')then

        begin
            --Sentencia de la consulta
            v_consulta:='select sol.fecha_entrega as fecha,
                                sol.nro_tramite as desc_plantilla,
                                NULL as rendicion,
                                NULL as importe_neto,
                                NULL as importe_descuento_ley,
                                sol.monto as cargo,
                                0.00 as descargo
                          from tes.tsolicitud_efectivo sol
                          where sol.id_proceso_wf='||v_parametros.id_proceso_wf||'
                          UNION ALL
                               select doc.fecha,
                               null as desc_plantilla,
                               ''Razon Social: ''       || doc.razon_social || '' N° Doc: '' ||
                               doc.nro_documento || ''Nit:'' || doc.nit || '' Nro Autorizacion:'' ||
                               doc.nro_autorizacion || '' Cod Control: '' || doc.codigo_control as rendicion,
                               doc.importe_neto,
                               doc.importe_descuento_ley,
                               0.00 as cargo,
                               doc.importe_neto as descargo
                      from tes.tsolicitud_efectivo sol
                      inner join tes.tsolicitud_efectivo ren on ren.id_solicitud_efectivo_fk=sol.id_solicitud_efectivo
                           inner join tes.tsolicitud_rendicion_det det on det.id_solicitud_efectivo =
                             ren.id_solicitud_efectivo
                           inner join conta.tdoc_compra_venta doc on doc.id_doc_compra_venta =
                             det.id_documento_respaldo
                           inner join param.tplantilla pla on pla.id_plantilla = doc.id_plantilla
                      where ren.estado = ''rendido'' and sol.id_proceso_wf='||v_parametros.id_proceso_wf||' ';
            
            --Definicion de la respuesta
            --v_consulta:=v_consulta||v_parametros.filtro;
            --v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            raise notice '%', v_consulta;
            return v_consulta;

        end;

    /*********************************
    #TRANSACCION:  'TES_SOLEFE_CONT'
    #DESCRIPCION:   Conteo de registros
    #AUTOR:     gsarmiento
    #FECHA:     24-11-2015 12:59:51
    ***********************************/

    elsif(p_transaccion='TES_SOLEFE_CONT')then

        begin
            v_filtro='';
            v_inner='';

            IF (v_parametros.id_funcionario_usu is null) then
                v_parametros.id_funcionario_usu = -1;
            END IF;
            
            v_saldo = 'solefe.monto';

            IF  pxp.f_existe_parametro(p_tabla,'historico') THEN
               v_historico =  v_parametros.historico;
            ELSE
               v_historico = 'no';
            END IF;

            IF  lower(v_parametros.tipo_interfaz) in ('condetalle','sindetalle','efectivocaja') THEN

                    select id_tipo_solicitud into v_id_tipo_solicitud
                    from tes.ttipo_solicitud
                    where codigo='SOLEFE';

                     
                    IF p_administrador !=1 THEN
                        v_i = 1;
                        FOR v_cajas in (select id_caja
                                        from tes.tcajero c
                                        where id_funcionario=v_parametros.id_funcionario_usu
                                        and tipo='responsable'   and c.estado_Reg = 'activo')LOOP
                            v_id_caja[v_i] = v_cajas.id_caja;
                            v_i = v_i + 1;
                        END LOOP;

                        IF v_i > 1 THEN
                            v_filtro = '(solefe.id_caja in ('|| array_to_string(v_id_caja,',') ||') 
                            
                                       OR (solefe.id_funcionario = '||v_parametros.id_funcionario_usu::varchar||' or  solefe.id_usuario_reg = '||p_id_usuario||')) and solefe.id_tipo_solicitud = '||v_id_tipo_solicitud||' and ';
                        ELSE
                            v_filtro = '(solefe.id_funcionario='||v_parametros.id_funcionario_usu::varchar||'  or solefe.id_usuario_reg='||p_id_usuario||' or solefe.id_usuario_mod='||p_id_usuario||') and solefe.id_tipo_solicitud = '||v_id_tipo_solicitud||' and ';
                        END IF;

                    ELSE
                      --   v_filtro = '(pc.estado = ''solicitado'') and ';
                       v_filtro = 'solefe.id_tipo_solicitud = '||v_id_tipo_solicitud||' and ';
                    END IF;

            END IF;
            
           
            
            
            IF lower(v_parametros.tipo_interfaz) in ('vbsolicitudefectivo') THEN
                

                

                v_inner =  'inner join wf.testado_wf ew on ew.id_estado_wf = solefe.id_estado_wf';
                IF p_administrador !=1 THEN
                   v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (solefe.estado in (''vbjefe'',''vbcajero'',''vbfin'')) and  solefe.id_tipo_solicitud in (select id_tipo_solicitud from tes.ttipo_solicitud where codigo in (''SOLEFE'',''INGEFE'')) and ';
                 ELSE
                     v_filtro = '(solefe.estado in (''vbjefe'',''vbcajero'',''vbfin'')) and
                     solefe.id_tipo_solicitud in (select id_tipo_solicitud from tes.ttipo_solicitud where codigo in (''SOLEFE'',''INGEFE'')) and ';
                END IF;
            END IF;

            IF lower(v_parametros.tipo_interfaz) in ('devolucionreposicionefectivovb') THEN
                

                

                v_inner =  'inner join wf.testado_wf ew on ew.id_estado_wf = solefe.id_estado_wf';
                IF p_administrador !=1 THEN
                   v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (solefe.estado = ''vbcajero'') and  solefe.id_tipo_solicitud in (select id_tipo_solicitud from tes.ttipo_solicitud where codigo in (''DEVEFE'',''REPEFE'')) and ';
                 ELSE
                     v_filtro = '(solefe.estado = ''vbcajero'') and
                     solefe.id_tipo_solicitud in (select id_tipo_solicitud from tes.ttipo_solicitud where codigo in (''DEVEFE'',''REPEFE'')) and ';
                END IF;
            END IF;
            

            IF lower(v_parametros.tipo_interfaz) in ('rendicionefectivo') THEN
                select id_tipo_solicitud into v_id_tipo_solicitud
                from tes.ttipo_solicitud
                where codigo='RENEFE';

               
                IF v_historico = 'si' THEN
                    v_inner =  'inner join wf.testado_wf ew on ew.id_proceso_wf = solefe.id_proceso_wf ';

                    IF p_administrador !=1 THEN
                       v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (solefe.estado in (''rendido'')) and  solefe.id_tipo_solicitud = ' || v_id_tipo_solicitud|| ' and ';
                    ELSE
                         v_filtro = '(solefe.estado in (''rendido'')) and solefe.id_tipo_solicitud=' ||v_id_tipo_solicitud||' and ';
                    END IF;
                ELSE
                    v_inner =  'inner join wf.testado_wf ew on ew.id_estado_wf = solefe.id_estado_wf';

                    IF p_administrador !=1 THEN
                       v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (solefe.estado in (''revision'',''vbjefedevsol'')) and  solefe.id_tipo_solicitud = ' || v_id_tipo_solicitud|| ' and ';
                    ELSE
                         v_filtro = '(solefe.estado in (''revision'',''vbjefedevsol'')) and solefe.id_tipo_solicitud=' ||v_id_tipo_solicitud||' and ';
                    END IF;

                END IF;

            END IF;

            IF lower(v_parametros.tipo_interfaz) in ('devolucionreposicion') THEN
                v_inner =  'inner join wf.testado_wf ew on ew.id_estado_wf = solefe.id_estado_wf';
                IF p_administrador !=1 THEN
                   v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (solefe.estado != ''vbcajero'') and
                   solefe.id_tipo_solicitud in (select id_tipo_solicitud from tes.ttipo_solicitud where codigo in (''DEVEFE'',''REPEFE'')) and ';
                 ELSE
                     v_filtro = '(solefe.estado !=''vbcajero'') and
                     solefe.id_tipo_solicitud in (select id_tipo_solicitud from tes.ttipo_solicitud where codigo in (''DEVEFE'',''REPEFE'')) and ';
                END IF;
            END IF;

            

            --Sentencia de la consulta de conteo de registros
            v_consulta:='select count(solefe.id_solicitud_efectivo)
                        from tes.tsolicitud_efectivo solefe
                        inner join segu.tusuario usu1 on usu1.id_usuario = solefe.id_usuario_reg
                        inner join tes.tcaja caja on caja.id_caja=solefe.id_caja
                        inner join orga.vfuncionario fun on fun.id_funcionario = solefe.id_funcionario
                        left join segu.tusuario usu2 on usu2.id_usuario = solefe.id_usuario_mod
                        left join tes.tsolicitud_efectivo solpri on solpri.id_solicitud_efectivo=solefe.id_solicitud_efectivo_fk
                        '||v_inner||'
                        where '||v_filtro;

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;

            --Devuelve la respuesta
            return v_consulta;

        end;

    /*********************************
    #TRANSACCION:  'TES_MEMOCJ_SEL'
    #DESCRIPCION:   Consulta de datos para reporte memo caja chica
    #AUTOR:     gsarmiento
    #FECHA:     16-06-2016
    ***********************************/

    elsif(p_transaccion='TES_MEMOCJ_SEL')then

        begin
            select pc.num_memo,
                   cj.id_depto,
                   pc.id_gestion,
                   pc.id_proceso_caja
            into
            v_num,
            v_id_depto,
            v_id_gestion,
            v_id_proceso_caja
            from tes.tts_libro_bancos lb
            inner join tes.tproceso_caja pc on pc.id_int_comprobante = lb.id_int_comprobante
            inner join tes.tcaja cj on cj.id_caja=pc.id_caja
            where lb.id_proceso_wf = v_parametros.id_proceso_wf;
            /*
            IF v_num IS NULL THEN

                v_num = param.f_obtener_correlativo(
                              'MEMO',
                               v_id_gestion,-- par_id,
                               NULL, --id_uo
                               v_id_depto,    -- id_depto
                               p_id_usuario,
                               'TES',
                               NULL);

                UPDATE tes.tproceso_caja
                SET num_memo = v_num
                WHERE id_proceso_caja = v_id_proceso_caja;

            END IF;
            */
            --Sentencia de la consulta
            v_consulta:='select lb.fecha,
                               lb.nro_cheque,
                               cj.codigo,
                               apro.desc_funcionario1 as aprobador,
                               apro.descripcion_cargo as cargo_aprobador,
                               sol.desc_funcionario1 as cajero,
                               sol.descripcion_cargo as cargo_cajero,
                               lb.importe_cheque,
                               pc.num_memo
                        from tes.tproceso_caja pc
                        inner join tes.tcaja cj on cj.id_caja = pc.id_caja
                        inner join tes.tts_libro_bancos lb on lb.id_int_comprobante=pc.id_int_comprobante
                        inner join tes.tproceso_caja ap on ap.id_caja = pc.id_caja and ap.tipo = ''apertura''
                        inner join wf.testado_wf wfe on wfe.id_proceso_wf = ap.id_proceso_wf and  wfe.id_funcionario is not null
                        left join orga.vfuncionario_cargo apro on apro.id_funcionario = wfe.id_funcionario and ap.fecha >= apro.fecha_asignacion and
                               apro.fecha_finalizacion is null
                        inner join tes.tcajero cjr on cjr.id_caja = cj.id_caja and lb.fecha between
                               cjr.fecha_inicio and cjr.fecha_fin
                        inner join orga.vfuncionario_cargo sol on sol.id_funcionario = cjr.id_funcionario and ap.fecha >= sol.fecha_asignacion and
                               sol.fecha_finalizacion is null
                        where pc.id_proceso_wf= '||v_parametros.id_proceso_wf;
            
            --Devuelve la respuesta
            raise notice '%', v_consulta;
            return v_consulta;
                        
        end;
        
    
    /*********************************
    #TRANSACCION:  'TES_INGRESOL_SEL'
    #DESCRIPCION:   Consulta de Ingresos
    #AUTOR:     rac
    #FECHA:     04/12/2017
    ***********************************/

    ELSEIF(p_transaccion='TES_INGRESOL_SEL')then

        begin
            v_filtro='';
            v_inner='';

            IF (v_parametros.id_funcionario_usu is null) then
                v_parametros.id_funcionario_usu = -1;
            END IF;
            
            v_saldo = 'solefe.monto';

            IF  pxp.f_existe_parametro(p_tabla,'historico') THEN
               v_historico =  v_parametros.historico;
            ELSE
               v_historico = 'no';
            END IF;

            IF  lower(v_parametros.tipo_interfaz) in ('ingreso_caja') THEN

                    select id_tipo_solicitud into v_id_tipo_solicitud
                    from tes.ttipo_solicitud
                    where codigo='INGEFE';
                   
                    IF p_administrador !=1 THEN
                        v_i = 1;
                        FOR v_cajas in (select id_caja
                                        from tes.tcajero
                                        where id_funcionario=v_parametros.id_funcionario_usu
                                        and tipo='responsable')LOOP
                            v_id_caja[v_i] = v_cajas.id_caja;
                            v_i = v_i + 1;
                        END LOOP;

                        IF v_i > 1 THEN
                            v_filtro = '(solefe.id_caja in ('||v_cajas.id_caja||') OR (solefe.id_funcionario = '||v_parametros.id_funcionario_usu::varchar||' or
                                        solefe.id_usuario_reg = '||p_id_usuario||')) and solefe.id_tipo_solicitud = '||v_id_tipo_solicitud||' and ';
                        ELSE
                            v_filtro = '(solefe.id_funcionario='||v_parametros.id_funcionario_usu::varchar||'  or solefe.id_usuario_reg='||p_id_usuario||' or solefe.id_usuario_mod='||p_id_usuario||') and solefe.id_tipo_solicitud = '||v_id_tipo_solicitud||' and ';
                        END IF;

                    ELSE                     
                       v_filtro = 'solefe.id_tipo_solicitud = '||v_id_tipo_solicitud||' and ';
                    END IF;

            END IF;
            
            
          

            IF v_historico = 'si' THEN
                    v_inner =  'inner join wf.testado_wf ew on ew.id_proceso_wf = solefe.id_proceso_wf ';

                    IF p_administrador !=1 THEN
                       v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' or solefe.id_usuario_reg = '||p_id_usuario||' ) and  (solefe.estado in (''rendido'')) and  solefe.id_tipo_solicitud = ' || v_id_tipo_solicitud|| ' and ';
                    ELSE
                         v_filtro = '(solefe.estado in (''rendido'')) and solefe.id_tipo_solicitud=' ||v_id_tipo_solicitud||' and ';
                    END IF;
             ELSE
                    v_inner =  'inner join wf.testado_wf ew on ew.id_estado_wf = solefe.id_estado_wf';

                    IF p_administrador !=1 THEN
                       v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' or solefe.id_usuario_reg = '||p_id_usuario||' )   and  solefe.id_tipo_solicitud = ' || v_id_tipo_solicitud|| ' and ';
                    ELSE
                         v_filtro = '  solefe.id_tipo_solicitud=' ||v_id_tipo_solicitud||' and ';
                    END IF;

            END IF;

           
            --Sentencia de la consulta
            v_consulta:='select
                        solefe.id_solicitud_efectivo,
                        solefe.id_caja,
                        caja.codigo,
                        caja.id_depto,
                        caja.id_moneda,
                        solefe.id_estado_wf,
                        solefe.monto,
                        COALESCE((select sum(monto) from tes.tsolicitud_efectivo where id_solicitud_efectivo_fk=solefe.id_solicitud_efectivo and estado=''rendido''),0.00) as monto_rendido,
                        COALESCE((select sum(monto) from tes.tsolicitud_efectivo where id_solicitud_efectivo_fk=solefe.id_solicitud_efectivo and estado=''devuelto''),0.00) as monto_devuelto,
                        COALESCE((select sum(monto) from tes.tsolicitud_efectivo where id_solicitud_efectivo_fk=solefe.id_solicitud_efectivo and estado=''repuesto''),0.00) as monto_repuesto,
                        solefe.id_proceso_wf,
                        solefe.nro_tramite,
                        solefe.estado,
                        solefe.estado_reg,
                        solefe.motivo,
                        solefe.id_funcionario,
                        fun.desc_funcionario1 as desc_funcionario,
                        solefe.fecha,
                        solefe.fecha_entrega,
                        caja.dias_maximo_rendicion,
                        case when solefe.estado=''finalizado'' then caja.dias_maximo_rendicion
                        else caja.dias_maximo_rendicion - (CURRENT_DATE -COALESCE(solefe.fecha_entrega,current_date) - pxp.f_get_weekend_days(COALESCE(solefe.fecha_entrega::date,current_date),current_date))::integer end as dias_no_rendidos,
                        solefe.id_usuario_ai,
                        solefe.fecha_reg,
                        solefe.usuario_ai,
                        solefe.id_usuario_reg,
                        solefe.id_usuario_mod,
                        solefe.fecha_mod,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod,
                        solpri.nro_tramite as solicitud_efectivo_padre,'
                        ||v_saldo||'
                        from tes.tsolicitud_efectivo solefe
                        inner join segu.tusuario usu1 on usu1.id_usuario = solefe.id_usuario_reg
                        inner join tes.tcaja caja on caja.id_caja=solefe.id_caja
                        inner join orga.vfuncionario fun on fun.id_funcionario = solefe.id_funcionario
                        left join segu.tusuario usu2 on usu2.id_usuario = solefe.id_usuario_mod
                        left join tes.tsolicitud_efectivo solpri on solpri.id_solicitud_efectivo=solefe.id_solicitud_efectivo_fk
                        '||v_inner||'
                        where  ' || v_filtro;

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            --Devuelve la respuesta
            raise notice   '%', v_consulta;
            return v_consulta;

        end;

    /*********************************
    #TRANSACCION:  'TES_SOLEFE_CONT'
    #DESCRIPCION:   Conteo de registros
    #AUTOR:     gsarmiento
    #FECHA:     24-11-2015 12:59:51
    ***********************************/

    elsif(p_transaccion='TES_INGRESOL_CONT')then

        begin
            v_filtro='';
            v_inner='';
            
            IF (v_parametros.id_funcionario_usu is null) then
                v_parametros.id_funcionario_usu = -1;
            END IF;
            
            v_saldo = 'solefe.monto';

            IF  pxp.f_existe_parametro(p_tabla,'historico') THEN
               v_historico =  v_parametros.historico;
            ELSE
               v_historico = 'no';
            END IF;

            IF  lower(v_parametros.tipo_interfaz) in ('ingreso_caja') THEN

                    select id_tipo_solicitud into v_id_tipo_solicitud
                    from tes.ttipo_solicitud
                    where codigo='INGEFE';

                   
                    IF p_administrador !=1 THEN
                        v_i = 1;
                        FOR v_cajas in (select id_caja
                                        from tes.tcajero
                                        where id_funcionario=v_parametros.id_funcionario_usu
                                        and tipo='responsable')LOOP
                            v_id_caja[v_i] = v_cajas.id_caja;
                            v_i = v_i + 1;
                        END LOOP;

                        IF v_i > 1 THEN
                            v_filtro = '(solefe.id_caja in ('||v_cajas.id_caja||') OR (solefe.id_funcionario = '||v_parametros.id_funcionario_usu::varchar||' or
                                        solefe.id_usuario_reg = '||p_id_usuario||')) and solefe.id_tipo_solicitud = '||v_id_tipo_solicitud||' and ';
                        ELSE
                            v_filtro = '(solefe.id_funcionario='||v_parametros.id_funcionario_usu::varchar||'  or solefe.id_usuario_reg='||p_id_usuario||' or solefe.id_usuario_mod='||p_id_usuario||') and solefe.id_tipo_solicitud = '||v_id_tipo_solicitud||' and ';
                        END IF;

                    ELSE
                      --   v_filtro = '(pc.estado = ''solicitado'') and ';
                       v_filtro = 'solefe.id_tipo_solicitud = '||v_id_tipo_solicitud||' and ';
                    END IF;

            END IF;
            
            
          

            IF v_historico = 'si' THEN
                    v_inner =  'inner join wf.testado_wf ew on ew.id_proceso_wf = solefe.id_proceso_wf ';

                    IF p_administrador !=1 THEN
                       v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' or solefe.id_usuario_reg = '||p_id_usuario||' ) and  (solefe.estado in (''rendido'')) and  solefe.id_tipo_solicitud = ' || v_id_tipo_solicitud|| ' and ';
                    ELSE
                         v_filtro = '(solefe.estado in (''rendido'')) and solefe.id_tipo_solicitud=' ||v_id_tipo_solicitud||' and ';
                    END IF;
             ELSE
                    v_inner =  'inner join wf.testado_wf ew on ew.id_estado_wf = solefe.id_estado_wf';

                    IF p_administrador !=1 THEN
                       v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' or solefe.id_usuario_reg = '||p_id_usuario||' ) and  (solefe.estado in (''revision'',''vbjefedevsol'')) and  solefe.id_tipo_solicitud = ' || v_id_tipo_solicitud|| ' and ';
                    ELSE
                         v_filtro = '(solefe.estado in (''revision'',''vbjefedevsol'')) and solefe.id_tipo_solicitud=' ||v_id_tipo_solicitud||' and ';
                    END IF;

            END IF;


            --Sentencia de la consulta de conteo de registros
            v_consulta:='select count(solefe.id_solicitud_efectivo)
                        from tes.tsolicitud_efectivo solefe
                        inner join segu.tusuario usu1 on usu1.id_usuario = solefe.id_usuario_reg
                        inner join tes.tcaja caja on caja.id_caja=solefe.id_caja
                        inner join orga.vfuncionario fun on fun.id_funcionario = solefe.id_funcionario
                        left join segu.tusuario usu2 on usu2.id_usuario = solefe.id_usuario_mod
                        left join tes.tsolicitud_efectivo solpri on solpri.id_solicitud_efectivo=solefe.id_solicitud_efectivo_fk
                        '||v_inner||'
                        where '||v_filtro;

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;

            --Devuelve la respuesta
            return v_consulta;

        end;
        
                    
    else
                         
        raise exception 'Transaccion inexistente';
                             
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