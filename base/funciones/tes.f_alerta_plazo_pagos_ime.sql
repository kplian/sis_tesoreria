--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_alerta_plazo_pagos_ime (
    p_administrador integer,
    p_id_usuario integer,
    p_tabla varchar,
    p_transaccion varchar
)
    RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:
 FUNCION:
 DESCRIPCION: Envia correos segun configuracion Estado
 AUTOR:
 FECHA:
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
     ISSUE            FECHA            AUTHOR                     DESCRIPCION
    #143            29/05/2020      EGS                     Creacion
***************************************************************************/

DECLARE

    v_parametros               record;
    v_resp                    varchar;
    v_nombre_funcion        text;

    v_acceso_directo        varchar;
    v_clase                 varchar;
    v_parametros_ad         varchar;
    v_tipo_noti             varchar;
    v_titulo                varchar;
    v_id_alarma             integer;
    v_descripcion_correo    varchar;
    v_record                record;
    v_fecha_now             date;
    v_consulta_dia          varchar;
    v_dia_semana            integer;
    v_dia_feriado           integer;
    v_dias_transcurridos    integer;
    v_dias_restantes        integer;
    v_array                 INTEGER[];
    v_tamano                integer;
    v_i                        integer;
    v_envio                 BOOLEAN;
    v_hora                  integer;
    v_minuto                integer;
    v_hora_actual           integer;
    v_minuto_actual         integer;
    v_tiempo_restante       time;
    v_consulta_hora         varchar;
    v_incremento_fecha      date;
    v_valor_incremento      varchar;
    v_domingo               INTEGER = 0;
    v_sabado                INTEGER = 6;
    v_cant_dias             numeric=0;
    v_dias_habiles          integer;
    v_fecha_aux             date;
    v_fecha_fin             date;
    v_pais_base             VARCHAR;
    v_id_lugar              integer;
    p_id_lugar              integer;
    v_dia                   integer;
    p_id_usuario            integer = 1;
    v_hrs_restantes          time;
    v_array_hrs             varchar[];
    v_existe                integer;
    v_dias_envio            varchar;
    v_dias_consecutivo      varchar;
    v_habilitado            VARCHAR;
    v_id_tipo_envio_correo   integer;
    v_copia                 record;
    v_fecha_limite          date;
    v_dias_vencimiento      integer;
    v_year                  varchar;
    v_month                 varchar;
    v_day                   varchar;
    v_consulta              varchar;

