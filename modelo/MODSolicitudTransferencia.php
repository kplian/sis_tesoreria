<?php
/**
*@package pXP
*@file gen-MODSolicitudTransferencia.php
*@author  (admin)
*@date 22-02-2018 03:43:11
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODSolicitudTransferencia extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarSolicitudTransferencia(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_solicitud_transferencia_sel';
		$this->transaccion='TES_SOLTRA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('interfaz','interfaz','varchar');
				
		//Definicion de la lista del resultado del query
		$this->captura('id_solicitud_transferencia','int4');
		$this->captura('id_cuenta_origen','int4');
		$this->captura('id_cuenta_destino','int4');
		$this->captura('id_proceso_wf','int4');
		$this->captura('id_estado_wf','int4');
		$this->captura('monto','numeric');
		$this->captura('motivo','text');
		$this->captura('num_tramite','varchar');
		$this->captura('estado_reg','varchar');		
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('estado','varchar');
		$this->captura('desc_cuenta_origen','varchar');
		$this->captura('desc_cuenta_destino','varchar');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarSolicitudTransferencia(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_solicitud_transferencia_ime';
		$this->transaccion='TES_SOLTRA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_origen','id_cuenta_origen','int4');
		$this->setParametro('id_cuenta_destino','id_cuenta_destino','int4');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('monto','monto','numeric');
		$this->setParametro('motivo','motivo','text');
		$this->setParametro('num_tramite','num_tramite','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarSolicitudTransferencia(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_solicitud_transferencia_ime';
		$this->transaccion='TES_SOLTRA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_solicitud_transferencia','id_solicitud_transferencia','int4');
		$this->setParametro('id_cuenta_origen','id_cuenta_origen','int4');
		$this->setParametro('id_cuenta_destino','id_cuenta_destino','int4');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('monto','monto','numeric');
		$this->setParametro('motivo','motivo','text');
		$this->setParametro('num_tramite','num_tramite','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarSolicitudTransferencia(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_solicitud_transferencia_ime';
		$this->transaccion='TES_SOLTRA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_solicitud_transferencia','id_solicitud_transferencia','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function siguienteEstadoSolicitud(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='tes.ft_solicitud_transferencia_ime';
        $this->transaccion='TES_SIGSOLTRA_IME';
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
    
    function anteriorEstadoPlanilla(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='plani.ft_planilla_ime';
        $this->transaccion='PLA_ANTEPLA_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        $this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('operacion','operacion','varchar');
        
        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_estado_wf','id_estado_wf','int4');
        $this->setParametro('obs','obs','text');
		
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
			
}
?>