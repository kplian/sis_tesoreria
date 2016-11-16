--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_pagos_pendientes_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.f_pagos_pendientes_sel
 DESCRIPCION:   Listado de pagos pendientes
 AUTOR: 		 (rac - kplian)
 FECHA:	        10-10-2014 15:43:23
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_filtro			varchar;
    
    v_historico        varchar;
    v_inner            varchar;
    v_strg_pp         varchar;
    v_strg_obs         varchar;
    va_id_depto        integer[];
    
  
BEGIN

	v_nombre_funcion = 'tes.f_pagos_pendientes_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_PAGOPEN_SEL'
 	#DESCRIPCION:	Consulta de pagos pendientes a la fecha para envio de alertas y solicitudes automatica
 	#AUTOR:		admin	
 	#FECHA:		10-04-2013 15:43:23
	***********************************/

	if(p_transaccion='TES_PAGOPEN_SEL')then
     				
    	begin
            
           --Sentencia de la consulta
			v_consulta:='SELECT 
                          id_plan_pago,
                          fecha_tentativa,
                          id_estado_wf,
                          id_proceso_wf,
                          monto,
                          liquido_pagable,
                          monto_retgar_mo,
                          monto_ejecutar_total_mo,
                          estado,
                          list,
                          list_unique,
                          desc_funcionario_solicitante,
                          email_empresa_fun_sol,
                          email_empresa_usu_reg,
                          desc_funcionario_usu_reg,
                          tipo,
                          tipo_pago,
                          tipo_obligacion,
                          tipo_solicitud,
                          tipo_concepto_solicitud,
                          pago_variable,
                          tipo_anticipo,
                          num_tramite,
                          nro_cuota,
                          nombre_pago,
                          obs,
                          codigo_moneda
                        FROM 
                          tes.vpago_pendientes_al_dia';
			
			 --Devuelve la respuesta
			return v_consulta;
						
		end;
					
	else
					     
		raise exception 'Transaccion inexistente';
					         
	end if;
					
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