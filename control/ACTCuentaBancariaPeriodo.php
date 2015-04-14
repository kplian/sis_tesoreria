<?php
/**
*@package pXP
*@file gen-ACTCuentaBancariaPeriodo.php
*@author  (gsarmiento)
*@date 09-04-2015 18:40:04
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTCuentaBancariaPeriodo extends ACTbase{    
			
	function listarCuentaBancariaPeriodo(){
		$this->objParam->defecto('ordenacion','id_cuenta_bancaria_periodo');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_cuenta_bancaria')!=''){
			$this->objParam->addFiltro("id_cuenta_bancaria = ".$this->objParam->getParametro('id_cuenta_bancaria'));	
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCuentaBancariaPeriodo','listarCuentaBancariaPeriodo');
		} else{
			$this->objFunc=$this->create('MODCuentaBancariaPeriodo');
			
			$this->res=$this->objFunc->listarCuentaBancariaPeriodo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarCuentaBancariaPeriodo(){
		$this->objFunc=$this->create('MODCuentaBancariaPeriodo');	
		if($this->objParam->insertar('id_cuenta_bancaria_periodo')){
			$this->res=$this->objFunc->insertarCuentaBancariaPeriodo($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCuentaBancariaPeriodo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function abrirCerrarCuentaBancariaPeriodo(){
		$this->objFunc=$this->create('MODCuentaBancariaPeriodo');	
		$this->res=$this->objFunc->abrirCerrarCuentaBancariaPeriodo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function eliminarCuentaBancariaPeriodo(){
			$this->objFunc=$this->create('MODCuentaBancariaPeriodo');	
		$this->res=$this->objFunc->eliminarCuentaBancariaPeriodo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>