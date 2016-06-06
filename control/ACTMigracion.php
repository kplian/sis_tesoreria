<?php
/**
*@package pXP
*@file gen-ACTAgencia.php
*@author  (jrivera)
*@date 06-01-2016 21:30:12
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTMigracion extends ACTbase{	
						
	function procesarMigracion(){
		$this->objFunc=$this->create('MODMigracion');	
		$this->res=$this->objFunc->procesarMigracion($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>