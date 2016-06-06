<?php
/**
*@package pXP
*@file gen-MODMigracion.php
*@author  (admin)
*@date 14-01-2013 18:19:52
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODMigracion extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function procesarMigracion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='informix.ft_migracion_ime';
		$this->transaccion='INF_PROCEMIGRA_UPD';
		$this->tipo_procedimiento='IME';//tipo de transaccion			
		
		$this->setParametro('fecha','fecha','varchar');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}    
			
}
?>