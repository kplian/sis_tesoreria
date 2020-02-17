<!--
*	ISSUE   FORK	     Fecha 		     Autor		        Descripcion
*  #56     ENDETR       17/02/2020      Manuel Guerra      cambio de fechas(periodo) de un documento en la rendcion
-->

<?php
/**
*@package pXP
*@file ACTSolicitudRendicionDet.php
*@author  (gsarmiento)
*@date 16-12-2015 15:14:01
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTSolicitudRendicionDet extends ACTbase{    
			
	function listarSolicitudRendicionDet(){
		$this->objParam->defecto('ordenacion','id_solicitud_rendicion_det');

		if($this->objParam->getParametro('id_solicitud_efectivo')!=''){
			if ($this->objParam->getParametro('interfaz')=='aprobacion_facturas'){
				$this->objParam->addFiltro("rend.id_solicitud_efectivo = ".$this->objParam->getParametro('id_solicitud_efectivo'));	
			}elseif ($this->objParam->getParametro('interfaz')=='facturas_rendicion'){
				$this->objParam->addFiltro("solren.id_solicitud_efectivo_fk = ".$this->objParam->getParametro('id_solicitud_efectivo'));	
				$this->objParam->addFiltro("solren.estado=''rendido''");	
			}else{
				$this->objParam->addFiltro("solefe.id_solicitud_efectivo = ".$this->objParam->getParametro('id_solicitud_efectivo'));	
				$this->objParam->addFiltro("solren.estado=''borrador''");	
			}
		}
		
		if($this->objParam->getParametro('id_proceso_caja')!=''){
			$this->objParam->addFiltro("id_proceso_caja = ".$this->objParam->getParametro('id_proceso_caja'));	
		}

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODSolicitudRendicionDet','listarSolicitudRendicionDet');
		} else{
			$this->objFunc=$this->create('MODSolicitudRendicionDet');
			
			$this->res=$this->objFunc->listarSolicitudRendicionDet($this->objParam);
		}
		
		$temp = Array();
			$temp['monto'] = $this->res->extraData['monto'];	
			$temp['tipo'] = 'summary';
			$temp['id_solicitud_rendicion_det'] = 0;			
			
			$this->res->total++;
			
			$this->res->addLastRecDatos($temp);
			
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarSolicitudRendicionDet(){
		$this->objFunc=$this->create('MODSolicitudRendicionDet');	
		if($this->objParam->insertar('id_solicitud_rendicion_det')){
			$this->res=$this->objFunc->insertarSolicitudRendicionDet($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarSolicitudRendicionDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function insertarRendicionDocCompleto(){
		
		$this->objParam->addParametro('tipo_solicitud','rendicion');
		
		$this->objFunc=$this->create('MODSolicitudRendicionDet');	
		if($this->objParam->insertar('id_doc_compra_venta')){
			$this->res=$this->objFunc->insertarRendicionDocCompleto($this->objParam);			
		} else{
			//TODO			
			//$this->res=$this->objFunc->modificarSolicitud($this->objParam);
			//trabajar en la modificacion compelta de solicitud ....			
			$this->res=$this->objFunc->modificarRendicionDocCompleto($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarSolicitudRendicionDet(){
			$this->objFunc=$this->create('MODSolicitudRendicionDet');	
		$this->res=$this->objFunc->eliminarSolicitudRendicionDet($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function devolverFactura(){
		$this->objFunc=$this->create('MODSolicitudRendicionDet');
		$this->res=$this->objFunc->devolverFactura($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function excluirFactura(){
		$this->objFunc=$this->create('MODSolicitudRendicionDet');
		$this->res=$this->objFunc->excluirFactura($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	/*
	function listarFacturasRendidas(){
		$this->objParam->defecto('ordenacion','id_solicitud_rendicion_det');

		if($this->objParam->getParametro('id_solicitud_efectivo')!=''){
			if ($this->objParam->getParametro('interfaz')=='aprobacion_facturas'){
				$this->objParam->addFiltro("rend.id_solicitud_efectivo = ".$this->objParam->getParametro('id_solicitud_efectivo'));	
			}elseif ($this->objParam->getParametro('interfaz')=='facturas_rendicion'){
				$this->objParam->addFiltro("solefe.id_solicitud_efectivo_fk = ".$this->objParam->getParametro('id_solicitud_efectivo'));	
			}else{
				$this->objParam->addFiltro("solefe.id_solicitud_efectivo = ".$this->objParam->getParametro('id_solicitud_efectivo'));	
				$this->objParam->addFiltro("solren.estado=''borrador''");	
			}
		}
		
		if($this->objParam->getParametro('id_proceso_caja')!=''){
			$this->objParam->addFiltro("id_proceso_caja = ".$this->objParam->getParametro('id_proceso_caja'));	
		}

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODSolicitudRendicionDet','listarSolicitudRendicionDet');
		} else{
			$this->objFunc=$this->create('MODSolicitudRendicionDet');
			
			$this->res=$this->objFunc->listarSolicitudRendicionDet($this->objParam);
		}
		
		$temp = Array();
			$temp['monto'] = $this->res->extraData['monto'];	
			$temp['tipo'] = 'summary';
			$temp['id_solicitud_rendicion_det'] = 0;			
			
			$this->res->total++;
			
			$this->res->addLastRecDatos($temp);
			
		$this->res->imprimirRespuesta($this->res->generarJson());
	}*/
	
	function obtener_item_monto(){
		$this->objFunc=$this->create('MODSolicitudRendicionDet');
		$this->res=$this->objFunc->obtener_item_monto($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
		
	function listarSolicitudIngresoDet(){
		if($this->objParam->getParametro('id_proceso_caja')!=''){
			$this->objParam->addFiltro("id_proceso_caja = ".$this->objParam->getParametro('id_proceso_caja'));	
		}
		
		$this->objFunc=$this->create('MODSolicitudRendicionDet');			
		$this->res=$this->objFunc->listarSolicitudIngresoDet($this->objParam);		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	//
	function ModificarDocumento(){
		$this->objFunc=$this->create('MODSolicitudRendicionDet');
		$this->res=$this->objFunc->ModificarDocumento($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
}

?>