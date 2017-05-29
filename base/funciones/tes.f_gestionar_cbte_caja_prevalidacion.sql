--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_gestionar_cbte_caja_prevalidacion (
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
Fecha:   05 abril de 2016
Descripcion  Esta funcion revierte el presupeusto comprometido en las facturas rendidas

               

*/


DECLARE

	 v_nombre_funcion   				text;
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
    
BEGIN

        v_nombre_funcion = 'tes.f_gestionar_cbte_caja_prevalidacion';
     
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
    
    
    
      IF  v_registros.codigo_tpc in ('RENYREP', 'RENYCER','SOLREN' ) THEN
                 
                   -- revertir el presupuesto de las facturas rendidas
                       
                   IF not tes.f_gestionar_presupuesto_doc_compra_venta(
                              NULL,
                              v_registros.id_proceso_caja, -- id_proceso_caja 
                              p_id_usuario, 
                              'revertir',
                              p_conexion)  THEN
                             
                         raise exception 'Error al revertir presupuesto';
                             
                   END IF;
                       
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