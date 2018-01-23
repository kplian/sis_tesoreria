--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_inserta_proceso_reposicion_rendicion_caja (
  p_administrador integer,
  p_id_usuario integer,
  p_hstore public.hstore
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Tesoreria
 FUNCION: 		tes.f_inserta_proceso_reposicion_rendicion_caja
 DESCRIPCION:   inserta procesos de Rendicion y de Reposicion de Caja Chica
 AUTOR: 		Gonzalo Sarmiento
 FECHA:	        27-01-2017
 COMENTARIOS:
***************************************************************************
 
    HISTORIAL DE MODIFICACIONES:
   	
 ISSUE            FECHA:		      AUTOR                 DESCRIPCION
   
 #0        		 27-01-2017        Gonzalo Sarmiento       inserta procesos de Rendicion y de Reposicion de Caja Chica
 #146 IC		 05/12/2017        RAC					   ajustar funcion de calculo de reposicion para considerar ingresos de efectiv en caja
***************************************************************************/

DECLARE
v_anho					integer;
v_id_gestion			integer;
v_proceso_pendiente		varchar;
v_codigo_tabla			varchar;
v_codigo_documento		varchar;
v_num_rendicion			varchar;
v_registros_trendicion	record;
v_registros				record;
v_monto					numeric;
v_id_proceso_caja		integer;
v_num_tramite			varchar;
v_id_proceso_wf			integer;
v_id_estado_wf			integer;
v_codigo_estado			varchar;
v_resp					varchar;
v_nombre_funcion		varchar;
v_solicitudes			record;
v_rendiciones			record;
v_monto_ing_extra       numeric;

BEGIN

	/*
    HSTORE  PARAMETERS

    (p_hstore->'fecha')::date;
    (p_hstore->'id_caja')::integer;
    (p_hstore->'tipo')::varchar;
    (p_hstore->'fecha_inicio')::date;
    (p_hstore->'fecha_fin')::date;
    (p_hstore->'motivo')::varchar;
    (p_hstore->'_nombre_usuario_ai')::varchar;
    (p_hstore->'_id_usuario_ai')::integer;
    */

    v_nombre_funcion = 'tes.f_inserta_proceso_reposicion_rendicion_caja';
	--obtener gestion
       v_anho = (date_part('year', (p_hstore->'fecha')::date))::integer;

        select
         ges.id_gestion
        into
          v_id_gestion
        from param.tgestion ges
        where ges.gestion = v_anho
        limit 1 offset 0;

        IF  v_id_gestion is null  THEN
          raise exception 'no se encontro una gestion parametrizada para el año %',v_anho;
        END IF;

      --verificar que no existen procesos pendientes de finalizacion por rendicion o reposicion solo deberia existir un proceso
      select pc.nro_tramite into v_proceso_pendiente
      from tes.tproceso_caja pc
      where pc.id_caja=(p_hstore->'id_caja')::integer and pc.tipo in ('SOLREN','REPO','CIERRE')
      and pc.estado not in ('contabilizado','rendido','cerrado');

      IF v_proceso_pendiente is not null THEN
         raise exception 'No se puede registra un nuevo proceso caja, existe el proceso % pendiente de finalizacion', v_proceso_pendiente;
      END IF;


      select
         pv.codigo
      into
        v_codigo_tabla
      from tes.tcaja pv
      where pv.id_caja = (p_hstore->'id_caja')::integer;

      IF (p_hstore->'tipo')::varchar = 'REPO' or (p_hstore->'tipo')::varchar = 'SOLREP' THEN
          v_codigo_documento = 'REP';
      ELSIF  (p_hstore->'tipo')::varchar = 'SOLREN' or (p_hstore->'tipo')::varchar = 'RENYREP' or  (p_hstore->'tipo')::varchar = 'RENYCER' THEN
          v_codigo_documento = 'REN';
      ELSIF (p_hstore->'tipo')::varchar = 'CIERRE' THEN
          v_codigo_documento = 'CIER';



          FOR v_solicitudes IN (select sol.nro_tramite, sol.estado , fun.desc_funcionario1
      	 					from tes.tsolicitud_efectivo sol
                            inner join orga.vfuncionario fun on fun.id_funcionario = sol.id_funcionario
         					where sol.id_caja = (p_hstore->'id_caja')::integer
         					and sol.estado in ('entregado')
         					and sol.id_tipo_solicitud = (select id_tipo_solicitud
                                  					from tes.ttipo_solicitud
                                  					where codigo='SOLEFE')) LOOP
	      	raise exception 'No puede cerrar la caja chica, existe la solicitud de gasto % del funcionario % aun
          				  pendiente de ser finalizado, la solicitud se encuentra en estado %',
           				  v_solicitudes.nro_tramite, v_solicitudes.desc_funcionario1, upper(v_solicitudes.estado);

      	  END LOOP;

          FOR v_rendiciones IN (select ren.nro_tramite, ren.estado, fun.desc_funcionario1, doc.nro_documento, doc.razon_social
							from tes.tsolicitud_efectivo ren
							inner join tes.tsolicitud_rendicion_det det on det.id_solicitud_efectivo=ren.id_solicitud_efectivo
                            inner join tes.tsolicitud_efectivo sol on sol.id_solicitud_efectivo=ren.id_solicitud_efectivo_fk
							inner join orga.vfuncionario fun on fun.id_funcionario=ren.id_funcionario
                            inner join conta.tdoc_compra_venta doc on doc.id_doc_compra_venta=det.id_documento_respaldo
							where ren.id_caja = (p_hstore->'id_caja')::integer and det.id_proceso_caja is null and
							ren.id_tipo_solicitud = (select id_tipo_solicitud
													from tes.ttipo_solicitud
                            						where codigo='RENEFE')) LOOP
            IF v_rendiciones.estado = 'rendido' THEN

	  			raise exception 'No puede cerrar la caja chica, el documento (Razon Social: % - Nro Documento: %) rendido de la
             			solicitud de gasto % del funcionario % no fue rendido por la caja, cree una rendicion de caja',
                        v_rendiciones.razon_social, v_rendiciones.nro_documento, v_rendiciones.nro_tramite,
                        v_rendiciones.desc_funcionario1;
            ELSE

	  			raise exception 'La rendicion de la solicitud de gasto % del funcionario % se encuentra en estado %,
            			finalice la rendicion', v_rendiciones.nro_tramite,
                        v_rendiciones.desc_funcionario1, upper(v_rendiciones.estado);
            END IF;

      	  END LOOP;
      ELSE
          raise exception 'Tipo inexistente %', v_codigo_documento;
      END IF;

      v_num_rendicion = param.f_obtener_correlativo(
             v_codigo_documento,
             NULL,-- par_id,
             NULL, --id_uo
             NULL,    -- id_depto
             p_id_usuario,
             'TES',
             NULL,
             0,
             0,
             'tes.tcaja',
             (p_hstore->'id_caja')::integer,
             v_codigo_tabla
             );

      --fin obtener correlativo
      IF (v_num_rendicion is NULL or v_num_rendicion ='') THEN
         raise exception 'No se pudo obtener un numero correlativo para la rendicion de caja consulte con el administrador';
      END IF;

      select tp.codigo, tpc.id_tipo_proceso_caja into v_registros_trendicion
      from  wf.ttipo_proceso tp
      inner join tes.ttipo_proceso_caja tpc on tpc.codigo_wf=tp.codigo
      where tpc.codigo =  (p_hstore->'tipo')::varchar;

      IF  v_registros_trendicion.codigo is NULL or v_registros_trendicion.codigo = '' THEN
         raise exception 'La rendicion de tipo (%) no tiene un proceso de WF relacionado',(p_hstore->'tipo')::varchar;
      END IF;
      
      --recupera datos de la caja y de su proceso caja de apertura
      select caj.id_proceso_wf, caj.id_estado_wf, c.id_depto, c.codigo, caj.nro_tramite, caj.estado, c.importe_maximo_caja
      into v_registros
      from tes.tproceso_caja caj
      inner join tes.tcaja c on c.id_caja=caj.id_caja
      where caj.id_caja = (p_hstore->'id_caja')::integer and caj.tipo='apertura';

      IF (p_hstore->'tipo')::varchar = 'REPO' THEN
          v_num_tramite = COALESCE(v_registros.nro_tramite,'');
      END IF;


      -- inciar el tramite en el sistema de WF
       SELECT
             ps_num_tramite ,
             ps_id_proceso_wf ,
             ps_id_estado_wf ,
             ps_codigo_estado
          into
             v_num_rendicion,
             v_id_proceso_wf,
             v_id_estado_wf,
             v_codigo_estado

        FROM wf.f_inicia_tramite(
             p_id_usuario,
             NULL,
             NULL,
             v_id_gestion,
             v_registros_trendicion.codigo,
             NULL,
             v_registros.id_depto,
             'Solicitud de rendicion para la CAJA: ('||v_num_rendicion||') '::varchar,
             v_num_rendicion,
             v_num_rendicion);
      --END IF;
      v_monto=0;

       IF (p_hstore->'tipo')::varchar in ('RENYREP','RENYCER') THEN
              select sum(r.monto) into v_monto
              from tes.tsolicitud_rendicion_det r
              inner join tes.tsolicitud_efectivo efe on efe.id_solicitud_efectivo=r.id_solicitud_efectivo
              where r.id_proceso_caja is null and efe.id_caja=(p_hstore->'id_caja')::integer
              --and d.fecha BETWEEN (p_hstore->'fecha_inicio')::date and (p_hstore->'fecha_fin')::date
              and efe.estado='rendido';
              
             
              
       END IF;

       IF (p_hstore->'tipo')::varchar = 'SOLREP' THEN
       
              
              --RAC  05/12/2017, RAC considerar para el calculo de reposicion efectivo ingresado directamente en caja
              
              select sum(det.monto) into v_monto
              from tes.tproceso_caja c
              inner join tes.tsolicitud_rendicion_det det on det.id_proceso_caja=c.id_proceso_caja
              where c.tipo='SOLREN' and c.id_caja=(p_hstore->'id_caja')::integer
              and c.estado ='rendido' and c.id_proceso_caja_repo is null;
              
              -- tenemso que restar los ingresos de efectivo sueltos
              
              select 
                sum(se.monto) into v_monto_ing_extra
              from tes.tsolicitud_efectivo se
              inner join tes.ttipo_solicitud ts on ts.id_tipo_solicitud = se.id_tipo_solicitud
              where 
              
                  se.id_caja = (p_hstore->'id_caja')::integer and 
                  ts.codigo = 'INGEFE' and
                  se.estado = 'ingresado' and
                  se.ingreso_extra = 'si' and 
                  se.id_proceso_caja_repo is null;
                  
              v_monto = COALESCE(v_monto,0) - COALESCE(v_monto_ing_extra,0);
              
              IF v_monto <= 0 THEN
                 -- raise exception 'No  tiene saldo por reponer,  o tiene reposiciones en proceso, (Primero rinda si tiene facturas pendientes y Revise si tiene reposiciones en proceso ...) % ',(v_monto * -1);
              END IF;
              
       ELSIF (p_hstore->'tipo')::varchar = 'SOLREN' THEN
       
       		select sum(r.monto) into v_monto
            from tes.tsolicitud_rendicion_det r
            inner join tes.tsolicitud_efectivo efe on efe.id_solicitud_efectivo=r.id_solicitud_efectivo
            inner join conta.tdoc_compra_venta d on d.id_doc_compra_venta=r.id_documento_respaldo
            where r.id_proceso_caja is null and efe.id_caja=(p_hstore->'id_caja')::integer
            --and d.fecha BETWEEN (p_hstore->'fecha_inicio')::date and (p_hstore->'fecha_fin')::date
            and efe.estado='rendido';
            
       END IF;

       IF (p_hstore->'tipo')::varchar = 'REPO' THEN
              v_monto =v_registros.importe_maximo_caja;
       END IF;

       IF (p_hstore->'tipo')::varchar = 'CIERRE' THEN
              v_monto = tes.f_calcular_saldo_caja((p_hstore->'id_caja')::integer);
       END IF;
       
       

      --Sentencia de la insercion de la rendicion o reposicion de caja
      insert into tes.tproceso_caja(
          estado,
          --id_comprobante_diario,
          nro_tramite,
          tipo,
          motivo,
          estado_reg,
          fecha_fin,
          id_caja,
          fecha,
          id_proceso_wf,
          monto,
          --id_comprobante_pago,
          id_estado_wf,
          fecha_inicio,
          fecha_reg,
          usuario_ai,
          id_usuario_reg,
          id_usuario_ai,
          fecha_mod,
          id_usuario_mod,
          id_tipo_proceso_caja,
          id_gestion
      ) values(
      v_codigo_estado,
      --v_parametros.id_comprobante_diario,
      v_num_rendicion,
      (p_hstore->'tipo')::varchar,
      (p_hstore->'motivo')::varchar,
      'activo',
      (p_hstore->'fecha_fin')::date,
      (p_hstore->'id_caja')::integer,
      (p_hstore->'fecha')::date,
      v_id_proceso_wf,
      v_monto,
      --v_parametros.id_comprobante_pago,
      v_id_estado_wf,
      (p_hstore->'fecha_inicio')::date,
      now(),
      (p_hstore->'_nombre_usuario_ai')::varchar,
      p_id_usuario,
      (p_hstore->'_id_usuario_ai')::integer,
      null,
      null,
      v_registros_trendicion.id_tipo_proceso_caja,
      v_id_gestion
      )RETURNING id_proceso_caja into v_id_proceso_caja;

      IF (p_hstore->'tipo')::varchar in ('SOLREN','RENYREP','RENYCER') THEN
          
          --asocia las facturas con el proceso caja de la rendicion de caja
          UPDATE tes.tsolicitud_rendicion_det
          SET id_proceso_caja = v_id_proceso_caja
          WHERE id_solicitud_rendicion_det in (select r.id_solicitud_rendicion_det
                                              from tes.tsolicitud_rendicion_det r
                                              inner join tes.tsolicitud_efectivo efe on efe.id_solicitud_efectivo=r.id_solicitud_efectivo
                                              inner join conta.tdoc_compra_venta d on d.id_doc_compra_venta=r.id_documento_respaldo
                                              where r.id_proceso_caja is null and efe.id_caja=(p_hstore->'id_caja')::integer
                                              --and d.fecha BETWEEN (p_hstore->'fecha_inicio')::date and (p_hstore->'fecha_fin')::date
                                              and efe.estado='rendido');
      
      ELSIF (p_hstore->'tipo')::varchar = 'SOLREP' THEN
          
          UPDATE tes.tproceso_caja
          SET id_proceso_caja_repo = v_id_proceso_caja
          WHERE tipo='SOLREN' and id_caja=(p_hstore->'id_caja')::integer
          and estado='rendido' and id_proceso_caja_repo is null;
          
          --RAC  05/12/2017, tenemos  que asociar los ingresos de efectivo sueltos
          UPDATE tes.tsolicitud_efectivo  se SET 
                id_proceso_caja_repo = v_id_proceso_caja
          from tes.ttipo_solicitud ts
          where 
                  ts.id_tipo_solicitud = se.id_tipo_solicitud and 
                  se.id_caja = (p_hstore->'id_caja')::integer and 
                  ts.codigo = 'INGEFE' and
                  se.estado = 'ingresado' and
                  se.ingreso_extra = 'si' and 
                  se.id_proceso_caja_repo is null;
                  
                  
          
      END IF;
     
      --Definicion de la respuesta
      v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Rendicion Caja almacenado(a) con exito (id_proceso_caja'||v_id_proceso_caja||')');
      v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_caja',v_id_proceso_caja::varchar);
	  v_resp = pxp.f_agrega_clave(v_resp,'id_estado_wf',v_id_estado_wf::varchar);
      v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_wf',v_id_proceso_wf::varchar);

      --Devuelve la respuesta
      return v_resp;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;