<?php
/**
*@package pXP
*@file gen-MODCajaFuncionario.php
*@author  (gsarmiento)
*@date 15-03-2017 20:10:37
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODCajaFuncionario extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarCajaFuncionario(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_caja_funcionario_sel';
		$this->transaccion='TES_CAJFUN_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_caja_funcionario','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_caja','int4');
		$this->captura('id_funcionario','int4');
		$this->captura('desc_funcionario1','text');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
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
			
	function insertarCajaFuncionario(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_caja_funcionario_ime';
		$this->transaccion='TES_CAJFUN_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_caja','id_caja','int4');
		$this->setParametro('id_funcionario','id_funcionario','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarCajaFuncionario(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_caja_funcionario_ime';
		$this->transaccion='TES_CAJFUN_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_caja_funcionario','id_caja_funcionario','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_caja','id_caja','int4');
		$this->setParametro('id_funcionario','id_funcionario','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarCajaFuncionario(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_caja_funcionario_ime';
		$this->transaccion='TES_CAJFUN_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_caja_funcionario','id_caja_funcionario','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>