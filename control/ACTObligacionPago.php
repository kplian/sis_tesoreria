<?php
/**
*@package pXP
*@file ACTObligacionPago.php
*@author  Gonzalo Sarmiento Sejas
*@date 02-04-2013 16:01:32
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
require_once(dirname(__FILE__).'/../../pxp/pxpReport/ReportWriter.php');
require_once(dirname(__FILE__).'/../reportes/RComEjePag.php');
require_once(dirname(__FILE__).'/../reportes/RPlanesPago.php');
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');
require_once(dirname(__FILE__).'/../reportes/RProcesosPendientesAdquisiciones.php');
require_once(dirname(__FILE__).'/../reportes/RProcesosPendientesContabilidad.php');
require_once(dirname(__FILE__).'/../reportes/RPagosSinDocumentosXls.php');
require_once(dirname(__FILE__).'/../reportes/RCertificacionPresupuestaria.php');


class ACTObligacionPago extends ACTbase{    
			
	function listarObligacionPago(){
		$this->objParam->defecto('ordenacion','id_obligacion_pago');
		$this->objParam->defecto('dir_ordenacion','asc');		
		$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
		
		if($this->objParam->getParametro('id_obligacion_pago')!=''){
			$this->objParam->addFiltro("obpg.id_obligacion_pago = ".$this->objParam->getParametro('id_obligacion_pago'));
		}
		
		if($this->objParam->getParametro('pes_estado')=='otros'){
             $this->objParam->addFiltro("obpg.tipo_obligacion not  in (''pago_unico'',''pago_directo'')");
        }
		if($this->objParam->getParametro('pes_estado')=='pago_directo'){
             $this->objParam->addFiltro("obpg.tipo_obligacion  in (''pago_directo'')");
        }
		if($this->objParam->getParametro('pes_estado')=='pago_unico'){
             $this->objParam->addFiltro("obpg.tipo_obligacion  in (''pago_unico'')");
        }

		if($this->objParam->getParametro('pago_simple')=='si'){
             $this->objParam->addFiltro("obpg.estado  in (''registrado'',''en_pago'',''finalizado'')");
        }
		
		
		if($this->objParam->getParametro('filtro_campo')!=''){
            $this->objParam->addFiltro($this->objParam->getParametro('filtro_campo')." = ".$this->objParam->getParametro('filtro_valor'));  
        }
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODObligacionPago','listarObligacionPago');
		} else{
			$this->objFunc=$this->create('MODObligacionPago');
			
			$this->res=$this->objFunc->listarObligacionPago($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	/*
	
	  Listado de obligacion de pago directas, para solicitudes individuales o por asistentes
	
	*/
	
	function listarObligacionPagoSol(){
        $this->objParam->defecto('ordenacion','id_obligacion_pago');
        $this->objParam->defecto('dir_ordenacion','asc');
        
        $this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
        
        
		if($this->objParam->getParametro('tipo_interfaz')=='obligacionPagoUnico'){
            $this->objParam->addFiltro("obpg.tipo_obligacion = ''pago_unico''");
        }
		
		if($this->objParam->getParametro('tipo_interfaz')=='obligacionPagoSol'){
            $this->objParam->addFiltro("obpg.tipo_obligacion in (''pago_directo'',''rrhh'')");
        }
		
		if($this->objParam->getParametro('tipo_interfaz')=='obligacionPagoAdq'){
            $this->objParam->addFiltro("obpg.tipo_obligacion = ''adquisiciones''");
        }
        
		
        
        if($this->objParam->getParametro('id_obligacion_pago')!=''){
            $this->objParam->addFiltro("obpg.id_obligacion_pago = ".$this->objParam->getParametro('id_obligacion_pago'));
        }
		
		if($this->objParam->getParametro('filtro_campo')!=''){
            $this->objParam->addFiltro($this->objParam->getParametro('filtro_campo')." = ".$this->objParam->getParametro('filtro_valor'));  
        }
        
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODObligacionPago','listarObligacionPagoSol');
        } else{
            $this->objFunc=$this->create('MODObligacionPago');
            
            $this->res=$this->objFunc->listarObligacionPagoSol($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
				
	/*
	 * Author:  		 RAC - KPLIAN
	 * Date:   			 19/02/2015
	 * Description		 insertar obligaciones de pago unicas  
	 * */
	
	function insertarObligacionCompleta(){
		$this->objFunc=$this->create('MODObligacionPago');	
		if($this->objParam->insertar('id_obligacion_pago')){
			$this->res=$this->objFunc->insertarObligacionCompleta($this->objParam);			
		} else{			
			//TODO .. trabajar en la edicion
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function insertarObligacionPago(){
		$this->objFunc=$this->create('MODObligacionPago');	
		if($this->objParam->insertar('id_obligacion_pago')){
			$this->res=$this->objFunc->insertarObligacionPago($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarObligacionPago($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarObligacionPago(){
			$this->objFunc=$this->create('MODObligacionPago');	
		$this->res=$this->objFunc->eliminarObligacionPago($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function modificarObsPresupuestos(){
			$this->objFunc=$this->create('MODObligacionPago');	
		$this->res=$this->objFunc->modificarObsPresupuestos($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	
	function extenderOp(){
		$this->objFunc=$this->create('MODObligacionPago');	
		$this->res=$this->objFunc->extenderOp($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function modificarObsPoa(){
		$this->objFunc=$this->create('MODObligacionPago');	
		$this->res=$this->objFunc->modificarObsPoa($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	
	
	
	function insertarAjustes(){
			$this->objFunc=$this->create('MODObligacionPago');	
		$this->res=$this->objFunc->insertarAjustes($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function finalizarRegistro(){
        $this->objFunc=$this->create('MODObligacionPago');  
        $this->res=$this->objFunc->finalizarRegistro($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
	
	function siguienteEstadoObligacion(){
        $this->objFunc=$this->create('MODObligacionPago');  
        $this->res=$this->objFunc->siguienteEstadoObligacion($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    
    function anteriorEstadoObligacion(){
        $this->objFunc=$this->create('MODObligacionPago');  
        $this->res=$this->objFunc->anteriorEstadoObligacion($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    
    function obtenerFaltante(){
        $this->objFunc=$this->create('MODObligacionPago');  
        $this->res=$this->objFunc->obtenerFaltante($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    
    
    function listarDeptoFiltradoObligacionPago(){
            
        $this->objFunc=$this->create('MODObligacionPago'); 
        $this->res=$this->objFunc->obtnerUosEpsDetalleObligacion($this->objParam);
        
        //si sucede un error
        if($this->res->getTipo()=='ERROR'){
            
            $this->res->imprimirRespuesta($this->res->generarJson());
            exit;
        }
        
        //var_dump($this->res->datos);

        $this->datos=array();
        $this->datos=$this->res->getDatos();
        $uos=$this->res->datos['uos'];
        $eps=$this->res->datos['eps'];
   
        
        $this->objParam->addParametro('eps',$eps);
        $this->objParam->addParametro('uos',$uos); 
        
        //////////////////////////
        
       
        
        // parametros de ordenacion por defecto
        $this->objParam->defecto('ordenacion','depto');
        $this->objParam->defecto('dir_ordenacion','asc');
        
       
        $this->objFunc=$this->create('sis_parametros/MODDepto'); 
        //ejecuta el metodo de lista personas a travez de la intefaz objetoFunSeguridad 
        $this->res=$this->objFunc->listarDeptoFiltradoXUOsEPs($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
        
        
    }
    
    function reporteComEjePag(){
       $dataSource = new DataSource();							
														
       $this->objParam->addParametroConsulta('ordenacion','id_obligacion_pago');
       $this->objParam->addParametroConsulta('dir_ordenacion','ASC');
       $this->objParam->addParametroConsulta('cantidad',1000);
       $this->objParam->addParametroConsulta('puntero',0);
	
	   	//consulta por los datos de la obligacion de pago					
       $this->objFunc=$this->create('MODObligacionPago');
       $resultObligacionPago = $this->objFunc->obligacionPagoSeleccionado($this->objParam);
    	
       if($resultObligacionPago->getTipo()=='EXITO'){
    	
        	    $datosObligacionPago = $resultObligacionPago->getDatos();
        	    $dataSource->putParameter('desc_proveedor',$datosObligacionPago[0]['desc_proveedor']);
            	$dataSource->putParameter('estado',$datosObligacionPago[0]['estado']);
            	$dataSource->putParameter('tipo_obligacion',$datosObligacionPago[0]['tipo_obligacion']);
            	$dataSource->putParameter('obs',$datosObligacionPago[0]['obs']);
            	$dataSource->putParameter('nombre_subsistema',$datosObligacionPago[0]['nombre_subsistema']);
            	$dataSource->putParameter('porc_retgar',$datosObligacionPago[0]['porc_retgar']);
            	$dataSource->putParameter('porc_anticipo',$datosObligacionPago[0]['porc_anticipo']);
            	$dataSource->putParameter('nombre_depto',$datosObligacionPago[0]['nombre_depto']);
            	$dataSource->putParameter('num_tramite',$datosObligacionPago[0]['num_tramite']);
            	$dataSource->putParameter('fecha',$datosObligacionPago[0]['fecha']);
            	$dataSource->putParameter('numero',$datosObligacionPago[0]['numero']);
            	$dataSource->putParameter('tipo_cambio_conv',$datosObligacionPago[0]['tipo_cambio_conv']);
            	$dataSource->putParameter('comprometido',$datosObligacionPago[0]['comprometido']);
            	$dataSource->putParameter('nro_cuota_vigente',$datosObligacionPago[0]['nro_cuota_vigente']);
            	$dataSource->putParameter('pago_variable',$datosObligacionPago[0]['pago_variable']);
                $dataSource->putParameter('moneda',$datosObligacionPago[0]['moneda']);
            	
            	
            	//consulta por el detalle de obligacion
                $this->objParam->addParametroConsulta('ordenacion','id_obligacion_det');
                $this->objParam->addParametroConsulta('dir_ordenacion','ASC');
                $this->objParam->addParametroConsulta('cantidad',1000);
                $this->objParam->addParametroConsulta('puntero',0);
        	   
            	//listado del detalle 						
                $this->objFunc=$this->create('MODObligacionPago');
                $resultObligacion=$this->objFunc->listarObligacion($this->objParam);
               
                if($resultObligacion->getTipo()=='EXITO'){
                    
                       $datosObligacion = $resultObligacion->getDatos();
                	   $dataSource->setDataSet($datosObligacion);
                	   $nombreArchivo = 'Reporte.pdf';
                	   $reporte = new RComEjePag();
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
                     $resultObligacion->imprimirRespuesta($resultObligacion->generarJson());    
                     
                 }
            }
        else
        {
                
             $resultObligacionPago->imprimirRespuesta($resultObligacionPago->generarJson());
        }
    }

	function reportePlanesPago(){
		$dataSource = new DataSource();
							
		$this->objParam->addParametroConsulta('ordenacion','id_obligacion_pago');
        $this->objParam->addParametroConsulta('dir_ordenacion','ASC');
        $this->objParam->addParametroConsulta('cantidad',1000);
        $this->objParam->addParametroConsulta('puntero',0);
							
		$this->objFunc=$this->create('MODObligacionPago');
		$resultObligacionPago = $this->objFunc->obligacionPagoSeleccionado($this->objParam);
		
		
		$datosObligacionPago = $resultObligacionPago->getDatos();
		$dataSource->putParameter('desc_proveedor',$datosObligacionPago[0]['desc_proveedor']);
		$dataSource->putParameter('estado',$datosObligacionPago[0]['estado']);
		$dataSource->putParameter('tipo_obligacion',$datosObligacionPago[0]['tipo_obligacion']);
		$dataSource->putParameter('obs',$datosObligacionPago[0]['obs']);
		$dataSource->putParameter('nombre_subsistema',$datosObligacionPago[0]['nombre_subsistema']);
		$dataSource->putParameter('porc_retgar',$datosObligacionPago[0]['porc_retgar']);
		$dataSource->putParameter('porc_anticipo',$datosObligacionPago[0]['porc_anticipo']);
		$dataSource->putParameter('nombre_depto',$datosObligacionPago[0]['nombre_depto']);
		$dataSource->putParameter('num_tramite',$datosObligacionPago[0]['num_tramite']);
		$dataSource->putParameter('fecha',$datosObligacionPago[0]['fecha']);
		$dataSource->putParameter('numero',$datosObligacionPago[0]['numero']);
		$dataSource->putParameter('tipo_cambio_conv',$datosObligacionPago[0]['tipo_cambio_conv']);
		$dataSource->putParameter('comprometido',$datosObligacionPago[0]['comprometido']);
		$dataSource->putParameter('nro_cuota_vigente',$datosObligacionPago[0]['nro_cuota_vigente']);
		$dataSource->putParameter('pago_variable',$datosObligacionPago[0]['pago_variable']);
		
		$this->objParam->addParametroConsulta('ordenacion','nro_cuota');
        $this->objParam->addParametroConsulta('dir_ordenacion','asc');
		$this->objFunc=$this->create('MODPlanPago');
		$resultPlanesPago = $this->objFunc->listarPlanesPagoPorObligacion($this->objParam);
		$datosPlanesPago = $resultPlanesPago->getDatos();
		$dataSource->setDataSet($datosPlanesPago);
		
		$nombreArchivo = 'Reporte.pdf';
	 
	   $reporte = new RPlanesPago();
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

	function obtenerIdsExternos(){
		$this->objFunc=$this->create('MODObligacionPago');	
		$this->res=$this->objFunc->obtenerIdsExternos($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function listarObligacionPresupuesto(){
		$this->objParam->defecto('ordenacion','id_partida');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODObligacionPago','listarObligacion');
		} else{
			$this->objFunc=$this->create('MODObligacionPago');
			
			$this->res=$this->objFunc->listarObligacion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function revertirParcialmentePresupuesto(){
		$this->objFunc=$this->create('MODObligacionPago');	
		$this->res=$this->objFunc->revertirParcialmentePresupuesto($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function recuperarDatosFiltro(){
		$this->objFunc=$this->create('MODObligacionPago');	
		$this->res=$this->objFunc->recuperarDatosFiltro($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

    function reporteProcesosPendientes()
    {
        $this->objFunc = $this->create('MODObligacionPago');
        $this->res = $this->objFunc->listarProcesosPendientes($this->objParam);
        //var_dump( $this->res);exit;
        //obtener titulo de reporte
        $titulo = 'Procesos Pendientes';
        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo = uniqid(md5(session_id()) . $titulo);

        $nombreArchivo .= '.xls';
        $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
        $this->objParam->addParametro('datos', $this->res->datos);
        //Instancia la clase de excel
        $this->objReporteFormato = new RProcesosPendientesAdquisiciones($this->objParam);
        $this->objReporteFormato->generarDatos();
        $this->objReporteFormato->generarReporte();


        $this->mensajeExito = new Mensaje();
        $this->mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado',
            'Se generó con éxito el reporte: ' . $nombreArchivo, 'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }

    function reporteProcesosPenContabilidad()
    {
        $this->objFunc = $this->create('MODObligacionPago');
        $this->res = $this->objFunc->listarProcesosPendientes($this->objParam);
        //var_dump( $this->res);exit;
        //obtener titulo de reporte
        $titulo = 'Procesos Pendientes';
        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo = uniqid(md5(session_id()) . $titulo);

        $nombreArchivo .= '.xls';
        $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
        $this->objParam->addParametro('datos', $this->res->datos);
        //Instancia la clase de excel
        $this->objReporteFormato = new RProcesosPendientesContabilidad($this->objParam);
        $this->objReporteFormato->generarDatos();
        $this->objReporteFormato->generarReporte();


        $this->mensajeExito = new Mensaje();
        $this->mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado',
            'Se generó con éxito el reporte: ' . $nombreArchivo, 'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }

    function recuperarPagoSinDocumento(){
        $this->objFunc = $this->create('MODObligacionPago');
        $cbteHeader = $this->objFunc->recuperarPagoSinDocumento($this->objParam);
        if($cbteHeader->getTipo() == 'EXITO'){
            return $cbteHeader;
        }
        else{
            $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
            exit;
        }

    }

    function reportePagoSinDocumento(){

        $nombreArchivo = 'PagosSinDocumentos'.uniqid(md5(session_id())).'.xls';

        $dataSource = $this->recuperarPagoSinDocumento();

        //parametros basicos
        $tamano = 'LETTER';
        $orientacion = 'L';
        $titulo = 'Consolidado';

        $this->objParam->addParametro('orientacion',$orientacion);
        $this->objParam->addParametro('tamano',$tamano);
        $this->objParam->addParametro('titulo_archivo',$titulo);
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);

        $reporte = new RPagosSinDocumentosXls($this->objParam);
        $reporte->datosHeader($dataSource->getDatos());
        $reporte->generarReporte();

        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }

    //Reporte Certificación Presupuestaria (F.E.A) 01/08/2017
    function reporteCertificacionP (){
        $this->objFunc=$this->create('MODObligacionPago');
        $dataSource=$this->objFunc->reporteCertificacionP();
        $this->dataSource=$dataSource->getDatos();

        $nombreArchivo = uniqid(md5(session_id()).'[Reporte-CertificaciónPresupuestaria]').'.pdf';
        $this->objParam->addParametro('orientacion','P');
        $this->objParam->addParametro('tamano','LETTER');
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);

        $this->objReporte = new RCertificacionPresupuestaria($this->objParam);
        $this->objReporte->setDatos($this->dataSource);
        $this->objReporte->generarReporte();
        $this->objReporte->output($this->objReporte->url_archivo,'F');


        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado', 'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }

    function listarObligacionPagoPS(){
		$this->objParam->defecto('ordenacion','id_obligacion_pago');
		$this->objParam->defecto('dir_ordenacion','asc');		
		$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
		
		if($this->objParam->getParametro('pago_simple')=='si'){
             $this->objParam->addFiltro("obpg.estado  in (''registrado'',''en_pago'',''finalizado'')");
        }
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODObligacionPago','listarObligacionPagoPS');
		} else{
			$this->objFunc=$this->create('MODObligacionPago');
			
			$this->res=$this->objFunc->listarObligacionPagoPS($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
    function listarObligacionPagoFiltro(){//#48
        $this->objParam->defecto('ordenacion','id_obligacion_pago');
        $this->objParam->defecto('dir_ordenacion','asc');
        $this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]);

        if($this->objParam->getParametro('pago_simple')=='si'){
            $this->objParam->addFiltro("obpg.estado  in (''registrado'',''en_pago'',''finalizado'')");
        }
        if($this->objParam->getParametro('id_proveedor')){
            $this->objParam->addFiltro("obpg.id_proveedor = ".$this->objParam->getParametro('id_proveedor'));
        }

        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODObligacionPago','listarObligacionPagoPS');
        } else{
            $this->objFunc=$this->create('MODObligacionPago');

            $this->res=$this->objFunc->listarObligacionPagoPS($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
	function editAntiRet(){
		$this->objFunc=$this->create('MODObligacionPago');	
		$this->res=$this->objFunc->editAntiRet($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

}

?>