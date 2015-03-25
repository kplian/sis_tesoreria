<?php
/**
*@package pXP
*@file gen-ACTDeptoCuentaBancaria.php
*@author  (admin)
*@date 25-03-2015 13:11:53
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTDeptoCuentaBancaria extends ACTbase{    
			
	function listarDeptoCuentaBancaria(){
		$this->objParam->defecto('ordenacion','id_depto_cuenta_bancaria');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODDeptoCuentaBancaria','listarDeptoCuentaBancaria');
		} else{
			$this->objFunc=$this->create('MODDeptoCuentaBancaria');
			
			$this->res=$this->objFunc->listarDeptoCuentaBancaria($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarDeptoCuentaBancaria(){
		$this->objFunc=$this->create('MODDeptoCuentaBancaria');	
		if($this->objParam->insertar('id_depto_cuenta_bancaria')){
			$this->res=$this->objFunc->insertarDeptoCuentaBancaria($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarDeptoCuentaBancaria($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarDeptoCuentaBancaria(){
			$this->objFunc=$this->create('MODDeptoCuentaBancaria');	
		$this->res=$this->objFunc->eliminarDeptoCuentaBancaria($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>