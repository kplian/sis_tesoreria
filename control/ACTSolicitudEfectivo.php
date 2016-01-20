<?php
/**
*@package pXP
*@file gen-ACTSolicitudEfectivo.php
*@author  (gsarmiento)
*@date 24-11-2015 12:59:51
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTSolicitudEfectivo extends ACTbase{    
			
	function listarSolicitudEfectivo(){
		$this->objParam->defecto('ordenacion','id_solicitud_efectivo');
		
		if($this->objParam->getParametro('tipo_interfaz')=='ConDetalle')
		{
			$this->objParam-> addFiltro("caja.tipo_ejecucion = ''con_detalle''");				
		}
		
		if($this->objParam->getParametro('tipo_interfaz')=='SinDetalle')
		{
			$this->objParam-> addFiltro("caja.tipo_ejecucion = ''sin_detalle''");
		}
		
		$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]);
		
		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODSolicitudEfectivo','listarSolicitudEfectivo');
		} else{
			$this->objFunc=$this->create('MODSolicitudEfectivo');
			
			$this->res=$this->objFunc->listarSolicitudEfectivo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarSolicitudEfectivo(){
		$this->objFunc=$this->create('MODSolicitudEfectivo');	
		if($this->objParam->insertar('id_solicitud_efectivo')){
			$this->res=$this->objFunc->insertarSolicitudEfectivo($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarSolicitudEfectivo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarSolicitudEfectivo(){
			$this->objFunc=$this->create('MODSolicitudEfectivo');	
		$this->res=$this->objFunc->eliminarSolicitudEfectivo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function siguienteEstadoSolicitudEfectivo(){
			$this->objFunc=$this->create('MODSolicitudEfectivo');	
		$this->res=$this->objFunc->siguienteEstadoSolicitudEfectivo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function anteriorEstadoSolicitudEfectivo(){
			$this->objFunc=$this->create('MODSolicitudEfectivo');	
		$this->res=$this->objFunc->anteriorEstadoSolicitudEfectivo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function insertarSolicitudEfectivoCompleta(){
		$this->objFunc=$this->create('MODSolicitudEfectivo');	
		if($this->objParam->insertar('id_solicitud_efectivo')){
			$this->res=$this->objFunc->insertarSolicitudEfectivoCompleta($this->objParam);			
		} 
		$this->res->imprimirRespuesta($this->res->generarJson());
	}	
}

?>