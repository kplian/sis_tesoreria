<?php
/**
*@package pXP
*@file ACTChequera.php
*@author  Gonzalo Sarmiento Sejas
*@date 24-04-2013 18:54:03
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTChequera extends ACTbase{    
			
	function listarChequera(){
		$this->objParam->defecto('ordenacion','id_chequera');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODChequera','listarChequera');
		} else{
			$this->objFunc=$this->create('MODChequera');
			
			$this->res=$this->objFunc->listarChequera($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarChequera(){
		$this->objFunc=$this->create('MODChequera');	
		if($this->objParam->insertar('id_chequera')){
			$this->res=$this->objFunc->insertarChequera($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarChequera($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarChequera(){
			$this->objFunc=$this->create('MODChequera');	
		$this->res=$this->objFunc->eliminarChequera($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>