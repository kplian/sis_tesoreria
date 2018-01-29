--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.ft_caja_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.ft_caja_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tcaja'
 AUTOR: 		 (admin)
 FECHA:	        16-12-2013 20:43:44
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_caja				integer;
	v_id_cajero				integer;
    v_respuesta				varchar;
    v_posicion_inicial		integer;
    v_posicion_final		integer;
    v_num					varchar;
    v_id_proceso_macro		integer;
    v_codigo_tipo_proceso	varchar;
    v_id_gestion			integer;
    v_num_tramite			varchar;
   	v_id_proceso_wf			integer;
   	v_id_estado_wf			integer;
   	v_codigo_estado		    varchar;

    v_id_proceso_caja		integer;
    v_tipo					varchar;
    v_fecha					date;
    v_hstore_caja			hstore;

    v_id_tipo_estado		integer;
    v_pedir_obs				varchar;
    v_codigo_estado_siguiente	varchar;

    v_id_depto				integer;
    v_obs					varchar;
    v_acceso_directo		varchar;
    v_clase					varchar;
    v_parametros_ad 		varchar;
    v_tipo_noti 			varchar;
    v_titulo 				varchar;
    v_id_estado_actual		integer;

    v_id_cuenta_bancaria	integer;
    v_id_depto_lb			integer;
    v_importe				numeric;
    v_nombre_cheque			varchar;
    v_codigo				varchar;
    v_id_finalidad			integer;
    v_id_funcionario		integer;
    v_id_usuario_reg		integer;
    v_id_estado_wf_ant		integer;
    v_codigo_tipo_pro		varchar;
	v_codigo_llave			varchar;
    v_registros_proc		record;
    v_registros_proceso_caja	record;
    v_id_estado_wf_pc		VARCHAR[];
    v_id_proceso_wf_pc		varchar[];
    v_id_proceso_caja_pc	varchar[];
    v_id_tipo_estado_pc		integer;
    v_depto					record;
    v_funcionarios			record;

