<?php
/**
*@package pXP
*@file MODChequera.php
*@author  Gonzalo Sarmiento Sejas
*@date 24-04-2013 18:54:03
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODChequera extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarChequera(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.f_chequera_sel';
		$this->transaccion='TES_CHQ_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->captura('id_chequera','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('nro_chequera','int4');
		$this->captura('codigo','varchar');
		$this->captura('id_cuenta_bancaria','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarChequera(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.f_chequera_ime';
		$this->transaccion='TES_CHQ_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nro_chequera','nro_chequera','int4');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarChequera(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.f_chequera_ime';
		$this->transaccion='TES_CHQ_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_chequera','id_chequera','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nro_chequera','nro_chequera','int4');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarChequera(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.f_chequera_ime';
		$this->transaccion='TES_CHQ_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_chequera','id_chequera','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>