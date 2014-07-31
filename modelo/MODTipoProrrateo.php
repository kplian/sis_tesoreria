<?php
/**
*@package pXP
*@file gen-MODTipoProrrateo.php
*@author  (jrivera)
*@date 31-07-2014 23:29:22
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODTipoProrrateo extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarTipoProrrateo(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_tipo_prorrateo_sel';
		$this->transaccion='TES_TIPO_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_tipo_prorrateo','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('descripcion','text');
		$this->captura('es_plantilla','varchar');
		$this->captura('nombre','varchar');
		$this->captura('codigo','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('tiene_cuenta','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarTipoProrrateo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_tipo_prorrateo_ime';
		$this->transaccion='TES_TIPO_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('descripcion','descripcion','text');
		$this->setParametro('es_plantilla','es_plantilla','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('tiene_cuenta','tiene_cuenta','varchar');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarTipoProrrateo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_tipo_prorrateo_ime';
		$this->transaccion='TES_TIPO_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_prorrateo','id_tipo_prorrateo','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('descripcion','descripcion','text');
		$this->setParametro('es_plantilla','es_plantilla','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('tiene_cuenta','tiene_cuenta','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarTipoProrrateo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_tipo_prorrateo_ime';
		$this->transaccion='TES_TIPO_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_prorrateo','id_tipo_prorrateo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>