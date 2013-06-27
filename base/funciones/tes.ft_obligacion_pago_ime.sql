--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.ft_obligacion_pago_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Tesoreria
 FUNCION: 		tes.ft_obligacion_pago_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tobligacion_pago'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        02-04-2013 16:01:32
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
	v_id_obligacion_pago	integer;
    
    v_tipo_documento   varchar;
    v_num varchar;
    v_id_periodo integer;
    v_codigo_proceso_macro  varchar;
    v_id_proceso_macro integer;
    v_codigo_tipo_proceso varchar;
    
     v_num_tramite  varchar;
     v_id_proceso_wf integer;
     v_id_estado_wf integer;
     v_codigo_estado varchar;
     v_anho integer;
     v_id_gestion integer;
     v_id_subsistema integer;
     
    va_id_tipo_estado integer[];
    va_codigo_estado varchar[];
    va_disparador varchar[];
    va_regla varchar[];
    va_prioridad  integer[];
    
    v_id_proceso_compra integer;
    v_id_depto integer;
    v_total_detalle numeric;
    v_id_estado_actual  integer;
    v_tipo_obligacion varchar;
    v_id_tipo_estado integer;
    v_id_funcionario integer;
    v_id_usuario_reg integer;
    v_id_estado_wf_ant  integer;
    v_comprometido varchar;
    v_monto_total numeric;
    v_id_obligacion_det integer;
    v_factor numeric;
    
    v_registros    record;
			    
