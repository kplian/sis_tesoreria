<?php
/**
*@package pXP
*@file gen-MODUsuarioCuentaBanc.php
*@author  (admin)
*@date 24-03-2017 15:30:36
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODUsuarioCuentaBanc extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarUsuarioCuentaBanc(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_usuario_cuenta_banc_sel';
		$this->transaccion='TES_UCU_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_usuario_cuenta_banc','int4');
		$this->captura('id_usuario','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_cuenta_bancaria','int4');
		$this->captura('tipo_permiso','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_persona','text');
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarUsuarioCuentaBanc(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_usuario_cuenta_banc_ime';
		$this->transaccion='TES_UCU_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_usuario','id_usuario','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('tipo_permiso','tipo_permiso','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarUsuarioCuentaBanc(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_usuario_cuenta_banc_ime';
		$this->transaccion='TES_UCU_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_usuario_cuenta_banc','id_usuario_cuenta_banc','int4');
		$this->setParametro('id_usuario','id_usuario','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('tipo_permiso','tipo_permiso','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarUsuarioCuentaBanc(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_usuario_cuenta_banc_ime';
		$this->transaccion='TES_UCU_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_usuario_cuenta_banc','id_usuario_cuenta_banc','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>