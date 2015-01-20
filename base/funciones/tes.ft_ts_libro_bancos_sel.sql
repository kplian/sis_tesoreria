--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.ft_ts_libro_bancos_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Tesoreria
 FUNCION: 		tes.ft_ts_libro_bancos_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'migra.tts_libro_bancos'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        17-11-2014 09:10:17
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_filtro_saldo		varchar;
    v_fecha_anterior	date;
			    
BEGIN

	v_nombre_funcion = 'tes.ft_ts_libro_bancos_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_LBAN_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		17-11-2014
	***********************************/

	if(p_transaccion='TES_LBAN_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select id_libro_bancos,
                        num_tramite,
                        id_cuenta_bancaria,
                        fecha,
                        a_favor,
                        nro_cheque,
                        importe_deposito,
                        nro_liquidacion,
                        detalle,
                        origen,
                        observaciones,
                        importe_cheque,
                        id_libro_bancos_fk,
                        estado,
                        nro_comprobante,
                        indice,
                        estado_reg,
                        tipo,
                        fecha_reg,
                        id_usuario_reg,
                        fecha_mod,
                        id_usuario_mod,
                        usr_reg,
                        usr_mod,
                        id_depto,
                        nombre_depto,
                        id_proceso_wf,
                        id_estado_wf,
                        fecha_cheque_literal,
                        id_finalidad,
                        nombre_finalidad,
                        color,
                        saldo_deposito,
                        nombre_regional,
                        sistema_origen
                        from tes.vlibro_bancos lban
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			raise notice 'consulta %', v_consulta;
			--Devuelve la respuesta
			return v_consulta;
						
		end;

	elsif(p_transaccion='TES_LBANCHQ_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select (max(lban.nro_cheque)+1) as num_cheque
						from tes.tts_libro_bancos lban
						where lban.id_cuenta_bancaria='||v_parametros.id_cuenta_bancaria||' and ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			--v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'TES_LBAN_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		17-11-2014
	***********************************/

	elsif(p_transaccion='TES_LBAN_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_libro_bancos)
					    from tes.vlibro_bancos lban
					    where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
        
	ELSIF (p_transaccion='TES_LBANSAL_SEL') THEN
        BEGIN
        	
            v_consulta := 'SELECT LBRBAN.id_libro_bancos,
            			   LBRBAN.fecha,
                           LBRBAN.a_favor,
                           LBRBAN.observaciones,
                           LBRBAN.importe_deposito,
                           CASE
                             When LBRBAN.tipo = ''deposito'' Then LBRBAN.importe_deposito 
                             				  - COALESCE((Select COALESCE(sum(lb.importe_cheque),0)
                                              	From tes.tts_libro_bancos lb
                                                Where lb.id_libro_bancos_fk = LBRBAN.id_libro_bancos and lb.tipo <> ''deposito''), 0) 
                                              + COALESCE((Select COALESCE(sum(lb.importe_deposito), 0)
                                              	From tes.tts_libro_bancos lb
                                              	Where lb.id_libro_bancos_fk = LBRBAN.id_libro_bancos and lb.tipo = ''deposito''), 0)
                             When (LBRBAN.tipo in (''cheque'', ''debito_automatico'',''transferencia_carta'') and LBRBAN.id_libro_bancos_fk is not null) Then 
                             					(Select COALESCE(lb.importe_deposito,0)
                                                From tes.tts_libro_bancos lb
                             					Where lb.id_libro_bancos = LBRBAN.id_libro_bancos_fk) 
                             				   + (Select COALESCE(sum(lb.importe_deposito), 0)
                             					  From tes.tts_libro_bancos lb
                             					  Where lb.id_libro_bancos_fk = LBRBAN.id_libro_bancos_fk and lb.tipo = ''deposito'')
                                               - (Select sum(lb2.importe_cheque)
                             					  From tes.tts_libro_bancos lb2
                             					  Where lb2.id_libro_bancos <= LBRBAN.id_libro_bancos and
                                   				  lb2.id_libro_bancos_fk = LBRBAN.id_libro_bancos_fk and
                                   				  lb2.tipo <> ''deposito'')
                             Else 0
                           END as saldo
                    		FROM tes.tts_libro_bancos LBRBAN

							WHERE LBRBAN.id_cuenta_bancaria='||v_parametros.id_cuenta_bancaria||' 
                            and LBRBAN.tipo = ''deposito'' AND LBRBAN.id_libro_bancos_fk is null ';
                            
            v_filtro_saldo := ' and
      						CASE
       			 			When LBRBAN.tipo = ''deposito'' Then LBRBAN.importe_deposito 
                            				 - COALESCE((Select COALESCE(sum(lb.importe_cheque),0)
                                             			 From tes.tts_libro_bancos lb
                                                         Where lb.id_libro_bancos_fk = LBRBAN.id_libro_bancos 
                                                         and lb.tipo <> ''deposito''), 0) 
                                             + COALESCE((Select COALESCE(sum(lb.importe_deposito), 0)
                         								 From tes.tts_libro_bancos lb
                         								 Where lb.id_libro_bancos_fk = LBRBAN.id_libro_bancos and
                               							 lb.tipo = ''deposito''), 0)
        					When (LBRBAN.tipo in (''cheque'', ''debito_automatico'',''transferencia_carta'') and LBRBAN.id_libro_bancos_fk is not null) Then
                            							(Select COALESCE(lb.importe_deposito, 0)
                                                 		 From tes.tts_libro_bancos lb
                                                 		 Where lb.id_libro_bancos = LBRBAN.id_libro_bancos_fk) 
            								 + (Select COALESCE(sum(lb.importe_deposito), 0)
        												 From tes.tts_libro_bancos lb
        												 Where lb.id_libro_bancos_fk = LBRBAN.id_libro_bancos_fk and lb.tipo = ''deposito'')
                                             - (Select sum(lb2.importe_cheque)
												         From tes.tts_libro_bancos lb2
												         Where lb2.id_libro_bancos <= LBRBAN.id_libro_bancos and
										                 lb2.id_libro_bancos_fk = LBRBAN.id_libro_bancos_fk and lb2.tipo <> ''deposito'')
        					Else 0
      						END > 0 and ';
            
            v_consulta := v_consulta || v_filtro_saldo;
            v_consulta := v_consulta || v_parametros.filtro;
            v_consulta := v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
 			
            return v_consulta;
        END;
    
    ELSIF (p_transaccion='TES_LBANSAL_CONT') THEN	
        BEGIN
        	
            v_consulta := 'SELECT COUNT(LBRBAN.id_libro_bancos) AS total
                    		FROM tes.tts_libro_bancos LBRBAN
							WHERE LBRBAN.id_cuenta_bancaria='||v_parametros.id_cuenta_bancaria||' 
                            and LBRBAN.tipo = ''deposito'' AND LBRBAN.id_libro_bancos_fk is null ';
                            
            v_filtro_saldo := ' and
      						CASE
       			 			When LBRBAN.tipo = ''deposito'' Then LBRBAN.importe_deposito 
                            				 - COALESCE((Select COALESCE(sum(lb.importe_cheque),0)
                                             			 From tes.tts_libro_bancos lb
                                                         Where lb.id_libro_bancos_fk = LBRBAN.id_libro_bancos 
                                                         and lb.tipo <> ''deposito''), 0) 
                                             + COALESCE((Select COALESCE(sum(lb.importe_deposito), 0)
                         								 From tes.tts_libro_bancos lb
                         								 Where lb.id_libro_bancos_fk = LBRBAN.id_libro_bancos and
                               							 lb.tipo = ''deposito''), 0)
        					When (LBRBAN.tipo in (''cheque'', ''debito_automatico'',''transferencia_carta'') and LBRBAN.id_libro_bancos_fk is not null) Then
                            							(Select COALESCE(lb.importe_deposito, 0)
                                                 		 From tes.tts_libro_bancos lb
                                                 		 Where lb.id_libro_bancos = LBRBAN.id_libro_bancos_fk) 
            								 + (Select COALESCE(sum(lb.importe_deposito), 0)
        												 From tes.tts_libro_bancos lb
        												 Where lb.id_libro_bancos_fk = LBRBAN.id_libro_bancos_fk and lb.tipo = ''deposito'')
                                             - (Select sum(lb2.importe_cheque)
												         From tes.tts_libro_bancos lb2
												         Where lb2.id_libro_bancos <= LBRBAN.id_libro_bancos and
										                 lb2.id_libro_bancos_fk = LBRBAN.id_libro_bancos_fk and lb2.tipo <> ''deposito'')
        					Else 0
      						END > 0 and ';
            
            v_consulta := v_consulta || v_filtro_saldo;
            v_consulta := v_consulta || v_parametros.filtro;
 			
            return v_consulta;
        END;
    ELSEIF (p_transaccion = 'TES_RELIBA_SEL') THEN
       BEGIN  
        --to_char(now(), ''dd/mm/yyyy'') as fecha, 
        raise notice 'fecha unio %', v_parametros.fecha_ini;
        v_fecha_anterior = to_char(v_parametros.fecha_ini-1, 'dd/mm/yyyy') ;
        raise notice 'fecha anterior %', v_fecha_anterior;
          v_consulta := '(SELECT
              '''||v_fecha_anterior||''' as fecha_reporte,           
              ''SALDO ANTERIOR'' as a_favor,
              NULL as detalle, 
              NULL as nro_liquidacion,
              NULL as nro_comprobante,
              NULL as nro_cheque,            
              NULL as debe,            
              NULL as haber,
              
              to_char(
                      coalesce((Select sum(Coalesce(lbr.importe_deposito,0))-sum(coalesce(lbr.importe_cheque,0)) 
                               From tes.tts_libro_bancos lbr
                               Where lbr.fecha < '''||v_parametros.fecha_ini||'''                              
                               and lbr.id_cuenta_bancaria = '||v_parametros.id_cuenta_bancaria||'
                               and lbr.estado <> ''anulado'' ),0.00),''999G999G999G999D99'') as saldo,
              NULL as total_debe,            
              NULL as total_haber,                  
              0::numeric as indice,
              ''01/01/2013''::date as fecha
              )
              ';  
                    
          v_consulta := v_consulta || ' UNION (SELECT 
  		  
              to_char(LB.fecha, ''dd/mm/yyyy'') as fecha_reporte,
              
              LB.a_favor,
              LB.detalle, 
              LB.nro_liquidacion,
              LB.nro_comprobante,
              LB.nro_cheque,
              case when LB.importe_deposito = 0 then 
                  NULL
              else
                  to_char(LB.importe_deposito,''999G999G999D99'')
              end as debe,
              case when LB.importe_cheque = 0 and LB.estado <> ''anulado'' then
                  NULL
              else
                  to_char(LB.importe_cheque,''999G999G999D99'') 
              end as haber,
              
              to_char((Select sum(lbr.importe_deposito) - sum(lbr.importe_cheque) 
                               From tes.tts_libro_bancos lbr
                               where                   
                               lbr.id_cuenta_bancaria = LB.id_cuenta_bancaria
                               and lbr.estado <> ''anulado''
                               and ((lbr.fecha < LB.fecha) or (lbr.fecha = LB.fecha and lbr.indice <= LB.indice)) 
                                                            
                                ),''999G999G999G999D99'') as saldo,
                                
                               
              to_char((Select sum(lbr.importe_deposito) 
                               From tes.tts_libro_bancos lbr
                               where lbr.fecha BETWEEN  '''||v_parametros.fecha_ini||''' and LB.fecha                              
                               and lbr.id_cuenta_bancaria = LB.id_cuenta_bancaria
                               and case when ('''||v_parametros.estado||'''=''Todos'')
                                then   lbr.estado in (''borrador'', ''impreso'',
                                                         ''entregado'',''cobrado'',
                                                         ''anulado'',''reingresado'',
                                                         ''depositado'' ) 
                                                         
                                when ('''||v_parametros.estado||'''=''impreso y entregado'')
                                then   lbr.estado in (''impreso'', ''entregado'' )
                                
                                else lbr.estado in ('''||v_parametros.estado||''')            
                                end 
                                
                                and      
                                        
                                case when ('''||v_parametros.tipo||'''=''Todos'')
                                then   lbr.tipo in   (''cheque'',
                                                      ''deposito'',
                                                      ''debito_automatico'',
                                                      ''transferencia_carta'') 
                                else lbr.tipo in ('''||v_parametros.tipo||''') 
                                end
                                
                                and 
                                case when ('||v_parametros.id_finalidad||'=0)
                                then   lbr.id_finalidad in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13) 
                                else lbr.id_finalidad in ('||v_parametros.id_finalidad||') 
                                end                  
                               ),''999G999G999G999D99'') as total_debe,
                               
              to_char((Select sum(lbr.importe_cheque) 
                               From tes.tts_libro_bancos lbr
                               where lbr.fecha BETWEEN  '''||v_parametros.fecha_ini||''' and  LB.fecha                              
                               and lbr.id_cuenta_bancaria = LB.id_cuenta_bancaria
                               and case when ('''||v_parametros.estado||'''=''Todos'')
                                then   lbr.estado in (''borrador'', ''impreso'',
                                                         ''entregado'',''cobrado'',
                                                         ''anulado'',''reingresado'',
                                                         ''depositado'' ) 
                                                         
                                when ('''||v_parametros.estado||'''=''impreso y entregado'')
                                then   lbr.estado in (''impreso'', ''entregado'' )
                                
                                else lbr.estado in ('''||v_parametros.estado||''')            
                                end 
                                
                                and      
                                        
                                case when ('''||v_parametros.tipo||'''=''Todos'')
                                then   lbr.tipo in   (''cheque'',
                                                                ''deposito'',
                                                                ''debito_automatico'',
                                                                ''transferencia_carta'') 
                                else lbr.tipo in ('''||v_parametros.tipo||''') 
                                end 
                                and
                                case when ('||v_parametros.id_finalidad||'=0)
                                then   lbr.id_finalidad in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13) 
                                else lbr.id_finalidad in ('||v_parametros.id_finalidad||') 
                                end 
                                ),''999G999G999G999D99'') as total_haber,
                               
                               
              LB.indice,
              LB.fecha
      		

              FROM tes.tts_libro_bancos LB
      		
              WHERE
              LB.id_cuenta_bancaria = '||v_parametros.id_cuenta_bancaria||' and
              LB.fecha BETWEEN  '''||v_parametros.fecha_ini||''' and   '''||v_parametros.fecha_fin||''' and      
              
              case when ('''||v_parametros.estado||'''=''Todos'')
              then   LB.estado in (''borrador'', ''impreso'',
                                       ''entregado'',''cobrado'',
                                       ''anulado'',''reingresado'',
                                       ''depositado'' ) 
                                       
              when ('''||v_parametros.estado||'''=''impreso y entregado'')
              then   LB.estado in (''impreso'', ''entregado'' )
                                
              else LB.estado in ('''||v_parametros.estado||''')            
              end 
              
              and      
                      
              case when ('''||v_parametros.tipo||'''=''Todos'')
              then   LB.tipo in   (''cheque'',
                                              ''deposito'',
                                              ''debito_automatico'',
                                              ''transferencia_carta'') 
              else LB.tipo in ('''||v_parametros.tipo||''') 
              end  
              
              and  
              case when ('||v_parametros.id_finalidad||'=0)
              then   LB.id_finalidad in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13) 
              else LB.id_finalidad in ('||v_parametros.id_finalidad||') 
              end
              
              )  order by fecha, indice, nro_cheque asc'; 
                      
              raise notice '%',v_consulta||'';
			
			 --Devuelve la respuesta
		 	 return v_consulta;
       END;
					
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