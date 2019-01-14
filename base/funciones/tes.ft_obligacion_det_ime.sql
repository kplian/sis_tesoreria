CREATE OR REPLACE FUNCTION tes.ft_obligacion_det_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:   Sistema de Tesoreria
 FUNCION:     tes.ft_obligacion_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tobligacion_det'
 AUTOR:     Gonzalo Sarmiento Sejas
 FECHA:         02-04-2013 20:27:35
 COMENTARIOS: 
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 Issue			Fecha        Author				Descripcion
#12        10/01/2019      MMV ENDETRAN       Considerar restar el iva al comprometer obligaciones de pago
***************************************************************************/

DECLARE

  v_nro_requerimiento     integer;
  v_parametros            record;
  v_id_requerimiento      integer;
  v_resp                varchar;
  v_nombre_funcion        text;
  v_mensaje_error         text;
  v_id_obligacion_det integer;
    v_tipo_cambio_conv     numeric;
    v_monto_mb numeric;
    v_tipo_obligacion varchar;
    v_id_moneda integer;
    v_id_partida integer;
    v_id_gestion integer;
    v_id_obligacion integer;
    v_id_partida_ejecucion integer;
    v_id_partida_anterior integer;
    v_id_cc_anterior    integer;
    v_monto         numeric;
    v_res         boolean;
    v_nombre_conexion   varchar;
    v_comprometido      varchar;
    v_monto_total_obligacion  numeric;
    v_registros       record;
    v_registros_cig         record;
    v_relacion        varchar;
    v_id_moneda_sg		integer; --#12
    v_monto_pago_sg_mb  numeric; --#12
    v_fecha_ob			date; --#12


