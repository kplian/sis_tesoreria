<?php
/**
*@package pXP
*@file gen-ACTCajero.php
*@author  (admin)
*@date 18-12-2013 19:39:02
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTCajero extends ACTbase{    
			
	function listarCajero(){
		$this->objParam->defecto('ordenacion','id_cajero');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_caja')!='')
		{
					$this->objParam-> addFiltro('cajero.id_caja ='.$this->objParam->getParametro('id_caja'));
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCajero','listarCajero');
		} else{
			$this->objFunc=$this->create('MODCajero');
			
			$this->res=$this->objFunc->listarCajero($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarCajero(){
		$this->objFunc=$this->create('MODCajero');	
		if($this->objParam->insertar('id_cajero')){
			$this->res=$this->objFunc->insertarCajero($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCajero($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCajero(){
			$this->objFunc=$this->create('MODCajero');	
		$this->res=$this->objFunc->eliminarCajero($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>