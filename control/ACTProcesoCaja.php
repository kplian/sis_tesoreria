<?php
/**
*@package pXP
*@file gen-ACTProcesoCaja.php
*@author  (gsarmiento)
*@date 21-12-2015 20:15:22
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTProcesoCaja extends ACTbase{

	function listarProcesoCaja(){
		$this->objParam->defecto('ordenacion','id_proceso_caja');

		$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]);

		if($this->objParam->getParametro('id_caja')!='')
		{
			$this->objParam-> addFiltro('ren.id_caja ='.$this->objParam->getParametro('id_caja'));
		}
		
		if($this->objParam->getParametro('pes_estado')!='')
		{			
			if($this->objParam->getParametro('pes_estado')=='no_contabilizados'){
				 $this->objParam->addFiltro("ren.estado in (''supconta'',''vbconta'',''pendiente'')");
			}
			if($this->objParam->getParametro('pes_estado')=='contabilizados'){
				 $this->objParam->addFiltro("ren.estado in (''contabilizado'',''rendido'',''entregado'')");
			}			
		}

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODProcesoCaja','listarProcesoCaja');
		} else{
			$this->objFunc=$this->create('MODProcesoCaja');

			$this->res=$this->objFunc->listarProcesoCaja($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function insertarProcesoCaja(){
		$this->objFunc=$this->create('MODProcesoCaja');
		if($this->objParam->insertar('id_proceso_caja')){
			$this->res=$this->objFunc->insertarProcesoCaja($this->objParam);
		} else{
			$this->res=$this->objFunc->modificarProcesoCaja($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function eliminarProcesoCaja(){
			$this->objFunc=$this->create('MODProcesoCaja');
		$this->res=$this->objFunc->eliminarProcesoCaja($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function siguienteEstadoProcesoCaja(){
		$this->objFunc=$this->create('MODProcesoCaja');
		$this->res=$this->objFunc->siguienteEstadoProcesoCaja($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function anteriorEstadoProcesoCaja(){
			$this->objFunc=$this->create('MODProcesoCaja');
		$this->res=$this->objFunc->anteriorEstadoProcesoCaja($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function insertarCajaDeposito(){
		$this->objFunc=$this->create('MODProcesoCaja');
		if($this->objParam->insertar('id_libro_bancos')){
			$this->res=$this->objFunc->insertarCajaDeposito($this->objParam);
		} else{
			$this->res=$this->objFunc->modificarCajaDeposito($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function listarCajaDeposito(){
		$this->objParam->defecto('ordenacion','id_proceso_caja');
		/*
		if($this->objParam->getParametro('id_proceso_caja')!='')
		{
			$this->objParam-> addFiltro('t.columna_pk_valor ='.$this->objParam->getParametro('id_proceso_caja'));
		}
		*/
		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODProcesoCaja','listarCajaDeposito');
		} else{
			$this->objFunc=$this->create('MODProcesoCaja');

			$this->res=$this->objFunc->listarCajaDeposito($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function eliminarCajaDeposito(){
		$this->objFunc=$this->create('MODProcesoCaja');
		$this->res=$this->objFunc->eliminarCajaDeposito($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function relacionarDeposito(){
		$this->objFunc=$this->create('MODProcesoCaja');
		$this->res=$this->objFunc->relacionarDeposito($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
}

?>
