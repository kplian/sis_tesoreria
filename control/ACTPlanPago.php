<?php
/**
*@package pXP
*@file gen-ACTPlanPago.php
*@author  (admin)
*@date 10-04-2013 15:43:23
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*
*@date 30/08/2018
*@description añadida la columna retenciones de garantía para mostrar el reporte de solicitud de pago
		ISSUE	FORK 	   FECHA			AUTHOR			DESCRIPCION
 		  #5	EndeETR		27/12/2018		EGS				Se añadio el dato de codigo de proveedor
 *        #35   ETR         07/10/2019      RAC            Adicionar descuento de anticipos en reporte de plan de pagos 
 *        #41   ENDETR      16/12/2019      JUAN           Reporte de información de pago
 * */

require_once(dirname(__FILE__).'/../../pxp/pxpReport/ReportWriter.php');
require_once(dirname(__FILE__).'/../reportes/RSolicitudPlanPago.php');
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');
require_once(dirname(__FILE__).'/../reportes/RConformidad.php');
require_once(dirname(__FILE__).'/../reportes/RProcesoConRetencionXLS.php');

require_once(dirname(__FILE__).'/../reportes/RConsultaOpObligacionPagoXls.php');
require_once(dirname(__FILE__).'/../reportes/RObligacionPagosPendientesXls.php');

