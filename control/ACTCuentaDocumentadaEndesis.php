<?php

include_once(dirname(__FILE__).'/../../lib/PHPMailer/class.phpmailer.php');
include_once(dirname(__FILE__).'/../../lib/PHPMailer/class.smtp.php');
include_once(dirname(__FILE__).'/../../lib/lib_general/cls_correo_externo.php');
/**
*@package pXP
*@file gen-ACTCajero.php
*@author  (admin)
*@date 18-12-2013 19:39:02
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTCuentaDocumentadaEndesis extends ACTbase{    
			
	function listarFondoAvance(){
		$this->objParam->defecto('ordenacion','id_cuenta_doc');
		$this->objParam->defecto('dir_ordenacion','desc');	
		$this->objParam->addFiltro("CUDOC.tipo_cuenta_doc like ''solicitud_avance'' AND CUDOC.estado = ''pendiente_aprobacion''");	
		
		$this->objFunc = $this->create('MODCuentaDocumentadaEndesis');
				
		$this->res=$this->objFunc->listarFondoAvance();
		
		//para decodificar porq el 
		$working = html_entity_decode(preg_replace('/\\\u([0-9a-z]{4})/', '&#x$1;', $this->res->generarJson()),ENT_NOQUOTES, 'UTF-8');
				
		$this->res->imprimirRespuesta($working);
	}
	
	function contarFondoAvance(){
		$this->objParam->defecto('ordenacion','id_cuenta_doc');
		$this->objParam->defecto('dir_ordenacion','desc');	
		//$this->objParam->addFiltro("CUDOC.tipo_cuenta_doc like ''solicitud_avance'' AND CUDOC.estado = ''pendiente_aprobacion''");	
		$this->objParam->addFiltro("(CUDOC.tipo_cuenta_doc like ''solicitud_avance'' AND CUDOC.estado = ''pendiente_aprobacion'') or (CUDOC.tipo_cuenta_doc like ''solicitud_efectivo'' AND CUDOC.estado = ''pago_efectivo'')");	
		
		$this->objFunc = $this->create('MODCuentaDocumentadaEndesis');
				
		$this->res=$this->objFunc->contarFondoAvance();
		
		//para decodificar porq el 
		$working = html_entity_decode(preg_replace('/\\\u([0-9a-z]{4})/', '&#x$1;', $this->res->generarJson()),ENT_NOQUOTES, 'UTF-8');
				
		$this->res->imprimirRespuesta($working);
	}		
	
	
	function aprobarFondoAvance(){
		$this->objParam->addParametro("filtro","CUDOC.tipo_cuenta_doc like ''solicitud_avance'' AND CUDOC.estado = ''pendiente_aprobacion''");	
		$this->objFunc = $this->create('MODCuentaDocumentadaEndesis');		
					
		$this->res=$this->objFunc->aprobarFondoAvance();		
		//para decodificar porq el 
		$working = html_entity_decode(preg_replace('/\\\u([0-9a-z]{4})/', '&#x$1;', $this->res->generarJson()),ENT_NOQUOTES, 'UTF-8');		
		
		$this->res->imprimirRespuesta($working);
	}
	
	function aprobarFondoAvanceCorreo(){
		//$this->objParam->addParametro("filtro","CUDOC.tipo_cuenta_doc like ''solicitud_avance'' AND CUDOC.estado = ''pendiente_aprobacion''");	
		
		$this->objParam->addParametro("filtro","CUDOC.tipo_cuenta_doc like ''solicitud_avance'' AND CUDOC.estado = ''pendiente_aprobacion''");
		$this->objFunc = $this->create('MODCuentaDocumentadaEndesis');		
					
		$this->res=$this->objFunc->aprobarFondoAvance();		
		//para decodificar porq el 
		$working = html_entity_decode(preg_replace('/\\\u([0-9a-z]{4})/', '&#x$1;', $this->res->generarJson()),ENT_NOQUOTES, 'UTF-8');		
		$working_obj = json_decode($working);
		
		/*if ($this->objParam->getParametro('tipo_cuenta_doc') == 'solicitud_efectivo') {
			echo 'Aprobaste la solicitud de efectivo';
			exit;
		}
		else 
		{
			echo 'Aprobaste el fondo en avance';
			exit;
		}*/
		
		if ($this->objParam->getParametro('accion') == 'aprobar') {
			$accion = 'AUTORIZADO';
			$accion2 = 'APRUEBA';
		} else {
			$accion = 'RECHAZADO';
			$accion2 = 'RECHAZA';
		}	 
		 /*Envio de correos*/
		$correo=new CorreoExterno();
		$correo->addDestinatario($working_obj->datos[0]->email_tesoreria,$working_obj->datos[0]->nombre_tesoreria);
		$correo->addCC($working_obj->datos[0]->nombre_solicitante,$working_obj->datos[0]->email_solicitante);
		$correo->setAsunto("FONDO EN AVANCE " . $accion);
        $correo->setMensajeHtml("<html><head><title>FONDO EN AVANCE $accion</title></head><body>
        <div style='width:100%'>Señor(a):<br />&nbsp;&nbsp;&nbsp;&nbsp;<b>  " . strtoupper($working_obj->datos[0]->nombre_tesoreria) . "  </b><br /><br />Presente.- <br /><br />  
<b style='margin-left:30%;' ><u>REF.: FONDO EN AVANCE $accion.  </u></b><br/><br/> 
En cumplimiento a politicas de la empresa, se <b>  $accion2  </b> el Fondo en Avance solicitado con el siguiente detalle: <br/><br/> 
<table style='width:100%'><tr> 
<td style='width:30%;padding-right:15px;'>&nbsp;&nbsp;&nbsp;&nbsp;<B>SOLICITANTE &nbsp;&nbsp; :</B> </td> 
<td style='width:65%'>  " . strtoupper($working_obj->datos[0]->nombre_solicitante) . "  </td></tr><tr> 
<td style='width:30%;padding-right:15px;'>&nbsp;&nbsp;&nbsp;&nbsp;<B>MOTIVO &nbsp;&nbsp; :</B></td> 
<td style='width:65%'>  " . strtoupper($working_obj->datos[0]->motivo) . "  </td></tr><tr> 
<td style='width:30%;padding-right:15px;'>&nbsp;&nbsp;&nbsp;&nbsp;<B>Importe Solicitado &nbsp;&nbsp; :</B></td> 
<td style='width:65%'>  " . $working_obj->datos[0]->importe . "   Bs.</td></tr></table> 
<br><b>NOTA: <br/>   " . strtoupper($this->objParam->getParametro('mensaje')) . "   </b><br/><br/>Atte.<br/><b>  " . strtoupper($working_obj->datos[0]->nombre_autorizacion) . "  </b></div></body></html>");
		$correo->enviarCorreo();
		
		/*Jefe de Unidad y unidad solicitante
		 * 
		 * 
		 *
<td style='width:30%;padding-right:15px;'>&nbsp;&nbsp;&nbsp;&nbsp;<B>UNIDAD SOLICITANTE &nbsp;&nbsp; :</B></td> 
<td style='width:65%'>  " . strtoupper($working_obj->datos[0]->nombre_unidad) . "  </td></tr><tr> 
<td style='width:30%;padding-right:15px;'>&nbsp;&nbsp;&nbsp;&nbsp;<B>JEFE DE UNIDAD &nbsp;&nbsp; :</B> </td> 
<td style='width:65%'>  " . strtoupper($working_obj->datos[0]->nombre_jefe) . "  </td></tr><tr> 
		 * */
		/*Envio de correos*/
		
		$this->res->imprimirRespuesta($working);
		
		}
	//}
	function enviarFondoAvanceCorreo(){
		$this->objParam->addParametro("filtro","CUDOC.tipo_cuenta_doc like ''solicitud_avance'' AND CUDOC.estado = ''pendiente_aprobacion''");
		$this->objFunc = $this->create('MODCuentaDocumentadaEndesis');		
					
		$this->res=$this->objFunc->correoFondoAvance();		
		//para decodificar porq el 
		$working = html_entity_decode(preg_replace('/\\\u([0-9a-z]{4})/', '&#x$1;', $this->res->generarJson()),ENT_NOQUOTES, 'UTF-8');		
		$working_obj = json_decode($working);		
		
		$accion = "AUTORIZADO";
		$accion2 = 'APRUEBA'; 
		 /*Envio de correos*/
		$correo=new CorreoExterno();
		$correo->addDestinatario($working_obj->datos[0]->email_tesoreria,$working_obj->datos[0]->nombre_tesoreria);
		$correo->addCC($working_obj->datos[0]->email_solicitante,$working_obj->datos[0]->nombre_solicitante);
		$correo->addCC('Jaime','jaime.rivera@boa.bo');
		$correo->addCC('Grover','gvelasquez@boa.bo');
		$correo->setAsunto("FONDO EN AVANCE " . $accion);
        $correo->setMensajeHtml("<html><head><title>FONDO EN AVANCE $accion</title></head><body>
        <div style='width:100%'>Señor(a):<br />&nbsp;&nbsp;&nbsp;&nbsp;<b>  " . strtoupper($working_obj->datos[0]->nombre_tesoreria) . "  </b><br /><br />Presente.- <br /><br />  
<b style='margin-left:30%;' ><u>REF.: FONDO EN AVANCE $accion.  </u></b><br/><br/> 
En cumplimiento a politicas de la empresa, se <b>  $accion2  </b> el Fondo en Avance solicitado con el siguiente detalle: <br/><br/> 
<table style='width:100%'><tr> 
<td style='width:30%;padding-right:15px;'>&nbsp;&nbsp;&nbsp;&nbsp;<B>SOLICITANTE &nbsp;&nbsp; :</B> </td> 
<td style='width:65%'>  " . strtoupper($working_obj->datos[0]->nombre_solicitante) . "  </td></tr><tr> 
<td style='width:30%;padding-right:15px;'>&nbsp;&nbsp;&nbsp;&nbsp;<B>MOTIVO &nbsp;&nbsp; :</B></td> 
<td style='width:65%'>  " . strtoupper($working_obj->datos[0]->motivo) . "  </td></tr><tr> 
<td style='width:30%;padding-right:15px;'>&nbsp;&nbsp;&nbsp;&nbsp;<B>Importe Solicitado &nbsp;&nbsp; :</B></td> 
<td style='width:65%'>  " . $working_obj->datos[0]->importe . "   Bs.</td></tr></table> 
<br><b>NOTA: <br/>   " . strtoupper($working_obj->datos[0]->observaciones) . "   </b><br/><br/>Atte.<br/><b>  " . strtoupper($working_obj->datos[0]->nombre_autorizacion) . "  </b></div></body></html>");
		$res = $correo->enviarCorreo();		
		var_dump($res);
		$this->res->imprimirRespuesta($working);
			
	}	
	
	
}

?>