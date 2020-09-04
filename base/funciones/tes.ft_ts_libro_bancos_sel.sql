-- FUNCTION: tes.ft_ts_libro_bancos_sel(integer, integer, character varying, character varying)

-- DROP FUNCTION tes.ft_ts_libro_bancos_sel(integer, integer, character varying, character varying);

CREATE OR REPLACE FUNCTION tes.ft_ts_libro_bancos_sel(
	p_administrador integer,
	p_id_usuario integer,
	p_tabla character varying,
	p_transaccion character varying)
    RETURNS character varying
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
/**************************************************************************
 SISTEMA:		Tesoreria
 FUNCION: 		tes.ft_ts_libro_bancos_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'migra.tts_libro_bancos'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        17-11-2014 09:10:17
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
 
 ISSUE 		   FECHA   			 AUTOR				 DESCRIPCION:
  #27 		 09/04/2019		  Manuel Guerra	      quitar el campo nro_cheque en reporte
  #67		 14.08.2020		  Mercedes Zambrana KPLIAN	listar correo proveedor
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_filtro_saldo		varchar;
    v_fecha_anterior	date;
    v_fecha_ant     	date;
    v_cnx 				varchar;
    v_aux 				varchar;
    v_signo				varchar;    
    v_sign				varchar;
	v_saldo 			numeric;
    v_cbte 				integer;
BEGIN

	v_nombre_funcion = 'tes.ft_ts_libro_bancos_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'TES_LBAN_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		17-11-2014
	***********************************/

	if(p_transaccion='TES_LBAN_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select id_libro_bancos,
                        num_tramite,
                        id_cuenta_bancaria,
                        fecha as fecha,
                        a_favor,
                        nro_cheque,
                        importe_deposito,
                        nro_liquidacion,
                        detalle,
                        origen,
                        observaciones,
                        importe_cheque,
                        id_libro_bancos_fk,
                        estado,
                        nro_comprobante,
                        comprobante_sigma,
                        indice,
                        estado_reg,
                        tipo,
                        nro_deposito,
                        fecha_reg,
                        id_usuario_reg,
                        fecha_mod,
                        id_usuario_mod,
                        usr_reg,
                        usr_mod,
                        id_depto,
                        nombre_depto,
                        id_proceso_wf,
                        id_estado_wf,
                        fecha_cheque_literal,
                        id_finalidad,
                        nombre_finalidad,
                        color,
                        saldo_deposito,
                        nombre_regional,
                        sistema_origen,
                        notificado,
                        fondo_devolucion_retencion
						,correo_proveedor, tabla_correo,
                        columna_correo, id_columna_correo
                        from tes.vlibro_bancos lban
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			raise notice 'consulta %', v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'TES_LBANCHQ_SEL'
 	#DESCRIPCION:	Consulta el siguiente numero de cheque
 	#AUTOR:		Gonzalo Sarmiento Sejas
	***********************************/

	elsif(p_transaccion='TES_LBANCHQ_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select (max(lban.nro_cheque)+1) as num_cheque
						from tes.tts_libro_bancos lban
						where lban.id_cuenta_bancaria='||v_parametros.id_cuenta_bancaria||' and ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			--v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'TES_LBAN_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		17-11-2014
	***********************************/

	elsif(p_transaccion='TES_LBAN_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_libro_bancos)
					    from tes.vlibro_bancos lban
					    where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;

    /*********************************
 	#TRANSACCION:  'TES_LBANSAL_SEL'
 	#DESCRIPCION:	Consulta el los depositos con saldo
 	#AUTOR:		Gonzalo Sarmiento Sejas
	***********************************/

	ELSIF (p_transaccion='TES_LBANSAL_SEL') THEN
        BEGIN

            v_consulta := 'SELECT LBRBAN.id_libro_bancos,
            			   LBRBAN.fecha,
                           LBRBAN.a_favor,
                           LBRBAN.detalle,
                           LBRBAN.observaciones,
                           LBRBAN.importe_deposito,
                           CASE
                             When LBRBAN.tipo = ''deposito'' Then LBRBAN.importe_deposito
                             				  - COALESCE((Select COALESCE(sum(lb.importe_cheque),0)
                                              	From tes.tts_libro_bancos lb
                                                Where lb.id_libro_bancos_fk = LBRBAN.id_libro_bancos and lb.tipo not in (''deposito'',''transf_interna_haber'')), 0)
                                              + COALESCE((Select COALESCE(sum(lb.importe_deposito), 0)
                                              	From tes.tts_libro_bancos lb
                                              	Where lb.id_libro_bancos_fk = LBRBAN.id_libro_bancos and lb.tipo in (''deposito'',''transf_interna_haber'')), 0)
                             When (LBRBAN.tipo in (''cheque'', ''debito_automatico'',''transferencia_carta'') and LBRBAN.id_libro_bancos_fk is not null) Then
                             					(Select COALESCE(lb.importe_deposito,0)
                                                From tes.tts_libro_bancos lb
                             					Where lb.id_libro_bancos = LBRBAN.id_libro_bancos_fk)
                             				   + (Select COALESCE(sum(lb.importe_deposito), 0)
                             					  From tes.tts_libro_bancos lb
                             					  Where lb.id_libro_bancos_fk = LBRBAN.id_libro_bancos_fk and lb.tipo in (''deposito'',''transf_interna_haber''))
                                               - (Select sum(lb2.importe_cheque)
                             					  From tes.tts_libro_bancos lb2
                             					  Where lb2.id_libro_bancos <= LBRBAN.id_libro_bancos and
                                   				  lb2.id_libro_bancos_fk = LBRBAN.id_libro_bancos_fk and
                                   				  lb2.tipo not in (''deposito'',''transf_interna_haber''))
                             Else 0
                           END as saldo
                    		FROM tes.tts_libro_bancos LBRBAN

							WHERE LBRBAN.id_cuenta_bancaria='||v_parametros.id_cuenta_bancaria||'
                            and LBRBAN.tipo = ''deposito'' AND LBRBAN.id_libro_bancos_fk is null ';

            v_filtro_saldo := ' and
      						CASE
       			 			When LBRBAN.tipo = ''deposito'' Then LBRBAN.importe_deposito
                            				 - COALESCE((Select COALESCE(sum(lb.importe_cheque),0)
                                             			 From tes.tts_libro_bancos lb
                                                         Where lb.id_libro_bancos_fk = LBRBAN.id_libro_bancos
                                                         and lb.tipo not in (''deposito'',''transf_interna_haber'')), 0)
                                             + COALESCE((Select COALESCE(sum(lb.importe_deposito), 0)
                         								 From tes.tts_libro_bancos lb
                         								 Where lb.id_libro_bancos_fk = LBRBAN.id_libro_bancos and
                               							 lb.tipo in (''deposito'',''transf_interna_haber'')), 0)
        					When (LBRBAN.tipo in (''cheque'', ''debito_automatico'',''transferencia_carta'') and LBRBAN.id_libro_bancos_fk is not null) Then
                            							(Select COALESCE(lb.importe_deposito, 0)
                                                 		 From tes.tts_libro_bancos lb
                                                 		 Where lb.id_libro_bancos = LBRBAN.id_libro_bancos_fk)
            								 + (Select COALESCE(sum(lb.importe_deposito), 0)
        												 From tes.tts_libro_bancos lb
        												 Where lb.id_libro_bancos_fk = LBRBAN.id_libro_bancos_fk and lb.tipo in (''deposito'',''transf_interna_haber''))
                                             - (Select sum(lb2.importe_cheque)
												         From tes.tts_libro_bancos lb2
												         Where lb2.id_libro_bancos <= LBRBAN.id_libro_bancos and
										                 lb2.id_libro_bancos_fk = LBRBAN.id_libro_bancos_fk and lb2.tipo not in (''deposito'',''transf_interna_haber''))
        					Else 0
      						END > 0 and ';

            v_consulta := v_consulta || v_filtro_saldo;
            v_consulta := v_consulta || v_parametros.filtro;
            v_consulta := v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
 			raise notice '%', v_consulta;
            return v_consulta;
        END;

	/*********************************
 	#TRANSACCION:  'TES_LBANSAL_CONT'
 	#DESCRIPCION:	Conteo de los depositos con saldo
 	#AUTOR:		Gonzalo Sarmiento Sejas
	***********************************/

    ELSIF (p_transaccion='TES_LBANSAL_CONT') THEN
        BEGIN

            v_consulta := 'SELECT COUNT(LBRBAN.id_libro_bancos) AS total
                    		FROM tes.tts_libro_bancos LBRBAN
							WHERE LBRBAN.id_cuenta_bancaria='||v_parametros.id_cuenta_bancaria||'
                            and LBRBAN.tipo = ''deposito'' AND LBRBAN.id_libro_bancos_fk is null ';

            v_filtro_saldo := ' and
      						CASE
       			 			When LBRBAN.tipo = ''deposito'' Then LBRBAN.importe_deposito
                            				 - COALESCE((Select COALESCE(sum(lb.importe_cheque),0)
                                             			 From tes.tts_libro_bancos lb
                                                         Where lb.id_libro_bancos_fk = LBRBAN.id_libro_bancos
                                                         and lb.tipo not in (''deposito'',''transf_interna_haber'')), 0)
                                             + COALESCE((Select COALESCE(sum(lb.importe_deposito), 0)
                         								 From tes.tts_libro_bancos lb
                         								 Where lb.id_libro_bancos_fk = LBRBAN.id_libro_bancos and
                               							 lb.tipo in (''deposito'',''transf_interna_haber'')), 0)
        					When (LBRBAN.tipo in (''cheque'', ''debito_automatico'',''transferencia_carta'') and LBRBAN.id_libro_bancos_fk is not null) Then
                            							(Select COALESCE(lb.importe_deposito, 0)
                                                 		 From tes.tts_libro_bancos lb
                                                 		 Where lb.id_libro_bancos = LBRBAN.id_libro_bancos_fk)
            								 + (Select COALESCE(sum(lb.importe_deposito), 0)
        												 From tes.tts_libro_bancos lb
        												 Where lb.id_libro_bancos_fk = LBRBAN.id_libro_bancos_fk and lb.tipo in (''deposito'',''transf_interna_haber''))
                                             - (Select sum(lb2.importe_cheque)
												         From tes.tts_libro_bancos lb2
												         Where lb2.id_libro_bancos <= LBRBAN.id_libro_bancos and
										                 lb2.id_libro_bancos_fk = LBRBAN.id_libro_bancos_fk and lb2.tipo not in (''deposito'',''transf_interna_haber''))
        					Else 0
      						END > 0 and ';

            v_consulta := v_consulta || v_filtro_saldo;
            v_consulta := v_consulta || v_parametros.filtro;

            return v_consulta;
        END;

        /*********************************
        #TRANSACCION:  'TES_SOLFONAVA_SEL'
        #DESCRIPCION:	Consulta de datos
        #AUTOR:			RCM
        #FECHA:			27/12/2013
        ***********************************/

        ELSIF(p_transaccion='TES_SOLFONAVA_SEL')then

            begin

                --1. Obtención de cadena de conexión a ENDESIS
                /*
                v_cnx = migra.f_obtener_cadena_conexion();

                --1.1 Apertura de la conexión
                v_resp = (SELECT dblink_connect(v_cnx));

                if v_resp != 'OK' then
                    raise exception 'No se pudo conectar con el servidor: No existe ninguna ruta hasta el host';
                end if;

                --Sentencia de la consulta
                v_consulta:='''Select emp.email2,
				              COALESCE(emp.nombre,'''''''') || '''' '''' ||
                              COALESCE(emp.apellido_paterno, '''''''') || '''' ''''||
             				  COALESCE( emp.apellido_materno, '''''''')
       						  From sci.tct_comprobante_libro_bancos cl
            				  inner join tesoro.tts_cuenta_doc cd on cd.id_comprobante = cl.id_comprobante
				              inner join kard.vkp_empleado emp on emp.id_empleado = cd.id_empleado
						      where cl.id_libro_bancos_cheque ='||v_parametros.id_libro_bancos||'''';

                v_consulta := 'select *
                              from dblink('||v_consulta||',true)
                              as (
                              email2 varchar,
                               nombre_completo text)';
            	*/

                v_consulta:= 'Select emp.email_empresa,
                                  emp.desc_funcionario1
                              from tes.tts_libro_bancos t
                              inner join cd.tcuenta_doc cd on cd.id_int_comprobante=t.id_int_comprobante
                              inner join orga.vfuncionario_persona emp on emp.id_funcionario=cd.id_funcionario
                              where t.id_libro_bancos='||v_parametros.id_libro_bancos||'';

                UPDATE tes.tts_libro_bancos
                SET notificado='si'
                WHERE id_libro_bancos= v_parametros.id_libro_bancos;

                return v_consulta;

            end;
	
     /*********************************
      #TRANSACCION:  'TES_REBAN_SEL'
      #DESCRIPCION:	Consulta de datos contabilizados
      #AUTOR:			mp
      #FECHA:			21/05/2018
      ***********************************/
      
    	ELSEIF(p_transaccion='TES_REBAN_SEL')then
        begin
        	--raise EXCEPTION '%',v_parametros.id_cuenta_bancaria;
            select nro_cuenta into v_aux
            from tes.tcuenta_bancaria 
            where id_cuenta_bancaria= v_parametros.id_cuenta_bancaria;
            
            v_fecha_ant = to_char(v_parametros.fecha_ini,'DD/MM/YYYY');
			    
            IF v_parametros.fecha_ini ='2018-01-01' THEN
            	v_sign = '';
            	v_signo = '=';                
                v_cbte = '1440';
            ELSE
            	v_sign ='=';
            	v_signo = '<';                
                v_cbte = '0';
                         
            END IF;
                            
          	v_consulta:='select
                      '''||v_fecha_ant||''' as fecha,
                      '''||v_cbte||''' as id_int_comprobante,
                      ''SALDO ANTERIOR''::varchar as nro_cuenta,
                      null::varchar as nombre_cuenta,
                      null::varchar as nro_cheque,
                      0::numeric as importe_debe_mb,
                      0::numeric as importe_haber_mb, 
                      0::numeric as importe_gasto_mb,
                      0::numeric as importe_recurso_mb,
                                                  
                      0::numeric as importe_debe_mt,
                      0::numeric as importe_haber_mt, 
                      0::numeric as importe_gasto_mt,
                      0::numeric as importe_recurso_mt,
                                                  
                      0::numeric as importe_debe_ma,
                      0::numeric as importe_haber_ma, 
                      0::numeric as importe_gasto_ma,
                      0::numeric as importe_recurso_ma,

                      COALESCE((sum(transa.importe_debe_mb) - sum(transa.importe_haber_mb)),0)::numeric as saldo

                      from conta.tint_transaccion transa
                      inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                      inner join param.tperiodo per on per.id_periodo = icbte.id_periodo
                      inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                      inner join conta.tconfig_tipo_cuenta ctc on ctc.tipo_cuenta = cue.tipo_cuenta     
                      inner join conta.tcuenta_auxiliar cax on cax.id_cuenta=cue.id_cuenta
                      inner join conta.tauxiliar tax on tax.id_auxiliar=cax.id_auxiliar  
                      inner join conta.tconfig_subtipo_cuenta csc on csc.id_config_subtipo_cuenta = cue.id_config_subtipo_cuenta 
                      where 
                      icbte.estado_reg = ''validado'' 
                      and icbte.fecha '||v_signo||' '''|| v_parametros.fecha_ini||'''
                      AND tax.nombre_auxiliar like '''||'%'||v_aux||'%'||'''
                      AND csc.nombre=''BANCOS'' 
                      AND per.id_gestion = 2 

                      union all

                      select
                      fecha,                      
                      icbte.id_int_comprobante::integer,
                      cue.nro_cuenta::varchar,
                      cue.nombre_cuenta::varchar,
                      (select lb.nro_cheque::varchar
                      from tes.tts_libro_bancos lb
                      where lb.id_int_comprobante=icbte.id_int_comprobante
                      LIMIT 1)::varchar as nro_cheque,
                      COALESCE(sum(transa.importe_debe_mb),0)::numeric as importe_debe_mb,
                      COALESCE(sum( transa.importe_haber_mb),0)::numeric as importe_haber_mb, 
                      COALESCE(sum( transa.importe_gasto_mb),0)::numeric as importe_gasto_mb,
                      COALESCE(sum(transa.importe_recurso_mb),0)::numeric as importe_recurso_mb,
                                                  
                      COALESCE(sum(transa.importe_debe_mt),0)::numeric as importe_debe_mt,
                      COALESCE(sum(transa.importe_haber_mt),0)::numeric as importe_haber_mt, 
                      COALESCE(sum(transa.importe_gasto_mt),0)::numeric as importe_gasto_mt,
                      COALESCE(sum(transa.importe_recurso_mt),0)::numeric as importe_recurso_mt,
                                                  
                      COALESCE(sum(transa.importe_debe_ma),0)::numeric as importe_debe_ma,
                      COALESCE(sum(transa.importe_haber_ma),0)::numeric as importe_haber_ma, 
                      COALESCE(sum(transa.importe_gasto_ma),0)::numeric as importe_gasto_ma,
                      COALESCE(sum(transa.importe_recurso_ma),0)::numeric as importe_recurso_ma,

                      0::numeric as saldo
                      from conta.tint_transaccion transa
                      inner join conta.tint_comprobante icbte on icbte.id_int_comprobante = transa.id_int_comprobante
                      inner join param.tdepto dep on dep.id_depto = icbte.id_depto
                      inner join param.tperiodo per on per.id_periodo = icbte.id_periodo                       
                      inner join conta.tcuenta cue on cue.id_cuenta = transa.id_cuenta
                      inner join conta.tconfig_tipo_cuenta ctc on ctc.tipo_cuenta = cue.tipo_cuenta     
                      inner join conta.tcuenta_auxiliar cax on cax.id_cuenta=cue.id_cuenta
                      inner join conta.tauxiliar tax on tax.id_auxiliar=cax.id_auxiliar                   
                      inner join conta.tconfig_subtipo_cuenta csc on csc.id_config_subtipo_cuenta = cue.id_config_subtipo_cuenta
                      where icbte.estado_reg = ''validado'' 
                      and icbte.fecha >'||v_sign||' '''||v_parametros.fecha_ini||''' and icbte.fecha <= '''||v_parametros.fecha_fin||''' 
                      AND tax.nombre_auxiliar like '''||'%'||v_aux||'%'||'''
                      and csc.nombre=''BANCOS'' 
                      AND per.id_gestion = 2 
                      group by icbte.id_int_comprobante,icbte.fecha,cue.nro_cuenta,cue.nombre_cuenta
                      order by fecha,id_int_comprobante ASC';	
                      
            --raise notice '%',v_consulta;          
          	--raise exception '%',v_consulta;            		                      
          return v_consulta;
        end;
    /*********************************
 	#TRANSACCION:  'TES_RELIBA_SEL'
 	#DESCRIPCION:	Reporte libro de bancos
 	#AUTOR:		Gonzalo Sarmiento Sejas
    #27
	***********************************/

	ELSEIF (p_transaccion = 'TES_RELIBA_SEL') THEN
    	BEGIN
        --to_char(now(), ''dd/mm/yyyy'') as fecha,
        --raise notice 'fecha %', v_parametros.fecha_ini;
        --raise notice 'fecha=> %', v_parametros.fecha_ini_reg; 
        --excel.       
        IF (v_parametros.fecha_ini is null) THEN
        	v_fecha_ant = to_char(v_parametros.fecha_ini_reg-1,'DD/MM/YYYY');
           -- raise exception 'fecha=> %', v_fecha_ant;     
          	v_consulta := '(SELECT 
            				null as fecha_reporte,
            				''01/01/2018'' as fecha_reg,
                            '''|| v_fecha_ant||''' as a_favor,                            
                            NULL as detalle,
                            NULL as nro_liquidacion,
                            NULL as nro_comprobante,
                            NULL as comprobante_sigma,
                            NULL as nro_cheque,
                            NULL as debe,
                            NULL as haber,
                            coalesce((Select sum(Coalesce(lbr.importe_deposito,0))-sum(coalesce(lbr.importe_cheque,0))
                                             From tes.tts_libro_bancos lbr
                                             Where lbr.fecha < '''||v_parametros.fecha_ini_reg||'''
                                             and lbr.id_cuenta_bancaria = '||v_parametros.id_cuenta_bancaria||'
                                             and lbr.estado not in (''anulado'', ''borrador'') ),0.00) as saldo,
                            NULL as total_debe,
                            NULL as total_haber,
                            0::numeric as indice,
                            ''01/01/2013''::date as fecha)';
          v_consulta := v_consulta || 
          					'UNION (SELECT                            
                            to_char(LB.fecha, ''dd/mm/yyyy'') as fecha_reporte,
                            to_char(LB.fecha_reg, ''dd/mm/yyyy'') as fecha_reg,
                            LB.a_favor,
                            case when LB.tipo=''transf_interna_debe'' then
                            LB.detalle ||''  -  Cbte destino: ''||COALESCE(lbp.nro_comprobante,'''')
                            when LB.tipo=''transf_interna_haber'' then
                            LB.detalle ||''  -  Cbte origen: ''||COALESCE(lbp.nro_comprobante,'''')
                            else
                            LB.detalle
                            end,
                            LB.nro_liquidacion,
                            LB.nro_comprobante,
                            LB.comprobante_sigma,
                            LB.nro_cheque,
                            case when LB.importe_deposito = 0 then
                                NULL
                            else
                                 LB.importe_deposito
                            end as debe,
                            case when LB.importe_cheque = 0 and LB.estado <> ''anulado'' then
                                NULL
                            else
                                LB.importe_cheque
                            end as haber,

                            (Select sum(lbr.importe_deposito) - sum(lbr.importe_cheque)
                                             From tes.tts_libro_bancos lbr
                                             where
                                             lbr.id_cuenta_bancaria = LB.id_cuenta_bancaria
                                             and lbr.estado not in (''anulado'',''borrador'')
                                             and ((lbr.fecha < LB.fecha) or (lbr.fecha = LB.fecha and lbr.indice <= LB.indice))

                                              ) as saldo,

                            (Select sum(lbr.importe_deposito)
                                             From tes.tts_libro_bancos lbr
                                             where lbr.fecha BETWEEN  '''||v_parametros.fecha_ini_reg||''' and LB.fecha
                                             and lbr.id_cuenta_bancaria = LB.id_cuenta_bancaria
                                             and case when ('''||v_parametros.estado||'''=''Todos'')
                                              then   lbr.estado in (''impreso'',
                                                                       ''entregado'',''cobrado'',
                                                                       ''anulado'',''reingresado'',
                                                                       ''depositado'',''transferido'',
                                                                       ''sigep_swift'')

                                              when ('''||v_parametros.estado||'''=''impreso y entregado'')
                                              then   lbr.estado in (''impreso'', ''entregado'' )

                                              else lbr.estado in ('''||v_parametros.estado||''')
                                              end

                                              and

                                              case when ('''||v_parametros.tipo||'''=''Todos'')
                                              then   lbr.tipo in   (''cheque'',
                                                                    ''deposito'',
                                                                    ''debito_automatico'',
                                                                    ''transferencia_carta'')

                                              when ('''||v_parametros.tipo||'''=''transferencia_interna'')
                                              then   lbr.tipo in (''transf_interna_debe'')

                                              else lbr.tipo in ('''||v_parametros.tipo||''')
                                              end

                                              and
                                              case when ('||v_parametros.id_finalidad||'=0)
                                              then   lbr.id_finalidad in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,14,15,16,17,18,19,20)
                                              else lbr.id_finalidad in ('||v_parametros.id_finalidad||')
                                              end
                                             ) as total_debe,

                            (Select sum(lbr.importe_cheque)
                                             From tes.tts_libro_bancos lbr
                                             where lbr.fecha BETWEEN  '''||v_parametros.fecha_ini_reg||''' and  LB.fecha
                                             and lbr.id_cuenta_bancaria = LB.id_cuenta_bancaria
                                             and case when ('''||v_parametros.estado||'''=''Todos'')
                                              then   lbr.estado in (''impreso'',
                                                                       ''entregado'',''cobrado'',
                                                                       ''anulado'',''reingresado'',
                                                                       ''depositado'',''transferido'',
                                                                       ''sigep_swift'' )

                                              when ('''||v_parametros.estado||'''=''impreso y entregado'')
                                              then   lbr.estado in (''impreso'', ''entregado'' )

                                              else lbr.estado in ('''||v_parametros.estado||''')
                                              end

                                              and

                                              case when ('''||v_parametros.tipo||'''=''Todos'')
                                              then   lbr.tipo in   (''cheque'',
                                                                              ''deposito'',
                                                                              ''debito_automatico'',
                                                                              ''transferencia_carta'')

                                              when ('''||v_parametros.tipo||'''=''transferencia_interna'')
                                              then   lbr.tipo in (''transf_interna_haber'')

                                              else lbr.tipo in ('''||v_parametros.tipo||''')
                                              end
                                              and
                                              case when ('||v_parametros.id_finalidad||'=0)
                                              then   lbr.id_finalidad in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,14,15,16,17,18,19,20)
                                              else lbr.id_finalidad in ('||v_parametros.id_finalidad||')
                                              end
                                              ) as total_haber,

                           coalesce( LB.indice,0),
                            LB.fecha

                            FROM tes.tts_libro_bancos LB
                            LEFT JOIN tes.tts_libro_bancos lbp on lbp.id_libro_bancos=LB.id_libro_bancos_fk
                            WHERE
                            LB.id_cuenta_bancaria = '||v_parametros.id_cuenta_bancaria||' and
                            LB.fecha >= '''||v_parametros.fecha_ini_reg||''' and  LB.fecha <=  '''||v_parametros.fecha_fin_reg||''' 
							and lb.estado not in (''anulado'',''borrador'') and
                            lb.fecha::date >= '''||v_parametros.fecha_ini_reg||''' and
                            lb.fecha is not null 
                            )  
                            order by fecha_reg, indice asc';
          					raise notice '%',v_consulta;
                            --raise exception '%',v_consulta;
     	ELSE
        	v_fecha_anterior = to_char(v_parametros.fecha_ini-1, 'dd/mm/yyyy') ;
        	raise notice 'fecha anterior %', v_fecha_anterior;     
