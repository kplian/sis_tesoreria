<?php
/**
*@package pXP
*@file gen-ACTSolicitudEfectivoDet.php
*@author  (gsarmiento)
*@date 24-11-2015 14:14:27
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTSolicitudEfectivoDet extends ACTbase{    
			
	function listarSolicitudEfectivoDet(){
		$this->objParam->defecto('ordenacion','id_solicitud_efectivo_det');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODSolicitudEfectivoDet','listarSolicitudEfectivoDet');
		} else{
			$this->objFunc=$this->create('MODSolicitudEfectivoDet');
			
			$this->res=$this->objFunc->listarSolicitudEfectivoDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarSolicitudEfectivoDet(){
		$this->objFunc=$this->create('MODSolicitudEfectivoDet');	
		if($this->objParam->insertar('id_solicitud_efectivo_det')){
			$this->res=$this->objFunc->insertarSolicitudEfectivoDet($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarSolicitudEfectivoDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarSolicitudEfectivoDet(){
			$this->objFunc=$this->create('MODSolicitudEfectivoDet');	
		$this->res=$this->objFunc->eliminarSolicitudEfectivoDet($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>