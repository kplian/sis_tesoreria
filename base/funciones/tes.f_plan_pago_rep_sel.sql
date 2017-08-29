--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_plan_pago_rep_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.f_plan_pago_rep_sel
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

	v_nombre_funcion = 'tes.f_plan_pago_rep_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	

    /*********************************
 	#TRANSACCION:  'TES_REPPAGOS_SEL'
 	#DESCRIPCION:	Reporte de pagos relacionados
 	#AUTOR:		rac
 	#FECHA:		22-12-2014 15:43:23
	***********************************/

	IF(p_transaccion='TES_REPPAGOS_SEL')then

    	begin

           v_filtro = ' ';

            --filtro de proveedores
           IF  pxp.f_existe_parametro(p_tabla,'id_proveedors')  THEN
             IF v_parametros.id_proveedors is not null and v_parametros.id_proveedors != '' THEN
                v_filtro = ' id_proveedor in ('||v_parametros.id_proveedors||') and ';
             END IF;
           END IF;

            --filtro de conceptos
           IF  pxp.f_existe_parametro(p_tabla,'id_concepto_ingas')  THEN
             IF v_parametros.id_concepto_ingas is not null and v_parametros.id_concepto_ingas != '' THEN
                v_filtro = v_filtro||' id_concepto_ingas &&  string_to_array('''||v_parametros.id_concepto_ingas||''','','') and ';
             END IF;
           END IF;

            --filtro de ordenes de trabajo
           IF  pxp.f_existe_parametro(p_tabla,'id_orden_trabajos')  THEN
             IF v_parametros.id_orden_trabajos is not null and v_parametros.id_orden_trabajos != '' THEN
                v_filtro = v_filtro||' id_orden_trabajos && string_to_array('''||v_parametros.id_orden_trabajos||''','','') and ';
             END IF;
           END IF;
           
           IF  pxp.f_existe_parametro(p_tabla,'desde')  THEN
             IF v_parametros.desde is not null  THEN
                v_filtro = v_filtro||' fecha_tentativa >= '''||v_parametros.desde||'''::date  and ';
             END IF;
           END IF;
           
           IF  pxp.f_existe_parametro(p_tabla,'hasta')  THEN
             IF v_parametros.hasta is not null  THEN
                v_filtro = v_filtro||' fecha_tentativa <= '''||v_parametros.hasta||'''::date  and ';
             END IF;
           END IF;
           
           IF  pxp.f_existe_parametro(p_tabla,'tipo_pago')  THEN
             IF v_parametros.tipo_pago is not null and v_parametros.tipo_pago != '' THEN
                v_filtro = v_filtro||' tipo = ANY(string_to_array('''||v_parametros.tipo_pago||''','','')) and ';
             END IF;
           END IF;
           
           IF  pxp.f_existe_parametro(p_tabla,'estado')  THEN
             IF v_parametros.estado is not null and v_parametros.estado != '' THEN
                v_filtro = v_filtro||' estado = ANY( string_to_array('''||v_parametros.estado||''','','')) and ';
             END IF;
           END IF;
           
           IF  pxp.f_existe_parametro(p_tabla,'fuera_estado')  THEN
             IF v_parametros.fuera_estado is not null and v_parametros.fuera_estado != '' THEN
                v_filtro = v_filtro||' NOT (estado = ANY (string_to_array('''||v_parametros.fuera_estado||''','',''))) and ';
             END IF;
           END IF;
           
         
            --Sentencia de la consulta
			v_consulta:='SELECT
                          id_plan_pago,
                          desc_proveedor,
                          num_tramite,
                          estado,
                          fecha_tentativa,
                          nro_cuota,
                          monto,
                          monto_mb,
                          codigo,
                          conceptos,
                          ordenes,
                          id_proceso_wf,
                          id_estado_wf,
                          id_proveedor,
                          obs,
                          tipo
                        FROM
                          tes.vpagos_relacionados
                        WHERE '||v_filtro;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            
             raise notice '% .',v_consulta;

			--Devuelve la respuesta
			return v_consulta;

		end;

   /*********************************
 	#TRANSACCION:  'TES_REPPAGOS_CONT'
 	#DESCRIPCION:	Conteo de registros para el reporte de  pagos
 	#AUTOR:		rac
 	#FECHA:		22-12-2014 15:43:23
	***********************************/

	elsif(p_transaccion='TES_REPPAGOS_CONT')then

		begin


           v_filtro = ' ';

            --filtro de proveedores
           IF  pxp.f_existe_parametro(p_tabla,'id_proveedors')  THEN
             IF v_parametros.id_proveedors is not null and v_parametros.id_proveedors != '' THEN
                v_filtro = ' id_proveedor in ('||v_parametros.id_proveedors||') and ';
             END IF;
           END IF;

            --filtro de conceptos
           IF  pxp.f_existe_parametro(p_tabla,'id_concepto_ingas')  THEN
             IF v_parametros.id_concepto_ingas is not null and v_parametros.id_concepto_ingas != '' THEN
                v_filtro = v_filtro||' id_concepto_ingas &&  string_to_array('''||v_parametros.id_concepto_ingas||''','','') and ';
             END IF;
           END IF;

            --filtro de ordenes de trabajo
           IF  pxp.f_existe_parametro(p_tabla,'id_orden_trabajos')  THEN
             IF v_parametros.id_orden_trabajos is not null and v_parametros.id_orden_trabajos != '' THEN
                v_filtro = v_filtro||' id_orden_trabajos && string_to_array('''||v_parametros.id_orden_trabajos||''','','') and ';
             END IF;
           END IF;
           
           IF  pxp.f_existe_parametro(p_tabla,'desde')  THEN
             IF v_parametros.desde is not null  THEN
                v_filtro = v_filtro||' fecha_tentativa >= '''||v_parametros.desde||'''::date  and ';
             END IF;
           END IF;
           
           IF  pxp.f_existe_parametro(p_tabla,'hasta')  THEN
             IF v_parametros.hasta is not null  THEN
                v_filtro = v_filtro||' fecha_tentativa <= '''||v_parametros.hasta||'''::date  and ';
             END IF;
           END IF;
           
           IF  pxp.f_existe_parametro(p_tabla,'tipo_pago')  THEN
             IF v_parametros.tipo_pago is not null and v_parametros.tipo_pago != '' THEN
                v_filtro = v_filtro||' tipo = ANY(string_to_array('''||v_parametros.tipo_pago||''','','')) and ';
             END IF;
           END IF;
           
           IF  pxp.f_existe_parametro(p_tabla,'estado')  THEN
             IF v_parametros.estado is not null and v_parametros.estado != '' THEN
                v_filtro = v_filtro||' estado = ANY( string_to_array('''||v_parametros.estado||''','','')) and ';
             END IF;
           END IF;
           
           IF  pxp.f_existe_parametro(p_tabla,'fuera_estado')  THEN
             IF v_parametros.fuera_estado is not null and v_parametros.fuera_estado != '' THEN
                v_filtro = v_filtro||' NOT (estado = ANY (string_to_array('''||v_parametros.fuera_estado||''','',''))) and ';
             END IF;
           END IF;



            v_consulta:='SELECT 
                                   count(id_plan_pago),
                                   sum(monto_mb) as monto_mb
						 FROM
                          tes.vpagos_relacionados
                        WHERE '||v_filtro;

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