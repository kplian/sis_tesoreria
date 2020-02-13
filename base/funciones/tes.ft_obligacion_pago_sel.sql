CREATE OR REPLACE FUNCTION tes.ft_obligacion_pago_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.ft_obligacion_pago_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tobligacion_pago'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        02-04-2013 16:01:32
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
 HISTORIAL DE MODIFICACIONES:

 ISSUE            FECHA:		      AUTOR                                DESCRIPCION
 #0       		  02-04-2013     Gonzalo Sarmiento Sejas (KPLIAN)    creación
 #7890            18/12/2018     RAC KPLIAN                          Se incluye la bandera que muestra que una obligacion a sido forzada a finalizar en los listados de obligaciones de pago
 #12        	  10/01/2019     MMV ENDETRAN       Considerar restar el iva al comprometer obligaciones de pago
 #16              16/01/2019     MMV ENDETRAN      					 Incluir comprometer al 100% pago único sin contrato
 #48              31/01/2020     JJA ENDETRAN                        Agregar tipo de relación en obligacion de pago
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_filadd 			varchar;
    va_id_depto 		integer[];
    v_obligaciones      record;
    v_obligaciones_partida	record;
    v_respuesta_verificar	record;
    v_inner 			varchar;
    v_historico         varchar;
    v_strg_sol			varchar;
    v_id_clase_comprobante	integer;

    --variables reporte certificacion presupuestaria
    v_record_op					record;
    v_index						integer;
    v_record					record;
    v_record_funcionario		record;
    v_firmas					varchar[];
    v_firma_fun					varchar;
    v_nombre_entidad			varchar;
    v_direccion_admin			varchar;
    v_unidad_ejecutora			varchar;
    v_cod_proceso				varchar;
    v_cont						integer;
    v_gerencia					varchar;
    v_id_funcionario			integer;

