<?php
/**
*@package pXP
*@file gen-ACTConceptoExcepcion.php
*@author  (admin)
*@date 12-06-2015 13:02:07
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTConceptoExcepcion extends ACTbase{    
			
	function listarConceptoExcepcion(){
		$this->objParam->defecto('ordenacion','id_concepto_excepcion');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODConceptoExcepcion','listarConceptoExcepcion');
		} else{
			$this->objFunc=$this->create('MODConceptoExcepcion');
			
			$this->res=$this->objFunc->listarConceptoExcepcion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarConceptoExcepcion(){
		$this->objFunc=$this->create('MODConceptoExcepcion');	
		if($this->objParam->insertar('id_concepto_excepcion')){
			$this->res=$this->objFunc->insertarConceptoExcepcion($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarConceptoExcepcion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarConceptoExcepcion(){
			$this->objFunc=$this->create('MODConceptoExcepcion');	
		$this->res=$this->objFunc->eliminarConceptoExcepcion($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>