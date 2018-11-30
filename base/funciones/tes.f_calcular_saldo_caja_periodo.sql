--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_calcular_saldo_caja_periodo (
  p_id_caja integer,
  f_fecha_final date
)
RETURNS numeric AS
$body$
DECLARE
	v_fecha_apertura		timestamp;
    v_monto_apertura		numeric;
    v_monto_entregado		numeric;
    v_monto_percibido		numeric;
    v_monto_reintegrado		numeric; 
    v_monto_reposicion_caja	numeric;
    v_monto_cierre_caja		numeric;
    v_saldo_caja			numeric;
    v_resp					varchar; 
    v_reg_per               record; 
    v_reg_entregado               record;     
    v_reg_finalizado               record;
    v_saldo_mayor   	numeric;
    v_monto_ajuste_apertura 	numeric;
    v_importe_rendido_documentos 	numeric;
    v_total_ingresado  numeric;
    v_importe_rendido_documentos_proceso  numeric;
   
BEGIN

   --determinar periodo


   --listado del saldo anterior
   
   
 /* 
v_saldo_caja =       COALESCE(v_monto_apertura,0)
               +     COALESCE(v_monto_reposicion_caja,0) 
               +     COALESCE(v_monto_percibido,0)   
               
               - COALESCE(v_monto_entregado,0) 
              
  			   - COALESCE(v_monto_reintegrado,0) 
               
               - COALESCE(v_monto_cierre_caja,0);*/
               
               
  --obtiene la fecha de apertura
               
   select efe.fecha  into v_fecha_apertura
   from tes.tsolicitud_efectivo efe
   inner join tes.ttipo_solicitud  ts on  ts.id_tipo_solicitud = efe.id_tipo_solicitud and ts.codigo='APECAJ'
   where       efe.id_caja=p_id_caja   
           and efe.estado in ('aperturado') 
           and efe.fecha <= f_fecha_final; 
           
           
   --obtenermos el motno de apertura monto de apertura
  
  
  select 
    efe.monto into v_monto_apertura
  from tes.tsolicitud_efectivo efe
  inner join tes.ttipo_solicitud  ts on  ts.id_tipo_solicitud = efe.id_tipo_solicitud and ts.codigo='APECAJ'
  where efe.id_caja=p_id_caja
  and efe.fecha  <= f_fecha_final
  and efe.estado in ('aperturado') ;  
       
       
  --obtenermos los ajsutes (peudes ser negativos si la caja tuvo iniciao real con un monto menor al de manejo de apertura
  
  select sum(efe.monto) into v_monto_ajuste_apertura
  from tes.tsolicitud_efectivo efe
  inner join tes.ttipo_solicitud  ts on  ts.id_tipo_solicitud = efe.id_tipo_solicitud and ts.codigo='INGEFE'
  where 		efe.id_caja=p_id_caja
          and   efe.fecha_ult_mov  >= v_fecha_apertura
          and   efe.fecha_ult_mov  <= f_fecha_final
          and   efe.estado in ('ingresado') 
          and   efe.motivo = 'apertura'; 
  
  
 --obtenemso tos los otrs ingresos que no sean por apertura 

 
  select sum(efe.monto) into v_monto_reposicion_caja
  from tes.tsolicitud_efectivo efe
  inner join tes.ttipo_solicitud  ts on  ts.id_tipo_solicitud = efe.id_tipo_solicitud and ts.codigo='INGEFE'
  where      efe.id_caja=p_id_caja
        and  efe.fecha_ult_mov  >= v_fecha_apertura
        and  efe.fecha_ult_mov  <= f_fecha_final  
        and  efe.estado in ('ingresado') 
        and   efe.motivo != 'apertura';
        
         
 -- sumamos todos los montos reingresados (monto percibido en caja) a caja por devoluciond e solicitantes de diversa indole.....  
 -- podria darse el caso de que el ingreso se regitr en un dia y se ahga aefectivo en otro       
        
  select sum(efe.monto) into v_monto_percibido
  from tes.tsolicitud_efectivo efe
  inner join tes.ttipo_solicitud  ts on  ts.id_tipo_solicitud = efe.id_tipo_solicitud and ts.codigo='DEVEFE'
  where       efe.id_caja=p_id_caja
         and  efe.fecha_ult_mov >= v_fecha_apertura
         and  efe.fecha_ult_mov <= f_fecha_final
         and  efe.estado in ('devuelto');
         
         
 
 --  listamos todas las salidas de dinero de caja
 
  select sum(efe.monto) into v_monto_entregado 
  from tes.tsolicitud_efectivo efe
  inner join tes.ttipo_solicitud  ts on  ts.id_tipo_solicitud = efe.id_tipo_solicitud and ts.codigo='SOLEFE'
  where 	efe.id_caja=p_id_caja
        and efe.fecha_entrega >= v_fecha_apertura
        and efe.fecha_entrega <= f_fecha_final
        and efe.estado in ('entregado','finalizado') ; 
   
               
--  listamos todos los monto devuelto a solicitante (si gataron mas de lo que solicitaron incialmente)   
--  monto de reintegro de efectivo


  select sum(efe.monto) into v_monto_reintegrado
  from tes.tsolicitud_efectivo efe
  inner join tes.ttipo_solicitud  ts on  ts.id_tipo_solicitud = efe.id_tipo_solicitud and ts.codigo='REPEFE'
  where 		efe.id_caja=p_id_caja
          and 	efe.fecha_ult_mov >= v_fecha_apertura
          and	efe.fecha_ult_mov <= f_fecha_final
          and 	efe.estado in ('repuesto') ;
           
 
 --   listado de todos los documentos rendidos  (en documentos lo valido es la fecha del documento.....)
 --   ya sean facturas, recibos de servicios bienes  o vales provisorios
    
    
    select 
            sum(dc.importe_pago_liquido::numeric) into v_importe_rendido_documentos
    from tes.tsolicitud_rendicion_det rend
    inner join tes.tsolicitud_efectivo solren on solren.id_solicitud_efectivo = rend.id_solicitud_efectivo
    inner join tes.tsolicitud_efectivo solefe on solefe.id_solicitud_efectivo = solren.id_solicitud_efectivo_fk
    inner join tes.tcaja caja on caja.id_caja = solefe.id_caja
    inner join conta.tdoc_compra_venta dc on dc.id_doc_compra_venta = rend.id_documento_respaldo
    inner join param.tplantilla pla on pla.id_plantilla = dc.id_plantilla
    where caja.id_caja=p_id_caja
    and  solren.estado='rendido' 
    and   dc.fecha >= v_fecha_apertura
    and  dc.fecha  <= f_fecha_final;
    
    
      select 
            sum(dc.importe_pago_liquido::numeric) into v_importe_rendido_documentos_proceso
    from tes.tsolicitud_rendicion_det rend
    inner join tes.tsolicitud_efectivo solren on solren.id_solicitud_efectivo = rend.id_solicitud_efectivo
    inner join tes.tsolicitud_efectivo solefe on solefe.id_solicitud_efectivo = solren.id_solicitud_efectivo_fk
    inner join tes.tcaja caja on caja.id_caja = solefe.id_caja
    inner join conta.tdoc_compra_venta dc on dc.id_doc_compra_venta = rend.id_documento_respaldo
    inner join param.tplantilla pla on pla.id_plantilla = dc.id_plantilla
    inner join tes.tproceso_caja pro on pro.id_proceso_caja = rend.id_proceso_caja
    where caja.id_caja=p_id_caja
    and  solren.estado='rendido' 
    and  pro.fecha >= v_fecha_apertura
    and  pro.fecha  <= f_fecha_final;
    
    
    

       
 /*
--listados de todas las  entregas de dinero sin rendiciones

select 
  sum(see.saldo) as saldo,
  sum(see.monto) as monto,
  sum(see.monto_devuelto) as monto_devuelto,
  sum(see.monto_rendido) as monto_rendido,
  sum(see.monto_repuesto)as  monto_repuesto
 
into
  v_reg_entregado 

from tes.vsolicitud_efectivo_entregado see
where      see.id_caja  =p_id_caja
      and  see.fecha_ult_mov  <= f_fecha_final;
      
      
      
 raise notice 'v_reg_entregado.saldo %', v_reg_entregado.saldo; 
 raise notice 'v_reg_entregado.monto %', v_reg_entregado.monto; 
 raise notice 'v_reg_entregado.monto_devuelto %', v_reg_entregado.monto_devuelto;
 raise notice 'v_reg_entregado.monto_rendido %', v_reg_entregado.monto_rendido;
 raise notice 'v_reg_entregado.monto_repuesto %', v_reg_entregado.monto_repuesto;
           
      
      
      
 select 
  sum(see.saldo) as saldo,
  sum(see.monto) as monto,
  sum(see.monto_devuelto) as monto_devuelto,
  sum(see.monto_rendido) as monto_rendido,
  sum(see.monto_rendido_sin_cbte) as monto_rendido_sin_cbte,
  sum(see.monto_rendido_con_cbte) as monto_rendido_con_cbte,
  sum(see.monto_repuesto)as  monto_repuesto
  
  into
    v_reg_finalizado

from  tes.vsolicitud_efectivo_finalizada see
where      see.id_caja  =p_id_caja
      and  see.fecha_ult_mov  <= f_fecha_final;
      
      
 raise notice 'v_reg_finalizado.saldo %', v_reg_finalizado.saldo; 
 raise notice 'v_reg_finalizado.monto %', v_reg_finalizado.monto; 
 raise notice 'v_reg_finalizado.monto_devuelto %', v_reg_finalizado.monto_devuelto;
 raise notice 'v_reg_finalizado.monto_rendido %', v_reg_finalizado.monto_rendido;
 raise notice 'v_reg_finalizado.monto_rendido_sin_cbte %', v_reg_finalizado.monto_rendido_sin_cbte;
 raise notice 'v_reg_finalizado.monto_rendido_sin_cbte %', v_reg_finalizado.monto_rendido_sin_cbte;
 raise notice 'v_reg_finalizado.monto_repuesto %', v_reg_finalizado.monto_repuesto;     
      
      
       */




--suma de todos lso documentos rendidos        
       
  v_saldo_caja =     COALESCE(v_monto_apertura,0)
                   + COALESCE(v_monto_ajuste_apertura,0)  
                   + COALESCE(v_monto_percibido,0)
                   + COALESCE(v_monto_reposicion_caja,0) 
                   - COALESCE(v_monto_entregado,0)  
  				   - COALESCE(v_monto_reintegrado,0)  
                   - COALESCE(v_monto_cierre_caja,0);
                   
                   
                   
   v_total_ingresado =     COALESCE(v_monto_apertura,0)
                         + COALESCE(v_monto_ajuste_apertura,0)
                         --  + COALESCE(v_monto_percibido,0)
                         + COALESCE(v_monto_reposicion_caja,0); 
                         
    
  raise notice 'v_total_ingresado %', v_total_ingresado;                                    
                                  
                   
                   
   v_saldo_mayor =  v_total_ingresado -  COALESCE(v_importe_rendido_documentos,0);
   
 --   v_saldo_mayor =  v_total_ingresado -  COALESCE(v_importe_rendido_documentos_proceso,0);
  
                  
                   
  raise notice 'v_monto_apertura %', v_monto_apertura;
  raise notice 'v_monto_ajuste_apertura %', v_monto_ajuste_apertura;  
  raise notice 'v_monto_entregado %', v_monto_entregado;
  raise notice 'v_monto_percibido %', v_monto_percibido;
  raise notice 'v_monto_reintegrado %', v_monto_reintegrado;
  raise notice 'v_monto_reposicion_caja %', v_monto_reposicion_caja;
  raise notice 'v_monto_cierre_caja %', v_monto_cierre_caja; 
  raise notice 'v_saldo_caja efectivo %', v_saldo_caja;   
  raise notice 'v_importe_rendido_documentos %', v_importe_rendido_documentos;
   raise notice 'v_importe_rendido_documentos_proceso %', v_importe_rendido_documentos_proceso;
  
  
  raise notice 'v_saldo_mayor  %', v_saldo_mayor; 
               
                
  return v_saldo_mayor;
  
  
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;