BEGIN

	v_nombre_funcion = 'tes.ft_obligacion_pago_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'TES_OBPG_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		02-04-2013 16:01:32
	***********************************/

	if(p_transaccion='TES_OBPG_SEL')then

    	begin

          v_filadd='';
          v_inner='';
          v_strg_sol = 'obpg.id_obligacion_pago';

          IF  pxp.f_existe_parametro(p_tabla,'historico') THEN
             v_historico =  v_parametros.historico;
          ELSE
            v_historico = 'no';
          END IF;


         IF   v_parametros.tipo_interfaz in ('obligacionPagoTes','obligacionPagoUnico') THEN

                 IF   p_administrador != 1 THEN

                   select
                       pxp.aggarray(depu.id_depto)
                    into
                       va_id_depto
                   from param.tdepto_usuario depu
                   where depu.id_usuario =  p_id_usuario;

                 v_filadd='(obpg.id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||')) and';

                END IF;


                IF   v_parametros.tipo_interfaz  = 'obligacionPagoUnico' THEN
                   v_filadd=v_filadd ||' obpg.tipo_obligacion = ''pago_unico'' and';
                ELSE
                   v_filadd=v_filadd ||' obpg.tipo_obligacion in (''pago_directo'',''rrhh'') and';
                END IF;



         ELSIF  v_parametros.tipo_interfaz =  'ObligacionPagoVb' THEN


              IF v_historico =  'si' THEN
                    v_inner =  '  inner join wf.testado_wf ew on ew.id_proceso_wf = obpg.id_proceso_wf  ';
                    v_strg_sol = 'DISTINCT(obpg.id_obligacion_pago)';
               ELSE
                     v_inner =  'inner join wf.testado_wf ew on ew.id_estado_wf = obpg.id_estado_wf';


                  IF p_administrador !=1 THEN

                      v_filadd = ' (ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (lower(obpg.estado) not in (''borrador'',''en_pago'',''registrado'',''finalizado'',''anulado'')) and ';
                  ELSE
                      v_filadd = ' (lower(obpg.estado) not in (''borrador'',''en_pago'',''registrado'',''finalizado'',''anulado'')) and ';
                  END IF;
              END IF;



         ELSIF  v_parametros.tipo_interfaz =  'ObligacionPagoVbPoa' THEN

              IF v_historico = 'no' THEN
                 v_filadd=' (obpg.estado = ''vbpoa'') and';
              ELSE
                 v_filadd=' (obpg.estado not in  (''borrador'')) and';
              END IF;

         ELSIF v_parametros.tipo_interfaz =  'ObligacionPagoConsulta' THEN
            --no hay limitaciones ...
         ELSIF v_parametros.tipo_interfaz =  'ObligacionPagoApropiacion' THEN
            --no hay limitaciones ...
         ELSIF v_parametros.tipo_interfaz =  'ObligacionPagoConta' THEN
            --no hay limitaciones ...
         ELSE

              -- SI LA NTERFACE VIENE DE ADQUISIONES

              IF   p_administrador != 1 THEN
                   select
                         pxp.aggarray(depu.id_depto)
                      into
                         va_id_depto
                     from param.tdepto_usuario depu
                     where depu.id_usuario =  p_id_usuario and depu.cargo = 'responsable';


                     v_filadd='( (pc.id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||'))   or   pc.id_usuario_auxiliar = '||p_id_usuario::varchar ||' or obpg.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and ';
              END IF;


              v_inner = '
                            inner join adq.tcotizacion cot on cot.id_obligacion_pago = obpg.id_obligacion_pago
                            inner join adq.tproceso_compra pc on pc.id_proceso_compra = cot.id_proceso_compra  ';
        END IF;



                  --Sentencia de la consulta
                  v_consulta:='select
                              '||v_strg_sol||',
                              obpg.id_proveedor,
                              pv.desc_proveedor,
                              obpg.estado,
                              obpg.tipo_obligacion,
                              obpg.id_moneda,
                              mn.moneda,
                              obpg.obs,
                              obpg.porc_retgar,
                              obpg.id_subsistema,
                              ss.nombre as nombre_subsistema,
                              obpg.id_funcionario,
                              fun.desc_funcionario1,
                              obpg.estado_reg,
                              obpg.porc_anticipo,
                              obpg.id_estado_wf,
                              obpg.id_depto,
                              dep.nombre as nombre_depto,
                              obpg.num_tramite,
                              obpg.id_proceso_wf,
                              obpg.fecha_reg,
                              obpg.id_usuario_reg,
                              obpg.fecha_mod,
                              obpg.id_usuario_mod,
                              usu1.cuenta as usr_reg,
                              usu2.cuenta as usr_mod,
                              obpg.fecha,
                              obpg.numero,
                              obpg.tipo_cambio_conv,
                              obpg.id_gestion,
                              obpg.comprometido,
                              obpg.nro_cuota_vigente,
                              mn.tipo_moneda,
                              COALESCE(obpg.total_pago,0) as total_pago,
                              obpg.pago_variable,
                              obpg.id_depto_conta,
                              obpg.total_nro_cuota,
                              obpg.fecha_pp_ini,
                              obpg.rotacion,
                              obpg.id_plantilla,
                              pla.desc_plantilla,
                              obpg.ultima_cuota_pp,
                              obpg.ultimo_estado_pp,
                              obpg.tipo_anticipo,
                              obpg.ajuste_anticipo,
                              obpg.ajuste_aplicado,
                              obpg.monto_estimado_sg,
                              obpg.id_obligacion_pago_extendida,
                              con.tipo||'' - ''||con.numero::varchar as desc_contrato,
                              con.id_contrato,
                              obpg.obs_presupuestos,
                              obpg.codigo_poa,
                              obpg.obs_poa,
                              obpg.uo_ex,
                              obpg.id_funcionario_responsable,
							  fresp.desc_funcionario1 AS desc_fun_responsable,
                              obpg.monto_ajuste_ret_garantia_ga,
                              obpg.monto_ajuste_ret_anticipo_par_ga,
                              obpg.monto_total_adjudicado,
                              obpg.total_anticipo,
                              obpg.pedido_sap,
                              obpg.fin_forzado,   --#7890
                              obpg.monto_sg_mo,    --#7890
							  obpg.comprometer_iva	 --#12
                              from tes.tobligacion_pago obpg
                              inner join segu.tusuario usu1 on usu1.id_usuario = obpg.id_usuario_reg
                              left join segu.tusuario usu2 on usu2.id_usuario = obpg.id_usuario_mod
                              inner join param.tmoneda mn on mn.id_moneda=obpg.id_moneda
                              inner join segu.tsubsistema ss on ss.id_subsistema=obpg.id_subsistema
                              inner join param.tdepto dep on dep.id_depto=obpg.id_depto
                              left join param.vproveedor pv on pv.id_proveedor=obpg.id_proveedor
                              left join leg.tcontrato con on con.id_contrato = obpg.id_contrato
                              left join param.tplantilla pla on pla.id_plantilla = obpg.id_plantilla
                              '||v_inner ||'
                              left join orga.vfuncionario fun on fun.id_funcionario=obpg.id_funcionario
                              left join orga.vfuncionario fresp ON fresp.id_funcionario = obpg.id_funcionario_responsable
                              where  '||v_filadd;

                  --Definicion de la respuesta
                  v_consulta:=v_consulta||v_parametros.filtro;
                  v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;



          --raise notice 'err %',v_consulta;
          --raise EXCEPTION 'error provocado %',v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;


    /*********************************
 	#TRANSACCION:  'TES_OBPG_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		02-04-2013 16:01:32
	***********************************/

	elsif(p_transaccion='TES_OBPG_CONT')then

		begin

              v_filadd='';
              v_inner='';
              v_strg_sol = 'obpg.id_obligacion_pago';

              IF  pxp.f_existe_parametro(p_tabla,'historico') THEN
                 v_historico =  v_parametros.historico;
              ELSE
                v_historico = 'no';
              END IF;


             IF   v_parametros.tipo_interfaz in ('obligacionPagoTes','obligacionPagoUnico') THEN

                     IF   p_administrador != 1 THEN

                       select
                           pxp.aggarray(depu.id_depto)
                        into
                           va_id_depto
                       from param.tdepto_usuario depu
                       where depu.id_usuario =  p_id_usuario;

                     v_filadd='(obpg.id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||')) and';

                    END IF;


                    IF   v_parametros.tipo_interfaz  = 'obligacionPagoUnico' THEN
                       v_filadd=v_filadd ||' obpg.tipo_obligacion = ''pago_unico'' and';
                    ELSE
                       v_filadd=v_filadd ||' obpg.tipo_obligacion in (''pago_directo'',''rrhh'') and';
                    END IF;



             ELSIF  v_parametros.tipo_interfaz =  'ObligacionPagoVb' THEN


                  IF v_historico =  'si' THEN
                        v_inner =  '  inner join wf.testado_wf ew on ew.id_proceso_wf = obpg.id_proceso_wf  ';
                        v_strg_sol = 'DISTINCT(obpg.id_obligacion_pago)';
                   ELSE
                         v_inner =  'inner join wf.testado_wf ew on ew.id_estado_wf = obpg.id_estado_wf';


                    IF p_administrador !=1 THEN
                        v_filadd = ' (ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (lower(obpg.estado) not in (''borrador'',''en_pago'',''registrado'',''finalizado'',''anulado'')) and ';
                    ELSE
                        v_filadd = ' (lower(obpg.estado) not in (''borrador'',''en_pago'',''registrado'',''finalizado'',''anulado'')) and ';
                    END IF;


                  END IF;

             ELSIF  v_parametros.tipo_interfaz =  'ObligacionPagoVbPoa' THEN

                  IF v_historico = 'no' THEN
                     v_filadd=' (obpg.estado = ''vbpoa'') and';
                  ELSE
                     v_filadd=' (obpg.estado not in  (''borrador'')) and';
                  END IF;

             ELSIF v_parametros.tipo_interfaz =  'ObligacionPagoConsulta' THEN
                --no hay limitaciones ...
             ELSIF v_parametros.tipo_interfaz =  'ObligacionPagoApropiacion' THEN
                --no hay limitaciones ...
             ELSIF v_parametros.tipo_interfaz =  'ObligacionPagoConta' THEN
                --no hay limitaciones ...
             ELSE

                  -- SI LA NTERFACE VIENE DE ADQUISIONES

                  IF   p_administrador != 1 THEN
                       select
                             pxp.aggarray(depu.id_depto)
                          into
                             va_id_depto
                         from param.tdepto_usuario depu
                         where depu.id_usuario =  p_id_usuario and depu.cargo = 'responsable';


                         v_filadd='( (pc.id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||'))   or   pc.id_usuario_auxiliar = '||p_id_usuario::varchar ||' ) and ';
                  END IF;


                  v_inner = '
                                inner join adq.tcotizacion cot on cot.id_obligacion_pago = obpg.id_obligacion_pago
                                inner join adq.tproceso_compra pc on pc.id_proceso_compra = cot.id_proceso_compra  ';
            END IF;


			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count('||v_strg_sol||')
					    from tes.tobligacion_pago obpg
						inner join segu.tusuario usu1 on usu1.id_usuario = obpg.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = obpg.id_usuario_mod
                        inner join param.tmoneda mn on mn.id_moneda=obpg.id_moneda
                        inner join segu.tsubsistema ss on ss.id_subsistema=obpg.id_subsistema
                        inner join param.tdepto dep on dep.id_depto=obpg.id_depto
                        left join param.vproveedor pv on pv.id_proveedor=obpg.id_proveedor
                        left join leg.tcontrato con on con.id_contrato = obpg.id_contrato
                        left join param.tplantilla pla on pla.id_plantilla = obpg.id_plantilla
                        '|| v_inner ||'
                        left join orga.vfuncionario fun on fun.id_funcionario=obpg.id_funcionario
                        left join orga.vfuncionario fresp ON fresp.id_funcionario = obpg.id_funcionario_responsable
                        where  '||v_filadd;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta

            raise notice '%',v_consulta;
			return v_consulta;

		end;

    /*********************************
 	#TRANSACCION:  'TES_OBPGSOL_SEL'
 	#DESCRIPCION:	Consulta de obligaciones de pagos por solicitante
 	#AUTOR:	Rensi Arteaga Copari
 	#FECHA:		08-05-2014 16:01:32
	***********************************/

	elsif(p_transaccion='TES_OBPGSOL_SEL')then

    	begin

          v_filadd='';
          v_inner='';


          IF  v_parametros.tipo_interfaz !=  'ObligacionPagoConta' THEN
            --no hay limitaciones ...
            IF   p_administrador != 1 THEN
                   v_filadd = '(obpg.id_funcionario='||v_parametros.id_funcionario_usu::varchar||'  or obpg.id_usuario_reg='||p_id_usuario||' ) and ';
            END IF;
          END IF;

         IF  v_parametros.tipo_interfaz in ('obligacionPagoSol', 'obligacionPagoUnico','obligacionPagoEspecial') THEN

                IF   v_parametros.tipo_interfaz  = 'obligacionPagoUnico' THEN
                   v_filadd=v_filadd ||' obpg.tipo_obligacion = ''pago_unico'' and ';

                ELSIF   v_parametros.tipo_interfaz  = 'obligacionPagoEspecial' THEN
                   v_filadd=v_filadd ||' obpg.tipo_obligacion = ''pago_especial'' and ';
                ELSE
                   v_filadd=v_filadd ||' obpg.tipo_obligacion in (''pago_directo'',''rrhh'') and';
                END IF;



         END IF;

         -- raise exception '(%),... %', v_parametros.tipo_interfaz, v_filadd;

                  --Sentencia de la consulta
                  v_consulta:='select
                              obpg.id_obligacion_pago,
                              obpg.id_proveedor,
                              pv.desc_proveedor,
                              obpg.estado,
                              obpg.tipo_obligacion,
                              obpg.id_moneda,
                              mn.moneda,
                              obpg.obs,
                              obpg.porc_retgar,
                              obpg.id_subsistema,
                              ss.nombre as nombre_subsistema,
                              obpg.id_funcionario,
                              fun.desc_funcionario1,
                              obpg.estado_reg,
                              obpg.porc_anticipo,
                              obpg.id_estado_wf,
                              obpg.id_depto,
                              dep.nombre as nombre_depto,
                              obpg.num_tramite,
                              obpg.id_proceso_wf,
                              obpg.fecha_reg,
                              obpg.id_usuario_reg,
                              obpg.fecha_mod,
                              obpg.id_usuario_mod,
                              usu1.cuenta as usr_reg,
                              usu2.cuenta as usr_mod,
                              obpg.fecha,
                              obpg.numero,
                              obpg.tipo_cambio_conv,
                              obpg.id_gestion,
                              obpg.comprometido,
                              obpg.nro_cuota_vigente,
                              mn.tipo_moneda,
                              COALESCE(obpg.total_pago,0) as total_pago,
                              obpg.pago_variable,
                              obpg.id_depto_conta,
                              obpg.total_nro_cuota,
                              obpg.fecha_pp_ini,
                              obpg.rotacion,
                              obpg.id_plantilla,
                              pla.desc_plantilla,
                              fun.desc_funcionario1 as desc_funcionario,
                              obpg.ultima_cuota_pp,
                              obpg.ultimo_estado_pp,
                              obpg.tipo_anticipo,
                              obpg.ajuste_anticipo,
                              obpg.ajuste_aplicado,
                              obpg.monto_estimado_sg,
                              obpg.id_obligacion_pago_extendida,
                              con.tipo||'' - ''||con.numero::varchar as desc_contrato,
                              con.id_contrato,
                              obpg.obs_presupuestos,
                              obpg.uo_ex,
                              obpg.monto_total_adjudicado,
                              obpg.total_anticipo,
                              obpg.monto_ajuste_ret_anticipo_par_ga,
                              obpg.monto_ajuste_ret_garantia_ga,
                              obpg.pedido_sap,                              
                              obpg.fin_forzado,   --#7890
                              obpg.monto_sg_mo,    --#7890
                              obpg.comprometer_iva,	  --#16

                              obpg.cod_tipo_relacion, --#48
                              opr.id_obligacion_pago_extendida as id_obligacion_pago_extendida_relacion, --#48
                              opr.num_tramite::varchar as desc_obligacion_pago --#48
                              from tes.tobligacion_pago obpg
                              left join tes.tobligacion_pago opr on opr.id_obligacion_pago_extendida=obpg.id_obligacion_pago --#48
                              inner join segu.tusuario usu1 on usu1.id_usuario = obpg.id_usuario_reg
                              left join segu.tusuario usu2 on usu2.id_usuario = obpg.id_usuario_mod
                              left join param.vproveedor pv on pv.id_proveedor=obpg.id_proveedor
                              inner join param.tmoneda mn on mn.id_moneda=obpg.id_moneda
                              inner join segu.tsubsistema ss on ss.id_subsistema=obpg.id_subsistema
                              inner join param.tdepto dep on dep.id_depto=obpg.id_depto
                              left join param.tplantilla pla on pla.id_plantilla = obpg.id_plantilla
                              inner join orga.vfuncionario fun on fun.id_funcionario=obpg.id_funcionario
                              left join leg.tcontrato con on con.id_contrato = obpg.id_contrato
                              where  '||v_filadd;

                  --Definicion de la respuesta
                  v_consulta:=v_consulta||v_parametros.filtro;
                  v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;







              raise notice 'SSS %',v_consulta;
			--Devuelve la respuesta
           -- RAISE EXCEPTION 'consulta atrapado %',v_consulta;
			return v_consulta;

		end;

     /*********************************
 	#TRANSACCION:  'TES_OBPGSOL_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:	 RAC (KPLIAN)
 	#FECHA:		04-05-2014 16:01:32
	***********************************/

	elsif(p_transaccion='TES_OBPGSOL_CONT')then

		begin

            v_filadd='';
            v_inner='';

             IF  v_parametros.tipo_interfaz !=  'ObligacionPagoConta' THEN
                --no hay limitaciones ...
                IF   p_administrador != 1 THEN
                       v_filadd = '(obpg.id_funcionario='||v_parametros.id_funcionario_usu::varchar||'  or obpg.id_usuario_reg='||p_id_usuario||' ) and ';
                END IF;
             END IF;

             IF  v_parametros.tipo_interfaz in ('obligacionPagoSol', 'obligacionPagoUnico','obligacionPagoEspecial') THEN

                  IF   v_parametros.tipo_interfaz  = 'obligacionPagoUnico' THEN
                     v_filadd=v_filadd ||' obpg.tipo_obligacion = ''pago_unico'' and ';
                  ELSIF   v_parametros.tipo_interfaz  = 'obligacionPagoEspecial' THEN
                   v_filadd=v_filadd ||' obpg.tipo_obligacion = ''pago_especial'' and ';
                  ELSE
                     v_filadd=v_filadd ||' obpg.tipo_obligacion in (''pago_directo'',''rrhh'') and';
                  END IF;
             END IF ;

			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(obpg.id_obligacion_pago)
					    from tes.tobligacion_pago obpg
						inner join segu.tusuario usu1 on usu1.id_usuario = obpg.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = obpg.id_usuario_mod
                        left join param.vproveedor pv on pv.id_proveedor=obpg.id_proveedor
                        inner join param.tmoneda mn on mn.id_moneda=obpg.id_moneda
                        inner join segu.tsubsistema ss on ss.id_subsistema=obpg.id_subsistema
						inner join param.tdepto dep on dep.id_depto=obpg.id_depto
                        inner join orga.vfuncionario fun on fun.id_funcionario=obpg.id_funcionario
                        left join leg.tcontrato con on con.id_contrato = obpg.id_contrato
                        where  '||v_filadd;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta

            raise notice '%',v_consulta;
			return v_consulta;

		end;

   /*********************************
 	#TRANSACCION:  'TES_ESTOBPG_SEL'
 	#DESCRIPCION:	Consulta de registros para los reportes
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		31-05-2013
	***********************************/
	elsif (p_transaccion='TES_ESTOBPG_SEL')then
    	begin
         create temporary table flujo_obligaciones(
        	funcionario text,
            nombre text,
            nombre_estado varchar,
            fecha_reg date,
            id_tipo_estado int4,
            id_estado_wf int4,
            id_estado_anterior int4
        ) on commit drop;

    	--recupera el flujo de control de las obligaciones

    	FOR v_obligaciones IN(
            select op.id_estado_wf
            from tes.tobligacion_pago op
            where op.id_obligacion_pago=v_parametros.id_obligacion_pago
        )LOOP
        		raise  notice 'estasd %', v_obligaciones.id_estado_wf;
        	   INSERT INTO flujo_obligaciones(
               WITH RECURSIVE estados_obligaciones(id_depto, id_proceso_wf, id_tipo_estado,id_estado_wf, id_estado_anterior, fecha_reg)AS(
                   SELECT et.id_depto, et.id_proceso_wf, et.id_tipo_estado, et.id_estado_wf, et.id_estado_anterior, et.fecha_reg
                   FROM wf.testado_wf et
                   WHERE et.id_estado_wf=v_obligaciones.id_estado_wf
                UNION ALL
                   SELECT et.id_depto, et.id_proceso_wf, et.id_tipo_estado, et.id_estado_wf, et.id_estado_anterior, et.fecha_reg
                   FROM wf.testado_wf et, estados_obligaciones
                   WHERE et.id_estado_wf=estados_obligaciones.id_estado_anterior
                )SELECT dep.nombre::text, tp.nombre||'-'||prv.desc_proveedor, te.nombre_estado, eo.fecha_reg, eo.id_tipo_estado, eo.id_estado_wf, COALESCE(eo.id_estado_anterior,NULL) as id_estado_anterior
                 FROM estados_obligaciones eo
                 INNER JOIN wf.ttipo_estado te on te.id_tipo_estado= eo.id_tipo_estado
                 INNER JOIN wf.tproceso_wf pwf on pwf.id_proceso_wf=eo.id_proceso_wf
                 INNER JOIN wf.ttipo_proceso tp on tp.id_tipo_proceso=pwf.id_tipo_proceso
                 INNER JOIN tes.tobligacion_pago op on op.id_proceso_wf=pwf.id_proceso_wf
                 INNER JOIN param.vproveedor prv on prv.id_proveedor=op.id_proveedor
                 LEFT JOIN param.tdepto dep on dep.id_depto=eo.id_depto
                 ORDER BY eo.id_estado_wf ASC
                 );
        END LOOP;

              v_consulta:='select * from flujo_obligaciones';
              --Devuelve la respuesta
              return v_consulta;


        end;



     /*********************************
 	#TRANSACCION:  'TES_OBPGSEL_SEL'
 	#DESCRIPCION:	Reporte de Obligacion Seleccionado
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		17-07-2013 16:01:32
	***********************************/

	elsif(p_transaccion='TES_OBPGSEL_SEL')then
      begin
      	v_consulta:='select
						obpg.id_obligacion_pago,
						obpg.id_proveedor,
                        pv.desc_proveedor,
						obpg.estado,
						obpg.tipo_obligacion,
						obpg.id_moneda,
                        mn.moneda,
						obpg.obs,
						obpg.porc_retgar,
						obpg.id_subsistema,
                        ss.nombre as nombre_subsistema,
						obpg.porc_anticipo,
						obpg.id_depto,
                        dep.nombre as nombre_depto,
						obpg.num_tramite,
                        obpg.fecha,
                        obpg.numero,
                        obpg.tipo_cambio_conv,
                        obpg.comprometido,
                        obpg.nro_cuota_vigente,
                        mn.tipo_moneda,
                        obpg.pago_variable
						from tes.tobligacion_pago obpg
                        inner join param.vproveedor pv on pv.id_proveedor=obpg.id_proveedor
                        inner join param.tmoneda mn on mn.id_moneda=obpg.id_moneda
                        inner join segu.tsubsistema ss on ss.id_subsistema=obpg.id_subsistema
						inner join param.tdepto dep on dep.id_depto=obpg.id_depto
                        where obpg.id_obligacion_pago='||v_parametros.id_obligacion_pago||'';

            --Definicion de la respuesta
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
      end;


    /*********************************
 	#TRANSACCION:  'TES_PROCP_SEL'
 	#DESCRIPCION:	Reporte de procesos pendientes
 	#AUTOR:		MAM
 	#FECHA:		05-12-20116 16:01:32
	***********************************/

    elsif(p_transaccion='TES_PROCP_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='with estadoPlanPago as (select op.num_tramite,p.nro_cuota,p.liquido_pagable, p.estado, op.id_obligacion_pago, p.fecha_tentativa, p.tipo
						from tes.tobligacion_pago op
						left join tes.tplan_pago p on p.id_obligacion_pago = op.id_obligacion_pago and p.estado_reg = ''activo''
						and p.estado != ''anulado'')
					SELECT
                    obl.num_tramite,
                    obl.id_obligacion_pago,
                    obl.estado,
                    to_char(obl.fecha,''DD/MM/YYYY''),
                    fu.desc_funcionario1,
                    pr.desc_proveedor,
                    obl.total_pago,
                    m.moneda,
                    es.estado as estado_pago,
                    es.nro_cuota,
                    es.liquido_pagable,
                    obl.obs,
                    to_char(es.fecha_tentativa,''DD/MM/YYYY'') as fecha_tentativa ,
                    per.nombre_completo1 as nombre,
                    de.nombre as nombre_depto,
                    obl.pago_variable,
                    es.tipo
                    from tes.tobligacion_pago obl
                    inner join segu.tusuario usu1 on usu1.id_usuario = obl.id_usuario_reg
                    inner join segu.vpersona per on per.id_persona = usu1.id_persona
                    inner join orga.vfuncionario fu on fu.id_funcionario = obl.id_funcionario
                    inner join param.vproveedor pr on pr.id_proveedor = obl.id_proveedor
                    inner join param.tmoneda m on m.id_moneda = obl.id_moneda
                    left join estadoPlanPago es on es.id_obligacion_pago = obl.id_obligacion_pago
                    inner join param.tdepto de on de.id_depto = obl.id_depto
                    inner join param.tproveedor pro on pro.id_proveedor = obl.id_proveedor
                    where  obl.fecha >= '''||v_parametros.fecha_ini||''' and obl.fecha <= '''||v_parametros.fecha_fin||'''
                    and obl.estado IN(''borrador'',''registrado'',''en_pago'',''anulado'')';
                    v_consulta:=v_consulta||'ORDER BY num_tramite, obl.num_tramite, es.nro_cuota ASC';

            raise notice '% .',v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;

    /*********************************
 	#TRANSACCION:  'TES_PAGSINDOC_SEL'
 	#DESCRIPCION:	Reporte de pagos sin documentos relacionados
 	#AUTOR:		Gonzalo Sarmiento
 	#FECHA:		03-03-2017 16:01:32
	***********************************/

    elsif(p_transaccion='TES_PAGSINDOC_SEL')then

    	begin
        	select cla.id_clase_comprobante into v_id_clase_comprobante
			from conta.tclase_comprobante cla
			where cla.codigo='DIARIO';

    		--Sentencia de la consulta
			v_consulta:='select dev.id_int_comprobante, dev.nro_tramite, dev.c31, dev.beneficiario, dev.glosa1
						from conta.tint_comprobante pago
						inner join conta.tint_comprobante dev on dev.id_int_comprobante = ANY(pago.id_int_comprobante_fks)
        				and dev.id_clase_comprobante = 3
					    and conta.f_recuperar_nro_documento_facturas_comprobante(dev.id_int_comprobante) is  null
						where dev.id_clase_comprobante ='|| v_id_clase_comprobante ||' and
		      			pago.fecha between '''||v_parametros.fecha_ini||''' and
      					'''||v_parametros.fecha_fin||''' and
      					pago.estado_reg = ''validado'' and
      					pago.id_moneda = (select id_moneda from param.tmoneda where tipo_moneda=''base'')';

            raise notice '% ',v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;

     /*********************************
 	#TRANSACCION:  'TES_COMEJEPAG_SEL'
 	#DESCRIPCION:	Reporte de Comprometido Ejecutado Pagado
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		17-07-2013 16:01:32
	***********************************/

	elsif(p_transaccion='TES_COMEJEPAG_SEL')then
        begin
    		--Sentencia de la consulta
            create temp table obligaciones(
                    id_obligacion_det 	integer,
                    id_partida			integer,
                    nombre_partida		text,
                    id_concepto_ingas	integer,
                    nombre_ingas			text,
                    id_obligacion_pago	integer,
                    id_centro_costo		integer,
                    codigo_cc			text,
                    id_partida_ejecucion_com	integer,
                    descripcion			text,
                    comprometido		numeric DEFAULT 0.00,
                    ejecutado			numeric DEFAULT 0.00,
                    pagado				numeric DEFAULT 0.00,
                    revertible			numeric DEFAULT 0.00,
                    revertir			numeric DEFAULT 0.00
            ) on commit drop;

            insert into obligaciones (id_obligacion_det,
                                      id_partida,
                                      nombre_partida,
            						  id_concepto_ingas,
                                      nombre_ingas,
                                      id_obligacion_pago,
                                      id_centro_costo,
                                      codigo_cc,
                                      id_partida_ejecucion_com,
                                      descripcion)
            select
                obdet.id_obligacion_det,
                obdet.id_partida,
                par.nombre_partida||'-('||par.codigo||')' as nombre_partida,
                obdet.id_concepto_ingas,
                cig.desc_ingas||'-('||cig.movimiento||')' as nombre_ingas,
                obdet.id_obligacion_pago,
                obdet.id_centro_costo,
                cc.codigo_cc,
                obdet.id_partida_ejecucion_com,
                obdet.descripcion
           from tes.tobligacion_det obdet
                inner join param.vcentro_costo cc on cc.id_centro_costo=obdet.id_centro_costo
                inner join segu.tusuario usu1 on usu1.id_usuario = obdet.id_usuario_reg
                inner join pre.tpartida par on par.id_partida=obdet.id_partida
                inner join param.tconcepto_ingas cig on cig.id_concepto_ingas=obdet.id_concepto_ingas





            where obdet.id_obligacion_pago=v_parametros.id_obligacion_pago;

            --raise exception 'Moneda %', v_parametros.id_moneda ;

			FOR v_obligaciones_partida in (select * from obligaciones)
       	    LOOP
            	v_respuesta_verificar = pre.f_verificar_com_eje_pag(v_obligaciones_partida.id_partida_ejecucion_com,v_parametros.id_moneda);



            	update obligaciones set
                comprometido = COALESCE(v_respuesta_verificar.ps_comprometido,0.00::numeric),
                ejecutado = COALESCE(v_respuesta_verificar.ps_ejecutado,0.00::numeric),
                pagado = COALESCE(v_respuesta_verificar.ps_pagado,0.00::numeric),
                revertible =  COALESCE(v_respuesta_verificar.ps_comprometido,0.00::numeric) - COALESCE(v_respuesta_verificar.ps_ejecutado,0.00::numeric)
                where obligaciones.id_obligacion_det=v_obligaciones_partida.id_obligacion_det;

        	END LOOP;

            --raise exception 'Moneda %', v_parametros.id_moneda ;

              v_consulta:='select * from obligaciones where  ';

              --Definicion de la respuesta
              v_consulta:=v_consulta||v_parametros.filtro;
              v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion;


			--Devuelve la respuesta
			return v_consulta;

		end;
	/*********************************
 	#TRANSACCION:  'TES_REPCERPRE_SEL'
 	#DESCRIPCION:	Reporte Certificación Presupuestaria
 	#AUTOR:		FEA
 	#FECHA:		02-08-2017 15:00
	***********************************/

	elsif(p_transaccion='TES_REPCERPRE_SEL')then

		begin

        	SELECT top.id_funcionario
            INTO v_id_funcionario
            FROM tes.tobligacion_pago top
            WHERE top.id_proceso_wf =  v_parametros.id_proceso_wf;

        	--Gerencia del funcionario solicitante
        	WITH RECURSIVE gerencia(id_uo, id_nivel_organizacional, nombre_unidad, nombre_cargo, codigo) AS (
              SELECT tu.id_uo, tu.id_nivel_organizacional, tu.nombre_unidad, tu.nombre_cargo, tu.codigo
              FROM orga.tuo  tu
              INNER JOIN orga.tuo_funcionario tf ON tf.id_uo = tu.id_uo
              WHERE tf.id_funcionario = v_id_funcionario and tu.estado_reg = 'activo'

              UNION ALL

              SELECT teu.id_uo_padre, tu1.id_nivel_organizacional, tu1.nombre_unidad, tu1.nombre_cargo, tu1.codigo
              FROM orga.testructura_uo teu
              INNER JOIN gerencia g ON g.id_uo = teu.id_uo_hijo
              INNER JOIN orga.tuo tu1 ON tu1.id_uo = teu.id_uo_padre
              WHERE substring(g.nombre_cargo,1,7) <> 'Gerente'
          	)

            SELECT (codigo||'-'||nombre_unidad)::varchar
            INTO v_gerencia
            FROM gerencia
            ORDER BY id_nivel_organizacional asc limit 1;
            --end gerencia

            SELECT top.estado, top.id_estado_wf, top.obs
            INTO v_record_op
            FROM tes.tobligacion_pago top
            WHERE top.id_proceso_wf = v_parametros.id_proceso_wf;


            SELECT tpo.nombre
            INTO v_cod_proceso
            FROM wf.tproceso_wf tpw
            INNER JOIN wf.ttipo_proceso ttp ON ttp.id_tipo_proceso = tpw.id_tipo_proceso
            INNER JOIN wf.tproceso_macro tpo ON tpo.id_proceso_macro = ttp.id_proceso_macro
            WHERE tpw.id_proceso_wf = v_parametros.id_proceso_wf;

            IF(v_record_op.estado IN ('vbpresupuestos', 'suppresu', 'registrado', 'en_pago', 'finalizado'))THEN
              v_index = 1;
              FOR v_record IN (WITH RECURSIVE firmas(id_estado_fw, id_estado_anterior,fecha_reg, codigo, id_funcionario) AS (
                                SELECT tew.id_estado_wf, tew.id_estado_anterior , tew.fecha_reg, te.codigo, tew.id_funcionario
                                FROM wf.testado_wf tew
                                INNER JOIN wf.ttipo_estado te ON te.id_tipo_estado = tew.id_tipo_estado
                                WHERE tew.id_estado_wf = v_record_op.id_estado_wf

                                UNION ALL

                                SELECT ter.id_estado_wf, ter.id_estado_anterior, ter.fecha_reg, te.codigo, ter.id_funcionario
                                FROM wf.testado_wf ter
                                INNER JOIN firmas f ON f.id_estado_anterior = ter.id_estado_wf
                                INNER JOIN wf.ttipo_estado te ON te.id_tipo_estado = ter.id_tipo_estado
                                WHERE f.id_estado_anterior IS NOT NULL
                            )SELECT distinct on (codigo) codigo, fecha_reg , id_estado_fw, id_estado_anterior, id_funcionario FROM firmas ORDER BY codigo, fecha_reg DESC) LOOP

                  IF(v_record.codigo = 'vbpoa' OR v_record.codigo = 'suppresu' OR v_record.codigo = 'vbpresupuestos' OR v_record.codigo = 'registrado')THEN
                    	SELECT vf.desc_funcionario1, vf.nombre_cargo, vf.oficina_nombre
                        INTO v_record_funcionario
                        FROM orga.vfuncionario_cargo_lugar vf
                        WHERE vf.id_funcionario = v_record.id_funcionario;
                        v_firmas[v_index] = v_record.codigo::VARCHAR||','||v_record.fecha_reg::VARCHAR||','||v_record_funcionario.desc_funcionario1::VARCHAR||','||v_record_funcionario.nombre_cargo::VARCHAR||','||v_record_funcionario.oficina_nombre;
                        v_index = v_index + 1;
                  END IF;
              END LOOP;
            	v_firma_fun = array_to_string(v_firmas,';');
            ELSE
            	v_firma_fun = '';
        	END IF;
        		------
            SELECT (''||te.codigo||' '||te.nombre)::varchar
            INTO v_nombre_entidad
            FROM param.tempresa te;
            ------
            SELECT (''||tda.codigo||' '||tda.nombre)::varchar
            INTO v_direccion_admin
            FROM pre.tdireccion_administrativa tda;
			------
            SELECT (''||tue.codigo||' '||tue.nombre)::varchar
            INTO v_unidad_ejecutora
            FROM pre.tunidad_ejecutora tue;
            ---

			--Sentencia de la consulta de conteo de registros
			v_consulta:='
            SELECT
            	vcp.id_categoria_programatica AS id_cp, ttc.codigo AS centro_costo,
            	vcp.codigo_programa , vcp.codigo_proyecto, vcp.codigo_actividad,
            	vcp.codigo_fuente_fin, vcp.codigo_origen_fin, tpar.codigo AS codigo_partida,
            	tpar.nombre_partida AS nombre_partida, tcg.codigo AS codigo_cg, tcg.nombre AS nombre_cg,
            	sum(tsd.monto_pago_mo) AS monto_pago, tmo.codigo AS codigo_moneda, ts.num_tramite,

            '''||v_nombre_entidad||'''::varchar AS nombre_entidad,
            COALESCE('''||v_direccion_admin||'''::varchar, '''') AS direccion_admin,
            '''||v_unidad_ejecutora||'''::varchar AS unidad_ejecutora,
            COALESCE('''||v_firma_fun||'''::varchar, '''') AS firmas,
            COALESCE('''||v_record_op.obs||'''::varchar,'''') AS justificacion,
            COALESCE(tet.codigo::varchar,''00''::varchar) AS codigo_transf,
            --(uo.codigo||''-''||uo.nombre_unidad)::varchar as unidad_solicitante,
            '''||v_gerencia||'''::varchar AS unidad_solicitante,
            fun.desc_funcionario1::varchar as funcionario_solicitante,
            '''||v_cod_proceso||'''::varchar AS codigo_proceso,

            COALESCE(ts.fecha,null::date) AS fecha_soli,
            COALESCE(tg.gestion, (extract(year from now()::date))::integer) AS gestion,
            ts.codigo_poa,
            (select  pxp.list(distinct ob.codigo|| '' ''||ob.descripcion||'' '')
            from pre.tobjetivo ob
            where ob.codigo = ANY (string_to_array(ts.codigo_poa,'',''))
            )::varchar as codigo_descripcion

            FROM tes.tobligacion_pago ts
            INNER JOIN tes.tobligacion_det tsd ON tsd.id_obligacion_pago = ts.id_obligacion_pago
            INNER JOIN pre.tpartida tpar ON tpar.id_partida = tsd.id_partida

            inner join param.tgestion tg on tg.id_gestion = ts.id_gestion

            INNER JOIN pre.tpresup_partida tpp ON tpp.id_partida = tpar.id_partida AND tpp.id_centro_costo = tsd.id_centro_costo

            INNER JOIN param.tcentro_costo tcc ON tcc.id_centro_costo = tsd.id_centro_costo
            INNER JOIN param.ttipo_cc ttc ON ttc.id_tipo_cc = tcc.id_tipo_cc

            INNER JOIN pre.tpresupuesto	tp ON tp.id_presupuesto = tpp.id_presupuesto
            INNER JOIN pre.vcategoria_programatica vcp ON vcp.id_categoria_programatica = tp.id_categoria_prog

            INNER JOIN pre.tclase_gasto_partida tcgp ON tcgp.id_partida = tpp.id_partida
            INNER JOIN pre.tclase_gasto tcg ON tcg.id_clase_gasto = tcgp.id_clase_gasto

            INNER JOIN param.tmoneda tmo ON tmo.id_moneda = ts.id_moneda

            inner join orga.vfuncionario fun on fun.id_funcionario = ts.id_funcionario
            --inner join orga.tuo uo on uo.id_uo = ts.id_uo

            left JOIN pre.tpresupuesto_partida_entidad tppe ON tppe.id_partida = tpar.id_partida AND tppe.id_presupuesto = tp.id_presupuesto
            left JOIN pre.tentidad_transferencia tet ON tet.id_entidad_transferencia = tppe.id_entidad_transferencia

            WHERE tsd.estado_reg = ''activo'' AND ts.id_proceso_wf = '||v_parametros.id_proceso_wf;

			v_consulta =  v_consulta ||
            ' GROUP BY vcp.id_categoria_programatica, tpar.codigo, ttc.codigo, vcp.codigo_programa,
            vcp.codigo_proyecto, vcp.codigo_actividad, vcp.codigo_fuente_fin, vcp.codigo_origen_fin,
    		tpar.nombre_partida, tcg.codigo, tcg.nombre, tmo.codigo, ts.num_tramite, tet.codigo,
    		funcionario_solicitante, ts.fecha, tg.gestion, ts.codigo_poa ';
			v_consulta =  v_consulta || 'ORDER BY tpar.codigo, tcg.nombre, vcp.id_categoria_programatica, ttc.codigo asc  ';
			--Devuelve la respuesta
            RAISE NOTICE 'v_consulta %',v_consulta;
			return v_consulta;

        end;


    /*********************************
    #TRANSACCION:  'TES_OBPGPS_SEL'
    #DESCRIPCION:   Consulta de datos para pagos simples
    #AUTOR:         RCM
    #FECHA:         14-01-2018
    ***********************************/

    elsif(p_transaccion='TES_OBPGPS_SEL')then

        begin

            --Sentencia de la consulta
            v_consulta:='select
                obpg.id_obligacion_pago,
                obpg.id_proveedor,
                pv.desc_proveedor,
                obpg.estado,
                obpg.tipo_obligacion,
                obpg.id_moneda,
                mn.moneda,
                obpg.obs,
                obpg.porc_retgar,
                obpg.id_subsistema,
                ss.nombre as nombre_subsistema,
                obpg.id_funcionario,
                fun.desc_funcionario1,
                obpg.estado_reg,
                obpg.porc_anticipo,
                obpg.id_estado_wf,
                obpg.id_depto,
                dep.nombre as nombre_depto,
                obpg.num_tramite,
                obpg.id_proceso_wf,
                obpg.fecha_reg,
                obpg.id_usuario_reg,
                obpg.fecha_mod,
                obpg.id_usuario_mod,
                usu1.cuenta as usr_reg,
                usu2.cuenta as usr_mod,
                obpg.fecha,
                obpg.numero,
                obpg.tipo_cambio_conv,
                obpg.id_gestion,
                obpg.comprometido,
                obpg.nro_cuota_vigente,
                mn.tipo_moneda,
                obpg.total_pago,
                obpg.pago_variable,
                obpg.id_depto_conta,
                obpg.total_nro_cuota,
                obpg.fecha_pp_ini,
                obpg.rotacion,
                obpg.id_plantilla,
                pla.desc_plantilla,
                obpg.ultima_cuota_pp,
                obpg.ultimo_estado_pp,
                obpg.tipo_anticipo,
                obpg.ajuste_anticipo,
                obpg.ajuste_aplicado,
                obpg.monto_estimado_sg,
                obpg.id_obligacion_pago_extendida,
                con.tipo||'' - ''||con.numero::varchar as desc_contrato,
                con.id_contrato,
                obpg.obs_presupuestos,
                obpg.codigo_poa,
                obpg.obs_poa,
                obpg.uo_ex,
                obpg.id_funcionario_responsable,
                fresp.desc_funcionario1 AS desc_fun_responsable,
                g.gestion::integer --#48
                from tes.tobligacion_pago obpg
                inner join segu.tusuario usu1 on usu1.id_usuario = obpg.id_usuario_reg
                left join segu.tusuario usu2 on usu2.id_usuario = obpg.id_usuario_mod
                inner join param.tmoneda mn on mn.id_moneda=obpg.id_moneda
                inner join segu.tsubsistema ss on ss.id_subsistema=obpg.id_subsistema
                inner join param.tdepto dep on dep.id_depto=obpg.id_depto
                left join param.vproveedor pv on pv.id_proveedor=obpg.id_proveedor
                left join leg.tcontrato con on con.id_contrato = obpg.id_contrato
                left join param.tplantilla pla on pla.id_plantilla = obpg.id_plantilla
                left join orga.vfuncionario fun on fun.id_funcionario=obpg.id_funcionario
                left join orga.vfuncionario fresp ON fresp.id_funcionario = obpg.id_funcionario_responsable
                join param.tgestion g on g.id_gestion=obpg.id_gestion --#48
                left join  adq.tcotizacion cot on cot.id_obligacion_pago=obpg.id_obligacion_pago --#48
                where ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            return v_consulta;

        end;

    /*********************************
    #TRANSACCION:  'TES_OBPGPS_CONT'
    #DESCRIPCION:   Consulta de datos para pagos simples
    #AUTOR:         RCM
    #FECHA:         14-01-2018
    ***********************************/

    elsif(p_transaccion='TES_OBPGPS_CONT')then

        begin

            --Sentencia de la consulta
            v_consulta:='select count(1)
                from tes.tobligacion_pago obpg
                inner join segu.tusuario usu1 on usu1.id_usuario = obpg.id_usuario_reg
                left join segu.tusuario usu2 on usu2.id_usuario = obpg.id_usuario_mod
                inner join param.tmoneda mn on mn.id_moneda=obpg.id_moneda
                inner join segu.tsubsistema ss on ss.id_subsistema=obpg.id_subsistema
                inner join param.tdepto dep on dep.id_depto=obpg.id_depto
                left join param.vproveedor pv on pv.id_proveedor=obpg.id_proveedor
                left join leg.tcontrato con on con.id_contrato = obpg.id_contrato
                left join param.tplantilla pla on pla.id_plantilla = obpg.id_plantilla
                left join orga.vfuncionario fun on fun.id_funcionario=obpg.id_funcionario
                left join orga.vfuncionario fresp ON fresp.id_funcionario = obpg.id_funcionario_responsable
                join param.tgestion g on g.id_gestion=obpg.id_gestion --#48
                left join  adq.tcotizacion cot on cot.id_obligacion_pago=obpg.id_obligacion_pago --#48
                where ';

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