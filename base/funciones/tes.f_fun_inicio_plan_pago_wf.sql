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
    v_mensaje 			varchar;
    
    v_registros 		record;
    v_regitros_ewf		record;
    v_monto_ejecutar_mo  numeric;
    v_id_uo	integer;
    v_id_usuario_excepcion	integer;
    v_resp_doc   boolean;
   
	
    
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
            pp.monto,
            pp.id_obligacion_pago
     into 
            v_registros
            
     from tes.tplan_pago  pp
     inner  join tes.tobligacion_pago op on op.id_obligacion_pago = pp.id_obligacion_pago
     where pp.id_proceso_wf  =  p_id_proceso_wf;
     
     
     select
       ewf.id_funcionario,
       ewf.id_depto,
       ewf.id_usuario_reg
     into
       v_regitros_ewf
     from wf.testado_wf ewf
     where  ewf.id_estado_wf = p_id_estado_wf; 
          
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
     
     --si el estado siguiente es visto supconta guarda el depto selecionado com oel depto de conta
     IF p_codigo_estado = 'supconta' THEN
         update tes.tplan_pago  t set 
           id_depto_conta = v_regitros_ewf.id_depto
         where id_proceso_wf = p_id_proceso_wf;
     END IF;
     
     
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
        IF p_codigo_estado  in ('vbfin')  THEN
        	select ce.id_uo into v_id_uo
            from tes.tconcepto_excepcion ce
            inner join tes.tobligacion_det od on ce.id_concepto_ingas = od.id_concepto_ingas                       
            where od.id_obligacion_pago = v_registros.id_obligacion_pago
            limit 1 offset 0;
            
            if (v_id_uo is not null) then
            	
                --obtener funcionario
            	select (orga.f_get_funcionarios_x_uo(v_id_uo, now()::date))[1] into v_id_usuario_excepcion;
                
                if (v_id_usuario_excepcion is null) then
                	raise exception 'No existe un funcionario asignado en la uo de la excepcion definida para el concepto de gasto';
                end if;
                
                --obtener usuario
                select u.id_usuario into v_id_usuario_excepcion
                from orga.tfuncionario f
                inner join segu.tusuario u on f.id_persona = u.id_persona
                where f.id_funcionario = v_id_usuario_excepcion;
                
                if v_id_usuario_excepcion is null then
            		raise exception 'El funcionario aprobador no tiene usuario en el sistema para firmar el acta de conformidad';
            	end if;
                
                update tes.tplan_pago
               set conformidad = 'SIN OBSERVACIONES',
               fecha_conformidad = now()
               where id_plan_pago = v_registros.id_plan_pago;
               
                              
               --para eliminar la firma si existiera
               update wf.tdocumento_wf 
               set fecha_firma = NULL
               from wf.ttipo_documento td
               where td.id_tipo_documento = wf.tdocumento_wf.id_tipo_documento and td.codigo = 'ACTCONF' and
               wf.tdocumento_wf .estado_reg = 'activo' and td.estado_reg = 'activo' and
               wf.tdocumento_wf .id_proceso_wf = p_id_proceso_wf;
               
               
               v_resp_doc = wf.f_verifica_documento(v_id_usuario_excepcion, p_id_estado_wf);
                
            end if;
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