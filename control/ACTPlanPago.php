<?php
/**
*@package pXP
*@file gen-ACTPlanPago.php
*@author  (admin)
*@date 10-04-2013 15:43:23
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTPlanPago extends ACTbase{    
			
	function listarPlanPago(){
		$this->objParam->defecto('ordenacion','id_plan_pago');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_obligacion_pago')!=''){
            $this->objParam->addFiltro("plapa.id_obligacion_pago = ".$this->objParam->getParametro('id_obligacion_pago'));  
        }
        
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPlanPago','listarPlanPago');
		} else{
			$this->objFunc=$this->create('MODPlanPago');
			
			$this->res=$this->objFunc->listarPlanPago($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarPlanPago(){
		$this->objFunc=$this->create('MODPlanPago');	
		if($this->objParam->insertar('id_plan_pago')){
			$this->res=$this->objFunc->insertarPlanPago($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarPlanPago($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPlanPago(){
			$this->objFunc=$this->create('MODPlanPago');	
		$this->res=$this->objFunc->eliminarPlanPago($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function solicitarDevPag(){
        $this->objFunc=$this->create('MODPlanPago');  
        $this->res=$this->objFunc->solicitarDevPag($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    
    function sincronizarPresupuesto(){
        $this->objFunc=$this->create('MODPlanPago');  
        $this->res=$this->objFunc->sincronizarPresupuesto($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
			
}

?>