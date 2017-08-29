--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_get_detalle_html (  
  p_id_obligacion_pago integer
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema Gestion de Materiales
 FUNCION: 		tes.f_get_detalle_html
 DESCRIPCION:   Funcion que recupera la descripcion concepto de gasto, y descripcion de los detalles de la compra.
 AUTOR: 		 (FRANKLIN ESPINOZA A.)
 FECHA:	        19-07-2017 15:15:26
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_resp		            varchar = '';
	v_nombre_funcion        text;
	v_record 				record;	    
BEGIN

    v_nombre_funcion = 'tes.f_get_detalle_html';
	
	FOR v_record IN (SELECT tci.desc_ingas, tod.descripcion
                     FROM  tes.tobligacion_det tod
                     INNER JOIN param.tconcepto_ingas tci ON tci.id_concepto_ingas = tod.id_concepto_ingas
                     WHERE tod.id_obligacion_pago = p_id_obligacion_pago)LOOP
    	v_resp = v_resp ||'<tr>
                              <td>'||v_record.desc_ingas||'</td>
                              <td>'||v_record.descripcion||'</td>
        				   </tr>';			                
    END LOOP;
	
    /*
    FOR v_record IN (SELECT tci.desc_ingas, sdt.descripcion, sdt.cantidad
                      FROM  adq.tcotizacion_det cot
                      INNER JOIN adq.tcotizacion ct on ct.id_cotizacion=cot.id_cotizacion
                      INNER JOIN adq.tsolicitud_det sdt on sdt.id_solicitud_det=cot.id_solicitud_det
                      INNER JOIN param.tconcepto_ingas tci ON tci.id_concepto_ingas = sdt.id_concepto_ingas
                      WHERE ct.id_obligacion_pago = p_id_obligacion_pago)LOOP
    	v_resp = v_resp ||'<tr>
                              <td>'||v_record.desc_ingas||'</td>
                              <td>'||v_record.descripcion||'</td>
                              <td>'||v_record.cantidad||'</td>
        				   </tr>';			                
    END LOOP;
    */
    return v_resp;

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