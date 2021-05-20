--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.ft_solicitud_efectivo_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:       Sistema de Obligaciones de Pago
 FUNCION:       tes.ft_solicitud_efectivo_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tsolicitud_efectivo'
 AUTOR:          (gsarmiento)
 FECHA:         24-11-2015 12:59:51
 COMENTARIOS:
***************************************************************************
     HISTORIAL DE MODIFICACIONES:

 ISSUE            FECHA:          AUTOR                 DESCRIPCION

 #0            10-02-2015        Gonzalo Sarmiento      Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tsolicitud_efectivo'
 #0            30/11/2017        Rensi Arteaga          BUG, Restituciones queda en borrador ....
 #146 SC       04/12/2017        RAC             		Validacion de vbcasjero para ingreso de caja, los pasa directoa finalizado
 #147 SC       10/10/2018        Manu Guerra     		puede generar solicitud efectivo, a pesar del cierre, se comentó
 #62           18/03/2020        MANUEL GUERRA           envio de param, para la paginacion, toolbar ayuda, botones de envio de correo y rechazo de sol por tiempo
***************************************************************************/

DECLARE

    v_nro_requerimiento     integer;
    v_parametros            record;
    v_id_requerimiento      integer;
    v_resp                  varchar;
    v_nombre_funcion        text;
    v_mensaje_error         text;
    v_id_solicitud_efectivo integer;
    v_codigo_tabla          varchar;
    v_num_sol_efe           varchar;
    v_id_gestion            integer;
    v_id_proceso_macro      integer;
    v_codigo_tipo_proceso   varchar;
    v_num_tramite           varchar;
    v_id_proceso_wf         integer;
    v_id_estado_wf          integer;
    v_codigo_estado         varchar;
    v_id_tipo_estado        integer;
    v_pedir_obs             varchar;
    v_codigo_estado_siguiente   varchar;
    v_obs                   varchar;
    v_acceso_directo        varchar;
    v_clase                 varchar;
    v_parametros_ad         varchar;
    v_tipo_noti             varchar;
    v_titulo                varchar;
    v_id_estado_actual      integer;
    v_motivo                varchar;
    v_id_funcionario        integer;
    v_id_usuario_reg        integer;
    v_id_depto              integer;
    v_id_estado_wf_ant      integer;
    v_caja                  record;
    v_registros_solicitud_efectivo  record;
    v_tipo                  varchar;
    v_id_tipo_solicitud     integer;
    v_id_solicitud_efectivo_fk  integer;
    v_solicitud_efectivo    record;
    v_monto_solicitado      numeric;
    v_monto_rendido         numeric;
    v_monto_devuelto        numeric;
    v_monto_repuesto        numeric;
    v_saldo                 numeric;
    v_doc_compra_venta      record;
    v_saldo_caja            numeric;
    v_importe_maximo_solicitud  numeric;
    v_temp                  interval;
    v_registros             record;
    v_id_plantilla          integer;
    v_codigo_relacion       varchar = '';
    v_id_doc_compra_venta   integer;
    v_rec                   record;
    v_fun                   record;
    v_id_tipo_doc_compra_venta integer;
    v_id_depto_conta        integer;
    v_registros1            record;
    v_id_solicitud_efectivo_rend integer;
    v_id_solicitud_rendicion_det integer;
    v_total_rendiciones     numeric;
    v_id_cuenta_doc         integer;
    v_rec1                  record;
    v_temp_rec          record;
    v_id_solicitud_efectivo_tmp  varchar[];
    v_sw_finalilzar_automatica   BOOLEAN;
    v_correo 				VARCHAR;
    v_nombre_vista          varchar;

