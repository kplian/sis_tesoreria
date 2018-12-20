--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_calcular_factor_obligacion_det (
  p_id_obligacion integer
)
RETURNS varchar AS
$body$
/************************************************************************** 
 SISTEMA:        Sistema de Tesoreria FUNCION:        tes.f_extender_obligacion
 DESCRIPCION:    Procesa la extención de la obligacion de pago para una siguiente gestion 
 AUTOR:          RAC KPLIAN  
 FECHA:          02-04-2013
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:    
 AUTOR:            
 FECHA:     
     HISTORIAL DE MODIFICACIONES:
   	
 ISSUE            FECHA:		      AUTOR                                DESCRIPCION
 #7890          12-12-2018		   RAC (KPLIAN)          aumenta el calculo prorrateado del monto para la siguiente gestion en el detalle
         
***************************************************************************/

DECLARE
    v_total_detalle 		numeric;
    v_factor				numeric;
    v_id_obligacion_det  	integer;
    v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
    v_monto_sg_mo           numeric;  --7890
    v_fecha_op              date;     --7890
    v_id_moneda	            integer;  --7890
    v_total_ges_act         numeric;  --7890
    v_total_ges_sig         numeric;  --7890
BEGIN
	v_nombre_funcion = 'tes.f_calcular_factor_obligacion_det';
       select 
        sum(od.monto_pago_mo),
        sum(od.monto_pago_mo - od.monto_pago_sg_mo),
        sum(od.monto_pago_sg_mo)
       into
        v_total_detalle,
        v_total_ges_act,
        v_total_ges_sig
       from tes.tobligacion_det od
       where od.id_obligacion_pago = p_id_obligacion and od.estado_reg ='activo'; 
                         
       IF v_total_detalle = 0 or v_total_detalle is null THEN
                         
           raise exception 'No existe el detalle de obligacion...';
                         
       END IF; 
                         
                  
      ------------------------------------------------------------
      --calcula el factor de prorrateo de la obligacion  detalle
      -----------------------------------------------------------
                        
      update tes.tobligacion_det set
      factor_porcentual =  (monto_pago_mo/v_total_ges_act) -- #7890 se calculo solo con el monto presupeustado para la gestion vigente, calculo anterior:      (monto_pago_mo/v_total_detalle)
      where estado_reg = 'activo' and id_obligacion_pago=p_id_obligacion;
                        
      --testeo
      select sum(od.factor_porcentual) into v_factor
      from tes.tobligacion_det od
      where od.id_obligacion_pago = p_id_obligacion and od.estado_reg='activo';
                        
                        
      v_factor = v_factor - 1;
                        
       --recuperar el primer  factor registrado                 
      select od.id_obligacion_det into v_id_obligacion_det
      from tes.tobligacion_det od
      where od.id_obligacion_pago = p_id_obligacion
      and od.estado_reg = 'activo'
      limit 1 offset 0; 
                        
                        
      --actualiza el factor del primer registro  para que la suma de siempre 1
      update tes.tobligacion_det  set
      factor_porcentual=  factor_porcentual - v_factor --cone sto porczamos que la suma siempre sea igual a 1
      where estado_reg = 'activo'
      and id_obligacion_det= v_id_obligacion_det;
      
      ------------------------------------------------------------------
      --  #7890  cacular el monto prorrateado para la siguiente gestion
      ------------------------------------------------------------------
      update tes.tobligacion_pago  set
       monto_sg_mo =  v_total_ges_sig
      where id_obligacion_pago = p_id_obligacion;
       
      
      
      
      return 'exito';
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