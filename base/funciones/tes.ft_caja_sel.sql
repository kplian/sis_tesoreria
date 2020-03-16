--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.ft_caja_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.ft_caja_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tcaja'
 AUTOR: 		 (admin)
 FECHA:	        16-12-2013 20:43:44
 COMENTARIOS:	
***************************************************************************
   HISTORIAL DE MODIFICACIONES:

 ISSUE            FECHA:		      AUTOR                 DESCRIPCION

 #61        	 16-03-2020        manuel guerra         agregar fecha y motivo al reporte rendicion

***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_aux				varchar;
    v_filtro			varchar;
    v_inner				varchar;
    v_cajas				record;
    v_i					integer;
    v_id_caja			integer[];
    v_id_tipo_solicitud_ape integer;
    v_id_tipo_solicitud_sal integer;
    v_id_tipo_solicitud_ing integer;
    v_id_tipo_solicitud_rep integer;
    v_id_tipo_solicitud_dev integer;
    v_id_tipo_solicitud_ren integer;
    v_id_tipo_solicitud_sol integer;
    v_fecha_aux 		date;
    v_year_ini		varchar;
    v_month_ini 	varchar;
    v_day_ini		varchar;
    v_ini			varchar;
    v_fin			varchar;
	v_year_fin		varchar;
    v_month_fin 	varchar;
    v_day_fin		varchar;
    v_saldo_deb 	numeric;
    v_saldo_hab 	numeric;
    v_m				integer;
    v_max			varchar;

BEGIN

	v_nombre_funcion = 'tes.ft_caja_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'TES_CAJA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin
 	#FECHA:		16-12-2013 20:43:44
	***********************************/

	if(p_transaccion='TES_CAJA_SEL')then

    	begin
        	v_filtro='';
            v_inner='';
			v_aux = ',''auxiliar''';
            IF (v_parametros.id_funcionario_usu is null) then

                v_parametros.id_funcionario_usu = -1;

            END IF;


            IF  lower(v_parametros.tipo_interfaz) = 'caja' THEN

                IF p_administrador !=1 THEN
                   --v_filtro = '(caja.id_usuario_reg='||p_id_usuario||' ) and  pc.estado in (''borrador'',''abierto'',''cerrado'',''anulado'',''rechazado'') and  ';
                   v_filtro = '(caja.id_usuario_reg='||p_id_usuario||' ) and ';
                   --pc.estado in (''borrador'',''anulado'',''rechazado'') and  ';
                 ELSE
                     --v_filtro = '(caja.id_usuario_reg='||p_id_usuario||' ) and  pc.estado in (''borrador'',''abierto'',''cerrado'',''anulado'',''rechazado'') and  ';
					 --v_filtro = 'pc.estado in (''borrador'',''anulado'',''rechazado'') and  ';
                END IF;

            END IF;

            IF  lower(v_parametros.tipo_interfaz) = 'cajavb' THEN

				v_inner =  'inner join wf.testado_wf ew on ew.id_proceso_wf = pc.id_proceso_wf';

                IF p_administrador !=1 THEN
                   v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||') and  (pc.estado = ''solicitado'') and  ';
                 ELSE
                     v_filtro = '(pc.estado = ''solicitado'') and ';
                END IF;

            END IF;

            IF  lower(v_parametros.tipo_interfaz) = 'cajaabierto' THEN

                IF p_administrador !=1 THEN
                	v_i = 1;
                	FOR v_cajas in (select id_caja
                    				from tes.tcajero c
                    				where id_funcionario=v_parametros.id_funcionario_usu
				                    and tipo in ('responsable','administrador')  and  c.estado_reg = 'activo')LOOP
                    	v_id_caja[v_i] = v_cajas.id_caja;
                        v_i = v_i + 1;
                    END LOOP;

                    IF v_i > 1 THEN
                    	v_filtro = '(caja.estado = ''abierto'') and (pc.tipo=''apertura'') and caja.id_caja in('||array_to_string(v_id_caja,',')||') and ';
                    ELSE
                    	v_inner = ' left join tes.tcaja_funcionario cjusu on cjusu.id_caja=caja.id_caja ';
                    	v_filtro = '(caja.estado = ''abierto'') and (pc.tipo=''apertura'') and cjusu.id_funcionario='||v_parametros.id_funcionario_usu::integer||' and ';
                    END IF;

                ELSE
	                 v_filtro = '(caja.estado = ''abierto'') and (pc.tipo=''apertura'') and ';
               END IF;
            END IF;

            IF  lower(v_parametros.tipo_interfaz) = 'solicitudcaja' THEN
				v_aux := '';
                IF p_administrador !=1 THEN
                	v_i = 1;
                	FOR v_cajas in (select id_caja
                    				from tes.tcajero c
                    				where id_funcionario=v_parametros.id_funcionario_usu
				                    and tipo='responsable'  and  c.estado_reg = 'activo')LOOP
                    	v_id_caja[v_i] = v_cajas.id_caja;
                        v_i = v_i + 1;
                    END LOOP;

                    IF v_i > 1 THEN
                    	v_filtro = '(caja.estado = ''abierto'') and (pc.tipo=''apertura'') and caja.id_caja in('||array_to_string(v_id_caja,',')||') and ';
                    ELSE
                        --TODO, RAC  23/12/2017,  si no esun cajero filtra las por lugar segun oficina del funcionario,..... queda pendiente


                    	v_filtro = '(caja.estado = ''abierto'') and (pc.tipo=''apertura'')  and ';


                    END IF;

               ELSE
	                 v_filtro = '(caja.estado = ''abierto'') and (pc.tipo=''apertura'') and ';
               END IF;

            END IF;



            IF  lower(v_parametros.tipo_interfaz) = 'cajacajero' THEN

                IF p_administrador !=1 THEN
                   v_filtro = '(caje.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (pc.estado in (''abierto'',''cerrado'',''aprobado'')) and  ';
                 ELSE
                     v_filtro = '(pc.estado in (''abierto'',''cerrado'',''aprobado'')) and ';
                END IF;

            END IF;

    		--Sentencia de la consulta
			v_consulta:='select
						caja.id_caja,
						caja.estado,
						caja.importe_maximo_caja,
                        tes.f_calcular_saldo_caja(caja.id_caja) as saldo,
						caja.tipo,
						caja.estado_reg,
                        pc.estado as estado_proceso,
						caja.importe_maximo_item,
						caja.id_moneda,
						caja.id_depto,
                        caja.id_cuenta_bancaria,
                        ctab.nro_cuenta ||''-'' ||ctab.denominacion as id_cuenta_bancaria,
						caja.codigo,
                        fun.desc_funcionario1 as cajero,
						caja.id_usuario_reg,
						caja.fecha_reg,
						caja.id_usuario_mod,
						caja.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						mon.moneda as desc_moneda,
						depto.nombre as desc_depto,
                        deplb.nombre as desc_depto_lb,
                        caja.tipo_ejecucion,
                        pc.id_proceso_wf,
				        pc.id_estado_wf,
       					pc.nro_tramite,
                        caja.dias_maximo_rendicion
						from tes.tcaja caja
						inner join segu.tusuario usu1 on usu1.id_usuario = caja.id_usuario_reg
                        inner join tes.tproceso_caja pc on pc.id_caja= caja.id_caja
						left join segu.tusuario usu2 on usu2.id_usuario = caja.id_usuario_mod
						inner join param.tmoneda mon on mon.id_moneda= caja.id_moneda
						inner join param.tdepto depto on depto.id_depto=caja.id_depto
                        left join param.tdepto deplb on deplb.id_depto=caja.id_depto_lb
                        left join tes.tcuenta_bancaria ctab on ctab.id_cuenta_bancaria=caja.id_cuenta_bancaria
                        left join tes.tcajero caje on caje.id_caja=caja.id_caja and caje.tipo in(''responsable''  '|| v_aux || ')
						left join orga.vfuncionario fun on fun.id_funcionario=caje.id_funcionario
                        '||v_inner||'
                        where caja.estado_reg = ''activo'' and  '||v_filtro;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			raise notice '%', v_consulta;
        --   raise EXCEPTION '%', v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;
        /*********************************
        #TRANSACCION:  'TES_LCAJ_SEL'
        #DESCRIPCION:	Listado de cajas
        #AUTOR:		admin
        #FECHA:		18-12-2013 19:39:02
        ***********************************/

        ELSIF(p_transaccion='TES_LCAJ_SEL')then
        	begin
                --Sentencia de la consulta
                v_consulta:='select
                            caja.id_caja,
                            caja.estado,
                            caja.tipo,
                            caja.codigo
                            from tes.tcaja caja
                            where caja.estado_reg = ''activo'' and
                            ';
                v_consulta:=v_consulta||v_parametros.filtro;
