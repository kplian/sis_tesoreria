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
require_once(dirname(__FILE__).'/../reportes/RConformidad.php');

class ACTPlanPago extends ACTbase{    
			
	function listarPlanPago(){
		
		if($this->objParam->getParametro('tipo_interfaz')=='PlanPagoRegIni'){
			 $this->objParam->defecto('ordenacion','nro_cuota');
             $this->objParam->defecto('dir_ordenacion','asc');	
        }
		else{
		   $this->objParam->defecto('ordenacion','id_plan_pago');
           $this->objParam->defecto('dir_ordenacion','asc');	
		}
		
		
		if($this->objParam->getParametro('id_gestion')!=''){
            $this->objParam->addFiltro("op.id_gestion = ".$this->objParam->getParametro('id_gestion'));  
        }
		
		if($this->objParam->getParametro('id_obligacion_pago')!=''){
            $this->objParam->addFiltro("plapa.id_obligacion_pago = ".$this->objParam->getParametro('id_obligacion_pago'));  
        }
        
        if($this->objParam->getParametro('filtro_campo')!=''){
            $this->objParam->addFiltro($this->objParam->getParametro('filtro_campo')." = ".$this->objParam->getParametro('filtro_valor'));  
        }
        
        
		$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
        
		
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
		
		if($resultPlanPago->getTipo()=='EXITO'){
        	        
        	    $datosPlanPago = $resultPlanPago->getDatos();
        	    
        		$dataSource->putParameter('estado',$datosPlanPago[0]['estado']);							
        		$dataSource->putParameter('numero_oc',$datosPlanPago[0]['numero_oc']);
        		$dataSource->putParameter('proveedor',$datosPlanPago[0]['proveedor']);
        		$dataSource->putParameter('nro_cuota',$datosPlanPago[0]['nro_cuota']);
        		$dataSource->putParameter('fecha_devengado',$datosPlanPago[0]['fecha_devengado']);
        		$dataSource->putParameter('fecha_pag',$datosPlanPago[0]['fecha_pag']);
        		$dataSource->putParameter('forma_pago',$datosPlanPago[0]['forma_pago']);
        		$dataSource->putParameter('tipo_pago',$datosPlanPago[0]['tipo_pago']);
        		$dataSource->putParameter('tipo',$datosPlanPago[0]['tipo']);
        		$dataSource->putParameter('modalidad',$datosPlanPago[0]['modalidad']);
        		$dataSource->putParameter('moneda',$datosPlanPago[0]['moneda']);
        		$dataSource->putParameter('tipo_cambio',$datosPlanPago[0]['tipo_cambio']);
        		
        		$dataSource->putParameter('codigo_moneda',$datosPlanPago[0]['codigo_moneda']);
        		
        		$dataSource->putParameter('importe',$datosPlanPago[0]['importe']);
        		$dataSource->putParameter('monto_no_pagado',$datosPlanPago[0]['monto_no_pagado']);
        		$dataSource->putParameter('otros_descuentos',$datosPlanPago[0]['otros_descuentos']);
        		$dataSource->putParameter('descuento_ley',$datosPlanPago[0]['descuento_ley']);
        		$dataSource->putParameter('monto_ejecutado_total',$datosPlanPago[0]['monto_ejecutado_total']);
        		$dataSource->putParameter('liquido_pagable',$datosPlanPago[0]['liquido_pagable']);
        		$dataSource->putParameter('total_pagado',$datosPlanPago[0]['total_pagado']);
        		$dataSource->putParameter('fecha_reg',$datosPlanPago[0]['fecha_reg']);
        		
        		$dataSource->putParameter('monto_excento',$datosPlanPago[0]['monto_excento']);
        		
        		
        		
        		
        		//preapra conslta del prorrateo
        		
        		$this->objParam->addFiltro("pro.id_plan_pago = ".$this->objParam->getParametro('id_plan_pago'));  
       
        		$this->objParam->addParametroConsulta('ordenacion','id_prorrateo');
                $this->objParam->addParametroConsulta('dir_ordenacion','ASC');
                $this->objParam->addParametroConsulta('cantidad',1000);
                $this->objParam->addParametroConsulta('puntero',0);
               
                //listado del detalle                        
                $this->objFunc=$this->create('MODProrrateo');
                $resultProrrateo=$this->objFunc->listarProrrateo($this->objParam);
        		
               
                if($resultProrrateo->getTipo()=='EXITO'){
                		        
                	    $datosProrrateo = $resultProrrateo->getDatos();
                        $dataSource->setDataSet($datosProrrateo);    
                        
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
                else{
                     
                     $resultProrrateo->imprimirRespuesta($resultProrrateo->generarJson());
                    
                }
         }
        else
        {
             $resultPlanPago->imprimirRespuesta($resultPlanPago->generarJson());
        }     																	
	}

     function siguienteEstadoPlanPago(){
        $this->objFunc=$this->create('MODPlanPago');  
        
        $this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
        
        $this->res=$this->objFunc->siguienteEstadoPlanPago($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    
     function anteriorEstadoPlanPago(){
        $this->objFunc=$this->create('MODPlanPago');  
        $this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
        $this->res=$this->objFunc->anteriorEstadoPlanPago($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
	 
	 function marcarRevisadoPlanPago(){
        $this->objFunc=$this->create('MODPlanPago');  
        $this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
        $this->res=$this->objFunc->marcarRevisadoPlanPago($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
	 
	 function generarConformidad(){
        $this->objFunc=$this->create('MODPlanPago');  
        $this->res=$this->objFunc->generarConformidad($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
	 
	 
    
	
	function verificarDisponibilidad(){
		$this->objParam->defecto('ordenacion','desc_partida');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPlanPago','verificarDisponibilidad');
		} else{
			$this->objFunc=$this->create('MODPlanPago');
			$this->res=$this->objFunc->verificarDisponibilidad($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function reporteActaConformidad()	{
		
		if ($this->objParam->getParametro('id_proceso_wf') != '') {
			$this->objParam->addFiltro("pp.id_proceso_wf = ". $this->objParam->getParametro('id_proceso_wf'));
		}
		
		if ($this->objParam->getParametro('firmar') == 'si') {
	    	$firmar = 'si';
			$fecha_firma = $this->objParam->getParametro('fecha_firma');
			$usuario_firma = $this->objParam->getParametro('usuario_firma');
	    } else {
	    	$firmar = 'no';
			$fecha_firma = '';
			$usuario_firma = '';
	    }
		
		$this->objFunc=$this->create('MODPlanPago');	
		
		$this->res=$this->objFunc->listarActaMaestro($this->objParam);
		
		//$this->objFunc=$this->create('MODPlanPago');
		//$this->res2=$this->objFunc->listarActaDetalle($this->objParam);
		//obtener titulo del reporte
		
		//Genera el nombre del archivo (aleatorio + titulo)
		$nombreArchivo=uniqid(md5(session_id()).'ACTACONFORMIDAD');
		
		
		$nombreArchivo.='.pdf';
		$this->objParam->addParametro('orientacion','P');
		$this->objParam->addParametro('tamano','LETTER');		
		$this->objParam->addParametro('titulo_archivo','ACTA DE CONFORMIDAD');
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		$this->objParam->addParametro('firmar',$firmar); 
		$this->objParam->addParametro('fecha_firma',$fecha_firma); 
		$this->objParam->addParametro('usuario_firma',$usuario_firma); 
		//Instancia la clase de pdf
		$this->objReporteFormato=new RConformidad($this->objParam);
				
		$firma = $this->objReporteFormato->generarReporte($this->res->getDatos());
		$this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
		
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
										'Se generó con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		
		//anade los datos de firma a la respuesta
		if ($firmar == 'si') {
			$this->mensajeExito->setDatos($firma);
		}
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
				
	}

	function listarPagosXConcepto() {
		
		$this->objParam->defecto('ordenacion','id_plan_pago');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_gestion')!=''){
            $this->objParam->addFiltro("op.id_gestion = ".$this->objParam->getParametro('id_gestion'));  
        }
        
        if($this->objParam->getParametro('filtro_campo')!=''){
            $this->objParam->addFiltro($this->objParam->getParametro('filtro_campo')." = ".$this->objParam->getParametro('filtro_valor'));  
        }       
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPlanPago','listarPagosXConcepto');
		} else{
			
			$this->objFunc=$this->create('MODPlanPago');
			
			$this->res=$this->objFunc->listarPagosXConcepto($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

   function listarPagosXProveedor() {
		
		$this->objParam->defecto('ordenacion','id_plan_pago');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_gestion')!=''){
            $this->objParam->addFiltro("id_gestion = ".$this->objParam->getParametro('id_gestion'));  
        }
        
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPlanPago','listarPagosXProveedor');
		} else{
			
			$this->objFunc=$this->create('MODPlanPago');
			
			$this->res=$this->objFunc->listarPagosXProveedor($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
			
}

?>