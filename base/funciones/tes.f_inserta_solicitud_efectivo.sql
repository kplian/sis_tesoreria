CREATE OR REPLACE FUNCTION tes.f_inserta_solicitud_efectivo (
  p_administrador integer,
  p_id_usuario integer,
  p_hstore public.hstore,
  p_id_cuenta_doc integer = NULL::integer
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:       Obligaciones de Pago
 FUNCION:       tes.f_inserta_solicitud_efectivo
 DESCRIPCION:   Inserta registro de solicitud efectivo
 AUTOR:         Gonzalo Sarmiento 
 FECHA:         10-02-2015
 COMENTARIOS:   
***************************************************************************
    

    HISTORIAL DE MODIFICACIONES:
    
 ISSUE            FECHA:              AUTOR                 DESCRIPCION
   
 #0              10-02-2015        Gonzalo Sarmiento       creacion de la funcion
 #0              30/11/2017        Rensi Arteaga           Ingreso de pasos por caja provinientes de cuenta documentada y viaticos
 #146 IC         04/12/2017        RAC                     COnsiderar ingresos de efectivo en caja
***************************************************************************/

DECLARE
    
    v_id_solicitud_efectivo integer;
    v_codigo_tabla          varchar;
    v_num_sol_efe           varchar;
    v_id_gestion            integer;
    v_codigo_tipo_proceso   varchar;
    v_num_tramite           varchar;
    v_id_proceso_wf         integer;
    v_id_estado_wf          integer;
    v_codigo_estado         varchar;
    v_motivo                varchar;
    v_tipo                  varchar;
    v_id_tipo_solicitud     integer;
    v_id_solicitud_efectivo_fk  integer;
    v_nombre_funcion        varchar;
    v_resp                  varchar;
    v_codigo_proceso_llave_wf   varchar;
    v_saldo_caja            numeric;
    v_id_cajero             integer;
    v_importe_maximo_solicitud  numeric;
    v_estado                varchar;
    v_monto_rendicion       numeric;
    v_reg_cd                record;
    v_id_tipo_estado        integer;
    v_id_estado_actual      integer;
    v_id_funcionario_cajero     integer;
    v_reg_sol_efe               record;
    v_id_funcionario_sol        integer;
    v_id_fun_wf                 integer;
    v_ingreso_extra             varchar;
    v_rec_se                    record;
    v_cod_proc                  varchar;
    v_codigo_caja           varchar;
    v_reg_caja              record;
    v_id_caja               integer;
BEGIN
            v_nombre_funcion = 'tes.f_inserta_solicitud_efectivo';

            /*
            HSTORE  PARAMETERS
                    (p_hstore->'id_caja')::integer
                    (p_hstore->'monto')::numeric
                    (p_hstore->'id_funcionario')::integer
                    (p_hstore->'tipo')::varchar,
                    (p_hstore->'fecha')::date,
                    (p_hstore->'motivo')::varchar,
                    (p_hstore->'id_solicitud_efectivo_fk')::integer                                
            */
            v_ingreso_extra = 'no'; --valor por defecto  

            select pv.codigo into v_codigo_tabla
            from tes.tcaja pv
            where pv.id_caja = (p_hstore->'id_caja')::integer;
            
            ------------------------------------------------------------------------------
            --  RENDICION DE EFECTIVO
            ---------------------------------------------------------------------------  

            IF (p_hstore->'tipo_solicitud')::varchar = 'rendicion' THEN
                
                v_tipo = 'RENEFE';
                
            
            ------------------------------------------------------------------------------
            --  CASO DE QUE EXISTAN DEVOLUCIONES DE DINERO DEL SOLICITANTE AL CAJERO
            ---------------------------------------------------------------------------    
                
            ELSIF (p_hstore->'tipo_solicitud')::varchar = 'devolucion' THEN
                
                v_tipo = 'DEVEFE';

                select sol.estado, sol.monto into v_estado, v_monto_rendicion
                from tes.tsolicitud_efectivo sol
                where sol.id_solicitud_efectivo_fk=(p_hstore->'id_solicitud_efectivo_fk')::integer;

                IF v_monto_rendicion > 0.00 AND v_estado not in ('rendido') THEN
                    raise exception 'No puede realizar una devolucion mientras tenga rendiciones pendientes';
                END IF;
                
            ---------------------------------------------------------------------------------
            --  CASO DE QUE EXISTAN REPSOICION DE DINERO, ELC AJERO RETORNA AL SOLICITANTE
            -------------------------------------------------------------------------------        

            ELSIF (p_hstore->'tipo_solicitud')::varchar = 'reposicion' THEN
                v_tipo = 'REPEFE';
            ---------------------------------------------
            --  SOLICTUD DE EFECTIVO EN CAJA
            ---------------------------------------------
            ELSIF (p_hstore->'tipo_solicitud')::varchar = 'solicitud' THEN
              
            
                v_tipo='SOLEFE';

                v_saldo_caja = tes.f_calcular_saldo_caja((p_hstore->'id_caja')::integer);

                IF v_saldo_caja < (p_hstore->'monto')::numeric THEN
                    raise exception 'El monto que esta intentando solicitar excede el saldo de la caja';
                END IF;

                select importe_maximo_item into v_importe_maximo_solicitud
                from tes.tcaja
                where id_caja=(p_hstore->'id_caja')::integer;

                IF v_importe_maximo_solicitud < (p_hstore->'monto')::numeric THEN
                    raise exception 'El monto que esta intentando solicitar excede el importe maximo de gasto';
                END IF;

            ELSIF (p_hstore->'tipo_solicitud')::varchar = 'apertura_caja' THEN
                v_tipo = 'APECAJ';
            ELSIF (p_hstore->'tipo_solicitud')::varchar = 'ingreso' THEN    --RAC 04/12/2017 se cambia el codigo de ingreso_caja -> ingreso, puede dar problemas en los procesos de reposicion OJO
                v_tipo = 'INGEFE';
                v_ingreso_extra = 'si';
            
            ELSIF (p_hstore->'tipo_solicitud')::varchar = 'ingreso_caja' THEN    --RAC 04/12/2017 se cambia el codigo de ingreso_caja -> ingreso, puede dar problemas en los procesos de reposicion OJO
                v_tipo = 'INGEFE'; 
                v_ingreso_extra = 'no';   
                
                
            ELSIF (p_hstore->'tipo_solicitud')::varchar = 'salida_caja' THEN
                v_tipo='SALEFE';
            ELSE
                 raise exception 'Tipo de solicitud =  % , no definido', (p_hstore->'tipo_solicitud')::varchar;
            END IF;
            
            

            IF v_tipo IN ('SOLEFE','APECAJ','INGEFE','SALEFE') THEN
             
                  -- obtener correlativo
                  v_num_sol_efe =  param.f_obtener_correlativo(
                       v_tipo,
                       NULL,-- par_id,
                       NULL, --id_uo
                       NULL,    -- id_depto
                       p_id_usuario,
                       'TES',
                       NULL,
                       0,
                       0,
                       'tes.tcaja',
                       (p_hstore->'id_caja')::integer,
                       v_codigo_tabla
                       );
                       
                  --fin obtener correlativo
                  
                IF (v_num_sol_efe is NULL or v_num_sol_efe ='') THEN
                   raise exception 'No se pudo obtener un numero correlativo para la solicitud efectivo caja consulte con el administrador';
                END IF;
              
            ELSE

                select 
                      sol.nro_tramite, 
                      cajero.id_funcionario ,
                      sol.id_funcionario
                  into 
                       v_num_sol_efe, 
                       v_id_cajero,
                       v_id_funcionario_sol
                from tes.tsolicitud_efectivo sol
                inner join tes.tcajero cajero on cajero.id_caja=sol.id_caja and cajero.estado='activo'
                where sol.id_solicitud_efectivo = (p_hstore->'id_solicitud_efectivo_fk')::integer;

            END IF;

            select tp.codigo, t.id_tipo_solicitud into v_codigo_tipo_proceso, v_id_tipo_solicitud
            from tes.ttipo_solicitud t
            inner join wf.ttipo_proceso tp on tp.codigo_llave=t.codigo_proceso_llave_wf
            where t.codigo=v_tipo;
            
            IF v_codigo_tipo_proceso is null THEN
              raise exception 'No se encontro el codigo de proceso wf llave para %',v_tipo;
            END IF;

            select
             ges.id_gestion
            into
              v_id_gestion
            from param.tgestion ges
            where ges.gestion = (date_part('year', current_date))::integer
            limit 1 offset 0;
            
            
            IF v_num_sol_efe is null THEN
               raise exception 'No se encontro un número de solicitud para % (%)',v_tipo, (p_hstore->'id_solicitud_efectivo_fk')::integer;
            END IF;
            
            
            --RAC, 29/11/2017, si la solictud no vienete de cuenta docuemntada genera un nuevo tramite
            IF p_id_cuenta_doc is  null  THEN
            
                -- TODO 30/11/2017, unir  procesos derivados, derivaciones, rendiciones, devolcuiones etc
            
                IF (p_hstore->'tipo_solicitud')::varchar  not in ('devolucion', 'reposicion','rendicion') THEN
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
                             NULL,
                             NULL,
                             v_id_gestion,
                             v_codigo_tipo_proceso,
                             v_id_cajero,--id_funcionario
                             --v_parametros.id_depto,
                             NULL,
                             'Fondo Rotativo ('||COALESCE(v_num_sol_efe,'')||') '::varchar,
                             COALESCE(v_num_sol_efe,'') );
                ELSE
                
                    -- RAISE exception 'xxxx  %', v_codigo_tipo_proceso;
                    IF (p_hstore->'tipo_solicitud')::varchar  not in ('rendicion') THEN
                       v_id_fun_wf = v_id_funcionario_sol;
                    ELSE
                       v_id_fun_wf = v_id_cajero;
                    END IF; 
                    
                    
                
                     --recuperamos datos de la solictud de efectivo
                    select 
                      sol.id_estado_wf,
                      sol.id_proceso_wf,
                      sol.nro_tramite
                    into 
                      v_reg_sol_efe
                    from tes.tsolicitud_efectivo sol
                    where sol.id_solicitud_efectivo=(p_hstore->'id_solicitud_efectivo_fk')::integer;
                    
                    SELECT
                             ps_id_proceso_wf,ps_id_estado_wf, ps_codigo_estado, ps_nro_tramite
                       into
                             v_id_proceso_wf,v_id_estado_wf,v_codigo_estado, v_num_tramite
                    FROM wf.f_registra_proceso_disparado_wf(
                                p_id_usuario,
                                NULL,--._id_usuario_ai,
                                NULL,--v_parametros._nombre_usuario_ai,
                                v_reg_sol_efe.id_estado_wf, 
                                v_id_fun_wf,  --id_funcionario wf
                                NULL, --id_depto
                                'Fondo Rotativo ('||COALESCE(v_num_sol_efe,'')||') '::varchar,
                                v_codigo_tipo_proceso,
                                v_reg_sol_efe.nro_tramite);
                   
                
                END IF;
                       
            ELSEIF   p_id_cuenta_doc is not  null  and (p_hstore->'tipo_solicitud')::varchar in ('solicitud','ingreso') THEN
            
                   --29/11/2017 viene de viaticos o cuenta docuemnta, rescatamo el nro de tramite y datos del proceso disparador
                
                    --recuperar datos de viaticos
                     select 
                       cdo.id_proceso_wf,
                       cdo.id_estado_wf,
                       cdo.nro_tramite,
                       cdo.id_funcionario
                      into 
                       v_reg_cd
                     from cd.tcuenta_doc cdo
                     where cdo.id_cuenta_doc = p_id_cuenta_doc;
                    
                     IF v_reg_cd is null THEN
                       raise exception 'Nose encontro la cuenta documentada dolicitada ID: %',p_id_cuenta_doc;
                     END IF;
                     
                    IF (p_hstore->'tipo_solicitud')::varchar in ('solicitud') THEN
                        v_cod_proc = 'SOLEFE';
                    ELSE
                       v_cod_proc = 'INGEFE';
                    END IF;
                    
                    SELECT
                             ps_id_proceso_wf,ps_id_estado_wf, ps_codigo_estado, ps_nro_tramite
                       into
                             v_id_proceso_wf,v_id_estado_wf,v_codigo_estado, v_num_tramite
                    FROM wf.f_registra_proceso_disparado_wf(
                                p_id_usuario,
                                NULL,--._id_usuario_ai,
                                NULL,--v_parametros._nombre_usuario_ai,
                                v_reg_cd.id_estado_wf, 
                                v_reg_cd.id_funcionario,  --id_funcionario wf
                                NULL, --id_depto
                                'Solicitud de pago por caja - '||v_num_sol_efe,
                                v_cod_proc, 
                                v_reg_cd.nro_tramite); 
                                
                                
                  v_num_sol_efe   = v_reg_cd.nro_tramite;   
                       
            END IF;

            IF (p_hstore->'motivo') IS NOT NULL THEN
                v_motivo = (p_hstore->'motivo')::varchar;
            ELSE
                v_motivo = NULL;
            END IF;

            IF (p_hstore->'id_solicitud_efectivo_fk') IS NOT NULL THEN
                v_id_solicitud_efectivo_fk = (p_hstore->'id_solicitud_efectivo_fk')::integer;
            ELSE
                v_id_solicitud_efectivo_fk = NULL;
            END IF;
            
         

            --Sentencia de la insercion
            insert into tes.tsolicitud_efectivo(
                id_caja,
                id_estado_wf,
                monto,
                id_proceso_wf,
                nro_tramite,
                estado,
                estado_reg,
                motivo,
                id_funcionario,
                fecha,
                id_usuario_ai,
                fecha_reg,
                usuario_ai,
                id_usuario_reg,
                id_usuario_mod,
                fecha_mod,
                id_tipo_solicitud,
                id_solicitud_efectivo_fk,
                id_gestion,
                ingreso_extra
            ) values(
                (p_hstore->'id_caja')::integer,
                v_id_estado_wf,
                (p_hstore->'monto')::numeric,
                v_id_proceso_wf,
                v_num_sol_efe,
                v_codigo_estado,
                'activo',
                v_motivo,
                (p_hstore->'id_funcionario')::integer,
                (p_hstore->'fecha')::date,
                (p_hstore->'_id_usuario_ai')::integer,
                now(),
                (p_hstore->'_nombre_usuario_ai')::varchar,
                p_id_usuario,
                null,
                null,
                v_id_tipo_solicitud,
                v_id_solicitud_efectivo_fk,
                v_id_gestion,
                v_ingreso_extra
            )RETURNING id_solicitud_efectivo into v_id_solicitud_efectivo;
            
            
            --RAC, 29/11/2017, si la solictud  viene  de cuenta docuemntada 
            -- ya tuvo todas las aprobaciones pasa directo para entrega de efectivo
            IF p_id_cuenta_doc is not  null  and (p_hstore->'tipo_solicitud')::varchar in ('solicitud','ingreso') THEN
            
                
                  select
                    te.id_tipo_estado
                  into
                    v_id_tipo_estado
                  from wf.tproceso_wf pw
                  inner join wf.ttipo_proceso tp on pw.id_tipo_proceso = tp.id_tipo_proceso
                  inner join wf.ttipo_estado te on te.id_tipo_proceso = tp.id_tipo_proceso and te.codigo = 'vbcajero'
                  where pw.id_proceso_wf = v_id_proceso_wf;
                     
                 IF v_id_tipo_estado is NULL THEN
                    raise exception 'El estado vbcajero para la solicitud de efectivo no esta parametrizado en el workflow';
                 END IF;

                 --obtenemso funcionario cajero --
                 /*   RAC 29/12/2017,  comentado por que aprantemete si viende decuatan docuemntada no tiene sentido usar id_solicitud_efectivo_fk ...
                 
                 
                  select 
                    caje.id_funcionario
                  into
                    v_id_funcionario_cajero
                  from tes.tsolicitud_efectivo se
                  inner join tes.tcajero caje on caje.id_caja=se.id_caja and caje.tipo='responsable' 
                  and (   now()::date between caje.fecha_inicio and caje.fecha_fin) or (now()::date >= caje.fecha_inicio and caje.fecha_fin is null)
                  where se.id_solicitud_efectivo = v_id_solicitud_efectivo_fk;
                  */
                  
                  --recupera la caja
                  select 
                    cud.id_caja,
                    cud.id_caja_dev,
                    cud.fecha
                  INTO
                    v_reg_caja 
                  from cd.tcuenta_doc cud
                  where cud.id_cuenta_doc = p_id_cuenta_doc;
                  
                  v_id_caja =  COALESCE(v_reg_caja.id_caja,v_reg_caja.id_caja_dev);
                  
                  IF v_id_caja is null THEN
                     raise exception 'No se encontro caja para la cuenta documentada ID %',p_id_cuenta_doc ;
                  END IF;
                  
                  
                  select 
                    caje.id_funcionario
                  into
                    v_id_funcionario_cajero
                  from tes.tcajero caje 
                  WHERE       caje.id_caja = v_id_caja and caje.tipo='responsable' 
                         and  ((v_reg_caja.fecha::date between caje.fecha_inicio and caje.fecha_fin) or (v_reg_caja.fecha::date >= caje.fecha_inicio and caje.fecha_fin is null))
                         and  caje.estado_reg = 'activo';
                  
                
                  
                  IF v_id_funcionario_cajero is null THEN
                        raise exception 'no se encontro cajero para la caja par ala fecha %',v_reg_caja.fecha;
                  END IF;
                 
                
                 v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado,
                                                             v_id_funcionario_cajero,
                                                             v_id_estado_wf,
                                                             v_id_proceso_wf,
                                                             p_id_usuario,
                                                             NULL,
                                                             NULL,
                                                             NULL,
                                                             'Solicitud de ingreso por Caja');


                     -- actualiza estado en solicitud de efectivo
                  update tes.tsolicitud_efectivo set
                       id_estado_wf =  v_id_estado_actual,
                       estado = 'vbcajero',
                       estado_reg = 'activo',
                       id_usuario_mod=p_id_usuario,
                       fecha_mod=now()
                  where id_solicitud_efectivo  = v_id_solicitud_efectivo;
            
            
            END IF;
            
            
            --si es un ingreso por reposicion de caja debemso saltar el estado de WF al ingresado de manera directa
             IF (p_hstore->'tipo_solicitud')::varchar = 'ingreso_caja' THEN 
             
             
                    -----------------------------------------------------------
                    --Cambia estado de la rendicion recien creada a finalizada
                    -----------------------------------------------------------
                    select 
                      se.id_estado_wf,
                      se.id_proceso_wf
                    into 
                      v_rec_se
                    from tes.tsolicitud_efectivo se
                    where se.id_solicitud_efectivo = v_id_solicitud_efectivo;
                    
                    
                     select
                         te.id_tipo_estado
                       into 
                         v_id_tipo_estado
                    
                    from tes.tsolicitud_efectivo se
                    inner join wf.tproceso_wf pw on pw.id_proceso_wf = se.id_proceso_wf
                    inner join wf.ttipo_proceso tp on pw.id_tipo_proceso = tp.id_tipo_proceso
                    inner join wf.ttipo_estado te on te.id_tipo_proceso = tp.id_tipo_proceso and te.codigo = 'ingresado'
                    where se.id_solicitud_efectivo = v_id_solicitud_efectivo;


                    if v_id_tipo_estado is null then
                        raise exception 'El estado Ingresado para la rendicion de solicitud de efectivo no esta parametrizado en el workflow';
                    end if;

                    v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado,
                                                                    NULL,
                                                                    v_rec_se.id_estado_wf,
                                                                    v_rec_se.id_proceso_wf,
                                                                    p_id_usuario,
                                                                    NULL,
                                                                    NULL,
                                                                    null,--id_depto
                                                                    'Ingresado por reposicion de caja ');

                    -- actualiza estado en solicitud de efectivo
                    update tes.tsolicitud_efectivo set
                      id_estado_wf = v_id_estado_actual,
                       estado = 'ingresado'
                    where id_solicitud_efectivo = v_id_solicitud_efectivo;
             
             
             END IF;

            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Solicitud Efectivo almacenado(a) con exito (id_solicitud_efectivo'||v_id_solicitud_efectivo||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud_efectivo', v_id_solicitud_efectivo::varchar);

            --Devuelve la respuesta
            return v_resp;
            
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