CREATE OR REPLACE FUNCTION tes.ft_caja_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:   Sistema de Tesoreria
 FUNCION:     tes.ft_caja_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tcaja'
 AUTOR:      (admin)
 FECHA:         16-12-2013 20:43:44
 COMENTARIOS: 
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION: 
 AUTOR:     
 FECHA:   
***************************************************************************/

DECLARE

  v_consulta        varchar;
  v_parametros      record;
  v_nombre_funcion    text;
  v_resp        varchar;
    v_filtro      varchar;
    v_inner       varchar;
    v_cajas       record;
    v_i         integer;
    v_id_caja     integer[];

BEGIN

  v_nombre_funcion = 'tes.ft_caja_sel';
    v_parametros = pxp.f_get_record(p_tabla);

  /*********************************
  #TRANSACCION:  'TES_CAJA_SEL'
  #DESCRIPCION: Consulta de datos
  #AUTOR:   admin
  #FECHA:   16-12-2013 20:43:44
  ***********************************/

  if(p_transaccion='TES_CAJA_SEL')then

      begin 
          v_filtro='';
            v_inner='';

            IF (v_parametros.id_funcionario_usu is null) then

                v_parametros.id_funcionario_usu = -1;

            END IF;


            IF  lower(v_parametros.tipo_interfaz) = 'caja' THEN

                IF p_administrador !=1 THEN
                   --v_filtro = '(caja.id_usuario_reg='||p_id_usuario||' ) and  pc.estado in (''borrador'',''abierto'',''cerrado'',''anulado'',''rechazado'') and  ';
                   v_filtro = '(caja.id_usuario_reg='||p_id_usuario||' ) and ';
                   --pc.estado in (''borrador'',''anulado'',''rechazado'') and  ';
                 ELSE
                     --v_filtro = '(caja.id_usuario_reg='||p_id_usuario||' ) and  pc.estado in (''borrador'',''abierto'',''cerrado'',''anulado'',''rechazado'') and  ';
           --v_filtro = 'pc.estado in (''borrador'',''anulado'',''rechazado'') and  ';
                END IF;

            END IF;

            IF  lower(v_parametros.tipo_interfaz) = 'cajavb' THEN

        v_inner =  'inner join wf.testado_wf ew on ew.id_proceso_wf = pc.id_proceso_wf';

                IF p_administrador !=1 THEN
                   v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||') and  (pc.estado = ''solicitado'') and  ';
                 ELSE
                     v_filtro = '(pc.estado = ''solicitado'') and ';
                END IF;

            END IF;

            IF  lower(v_parametros.tipo_interfaz) = 'cajaabierto' THEN

                IF p_administrador !=1 THEN
                  v_i = 1;
                  FOR v_cajas in (select id_caja
                            from tes.tcajero c 
                            where id_funcionario=v_parametros.id_funcionario_usu
                            and tipo='responsable'  and  c.estado_reg = 'activo')LOOP
                      v_id_caja[v_i] = v_cajas.id_caja;
                        v_i = v_i + 1;
                    END LOOP;

                    IF v_i > 1 THEN
                      v_filtro = '(caja.estado = ''abierto'') and (pc.tipo=''apertura'') and caja.id_caja in('||array_to_string(v_id_caja,',')||') and ';
                    ELSE
                      v_inner = ' left join tes.tcaja_funcionario cjusu on cjusu.id_caja=caja.id_caja ';
                      v_filtro = '(caja.estado = ''abierto'') and (pc.tipo=''apertura'') and cjusu.id_funcionario='||v_parametros.id_funcionario_usu::integer||' and ';
                    END IF;
           
                ELSE
                   v_filtro = '(caja.estado = ''abierto'') and (pc.tipo=''apertura'') and ';
               END IF;              
            END IF;
            
            IF  lower(v_parametros.tipo_interfaz) = 'solicitudcaja' THEN

                IF p_administrador !=1 THEN
                  v_i = 1;
                  FOR v_cajas in (select id_caja
                            from tes.tcajero c
                            where id_funcionario=v_parametros.id_funcionario_usu
                            and tipo='responsable'  and  c.estado_reg = 'activo')LOOP
                      v_id_caja[v_i] = v_cajas.id_caja;
                        v_i = v_i + 1;
                    END LOOP;

                    IF v_i > 1 THEN
                      v_filtro = '(caja.estado = ''abierto'') and (pc.tipo=''apertura'') and caja.id_caja in('||array_to_string(v_id_caja,',')||') and ';
                    ELSE
                        --TODO, RAC  23/12/2017,  si no esun cajero filtra las por lugar segun oficina del funcionario,..... queda pendiente
                        
                      
                      v_filtro = '(caja.estado = ''abierto'') and (pc.tipo=''apertura'')  and ';
                        
                        
                    END IF;
           
                ELSE
                   v_filtro = '(caja.estado = ''abierto'') and (pc.tipo=''apertura'') and ';
               END IF;              
            END IF;
            
            
            
            IF  lower(v_parametros.tipo_interfaz) = 'cajacajero' THEN
                
                IF p_administrador !=1 THEN
                   v_filtro = '(caje.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (pc.estado in (''abierto'',''cerrado'',''aprobado'')) and  ';
                 ELSE
                     v_filtro = '(pc.estado in (''abierto'',''cerrado'',''aprobado'')) and ';
                END IF;                
                
            END IF;
                        
        --Sentencia de la consulta
      v_consulta:='select
            caja.id_caja,
            caja.estado,
            caja.importe_maximo_caja,
                        tes.f_calcular_saldo_caja(caja.id_caja) as saldo,
            caja.tipo,
            caja.estado_reg,
                        pc.estado as estado_proceso,
            caja.importe_maximo_item,
            caja.id_moneda,
            caja.id_depto,
                        caja.id_cuenta_bancaria,
                        ctab.nro_cuenta ||''-'' ||ctab.denominacion as id_cuenta_bancaria,
            caja.codigo,
                        fun.desc_funcionario1 as cajero,
            caja.id_usuario_reg,
            caja.fecha_reg,
            caja.id_usuario_mod,
            caja.fecha_mod,
            usu1.cuenta as usr_reg,
            usu2.cuenta as usr_mod,
            mon.moneda as desc_moneda,  
            depto.nombre as desc_depto,
                        deplb.nombre as desc_depto_lb,
                        caja.tipo_ejecucion,
                        pc.id_proceso_wf,
                pc.id_estado_wf,
                pc.nro_tramite,
                        caja.dias_maximo_rendicion
            from tes.tcaja caja
            inner join segu.tusuario usu1 on usu1.id_usuario = caja.id_usuario_reg
                        inner join tes.tproceso_caja pc on pc.id_caja= caja.id_caja
            left join segu.tusuario usu2 on usu2.id_usuario = caja.id_usuario_mod
            inner join param.tmoneda mon on mon.id_moneda= caja.id_moneda
            inner join param.tdepto depto on depto.id_depto=caja.id_depto
                        left join param.tdepto deplb on deplb.id_depto=caja.id_depto_lb
                        left join tes.tcuenta_bancaria ctab on ctab.id_cuenta_bancaria=caja.id_cuenta_bancaria
                        left join tes.tcajero caje on caje.id_caja=caja.id_caja and caje.tipo=''responsable''
            left join orga.vfuncionario fun on fun.id_funcionario=caje.id_funcionario
                        '||v_inner||'   
                        where caja.estado_reg = ''activo'' and  '||v_filtro;
            
      --Definicion de la respuesta
      v_consulta:=v_consulta||v_parametros.filtro;
      v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
      raise notice '%', v_consulta;
      --Devuelve la respuesta
      return v_consulta;
            
    end;

      /*********************************    
      #TRANSACCION:  'TES_CAJA_REP_SEL'
      #DESCRIPCION: Reporte de datos
      #AUTOR:   mp  
      #FECHA:   29-08-2013 00:28:30
      ***********************************/
    elsif(p_transaccion='TES_CAJA_REP_SEL') then
        begin     
        v_consulta := 'SELECT 
                              ren.id_proceso_caja,
                              ren.estado,
                              ren.id_int_comprobante,
                              ren.nro_tramite,
                              ren.tipo,
                              ren.motivo,
                              ren.estado_reg,
                              ren.id_caja,
                              caja.id_depto_lb,
                              ren.id_proceso_wf,
                              0::NUMERIC as monto,
                              rend.nombre,
                              caja.id_moneda,
                              '''' as razon_social,     
                              0::NUMERIC as importe_pago_liquido,
                              '''' as tramites,
                    ren.fecha,
                              '''' as nombre_fun                                                       
                              FROM tes.tproceso_caja ren
                              INNER JOIN segu.tusuario usu1 ON usu1.id_usuario = ren.id_usuario_reg
                              LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = ren.id_usuario_mod
                              LEFT JOIN tes.ttipo_proceso_caja rend ON rend.id_tipo_proceso_caja = ren.id_tipo_proceso_caja
                              LEFT JOIN tes.tcaja caja ON caja.id_caja = ren.id_caja
                              WHERE '||v_parametros.filtro||'
                                                                                                              
                              UNION ALL
                                                                                         
                              SELECT 
                              ren.id_proceso_caja AS id_proceso_caja,
                              '''' as estado,
                              0 AS id_int_comprobante,
                              '''' as nro_tramite,
                              '''' as tipo,
                              '''' as motivo,
                              '''' as estado_reg,
                              0 as id_caja,
                              0 as id_depto_lb,
                              0 as id_proceso_wf,
                              0::NUMERIC as monto,
                              '''' as nombre,
                              0 as id_moneda, 
                              dc.razon_social,    
                              dc.importe_pago_liquido::NUMERIC,
                              solren.nro_tramite as tramites,
                              solefe.fecha,                                                                                    
                              f.paterno as nombre_fun
                              FROM tes.tsolicitud_rendicion_det ren
                              INNER JOIN tes.tsolicitud_efectivo solren on solren.id_solicitud_efectivo = ren.id_solicitud_efectivo
                              INNER JOIN tes.tsolicitud_efectivo solefe on solefe.id_solicitud_efectivo=solren.id_solicitud_efectivo_fk
                              INNER JOIN tes.tcaja caja on caja.id_caja=solefe.id_caja
                              LEFT JOIN conta.tdoc_compra_venta dc on dc.id_doc_compra_venta=ren.id_documento_respaldo
                              LEFT JOIN param.tplantilla pla on pla.id_plantilla = dc.id_plantilla
                              LEFT JOIN param.tmoneda mon on mon.id_moneda = dc.id_moneda
                              INNER JOIN segu.tusuario usu1 on usu1.id_usuario = ren.id_usuario_reg
                              LEFT JOIN segu.tusuario usu2 on usu2.id_usuario = ren.id_usuario_mod
                              LEFT JOIN orga.tfuncionario_tmp f on f.id_funcionario=solefe.id_funcionario
                              WHERE ren.id_proceso_caja is not null and '||v_parametros.filtro||' 
                              ';
        return v_consulta;
      end;

  /*********************************    
  #TRANSACCION:  'TES_CAJA_CONT'
  #DESCRIPCION: Conteo de registros
  #AUTOR:   admin 
  #FECHA:   16-12-2013 20:43:44
  ***********************************/

  elsif(p_transaccion='TES_CAJA_CONT')then

    begin
          v_filtro='';
            v_inner='';
            
            IF (v_parametros.id_funcionario_usu is null) then
                
                v_parametros.id_funcionario_usu = -1;
            
            END IF;                        
            
            IF  lower(v_parametros.tipo_interfaz) = 'cajavb' THEN
            
                v_inner =  'inner join wf.testado_wf ew on ew.id_proceso_wf = pc.id_proceso_wf';
                
                IF p_administrador !=1 THEN
                   v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||') and  (pc.estado = ''solicitado'') and  ';
                 ELSE
                     v_filtro = '(pc.estado = ''solicitado'') and ';
                END IF;                
                
            END IF;
            
           IF  lower(v_parametros.tipo_interfaz) = 'cajaabierto' THEN

                IF p_administrador !=1 THEN
                  v_i = 1;
                  FOR v_cajas in (select id_caja
                            from tes.tcajero c
                            where id_funcionario=v_parametros.id_funcionario_usu
                            and tipo='responsable'  and  c.estado_reg = 'activo')LOOP
                      v_id_caja[v_i] = v_cajas.id_caja;
                        v_i = v_i + 1;
                    END LOOP;

                    IF v_i > 1 THEN
                      v_filtro = '(caja.estado = ''abierto'') and (pc.tipo=''apertura'') and caja.id_caja in('||array_to_string(v_id_caja,',')||') and ';
                    ELSE
                      v_inner = ' left join tes.tcaja_funcionario cjusu on cjusu.id_caja=caja.id_caja ';
                      v_filtro = '(caja.estado = ''abierto'') and (pc.tipo=''apertura'') and cjusu.id_funcionario='||v_parametros.id_funcionario_usu::integer||' and ';
                    END IF;
           
                ELSE
                   v_filtro = '(caja.estado = ''abierto'') and (pc.tipo=''apertura'') and ';
               END IF;              
            END IF;
            
            IF  lower(v_parametros.tipo_interfaz) = 'solicitudcaja' THEN

                IF p_administrador !=1 THEN
                  v_i = 1;
                  FOR v_cajas in (select id_caja
                            from tes.tcajero c
                            where id_funcionario=v_parametros.id_funcionario_usu
                            and tipo='responsable' and  c.estado_reg = 'activo' )LOOP
                      v_id_caja[v_i] = v_cajas.id_caja;
                        v_i = v_i + 1;
                    END LOOP;

                    IF v_i > 1 THEN
                      v_filtro = '(caja.estado = ''abierto'') and (pc.tipo=''apertura'') and caja.id_caja in('||array_to_string(v_id_caja,',')||') and ';
                    ELSE
                        --TODO, RAC  23/12/2017,  si no esun cajero filtra las por lugar segun oficina del funcionario,..... queda pendiente
                        
                      
                      v_filtro = '(caja.estado = ''abierto'') and (pc.tipo=''apertura'')  and ';
                        
                        
                    END IF;
           
                ELSE
                   v_filtro = '(caja.estado = ''abierto'') and (pc.tipo=''apertura'') and ';
               END IF;              
            END IF;
            
            IF  lower(v_parametros.tipo_interfaz) = 'caja' THEN
                
                IF p_administrador !=1 THEN
                   v_filtro = '(caja.id_usuario_reg='||p_id_usuario||' ) and  pc.estado in (''borrador'',''anulado'',''rechazado'') and ';
                 ELSE
                     v_filtro = 'pc.estado in (''borrador'',''anulado'',''rechazado'') and  ';
                END IF;                
                
            END IF;
            
            IF  lower(v_parametros.tipo_interfaz) = 'cajacajero' THEN
                
                IF p_administrador !=1 THEN
                   v_filtro = '(caje.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (pc.estado in (''abierto'',''cerrado'',''aprobado'')) and  ';
                 ELSE
                     v_filtro = '(pc.estado in (''abierto'',''cerrado'',''aprobado'')) and ';
                END IF;                
                
            END IF;
            
      --Sentencia de la consulta de conteo de registros
      v_consulta:='select count(caja.id_caja)
              from tes.tcaja caja
              inner join segu.tusuario usu1 on usu1.id_usuario = caja.id_usuario_reg
                  inner join tes.tproceso_caja pc on pc.id_caja= caja.id_caja
            left join segu.tusuario usu2 on usu2.id_usuario = caja.id_usuario_mod
            inner join param.tmoneda mon on mon.id_moneda= caja.id_moneda
                        inner join param.tdepto depto on depto.id_depto=caja.id_depto
                        left join param.tdepto deplb on deplb.id_depto=caja.id_depto_lb
                        left join tes.tcuenta_bancaria ctab on ctab.id_cuenta_bancaria=caja.id_cuenta_bancaria
                        left join tes.tcajero caje on caje.id_caja=caja.id_caja and caje.tipo=''responsable''
            left join orga.vfuncionario fun on fun.id_funcionario=caje.id_funcionario
              '||v_inner||'   
                        where caja.estado_reg = ''activo'' AND '||v_filtro;
      
      --Definicion de la respuesta        
      v_consulta:=v_consulta||v_parametros.filtro;

      --Devuelve la respuesta
      return v_consulta;

    end;
          
  else
               
    raise exception 'Transaccion inexistente';
                   
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