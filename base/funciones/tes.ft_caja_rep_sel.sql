--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.ft_caja_rep_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.ft_caja_rep_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tcaja'
 AUTOR: 		 (admin)
 FECHA:	        16-12-2013 20:43:44
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************

* ISSUE SIS       EMPRESA      FECHA:		      AUTOR       		DESCRIPCION
 #20 TES       		ETR         01/02/2019      MANUEL GUERRA       agregacion de gestion para reportes mensuales
***************************************************************************/


DECLARE

	v_consulta    		varchar;
	v_consulta_b   		varchar;    
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
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
    v_aux 				varchar;
    v_resultado 		varchar;
    v_auxiliar			integer;
    v_saldo_ant 		numeric;
    v_saldo 			numeric;
    v_fecha				date[];
    v_estado			varchar;
    v_tipo 				varchar;
	v_tipo_c 			varchar[];
    v_tam				integer;
    v_mes				integer;
    v_anio_ciere		integer;
    v_int				record;
    v_lp				record;
    v_total 			numeric;
    v_sw	 			integer;
    v_gestion 			integer;
    v_ini    			integer;
    v_anios   			record;
BEGIN

	v_nombre_funcion = 'tes.ft_caja_rep_sel';
    v_parametros = pxp.f_get_record(p_tabla);
    
    /*********************************    
    #TRANSACCION:  'TES_CAJA_REP_MEN_SEL'
    #DESCRIPCION:	Reporte de rendicion mensual de cajaero
    #AUTOR:		mp	
    #FECHA:		21-03-2018 00:28:30
    ***********************************/
    if(p_transaccion='TES_CAJA_REP_MEN_SEL') then
    	begin
            SELECT
            pc.id_proceso_caja, 
            pc.fecha,
            pc.tipo,
            pc.estado
            INTO v_int
            FROM tes.tproceso_caja pc
            INNER JOIN tes.tcaja caja on pc.id_caja=caja.id_caja
            WHERE caja.id_caja = v_parametros.id_caja
            and pc.estado='cerrado' and pc.estado_reg='activo';            	                                            
                             
            SELECT g.gestion
            INTO v_lp
            FROM param.tgestion g
            WHERE g.id_gestion=v_parametros.id_gestion;                		        
                                	
        	SELECT COALESCE(k.id_gestion,0)as id_gestion
            INTO v_anios
            FROM param.tgestion k
            WHERE k.gestion= EXTRACT(YEAR FROM v_int.fecha);  			
            
            IF v_anios.id_gestion IS NULL THEN
            	v_anios.id_gestion =0;
            END IF;  
            
            v_total=0;
            v_anio_ciere = v_anios.id_gestion;
            --id_gestion esel 1er año habilitado donde existe movimiento
            v_ini = 2;         

            WHILE v_ini <= v_parametros.id_gestion LOOP                                                                                                       			               
                v_resultado=0;
              	v_auxiliar=v_parametros.mes-1; 
                
                IF v_ini = v_anio_ciere THEN
                    v_mes=EXTRACT(MONTH FROM v_int.fecha);
                ELSE
                    v_mes =0;  
                END IF; 
                           
              	IF v_ini != v_parametros.id_gestion THEN
                    v_auxiliar=12;	
                END IF;
                                                       	
            	WHILE v_auxiliar > v_mes LOOP 
                    v_resultado = v_resultado ||','||v_auxiliar;                     
                    v_auxiliar = v_auxiliar-1;
                END LOOP;  
             
                IF v_parametros.id_caja=135 THEN
                  v_aux = 'dc.fecha';                    
                    v_consulta:='select 
                          sum(COALESCE(debe,0))-sum(COALESCE(haber,0)) as saldo                                 
                                from ( 
                                    select 
                                    sum(ren.monto) as debe,
                                    0::numeric as haber
                                    from tes.tproceso_caja ren
                                    left join tes.ttipo_proceso_caja tpc on tpc.id_tipo_proceso_caja=ren.id_tipo_proceso_caja 
                                    left join tes.tcaja cj on cj.id_caja=ren.id_caja
                                    join param.tgestion g on g.id_gestion = '||v_ini||'
                                    where cj.id_caja= '||v_parametros.id_caja||' and 
                                    ren.motivo NOT ILIKE ''%RENDICION%'' 
                                    and tpc.codigo!=''SOLREN'' 
                                    and tpc.codigo!=''CIERRE''
                                    and (EXTRACT(MONTH FROM ren.fecha)) in ('||v_resultado||')
                                    and (EXTRACT(YEAR FROM ren.fecha)) = g.gestion
                            
                                    union all

                                    select           
                                    sum(solefe.monto)as debe,
                                    0::numeric as haber
                                    from tes.tsolicitud_efectivo solefe
                                    inner join tes.tcaja caja on caja.id_caja=solefe.id_caja
                                    join param.tgestion g on g.id_gestion = '||v_ini||'
                                    where caja.id_caja= '||v_parametros.id_caja||' and 
                                    solefe.estado=''ingresado'' and 
                                    (EXTRACT(MONTH FROM solefe.fecha_mod))in ('||v_resultado||') and
                                    (EXTRACT(YEAR FROM solefe.fecha_mod))= g.gestion
                                      
                                    union all

                                    select 
                                    sum(0::numeric) as debe,
                                    sum(dc.importe_pago_liquido)::numeric as haber
                                    from tes.tsolicitud_rendicion_det rend
                                    inner join tes.tsolicitud_efectivo solren on solren.id_solicitud_efectivo = rend.id_solicitud_efectivo
                                    inner join tes.tsolicitud_efectivo solefe on solefe.id_solicitud_efectivo = solren.id_solicitud_efectivo_fk
                                    inner join tes.tcaja caja on caja.id_caja = solefe.id_caja
                                    left join conta.tdoc_compra_venta dc on dc.id_doc_compra_venta = rend.id_documento_respaldo
                                    join param.tgestion g on g.id_gestion = '||v_ini||'
                                    where caja.id_caja= '||v_parametros.id_caja||' and 
                                    solren.estado=''rendido'' and 
                                    (EXTRACT(MONTH FROM dc.fecha)) in ('||v_resultado||') AND
                                    (EXTRACT(YEAR FROM dc.fecha)) = g.gestion                      
                                )as resultado';                     
              ELSE
                  v_aux = 'dc.fecha';                    
                  v_consulta:='select 
                              sum(COALESCE(debe,0))-sum(COALESCE(haber,0)) as saldo                                     
                              from ( 
                                  select 
                                  sum(ren.monto) as debe,
                                  0::numeric as haber
                                  from tes.tproceso_caja ren
                                  left join tes.ttipo_proceso_caja tpc on tpc.id_tipo_proceso_caja=ren.id_tipo_proceso_caja 
                                  left join tes.tcaja cj on cj.id_caja=ren.id_caja
                                  join param.tgestion g on g.id_gestion = '||v_ini||'
                                  where cj.id_caja= '||v_parametros.id_caja||'  
                                  and ren.motivo NOT ILIKE ''%RENDICION%'' 
                                  and tpc.codigo!=''SOLREN'' 
                                  and tpc.codigo!=''CIERRE''
                                  and (EXTRACT(MONTH FROM ren.fecha)) in ('||v_resultado||')
                                  AND (EXTRACT(YEAR FROM ren.fecha))= g.gestion

                                  union all

                                  select           
                                  sum(solefe.monto)as debe,
                                  0::numeric as haber
                                  from tes.tsolicitud_efectivo solefe
                                  inner join tes.tcaja caja on caja.id_caja=solefe.id_caja
                                  join param.tgestion g on g.id_gestion = '||v_ini||'
                                  where caja.id_caja= '||v_parametros.id_caja||' and 
                                  solefe.estado=''ingresado'' and 
                                  (EXTRACT(MONTH FROM solefe.fecha_mod)) in ('||v_resultado||') AND
                                  (EXTRACT(year FROM solefe.fecha_mod)) = g.gestion
                                   
                                  union all

                                  select 
                                  sum(0::numeric) as debe,
                                  sum(dc.importe_pago_liquido)::numeric as haber
                                  from tes.tsolicitud_rendicion_det rend
                                  inner join tes.tsolicitud_efectivo solren on solren.id_solicitud_efectivo = rend.id_solicitud_efectivo
                                  inner join tes.tsolicitud_efectivo solefe on solefe.id_solicitud_efectivo = solren.id_solicitud_efectivo_fk
                                  inner join tes.tcaja caja on caja.id_caja = solefe.id_caja
                                  left join conta.tdoc_compra_venta dc on dc.id_doc_compra_venta = rend.id_documento_respaldo
                                join param.tgestion g on g.id_gestion = '||v_ini||'
                                where caja.id_caja= '||v_parametros.id_caja||' and 
                                solren.estado=''rendido'' and 
                                (EXTRACT(MONTH FROM dc.fecha)) in ('||v_resultado||') and
                                (EXTRACT(YEAR FROM dc.fecha)) = g.gestion                       
                              )as resultado';                                                            
                END IF;  
                 
                EXECUTE(v_consulta)into v_saldo_ant;             	                    
              	v_total = v_total + v_saldo_ant;
				v_ini = v_ini + 1;   
                 
            END LOOP;
                          
            --RAISE NOTICE 'total=>%',v_total;
			--RAISE EXCEPTION 'total=>%',v_total;      
                                                                          
            IF v_int.tipo='CIERRE' and v_parametros.mes=EXTRACT(MONTH FROM v_int.fecha)+1 THEN
               v_saldo_ant=0;
            END IF;
      
            IF v_parametros.mes=1 and v_parametros.id_caja=128 THEN
                v_aux = 'dc.fecha';
            END IF;   
            IF v_parametros.mes=1 THEN
                v_saldo_ant=0;
            END IF;   
            --raise exception '%',v_aux; 
                   
			v_consulta := '(select 
                  			  '||v_saldo_ant||'::numeric as saldo,
                              ''SALDO MES ANTERIOR''::varchar as nro_tramite,
                              ''''::varchar as desc_plantilla,
                              null::date as fecha,
                              ''''::varchar as nit,
                              ''''::varchar as razon_social,
                              ''''::varchar as nro_autorizacion,
                              ''''::varchar as nro_documento,
                              ''''::varchar as codigo_control,
                              0::numeric as monto,
                              null::numeric as importe_pago_liquido,
                              null::numeric as importe_iva,
                              null::numeric as importe_descuento,
                              null::numeric as importe_descuento_ley,
                              null::numeric as importe_excento,
                              ''''::varchar as motivo,
                              null::varchar as tramite 
                              from tes.tproceso_caja n
                              LIMIT 1)
                              
                              UNION 
                              
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
                              ren.monto,
                              null::numeric as importe_pago_liquido,
                              null::numeric as importe_iva,
                              null::numeric as importe_descuento,
                              null::numeric as importe_descuento_ley,
                              null::numeric as importe_excento,
                              ''rendido''as motivo,
                              null::varchar as tramite                             
                              from tes.tproceso_caja ren
                              left join tes.ttipo_proceso_caja tpc on tpc.id_tipo_proceso_caja=ren.id_tipo_proceso_caja 
                              left join tes.tcaja cj on cj.id_caja=ren.id_caja
                              join param.tgestion g on g.id_gestion = '||v_parametros.id_gestion||'
                              where cj.id_caja='||v_parametros.id_caja||' 
                              and  tpc.codigo=''CIERRE'' 
                              and (EXTRACT(MONTH FROM ren.fecha))= '||v_parametros.mes||'
                              and (EXTRACT(YEAR FROM ren.fecha))= g.gestion

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
                              ren.monto,
                              null::numeric as importe_pago_liquido,
                              null::numeric as importe_iva,
                              null::numeric as importe_descuento,
                              null::numeric as importe_descuento_ley,
                              null::numeric as importe_excento,
                              ren.motivo::varchar,
                              null::varchar as tramite 
                              from tes.tproceso_caja ren
                              left join tes.ttipo_proceso_caja tpc on tpc.id_tipo_proceso_caja=ren.id_tipo_proceso_caja 
                              left join tes.tcaja cj on cj.id_caja=ren.id_caja
                              join param.tgestion g on g.id_gestion = '||v_parametros.id_gestion||'
                              where cj.id_caja='||v_parametros.id_caja||' and 
                              ren.motivo NOT ILIKE ''%RENDICION%'' AND 
                              tpc.codigo!=''CIERRE'' and 
                              tpc.codigo!=''SOLREN'' and 
                              (EXTRACT(MONTH FROM ren.fecha))= '||v_parametros.mes||'and
							  (EXTRACT(YEAR FROM ren.fecha))= g.gestion
                              
                              union all

                              select 
                              0::numeric as saldo,
                              solefe.nro_tramite::varchar,
                              ''''::varchar as desc_plantilla,
                              solefe.fecha_mod::DATE,
                              ''''::varchar as nit,
                              ''''::varchar as razon_social,
                              ''''::varchar as nro_autorizacion,
                              ''''::varchar as nro_documento,
                              ''''::varchar as codigo_control,                              
                              solefe.monto,
                              null::numeric as importe_pago_liquido,
                              null::numeric as importe_iva,
                              null::numeric as importe_descuento,
                              null::numeric as importe_descuento_ley,
                              null::numeric as importe_excento,
                              solefe.estado::varchar as motivo,
                              null::varchar as tramite 
                              from tes.tsolicitud_efectivo solefe
                              inner join segu.tusuario usu1 on usu1.id_usuario = solefe.id_usuario_reg
                              inner join tes.tcaja caja on caja.id_caja=solefe.id_caja
                              inner join orga.vfuncionario fun on fun.id_funcionario = solefe.id_funcionario
                              left join segu.tusuario usu2 on usu2.id_usuario = solefe.id_usuario_mod
                              left join tes.tsolicitud_efectivo solpri on solpri.id_solicitud_efectivo=solefe.id_solicitud_efectivo_fk
                              join param.tgestion g on g.id_gestion = '||v_parametros.id_gestion||'
                              where caja.id_caja='||v_parametros.id_caja||' and 
                              solefe.estado=''ingresado'' and 
                              (EXTRACT(MONTH FROM solefe.fecha_mod))= '||v_parametros.mes||' and
                              (EXTRACT(YEAR FROM solefe.fecha_mod))= g.gestion 

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
                              dc.importe_doc::numeric as monto,
                              dc.importe_pago_liquido::numeric,
                              dc.importe_iva::numeric,
                              dc.importe_descuento::numeric,
                              dc.importe_descuento_ley::numeric,
                              dc.importe_excento::numeric,
                              solren.estado::varchar as motivo,
                              tc.nro_tramite as tramite
                              from tes.tsolicitud_rendicion_det rend
                              inner join tes.tsolicitud_efectivo solren on solren.id_solicitud_efectivo = rend.id_solicitud_efectivo
                              inner join tes.tsolicitud_efectivo solefe on solefe.id_solicitud_efectivo = solren.id_solicitud_efectivo_fk
                              inner join tes.tcaja caja on caja.id_caja = solefe.id_caja
                              left join conta.tdoc_compra_venta dc on dc.id_doc_compra_venta = rend.id_documento_respaldo
                              left join param.tplantilla pla on pla.id_plantilla = dc.id_plantilla
                              left join tes.tproceso_caja tc on tc.id_proceso_caja=rend.id_proceso_caja
                              join param.tgestion g on g.id_gestion = '||v_parametros.id_gestion||'
                              where caja.id_caja='||v_parametros.id_caja||' and 
                              solren.estado=''rendido'' and 
                              (EXTRACT(MONTH FROM '|| v_aux ||'))= '||v_parametros.mes||' AND
                              (EXTRACT(YEAR FROM '|| v_aux ||'))= g.gestion
                              order by fecha asc ';                                 
   
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