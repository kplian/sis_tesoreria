--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_conta_act_tran_plan_pago_dev (
  p_id_int_transaccion integer,
  p_id_prorrateo integer
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.f_conta_act_tran_plan_pago_dev
 DESCRIPCION:  Esta funciona actualiza el id_int_trasaccion en 
 AUTOR: 		 RAC
 FECHA:	        04-09-2013 03:51:00
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_transaccion	integer;
			    
BEGIN

    v_nombre_funcion = 'tes.f_conta_act_tran_plan_pago_dev';
  
      update tes.tprorrateo set
      id_int_transaccion = p_id_int_transaccion
      where id_prorrateo = p_id_prorrateo;

	RETURN TRUE;
	

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