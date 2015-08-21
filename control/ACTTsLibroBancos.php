<?php
/**
*@package pXP
*@file gen-ACTTsLibroBancos.php
*@author  (admin)
*@date 01-12-2013 09:10:17
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
include_once(dirname(__FILE__).'/../../lib/lib_general/funciones.inc.php');
require_once(dirname(__FILE__).'/../../pxp/pxpReport/ReportWriter.php');
require_once(dirname(__FILE__).'/../../sis_tesoreria/reportes/RLibroBancos.php');
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');
include_once(dirname(__FILE__).'/../../lib/PHPMailer/class.phpmailer.php');
include_once(dirname(__FILE__).'/../../lib/PHPMailer/class.smtp.php');
include_once(dirname(__FILE__).'/../../lib/lib_general/cls_correo_externo.php');


class ACTTsLibroBancos extends ACTbase{    
			
	function listarTsLibroBancos(){
		$this->objParam->defecto('ordenacion','id_libro_bancos');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_cuenta_bancaria')!=''){
			$this->objParam->addFiltro("id_cuenta_bancaria = ".$this->objParam->getParametro('id_cuenta_bancaria'));	
		}
		
		if($this->objParam->getParametro('mycls')=='TsLibroBancosDeposito'){
			$this->objParam->addFiltro("id_libro_bancos_fk is null");	
			$this->objParam->addFiltro("tipo=''deposito''");
		}
		if($this->objParam->getParametro('mycls')=='TsLibroBancosCheque'){
			$this->objParam->addFiltro("id_libro_bancos_fk = ".$this->objParam->getParametro('id_libro_bancos'));
			$this->objParam->addFiltro("tipo in (''cheque'',''debito_automatico'',''transferencia_carta'',''transf_interna_debe'')");
		}
		if($this->objParam->getParametro('mycls')=='TsLibroBancosDepositoExtra'){
			$this->objParam->addFiltro("id_libro_bancos_fk = ".$this->objParam->getParametro('id_libro_bancos'));
			$this->objParam->addFiltro("tipo in (''deposito'',''transf_interna_haber'')");
		}
		
		if($this->objParam->getParametro('m_nro_cheque')!=''){
			$this->objParam->addFiltro("nro_cheque= (Select max (lb.nro_cheque)
													From tes.tts_libro_bancos lb 
													Where lb.id_cuenta_bancaria=".$this->objParam->getParametro('m_id_cuenta_bancaria').") ");	
		}		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTsLibroBancos','listarTsLibroBancos');
		} else{
			$this->objFunc=$this->create('MODTsLibroBancos');
			
			$this->res=$this->objFunc->listarTsLibroBancos($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function listarTsLibroBancosDepositosConSaldo(){
		$this->objParam->defecto('ordenacion','fecha');
		$this->objParam->defecto('dir_ordenacion','desc');
		
		$this->objFunc=$this->create('MODTsLibroBancos');
		$this->res=$this->objFunc->listarTsLibroBancosDepositosConSaldo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTsLibroBancos(){
		$this->objFunc=$this->create('MODTsLibroBancos');	
		if($this->objParam->insertar('id_libro_bancos')){
			$this->res=$this->objFunc->insertarTsLibroBancos($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTsLibroBancos($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function anteriorEstadoLibroBancos(){
        $this->objFunc=$this->create('MODTsLibroBancos');  
        $this->res=$this->objFunc->anteriorEstadoLibroBancos($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
	
	function siguienteEstadoLibroBancos(){
		$this->objFunc=$this->create('MODTsLibroBancos');
		$this->res=$this->objFunc->siguienteEstadoLibroBancos($this->objParam);					
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function transferirDeposito(){
        $this->objFunc=$this->create('MODTsLibroBancos');  
        $this->res=$this->objFunc->transferirDeposito($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
	
	function eliminarTsLibroBancos(){
			$this->objFunc=$this->create('MODTsLibroBancos');	
		$this->res=$this->objFunc->eliminarTsLibroBancos($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function imprimirCheque(){
		
		$fecha_cheque_literal = $this->objParam->getParametro('fecha_cheque_literal');
		$importe_cheque =$this->objParam->getParametro('importe_cheque');;	
		$a_favor = $this->objParam->getParametro('a_favor');
		$nombre_lugar = $this->objParam->getParametro('nombre_regional');
		
		$fichero= 'HTMLReporteCheque.php';
		$fichero_salida = dirname(__FILE__).'/../../reportes_generados/'.$fichero;
		
		$fp=fopen($fichero_salida,w);
		
		$funciones = new funciones();
		
		$contenido = "<body onLoad='window.print();'>";
		$contenido = $contenido. "<table border=0 style='line-height: 10px;'>";
		$contenido = $contenido. "<td colspan='10'; style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td colspan='26'; style='text-align: left; width:25px; font-size:8pt'>".$nombre_lugar.", ".$fecha_cheque_literal."</td><tr>";
		$contenido = $contenido. "<td colspan='28'; style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td colspan='3'; style='text-align: left; width:35px; font-size:8pt'>".number_format($importe_cheque,2)."</td><tr>";
		$contenido = $contenido. "<td colspan='33'; style='text-align: left; width:35px; font-size:8pt'></td><tr>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td colspan='31'; style='text-align: left; width:35px; font-size:8pt'>".$a_favor."</td><tr>";
		$contenido = $contenido. "<td colspan='33'; style='text-align: left; width:35px; font-size:8pt'></td><tr>";
		$contenido = $contenido. "<td colspan='33'; style='text-align: left; width:35px; font-size:8pt'></td><tr>";
		$contenido = $contenido. "<td colspan='33'; style='text-align: left; width:35px; font-size:8pt'></td><tr>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td colspan='31'; style='text-align: left; width:35px; font-size:8pt'>".$funciones->num2letrasCheque($importe_cheque).'-----'."</td><tr>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td><tr>";
		$contenido = $contenido. '</body>';

		fwrite($fp, $contenido);
		fclose($fp);
			
		$mensajeExito = new Mensaje();
		$mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
										'Se generó con éxito el reporte: '.$fichero,'control');
		$mensajeExito->setArchivoGenerado($fichero);
		$this->res = $mensajeExito;
		$this->res->imprimirRespuesta($this->res->generarJson());
	  }
	  
	function imprimirCheque2(){
		
		$fecha_cheque_literal = $this->objParam->getParametro('fecha_cheque_literal');
		$importe_cheque =$this->objParam->getParametro('importe_cheque');;	
		$a_favor = $this->objParam->getParametro('a_favor');
		$nombre_lugar = $this->objParam->getParametro('nombre_regional');
		
		$fichero= 'HTMLReporteCheque2.php';
		$fichero_salida = dirname(__FILE__).'/../../reportes_generados/'.$fichero;
		
		$fp=fopen($fichero_salida,w);
		
		$funciones = new funciones();
		
		$contenido = "<body onLoad='window.print();'>";
		$contenido = $contenido. "<table border=0 style='line-height: 10px;'>";
		$contenido = $contenido. "<td colspan='7'; style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td colspan='26'; style='text-align: left; width:25px; font-size:8pt'>".$nombre_lugar.", ".$fecha_cheque_literal."</td><tr>";
		$contenido = $contenido. "<td colspan='25'; style='text-align: left; width:35px; font-size:8pt'></td>";	
		$contenido = $contenido. "<td colspan='3'; style='text-align: left; width:35px; font-size:8pt'>".number_format($importe_cheque,2)."</td><tr>";
		$contenido = $contenido. "<td colspan='33'; style='text-align: left; width:35px; font-size:8pt'></td><tr>";
		/*$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td>"; */
		$contenido = $contenido. "<td colspan='31'; style='text-align: left; width:35px; font-size:8pt'>".$a_favor."</td><tr>";
		$contenido = $contenido. "<td colspan='33'; style='text-align: left; width:35px; font-size:8pt'></td><tr>";
		$contenido = $contenido. "<td colspan='33'; style='text-align: left; width:35px; font-size:8pt'></td><tr>";
		$contenido = $contenido. "<td colspan='33'; style='text-align: left; width:35px; font-size:8pt'></td><tr>";
		/*$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td>";*/
		$contenido = $contenido. "<td colspan='31'; style='text-align: left; width:35px; font-size:8pt'>".$funciones->num2letrasCheque($importe_cheque).'-----'."</td><tr>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td><tr>";
		$contenido = $contenido. '</body>';

		fwrite($fp, $contenido);
		fclose($fp);
			
		$mensajeExito = new Mensaje();
		$mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
										'Se generó con éxito el reporte: '.$fichero,'control');
		$mensajeExito->setArchivoGenerado($fichero);
		$this->res = $mensajeExito;
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function vistaPrevia(){
		
		$fecha_cheque_literal = $this->objParam->getParametro('fecha_cheque_literal');
		$importe_cheque =$this->objParam->getParametro('importe_cheque');;	
		$a_favor = $this->objParam->getParametro('a_favor');
		$nombre_lugar = $this->objParam->getParametro('nombre_regional');
		
		$fichero= 'HTMLReporteCheque.php';
		$fichero_salida = dirname(__FILE__).'/../../reportes_generados/'.$fichero;
		
		$fp=fopen($fichero_salida,w);
		
		$funciones = new funciones();
		
		$contenido = "<body onLoad='window.print();'>";
		$contenido = $contenido. "<table border=0 style='line-height: 10px;'>";
		$contenido = $contenido. "<td colspan='10'; style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td colspan='26'; style='text-align: left; width:25px; font-size:8pt'>".$nombre_lugar.", ".$fecha_cheque_literal."</td><tr>";
		$contenido = $contenido. "<td colspan='28'; style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td colspan='3'; style='text-align: left; width:35px; font-size:8pt'>".number_format($importe_cheque,2)."</td><tr>";
		$contenido = $contenido. "<td colspan='33'; style='text-align: left; width:35px; font-size:8pt'></td><tr>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td colspan='31'; style='text-align: left; width:35px; font-size:8pt'>".$a_favor."</td><tr>";
		$contenido = $contenido. "<td colspan='33'; style='text-align: left; width:35px; font-size:8pt'></td><tr>";
		$contenido = $contenido. "<td colspan='33'; style='text-align: left; width:35px; font-size:8pt'></td><tr>";
		$contenido = $contenido. "<td colspan='33'; style='text-align: left; width:35px; font-size:8pt'></td><tr>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td colspan='31'; style='text-align: left; width:35px; font-size:8pt'>".$funciones->num2letrasCheque($importe_cheque).'-----'."</td><tr>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'>VISTA PREVIA SIN VALOR</td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'>VISTA PREVIA SIN VALOR</td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'>VISTA PREVIA SIN VALOR</td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'>VISTA PREVIA SIN VALOR</td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'>VISTA PREVIA SIN VALOR</td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'>VISTA PREVIA SIN VALOR</td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'>VISTA PREVIA SIN VALOR</td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'>VISTA PREVIA SIN VALOR</td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'>VISTA PREVIA SIN VALOR</td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'>VISTA PREVIA SIN VALOR</td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'>VISTA PREVIA SIN VALOR</td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'>VISTA PREVIA SIN VALOR</td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'>VISTA PREVIA SIN VALOR</td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td><tr>";
		$contenido = $contenido. '</body>';

		fwrite($fp, $contenido);
		fclose($fp);
			
		$mensajeExito = new Mensaje();
		$mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
										'Se generó con éxito el reporte: '.$fichero,'control');
		$mensajeExito->setArchivoGenerado($fichero);
		$this->res = $mensajeExito;
		$this->res->imprimirRespuesta($this->res->generarJson());
	  }
	  
	function listarDepositosENDESIS(){
		$this->objParam->defecto('ordenacion','id_libro_bancos');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_cuenta_bancaria')!=''){
			$this->objParam->addFiltro("id_cuenta_bancaria = ".$this->objParam->getParametro('id_cuenta_bancaria'));	
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTsLibroBancos','listarDepositosENDESIS');
		} else{
			$this->objFunc=$this->create('MODTsLibroBancos');
			$this->res=$this->objFunc->listarDepositosENDESIS($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function reporteLibroBancos(){
		$dataSource = new DataSource();
		
		$nro_cuenta = $this->objParam->getParametro('nro_cuenta');
		$fecha_ini = $this->objParam->getParametro('fecha_ini');
		$fecha_fin = $this->objParam->getParametro('fecha_fin');
		$tipo = $this->objParam->getParametro('tipo');
		$estado = $this->objParam->getParametro('estado');
		$finalidad = $this->objParam->getParametro('finalidad');
		
		$this->objParam->addParametroConsulta('ordenacion','id_libro_bancos');
        $this->objParam->addParametroConsulta('dir_ordenacion','ASC');
        $this->objParam->addParametroConsulta('cantidad',1000);
        $this->objParam->addParametroConsulta('puntero',0);
		
		$dataSource->putParameter('nro_cuenta', $nro_cuenta);
		$dataSource->putParameter('fecha_ini', $fecha_ini);
		$dataSource->putParameter('fecha_fin', $fecha_fin);
		$dataSource->putParameter('tipo', $tipo);
		$dataSource->putParameter('estado', $estado);
		$dataSource->putParameter('finalidad', $finalidad);		
		
		$this->objFunc=$this->create('MODTsLibroBancos');
		$resultLibroBancos = $this->objFunc->reporteLibroBancos($this->objParam);
				
		if($resultLibroBancos->getTipo()=='EXITO'){
						
			$datosLibroBancos = $resultLibroBancos->getDatos();
			
			$dataSource->setDataSet($datosLibroBancos);    
			
			$nombreArchivo = 'LibroBancos.pdf';
			$reporte = new RLibroBancos();
			
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
			 $resultLibroBancos->imprimirRespuesta($resultLibroBancos->generarJson());			
		}
	}
	
	/*
    * 
    * Author: GSS
    * DESC:   Envia email de notificacion al solicitante
    * DATE:   03/02/2015
    * */
    function enviarNotificacion(){
  	
	     //obtiene direcciones de envio
	     $this->objFunSeguridad=$this->create('MODTsLibroBancos'); 
         $this->res=$this->objFunSeguridad->obtenerDatosSolicitanteFondoAvance($this->objParam);
		 
	     $array = $this->res->getDatos();		 
		 
		 if($array[0]['email']==''){
			echo "{\"ROOT\":{\"error\":true,\"detalle\":{\"mensaje\":\" Error al enviar correo no existe destinatario\"}}}"; 
		 }
		 ////////////////////////////////////////
		 //arma el texto del correo electronico
		 ///////////////////////////////////////
		 $data_mail = '';
		 
		 $data_mail.= 'Estimad@ '.$array[0]['nombre_completo'].'<br><br>'.
            
            'En cumplimiento a políticas de la empresa, le informamos que su solicitud ha sido atendida de acuerdo al siguiente detalle:<br><br>'.
            '&nbsp;&nbsp;&nbsp;&nbsp;<B>Número Cheque:</B> '.$this->objParam->getParametro('nro_cheque').'<br>'.
            '&nbsp;&nbsp;&nbsp;&nbsp;<B>A favor:</B> '.$this->objParam->getParametro('a_favor').'<br>'.
            '&nbsp;&nbsp;&nbsp;&nbsp;<B>Detalle:</B> '.$this->objParam->getParametro('detalle').'<br>'.
            '&nbsp;&nbsp;&nbsp;&nbsp;<B>Importe:</B> '.$this->objParam->getParametro('importe_cheque').' Bs.<br><br>'.
            'Favor pasar a recoger el cheque de la Unidad de Tesorería.<br><br>'.            
            '-------------------------------------<br>'.
        	'* Sistema ERP BOA<br>';
		 
		 ///////////////////////////////////////////////////
		 //manda el correo electronicos al solicitante
		 ///////////////////////////////////////////////////
		   
		    $correo=new CorreoExterno();
		    $correo->addDestinatario($_SESSION['_MAIL_NITIFICACIONES_3']); //  este mail esta destinado al area de tesoreria
	        $correo->addDestinatario($array[0]['email']);
			
		    //asunto
       		$correo->setAsunto('Solicitud atendida');
            //cuerpo mensaje
            $correo->setMensaje($data_mail);
            $correo->setTitulo('Solicitud atendida');
			
			$correo->setDefaultPlantilla();
            $resp=$correo->enviarCorreo();           
        
            if($resp=='OK'){
                $mensajeExito = new Mensaje();
                $mensajeExito->setMensaje('EXITO','Solicitud.php','Correo enviado',
                'Se mando el correo con exito: OK','control' );
                $this->res = $mensajeExito;
                $this->res->imprimirRespuesta($this->res->generarJson());
            
           }  
            else{
              //echo $resp;      
              echo "{\"ROOT\":{\"error\":true,\"detalle\":{\"mensaje\":\" Error al enviar correo\"}}}";  
              
           } 
		 
		   exit;
	   
    }
	
}

?>