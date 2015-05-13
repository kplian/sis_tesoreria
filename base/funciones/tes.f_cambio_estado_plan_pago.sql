--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_cambio_estado_plan_pago (
  p_id_usuario integer,
  p_id_plan_pago integer
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		tes.f_cambio_estado_plan_pago
 DESCRIPCION:   Inserta registro de cotizacion
 AUTOR: 		Rensi Arteaga COpar
 FECHA:	        26-1-2014
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

    v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
    v_registros				record;
    
     va_id_tipo_estado_pro 	integer[];
    va_codigo_estado_pro 	varchar[];
    va_disparador_pro 		varchar[];
    va_regla_pro 			varchar[];
    va_prioridad_pro		integer[];
    
    v_acceso_directo     	varchar;
    v_clase    				varchar;
    v_parametros_ad    		varchar;
    v_tipo_noti    			varchar;
    v_titulo    			varchar;
    v_num_funcionarios		integer;
    v_id_funcionario_estado_sig  integer;
    v_id_estado_actual			 integer;
    v_num_estados				 integer;
    
    	
 
    
     
			    
BEGIN


               v_nombre_funcion = 'tes.f_cambio_estado_plan_pago';
    
               --obtener datos del pago
   
               select 
                 pp.id_plan_pago,
                 pp.id_proceso_wf,
                 pp.id_estado_wf,
                 pp.estado,
                 pp.nro_cuota
               into
                  v_registros
               from tes.tplan_pago pp
               where pp.id_plan_pago = p_id_plan_pago;   
               
               
                --obtener detos del siguiente estado
               SELECT 
                     ps_id_tipo_estado,
                     ps_codigo_estado,
                     ps_disparador,
                     ps_regla,
                     ps_prioridad
                  into
                    va_id_tipo_estado_pro,
                    va_codigo_estado_pro,
                    va_disparador_pro,
                    va_regla_pro,
                    va_prioridad_pro
                          
                FROM wf.f_obtener_estado_wf( v_registros.id_proceso_wf,v_registros.id_estado_wf,NULL,'siguiente');   
          
        
                IF  va_id_tipo_estado_pro[2] is not null  THEN
                     raise exception 'La obligacion de pago único se encuentra mal parametrizada dentro de Work Flow,  solo  se admite un estado siguiente;  no admitido (%)',va_codigo_estado_pro[2];
                END IF;
                
                 v_num_estados= array_length(va_id_tipo_estado_pro, 1);
                 
                 
                --definir el depto y funcionario para el siguiente estado
                IF v_num_estados = 1 then
                  		-- si solo hay un estado,  verificamos si tiene mas de un funcionario por este estado
                     SELECT 
                       *
                       into
                        v_num_funcionarios
                      
                     FROM wf.f_funcionario_wf_sel(
                         p_id_usuario, 
                         va_id_tipo_estado_pro[1], 
                         now()::date,
                         v_registros.id_estado_wf,
                         TRUE) AS (total bigint);
                     
                     
             
                                   
                      IF v_num_funcionarios = 1 THEN
                      -- si solo es un funcionario, recuperamos el funcionario correspondiente
                           SELECT 
                               id_funcionario
                                 into
                               v_id_funcionario_estado_sig
                           FROM wf.f_funcionario_wf_sel(
                               p_id_usuario, 
                               va_id_tipo_estado_pro[1], 
                               now()::date,
                               v_registros.id_estado_wf,
                               FALSE) 
                               AS (id_funcionario integer,
                                 desc_funcionario text,
                                 desc_funcionario_cargo text,
                                 prioridad integer);
                      END IF;  
        
        ELSE
        
            raise exception 'El flujo se encuentra mal parametrizados, mas de un estado destino';
        
        END IF;
        
             IF   va_codigo_estado_pro[1] in('vbgerente','vbdeposito')   THEN
                  
                  v_acceso_directo = '../../../sis_tesoreria/vista/plan_pago/PlanPagoVb.php';
                  v_clase = 'PlanPagoVb';
                  v_parametros_ad = '{filtro_directo:{campo:"plapa.id_proceso_wf",valor:"'||v_registros.id_proceso_wf::varchar||'"}}';
                  v_tipo_noti = 'notificacion';
                  v_titulo  = 'Visto Bueno';
             
             END IF;
                
                 -- registra estado siguiente para la obligacion de pago
                 
                 v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado_pro[1], 
                                                         v_id_funcionario_estado_sig, 
                                                         v_registros.id_estado_wf,  --estado actual 
                                                         v_registros.id_proceso_wf, --proceso actual
                                                         p_id_usuario,
                                                         NULL,
                                                         NULL,
                                                         NULL,
                                                         'Cuota única plan de pago por excepción',
                                                         v_acceso_directo ,
                                                         v_clase,
                                                         v_parametros_ad,
                                                         v_tipo_noti,
                                                         v_titulo);
                                                         
                                                        
                    
                  
                 -- actualiza estado en la solicitud
                 -- funcion para cambio de estado     
                 
                IF  tes.f_fun_inicio_plan_pago_wf(p_id_usuario, 
                                                  NULL, --_id_usuario_ai, 
                                                  NULL, --_nombre_usuario_ai, 
                                                  v_id_estado_actual, 
                                                  v_registros.id_proceso_wf, 
                                                  va_codigo_estado_pro[1]) THEN
                                                  
                END IF;
                     
    
               
 

           
            --Devuelve la respuesta
          return TRUE;




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