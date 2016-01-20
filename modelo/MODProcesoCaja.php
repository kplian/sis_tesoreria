<?php
/**
*@package pXP
*@file gen-MODProcesoCaja.php
*@author  (gsarmiento)
*@date 21-12-2015 20:15:22
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODProcesoCaja extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarProcesoCaja(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_proceso_caja_sel';
		$this->transaccion='TES_REN_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('tipo_interfaz','tipo_interfaz','varchar');
				
		//Definicion de la lista del resultado del query
		$this->captura('id_proceso_caja','int4');
		$this->captura('estado','varchar');
		$this->captura('id_comprobante_diario','int4');
		$this->captura('nro_tramite','varchar');
		$this->captura('tipo','varchar');
		$this->captura('motivo','text');
		$this->captura('estado_reg','varchar');
		$this->captura('fecha_fin','date');
		$this->captura('id_caja','int4');
		$this->captura('fecha','date');
		$this->captura('id_proceso_wf','int4');
		$this->captura('monto_reposicion','numeric');
		$this->captura('id_comprobante_pago','int4');
		$this->captura('id_estado_wf','int4');
		$this->captura('fecha_inicio','date');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
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
			
	function insertarProcesoCaja(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_proceso_caja_ime';
		$this->transaccion='TES_REN_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('id_comprobante_diario','id_comprobante_diario','int4');
		$this->setParametro('nro_tramite','nro_tramite','varchar');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('motivo','motivo','text');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('id_caja','id_caja','int4');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		$this->setParametro('monto_reposicion','monto_reposicion','numeric');
		$this->setParametro('id_comprobante_pago','id_comprobante_pago','int4');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('fecha_inicio','fecha_inicio','date');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarProcesoCaja(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_proceso_caja_ime';
		$this->transaccion='TES_REN_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_proceso_caja','id_proceso_caja','int4');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('id_comprobante_diario','id_comprobante_diario','int4');
		$this->setParametro('nro_tramite','nro_tramite','varchar');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('motivo','motivo','text');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('id_caja','id_caja','int4');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		$this->setParametro('monto_reposicion','monto_reposicion','numeric');
		$this->setParametro('id_comprobante_pago','id_comprobante_pago','int4');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('fecha_inicio','fecha_inicio','date');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarProcesoCaja(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_proceso_caja_ime';
		$this->transaccion='TES_REN_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_proceso_caja','id_proceso_caja','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function siguienteEstadoProcesoCaja(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='tes.ft_proceso_caja_ime';
        $this->transaccion='TES_SIGEREN_IME';
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

	function anteriorEstadoProcesoCaja(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='tes.ft_proceso_caja_ime';
        $this->transaccion='TES_ANTEREN_IME';
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