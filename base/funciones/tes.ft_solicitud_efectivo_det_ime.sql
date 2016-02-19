CREATE OR REPLACE FUNCTION tes.ft_solicitud_efectivo_det_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Obligaciones de Pago
 FUNCION: 		tes.ft_solicitud_efectivo_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tsolicitud_efectivo_det'
 AUTOR: 		 (gsarmiento)
 FECHA:	        24-11-2015 14:14:27
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
	v_id_solicitud_efectivo_det	integer;
    v_id_solicitud_efectivo	integer;
			    
BEGIN

    v_nombre_funcion = 'tes.ft_solicitud_efectivo_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_SOLDET_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		24-11-2015 14:14:27
	***********************************/

	if(p_transaccion='TES_SOLDET_INS')then
					
        begin
            
        	--Sentencia de la insercion
        	insert into tes.tsolicitud_efectivo_det(
			id_solicitud_efectivo,
			id_cc,
			id_concepto_ingas,
			estado_reg,
			monto,
			id_usuario_reg,
			fecha_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_solicitud_efectivo,
			v_parametros.id_cc,
			v_parametros.id_concepto_ingas,
			'activo',
			v_parametros.monto,
			p_id_usuario,
			now(),
			null,
			null
			)RETURNING id_solicitud_efectivo_det into v_id_solicitud_efectivo_det;
			
            UPDATE tes.tsolicitud_efectivo
            SET monto =  (select sum(monto) 
            			  from tes.tsolicitud_efectivo_det
            			  where id_solicitud_efectivo=v_parametros.id_solicitud_efectivo)
            where id_solicitud_efectivo=v_parametros.id_solicitud_efectivo;
            
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle almacenado(a) con exito (id_solicitud_efectivo_det'||v_id_solicitud_efectivo_det||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud_efectivo_det',v_id_solicitud_efectivo_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_SOLDET_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		24-11-2015 14:14:27
	***********************************/

	elsif(p_transaccion='TES_SOLDET_MOD')then

		begin
			--Sentencia de la modificacion
			update tes.tsolicitud_efectivo_det set
			id_solicitud_efectivo = v_parametros.id_solicitud_efectivo,
			id_cc = v_parametros.id_cc,
			id_concepto_ingas = v_parametros.id_concepto_ingas,
			monto = v_parametros.monto,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now()
			where id_solicitud_efectivo_det=v_parametros.id_solicitud_efectivo_det;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud_efectivo_det',v_parametros.id_solicitud_efectivo_det::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TES_SOLDET_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		24-11-2015 14:14:27
	***********************************/

	elsif(p_transaccion='TES_SOLDET_ELI')then

		begin
        	
            SELECT id_solicitud_efectivo into v_id_solicitud_efectivo
            FROM tes.tsolicitud_efectivo_det
            WHERE id_solicitud_efectivo_det = v_parametros.id_solicitud_efectivo_det;
            
			--Sentencia de la eliminacion
			delete from tes.tsolicitud_efectivo_det
            where id_solicitud_efectivo_det=v_parametros.id_solicitud_efectivo_det;            
            
            UPDATE tes.tsolicitud_efectivo
            SET monto = COALESCE((select sum(monto) 
            			  from tes.tsolicitud_efectivo_det
            			  where id_solicitud_efectivo=v_id_solicitud_efectivo), 0.00)
            where id_solicitud_efectivo=v_id_solicitud_efectivo;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud_efectivo_det',v_parametros.id_solicitud_efectivo_det::varchar);
              
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