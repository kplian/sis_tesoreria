<?php
/**
*@package pXP
*@file ACTObligacionPago.php
*@author  Gonzalo Sarmiento Sejas
*@date 02-04-2013 16:01:32
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTObligacionPago extends ACTbase{    
			
	function listarObligacionPago(){
		$this->objParam->defecto('ordenacion','id_obligacion_pago');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODObligacionPago','listarObligacionPago');
		} else{
			$this->objFunc=$this->create('MODObligacionPago');
			
			$this->res=$this->objFunc->listarObligacionPago($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarObligacionPago(){
		$this->objFunc=$this->create('MODObligacionPago');	
		if($this->objParam->insertar('id_obligacion_pago')){
			$this->res=$this->objFunc->insertarObligacionPago($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarObligacionPago($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarObligacionPago(){
			$this->objFunc=$this->create('MODObligacionPago');	
		$this->res=$this->objFunc->eliminarObligacionPago($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function finalizarRegistro(){
        $this->objFunc=$this->create('MODObligacionPago');  
        $this->res=$this->objFunc->finalizarRegistro($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    
    function anteriorEstadoObligacion(){
        $this->objFunc=$this->create('MODObligacionPago');  
        $this->res=$this->objFunc->anteriorEstadoObligacion($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    
    function obtenerFaltante(){
        $this->objFunc=$this->create('MODObligacionPago');  
        $this->res=$this->objFunc->obtenerFaltante($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    
    
        
			
}

?>