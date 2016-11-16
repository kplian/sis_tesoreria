--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.ft_concepto_excepcion_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Obligaciones de Pago
 FUNCION: 		tes.ft_concepto_excepcion_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tconcepto_excepcion'
 AUTOR: 		 (admin)
 FECHA:	        12-06-2015 13:02:07
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
	v_id_concepto_excepcion	integer;
			    
BEGIN

    v_nombre_funcion = 'tes.ft_concepto_excepcion_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_conex_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		12-06-2015 13:02:07
	***********************************/

	if(p_transaccion='TES_conex_INS')then
					
        begin
            
           --revisar que no se tengan excepciones dobles para un mismo concepto de gasto
            IF exists( select 1 from   
                                tes.tconcepto_excepcion c 
                                where c.id_concepto_ingas = v_parametros.id_concepto_ingas and
                                 c.estado_reg = 'activo') THEN
                raise exception 'Ya existe una excepción activa para este concepto';
            END IF;
        
        	--Sentencia de la insercion
        	insert into tes.tconcepto_excepcion(
			id_uo,
			estado_reg,
			id_concepto_ingas,
			id_usuario_ai,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_uo,
			'activo',
			v_parametros.id_concepto_ingas,
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			null,
			null
							
			
			
			)RETURNING id_concepto_excepcion into v_id_concepto_excepcion;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Excepciónes almacenado(a) con exito (id_concepto_excepcion'||v_id_concepto_excepcion||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_concepto_excepcion',v_id_concepto_excepcion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_conex_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		12-06-2015 13:02:07
	***********************************/

	elsif(p_transaccion='TES_conex_MOD')then

		begin
        
            --revisar que no se tengan excepciones dobles para un mismo concepto de gasto
            IF exists( select 1 from   
                                tes.tconcepto_excepcion c 
                                where c.id_concepto_ingas = v_parametros.id_concepto_ingas and
                                 c.estado_reg = 'activo' and 
                                 c.id_concepto_excepcion != v_parametros.id_concepto_excepcion) THEN
                raise exception 'Ya existe una excepción activa para este concepto';
            END IF;
            
            
			--Sentencia de la modificacion
			update tes.tconcepto_excepcion set
			id_uo = v_parametros.id_uo,
			id_concepto_ingas = v_parametros.id_concepto_ingas,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_concepto_excepcion=v_parametros.id_concepto_excepcion;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Excepciónes modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_concepto_excepcion',v_parametros.id_concepto_excepcion::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TES_conex_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		12-06-2015 13:02:07
	***********************************/

	elsif(p_transaccion='TES_conex_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from tes.tconcepto_excepcion
            where id_concepto_excepcion=v_parametros.id_concepto_excepcion;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Excepciónes eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_concepto_excepcion',v_parametros.id_concepto_excepcion::varchar);
              
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