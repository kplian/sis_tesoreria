<?php
/*
***************************************************************************
  ISSUE    SIS   	EMPRESA     FECHA           AUTOR               DESCRIPCION
  #29      TES 		ETR     	01/04/2019      MANUEL GUERRA       el inmediato superior sera responsable de los funcionarios inactivos
  #61	   TES		ETR 	  	01/08/2019	    RCM 	      		Actualizacion PHP 7 problema Count
 ***************************************************************************
*/
require_once(dirname(__FILE__).'/../../pxp/pxpReport/ReportWriter.php');
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');
require_once(dirname(__FILE__).'/../reportes/RSolicitudEfectivo.php');
require_once(dirname(__FILE__).'/../reportes/RReciboEntrega.php');
require_once(dirname(__FILE__).'/../reportes/RRendicionEfectivo.php');

class ACTSolicitudEfectivo extends ACTbase{

	function listarSolicitudEfectivo(){
		$this->objParam->defecto('ordenacion','id_solicitud_efectivo');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('tipo_interfaz')=='ConDetalle')
		{
			$this->objParam-> addFiltro("caja.tipo_ejecucion = ''con_detalle''");
		}

		if($this->objParam->getParametro('tipo_interfaz')=='SinDetalle')
		{
			$this->objParam-> addFiltro("caja.tipo_ejecucion = ''sin_detalle''");

			if($this->objParam->getParametro('pes_estado')=='borrador'){
				 $this->objParam->addFiltro("solefe.estado in (''borrador'')");
			}
			if($this->objParam->getParametro('pes_estado')=='iniciado'){
				$this->objParam->addFiltro("solefe.estado in (''vbjefe'',''vbcajero'',''vbfin'')");
			}
			if($this->objParam->getParametro('pes_estado')=='entregado'){
				 $this->objParam->addFiltro("solefe.estado in (''entregado'')");
			}
			if($this->objParam->getParametro('pes_estado')=='finalizado'){
				 $this->objParam->addFiltro("solefe.estado in (''finalizado'')");
				 //$this->objParam-> addFiltro('ge.id_gestion ='.$this->objParam->getParametro('id_gestion'));
			}
		}

		if($this->objParam->getParametro('id_caja')!='')
		{
			if($this->objParam->getParametro('tipo_interfaz')=='efectivoCaja'){
				$this->objParam-> addFiltro('solefe.id_caja ='.$this->objParam->getParametro('id_caja'));
				$this->objParam-> addFiltro('solefe.id_solicitud_efectivo_fk is null');
			}else{
				$this->objParam-> addFiltro('ren.id_caja ='.$this->objParam->getParametro('id_caja'));
			}
		}

		if($this->objParam->getParametro('id_solicitud_efectivo')!='')
		{
			$this->objParam-> addFiltro('solefe.fk_id_solicitud_efectivo ='.$this->objParam->getParametro('id_solicitud_efectivo'));
		}

		if($this->objParam->getParametro('id_solicitud_efectivo_fk')!='')
		{
			$this->objParam-> addFiltro('solefe.id_solicitud_efectivo_fk ='.$this->objParam->getParametro('id_solicitud_efectivo_fk'));
		}

		if($this->objParam->getParametro('filtro_campo')!=''){
			$this->objParam->addFiltro($this->objParam->getParametro('filtro_campo')." = ".$this->objParam->getParametro('filtro_valor'));
		}

