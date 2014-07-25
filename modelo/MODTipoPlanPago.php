<?php
/**
*@package pXP
*@file gen-MODTipoPlanPago.php
*@author  (admin)
*@date 08-07-2014 13:12:03
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODTipoPlanPago extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarTipoPlanPago(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_tipo_plan_pago_sel';
		$this->transaccion='TES_TPP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_tipo_plan_pago','int4');
		$this->captura('codigo_proceso_llave_wf','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('codigo_plantilla_comprobante','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('codigo','varchar');
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
			
	function insertarTipoPlanPago(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_tipo_plan_pago_ime';
		$this->transaccion='TES_TPP_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('codigo_proceso_llave_wf','codigo_proceso_llave_wf','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('codigo_plantilla_comprobante','codigo_plantilla_comprobante','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo','codigo','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarTipoPlanPago(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_tipo_plan_pago_ime';
		$this->transaccion='TES_TPP_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_plan_pago','id_tipo_plan_pago','int4');
		$this->setParametro('codigo_proceso_llave_wf','codigo_proceso_llave_wf','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('codigo_plantilla_comprobante','codigo_plantilla_comprobante','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo','codigo','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarTipoPlanPago(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_tipo_plan_pago_ime';
		$this->transaccion='TES_TPP_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_plan_pago','id_tipo_plan_pago','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>