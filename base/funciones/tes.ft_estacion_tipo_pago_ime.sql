CREATE OR REPLACE FUNCTION "tes"."ft_estacion_tipo_pago_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Obligaciones de Pago
 FUNCION: 		tes.ft_estacion_tipo_pago_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.testacion_tipo_pago'
 AUTOR: 		 (admin)
 FECHA:	        25-08-2015 15:36:37
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
	v_id_estacion_tipo_pago	integer;
			    
BEGIN

    v_nombre_funcion = 'tes.ft_estacion_tipo_pago_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_ETP_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		25-08-2015 15:36:37
	***********************************/

	if(p_transaccion='TES_ETP_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into tes.testacion_tipo_pago(
			estado_reg,
			id_estacion,
			id_tipo_plan_pago,
			codigo_plantilla_comprobante,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.id_estacion,
			v_parametros.id_tipo_plan_pago,
			v_parametros.codigo_plantilla_comprobante,
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_estacion_tipo_pago into v_id_estacion_tipo_pago;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Estación Tipo Pago almacenado(a) con exito (id_estacion_tipo_pago'||v_id_estacion_tipo_pago||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_estacion_tipo_pago',v_id_estacion_tipo_pago::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_ETP_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		25-08-2015 15:36:37
	***********************************/

	elsif(p_transaccion='TES_ETP_MOD')then

		begin
			--Sentencia de la modificacion
			update tes.testacion_tipo_pago set
			id_estacion = v_parametros.id_estacion,
			id_tipo_plan_pago = v_parametros.id_tipo_plan_pago,
			codigo_plantilla_comprobante = v_parametros.codigo_plantilla_comprobante,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_estacion_tipo_pago=v_parametros.id_estacion_tipo_pago;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Estación Tipo Pago modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_estacion_tipo_pago',v_parametros.id_estacion_tipo_pago::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TES_ETP_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		25-08-2015 15:36:37
	***********************************/

	elsif(p_transaccion='TES_ETP_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from tes.testacion_tipo_pago
            where id_estacion_tipo_pago=v_parametros.id_estacion_tipo_pago;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Estación Tipo Pago eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_estacion_tipo_pago',v_parametros.id_estacion_tipo_pago::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
         
	else
     
    	raise exception 'Transaccion inexistente: %',p_transaccion;

	end if;

EXCEPTION
				
	WHEN OTHERS THEN
		v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
		v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
		v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
		raise exception '%',v_resp;
				        
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "tes"."ft_estacion_tipo_pago_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
