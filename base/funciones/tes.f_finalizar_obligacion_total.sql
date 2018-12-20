--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_finalizar_obligacion_total (
  p_id_obligacion_pago integer,
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_nombre_usuario_ai varchar,
  p_forzar_fin varchar = 'no'::character varying
)
RETURNS varchar AS
$body$
/************************************************************************** SISTEMA:        Sistema de Tesoreria FUNCION:         tes.ft_obligacion_pago_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tobligacion_pago'
 AUTOR:         RAC KPLIAN  
 FECHA:        2014 16:01:32
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:    
 AUTOR:            
 FECHA:     
     HISTORIAL DE MODIFICACIONES:
   	
 ISSUE            FECHA:		      AUTOR                                DESCRIPCION
 #0       		       2014     RAC (KPLIAN)          creación
 #7890           29/11/2018     RAC KPLIAN            Se corrige la opcion de preguntar apra forzar cierres en obligaciones de pago extendidas
          
***************************************************************************/



DECLARE
  v_total_detalle 		numeric;
  v_factor				numeric;
  v_id_obligacion_det	integer;
  v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
    v_id_proceso_wf			integer;
    v_id_estado_wf			integer;
    v_codigo_estado			varchar;
    v_id_depto				integer;
    v_tipo_obligacion		varchar;
    v_total_nro_cuota		integer;
    v_fecha_pp_ini			date;
    v_rotacion				integer;
    v_id_plantilla			integer;
    v_tipo_cambio_conv		numeric;
    v_desc_proveedor		text;
    v_pago_variable			varchar;
    v_comprometido			varchar;
    v_id_usuario_reg_op		integer;
    v_fecha_op				date;
    va_id_tipo_estado 		integer[];
    va_codigo_estado 		varchar[];
    va_disparador 			varchar[];
    va_regla 				varchar[];
    va_prioridad  			integer[];
    v_id_estado_actual		integer;
    v_num_estados 			integer;     
    v_obs 					varchar;
    v_resp_fin 				varchar[];
    v_preguntar				varchar;
    v_id_funcionario_estado integer;
BEGIN
	v_nombre_funcion = 'tes.f_finalizar_obligacion_total';
    v_preguntar = 'no';   --#7890   mejora a las funcionaldiad de extencion de adquisiciones  
       --recupera parametros
			
             select 
                op.id_proceso_wf,
                op.id_estado_wf,
                op.estado,
                op.id_depto,
                op.tipo_obligacion,
                op.total_nro_cuota,
                op.fecha_pp_ini,
                op.rotacion,
                op.id_plantilla,
                op.tipo_cambio_conv,
                pr.desc_proveedor,
                op.pago_variable,
                op.comprometido,
                op.id_usuario_reg,
                op.fecha
              
             into
                v_id_proceso_wf,
                v_id_estado_wf,
                v_codigo_estado,
                v_id_depto,
                v_tipo_obligacion,
                v_total_nro_cuota,
                v_fecha_pp_ini,
                v_rotacion,
                v_id_plantilla,
                v_tipo_cambio_conv,
                v_desc_proveedor,
                v_pago_variable,
                v_comprometido,
                v_id_usuario_reg_op,
                v_fecha_op
             from tes.tobligacion_pago op
             left join param.vproveedor pr  on pr.id_proveedor = op.id_proveedor
             where op.id_obligacion_pago = p_id_obligacion_pago; 
             
             -- VALIDACIONES que se finalicen solo boligaciones en pago
             
             IF  v_codigo_estado NOT in  ('en_pago') THEN
               raise exception 'Solo se admiten obligaciones  en pago';
             END IF;
			
            
             -- obtiene el siguiente estado del flujo 
             SELECT 
                 *
              into
                va_id_tipo_estado,
                va_codigo_estado,
                va_disparador,
                va_regla,
                va_prioridad
            
            FROM wf.f_obtener_estado_wf(v_id_proceso_wf, v_id_estado_wf,NULL,'siguiente');
            
            
            
            v_num_estados= array_length(va_id_tipo_estado, 1);
            v_obs = '';
           
           
            ---------------------------------------
            -- REGISTRA EL SIGUIENTE ESTADO DEL WF.
            ---------------------------------------
             v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado[1], 
                                                           v_id_funcionario_estado, 
                                                           v_id_estado_wf, 
                                                           v_id_proceso_wf,
                                                           p_id_usuario,
                                                           p_id_usuario_ai,
                                                           p_nombre_usuario_ai,
                                                           v_id_depto,
                                                           v_obs);
            
            
            --------------------------------------
            -- actualiza estado en la solicitud
            -------------------------------------
             
             
             update tes.tobligacion_pago  set 
               id_estado_wf =  v_id_estado_actual,
               estado = va_codigo_estado[1],
               id_usuario_mod = p_id_usuario,               
               fecha_mod = now(),
               id_usuario_ai = p_id_usuario_ai,
               usuario_ai = p_nombre_usuario_ai
             where id_obligacion_pago  = p_id_obligacion_pago;
        
          
            ----------------------------------------------------------------------------------------
            -- FINALIZACION DE OBLIGACION DE PAGO (pasa del estado "en pago" al estado "finalizado")
            ----------------------------------------------------------------------------------------
            
            
            -- esta verificacion se hace al final por que es necesario
            -- que la llamada de integracion con endesis quede por ulitmo en caso de acontecer algun error
            -- el rollback sea efectivo y no afecte la integridad de endesis
            
            IF  v_codigo_estado = 'en_pago' THEN
              
               --llamar a la funcion de finalizacion de obligacion
                 
                 v_resp_fin = tes.f_finalizar_obligacion(p_id_obligacion_pago, 
                  										 p_id_usuario,
                                                         p_id_usuario_ai,
                                                         p_nombre_usuario_ai,
                                                         p_forzar_fin);
            
                 IF v_resp_fin[1] = 'false'  THEN
                    
                    v_preguntar = 'si';                    
                    raise exception ' %',v_resp_fin[2];
                 
                 ELSE
                      --#7890  se marcan las obligaciones forzadas a finalizar
                      update tes.tobligacion_pago set
                        fin_forzado = p_forzar_fin
                      where id_obligacion_pago = p_id_obligacion_pago;
                 
                     v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Obligacion fue finzalida, y el presupuesto sobrante revertido');
                     v_resp = pxp.f_agrega_clave(v_resp,'preguntar','no');
                 END IF;
            ELSE
                v_resp = pxp.f_agrega_clave(v_resp,'mensaje','La obligacion paso al siguiente estado');
            
            END IF;
            
            v_resp = pxp.f_agrega_clave(v_resp,'id_obligacion_pago',p_id_obligacion_pago::varchar);
            
            --raise exception 'llega al final...';
              
            --Devuelve la respuesta
            return v_resp;      
      
EXCEPTION
				
	WHEN OTHERS THEN
		v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
		v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
		v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
        v_resp = pxp.f_agrega_clave(v_resp,'_preguntar',v_preguntar);  --#7890  manda variable para preguntar si es necesario forzar el cierre
                                                                       --#7890 NOTA, los nombres de las varaible no peende usarce de una funcion aotra
                                                                       --#7890 el resultado se peirde no investigue la causa
        
		raise exception '%',v_resp;
				        
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;