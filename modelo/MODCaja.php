<?php
/**
*@package pXP
*@file gen-MODCaja.php
*@author  (admin)
*@date 16-12-2013 20:43:44
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODCaja extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarCaja(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_caja_sel';
		$this->transaccion='TES_CAJA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('tipo_interfaz','tipo_interfaz','varchar');
				
		//Definicion de la lista del resultado del query
		$this->captura('id_caja','int4');
		$this->captura('estado','varchar');
		$this->captura('importe_maximo','numeric');
		$this->captura('saldo','numeric');
		$this->captura('tipo','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('estado_proceso','varchar');
		$this->captura('porcentaje_compra','numeric');
		$this->captura('id_moneda','int4');
		$this->captura('id_depto','int4');
		$this->captura('id_cuenta_bancaria','int4');
		$this->captura('cuenta_bancaria','text');
		$this->captura('codigo','varchar');
		$this->captura('cajero','text');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_moneda','varchar');
		$this->captura('desc_depto','varchar');
		$this->captura('tipo_ejecucion','varchar');	
		$this->captura('id_proceso_wf','int4');
		$this->captura('id_estado_wf','int4');
		$this->captura('nro_tramite','varchar');		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarCaja(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_caja_ime';
		$this->transaccion='TES_CAJA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('importe_maximo','importe_maximo','numeric');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('porcentaje_compra','porcentaje_compra','numeric');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('id_depto','id_depto','int4');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('tipo_ejecucion','tipo_ejecucion','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarCaja(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_caja_ime';
		$this->transaccion='TES_CAJA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_caja','id_caja','int4');
		$this->setParametro('importe_maximo','importe_maximo','numeric');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('porcentaje_compra','porcentaje_compra','numeric');
		$this->setParametro('id_moneda','id_moneda','int4');		
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('id_depto','id_depto','int4');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('tipo_ejecucion','tipo_ejecucion','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function abrirCerrarCaja(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_caja_ime';
		$this->transaccion='TES_CAJA_ABRCER';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_caja','id_caja','int4');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('id_depto_lb','id_depto_lb','int4');
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('importe','importe','numeric');
		$this->setParametro('a_favor','a_favor','varchar');
		$this->setParametro('detalle','detalle','varchar');
		$this->setParametro('id_finalidad','id_finalidad','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function eliminarCaja(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_caja_ime';
		$this->transaccion='TES_CAJA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_caja','id_caja','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function siguienteEstadoCaja(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='tes.ft_caja_ime';
        $this->transaccion='TES_SIGECAJA_IME';
        $this->tipo_procedimiento='IME';
        
        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
        $this->setParametro('id_estado_wf_act','id_estado_wf_act','int4');
        $this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
        $this->setParametro('id_depto_wf','id_depto_wf','int4');
        $this->setParametro('obs','obs','text');
        $this->setParametro('json_procesos','json_procesos','text');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
	
	function anteriorEstadoCaja(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='tes.ft_caja_ime';
        $this->transaccion='TES_ANTECAJA_IME';
        $this->tipo_procedimiento='IME';
        
        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        $this->setParametro('id_estado_wf','id_estado_wf','int4');
        $this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
        $this->setParametro('id_depto_wf','id_depto_wf','int4');
        $this->setParametro('obs','obs','text');
        $this->setParametro('json_procesos','json_procesos','text');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
}
?>