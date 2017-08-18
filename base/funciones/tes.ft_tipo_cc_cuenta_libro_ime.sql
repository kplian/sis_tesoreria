--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.ft_tipo_cc_cuenta_libro_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.ft_tipo_cc_cuenta_libro_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.ttipo_cc_cuenta_libro'
 AUTOR: 		 (admin)
 FECHA:	        18-08-2017 16:07:02
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
	v_id_ttipo_cc_cuenta_libro	integer;
			    
BEGIN

    v_nombre_funcion = 'tes.ft_tipo_cc_cuenta_libro_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_TCP_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		18-08-2017 16:07:02
	***********************************/

	if(p_transaccion='TES_TCP_INS')then
					
        begin
        
            --verifica que el tipo_cc  nose duplique para la cuenta y libro de bancos
            
            IF  exists ( select 1 
                          from tes.ttipo_cc_cuenta_libro tcl
                          where tcl.id_cuenta_bancaria = v_parametros.id_cuenta_bancaria
                          and tcl.id_depto = v_parametros.id_depto 
                          and tcl.estado_reg = 'activo') THEN
               raise exception 'El tipo de centro ya se encuentra parametrizado para esta cuenta';
            END IF;
        
        	--Sentencia de la insercion
        	insert into tes.ttipo_cc_cuenta_libro(
			id_depto,
			id_cuenta_bancaria,
			obs,
			estado_reg,
			id_tipo_cc,
			id_usuario_ai,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_depto,
			v_parametros.id_cuenta_bancaria,
			v_parametros.obs,
			'activo',
			v_parametros.id_tipo_cc,
			v_parametros._id_usuario_ai,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			null,
			null
							
			
			
			)RETURNING id_ttipo_cc_cuenta_libro into v_id_ttipo_cc_cuenta_libro;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Configuración almacenado(a) con exito (id_ttipo_cc_cuenta_libro'||v_id_ttipo_cc_cuenta_libro||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_ttipo_cc_cuenta_libro',v_id_ttipo_cc_cuenta_libro::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_TCP_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		18-08-2017 16:07:02
	***********************************/

	elsif(p_transaccion='TES_TCP_MOD')then

		begin
        
          IF  exists ( select 1 
                          from tes.ttipo_cc_cuenta_libro tcl
                          where tcl.id_cuenta_bancaria = v_parametros.id_cuenta_bancaria
                          and tcl.id_depto = v_parametros.id_depto 
                          and tcl.id_ttipo_cc_cuenta_libro != v_parametros.id_ttipo_cc_cuenta_libro
                          and tcl.estado_reg = 'activo') THEN
               raise exception 'El tipo de centro ya se encuentra parametrizado para esta cuenta';
            END IF;
            
            
			--Sentencia de la modificacion
			update tes.ttipo_cc_cuenta_libro set
			id_depto = v_parametros.id_depto,
			id_cuenta_bancaria = v_parametros.id_cuenta_bancaria,
			obs = v_parametros.obs,
			id_tipo_cc = v_parametros.id_tipo_cc,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_ttipo_cc_cuenta_libro=v_parametros.id_ttipo_cc_cuenta_libro;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Configuración modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_ttipo_cc_cuenta_libro',v_parametros.id_ttipo_cc_cuenta_libro::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TES_TCP_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		18-08-2017 16:07:02
	***********************************/

	elsif(p_transaccion='TES_TCP_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from tes.ttipo_cc_cuenta_libro
            where id_ttipo_cc_cuenta_libro=v_parametros.id_ttipo_cc_cuenta_libro;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Configuración eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_ttipo_cc_cuenta_libro',v_parametros.id_ttipo_cc_cuenta_libro::varchar);
              
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