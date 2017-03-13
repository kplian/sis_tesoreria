<?php
/**
*@package pXP
*@file ACTTipoSolicitud.php
*@author  Gonzalo Sarmiento
*@date 04-02-2016 21:15:09
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTipoSolicitud extends ACTbase{    
			
	function listarTipoSolicitud(){
		$this->objParam->defecto('ordenacion','id_tipo_solicitud');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoSolicitud','listarTipoSolicitud');
		} else{
			$this->objFunc=$this->create('MODTipoSolicitud');
			
			$this->res=$this->objFunc->listarTipoSolicitud($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTipoSolicitud(){
		$this->objFunc=$this->create('MODTipoSolicitud');	
		if($this->objParam->insertar('id_tipo_solicitud')){
			$this->res=$this->objFunc->insertarTipoSolicitud($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTipoSolicitud($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTipoSolicitud(){
			$this->objFunc=$this->create('MODTipoSolicitud');	
		$this->res=$this->objFunc->eliminarTipoSolicitud($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>