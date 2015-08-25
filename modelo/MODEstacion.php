<?php
/**
*@package pXP
*@file gen-MODEstacion.php
*@author  (admin)
*@date 25-08-2015 15:36:34
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODEstacion extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarEstacion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_estacion_sel';
		$this->transaccion='TES_EST_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_estacion','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('codigo','varchar');
		$this->captura('host','varchar');
		$this->captura('puerto','varchar');
		$this->captura('dbname','varchar');
		$this->captura('usuario','varchar');		
		$this->captura('id_depto_lb','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_depto_lb','varchar');
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarEstacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_estacion_ime';
		$this->transaccion='TES_EST_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('host','host','varchar');
		$this->setParametro('puerto','puerto','varchar');
		$this->setParametro('dbname','dbname','varchar');
		$this->setParametro('usuario','usuario','varchar');
		$this->setParametro('password','password','varchar');
		$this->setParametro('id_depto_lb','id_depto_lb','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarEstacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_estacion_ime';
		$this->transaccion='TES_EST_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_estacion','id_estacion','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('host','host','varchar');
		$this->setParametro('puerto','puerto','varchar');
		$this->setParametro('dbname','dbname','varchar');
		$this->setParametro('usuario','usuario','varchar');
		$this->setParametro('password','password','varchar');
		$this->setParametro('id_depto_lb','id_depto_lb','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarEstacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_estacion_ime';
		$this->transaccion='TES_EST_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_estacion','id_estacion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>