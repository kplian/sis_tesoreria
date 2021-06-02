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
 ISSUE            FECHA:		      AUTOR                 DESCRIPCION

 #67        	18-08-2020        MZM KPLIAN        actualizacion de proveedor por LB
 #ETR-1606      03/11-2020        manuel guerra     agregar estado de borrador y anulado, para el saldo de banco
 #67			04.11.2020		  MZM KPLIAN		omision de actualizacion de correo empresarial para funcionario
***************************************************************************/

DECLARE

	v_parametros           	record;
	v_resp		            varchar;
	v_nombre_funcion        text;
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
    v_nro_cheque			integer;
    v_tipo					varchar;
    g_id_libro_bancos_fk	integer;
    g_importe_deposito		numeric;
    g_libro_bancos			record;
    g_fecha					date;
    v_estado				varchar;
    v_periodo				integer;
    g_importe_transferencia	numeric;
    g_id_periodo			integer;
    g_id_cuenta_bancaria_periodo	integer;
    v_id_cuenta_bancaria	integer;
    v_estado_padre			varchar;
    v_resp_doc				boolean;
    g_verifica_documento	varchar;
	g_origen				varchar;
    g_nro_tramite			varchar;
    g_id_int_comprobante	integer;
    v_correo	varchar; --#67
    
    
