<?php
/**
*@package pXP
*@file gen-ACTUsuarioCuentaBanc.php
*@author  (admin)
*@date 24-03-2017 15:30:36
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTUsuarioCuentaBanc extends ACTbase{    
			
	function listarUsuarioCuentaBanc(){
		$this->objParam->defecto('ordenacion','id_usuario_cuenta_banc');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_cuenta_bancaria')!=''){
            $this->objParam->addFiltro(" id_cuenta_bancaria = ".$this->objParam->getParametro('id_cuenta_bancaria'));    
        }
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODUsuarioCuentaBanc','listarUsuarioCuentaBanc');
		} else{
			$this->objFunc=$this->create('MODUsuarioCuentaBanc');
			
			$this->res=$this->objFunc->listarUsuarioCuentaBanc($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarUsuarioCuentaBanc(){
		$this->objFunc=$this->create('MODUsuarioCuentaBanc');	
		if($this->objParam->insertar('id_usuario_cuenta_banc')){
			$this->res=$this->objFunc->insertarUsuarioCuentaBanc($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarUsuarioCuentaBanc($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarUsuarioCuentaBanc(){
			$this->objFunc=$this->create('MODUsuarioCuentaBanc');	
		$this->res=$this->objFunc->eliminarUsuarioCuentaBanc($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>