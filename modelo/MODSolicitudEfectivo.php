<?php
/**
*@package pXP
*@file gen-MODSolicitudEfectivo.php
*@author  (gsarmiento)
*@date 24-11-2015 12:59:51
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODSolicitudEfectivo extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarSolicitudEfectivo(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_solicitud_efectivo_sel';
		$this->transaccion='TES_SOLEFE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_solicitud_efectivo','int4');
		$this->captura('id_caja','int4');
		$this->captura('id_estado_wf','int4');
		$this->captura('monto','numeric');
		$this->captura('id_proceso_wf','int4');
		$this->captura('nro_tramite','varchar');
		$this->captura('estado','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('motivo','text');
		$this->captura('id_funcionario','int4');
		$this->captura('fecha','date');
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
			
	function insertarSolicitudEfectivo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_solicitud_efectivo_ime';
		$this->transaccion='TES_SOLEFE_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_caja','id_caja','int4');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('monto','monto','numeric');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		$this->setParametro('nro_tramite','nro_tramite','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('motivo','motivo','text');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('fecha','fecha','date');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarSolicitudEfectivo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_solicitud_efectivo_ime';
		$this->transaccion='TES_SOLEFE_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_solicitud_efectivo','id_solicitud_efectivo','int4');
		$this->setParametro('id_caja','id_caja','int4');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('monto','monto','numeric');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		$this->setParametro('nro_tramite','nro_tramite','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('motivo','motivo','text');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('fecha','fecha','date');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarSolicitudEfectivo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_solicitud_efectivo_ime';
		$this->transaccion='TES_SOLEFE_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_solicitud_efectivo','id_solicitud_efectivo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>