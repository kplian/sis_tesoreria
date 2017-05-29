<?php
/**
*@package pXP
*@file gen-ACTCuentaBancariaMov.php
*@author  (admin)
*@date 12-12-2013 18:01:35
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTCuentaBancariaMov extends ACTbase{    
			
	function listarCuentaBancariaMov(){
		$this->objParam->defecto('ordenacion','id_cuenta_bancaria_mov');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_cuenta_bancaria')!=''){
			$this->objParam->addFiltro('cbanmo.id_cuenta_bancaria = '.$this->objParam->getParametro('id_cuenta_bancaria'). " and cbanmo.tipo_mov = ''ingreso'' and cbanmo.tipo = ''deposito''");
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCuentaBancariaMov','listarCuentaBancariaMov');
		} else{
			$this->objFunc=$this->create('MODCuentaBancariaMov');
			
			$this->res=$this->objFunc->listarCuentaBancariaMov($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarCuentaBancariaMov(){
		$this->objFunc=$this->create('MODCuentaBancariaMov');	
		if($this->objParam->insertar('id_cuenta_bancaria_mov')){
			$this->res=$this->objFunc->insertarCuentaBancariaMov($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCuentaBancariaMov($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCuentaBancariaMov(){
			$this->objFunc=$this->create('MODCuentaBancariaMov');	
		$this->res=$this->objFunc->eliminarCuentaBancariaMov($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>