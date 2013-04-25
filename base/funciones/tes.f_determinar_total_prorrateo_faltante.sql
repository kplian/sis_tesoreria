--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_determinar_total_prorrateo_faltante (
  p_id_obligacion_det integer,
  p_filtro varchar = 'registrado'::character varying
)
RETURNS numeric AS
$body$
DECLARE
    v_consulta    		varchar;
	v_registros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
     v_monto_total_registrado numeric;
     v_monto_total numeric;
			    
BEGIN

	v_nombre_funcion = 'tes.f_determinar_total_prorrateo_faltante';
    
            select
              od.id_obligacion_det,
              od.monto_pago_mo
            into v_registros
            from tes.tobligacion_det od
            where od.id_obligacion_det = p_id_obligacion_det;
              
   
 
            IF p_filtro not in ('registrado','devengado','pagado') THEN
              
              raise exception 'filtro no reconocido';
            
            END IF;
            
            IF   p_filtro = 'registrado' THEN
            
                 
                     --determinar el total registrado
                   
                     select 
                       sum( p.monto_ejecutar_mo)
                     into 
                       v_monto_total_registrado
                     from tes.tprorrateo p
                     inner join tes.tplan_pago pp on p.id_plan_pago = pp.id_plan_pago 
                                                  and pp.estado != 'anulado' and pp.estado_reg='activo' 
                     where  p.estado_reg='activo' and p.id_obligacion_det = p_id_obligacion_det;       
            
            
                      v_monto_total= COALESCE(v_registros.monto_pago_mo,0)-COALESCE(v_monto_total_registrado,0);
                    
                    return v_monto_total;    
           
    
    
        
             ELSE
            
            
            --TO DO,   fltro para faltante por devengar, faltante por pagar 
            
              raise exception 'Los otros filtros no fueron implementados';
            
            
            
            END IF;



 
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