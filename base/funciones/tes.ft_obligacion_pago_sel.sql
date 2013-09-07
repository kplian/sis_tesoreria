--------------- SQL ---------------

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
        
           IF   p_administrador != 1 THEN
           
             select  
                 pxp.aggarray(depu.id_depto)
              into 
                 va_id_depto
             from param.tdepto_usuario depu 
             where depu.id_usuario =  p_id_usuario; 
        
           v_filadd='(obpg.id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||')) and';
          
          END IF;
        
        
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
                      --  fun.desc_funcionario1,
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
                        obpg.id_depto_conta
						from tes.tobligacion_pago obpg
						inner join segu.tusuario usu1 on usu1.id_usuario = obpg.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = obpg.id_usuario_mod
                        inner join param.vproveedor pv on pv.id_proveedor=obpg.id_proveedor
                        inner join param.tmoneda mn on mn.id_moneda=obpg.id_moneda
                        inner join segu.tsubsistema ss on ss.id_subsistema=obpg.id_subsistema
						inner join param.tdepto dep on dep.id_depto=obpg.id_depto
                       -- left join orga.vfuncionario fun on fun.id_funcionario=obpg.id_funcionario
                        where  '||v_filadd;
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;


  -- raise notice '%',v_consulta;
			--Devuelve la respuesta
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
 	#TRANSACCION:  'TES_OBPG_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		02-04-2013 16:01:32
	***********************************/

	elsif(p_transaccion='TES_OBPG_CONT')then

		begin
        
           v_filadd='';
          
             IF   p_administrador != 1 THEN
             
               select  
                   pxp.aggarray(depu.id_depto)
                into 
                   va_id_depto
               from param.tdepto_usuario depu 
               where depu.id_usuario =  p_id_usuario; 
          
             v_filadd='(obpg.id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||')) and';
            
            END IF;
        
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_obligacion_pago)
					    from tes.tobligacion_pago obpg
						inner join segu.tusuario usu1 on usu1.id_usuario = obpg.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = obpg.id_usuario_mod
                        inner join param.vproveedor pv on pv.id_proveedor=obpg.id_proveedor
                        inner join param.tmoneda mn on mn.id_moneda=obpg.id_moneda
                        inner join segu.tsubsistema ss on ss.id_subsistema=obpg.id_subsistema
						inner join param.tdepto dep on dep.id_depto=obpg.id_depto
                       -- left join orga.vfuncionario fun on fun.id_funcionario=obpg.id_funcionario
                        where  '||v_filadd;
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
            
            raise notice '%',v_consulta;
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
                pagado				numeric DEFAULT 0.00
        ) on commit drop;
            
            insert into obligaciones (id_obligacion_det,id_partida,nombre_partida,
            						id_concepto_ingas,nombre_ingas,id_obligacion_pago,
                                    id_centro_costo, codigo_cc, id_partida_ejecucion_com,
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
                inner join segu.tusuario usu1 on usu1.id_usuario = obdet.id_usuario_reg
                left join segu.tusuario usu2 on usu2.id_usuario = obdet.id_usuario_mod
                left join conta.tcuenta cta on cta.id_cuenta=obdet.id_cuenta
                left join pre.tpartida par on par.id_partida=obdet.id_partida
                left join conta.tauxiliar aux on aux.id_auxiliar=obdet.id_auxiliar
                left join param.tconcepto_ingas cig on cig.id_concepto_ingas=obdet.id_concepto_ingas
                left join param.vcentro_costo cc on cc.id_centro_costo=obdet.id_centro_costo
                where obdet.id_obligacion_pago=v_parametros.id_obligacion_pago;

			FOR v_obligaciones_partida in (select * from obligaciones)
       	    LOOP
            	v_respuesta_verificar = pre.f_verificar_com_eje_pag(v_obligaciones_partida.id_partida_ejecucion_com,v_parametros.id_moneda);

            	update obligaciones set
                comprometido = COALESCE(v_respuesta_verificar.ps_comprometido,0.00::numeric),
                ejecutado = COALESCE(v_respuesta_verificar.ps_ejecutado,0.00::numeric),
                pagado = COALESCE(v_respuesta_verificar.ps_pagado,0.00::numeric) 
                where obligaciones.id_obligacion_det=v_obligaciones_partida.id_obligacion_det;
                        
        	END LOOP;
            
            v_consulta:='select * from obligaciones';
            
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