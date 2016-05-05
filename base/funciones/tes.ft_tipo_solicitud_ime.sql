--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.ft_tipo_solicitud_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Obligaciones de Pago
 FUNCION: 		tes.ft_tipo_solicitud_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.ttipo_solicitud'
 AUTOR: 		 (admin)
 FECHA:	        04-02-2016 21:15:09
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
	v_id_tipo_solicitud	integer;
			    
BEGIN

    v_nombre_funcion = 'tes.ft_tipo_solicitud_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_TPSOL_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		04-02-2016 21:15:09
	***********************************/

	if(p_transaccion='TES_TPSOL_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into tes.ttipo_solicitud(
			codigo,
			estado_reg,
			codigo_proceso_llave_wf,
			codigo_plantilla_comprobante,
			nombre,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.codigo,
			'activo',
			v_parametros.codigo_proceso_llave_wf,
			v_parametros.codigo_plantilla_comprobante,
			v_parametros.nombre,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_tipo_solicitud into v_id_tipo_solicitud;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Solicitud almacenado(a) con exito (id_tipo_solicitud'||v_id_tipo_solicitud||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_solicitud',v_id_tipo_solicitud::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_TPSOL_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		04-02-2016 21:15:09
	***********************************/

	elsif(p_transaccion='TES_TPSOL_MOD')then

		begin
			--Sentencia de la modificacion
			update tes.ttipo_solicitud set
			codigo = v_parametros.codigo,
			codigo_proceso_llave_wf = v_parametros.codigo_proceso_llave_wf,
			codigo_plantilla_comprobante = v_parametros.codigo_plantilla_comprobante,
			nombre = v_parametros.nombre,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_tipo_solicitud=v_parametros.id_tipo_solicitud;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Solicitud modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_solicitud',v_parametros.id_tipo_solicitud::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TES_TPSOL_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		04-02-2016 21:15:09
	***********************************/

	elsif(p_transaccion='TES_TPSOL_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from tes.ttipo_solicitud
            where id_tipo_solicitud=v_parametros.id_tipo_solicitud;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Solicitud eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_solicitud',v_parametros.id_tipo_solicitud::varchar);
              
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
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;