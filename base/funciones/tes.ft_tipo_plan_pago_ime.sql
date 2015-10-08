--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.ft_tipo_plan_pago_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.ft_tipo_plan_pago_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.ttipo_plan_pago'
 AUTOR: 		 (admin)
 FECHA:	        08-07-2014 13:12:03
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
	v_id_tipo_plan_pago	integer;
			    
BEGIN

    v_nombre_funcion = 'tes.ft_tipo_plan_pago_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_TPP_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		08-07-2014 13:12:03
	***********************************/

	if(p_transaccion='TES_TPP_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into tes.ttipo_plan_pago(
			codigo_proceso_llave_wf,
			descripcion,
			codigo_plantilla_comprobante,
			estado_reg,
			codigo,
			id_usuario_ai,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.codigo_proceso_llave_wf,
			v_parametros.descripcion,
			v_parametros.codigo_plantilla_comprobante,
			'activo',
			v_parametros.codigo,
			v_parametros._id_usuario_ai,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			null,
			null
							
			
			
			)RETURNING id_tipo_plan_pago into v_id_tipo_plan_pago;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Plan Pago almacenado(a) con exito (id_tipo_plan_pago'||v_id_tipo_plan_pago||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_plan_pago',v_id_tipo_plan_pago::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_TPP_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		08-07-2014 13:12:03
	***********************************/

	elsif(p_transaccion='TES_TPP_MOD')then

		begin
			--Sentencia de la modificacion
			update tes.ttipo_plan_pago set
			codigo_proceso_llave_wf = v_parametros.codigo_proceso_llave_wf,
			descripcion = v_parametros.descripcion,
			codigo_plantilla_comprobante = v_parametros.codigo_plantilla_comprobante,
			codigo = v_parametros.codigo,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_tipo_plan_pago=v_parametros.id_tipo_plan_pago;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Plan Pago modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_plan_pago',v_parametros.id_tipo_plan_pago::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TES_TPP_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		08-07-2014 13:12:03
	***********************************/

	elsif(p_transaccion='TES_TPP_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from tes.ttipo_plan_pago
            where id_tipo_plan_pago=v_parametros.id_tipo_plan_pago;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Plan Pago eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_plan_pago',v_parametros.id_tipo_plan_pago::varchar);
              
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