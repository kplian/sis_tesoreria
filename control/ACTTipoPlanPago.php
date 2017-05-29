<?php
/**
*@package pXP
*@file gen-ACTTipoPlanPago.php
*@author  (admin)
*@date 08-07-2014 13:12:03
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTipoPlanPago extends ACTbase{    
			
	function listarTipoPlanPago(){
		$this->objParam->defecto('ordenacion','id_tipo_plan_pago');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoPlanPago','listarTipoPlanPago');
		} else{
			$this->objFunc=$this->create('MODTipoPlanPago');
			
			$this->res=$this->objFunc->listarTipoPlanPago($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTipoPlanPago(){
		$this->objFunc=$this->create('MODTipoPlanPago');	
		if($this->objParam->insertar('id_tipo_plan_pago')){
			$this->res=$this->objFunc->insertarTipoPlanPago($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTipoPlanPago($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTipoPlanPago(){
			$this->objFunc=$this->create('MODTipoPlanPago');	
		$this->res=$this->objFunc->eliminarTipoPlanPago($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>