--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_finalizar_solicitud_efectivo (
  p_id_usuario integer,
  p_id_solicitud_efectivo integer
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Tesoreria
 FUNCION: 		tes.f_finalizar_solicitud_efectivo
 DESCRIPCION:   Finaliza solicitud de efectivo
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        21-03-2016
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


               v_nombre_funcion = 'tes.f_finaliza_solicitud_efectivo';
               
               
               --TODO RAC 30/11/2017  calcular saldo y realizar devolucion si tiene saldo positivo lanzar error si tiene saldo negativo
    
               --obtener datos de la solicitud de efectivo
   
               select 
                 se.id_solicitud_efectivo,
                 se.id_proceso_wf,
                 se.id_estado_wf,
                 se.estado
               into
                  v_registros
               from tes.tsolicitud_efectivo se
               where se.id_solicitud_efectivo = p_id_solicitud_efectivo;   
               
                --obtener datos del siguiente estado
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
                     raise exception 'La solicitud de efectivo se encuentra mal parametrizada dentro de Work Flow,  solo  se admite un estado siguiente;  no admitido (%)',va_codigo_estado_pro[2];
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
        
         -- registra estado siguiente para la obligacion de pago
                   
         v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado_pro[1], 
                                                 v_id_funcionario_estado_sig, 
                                                 v_registros.id_estado_wf,  --estado actual 
                                                 v_registros.id_proceso_wf, --proceso actual
                                                 p_id_usuario,
                                                 NULL,
                                                 NULL,
                                                 NULL,
                                                 'Solicitud de efectivo finalizada',
                                                 v_acceso_directo ,
                                                 v_clase,
                                                 v_parametros_ad,
                                                 v_tipo_noti,
                                                 v_titulo);
                                                           
                    
         -- actualiza estado en la solicitud
                       
        update tes.tsolicitud_efectivo  s set 
        id_estado_wf =  v_id_estado_actual,
        estado = va_codigo_estado_pro[1],
        id_usuario_mod=p_id_usuario,
        fecha_mod=now()                           
        where id_solicitud_efectivo = p_id_solicitud_efectivo;
           		
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