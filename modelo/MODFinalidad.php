<?php
/**
*@package pXP
*@file gen-MODFinalidad.php
*@author  (gsarmiento)
*@date 02-12-2014 13:11:02
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODFinalidad extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarFinalidad(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_finalidad_sel';
		$this->transaccion='TES_FIN_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_finalidad','int4');
		$this->captura('estado','varchar');
		$this->captura('color','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('nombre_finalidad','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
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
	
	function listarFinalidadCuentaBancaria(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_finalidad_sel';
		$this->transaccion='TES_FINCTABAN_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('vista','vista','varchar');
		//Definicion de la lista del resultado del query
		$this->captura('id_finalidad','int4');
		$this->captura('estado','varchar');
		$this->captura('color','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('nombre_finalidad','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarFinalidad(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_finalidad_ime';
		$this->transaccion='TES_FIN_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('color','color','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nombre_finalidad','nombre_finalidad','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarFinalidad(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_finalidad_ime';
		$this->transaccion='TES_FIN_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_finalidad','id_finalidad','int4');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('color','color','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nombre_finalidad','nombre_finalidad','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarFinalidad(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_finalidad_ime';
		$this->transaccion='TES_FIN_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_finalidad','id_finalidad','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>