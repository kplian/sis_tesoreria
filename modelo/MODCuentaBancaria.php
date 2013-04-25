<?php
/**
*@package pXP
*@file MODCuentaBancaria.php
*@author  Gonzalo Sarmiento Sejas
*@date 24-04-2013 15:19:30
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODCuentaBancaria extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarCuentaBancaria(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.f_cuenta_bancaria_sel';
		$this->transaccion='TES_CTABAN_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_cuenta_bancaria','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_cuenta','int4');
		$this->captura('nombre_cuenta','varchar');
		$this->captura('fecha_baja','date');
		$this->captura('nro_cuenta','varchar');
		$this->captura('fecha_alta','date');
		$this->captura('id_auxiliar','int4');
		$this->captura('nombre_auxiliar','varchar');
		$this->captura('id_institucion','int4');
		$this->captura('nombre_institucion','varchar');
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
			
	function insertarCuentaBancaria(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.f_cuenta_bancaria_ime';
		$this->transaccion='TES_CTABAN_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('fecha_baja','fecha_baja','date');
		$this->setParametro('nro_cuenta','nro_cuenta','varchar');
		$this->setParametro('fecha_alta','fecha_alta','date');
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('id_institucion','id_institucion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarCuentaBancaria(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.f_cuenta_bancaria_ime';
		$this->transaccion='TES_CTABAN_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('fecha_baja','fecha_baja','date');
		$this->setParametro('nro_cuenta','nro_cuenta','varchar');
		$this->setParametro('fecha_alta','fecha_alta','date');
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('id_institucion','id_institucion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarCuentaBancaria(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.f_cuenta_bancaria_ime';
		$this->transaccion='TES_CTABAN_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>