--         raise exception '%',v_fecha_anterior;       
          	v_consulta := '(SELECT 
            				'''||v_fecha_anterior||''' as fecha_reporte,
            				NULL as fecha_reg,
                            ''SALDO ANTERIOR'' as a_favor,
                            NULL as detalle,
                            NULL as nro_liquidacion,
                            NULL as nro_comprobante,
                            NULL as comprobante_sigma,
                            NULL as nro_cheque,
                            NULL as debe,
                            NULL as haber,
                           
                                    coalesce((Select sum(Coalesce(lbr.importe_deposito,0))-sum(coalesce(lbr.importe_cheque,0))
                                             From tes.tts_libro_bancos lbr
                                             Where lbr.fecha < '''||v_parametros.fecha_ini||'''
                                             and lbr.id_cuenta_bancaria = '||v_parametros.id_cuenta_bancaria||'
                                             and lbr.estado not in (''anulado'', ''borrador'') ),0.00)  as saldo,
                            NULL as total_debe,
                            NULL as total_haber,
                            0::numeric as indice,
                            ''01/01/2013''::date as fecha)';
          v_consulta := v_consulta || 
          					'UNION 
                            (SELECT
                            to_char(LB.fecha, ''dd/mm/yyyy'') as fecha_reporte,
                            to_char(LB.fecha_reg, ''dd/mm/yyyy'') as fecha_reg,
                            LB.a_favor,
                            case when LB.tipo=''transf_interna_debe'' then
                            LB.detalle ||''  -  Cbte destino: ''||COALESCE(lbp.nro_comprobante,'''')
                            when LB.tipo=''transf_interna_haber'' then
                            LB.detalle ||''  -  Cbte origen: ''||COALESCE(lbp.nro_comprobante,'''')
                            else
                            LB.detalle
                            end,
                            LB.nro_liquidacion,
                            LB.nro_comprobante,
                            LB.comprobante_sigma,
                            LB.nro_cheque,
                            case when LB.importe_deposito = 0 then
                                NULL
                            else
                                 LB.importe_deposito 
                            end as debe,
                            case when LB.importe_cheque = 0 and LB.estado <> ''anulado'' then
                                NULL
                            else
                                 LB.importe_cheque 
                            end as haber,

                            (Select sum(lbr.importe_deposito) - sum(lbr.importe_cheque)
                                             From tes.tts_libro_bancos lbr
                                             where
                                             lbr.id_cuenta_bancaria = LB.id_cuenta_bancaria
                                             and lbr.estado not in (''anulado'',''borrador'')
                                             and ((lbr.fecha < LB.fecha) or (lbr.fecha = LB.fecha and lbr.indice <= LB.indice))

                                              )  as saldo,

                             (Select sum(lbr.importe_deposito)
                                             From tes.tts_libro_bancos lbr
                                             where lbr.fecha BETWEEN  '''||v_parametros.fecha_ini||''' and LB.fecha
                                             and lbr.id_cuenta_bancaria = LB.id_cuenta_bancaria
                                             and case when ('''||v_parametros.estado||'''=''Todos'')
                                              then   lbr.estado in (''impreso'',
                                                                       ''entregado'',''cobrado'',
                                                                       ''anulado'',''reingresado'',
                                                                       ''depositado'',''transferido'',
                                                                       ''sigep_swift'' )

                                              when ('''||v_parametros.estado||'''=''impreso y entregado'')
                                              then   lbr.estado in (''impreso'', ''entregado'' )

                                              else lbr.estado in ('''||v_parametros.estado||''')
                                              end

                                              and

                                              case when ('''||v_parametros.tipo||'''=''Todos'')
                                              then   lbr.tipo in   (''cheque'',
                                                                    ''deposito'',
                                                                    ''debito_automatico'',
                                                                    ''transferencia_carta'')

                                              when ('''||v_parametros.tipo||'''=''transferencia_interna'')
                                              then   lbr.tipo in (''transf_interna_debe'')

                                              else lbr.tipo in ('''||v_parametros.tipo||''')
                                              end

                                              and
                                              case when ('||v_parametros.id_finalidad||'=0)
                                              then   lbr.id_finalidad in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,14,15,16,17,18,19,20)
                                              else lbr.id_finalidad in ('||v_parametros.id_finalidad||')
                                              end
                                             )  as total_debe,

                             (Select sum(lbr.importe_cheque)
                                             From tes.tts_libro_bancos lbr
                                             where lbr.fecha BETWEEN  '''||v_parametros.fecha_ini||''' and  LB.fecha
                                             and lbr.id_cuenta_bancaria = LB.id_cuenta_bancaria
                                             and case when ('''||v_parametros.estado||'''=''Todos'')
                                              then   lbr.estado in (''impreso'',
                                                                       ''entregado'',''cobrado'',
                                                                       ''anulado'',''reingresado'',
                                                                       ''depositado'',''transferido'',
                                                                       ''sigep_swift'' )

                                              when ('''||v_parametros.estado||'''=''impreso y entregado'')
                                              then   lbr.estado in (''impreso'', ''entregado'' )

                                              else lbr.estado in ('''||v_parametros.estado||''')
                                              end

                                              and

                                              case when ('''||v_parametros.tipo||'''=''Todos'')
                                              then   lbr.tipo in   (''cheque'',
                                                                              ''deposito'',
                                                                              ''debito_automatico'',
                                                                              ''transferencia_carta'')

                                              when ('''||v_parametros.tipo||'''=''transferencia_interna'')
                                              then   lbr.tipo in (''transf_interna_haber'')

                                              else lbr.tipo in ('''||v_parametros.tipo||''')
                                              end
                                              and
                                              case when ('||v_parametros.id_finalidad||'=0)
                                              then   lbr.id_finalidad in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,14,15,16,17,18,19,20)
                                              else lbr.id_finalidad in ('||v_parametros.id_finalidad||')
                                              end
                                              )  as total_haber,

                            LB.indice,
                            LB.fecha

                            FROM tes.tts_libro_bancos LB
                            LEFT JOIN tes.tts_libro_bancos lbp on lbp.id_libro_bancos=LB.id_libro_bancos_fk
                            WHERE
                            LB.id_cuenta_bancaria = '||v_parametros.id_cuenta_bancaria||' and
                            LB.fecha BETWEEN  '''||v_parametros.fecha_ini||''' and   '''||v_parametros.fecha_fin||''' and

                            case when ('''||v_parametros.estado||'''=''Todos'')
                            then   LB.estado in (''impreso'',
                                                     ''entregado'',''cobrado'',
                                                     ''anulado'',''reingresado'',
                                                     ''depositado'',''transferido'',
                                                     ''sigep_swift'' )

                            when ('''||v_parametros.estado||'''=''impreso y entregado'')
                            then   LB.estado in (''impreso'', ''entregado'' )

                            else LB.estado in ('''||v_parametros.estado||''')
                            end

                            and

                            case when ('''||v_parametros.tipo||'''=''Todos'')
                            then   LB.tipo in   (''cheque'',
                                                            ''deposito'',
                                                            ''debito_automatico'',
                                                            ''transferencia_carta'')

                            when ('''||v_parametros.tipo||'''=''transferencia_interna'')
                            then   lb.tipo in (''transf_interna_debe'',''transf_interna_haber'')
                            else LB.tipo in ('''||v_parametros.tipo||''')
                            end

                            and
                            case when ('||v_parametros.id_finalidad||'=0)
                            then   0=0
                            else LB.id_finalidad in ('||v_parametros.id_finalidad||')
                            end
                            )  
                            order by fecha, indice asc';
		  END IF;
          raise notice '%',v_consulta;
         --raise exception '%',v_consulta;
          --raise exception  'libro de bancos %',v_consulta;
		  --Devuelve la respuesta
		  return v_consulta;
             
       END;    

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
$BODY$;

ALTER FUNCTION tes.ft_ts_libro_bancos_sel(integer, integer, character varying, character varying)
    OWNER TO postgres;