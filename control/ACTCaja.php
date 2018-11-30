<?php
/**
*@package pXP
*@file gen-ACTCaja.php
*@author  (admin)
*@date 16-12-2013 20:43:44
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
require_once(dirname(__FILE__).'/../reportes/RProcesoCaja.php');
require_once(dirname(__FILE__).'/../../pxp/pxpReport/ReportWriter.php');
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');
require_once(dirname(__FILE__).'/../../sis_tesoreria/reportes/RepCajaFecXls.php');
require_once(dirname(__FILE__).'/../../sis_tesoreria/reportes/RepMenFecXls.php');
require_once(dirname(__FILE__).'/../../sis_tesoreria/reportes/RepArqueoXls.php');

class ACTCaja extends ACTbase{    
			
	function listarCaja(){
		$this->objParam->defecto('ordenacion','id_caja');

		$this->objParam->defecto('dir_ordenacion','desc');
		
		if($this->objParam->getParametro('tipo_interfaz')=='caja'){
			$this->objParam->addFiltro("pc.tipo = ''apertura''");
		}
		
		if($this->objParam->getParametro('con_detalle') == 'si'){
			$this->objParam->addFiltro("caja.tipo_ejecucion = ''con_detalle''");
		}		
		
		if($this->objParam->getParametro('con_detalle') == 'no'){
			$this->objParam->addFiltro("caja.tipo_ejecucion = ''sin_detalle''");
		}
		
		if($this->objParam->getParametro('pes_estado')=='borrador'){
            $this->objParam->addFiltro("pc.estado in (''borrador'')");
        }
        if($this->objParam->getParametro('pes_estado')=='proceso'){
            $this->objParam->addFiltro("pc.estado = ''solicitado''");
        }
        if($this->objParam->getParametro('pes_estado')=='finalizados'){
            $this->objParam->addFiltro("pc.estado in (''aprobado'',''rechazado'',''anulado'')");
        }
        if($this->objParam->getParametro('id_moneda')!=''){
            $this->objParam->addFiltro("caja.id_moneda = ".$this->objParam->getParametro('id_moneda'));
        }
        //RCM 02/04/2018
        if($this->objParam->getParametro('solo_resp')=='si'){
            $this->objParam->addFiltro("caje.tipo = ''responsable''");
        }
		
		$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]);
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCaja','listarCaja');
		} else{
			$this->objFunc=$this->create('MODCaja');
			
			$this->res=$this->objFunc->listarCaja($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function abrirCerrarCaja(){
		$this->objFunc=$this->create('MODCaja');
		$this->res=$this->objFunc->abrirCerrarCaja($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}	
	
	function insertarCaja(){
		$this->objFunc=$this->create('MODCaja');	
		if($this->objParam->insertar('id_caja')){
			$this->res=$this->objFunc->insertarCaja($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCaja($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCaja(){
			$this->objFunc=$this->create('MODCaja');	
		$this->res=$this->objFunc->eliminarCaja($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function siguienteEstadoCaja(){
		$this->objFunc=$this->create('MODCaja');	
		$this->res=$this->objFunc->siguienteEstadoCaja($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function anteriorEstadoCaja(){
		$this->objFunc=$this->create('MODCaja');	
		$this->res=$this->objFunc->anteriorEstadoCaja($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	//
	function listarCajaRep(){
		
		$this->objParam->defecto('dir_ordenacion','desc');
		$this->objParam->defecto('dir_ordenacion','desc');
		
		$this->objFunc=$this->create('MODCaja');		
		$cbteHeader = $this->objFunc->listarCajaRep($this->objParam);			
		if($cbteHeader->getTipo() == 'EXITO'){										
			return $cbteHeader;			
		}
		else{
			$cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}	
	}
	//
	//mp
	function listarRepCaja(){

		if($this->objParam->getParametro('id_caja')!=''){
			$this->objParam->addFiltro("caja.id_caja =".$this->objParam->getParametro('id_caja')." AND "."ren.id_proceso_caja =".$this->objParam->getParametro('id_proceso_caja'));    
		}
		
		$this->objFunc=$this->create('MODCaja');		
		$cbteHeader = $this->objFunc->listarRepCaja($this->objParam);					
		if($cbteHeader->getTipo() == 'EXITO'){										
			return $cbteHeader;			
		}
		else{
			$cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}			
	}
	//
	function impReporteProcesoCaja() {
		$nombreArchivo = uniqid(md5(session_id()).'ProcesoCaja').'.pdf';			
		$dataSource = $this->listarRepCaja();
		$dataEntidad = "";
		$dataPeriodo = "";	
		$orientacion = 'P';		
		$tamano = 'LETTER';
		$titulo = 'Consolidado';

		$this->objParam->addParametro('orientacion',$orientacion);
		$this->objParam->addParametro('tamano',$tamano);		
		$this->objParam->addParametro('titulo_archivo',$titulo);	
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		$reporte = new RProcesoCaja($this->objParam);  
		$reporte->datosHeader($dataSource->getDatos(),$dataSource->extraData, $this->objParam->getParametro('codigo'), $this->objParam->getParametro('fecha'));		
		$reporte->generarReporte();
		$reporte->output($reporte->url_archivo,'F');
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genera con exito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());		
	}
	//
	function editMonto(){
		$this->objFunc=$this->create('MODCaja');				
		$this->res=$this->objFunc->editMon($this->objParam);		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function reporteMovimientoCaja(){
		//Obtención datos
		$dataSource = $this->recuperarMovimientoCaja();
		
		//Parámetros básicos
		$tamano = 'LETTER';
		$orientacion = 'L';
		$titulo = 'Movimiento de Caja';
		$nombreArchivo = uniqid('MovimientoCaja-'.session_id()).'.xls';
		$this->objParam->addParametro('orientacion',$orientacion);
		$this->objParam->addParametro('tamano',$tamano);
		$this->objParam->addParametro('titulo_archivo',$titulo);
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		
		//Generación del Reporte
		$reporte = new RMovimientoCajaXls($this->objParam);
		$reporte->datosHeader($dataSource->getDatos());
		$reporte->setDataSet($dataSource->getDatos());
		$reporte->generarReporte();
		
		//Salida del reporte
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
	}

	function recuperarMovimientoCaja(){
		$this->objFunc = $this->create('MODCaja');
		$cbteHeader = $this->objFunc->recuperarMovimientoCaja($this->objParam);

		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		} else {
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		} 
    }
	//
	function listarCajas(){
		$this->objParam->defecto('ordenacion','id_caja');
		$this->objParam->defecto('dir_ordenacion','desc');
			
		$this->objFunc=$this->create('MODCaja');
		$this->res=$this->objFunc->listarCajas($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	
	function repCajaFechas(){
		$dataSource = new DataSource();
		
		$caja = $this->objParam->getParametro('id_caja');
		$fecha_ini = $this->objParam->getParametro('fecha_ini');
		$fecha_fin = $this->objParam->getParametro('fecha_fin');
			
		$dataSource->putParameter('id_caja', $caja);
		$dataSource->putParameter('fecha_ini', $fecha_ini);
		$dataSource->putParameter('fecha_fin', $fecha_fin);
					
		$this->objFun=$this->create('MODCaja');	
		$this->res = $this->objFun->repCajaFechas();
			
		if($this->res->getTipo()=='ERROR'){
			$this->res->imprimirRespuesta($this->res->generarJson());
			exit;
		}
		$titulo ='Libro';
		$nombreArchivo=uniqid(md5(session_id()).$titulo);
		$nombreArchivo.='.xls';
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		$this->objParam->addParametro('datos',$this->res->datos);			
		$this->objReporteFormato=new RepCajaFecXls($this->objParam);
		$this->objReporteFormato->generarDatos();
		$this->objReporteFormato->generarReporte();
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genero con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());	
	}
//
	function repMensualFechas(){
		$dataSource = new DataSource();
		
		$caja = $this->objParam->getParametro('id_caja');
		$fecha_ini = $this->objParam->getParametro('fecha_ini');
		$fecha_fin = $this->objParam->getParametro('fecha_fin');
			
		$dataSource->putParameter('id_caja', $caja);
		$dataSource->putParameter('fecha_ini', $fecha_ini);
		$dataSource->putParameter('fecha_fin', $fecha_fin);
					
		$this->objFun=$this->create('MODCaja');	
		$this->res = $this->objFun->repMensualFechas();
				
		if($this->res->getTipo()=='ERROR'){
			$this->res->imprimirRespuesta($this->res->generarJson());
			exit;
		}
		$titulo ='Libro';
		$nombreArchivo=uniqid(md5(session_id()).$titulo);
		$nombreArchivo.='.xls';
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		$this->objParam->addParametro('datos',$this->res->datos);			
		$this->objReporteFormato=new RepMenFecXls($this->objParam);
		$this->objReporteFormato->generarDatos();
		$this->objReporteFormato->generarReporte();
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genero con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());	
	}
	//
	function recuperarDatos(){
		if($this->objParam->getParametro('id_caja')!=''){
			$this->objParam->addFiltro("c.id_caja =".$this->objParam->getParametro('id_caja')." AND "."p.id_proceso_caja =".$this->objParam->getParametro('id_proceso_caja'));    
		}		
		$this->objFunc = $this->create('MODCaja');
		$cbteHeader = $this->objFunc->recuperarDatos($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){
			return $cbteHeader;
		}
		else{
			$cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}
	}
	//
	function arqueo() {
		$dataSource = new DataSource();	
		$dataSource = $this->recuperarDatos();
		//$caja = $this->objParam->getParametro('id_caja');		
		if($this->objParam->getParametro('id_caja')!=''){
			$this->objParam->addFiltro("caja.id_caja =".$this->objParam->getParametro('id_caja')." AND "."ren.id_proceso_caja =".$this->objParam->getParametro('id_proceso_caja')." AND "."esta.fecha_mod =".$this->objParam->getParametro('fecha'));
		}
		$this->objFun=$this->create('MODCaja');	
		$this->res = $this->objFun->listDatArq();
		if($this->res->getTipo()=='ERROR'){
			$this->res->imprimirRespuesta($this->res->generarJson());
			exit;
		}
		
		$titulo ='Libro';
		$nombreArchivo=uniqid(md5(session_id()).$titulo);
		$nombreArchivo.='.xls';
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		$this->objParam->addParametro('datos',$this->res->datos);			
		$this->objReporteFormato=new RepArqueoXls($this->objParam);
		$this->objReporteFormato->datosHeader($dataSource->getDatos());
		$this->objReporteFormato->generarDatos();
		$this->objReporteFormato->generarReporte();
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genero con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());			
	}	
}

?>