BEGIN

    v_nombre_funcion = 'tes.ft_caja_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'TES_CAJA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin
 	#FECHA:		16-12-2013 20:43:44
	***********************************/

	if(p_transaccion='TES_CAJA_INS')then

        begin

        	v_num =   param.f_obtener_correlativo(
                                 'CAJA',
                                 NULL,-- par_id,
                                 NULL, --id_uo
                                 v_parametros.id_depto,    -- id_depto
                                 p_id_usuario,
                                 'TES',
                                 NULL);

            IF (v_num is NULL or v_num ='') THEN

              raise exception 'No se pudo obtener un numero correlativo para ingreso de caja';

            END IF;

			--obtener id del proceso macro

            select
             pm.id_proceso_macro
            into
             v_id_proceso_macro
            from wf.tproceso_macro pm
            where pm.codigo = 'TES-CAJA';

            If v_id_proceso_macro is NULL THEN
             raise exception 'El proceso macro  de codigo % no esta configurado en el sistema WF',v_codigo_proceso_macro;
            END IF;


            --   obtener el codigo del tipo_proceso

            select   tp.codigo
                into v_codigo_tipo_proceso
            from  wf.ttipo_proceso tp
            where   tp.id_proceso_macro = v_id_proceso_macro
                    and tp.estado_reg = 'activo' and tp.inicio = 'si';


            IF v_codigo_tipo_proceso is NULL THEN
               raise exception 'No existe un proceso inicial para el proceso macro indicado % (Revise la configuración)',v_codigo_proceso_macro;
            END IF;

            select
             ges.id_gestion
            into
              v_id_gestion
            from param.tgestion ges
            where ges.gestion = (date_part('year', current_date))::integer
            limit 1 offset 0;

            -- inciar el tramite en el sistema de WF
             SELECT
                   ps_num_tramite ,
                   ps_id_proceso_wf ,
                   ps_id_estado_wf ,
                   ps_codigo_estado
                into
                   v_num_tramite,
                   v_id_proceso_wf,
                   v_id_estado_wf,
                   v_codigo_estado

              FROM wf.f_inicia_tramite(
                   p_id_usuario,
                   NULL,
                   NULL,
                   v_id_gestion,
                   v_codigo_tipo_proceso,
                   NULL,
                   v_parametros.id_depto,
                   'Caja ('||v_num||') '::varchar,
                   v_num );

             IF (SELECT 1 FROM tes.tcaja where codigo=upper(v_parametros.codigo))THEN
             	raise exception 'Ya existe una caja con ese codigo';
             END IF;

        	--Sentencia de la insercion
        	insert into tes.tcaja(
			importe_maximo_caja,
			tipo,
			estado_reg,
			importe_maximo_item,
            dias_maximo_rendicion,
			id_moneda,
			id_depto,
			codigo,
			id_usuario_reg,
			fecha_reg,
			id_usuario_mod,
			fecha_mod,
            tipo_ejecucion,
            --id_cuenta_bancaria
            id_depto_lb
          	) values(
			v_parametros.importe_maximo_caja,
			v_parametros.tipo,
			'activo',
			v_parametros.importe_maximo_item,
            v_parametros.dias_maximo_rendicion,
			v_parametros.id_moneda,
			v_parametros.id_depto,
			upper(v_parametros.codigo),
			p_id_usuario,
			now(),
			null,
			null,
			v_parametros.tipo_ejecucion,
            --v_parametros.id_cuenta_bancaria
            v_parametros.id_depto_lb
			)RETURNING id_caja into v_id_caja;

            insert into tes.tproceso_caja(
            id_proceso_wf,
            id_estado_wf,
            id_caja,
            estado,
            motivo,			--no permite nulo por eso llenado
            fecha,
            nro_tramite,
            tipo
            )values(
            v_id_proceso_wf,
            v_id_estado_wf,
            v_id_caja,
            v_codigo_estado,
            'Solicitud creacion caja chica '||upper(v_parametros.codigo),
            current_date,	--no permite nulo por eso llenado
            v_num,
            'apertura'
            );

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Caja almacenado(a) con exito (id_caja'||v_id_caja||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_caja',v_id_caja::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'TES_CAJA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin
 	#FECHA:		16-12-2013 20:43:44
	***********************************/

	elsif(p_transaccion='TES_CAJA_MOD')then

		begin
        	if(pxp.f_existe_parametro(p_tabla,'id_cuenta_bancaria')) then
            	v_id_cuenta_bancaria = v_parametros.id_cuenta_bancaria;
            else
              	v_id_cuenta_bancaria = null;
            end if;
			--Sentencia de la modificacion
			update tes.tcaja set
			importe_maximo_caja = v_parametros.importe_maximo_caja,
			tipo = v_parametros.tipo,
			importe_maximo_item = v_parametros.importe_maximo_item,
			id_moneda = v_parametros.id_moneda,
			id_depto = v_parametros.id_depto,
            id_cuenta_bancaria = v_id_cuenta_bancaria,
			codigo = v_parametros.codigo,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
            tipo_ejecucion = v_parametros.tipo_ejecucion
			where id_caja=v_parametros.id_caja;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Caja modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_caja',v_parametros.id_caja::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

    elsif(p_transaccion='TES_SIGECAJA_IME')then
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
       		pc.tipo,
            pc.id_caja,
            pc.fecha
        into
            v_id_proceso_caja,
            v_id_proceso_wf,
            v_codigo_estado,
            v_tipo,
            v_id_caja,
            v_fecha
        from tes.tproceso_caja pc
        where pc.id_proceso_wf  = v_parametros.id_proceso_wf_act;
          --raise exception '%',v_codigo_estado;
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
		  --depto
          IF pxp.f_existe_parametro(p_tabla,'id_depto_wf') THEN
          	v_id_depto = v_parametros.id_depto_wf;
          END IF;
          --proveido
          IF  pxp.f_existe_parametro(p_tabla,'obs') THEN
         	 v_obs=v_parametros.obs;
          ELSE
         	 v_obs='---';
          END IF;

         --configurar acceso directo para la alarma
         /*
         v_acceso_directo = '';
         v_clase = '';
         v_parametros_ad = '';
         v_tipo_noti = '';
         v_titulo  = '';*/
--el siguiente estado sera aprobado, no entra en este if
         IF v_codigo_estado_siguiente in ('solicitado')THEN
            v_acceso_directo = '../../../sis_tesoreria/vista/caja/CajaVB.php';
            v_clase = 'CajaVb';
            v_parametros_ad = '{filtro_directo:{campo:"pc.id_proceso_wf",valor:"'||v_id_proceso_wf::varchar||'"}}';
            v_tipo_noti = 'notificacion';
            v_titulo  = 'Visto Bueno';
           
         END IF;
        
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
                                                             v_acceso_directo,
                                                             v_clase,
                                                             v_parametros_ad,
                                                             v_tipo_noti,
                                                             v_titulo);