BEGIN

    v_nombre_funcion = 'tes.ft_obligacion_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);

  /*********************************
  #TRANSACCION:  'TES_OBDET_INS'
  #DESCRIPCION: Insercion de registros
  #AUTOR:   Gonzalo Sarmiento Sejas
  #FECHA:   02-04-2013 20:27:35
  ***********************************/

  if(p_transaccion='TES_OBDET_INS')then

        begin

           --calculo monto en moneda base

           select
             op.tipo_cambio_conv,
             op.tipo_obligacion,
             op.id_gestion
             into
             v_tipo_cambio_conv,
             v_tipo_obligacion,
             v_id_gestion
           from tes.tobligacion_pago op
           where op.id_obligacion_pago = v_parametros.id_obligacion_pago;


          --no se admiten incersiones para pago tipo obligacion
          IF v_tipo_obligacion='adquisiciones' THEN
              raise exception 'no se permiten inserciones en pagos de adquisiciones';
          END IF;

          --calcula monto en moneda base
           v_monto_mb = v_parametros.monto_pago_mo * v_tipo_cambio_conv;


          --recueprar la partida de la parametrizacion
          v_id_partida = NULL;


          raise notice '(''CUECOMP'', %, %, %)',  v_id_gestion, v_parametros.id_concepto_ingas, v_parametros.id_centro_costo;

          --recupera el nombre del concepto de gasto

          select
            cig.desc_ingas
          into
            v_registros_cig
          from param.tconcepto_ingas cig
          where cig.id_concepto_ingas =  v_parametros.id_concepto_ingas;


          IF v_tipo_obligacion = 'pago_especial' THEN
              v_relacion = 'PAGOES';
          ELSE
              v_relacion = 'CUECOMP';
          END IF;

          --raise exception 'sssssss  %', v_tipo_obligacion;

          SELECT
            ps_id_partida
          into
            v_id_partida
          FROM conta.f_get_config_relacion_contable(v_relacion, v_id_gestion, v_parametros.id_concepto_ingas, v_parametros.id_centro_costo, 'No se encontro relación contable para el conceto de gasto: '||v_registros_cig.desc_ingas||'. <br> Mensaje: ');



          IF v_id_partida is NULL THEN
              raise exception 'no se tiene una parametrizacion de partida  para este concepto de gasto en la relacion contable de código  (%,%,%,%)','CUECOMP', v_relacion, v_parametros.id_concepto_ingas, v_parametros.id_centro_costo;
          END IF;
             ----#12
        select 	op.id_moneda,
        		op.fecha
        		into
                v_id_moneda_sg,
                v_fecha_ob
        from tes.tobligacion_pago op
        where op.id_obligacion_pago = v_parametros.id_obligacion_pago;


        v_monto_pago_sg_mb = param.f_convertir_moneda( 	v_id_moneda,
                                                       	NULL,   --por defecto moenda base
                                                      	v_parametros.monto_pago_sg_mb,
                                                       	v_fecha_ob,
                                                      	 'O',-- tipo oficial, venta, compra
                                                 NULL);
             ---#12

          --Sentencia de la insercion
          insert into tes.tobligacion_det(
      estado_reg,
      --id_cuenta,
      id_partida,
      --id_auxiliar,
      id_concepto_ingas,
      monto_pago_mo,
      id_obligacion_pago,
      id_centro_costo,
      monto_pago_mb,
      descripcion,
      fecha_reg,
      id_usuario_reg,
      fecha_mod,
      id_usuario_mod,
      id_orden_trabajo,
      monto_pago_sg_mo, --#12
      monto_pago_sg_mb --#12
          )
          values(
      'activo',
      --v_parametros.id_cuenta,
      v_id_partida,
      --v_parametros.id_auxiliar,
      v_parametros.id_concepto_ingas,
      v_parametros.monto_pago_mo,
      v_parametros.id_obligacion_pago,
      v_parametros.id_centro_costo,
      v_monto_mb,
      v_parametros.descripcion,
      now(),
      p_id_usuario,
      null,
      null,
      v_parametros.id_orden_trabajo,
      v_parametros.monto_pago_sg_mb,--#12
      v_monto_pago_sg_mb --#12
      )RETURNING id_obligacion_det into v_id_obligacion_det;

      --Definicion de la respuesta
      v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle almacenado(a) con exito (id_obligacion_det'||v_id_obligacion_det||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_obligacion_det',v_id_obligacion_det::varchar);

            --Devuelve la respuesta
            return v_resp;

    end;

  /*********************************
  #TRANSACCION:  'TES_OBDET_MOD'
  #DESCRIPCION: Modificacion de registros
  #AUTOR:   Gonzalo Sarmiento Sejas
  #FECHA:   02-04-2013 20:27:35
  ***********************************/

  elsif(p_transaccion='TES_OBDET_MOD')then

    begin

           --calculo monto en moneda base

           select
           op.tipo_cambio_conv,
           op.id_moneda,
           op.id_gestion
           into
           v_tipo_cambio_conv,
           v_id_moneda,
           v_id_gestion
           from tes.tobligacion_pago op
           where op.id_obligacion_pago = v_parametros.id_obligacion_pago;

           v_monto_mb = v_parametros.monto_pago_mo * v_tipo_cambio_conv;

           --recueprar la partida de la parametrizacion
          v_id_partida = NULL;


          select
            cig.desc_ingas
            into
            v_registros_cig
            from param.tconcepto_ingas cig
            where cig.id_concepto_ingas =  v_parametros.id_concepto_ingas;

          SELECT
              ps_id_partida
            into
              v_id_partida
          FROM conta.f_get_config_relacion_contable('CUECOMP', v_id_gestion, v_parametros.id_concepto_ingas, v_parametros.id_centro_costo, 'No se encontro relación contable para el conceto de gasto: '||v_registros_cig.desc_ingas||'. <br> Mensaje: ');




           IF v_id_partida is NULL THEN

            raise exception 'no se tiene una parametrizacionde partida  para este concepto de gasto en la relacion contable de código CUECOMP  (%,%,%,%)','CUECOMP', v_id_gestion, v_parametros.id_concepto_ingas, v_parametros.id_centro_costo;

           END IF;

              ----#12
        select 	op.id_moneda,
        		op.fecha
        		into
                v_id_moneda_sg,
                v_fecha_ob
        from tes.tobligacion_pago op
        where op.id_obligacion_pago = v_parametros.id_obligacion_pago;


        v_monto_pago_sg_mb = param.f_convertir_moneda( 	v_id_moneda,
                                                       	NULL,   --por defecto moenda base
                                                      	v_parametros.monto_pago_sg_mb,
                                                       	v_fecha_ob,
                                                      	 'O',-- tipo oficial, venta, compra
                                                 NULL);
         ---#12

      --Sentencia de la modificacion
      update tes.tobligacion_det set
      --id_cuenta = v_parametros.id_cuenta,
      id_partida = v_id_partida,
      --id_auxiliar = v_parametros.id_auxiliar,
      id_concepto_ingas = v_parametros.id_concepto_ingas,
      monto_pago_mo = v_parametros.monto_pago_mo,
      id_obligacion_pago = v_parametros.id_obligacion_pago,
      id_centro_costo = v_parametros.id_centro_costo,
      monto_pago_mb = v_monto_mb,
      fecha_mod = now(),
      descripcion=v_parametros.descripcion,
      id_usuario_mod = p_id_usuario,
      id_orden_trabajo = v_parametros.id_orden_trabajo,
      monto_pago_sg_mo = v_parametros.monto_pago_sg_mb,--#12
      monto_pago_sg_mb = v_monto_pago_sg_mb --#12
      where id_obligacion_det=v_parametros.id_obligacion_det;
               
      --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_obligacion_det',v_parametros.id_obligacion_det::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
    end;

  /*********************************    
  #TRANSACCION:  'TES_OBDET_ELI'
  #DESCRIPCION: Eliminacion de registros
  #AUTOR:   admin 
  #FECHA:   02-04-2013 20:27:35
  ***********************************/

  elsif(p_transaccion='TES_OBDET_ELI')then

    begin
           
        
            delete from tes.tprorrateo p 
            where  p.id_obligacion_det = v_parametros.id_obligacion_det;
            
            --Sentencia de la eliminacion
      delete from tes.tobligacion_det
            where id_obligacion_det=v_parametros.id_obligacion_det;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_obligacion_det',v_parametros.id_obligacion_det::varchar);
              
            --Devuelve la respuesta
            return v_resp;

    end;
        
    /*********************************    
  #TRANSACCION:  'TES_OBDETAPRO_MOD'
  #DESCRIPCION: Cambio en la apropacion de un detalle de obligacion
  #AUTOR:   admin 
  #FECHA:   02-04-2013 20:27:35
  ***********************************/

  elsif(p_transaccion='TES_OBDETAPRO_MOD')then

    begin
          
        
            /************************OBTENER DATOS**********************/
            select od.id_partida_ejecucion_com,od.id_obligacion_pago, od.id_partida,od.id_centro_costo,op.id_moneda,
            od.monto_pago_mo,op.id_gestion,op.total_pago,op.comprometido 
            into v_id_partida_ejecucion,v_id_obligacion,v_id_partida_anterior, v_id_cc_anterior,v_id_moneda,
            v_monto,v_id_gestion,v_monto_total_obligacion,v_comprometido
            from tes.tobligacion_det od
            inner join tes.tobligacion_pago op on op.id_obligacion_pago = od.id_obligacion_pago
            where id_obligacion_det = v_parametros.id_obligacion_det;
      
            /*Validacion de que no haya ninguna cuota de tipo devengado y devengado_pago en estado devengado*/
            
            if exists ( select 1 
                  from tes.tplan_pago pp
                        where ((pp.tipo in ('devengado','devengado_pagado','devengado_pagado_1c') and pp.estado = 'devengado') OR
                          pp.tipo in ('ant_aplicado') and pp.estado = 'aplicado') and 
                            pp.id_obligacion_pago = v_id_obligacion and pp.estado_reg != 'inactivo' ) then
              raise exception 'Existe un pago devengado para esta solicitud. Por lo que no es posible modificar la apropiacion';
            end if;
            
                    
            /************************OBTENER NUEVA PARTIDA**********************/
            SELECT 
            ps_id_partida into v_id_partida           
            FROM conta.f_get_config_relacion_contable('CUECOMP', v_id_gestion, v_parametros.id_concepto_ingas, v_parametros.id_centro_costo);
            
            IF v_id_partida is NULL THEN
          
            raise exception 'No se tiene una parametrizacion de partida  para este concepto de gasto en la relacion contable de código CUECOMP  (%,%,%,%)','CUECOMP', v_id_gestion, v_parametros.id_concepto_ingas, v_parametros.id_centro_costo;
            
           END IF;           
           
           select * into v_nombre_conexion from migra.f_crear_conexion(); 

             /************************REVERTIR COMPROMETIDO**********************/
            if (v_comprometido = 'si') then
                select tes.f_gestionar_presupuesto_tesoreria(v_id_obligacion, 1, 'revertir',NULL,v_nombre_conexion) into v_res;
                if v_res = false then
                    raise exception 'Error al revertir el presupuesto';
                end if;
                
                update tes.tobligacion_pago
                set comprometido = 'no'
                where id_obligacion_pago = v_id_obligacion;
            end if;
            /******************************ELIMINAR DATOS DE PRORRATEO***********************************/
             delete from tes.tprorrateo using tes.tplan_pago
             where tes.tprorrateo.id_plan_pago = tes.tplan_pago.id_plan_pago 
             and tes.tplan_pago.id_obligacion_pago = v_id_obligacion; 

            /************************ACTUALIZAR DATOS EN TABLA OBPDET**********************/
            v_monto_mb = v_parametros.monto_pago_mo * v_tipo_cambio_conv;
            update tes.tobligacion_det set 
            id_concepto_ingas = v_parametros.id_concepto_ingas,
            id_partida = v_id_partida,
            id_centro_costo = v_parametros.id_centro_costo,
            id_orden_trabajo = v_parametros.id_orden_trabajo,
            monto_pago_mo = v_parametros.monto_pago_mo,   
      monto_pago_mb = v_monto_mb,
        fecha_mod = now(),
            descripcion=v_parametros.descripcion,
      id_usuario_mod = p_id_usuario
            where id_obligacion_det = v_parametros.id_obligacion_det;
            
            /***********GENERAR PRORRATEOS**********/
            if ((select sum(od.monto_pago_mo) 
              from tes.tobligacion_det od 
                where id_obligacion_pago = v_id_obligacion and estado_reg = 'activo') = v_monto_total_obligacion) THEN
                v_resp = tes.f_calcular_factor_obligacion_det(v_id_obligacion);
                for v_registros in (select id_plan_pago,op.pago_variable,pp.monto_ejecutar_total_mo,pp.id_plan_pago_fk 
                          from tes.tplan_pago pp
                                    inner join tes.tobligacion_pago op on  op.id_obligacion_pago = pp.id_obligacion_pago
                                    where op.id_obligacion_pago = v_id_obligacion and pp.tipo in ('devengado','devengado_pagado','devengado_pagado_1c')
                                    and pp.estado != 'anulado' and pp.estado_reg = 'activo') loop
                                    
                 v_res = tes.f_prorrateo_plan_pago(v_registros.id_plan_pago, v_id_obligacion,
                     v_registros.pago_variable, v_registros.monto_ejecutar_total_mo, p_id_usuario, NULL);
                end loop;
            end if;
           
            select * into v_resp from migra.f_cerrar_conexion(v_nombre_conexion,'exito'); 
             --Definicion de la respuesta
            v_resp = '';
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cambio en apropiacon realizado'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_obligacion_det',v_parametros.id_obligacion_det::varchar);
              
            --Devuelve la respuesta
            return v_resp;  
            
        END;
      
        /*********************************    
  #TRANSACCION:  'TES_OBDETAPRO_INS'
  #DESCRIPCION: Cambio en la apropacion de un detalle de obligacion
  #AUTOR:   admin 
  #FECHA:   02-04-2013 20:27:35
  ***********************************/

  elsif(p_transaccion='TES_OBDETAPRO_INS')then

    begin
          
        
            /************************OBTENER DATOS**********************/
            select op.id_obligacion_pago,op.id_moneda,op.id_gestion, comprometido,op.total_pago 
            into v_id_obligacion,v_id_moneda,v_id_gestion,v_comprometido,v_monto_total_obligacion
            from tes.tobligacion_pago op            
            where id_obligacion_pago = v_parametros.id_obligacion_pago;
      
            /*Validacion de que no haya ninguna cuota de tipo devengado y devengado_pago en estado devengado*/
            
            if exists ( select 1 
                  from tes.tplan_pago pp
                        where ((pp.tipo in ('devengado','devengado_pagado','devengado_pagado_1c') and pp.estado = 'devengado') OR
                          pp.tipo in ('ant_aplicado') and pp.estado = 'aplicado') and 
                            pp.id_obligacion_pago = v_id_obligacion and pp.estado_reg != 'inactivo' ) then
              raise exception 'Existe un pago devengado para esta solicitud. Por lo que no es posible modificar la apropiacion';
            end if;
            
                    
            /************************OBTENER NUEVA PARTIDA**********************/
            --raise exception '%', v_parametros.id_obligacion_pago;
            SELECT 
            ps_id_partida into v_id_partida           
            FROM conta.f_get_config_relacion_contable('CUECOMP', v_id_gestion, v_parametros.id_concepto_ingas, v_parametros.id_centro_costo);
            
            IF v_id_partida is NULL THEN
          
            raise exception 'No se tiene una parametrizacion de partida  para este concepto de gasto en la relacion contable de código CUECOMP  (%,%,%,%)','CUECOMP', v_id_gestion, v_parametros.id_concepto_ingas, v_parametros.id_centro_costo;
            
           END IF;           
           
           select * into v_nombre_conexion from migra.f_crear_conexion(); 

             /************************REVERTIR COMPROMETIDO**********************/
             if (v_comprometido = 'si') then
                select tes.f_gestionar_presupuesto_tesoreria(v_id_obligacion, 1, 'revertir',NULL,v_nombre_conexion) into v_res;
                if v_res = false then
                    raise exception 'Error al revertir el presupuesto';
                end if;
                
                update tes.tobligacion_pago
                set comprometido = 'no'
                where id_obligacion_pago = v_id_obligacion;
             end if;
           
           /******************************ELIMINAR DATOS DE PRORRATEO***********************************/
             delete from tes.tprorrateo using tes.tplan_pago
             where tes.tprorrateo.id_plan_pago = tes.tplan_pago.id_plan_pago 
             and tes.tplan_pago.id_obligacion_pago = v_parametros.id_obligacion_pago;

            /************************ACTUALIZAR DATOS EN TABLA OBPDET**********************/
            v_monto_mb = v_parametros.monto_pago_mo * v_tipo_cambio_conv;
            --Sentencia de la insercion
          insert into tes.tobligacion_det(
      estado_reg,     
      id_partida,     
      id_concepto_ingas,
      monto_pago_mo,
      id_obligacion_pago,
      id_centro_costo,
      monto_pago_mb,
            descripcion,
      fecha_reg,
      id_usuario_reg,
      fecha_mod,
      id_usuario_mod,
            id_orden_trabajo
            ) values(
      'activo',     
      v_id_partida,     
      v_parametros.id_concepto_ingas,
      v_parametros.monto_pago_mo,
      v_parametros.id_obligacion_pago,
      v_parametros.id_centro_costo,
      v_monto_mb,
            v_parametros.descripcion,   
      now(),
      p_id_usuario,
      null,
      null,
            v_parametros.id_orden_trabajo
              
      )RETURNING id_obligacion_det into v_id_obligacion_det;
            
            /***********GENERAR PRORRATEOS**********/
            if ((select sum(od.monto_pago_mo) 
              from tes.tobligacion_det od 
                where id_obligacion_pago = v_id_obligacion and estado_reg = 'activo') = v_monto_total_obligacion) THEN
                v_resp = tes.f_calcular_factor_obligacion_det(v_id_obligacion);
                for v_registros in (select id_plan_pago,op.pago_variable,pp.monto_ejecutar_total_mo,pp.id_plan_pago_fk 
                          from tes.tplan_pago pp
                                    inner join tes.tobligacion_pago op on  op.id_obligacion_pago = pp.id_obligacion_pago
                                    where op.id_obligacion_pago = v_id_obligacion and pp.tipo in ('devengado','devengado_pagado','devengado_pagado_1c')
                                    and pp.estado != 'anulado' and pp.estado_reg = 'activo') loop
                 
                     v_res = tes.f_prorrateo_plan_pago(v_registros.id_plan_pago, v_id_obligacion,
                     v_registros.pago_variable, v_registros.monto_ejecutar_total_mo, p_id_usuario, NULL);
                end loop;
            end if;
           
            select * into v_resp from migra.f_cerrar_conexion(v_nombre_conexion,'exito'); 
             --Definicion de la respuesta
             v_resp = '';
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle almacenado(a) con exito (id_obligacion_det'||v_id_obligacion_det||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_obligacion_det',v_id_obligacion_det::varchar);
              
            --Devuelve la respuesta
            return v_resp;  
            
        END;
    
    /*********************************    
  #TRANSACCION:  'TES_OBDETAPRO_ELI'
  #DESCRIPCION: Cambio en la apropacion de un detalle de obligacion
  #AUTOR:   admin 
  #FECHA:   02-04-2013 20:27:35
  ***********************************/

  elsif(p_transaccion='TES_OBDETAPRO_ELI')then

    begin
          
        
            /************************OBTENER DATOS**********************/
            select od.id_partida_ejecucion_com,od.id_obligacion_pago, od.id_partida,od.id_centro_costo,op.id_moneda,
            od.monto_pago_mo,op.id_gestion,op.total_pago,op.comprometido 
            into v_id_partida_ejecucion,v_id_obligacion,v_id_partida_anterior, v_id_cc_anterior,v_id_moneda,
            v_monto,v_id_gestion,v_monto_total_obligacion,v_comprometido
            from tes.tobligacion_det od
            inner join tes.tobligacion_pago op on op.id_obligacion_pago = od.id_obligacion_pago
            where id_obligacion_det = v_parametros.id_obligacion_det;
      
            /*Validacion de que no haya ninguna cuota de tipo devengado y devengado_pago en estado devengado*/
            
            if exists ( select 1 
                  from tes.tplan_pago pp
                        where ((pp.tipo in ('devengado','devengado_pagado','devengado_pagado_1c') and pp.estado = 'devengado') OR
                          pp.tipo in ('ant_aplicado') and pp.estado = 'aplicado') and 
                            pp.id_obligacion_pago = v_id_obligacion and pp.estado_reg != 'inactivo' ) then
              raise exception 'Existe un pago devengado para esta solicitud. Por lo que no es posible modificar la apropiacion';
            end if;            
                    
           
             /************************REVERTIR COMPROMETIDO**********************/
             if (v_comprometido = 'si') then
                  select tes.f_gestionar_presupuesto_tesoreria(v_id_obligacion, 1, 'revertir',NULL,v_nombre_conexion) into v_res;
                  if v_res = false then
                      raise exception 'Error al revertir el presupuesto';
                  end if;
                  
                  update tes.tobligacion_pago
                  set comprometido = 'no'
                  where id_obligacion_pago = v_id_obligacion;
             end if;
            /******************************ELIMINAR DATOS DE PRORRATEO***********************************/
             delete from tes.tprorrateo using tes.tplan_pago
             where tes.tprorrateo.id_plan_pago = tes.tplan_pago.id_plan_pago 
             and tes.tplan_pago.id_obligacion_pago = v_id_obligacion; 

            /************************ACTUALIZAR DATOS EN TABLA OBPDET**********************/
            delete from tes.tobligacion_det
            where id_obligacion_det=v_parametros.id_obligacion_det;
            
            /***********GENERAR PRORRATEOS**********/
            if ((select sum(od.monto_pago_mo) 
              from tes.tobligacion_det od 
                where id_obligacion_pago = v_id_obligacion and estado_reg = 'activo') = v_monto_total_obligacion) THEN
                v_resp = tes.f_calcular_factor_obligacion_det(v_id_obligacion);
                for v_registros in (select id_plan_pago,op.pago_variable,pp.monto_ejecutar_total_mo,pp.id_plan_pago_fk 
                          from tes.tplan_pago pp
                                    inner join tes.tobligacion_pago op on  op.id_obligacion_pago = pp.id_obligacion_pago
                                    where op.id_obligacion_pago = v_id_obligacion and pp.tipo in ('devengado','devengado_pagado','devengado_pagado_1c')
                                    and pp.estado != 'anulado' and pp.estado_reg = 'activo') loop
                 v_res = tes.f_prorrateo_plan_pago(v_registros.id_plan_pago, v_id_obligacion,
                     v_registros.pago_variable, v_registros.monto_ejecutar_total_mo, p_id_usuario, NULL);
                end loop;
            end if;
            
            select * into v_resp from migra.f_cerrar_conexion(v_nombre_conexion,'exito'); 
             --Definicion de la respuesta
            --Definicion de la respuesta
             v_resp = '';
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_obligacion_det',v_parametros.id_obligacion_det::varchar);
              
            --Devuelve la respuesta
            return v_resp;  
            
        END;
         
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