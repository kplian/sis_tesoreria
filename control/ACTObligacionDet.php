<?php
/**
*@package pXP
*@file ACTObligacionDet.php
*@author  Gonzalo Sarmiento Sejas
*@date 02-04-2013 20:27:35
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTObligacionDet extends ACTbase{    
			
	function listarObligacionDet(){
		$this->objParam->defecto('ordenacion','id_obligacion_det');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODObligacionDet','listarObligacionDet');
		} else{
			$this->objFunc=$this->create('MODObligacionDet');
			
			$this->res=$this->objFunc->listarObligacionDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarObligacionDet(){
		$this->objFunc=$this->create('MODObligacionDet');	
		if($this->objParam->insertar('id_obligacion_det')){
			$this->res=$this->objFunc->insertarObligacionDet($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarObligacionDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarObligacionDet(){
			$this->objFunc=$this->create('MODObligacionDet');	
		$this->res=$this->objFunc->eliminarObligacionDet($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>