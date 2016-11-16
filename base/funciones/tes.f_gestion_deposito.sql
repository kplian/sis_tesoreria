--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_gestion_deposito (
  p_administrador integer,
  p_id_usuario integer,
  p_id_cuenta_bancaria integer,
  p_fecha date,
  p_id_libro_bancos_fk integer,
  p_id_finalidad integer,
  p_id_int_comprobante integer,
  p_tipo varchar,
  p_importe_cheque numeric,
  p_importe_deposito numeric,
  p_nro_cheque integer,
  p_nro_comprobante varchar,
  p_comprobante_sigma varchar,
  p_nro_liquidacion varchar,
  p_detalle varchar,
  p_a_favor varchar,
  p_origen varchar,
  p_id_depto integer,
  p_observaciones varchar,
  p_nro_deposito varchar,
  p_sistema_origen varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Obligaciones de Pago
 FUNCION: 		tes.f_gestion_deposito
 DESCRIPCION:   para gestion el regitro de depositos en libro de bancos desde otros sistemas
                esta funcion es para remplazar las originales y confusas
                
                
 AUTOR: 		 rensi arteaga
 FECHA:	       12/10/2016
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/


DECLARE
    v_total_detalle 		numeric;
    v_factor				numeric;
    v_id_obligacion_det	integer;
    v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
    
    
    g_centro				varchar;
    g_id_periodo			integer;
    v_periodo				integer;
    g_id_cuenta_bancaria_periodo	integer;
    v_estado				varchar;
    g_fecha					date;
    g_saldo_cuenta_bancaria	numeric;
    g_saldo_deposito		numeric;
    g_nro_cuenta_banco		varchar;
    g_nro_cheque			integer;
    v_id_libro_bancos		integer;
    g_indice		integer;
    
     v_hstore_registros hstore;

    
    
    
BEGIN
	    
           v_nombre_funcion = 'tes.f_gestion_deposito';
        
        
            select ctaban.centro into g_centro
            from tes.tcuenta_bancaria ctaban
            where ctaban.id_cuenta_bancaria = p_id_cuenta_bancaria;
            
            IF(p_id_libro_bancos_fk is null and g_centro in ('no','esp') and p_tipo!='deposito')THEN 
                raise exception 'Los datos a ingresar deben tener un deposito asociado. Ingrese los datos a traves de Depositos y Cheques.';
            END IF;
            
             			
            select per.id_periodo, 
                   per.periodo
               into 
                   g_id_periodo, 
                   v_periodo
			from param.tperiodo per
			where g_fecha between per.fecha_ini and per.fecha_fin;
                  
            
            select 
                ctaper.id_cuenta_bancaria_periodo, 
                ctaper.estado
            into 
                g_id_cuenta_bancaria_periodo, 
                v_estado
			from tes.tcuenta_bancaria_periodo ctaper 
			where ctaper.id_periodo = g_id_periodo 
            and ctaper.id_cuenta_bancaria = p_id_cuenta_bancaria;
            
            
            
            IF (g_id_cuenta_bancaria_periodo IS NULL) THEN
                  
                INSERT INTO tes.tcuenta_bancaria_periodo(
                  id_usuario_reg,
                  id_cuenta_bancaria,
                  id_periodo,
                  estado
                )VALUES(
                  1,
                  p_id_cuenta_bancaria,
                  g_id_periodo,
                  'abierto'
                );
            ELSE
                IF(v_estado='cerrado')THEN
                    raise exception 'El periodo % se encuentra cerrado', pxp.f_obtener_literal_periodo(v_periodo,0); 
                END IF;
            END IF;
            
            
                        
            IF(p_tipo in ('cheque','debito_automatico','transferencia_carta','transf_interna_debe','transf_interna_haber'))Then
              
              -- Comparamos el saldo de la cuenta bancaria con el importe del cheque
              
              Select 
                   coalesce(sum(Coalesce(lbr.importe_deposito, 0)) - sum(coalesce(lbr.importe_cheque, 0)), 0)
                into 
                   g_saldo_cuenta_bancaria
              From tes.tts_libro_bancos lbr
              where lbr.fecha <= g_fecha and 
              lbr.id_cuenta_bancaria = p_id_cuenta_bancaria;
                
              IF(p_importe_cheque > g_saldo_cuenta_bancaria) Then
                    raise exception               
                     'El importe que intenta registrar excede el saldo general de la cuenta bancaria al %. Por favor revise el saldo de la cuenta al %. id cuenta bancaria %',
                     g_fecha,g_fecha, p_id_cuenta_bancaria;                
              End If;
            
              --Comparamos el saldo del deposito con el importe del cheque
            
              IF(  p_tipo <> 'deposito' and p_id_libro_bancos_fk is not null) Then 
                         	
                --Obtenemos el importe del saldo del deposito
                
                if((select lb.estado
					from tes.tts_libro_bancos lb
					where lb.id_libro_bancos = p_id_libro_bancos_fk )= 'borrador')then
                	
                    if (pxp.f_existe_parametro(p_tabla,'sistema_origen') = FALSE) then
                		raise exception 'No se puede ingresar un cheque, debito automatico o transferencia carta sobre un deposito en estado BORRADOR';
                    end if;
                    
                end if;
                
                
                Select lb.importe_deposito - Coalesce((Select sum (ba.importe_cheque)
                                              From tes.tts_libro_bancos ba
                                              Where ba.id_libro_bancos_fk=lb.id_libro_bancos
                                              and ba.tipo not in ('deposito','transf_interna_haber')),0)
                                                
                                           + Coalesce((Select sum (ba.importe_deposito)
                                              From tes.tts_libro_bancos ba
                                              Where ba.id_libro_bancos_fk=lb.id_libro_bancos
                                              and ba.tipo in ('deposito','transf_interna_haber')),0)
                Into g_saldo_deposito
                From tes.tts_libro_bancos lb
                Where lb.id_libro_bancos = p_id_libro_bancos_fk;
                  
                If(p_importe_cheque > g_saldo_deposito) Then
                  raise exception 'El importe que intenta registrar: % Bs., excede el saldo del deposito asociado: % Bs. Por favor revise el saldo.',p_importe_cheque,g_saldo_deposito;
                End If;
            
              END IF; --fin de la verificacio si es un registro asociado a un deposito
                
            END IF;--fin de la verifiacion de cheque, debito automatico o transferencia con carta
            
            
            --Verificacion de unicidad de numero de cheque
            IF(p_tipo='cheque' AND p_nro_cheque is not null)THEN
              
              select cb.nro_cuenta 
                into 
                  g_nro_cuenta_banco
              from tes.tts_libro_bancos lb
              inner join tes.tcuenta_bancaria cb on cb.id_cuenta_bancaria = lb.id_cuenta_bancaria
              where lb.id_cuenta_bancaria = p_id_cuenta_bancaria and lb.nro_cheque=p_nro_cheque;
              
              if(g_nro_cuenta_banco is not null)then 
                 raise exception 'Ya existe el cheque nro % en la cuenta bancaria %', p_nro_cheque, g_nro_cuenta_banco;
              end if;
              
        	END IF;
            
           --solo en el caso de cheques colocamos el numero de cheque
            
            if(p_tipo ='cheque')then
                g_nro_cheque  =  p_nro_cheque;
            else
                g_nro_cheque =  null;
            end if; 
                          
           raise notice 'antes de llamar a la funcion tes.f_inserta_libro_bancos';
           
           
           v_hstore_registros =   hstore(ARRAY[
                                                  'tipo', p_tipo::varchar,
                                                  'fecha', p_fecha::varchar,
                                                  'origen', p_origen::varchar,
                                                  'a_favor', p_a_favor::varchar,
                                                  'detalle',p_detalle::varchar,
                                                  'nro_cheque', p_nro_cheque::varchar,
                                                  'importe_cheque', p_importe_cheque::varchar,
                                                  'importe_deposito', p_importe_deposito::varchar,
                                                  'nro_comprobante', p_nro_comprobante::varchar,
                                                  'comprobante_sigma', p_comprobante_sigma::varchar,
                                                  'nro_liquidacion', p_nro_liquidacion::varchar,
                                                  'id_cuenta_bancaria', p_id_cuenta_bancaria::varchar,
                                                  'id_libro_bancos_fk', p_id_libro_bancos_fk::varchar,                                                  
                                                  'id_finalidad', p_id_finalidad::varchar,
                                                  'id_int_comprobante', p_id_int_comprobante::varchar,
                                                  'id_depto',p_id_depto::varchar,
                                                  'observaciones',p_observaciones::varchar,
                                                  'nro_deposito',p_nro_deposito::varchar,
                                                  'sistema_origen',p_sistema_origen::varchar
                                                ]);
           
           v_id_libro_bancos = tes.f_inserta_libro_bancos(p_administrador,p_id_usuario,v_hstore_registros);
           
           
         --ALGORITMO DE ORDENACION DE REGISTROS
         
         --VERIFICAMOS SI ES UN DEPOSITO, transferencia o debito automatico
         IF(p_tipo in ('transf_interna_debe','transf_interna_haber')) Then
         
             Select max(lb.indice)
                Into g_indice
            From tes.tts_libro_bancos lb
            Where lb.id_cuenta_bancaria = p_id_cuenta_bancaria
            and lb.fecha = g_fecha;
            
            If(g_indice is null )Then
            	g_indice = 0;
            end if;
            
            UPDATE tes.tts_libro_bancos SET 
				indice = g_indice + 1
        	WHERE tes.tts_libro_bancos.id_libro_bancos= v_id_libro_bancos;
         
         END IF; --fin comparacion tipo
         
		
        --Devuelve la respuesta
        return v_id_libro_bancos;
        
       
       
      
      return 'exito';
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