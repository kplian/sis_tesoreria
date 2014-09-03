--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.ft_obligacion_det_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.ft_obligacion_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tobligacion_det'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        02-04-2013 20:27:35
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
	v_id_obligacion_det	integer;
    v_tipo_cambio_conv	   numeric;
    v_monto_mb numeric;
    v_tipo_obligacion varchar;
    v_id_moneda integer;
    v_id_partida integer;
    v_id_gestion integer;
      
    
BEGIN

    v_nombre_funcion = 'tes.ft_obligacion_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_OBDET_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		02-04-2013 20:27:35
	***********************************/

	if(p_transaccion='TES_OBDET_INS')then
					
        begin
        
           --calculo monto en moneda base
           
           select
           op.tipo_cambio_conv,
           op.tipo_obligacion,
           op.id_gestion
           into
           v_tipo_cambio_conv,
           v_tipo_obligacion,
           v_id_gestion
           from tes.tobligacion_pago op 
           where op.id_obligacion_pago = v_parametros.id_obligacion_pago;
           
          
          --no se admiten incersiones para pago tipo obligacion
          IF v_tipo_obligacion='adquisiciones' THEN
          
              raise exception 'no se permiten inserciones en pagos de adquisiciones';
          
          END IF;
          
        
        
          --calcula monto en moneda base
           v_monto_mb = v_parametros.monto_pago_mo * v_tipo_cambio_conv;
        
        
          --recueprar la partida de la parametrizacion
          v_id_partida = NULL;
          
          
          raise notice '(''CUECOMP'', %, %, %)',  v_id_gestion, v_parametros.id_concepto_ingas, v_parametros.id_centro_costo;
         
        
          
          SELECT 
              ps_id_partida 
            into 
              v_id_partida 
          FROM conta.f_get_config_relacion_contable('CUECOMP', v_id_gestion, v_parametros.id_concepto_ingas, v_parametros.id_centro_costo);
          
        
           
        
           IF v_id_partida is NULL THEN
          
            raise exception 'no se tiene una parametrizacion de partida  para este concepto de gasto en la relacion contable de código CUECOMP  (%,%,%,%)','CUECOMP', v_id_gestion, v_parametros.id_concepto_ingas, v_parametros.id_centro_costo;
            
           END IF;
         
        
        	--Sentencia de la insercion
        	insert into tes.tobligacion_det(
			estado_reg,
			--id_cuenta,
			id_partida,
			--id_auxiliar,
			id_concepto_ingas,
			monto_pago_mo,
			id_obligacion_pago,
			id_centro_costo,
			monto_pago_mb,
            descripcion,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod,
            id_orden_trabajo
          	) values(
			'activo',
			--v_parametros.id_cuenta,
			v_id_partida,
			--v_parametros.id_auxiliar,
			v_parametros.id_concepto_ingas,
			v_parametros.monto_pago_mo,
			v_parametros.id_obligacion_pago,
			v_parametros.id_centro_costo,
			v_monto_mb,
            v_parametros.descripcion,		
			now(),
			p_id_usuario,
			null,
			null,
            v_parametros.id_orden_trabajo
							
			)RETURNING id_obligacion_det into v_id_obligacion_det;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle almacenado(a) con exito (id_obligacion_det'||v_id_obligacion_det||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_obligacion_det',v_id_obligacion_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_OBDET_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		02-04-2013 20:27:35
	***********************************/

	elsif(p_transaccion='TES_OBDET_MOD')then

		begin
        
           --calculo monto en moneda base
           
           select
           op.tipo_cambio_conv,
           op.id_moneda,
           op.id_gestion
           into
           v_tipo_cambio_conv,
           v_id_moneda,
           v_id_gestion
           from tes.tobligacion_pago op 
           where op.id_obligacion_pago = v_parametros.id_obligacion_pago;
           
           v_monto_mb = v_parametros.monto_pago_mo * v_tipo_cambio_conv;
           
           --recueprar la partida de la parametrizacion
          v_id_partida = NULL;
          
          SELECT 
              ps_id_partida 
            into 
              v_id_partida 
          FROM conta.f_get_config_relacion_contable('CUECOMP', v_id_gestion, v_parametros.id_concepto_ingas, v_parametros.id_centro_costo);
          
        
           
        
           IF v_id_partida is NULL THEN
          
            raise exception 'no se tiene una parametrizacionde partida  para este concepto de gasto en la relacion contable de código CUECOMP  (%,%,%,%)','CUECOMP', v_id_gestion, v_parametros.id_concepto_ingas, v_parametros.id_centro_costo;
            
           END IF;
        
        
			--Sentencia de la modificacion
			update tes.tobligacion_det set
			--id_cuenta = v_parametros.id_cuenta,
			id_partida = v_id_partida,
			--id_auxiliar = v_parametros.id_auxiliar,
			id_concepto_ingas = v_parametros.id_concepto_ingas,
			monto_pago_mo = v_parametros.monto_pago_mo,
			id_obligacion_pago = v_parametros.id_obligacion_pago,
			id_centro_costo = v_parametros.id_centro_costo,
			monto_pago_mb = v_monto_mb,
		    fecha_mod = now(),
            descripcion=v_parametros.descripcion,
			id_usuario_mod = p_id_usuario,
            id_orden_trabajo = v_parametros.id_orden_trabajo
			where id_obligacion_det=v_parametros.id_obligacion_det;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_obligacion_det',v_parametros.id_obligacion_det::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TES_OBDET_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		02-04-2013 20:27:35
	***********************************/

	elsif(p_transaccion='TES_OBDET_ELI')then

		begin
           
        
            delete from tes.tprorrateo p 
            where  p.id_obligacion_det = v_parametros.id_obligacion_det;
            
            --Sentencia de la eliminacion
			delete from tes.tobligacion_det
            where id_obligacion_det=v_parametros.id_obligacion_det;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_obligacion_det',v_parametros.id_obligacion_det::varchar);
              
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