<?php
/**
*@package pXP
*@file ACTRendicionEfectivo.php
*@author  (gsarmiento)
*@date 12-02-2016
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTRendicionEfectivo extends ACTbase{    
			
	function listarRendicionEfectivo(){
		$this->objParam->defecto('ordenacion','id_proceso_caja');
		
		$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]);
		
		if($this->objParam->getParametro('id_caja')!='')
		{
			$this->objParam-> addFiltro('ren.id_caja ='.$this->objParam->getParametro('id_caja'));
		}

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODRendicionEfectivo','listarRendicionEfectivo');
		} else{
			$this->objFunc=$this->create('MODRendicionEfectivo');
			
			$this->res=$this->objFunc->listarRendicionEfectivo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarRendicionEfectivo(){
		$this->objFunc=$this->create('MODRendicionEfectivo');	
		if($this->objParam->insertar('id_proceso_caja')){
			$this->res=$this->objFunc->insertarRendicionEfectivo($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarRendicionEfectivo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarRendicionEfectivo(){
			$this->objFunc=$this->create('MODRendicionEfectivo');	
		$this->res=$this->objFunc->eliminarRendicionEfectivo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}	
	
	function siguienteEstadoRendicionEfectivo(){
		$this->objFunc=$this->create('MODRendicionEfectivo');	
		$this->res=$this->objFunc->siguienteEstadoRendicionEfectivo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function anteriorEstadoRendicionEfectivo(){
			$this->objFunc=$this->create('MODRendicionEfectivo');	
		$this->res=$this->objFunc->anteriorEstadoRendicionEfectivo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
}

?>