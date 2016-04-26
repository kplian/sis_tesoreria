CREATE OR REPLACE FUNCTION "tes"."ft_tipo_proceso_caja_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Tesoreria
 FUNCION: 		tes.ft_tipo_proceso_caja_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.ttipo_proceso_caja'
 AUTOR: 		 (admin)
 FECHA:	        23-03-2016 13:33:41
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
	v_id_tipo_proceso_caja	integer;
			    
BEGIN

    v_nombre_funcion = 'tes.ft_tipo_proceso_caja_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_PRCJ_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		23-03-2016 13:33:41
	***********************************/

	if(p_transaccion='TES_PRCJ_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into tes.ttipo_proceso_caja(
			visible_en,
			estado_reg,
			codigo_wf,
			nombre,
			codigo_plantilla_cbte,
			codigo,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.visible_en,
			'activo',
			v_parametros.codigo_wf,
			v_parametros.nombre,
			v_parametros.codigo_plantilla_cbte,
			v_parametros.codigo,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_tipo_proceso_caja into v_id_tipo_proceso_caja;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Proceso Caja almacenado(a) con exito (id_tipo_proceso_caja'||v_id_tipo_proceso_caja||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_proceso_caja',v_id_tipo_proceso_caja::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_PRCJ_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		23-03-2016 13:33:41
	***********************************/

	elsif(p_transaccion='TES_PRCJ_MOD')then

		begin
			--Sentencia de la modificacion
			update tes.ttipo_proceso_caja set
			visible_en = v_parametros.visible_en,
			codigo_wf = v_parametros.codigo_wf,
			nombre = v_parametros.nombre,
			codigo_plantilla_cbte = v_parametros.codigo_plantilla_cbte,
			codigo = v_parametros.codigo,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_tipo_proceso_caja=v_parametros.id_tipo_proceso_caja;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Proceso Caja modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_proceso_caja',v_parametros.id_tipo_proceso_caja::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TES_PRCJ_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		23-03-2016 13:33:41
	***********************************/

	elsif(p_transaccion='TES_PRCJ_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from tes.ttipo_proceso_caja
            where id_tipo_proceso_caja=v_parametros.id_tipo_proceso_caja;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Proceso Caja eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_proceso_caja',v_parametros.id_tipo_proceso_caja::varchar);
              
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
ALTER FUNCTION "tes"."ft_tipo_proceso_caja_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
