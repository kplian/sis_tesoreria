<?php
/**
*@package pXP
*@file gen-MODCaja.php
*@author  (admin)
*@date 16-12-2013 20:43:44
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODCuentaDocumentadaEndesis extends MODbase{
	
	function __construct(CTParametro $pParam){
		
		parent::__construct($pParam);
	}
			
	function listarFondoAvance() {		
		
		$parametros_consulta = $this->aParam->getParametrosconsulta();
		$ordenacion = $parametros_consulta['ordenacion'] . ' ' . $parametros_consulta['dir_ordenacion'];
		$filtro = $parametros_consulta['filtro'];
		$dir_ordenacion = $parametros_consulta['dir_ordenacion'];
		$puntero = $parametros_consulta['puntero'];
		$cantidad = $parametros_consulta['cantidad'];
		$id_usuario = $_SESSION["ss_id_usuario"];
		$ip = $_SERVER['REMOTE_ADDR'];
		
		$query = "SELECT * 
		FROM tesoro.f_tts_cuenta_doc_sel($id_usuario, '$ip', '00:19:d1:09:22:7e', 'TS_SOLVIA2_SEL', NULL,
		 $cantidad, $puntero, '$ordenacion', '$dir_ordenacion', '$filtro', NULL, NULL, NULL, NULL, NULL, 'pendiente_aprobacion') AS func(
		 id_cuenta_doc int4,
		 id_presupuesto int4,
		 desc_presupuesto text,		 
		  id_empleado int4,
		  desc_empleado text,
		  id_categoria int4,
		  desc_categoria varchar,
		  fecha_ini date,
		  fecha_fin date,
		  tipo_pago varchar,
		  tipo_contrato varchar,
		  id_usuario_rendicion int4,
		  desc_usuario text,
		  estado varchar,
		  nro_documento varchar,
		  fecha_reg date,
		  motivo varchar,
		  recorrido varchar,
		  observaciones varchar,
		  id_depto int4,
		  desc_depto varchar,
		  id_moneda int4,
		  desc_moneda varchar,
		  fecha_sol date,
		  fa_solicitud varchar,
		  id_caja int4,
		  desc_caja varchar,
		  id_cajero int4,
		  desc_cajero varchar,		  
		  importe numeric,
		  id_parametro int4,
		  desc_parametro numeric,
		  resp_registro text,
			tipo_pago_fin varchar,
		   id_cuenta_bancaria integer,
		   id_cuenta_bancaria_fin integer, 
		   id_caja_fin integer,
		   id_cajero_fin integer,
		   nro_deposito varchar,
		   desc_cuenta_bancaria_fin varchar,
		   desc_caja_fin varchar,
		   desc_cajero_fin varchar,
		   id_autorizacion int4,
		   desc_autorizacion text,
		   nombre_cheque varchar,
		   nro_cheque text,		   
		   tipo_cuenta_doc varchar,
		   fk_id_cuenta_doc integer,
		   id_usuario_reg integer,
		   id_comprobante integer,
		   nro_dias_para_rendir integer,
		   fecha_aut_rendicion timestamp,
		   cant_rend_registradas bigint,
		   cant_rend_finalizadas bigint,
		   cant_rend_contabilizadas bigint,		   
		   codigo_caja varchar,  
		   respuesta_aprobador text, 
		   saldo_solicitante numeric,		   
		   importe_detalle numeric,
		   id_presupuesto_detalle integer, 	   
		   saldo_rendiciones numeric,
		   saldo_retenciones numeric,
		   saldo_depositar numeric
		 );";
		 
		 $query_count = "SELECT * FROM tesoro.f_tts_cuenta_doc_sel($id_usuario,'$ip','00:19:d1:09:22:7e','TS_SOLVIA2_COUNT',NULL,
		  $cantidad, $puntero, '$ordenacion', '$dir_ordenacion', '$filtro','%','%','%','%','%','pendiente_aprobacion') AS (total bigint)";
		
		try {
			
			//crear conexion pdo		 
	        $cone=new conexion();			
			$link = $cone->conectarpdo('ENDESIS');
			
			$link->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);	
				
		  	$link->beginTransaction();
		  	$link->exec("set names 'UTF8'");			
			$stmt = $link->prepare($query);
			$stmt->execute();			
			$data = $stmt->fetchAll(PDO::FETCH_ASSOC);	
			$stmt = $link->prepare($query_count);
			$stmt->execute();
			$count = $stmt->fetchColumn(0);
							
			$link->commit();
						
			$this->respuesta=new Mensaje();			
			$this->respuesta->setMensaje('EXITO',$this->nombre_archivo,'Consulta de FA ejecutada con exito','Consulta de FA ejecutada con exito','base','tesoro.f_tts_cuenta_doc_sel(Endesis)','TS_SOLVIA2_SEL','SEL','');
			$this->respuesta->setDatos($data);
			$this->respuesta->setTotal($count);
			
		} catch (Exception $e) {
							
		    $this->respuesta=new Mensaje();		
		    $this->respuesta->setMensaje('ERROR',$this->nombre_archivo,$e->getMessage(),$e->getMessage(),'base','tesoro.f_tts_cuenta_doc_sel(Endesis)','TS_SOLVIA2_SEL','SEL','');			
		}			
        return $this->respuesta;
		
  
	}
	function aprobarFondoAvance() {
		$separador = "#@@@#";
		$id_usuario = $_SESSION["ss_id_usuario"];
		$ip = $_SERVER['REMOTE_ADDR'];
		$filtro = $this->aParam->getParametro('filtro');
		$accion = $this->aParam->getParametro('accion');
		
		if ($accion == 'aprobar') {
			$transaccion = 'TS_APRSOLPAGCD_UPD';
		} else {
			$transaccion = 'TS_RECHSOLPAGCD_UPD';
		}
		$id_cuenta_documentada = $this->aParam->getParametro('id_cuenta_documentada');
		$observaciones = $this->aParam->getParametro('mensaje');
		
		$query = "SELECT tesoro.f_tts_cuenta_doc_iud ($id_usuario,'$ip',
								'SELECT tesoro.f_tts_cuenta_doc_iud ($id_usuario,''$ip'',''00:19:d1:09:22:7e'',''$transaccion'',NULL,$id_cuenta_documentada,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,''$observaciones'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)',
								'$transaccion',NULL,$id_cuenta_documentada,NULL,NULL,NULL,NULL,NULL,NULL,
								NULL,NULL,NULL,NULL,'$observaciones',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
								NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)";
								
		
		$query_correos = "	select 
							(case when int.id_item_suplente is not null THEN
								aut_sup.email2
							else
                            	aut.email2
							end)as email_autorizacion,
                            (case when int.id_item_suplente is not null THEN
								COALESCE(aut_sup.nombre,'')||' '||COALESCE(aut_sup.apellido_paterno,'')||' '||COALESCE(aut_sup.apellido_materno,'')
							else
                            	COALESCE(aut.nombre,'')||' '||COALESCE(aut.apellido_paterno,'')||' '||COALESCE(aut.apellido_materno,'')
							end) as nombre_autorizacion,
				             
				            
				            coalesce (em.email2,'gvelasquez@boa.bo')::varchar as email_jefe, 
				            COALESCE(em.nombre,'')||' '||COALESCE(em.apellido_paterno,'')||' '||COALESCE(em.apellido_materno,'') as nombre_jefe,
				            sol.nombre_completo as nombre_solicitante,
				            sol.email2 as email_solicitante,
                            usu.email2 as email_tesoreria,
                            COALESCE(usu.nombre,'')||' '||COALESCE(usu.apellido_paterno,'')||' '||COALESCE(usu.apellido_materno,'') as nombre_tesoreria,
				            un.nombre_unidad,
				            cd.motivo,
				            cd.observaciones,
				            cd.importe         
				            from tesoro.tts_cuenta_doc cd
				            inner join kard.vkp_empleado sol on sol.id_empleado=cd.id_empleado
				            inner join kard.vkp_empleado aut on aut.id_empleado=cd.id_autorizacion
                            inner join kard.tkp_historico_asignacion ha_aut on ha_aut.id_empleado = aut.id_empleado 
                            											and ha_aut.estado_reg != 'eliminado' and ha_aut.fecha_asignacion <= now() AND
                                                                        (ha_aut.fecha_finalizacion >= now() or ha_aut.fecha_finalizacion is null)
                            left join kard.tkp_interinato int
                            	on ha_aut.id_item = int.id_item_titular and int.fecha_ini<=now() and int.fecha_fin>=now()
                            left join kard.tkp_historico_asignacion ha_sup on int.id_item_suplente = ha_sup.id_item
                            				           					and ha_sup.estado_reg != 'eliminado' and ha_sup.fecha_asignacion <= now() AND
                                                                        (ha_sup.fecha_finalizacion >= now() or ha_sup.fecha_finalizacion is null)
                            left join kard.vkp_empleado aut_sup on aut_sup.id_empleado = ha_sup.id_empleado
				            inner join presto.tpr_presupuesto pre on pre.id_presupuesto=cd.id_presupuesto
				            inner join kard.tkp_unidad_organizacional un on un.id_unidad_organizacional=pre.id_unidad_organizacional
				            left join kard.tkp_historico_asignacion ha on (ha.id_unidad_organizacional=un.id_unidad_organizacional and now() BETWEEN ha.fecha_asignacion and COALESCE(ha.fecha_finalizacion, now()))
				            left join kard.vkp_empleado em on em.id_empleado=ha.id_empleado
				            left join param.tpm_depto_usuario  dus on dus.id_depto = cd.id_depto and 
                            	dus.cargo = 'Responsable de Tesoreria'
                            left join sss.vss_usuario usu on usu.id_usuario = dus.id_usuario       
				            where cd.id_cuenta_doc=$id_cuenta_documentada;";
				            
		$query_count = "SELECT * FROM tesoro.f_tts_cuenta_doc_sel($id_usuario,'$ip','00:19:d1:09:22:7e','TS_SOLVIA2_COUNT',NULL,
		  0, 0, '', '', '$filtro','%','%','%','%','%','pendiente_aprobacion') AS (total bigint)";
		 try {
			
			//crear conexion pdo		 
	        $cone=new conexion();			
			$link = $cone->conectarpdo('ENDESIS');
			
			$link->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);	
				
		  	$link->beginTransaction();
		  	$link->exec("set names 'UTF8'");
					
			$stmt = $link->prepare($query);
			
			//validar si hubo un error lanzar una excepcion
			$stmt->execute();	
			$data = $stmt->fetchAll(PDO::FETCH_ASSOC);
			
			
			$res = $data[0]['f_tts_cuenta_doc_iud'];
			
			$res_array = explode($separador, $res);
			if ($res_array[0]=='f') {				
				throw new Exception($res_array[1], 2);
			}
			
			$stmt = $link->prepare($query_correos);
			
			
			//si hubo uin error lanzar una excepcion
			$stmt->execute();
			$data = $stmt->fetchAll(PDO::FETCH_ASSOC);
			if (count($data) == 0) {
				throw new Exception("No se pudo obtener información para enviar los correos desde Endesis", 2);
			}
			
			$stmt = $link->prepare($query_count);
			$stmt->execute();
			$count = $stmt->fetchColumn(0);
							
			$link->commit();
						
			$this->respuesta=new Mensaje();			
			$this->respuesta->setMensaje('EXITO',$this->nombre_archivo,'Consulta de FA ejecutada con exito','Consulta de FA ejecutada con exito','base','tesoro.f_tts_cuenta_doc_iud(Endesis)','TS_APRSOLPAGCD_UPD','SEL','');
			$this->respuesta->setDatos($data);
			$this->respuesta->setTotal($count);
			
		} catch (Exception $e) {
							
		    $this->respuesta=new Mensaje();		
		    $this->respuesta->setMensaje('ERROR',$this->nombre_archivo,$e->getMessage(),$e->getMessage(),'base','tesoro.f_tts_cuenta_doc_iud(Endesis)',$transaccion,'IME','');			
		}
		return $this->respuesta;
	}

	function listarFondoAvance2() {		
		
		$parametros_consulta = $this->aParam->getParametrosconsulta();
		$ordenacion = $parametros_consulta['ordenacion'] . ' ' . $parametros_consulta['dir_ordenacion'];
		$filtro = $parametros_consulta['filtro'];
		$dir_ordenacion = $parametros_consulta['dir_ordenacion'];
		$puntero = $parametros_consulta['puntero'];
		$cantidad = $parametros_consulta['cantidad'];
		$id_usuario = 1;
		$ip = $_SERVER['REMOTE_ADDR'];
		
		$query = "SELECT * 
		FROM tesoro.f_tts_cuenta_doc_sel($id_usuario, '$ip', '00:19:d1:09:22:7e', 'TS_APRSOLPAGCD_UPD', NULL,
		 $cantidad, $puntero, '$ordenacion', '$dir_ordenacion', '$filtro', NULL, NULL, NULL, NULL, NULL, NULL) AS func(
		 id_cuenta_doc int4,
		 id_presupuesto int4,
		 desc_presupuesto text,		 
		  id_empleado int4,
		  desc_empleado text,
		  id_categoria int4,
		  desc_categoria varchar,
		  fecha_ini date,
		  fecha_fin date,
		  tipo_pago varchar,
		  tipo_contrato varchar,
		  id_usuario_rendicion int4,
		  desc_usuario text,
		  estado varchar,
		  nro_documento varchar,
		  fecha_reg date,
		  motivo varchar,
		  recorrido varchar,
		  observaciones varchar,
		  id_depto int4,
		  desc_depto varchar,
		  id_moneda int4,
		  desc_moneda varchar,
		  fecha_sol date,
		  fa_solicitud varchar,
		  id_caja int4,
		  desc_caja varchar,
		  id_cajero int4,
		  desc_cajero varchar,		  
		  importe numeric,
		  id_parametro int4,
		  desc_parametro numeric,
		  resp_registro text,
			tipo_pago_fin varchar,
		   id_cuenta_bancaria integer,
		   id_cuenta_bancaria_fin integer, 
		   id_caja_fin integer,
		   id_cajero_fin integer,
		   nro_deposito varchar,
		   desc_cuenta_bancaria_fin varchar,
		   desc_caja_fin varchar,
		   desc_cajero_fin varchar,
		   id_autorizacion int4,
		   desc_autorizacion text,
		   nombre_cheque varchar,
		   nro_cheque text,		   
		   tipo_cuenta_doc varchar,
		   fk_id_cuenta_doc integer,
		   id_usuario_reg integer,
		   id_comprobante integer,
		   nro_dias_para_rendir integer,
		   fecha_aut_rendicion timestamp,
		   cant_rend_registradas bigint,
		   cant_rend_finalizadas bigint,
		   cant_rend_contabilizadas bigint,		   
		   codigo_caja varchar,   
		   saldo_solicitante numeric,		   
		   importe_detalle numeric,
		   id_presupuesto_detalle integer, 	   
		   saldo_rendiciones numeric,
		   saldo_retenciones numeric,
		   saldo_depositar numeric
		 );";
		 
		 $query_count = "SELECT * FROM tesoro.f_tts_cuenta_doc_sel($id_usuario,'$ip','00:19:d1:09:22:7e','TS_SOLVIA2_COUNT',NULL,
		  $cantidad, $puntero, '$ordenacion', '$dir_ordenacion', '$filtro','%','%','%','%','%',NULL) AS (total bigint)";
		
		try {
			
			//crear conexion pdo		 
	        $cone=new conexion();			
			$link = $cone->conectarpdo('ENDESIS');
			
			$link->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);	
				
		  	$link->beginTransaction();
		  	$link->exec("set names 'UTF8'");			
			$stmt = $link->prepare($query);
			$stmt->execute();			
			$data = $stmt->fetchAll(PDO::FETCH_ASSOC);	
			$stmt = $link->prepare($query_count);
			$stmt->execute();
			$count = $stmt->fetchColumn(0);
							
			$link->commit();
						
			$this->respuesta=new Mensaje();			
			$this->respuesta->setMensaje('EXITO',$this->nombre_archivo,'Consulta de FA ejecutada con exito','Consulta de FA ejecutada con exito','base','tesoro.f_tts_cuenta_doc_sel(Endesis)','TS_SOLVIA2_SEL','SEL','');
			$this->respuesta->setDatos($data);
			$this->respuesta->setTotal($count);
			
		} catch (Exception $e) {
							
		    $this->respuesta=new Mensaje();		
		    $this->respuesta->setMensaje('ERROR',$this->nombre_archivo,$e->getMessage(),$e->getMessage(),'base','tesoro.f_tts_cuenta_doc_sel(Endesis)','TS_SOLVIA2_SEL','SEL','');			
		}			
        return $this->respuesta;
		
  
	}

	
			
	
			
}
?>