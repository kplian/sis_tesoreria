--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_plan_pago_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.f_plan_pago_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tplan_pago'
 AUTOR: 		 (admin)
 FECHA:	        10-04-2013 15:43:23
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_filtro			varchar;
    
    v_historico        varchar;
    v_inner            varchar;
    v_strg_pp         varchar;
    v_strg_obs         varchar;
    va_id_depto        integer[];
    
  
BEGIN

	v_nombre_funcion = 'tes.f_plan_pago_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_PLAPA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		10-04-2013 15:43:23
	***********************************/

	if(p_transaccion='TES_PLAPA_SEL')then
     				
    	begin
        
            
            -- obtiene los departamentos del usuario
            select  
                pxp.aggarray(depu.id_depto)
            into 
                va_id_depto
            from param.tdepto_usuario depu 
            where depu.id_usuario =  p_id_usuario; 
        
        
       
        
            v_filtro='';
            
            IF (v_parametros.id_funcionario_usu is null) then
              	
                v_parametros.id_funcionario_usu = -1;
            
            END IF;
            
            
            
            IF  lower(v_parametros.tipo_interfaz) = 'planpagovb' THEN
                
                IF p_administrador !=1 THEN
                   v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||'  or (ew.id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||'))    ) and  (lower(plapa.estado)!=''borrador'') and lower(plapa.estado)!=''pagado'' and lower(plapa.estado)!=''devengado'' and lower(plapa.estado)!=''anticipado'' and lower(plapa.estado)!=''aplicado'' and lower(plapa.estado)!=''anulado'' and  ';
                 ELSE
                     v_filtro = ' (lower(plapa.estado)!=''borrador''  and lower(plapa.estado)!=''pendiente''  and lower(plapa.estado)!=''pagado'' and lower(plapa.estado)!=''devengado'' and lower(plapa.estado)!=''anticipado'' and lower(plapa.estado)!=''aplicado'' and lower(plapa.estado)!=''anulado'') and ';
                END IF;
                
                
            END IF; 
            
            IF  pxp.f_existe_parametro(p_tabla,'historico') THEN
             v_historico =  v_parametros.historico;
            ELSE
               v_historico = 'no';
            END IF;
            
            
            IF  lower(v_parametros.tipo_interfaz) = 'planpagovbasistente' and v_historico != 'si'  THEN
              	v_filtro = ' (ew.id_funcionario  IN (select * FROM orga.f_get_funcionarios_x_usuario_asistente(now()::date,'||p_id_usuario||') AS (id_funcionario INTEGER))) and ';
            	v_filtro = v_filtro || ' (lower(plapa.estado)=''vbgerente'') and ';
            END IF;
            
            IF  lower(v_parametros.tipo_interfaz) = 'planpagoconformidadpendiente'  THEN
            	IF p_administrador !=1 THEN
              		v_filtro = ' (op.id_funcionario  = ' || v_parametros.id_funcionario_usu::varchar || ' or op.id_usuario_reg = ' || p_id_usuario||' ) and ';
                END IF;
            	v_filtro = v_filtro || ' lower(plapa.tipo) in (''devengado'',''devengado_pagado'',''devengado_pagado_1c'') and plapa.fecha_conformidad is null and  ';
            END IF;
            
            IF  lower(v_parametros.tipo_interfaz) = 'planpagoconformidadrealizada'  THEN
              	IF p_administrador !=1 THEN
              		v_filtro = ' (op.id_funcionario  = ' || v_parametros.id_funcionario_usu::varchar || ' or op.id_usuario_reg = ' || p_id_usuario||' ) and ';
                END IF;
            	v_filtro = v_filtro || ' lower(plapa.tipo) in (''devengado'',''devengado_pagado'',''devengado_pagado_1c'') and plapa.fecha_conformidad is not null and  ';
            END IF;
            
            
            
            
            
            
            
            IF v_historico =  'si' THEN
            
              
                v_inner =  'inner join wf.testado_wf ew on ew.id_proceso_wf = plapa.id_proceso_wf ';
                v_strg_pp = 'DISTINCT(plapa.id_plan_pago)';
                v_strg_obs = '''---''::text  as obs_wf'; 
              
               IF  lower(v_parametros.tipo_interfaz) != 'planpagovbasistente'  THEN
                      IF p_administrador !=1 THEN                    
                            --v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  ';
                       v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||'  or (ew.id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||'))    ) and  ';
                     ELSE 
                        v_filtro = '';
                     END IF;
               ELSE
                  --historico para interface de asistentes
                  v_filtro = ' (ew.id_funcionario  IN (select * FROM orga.f_get_funcionarios_x_usuario_asistente(now()::date,'||p_id_usuario||') AS (id_funcionario INTEGER))) and ';
            	
               END IF;
               
            
            ELSE
            
               v_inner =  'inner join wf.testado_wf ew on ew.id_estado_wf = plapa.id_estado_wf';
               v_strg_pp = 'plapa.id_plan_pago';
               v_strg_obs = 'ew.obs as obs_wf'; 
               
               
             END IF;
        
        
        
        
    		--Sentencia de la consulta
			v_consulta:='select
						'||v_strg_pp||', 
						plapa.estado_reg,
						plapa.nro_cuota,
						plapa.monto_ejecutar_total_mb,
						plapa.nro_sol_pago,
						plapa.tipo_cambio,
						plapa.fecha_pag,
						plapa.id_proceso_wf,
						plapa.fecha_dev,
						plapa.estado,
						plapa.tipo_pago,
						plapa.monto_ejecutar_total_mo,
						plapa.descuento_anticipo_mb,
						plapa.obs_descuentos_anticipo,
						plapa.id_plan_pago_fk,
						plapa.id_obligacion_pago,
						plapa.id_plantilla,
						plapa.descuento_anticipo,
						plapa.otros_descuentos,
						plapa.tipo,
						plapa.obs_monto_no_pagado,
						plapa.obs_otros_descuentos,
						plapa.monto,
						plapa.id_int_comprobante,
						plapa.nombre_pago,
						plapa.monto_no_pagado_mb,
						plapa.monto_mb,
						plapa.id_estado_wf,
						plapa.id_cuenta_bancaria,
						plapa.otros_descuentos_mb,
						plapa.forma_pago,
						plapa.monto_no_pagado,
						plapa.fecha_reg,
						plapa.id_usuario_reg,
						plapa.fecha_mod,
						plapa.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        plapa.fecha_tentativa,
                        pla.desc_plantilla,
                        plapa.liquido_pagable,
                        plapa.total_prorrateado,
                        plapa.total_pagado ,                       
						coalesce(cb.nombre_institucion,''S/N'') ||'' (''||coalesce(cb.nro_cuenta,''S/C'')||'')'' as desc_cuenta_bancaria ,
                        plapa.sinc_presupuesto ,
                        plapa.monto_retgar_mb,
                        plapa.monto_retgar_mo,
                        descuento_ley, 
                        obs_descuentos_ley , 
                        descuento_ley_mb, 
                        porc_descuento_ley, 
                        plapa.nro_cheque,
                        plapa.nro_cuenta_bancaria,
                        plapa.id_cuenta_bancaria_mov,
                        cbanmo.descripcion as desc_deposito,
                        op.numero  as numero_op ,
                        op.id_depto_conta,
                        op.id_moneda ,
                        mon.tipo_moneda ,
                        mon.codigo as desc_moneda,
                        op.num_tramite,
                        plapa.porc_monto_excento_var,
                        plapa.monto_excento,
                        '||v_strg_obs||' ,
                        plapa.obs_descuento_inter_serv,
                        plapa.descuento_inter_serv,
                        plapa.porc_monto_retgar,
                        fun.desc_funcionario1::text,
                        plapa.revisado_asistente,
                        plapa.conformidad,
                        plapa.fecha_conformidad,
                        op.tipo_obligacion,
                        plapa.monto_ajuste_ag,
                        plapa.monto_ajuste_siguiente_pago,
                        op.pago_variable,
                        plapa.monto_anticipo,
                        plapa.fecha_costo_ini,
                        plapa.fecha_costo_fin,
                        funwf.desc_funcionario1::text as funcionario_wf,
                        plapa.tiene_form500,
                        plapa.id_depto_lb,
                        depto.nombre as desc_depto_lb,
                        op.ultima_cuota_dev,
                        plapa.id_depto_conta as id_depto_conta_pp,
                        depc.nombre_corto as desc_depto_conta_pp,
                        (select count(*)
                             from unnest(pwf.id_tipo_estado_wfs) elemento
                             where elemento = ew.id_tipo_estado) as contador_estados,
                        depto.prioridad as prioridad_lp
                                                 
                        from tes.tplan_pago plapa
                        inner join wf.tproceso_wf pwf on pwf.id_proceso_wf = plapa.id_proceso_wf 
                        inner join tes.tobligacion_pago op on op.id_obligacion_pago = plapa.id_obligacion_pago
                        inner join param.tmoneda mon on mon.id_moneda = op.id_moneda
                        '||v_inner||'  
                        left join param.tplantilla pla on pla.id_plantilla = plapa.id_plantilla
                        inner join segu.tusuario usu1 on usu1.id_usuario = plapa.id_usuario_reg
                        left join tes.vcuenta_bancaria cb on cb.id_cuenta_bancaria = plapa.id_cuenta_bancaria
                        left join segu.tusuario usu2 on usu2.id_usuario = plapa.id_usuario_mod
                        left join tes.tcuenta_bancaria_mov cbanmo on cbanmo.id_cuenta_bancaria_mov = plapa.id_cuenta_bancaria_mov
                        left join param.vproveedor pro on pro.id_proveedor = op.id_proveedor
                        left join orga.vfuncionario fun on fun.id_funcionario = op.id_funcionario
                        left join orga.vfuncionario funwf on funwf.id_funcionario = ew.id_funcionario
                        left join param.tdepto depto on depto.id_depto = plapa.id_depto_lb
                        left join tes.tts_libro_bancos lb on lb.id_int_comprobante=plapa.id_int_comprobante
                        left join param.tdepto depc on depc.id_depto = plapa.id_depto_conta
                       where  plapa.estado_reg=''activo''  and '||v_filtro;
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
                
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ', nro_cuota ASC limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

             raise notice '%',v_consulta;

			--Devuelve la respuesta
			return v_consulta;
						
		end;
        
   /*********************************    
 	#TRANSACCION:  'TES_PLAPA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		10-04-2013 15:43:23
	***********************************/

	elsif(p_transaccion='TES_PLAPA_CONT')then

		begin
        
        
        v_filtro='';
            
            IF (v_parametros.id_funcionario_usu is null) then
              	v_parametros.id_funcionario_usu = -1;
            END IF;
            
            
            IF  lower(v_parametros.tipo_interfaz) = 'planpagovb' THEN
                 IF p_administrador !=1 THEN
                    v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (lower(plapa.estado)!=''borrador'') and lower(plapa.estado)!=''pagado'' and lower(plapa.estado)!=''devengado'' and lower(plapa.estado)!=''anticipado'' and lower(plapa.estado)!=''aplicado''  and ';
                 ELSE
                      v_filtro = ' (lower(plapa.estado)!=''borrador''  and lower(plapa.estado)!=''pendiente''  and lower(plapa.estado)!=''pagado'' and lower(plapa.estado)!=''devengado'' and lower(plapa.estado)!=''anticipado'' and lower(plapa.estado)!=''aplicado'' and lower(plapa.estado)!=''anulado'') and ';
                END IF;
            END IF;
            
            IF  lower(v_parametros.tipo_interfaz) = 'planpagovbasistente' THEN
              v_filtro = ' (ew.id_funcionario  IN (select * FROM orga.f_get_funcionarios_x_usuario_asistente(now()::date,'||p_id_usuario||') AS (id_funcionario INTEGER))) and ';
            END IF;
            
            
            IF  pxp.f_existe_parametro(p_tabla,'historico') THEN
                v_historico =  v_parametros.historico;
            ELSE
               v_historico = 'no';
            END IF;
            
            IF v_historico =  'si' THEN
            
               v_inner =  'inner join wf.testado_wf ew on ew.id_proceso_wf = plapa.id_proceso_wf';
               v_strg_pp = 'DISTINCT(plapa.id_plan_pago)'; 
              
                IF p_administrador =1 THEN
                
                       --v_filtro = ' (lower(plapa.estado)!=''borrador'' ) and ';
                
               END IF;
            
            ELSE
            
               v_inner =  'inner join wf.testado_wf ew on ew.id_estado_wf = plapa.id_estado_wf';
               v_strg_pp = 'plapa.id_plan_pago';
               
               
             END IF;
        
         
        
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count('||v_strg_pp||')
						from tes.tplan_pago plapa
                        inner join tes.tobligacion_pago op on op.id_obligacion_pago = plapa.id_obligacion_pago
                        inner join param.tmoneda mon on mon.id_moneda = op.id_moneda
                        '||v_inner||'  
                        left join param.tplantilla pla on pla.id_plantilla = plapa.id_plantilla
                        inner join segu.tusuario usu1 on usu1.id_usuario = plapa.id_usuario_reg
                        left join tes.vcuenta_bancaria cb on cb.id_cuenta_bancaria = plapa.id_cuenta_bancaria
                        left join segu.tusuario usu2 on usu2.id_usuario = plapa.id_usuario_mod
                        left join orga.vfuncionario fun on fun.id_funcionario = op.id_funcionario
                        left join tes.tcuenta_bancaria_mov cbanmo on cbanmo.id_cuenta_bancaria_mov = plapa.id_cuenta_bancaria_mov
                        left join param.vproveedor pro on pro.id_proveedor = op.id_proveedor
                        left join orga.vfuncionario funwf on funwf.id_funcionario = ew.id_funcionario
                        left join param.tdepto depto on depto.id_depto = plapa.id_depto_lb
                        left join tes.tts_libro_bancos lb on lb.id_int_comprobante=plapa.id_int_comprobante
                      where  plapa.estado_reg=''activo''   and '||v_filtro;
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;
         
            raise notice '% .',v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;
		     
        

	/*********************************    
 	#TRANSACCION:  'TES_PLAPAOB_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		18-07-2013 15:43:23
	***********************************/

	elsif(p_transaccion='TES_PLAPAOB_SEL')then
     				
    	begin
        
        
    		--Sentencia de la consulta
			v_consulta:='select
						plapa.id_plan_pago,
						plapa.nro_cuota,
						plapa.monto_ejecutar_total_mb,
						plapa.nro_sol_pago,
						plapa.tipo_cambio,
						plapa.fecha_pag,
						plapa.fecha_dev,
						plapa.estado,
						plapa.tipo_pago,
						plapa.monto_ejecutar_total_mo,
						plapa.descuento_anticipo_mb,
						plapa.obs_descuentos_anticipo,
						plapa.id_plan_pago_fk,
						plapa.descuento_anticipo,
						plapa.otros_descuentos,
						plapa.tipo,
						plapa.obs_monto_no_pagado,
						plapa.obs_otros_descuentos,
						plapa.monto,
						plapa.nombre_pago,
						plapa.monto_no_pagado_mb,
						plapa.monto_mb,
						plapa.otros_descuentos_mb,
						plapa.forma_pago,
						plapa.monto_no_pagado,
                        plapa.fecha_tentativa,
                        pla.desc_plantilla,
                        plapa.liquido_pagable,
                        plapa.total_prorrateado,
                        plapa.total_pagado ,                       
						cb.nombre_institucion ||'' (''||cb.nro_cuenta||'')'' as desc_cuenta_bancaria ,
                        plapa.sinc_presupuesto ,
                        plapa.monto_retgar_mb,
                        plapa.monto_retgar_mo                                             
						from tes.tplan_pago plapa
                        left join param.tplantilla pla on pla.id_plantilla = plapa.id_plantilla
						inner join segu.tusuario usu1 on usu1.id_usuario = plapa.id_usuario_reg
                        left join tes.vcuenta_bancaria cb on cb.id_cuenta_bancaria = plapa.id_cuenta_bancaria
                        left join segu.tusuario usu2 on usu2.id_usuario = plapa.id_usuario_mod
                       where  plapa.estado_reg=''activo''  and plapa.id_obligacion_pago='||v_parametros.id_obligacion_pago||' and ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

             raise notice '%',v_consulta;

			--Devuelve la respuesta
			return v_consulta;
						
		end;
        
   	/*********************************    
 	#TRANSACCION:  'TES_PLAPAREP_SEL'
 	#DESCRIPCION:	Consulta para reporte plan de pagos
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		19-07-2013 15:43:23
	***********************************/

	elsif(p_transaccion='TES_PLAPAREP_SEL')then
     				
    	begin
        
    		  --  Sentencia de la consulta
              v_consulta:='select 
                               	  pg.estado,
                                  op.numero as numero_oc,
                                  pv.desc_proveedor as proveedor,
                                  pg.nro_cuota as nro_cuota,
                                  pg.fecha_dev as fecha_devengado	,
                                  pg.fecha_pag as fecha_pago,
                                  pg.forma_pago as forma_pago,
                                  pg.tipo_pago as tipo_pago,
                                  mon.moneda as moneda,
                                  mon.codigo as codigo_moneda,
                                  op.tipo_cambio_conv as tipo_cambio,
                                  pg.monto as importe,
                                  pg.monto_no_pagado as monto_no_pagado,
                                  pg.otros_descuentos as otros_descuentos,
                                  pg.obs_otros_descuentos,
                                  pg.descuento_ley,
                                  pg.obs_descuentos_ley,
                                  pg.monto_ejecutar_total_mo as monto_ejecutado_total,
                                  pg.liquido_pagable as liquido_pagable,
                                  pg.total_pagado as total_pagado,
                                  pg.fecha_reg,
                                  op.total_pago,
                                  pg.tipo,
                                  pg.monto_excento     
                        from tes.tplan_pago pg
                        inner join tes.tobligacion_pago op on op.id_obligacion_pago=pg.id_obligacion_pago
                        inner join param.vproveedor pv on pv.id_proveedor=op.id_proveedor
                        left join tes.tcuenta_bancaria cta on cta.id_cuenta_bancaria=pg.id_cuenta_bancaria
                        inner join param.tmoneda mon on mon.id_moneda=op.id_moneda  
                        where pg.id_plan_pago='||v_parametros.id_plan_pago||' and ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;
    
	
		
	/*********************************    
 	#TRANSACCION:  'TES_VERDIS_SEL'
 	#DESCRIPCION:	Consulta para verificar la disponibilidad presupuestaria de toda la cuota
 	#AUTOR:			RCM
 	#FECHA:			15/12/2013
	***********************************/

	elsif(p_transaccion='TES_VERDIS_SEL')then
     				
    	begin
        
    		--Sentencia de la consulta
              v_consulta:='select
              				id_partida,  id_presupuesto, id_moneda, importe,
							presupuesto, desc_partida , desc_presupuesto
              				from
							tes.f_verificar_disponibilidad_presup_oblig_pago('||v_parametros.id_plan_pago ||')
							as (id_partida integer, id_presupuesto integer, id_moneda INTEGER, importe numeric,
							presupuesto varchar,
							desc_partida text, desc_presupuesto text)
							where ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			
			--Devuelve la respuesta
			return v_consulta;
						
		end;
    
	/*********************************    
 	#TRANSACCION:  'TES_VERDIS_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:			RCM	
 	#FECHA:			15/12/2013
	***********************************/

	elsif(p_transaccion='TES_VERDIS_CONT')then

		begin
        
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_partida)
						from
						tes.f_verificar_disponibilidad_presup_oblig_pago('||v_parametros.id_plan_pago ||')
						as (id_partida integer, id_presupuesto integer, id_moneda INTEGER, importe numeric,
						presupuesto varchar,
						desc_partida text, desc_presupuesto text)
                        where ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
            
            raise notice '%',v_consulta;
			
			--Devuelve la respuesta
			return v_consulta;

		end;
	
	/*********************************    
 	#TRANSACCION:  'TES_ACTCONFPP_SEL'
 	#DESCRIPCION:	Acta de Conformidad Maestro Plan de Pago
 	#AUTOR:			JRR	
 	#FECHA:			30/09/2014
	***********************************/

	elsif(p_transaccion='TES_ACTCONFPP_SEL')then

		begin
        
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select fun.desc_funcionario1, prov.desc_proveedor, 
            			to_char( pp.fecha_conformidad,''DD/MM/YYYY''),pp.conformidad, 
                        cot.numero_oc,op.numero, pp.nro_cuota,op.num_tramite::varchar,
                         pxp.html_rows(''<td>'' || ci.desc_ingas || ''</td><td>'' || od.descripcion|| ''</td>'')::text,
                         (case when (pxp.list_unique(ci.tipo)) is null THEN
                            ''Servicio''
                         ELSE
                            pxp.list_unique(ci.tipo)
                         END)::varchar as tipo
						from tes.tplan_pago pp
						inner join tes.tobligacion_pago op
							on pp.id_obligacion_pago = op.id_obligacion_pago
						inner join param.vproveedor prov 
							on prov.id_proveedor = op.id_proveedor
						inner join orga.vfuncionario fun
							on fun.id_funcionario = op.id_funcionario
						left join adq.tcotizacion cot
							on cot.id_obligacion_pago = op.id_obligacion_pago
                        inner join tes.tobligacion_det od
                            on od.id_obligacion_pago = op.id_obligacion_pago
                        inner join param.tconcepto_ingas ci 
                            on ci.id_concepto_ingas = od.id_concepto_ingas
						where ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' group by fun.desc_funcionario1, prov.desc_proveedor, pp.fecha_conformidad,pp.conformidad, cot.numero_oc,op.numero, pp.nro_cuota,op.num_tramite';
            raise notice '%',v_consulta;
			
			--Devuelve la respuesta
			return v_consulta;

		end;
    
    /*********************************    
 	#TRANSACCION:  'TES_PAXCIG_SEL'
 	#DESCRIPCION:	Listado de pagos por concepto
 	#AUTOR:			JRR	
 	#FECHA:			15/12/2013
	***********************************/

	elsif(p_transaccion='TES_PAXCIG_SEL')then

		begin
        
			--Sentencia de la consulta de conteo de registros
			v_consulta:='WITH obligacion_pago_concepto AS(
						    SELECT
						        pxp.aggarray(od.id_obligacion_det) as id_obligacion_det,
						        od.id_obligacion_pago,
						        pxp.list(ot.desc_orden) as desc_orden      
						    FROM tes.tobligacion_det od
						    inner join conta.torden_trabajo ot on ot.id_orden_trabajo = od.id_orden_trabajo
						    where od.id_concepto_ingas = ' || v_parametros.id_concepto || ' and od.estado_reg = ''activo''
						    group by od.id_obligacion_pago
						)
						
						SELECT pp.id_plan_pago,
                        		(case when ot.id_orden_trabajo is not null then 
								ot.desc_orden
						        ELSE
						        opc.desc_orden 
						        end) as orden_trabajo, op.num_tramite,pp.nro_cuota,prov.rotulo_comercial as proveedor,pp.estado,
						        (case when com.fecha is null THEN
						        pp.fecha_tentativa else
						        com.fecha
						        end) as fecha
						        ,mon.moneda,pp.monto,pro.monto_ejecutar_mo,
								od.id_centro_costo, pp.fecha_costo_ini, pp.fecha_costo_fin
						FROM tes.tobligacion_pago op
						inner join obligacion_pago_concepto opc on op.id_obligacion_pago = opc.id_obligacion_pago
						inner join tes.tplan_pago pp on op.id_obligacion_pago = pp.id_obligacion_pago and pp.estado_reg = ''activo''
						left join tes.tprorrateo pro on pro.id_plan_pago = pp.id_plan_pago and  pro.id_obligacion_det = ANY(opc.id_obligacion_det) and pro.estado_reg = ''activo''
						left join tes.tobligacion_det od on od.id_obligacion_det = pro.id_obligacion_det
						left join conta.torden_trabajo ot on od.id_orden_trabajo = ot.id_orden_trabajo
						inner join param.vproveedor prov on prov.id_proveedor = op.id_proveedor 
						inner join param.tmoneda mon on op.id_moneda = mon.id_moneda
						left join conta.tint_comprobante com on com.id_int_comprobante = pp.id_int_comprobante
						where pp.tipo = ''devengado_pagado''  and  op.estado_reg = ''activo'' and '||v_parametros.filtro ||
						'order by opc.desc_orden,com.fecha, op.num_tramite,pp.nro_cuota';
			
						
			--Devuelve la respuesta
			return v_consulta;

		end;
	
	/*********************************    
 	#TRANSACCION:  'TES_PAXCIG_CONT'
 	#DESCRIPCION:	Conteo de pagos por concepto
 	#AUTOR:			JRR	
 	#FECHA:			15/12/2013
	***********************************/

	elsif(p_transaccion='TES_PAXCIG_CONT')then

		begin
        
			--Sentencia de la consulta de conteo de registros
			v_consulta:='WITH obligacion_pago_concepto AS(
						    SELECT
						        pxp.aggarray(od.id_obligacion_det) as id_obligacion_det,
						        od.id_obligacion_pago,
						        pxp.list(ot.desc_orden) as desc_orden      
						    FROM tes.tobligacion_det od
						    inner join conta.torden_trabajo ot on ot.id_orden_trabajo = od.id_orden_trabajo
						    where od.id_concepto_ingas = ' || v_parametros.id_concepto || ' and od.estado_reg = ''activo''
						    group by od.id_obligacion_pago
						)
						
						SELECT count(pp.id_plan_pago)
						    
						FROM tes.tobligacion_pago op
						inner join obligacion_pago_concepto opc on op.id_obligacion_pago = opc.id_obligacion_pago
						inner join tes.tplan_pago pp on op.id_obligacion_pago = pp.id_obligacion_pago and pp.estado_reg = ''activo''
						left join tes.tprorrateo pro on pro.id_plan_pago = pp.id_plan_pago and  pro.id_obligacion_det = ANY(opc.id_obligacion_det) and pro.estado_reg = ''activo''
						left join tes.tobligacion_det od on od.id_obligacion_det = pro.id_obligacion_det
						left join conta.torden_trabajo ot on od.id_orden_trabajo = ot.id_orden_trabajo
						inner join param.vproveedor prov on prov.id_proveedor = op.id_proveedor 
						inner join param.tmoneda mon on op.id_moneda = mon.id_moneda
						left join conta.tint_comprobante com on com.id_int_comprobante = pp.id_int_comprobante
						where pp.tipo = ''devengado_pagado''  and  op.estado_reg = ''activo'' and '||v_parametros.filtro;
			
						
			--Devuelve la respuesta
			return v_consulta;

		end;
	/*********************************    
 	#TRANSACCION:  'TES_PAGOS_SEL'
 	#DESCRIPCION:	Consulta para reporte de pagos
 	#AUTOR:		rac	
 	#FECHA:		22-12-2014 15:43:23
	***********************************/

	ELSIF(p_transaccion='TES_PAGOS_SEL')then
     				
    	begin
        
            --Sentencia de la consulta
			v_consulta:='SELECT 
                            id_plan_pago,
                            id_gestion,
                            gestion,
                            id_obligacion_pago,
                            num_tramite,
                            orden_compra,
                            tipo_obligacion,
                            pago_variable,
                            desc_proveedor,
                            estado,
                            usuario_reg,
                            fecha,
                            fecha_reg,
                            ob_obligacion_pago,
                            fecha_tentativa_de_pago,
                            nro_cuota,
                            tipo_plan_pago,
                            estado_plan_pago,
                            obs_descuento_inter_serv,
                            obs_descuentos_anticipo,
                            obs_descuentos_ley,
                            obs_monto_no_pagado,
                            obs_otros_descuentos,
                            codigo,
                            monto_cuota,
                            monto_anticipo,
                            monto_excento,
                            monto_retgar_mo,
                            monto_ajuste_ag,
                            monto_ajuste_siguiente_pago,
                            liquido_pagable,
                            monto_presupuestado,
                            desc_contrato,
							desc_funcionario1
                          FROM 
                            tes.vpago_x_proveedor 
							WHERE  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ', nro_cuota ASC limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

             raise notice '%',v_consulta;

			--Devuelve la respuesta
			return v_consulta;
						
		end;
        
   /*********************************    
 	#TRANSACCION:  'TES_PAGOS_CONT'
 	#DESCRIPCION:	Conteo de registros para el reporte de  pagos
 	#AUTOR:		rac	
 	#FECHA:		22-12-2014 15:43:23
	***********************************/

	elsif(p_transaccion='TES_PAGOS_CONT')then

		begin
        
        
        v_filtro='';
            /*
           
			--Sentencia de la consulta de conteo de registros
			v_consulta:='SELECT count(id_plan_pago),
                                sum(monto_cuota) as monto_cuota,
                                sum(monto_anticipo) as monto_anticipo,
                                sum(monto_excento) as monto_excento,
                                sum(monto_retgar_mo) as monto_retgar_mo,
                                sum(monto_ajuste_ag) as monto_ajuste_ag,
                                sum(monto_ajuste_siguiente_pago) as monto_ajuste_siguiente_pago,
                                sum(liquido_pagable) as liquido_pagable,
                                sum(monto_presupuestado) as monto_presupuestado
						 FROM  tes.vpago_x_proveedor  
                         WHERE ';*/
			
            
            v_consulta:='SELECT count(id_plan_pago)
						 FROM  tes.vpago_x_proveedor  
                         WHERE ';
            
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;
         
            raise notice '% .',v_consulta;
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