CREATE OR REPLACE FUNCTION tes.f_fun_aprueba_pago_wf (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_estado_wf integer,
  p_id_proceso_wf integer,
  p_codigo_estado varchar,
  p_instrucciones_aprobador varchar = 'Paguese sin documentacion'::character varying
)
RETURNS boolean AS
$body$
/*
*
*  Autor:   GSS
*  DESC:    funcion que actualiza los estados despues del registro de una aprobacion de pago
*  Fecha:   08/04/2015
*
*/

DECLARE

	v_nombre_funcion   	text;
    v_resp    			varchar;
    v_mensaje varchar;
    
    v_registros record;
    v_estado_anterior varchar;
   
	
    
BEGIN

	 v_nombre_funcion = 'tes.f_fun_aprueba_pago_wf';
     
           select
            lb.id_libro_bancos,
            lb.id_proceso_wf,
            lb.id_estado_wf,
            lb.num_tramite,
            lb.estado
          into 
            v_registros
            
          from tes.tts_libro_bancos lb
          where id_proceso_wf = p_id_proceso_wf;
     
          IF p_instrucciones_aprobador = '' THEN
              p_instrucciones_aprobador =  'Paguese sin documentacion';
          END IF;
             --raise exception '%', p_id_proceso_wf;
             -- actualiza estado en el libro de bancos
            
             update tes.tts_libro_bancos lb set 
               id_estado_wf =  p_id_estado_wf,
               estado =p_codigo_estado,
               id_usuario_mod=p_id_usuario,
               fecha_mod=now(),
               observaciones= COALESCE(p_instrucciones_aprobador,'Paguese sin documentacion')
               
             where id_proceso_wf = p_id_proceso_wf;
    
          
             select 
               te.codigo
             into
               v_estado_anterior
             from wf.testado_wf ew 
             inner join wf.testado_wf eant on ew.id_estado_anterior = eant.id_estado_wf
             inner join wf.ttipo_estado te on te.id_tipo_estado = eant.id_tipo_estado
             where ew.id_estado_wf = p_id_estado_wf;
                   
      
      		 -- comprometer presupuesto cuando el estado anterior es el vbpresupuestos)
             IF v_estado_anterior =  'vbpagosindocumento' THEN 
              
              --modifca bandera de verificar documento  
           
                   update wf.testado_wf set 
                     verifica_documento='no'
                   where id_estado_wf = p_id_estado_wf;
                               
            
            END IF; 
            

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