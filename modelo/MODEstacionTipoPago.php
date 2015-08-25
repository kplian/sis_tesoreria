<?php
/**
*@package pXP
*@file gen-MODEstacionTipoPago.php
*@author  (admin)
*@date 25-08-2015 15:36:37
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODEstacionTipoPago extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarEstacionTipoPago(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_estacion_tipo_pago_sel';
		$this->transaccion='TES_ETP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_estacion_tipo_pago','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_estacion','int4');
		$this->captura('id_tipo_plan_pago','int4');
		$this->captura('codigo_plantilla_comprobante','varchar');
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
			
	function insertarEstacionTipoPago(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_estacion_tipo_pago_ime';
		$this->transaccion='TES_ETP_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_estacion','id_estacion','int4');
		$this->setParametro('id_tipo_plan_pago','id_tipo_plan_pago','int4');
		$this->setParametro('codigo_plantilla_comprobante','codigo_plantilla_comprobante','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarEstacionTipoPago(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_estacion_tipo_pago_ime';
		$this->transaccion='TES_ETP_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_estacion_tipo_pago','id_estacion_tipo_pago','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_estacion','id_estacion','int4');
		$this->setParametro('id_tipo_plan_pago','id_tipo_plan_pago','int4');
		$this->setParametro('codigo_plantilla_comprobante','codigo_plantilla_comprobante','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarEstacionTipoPago(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_estacion_tipo_pago_ime';
		$this->transaccion='TES_ETP_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_estacion_tipo_pago','id_estacion_tipo_pago','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>