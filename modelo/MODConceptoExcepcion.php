<?php
/**
*@package pXP
*@file gen-MODConceptoExcepcion.php
*@author  (admin)
*@date 12-06-2015 13:02:07
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODConceptoExcepcion extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarConceptoExcepcion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_concepto_excepcion_sel';
		$this->transaccion='TES_conex_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_concepto_excepcion','int4');
		$this->captura('id_uo','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_concepto_ingas','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_uo','varchar');
		$this->captura('desc_ingas','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarConceptoExcepcion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_concepto_excepcion_ime';
		$this->transaccion='TES_conex_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_uo','id_uo','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarConceptoExcepcion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_concepto_excepcion_ime';
		$this->transaccion='TES_conex_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_concepto_excepcion','id_concepto_excepcion','int4');
		$this->setParametro('id_uo','id_uo','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarConceptoExcepcion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_concepto_excepcion_ime';
		$this->transaccion='TES_conex_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_concepto_excepcion','id_concepto_excepcion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>