BEGIN

    v_nombre_funcion = 'tes.ft_solicitud_efectivo_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
    #TRANSACCION:  'TES_SOLEFE_INS'
    #DESCRIPCION:   Insercion de registros
    #AUTOR:     gsarmiento
    #FECHA:     24-11-2015 12:59:51
    ***********************************/

    if(p_transaccion='TES_SOLEFE_INS')then

        begin
            IF EXISTS (select 1
                     from tes.tproceso_caja
                     where tipo='CIERRE' and id_caja=v_parametros.id_caja)  THEN
                     --#147
		             --raise exception 'No puede realizar solicitudes ni rendiciones, la caja se encuentra en proceso de cierre';
            END IF;

            v_resp=tes.f_inserta_solicitud_efectivo(p_administrador,p_id_usuario,hstore(v_parametros));

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************
    #TRANSACCION:  'TES_SOLEFE_MOD'
    #DESCRIPCION:   Modificacion de registros
    #AUTOR:     gsarmiento
    #FECHA:     24-11-2015 12:59:51
    ***********************************/

    elsif(p_transaccion='TES_SOLEFE_MOD')then

        begin

            IF(pxp.f_existe_parametro(p_tabla,'motivo'))THEN
                v_motivo = v_parametros.motivo;
            ELSE
                v_motivo = NULL;
            END IF;

            IF v_parametros.tipo_solicitud = 'solicitud' THEN
                v_saldo_caja = tes.f_calcular_saldo_caja(v_parametros.id_caja);

                IF v_saldo_caja < v_parametros.monto THEN
                    raise exception 'El monto que esta intentando solicitar excede el saldo de la caja';
                END IF;

                select importe_maximo_item into v_importe_maximo_solicitud
                from tes.tcaja
                where id_caja=v_parametros.id_caja;

                IF v_importe_maximo_solicitud < v_parametros.monto THEN
                    raise exception 'El monto que esta intentando solicitar excede el importe maximo de gasto';
                END IF;

            END IF;

            --Sentencia de la modificacion
            update tes.tsolicitud_efectivo set
            id_caja = v_parametros.id_caja,
            monto = v_parametros.monto,
            motivo = v_motivo,
            id_funcionario = v_parametros.id_funcionario,
            fecha = v_parametros.fecha,
            id_usuario_mod = p_id_usuario,
            fecha_mod = now(),
            id_usuario_ai = v_parametros._id_usuario_ai,
            usuario_ai = v_parametros._nombre_usuario_ai
            where id_solicitud_efectivo=v_parametros.id_solicitud_efectivo;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Solicitud Efectivo modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud_efectivo',v_parametros.id_solicitud_efectivo::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************
    #TRANSACCION:  'TES_SOLEFE_ELI'
    #DESCRIPCION:   Eliminacion de registros
    #AUTOR:     gsarmiento
    #FECHA:     24-11-2015 12:59:51
    ***********************************/

    elsif(p_transaccion='TES_SOLEFE_ELI')then

        begin
            select s.estado,
                   s.id_proceso_wf,
                   --pc.id_proceso_caja,
                   c.id_depto,
                   s.id_estado_wf
            into v_registros_solicitud_efectivo
            from tes.tsolicitud_efectivo s
            inner join tes.tcaja c on c.id_caja=s.id_caja
            where id_solicitud_efectivo=v_parametros.id_solicitud_efectivo;

            IF v_registros_solicitud_efectivo.estado ='revision' THEN
                IF EXISTS (select 1 from tes.tsolicitud_rendicion_det where id_solicitud_efectivo=v_parametros.id_solicitud_efectivo)THEN
                    raise exception 'No es posible eliminar la rendicion de efectivo, esta contiene facturas rendidas,
                    devuelva las facturas al solicitante';
                END IF;
            END IF;

            IF v_registros_solicitud_efectivo.estado not in ('borrador','revision') THEN
                raise exception 'No es posible eliminar la solicitud de efectivo, no se encuentra en estado borrador';
            END IF;

           --recuperamos el id_tipo_proceso en el WF para el estado anulado
           --este es un estado especial que no tiene padres definidos

           select
            te.id_tipo_estado
           into
            v_id_tipo_estado
           from wf.tproceso_wf pw
           inner join wf.ttipo_proceso tp on pw.id_tipo_proceso = tp.id_tipo_proceso
           inner join wf.ttipo_estado te on te.id_tipo_proceso = tp.id_tipo_proceso and te.codigo = 'anulado'
           where pw.id_proceso_wf = v_registros_solicitud_efectivo.id_proceso_wf;


           IF v_id_tipo_estado is NULL THEN

              raise exception 'El estado anulado para la solicitud de efectivo no esta parametrizado en el workflow';

           END IF;

           -- pasamos la obligacion al estado anulado

           v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado,
                                                       NULL,
                                                       v_registros_solicitud_efectivo.id_estado_wf,
                                                       v_registros_solicitud_efectivo.id_proceso_wf,
                                                       p_id_usuario,
                                                       v_parametros._id_usuario_ai,
                                                       v_parametros._nombre_usuario_ai,
                                                       v_registros_solicitud_efectivo.id_depto,
                                                       'Solicitud de Caja Anulada');


               -- actualiza estado en solicitud de efectivo
            update tes.tsolicitud_efectivo set
                 id_estado_wf =  v_id_estado_actual,
                 estado = 'anulado',
                 estado_reg = 'inactivo',
                 id_usuario_mod=p_id_usuario,
                 fecha_mod=now(),
                 id_usuario_ai = v_parametros._id_usuario_ai,
                 usuario_ai = v_parametros._nombre_usuario_ai
            where id_solicitud_efectivo  = v_parametros.id_solicitud_efectivo;

            --Sentencia de la eliminacion
            --inactivamos el detalle
            update tes.tsolicitud_efectivo_det
            set estado_reg = 'inactivo'
            where id_solicitud_efectivo=v_parametros.id_solicitud_efectivo;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Solicitud Efectivo anulado');
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud_efectivo',v_parametros.id_solicitud_efectivo::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************
    #TRANSACCION:  'TES_SIGESOLEFE_IME'
    #DESCRIPCION:   Transaccion utilizada  pasar a  estados siguientes en solicitud efectivo segun la operacion definida
    #AUTOR:     GSS
    #FECHA:     09-12-2015
    ***********************************/

    elsif(p_transaccion='TES_SIGESOLEFE_IME')then
        begin

         /*   PARAMETROS

        $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
        $this->setParametro('id_depto_wf','id_depto_wf','int4');
        $this->setParametro('obs','obs','text');
        */

        ------------------------------------------------
        --  EXISTEN DIFERENTES TIPOS DE SOLICITUD DE EFECTIVO:  solicitud, rendicion, reposicion, devolucion
        --  30/11/2017, es funcion tiene defecto que no controla el flujo por tipo
        --  funcina por suerte por los estados de los diferentes tipos son unicos
        --  hay que analziar la forma de solucionar esto con minimo impacto
        -----------------------------------------------

              --obtenermos datos basicos
              select
                  se.id_solicitud_efectivo,
                  se.id_solicitud_efectivo_fk,
                  se.id_proceso_wf,
                  se.estado,
                  se.fecha,
                  se.monto,
                  se.nro_tramite,
                  ca.id_moneda,
                  se.id_funcionario,
                  se.id_caja,
                  se.id_estado_wf,
                  ca.id_depto,
                  se.motivo
              into
                  v_rec
              from tes.tsolicitud_efectivo se
              inner join tes.tcaja ca on ca.id_caja = se.id_caja
              where se.id_proceso_wf  = v_parametros.id_proceso_wf_act;



              SELECT cj.tipo_ejecucion, cj.id_depto into v_caja
              from tes.tsolicitud_efectivo se
              inner join tes.tcaja cj on cj.id_caja=se.id_caja
              where se.id_solicitud_efectivo=v_rec.id_solicitud_efectivo;

              select
                ew.id_tipo_estado,
                te.pedir_obs,
                ew.id_estado_wf
               into
                v_id_tipo_estado,
                v_pedir_obs,
                v_id_estado_wf
              from wf.testado_wf ew
              inner join wf.ttipo_estado te on te.id_tipo_estado = ew.id_tipo_estado
              where ew.id_estado_wf =  v_parametros.id_estado_wf_act;

           -- obtener datos tipo estado

              select
                 te.codigo
              into
                 v_codigo_estado_siguiente
             from wf.ttipo_estado te
             where te.id_tipo_estado = v_parametros.id_tipo_estado;

             IF  pxp.f_existe_parametro(p_tabla,'obs') THEN
                  v_obs=v_parametros.obs;
             ELSE
                   v_obs='---';
             END IF;

             --configurar acceso directo para la alarma
             v_acceso_directo = '';
             v_clase = '';
             v_parametros_ad = '';
             v_tipo_noti = 'notificacion';
             v_titulo  = '';

             IF   v_codigo_estado_siguiente in('vbjefe', 'vbfin' ,'vbcajero')   THEN
                  v_acceso_directo = '../../../sis_tesoreria/vista/solicitud_efectivo/SolicitudEfectivoVb.php';
                  v_clase = 'SolicitudEfectivoVb';
                  v_parametros_ad = '{filtro_directo:{campo:"solefe.id_proceso_wf",valor:"'||v_rec.id_proceso_wf::varchar||'"}}';
                  v_tipo_noti = 'notificacion';
                  v_titulo  = 'Visto Bueno Solicitud Efectivo';
             END IF;


           --------------------------------------------
           --  Cunado  Cajero en la soclitud de efectivo entrega el dinero pasa estado
           --  ENTREGADO
           ---------------------------------------------


            IF v_codigo_estado_siguiente = 'entregado' THEN


                --  verifica saldo de caja
                select id_caja, monto
                into v_solicitud_efectivo
                from tes.tsolicitud_efectivo
                where id_solicitud_efectivo=v_rec.id_solicitud_efectivo;

                v_saldo_caja = tes.f_calcular_saldo_caja(v_solicitud_efectivo.id_caja::integer)::numeric;

                IF v_saldo_caja < v_solicitud_efectivo.monto THEN
                    raise exception 'El monto que esta intentando entregar excede el saldo de la caja, SALDO CAJA: %', v_saldo_caja;
                END IF;

                UPDATE tes.tsolicitud_efectivo
                SET fecha_entrega=current_date
                where id_solicitud_efectivo=v_rec.id_solicitud_efectivo;

                -----------------------------------------------------------------------------------------------------------
                -- RAC 28/11/2017
                -- Verifica si viene de viaticos para terminar el flujo
                -- y generar automaticamente el documento de rendicion
                -----------------------------------------------------------------------------------------------------------
                if exists(select 1 from cd.tcuenta_doc  where id_solicitud_efectivo = v_rec.id_solicitud_efectivo) then

                          --Obtencion del depto de conta
                          select dede.id_depto_destino
                          into v_id_depto_conta
                          from param.tdepto_depto dede
                          inner join param.tdepto ddes on ddes.id_depto = dede.id_depto_destino
                          inner join segu.tsubsistema sdes on sdes.id_subsistema = ddes.id_subsistema
                          where dede.id_depto_origen = v_rec.id_depto
                          and sdes.codigo = 'CONTA';

                          if v_id_depto_conta is null then
                              raise exception 'Depto. de Contabilidad no definido';
                          end if;

                          --Obtencion de datos del recibo de caja
                          select
                          funp.desc_funcionario1 as desc_funcionario, funp.ci, aux.id_auxiliar
                          into v_fun
                          from orga.tfuncionario fun
                          inner join orga.vfuncionario_persona funp
                          on funp.id_funcionario = fun.id_funcionario
                          left join conta.tauxiliar aux on aux.id_auxiliar = fun.id_auxiliar
                          where fun.id_funcionario = v_rec.id_funcionario;

                          if v_fun.id_auxiliar is null then
                              raise exception 'No existe registrado un auxiliar para %. Comuniquese con el depto. contable.',v_fun.desc_funcionario;
                          end if;


                           -------------------------------------------------------------

                          --Finaliza el registro de la solicitud de efectivo
                          select te.id_tipo_estado
                          into v_id_tipo_estado
                          from wf.tproceso_wf pw
                          inner join wf.ttipo_proceso tp on pw.id_tipo_proceso = tp.id_tipo_proceso
                          inner join wf.ttipo_estado te on te.id_tipo_proceso = tp.id_tipo_proceso and te.codigo = 'entregado'
                          where pw.id_proceso_wf = v_rec.id_proceso_wf;


                          if v_id_tipo_estado is null then
                              raise exception 'El estado finalizado para la solicitud de efectivo no esta parametrizado en el workflow';
                          end if;

                          v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado,
                                                                          NULL,
                                                                          v_rec.id_estado_wf,
                                                                          v_rec.id_proceso_wf,
                                                                          p_id_usuario,
                                                                          v_parametros._id_usuario_ai,
                                                                          v_parametros._nombre_usuario_ai,
                                                                          v_rec.id_depto,
                                                                          'Solicitud de Efectivo para Viatico finalizado');

                          -- actualiza estado en solicitud de efectivo
                          update tes.tsolicitud_efectivo set
                          id_estado_wf =  v_id_estado_actual,
                          estado = 'finalizado',
                          id_usuario_mod=p_id_usuario,
                          fecha_mod=now(),
                          id_usuario_ai = v_parametros._id_usuario_ai,
                          usuario_ai = v_parametros._nombre_usuario_ai
                          where id_solicitud_efectivo  = v_rec.id_solicitud_efectivo;

                          -------------------------------------



                          --Obtener el ID de la plantilla de documento para viaticos
                          select id_plantilla
                          into v_id_plantilla
                          from param.tplantilla
                          where desc_plantilla = 'Vale Provisorio'
                          and tipo_informe = 'efectivo';

                          --Obtiene el id_tipo_doc_compra_venta
                          select id_tipo_doc_compra_venta
                          into v_id_tipo_doc_compra_venta
                          from conta.ttipo_doc_compra_venta
                          where codigo = 'V';

                          if v_id_tipo_doc_compra_venta is null then
                              raise exception 'Tipo documento compra venta invalido';
                          end if;


                          --Obtencion de datos
                          select
                          v_rec.id_caja as id_caja,
                          v_rec.monto as monto,
                          v_rec.id_funcionario as id_funcionario,
                          'solicitud' as tipo_solicitud,
                          v_rec.fecha as fecha,
                          v_rec.motivo as motivo
                          into v_registros;

                          select v_rec.id_solicitud_efectivo as id_solicitud_efectivo_fk, 'rendicion' as tipo_solicitud
                          into v_registros1;


                          -------------------------------------------
                          --Creacion de la rendicion
                          -----------------------------------

                          --RAC, 06/04/2018, se modifica la fecha del documento , vale provisorio para que sea la fecha de regisotr conincidiendo con la fecha de entrega del dinero en cajas

                          v_resp = tes.f_inserta_solicitud_efectivo(0,p_id_usuario,hstore(v_registros)||hstore(v_registros1));
                          v_id_solicitud_efectivo_rend = pxp.f_obtiene_clave_valor(v_resp,'id_solicitud_efectivo','','','valor')::integer;

                          --Genera automaticamente el documento de respaldo de la rendicion de la solicitud de efectivo
                          select
                          'si' as revisado,-- = (p_hstore->'revisado')::varchar; --'si',--'revisado',
                          'no' as movil,-- = (p_hstore->'movil')::varchar; --'no',--'movil',
                          'compra' as tipo, -- (p_hstore->'tipo')::varchar; --'venta',--'tipo',
                          0 as importe_excento, -- (p_hstore->'importe_excento')::numeric; --coalesce(null as venta.excento::varchar,'0'),--'importe_excento',
                          now()::date as fecha, -- (p_hstore->'fecha')::date; --to_char(null as venta.fecha,'DD/MM/YYYY'),--'fecha',
                          v_rec.nro_tramite||'-DEV' as nro_documento, -- (p_hstore->'nro_documento')::varchar; --COALESCE(null as venta.nro_factura,'0')::varchar,--'nro_documento',
                          v_fun.ci as nit, -- (p_hstore->'nit')::varchar; --coalesce(null as venta.nit,''),--'nit',
                          0 as importe_ice, -- (p_hstore->'importe_ice')::numeric; --null as venta.total_venta_msuc::varchar,--'importe_ice',
                          '' as nro_autorizacion, -- (p_hstore->'nro_autorizacion')::varchar; --coalesce(null as venta.nroaut,''); --'nro_autorizacion',
                          0 as importe_iva, -- (p_hstore->'importe_iva')::numeric; --(null as venta.total_venta_msuc * null as iva)::varchar,--'importe_iva',
                          0 as importe_descuento, -- (p_hstore->'importe_descuento')::numeric; --'0',--'importe_descuento',
                          v_rec.monto as importe_doc, -- (p_hstore->'importe_doc')::numeric; --(null as venta.total_venta_msuc )::varchar,--'importe_doc',
                          'no' as sw_contabilizar, -- (p_hstore->'sw_contabilizar')::varchar; --'no',--'sw_contabilizar',
                          'tsolicitud_efectivo' as tabla_origen, -- (p_hstore->'tabla_origen')::varchar; --'vef.tventa',--'tabla_origen',
                          'validado' as estado, -- (p_hstore->'estado')::varchar; --'validado',--'estado',
                          v_id_depto_conta as id_depto_conta, -- (p_hstore->'id_depto_conta')::integer; --null as id_depto_conta::varchar,--'id_depto_conta',
                          v_rec.id_solicitud_efectivo as id_origen, -- (p_hstore->'id_origen')::integer; --null as venta.id_venta::varchar,--'id_origen',
                          'Entrega de viatico' as obs, -- (p_hstore->'obs')::varchar; --coalesce(null as venta.observaciones,''),--'obs',
                          'activo' as estado_reg, -- (p_hstore->'estado_reg')::varchar; --'activo',--'estado_reg',
                          '' as codigo_control, -- (p_hstore->'codigo_control')::varchar; --coalesce(null as venta.cod_control,''),--'codigo_control',
                          0 as importe_it, -- (p_hstore->'importe_it')::numeric; --(null as venta.total_venta_msuc * null as it)::varchar,--'importe_it',
                          v_fun.desc_funcionario as razon_social, -- (p_hstore->'razon_social')::varchar; --coalesce(null as venta.nombre_factura,''),--'razon_social',
                          0 as importe_descuento_ley, -- (p_hstore->'importe_descuento_ley')::numeric; --(null as venta.total_venta_msuc * null as descuento_porc)::varchar,--'importe_descuento_ley',
                          v_rec.monto as importe_pago_liquido, -- (p_hstore->'importe_pago_liquido')::numeric; --coalesce((null as venta.total_venta_msuc - (null as venta.total_venta_msuc * null as descuento_porc))::varchar,''),--'importe_pago_liquido',
                          '' as nro_dui, -- (p_hstore->'nro_dui')::varchar; --'0',--'nro_dui',
                          v_rec.id_moneda as id_moneda, -- (p_hstore->'id_moneda')::integer; --null as venta.id_moneda_sucursal::varchar,--'id_moneda',
                          0 as importe_pendiente, -- (p_hstore->'importe_pendiente')::numeric; --'0',--'importe_pendiente',
                          0 as importe_anticipo, -- (p_hstore->'importe_anticipo')::numeric; --'0',--'importe_anticipo',
                          0 as importe_retgar, -- (p_hstore->'importe_retgar')::numeric; --'0',--'importe_retgar',
                          v_rec.monto as importe_neto, -- (p_hstore->'importe_neto')::numeric; --(null as venta.total_venta_msuc - (null as venta.total_venta_msuc * null as descuento_porc))::varchar,--'importe_neto',--
                          v_fun.id_auxiliar as id_auxiliar, -- (p_hstore->'id_auxiliar')::integer; --'',--'id_auxiliar',
                          v_id_tipo_doc_compra_venta as id_tipo_compra_venta -- (p_hstore->'id_tipo_compra_venta')::integer; --v_id_tipo_compra_venta::varchar
                          into v_registros;

                          v_id_doc_compra_venta = conta.f_registrar_documento(p_administrador,p_id_usuario, v_id_plantilla, v_codigo_relacion, v_parametros._nombre_usuario_ai, v_parametros._id_usuario_ai::varchar,hstore(v_registros));

                          --Detalle de la rendicion
                          insert into tes.tsolicitud_rendicion_det(
                              id_solicitud_efectivo,
                              id_documento_respaldo,
                              estado_reg,
                              monto,
                              id_usuario_reg,
                              fecha_reg,
                              usuario_ai,
                              id_usuario_ai,
                              fecha_mod,
                              id_usuario_mod
                          ) values(
                              v_id_solicitud_efectivo_rend,
                              v_id_doc_compra_venta,
                              'activo',
                              v_rec.monto,
                              p_id_usuario,
                              now(),
                              v_parametros._nombre_usuario_ai,
                              v_parametros._id_usuario_ai,
                              null,
                              null
                          ) returning id_solicitud_rendicion_det into v_id_solicitud_rendicion_det;

                          update conta.tdoc_compra_venta set
                          tabla_origen = 'tes.tsolicitud_rendicion_det',
                          id_origen = v_id_solicitud_rendicion_det
                          where id_doc_compra_venta=v_id_doc_compra_venta;

                          select sum(rend.monto) into v_total_rendiciones
                          from tes.tsolicitud_rendicion_det rend
                          where rend.id_solicitud_efectivo = v_id_solicitud_efectivo_rend;

                          update tes.tsolicitud_efectivo set
                          monto = v_total_rendiciones
                          where id_solicitud_efectivo = v_id_solicitud_efectivo_rend;

                          -----------------------------------------------------------
                          --Cambia estado de la rendicion recien creada a finalizada
                          -----------------------------------------------------------
                          select
                          te.id_tipo_estado
                          into v_id_tipo_estado
                          from tes.tsolicitud_efectivo se
                          inner join wf.tproceso_wf pw on pw.id_proceso_wf = se.id_proceso_wf
                          inner join wf.ttipo_proceso tp on pw.id_tipo_proceso = tp.id_tipo_proceso
                          inner join wf.ttipo_estado te on te.id_tipo_proceso = tp.id_tipo_proceso and te.codigo = 'rendido'
                          where se.id_solicitud_efectivo = v_id_solicitud_efectivo_rend;

                          select se.id_estado_wf,se.id_proceso_wf, se.nro_tramite
                          into v_rec1
                          from tes.tsolicitud_efectivo se
                          where se.id_solicitud_efectivo = v_id_solicitud_efectivo_rend;


                          if v_id_tipo_estado is null then
                              raise exception 'El estado Rendido para la rendicion de solicitud de efectivo no esta parametrizado en el workflow';
                          end if;

                          v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado,
                                                                          NULL,
                                                                          v_rec1.id_estado_wf,
                                                                          v_rec1.id_proceso_wf,
                                                                          p_id_usuario,
                                                                          v_parametros._id_usuario_ai,
                                                                          v_parametros._nombre_usuario_ai,
                                                                          null,--id_depto
                                                                          'Rendicion de solicitud de efectivo para Viatico rendido');


                          -- actualiza estado en solicitud de efectivo
                          update tes.tsolicitud_efectivo set
                          id_estado_wf = v_id_estado_actual,
                          estado = 'rendido',
                          id_usuario_mod = p_id_usuario,
                          fecha_mod = now(),
                          id_usuario_ai = v_parametros._id_usuario_ai,
                          usuario_ai = v_parametros._nombre_usuario_ai
                          where id_solicitud_efectivo = v_id_solicitud_efectivo_rend;

                          --------------------------------------------------------------
                          --Cambia el estado de la cuenta documentada a 'contabilizado'
                          --------------------------------------------------------------
                          ---Verificar si es cuenta documentada del tipo solicitud cambiar el estado a contabilizado, por else nada
                          select cdo.id_cuenta_doc, cdo.id_funcionario, cdo.id_estado_wf, cdo.id_proceso_wf, tcdo.codigo as codigo_tipo_cuenta_doc, tcdo.sw_solicitud
                          into v_rec1
                          from cd.tcuenta_doc cdo
                          inner join cd.ttipo_cuenta_doc tcdo
                          on tcdo.id_tipo_cuenta_doc = cdo.id_tipo_cuenta_doc
                          where cdo.id_solicitud_efectivo = v_rec.id_solicitud_efectivo;

                          if v_rec1.sw_solicitud = 'si' then

                              select
                              te.id_tipo_estado
                              into v_id_tipo_estado
                              from cd.tcuenta_doc cd
                              inner join wf.tproceso_wf pw on pw.id_proceso_wf = cd.id_proceso_wf
                              inner join wf.ttipo_proceso tp on pw.id_tipo_proceso = tp.id_tipo_proceso
                              inner join wf.ttipo_estado te on te.id_tipo_proceso = tp.id_tipo_proceso and te.codigo = 'contabilizado'
                              where cd.id_cuenta_doc = v_rec1.id_cuenta_doc;


                              if v_id_tipo_estado is null then
                                  raise exception 'El estado finalizado para la Cuenta Documentada no esta parametrizado en el workflow';
                              end if;

                              v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado,
                                                                              v_rec1.id_funcionario,
                                                                              v_rec1.id_estado_wf,
                                                                              v_rec1.id_proceso_wf,
                                                                              p_id_usuario,
                                                                              v_parametros._id_usuario_ai,
                                                                              v_parametros._nombre_usuario_ai,
                                                                              null,--id_depto
                                                                              'Rendicion de solicitud de efectivo para Viatico finalizado');


                              -- actualiza estado en solicitud de efectivo
                              update cd.tcuenta_doc set
                              id_estado_wf = v_id_estado_actual,
                              estado = 'contabilizado',
                              id_usuario_mod = p_id_usuario,
                              fecha_mod = now(),
                              id_usuario_ai = v_parametros._id_usuario_ai,
                              usuario_ai = v_parametros._nombre_usuario_ai
                              where id_cuenta_doc = v_rec1.id_cuenta_doc;

                          end if;


                end if; --RCM, FIN SIE ES VIATICO O CUENTA DOCUMENTADA

            END IF;   -- FIN estado entregado de la colicitud de efectivo


            --registra id_funcionario_jefe

            IF v_codigo_estado_siguiente = 'vbjefe' THEN
                UPDATE tes.tsolicitud_efectivo
                SET id_funcionario_jefe_aprobador = v_parametros.id_funcionario_wf
                WHERE id_solicitud_efectivo=v_rec.id_solicitud_efectivo;
            ELSIF v_codigo_estado_siguiente = 'vbfin' THEN
                UPDATE tes.tsolicitud_efectivo
                SET id_funcionario_finanzas = v_parametros.id_funcionario_wf
                WHERE id_solicitud_efectivo=v_rec.id_solicitud_efectivo;
            END IF;

            ---------------------------------
            --  TODO, 1/12/2017 RAC,
            --  esto aprece un parcharzo
            --  no entiendo apra que sirve
            --  necesario debuguear
            ---------------------------------------

            --Si no se actualizo el estado antes, lo hace
            if v_id_estado_actual is null then
                -- hay que recuperar el supervidor que seria el estado inmediato,...
                v_id_estado_actual =  wf.f_registra_estado_wf(v_parametros.id_tipo_estado,
                                                             v_parametros.id_funcionario_wf,
                                                             v_parametros.id_estado_wf_act,
                                                             v_rec.id_proceso_wf,
                                                             p_id_usuario,
                                                             v_parametros._id_usuario_ai,
                                                             v_parametros._nombre_usuario_ai,
                                                             NULL,
                                                             ' Obs:'||v_obs,
                                                             --NULL,
                                                             v_acceso_directo,
                                                             --NULL,
                                                             v_clase,
                                                             --NULL,
                                                             v_parametros_ad,
                                                             --NULL,
                                                             v_tipo_noti,
                                                             --NULL);
                                                             v_titulo);

                update tes.tsolicitud_efectivo  s set
                id_estado_wf =  v_id_estado_actual,
                estado = v_codigo_estado_siguiente,
                id_usuario_mod=p_id_usuario,
                fecha_mod=now()
                where id_proceso_wf = v_parametros.id_proceso_wf_act;
            end if;

            ----------------------------------------------------------
            -- solo en caso de rendicion se compromete presupuesto
            -- TODO ,   no considera el tipo de solictud
            ----------------------------------------------------------


            IF v_codigo_estado_siguiente='rendido' THEN





                FOR v_doc_compra_venta IN (select doc.id_doc_compra_venta
                                         from tes.tsolicitud_rendicion_det rendet
                                         inner join conta.tdoc_compra_venta doc on doc.id_doc_compra_venta=rendet.id_documento_respaldo
                                         where rendet.id_solicitud_efectivo= v_rec.id_solicitud_efectivo)LOOP
                      --to do comprometer presupuesto
                      IF not tes.f_gestionar_presupuesto_doc_compra_venta(
                              v_doc_compra_venta.id_doc_compra_venta::integer,
                              NULL, -- id_proceso_caja
                              p_id_usuario,
                              'comprometer')  THEN

                          raise exception 'Error al comprometer el presupeusto';

                      END IF;
                END LOOP;



              IF pxp.f_existe_parametro(p_tabla,'devolucion_dinero') and pxp.f_existe_parametro(p_tabla,'saldo')THEN

                      IF v_parametros.devolucion_dinero = 'si' THEN

                            select
                                 id_caja,
                                 id_funcionario,
                                 current_date as fecha,
                              case
                                  when v_parametros.saldo > 0 then
                                     'devolucion'
                                 else
                                     'reposicion'
                                 end as tipo_solicitud,
                              case
                                 when v_parametros.saldo > 0 then
                                     v_parametros.saldo
                                 else
                                    v_parametros.saldo * (-1)
                                 end as monto,
                              case
                                  when v_parametros.saldo > 0 then
                                     'Devolucion de dinero del solicitante al cajero'
                                  else
                                     'Solicitud de reposicion de dinero al solicitante, gasto excedido'
                                  end as motivo,
                             id_solicitud_efectivo_fk as id_solicitud_efectivo_fk,
                             id_estado_wf
                          into
                            v_solicitud_efectivo
                          from tes.tsolicitud_efectivo
                          where id_solicitud_efectivo=v_rec.id_solicitud_efectivo;

                          -- crear devolucion o ampliacion
                          v_resp=tes.f_inserta_solicitud_efectivo(p_administrador,p_id_usuario,hstore(v_parametros)||hstore(v_solicitud_efectivo));
                          v_id_solicitud_efectivo_tmp = pxp.f_recupera_clave(v_resp, 'id_solicitud_efectivo');

                          select * into v_temp_rec from
                          tes.tsolicitud_efectivo s
                          where s.id_solicitud_efectivo = v_id_solicitud_efectivo_tmp[1]::integer;



                      END IF;


                      --RAC 30/11/2017, este codigo se encotnraba comentado, para la finalizacion automatica
                     --finalizar solicitud efectivo--------------------
                     -- si sobra se devuelve o se repone, nunca ambos
                     IF v_rec.id_solicitud_efectivo_fk is not null  THEN
                         IF tes.f_finalizar_solicitud_efectivo(p_id_usuario, v_rec.id_solicitud_efectivo_fk) = false THEN
                                  raise exception 'No se pudo finalizar la solicitud de efectivo automaticamente';
                         END IF;
                      ELSE
                         raise exception 'No se puede finalizar la solcitud, la referencia de la rendición esta nula';
                     END IF;



            ELSE



                --si no hay devoluciones, entonces no hay saldo se peude finalizar directamente
                --RAC 30/11/2017, este codigo se encotnraba comentado, para la finalizacion automatica

                 IF v_rec.id_solicitud_efectivo_fk is not null  THEN
                     IF tes.f_finalizar_solicitud_efectivo(p_id_usuario, v_rec.id_solicitud_efectivo_fk) = false THEN
                          raise exception 'No se pudo finalizar la solicitud de efectivo automaticamente';
                     END IF;
                 ELSE
                    raise exception 'No se peude finalizar la solcitud, la referencia de la rendición esta nula';
                 END IF;

            END IF;

          END IF;



          --raise exception 'PASA';


          IF v_codigo_estado_siguiente='finalizado' THEN


              select sum(sol.monto) into v_monto_rendido
              from tes.tsolicitud_efectivo sol
              where sol.id_solicitud_efectivo_fk = v_rec.id_solicitud_efectivo and sol.estado='rendido';

              select sum(sol.monto) into v_monto_devuelto
              from tes.tsolicitud_efectivo sol
              where sol.id_solicitud_efectivo_fk = v_rec.id_solicitud_efectivo and sol.estado='devuelto';

              select sum(sol.monto) into v_monto_repuesto
              from tes.tsolicitud_efectivo sol
              where sol.id_solicitud_efectivo_fk = v_rec.id_solicitud_efectivo and sol.estado='repuesto';

              select sum(sol.monto) into v_monto_solicitado
              from tes.tsolicitud_efectivo sol
              where sol.id_solicitud_efectivo = v_rec.id_solicitud_efectivo;

              --calcular saldo solicitud efectivo
              v_saldo = v_monto_solicitado - COALESCE(v_monto_rendido,0) - COALESCE(v_monto_devuelto,0) + COALESCE(v_monto_repuesto,0);

               --RAC 30/11/2017, cambia la regla del IF , saldo > 0 , antes estaba saldo != 0, esto generaba devolicioones negativas
               --RAC 30/11/2017 hay que considera lso casos que el saldo se negativo

              IF v_saldo > 0 THEN

                select id_caja, id_funcionario, current_date as fecha,
                       'devolucion' as tipo_solicitud,
                       v_saldo as monto,
                       id_solicitud_efectivo as id_solicitud_efectivo_fk,
                       nro_tramite,
                       'Devolucion de dinero del solicitante al cajero' as motivo
                into v_solicitud_efectivo
                from tes.tsolicitud_efectivo
                where id_solicitud_efectivo=v_rec.id_solicitud_efectivo;

                --crear devolucion

                v_resp=tes.f_inserta_solicitud_efectivo(p_administrador,p_id_usuario,hstore(v_parametros)||hstore(v_solicitud_efectivo)||hstore(v_caja));

              ELSEIF v_saldo < 0 THEN
                 raise exception 'Consulte con el administrador de sistemas, se tiene un saldo negativo de %, ID: %',v_saldo, v_rec.id_solicitud_efectivo;
              END IF;



          END IF;

          --raise exception 'llega';
            if(v_codigo_estado_siguiente in ('vbjefedevsol','vbjefe')) then
                IF(v_codigo_estado_siguiente = 'vbjefe')then
                    v_nombre_vista = 'vbSolicitudEfectivo';
                end if;
                IF(v_codigo_estado_siguiente = 'vbjefedevsol')then
                    v_nombre_vista = 'RendicionEfectivo';
                end if;
                 v_resp = param.f_insertar_notificacion(p_administrador, p_id_usuario, v_rec.id_solicitud_efectivo,
                                                       v_rec.id_proceso_wf,
                                                       v_rec.id_estado_wf, v_rec.id_funcionario,
                                                        v_parametros.id_funcionario_wf, 'tesoreria', 'tes',
                                                       'El tramite ' || v_rec.nro_tramite ||
                                                       ' esta pendiente de liberación',
                                                       'Solivitud de Efectivo - ' || v_rec.nro_tramite,
                                                       v_nombre_vista);
            end if;
          -- si hay mas de un estado disponible  preguntamos al usuario
          v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado de la solicitud de efectivo)');
          v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');


          -- Devuelve la respuesta
          return v_resp;

     end;

     /*********************************
    #TRANSACCION:  'TES_ANTESOLEFE_IME'
    #DESCRIPCION:   Transaccion utilizada  pasar a  estados anterior en solicitud efectivo segun la operacion definida
    #AUTOR:     GSS
    #FECHA:     15-12-2015
    ***********************************/

    elsif(p_transaccion='TES_ANTESOLEFE_IME')then
        BEGIN
            --------------------------------------------------
            --Retrocede al estado inmediatamente anterior
            -------------------------------------------------
            --recuperaq estado anterior segun Log del WF

          SELECT
             ps_id_tipo_estado,
             ps_id_funcionario,
             ps_id_usuario_reg,
             ps_id_depto,
             ps_codigo_estado,
             ps_id_estado_wf_ant
          INTO
             v_id_tipo_estado,
             v_id_funcionario,
             v_id_usuario_reg,
             v_id_depto,
             v_codigo_estado,
             v_id_estado_wf_ant
          FROM wf.f_obtener_estado_ant_log_wf(v_parametros.id_estado_wf);

          select
               ew.id_proceso_wf
            into
               v_id_proceso_wf
          from wf.testado_wf ew
          where ew.id_estado_wf= v_id_estado_wf_ant;

          --configurar acceso directo para la alarma
             v_acceso_directo = '';
             v_clase = '';
             v_parametros_ad = '';
             v_tipo_noti = 'notificacion';
             v_titulo  = '';

          IF   v_codigo_estado in('vbjefe', 'vbfin')   THEN
            v_acceso_directo = '../../../sis_tesoreria/vista/solicitud_efectivo/SolicitudEfectivoVb.php';
            v_clase = 'SolicitudEfectivoVb';
            v_parametros_ad = '{filtro_directo:{campo:"solefe.id_proceso_wf",valor:"'||v_id_proceso_wf::varchar||'"}}';
            v_tipo_noti = 'notificacion';
            v_titulo  = 'Visto Bueno Solicitud Efectivo';

          END IF;

          v_id_estado_actual = wf.f_registra_estado_wf(
              v_id_tipo_estado,
              v_id_funcionario,
              v_parametros.id_estado_wf,
              v_id_proceso_wf,
              p_id_usuario,
              v_parametros._id_usuario_ai,
              v_parametros._nombre_usuario_ai,
              v_id_depto,
              '[RETROCESO] ',
              v_acceso_directo,
              v_clase,
              v_parametros_ad,
              v_tipo_noti,
              v_titulo);

           IF  NOT tes.f_fun_regreso_solicitud_efectivo_wf(p_id_usuario,
                                                   v_parametros._id_usuario_ai,
                                                   v_parametros._nombre_usuario_ai,
                                                   v_id_estado_actual,
                                                   v_parametros.id_proceso_wf,
                                                   v_codigo_estado) THEN

               raise exception 'Error al retroceder estado';

            END IF;

         -- si hay mas de un estado disponible  preguntamos al usuario
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado)');
            v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');

          --Devuelve la respuesta
            return v_resp;

        END;


