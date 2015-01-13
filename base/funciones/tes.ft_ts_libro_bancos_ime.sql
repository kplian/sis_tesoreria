--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.ft_ts_libro_bancos_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Tesoreria
 FUNCION: 		tes.ft_ts_libro_bancos_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'migra.tts_libro_bancos'
 AUTOR: 		 (admin)
 FECHA:	        01-12-2013 09:10:17
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
	v_id_libro_bancos		integer;
    g_centro				varchar;
    g_saldo_cuenta_bancaria	numeric;
    g_saldo_deposito		numeric;
    g_nro_cuenta_banco		varchar;
    g_nro_cheque			integer;
    g_indice				numeric;
    g_max_nro_cheque		integer;
    g_registros				record;
    g_fecha_ant				date;
    g_estado_actual			varchar;
    v_id_proceso_wf			integer;
    v_id_estado_wf			integer;
    v_codigo_estado			varchar;
    v_id_tipo_estado		integer;
    v_id_estado_actual		integer;
    v_pedir_obs				varchar;
    v_codigo_estado_siguiente	varchar;
    v_id_depto				integer;
    v_obs					varchar;
    v_registros_proc				record;
    v_codigo_tipo_pro		varchar;
	v_origen				varchar;			    
    v_sql					varchar;
    v_cadena_cnx			varchar;
    v_id_funcionario		integer;
    v_id_estado_wf_ant		integer;
    v_id_usuario_reg		integer;
    v_acceso_directo 		varchar;
    v_clase 				varchar;
    v_parametros_ad 		varchar;
    v_tipo_noti 			varchar;
    v_titulo 				varchar;
