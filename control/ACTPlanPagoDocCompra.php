<?php
/**
*@package pXP
*@file gen-ACTPlanPagoDocCompra.php
*@author  (admin)
*@date 25-01-2018 15:16:48
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTPlanPagoDocCompra extends ACTbase{    
			
	function listarPlanPagoDocCompra(){
		$this->objParam->defecto('ordenacion','tobligacion_pago_doc_compra');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_plan_pago')!=''){
			$this->objParam->addFiltro("opdcomp.id_plan_pago = ".$this->objParam->getParametro('id_plan_pago'));	
		}

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPlanPagoDocCompra','listarPlanPagoDocCompra');
		} else{
			$this->objFunc=$this->create('MODPlanPagoDocCompra');
			
			$this->res=$this->objFunc->listarPlanPagoDocCompra($this->objParam);
		}

		$temp = Array();
		$temp['importe_ice'] = $this->res->extraData['total_importe_ice'];
		$temp['importe_excento'] = $this->res->extraData['total_importe_excento'];
		$temp['importe_it'] = $this->res->extraData['total_importe_it'];
		$temp['importe_iva'] = $this->res->extraData['total_importe_iva'];
		$temp['importe_descuento'] = $this->res->extraData['total_importe_descuento'];
		$temp['importe_doc'] = $this->res->extraData['total_importe_doc'];			
		$temp['importe_retgar'] = $this->res->extraData['total_importe_retgar'];
		$temp['importe_anticipo'] = $this->res->extraData['total_importe_anticipo'];
		$temp['importe_pendiente'] = $this->res->extraData['tota_importe_pendiente'];
		$temp['importe_neto'] = $this->res->extraData['total_importe_neto'];
		$temp['importe_descuento_ley'] = $this->res->extraData['total_importe_descuento_ley'];
		$temp['importe_pago_liquido'] = $this->res->extraData['total_importe_pago_liquido'];	
		$temp['importe_aux_neto'] = $this->res->extraData['total_importe_aux_neto'];	
				
		$temp['tipo_reg'] = 'summary';
		$temp['id_doc_compra_venta'] = 0;

		$this->res->total++;
		$this->res->addLastRecDatos($temp);
		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarDocCompleto(){
		$this->objFunc=$this->create('MODPlanPagoDocCompra');	
		if($this->objParam->insertar('id_doc_compra_venta')){
			$this->res=$this->objFunc->insertarDocCompleto($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarDocCompleto($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarDocCompraVenta(){
		$this->objFunc=$this->create('MODPlanPagoDocCompra');	
		$this->res=$this->objFunc->eliminarDocCompraVenta($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>