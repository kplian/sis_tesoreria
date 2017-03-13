<?php
/**
*@package pXP
*@file gen-MODCuentaBancariaPeriodo.php
*@author  (gsarmiento)
*@date 09-04-2015 18:40:04
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODCuentaBancariaPeriodo extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarCuentaBancariaPeriodo(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_cuenta_bancaria_periodo_sel';
		$this->transaccion='TES_PERCTAB_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_cuenta_bancaria_periodo','int4');
		$this->captura('id_cuenta_bancaria','int4');
		$this->captura('estado','varchar');
		$this->captura('gestion','int4');		
		$this->captura('id_periodo','int4');
		$this->captura('periodo','int4');
		$this->captura('nombre_periodo','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
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
			
	function insertarCuentaBancariaPeriodo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_cuenta_bancaria_periodo_ime';
		$this->transaccion='TES_PERCTAB_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarCuentaBancariaPeriodo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_cuenta_bancaria_periodo_ime';
		$this->transaccion='TES_PERCTAB_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_bancaria_periodo','id_cuenta_bancaria_periodo','int4');
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function abrirCerrarCuentaBancariaPeriodo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_cuenta_bancaria_periodo_ime';
		$this->transaccion='TES_PERCTABRCER_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_bancaria_periodo','id_cuenta_bancaria_periodo','int4');
		$this->setParametro('estado','estado','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function eliminarCuentaBancariaPeriodo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_cuenta_bancaria_periodo_ime';
		$this->transaccion='TES_PERCTAB_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_bancaria_periodo','id_cuenta_bancaria_periodo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>