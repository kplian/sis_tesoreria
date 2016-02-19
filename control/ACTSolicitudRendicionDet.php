<?php
/**
*@package pXP
*@file ACTSolicitudRendicionDet.php
*@author  (gsarmiento)
*@date 16-12-2015 15:14:01
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTSolicitudRendicionDet extends ACTbase{    
			
	function listarSolicitudRendicionDet(){
		$this->objParam->defecto('ordenacion','id_solicitud_rendicion_det');

		if($this->objParam->getParametro('id_solicitud_efectivo')!=''){
			if ($this->objParam->getParametro('interfaz')=='aprobacion_facturas'){
				$this->objParam->addFiltro("rend.id_solicitud_efectivo = ".$this->objParam->getParametro('id_solicitud_efectivo'));	
			}else{
				$this->objParam->addFiltro("solefe.id_solicitud_efectivo = ".$this->objParam->getParametro('id_solicitud_efectivo'));	
				$this->objParam->addFiltro("solren.estado=''borrador''");	
			}
		}
		
		if($this->objParam->getParametro('id_proceso_caja')!=''){
			$this->objParam->addFiltro("id_proceso_caja = ".$this->objParam->getParametro('id_proceso_caja'));	
		}

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODSolicitudRendicionDet','listarSolicitudRendicionDet');
		} else{
			$this->objFunc=$this->create('MODSolicitudRendicionDet');
			
			$this->res=$this->objFunc->listarSolicitudRendicionDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarSolicitudRendicionDet(){
		$this->objFunc=$this->create('MODSolicitudRendicionDet');	
		if($this->objParam->insertar('id_solicitud_rendicion_det')){
			$this->res=$this->objFunc->insertarSolicitudRendicionDet($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarSolicitudRendicionDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function insertarRendicionDocCompleto(){
		
		$this->objParam->addParametro('tipo_solicitud','rendicion');
		
		$this->objFunc=$this->create('MODSolicitudRendicionDet');	
		if($this->objParam->insertar('id_solicitud_rendicion_det')){
			$this->res=$this->objFunc->insertarRendicionDocCompleto($this->objParam);			
		} else{
			//TODO			
			//$this->res=$this->objFunc->modificarSolicitud($this->objParam);
			//trabajar en la modificacion compelta de solicitud ....
			$this->res=$this->objFunc->modificarRendicionDocCompleto($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarSolicitudRendicionDet(){
			$this->objFunc=$this->create('MODSolicitudRendicionDet');	
		$this->res=$this->objFunc->eliminarSolicitudRendicionDet($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>