<?php
/**
*@package pXP
*@file gen-ACTFinalidad.php
*@author  (gsarmiento)
*@date 02-12-2014 13:11:02
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTFinalidad extends ACTbase{    
			
	function listarFinalidad(){
		$this->objParam->defecto('ordenacion','id_finalidad');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODFinalidad','listarFinalidad');
		} else{
			$this->objFunc=$this->create('MODFinalidad');
			
			$this->res=$this->objFunc->listarFinalidad($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function listarFinalidadCuentaBancaria(){
		$this->objParam->defecto('ordenacion','id_finalidad');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_cuenta_bancaria')!=''){
			$this->objParam->addFiltro("cb.id_cuenta_bancaria = ".$this->objParam->getParametro('id_cuenta_bancaria'));
		}
		
		$this->objFunc=$this->create('MODFinalidad');
		$this->res=$this->objFunc->listarFinalidadCuentaBancaria($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function insertarFinalidad(){
		$this->objFunc=$this->create('MODFinalidad');	
		if($this->objParam->insertar('id_finalidad')){
			$this->res=$this->objFunc->insertarFinalidad($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarFinalidad($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarFinalidad(){
			$this->objFunc=$this->create('MODFinalidad');	
		$this->res=$this->objFunc->eliminarFinalidad($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>