--actualia el estado del flujo
          update tes.tproceso_caja  t set
             id_estado_wf =  v_id_estado_actual,
             estado = v_codigo_estado_siguiente,
             id_usuario_mod=p_id_usuario,
             fecha_mod=now()
          where id_proceso_wf = v_parametros.id_proceso_wf_act;

          select caj.id_cajero, fun.desc_funcionario1 
          into v_id_cajero, v_nombre_cheque
          from tes.tcajero caj
          left join orga.vfuncionario fun on caj.id_funcionario=fun.id_funcionario
          where caj.id_caja=v_id_caja and caj.tipo='responsable';
		--and now() BETWEEN caj.fecha_inicio and COALESCE(caj.fecha_fin,now());
--verifica si existe un responsable de caja
          IF v_id_cajero is null THEN
              raise exception 'Deber asignar un responsable vigente en fecha de la Caja antes de aperturarla';
          END IF;
--va a aprobado
          if(v_codigo_estado_siguiente = 'aprobado')then
--cierra el estado de la caja
            UPDATE tes.tcaja
            SET estado='cerrado'
            WHERE id_caja = v_id_caja;
--raise exception 'in';
            --armar hstore
            --obtiene los datos tipo, caja, motivo(apertura de caja) ,fecha
             v_hstore_caja =   hstore(ARRAY[
                              'id_proceso_caja', '',
                              'tipo','REPO'::varchar,
                              'motivo','Apertura Caja'::varchar,
                              'id_caja',v_id_caja::varchar,
                              'fecha',to_char(CURRENT_DATE,'DD-MM-YYYY')::varchar
                             ]);
                             
                             --Rendicion Caja almacenado(a) con exito (id_proceso_caja283)
                             
            v_resp = tes.f_inserta_proceso_reposicion_rendicion_caja(p_administrador,p_id_usuario,v_hstore_caja);
            
            --07/01/2017, manuel guerra, se esta comentando, se evita el error de depto 
            /* 
--raise exception '%',v_resp;
            v_id_estado_wf_pc =  pxp.f_recupera_clave(v_resp, 'id_estado_wf');
            v_id_proceso_wf_pc =  pxp.f_recupera_clave(v_resp, 'id_proceso_wf');
            --v_id_proceso_caja_pc =  pxp.f_recupera_clave(v_resp, 'id_proceso_caja');

            select te.id_tipo_estado
            into v_id_tipo_estado_pc
            from wf.ttipo_estado te
            inner join wf.tproceso_wf  pw on pw.id_tipo_proceso = te.id_tipo_proceso
                  and pw.id_proceso_wf = v_id_proceso_wf_pc[1]::integer
            where te.codigo = 'vbfondos';

            select * into v_depto from tes.f_lista_depto_conta_x_op_wf_sel(p_id_usuario,v_id_tipo_estado_pc) as
            (id_depto integer, codigo_depto varchar, nombre_corto_depto varchar,nombre_depto varchar,
                               prioridad integer, subsistema varchar);
raise exception '%', v_depto;
          	select * into v_funcionarios from wf.f_funcionario_wf_sel(p_id_usuario,v_id_tipo_estado_pc) as
            (id_funcionario INTEGER, desc_funcionario text, desc_funcionario_cargo text, prioridad integer);

            --configurar acceso directo para la alarma
             v_acceso_directo = '../../../sis_tesoreria/vista/proceso_caja/ProcesoCajaVbFondos.php';
             v_clase = 'ProcesoCajaVbFondos';
             v_parametros_ad = '{filtro_directo:{campo:"ren.id_proceso_wf",valor:"'||v_id_proceso_wf_pc[1]::varchar||'"}}';
             v_tipo_noti = 'notificacion';
             v_titulo  = 'Visto Fondos';

             v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado_pc,
                                                             v_funcionarios.id_funcionario,
                                                             v_id_estado_wf_pc[1]::integer,
                                                             v_id_proceso_wf_pc[1]::integer,
                                                             p_id_usuario,
                                                             v_parametros._id_usuario_ai,
                                                             v_parametros._nombre_usuario_ai,
                                                             v_depto.id_depto,
                                                             ' Obs:'||v_obs,
                                                             v_acceso_directo,
                                                             v_clase,
                                                             v_parametros_ad,
                                                             v_tipo_noti,
                                                             v_titulo);

          update tes.tproceso_caja  set
             id_estado_wf =  v_id_estado_actual,
             estado = 'vbfondos',
             id_usuario_mod=p_id_usuario,
             id_depto_conta = v_depto.id_depto,
             fecha_mod=now()
          where id_proceso_wf = v_id_proceso_wf_pc[1]::integer;
*/
          end if;
          /*
          if(v_codigo_estado_siguiente = 'rechazado')then

            UPDATE tes.tcaja
            SET estado='cerrado'
            WHERE id_caja = v_id_caja;

          end if;*/

          --end if;

          -- si hay mas de un estado disponible  preguntamos al usuario
          v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado de la caja)');
          v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');


          -- Devuelve la respuesta
          return v_resp;

     end;

     /*********************************
 	#TRANSACCION:  'TES_ANTECAJA_IME'
 	#DESCRIPCION:	Transaccion utilizada  pasar a  estados anterior en caja segun la operacion definida
 	#AUTOR:		GSS
 	#FECHA:		09-12-2015
	***********************************/

	elsif(p_transaccion='TES_ANTECAJA_IME')then
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

           IF  NOT tes.f_fun_regreso_caja_wf(p_id_usuario,
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
 	#TRANSACCION:  'TES_CAJA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin
 	#FECHA:		16-12-2013 20:43:44
	***********************************/

	elsif(p_transaccion='TES_CAJA_ELI')then

		begin
        	select pc.estado,
                   pc.id_proceso_wf,
                   pc.id_proceso_caja,
                   cj.id_depto,
                   pc.id_estado_wf
            into v_registros_proceso_caja
			from tes.tproceso_caja pc
            inner join tes.tcaja cj on cj.id_caja= pc.id_caja and pc.tipo='apertura'
			where pc.id_caja=v_parametros.id_caja;

            IF v_registros_proceso_caja.estado !='borrador' THEN
            	raise exception 'No es posible eliminar la solicitud de apertura de caja, no se encuentra en estado borrador';
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
           where pw.id_proceso_wf = v_registros_proceso_caja.id_proceso_wf;


           IF v_id_tipo_estado is NULL THEN

              raise exception 'El estado anulado para la solcititud de apertura de caja no esta parametrizado en el workflow';

           END IF;

           -- pasamos la obligacion al estado anulado

           v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado,
                                                       NULL,
                                                       v_registros_proceso_caja.id_estado_wf,
                                                       v_registros_proceso_caja.id_proceso_wf,
                                                       p_id_usuario,
                                                       v_parametros._id_usuario_ai,
                                                       v_parametros._nombre_usuario_ai,
                                                       v_registros_proceso_caja.id_depto,
                                                       'Solicitud de Caja Anulada');


               -- actualiza estado en proceso caja
            update tes.tproceso_caja set
			     id_estado_wf =  v_id_estado_actual,
                 estado = 'anulado',
                 id_usuario_mod=p_id_usuario,
                 fecha_mod=now(),
                 id_usuario_ai = v_parametros._id_usuario_ai,
                 usuario_ai = v_parametros._nombre_usuario_ai
            where id_proceso_caja  = v_registros_proceso_caja.id_proceso_caja;

			--Sentencia de la eliminacion
           	update tes.tcajero
            set estado_reg = 'inactivo',
            estado = 'inactivo'
            where id_caja=v_parametros.id_caja;

			update tes.tcaja
            set estado_reg  = 'inactivo'
            where id_caja=v_parametros.id_caja;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Caja anulada(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_caja',v_parametros.id_caja::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;
	
    /*********************************
 	#TRANSACCION:  'TES_CAJA_MOD_MONTO'
 	#DESCRIPCION:	Modifica el monto de reposicion
 	#AUTOR:		manuel guerra
 	#FECHA:		09-11-2015
	***********************************/

	elsif(p_transaccion='TES_CAJA_MOD_MONTO')then
		begin
        
        	IF v_parametros.estado!='borrador' THEN            	     
            	raise exception 'La reposicion debe estar en estado Borrador';  	
            END IF;
            
            update tes.tproceso_caja set
            monto = v_parametros.monto
            where id_proceso_caja=v_parametros.id_proceso_caja; 
              
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Monto modificado');         
            v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_caja',v_parametros.id_proceso_caja::varchar);

     		return v_resp;
		end;    
    /*********************************
 	#TRANSACCION:  'TES_CAJA_ABRCER'
 	#DESCRIPCION:	Apertura y cierre de caja chica
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		09-11-2015
	***********************************/

	elsif(p_transaccion='TES_CAJA_ABRCER')then

		begin
			IF(v_parametros.estado='cerrado')THEN

                UPDATE tes.tcaja
                SET estado='abierto'
                WHERE id_caja = v_parametros.id_caja;

                select id_cajero into v_id_cajero
                from tes.tcajero
				where id_caja=v_parametros.id_caja and tipo='responsable'
                and now() BETWEEN fecha_inicio and fecha_fin;

                IF v_id_cajero is null THEN
                	raise exception 'Deber asignar un responsable vigente en fecha de la Caja antes de aperturarla';
                END IF;

                --insertar en libro de bancos
                v_resp = pxp.f_intermediario_ime(p_id_usuario::int4,NULL,NULL::varchar,'v58gc566o75102428i2usu08i4',13313,'172.17.45.202','99:99:99:99:99:99','tes.ft_ts_libro_bancos_ime','TES_LBAN_INS',NULL,'no',NULL,
                            array['filtro','ordenacion','dir_ordenacion','puntero','cantidad','_id_usuario_ai','_nombre_usuario_ai','id_cuenta_bancaria','fecha','id_depto','a_favor','nro_cheque','importe_deposito','nro_liquidacion','detalle','origen','observaciones','importe_cheque','id_libro_bancos_fk','nro_comprobante','comprobante_sigma','tipo','id_finalidad','sistema_origen','id_int_comprobante'],
                            array[' 0 = 0 ','','','','','NULL','NULL',v_parametros.id_cuenta_bancaria::varchar,v_parametros.fecha::varchar,v_parametros.id_depto_lb::varchar,v_parametros.a_favor::varchar,'NULL','0','','PAGO '||upper(v_parametros.detalle)::varchar,'CBB'::varchar,''::varchar,v_parametros.importe::varchar,'NULL','','C31-','cheque',v_parametros.id_finalidad::varchar,''::varchar,'NULL'],
                            array['varchar','varchar','varchar','integer','integer','int4','varchar','int4','date','int4','varchar','int4','numeric','varchar','text','varchar','text','numeric','int4','varchar','varchar','varchar','int4','varchar','int4']
                            ,'',NULL,NULL);

                v_respuesta = substring(v_resp from '%#"tipo_respuesta":"_____"#"%' for '#');

                IF v_respuesta = 'tipo_respuesta":"ERROR"' THEN
                    v_posicion_inicial = position('"mensaje":"' in v_resp) + 11;
                    v_posicion_final = position('"codigo_error":' in v_resp) - 2;
                    RAISE EXCEPTION 'No se pudo ingresar el cheque en libro de bancos ERP-BOA: mensaje: %',substring(v_resp from v_posicion_inicial for (v_posicion_final-v_posicion_inicial));
                END IF;--fin error respuesta


                v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Caja abierta');
				--implementacion de comprobante si es que corresponde
            ELSE

            	UPDATE tes.tcaja
                SET estado='cerrado'
                WHERE id_caja = v_parametros.id_caja;

	            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Caja cerrada');
                --raise exception 'Se procedio a cerrar la caja';
            END IF;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'id_caja',v_parametros.id_caja::varchar);

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
COST 100;