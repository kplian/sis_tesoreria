<?php
/**
*@package pXP
*@file gen-ACTTipoProcesoCaja.php
*@author  (admin)
*@date 23-03-2016 13:33:41
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTipoProcesoCaja extends ACTbase{    
			
	function listarTipoProcesoCaja(){
		$this->objParam->defecto('ordenacion','id_tipo_proceso_caja');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('estado_caja')!=''){
			$this->objParam->addFiltro("prcj.visible_en = ''".$this->objParam->getParametro('estado_caja')."''");
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoProcesoCaja','listarTipoProcesoCaja');
		} else{
			$this->objFunc=$this->create('MODTipoProcesoCaja');
			
			$this->res=$this->objFunc->listarTipoProcesoCaja($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTipoProcesoCaja(){
		$this->objFunc=$this->create('MODTipoProcesoCaja');	
		if($this->objParam->insertar('id_tipo_proceso_caja')){
			$this->res=$this->objFunc->insertarTipoProcesoCaja($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTipoProcesoCaja($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTipoProcesoCaja(){
			$this->objFunc=$this->create('MODTipoProcesoCaja');	
		$this->res=$this->objFunc->eliminarTipoProcesoCaja($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>