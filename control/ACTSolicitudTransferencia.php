<?php
/**
*@package pXP
*@file gen-ACTSolicitudTransferencia.php
*@author  (admin)
*@date 22-02-2018 03:43:11
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTSolicitudTransferencia extends ACTbase{    
			
	function listarSolicitudTransferencia(){
		$this->objParam->defecto('ordenacion','id_solicitud_transferencia');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if ($this->objParam->getParametro('pes_estado') != '') {
			
			$this->objParam->addFiltro("soltra.estado = ''" . $this->objParam->getParametro('pes_estado') . "''");		
			
		}
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODSolicitudTransferencia','listarSolicitudTransferencia');
		} else{
			$this->objFunc=$this->create('MODSolicitudTransferencia');
			
			$this->res=$this->objFunc->listarSolicitudTransferencia($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarSolicitudTransferencia(){
		$this->objFunc=$this->create('MODSolicitudTransferencia');	
		if($this->objParam->insertar('id_solicitud_transferencia')){
			$this->res=$this->objFunc->insertarSolicitudTransferencia($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarSolicitudTransferencia($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarSolicitudTransferencia(){
			$this->objFunc=$this->create('MODSolicitudTransferencia');	
		$this->res=$this->objFunc->eliminarSolicitudTransferencia($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	function siguienteEstadoSolicitud(){
        $this->objFunc=$this->create('MODSolicitudTransferencia');  
        
        $this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
        
        $this->res=$this->objFunc->siguienteEstadoSolicitud($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    
     function anteriorEstadoSolicitud(){
        $this->objFunc=$this->create('MODSolicitudTransferencia');  
        $this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
        $this->res=$this->objFunc->anteriorEstadoSolicitud($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
			
}

?>