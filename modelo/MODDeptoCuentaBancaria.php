<?php
/**
*@package pXP
*@file gen-MODDeptoCuentaBancaria.php
*@author  (gsarmiento)
*@date 03-03-2015 19:10:38
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODDeptoCuentaBancaria extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarDeptoCuentaBancaria(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_depto_cuenta_bancaria_sel';
		$this->transaccion='TES_DCB_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		//$this->setParametro('id_depto','id_depto','integer');	
		//Definicion de la lista del resultado del query
		$this->captura('id_depto_cuenta_bancaria','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_cuenta_bancaria','int4');
		$this->captura('denominacion','varchar');
		$this->captura('id_depto','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarDeptoCuentaBancaria(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_depto_cuenta_bancaria_ime';
		$this->transaccion='TES_DCB_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('id_depto','id_depto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarDeptoCuentaBancaria(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_depto_cuenta_bancaria_ime';
		$this->transaccion='TES_DCB_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_depto_cuenta_bancaria','id_depto_cuenta_bancaria','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('id_depto','id_depto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarDeptoCuentaBancaria(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_depto_cuenta_bancaria_ime';
		$this->transaccion='TES_DCB_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_depto_cuenta_bancaria','id_depto_cuenta_bancaria','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>