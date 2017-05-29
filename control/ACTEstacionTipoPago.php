<?php
/**
*@package pXP
*@file gen-ACTEstacionTipoPago.php
*@author  (admin)
*@date 25-08-2015 15:36:37
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTEstacionTipoPago extends ACTbase{    
			
	function listarEstacionTipoPago(){
		$this->objParam->defecto('ordenacion','id_estacion_tipo_pago');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODEstacionTipoPago','listarEstacionTipoPago');
		} else{
			$this->objFunc=$this->create('MODEstacionTipoPago');
			
			$this->res=$this->objFunc->listarEstacionTipoPago($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarEstacionTipoPago(){
		$this->objFunc=$this->create('MODEstacionTipoPago');	
		if($this->objParam->insertar('id_estacion_tipo_pago')){
			$this->res=$this->objFunc->insertarEstacionTipoPago($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarEstacionTipoPago($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarEstacionTipoPago(){
			$this->objFunc=$this->create('MODEstacionTipoPago');	
		$this->res=$this->objFunc->eliminarEstacionTipoPago($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>