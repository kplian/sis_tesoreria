<?php
/**
*@package pXP
*@file gen-MODCuentaBancariaMov.php
*@author  (admin)
*@date 12-12-2013 18:01:35
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODCuentaBancariaMov extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarCuentaBancariaMov(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_cuenta_bancaria_mov_sel';
		$this->transaccion='TES_CBANMO_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_cuenta_bancaria_mov','int4');
		$this->captura('descripcion','varchar');
		$this->captura('tipo_mov','varchar');
		$this->captura('tipo','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('nro_doc_tipo','varchar');
		$this->captura('fecha','date');
		$this->captura('estado','varchar');
		$this->captura('id_int_comprobante','int4');
		$this->captura('id_cuenta_bancaria','int4');
		$this->captura('id_cuenta_bancaria_mov_fk','int4');
		$this->captura('importe','numeric');
		$this->captura('observaciones','varchar');
		$this->captura('fecha_reg','timestamp');
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
			
	function insertarCuentaBancariaMov(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_cuenta_bancaria_mov_ime';
		$this->transaccion='TES_CBANMO_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('tipo_mov','tipo_mov','varchar');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nro_doc_tipo','nro_doc_tipo','varchar');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('id_cuenta_bancaria_mov_fk','id_cuenta_bancaria_mov_fk','int4');
		$this->setParametro('importe','importe','numeric');
		$this->setParametro('observaciones','observaciones','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarCuentaBancariaMov(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_cuenta_bancaria_mov_ime';
		$this->transaccion='TES_CBANMO_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_bancaria_mov','id_cuenta_bancaria_mov','int4');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('tipo_mov','tipo_mov','varchar');
		$this->setParametro('tipo','tipo','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('nro_doc_tipo','nro_doc_tipo','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('id_cuenta_bancaria_mov_fk','id_cuenta_bancaria_mov_fk','int4');
		$this->setParametro('importe','importe','numeric');
		$this->setParametro('observaciones','observaciones','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarCuentaBancariaMov(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_cuenta_bancaria_mov_ime';
		$this->transaccion='TES_CBANMO_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_bancaria_mov','id_cuenta_bancaria_mov','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>