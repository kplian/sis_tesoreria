--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_gestionar_cbte_caja (
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
Fecha:   28 marzo de 2016
Descripcion  Esta funcion gestiona los cbtes de caja cuando son validados

               

*/


DECLARE

	 v_nombre_funcion   			text;
	 v_resp							varchar;
     v_registros 					record;
     v_id_estado_actual  			integer;
     va_id_tipo_estado 				integer[];
     va_codigo_estado 				varchar[];
     va_disparador    				varchar[];
     va_regla        				varchar[]; 
     va_prioridad     				integer[];    
     v_tipo_sol   					varchar;    
     v_nro_cuota 					numeric;    
     v_id_proceso_wf 				integer;
     v_id_estado_wf 				integer;
     v_codigo_estado 				varchar;
     v_id_plan_pago 				integer;
     v_verficacion  				boolean;
     v_verficacion2 				varchar[];     
     v_id_tipo_estado  				integer;
     v_codigo_proceso_llave_wf   	varchar;
	 --gonzalo
     v_id_finalidad					integer;
     v_respuesta_libro_bancos 		varchar;
     v_registros_tpc				record;
     v_codigo_tpc  					varchar;
     v_id_proceso_caja				integer;
     v_id_int_comprobante			integer;
     v_sw_disparo 					boolean;
     v_hstore_registros 			hstore;
     v_tmp_tipo						varchar;
     v_id_solicitud_efectivo		varchar[];
     v_saldo_caja					numeric;
     v_monto						numeric;
     v_registros_cv					record;
     v_num							varchar;

BEGIN

	v_nombre_funcion = 'tes.f_gestionar_cbte_caja';

   -- 1) con el id_comprobante identificar el plan de pago

   select
            pc.id_proceso_caja,
            pc.id_estado_wf,
            pc.id_proceso_wf,
            pc.tipo,
            pc.estado,
            pc.id_proceso_caja_fk,
            pc.id_caja,
            ca.id_depto ,
            pc.id_cuenta_bancaria ,
            pc.fecha,
            pc.monto,
            pc.id_depto_conta,
            tpc.codigo_plantilla_cbte,
            ca.id_depto_lb,
            dpc.prioridad as prioridad_conta,
            dpl.prioridad as prioridad_libro,
            c.temporal,
            c.fecha as fecha_cbte,
            tpc.codigo as codigo_tpc,
            tpc.codigo_wf,
            ew.id_funcionario,
            ew.id_depto,
            pc.id_depto_conta,
            pc.id_gestion,
            pc.nro_tramite,
            pc.motivo,
            pc.fecha_fin,
            pc.fecha_inicio,
            pc.id_gestion
      into
            v_registros

      from  tes.tproceso_caja pc

      inner join tes.ttipo_proceso_caja tpc on tpc.id_tipo_proceso_caja = pc.id_tipo_proceso_caja and tpc.estado_reg = 'activo'
      inner join conta.tint_comprobante  c on c.id_int_comprobante = pc.id_int_comprobante
	  inner join tes.tcaja ca on ca.id_caja = pc.id_caja
      inner join wf.testado_wf ew on ew.id_estado_wf = pc.id_estado_wf
      left join param.tdepto dpc on dpc.id_depto = pc.id_depto_conta
	  left join param.tdepto dpl on dpl.id_depto = ca.id_depto_lb

      where  pc.id_int_comprobante = p_id_int_comprobante;


      --2) Validar que tenga un proceso de caja

     IF  v_registros.id_proceso_caja is NULL  THEN
        raise exception 'El comprobante no esta relacionado con ningun proceso de caja';
     END IF;

    --------------------------------------------------------
    ---  cambiar el estado del proceso de caja         -----
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



              IF va_codigo_estado[2] is not null THEN
                 raise exception 'El proceso de WF esta mal parametrizado,  solo admite un estado siguiente para el estado: %', v_registros.estado;
              END IF;

              IF va_codigo_estado[1] is  null THEN
                 raise exception 'El proceso de WF esta mal parametrizado, no se encuentra el estado siguiente,  para el estado: %', v_registros.estado;
              END IF;

              -- estado siguiente
              v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado[1],
                                                             v_registros.id_funcionario,
                                                             v_registros.id_estado_wf,
                                                             v_registros.id_proceso_wf,
                                                             p_id_usuario,
                                                             p_id_usuario_ai, -- id_usuario_ai
                                                             p_usuario_ai, -- usuario_ai
                                                             v_registros.id_depto_conta,
                                                             'Comprobante validado');
              -- actualiza estado del proceso

              update tes.tproceso_caja pc  set
                           id_estado_wf =  v_id_estado_actual,
                           estado = va_codigo_estado[1],
                           id_usuario_mod=p_id_usuario,
                           fecha_mod=now(),
                           id_usuario_ai = p_id_usuario_ai,
                           usuario_ai = p_usuario_ai
              where pc.id_proceso_caja  = v_registros.id_proceso_caja;


           ----------------------------------------------------------------------------------
           -- 3.1)  si es tipo de rendir y reponer  o rendr y cerrar
           --       asociamos un nuevo proceso de caja en estado
           --       pendiente segun corresponda
           -----------------------------------------------------------------------------------

           IF  v_registros.codigo_tpc in ('RENYREP', 'RENYCER' , 'SOLREN' ) THEN

                      --  relacionar facturas con el comprobante de rendicion
                      FOR v_registros_cv in (
                                      SELECT cv.id_doc_compra_venta,
                                             cv.id_moneda,
                                             pc.fecha as fecha_reversion
                                      FROM conta.tdoc_compra_venta cv
                                      INNER JOIN tes.tsolicitud_rendicion_det rd on rd.id_documento_respaldo=cv.id_doc_compra_venta
                                      inner join tes.tproceso_caja pc on pc.id_proceso_caja = rd.id_proceso_caja
                                       WHERE rd.id_proceso_caja = v_registros.id_proceso_caja) LOOP


                              update conta.tdoc_compra_venta set
                                id_int_comprobante = p_id_int_comprobante
                              where id_doc_compra_venta = v_registros_cv.id_doc_compra_venta;

                       END LOOP;


           END IF;

           IF  v_registros.codigo_tpc in ('RENYREP', 'RENYCER' ) THEN

                       ----------------------------------------------------
                       --  Crear procesos derivados por cierre o reposición
                       ----------------------------------------------------


                       -- TODO obtener array de rendiciones SOLREN (rendiciones sueltas desde la ultima apertura de caja)


                       v_sw_disparo = true;

                       IF  v_registros.codigo_tpc = 'RENYREP' THEN

                           v_codigo_tpc = 'SOLREP';
                           v_monto = v_registros.monto;





                           -- TODO adicionar el monto a rendir


                       ELSE

                          v_codigo_tpc = 'CIERRE';

                          --  calcular si tiene monto para cierre de caja
                          v_saldo_caja =  tes.f_calcular_saldo_caja(v_registros.id_caja);

                          --TODO  sumar montos de deposito
                          -- los depositos tiene que coincidir con el monto de cierre

                          --   IF  si no tiene monto a cerrar se salta el proceso disparado de cierre
                          IF COALESCE(v_saldo_caja,0) = 0 THEN
                             v_sw_disparo = false;
                          ELSE
                             v_sw_disparo = true;
                          END IF;

                          v_monto = v_saldo_caja;

                       END IF;

                       --recuperar el tipo de proceso para reposicion

                        select
                           tpc.id_tipo_proceso_caja,
                           tpc.codigo_plantilla_cbte,
                           tpc.codigo_wf,
                           tpc.codigo
                        into
                          v_registros_tpc
                        from tes.ttipo_proceso_caja tpc
                        where tpc.codigo = v_codigo_tpc;


                       -- Evalua si se dispara el proceso de cierre o reposicion
                       IF v_sw_disparo THEN

                            --  Manejo de estados con el WF

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
                                     v_registros.id_funcionario,
                                     v_registros.id_depto_conta,
                                     v_codigo_tpc,
                                     v_registros_tpc.codigo_wf, --codigo llave
                                    ''
                                    );

                           -- insertar proceso de caja, asociado al proceso de rendicion
                           -- Sentencia de la insercion de la rendicion o reposicion de caja
                            insert into tes.tproceso_caja(
                                estado,
                                nro_tramite,
                                tipo,
                                motivo,
                                estado_reg,
                                fecha_fin,
                                id_caja,
                                fecha,
                                id_proceso_wf,
                                monto,
                                id_estado_wf,
                                fecha_inicio,
                                fecha_reg,
                                usuario_ai,
                                id_usuario_reg,
                                id_usuario_ai,
                                id_tipo_proceso_caja,
                                id_gestion,
                                id_depto_conta,
                                id_cuenta_bancaria,
                                id_proceso_caja_fk
                            ) values(
                                v_codigo_estado,
                                v_registros.nro_tramite,
                                v_registros_tpc.codigo,
                                v_registros.motivo,
                                'activo',
                                v_registros.fecha_fin,
                                v_registros.id_caja,
                                v_registros.fecha,
                                v_id_proceso_wf,
                                v_monto,        -- monto de cierre o reposicion
                                v_id_estado_wf,
                                v_registros.fecha_inicio,
                                now(),
                                p_usuario_ai,
                                p_id_usuario,
                                p_id_usuario_ai,
                                v_registros_tpc.id_tipo_proceso_caja,
                                v_registros.id_gestion,
                                v_registros.id_depto_conta,
                                v_registros.id_cuenta_bancaria,
                                v_registros.id_proceso_caja
                            )RETURNING id_proceso_caja into v_id_proceso_caja;



                            --TODO FOR  insertar referencia a id_proceso_caja_repo, segun array


                              ---------------------------------------------------------------------------
                              --  antes de generar el comprobante pasa al estado vbconta
                              ---------------------------------------------------------------------------
                               select
                                te.id_tipo_estado
                               into
                                v_id_tipo_estado
                               from wf.ttipo_estado te
                               inner join wf.tproceso_wf  pw on pw.id_tipo_proceso = te.id_tipo_proceso
                                  and pw.id_proceso_wf = v_id_proceso_wf
                               where te.codigo = 'vbconta';

                              IF v_id_tipo_estado is  null THEN
                                raise exception 'El proceso de WF esta mal parametrizado, no tiene el estado Visto bueno contabilidad (vbconta) ';
                              END IF;

                              --registrar el siguiente estado detectado  (vbconta)
                              v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado,
                                                                           v_registros.id_funcionario,
                                                                           v_id_estado_wf,
                                                                           v_id_proceso_wf,
                                                                           p_id_usuario,
                                                                           p_id_usuario_ai,
                                                                           p_usuario_ai,
                                                                           v_registros.id_depto,
                                                                           'para revisión de contabiliad');

                              ---------------------------------------------------------------------------
                              -- antes de generar el comprobante pasa al estado pendiente
                              ---------------------------------------------------------------------------

                               select
                                te.id_tipo_estado
                               into
                                v_id_tipo_estado
                               from wf.ttipo_estado te
                               inner join wf.tproceso_wf  pw on pw.id_tipo_proceso = te.id_tipo_proceso
                                  and pw.id_proceso_wf = v_id_proceso_wf
                               where te.codigo = 'pendiente';

                              IF v_id_tipo_estado is  null THEN
                                raise exception 'El proceso de WF esta mal parametrizado, no tiene el estado Pendiente ';
                              END IF;

                              --registrar el siguiente estado detectado  (vbconta)
                              v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado,
                                                                           v_registros.id_funcionario,
                                                                           v_id_estado_actual,
                                                                           v_id_proceso_wf,
                                                                           p_id_usuario,
                                                                           p_id_usuario_ai,
                                                                           p_usuario_ai,
                                                                           v_registros.id_depto,
                                                                           'cbte generado');


                               --actualiza el nuevo estado para el nuevo pago
                               update tes.tproceso_caja pc  set
                                     id_estado_wf =  v_id_estado_actual,
                                     estado = 'pendiente'
                               where pc.id_proceso_caja  = v_id_proceso_caja;

                             -------------------------------------------------
                             -- solicitar negeracion de comprobantes de pago
                             -------------------------------------------------

                             v_id_int_comprobante =   conta.f_gen_comprobante (
                                                           v_id_proceso_caja ,
                                                           v_registros_tpc.codigo_plantilla_cbte ,
                                                           v_id_estado_actual,
                                                           p_id_usuario,
                                                           p_id_usuario_ai,
                                                           p_usuario_ai,
                                                           p_conexion);

                             update tes.tproceso_caja  pc set
                                id_int_comprobante = v_id_int_comprobante
                             where pc.id_proceso_caja  = v_id_proceso_caja;

                  ELSE
                       IF  v_registros.codigo_tpc = 'RENYCER'  THEN

                            --si el proceso es de rendir y cerrar, perto no hay monto para cerrar
                            --  cerramos directamente la caja
                            update tes.tcaja ca set
                              estado = 'cerrado',
                              fecha_cierre = v_registros.fecha_cbte
                            where ca.id_caja = v_registros.id_caja;


                       END IF;
                  END IF;

           END IF;


           ------------------------------------------
           -- si el comprobante es tipo reposicion
           ------------------------------------------

           IF   v_registros.codigo_tpc ='REPO' or  v_registros.codigo_tpc = 'SOLREP'  THEN



               IF  v_registros.id_proceso_caja_fk  is  null  THEN

                   IF  v_registros.codigo_tpc = 'REPO' THEN
                       v_tmp_tipo = 'apertura_caja';
                       --   abrimo la caja
                       update tes.tcaja ca set
                          estado = 'abierto',
                          fecha_apertura = v_registros.fecha_cbte
                       where ca.id_caja = v_registros.id_caja;

                       v_num =   param.f_obtener_correlativo(
                          'MEMOCCH',
                           v_registros.id_gestion,-- par_id,
                           NULL, --id_uo
                           v_registros.id_depto,    -- id_depto
                           p_id_usuario,
                           'CCH',
                           NULL);

                        update tes.tproceso_caja pc set
                          num_memo = v_num
                        where id_proceso_caja = v_registros.id_proceso_caja;

                   ELSE
                       v_tmp_tipo = 'ingreso_caja';
                   END IF;

               ELSE
                 	v_tmp_tipo = 'ingreso_caja';
               END IF;

                v_monto = v_registros.monto;



                --  registro de repoisicion para arqueos
                v_hstore_registros =   hstore(ARRAY[
                                                  'id_caja', v_registros.id_caja::varchar,
                                                  'monto',  v_monto::varchar,
                                                  'id_funcionario', v_registros.id_funcionario::varchar,
                                                  'tipo_solicitud', v_tmp_tipo::varchar,
                                                  'fecha',v_registros.fecha::varchar,
                                                  'motivo', v_registros.motivo::varchar
                                                ]);

                v_resp=tes.f_inserta_solicitud_efectivo(0,p_id_usuario,v_hstore_registros);
                v_id_solicitud_efectivo =  pxp.f_recupera_clave(v_resp, 'id_solicitud_efectivo');
               --guardamos la relacion
               update tes.tproceso_caja  set
                  id_solicitud_efectivo_rel = v_id_solicitud_efectivo[1]::integer
               where id_proceso_caja = v_registros.id_proceso_caja;


           END IF;



           --------------------------------------------------------
           -- si el comprobante es de tipo cierre cerramos la caja
		   --------------------------------------------------------


             IF   v_registros.codigo_tpc = 'CIERRE' THEN

               update tes.tcaja ca set
                  estado = 'cerrado',
                  fecha_cierre = v_registros.fecha_cbte
               where ca.id_caja = v_registros.id_caja;


               -- obtenemos el monto del cierre
               v_monto = v_registros.monto;

               IF v_monto > 0 THEN
                    --  si hay monto de cierre introduce el valor para arqueos
                    v_tmp_tipo = 'salida_caja';
                    --  registro de reposicion para arqueos
                    v_hstore_registros =   hstore(ARRAY[
                                                      'id_caja', v_registros.id_caja::varchar,
                                                      'monto',  v_monto::varchar,
                                                      'id_funcionario', v_registros.id_funcionario::varchar,
                                                      'tipo_solicitud', v_tmp_tipo::varchar,
                                                      'fecha',v_registros.fecha::varchar,
                                                      'motivo', v_registros.motivo::varchar
                                                    ]);

                    v_resp = tes.f_inserta_solicitud_efectivo(0,p_id_usuario,v_hstore_registros);
                    v_id_solicitud_efectivo = pxp.f_recupera_clave(v_resp,'id_solicitud_efectivo');
               END IF;

               --guardamos la relacion
               update tes.tproceso_caja  set
                  id_solicitud_efectivo_rel = v_id_solicitud_efectivo[1]::integer
               where id_proceso_caja = v_id_proceso_caja;
               
           END IF;

  
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
COST 100;