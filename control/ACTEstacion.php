<?php
/**
*@package pXP
*@file gen-ACTEstacion.php
*@author  (admin)
*@date 25-08-2015 15:36:34
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTEstacion extends ACTbase{    
			
	function listarEstacion(){
		$this->objParam->defecto('ordenacion','id_estacion');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODEstacion','listarEstacion');
		} else{
			$this->objFunc=$this->create('MODEstacion');
			
			$this->res=$this->objFunc->listarEstacion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarEstacion(){
		$this->objFunc=$this->create('MODEstacion');	
		if($this->objParam->insertar('id_estacion')){
			$this->res=$this->objFunc->insertarEstacion($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarEstacion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarEstacion(){
			$this->objFunc=$this->create('MODEstacion');	
		$this->res=$this->objFunc->eliminarEstacion($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>