--                raise exception '%',v_consulta;
                v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			return v_consulta;
		end;
        /*********************************
        #TRANSACCION:  'TES_LCAJ_COUNT'
        #DESCRIPCION:	Listado de cajas
        #AUTOR:		admin
        #FECHA:		18-12-2013 19:39:02
        ***********************************/

        ELSIF(p_transaccion='TES_LCAJ_COUNT')then
        	begin
                --Sentencia de la consulta
                v_consulta:='select count(caja.id_caja)
                            from tes.tcaja caja
                            where caja.estado_reg = ''activo'' and ';
                v_consulta:=v_consulta||v_parametros.filtro;
                --raise exception '%',v_consulta;
			return v_consulta;
		end;
      /*********************************
      #TRANSACCION:  'TES_CAJA_REP_SEL'
      #DESCRIPCION:	Reporte de rendicion de cajaero
      #AUTOR:		mp
      #FECHA:		29-08-2013 00:28:30
      ***********************************/
		elsif(p_transaccion='TES_CAJA_REP_SEL') then
     		begin


                select id_tipo_solicitud into v_id_tipo_solicitud_sol
                from tes.ttipo_solicitud
                where codigo='SOLEFE';

                select id_tipo_solicitud into v_id_tipo_solicitud_ren
                from tes.ttipo_solicitud
                where codigo='RENEFE';

                select id_tipo_solicitud into v_id_tipo_solicitud_dev
                from tes.ttipo_solicitud
                where codigo='DEVEFE';

                select id_tipo_solicitud into v_id_tipo_solicitud_rep
                from tes.ttipo_solicitud
                where codigo='REPEFE';

                select id_tipo_solicitud into v_id_tipo_solicitud_ing
                from tes.ttipo_solicitud
                where codigo='INGEFE';

                select id_tipo_solicitud into v_id_tipo_solicitud_sal
                from tes.ttipo_solicitud
                where codigo='SALEFE';

                select id_tipo_solicitud into v_id_tipo_solicitud_ape
                from tes.ttipo_solicitud
                where codigo='APECAJ';
         		-- raise notice '%',v_parametros.fecha;
                -- raise exception '%',v_parametros.fecha;
              v_consulta := ' (
                              select
                              solefe.nro_tramite::varchar,
                              dc.tipo::varchar,
                              solefe.motivo::varchar,
                              rend.monto::numeric,
                              pla.desc_plantilla::varchar as nombre,
                              dc.id_moneda::integer,
                              dc.razon_social::varchar,
                              dc.importe_pago_liquido::numeric,
                              dc.fecha::date,
                              ''''::varchar as nombre_fun,
                              dc.fecha_reg::date,
                              dc.estado_reg::varchar as estado_r,
                              dc.nit::varchar,
                              dc.nro_autorizacion::varchar,
                              dc.nro_documento::varchar,
                              dc.codigo_control::varchar,
                              dc.importe_doc::numeric,
                              dc.importe_iva::numeric,
                              null::varchar as nom_proceso

                              from tes.tsolicitud_rendicion_det rend
                              inner join tes.tsolicitud_efectivo solren on solren.id_solicitud_efectivo = rend.id_solicitud_efectivo
                              inner join tes.tsolicitud_efectivo solefe on solefe.id_solicitud_efectivo = solren.id_solicitud_efectivo_fk
                              inner join tes.tcaja caja on caja.id_caja = solefe.id_caja
                              left join conta.tdoc_compra_venta dc on dc.id_doc_compra_venta = rend.id_documento_respaldo
                              left join param.tplantilla pla on pla.id_plantilla = dc.id_plantilla
                              left join param.tmoneda mon on mon.id_moneda = dc.id_moneda
                              inner join segu.tusuario usu1 on usu1.id_usuario = rend.id_usuario_reg
                              left join segu.tusuario usu2 on usu2.id_usuario = rend.id_usuario_mod
                              where rend.id_proceso_caja = '||v_parametros.id_proceso_caja||'

                              union all

                              select
                              tesa.nro_tramite,
                              NULL::varchar as tipo,
                              tesa.motivo::varchar as motivo,  --#61
                              tesa.monto,
                              NULL::varchar as nombre,
                              0::integer as id_moneda,
                              NULL::varchar as razon_social,
                              0::numeric as importe_pago_liquido,
                              tesa.fecha,
                              ''''::varchar as nombre_fun,
                              tesa.fecha_ult_mov::date as fecha_reg, --#61
                              a.nombre::varchar as estado_reg,
                              ''''::varchar as nit,
                              ''''::varchar as nro_autorizacion,
                              ''''::varchar as nro_documento,
                              ''''::varchar as codigo_control,
                              0::numeric as importe_doc,
                              0::numeric as importe_iva,
                              tp.nro_tramite as nom_proceso

                              from tes.tsolicitud_efectivo tesa
                              inner join segu.tusuario usu1 on usu1.id_usuario = tesa.id_usuario_reg
                              left join segu.tusuario usu2 on usu2.id_usuario = tesa.id_usuario_mod
                              join tes.tcaja caja on caja.id_caja=tesa.id_caja
                              join tes.ttipo_solicitud a on a.id_tipo_solicitud=tesa.id_tipo_solicitud
                              join tes.tproceso_caja tp on tp.id_proceso_caja=tesa.id_proceso_caja_rend
                              where
                              tesa.ingreso_cd=''si'' and
                              tesa.estado=''ingresado'' and
                              id_proceso_caja='||v_parametros.id_proceso_caja||' and
                              a.id_tipo_solicitud='||v_id_tipo_solicitud_ing||'
                              order by nro_tramite ASC
                              )';

                              IF p_id_usuario = 428 THEN
                                 raise notice '%', v_consulta;
                                -- raise exception '%', v_consulta;
                              END IF;
				return v_consulta;
			end;
	/*********************************
 	#TRANSACCION:  'TES_RECAJFEC_SEL'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin
 	#FECHA:		16-12-2013 20:43:44
	***********************************/

	elsif(p_transaccion='TES_RECAJFEC_SEL')then
		begin
    	--Sentencia de la consulta de conteo de registros
        	v_fecha_aux = to_char(v_parametros.fecha_ini-1,'DD/MM/YYYY');
			v_consulta:='select
                        0::integer as id_solicitud_efectivo,
                        c.fecha as fecha_ult_mov,
                        c.monto_ren_ingreso as monto_ingreso,
                        c.monto as monto_salida,
                        c.estado,
                        c.monto,
                        c.nro_tramite
                        from tes.tproceso_caja c
                        where c.id_caja = '||v_parametros.id_caja||'
                        and c.estado =''cerrado''

                        union

            			select
                        0::integer as id_solicitud_efectivo,
                        '''||v_fecha_aux||'''::date as fecha_ult_mov,

                        sum(case when s.estado in(''aperturado'',''devuelto'',''ingresado'') then
                          s.monto
                        else
                            0
                        end)::numeric as monto_ingreso,

                        sum(case when s.estado in(''finalizado'',''repuesto'',''entregado'') then
                            s.monto
                        else
                            0
                        end)::numeric as monto_salida,

                        null::varchar as estado,
                        0::numeric as monto,
                        ''SALDO ANTERIOR''::varchar as nro_tramite

                        from tes.tsolicitud_efectivo s
                        where s.id_caja='||v_parametros.id_caja||'
                        and s.fecha_ult_mov < '''||v_parametros.fecha_ini||'''
                        and s.estado not in(''anulado'',''borrador'')

            			union all

            			select
                        s.id_solicitud_efectivo,
                        s.fecha_ult_mov,

                        case when s.estado in(''aperturado'',''devuelto'',''ingresado'') then
                            COALESCE(s.monto,0)
                        else
                            0::numeric
                        end as monto_ingreso,

                        case when s.estado in(''finalizado'',''repuesto'',''entregado'') then
                            COALESCE(s.monto,0)
                        else
                            0::numeric
                        end as monto_salida,

                        s.estado,
                        s.monto,
                        s.nro_tramite
                        from tes.tsolicitud_efectivo s
                        where s.id_caja='||v_parametros.id_caja||'
                        and s.fecha_ult_mov >= '''||v_parametros.fecha_ini||'''
                        and s.fecha_ult_mov <= '''||v_parametros.fecha_fin||'''
                        and s.estado not in(''anulado'',''borrador'')
                        and s.estado!=''rendido''
                        and';
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta|| 'order by fecha_ult_mov asc';

            return v_consulta;
    end;

     /*********************************
 	#TRANSACCION:  'TES_REPMENFEC_SEL'
 	#DESCRIPCION:	Reporte por rango de fechas
 	#AUTOR:		mp
 	#FECHA:		16-07-2018 20:43:44
	***********************************/

	elsif(p_transaccion='TES_REPMENFEC_SEL')then
		begin
    	--Sentencia de la consulta de conteo de registros
            v_year_ini =(EXTRACT(YEAR FROM v_parametros.fecha_ini));
            v_month_ini =(EXTRACT(MONTH FROM v_parametros.fecha_ini));
            v_day_ini =(EXTRACT(DAY FROM v_parametros.fecha_ini));
            v_ini= v_day_ini||'-'||v_month_ini||'-'||v_year_ini;
            v_m= v_day_ini::integer -1;
            v_max= v_m::varchar||'-'||v_month_ini||'-'||v_year_ini;

            v_year_fin =(EXTRACT(YEAR FROM v_parametros.fecha_fin));
            v_month_fin =(EXTRACT(MONTH FROM v_parametros.fecha_fin));
            v_day_fin =(EXTRACT(DAY FROM v_parametros.fecha_fin));
            v_fin= v_day_fin||'-'||v_month_fin||'-'||v_year_fin;

            v_fecha_aux = to_char(v_parametros.fecha_ini-1,'DD/MM/YYYY');


            v_consulta:='select

                        sum (COALESCE(monto::numeric,0)) -
                        sum (COALESCE(importe_pago_liquido::numeric,0)) as importe_pago_liquido

                        from
                        (
                        select
                        0::numeric as saldo,
                        ren.nro_tramite::VARCHAR,
                        ''''::varchar as desc_plantilla,
                        ren.fecha::DATE,
                        ''''::varchar as nit,
                        ''''::varchar as razon_social,
                        ''''::varchar as nro_autorizacion,
                        ''''::varchar as nro_documento,
                        ''''::varchar as codigo_control,
                        sum (COALESCE(ren.monto::numeric,0)) as monto,
                        sum (0) as importe_pago_liquido,
                        null::numeric as importe_iva,
                        null::numeric as importe_descuento,
                        null::numeric as importe_descuento_ley,
                        null::numeric as importe_excento,
                        ren.estado::varchar as motivo

                        from tes.tproceso_caja ren
                        left join tes.ttipo_proceso_caja tpc on tpc.id_tipo_proceso_caja=ren.id_tipo_proceso_caja
                        left join tes.tcaja cj on cj.id_caja=ren.id_caja
                        where cj.id_caja = '||v_parametros.id_caja||'
                        and ren.motivo NOT ILIKE ''%RENDICION%''
                        and tpc.codigo!=''SOLREN''

                        and (EXTRACT(day FROM ren.fecha))<= (EXTRACT(day FROM '''||v_fecha_aux||''' ::date))
                        and (EXTRACT(MONTH FROM ren.fecha))<= (EXTRACT(MONTH FROM '''||v_fecha_aux||''' ::date))
                        and (EXTRACT(year FROM ren.fecha))<= (EXTRACT(year FROM '''||v_fecha_aux||''' ::date))
                        group by 1,2,3,4,5,6,7,8,9,12,13,14,15,16

                        union all

                        select
                        0::numeric as saldo,
                        solefe.nro_tramite::varchar,
                        ''''::varchar as desc_plantilla,
                        solefe.fecha_mod::DATE as fecha,
                        ''''::varchar as nit,
                        ''''::varchar as razon_social,
                        ''''::varchar as nro_autorizacion,
                        ''''::varchar as nro_documento,
                        ''''::varchar as codigo_control,
                        sum(COALESCE(solefe.monto::numeric,0))as monto,
                        sum(0) as importe_pago_liquido,
                        null::numeric as importe_iva,
                        null::numeric as importe_descuento,
                        null::numeric as importe_descuento_ley,
                        null::numeric as importe_excento,
                        solefe.estado::varchar as motivo

                        from tes.tsolicitud_efectivo solefe
                        inner join segu.tusuario usu1 on usu1.id_usuario = solefe.id_usuario_reg
                        inner join tes.tcaja caja on caja.id_caja=solefe.id_caja
                        inner join orga.vfuncionario fun on fun.id_funcionario = solefe.id_funcionario
                        left join segu.tusuario usu2 on usu2.id_usuario = solefe.id_usuario_mod
                        left join tes.tsolicitud_efectivo solpri on solpri.id_solicitud_efectivo=solefe.id_solicitud_efectivo_fk
                        where caja.id_caja='||v_parametros.id_caja||'
                        and solefe.estado=''ingresado''

                        and (EXTRACT(day FROM solefe.fecha_mod))<= (EXTRACT(day FROM '''||v_fecha_aux||''' ::date))
                        and (EXTRACT(MONTH FROM solefe.fecha_mod))<= (EXTRACT(MONTH FROM '''||v_fecha_aux||''' ::date))
                        and (EXTRACT(year FROM solefe.fecha_mod))<= (EXTRACT(year FROM '''||v_fecha_aux||''' ::date))
                        group by 1,2,3,4,5,6,7,8,9,12,13,14,15,16

                        union all

                        select
                        0::numeric as saldo,
                        null::varchar as nro_tramite,
                        ''''::varchar as desc_plantilla,
                        null::DATE as fecha,
                        ''''::varchar as nit,
                        ''''::varchar as razon_social,
                        ''''::varchar as nro_autorizacion,
                        ''''::varchar as nro_documento,
                        ''''::varchar as codigo_control,
                        sum(0) as monto,
                        sum(COALESCE(dc.importe_pago_liquido::numeric,0)) as importe_pago_liquido,
                        null::numeric as importe_iva,
                        null::numeric as importe_descuento,
                        null::numeric as importe_descuento_ley,
                        null::numeric as importe_excento,
                        null::varchar as motivo
                        from tes.tsolicitud_rendicion_det rend
                        inner join tes.tsolicitud_efectivo solren on solren.id_solicitud_efectivo = rend.id_solicitud_efectivo
                        inner join tes.tsolicitud_efectivo solefe on solefe.id_solicitud_efectivo = solren.id_solicitud_efectivo_fk
                        inner join tes.tcaja caja on caja.id_caja = solefe.id_caja
                        left join conta.tdoc_compra_venta dc on dc.id_doc_compra_venta = rend.id_documento_respaldo
                        left join param.tplantilla pla on pla.id_plantilla = dc.id_plantilla
                        where caja.id_caja='||v_parametros.id_caja||' and solren.estado=''rendido''

                        and (EXTRACT(day FROM dc.fecha))<= (EXTRACT(day FROM '''||v_fecha_aux||''' ::date))
                        and (EXTRACT(MONTH FROM dc.fecha))<= (EXTRACT(MONTH FROM '''||v_fecha_aux||''' ::date))
                        and (EXTRACT(year FROM dc.fecha))<=(EXTRACT(year FROM '''||v_fecha_aux||''' ::date))
                        group by 1,2,3,4,5,6,7,8,9,12,13,14,15,16

                        ) as resultado';
            EXECUTE(v_consulta)into v_saldo_deb;

			v_consulta:='(select
                        0::numeric as saldo,
                        ''SALDO ANTERIOR''::varchar as nro_tramite,
                        ''''::varchar as desc_plantilla,
                        '''||v_fecha_aux||'''::date as fecha,
                        ''''::varchar as nit,
                        ''''::varchar as razon_social,
                        ''''::varchar as nro_autorizacion,
                        ''''::varchar as nro_documento,
                        ''''::varchar as codigo_control,
                        COALESCE('||v_saldo_deb||',0) as monto,
                        0::numeric as importe_pago_liquido,
                        null::numeric as importe_iva,
                        null::numeric as importe_descuento,
                        null::numeric as importe_descuento_ley,
                        null::numeric as importe_excento,
                        ''''::varchar as motivo
                        from tes.tproceso_caja
                        LIMIT 1)

                        UNION all

                        select
                        0::numeric as saldo,
                        ren.nro_tramite::VARCHAR,
                        ''''::varchar as desc_plantilla,
                        ren.fecha::DATE,
                        ''''::varchar as nit,
                        ''''::varchar as razon_social,
                        ''''::varchar as nro_autorizacion,
                        ''''::varchar as nro_documento,
                        ''''::varchar as codigo_control,
                        ren.monto::numeric,
                        null::numeric as importe_pago_liquido,
                        null::numeric as importe_iva,
                        null::numeric as importe_descuento,
                        null::numeric as importe_descuento_ley,
                        null::numeric as importe_excento,
                        ren.estado::varchar as motivo
                        from tes.tproceso_caja ren
                        left join tes.ttipo_proceso_caja tpc on tpc.id_tipo_proceso_caja=ren.id_tipo_proceso_caja
                        left join tes.tcaja cj on cj.id_caja=ren.id_caja
                        where cj.id_caja = '||v_parametros.id_caja||'
                        and ren.motivo NOT ILIKE ''%RENDICION%''
                        and tpc.codigo!=''SOLREN''

                        and (EXTRACT(day FROM ren.fecha))>= (EXTRACT(day FROM '''||v_ini||''' ::date))
                        and (EXTRACT(MONTH FROM ren.fecha))>= (EXTRACT(MONTH FROM '''||v_ini||''' ::date))
                        and (EXTRACT(year FROM ren.fecha))>= (EXTRACT(year FROM '''||v_ini||''' ::date))

                        and (EXTRACT(day FROM ren.fecha))<= (EXTRACT(day FROM '''||v_fin||''' ::date))
                        and (EXTRACT(MONTH FROM ren.fecha))<= (EXTRACT(MONTH FROM '''||v_fin||''' ::date))
                        and (EXTRACT(year FROM ren.fecha))<= (EXTRACT(year FROM '''||v_fin||''' ::date))

                        union all

                        select
                        0::numeric as saldo,
                        solefe.nro_tramite::varchar,
                        ''''::varchar as desc_plantilla,
                        solefe.fecha_mod::DATE as fecha,
                        ''''::varchar as nit,
                        ''''::varchar as razon_social,
                        ''''::varchar as nro_autorizacion,
                        ''''::varchar as nro_documento,
                        ''''::varchar as codigo_control,
                        solefe.monto::numeric,
                        null::numeric as importe_pago_liquido,
                        null::numeric as importe_iva,
                        null::numeric as importe_descuento,
                        null::numeric as importe_descuento_ley,
                        null::numeric as importe_excento,
                        solefe.estado::varchar as motivo
                        from tes.tsolicitud_efectivo solefe
                        inner join segu.tusuario usu1 on usu1.id_usuario = solefe.id_usuario_reg
                        inner join tes.tcaja caja on caja.id_caja=solefe.id_caja
                        inner join orga.vfuncionario fun on fun.id_funcionario = solefe.id_funcionario
                        left join segu.tusuario usu2 on usu2.id_usuario = solefe.id_usuario_mod
                        left join tes.tsolicitud_efectivo solpri on solpri.id_solicitud_efectivo=solefe.id_solicitud_efectivo_fk
                        where caja.id_caja='||v_parametros.id_caja||'
                        and solefe.estado=''ingresado''

                        and (EXTRACT(day FROM solefe.fecha_mod))>= (EXTRACT(day FROM '''||v_ini||''' ::date))
                        and (EXTRACT(MONTH FROM solefe.fecha_mod))>= (EXTRACT(MONTH FROM '''||v_ini||''' ::date))
                        and (EXTRACT(year FROM solefe.fecha_mod))>= (EXTRACT(year FROM '''||v_ini||''' ::date))

                        and (EXTRACT(day FROM solefe.fecha_mod))<= (EXTRACT(day FROM '''||v_fin||''' ::date))
                        and (EXTRACT(MONTH FROM solefe.fecha_mod))<= (EXTRACT(MONTH FROM '''||v_fin||''' ::date))
                        and (EXTRACT(year FROM solefe.fecha_mod))<= (EXTRACT(year FROM '''||v_fin||''' ::date))

                        union all

                        select
                        0::numeric as saldo,
                        solefe.nro_tramite::varchar,
                        pla.desc_plantilla::varchar,
                        solefe.fecha_entrega::DATE,
                        dc.nit::varchar,
                        dc.razon_social::varchar,
                        dc.nro_autorizacion::varchar,
                        dc.nro_documento::varchar,
                        dc.codigo_control::varchar,
                        dc.importe_pago_liquido::numeric as monto,
                        dc.importe_doc::numeric as importe_pago_liquido,
                        dc.importe_iva::numeric,
                        dc.importe_descuento::numeric,
                        dc.importe_descuento_ley::numeric,
                        dc.importe_excento::numeric,
                        solren.estado::varchar as motivo
                        from tes.tsolicitud_rendicion_det rend
                        inner join tes.tsolicitud_efectivo solren on solren.id_solicitud_efectivo = rend.id_solicitud_efectivo
                        inner join tes.tsolicitud_efectivo solefe on solefe.id_solicitud_efectivo = solren.id_solicitud_efectivo_fk
                        inner join tes.tcaja caja on caja.id_caja = solefe.id_caja
                        left join conta.tdoc_compra_venta dc on dc.id_doc_compra_venta = rend.id_documento_respaldo
                        left join param.tplantilla pla on pla.id_plantilla = dc.id_plantilla
                        where caja.id_caja='||v_parametros.id_caja||' and solren.estado=''rendido''

                        and (EXTRACT(day FROM dc.fecha))>= (EXTRACT(day FROM '''||v_ini||''' ::date))
                        and (EXTRACT(MONTH FROM dc.fecha))>= (EXTRACT(MONTH FROM '''||v_ini||''' ::date))
                        and (EXTRACT(year FROM dc.fecha))>= (EXTRACT(year FROM '''||v_ini||''' ::date))

                        and (EXTRACT(day FROM dc.fecha))<= (EXTRACT(day FROM '''||v_fin||''' ::date))
                        and (EXTRACT(MONTH FROM dc.fecha))<= (EXTRACT(MONTH FROM '''||v_fin||''' ::date))
                        and (EXTRACT(year FROM dc.fecha))<= (EXTRACT(year FROM '''||v_fin||''' ::date))
                        and ';
			--Definicion de la respuesta

            v_consulta:=v_consulta||v_parametros.filtro;

            v_consulta:=v_consulta|| 'order by fecha asc';
            return v_consulta;
    end;

	/*********************************
 	#TRANSACCION:  'TES_CAJA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin
 	#FECHA:		16-12-2013 20:43:44
	***********************************/

	elsif(p_transaccion='TES_CAJA_CONT')then

		begin
        	v_filtro='';
            v_inner='';

            IF (v_parametros.id_funcionario_usu is null) then

                v_parametros.id_funcionario_usu = -1;

            END IF;

            IF  lower(v_parametros.tipo_interfaz) = 'cajavb' THEN

                v_inner =  'inner join wf.testado_wf ew on ew.id_proceso_wf = pc.id_proceso_wf';

                IF p_administrador !=1 THEN
                   v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||') and  (pc.estado = ''solicitado'') and  ';
                 ELSE
                     v_filtro = '(pc.estado = ''solicitado'') and ';
                END IF;

            END IF;

           IF  lower(v_parametros.tipo_interfaz) = 'cajaabierto' THEN

                IF p_administrador !=1 THEN
                	v_i = 1;
                	FOR v_cajas in (select id_caja
                    				from tes.tcajero c
                    				where id_funcionario=v_parametros.id_funcionario_usu
				                    and tipo='responsable'  and  c.estado_reg = 'activo')LOOP
                    	v_id_caja[v_i] = v_cajas.id_caja;
                        v_i = v_i + 1;
                    END LOOP;

                    IF v_i > 1 THEN
                    	v_filtro = '(caja.estado = ''abierto'') and (pc.tipo=''apertura'') and caja.id_caja in('||array_to_string(v_id_caja,',')||') and ';
                    ELSE
                    	v_inner = ' left join tes.tcaja_funcionario cjusu on cjusu.id_caja=caja.id_caja ';
                    	v_filtro = '(caja.estado = ''abierto'') and (pc.tipo=''apertura'') and cjusu.id_funcionario='||v_parametros.id_funcionario_usu::integer||' and ';
                    END IF;

                ELSE
	                 v_filtro = '(caja.estado = ''abierto'') and (pc.tipo=''apertura'') and ';
               END IF;
            END IF;

            IF  lower(v_parametros.tipo_interfaz) = 'solicitudcaja' THEN

                IF p_administrador !=1 THEN
                	v_i = 1;
                	FOR v_cajas in (select id_caja
                    				from tes.tcajero c
                    				where id_funcionario=v_parametros.id_funcionario_usu
				                    and tipo='responsable' and  c.estado_reg = 'activo' )LOOP
                    	v_id_caja[v_i] = v_cajas.id_caja;
                        v_i = v_i + 1;
                    END LOOP;

                    IF v_i > 1 THEN
                    	v_filtro = '(caja.estado = ''abierto'') and (pc.tipo=''apertura'') and caja.id_caja in('||array_to_string(v_id_caja,',')||') and ';
                    ELSE
                        --TODO, RAC  23/12/2017,  si no esun cajero filtra las por lugar segun oficina del funcionario,..... queda pendiente


                    	v_filtro = '(caja.estado = ''abierto'') and (pc.tipo=''apertura'')  and ';


                    END IF;

                ELSE
	                 v_filtro = '(caja.estado = ''abierto'') and (pc.tipo=''apertura'') and ';
               END IF;
            END IF;

            IF  lower(v_parametros.tipo_interfaz) = 'caja' THEN

                IF p_administrador !=1 THEN
                   v_filtro = '(caja.id_usuario_reg='||p_id_usuario||' ) and  pc.estado in (''borrador'',''anulado'',''rechazado'') and ';
                 ELSE
                     v_filtro = 'pc.estado in (''borrador'',''anulado'',''rechazado'') and  ';
                END IF;

            END IF;

            IF  lower(v_parametros.tipo_interfaz) = 'cajacajero' THEN

                IF p_administrador !=1 THEN
                   v_filtro = '(caje.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (pc.estado in (''abierto'',''cerrado'',''aprobado'')) and  ';
                 ELSE
                     v_filtro = '(pc.estado in (''abierto'',''cerrado'',''aprobado'')) and ';
                END IF;

            END IF;

			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(caja.id_caja)
					    from tes.tcaja caja
					    inner join segu.tusuario usu1 on usu1.id_usuario = caja.id_usuario_reg
            			inner join tes.tproceso_caja pc on pc.id_caja= caja.id_caja
						left join segu.tusuario usu2 on usu2.id_usuario = caja.id_usuario_mod
						inner join param.tmoneda mon on mon.id_moneda= caja.id_moneda
                        inner join param.tdepto depto on depto.id_depto=caja.id_depto
                        left join param.tdepto deplb on deplb.id_depto=caja.id_depto_lb
                        left join tes.tcuenta_bancaria ctab on ctab.id_cuenta_bancaria=caja.id_cuenta_bancaria
                        left join tes.tcajero caje on caje.id_caja=caja.id_caja and caje.tipo in (''responsable'',''administrador'')
						left join orga.vfuncionario fun on fun.id_funcionario=caje.id_funcionario
					    '||v_inner||'
                        where caja.estado_reg = ''activo'' AND '||v_filtro;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'TES_DATOS_SEL'
 	#DESCRIPCION:	datos cabecera
 	#AUTOR:		mp
 	#FECHA:		16-07-2018 20:43:44
	***********************************/
    ELSIF(p_transaccion='TES_DATOS_SEL')THEN
    BEGIN
    	v_consulta:=' select
                      fun.desc_funcionario1::varchar as cajero,
                      c.codigo::varchar,
                      p.monto::numeric as salida,
                      p.monto_ren_ingreso::numeric as ingreso,
                      t.nombre::varchar,
                      tes.f_calcular_saldo_caja(c.id_caja) as saldo
                      from tes.tproceso_caja p
                      join tes.tcaja c on c.id_caja = p.id_caja
                      join tes.tcajero ca on ca.id_caja = c.id_caja
                      join orga.vfuncionario fun on fun.id_funcionario=ca.id_funcionario
                      join param.tdepto t on t.id_depto = c.id_depto
                      where ca.tipo=''responsable''
                      and ca.estado=''activo''
                      AND ';

        --Definicion de la respuesta
        v_consulta:=v_consulta||v_parametros.filtro;
        --raise notice '%',v_consulta;
    	--raise exception '%',v_consulta;
        return v_consulta;
    END;

      /*********************************
      #TRANSACCION:  'TES_CAJARQ_SEL'
      #DESCRIPCION:	Reporte de arqueo
      #AUTOR:		mp
      #FECHA:		29-08-2013 00:28:30
      ***********************************/
		elsif(p_transaccion='TES_CAJARQ_SEL') then
     		begin
                select id_tipo_solicitud into v_id_tipo_solicitud_sol
                from tes.ttipo_solicitud
                where codigo='SOLEFE';

                select id_tipo_solicitud into v_id_tipo_solicitud_ren
                from tes.ttipo_solicitud
                where codigo='RENEFE';

                select id_tipo_solicitud into v_id_tipo_solicitud_dev
                from tes.ttipo_solicitud
                where codigo='DEVEFE';

                select id_tipo_solicitud into v_id_tipo_solicitud_rep
                from tes.ttipo_solicitud
                where codigo='REPEFE';

                select id_tipo_solicitud into v_id_tipo_solicitud_ing
                from tes.ttipo_solicitud
                where codigo='INGEFE';

                select id_tipo_solicitud into v_id_tipo_solicitud_sal
                from tes.ttipo_solicitud
                where codigo='SALEFE';

                select id_tipo_solicitud into v_id_tipo_solicitud_ape
                from tes.ttipo_solicitud
                where codigo='APECAJ';
         		-- raise notice '%',v_parametros.fecha;
                -- raise exception '%',v_parametros.fecha;
              v_consulta := '(
              				  select
                              tab.nro_tramite::varchar,
                              tab.codigo::varchar as tipo,
                              tab.motivo::varchar,
                              tab.monto::numeric,
                              NULL::varchar as nombre,
                              0::integer as id_moneda,
                              NULL::varchar as razon_social,
                              0::numeric as importe_pago_liquido,
                              tab.fecha_reg::date as fecha,
                              ''''::varchar as nombre_fun,
                              null::date as fecha_reg,
                              null::varchar as estado_reg,
                              ''''::varchar as nit,
                              ''''::varchar as nro_autorizacion,
                              ''''::varchar as nro_documento,
                              ''''::varchar as codigo_control,
                              0::numeric as importe_doc,
                              0::numeric as importe_iva,
                              ''proceso''::varchar as nom_proceso
                              from
                              (
                              SELECT
                              tesa.nro_tramite,
                              tesa.id_solicitud_efectivo,
                              est.id_estado_wf,
                              test.codigo,
                              est.fecha_reg,
                              est.fecha_mod,
							  tesa.monto,
							  tesa.motivo
                              FROM tes.tsolicitud_efectivo tesa
                              JOIN tes.tcaja caja on caja.id_caja=tesa.id_caja
                              JOIN wf.tproceso_wf wfl on wfl.id_proceso_wf = tesa.id_proceso_wf
                              JOIN wf.testado_wf est on est.id_proceso_wf = wfl.id_proceso_wf
                              JOIN wf.ttipo_estado test on test.id_tipo_estado =est.id_tipo_estado
                              WHERE caja.id_caja='||v_parametros.id_caja||'
                              AND test.codigo in (''entregado'')
                              AND tesa.nro_tramite like ''CAJA%''
                              AND est.fecha_mod::date <= '''||v_parametros.fecha||'''
                              ) as tab
                              left join
                              (
                              SELECT
                              t.nro_tramite,
                              t.id_solicitud_efectivo,
                              esta.id_estado_wf,
                              te.codigo,
                              esta.fecha_reg,
                              esta.fecha_mod,
						      t.monto
                              FROM tes.tsolicitud_efectivo t
                              JOIN tes.tcaja caja on caja.id_caja=t.id_caja
                              JOIN wf.tproceso_wf wflw on wflw.id_proceso_wf = t.id_proceso_wf
                              JOIN wf.testado_wf esta on esta.id_proceso_wf = wflw.id_proceso_wf
                              JOIN wf.ttipo_estado te on te.id_tipo_estado =esta.id_tipo_estado
                              WHERE caja.id_caja='||v_parametros.id_caja||'
                              AND te.codigo in (''finalizado'')
                              AND t.nro_tramite like ''CAJA%''
                              )as y  on tab.id_solicitud_efectivo = y.id_solicitud_efectivo
                              where tab.nro_tramite like ''CAJA%''
							  and y.id_solicitud_efectivo is null
                              )
                              union all
              				  (
                              select
                              solefe.nro_tramite::varchar,
                              dc.tipo::varchar,
                              solefe.motivo::varchar,
                              rend.monto::numeric,
                              pla.desc_plantilla::varchar as nombre,
                              dc.id_moneda::integer,
                              dc.razon_social::varchar,
                              dc.importe_pago_liquido::numeric,
                              dc.fecha::date,
                              ''''::varchar as nombre_fun,
                              dc.fecha_reg::date,
                              dc.estado_reg::varchar as estado_r,
                              dc.nit::varchar,
                              dc.nro_autorizacion::varchar,
                              dc.nro_documento::varchar,
                              dc.codigo_control::varchar,
                              dc.importe_doc::numeric,
                              dc.importe_iva::numeric,
                              null::varchar as nom_proceso

                              from tes.tsolicitud_rendicion_det rend
                              inner join tes.tsolicitud_efectivo solren on solren.id_solicitud_efectivo = rend.id_solicitud_efectivo
                              inner join tes.tsolicitud_efectivo solefe on solefe.id_solicitud_efectivo = solren.id_solicitud_efectivo_fk
                              inner join tes.tcaja caja on caja.id_caja = solefe.id_caja
                              left join conta.tdoc_compra_venta dc on dc.id_doc_compra_venta = rend.id_documento_respaldo
                              left join param.tplantilla pla on pla.id_plantilla = dc.id_plantilla
                              left join param.tmoneda mon on mon.id_moneda = dc.id_moneda
                              inner join segu.tusuario usu1 on usu1.id_usuario = rend.id_usuario_reg
                              left join segu.tusuario usu2 on usu2.id_usuario = rend.id_usuario_mod
                              where rend.id_proceso_caja = '||v_parametros.id_proceso_caja||'

                              union all

                              select
                              tesa.nro_tramite,
                              NULL::varchar as tipo,
                              NULL::varchar as motivo,
                              tesa.monto,
                              NULL::varchar as nombre,
                              0::integer as id_moneda,
                              NULL::varchar as razon_social,
                              0::numeric as importe_pago_liquido,
                              tesa.fecha,
                              ''''::varchar as nombre_fun,
                              null::date as fecha_reg,
                              a.nombre::varchar as estado_reg,
                              ''''::varchar as nit,
                              ''''::varchar as nro_autorizacion,
                              ''''::varchar as nro_documento,
                              ''''::varchar as codigo_control,
                              0::numeric as importe_doc,
                              0::numeric as importe_iva,
                              tp.nro_tramite as nom_proceso

                              from tes.tsolicitud_efectivo tesa
                              inner join segu.tusuario usu1 on usu1.id_usuario = tesa.id_usuario_reg
                              left join segu.tusuario usu2 on usu2.id_usuario = tesa.id_usuario_mod
                              join tes.tcaja caja on caja.id_caja=tesa.id_caja
                              join tes.ttipo_solicitud a on a.id_tipo_solicitud=tesa.id_tipo_solicitud
                              join tes.tproceso_caja tp on tp.id_proceso_caja=tesa.id_proceso_caja_rend
                              where
                              tesa.ingreso_cd=''si'' and
                              tesa.estado=''ingresado'' and
                              id_proceso_caja='||v_parametros.id_proceso_caja||' and
                              a.id_tipo_solicitud='||v_id_tipo_solicitud_ing||'
                              order by nro_tramite ASC
                              )';

                              IF p_id_usuario = 428 THEN
                                 raise notice '%', v_consulta;
                                 --raise exception '%', v_consulta;
                              END IF;
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
PARALLEL UNSAFE
COST 100;