require_once(dirname(__FILE__).'/../reportes/RInfPago.php');

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
		
		if($this->objParam->getParametro('pes_estado')=='internacional'){
             $this->objParam->addFiltro("depto.prioridad = 3");
        }
		if($this->objParam->getParametro('pes_estado')=='nacional'){
             $this->objParam->addFiltro("depto.prioridad  != 3");
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
        $this->objFunc1=$this->create('MODPlanPago');

		if($resultPlanPago->getTipo()=='EXITO'){
        	        
        	    $datosPlanPago = $resultPlanPago->getDatos();
                $resultGCCPlanPago = $this->objFunc1->reporteGCCPlanPago($this->objParam);
                $listaCentroCosto = $resultGCCPlanPago->getDatos();
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
        		$dataSource->putParameter('monto_retgar_mo',$datosPlanPago[0]['monto_retgar_mo']);
        		$dataSource->putParameter('otros_descuentos',$datosPlanPago[0]['otros_descuentos']);
                $dataSource->putParameter('descuento_ley',$datosPlanPago[0]['descuento_ley']);
        		$dataSource->putParameter('monto_ejecutado_total',$datosPlanPago[0]['monto_ejecutado_total']);
        		$dataSource->putParameter('liquido_pagable',$datosPlanPago[0]['liquido_pagable']);
        		$dataSource->putParameter('total_pagado',$datosPlanPago[0]['total_pagado']);
        		$dataSource->putParameter('fecha_reg',$datosPlanPago[0]['fecha_reg']);
        		
        		$dataSource->putParameter('monto_excento',$datosPlanPago[0]['monto_excento']);
				
        		$dataSource->putParameter('num_tramite',$datosPlanPago[0]['num_tramite']);
        		$dataSource->putParameter('nro_contrato',$datosPlanPago[0]['nro_contrato']);
				$dataSource->putParameter('pago_borrador',$datosPlanPago[0]['pago_borrador']);
				$dataSource->putParameter('codigo_proveedor',$datosPlanPago[0]['codigo_proveedor']);
				$dataSource->putParameter('descuento_anticipo',$datosPlanPago[0]['descuento_anticipo']); //#35
        		$dataSource->putParameter("lista_centro_costo",$listaCentroCosto);
        		
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
			$nombre_usuario_firma = $this->objParam->getParametro('nombre_usuario_firma');
	    } else {
	    	$firmar = 'no';
			$fecha_firma = '';
			$usuario_firma = '';
			$nombre_usuario_firma = '';
	    }
		
		$this->objFunc=$this->create('MODPlanPago');	
		
		$this->res=$this->objFunc->listarActaMaestro($this->objParam);
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
		$this->objParam->addParametro('nombre_usuario_firma',$nombre_usuario_firma);  
		//Instancia la clase de pdf
		$this->objReporteFormato=new RConformidad($this->objParam);
				
		$firma = $this->objReporteFormato->generarActa($this->res->getDatos());
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
   
   function listarPagos() {
		
		$this->objParam->defecto('ordenacion','id_plan_pago');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_gestion')!=''){
            $this->objParam->addFiltro("id_gestion = ".$this->objParam->getParametro('id_gestion'));  
        }
        
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPlanPago','listarPagos');
		} else{
			
			$this->objFunc=$this->create('MODPlanPago');
			
			$this->res=$this->objFunc->listarPagos($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
   
   function listadosPagosRelacionados() {
		
		$this->objParam->defecto('ordenacion','id_plan_pago');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_plan_pago')!=''){
            $this->objParam->addFiltro("id_plan_pago != ".$this->objParam->getParametro('id_plan_pago'));  
        }
		
		if($this->objParam->getParametro('nro_tramite')!=''){
            $this->objParam->addFiltro("num_tramite like ''%".$this->objParam->getParametro('nro_tramite')."%''");  
        }
		
		
        
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPlanPago','listadosPagosRelacionados');
		} else{
			$this->objFunc=$this->create('MODPlanPago');
			$this->res=$this->objFunc->listadosPagosRelacionados($this->objParam);
		}
		
		if($this->objParam->getParametro('resumen')!='no'){
			//adicionar una fila al resultado con el summario
			$temp = Array();
			$temp['monto_mb'] = $this->res->extraData['monto_mb'];
			$temp['tipo_reg'] = 'summary';
			$temp['id_plan_pago'] = 0;
			
			$this->res->total++;
			
			$this->res->addLastRecDatos($temp);
		}
		
		
		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
   
   function getConfigPago(){
		$this->objFunc=$this->create('MODPlanPago');	
		$this->res=$this->objFunc->getConfigPago($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	function reporteProcesoConRetencion()
    {

        //$this->objParam->getParametro('fecha_ini');
        //$this->objParam->getParametro('fecha_fin');

        $this->objFunc = $this->create('MODPlanPago');
        $this->res = $this->objFunc->listarProcesoConRetencion($this->objParam);
        //var_dump( $this->res);exit;
        //obtener titulo de reporte
        $titulo = 'Proceso Con Retencion';
        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo = uniqid(md5(session_id()) . $titulo);

        $nombreArchivo .= '.xls';
        $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
        $this->objParam->addParametro('datos', $this->res->datos);
        //Instancia la clase de excel
        $this->objReporteFormato = new RProcesoConRetencionXLS($this->objParam);
        $this->objReporteFormato->generarDatos();
        $this->objReporteFormato->generarReporte();



        $this->mensajeExito = new Mensaje();
        $this->mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado',
            'Se generó con éxito el reporte: ' . $nombreArchivo, 'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());


    }
	function consultaOpPlanPago(){
		
		$var='';
		
        $this->objFun=$this->create('MODPlanPago');
		if($this->objParam->getParametro('tipo_repo') == 'consulta_op_plan_pago'){
			$this->res = $this->objFun->consultaOpPlanPago();
		}else{
			$this->res = $this->objFun->obligacionPagosPendientes();
		}
		
		
		if($this->objParam->getParametro('formato_reporte') == 'xls'){


            if($this->res->getTipo()=='ERROR'){
                $this->res->imprimirRespuesta($this->res->generarJson());
                exit;
            }

			$var = 'Consulta OP por plan de pagos';
            //obtener titulo de reporte
            $titulo ='Consulta OP por plan de pagos';
            //Genera el nombre del archivo (aleatorio + titulo)
            $nombreArchivo=uniqid(md5(session_id()).$titulo);
            $nombreArchivo.='.xls';

            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            $this->objParam->addParametro('datos',$this->res->datos);
			$this->objParam->addParametro('gestion',$this->objParam->getParametro('gestion'));
			
			$this->objParam->addParametro('var',$var);
            //Instancia la clase de excel
            if($this->objParam->getParametro('tipo_repo') == 'consulta_op_plan_pago'){
               $this->objReporteFormato=new RConsultaOpObligacionPagoXls($this->objParam);
			}else{
			   $this->objReporteFormato=new RObligacionPagosPendientesXls($this->objParam);
			}
			
            $this->objReporteFormato->generarDatos();
            $this->objReporteFormato->generarReporte();

            $this->mensajeExito=new Mensaje();
            $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
                'Se generó con éxito el reporte: '.$nombreArchivo,'control');
            $this->mensajeExito->setArchivoGenerado($nombreArchivo);
            $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

        } 
	}	
	function datosCabeceraInfPago(){//#41
		$dataSource = new DataSource();			
	
		$this->objFunc = $this->create('MODPlanPago');	
		$cbteHeader = $this->objFunc->ReporteInfPago($this->objParam);

		if($cbteHeader->getTipo() == 'EXITO'){							
			$dataSource->putParameter('cabecera',$cbteHeader->getDatos());								
			return $dataSource;
		}
		else{
			$cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
		}
	}
	function ReporteInfPago(){	//#41
		$dataSource = $this->datosCabeceraInfPago();				

		$nombreArchivo = uniqid(md5(session_id()).'-InfPago') . '.pdf'; 		
		$tamano = 'LETTER';
		$orientacion = 'p';
		$this->objParam->addParametro('orientacion',$orientacion);
		$this->objParam->addParametro('tamano',$tamano);		
		$this->objParam->addParametro('titulo_archivo',$titulo);        
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		
		$reporte = new RInfPago($this->objParam); 		
		$reporte->datosHeader($dataSource);
		$reporte->generarReporte();
		$reporte->output($reporte->url_archivo,'F');
		
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
	}	

}

?>