/*********************************
    #TRANSACCION:  'TES_AMPREN_IME'
    #DESCRIPCION:   Ampliar dias para rendir solicitud efectivo
    #AUTOR:     Gonzalo Sarmiento
    #FECHA:     10-04-2017
    ***********************************/


    elsif(p_transaccion='TES_AMPREN_IME')then

        begin
             --raise exception '%',v_parametros.dias_ampliado::varchar;
            v_temp = v_parametros.dias_ampliado::varchar||' days';

            --Sentencia de la modificacion
            update tes.tsolicitud_efectivo set

                fecha_entrega = (fecha_entrega::Date +  v_temp)::date,
                id_usuario_mod = p_id_usuario,
                fecha_mod = now()
            where id_solicitud_efectivo = v_parametros.id_solicitud_efectivo;


            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Dias de rendicion ampliados)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud_efectivo',v_parametros.id_solicitud_efectivo::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;


        /*********************************
        #TRANSACCION:  'TES_RECSOL_IME'
        #DESCRIPCION:   lleva un proceso a borrador
        #AUTOR:     manu
        #FECHA:     10-04-2017
        ***********************************/

    	elsif(p_transaccion='TES_RECSOL_IME')then

        begin
			SELECT wfw.id_estado_wf
            into v_id_estado_actual
            FROM wf.testado_wf wfw
            WHERE v_parametros.id_proceso_wf = wfw.id_proceso_wf and wfw.estado_reg='activo';

            UPDATE wf.testado_wf
            SET estado_reg='inactivo',fecha_mod=NOW(),id_usuario_mod = p_id_usuario
            WHERE id_estado_wf=v_id_estado_actual;

            SELECT te.codigo,te.id_tipo_estado
            INTO v_registros1
            FROM wf.ttipo_estado te
            JOIN wf.ttipo_proceso tp on tp.id_tipo_proceso=te.id_tipo_proceso
            WHERE tp.codigo='SOLEFE' and te.nombre_estado='Borrador';

            INSERT INTO wf.testado_wf(id_usuario_reg,id_proceso_wf,id_tipo_estado,id_estado_anterior)
            VALUES (p_id_usuario,v_parametros.id_proceso_wf,v_registros1.id_tipo_estado,v_id_estado_actual)
            RETURNING id_estado_wf
            INTO v_id_estado_wf;

            UPDATE tes.tsolicitud_efectivo
            SET id_usuario_mod = p_id_usuario,
                fecha_mod = now(),
                estado=v_registros1.codigo,
                id_estado_wf=v_id_estado_wf
            WHERE id_solicitud_efectivo = v_parametros.id_solicitud_efectivo and id_proceso_wf=v_parametros.id_proceso_wf;


            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud_efectivo',v_parametros.id_solicitud_efectivo::varchar);
            raise notice '%',v_resp;

            return v_resp;
        end;

        /*********************************
        #TRANSACCION:  'TES_ENVCOR_IME'
        #DESCRIPCION:   lleva un proceso a borrador
        #AUTOR:     manu  --62
        #FECHA:     10-04-2017
        ***********************************/

    	elsif(p_transaccion='TES_ENVCOR_IME')then

        begin

            select email_empresa
            into v_correo
            from orga.tfuncionario
            where id_funcionario = v_parametros.id_funcionario;

            insert into param.talarma(
                acceso_directo,
                id_funcionario,
                fecha,
                estado_reg,
                descripcion,
                id_usuario_reg,
                fecha_reg,
                id_usuario_mod,
                fecha_mod,
                tipo,
                obs,
                clase,
                titulo,
                parametros,
                id_usuario,
                titulo_correo,
                correos,
                documentos,
                id_proceso_wf,
                id_estado_wf,
                id_plantilla_correo,
                estado_envio, --posible
                sw_correo,
                pendiente
                ) values(
                '../../../sis_tesoreria/vista/solicitud_efectivo/SolicitudEfectivoVb.php', --acceso_directo
                v_parametros.id_funcionario::INTEGER,  --par_id_funcionario 562 manu
                now(), --par_fecha
                'activo',
                '<font color="000000" size="5"><font size="4"> </font> </font><br><br><b></b>El motivo de la presente es solicitar evalúes el curso  de : <b>'||v_parametros.nro_tramite||'</b><br> '||v_parametros.nro_tramite||'El cuestionario de evaluación se encuentra en el ENDESIS <br>en el siguiente enlace<br> <a href="http://172.18.79.204/etr/sis_seguridad/vista/_adm/index.php#main-tabs:CUE">Evaluar curso</a><br> Agradezco de antemano la colaboración.<br>  Saludos<br> ',--par_descripcion
                1, --par_id_usuario admin
                now(),
                null,
                null,
                'notificacion',--par_tipo
                ''::varchar, --par_obs
                'SolicitudEfectivoVb',--par_clase
                'SOLICITUD DE EFECTIVO PENDIENTE',--par_titulo
                '',--par_parametros
                v_parametros.id_usuario_reg::INTEGER,--par_id_usuario_alarma 381 manu
                'SOLICITUD DE EFECTIVO PENDIENTE',--par_titulo correo
                v_correo,--'manuel.guerra@endetransmision.bo',--v_correo,--'',--par_correos
                '',--par_documentos
                NULL,--p_id_proceso_wf
                NULL,--p_id_estado_wf
                NULL,--p_id_plantilla_correo
                'exito'::character varying, --v_estado_envio
                1,
                'no'
              );

            return v_resp;
        end;

	/*********************************
    #TRANSACCION:  'TES_DEVSOL_IME'
    #DESCRIPCION:   retroceso de solicitud hacia la interfaz dev-rep de cuenta documentada
    #AUTOR:    MANU
    #FECHA:    01-04-2020
    ***********************************/

    elsif(p_transaccion='TES_DEVSOL_IME')then

        BEGIN
        	IF v_parametros.id_solicitud_efectivo IS NOT NULL THEN
            	--SOLEFE SE VUELVE INACTIVO
            	UPDATE tes.tsolicitud_efectivo
              	SET estado_reg='inactivo'
              	WHERE id_solicitud_efectivo=v_parametros.id_solicitud_efectivo;

                --hijo cuenta documentada
                SELECT c.id_proceso_wf,c.id_estado_wf,c.id_cuenta_doc_fk
                INTO v_id_proceso_wf,v_id_estado_actual,v_id_cuenta_doc
                FROM cd.tcuenta_doc c
                WHERE c.id_solicitud_efectivo = v_parametros.id_solicitud_efectivo;
                --inactivo el ultimo estadowf de la cd
                UPDATE wf.testado_wf
                SET estado_reg='inactivo',fecha_mod=NOW(),id_usuario_mod = p_id_usuario
                WHERE id_estado_wf=v_id_estado_actual;
                --obtengo el codigo y estado de wf
                SELECT te.codigo,te.id_tipo_estado
                INTO v_registros1
                FROM wf.ttipo_estado te
                WHERE te.codigo='vbtesoreria' and te.nombre_estado='APROBACION MODALIDAD DE PAGO';
                --nuevo estado del hijo
                INSERT INTO wf.testado_wf(id_usuario_reg,id_proceso_wf,id_tipo_estado,id_estado_anterior)
                VALUES (p_id_usuario,v_id_proceso_wf,v_registros1.id_tipo_estado,v_id_estado_actual)
                RETURNING id_estado_wf
                INTO v_id_estado_wf;
                --hijo
             	UPDATE cd.tcuenta_doc
              	SET
                estado = v_registros1.codigo,
                id_estado_wf = v_id_estado_wf,
                sw_nodo=null,
                dev_tipo=NULL,
                dev_a_favor_de=NULL,
                dev_saldo=NULL,
                dev_saldo_original=NULL,
                dev_nombre_cheque=NULL,
                id_caja_dev = NULL,
                id_moneda_dev = null,
                id_usuario_mod = p_id_usuario,
                fecha_mod = now()
              	WHERE id_solicitud_efectivo = v_parametros.id_solicitud_efectivo;
                -- setear
                v_id_proceso_wf=NULL;
                v_id_cuenta_doc=NULL;
                v_registros1=NULL;
				--padre
                SELECT c.id_proceso_wf,c.id_cuenta_doc
                INTO v_id_proceso_wf,v_id_cuenta_doc
                FROM cd.tcuenta_doc c
                WHERE id_cuenta_doc=v_id_cuenta_doc;
                --
                --inactivo el ultimo estadowf de la cd
                UPDATE wf.testado_wf
                SET estado_reg='inactivo',fecha_mod=NOW(),id_usuario_mod = p_id_usuario
                WHERE id_estado_wf=v_id_estado_actual;
                --obtengo el codigo y estado de wf
                SELECT te.codigo,te.id_tipo_estado
                INTO v_registros1
                FROM wf.ttipo_estado te
                WHERE te.codigo='contabilizado' and te.nombre_estado='Contabilizado';
                --nuevo estado del hijo
                INSERT INTO wf.testado_wf(id_usuario_reg,id_proceso_wf,id_tipo_estado,id_estado_anterior)
                VALUES (p_id_usuario,v_id_proceso_wf,v_registros1.id_tipo_estado,v_id_estado_actual)
                RETURNING id_estado_wf
                INTO v_id_estado_wf;
                --actuliazcion del padre
                UPDATE cd.tcuenta_doc
                SET
                estado = v_registros1.codigo,
                id_estado_wf = v_id_estado_wf,
                id_usuario_mod = p_id_usuario,
                fecha_mod = now()
                WHERE id_cuenta_doc=v_id_cuenta_doc;

                --Definicion de la respuesta
                v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Devolucion aceptada)');
                v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud_efectivo',v_parametros.id_solicitud_efectivo::varchar);
            ELSE
            	RAISE EXCEPTION 'Error, no existe ese registro';
            END IF;

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