BEGIN
    v_nombre_funcion = 'tes.ft_ts_libro_bancos_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	IF pxp.f_existe_parametro(p_tabla,'fecha')THEN
    	g_fecha = v_parametros.fecha;
    ELSE
    	g_fecha = now();
    END IF;

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

            IF(v_parametros.id_libro_bancos_fk is null and g_centro in ('no','esp') and v_parametros.tipo!='deposito')THEN
                raise exception
                  'Los datos a ingresar deben tener un deposito asociado. Ingrese los datos a traves de Depositos y Cheques.'
                  ;
            END IF;

            --validamos que no se registren datos con fecha de la gestion 2015
            IF( g_fecha < '01-01-2015') then
                raise exception 'No se puede registrar transacciones anteriores a la gestion 2015, use el sistema endesis en este caso';
            END IF;

            select per.id_periodo, per.periodo
            into g_id_periodo, v_periodo
			from param.tperiodo per
			where g_fecha between per.fecha_ini and per.fecha_fin;

            select ctaper.id_cuenta_bancaria_periodo, ctaper.estado
            into g_id_cuenta_bancaria_periodo, v_estado
			from tes.tcuenta_bancaria_periodo ctaper
			where ctaper.id_periodo=g_id_periodo
            and ctaper.id_cuenta_bancaria=v_parametros.id_cuenta_bancaria;

            IF (g_id_cuenta_bancaria_periodo IS NULL) THEN

                INSERT INTO tes.tcuenta_bancaria_periodo(
				id_usuario_reg,
                id_cuenta_bancaria,
                id_periodo,
                estado
                )VALUES(
				1,
                v_parametros.id_cuenta_bancaria,
                g_id_periodo,
                'abierto'
                );
            ELSE
                IF(v_estado='cerrado')THEN
                    raise exception 'El periodo % se encuentra cerrado', pxp.f_obtener_literal_periodo(v_periodo,0);
                END IF;
            END IF;

            IF(v_parametros.tipo in ('cheque','debito_automatico','transferencia_carta','transf_interna_debe','transf_interna_haber'))Then

              IF g_centro != 'otro' THEN
                  
                  
                  
                  --Comparamos el saldo de la cuenta bancaria con el importe del cheque
                  Select coalesce(sum(Coalesce(lbr.importe_deposito, 0)) -
                          sum(coalesce(lbr.importe_cheque, 0)), 0)
                          into g_saldo_cuenta_bancaria
                  From tes.tts_libro_bancos lbr
                  where  lbr.fecha is not null and -- lbr.fecha <= g_fecha and   --OJO  27/03/2018   COMENTADO para VALIDAR, comentado
                  lbr.estado not in ('borrador','anulado') and --#ETR-1606
                  lbr.id_cuenta_bancaria = v_parametros.id_cuenta_bancaria;

                  IF(v_parametros.importe_cheque > g_saldo_cuenta_bancaria) Then
                      raise exception
                       'El importe que intenta registrar excede el saldo general de la cuenta bancaria al %. Por favor revise el saldo de la cuenta al %. id cuenta bancaria %',
                       g_fecha,g_fecha, v_parametros.id_cuenta_bancaria;
                  End If;
               END IF;
              --Comparamos el saldo del deposito con el importe del cheque

              IF(v_parametros.tipo <> 'deposito' and v_parametros.id_libro_bancos_fk is not null) Then
                --Obtenemos el importe del saldo del deposito
                if((select lb.estado
					from tes.tts_libro_bancos lb
					where lb.id_libro_bancos = v_parametros.id_libro_bancos_fk)='borrador')then

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
           raise notice 'antes de llamar a la funcion tes.f_inserta_libro_bancos';
            v_id_libro_bancos = tes.f_inserta_libro_bancos(p_administrador,p_id_usuario,hstore(v_parametros));
         --ALGORITMO DE ORDENACION DE REGISTROS

         --VERIFICAMOS SI ES UN DEPOSITO, transferencia o debito automatico
         IF(v_parametros.tipo in ('transf_interna_debe','transf_interna_haber')) Then

         --IF(v_parametros.tipo in ('deposito','debito_automatico','transferencia_carta','transf_interna_debe','transf_interna_haber')) Then
         	--Obtenemos el numero de indice que sera asignado al nuevo registro
            Select max(lb.indice)
            Into g_indice
            From tes.tts_libro_bancos lb
            Where lb.id_cuenta_bancaria = v_parametros.id_cuenta_bancaria
            and lb.fecha = g_fecha;

            If(g_indice is null )Then
            	g_indice = 0;
            end if;

            UPDATE tes.tts_libro_bancos SET
				indice = g_indice + 1
        	WHERE tes.tts_libro_bancos.id_libro_bancos= v_id_libro_bancos;

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

            IF(v_parametros.id_libro_bancos_fk is null and g_centro in ('no','esp') and v_parametros.tipo!='deposito')THEN
				raise exception 'Los datos a ingresar deben tener un deposito asociado. Ingrese los datos a traves de Depositos y Cheques.';
	        END IF;

        	--destino
            select ctaper.estado, per.periodo
            into v_estado, v_periodo
			from tes.tcuenta_bancaria_periodo ctaper
            inner join param.tperiodo per on per.id_periodo=ctaper.id_periodo
			where g_fecha between per.fecha_ini and per.fecha_fin
            and ctaper.id_cuenta_bancaria=v_parametros.id_cuenta_bancaria;

            if(v_estado!='abierto')then
            	raise exception 'El periodo % no se encuentra abierto',  pxp.f_obtener_literal_periodo(v_periodo,null);
            end if;

            SELECT LBRBAN.fecha, LBRBAN.id_estado_wf , lbrpad.estado into g_fecha, v_id_estado_wf, v_estado_padre
            FROM tes.tts_libro_bancos LBRBAN
            LEFT JOIN tes.tts_libro_bancos LBRPAD on lbrpad.id_libro_bancos=lbrban.id_libro_bancos_fk
            WHERE LBRBAN.id_libro_bancos=v_parametros.id_libro_bancos;

            if(v_estado_padre = 'borrador')then
            	raise exception '%', 'El deposito se encuentra en estado borrador';
            end if;

            --origen
            select ctaper.estado, per.periodo
            into v_estado, v_periodo
			from tes.tcuenta_bancaria_periodo ctaper
            inner join param.tperiodo per on per.id_periodo=ctaper.id_periodo
			where g_fecha between per.fecha_ini and per.fecha_fin
            and ctaper.id_cuenta_bancaria=v_parametros.id_cuenta_bancaria;

            if(v_estado!='abierto')then
            	raise exception 'El periodo % no se encuentra abierto',  pxp.f_obtener_literal_periodo(v_periodo,null);
            end if;

        IF(v_parametros.tipo in ('cheque','debito_automatico','transferencia_carta'))Then

        	--Validamos que no se exceda el saldo general de la cuenta
            --Obtenemos el importe del saldo del deposito
            Select coalesce( sum(Coalesce(lbr.importe_deposito,0)) - sum(coalesce(lbr.importe_cheque,0)) + (Select li.importe_cheque
                                                                                                            From tes.tts_libro_bancos li
                                                                                                            Where li.id_libro_bancos = v_parametros.id_libro_bancos) , 0)
            Into g_saldo_cuenta_bancaria
            From tes.tts_libro_bancos lbr
            where lbr.fecha is not null and --lbr.fecha <= v_parametros.fecha  and  --OJO  27/03/2018   COMENTADO APRA VALIDAR, comentado
            lbr.estado not in ('borrador','anulado') and --#ETR-1606
            lbr.id_cuenta_bancaria = v_parametros.id_cuenta_bancaria;

            --Comparamos el saldo de la cuenta bancaria con el importe del cheque
            IF(v_parametros.importe_cheque > g_saldo_cuenta_bancaria) Then
              raise exception 'El importe que intenta registrar excede el saldo general de la cuenta bancaria al %. Por favor revise el saldo de la cuenta al %.',v_parametros.fecha,v_parametros.fecha;
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


        else
        	--validamos que el deposito no sea menor a la suma de los cheques y depositos adicionales
            IF(v_parametros.id_libro_bancos_fk is null) Then

               Select Coalesce((Select sum (ba.importe_cheque)
                      From tes.tts_libro_bancos ba
                      Where ba.id_libro_bancos_fk=lb.id_libro_bancos),0)
                   -
                      Coalesce((Select sum (ba.importe_deposito)
                      From tes.tts_libro_bancos ba
                      Where ba.id_libro_bancos_fk=lb.id_libro_bancos),0)
              Into g_saldo_deposito
              From tes.tts_libro_bancos lb
              Where lb.id_libro_bancos = v_parametros.id_libro_bancos;

              if(v_parametros.importe_deposito < g_saldo_deposito)then
              	raise exception 'El monto que intenta ingresar es menor a la suma de los cheques y depositos adicionales';
              end if;
            ELSE
                  Select (
                           Select li.importe_deposito
                           From tes.tts_libro_bancos li
                           Where li.id_libro_bancos = v_parametros.id_libro_bancos_fk
                         ) - Coalesce((
                                        Select sum(ba.importe_cheque)
                                        From tes.tts_libro_bancos ba
                                        Where ba.id_libro_bancos_fk = lb.id_libro_bancos_fk
                         ), 0) + Coalesce((
                                            Select sum(ba.importe_deposito)
                                            From tes.tts_libro_bancos ba
                                            Where ba.id_libro_bancos_fk = lb.id_libro_bancos_fk
                         ), 0) -
                         (
                           Select li.importe_deposito
                           From tes.tts_libro_bancos li
                           Where li.id_libro_bancos = v_parametros.id_libro_bancos
                         ) into g_saldo_deposito
                 From tes.tts_libro_bancos lb
                Where lb.id_libro_bancos = v_parametros.id_libro_bancos;

                IF ((v_parametros.importe_deposito + g_saldo_deposito) < 0) THEN
                	raise exception 'el saldo del deposito no puede ser menor a 0';
                END IF;
            END IF;

        End If; --fin de la verificacion de si es cheque, debito automatico o transferencia con carta

        --obtenemos la fecha antes de actualizarla
        Select lb.fecha, ew.verifica_documento, lb.sistema_origen
        Into g_fecha_ant, g_verifica_documento, g_origen
        From tes.tts_libro_bancos lb
        inner join wf.testado_wf ew on ew.id_estado_wf=lb.id_estado_wf
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
        id_finalidad = v_parametros.id_finalidad,
        comprobante_sigma = v_parametros.comprobante_sigma
		WHERE tes.tts_libro_bancos.id_libro_bancos = v_parametros.id_libro_bancos;

        if(g_verifica_documento = 'si')then
	        v_resp_doc = wf.f_verifica_documento(p_id_usuario,v_id_estado_wf);
    	end if;

		IF(v_parametros.tipo = 'deposito' and g_origen='KERP')THEN
        	UPDATE tes.tts_libro_bancos SET
            detalle = v_parametros.detalle,
            observaciones = v_parametros.observaciones
            WHERE id_libro_bancos_fk=v_parametros.id_libro_bancos;
        END IF;
        
        if(pxp.f_existe_parametro(p_tabla,'nro_deposito')=TRUE) then
        	UPDATE tes.tts_libro_bancos SET
            nro_deposito = v_parametros.nro_deposito
            WHERE id_libro_bancos=v_parametros.id_libro_bancos;
        end if;
		
		--#67
		--IF(v_parametros.tipo = 'cheque' and coalesce(v_parametros.id_proveedor,0)!=0) then
		   -- if exists (select 1 from param.tproveedor where id_proveedor=v_parametros.id_proveedor and tipo='institucion') then
			 /*  update param.tinstitucion set
			   email1=v_parametros.correo_proveedor
			   where id_institucion=(select id_institucion from param.tproveedor where id_proveedor=v_parametros.id_proveedor);
			else
  			   update segu.tpersona set
			   correo=v_parametros.correo_proveedor
			   where id_persona=(select id_persona from param.tproveedor where id_proveedor=v_parametros.id_proveedor);
			
			end if;*/
			
		--end if; 
        --#67
        if (v_parametros.tabla_correo='orga.tfuncionario') then --#67 04.11.2020
           /* update orga.tfuncionario
            set email_empresa=v_parametros.correo_proveedor
            where id_funcionario=v_parametros.id_columna_correo;*/
        elsif (v_parametros.tabla_correo='param.tproveedor') then
        	if exists (select 1 from param.tproveedor where id_proveedor=v_parametros.id_columna_correo and tipo='institucion') then
			   update param.tinstitucion set
			   email1=v_parametros.correo_proveedor
			   where id_institucion=(select id_institucion from param.tproveedor where id_proveedor=v_parametros.id_columna_correo);
			else
  			   update segu.tpersona set
			   correo=v_parametros.correo_proveedor
			   where id_persona=(select id_persona from param.tproveedor where id_proveedor=v_parametros.id_columna_correo);
			
			end if;
        end if;
        
        
        update tes.tts_libro_bancos 
        set correo=v_parametros.correo_proveedor
        where id_libro_bancos=v_parametros.id_libro_bancos;
        
        
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
            Select lb.estado, lb.id_int_comprobante, lb.num_tramite into g_estado_actual, g_id_int_comprobante, g_nro_tramite
            From tes.tts_libro_bancos lb
            where lb.id_libro_bancos=v_parametros.id_libro_bancos;

            IF g_id_int_comprobante is not null THEN
            	--raise exception 'No puede eliminar el cheque, esta relacionado al tramite %, debe crear otro cheque y relacionar a ese tramite', g_nro_tramite;
            END IF;

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
 	#TRANSACCION:  'TES_RELCHQ_IME'
 	#DESCRIPCION:	Relaciona cheque con tramite de otro cheque
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		06-07-2016 09:10:17
	***********************************/

	elsif(p_transaccion='TES_RELCHQ_IME')then

		begin
        	--cheque nuevo

            Select lb.id_int_comprobante, lb.num_tramite into g_id_int_comprobante, g_nro_tramite
            From tes.tts_libro_bancos lb
            where lb.id_libro_bancos=v_parametros.id_libro_bancos_new;

            IF g_id_int_comprobante is not null THEN
            	raise exception 'El cheque no es manual, el cheque esta asocicado al tramite %', g_nro_tramite;
            END IF;

        	--obtenermos del cheque anterior
            Select lb.id_int_comprobante, lb.num_tramite into g_id_int_comprobante, g_nro_tramite
            From tes.tts_libro_bancos lb
            where lb.id_libro_bancos=v_parametros.id_libro_bancos_old;

            IF g_id_int_comprobante is null THEN
            	raise exception 'No puede relacionar el cheque, el cheque del tramite %, no cuenta con un comprobante', g_nro_tramite;
            END IF;

            UPDATE tes.tts_libro_bancos
            SET id_int_comprobante=g_id_int_comprobante
            WHERE id_libro_bancos=v_parametros.id_libro_bancos_new;

            UPDATE tes.tts_libro_bancos
            SET id_int_comprobante=NULL
            WHERE id_libro_bancos=v_parametros.id_libro_bancos_old;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cheque relacionado');
            v_resp = pxp.f_agrega_clave(v_resp,'id_libro_bancos',v_parametros.id_libro_bancos_new::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

    /*********************************
 	#TRANSACCION:  'TES_SIGELB_IME'
 	#DESCRIPCION:	funcion que controla el cambio al Siguiente estado de los movimientos bancarios, integrado  con el WF
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		18-11-2014
	***********************************/

	elsif(p_transaccion='TES_SIGELB_IME')then
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
            lb.sistema_origen,
            lb.nro_cheque,
       		lb.tipo,
            lb.id_cuenta_bancaria,
            lb.fecha,
            lb.indice
            ,lb.correo --#67
        into
            v_id_libro_bancos,
            v_id_proceso_wf,
            v_codigo_estado,
            v_origen,
            v_nro_cheque,
            v_tipo,
            v_id_cuenta_bancaria,
            g_fecha,
            g_indice
            ,v_correo --#67
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

             --configurar acceso directo para la alarma
             v_acceso_directo = '';
             v_clase = '';
             v_parametros_ad = '';
             v_tipo_noti = '';
             v_titulo  = '';


             IF   v_codigo_estado_siguiente in('vbpagosindocumento')   THEN
                  v_acceso_directo = '../../../sis_workflow/vista/proceso_wf/VoBoProceso.php';
                  v_clase = 'VoBoProceso';
                  v_parametros_ad = '{filtro_directo:{campo:"lb.id_proceso_wf",valor:"'||v_id_proceso_wf::varchar||'"}}';
                  v_tipo_noti = 'notificacion';
                  v_titulo  = 'Visto Bueno';

             END IF;

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
                                                             --NULL,
                                                             v_acceso_directo,
                                                             --NULL,
                                                             v_clase,
                                                             --NULL,
                                                             v_parametros_ad,
                                                             --NULL,
                                                             v_tipo_noti,
                                                             --NULL);
                                                             v_titulo);
                                                          
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
          if((v_codigo_estado_siguiente in ('impreso', 'anulado','depositado')) or (v_tipo in('debito_automatico','transferencia_carta') and v_codigo_estado_siguiente='cobrado'))then

            SELECT LBRBAN.fecha,LBRBAN.id_cuenta_bancaria into g_fecha, v_id_cuenta_bancaria
            FROM tes.tts_libro_bancos LBRBAN
            WHERE LBRBAN.id_libro_bancos=v_id_libro_bancos;

            select ctaper.estado, per.periodo
            into v_estado, v_periodo
			from tes.tcuenta_bancaria_periodo ctaper
            inner join param.tperiodo per on per.id_periodo=ctaper.id_periodo
			where g_fecha between per.fecha_ini and per.fecha_fin
            and ctaper.id_cuenta_bancaria=v_id_cuenta_bancaria;

            if(v_estado!='abierto')then
            	raise exception 'El periodo % no se encuentra abierto',  pxp.f_obtener_literal_periodo(v_periodo,null);
            end if;
          end if;
          if(v_codigo_estado_siguiente='anulado')then
          	update tes.tts_libro_bancos  t set
             importe_cheque = 0,
             importe_deposito = 0,
             a_favor = 'ANULADO'
          	where id_libro_bancos = v_id_libro_bancos;
          end if;

          --VERIFICAMOS SI ES UN DEPOSITO, transferencia o debito automatico
         	IF(v_tipo in ('deposito','debito_automatico','transferencia_carta')) Then
				if(v_codigo_estado_siguiente in ('depositado','cobrado') AND g_indice IS NULL)then
                    --Obtenemos el numero de indice que sera asignado al nuevo registro
                    Select max(lb.indice)
                    Into g_indice
                    From tes.tts_libro_bancos lb
                    Where lb.id_cuenta_bancaria = v_id_cuenta_bancaria
                    and lb.fecha = g_fecha;

                    If(g_indice is null )Then
                        g_indice = 0;
                    end if;

                    UPDATE tes.tts_libro_bancos SET
                        indice = g_indice + 1
                    WHERE tes.tts_libro_bancos.id_libro_bancos= v_id_libro_bancos;
                end if;

         	ELSE  --si es CHEQUE

            	if(v_codigo_estado_siguiente ='impreso')then --solo pone indice cuando cambia de estado a impreso
                  --Obtenemos el numero de indice que sera asignado al nuevo registro
                  Select max(lb.nro_cheque)
                  Into g_max_nro_cheque
                  From tes.tts_libro_bancos lb
                  Where lb.id_cuenta_bancaria = v_id_cuenta_bancaria
                  and lb.fecha = g_fecha
                  and lb.tipo = 'cheque'
                  and lb.estado != 'borrador'
                  and lb.id_libro_bancos <> v_id_libro_bancos;

                  If(g_max_nro_cheque is null)Then

                      --Obtenemos el numero de indice que sera asignado al nuevo registro
                      Select max(lb.indice)
                      Into g_indice
                      From tes.tts_libro_bancos lb
                      Where lb.id_cuenta_bancaria = v_id_cuenta_bancaria
                      and lb.fecha = g_fecha;

                      If(g_indice is null )Then
                          g_indice = 0;
                      end if;

                      UPDATE tes.tts_libro_bancos SET
                          indice = g_indice + 1
                      WHERE tes.tts_libro_bancos.id_libro_bancos= v_id_libro_bancos;

                  else --hay cheques registrados ese dia
                      --comparamos el numero de cheque actual con el maximo de la fecha
                      IF(v_nro_cheque > g_max_nro_cheque) Then

                            --Obtenemos el numero de indice que sera asignado al nuevo registro
                            Select max(lb.indice)
                            Into g_indice
                            From tes.tts_libro_bancos lb
                            Where lb.id_cuenta_bancaria = v_id_cuenta_bancaria
                            and lb.fecha = g_fecha;

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
                                                        Where lb.id_cuenta_bancaria = '||v_id_cuenta_bancaria||'
                                                        and lb.fecha ='''||g_fecha||''' and lb.tipo=''cheque''
                                                        and lb.indice is not null and lb.estado!=''borrador''
                                                        order by lb.indice asc') LOOP
                                  /*g_indice = null;

                                  Select lib.indice
                                  Into g_indice
                                  From tes.tts_libro_bancos lib
                                  Where lib.id_libro_bancos = v_id_libro_bancos;
                                  */
                                  /*If(g_indice is null )Then
                                      g_indice = 0;
                                  end if;*/

                                  --Comparamos si el numero de cheque nuevo es menor al numero de cheque del ciclo
                                  If (v_nro_cheque < g_registros.nro_cheque) Then
                                      --actualizamos los indices de los registros superiores
                                      UPDATE tes.tts_libro_bancos SET
                                          indice = indice + 1
                                      Where tes.tts_libro_bancos.id_cuenta_bancaria = v_id_cuenta_bancaria
                                      and tes.tts_libro_bancos.fecha = g_fecha
                                      and tes.tts_libro_bancos.estado!='borrador'
                                      and tes.tts_libro_bancos.indice >= g_registros.indice;

                                      --asignamos el valor del indice del ciclo al registro nuevo
                                      UPDATE tes.tts_libro_bancos SET
                                          indice = g_registros.indice
                                      WHERE tes.tts_libro_bancos.id_libro_bancos= v_id_libro_bancos;
                                      exit;
                                  End IF;

                            END LOOP;

                        END IF; --fin comparacion numero de cheque

                    End if; --Fin comparacion del null en el maximo numero de cheque
             	end if; --fin siguiente estado impreso
        	END IF; --fin comparacion tipo

          if(v_codigo_estado_siguiente='cobrado' and v_tipo='transferencia_carta' and g_fecha is null)then
          	raise exception 'No se puede pasar al siguiente estado, registre fecha de la transferencia';
          end if;

          IF EXISTS (select 1
                     from tes.tts_libro_bancos lb
                     inner join cd.tcuenta_doc cd on cd.id_int_comprobante=lb.id_int_comprobante
                     where lb.id_libro_bancos=v_id_libro_bancos) THEN
          	if(v_codigo_estado_siguiente in ('entregado','cobrado'))then
          		UPDATE cd.tcuenta_doc
                SET fecha_entrega= current_date
                WHERE id_int_comprobante=(select id_int_comprobante
                 						  from tes.tts_libro_bancos
                                          where id_libro_bancos=v_id_libro_bancos);
          	end if;
          END IF;

          if(v_codigo_estado_siguiente='impreso')then
          	if(v_tipo='cheque' AND v_nro_cheque is null)then
            	raise exception 'No puede pasar al siguiente estado si no esta registrado el numero de cheque';
            end if;
            
            --02.09.2020
            if (v_correo is null or length(v_correo)=0) then
              raise exception 'No puede pasar al siguiente estado si no esta registrado el correo para la noificacion';
            end if;

            if(v_origen='FONDOS_AVANCE')then

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
          end if;
          -- si hay mas de un estado disponible  preguntamos al usuario
          v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado del libro bancos)');
          v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');


          -- Devuelve la respuesta
          return v_resp;

     end;


    /*********************************
 	#TRANSACCION:  'TES_ANTELB_IME'
 	#DESCRIPCION:	Transaccion utilizada  pasar a  estados anterior en el libro bancos segun la operacion definida
 	#AUTOR:		GSS
 	#FECHA:		13-01-2015
	***********************************/

	elsif(p_transaccion='TES_ANTELB_IME')then
        BEGIN
        	--------------------------------------------------
        	--Retrocede al estado inmediatamente anterior
       		-------------------------------------------------
       		--recuperaq estado anterior segun Log del WF


          SELECT LBRBAN.fecha, LBRBAN.id_cuenta_bancaria, LBRBAN.id_libro_bancos
          into g_fecha, v_id_cuenta_bancaria, v_id_libro_bancos
          FROM tes.tts_libro_bancos LBRBAN
          WHERE LBRBAN.id_estado_wf = v_parametros.id_estado_wf;

          IF EXISTS (select 1 from tes.tts_libro_bancos
          			 where id_libro_bancos_fk=v_id_libro_bancos
                     and estado not in ('borrador','transferido'))THEN
          	raise exception 'No puede retroceder tiene registros que no se encuentran en borrador';
          END IF;

          select ctaper.estado, per.periodo
          into v_estado, v_periodo
          from tes.tcuenta_bancaria_periodo ctaper
          inner join param.tperiodo per on per.id_periodo=ctaper.id_periodo
          where g_fecha between per.fecha_ini and per.fecha_fin
          and ctaper.id_cuenta_bancaria=v_id_cuenta_bancaria;

          if(v_estado!='abierto')then
              raise exception 'El periodo % no se encuentra abierto',  pxp.f_obtener_literal_periodo(v_periodo,null);
          end if;

          SELECT
             ps_id_tipo_estado,
             ps_id_funcionario,
             ps_id_usuario_reg,
             ps_id_depto,
             ps_codigo_estado,
             ps_id_estado_wf_ant
          INTO
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

           IF  NOT tes.f_fun_regreso_libro_bancos_wf(p_id_usuario,
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

    /*********************************
 	#TRANSACCION:  'TES_TRALB_IME'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		09-02-2015
	***********************************/

	elsif(p_transaccion='TES_TRALB_IME')then

		BEGIN
        	if(pxp.f_existe_parametro(p_tabla,'tipo')=FALSE) then
            	raise exception '%', 'No se definio el tipo de transaccion';
            end if;

            if(pxp.f_existe_parametro(p_tabla,'id_libro_bancos')=FALSE) then
            	raise exception '%', 'No se definio el deposito origen a ser transferido';
            end if;

			if(pxp.f_existe_parametro(p_tabla,'id_libro_bancos_fk')=FALSE) then
            	raise exception '%', 'No se definio el deposito destino de la transferencia';
            end if;

        	if(v_parametros.tipo='total')then
            	-- es una transferencia del total
                select lb.id_libro_bancos_fk into g_id_libro_bancos_fk
                from tes.tts_libro_bancos lb
                where lb.id_libro_bancos=v_parametros.id_libro_bancos;

                if(g_id_libro_bancos_fk is null) then
                	--todos los cheques y depositos adicionales del deposito origen pasaran el deposito destino
                	UPDATE tes.tts_libro_bancos
                    SET id_libro_bancos_fk = v_parametros.id_libro_bancos_fk
                    WHERE id_libro_bancos_fk=v_parametros.id_libro_bancos;
                else
                	--es transferencia de un deposito adicional
                    select lbp.saldo_deposito, lb.importe_deposito into g_saldo_deposito, g_importe_deposito
                	from tes.tts_libro_bancos lb
                	inner join tes.vlibro_bancos lbp on lbp.id_libro_bancos=lb.id_libro_bancos_fk
                	where lb.id_libro_bancos=v_parametros.id_libro_bancos;

                    IF(g_saldo_deposito - g_importe_deposito < 0)THEN
                    	raise exception 'No se puede hacer la transferencia, ya que el saldo seria menor a cero';
                	END IF;

                end if;

                UPDATE tes.tts_libro_bancos
                SET id_libro_bancos_fk = v_parametros.id_libro_bancos_fk
                WHERE id_libro_bancos = v_parametros.id_libro_bancos;

            else
            	-- es una transferencia de saldo
                select lbp.saldo_deposito into g_saldo_deposito
                from tes.vlibro_bancos lbp
                where lbp.id_libro_bancos=v_parametros.id_libro_bancos;

                if(v_parametros.tipo='parcial')then
            		g_importe_transferencia = v_parametros.importe_transferencia;
                else
                	g_importe_transferencia = g_saldo_deposito;
                end if;

                select lb.id_cuenta_bancaria, COALESCE(lb.id_depto, dp.id_depto) as id_depto, lb.fecha, lb.a_favor, lb.nro_cheque, lb.saldo_deposito,
				lb.nro_liquidacion, lb.detalle, lb.origen, lb.observaciones, lb.nro_comprobante, lb.tipo,
                lb.id_finalidad, lb.comprobante_sigma into g_libro_bancos
				from tes.vlibro_bancos lb
                left join param.tdepto dp on ('OP - ' || lb.origen)= dp.nombre_corto
				where lb.id_libro_bancos=v_parametros.id_libro_bancos;

                --inserta transferencia interna haber
                create temporary table tt_parametros_libro_bancos_deposito(
                _id_usuario_ai int4, _nombre_usuario_ai varchar, id_cuenta_bancaria int4,
                id_depto int4, fecha date, a_favor varchar, nro_cheque int4, importe_deposito
                numeric, nro_liquidacion varchar, detalle text, origen varchar, observaciones
                text, importe_cheque numeric, id_libro_bancos_fk int4, nro_comprobante varchar,
                 tipo varchar, id_finalidad int4, comprobante_sigma varchar) on commit drop;

                 insert into tt_parametros_libro_bancos_deposito
                 values (NULL, 'NULL', g_libro_bancos.id_cuenta_bancaria, g_libro_bancos.id_depto, now()::date,
                 g_libro_bancos.a_favor, null, g_importe_transferencia,g_libro_bancos.nro_liquidacion,
                 g_libro_bancos.detalle,g_libro_bancos.origen, g_libro_bancos.observaciones, 0, v_parametros.id_libro_bancos_fk,
                 g_libro_bancos.nro_comprobante, 'transf_interna_haber',g_libro_bancos.id_finalidad,g_libro_bancos.comprobante_sigma);


                 v_resp = tes.ft_ts_libro_bancos_ime (
 				 p_administrador,
  				 p_id_usuario,
  				 'tt_parametros_libro_bancos_deposito',
  				 'TES_LBAN_INS');

                 --insertar transferencia interna debe
                create temporary table tt_parametros_libro_bancos_cheque(
                _id_usuario_ai int4, _nombre_usuario_ai varchar, id_cuenta_bancaria int4,
                id_depto int4, fecha date, a_favor varchar, nro_cheque int4, importe_deposito
                numeric, nro_liquidacion varchar, detalle text, origen varchar, observaciones
                text, importe_cheque numeric, id_libro_bancos_fk int4, nro_comprobante varchar,
                 tipo varchar, id_finalidad int4, comprobante_sigma varchar) on commit drop;

                 insert into tt_parametros_libro_bancos_cheque
                 values (NULL, 'NULL', g_libro_bancos.id_cuenta_bancaria, g_libro_bancos.id_depto, now()::date,
                 g_libro_bancos.a_favor, null, 0 ,g_libro_bancos.nro_liquidacion, g_libro_bancos.detalle,
                 g_libro_bancos.origen, g_libro_bancos.observaciones, g_importe_transferencia,
                 v_parametros.id_libro_bancos, g_libro_bancos.nro_comprobante, 'transf_interna_debe',
                 g_libro_bancos.id_finalidad, g_libro_bancos.comprobante_sigma);

                 v_resp = tes.ft_ts_libro_bancos_ime (
 				 p_administrador,
  				 p_id_usuario,
  				 'tt_parametros_libro_bancos_cheque',
  				 'TES_LBAN_INS');

            end if;

            -- definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo la transferencia de deposito)');
            v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');

            --Devuelve la respuesta
            return v_resp;

        END;

    /*********************************
 	#TRANSACCION:  'TES_DEVRET_IME'
 	#DESCRIPCION:	Fondos para Devoluciones y Retenciones
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		30-05-2016
	***********************************/

	elsif(p_transaccion='TES_DEVRET_IME')then

		BEGIN
        	IF v_parametros.operacion = 'colocar' THEN

                UPDATE tes.tts_libro_bancos
                SET fondo_devolucion_retencion = 'si'
                WHERE id_libro_bancos = v_parametros.id_libro_bancos;

            ELSE

            	UPDATE tes.tts_libro_bancos
                SET fondo_devolucion_retencion = 'no'
                WHERE id_libro_bancos = v_parametros.id_libro_bancos;

            END IF;

            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo la asignacion como fondo de devolucion o retencion');
            v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');


            -- Devuelve la respuesta
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
PARALLEL UNSAFE
COST 100;