BEGIN

    v_nombre_funcion = 'tes.f_alerta_plazo_pagos_ime';
    v_parametros = pxp.f_get_record(p_tabla);


    /*********************************
    #TRANSACCION:  'WF_INISLA_IME'
    #DESCRIPCION:
    #AUTOR:        EGS
    #FECHA:
    #ISSUE:
    ***********************************/

    if(p_transaccion='TES_PLAPAG_IME')then

        begin
            --RAISE EXCEPTION 'v_parametros existe  %',v_parametros.habilitado;
            SELECT
                tc.id_tipo_envio_correo,
                tc.dias_envio,
                tc.dias_consecutivo,
                tc.habilitado,
                tc.dias_vencimiento
            into
                v_id_tipo_envio_correo,
                v_dias_envio,
                v_dias_consecutivo,
                v_habilitado,
                v_dias_vencimiento
            FROM param.ttipo_envio_correo tc
            WHERE tc.codigo = 'PPG';

            IF v_habilitado = 'si' THEN

                FOR  v_record IN(
                    SELECT
                        ob.id_proceso_wf as id_proceso_wf_ob,
                        ob.id_estado_wf as id_estado_wf_ob,
                        p.id_proceso_wf,
                        p.id_estado_wf,
                        p.id_plan_pago,
                        p.fecha_documento,
                        p.fecha_derivacion,
                        p.dias_limite,
                        ob.num_tramite as nro_tramite,
                        ob.id_proveedor,
                        pr.desc_proveedor,
                        p.nro_cuota
                    FROM tes.tplan_pago p
                             left join tes.tobligacion_pago ob on ob.id_obligacion_pago = p.id_obligacion_pago
                             left join param.vproveedor pr on pr.id_proveedor = ob.id_proveedor
                    WHERE p.estado not in ('anulado','contabilizado','devengado')
                      and (p.dias_limite is not null or p.dias_limite <> null)

                )LOOP
                        v_existe = 0;
                        v_envio = false;
                        v_cant_dias=0;
                        v_fecha_aux=v_record.fecha_documento::date;
                        v_fecha_fin=now()::date;
                        p_id_lugar = v_id_lugar;
                        v_valor_incremento := '1' || ' DAY';
                        --recuperamos la fecha limite
                        WHILE (SELECT v_cant_dias <= v_record.dias_limite ) loop

                                v_cant_dias=v_cant_dias+1;

                                v_incremento_fecha=(SELECT v_fecha_aux::date + CAST(v_valor_incremento AS INTERVAL));
                                v_fecha_aux = v_incremento_fecha;

                                IF   v_record.dias_limite =  v_cant_dias THEN
                                    v_fecha_limite = v_fecha_aux;
                                END IF;

                            end loop;

                        v_cant_dias=0;
                        v_fecha_aux=v_record.fecha_documento::date;
                        v_fecha_fin=now()::date;
                        --recuperamos la
                        WHILE (SELECT v_fecha_aux::date < v_fecha_fin::date ) loop

                                v_cant_dias=v_cant_dias+1;

                                v_incremento_fecha=(SELECT v_fecha_aux::date + CAST(v_valor_incremento AS INTERVAL));
                                v_fecha_aux = v_incremento_fecha;

                            end loop;
                        IF v_fecha_limite is null THEN
                            v_fecha_limite = NOW();
                        END IF;
                        v_consulta = 'SELECT
                                    date_part(''year'', '||COALESCE(''''||v_fecha_limite::varchar||'''','')||'::date) as year,
                                    to_char(date_part(''month'','||COALESCE(''''||v_fecha_limite::varchar||'''','')||'::date),''fm000'') as month,
                                    to_char(date_part(''day'', '||COALESCE(''''||v_fecha_limite::varchar||'''','')||'::date), ''fm000'') as day
                                    ';
                        execute(v_consulta) into v_year,v_month,v_day ;



                        v_dias_transcurridos=v_cant_dias;

                        v_dias_restantes = v_record.dias_limite::integer - v_dias_transcurridos;
                        --raise exception 'dia h % % % % %',v_record.fecha_documento,v_fecha_limite,v_record.dias_limite,v_dias_transcurridos ,v_dias_restantes  ;

                        --recuperamos que dias se enviaran las alertas
                        v_array = string_to_array(v_dias_envio,',');
                        v_tamano:=array_upper(v_array,1);

                        --cuando se envia los dias configurados
                        For i in 1..(v_tamano) loop

                                v_dia = v_array[i]::integer;
                                IF (v_dia = v_dias_restantes) THEN

                                    v_envio = true;
                                END IF;

                                v_descripcion_correo = '<b><font color="#008000" size="5"><font size="4">RECORDATORIO</font> </font></b><br><br><b></b>El Tramite : <b>'||v_record.nro_tramite||'</b> , cuota N° <b>'||v_record.nro_cuota||'</b> que tiene como Beneficiario a <b>'||v_record.desc_proveedor||'</b>. Tiene Fecha de vencimiento el '|| SUBSTRING(v_day,length(v_day)-2+1,2)||'/'||SUBSTRING(v_month,length(v_month)-2+1,2)||'/'||v_year||'.('||v_dias_restantes||' dias a partir de hoy).<br>Saludos<br>';

                            End loop;
                        --cuando se configura cada dia desde uno determinado para cumplir el tiempo limite

                        IF v_dias_consecutivo is not null THEN
                            IF v_dias_restantes <= v_dias_consecutivo::integer and v_dias_restantes >= 0 THEN

                                v_envio = true;

                                v_descripcion_correo = '<b><font color="#ADFF2F" size="5"><font size="4">RECORDATORIO</font> </font></b><br><br><b></b>El Tramite : <b>'||v_record.nro_tramite||'</b> , cuota N° <b>'||v_record.nro_cuota||'</b> que tiene como Beneficiario a <b>'||v_record.desc_proveedor||'</b>. Tiene Fecha de vencimiento el '||SUBSTRING(v_day,length(v_day)-2+1,2)||'/'||SUBSTRING(v_month,length(v_month)-2+1,2)||'/'||v_year||'.('||v_dias_restantes||' dias a partir de hoy).<br>Saludos<br>';

                            END IF;
                        END IF;
                        --cuando ya paso el tiempo limite
                        IF v_dias_vencimiento is not null THEN
                            IF v_dias_restantes < 0 and v_dias_vencimiento >= abs(v_dias_restantes) THEN

                                v_envio = true;

                                v_descripcion_correo = '<b><font color="#FF0000" size="5"><font size="4">RECORDATORIO</font> </font></b><br><br><b></b>El Tramite : <b>'||v_record.nro_tramite||'</b> , cuota N° <b>'||v_record.nro_cuota||'</b> que tiene como Beneficiario a <b>'||v_record.desc_proveedor||'</b>. Tiene Fecha de vencimiento el '||SUBSTRING(v_day,length(v_day)-2+1,2)||'/'||SUBSTRING(v_month,length(v_month)-2+1,2)||'/'||v_year||'.(Ya pasaron '|| abs(v_dias_restantes)||' dias del limite).<br>Saludos<br>';

                            END IF;
                        END IF;

                        IF v_envio = true THEN
                            --enviamos las copias del correo
                            FOR v_copia IN(
                                SELECT
                                    cor.id_funcionario,
                                    cor.correo,
                                    f.email_empresa
                                FROM param.tagrupacion_correo cor
                                         left join orga.vfuncionario fun on fun.id_funcionario = cor.id_funcionario
                                         left join orga.tfuncionario f on f.id_funcionario = cor.id_funcionario
                                Where cor.id_tipo_envio_correo = v_id_tipo_envio_correo::integer
                            )LOOP

                                    v_acceso_directo = '';
                                    v_clase = '';
                                    v_parametros_ad = '{filtro_directo:{campo:"help.id_proceso_wf",valor:"'||v_record.id_proceso_wf::varchar||'"}}';
                                    v_tipo_noti = 'notificacion';
                                    v_titulo = 'Servicio de Recordatorio: ';

                                    v_id_alarma = param.f_inserta_alarma(
                                            v_copia.id_funcionario,
                                            v_descripcion_correo,--par_descripcion
                                            v_acceso_directo,--acceso directo
                                            now()::date,--par_fecha: Indica la fecha de vencimiento de la alarma
                                            v_tipo_noti, --notificacion
                                            v_titulo,  --asunto
                                            p_id_usuario,
                                            v_clase, --clase
                                            v_titulo,--titulo
                                            v_parametros_ad,--par_parametros varchar,   parametros a mandar a la interface de acceso directo
                                            v_parametros.id_usuario, --usuario a quien va dirigida la alarma
                                            v_titulo,--titulo correo
                                            v_copia.email_empresa, --correo funcionario
                                            null,--#9
                                            v_record.id_proceso_wf,
                                            v_record.id_estado_wf
                                        );




                                END LOOP;

                        END IF;

                    END LOOP;




            ELSE
                v_resp = 'no esta habilitado la opcion de desactivado automatico';
            END IF;
            v_resp='exito';
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje',v_resp);

            --Devuelve la respuesta
            return v_resp;


        end;


    else

        raise exception 'Transaccion inexistente: %',p_transaccion;

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
    PARALLEL UNSAFE
    COST 100;