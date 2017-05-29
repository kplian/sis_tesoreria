<?php
/**
*@package pXP
*@file gen-ACTProrrateo.php
*@author  (admin)
*@date 16-04-2013 01:45:48
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTProrrateo extends ACTbase{    
			
	function listarProrrateo(){
		$this->objParam->defecto('ordenacion','id_prorrateo');

		if($this->objParam->getParametro('id_plan_pago')!=''){
            $this->objParam->addFiltro("pro.id_plan_pago = ".$this->objParam->getParametro('id_plan_pago'));  
        }
        
        
		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODProrrateo','listarProrrateo');
		} else{
			$this->objFunc=$this->create('MODProrrateo');
			
			$this->res=$this->objFunc->listarProrrateo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarProrrateo(){
		$this->objFunc=$this->create('MODProrrateo');	
		if($this->objParam->insertar('id_prorrateo')){
			$this->res=$this->objFunc->insertarProrrateo($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarProrrateo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarProrrateo(){
			$this->objFunc=$this->create('MODProrrateo');	
		$this->res=$this->objFunc->eliminarProrrateo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>