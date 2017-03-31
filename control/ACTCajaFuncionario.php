<?php
/**
*@package pXP
*@file gen-ACTCajaFuncionario.php
*@author  (gsarmiento)
*@date 15-03-2017 20:10:37
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTCajaFuncionario extends ACTbase{
			
	function listarCajaFuncionario(){
		$this->objParam->defecto('ordenacion','id_caja_funcionario');

		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_caja')!='')
		{
			$this->objParam-> addFiltro('cajusu.id_caja ='.$this->objParam->getParametro('id_caja'));
		}

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCajaFuncionario','listarCajaFuncionario');
		} else{
			$this->objFunc=$this->create('MODCajaFuncionario');
			
			$this->res=$this->objFunc->listarCajaFuncionario($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarCajaFuncionario(){
		$this->objFunc=$this->create('MODCajaFuncionario');
		if($this->objParam->insertar('id_caja_funcionario')){
			$this->res=$this->objFunc->insertarCajaFuncionario($this->objParam);
		} else{			
			$this->res=$this->objFunc->modificarCajaFuncionario($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCajaFuncionario(){
			$this->objFunc=$this->create('MODCajaFuncionario');
		$this->res=$this->objFunc->eliminarCajaFuncionario($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>