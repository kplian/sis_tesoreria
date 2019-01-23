CREATE OR REPLACE FUNCTION tes.f_extender_obligacion (
  p_administrador integer,
  p_id_obligacion_pago integer,
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_nombre_usuario_ai varchar
)
RETURNS varchar AS
$body$
/************************************************************************** 
 SISTEMA:        Sistema de Tesoreria FUNCION:        tes.f_extender_obligacion
 DESCRIPCION:    Procesa la extención de la obligacion de pago para una siguiente gestion 
 AUTOR:         RAC KPLIAN  
 FECHA:         29/11/2018 16:316
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:    
 AUTOR:            
 FECHA:     
     HISTORIAL DE MODIFICACIONES:
   	
 ISSUE            FECHA:		      AUTOR                                DESCRIPCION
 #7890          29/11/2018		     RAC (KPLIAN)            refactorizacion de codigo para la extencion de obligaciones de  pago , seañaden neuvas funcionalidades 
 #12            10/01/2019           RAC (KPLIAN)            considerar el campo comproemter_iva
--#18 endetr    23/01/2018        chros                     se mejoró el mensaje que se visualiza a momento de validar que existan los centros de costo en la siguiente gestión          
***************************************************************************/



DECLARE
 
    v_resp		                varchar;
	v_nombre_funcion            text;
    v_anho                      integer;
    v_registros                 record;
    v_registros_det             record;
    v_date                      date;
    v_hstore_registros          hstore;
    v_id_gestion_sg             varchar [];
    v_id_obligacion_pago_sg     varchar [];
    v_id_centro_costo_dos       integer;
    v_id_partida                integer;
    v_id_obligacion_det         integer;
    v_ext_liquido_faltante          numeric;  --#7890  
    v_ext_total_ant_parcial         numeric;  --#7890  
    v_ext_total_ant_facturado       numeric ; --#7890  
    v_ext_pendinte_aplicar          numeric;  --#7890  
    v_ext_pendiente_anticipo_ret    numeric;  --#7890  
    v_ext_monto_a_no_comprometer    numeric;  --#7890  
    v_ext_monto_a_comprometer       numeric;  --#7890  
    v_ext_retgar_por_pagar          numeric;  --#7890  
    v_monto_pro_total               numeric;  --#7890 
    v_monto_od_mo                   numeric;  --#7890
    v_monto_od_mb                   numeric;  --#7890
    v_comprometer_iva               varchar;  --#12
    v_id_gestion                    integer; --#12
  
	
