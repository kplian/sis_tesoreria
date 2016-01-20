CREATE OR REPLACE FUNCTION "tes"."ft_proceso_caja_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Obligaciones de Pago
 FUNCION: 		tes.ft_proceso_caja_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tproceso_caja'
 AUTOR: 		 (gsarmiento)
 FECHA:	        21-12-2015 20:15:22
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
	v_id_proceso_caja	integer;
			    
BEGIN

    v_nombre_funcion = 'tes.ft_proceso_caja_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_REN_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		21-12-2015 20:15:22
	***********************************/

	if(p_transaccion='TES_REN_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into tes.tproceso_caja(
			estado,
			id_comprobante_diario,
			nro_tramite,
			tipo,
			motivo,
			estado_reg,
			fecha_fin,
			id_caja,
			fecha,
			id_proceso_wf,
			monto_reposicion,
			id_comprobante_pago,
			id_estado_wf,
			fecha_inicio,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.estado,
			v_parametros.id_comprobante_diario,
			v_parametros.nro_tramite,
			v_parametros.tipo,
			v_parametros.motivo,
			'activo',
			v_parametros.fecha_fin,
			v_parametros.id_caja,
			v_parametros.fecha,
			v_parametros.id_proceso_wf,
			v_parametros.monto_reposicion,
			v_parametros.id_comprobante_pago,
			v_parametros.id_estado_wf,
			v_parametros.fecha_inicio,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_proceso_caja into v_id_proceso_caja;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Rendicion Caja almacenado(a) con exito (id_proceso_caja'||v_id_proceso_caja||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_caja',v_id_proceso_caja::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_REN_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		21-12-2015 20:15:22
	***********************************/

	elsif(p_transaccion='TES_REN_MOD')then

		begin
			--Sentencia de la modificacion
			update tes.tproceso_caja set
			estado = v_parametros.estado,
			id_comprobante_diario = v_parametros.id_comprobante_diario,
			nro_tramite = v_parametros.nro_tramite,
			tipo = v_parametros.tipo,
			motivo = v_parametros.motivo,
			fecha_fin = v_parametros.fecha_fin,
			id_caja = v_parametros.id_caja,
			fecha = v_parametros.fecha,
			id_proceso_wf = v_parametros.id_proceso_wf,
			monto_reposicion = v_parametros.monto_reposicion,
			id_comprobante_pago = v_parametros.id_comprobante_pago,
			id_estado_wf = v_parametros.id_estado_wf,
			fecha_inicio = v_parametros.fecha_inicio,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_proceso_caja=v_parametros.id_proceso_caja;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Rendicion Caja modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_caja',v_parametros.id_proceso_caja::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TES_REN_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		21-12-2015 20:15:22
	***********************************/

	elsif(p_transaccion='TES_REN_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from tes.tproceso_caja
            where id_proceso_caja=v_parametros.id_proceso_caja;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Rendicion Caja eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_caja',v_parametros.id_proceso_caja::varchar);
              
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
ALTER FUNCTION "tes"."ft_proceso_caja_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
