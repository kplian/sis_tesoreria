--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.ft_solicitud_rendicion_det_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Obligaciones de Pago
 FUNCION: 		tes.ft_solicitud_rendicion_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tsolicitud_rendicion_det'
 AUTOR: 		 (gsarmiento)
 FECHA:	        16-12-2015 15:14:01
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
	v_id_solicitud_rendicion_det	integer;
    v_id_documento_respaldo	integer;
    v_solicitud_efectivo	record;
    v_id_solicitud_efectivo_rend	integer;
    v_total_rendiciones		numeric;
    v_tipo					varchar;
    v_id_proceso_caja		integer;
    
			    
BEGIN

    v_nombre_funcion = 'tes.ft_solicitud_rendicion_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_REND_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		16-12-2015 15:14:01
	***********************************/

	if(p_transaccion='TES_REND_INS')then
					
        begin
             
             select sol.id_solicitud_efectivo into v_id_solicitud_efectivo_rend 
             from tes.tsolicitud_efectivo sol
             inner join tes.ttipo_solicitud tp on tp.id_tipo_solicitud=sol.id_tipo_solicitud
             where sol.id_solicitud_efectivo_fk= v_parametros.id_solicitud_efectivo_fk
             and sol.estado='borrador' and tp.codigo='RENEFE';
             
             IF v_id_solicitud_efectivo_rend is null THEN
               
               select id_caja, id_funcionario into v_solicitud_efectivo
               from tes.tsolicitud_efectivo
               where id_solicitud_efectivo=v_parametros.id_solicitud_efectivo_fk;

               v_resp = tes.f_inserta_solicitud_efectivo(p_administrador, p_id_usuario,hstore(v_parametros)||hstore(v_solicitud_efectivo));
             
               v_id_solicitud_efectivo_rend = v_resp;

             END IF;

        	--Sentencia de la insercion
        	insert into tes.tsolicitud_rendicion_det(
			id_solicitud_efectivo,
			id_documento_respaldo,
			estado_reg,
			monto,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_id_solicitud_efectivo_rend,
			v_parametros.id_documento_respaldo,
			'activo',
			v_parametros.monto,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null
			)RETURNING id_solicitud_rendicion_det into v_id_solicitud_rendicion_det;
            
            UPDATE conta.tdoc_compra_venta
            SET tabla_origen='tes.ft_solicitud_rendicion_det',
            id_origen=v_id_solicitud_rendicion_det
            WHERE id_doc_compra_venta=v_parametros.id_documento_respaldo;
			            
            select sum(rend.monto) into v_total_rendiciones
            from tes.tsolicitud_rendicion_det rend
            where rend.id_solicitud_efectivo=v_id_solicitud_efectivo_rend;
             
            UPDATE tes.tsolicitud_efectivo
            SET monto=v_total_rendiciones
            WHERE id_solicitud_efectivo=v_id_solicitud_efectivo_rend;
            
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Rendicion almacenado(a) con exito (id_solicitud_rendicion_det'||v_id_solicitud_rendicion_det||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud_rendicion_det',v_id_solicitud_rendicion_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_REND_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		16-12-2015 15:14:01
	***********************************/

	elsif(p_transaccion='TES_REND_MOD')then

		begin
			--Sentencia de la modificacion
			update tes.tsolicitud_rendicion_det set
			--id_solicitud_efectivo = v_parametros.id_solicitud_efectivo,
			--id_documento_respaldo = v_parametros.id_documento_respaldo,
			monto = v_parametros.monto,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_documento_respaldo=v_parametros.id_documento_respaldo;
            
            select id_solicitud_efectivo into v_id_solicitud_efectivo_rend
            from tes.tsolicitud_rendicion_det
            where id_documento_respaldo=v_parametros.id_documento_respaldo;
            
            UPDATE tes.tsolicitud_efectivo
            SET monto=(select sum(monto)
              		   from tes.tsolicitud_rendicion_det
            		   where id_solicitud_efectivo=v_id_solicitud_efectivo_rend)
            WHERE id_solicitud_efectivo=v_id_solicitud_efectivo_rend;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Rendicion modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_documento_respaldo',v_parametros.id_documento_respaldo::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TES_REND_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		gsarmiento	
 	#FECHA:		16-12-2015 15:14:01
	***********************************/

	elsif(p_transaccion='TES_REND_ELI')then

		begin
			--Sentencia de la eliminacion
            select id_documento_respaldo into v_id_documento_respaldo
            from tes.tsolicitud_rendicion_det
            where id_solicitud_rendicion_det=v_parametros.id_solicitud_rendicion_det;
            
			delete from tes.tsolicitud_rendicion_det
            where id_solicitud_rendicion_det=v_parametros.id_solicitud_rendicion_det;
            
            delete from conta.tdoc_compra_venta
            where id_doc_compra_venta=v_id_documento_respaldo;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Rendicion eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud_rendicion_det',v_parametros.id_solicitud_rendicion_det::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
        
    elsif(p_transaccion='TES_RENDEVFAC_IME')then
    	begin
        	--recuperamos el id de la solicitud de efectivo             
        	 select sol.id_caja, sol.id_funcionario, ren.monto, 
             sol.id_solicitud_efectivo_fk as id_solicitud_efectivo_fk, 
             sol.id_solicitud_efectivo as id_solicitud_efectivo_rendicion
             into v_solicitud_efectivo
             from tes.tsolicitud_efectivo sol
             inner join tes.tsolicitud_rendicion_det ren on ren.id_solicitud_efectivo=sol.id_solicitud_efectivo
             where ren.id_solicitud_rendicion_det=v_parametros.id_solicitud_rendicion_det;
                 
             select sol.id_solicitud_efectivo into v_id_solicitud_efectivo_rend 
             from tes.tsolicitud_efectivo sol
             inner join tes.ttipo_solicitud tp on tp.id_tipo_solicitud=sol.id_tipo_solicitud
             where sol.id_solicitud_efectivo_fk= v_solicitud_efectivo.id_solicitud_efectivo_fk
             and sol.estado='borrador' and tp.codigo='RENEFE';
             
             --verificamos si existe alguna rendicion activa
             IF v_id_solicitud_efectivo_rend is null THEN
               
               v_resp = tes.f_inserta_solicitud_efectivo(p_administrador, p_id_usuario,hstore(v_parametros)||hstore(v_solicitud_efectivo));
             
               v_id_solicitud_efectivo_rend = v_resp;

             END IF;
             
             UPDATE tes.tsolicitud_rendicion_det
             SET id_solicitud_efectivo=v_id_solicitud_efectivo_rend
             WHERE id_solicitud_rendicion_det=v_parametros.id_solicitud_rendicion_det;

             --actualizamos el monto total de la rendicion actual
             select sum(rend.monto) into v_total_rendiciones
             from tes.tsolicitud_rendicion_det rend
             where rend.id_solicitud_efectivo=v_solicitud_efectivo.id_solicitud_efectivo_rendicion;
             
             UPDATE tes.tsolicitud_efectivo
             SET monto=COALESCE(v_total_rendiciones,0)
             WHERE id_solicitud_efectivo=v_solicitud_efectivo.id_solicitud_efectivo_rendicion;
             
             --actualizamos el monto total de la nueva rendicion
             select sum(rend.monto) into v_total_rendiciones
             from tes.tsolicitud_rendicion_det rend
             where rend.id_solicitud_efectivo=v_id_solicitud_efectivo_rend;
             
             UPDATE tes.tsolicitud_efectivo
             SET monto=COALESCE(v_total_rendiciones,0)
             WHERE id_solicitud_efectivo=v_id_solicitud_efectivo_rend;             
             
             --Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Rendicion Factura devuelta a la solicitud de efectivo con exito (id_solicitud_rendicion_det'||v_id_solicitud_rendicion_det||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud_rendicion_det',v_id_solicitud_rendicion_det::varchar);

            --Devuelve la respuesta
            return v_resp;
             
        end;         
        
    elsif(p_transaccion='TES_RENEXCFAC_IME')then
    	begin
        	--recuperamos el id de la solicitud de efectivo             
        	 SELECT pc.tipo, pc.id_proceso_caja into v_tipo, v_id_proceso_caja
             FROM tes.tsolicitud_rendicion_det ren
             INNER JOIN tes.tproceso_caja pc on pc.id_proceso_caja=ren.id_proceso_caja
             WHERE ren.id_solicitud_rendicion_det=v_parametros.id_solicitud_rendicion_det;
             
             IF v_tipo IS NULL THEN
             	raise exception 'No existe una factura seleccionada';
             END IF;
             
             UPDATE tes.tsolicitud_rendicion_det
             SET id_proceso_caja = NULL
             WHERE id_solicitud_rendicion_det=v_parametros.id_solicitud_rendicion_det;
             
             IF v_tipo in ('RENYREP','RENYCER') THEN                 
             	--actualizamos el monto reposicion
                UPDATE tes.tproceso_caja
                SET monto_reposicion = (SELECT sum(monto) FROM tes.tsolicitud_rendicion_det WHERE id_proceso_caja=v_id_proceso_caja) 
                WHERE id_proceso_caja=v_id_proceso_caja;
             END IF;
                                       
             --Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Rendicion Factura devuelta a la solicitud de efectivo con exito (id_solicitud_rendicion_det'||v_id_solicitud_rendicion_det||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud_rendicion_det',v_id_solicitud_rendicion_det::varchar);

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