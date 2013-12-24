<?php
/**
*@package pXP
*@file gen-MODCajero.php
*@author  (admin)
*@date 18-12-2013 19:39:02
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODCajero extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarCajero(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_cajero_sel';
		$this->transaccion='TES_CAJERO_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_cajero','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('tipo','varchar');
		$this->captura('estado','varchar');
		$this->captura('id_funcionario','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
	 $this->captura('desc_funcionario','text');
		$this->captura('id_caja','int4');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarCajero(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_cajero_ime';
		$this->transaccion='TES_CAJERO_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('id_caja','id_caja','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarCajero(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_cajero_ime';
		$this->transaccion='TES_CAJERO_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cajero','id_cajero','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('id_caja','id_caja','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarCajero(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_cajero_ime';
		$this->transaccion='TES_CAJERO_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cajero','id_cajero','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>