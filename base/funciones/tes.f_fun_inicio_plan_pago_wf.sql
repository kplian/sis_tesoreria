CREATE OR REPLACE FUNCTION tes.f_fun_inicio_plan_pago_wf (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_estado_wf integer,
  p_id_proceso_wf integer,
  p_codigo_estado varchar
)
RETURNS boolean AS
$body$
/*
*
*  Autor:   RAC
*  DESC:    funcion que actualiza los estados despues del registro de un retroceso en el plan de pago
*  Fecha:   10/06/2013
*
*/

DECLARE

	v_nombre_funcion   	text;
    v_resp    			varchar;
    v_mensaje varchar;
    
    v_registros record;
    v_monto_ejecutar_mo  numeric;
   
	
    
BEGIN

	 v_nombre_funcion = 'tes.f_fun_inicio_plan_pago_wf';
    
     -- obtenermos datos basicos
     select
            pp.id_plan_pago,
            pp.id_proceso_wf,
            pp.id_estado_wf,
            pp.estado,
            pp.fecha_tentativa,
            op.numero,
            pp.total_prorrateado ,
            pp.monto_ejecutar_total_mo,
            pp.fecha_conformidad,
            pp.conformidad,
            pp.monto
     into 
            v_registros
            
     from tes.tplan_pago  pp
     inner  join tes.tobligacion_pago op on op.id_obligacion_pago = pp.id_obligacion_pago
     where pp.id_proceso_wf  =  p_id_proceso_wf;
          
    -----------------------------------------------------------------------------------
    -- validacion del prorrateo--  (con el codigo actual de estado antes de cambiarlo)   
    -----------------------------------------------------------------------------------
          
     IF p_codigo_estado  in ('vbsolicitante')  THEN
              
             select
                sum(pro.monto_ejecutar_mo)
             into
                v_monto_ejecutar_mo
             from tes.tprorrateo pro
             where pro.estado_reg = 'activo' and  
                pro.id_plan_pago  = v_registros.id_plan_pago;
                    
            IF v_registros.total_prorrateado != v_registros.monto_ejecutar_total_mo  or  v_registros.monto_ejecutar_total_mo != v_monto_ejecutar_mo THEN
                raise exception 'El total prorrateado no iguala con el monto total a ejecutar';
            END IF;
     END IF;
     /*jrr(10/10/2014): El monto no puede ser menor o igual a 0*/ 
     IF p_codigo_estado  in ('vbgerente','vbfin','vbsolicitante')  THEN
     	/*if (v_registros.fecha_conformidad is null or v_registros.conformidad is null) then
        	raise exception 'Registre la conformidad antes de pasar al siguiente estado';
        end if;*/
        if (v_registros.monto <= 0 ) then
        	raise exception 'El monto del pago no puede ser 0 ni menor a 0';
        end if;
     END IF; 
     
     IF p_codigo_estado = 'pendiente' THEN
         raise exception 'Error el estado pendiente debe generar comprobantes';
     END IF;
     
        
    -- actualiza estado en la solicitud
    update tes.tplan_pago  t set 
       id_estado_wf =  p_id_estado_wf,
       estado = p_codigo_estado,
       id_usuario_mod=p_id_usuario,
       id_usuario_ai = p_id_usuario_ai,
       usuario_ai = p_usuario_ai,
       fecha_mod=now()
                   
    where id_proceso_wf = p_id_proceso_wf;
   
   

RETURN   TRUE;



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