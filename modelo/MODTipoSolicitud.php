<?php
/**
*@package pXP
*@file MODTipoSolicitud.php
*@author  Gonzalo Sarmiento 
*@date 04-02-2016 21:15:09
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODTipoSolicitud extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarTipoSolicitud(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_tipo_solicitud_sel';
		$this->transaccion='TES_TPSOL_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_tipo_solicitud','int4');
		$this->captura('codigo','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('codigo_proceso_llave_wf','varchar');
		$this->captura('codigo_plantilla_comprobante','varchar');
		$this->captura('nombre','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarTipoSolicitud(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_tipo_solicitud_ime';
		$this->transaccion='TES_TPSOL_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo_proceso_llave_wf','codigo_proceso_llave_wf','varchar');
		$this->setParametro('codigo_plantilla_comprobante','codigo_plantilla_comprobante','varchar');
		$this->setParametro('nombre','nombre','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarTipoSolicitud(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_tipo_solicitud_ime';
		$this->transaccion='TES_TPSOL_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_solicitud','id_tipo_solicitud','int4');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo_proceso_llave_wf','codigo_proceso_llave_wf','varchar');
		$this->setParametro('codigo_plantilla_comprobante','codigo_plantilla_comprobante','varchar');
		$this->setParametro('nombre','nombre','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarTipoSolicitud(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_tipo_solicitud_ime';
		$this->transaccion='TES_TPSOL_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_solicitud','id_tipo_solicitud','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>