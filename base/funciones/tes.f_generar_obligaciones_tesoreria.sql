CREATE OR REPLACE FUNCTION plani.f_generar_obligaciones_tesoreria (
  p_id_planilla integer,
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_nombre_usuario_ai varchar
)
RETURNS boolean AS
$body$
DECLARE
  	v_planilla						record;
  	v_resp		            		varchar;
	v_nombre_funcion        		text;
	v_mensaje_error         		text;
    v_id_funcionario_responsable	integer;
    v_codigo_tipo_pro				varchar;
    v_codigo_llave					varchar;
    v_id_proceso_wf					integer;
    v_id_estado_wf					integer;
    v_codigo_estado					varchar;
    v_id_subsistema					integer;
    v_id_moneda						integer;
    v_id_funcionario				integer;
    v_id_obligacion_pago			integer;
    v_id_obligacion_det 			integer;
    v_codigo_tipo_cuenta			varchar;
    v_registros						record;
    v_id_partida					integer;
	v_id_cuenta						integer; 
    v_id_auxiliar					integer;
    
BEGIN
	v_nombre_funcion = 'plani.f_generar_obligaciones_tesoreria';
    
    select *
    into v_planilla
    from plani.tplanilla
    where id_planilla = p_id_planilla;
    
    --get id_funcionario responsable
    
    select e.id_funcionario into v_id_funcionario
    from wf.testado_wf e
    where id_estado_wf = v_planilla.id_estado_wf;
    
    --get id_subsistema
    select id_subsistema into v_id_subsistema
    from segu.tsubsistema s
    where  s.codigo = 'PLANI'; 
    
    --get id_moneda base
    select param.f_get_moneda_base() into v_id_moneda;   
   
     
     --Inserta la obligacion en el ultimo estado
     INSERT INTO 
              tes.tobligacion_pago
            (
              id_usuario_reg,
              fecha_reg,
              estado_reg,
              --id_proveedor,
              id_subsistema,
              id_moneda,
             -- id_depto,
              tipo_obligacion,
              fecha,
              numero,
              tipo_cambio_conv,
              num_tramite,
              id_gestion,
              comprometido,
              --id_categoria_compra,
              --tipo_solicitud,
              --tipo_concepto_solicitud,
              id_funcionario
            ) 
            VALUES (
              p_id_usuario,
              now(),
              'activo',
              --v_id_proveedor,
              v_id_subsistema,
              v_id_moneda,
             -- v_parametros.id_depto_tes,    ------------------ojo
              'rrhh',
              now(),
              v_planilla.nro_planilla,
              1,
              v_planilla.nro_planilla,
              v_planilla.id_gestion,
              'si',
              --v_id_categoria_compra,
              --v_tipo,
              --v_tipo_concepto,
              v_id_funcionario
              
            ) RETURNING id_obligacion_pago into v_id_obligacion_pago;
            
     --actualizar el id_obligacion pago en la planilla
     update plani.tplanilla
     set id_obligacion_pago = v_id_obligacion_pago
     where id_planilla = p_id_planilla;
     
     --Inserta obligaciones_det
     FOR v_registros in (
              select 
                cc.id_consolidado_columna,
                cc.codigo_columna,
                cc.valor_ejecutado,
                c.id_presupuesto,
                tc.nombre || ' Tipo contrato : '||cc.tipo_contrato as nombre,
                cc.tipo_contrato
              from plani.tconsolidado c
              inner join plani.tconsolidado_columna cc on cc.id_consolidado = c.id_consolidado
              inner join plani.ttipo_columna tc on cc.id_tipo_columna = tc.id_tipo_columna
              where c.id_planilla = p_id_planilla 
                    and cc.estado_reg='activo'
              
            )LOOP
            	if (v_registros.tipo_contrato = 'PLA') then
                	v_codigo_tipo_cuenta = 'CUETIPCOLPLA';
                else
                	v_codigo_tipo_cuenta = 'CUETIPCOLEVE';
                end if;
            	if (v_registros.valor_ejecutado > 0) then
                    --obtener los datos de partida, cuenta y auxiliar para el detalle
                    SELECT 
                      ps_id_partida ,
                      ps_id_cuenta,
                      ps_id_auxiliar
                    into 
                      v_id_partida,
                      v_id_cuenta, 
                      v_id_auxiliar
                    FROM conta.f_get_config_relacion_contable('CUETIPCOLPLA', v_planilla.id_gestion, v_registros.id_tipo_columna, v_registros.id_presupuesto);
                 
                           /*INSERT INTO 
                            tes.tobligacion_det
                          (
                            id_usuario_reg,
                            fecha_reg,
                            estado_reg,
                            id_obligacion_pago,
                            --id_concepto_ingas,
                            id_centro_costo,
                            id_partida,
                            id_cuenta,
                            id_auxiliar,                        
                            monto_pago_mo,
                            monto_pago_mb,
                            descripcion) 
                          VALUES (
                            p_id_usuario,
                            now(),
                            'activo',
                            v_id_obligacion_pago,
                            --v_registros.id_concepto_ingas,
                            v_registros.presupuesto,
                            v_id_partida,
                            v_id_cuenta,
                            v_id_auxiliar,                        
                            v_registros.valor_ejecutado, 
                            v_registros.valor, 
                            v_registros.nombre
                          )RETURNING id_obligacion_det into v_id_obligacion_det;                
                           
                       update plani.tconsolidado_columna
                       set id_obligacion_det = v_id_obligacion_det
                       where id_consolidado_columna = v_registros.id_consolidado_columna;*/
                end if;
            END LOOP;
     
     
     --Inserta planes de pago y prorrateo un pago de devengado (Global) y n pagos de pago(uno por obligacion de la planilla) */ 
    return true;
       
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