		$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]);

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODSolicitudEfectivo','listarSolicitudEfectivo');
		} else{
			$this->objFunc=$this->create('MODSolicitudEfectivo');

			$this->res=$this->objFunc->listarSolicitudEfectivo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}




    function listarSolicitudIngreso(){
		$this->objParam->defecto('ordenacion','id_solicitud_efectivo');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('tipo_interfaz')=='ingreso_caja')
		{
			$this->objParam-> addFiltro("caja.tipo_ejecucion = ''sin_detalle''");

			if($this->objParam->getParametro('pes_estado')=='borrador'){
				 $this->objParam->addFiltro("solefe.estado in (''borrador'')");
			}
			if($this->objParam->getParametro('pes_estado')=='iniciado'){
				$this->objParam->addFiltro("solefe.estado in (''vbjefe'',''vbcajero'',''vbfin'')");
			}

			if($this->objParam->getParametro('pes_estado')=='finalizado'){
				 $this->objParam->addFiltro("solefe.estado in (''ingresado'')");
			}
		}


		if($this->objParam->getParametro('id_caja')!='')
		{
			if($this->objParam->getParametro('tipo_interfaz')=='efectivoCaja'){
				$this->objParam-> addFiltro('solefe.id_caja ='.$this->objParam->getParametro('id_caja'));
				$this->objParam-> addFiltro('solefe.id_solicitud_efectivo_fk is null');
			}else{
				$this->objParam-> addFiltro('ren.id_caja ='.$this->objParam->getParametro('id_caja'));
			}
		}

		if($this->objParam->getParametro('id_solicitud_efectivo')!='')
		{
			$this->objParam-> addFiltro('solefe.fk_id_solicitud_efectivo ='.$this->objParam->getParametro('id_solicitud_efectivo'));
		}
		//
		/*ssif($this->objParam->getParametro('id_gestion')!='')
		{
			$this->objParam-> addFiltro('ge.id_gestion ='.$this->objParam->getParametro('id_gestion'));
		}*/
		//
		if($this->objParam->getParametro('id_solicitud_efectivo_fk')!='')
		{
			$this->objParam-> addFiltro('solefe.id_solicitud_efectivo_fk ='.$this->objParam->getParametro('id_solicitud_efectivo_fk'));
		}

		if($this->objParam->getParametro('filtro_campo')!=''){
			$this->objParam->addFiltro($this->objParam->getParametro('filtro_campo')." = ".$this->objParam->getParametro('filtro_valor'));
		}

		$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]);

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODSolicitudEfectivo','listarSolicitudIngreso');
		} else{
			$this->objFunc=$this->create('MODSolicitudEfectivo');

			$this->res=$this->objFunc->listarSolicitudIngreso($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}


	function insertarSolicitudEfectivo(){
		$this->objFunc=$this->create('MODSolicitudEfectivo');
		if($this->objParam->insertar('id_solicitud_efectivo')){
			$this->res=$this->objFunc->insertarSolicitudEfectivo($this->objParam);
		} else{
			$this->res=$this->objFunc->modificarSolicitudEfectivo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function eliminarSolicitudEfectivo(){
			$this->objFunc=$this->create('MODSolicitudEfectivo');
		$this->res=$this->objFunc->eliminarSolicitudEfectivo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function siguienteEstadoSolicitudEfectivo(){
			$this->objFunc=$this->create('MODSolicitudEfectivo');
		$this->res=$this->objFunc->siguienteEstadoSolicitudEfectivo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function anteriorEstadoSolicitudEfectivo(){
			$this->objFunc=$this->create('MODSolicitudEfectivo');
		$this->res=$this->objFunc->anteriorEstadoSolicitudEfectivo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function insertarSolicitudEfectivoCompleta(){
		//$this->objParam->addParametro('tipo_solicitud','solicitud');
		$this->objFunc=$this->create('MODSolicitudEfectivo');
		if($this->objParam->insertar('id_solicitud_efectivo')){
			$this->res=$this->objFunc->insertarSolicitudEfectivoCompleta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function devolucionSolicitudEfectivo(){
		$this->objFunc=$this->create('MODSolicitudEfectivo');
		$this->res=$this->objFunc->devolucionSolicitudEfectivo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function ampliarDiasRendicion(){
		$this->objFunc=$this->create('MODSolicitudEfectivo');
		$this->res=$this->objFunc->ampliarDiasRendicion($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function reporteSolicitudEfectivo($create_file=false, $onlyData = false){
		$dataSource = new DataSource();
		//captura datos de firma
		if ($this->objParam->getParametro('firmar') == 'si') {
			$firmar = 'si';
			$fecha_firma = $this->objParam->getParametro('fecha_firma');
			$usuario_firma = $this->objParam->getParametro('usuario_firma');
		} else {
			$firmar = 'no';
			$fecha_firma = '';
			$usuario_firma = '';
		}

		if($this->objParam->getParametro('id_proceso_wf')!='')
		{
			$this->objParam-> addFiltro('solefe.id_proceso_wf ='.$this->objParam->getParametro('id_proceso_wf'));
		}

		$this->objParam->addParametroConsulta('ordenacion','id_solicitud_efectivo');
		$this->objParam->addParametroConsulta('dir_ordenacion','ASC');
		$this->objParam->addParametroConsulta('cantidad',1000);
		$this->objParam->addParametroConsulta('puntero',0);

		$this->objFunc = $this->create('MODSolicitudEfectivo');

		$resultSolicitud = $this->objFunc->reporteSolicitudEfectivo();

		$datosSolicitud = $resultSolicitud->getDatos();

		//armamos el array parametros y metemos ahi los data sets de las otras tablas
		$dataSource->putParameter('codigo', $datosSolicitud[0]['codigo']);
		$dataSource->putParameter('monto', $datosSolicitud[0]['monto']);
		$dataSource->putParameter('moneda', $datosSolicitud[0]['moneda']);
		$dataSource->putParameter('codigo_moneda', $datosSolicitud[0]['codigo_moneda']);
		$dataSource->putParameter('monto_literal', $datosSolicitud[0]['monto_literal']);
		$dataSource->putParameter('nro_tramite', $datosSolicitud[0]['nro_tramite']);
		$dataSource->putParameter('estado', $datosSolicitud[0]['estado']);
		$dataSource->putParameter('desc_funcionario', $datosSolicitud[0]['desc_funcionario']);
		$dataSource->putParameter('motivo', $datosSolicitud[0]['motivo']);
		$dataSource->putParameter('fecha', $datosSolicitud[0]['fecha']);
		$dataSource->putParameter('vbjefe', $datosSolicitud[0]['vbjefe']);
		$dataSource->putParameter('vbfinanzas', $datosSolicitud[0]['vbfinanzas']);

		//get detalle
    //Reset all extra params:
    $this->objParam->defecto('ordenacion', 'id_solicitud_efectivo_det');
    $this->objParam->defecto('cantidad', 1000);
    $this->objParam->defecto('puntero', 0);

    $modSolicitudEfecitovDet = $this->create('MODSolicitudEfectivoDet');
    //lista el detalle de la solicitud
    $resultSolicitudEfectivoDet = $modSolicitudEfecitovDet->listarSolicitudEfectivoDet();

	//agrupa el detalle de la solcitud por centros de costos y partidas
    $solicitudEfectivoDetAgrupado = $this->groupArray($resultSolicitudEfectivoDet->getDatos(), 'desc_ingas','codigo_cc', $datosSolicitud[0]['id_moneda'],$datosSolicitud[0]['estado'],$onlyData);
    //var_dump($solicitudEfectivoDetAgrupado); exit;

    $solicitudEfectivoDetDataSource = new DataSource();
    $solicitudEfectivoDetDataSource->setDataSet($solicitudEfectivoDetAgrupado);

	//inserta el detalle de la solicitud como origen de datos
    $dataSource->putParameter('detalleDataSource', $solicitudEfectivoDetDataSource);

		if ($onlyData){

			return $dataSource;
		}
		$nombreArchivo = uniqid(md5(session_id()).'SolicitudEfectivo') . '.pdf';
		$this->objParam->addParametro('orientacion','P');
		$this->objParam->addParametro('tamano','LETTER');
		$this->objParam->addParametro('titulo_archivo','SOLICITUD DE EFECTIVO');
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		$this->objParam->addParametro('firmar',$firmar);
		$this->objParam->addParametro('fecha_firma',$fecha_firma);
		$this->objParam->addParametro('usuario_firma',$usuario_firma);
		//build the report
		$reporte = new RSolicitudEfectivo($this->objParam);

		$reporte->setDataSource($dataSource);

		$reporte->write1();//#61: cambio nombre de función

			if(!$create_file){
						$mensajeExito = new Mensaje();
						$mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
														'Se generó con éxito el reporte: '.$nombreArchivo,'control');
						$mensajeExito->setArchivoGenerado($nombreArchivo);
						//anade los datos de firma a la respuesta
						/*if ($firmar == 'si') {
							$mensajeExito->setDatos($datos_firma);
						}*/
						$this->res = $mensajeExito;
						$this->res->imprimirRespuesta($this->res->generarJson());
			}
			else{

				return dirname(__FILE__).'/../../reportes_generados/'.$nombreArchivo;

			}
	}

	function reporteReciboEntrega($create_file=false, $onlyData = false){
		$dataSource = new DataSource();
		//captura datos de firma
		if ($this->objParam->getParametro('firmar') == 'si') {
			$firmar = 'si';
			$fecha_firma = $this->objParam->getParametro('fecha_firma');
			$usuario_firma = $this->objParam->getParametro('usuario_firma');
		} else {
			$firmar = 'no';
			$fecha_firma = '';
			$usuario_firma = '';
		}

		if($this->objParam->getParametro('id_proceso_wf')!='')
		{
			$this->objParam-> addFiltro('sol.id_proceso_wf ='.$this->objParam->getParametro('id_proceso_wf'));
		}


		$this->objParam->addParametroConsulta('ordenacion','sol.id_solicitud_efectivo');
		$this->objParam->addParametroConsulta('dir_ordenacion','ASC');
		$this->objParam->addParametroConsulta('cantidad',1000);
		$this->objParam->addParametroConsulta('puntero',0);

		$this->objFunc = $this->create('MODSolicitudEfectivo');

		$resultSolicitud = $this->objFunc->reporteReciboEntrega();

		if($resultSolicitud->getTipo() != 'EXITO'){
			$resultSolicitud->imprimirRespuesta($resultSolicitud->generarJson());
			exit;
		}

		$datosSolicitud = $resultSolicitud->getDatos();
		if($this->objParam->getParametro('aux')!='')
		{
			$datosSolicitud[0]['codigo_proc']='INGEFE';
		}
		//armamos el array parametros y metemos ahi los data sets de las otras tablas
		$dataSource->putParameter('codigo_proc', $datosSolicitud[0]['codigo_proc']);
		$dataSource->putParameter('fecha_entrega', $datosSolicitud[0]['fecha_entrega']);
		$dataSource->putParameter('moneda', $datosSolicitud[0]['moneda']);
		$dataSource->putParameter('nro_tramite', $datosSolicitud[0]['nro_tramite']);
		$dataSource->putParameter('codigo', $datosSolicitud[0]['codigo']);
		$dataSource->putParameter('cajero', $datosSolicitud[0]['cajero']);
		$dataSource->putParameter('nombre_unidad', $datosSolicitud[0]['nombre_unidad']);
		$dataSource->putParameter('solicitante', $datosSolicitud[0]['solicitante']);
		$dataSource->putParameter('superior', $datosSolicitud[0]['superior']);
		$dataSource->putParameter('motivo', $datosSolicitud[0]['motivo']);
		$dataSource->putParameter('monto', $datosSolicitud[0]['monto']);

		if ($onlyData){

			return $dataSource;
		}
		$nombreArchivo = uniqid(md5(session_id()).'ReciboEntregaSolicitante') . '.pdf';
		$this->objParam->addParametro('orientacion','P');
		$this->objParam->addParametro('tamano','LETTER');
		$this->objParam->addParametro('titulo_archivo','RECIBO DE ENTREGA');
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		$this->objParam->addParametro('firmar',$firmar);
		$this->objParam->addParametro('fecha_firma',$fecha_firma);
		$this->objParam->addParametro('usuario_firma',$usuario_firma);

		//build the report
		$reporte = new RReciboEntrega($this->objParam);

		$reporte->setDataSource($dataSource);

		$reporte->write();

			if(!$create_file){
						$mensajeExito = new Mensaje();
						$mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
														'Se generó con éxito el reporte: '.$nombreArchivo,'control');
						$mensajeExito->setArchivoGenerado($nombreArchivo);
						//anade los datos de firma a la respuesta
						/*if ($firmar == 'si') {
							$mensajeExito->setDatos($datos_firma);
						}*/
						$this->res = $mensajeExito;
						$this->res->imprimirRespuesta($this->res->generarJson());
			}
			else{

				return dirname(__FILE__).'/../../reportes_generados/'.$nombreArchivo;

			}
	}

	function reporteRendicionEfectivo($create_file=false, $onlyData = false){
		$dataSource = new DataSource();
		//captura datos de firma
		if ($this->objParam->getParametro('firmar') == 'si') {
			$firmar = 'si';
			$fecha_firma = $this->objParam->getParametro('fecha_firma');
			$usuario_firma = $this->objParam->getParametro('usuario_firma');
		} else {
			$firmar = 'no';
			$fecha_firma = '';
			$usuario_firma = '';
		}

		if($this->objParam->getParametro('id_proceso_wf')!='')
		{
			$this->objParam-> addFiltro('sol.id_proceso_wf ='.$this->objParam->getParametro('id_proceso_wf'));
		}


		$this->objParam->addParametroConsulta('ordenacion','sol.id_solicitud_efectivo');
		$this->objParam->addParametroConsulta('dir_ordenacion','ASC');
		$this->objParam->addParametroConsulta('cantidad',1000);
		$this->objParam->addParametroConsulta('puntero',0);

		$this->objFunc = $this->create('MODSolicitudEfectivo');

		$resultReciboEntrega = $this->objFunc->reporteReciboEntrega();

		$datosReciboEntrega = $resultReciboEntrega->getDatos();
		//armamos el array parametros y metemos ahi los data sets de las otras tablas
		$dataSource->putParameter('codigo_proc', $datosReciboEntrega[0]['codigo_proc']);
		$dataSource->putParameter('fecha_entrega', $datosReciboEntrega[0]['fecha_entrega']);
		$dataSource->putParameter('moneda', $datosReciboEntrega[0]['moneda']);
		$dataSource->putParameter('nro_tramite', $datosReciboEntrega[0]['nro_tramite']);
		$dataSource->putParameter('codigo', $datosReciboEntrega[0]['codigo']);
		$dataSource->putParameter('cajero', $datosReciboEntrega[0]['cajero']);
		$dataSource->putParameter('nombre_unidad', $datosReciboEntrega[0]['nombre_unidad']);
		$dataSource->putParameter('solicitante', $datosReciboEntrega[0]['solicitante']);
		$dataSource->putParameter('motivo', $datosReciboEntrega[0]['motivo']);
		$dataSource->putParameter('monto', $datosReciboEntrega[0]['monto']);
		$dataSource->putParameter('fecha_rendicion', $datosReciboEntrega[0]['fecha_rendicion']);
		$dataSource->putParameter('monto_dev', $datosReciboEntrega[0]['monto_dev']);

		$this->objParam->defecto('ordenacion', 'fecha');
		$this->objParam->defecto('cantidad', 1000);
		$this->objParam->defecto('puntero', 0);

		$modRendicionEfectivo = $this->create('MODSolicitudEfectivo');
		//lista el detalle de la rendicion
		$resultRendicionEfectivo = $modRendicionEfectivo->reporteRendicionEfectivo();

		//var_dump($resultRendicionEfectivo); exit;
		//agrupa el detalle de la rendicion por centros de costos y partidas
		//$solicitudRendicionEfectivoAgrupado = $this->groupArray($resultRendicionEfectivo->getDatos(), 'desc_ingas','codigo_cc', $datosSolicitud[0]['id_moneda'],$datosSolicitud[0]['estado'],$onlyData);


		$solicitudRendicionEfectivoDataSource = new DataSource();
		$solicitudRendicionEfectivoDataSource->setDataSet($resultRendicionEfectivo->getDatos());

		//inserta el detalle de la solicitud como origen de datos
		$dataSource->putParameter('detalleDataSource', $solicitudRendicionEfectivoDataSource);

		if ($onlyData){

			return $dataSource;
		}
		$nombreArchivo = uniqid(md5(session_id()).'RendicionEfectivo') . '.pdf';
		$this->objParam->addParametro('orientacion','P');
		$this->objParam->addParametro('tamano','LETTER');
		$this->objParam->addParametro('titulo_archivo','REPORTE DE RENDICION');
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		$this->objParam->addParametro('firmar',$firmar);
		$this->objParam->addParametro('fecha_firma',$fecha_firma);
		$this->objParam->addParametro('usuario_firma',$usuario_firma);
		//build the report
		$reporte = new RRendicionEfectivo($this->objParam);

		$reporte->setDataSource($dataSource);

		$reporte->write();

			if(!$create_file){
						$mensajeExito = new Mensaje();
						$mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
														'Se generó con éxito el reporte: '.$nombreArchivo,'control');
						$mensajeExito->setArchivoGenerado($nombreArchivo);
						//anade los datos de firma a la respuesta
						/*if ($firmar == 'si') {
							$mensajeExito->setDatos($datos_firma);
						}*/
						$this->res = $mensajeExito;
						$this->res->imprimirRespuesta($this->res->generarJson());
			}
			else{

				return dirname(__FILE__).'/../../reportes_generados/'.$nombreArchivo;

			}
	}

	function groupArray($array,$groupkey,$groupkeyTwo,$id_moneda,$estado_sol, $onlyData){
	 if (count($array)>0)
	 {
	 	//recupera las llaves del array
	 	$keys = array_keys($array[0]);

	 	$removekey = array_search($groupkey, $keys);
	 	$removekeyTwo = array_search($groupkeyTwo, $keys);

		if ($removekey===false)
 		     return array("Clave \"$groupkey\" no existe");
		if($removekeyTwo===false)
 		     return array("Clave \"$groupkeyTwo\" no existe");


	 	//crea los array para agrupar y para busquedas
	 	$groupcriteria = array();
	 	$arrayResp=array();

	 	//recorre el resultado de la consulta de oslicitud detalle
	 	foreach($array as $value)
	 	{
	 		//por cada registro almacena el valor correspondiente en $item
	 		$item=null;
	 		foreach ($keys as $key)
	 		{
	 			$item[$key] = $value[$key];
	 		}

	 		//buscar si el grupo ya se incerto
	 	 	$busca = array_search($value[$groupkey].$value[$groupkeyTwo], $groupcriteria);

	 		if ($busca === false)
	 		{
	 		     //si el grupo no existe lo crea
	 		    //en la siguiente posicicion de crupcriteria agrega el identificador del grupo
	 			$groupcriteria[]=$value[$groupkey].$value[$groupkeyTwo];

	 			//en la siguiente posivion cre ArrayResp cre un btupo con el identificaor nuevo
	 			//y un bubgrupo para acumular los detalle de semejaste caracteristicas

	 			$arrayResp[]=array($groupkey.$groupkeyTwo=>$value[$groupkey].$value[$groupkeyTwo],'groupeddata'=>array(),'presu_verificado'=>"false");
	 			$arrayPresuVer[]=
	 			//coloca el indice en la ultima posicion insertada
	 			$busca=count($arrayResp)-1;



	 		}

	 		//inserta el registro en el subgrupo correspondiente
	 		$arrayResp[$busca]['groupeddata'][]=$item;

	 	}

	 	return $arrayResp;
	 }
	 else
	 	return array();
	}
}

?>
