<?php
/**
*@package pXP
*@file ACTCuentaBancaria.php
*@author  Gonzalo Sarmiento Sejas
*@date 24-04-2013 15:19:30
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTCuentaBancaria extends ACTbase{    
			
	function listarCuentaBancaria(){
		$this->objParam->defecto('ordenacion','id_cuenta_bancaria');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		
		if($this->objParam->getParametro('id_depto_lb')!=''){
			$this->objParam->addFiltro("deptctab.id_depto = ".$this->objParam->getParametro('id_depto_lb'));
		}
		
		if($this->objParam->getParametro('id_depto_lbs')!=''){
			$this->objParam->addFiltro("deptctab.id_depto in ( ".$this->objParam->getParametro('id_depto_lbs').")");
		}
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCuentaBancaria','listarCuentaBancaria');
		} else{
			$this->objFunc=$this->create('MODCuentaBancaria');
			
			$this->res=$this->objFunc->listarCuentaBancaria($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function listarCuentaBancariaUsuario(){
		$this->objParam->defecto('ordenacion','id_cuenta_bancaria');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_depto_lb')!=''){
			$this->objParam->addFiltro("deptctab.id_depto = ".$this->objParam->getParametro('id_depto_lb'));
		}
		
		/*if($this->objParam->getParametro('permiso')!=''){
			$permisos = explode(',',$this->objParam->getParametro('permiso'));
			
			if(count($permisos)==2)
				$this->objParam->addFiltro("usrbanc.tipo_permiso in (''".$permisos[0].''."'',''".''.$permisos[1]."'')");
			else
				$this->objParam->addFiltro("usrbanc.tipo_permiso = ''".$permisos[0]."''");
		}*/
		
		if($this->objParam->getParametro('id_moneda')!=''){
			$this->objParam->addFiltro("ctaban.id_moneda = ".$this->objParam->getParametro('id_moneda'));
		}
		/*
		if($this->objParam->getParametro('tipo_interfaz')!=''){
			$this->objParam->addFiltro("''".$this->objParam->getParametro('tipo_interfaz')."''=ANY(fin.sw_tipo_interfaz)");
		}
		*/	
		$this->objFunc=$this->create('MODCuentaBancaria');			
		$this->res=$this->objFunc->listarCuentaBancariaUsuario($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarCuentaBancaria(){
		$this->objFunc=$this->create('MODCuentaBancaria');	
		if($this->objParam->insertar('id_cuenta_bancaria')){
			$this->res=$this->objFunc->insertarCuentaBancaria($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCuentaBancaria($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCuentaBancaria(){
			$this->objFunc=$this->create('MODCuentaBancaria');	
		$this->res=$this->objFunc->eliminarCuentaBancaria($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
}

?>