BEGIN

    v_nombre_funcion = 'tes.ft_obligacion_pago_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_OBPG_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		02-04-2013 16:01:32
	***********************************/

	if(p_transaccion='TES_OBPG_INS')then
					
        begin
        
           --determina la fecha del periodo
        
         select id_periodo into v_id_periodo from
                        param.tperiodo per 
                       where per.fecha_ini <= v_parametros.fecha 
                         and per.fecha_fin >=  v_parametros.fecha
                         limit 1 offset 0;
        
        
        IF   v_parametros.tipo_obligacion ='adquisiciones'    THEN
        
              raise exception 'Los pagos de adquisiciones tienen que ser habilitados desde el sistema de adquisiciones';   
        
        
        
        
        ELSIF   v_parametros.tipo_obligacion ='pago_directo'    THEN
              
                v_tipo_documento = 'PGD';
                
                  --obtener correlativo
                 v_num =   param.f_obtener_correlativo(
                          'PGD', 
                           v_id_periodo,-- par_id, 
                           NULL, --id_uo 
                           v_parametros.id_depto,    -- id_depto
                           p_id_usuario, 
                           'TES', 
                           NULL);
                           
        
                v_codigo_proceso_macro = 'TES-PD';          
                           
              
        ELSE
              
              
          raise exception 'falta agregar la funcionalidad'; 
              
        END IF;
       
       
        IF (v_num is NULL or v_num ='') THEN
        
          raise exception 'No se pudo obtener un numero correlativo para la obligación';
        
        END IF;
        
        --obtener id del proceso macro
        
        select 
         pm.id_proceso_macro
        into
         v_id_proceso_macro
        from wf.tproceso_macro pm
        where pm.codigo = v_codigo_proceso_macro;
        
        
        If v_id_proceso_macro is NULL THEN
        
           raise exception 'El proceso macro  de codigo % no esta configurado en el sistema WF',v_codigo_proceso_macro;  
        
        END IF;
        
        --   obtener el codigo del tipo_proceso
       
        select   tp.codigo 
            into v_codigo_tipo_proceso
        from  wf.ttipo_proceso tp 
        where   tp.id_proceso_macro = v_id_proceso_macro
                and tp.estado_reg = 'activo' and tp.inicio = 'si';
            
         
        IF v_codigo_tipo_proceso is NULL THEN
        
           raise exception 'No existe un proceso inicial para el proceso macro indicado % (Revise la configuración)',v_codigo_proceso_macro;
        
        END IF;
        
        
        v_anho = (date_part('year', v_parametros.fecha))::integer;
			
            select 
             ges.id_gestion
             into v_id_gestion
            from param.tgestion ges
            where ges.gestion = v_anho
            limit 1 offset 0;
       
       --id_subsistema
       
       select
       s.id_subsistema
       into 
       v_id_subsistema
       from segu.tsubsistema s where s.codigo = 'ADQ';
    
        
        -- inciar el tramite en el sistema de WF
         SELECT 
               ps_num_tramite ,
               ps_id_proceso_wf ,
               ps_id_estado_wf ,
               ps_codigo_estado 
            into
               v_num_tramite,
               v_id_proceso_wf,
               v_id_estado_wf,
               v_codigo_estado   
                
          FROM wf.f_inicia_tramite(
               p_id_usuario, 
               v_id_gestion, 
               v_codigo_tipo_proceso, 
               NULL,
               v_parametros.id_depto);
            
           
            -- raise exception 'estado %',v_codigo_estado;
             
      
        	--Sentencia de la insercion
        	insert into tes.tobligacion_pago(
			id_proveedor,
			estado,
			tipo_obligacion,
			id_moneda,
			obs,
			porc_retgar,
			id_subsistema,
			id_funcionario,
			estado_reg,
			--porc_anticipo,
			id_estado_wf,
			id_depto,
			num_tramite,
			id_proceso_wf,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod,
            numero,
            fecha,
            id_gestion,
            tipo_cambio_conv,
            pago_variable
          	) values(
			v_parametros.id_proveedor,
			v_codigo_estado,
			v_parametros.tipo_obligacion,
			v_parametros.id_moneda,
			v_parametros.obs,
			v_parametros.porc_retgar,
			v_id_subsistema,
			v_parametros.id_funcionario,
			'activo',
			--v_parametros.porc_anticipo,
			v_id_estado_wf,
			v_parametros.id_depto,
			v_num_tramite,
			v_id_proceso_wf,
			now(),
			p_id_usuario,
			null,
			null,
            v_num,
            v_parametros.fecha,
            v_id_gestion,
            v_parametros.tipo_cambio_conv,
            v_parametros.pago_variable
							
			)RETURNING id_obligacion_pago into v_id_obligacion_pago;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Obligaciones de Pago almacenado(a) con exito (id_obligacion_pago'||v_id_obligacion_pago||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_obligacion_pago',v_id_obligacion_pago::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_OBPG_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		02-04-2013 16:01:32
	***********************************/

	elsif(p_transaccion='TES_OBPG_MOD')then

		begin
			--Sentencia de la modificacion
			update tes.tobligacion_pago set
			id_proveedor = v_parametros.id_proveedor,
		    id_moneda = v_parametros.id_moneda,
            tipo_cambio_conv=v_parametros.tipo_cambio_conv,
			obs = v_parametros.obs,
			porc_retgar = v_parametros.porc_retgar,
		    id_funcionario = v_parametros.id_funcionario,
			--porc_anticipo = v_parametros.porc_anticipo,
		    id_depto = v_parametros.id_depto,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
            pago_variable=v_parametros.pago_variable
			where id_obligacion_pago=v_parametros.id_obligacion_pago;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Obligaciones de Pago modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_obligacion_pago',v_parametros.id_obligacion_pago::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TES_OBPG_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		02-04-2013 16:01:32
	***********************************/

	elsif(p_transaccion='TES_OBPG_ELI')then

		begin
        
            -- obtiene datos de la obligacion
           
                select
                  op.estado,
                  op.id_proceso_wf,
                  op.id_obligacion_pago,
                  op.id_depto,
                  op.id_estado_wf
                into v_registros  
                 from  tes.tobligacion_pago op 
                 where  op.id_obligacion_pago = v_parametros.id_obligacion_pago;
                 
                 
                IF v_registros.estado!='borrador'  THEN
                
                   raise exception 'Solo se pueden anular obligaciones en estado borrador';
                
                END IF; 
            
               --recuperamos el id_tipo_proceso en el WF para el estado anulado
               --ya que este es un estado especial que no tiene padres definidos
               
               
               select 
               	te.id_tipo_estado
               into
               	v_id_tipo_estado
               from wf.tproceso_wf pw 
               inner join wf.ttipo_proceso tp on pw.id_tipo_proceso = tp.id_tipo_proceso
               inner join wf.ttipo_estado te on te.id_tipo_proceso = tp.id_tipo_proceso and te.codigo = 'anulado'               
               where pw.id_proceso_wf = v_registros.id_proceso_wf;
               
               
               IF v_id_tipo_estado is NULL THEN
               
                  raise exception 'El estado anulado para la obligacion de pago no esta parametrizado en el workflow';  
               
               END IF;
              
              
               -- pasamos la obligacion al estado anulado
               
               
           
               v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado, 
                                                           NULL, 
                                                           v_registros.id_estado_wf, 
                                                           v_registros.id_proceso_wf,
                                                           p_id_usuario,
                                                           v_registros.id_depto,
                                                           'Obligacion de Pago Anulada');
            
            
               -- actualiza estado en la cotizacion
              
               update tes.tobligacion_pago  op set 
                 id_estado_wf =  v_id_estado_actual,
                 estado = 'anulado',
                 id_usuario_mod=p_id_usuario,
                 fecha_mod=now(),
                 estado_reg='inactivo'
               where op.id_obligacion_pago  = v_parametros.id_obligacion_pago;
               
               
               --inactiva el datalle de la solicitud
               update tes.tobligacion_det od set  
                estado_reg= 'inactivo'
               where  od.id_obligacion_pago = v_parametros.id_obligacion_pago;
               
               
               ----------------------------------------------------------------
               ---si esta integrado con adquisiciones libera la cotizacion ----
               -----------------------------------------------------------------
                
                IF  exists (select 1 
                            from adq.tcotizacion cot 
                            where cot.id_obligacion_pago = v_parametros.id_obligacion_pago)  THEN
                
                     
                         -- retroceder el estado de la cotizacion
                        
                          Select     
                          c.id_cotizacion,
                          c.id_proceso_wf,
                          c.id_estado_wf,
                          c.estado
                          into
                          v_registros
                          
                          from adq.tcotizacion c 
                          where c.id_obligacion_pago = v_parametros.id_obligacion_pago;   
                              
                         --recuperaq estado anterior segun Log del WF
                          
                            SELECT  
                               ps_id_tipo_estado,
                               ps_id_funcionario,
                               ps_id_usuario_reg,
                               ps_id_depto,
                               ps_codigo_estado,
                               ps_id_estado_wf_ant
                            into
                               v_id_tipo_estado,
                               v_id_funcionario,
                               v_id_usuario_reg,
                               v_id_depto,
                               v_codigo_estado,
                               v_id_estado_wf_ant 
                            FROM wf.f_obtener_estado_ant_log_wf(v_registros.id_estado_wf);
                                                   
                
                          
                          
                          -- registra nuevo estado
                          
                          v_id_estado_actual = wf.f_registra_estado_wf(
                              v_id_tipo_estado, 
                              v_id_funcionario, 
                              v_registros.id_estado_wf, 
                              v_registros.id_proceso_wf, 
                              p_id_usuario,
                              v_id_depto,
                              'El estado  retrocede por anulacion de la obligacion en tesoreria');
                          
                        
                          
                            -- actualiza estado en la solicitud
                            update adq.tcotizacion  s set 
                               id_estado_wf =  v_id_estado_actual,
                               estado = v_codigo_estado,
                               id_usuario_mod=p_id_usuario,
                               fecha_mod=now(),
                               id_obligacion_pago = NULL
                             where id_cotizacion = v_registros.id_cotizacion;    
                    
                    --romper relacion con obligacion det
                           update adq.tcotizacion_det  s set 
                                   id_obligacion_det = NULL
                             where id_cotizacion = v_registros.id_cotizacion; 
                
                  v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Obligaciones de Pago eliminado(a), y cotizacion retrocedida'); 
                
                ELSE
                  v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Obligaciones de Pago eliminado(a)'); 
                END IF; 
              
            --Definicion de la respuesta
          
            v_resp = pxp.f_agrega_clave(v_resp,'id_obligacion_pago',v_parametros.id_obligacion_pago::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
      
    /*********************************    
 	#TRANSACCION:  'TES_FINREG_IME'
 	#DESCRIPCION:	Finaliza el registro de obligacion de pago
 	#AUTOR:	    Rensi Arteaga Copari
 	#FECHA:		02-04-2013 16:01:32
	***********************************/

	elsif(p_transaccion='TES_FINREG_IME')then

		begin
        
             --recupera parametros
			
             select 
              op.id_proceso_wf,
              op.id_estado_wf,
              op.estado,
              op.id_depto,
              op.tipo_obligacion
              
             into
              v_id_proceso_wf,
              v_id_estado_wf,
              v_codigo_estado,
              v_id_depto,
              v_tipo_obligacion
             from tes.tobligacion_pago op
             where op.id_obligacion_pago = v_parametros.id_obligacion_pago; 
             
             --VALIDACIONES
             
             IF  v_codigo_estado NOT in  ('borrador','en_pago') THEN
               raise exception 'Solo se admiten obligaciones  en borrador o en pago';
             END IF;
			
            
            IF  v_codigo_estado = 'borrador' THEN
        
             --validamos que el detalle tenga por lo menos un item con valor
             
                   select 
                    sum(od.monto_pago_mo)
                   into
                    v_total_detalle
                   from tes.tobligacion_det od
                   where od.id_obligacion_pago = v_parametros.id_obligacion_pago and od.estado_reg ='activo'; 
                   
                   IF v_total_detalle = 0 or v_total_detalle is null THEN
                   
                       raise exception 'No existe el detalle de obligacion...';
                   
                   END IF; 
                   
            
                  ------------------------------------------------------------
                  --calcula el factor de prorrateo de la obligacion  detalle
                  -----------------------------------------------------------
                  
                  update tes.tobligacion_det set
                  factor_porcentual = (monto_pago_mo/v_total_detalle)
                  where estado_reg = 'activo' and id_obligacion_pago=v_parametros.id_obligacion_pago;
                  
                  --testeo
                  select sum(od.factor_porcentual) into v_factor
                  from tes.tobligacion_det od
                  where od.id_obligacion_pago = v_parametros.id_obligacion_pago and od.estado_reg='activo';
                  
                  
                  v_factor = v_factor - 1;
                  
                  
                  select od.id_obligacion_det into v_id_obligacion_det
                  from tes.tobligacion_det od
                  where od.id_obligacion_pago = v_parametros.id_obligacion_pago
                  and od.estado_reg = 'activo'
                  limit 1 offset 0; 
                  
                  
                  --actualiza el factor del primer registro  para que la suma de siempre 1
                  update tes.tobligacion_det  set
                  factor_porcentual=  factor_porcentual - v_factor
                  where estado_reg = 'activo'
                  and id_obligacion_det= v_id_obligacion_det;
                  
                
            
            
            
            
            
            
             ELSEIF  v_codigo_estado = 'en_pago' THEN
              
             
                --  validar que el total del detalle de obligacion
                --  este pagado y no se tengan pendientes
               
               
                --  si tiene relacionado una cotizacion llama a la funcion de finalizar cotizacion              
                
               
             raise exception 'Falta las valiaciones';
             
             
             
             END IF;
             
             
              
             -- obtiene el siguiente estado del flujo 
             SELECT 
                 *
              into
                va_id_tipo_estado,
                va_codigo_estado,
                va_disparador,
                va_regla,
                va_prioridad
            
            FROM wf.f_obtener_estado_wf(v_id_proceso_wf, v_id_estado_wf,NULL,'siguiente');
            
            
            --raise exception '--  % ,  % ,% ',v_id_proceso_wf,v_id_estado_wf,va_codigo_estado;
            
            
            IF va_codigo_estado[2] is not null THEN
            
             raise exception 'El proceso de WF esta mal parametrizado, el estado borrador de la obligacion solo admite un estado ';
            
            END IF;
            
             IF va_codigo_estado[1] is  null THEN
            
             raise exception 'El proceso de WF esta mal parametrizado, no se encuentra el estado siguiente ';
            
            END IF;
            
            
          
            
            -- hay que recuperar  el estado inmediato,...
             v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado[1], 
                                                           NULL, 
                                                           v_id_estado_wf, 
                                                           v_id_proceso_wf,
                                                           p_id_usuario,
                                                           v_id_depto);
            
            
           
            IF  va_codigo_estado[1] = 'registrado'  and v_tipo_obligacion != 'adquisiciones' THEN
            
               -- verficar presupuesto y comprometer
               IF not tes.f_gestionar_presupuesto_tesoreria(v_parametros.id_obligacion_pago, p_id_usuario, 'comprometer')  THEN
                   
                     raise exception 'Error al comprometer el presupeusto';
                   
               END IF;
           
           END IF;
            
            
            
             -- actualiza estado en la solicitud
            
             update tes.tobligacion_pago  set 
               id_estado_wf =  v_id_estado_actual,
               estado = va_codigo_estado[1],
               id_usuario_mod=p_id_usuario,
               comprometido = 'si',
               total_pago=v_total_detalle,
               fecha_mod=now()
             where id_obligacion_pago  = v_parametros.id_obligacion_pago;
        
        
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Obligacion de pago fin de registro'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_obligacion_pago',v_parametros.id_obligacion_pago::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
     
    /*********************************    
 	#TRANSACCION:  'TES_ANTEOB_IME'
 	#DESCRIPCION:	Retrocede estado de la obligacion
 	#AUTOR:	        Rensi Arteaga Copari
 	#FECHA:		02-04-2013 16:01:32
	***********************************/

	elsif(p_transaccion='TES_ANTEOB_IME')then

		begin
        
        --recupera parametros
            select 
            op.id_estado_wf,
            op.id_proceso_wf,
            op.estado,
            op.comprometido,
            op.tipo_obligacion
            into
            v_id_estado_wf,
            v_id_proceso_wf,
            v_codigo_estado,
            v_comprometido,
            v_tipo_obligacion
            
            from tes.tobligacion_pago op
            where op.id_obligacion_pago = v_parametros.id_obligacion_pago; 
            
        
        
        --------------------------------------------------
        --REtrocede al estado inmediatamente anterior
        -------------------------------------------------
         IF  v_parametros.operacion = 'cambiar' THEN
                     
                       --validaciones
                       
                       IF v_codigo_estado= 'en_pago' THEN
                       --verificar que no tenga plnes de pago
                       
                         IF  EXISTS(select 1
                         from tes.tplan_pago pp
                         where pp.id_obligacion_pago = v_parametros.id_obligacion_pago
                               and pp.estado_reg='activo') THEN
                       
                            raise exception 'Para retroceder no debe tener planes de pago activos';
                          
                         END IF;
                       
                       
                       END IF;      
         
         
              
                      --recuperaq estado anterior segun Log del WF
                      
                        SELECT  
                           ps_id_tipo_estado,
                           ps_id_funcionario,
                           ps_id_usuario_reg,
                           ps_id_depto,
                           ps_codigo_estado,
                           ps_id_estado_wf_ant
                        into
                           v_id_tipo_estado,
                           v_id_funcionario,
                           v_id_usuario_reg,
                           v_id_depto,
                           v_codigo_estado,
                           v_id_estado_wf_ant 
                        FROM wf.f_obtener_estado_ant_log_wf(v_id_estado_wf);
                        
                        
                      -- recupera el proceso_wf
                      
                      select 
                           ew.id_proceso_wf 
                        into 
                           v_id_proceso_wf
                      from wf.testado_wf ew
                      where ew.id_estado_wf= v_id_estado_wf_ant;
                      
                      
                      -- registra nuevo estado
                      
                      v_id_estado_actual = wf.f_registra_estado_wf(
                          v_id_tipo_estado, 
                          v_id_funcionario, 
                          v_id_estado_wf, 
                          v_id_proceso_wf, 
                          p_id_usuario,
                          v_id_depto);
                      
                    
                      
                      -- actualiza estado en la obligacion
                        update tes.tobligacion_pago  op set 
                           id_estado_wf =  v_id_estado_actual,
                           estado = v_codigo_estado,
                           id_usuario_mod=p_id_usuario,
                           fecha_mod=now()
                         where id_obligacion_pago = v_parametros.id_obligacion_pago;
                         
                        
                        -- cuando el estado al que regresa es  y no viene de adquisiciones se revierte el repsupuesto
                         IF v_codigo_estado = 'borrador'  and v_tipo_obligacion !='adquisiciones' THEN
                         
                           --se revierte el presupeusto
                           IF not tes.f_gestionar_presupuesto_tesoreria(v_parametros.id_obligacion_pago, p_id_usuario, 'revertir')  THEN
                               
                                 raise exception 'Error al revertir el presupeusto';
                               
                           END IF;
                          
                          
                          
                          --se modifica la bandera del comprometido
                          update tes.tobligacion_pago op set
                            comprometido = 'no'
                          where id_obligacion_pago = v_parametros.id_obligacion_pago;                         
                         
                         END IF;
                         
                         
                          IF v_codigo_estado = 'borrador' THEN
                          
                              --se modifica la bandera del comprometido
                              update tes.tobligacion_pago op set
                                 total_pago=NULL
                              where id_obligacion_pago = v_parametros.id_obligacion_pago; 
                         
                          END IF;
                        -- si hay mas de un estado disponible  preguntamos al usuario
                        v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado)'); 
                        v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');
                        
                              
                      --Devuelve la respuesta
                        return v_resp;
                        
        
         
         
           ELSEIF  v_parametros.operacion = 'inicio' THEN
        			 
                   raise exception 'Operacion no implementada';
            
           ELSE
              
                   raise exception 'Operacion no implementada';   
           END IF; 
      
        
        
        
			
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Retrocede estado de la obligacion'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_obligacion_pago',v_parametros.id_obligacion_pago::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
    /*********************************    
 	#TRANSACCION:  'TES_PAFPP_IME'
 	#DESCRIPCION:	Calcula el restante por registrar, devengar o pagar  segun filtro
 	#AUTOR:		admin	
 	#FECHA:		10-04-2013 15:43:23
	***********************************/

	elsif(p_transaccion='TES_PAFPP_IME')then

		begin
			
            v_monto_total= tes.f_determinar_total_faltante(v_parametros.id_obligacion_pago, v_parametros.ope_filtro, v_parametros.id_plan_pago);
            
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','determina cuanto falta por pgar'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_obligacion_pago',v_parametros.id_obligacion_pago::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'monto_total_faltante',v_monto_total::varchar);
              
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