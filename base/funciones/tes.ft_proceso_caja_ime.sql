--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.ft_proceso_caja_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:   Sistema de Obligaciones de Pago
 FUNCION:     tes.ft_proceso_caja_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tproceso_caja'
 AUTOR:      (gsarmiento)
 FECHA:         21-12-2015 20:15:22
 COMENTARIOS: 
***************************************************************************
    HISTORIAL DE MODIFICACIONES:
   	
 ISSUE            FECHA:		      AUTOR                 DESCRIPCION
   
 #0        		 21-12-2015        Gonzalo Sarmiento       creacion 
 #888            15/08/2018        RAC                     sequita la edicion id_proceso_caja_rend por genera un bug al eliminar procesos de reposicion desvinculaba todos los ignresos previos
***************************************************************************/

DECLARE

  	v_nro_requerimiento     integer;
    v_parametros            record;
    v_id_requerimiento      integer;
    v_resp                varchar;
    v_resp2               varchar;
    v_nombre_funcion        text;
    v_mensaje_error         text;
    v_id_proceso_caja integer;
    v_codigo_tabla      varchar;
    v_num_rendicion     varchar;
    v_registros_trendicion  record;
    v_registros       record;
    v_id_estado_wf      integer;
    v_id_proceso_wf     integer;
  	v_codigo_estado     varchar;
    v_id_tipo_estado    integer;
    v_pedir_obs       varchar;
    v_codigo_estado_siguiente varchar;
    v_obs         varchar;
    v_acceso_directo    varchar;
    v_clase         varchar;
    v_parametros_ad     varchar;
    v_tipo_noti       varchar;
    v_titulo        varchar;
    v_id_estado_actual    integer;
    v_id_funcionario    integer;
    v_id_usuario_reg    integer;
    v_id_depto        integer;
    v_id_estado_wf_ant    integer;
    v_monto         numeric;
    v_codigo_plantilla_cbte   varchar;

    v_nombre_conexion     varchar;
    v_id_int_comprobante    integer;
    v_anho            integer;
    v_id_gestion        integer;
    v_codigo_documento      varchar;
    v_proceso_pendiente     varchar;
    v_sincronizar       varchar;
    v_num_tramite       varchar;
    v_cuenta_bancaria     record;
    v_depositante       text;
    v_id_finalidad      integer;
    v_respuesta       varchar;
    v_posicion_inicial    integer;
    v_posicion_final    integer;
    v_id_deposito     integer;
    v_id_fondo_rotativo   integer;
    v_fecha_inicio      date;
    v_fecha_fin       date;

    v_codigo_proceso    			varchar;
    v_importe_deposito    			numeric;
    v_sistema_origen    			varchar;
    v_importe       				numeric;
    v_tabla         				varchar;
    v_id_solicitud_efectivo    		integer[];
    v_hstore_registros   hstore;
    v_id_caja  						integer;
    
    va_id_tipo_estado 				integer[];
    va_codigo_estado 				varchar[];
    va_disparador    				varchar[];
    va_regla        				varchar[]; 
    va_prioridad     				integer[];   