BEGIN

    v_nombre_funcion = 'tes.ft_ts_libro_bancos_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TES_LBAN_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		01-12-2013 09:10:17
	***********************************/

	if(p_transaccion='TES_LBAN_INS')then
					
        begin
        
        	select ctaban.centro into g_centro
            from tes.tcuenta_bancaria ctaban
            where ctaban.id_cuenta_bancaria = v_parametros.id_cuenta_bancaria;
            
            IF(v_parametros.id_libro_bancos_fk is null and g_centro='no' and v_parametros.tipo!='deposito')THEN 
                raise exception
                  'Los datos a ingresar deben tener un deposito asociado. Ingrese los datos a traves de Depositos y Cheques.'
                  ;
            END IF;
            
            IF(v_parametros.tipo in ('cheque','debito_automatico','transferencia_carta'))Then
              --Comparamos el saldo de la cuenta bancaria con el importe del cheque
                
              Select coalesce(sum(Coalesce(lbr.importe_deposito, 0)) - 
                      sum(coalesce(lbr.importe_cheque, 0)), 0)
                      into g_saldo_cuenta_bancaria
              From tes.tts_libro_bancos lbr
              where lbr.fecha <= v_parametros.fecha and 
              lbr.id_cuenta_bancaria = v_parametros.id_cuenta_bancaria;
                
              IF(v_parametros.importe_cheque > g_saldo_cuenta_bancaria) Then
                raise exception               
                 'El importe que intenta registrar excede el saldo general de la cuenta bancaria al %. Por favor revise el saldo de la cuenta al %. id cuenta bancaria %',
                 v_parametros.fecha,v_parametros.fecha, v_parametros.id_cuenta_bancaria;
              End If;
            
              --Comparamos el saldo del deposito con el importe del cheque
            
              IF(v_parametros.tipo <> 'deposito' and v_parametros.id_libro_bancos_fk is not null) Then            	
                --Obtenemos el importe del saldo del deposito
                Select lb.importe_deposito - Coalesce((Select sum (ba.importe_cheque)
                                              From tes.tts_libro_bancos ba
                                              Where ba.id_libro_bancos_fk=lb.id_libro_bancos
                                              and ba.tipo <> 'deposito'),0)
                                                
                                           + Coalesce((Select sum (ba.importe_deposito)
                                              From tes.tts_libro_bancos ba
                                              Where ba.id_libro_bancos_fk=lb.id_libro_bancos
                                              and ba.tipo = 'deposito'),0)
                Into g_saldo_deposito
                From tes.tts_libro_bancos lb
                Where lb.id_libro_bancos = v_parametros.id_libro_bancos_fk;
                  
                If(v_parametros.importe_cheque > g_saldo_deposito) Then
                  raise exception 'El importe que intenta registrar: % Bs., excede el saldo del deposito asociado: % Bs. Por favor revise el saldo.',v_parametros.importe_cheque,g_saldo_deposito;
                End If;
            
              END IF; --fin de la verificacio si es un registro asociado a un deposito
                
            END IF;--fin de la verifiacion de cheque, debito automatico o transferencia con carta
            
            --Verificacion de unicidad de numero de cheque
            IF(v_parametros.tipo='cheque' AND v_parametros.nro_cheque is not null)THEN
              select cb.nro_cuenta into g_nro_cuenta_banco
              from tes.tts_libro_bancos lb
              inner join tes.tcuenta_bancaria cb on cb.id_cuenta_bancaria=lb.id_cuenta_bancaria
              where lb.id_cuenta_bancaria=v_parametros.id_cuenta_bancaria and lb.nro_cheque=v_parametros.nro_cheque;
              
              if(g_nro_cuenta_banco is not null)then 
                 raise exception 'Ya existe el cheque nro % en la cuenta bancaria %', v_parametros.nro_cheque, g_nro_cuenta_banco;
              end if;
        	END IF;
            
        --solo en el caso de cheques colocamos el numero de cheque
            if(v_parametros.tipo ='cheque')then
                g_nro_cheque=v_parametros.nro_cheque;
            else
                g_nro_cheque=null;
            end if;               
           
            v_id_libro_bancos = tes.f_inserta_libro_bancos(p_administrador,p_id_usuario,hstore(v_parametros));
         --ALGORITMO DE ORDENACION DE REGISTROS
         
         --VERIFICAMOS SI ES UN DEPOSITO, transferencia o debito automatico
         IF(v_parametros.tipo in ('deposito','debito_automatico','transferencia_carta')) Then
         
         	--Obtenemos el numero de indice que sera asignado al nuevo registro            
            Select max(lb.indice)
            Into g_indice
            From tes.tts_libro_bancos lb
            Where lb.id_cuenta_bancaria = v_parametros.id_cuenta_bancaria
            and lb.fecha = v_parametros.fecha;
            
            If(g_indice is null )Then
            	g_indice = 0;
            end if;
            
            UPDATE tes.tts_libro_bancos SET 
				indice = g_indice + 1
        	WHERE tes.tts_libro_bancos.id_libro_bancos= v_id_libro_bancos;
         
         ELSE  --si es CHEQUE
         
         	--Obtenemos el numero de indice que sera asignado al nuevo registro            
            Select max(lb.nro_cheque)
            Into g_max_nro_cheque
            From tes.tts_libro_bancos lb
            Where lb.id_cuenta_bancaria = v_parametros.id_cuenta_bancaria
            and lb.fecha = v_parametros.fecha
            and lb.tipo = 'cheque'
            and lb.id_libro_bancos <> v_id_libro_bancos;
            
            If(g_max_nro_cheque is null)Then
            
            	--Obtenemos el numero de indice que sera asignado al nuevo registro            
                Select max(lb.indice)
                Into g_indice
                From tes.tts_libro_bancos lb
                Where lb.id_cuenta_bancaria = v_parametros.id_cuenta_bancaria
                and lb.fecha = v_parametros.fecha;
                
                If(g_indice is null )Then
                    g_indice = 0;
                end if;
                
                UPDATE tes.tts_libro_bancos SET 
                    indice = g_indice + 1
                WHERE tes.tts_libro_bancos.id_libro_bancos= v_id_libro_bancos;
            	
            else
            
                --comparamos el numero de cheque actual con el maximo de la fecha
                IF(v_parametros.nro_cheque > g_max_nro_cheque) Then
                
                    --Obtenemos el numero de indice que sera asignado al nuevo registro            
                    Select max(lb.indice)
                    Into g_indice
                    From tes.tts_libro_bancos lb
                    Where lb.id_cuenta_bancaria = v_parametros.id_cuenta_bancaria
                    and lb.fecha = v_parametros.fecha;
                    
                    If(g_indice is null )Then
                        g_indice = 0;
                    end if;
                    
                    --Asignamos el indice
                    UPDATE tes.tts_libro_bancos SET 
                        indice = g_indice + 1
                    WHERE tes.tts_libro_bancos.id_libro_bancos = v_id_libro_bancos;
                    
                ELSE
                	
                    FOR g_registros in EXECUTE('Select lb.nro_cheque, lb.indice
                                                From tes.tts_libro_bancos lb
                                                Where lb.id_cuenta_bancaria = '||v_parametros.id_cuenta_bancaria||'
                                                and lb.fecha ='''||v_parametros.fecha||'''
                                                and lb.indice is not null
                                                order by lb.indice asc') LOOP
                    	  g_indice = null;       
                         
                          Select lib.indice
                          Into g_indice
                          From tes.tts_libro_bancos lib
                          Where lib.id_libro_bancos = v_id_libro_bancos;
                          
                          /*If(g_indice is null )Then
                              g_indice = 0;
                          end if;*/
                                
                          --Comparamos si el numero de cheque nuevo es menor al numero de cheque del ciclo
                          If (v_parametros.nro_cheque < g_registros.nro_cheque and g_indice is null) Then
                                                            
                              --actualizamos los indices de los registros superiores
                              UPDATE tes.tts_libro_bancos SET 
                                  indice = indice + 1
                              Where tes.tts_libro_bancos.id_cuenta_bancaria = v_parametros.id_cuenta_bancaria
                              and tes.tts_libro_bancos.fecha = v_parametros.fecha
                              and tes.tts_libro_bancos.indice >= g_registros.indice;
                              
                              --asignamos el valor del indice del ciclo al registro nuevo
                              UPDATE tes.tts_libro_bancos SET 
                                  indice = g_registros.indice
                              WHERE tes.tts_libro_bancos.id_libro_bancos= v_id_libro_bancos;
                              
                          End IF;                    
                                
                    END LOOP;
                  
                END IF; --fin comparacion numero de cheque

            End if; --Fin comparacion del null en el maximo numero de cheque
           	
         END IF; --fin comparacion tipo
         
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Depósitos almacenado(a) con exito (id_libro_bancos'||v_id_libro_bancos||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_libro_bancos',v_id_libro_bancos::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TES_LBAN_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		01-12-2013 09:10:17
	***********************************/

	elsif(p_transaccion='TES_LBAN_MOD')then

		begin
        
        	--VERIFICA EXISTENCIA DEL REGISTRO
            IF NOT EXISTS(SELECT 1 FROM tes.tts_libro_bancos LBRBAN
                          WHERE LBRBAN.id_libro_bancos=v_parametros.id_libro_bancos) THEN
                              
                raise exception 'Modificación no realizada: no existe el registro % en la tabla tes.tts_libro_bancos', v_parametros.id_libro_bancos;
                    
            END IF;
			--verificacion de nueva fecha de cheque esta en la gestion correcta
            --g_anio:=extract(YEAR FROM ts_fecha);
                            
        	select ctaban.centro into g_centro
            from tes.tcuenta_bancaria ctaban                        
			where ctaban.id_cuenta_bancaria=v_parametros.id_cuenta_bancaria;
			/*
			IF(g_anio <> g_gestion_cta_banc)THEN
        	    raise exception 'Registro no almacenado, no pertenece a la gestion de la cuenta bancaria, revise la fecha';
    		END IF;*/
            
            IF(v_parametros.id_libro_bancos_fk is null and g_centro='no' and v_parametros.tipo!='deposito')THEN 
				raise exception 'Los datos a ingresar deben tener un deposito asociado. Ingrese los datos a traves de Depositos y Cheques.';
	        END IF;
            
        	--verificacion que la transaccion puede ser modificada porque el periodo se encuentra abierto
        	--g_mes:=extract(MONTH FROM (select lb.fecha from tesoro.tts_libro_bancos lb where lb.id_libro_bancos=ts_id_libro_bancos));
            --g_anio:=extract(YEAR FROM (select lb.fecha from tesoro.tts_libro_bancos lb where lb.id_libro_bancos=ts_id_libro_bancos));
			/*
            select ctaper.estado into g_estado
			from tesoro.tts_libro_bancos lb
  			inner join tesoro.tts_cuenta_bancaria_periodo ctaper on ctaper.id_cuenta_bancaria=lb.id_cuenta_bancaria
  			inner join param.tpm_periodo per on per.id_periodo=ctaper.id_periodo
			inner join param.tpm_gestion ges on ges.id_gestion=per.id_gestion
			where per.periodo=g_mes and ges.gestion=g_anio and lb.id_libro_bancos=ts_id_libro_bancos;
            
            IF(g_estado='cerrado')THEN
            	raise exception 'El periodo % se encuentra cerrado', public.f_mes_lite(g_mes,0); 
            END IF;  */
        
        IF(v_parametros.tipo in ('cheque','debito_automatico','transferencia_carta'))Then        
            
        	--Validamos que no se exceda el saldo general de la cuenta
            --Obtenemos el importe del saldo del deposito
            Select coalesce( sum(Coalesce(lbr.importe_deposito,0)) - sum(coalesce(lbr.importe_cheque,0)) + (Select li.importe_cheque
                                                                                                            From tes.tts_libro_bancos li
                                                                                                            Where li.id_libro_bancos = v_parametros.id_libro_bancos) , 0) 
            Into g_saldo_cuenta_bancaria
             From tes.tts_libro_bancos lbr
             where lbr.fecha <= v_parametros.fecha                            
             and lbr.id_cuenta_bancaria = v_parametros.id_cuenta_bancaria;                             
         
            --Comparamos el saldo de la cuenta bancaria con el importe del cheque
            IF(v_parametros.importe_cheque > g_saldo_cuenta_bancaria) Then
              raise exception 'El importe que intenta registrar excede el saldo general de la cuenta bancaria al %. Por favor revise el saldo de la cuenta al %.',ts_fecha,ts_fecha;
            End If;
            
            
            
             --validamos que no se inserte un cheque que exceda el saldo del deposito asociado
             IF(v_parametros.id_libro_bancos_fk is not null) Then
              	
              --Obtenemos el importe del saldo del deposito
              Select lb.importe_deposito -  Coalesce((Select sum (ba.importe_cheque)
                                            From tes.tts_libro_bancos ba
                                            Where ba.id_libro_bancos_fk=lb.id_libro_bancos),0) 
              							 +
                                            Coalesce((Select sum (ba.importe_deposito)
                                            From tes.tts_libro_bancos ba
                                            Where ba.id_libro_bancos_fk=lb.id_libro_bancos),0)                                            
                                         +   
                                           (Select li.importe_cheque
                                            From tes.tts_libro_bancos li
                                            Where li.id_libro_bancos = v_parametros.id_libro_bancos) 
              Into g_saldo_deposito
              From tes.tts_libro_bancos lb
              Where lb.id_libro_bancos = v_parametros.id_libro_bancos_fk;
                
              --Comparamos el saldo del deposito con el importe del cheque
              IF(v_parametros.importe_cheque > g_saldo_deposito) Then
                raise exception 'El importe que intenta registrar, excede el saldo del deposito asociado. Por favor revise el saldo.';
              End If;
              
            End If; --fin de la verifiacion de si es un cheque asociado a un deposito
            
        End If; --fin de la verificacion de si es cheque, debito automatico o transferencia con carta  
        
        --obtenemos la fecha antes de actualizarla
        Select lb.fecha
        Into g_fecha_ant
        From tes.tts_libro_bancos lb
        Where lb.id_libro_bancos = v_parametros.id_libro_bancos;
        
        /*IF(v_parametros.tipo='cheque' AND v_parametros.nro_cheque is not null)THEN
              select cb.nro_cuenta into g_nro_cuenta_banco
              from tes.tts_libro_bancos lb
              inner join tes.tcuenta_bancaria cb on cb.id_cuenta_bancaria=lb.id_cuenta_bancaria
              where lb.id_cuenta_bancaria=v_parametros.id_cuenta_bancaria and lb.nro_cheque=v_parametros.nro_cheque;
              
              if(g_nro_cuenta_banco is not null)then 
                 raise exception 'Ya existe el cheque nro % en la cuenta bancaria %', v_parametros.nro_cheque, g_nro_cuenta_banco;
              end if;
        END IF;*/
        --solo en el caso de cheques colocamos el numero de cheque
        if(v_parametros.tipo ='cheque')then
        	g_nro_cheque=v_parametros.nro_cheque;
        else
        	g_nro_cheque=null;
        end if;

		UPDATE tes.tts_libro_bancos SET 
		id_cuenta_bancaria=v_parametros.id_cuenta_bancaria,
		fecha=v_parametros.fecha,
		a_favor=upper(translate (v_parametros.a_favor, 'áéíóúÁÉÍÓÚäëïöüÄËÏÖÜñ', 'aeiouAEIOUaeiouAEIOUÑ')),
		nro_cheque=g_nro_cheque,
        importe_deposito=v_parametros.importe_deposito,
		nro_comprobante=v_parametros.nro_comprobante,
        nro_liquidacion=upper(translate (v_parametros.nro_liquidacion, 'áéíóúÁÉÍÓÚäëïöüÄËÏÖÜñ', 'aeiouAEIOUaeiouAEIOUÑ')),
        detalle=upper(translate (v_parametros.detalle, 'áéíóúÁÉÍÓÚäëïöüÄËÏÖÜñ', 'aeiouAEIOUaeiouAEIOUÑ')),
		origen=v_parametros.origen,
        observaciones=upper(translate (v_parametros.observaciones, 'áéíóúÁÉÍÓÚäëïöüÄËÏÖÜñ', 'aeiouAEIOUaeiouAEIOUÑ')),
		importe_cheque=v_parametros.importe_cheque,
        id_libro_bancos_fk=v_parametros.id_libro_bancos_fk,
        tipo=v_parametros.tipo,
		fecha_mod=now(),
		id_usuario_mod = p_id_usuario,
        id_finalidad = v_parametros.id_finalidad
		WHERE tes.tts_libro_bancos.id_libro_bancos = v_parametros.id_libro_bancos;
        
            
        If (v_parametros.fecha<> g_fecha_ant) Then
        	--ALGORITMO DE ORDENACION DE REGISTROS
         
           --VERIFICAMOS SI ES UN DEPOSITO, transferencia o debito automatico
           IF(v_parametros.tipo in ('deposito','debito_automatico','transferencia_carta')) Then
           
              --Obtenemos el numero de indice que sera asignado al nuevo registro            
              Select max(lb.indice)
              Into g_indice
              From tes.tts_libro_bancos lb
              Where lb.id_cuenta_bancaria = v_parametros.id_cuenta_bancaria
              and lb.fecha = v_parametros.fecha;
              
              If(g_indice is null )Then
                  g_indice = 0;
              end if;
              
              UPDATE tes.tts_libro_bancos SET 
                  indice = g_indice + 1
              WHERE tes.tts_libro_bancos.id_libro_bancos= v_parametros.id_libro_bancos;
           
           ELSE  --si es CHEQUE
           
              --Obtenemos el numero de indice que sera asignado al nuevo registro            
              Select max(lb.nro_cheque)
              Into g_max_nro_cheque
              From tes.tts_libro_bancos lb
              Where lb.id_cuenta_bancaria = v_parametros.id_cuenta_bancaria
              and lb.fecha = v_parametros.fecha
              and lb.tipo = 'cheque'
              and lb.id_libro_bancos <> v_parametros.id_libro_bancos;
              
              If(g_max_nro_cheque is null)Then
                            
                  --Obtenemos el numero de indice que sera asignado al nuevo registro            
                  Select max(lb.indice)
                  Into g_indice
                  From tes.tts_libro_bancos lb
                  Where lb.id_cuenta_bancaria = v_parametros.id_cuenta_bancaria
                  and lb.fecha = v_parametros.fecha;
                  
                  If(g_indice is null )Then
                      g_indice = 0;
                  end if;
                  
                  UPDATE tes.tts_libro_bancos SET 
                      indice = g_indice + 1
                  WHERE tes.tts_libro_bancos.id_libro_bancos= v_parametros.id_libro_bancos;
              	
              else
                  --comparamos el numero de cheque actual con el maximo de la fecha
                  IF(v_parametros.nro_cheque > g_max_nro_cheque) Then
                  
                      --Obtenemos el numero de indice que sera asignado al nuevo registro            
                      Select max(lb.indice)
                      Into g_indice
                      From tes.tts_libro_bancos lb
                      Where lb.id_cuenta_bancaria = v_parametros.id_cuenta_bancaria
                      and lb.fecha = v_parametros.fecha;
                      
                      If(g_indice is null )Then
                          g_indice = 0;
                      end if;
                      
                      --Asignamos el indice
                      UPDATE tes.tts_libro_bancos SET 
                          indice = g_indice + 1
                      WHERE tes.tts_libro_bancos.id_libro_bancos = v_parametros.id_libro_bancos;
                      
                  ELSE
                  	
                      FOR g_registros in EXECUTE('Select lb.nro_cheque, lb.indice
                                                  From tes.tts_libro_bancos lb
                                                  Where lb.id_cuenta_bancaria = '||v_parametros.id_cuenta_bancaria||'
                                                  and lb.fecha ='''||v_parametros.fecha||'''
                                                  and lb.indice is not null
                                                  order by lb.indice asc') LOOP
                            g_indice = null;       
                           
                            Select lib.indice
                            Into g_indice
                            From tes.tts_libro_bancos lib
                            Where lib.id_libro_bancos = v_parametros.id_libro_bancos;
                                                              
                            --Comparamos si el numero de cheque nuevo es menor al numero de cheque del ciclo
                            If (v_parametros.nro_cheque < g_registros.nro_cheque and g_indice is null) Then        	
                                                              
                                --actualizamos los indices de los registros superiores
                                UPDATE tes.tts_libro_bancos SET 
                                    indice = indice + 1
                                Where tes.tts_libro_bancos.id_cuenta_bancaria = v_parametros.id_cuenta_bancaria
                                and tes.tts_libro_bancos.fecha = v_parametros.fecha
                                and tes.tts_libro_bancos.indice >= g_registros.indice;
                                
                                --asignamos el valor del indice del ciclo al registro nuevo
                                UPDATE tes.tts_libro_bancos SET 
                                    indice = g_registros.indice
                                WHERE tes.tts_libro_bancos.id_libro_bancos= v_parametros.id_libro_bancos;
                                
                            End IF;                    
                                  
                      END LOOP;
                    
                  END IF; --fin comparacion numero de cheque

              End if; --Fin comparacion del null en el maximo numero de cheque
             	
           END IF; --fin comparacion tipo
        End If;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Depósitos modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_libro_bancos',v_parametros.id_libro_bancos::varchar);
               
            --Devuelve la respuesta
            return v_resp;

        END;
               

	/*********************************    
 	#TRANSACCION:  'TES_LBAN_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		01-12-2013 09:10:17
	***********************************/

	elsif(p_transaccion='TES_LBAN_ELI')then

		begin
        
        	--obtenermos el estado actual del registro
            Select lb.estado into g_estado_actual
            From tes.tts_libro_bancos lb 
            where lb.id_libro_bancos=v_parametros.id_libro_bancos;
            
            --eliminamos solo los que estan en estado borrador	
    		if(g_estado_actual = 'borrador')then 
	        	delete from tes.tts_libro_bancos
            	where id_libro_bancos=v_parametros.id_libro_bancos;            
			else
            	raise exception 'Solo los registros en estado BORRADOR pueden ser eliminados. El estado actual del registro es: %.',upper( g_estado_actual);
            end if;
			   
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Depósitos eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_libro_bancos',v_parametros.id_libro_bancos::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
            
    /*********************************    
 	#TRANSACCION:  'TES_SIGELB_IME'
 	#DESCRIPCION:	funcion que controla el cambio al Siguiente estado de los movimientos bancarios, integrado  con el WF
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		18-11-2014
	***********************************/

	elseif(p_transaccion='TES_SIGELB_IME')then   
        begin
        
         /*   PARAMETROS
         
        $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
        $this->setParametro('id_depto_wf','id_depto_wf','int4');
        $this->setParametro('obs','obs','text');
        $this->setParametro('json_procesos','json_procesos','text');
        */
        
        --obtenermos datos basicos
        select
            lb.id_libro_bancos,
            lb.id_proceso_wf,
            lb.estado,
            lb.sistema_origen
            --pp.fecha_tentativa,
            --op.numero,
            --pp.total_prorrateado ,
            --pp.monto_ejecutar_total_mo
        into 
            v_id_libro_bancos,
            v_id_proceso_wf,
            v_codigo_estado,
            v_origen
            --v_fecha_tentativa,
            --v_num_obliacion_pago,
            --v_total_prorrateo,
            --v_monto_ejecutar_total_mo            
        from tes.tts_libro_bancos  lb
        --inner  join tes.tobligacion_pago op on op.id_obligacion_pago = pp.id_obligacion_pago
        where lb.id_proceso_wf  = v_parametros.id_proceso_wf_act;
          
          select 
            ew.id_tipo_estado ,
            te.pedir_obs,
            ew.id_estado_wf
           into 
            v_id_tipo_estado,
            v_pedir_obs,
            v_id_estado_wf
            
          from wf.testado_wf ew
          inner join wf.ttipo_estado te on te.id_tipo_estado = ew.id_tipo_estado
          where ew.id_estado_wf =  v_parametros.id_estado_wf_act;
          
           -- obtener datos tipo estado
                
                select
                 te.codigo
                into
                 v_codigo_estado_siguiente
                from wf.ttipo_estado te
                where te.id_tipo_estado = v_parametros.id_tipo_estado;
      
             IF  pxp.f_existe_parametro(p_tabla,'id_depto_wf') THEN
                 
               v_id_depto = v_parametros.id_depto_wf;
                
             END IF;
                
                
                
             IF  pxp.f_existe_parametro(p_tabla,'obs') THEN
                  v_obs=v_parametros.obs;
             ELSE
                   v_obs='---';
                
             END IF;
             /*  
             --configurar acceso directo para la alarma   
             v_acceso_directo = '';
             v_clase = '';
             v_parametros_ad = '';
             v_tipo_noti = 'notificacion';
             v_titulo  = 'Visto Bueno';
             
           
             IF   v_codigo_estado_siguiente not in('borrador','pendiente','pagado','devengado','anulado')   THEN
                  v_acceso_directo = '../../../sis_tesoreria/vista/plan_pago/PlanPagoVb.php';
                  v_clase = 'PlanPagoVb';
                  v_parametros_ad = '{filtro_directo:{campo:"plapa.id_proceso_wf",valor:"'||v_id_proceso_wf::varchar||'"}}';
                  v_tipo_noti = 'notificacion';
                  v_titulo  = 'Visto Bueno';
             
             END IF;
            */ 
             
             -- hay que recuperar el supervidor que seria el estado inmediato,...
             v_id_estado_actual =  wf.f_registra_estado_wf(v_parametros.id_tipo_estado, 
                                                             v_parametros.id_funcionario_wf, 
                                                             v_parametros.id_estado_wf_act, 
                                                             v_id_proceso_wf,
                                                             p_id_usuario,
                                                             v_parametros._id_usuario_ai,
                                                             v_parametros._nombre_usuario_ai,
                                                             v_id_depto,
                                                             ' Obs:'||v_obs,
                                                             NULL,	--v_acceso_directo ,
                                                             NULL, 	--v_clase,
                                                             NULL, 	--v_parametros_ad,
                                                             NULL,	--v_tipo_noti,
                                                             NULL);	--v_titulo);

          --------------------------------------
          -- registra los procesos disparados
          --------------------------------------
         
          FOR v_registros_proc in ( select * from json_populate_recordset(null::wf.proceso_disparado_wf, v_parametros.json_procesos::json)) LOOP
    
               --get cdigo tipo proceso
               select   
                  tp.codigo 
               into 
                  v_codigo_tipo_pro   
               from wf.ttipo_proceso tp 
               where  tp.id_tipo_proceso =  v_registros_proc.id_tipo_proceso_pro;
          
          
               -- disparar creacion de procesos seleccionados
              
              SELECT
                       ps_id_proceso_wf,
                       ps_id_estado_wf,
                       ps_codigo_estado
                 into
                       v_id_proceso_wf,
                       v_id_estado_wf,
                       v_codigo_estado
              FROM wf.f_registra_proceso_disparado_wf(
                       p_id_usuario,
                       v_parametros._id_usuario_ai,
                       v_parametros._nombre_usuario_ai,
                       v_id_estado_actual, 
                       v_registros_proc.id_funcionario_wf_pro, 
                       v_registros_proc.id_depto_wf_pro,
                       v_registros_proc.obs_pro,
                       v_codigo_tipo_pro,    
                       v_codigo_tipo_pro);
                       
                       
           END LOOP; 
           
           -- actualiza estado en la solicitud
           -- funcion para cambio de estado     
           /*
          IF  tes.f_fun_inicio_plan_pago_wf(p_id_usuario, 
           									v_parametros._id_usuario_ai, 
                                            v_parametros._nombre_usuario_ai, 
                                            v_id_estado_actual, 
                                            v_parametros.id_proceso_wf_act, 
                                            v_codigo_estado_siguiente) THEN
                                            
          END IF;*/
          --actualiza estado en el libro bancos
          -- actualiza estado en la solicitud
          update tes.tts_libro_bancos  t set 
             id_estado_wf =  v_id_estado_actual,
             estado = v_codigo_estado_siguiente,
             id_usuario_mod=p_id_usuario,
             fecha_mod=now()
                           
          where id_proceso_wf = v_parametros.id_proceso_wf_act;
          
          
          if(v_codigo_estado_siguiente='anulado')then
          	update tes.tts_libro_bancos  t set 
             importe_cheque = 0, 
             importe_deposito = 0,
             a_favor = 'ANULADO'                          
          	where id_libro_bancos = v_id_libro_bancos;
          end if;
           
          if(v_codigo_estado_siguiente='impreso' AND v_origen='FONDOS_AVANCE')then
          
			v_sql:='select tesoro.f_solicitud_avance_pagado_pxp('||v_id_libro_bancos||')';
            
            --Obtención de la cadena de conexión
            v_cadena_cnx =  migra.f_obtener_cadena_conexion();
            
            --Abrir conexión
            v_resp = dblink_connect(v_cadena_cnx);
         
            IF v_resp!='OK' THEN
                raise exception 'FALLO LA CONEXION A LA BASE DE DATOS CON DBLINK';
            END IF;
            
            --Ejecuta la función remotamente
            perform * from dblink(v_sql, true) as (respuesta varchar);
            
            --Cierra la conexión abierta
            perform dblink_disconnect();              	
          	
          end if;
          -- si hay mas de un estado disponible  preguntamos al usuario
          v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado del libro bancos)'); 
          v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');
          
          
          -- Devuelve la respuesta
          return v_resp;
        
     end;
     /*********************************    
 	#TRANSACCION:  'TES_ANTELB_IME'
 	#DESCRIPCION:	Transaccion utilizada  pasar a  estados anterior en el libro bancos
                    segun la operacion definida
 	#AUTOR:		GSS
 	#FECHA:		13-01-2015
	***********************************/

	elseif(p_transaccion='TES_ANTELB_IME')then   
        BEGIN
        	--------------------------------------------------
        	--Retrocede al estado inmediatamente anterior
       		-------------------------------------------------
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
          FROM wf.f_obtener_estado_ant_log_wf(v_parametros.id_estado_wf);
          
          select 
               ew.id_proceso_wf 
            into 
               v_id_proceso_wf
          from wf.testado_wf ew
          where ew.id_estado_wf= v_id_estado_wf_ant;
          
          --configurar acceso directo para la alarma   
             v_acceso_directo = '';
             v_clase = '';
             v_parametros_ad = '';
             v_tipo_noti = '';
             v_titulo  = '';
             
          v_id_estado_actual = wf.f_registra_estado_wf(
              v_id_tipo_estado, 
              v_id_funcionario, 
              v_parametros.id_estado_wf, 
              v_id_proceso_wf, 
              p_id_usuario,
              v_parametros._id_usuario_ai,
              v_parametros._nombre_usuario_ai,
              v_id_depto,
              '[RETROCESO] ',
              v_acceso_directo,
              v_clase,
              v_parametros_ad,
              v_tipo_noti,
              v_titulo);
           
           IF  not tes.f_fun_regreso_libro_bancos_wf(p_id_usuario, 
                                                   v_parametros._id_usuario_ai, 
                                                   v_parametros._nombre_usuario_ai, 
                                                   v_id_estado_actual, 
                                                   v_parametros.id_proceso_wf, 
                                                   v_codigo_estado) THEN
            
               raise exception 'Error al retroceder estado';
            
            END IF;        
                    
         -- si hay mas de un estado disponible  preguntamos al usuario
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');                        
                              
          --Devuelve la respuesta
            return v_resp;
                        
        END;
             
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