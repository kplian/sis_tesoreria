<?php
/**
*@package pXP
*@file gen-ACTCaja.php
*@author  (admin)
*@date 16-12-2013 20:43:44
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTCaja extends ACTbase{    
			
	function listarCaja(){
		$this->objParam->defecto('ordenacion','id_caja');

		$this->objParam->defecto('dir_ordenacion','asc');
		/*
		if($this->objParam->getParametro('tipo_interfaz')=='cajaVb'){
			$this->objParam->addFiltro("pc.estado in (''solicitado'')");
		}
		
		if($this->objParam->getParametro('tipo_interfaz')=='cajaAbierto'){
			$this->objParam->addFiltro("pc.estado in (''abierto'')");
		}
		*/
		if($this->objParam->getParametro('tipo_interfaz')=='caja'){
			$this->objParam->addFiltro("pc.tipo = ''apertura''");
		}
		
		if($this->objParam->getParametro('con_detalle') == 'si'){
			$this->objParam->addFiltro("caja.tipo_ejecucion = ''con_detalle''");
		}		
		
		if($this->objParam->getParametro('con_detalle') == 'no'){
			$this->objParam->addFiltro("caja.tipo_ejecucion = ''sin_detalle''");
		}
		
		$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]);
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCaja','listarCaja');
		} else{
			$this->objFunc=$this->create('MODCaja');
			
			$this->res=$this->objFunc->listarCaja($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function abrirCerrarCaja(){
		$this->objFunc=$this->create('MODCaja');
		$this->res=$this->objFunc->abrirCerrarCaja($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}	
	
	function insertarCaja(){
		$this->objFunc=$this->create('MODCaja');	
		if($this->objParam->insertar('id_caja')){
			$this->res=$this->objFunc->insertarCaja($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCaja($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCaja(){
			$this->objFunc=$this->create('MODCaja');	
		$this->res=$this->objFunc->eliminarCaja($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function siguienteEstadoCaja(){
		$this->objFunc=$this->create('MODCaja');	
		$this->res=$this->objFunc->siguienteEstadoCaja($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function anteriorEstadoCaja(){
		$this->objFunc=$this->create('MODCaja');	
		$this->res=$this->objFunc->anteriorEstadoCaja($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
}

?>