BEGIN

    v_nombre_funcion = 'tes.ft_proceso_caja_ime';
    v_parametros = pxp.f_get_record(p_tabla);

  /*********************************
  # TRANSACCION:  'TES_REN_INS'
  # DESCRIPCION:  Insercion de registros
  # AUTOR:    gsarmiento
  # FECHA:    21-12-2015 20:15:22
  ***********************************/

  if(p_transaccion='TES_REN_INS')then

        begin
      
           v_resp = tes.f_inserta_proceso_reposicion_rendicion_caja(p_administrador,p_id_usuario,hstore(v_parametros));

            --Devuelve la respuesta
            return v_resp;

    end;

  /*********************************
  #TRANSACCION:  'TES_REN_MOD'
  #DESCRIPCION: Modificacion de registros
  #AUTOR:   gsarmiento
  #FECHA:   21-12-2015 20:15:22
  ***********************************/

  elsif(p_transaccion='TES_REN_MOD')then

    begin

            --Sentencia de la modificacion
      update tes.tproceso_caja set
              estado = v_parametros.estado,
              --id_comprobante_diario = v_parametros.id_comprobante_diario,
              --nro_tramite = v_parametros.nro_tramite,
              --tipo = v_parametros.tipo,
              motivo = v_parametros.motivo,
              fecha_fin = v_parametros.fecha_fin,
              --id_caja = v_parametros.id_caja,
              fecha = v_parametros.fecha,
              --id_proceso_wf = v_parametros.id_proceso_wf,
              monto = v_parametros.monto,
              --id_comprobante_pago = v_parametros.id_comprobante_pago,
              --id_estado_wf = v_parametros.id_estado_wf,
              fecha_inicio = v_parametros.fecha_inicio,
              fecha_mod = now(),
              id_usuario_mod = p_id_usuario,
              id_usuario_ai = v_parametros._id_usuario_ai,
              usuario_ai = v_parametros._nombre_usuario_ai
      where id_proceso_caja=v_parametros.id_proceso_caja;

      --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Rendicion Caja modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_caja',v_parametros.id_proceso_caja::varchar);

            --Devuelve la respuesta
            return v_resp;

    end;

  /*********************************
  #TRANSACCION:  'TES_REN_ELI'
  #DESCRIPCION: Eliminacion de registros
  #AUTOR:   gsarmiento
  #FECHA:   21-12-2015 20:15:22
  ***********************************/

  elsif(p_transaccion='TES_REN_ELI')then

    begin
            
        
            --solo peude eliminar procesos en estado borrador
            select 
             p.estado
            into
              v_registros
            from tes.tproceso_caja p
            where p.id_proceso_caja = v_parametros.id_proceso_caja;
        
            IF  v_registros.estado != 'borrador' THEN
                raise exception 'solo puede eliminar procesos en estado borrador';
            END IF;
        
        
      --Sentencia de la eliminacion
            UPDATE tes.tsolicitud_rendicion_det
            SET id_proceso_caja = NULL
            WHERE id_proceso_caja = v_parametros.id_proceso_caja;

            UPDATE tes.tproceso_caja
            SET id_proceso_caja_repo = NULL
            WHERE id_proceso_caja_repo = v_parametros.id_proceso_caja;
            
            --RAc, 05/12/2017,  apra desvincular solicitudes de ingreso extras
            UPDATE tes.tsolicitud_efectivo se SET 
               id_proceso_caja_repo = NULL 
            WHERE id_proceso_caja_repo = v_parametros.id_proceso_caja;
            
            /*#888   RAC 15/08/2018  sequita la edicion id_proceso_caja_rend por genera un bug al eliminar procesos de reposicion desvinculaba todos los ignresos previos
            UPDATE tes.tsolicitud_efectivo se SET 
               id_proceso_caja_repo = NULL,
               id_proceso_caja_rend = NULL    --13/03/2018 se considera eliminacion para quitar la relacion entre ingresos por rendiciones y el proceso de rendicion
            WHERE id_proceso_caja_repo = v_parametros.id_proceso_caja;
            */
            
            --RAc, 05/12/2017,  apra desvincular solicitudes de ingreso extras
            UPDATE tes.tsolicitud_efectivo se SET                
               id_proceso_caja_rend = NULL    
            WHERE id_proceso_caja_rend = v_parametros.id_proceso_caja;

            delete from tes.tproceso_caja
            where id_proceso_caja=v_parametros.id_proceso_caja;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Rendicion Caja eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_caja',v_parametros.id_proceso_caja::varchar);

            --Devuelve la respuesta
            return v_resp;

    end;

    /*********************************
  #TRANSACCION:  'TES_SIGEREN_IME'
  #DESCRIPCION: Transaccion utilizada  pasar a  estados siguientes en proceso caja segun la rendicion definida
  #AUTOR:   Gonzalo Sarmiento Sejas
  #FECHA:   23-12-2015
  ***********************************/

    elsif(p_transaccion='TES_SIGEREN_IME')then
        begin

         /*   PARAMETROS

        $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
        $this->setParametro('id_depto_wf','id_depto_wf','int4');
        $this->setParametro('obs','obs','text');
        $this->setParametro('json_procesos','json_procesos','text');
        */

        --obtenermos datos basicos
        select
            pc.id_proceso_caja,
            pc.id_proceso_wf,
            pc.estado,
            tpc.codigo_plantilla_cbte,
            tpc.codigo,
            pc.id_proceso_caja,
            pc.monto,
            pc.id_caja
        into
            v_id_proceso_caja,
            v_id_proceso_wf,
            v_codigo_estado,
            v_codigo_plantilla_cbte,
            v_codigo_proceso,
            v_id_proceso_caja,
            v_monto,
            v_id_caja
        from tes.tproceso_caja pc
        inner join tes.ttipo_proceso_caja tpc on tpc.id_tipo_proceso_caja = pc.id_tipo_proceso_caja
        where pc.id_proceso_wf = v_parametros.id_proceso_wf_act;

        IF(v_codigo_estado = 'vbconta' AND v_codigo_proceso='CIERRE') THEN

          select sum(dpc.importe_contable_deposito) into v_importe_deposito
            from tes.tts_libro_bancos lb
            inner join tes.tdeposito_proceso_caja dpc on dpc.id_libro_bancos=lb.id_libro_bancos
            where lb.tabla='tes.tproceso_caja'
            and lb.columna_pk='id_proceso_caja'
            and lb.columna_pk_valor=v_id_proceso_caja;

            IF COALESCE(v_importe_deposito,0.00) <> v_monto THEN
              raise exception 'La suma de los depositos no iguala al monto de cierre de caja';
            END IF;

        END IF;

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


             IF  pxp.f_existe_parametro(p_tabla,'id_depto_wf') THEN

               v_id_depto = v_parametros.id_depto_wf;

             END IF;

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

             /*
             IF   v_codigo_estado_siguiente in('vbpagosindocumento')   THEN
                  v_acceso_directo = '../../../sis_workflow/vista/proceso_wf/VoBoProceso.php';
                  v_clase = 'VoBoProceso';
                  v_parametros_ad = '{filtro_directo:{campo:"lb.id_proceso_wf",valor:"'||v_id_proceso_wf::varchar||'"}}';
                  v_tipo_noti = 'notificacion';
                  v_titulo  = 'Visto Bueno';

             END IF;
             */

             -- hay que recuperar el supervidor que seria el estado inmediato,...
             v_id_estado_actual =  wf.f_registra_estado_wf(v_parametros.id_tipo_estado,
                                                             v_parametros.id_funcionario_wf,
                                                             v_parametros.id_estado_wf_act,
                                                             v_id_proceso_wf,
                                                             p_id_usuario,
                                                             v_parametros._id_usuario_ai,
                                                             v_parametros._nombre_usuario_ai,
                                                             v_id_depto,
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

          update tes.tproceso_caja  p set
             id_estado_wf =  v_id_estado_actual,
             estado = v_codigo_estado_siguiente,
             id_usuario_mod=p_id_usuario,
             fecha_mod=now()
          where id_proceso_wf = v_parametros.id_proceso_wf_act;

           IF v_codigo_estado_siguiente in ('supconta','vbfondos', 'vbconta') THEN

                update tes.tproceso_caja  p set
                 id_depto_conta = v_id_depto
                where id_proceso_wf = v_parametros.id_proceso_wf_act;

          END IF;

      IF v_codigo_estado_siguiente = 'pendiente' THEN

                update tes.tproceso_caja  p set
                 id_cuenta_bancaria=v_parametros.id_cuenta_bancaria,
                 id_cuenta_bancaria_mov = v_parametros.id_cuenta_bancaria_mov
                where id_proceso_wf = v_parametros.id_proceso_wf_act;


                --TODO
                 v_sincronizar = pxp.f_get_variable_global('sincronizar');
                 --  generacion de comprobante
                IF (v_sincronizar = 'true') THEN
                  select * into v_nombre_conexion from migra.f_crear_conexion();
                END IF;

               -- RAC, 14/01/2018   condicion temporal para apretura de cajas 
         
                ----------------------------------------------------------------------------------------------------
                --   OJO PELIGRO SOLO PERMITIR ENTRAN EN ESTE IF, EN EL PRIMER COMPROBANTE DE REPOSICION, DEL AÑO
                ----  EN CASO CONTRARIO LSO DATOS NO SERAN COHERENTES
                ---------------------------------------------------------------------------------------------------
                IF 0=1  THEN         
         
                    
                     --inmediatamente apsa al estado finalizado
                     
                            SELECT
                               *
                            into
                              va_id_tipo_estado,
                              va_codigo_estado,
                              va_disparador,
                              va_regla,
                              va_prioridad

                          FROM wf.f_obtener_estado_wf(v_id_proceso_wf, v_id_estado_actual,NULL,'siguiente');
                          
                          IF va_codigo_estado[2] is not null THEN
                             raise exception 'El proceso de WF esta mal parametrizado,  solo admite un estado siguiente para el estado: %', v_registros.estado;
                          END IF;

                          IF va_codigo_estado[1] is  null THEN
                             raise exception 'El proceso de WF esta mal parametrizado, no se encuentra el estado siguiente,  para el estado: %', v_registros.estado;
                          END IF;

                          -- estado siguiente
                          v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado[1],
                                                                         v_parametros.id_funcionario_wf,
                                                                         v_id_estado_actual,
                                                                         v_id_proceso_wf,
                                                                         p_id_usuario,
                                                                         NULL, -- id_usuario_ai
                                                                         '', -- usuario_ai
                                                                         v_id_depto,
                                                                         'saldo inicial');
                       -- actualiza estado del proceso
                        
                        update tes.tproceso_caja pc  set
                                    id_estado_wf =  v_id_estado_actual,
                                    estado = va_codigo_estado[1],
                                    id_usuario_mod=p_id_usuario,
                                    fecha_mod=now()
                        where pc.id_proceso_caja  =v_id_proceso_caja; 
                        
                        
                        --  registro de repoisicion para arqueos
                       v_hstore_registros =   hstore(ARRAY[
                                                      'id_caja', v_id_caja::varchar,
                                                      'monto',  v_monto::varchar,
                                                      'id_funcionario', v_parametros.id_funcionario_wf::varchar,
                                                      'tipo_solicitud', 'apertura_caja'::varchar,
                                                      'fecha','01/01/2018'::varchar,
                                                      'motivo', 'Saldo inicial'::varchar
                                                    ]);
                                                    
                          --   raise exception 'monto %',v_monto;                     

                     v_resp=tes.f_inserta_solicitud_efectivo(0,p_id_usuario,v_hstore_registros);
                    

                     
                     
                    
                     v_id_solicitud_efectivo =  pxp.f_recupera_clave(v_resp, 'id_solicitud_efectivo');
                     
                     
                    
                     --guardamos la relacion
                     update tes.tproceso_caja  set
                       id_solicitud_efectivo_rel = v_id_solicitud_efectivo[1]::integer
                    where id_proceso_caja = v_id_proceso_caja;
                        
                        
                       update tes.tcaja ca set
                          estado = 'abierto',
                          fecha_apertura = '01/01/2018'::date
                       where ca.id_caja = v_id_caja;
                       
                       
            
                
                    
                ELSE
           
            
                --  Si NO  se contabiliza nacionalmente
                v_id_int_comprobante =   conta.f_gen_comprobante (
                                                     v_id_proceso_caja ,
                                                     v_codigo_plantilla_cbte ,
                                                     v_id_estado_actual,
                                                     p_id_usuario,
                                                     v_parametros._id_usuario_ai,
                                                     v_parametros._nombre_usuario_ai,
                                                     v_nombre_conexion);
                 
                END IF;

 
                update tes.tproceso_caja  p set
                    id_int_comprobante = v_id_int_comprobante
                where id_proceso_wf = v_parametros.id_proceso_wf_act;

                IF (v_sincronizar = 'true') THEN
                  select * into v_resp from migra.f_cerrar_conexion(v_nombre_conexion,'exito');
                 END IF;

          END IF;
          -- si hay mas de un estado disponible  preguntamos al usuario
          v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado del proceso caja)');
          v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');
         

          -- Devuelve la respuesta
          return v_resp;

     end;

    /*********************************
  #TRANSACCION:  'TES_ANTEREN_IME'
  #DESCRIPCION: Transaccion utilizada  pasar a  estados anterior en proceso caja segun la operacion definida
  #AUTOR:   GSS
  #FECHA:   28-12-2015
  ***********************************/

  elsif(p_transaccion='TES_ANTEREN_IME')then
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

          -- configurar acceso directo para la alarma
             v_acceso_directo = '';
             v_clase = '';
             v_parametros_ad = '';
             v_tipo_noti = '';
             v_titulo  = '';

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

           IF  NOT tes.f_fun_regreso_proceso_caja_wf(p_id_usuario,
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

           -- Devuelve la respuesta
            return v_resp;

        END;

    /*********************************
  # TRANSACCION:  'TES_DEP_INS'
  # DESCRIPCION:  Insercion de registro de depositos de caja
  # AUTOR:    gsarmiento
  # FECHA:    17-05-2016 20:15:22
  ***********************************/

  elsif(p_transaccion='TES_DEP_INS')then
      BEGIN
             -- RAC 29/12/2017 Se quito bastante codigo que realizaba depositos, la funcionalidad de deposito no la entiendo, me parece inutil
             -- TODO  simpificar y crear un funcion directa para isnertar depositos a libro de bancos que vincule con nro de tramite
             --  es necesario quitar este tramite de aca prceso de caja es de caja, no tiene relacion con libro de bnacos, no deberia esta por aca

              IF v_parametros.id_cuenta_bancaria is NULL THEN
                raise exception 'No existe una cuenta bancaria a la cual se depositara';
              END IF;
              
              --recupera datos de la cuenta bancaria
              select 
                  dcb.id_depto,
                  int.nombre, 
                  cb.nro_cuenta 
              into 
                  v_cuenta_bancaria
              from tes.tdepto_cuenta_bancaria dcb
              inner join tes.tcuenta_bancaria cb on cb.id_cuenta_bancaria=dcb.id_cuenta_bancaria
              inner join param.tinstitucion int on int.id_institucion=cb.id_institucion
              where dcb.id_cuenta_bancaria=v_parametros.id_cuenta_bancaria::integer;

              IF v_cuenta_bancaria.id_depto IS NULL THEN
                raise exception 'No existe un departamento de libro de bancos relacionado a la cuenta bancaria %',v_cuenta_bancaria.nombre;
              END IF;

              --el nombre del depositante lo saca del usuario ... TODO cambiar el duñose del viatico o cuenta docuemntada
              SELECT 
                  p.nombre_completo1 
                into 
                  v_depositante
              FROM segu.tusuario u
              INNER JOIN segu.vpersona p on p.id_persona=u.id_persona
              WHERE u.id_usuario=p_id_usuario;
              
              --recupera la finalizadad del deposito

              IF v_parametros.tipo_deposito = 'FONDO ROTATIVO' THEN
                  SELECT id_finalidad into v_id_finalidad
                  FROM tes.tfinalidad
                  WHERE nombre_finalidad ilike 'Fondo Rotativo'::varchar;
               ELSIF v_parametros.tipo_deposito = 'RETENCION' THEN
             
                  SELECT id_finalidad into v_id_finalidad
                  FROM tes.tfinalidad
                  WHERE nombre_finalidad ilike 'Proveedores'::varchar;
               ELSE
                  raise exception 'Tipo de Deposito inexistente';
              END IF;
      
              select 
                  fecha_ini, 
                  fecha_fin 
              into 
                  v_fecha_inicio, 
                  v_fecha_fin
              from param.tperiodo p
              where v_parametros.fecha BETWEEN fecha_ini and fecha_fin;

              select id_libro_bancos into v_id_fondo_rotativo
              from tes.tts_libro_bancos
              where id_cuenta_bancaria=v_parametros.id_cuenta_bancaria::integer
              and fondo_devolucion_retencion='si' and (fecha between v_fecha_inicio and v_fecha_fin);


              v_resp2 = pxp.f_intermediario_ime(p_id_usuario::int4,NULL,NULL::varchar,'v58gc566o75102428i2usu08i4',13313,'172.17.45.202','99:99:99:99:99:99','tes.ft_ts_libro_bancos_ime','TES_LBAN_INS',NULL,'no',NULL,
                        array['filtro','ordenacion','dir_ordenacion','puntero','cantidad','_id_usuario_ai','_nombre_usuario_ai','id_cuenta_bancaria','id_depto','fecha','a_favor','nro_cheque','importe_deposito','nro_liquidacion','detalle','origen','observaciones','importe_cheque','id_libro_bancos_fk','nro_comprobante','comprobante_sigma','tipo','id_finalidad','id_int_comprobante','sistema_origen','nro_deposito'],
                        array[' 0 = 0 ','','','','','NULL','NULL',v_parametros.id_cuenta_bancaria::varchar,v_cuenta_bancaria.id_depto::varchar,''||v_parametros.fecha::varchar||'',(v_cuenta_bancaria.nombre||' '||v_cuenta_bancaria.nro_cuenta||' DEPOSITO')::varchar,''::varchar,v_parametros.importe_deposito::varchar,'','DEPOSITADO POR '||v_depositante::varchar,v_parametros.origen::varchar,v_parametros.observaciones::varchar,'0'::varchar,'NULL','','','deposito'::varchar,v_id_finalidad::varchar,''::varchar,'CAJA_CHICA'::varchar,v_parametros.nro_deposito::varchar],
                        array['varchar','varchar','varchar','integer','integer','int4','varchar','int4','int4','date','varchar','int4','numeric','varchar','text','varchar','text','numeric','int4','varchar','varchar','varchar','int4','int4','varchar','varchar']
                        ,'',NULL,NULL);

                v_respuesta = substring(v_resp2 from '%#"tipo_respuesta":"_____"#"%' for '#');    

                IF v_respuesta = 'tipo_respuesta":"ERROR"' THEN
                    v_posicion_inicial = position('"mensaje":"' in v_resp2) + 11;
                    v_posicion_final = position('"codigo_error":' in v_resp2) - 2;
                    RAISE EXCEPTION 'No se pudo ingresar el deposito en libro de bancos K-ERP: mensaje: %',substring(v_resp2 from v_posicion_inicial for (v_posicion_final-v_posicion_inicial));
                ELSE
                    v_posicion_inicial = position('"id_libro_bancos":"' in v_resp2) + 19;
                    v_posicion_final = position('"}' in v_resp2);
                    v_id_deposito=substring(v_resp2 from v_posicion_inicial for (v_posicion_final-v_posicion_inicial));
        
        

                END IF;--fin error respuesta

                UPDATE tes.tts_libro_bancos
                SET fondo_devolucion_retencion = 'si'
                WHERE id_libro_bancos=v_id_deposito;

             

              v_respuesta = substring(v_resp2 from '%#"tipo_respuesta":"_____"#"%' for '#');

              IF v_respuesta = 'tipo_respuesta":"ERROR"' THEN
                  v_posicion_inicial = position('"mensaje":"' in v_resp2) + 11;
                  v_posicion_final = position('"codigo_error":' in v_resp2) - 2;
                  RAISE EXCEPTION 'No se pudo ingresar el deposito en libro de bancos ERP-BOA: mensaje: %',substring(v_resp2 from v_posicion_inicial for (v_posicion_final-v_posicion_inicial));
              ELSE
                  v_posicion_inicial = position('"id_libro_bancos":"' in v_resp2) + 19;
                  v_posicion_final = position('"}' in v_resp2);
                  v_id_deposito=substring(v_resp2 from v_posicion_inicial for (v_posicion_final-v_posicion_inicial));

              END IF;--fin error respuesta

              UPDATE tes.tts_libro_bancos
              SET tabla=v_parametros.tabla,
              columna_pk=v_parametros.columna_pk,
              columna_pk_valor=v_parametros.columna_pk_valor
              WHERE id_libro_bancos=v_id_deposito;

              --Definicion de la respuesta
              v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Deposito de Caja almacenado(a) con exito');
              v_resp = pxp.f_agrega_clave(v_resp,'columna_pk_valor',v_parametros.columna_pk_valor::varchar);
              v_resp = pxp.f_agrega_clave(v_resp,'id_libro_bancos',v_id_deposito::varchar);




              --Devuelve la respuesta
              return v_resp;

        END;

    /*********************************
  # TRANSACCION:  'TES_DEP_ELI'
  # DESCRIPCION:  Eliminacion de registro de depositos de caja
  # AUTOR:    gsarmiento
  # FECHA:    20-05-2016 20:15:22
  ***********************************/

  elsif(p_transaccion='TES_DEP_ELI')then
      begin

            IF NOT EXISTS (SELECT 1
                     FROM tes.tts_libro_bancos
                     WHERE id_libro_bancos=v_parametros.id_libro_bancos)THEN
              raise exception 'No existe el registro que desea eliminar';
            END IF;

            SELECT sistema_origen into v_sistema_origen
            FROM tes.tts_libro_bancos
            WHERE id_libro_bancos=v_parametros.id_libro_bancos;

            IF v_sistema_origen != 'CAJA_CHICA' or v_sistema_origen IS NULL THEN
              raise exception 'No es posible eliminar un deposito que no se registro por Caja Chica';
            END IF;

            delete from tes.tts_libro_bancos
            where id_libro_bancos=v_parametros.id_libro_bancos;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Deposito eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_libro_bancos',v_parametros.id_libro_bancos::varchar);

            --Devuelve la respuesta
            return v_resp;

    end;

    elsif(p_transaccion='TES_RELDEP_INS')then
      begin

            IF NOT EXISTS (SELECT 1
                     FROM tes.tts_libro_bancos
                     WHERE id_libro_bancos=v_parametros.id_libro_bancos)THEN
              raise exception 'No existe el registro que desea relacionar';
            END IF;

            select importe_deposito into v_importe
            from tes.tts_libro_bancos
            where id_libro_bancos=v_parametros.id_libro_bancos;

            UPDATE tes.tts_libro_bancos
            SET tabla = v_parametros.tabla,
            columna_pk = v_parametros.columna_pk,
            columna_pk_valor = v_parametros.columna_pk_valor
            WHERE id_libro_bancos = v_parametros.id_libro_bancos;

            IF v_parametros.tabla = 'tes.tproceso_caja' THEN
              INSERT INTO tes.tdeposito_proceso_caja
                (id_proceso_caja, id_libro_bancos, importe_contable_deposito)
                VALUES
                (v_parametros.columna_pk_valor,v_parametros.id_libro_bancos,v_importe);
            ELSE
                INSERT INTO cd.tdeposito_cd
                (id_cuenta_doc, id_libro_bancos, importe_contable_deposito)
                VALUES
                (v_parametros.columna_pk_valor,v_parametros.id_libro_bancos,v_importe);
            END IF;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Deposito relacionado');
            v_resp = pxp.f_agrega_clave(v_resp,'id_libro_bancos',v_parametros.id_libro_bancos::varchar);

            --Devuelve la respuesta
            return v_resp;

    end;

    /*********************************
  # TRANSACCION:  'TES_ELIRELDEP_INS'
  # DESCRIPCION:  Quitar relacion de depositos de fondo
  # AUTOR:    gsarmiento
  # FECHA:    12-10-2016 20:15:22
  ***********************************/
    elsif(p_transaccion='TES_ELIRELDEP_INS')then
      begin

            IF NOT EXISTS (SELECT 1
                     FROM tes.tts_libro_bancos
                     WHERE id_libro_bancos=v_parametros.id_libro_bancos)THEN
              raise exception 'No existe el registro que desea quitar la relacion en libro_bancos';
            END IF;

            SELECT tabla into v_tabla
            FROM tes.tts_libro_bancos
            WHERE id_libro_bancos=v_parametros.id_libro_bancos;

            IF v_tabla = 'cd.tcuenta_doc' THEN
                IF NOT EXISTS (SELECT 1
                               FROM cd.tdeposito_cd
                               WHERE id_libro_bancos=v_parametros.id_libro_bancos)THEN
                    raise exception 'No existe el registro que desea quitar la relacion en deposito_cd';
                END IF;
            ELSE
              IF NOT EXISTS (SELECT 1
                               FROM tes.tdeposito_proceso_caja
                               WHERE id_libro_bancos=v_parametros.id_libro_bancos)THEN
                    raise exception 'No existe el registro que desea quitar la relacion en deposito_pc';
                END IF;
            END IF;

            UPDATE tes.tts_libro_bancos
            SET tabla = NULL,
            columna_pk = NULL,
            columna_pk_valor = NULL
            WHERE id_libro_bancos = v_parametros.id_libro_bancos;

            IF v_tabla = 'cd.tcuenta_doc' THEN
                DELETE FROM cd.tdeposito_cd
                WHERE id_libro_bancos = v_parametros.id_libro_bancos;
            ELSE
              DELETE FROM tes.tdeposito_proceso_caja
                WHERE id_libro_bancos = v_parametros.id_libro_bancos;
            END IF;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se quito la relacion del Deposito');
            v_resp = pxp.f_agrega_clave(v_resp,'id_libro_bancos',v_parametros.id_libro_bancos::varchar);

            --Devuelve la respuesta
            return v_resp;

    end;

    elsif(p_transaccion='TES_IMPDEP_IME')then
      begin

            IF NOT EXISTS (SELECT 1
                     FROM cd.tdeposito_cd
                     WHERE id_libro_bancos=v_parametros.id_libro_bancos
                           AND id_cuenta_doc=v_parametros.id_cuenta_doc)THEN

              INSERT INTO cd.tdeposito_cd
                (id_cuenta_doc, id_libro_bancos, importe_contable_deposito)
                VALUES
                (v_parametros.id_cuenta_doc,v_parametros.id_libro_bancos,v_parametros.importe_contable_deposito);

            ELSE

                UPDATE cd.tdeposito_cd
                SET importe_contable_deposito = v_parametros.importe_contable_deposito
                WHERE id_libro_bancos = v_parametros.id_libro_bancos
                AND id_cuenta_doc=v_parametros.id_cuenta_doc;

            END IF;

            IF NOT EXISTS (SELECT 1
                     FROM tes.tdeposito_proceso_caja
                     WHERE id_libro_bancos=v_parametros.id_libro_bancos
                           AND id_proceso_caja=v_parametros.id_proceso_caja)THEN

              INSERT INTO tes.tdeposito_proceso_caja
                (id_proceso_caja, id_libro_bancos, importe_contable_deposito)
                VALUES
                (v_parametros.id_proceso_caja,v_parametros.id_libro_bancos,v_parametros.importe_contable_deposito);

            ELSE

                UPDATE tes.tdeposito_proceso_caja
                SET importe_contable_deposito = v_parametros.importe_contable_deposito
                WHERE id_libro_bancos = v_parametros.id_libro_bancos
                AND id_proceso_caja=v_parametros.id_proceso_caja;
                
            END IF;
              
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Importe Contable Deposito modificado'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_libro_bancos',v_parametros.id_libro_bancos::varchar);
              
            --Devuelve la respuesta
            return v_resp;

    end;

    /*********************************
    # TRANSACCION:  'TES_EXCDOC_IME'
    # DESCRIPCION:  Quitar registro de proceso de caja
    # AUTOR:    gsarmiento
    # FECHA:    12-10-2016 20:15:22
    ***********************************/
    elsif(p_transaccion='TES_EXCDOC_IME')then
    
    begin	 
    
    	SELECT id_proceso_caja
        INTO v_id_proceso_caja
        FROM tes.tsolicitud_rendicion_det
        WHERE id_solicitud_rendicion_det=v_parametros.id_solicitud_rendicion_det;
        
    	SELECT estado
        INTO v_codigo_proceso
        FROM tes.tproceso_caja 
        WHERE id_proceso_caja=v_id_proceso_caja;
  
        IF v_codigo_proceso != 'borrador' THEN
        	RAISE EXCEPTION 'No se puede realizar el movimiento en estado %',v_codigo_proceso;
        END IF;
        
        UPDATE tes.tsolicitud_rendicion_det
        SET id_proceso_caja=NULL
        WHERE id_solicitud_rendicion_det=v_parametros.id_solicitud_rendicion_det;
        
        SELECT sum(monto)
        INTO v_monto
        FROM tes.tsolicitud_rendicion_det
        WHERE id_proceso_caja=v_id_proceso_caja;

        UPDATE tes.tproceso_caja 
        SET monto=v_monto
        WHERE id_proceso_caja=v_id_proceso_caja;
        
        
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Modificacion'); 
        v_resp = pxp.f_agrega_clave(v_resp,'Modificacion en ',v_id_proceso_caja::varchar);
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