BEGIN
	  
      v_nombre_funcion = 'tes.f_extender_obligacion';
      --------------------------------------
      -- verificar que no este extendida
      --------------------------------------

      Select *
      into v_registros
      from tes.tobligacion_pago op
      where op.id_obligacion_pago = p_id_obligacion_pago;

      --validar que el estado de la obligacion sea finaliza
      IF v_registros.estado not in ('finalizado') THEN
        raise exception
        'No se permiten obligaciones de pago que no esten finalizadas';
      END IF;

      --validar que no tenga extenciones
      IF v_registros.id_obligacion_pago_extendida is not null THEN
        raise exception 'la obligacion de pago ya fue extendida';
      END IF;
      
      
      
      ---------------------------------------------------------------------------------------------------
      --  #12  considerar si marcamos o no el campo de comprometer iva para la obligacion extendidad
      --------------------------------------------------------------------------------------------------
      v_comprometer_iva = v_registros.comprometer_iva; --valor por defecto
      
      
     
      ------------------------------
      -- copiar obligacion de pago
      ------------------------------

      v_date = now()::Date;
      v_anho = (date_part('year', v_registros.fecha))::integer;
      v_anho = v_anho  + 1;

      IF (v_anho||'-1-1')::date > v_date THEN
        v_date = (v_anho::varchar||'-1-1')::Date;
      END IF;
      
      --#12 validar gestion 
      SELECT per.id_gestion INTO v_id_gestion 
      FROM param.tperiodo per
      WHERE  per.fecha_ini <= v_date and per.fecha_fin >= v_date;  
      
      IF v_id_gestion is null THEN
         raise exception 'No se encontre una gestion abierta para la fecha % ',v_date;
      END IF;
      
      --verificar si existe una sigueinte gestion apra el proceso

      v_hstore_registros =   hstore(ARRAY[
        'fecha',v_date::varchar,
        'tipo_obligacion', 'pago_directo',
        'id_funcionario',v_registros.id_funcionario::varchar,
        '_id_usuario_ai',p_id_usuario_ai::varchar,
        '_nombre_usuario_ai',p_nombre_usuario_ai::varchar,
        'id_depto',v_registros.id_depto::varchar,
        'obs','Extiende el tramite: '||v_registros.num_tramite||',  Obs:  '||
        v_registros.obs,
        'id_proveedor',v_registros.id_proveedor::varchar,      
        'id_moneda',v_registros.id_moneda::varchar,
        'tipo_cambio_conv',v_registros.tipo_cambio_conv::varchar,
        'pago_variable',v_registros.pago_variable::varchar,
        'total_nro_cuota',v_registros.total_nro_cuota::varchar,
        'fecha_pp_ini',v_registros.fecha_pp_ini::varchar,
        'rotacion',v_registros.rotacion::varchar,
        'id_plantilla',v_registros.id_plantilla::varchar,
        'tipo_anticipo',v_registros.tipo_anticipo::varchar,
        'id_contrato',v_registros.id_contrato::varchar,  ---#7890  manda contrato para la obligacion extendida id_contrato
        'extendida', 'si',  --#7890  indica que se esta extendiendo
        'id_obligacion_pago_ext', p_id_obligacion_pago::varchar,  --#7890  id_obligacion_pago_original
        'comprometer_iva', v_comprometer_iva::varchar --#12
        ]);

      v_resp = tes.f_inserta_obligacion_pago(p_administrador, p_id_usuario,  hstore(v_hstore_registros));
      v_id_obligacion_pago_sg =  pxp.f_recupera_clave(v_resp, 'id_obligacion_pago');
      v_id_gestion_sg =  pxp.f_recupera_clave(v_resp, 'id_gestion');
      
      -------------------------------------------------------------------
      -- #7890   DETERMINAN SALDO  POR  PAGAR PARA LA SIGUEINTE GESTION
      -------------------------------------------------------------------
              
        -- Chequear si tiene dev de garantia pendientes,
        v_ext_retgar_por_pagar = 0;
        v_ext_retgar_por_pagar = tes.f_determinar_total_faltante( p_id_obligacion_pago,'dev_garantia');

        -- chequear si tiene retenciones pendientes de anticipos parciales
        v_ext_pendiente_anticipo_ret = 0;
        v_ext_pendiente_anticipo_ret = tes.f_determinar_total_faltante(p_id_obligacion_pago,'ant_parcial_descontado');
        
        --anticipo registrados
        select 
           sum(pp.monto)
        into
           v_ext_total_ant_parcial
        from tes.tplan_pago pp
        where  pp.estado_reg='activo'  
                and pp.tipo in('ant_parcial')
                and pp.id_obligacion_pago = p_id_obligacion_pago; --recupera los anticipos registrados para la obligacion que se extiende
              
       
      --  #7890  actuliza variables en la obligacion extendida       
       update tes.tobligacion_pago  set 
          monto_ajuste_ret_garantia_ga = COALESCE(v_ext_retgar_por_pagar, 0),
          monto_ajuste_ret_anticipo_par_ga = COALESCE(v_ext_pendiente_anticipo_ret, 0),
          pedido_sap = v_registros.pedido_sap,
          monto_total_adjudicado = v_registros.total_pago,
          total_anticipo = v_ext_total_ant_parcial  + COALESCE(v_registros.total_anticipo,0)   --suma anticipos registrados (Gestion Actual) +  posibles anticipos previos (gestion anterios), en caso de tener mas de dos gestion
       where id_obligacion_pago = v_id_obligacion_pago_sg[1]::integer;
       
      
      --------------------------------------------------------------------------------------------
      -- copiar detalle de obligacion , verifican la tabla id_presupuestos_ids si existe se copia...
      ------------------------------------------------------------------------------------------------
      FOR  v_registros_det in (
      SELECT od.id_obligacion_det,
             od.id_concepto_ingas,
             od.id_centro_costo,
             od.id_partida,
             od.descripcion,
             od.monto_pago_mo,
             od.id_orden_trabajo,
             od.monto_pago_mb,
             tcc.codigo
      FROM tes.tobligacion_det od
      JOIN param.tcentro_costo cc ON cc.id_centro_costo=od.id_centro_costo
      JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc=cc.id_tipo_cc
      where od.estado_reg = 'activo' and
            od.id_obligacion_pago = p_id_obligacion_pago)
      LOOP
      
      

        --recueprar centro de cotos para la siguiente gestion  (los centro de cosots y presupeustos tiene los mismo IDS)

        select pi.id_presupuesto_dos
        into v_id_centro_costo_dos
        from pre.tpresupuesto_ids pi
        where pi.id_presupuesto_uno = v_registros_det.id_centro_costo;
        
        --7890 add validacion
        IF v_id_centro_costo_dos is NULL  THEN
          raise exception 'No se encontro centro de costo equivalente en la siguiente gestion para el centro %' , v_registros_det.codigo;--#18
        END IF;
        

        IF v_id_centro_costo_dos is not NULL THEN
          
          SELECT ps_id_partida
          into v_id_partida
          FROM conta.f_get_config_relacion_contable('CUECOMP', v_id_gestion_sg [
            1 ]::integer, v_registros_det.id_concepto_ingas,
            v_id_centro_costo_dos);
            
            --7890 add validacion
            IF v_id_partida is NULL  THEN
              raise exception 'No se encontro relacion contable para la siguiente gestion , concepto de gasto id %, CC id %' ,v_registros_det.id_concepto_ingas, v_id_centro_costo_dos;          
            END IF;
            
            --------------------------------------------------------------------------
            --  7890  determinar diferencia por prorratear..... segun precio adjudicado
            --------------------------------------------------------------------------
            --caculamos la suma total del monto prorrateado para el item en la gestion actual
            select
                sum(pro.monto_ejecutar_mo)   into v_monto_pro_total
            from tes.tprorrateo pro
            inner join tes.tplan_pago pp on pp.id_plan_pago = pro.id_plan_pago
            where     pro.id_obligacion_det = v_registros_det.id_obligacion_det
                  and pp.tipo in('devengado','devengado_pagado','devengado_pagado_1c')
                  and  pro.estado_reg = 'activo' and pp.estado_reg = 'activo' ;
                  
            IF v_registros_det.monto_pago_mo  - COALESCE(v_monto_pro_total, 0) > 0 THEN
               v_monto_od_mo =  v_registros_det.monto_pago_mo  - COALESCE(v_monto_pro_total,0);
            ELSE
               v_monto_od_mo = 0; 
            END IF;
            
            v_monto_od_mb  = param.f_convertir_moneda(
                                                       v_registros.id_moneda,
                                                       NULL,   --por defecto moenda base
                                                       v_monto_od_mo,
                                                       v_registros.fecha, --#7890  OJO  no estoy seguro de la fecha que deberiamos usar...... v_date,
                                                       'O',-- tipo oficial, venta, compra
                                                       NULL);--defecto dos decimales
            
            

          --Sentencia de la insercion

          insert into tes.tobligacion_det(estado_reg,
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
                      id_orden_trabajo)
          values ('activo',
                   --v_parametros.id_cuenta,
                   v_id_partida,
                   --v_parametros.id_auxiliar,
                   v_registros_det.id_concepto_ingas,
                   v_monto_od_mo,    --7890
                   v_id_obligacion_pago_sg [ 1 ]::integer, 
                   v_id_centro_costo_dos,
                   v_monto_od_mb, 
                   v_registros_det.descripcion,
                   now(), 
                   p_id_usuario, 
                   null,
                   null,
                   v_registros_det.id_orden_trabajo) RETURNING id_obligacion_det
          into v_id_obligacion_det;

        END IF;

      END LOOP;

      --actualiza obligacion extendida en la original  

      update tes.tobligacion_pago
      set id_obligacion_pago_extendida = v_id_obligacion_pago_sg [ 1 ]::integer,
          id_usuario_mod = p_id_usuario,
          fecha_mod = now()
      where id_obligacion_pago = p_id_obligacion_pago;

      -- Definicion de la respuesta
      v_resp = pxp.f_agrega_clave(v_resp,'mensaje',
        'Se extendio la obligacion de pago a la siguiente gestion');
      v_resp = pxp.f_agrega_clave(v_resp,'id_obligacion_pago', p_id_obligacion_pago::varchar);
      
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
COST 100;
