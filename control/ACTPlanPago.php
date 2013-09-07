<?php
/**
*@package pXP
*@file gen-ACTPlanPago.php
*@author  (admin)
*@date 10-04-2013 15:43:23
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

require_once(dirname(__FILE__).'/../../pxp/pxpReport/ReportWriter.php');
require_once(dirname(__FILE__).'/../reportes/RSolicitudPlanPago.php');
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');

class ACTPlanPago extends ACTbase{    
			
	function listarPlanPago(){
		$this->objParam->defecto('ordenacion','id_plan_pago');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_obligacion_pago')!=''){
            $this->objParam->addFiltro("plapa.id_obligacion_pago = ".$this->objParam->getParametro('id_obligacion_pago'));  
        }
        
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPlanPago','listarPlanPago');
		} else{
			$this->objFunc=$this->create('MODPlanPago');
			
			$this->res=$this->objFunc->listarPlanPago($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarPlanPago(){
		$this->objFunc=$this->create('MODPlanPago');	
		if($this->objParam->insertar('id_plan_pago')){
			$this->res=$this->objFunc->insertarPlanPago($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarPlanPago($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPlanPago(){
			$this->objFunc=$this->create('MODPlanPago');	
		$this->res=$this->objFunc->eliminarPlanPago($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function solicitarDevPag(){
        $this->objFunc=$this->create('MODPlanPago');  
        $this->res=$this->objFunc->solicitarDevPag($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    
    function sincronizarPresupuesto(){
        $this->objFunc=$this->create('MODPlanPago');  
        $this->res=$this->objFunc->sincronizarPresupuesto($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    
    
				
	function solicitudPlanPago(){
					  $dataSource = new DataSource();
							
							$this->objParam->addParametroConsulta('ordenacion','id_plan_pago');
       $this->objParam->addParametroConsulta('dir_ordenacion','ASC');
       $this->objParam->addParametroConsulta('cantidad',1000);
       $this->objParam->addParametroConsulta('puntero',0);
							
							$this->objFunc=$this->create('MODPlanPago');
							$resultPlanPago = $this->objFunc->reportePlanPago($this->objParam);
							$datosPlanPago = $resultPlanPago->getDatos();
							
							$dataSource->putParameter('estado',$datosPlanPago[0]['estado']);							
							$dataSource->putParameter('numero_oc',$datosPlanPago[0]['numero_oc']);
							$dataSource->putParameter('proveedor',$datosPlanPago[0]['proveedor']);
							$dataSource->putParameter('nro_cuota',$datosPlanPago[0]['nro_cuota']);
							$dataSource->putParameter('fecha_devengado',$datosPlanPago[0]['fecha_devengado']);
							$dataSource->putParameter('fecha_pag',$datosPlanPago[0]['fecha_pag']);
							$dataSource->putParameter('forma_pago',$datosPlanPago[0]['forma_pago']);
							$dataSource->putParameter('tipo_pago',$datosPlanPago[0]['tipo_pago']);
							$dataSource->putParameter('modalidad',$datosPlanPago[0]['modalidad']);
							$dataSource->putParameter('moneda',$datosPlanPago[0]['moneda']);
							$dataSource->putParameter('tipo_cambio',$datosPlanPago[0]['tipo_cambio']);
							$dataSource->putParameter('importe',$datosPlanPago[0]['importe']);
							$dataSource->putParameter('monto_no_pagado',$datosPlanPago[0]['monto_no_pagado']);
							$dataSource->putParameter('otros_descuentos',$datosPlanPago[0]['otros_descuentos']);
							$dataSource->putParameter('monto_ejecutado_total',$datosPlanPago[0]['monto_ejecutado_total']);
							$dataSource->putParameter('liquido_pagable',$datosPlanPago[0]['liquido_pagable']);
							$dataSource->putParameter('total_pagado',$datosPlanPago[0]['total_pagado']);
							$dataSource->putParameter('fecha_reg',$datosPlanPago[0]['fecha_reg']);
							
							$dataSource->putParameter('nombre_uo',$datosPlanPago[0]['nombre_uo']);
							$dataSource->putParameter('nombre_programa',$datosPlanPago[0]['nombre_programa']);
							$dataSource->putParameter('nombre_regional',$datosPlanPago[0]['nombre_regional']);
							$dataSource->putParameter('nombre_proyecto',$datosPlanPago[0]['nombre_proyecto']);
							$dataSource->putParameter('nombre_financiador',$datosPlanPago[0]['nombre_financiador']);
							$dataSource->putParameter('nombre_actividad',$datosPlanPago[0]['nombre_actividad']);
							$dataSource->putParameter('nombre_partida',$datosPlanPago[0]['nombre_partida']);
							$dataSource->putParameter('total_pago',$datosPlanPago[0]['total_pago']);
							
							$nombreArchivo = 'SolicitudPlanPago.pdf';
						 
						 $reporte = new RSolicitudPlanPago();
       $reporte->setDataSource($dataSource);	
							$reportWriter = new ReportWriter($reporte, dirname(__FILE__).'/../../reportes_generados/'.$nombreArchivo);
       $reportWriter->writeReport(ReportWriter::PDF);

       $mensajeExito = new Mensaje();
       $mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
       'Se generó con éxito el reporte: '.$nombreArchivo,'control');
       $mensajeExito->setArchivoGenerado($nombreArchivo);
       $this->res = $mensajeExito;
       $this->res->imprimirRespuesta($this->res->generarJson());																	
				}
			
}

?>