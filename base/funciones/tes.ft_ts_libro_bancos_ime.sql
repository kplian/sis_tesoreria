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
                     
        	--Sentencia de la insercion
        	insert into tes.tts_libro_bancos(
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
			estado_reg,
			tipo,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_cuenta_bancaria,
			v_parametros.fecha,
			upper(translate (v_parametros.a_favor, '·ÈÌÛ˙¡…Õ”⁄‰ÎÔˆ¸ƒÀœ÷‹Ò', 'aeiouAEIOUaeiouAEIOU—')),
			v_parametros.nro_cheque,
			v_parametros.importe_deposito,
			upper(translate (v_parametros.nro_liquidacion, '·ÈÌÛ˙¡…Õ”⁄‰ÎÔˆ¸ƒÀœ÷‹Ò', 'aeiouAEIOUaeiouAEIOU—')),
			upper(translate (v_parametros.detalle, '·ÈÌÛ˙¡…Õ”⁄‰ÎÔˆ¸ƒÀœ÷‹Ò', 'aeiouAEIOUaeiouAEIOU—')),
			v_parametros.origen,
			upper(translate (v_parametros.observaciones, '·ÈÌÛ˙¡…Õ”⁄‰ÎÔˆ¸ƒÀœ÷‹Ò', 'aeiouAEIOUaeiouAEIOU—')),
			v_parametros.importe_cheque,
			v_parametros.id_libro_bancos_fk,
			'borrador',
			v_parametros.nro_comprobante,
			'activo',
			v_parametros.tipo,
			now(),
			p_id_usuario,
			null,
			null
							
			)RETURNING id_libro_bancos into v_id_libro_bancos;
			
            
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
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','DepÛsitos almacenado(a) con exito (id_libro_bancos'||v_id_libro_bancos||')'); 
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
                              
                raise exception 'ModificaciÛn no realizada: no existe el registro % en la tabla tes.tts_libro_bancos', v_parametros.id_libro_bancos;
                    
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
		a_favor=upper(translate (v_parametros.a_favor, '·ÈÌÛ˙¡…Õ”⁄‰ÎÔˆ¸ƒÀœ÷‹Ò', 'aeiouAEIOUaeiouAEIOU—')),
		nro_cheque=g_nro_cheque,
        importe_deposito=v_parametros.importe_deposito,
		nro_comprobante=v_parametros.nro_comprobante,
        nro_liquidacion=upper(translate (v_parametros.nro_liquidacion, '·ÈÌÛ˙¡…Õ”⁄‰ÎÔˆ¸ƒÀœ÷‹Ò', 'aeiouAEIOUaeiouAEIOU—')),
        detalle=upper(translate (v_parametros.detalle, '·ÈÌÛ˙¡…Õ”⁄‰ÎÔˆ¸ƒÀœ÷‹Ò', 'aeiouAEIOUaeiouAEIOU—')),
		origen=v_parametros.origen,
        observaciones=upper(translate (v_parametros.observaciones, '·ÈÌÛ˙¡…Õ”⁄‰ÎÔˆ¸ƒÀœ÷‹Ò', 'aeiouAEIOUaeiouAEIOU—')),
		importe_cheque=v_parametros.importe_cheque,
        id_libro_bancos_fk=v_parametros.id_libro_bancos_fk,
        tipo=v_parametros.tipo,
		fecha_mod=now(),
		id_usuario_mod = p_id_usuario
		WHERE tes.tts_libro_bancos.id_libro_bancos = v_parametros.id_libro_bancos;
        
        
        /*
         --en el caso de tener FA asociado registramos la relacion
         IF(ts_id_comprobante_libro_bancos is not null and ts_tipo = 'cheque')THEN

			--obtenemos los datos del fondo en avance anterior
            select cl.id_comprobante, cl.id_libro_bancos_deposito, cl.tipo
            into g_id_comprobante, g_id_libro_bancos_deposito, g_tipo
            from sci.tct_comprobante_libro_bancos cl
            where cl.id_comprobante_libro_bancos=ts_id_comprobante_libro_bancos;
            
            --insertamos el nuevo registro
         	INSERT INTO sci.tct_comprobante_libro_bancos (
            	id_comprobante,
                id_libro_bancos_deposito,
                tipo,
                id_libro_bancos_cheque            
            )
            VALUES
            (
            	g_id_comprobante,
                g_id_libro_bancos_deposito,
                g_tipo,
            	ts_id_libro_bancos
            );
            
         END IF;
        */
            
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
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','DepÛsitos modificado(a)'); 
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
			--Sentencia de la eliminacion
			delete from tes.tts_libro_bancos
            where id_libro_bancos=v_parametros.id_libro_bancos;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','DepÛsitos eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_libro_bancos',v_parametros.id_libro_bancos::varchar);
              
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