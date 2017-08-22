<?php
/**
*@package pXP
*@file gen-ACTTipoCcCuentaLibro.php
*@author  (admin)
*@date 18-08-2017 16:07:02
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTipoCcCuentaLibro extends ACTbase{    
			
	function listarTipoCcCuentaLibro(){
		$this->objParam->defecto('ordenacion','id_ttipo_cc_cuenta_libro');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_cuenta_bancaria')!=''){
            $this->objParam->addFiltro(" id_cuenta_bancaria = ".$this->objParam->getParametro('id_cuenta_bancaria'));    
        }
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoCcCuentaLibro','listarTipoCcCuentaLibro');
		} else{
			$this->objFunc=$this->create('MODTipoCcCuentaLibro');
			
			$this->res=$this->objFunc->listarTipoCcCuentaLibro($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTipoCcCuentaLibro(){
		$this->objFunc=$this->create('MODTipoCcCuentaLibro');	
		if($this->objParam->insertar('id_ttipo_cc_cuenta_libro')){
			$this->res=$this->objFunc->insertarTipoCcCuentaLibro($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTipoCcCuentaLibro($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTipoCcCuentaLibro(){
			$this->objFunc=$this->create('MODTipoCcCuentaLibro');	
		$this->res=$this->objFunc->eliminarTipoCcCuentaLibro($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>