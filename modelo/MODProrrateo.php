<?php
/**
*@package pXP
*@file gen-MODProrrateo.php
*@author  (admin)
*@date 16-04-2013 01:45:48
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODProrrateo extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarProrrateo(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.f_prorrateo_sel';
		$this->transaccion='TES_PRO_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_prorrateo','int4');
		$this->captura('id_obligacion_det','int4');
		$this->captura('monto_ejecutar_mb','numeric');
		$this->captura('id_partida_ejecucion_dev','int4');
		$this->captura('id_plan_pago','int4');
		$this->captura('id_transaccion_dev','int4');
		$this->captura('id_transaccion_pag','int4');
		$this->captura('id_partida_ejecucion_pag','int4');
		$this->captura('monto_ejecutar_mo','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('codigo_cc','text');
		$this->captura('desc_ingas','varchar');
		$this->captura('descripcion','text');
		
		
		$this->captura('nombre_programa','varchar');
		$this->captura('nombre_proyecto','varchar');
		$this->captura('nombre_actividad','varchar');
		$this->captura('nombre_financiador','varchar');
		$this->captura('nombre_regional','varchar');
		$this->captura('nombre_uo','varchar');
		$this->captura('nombre_partida','varchar');
		$this->captura('codigo_partida','varchar');
		$this->captura('desc_orden','varchar');
		
		
		
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarProrrateo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.f_prorrateo_ime';
		$this->transaccion='TES_PRO_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_obligacion_det','id_obligacion_det','int4');
		$this->setParametro('monto_ejecutar_mb','monto_ejecutar_mb','numeric');
		$this->setParametro('id_partida_ejecucion_dev','id_partida_ejecucion_dev','int4');
		$this->setParametro('id_plan_pago','id_plan_pago','int4');
		$this->setParametro('id_transaccion_dev','id_transaccion_dev','int4');
		$this->setParametro('id_transaccion_pag','id_transaccion_pag','int4');
		$this->setParametro('id_partida_ejecucion_pag','id_partida_ejecucion_pag','int4');
		$this->setParametro('monto_ejecutar_mo','monto_ejecutar_mo','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarProrrateo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.f_prorrateo_ime';
		$this->transaccion='TES_PRO_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_prorrateo','id_prorrateo','int4');
		$this->setParametro('id_obligacion_det','id_obligacion_det','int4');
		$this->setParametro('monto_ejecutar_mb','monto_ejecutar_mb','numeric');
		$this->setParametro('id_partida_ejecucion_dev','id_partida_ejecucion_dev','int4');
		$this->setParametro('id_plan_pago','id_plan_pago','int4');
		$this->setParametro('id_transaccion_dev','id_transaccion_dev','int4');
		$this->setParametro('id_transaccion_pag','id_transaccion_pag','int4');
		$this->setParametro('id_partida_ejecucion_pag','id_partida_ejecucion_pag','int4');
		$this->setParametro('monto_ejecutar_mo','monto_ejecutar_mo','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarProrrateo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.f_prorrateo_ime';
		$this->transaccion='TES_PRO_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_prorrateo','id_prorrateo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>