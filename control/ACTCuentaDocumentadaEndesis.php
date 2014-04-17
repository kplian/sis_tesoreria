<?php
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
	
	
	function aprobarFondoAvance(){
		$this->objParam->addParametro("filtro","CUDOC.tipo_cuenta_doc like ''solicitud_avance'' AND CUDOC.estado = ''pendiente_aprobacion''");	
		$this->objFunc = $this->create('MODCuentaDocumentadaEndesis');		
					
		$this->res=$this->objFunc->aprobarFondoAvance();		
		//para decodificar porq el 
		$working = html_entity_decode(preg_replace('/\\\u([0-9a-z]{4})/', '&#x$1;', $this->res->generarJson()),ENT_NOQUOTES, 'UTF-8');		
		
		$this->res->imprimirRespuesta($working);
	}
	
	
	
}

?>