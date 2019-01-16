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
		$this->captura('importe_maximo_caja','numeric');
		$this->captura('saldo','numeric');
		$this->captura('tipo','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('estado_proceso','varchar');
		$this->captura('importe_maximo_item','numeric');
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
		$this->captura('desc_depto_lb','varchar');
		$this->captura('tipo_ejecucion','varchar');	
		$this->captura('id_proceso_wf','int4');
		$this->captura('id_estado_wf','int4');
		$this->captura('nro_tramite','varchar');		
		$this->captura('dias_maximo_rendicion','int4');
		//$this->captura('id_proceso_caja','int4');				
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//var_dump($this->consulta); exit;
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarCaja(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_caja_ime';
		$this->transaccion='TES_CAJA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('importe_maximo_caja','importe_maximo_caja','numeric');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('importe_maximo_item','importe_maximo_item','numeric');
		$this->setParametro('dias_maximo_rendicion','dias_maximo_rendicion','numeric');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_depto_lb','id_depto_lb','int4');
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
		$this->setParametro('importe_maximo_caja','importe_maximo_caja','numeric');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('importe_maximo_item','importe_maximo_item','numeric');
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
	
	function editMon(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_caja_ime';
		$this->transaccion='TES_CAJA_MOD_MONTO';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_caja','id_caja','int4');
		$this->setParametro('monto','monto','numeric');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('id_proceso_caja','id_proceso_caja','int4');
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
	//
	function listarRepCaja(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_caja_sel';
		$this->transaccion='TES_CAJA_REP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this-> setCount(false);
		$this->setParametro('id_caja','id_caja','int4');
		$this->setParametro('id_proceso_caja','id_proceso_caja','int4');		
		$this->setParametro('nro_tramite','nro_tramite','varchar');
		
		$this->setParametro('fecha','fecha','date');	
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		$this->setParametro('nombre','nombre','varchar');	
		//Definicion de la lista del resultado del query
		
		$this->captura('nro_tramite','varchar');
		$this->captura('tipo','varchar');
		$this->captura('motivo','varchar');
		$this->captura('monto','numeric');
		$this->captura('nombre','varchar');
		$this->captura('id_moneda','int4');	
		$this->captura('razon_social','varchar');
		$this->captura('importe_pago_liquido','numeric');
		$this->captura('fecha','date');
		$this->captura('nombre_fun','varchar');
		$this->captura('fecha_reg','date');
	    $this->captura('estado_r','varchar');		
		$this->captura('nit','varchar');
		$this->captura('nro_autorizacion','varchar');	
		$this->captura('nro_documento','varchar');	
		$this->captura('codigo_control','varchar');
		$this->captura('importe_doc','numeric');	
		$this->captura('importe_iva','numeric');
		$this->captura('nom_proceso','varchar');	
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		return $this->respuesta;
	}
	//
	function listarCajas(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_caja_sel';
		$this->transaccion='TES_LCAJ_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		//Definicion de la lista del resultado del query
		$this-> setCount(false);
		$this->captura('id_caja','int4');
		$this->captura('estado','varchar');
		$this->captura('tipo','varchar');
		$this->captura('codigo','varchar');	
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		return $this->respuesta;
	}

	function repCajaFechas(){
		$this->procedimiento='tes.ft_caja_sel';
		$this->transaccion='TES_RECAJFEC_SEL';
		$this->tipo_procedimiento='SEL';
		$this->setCount(false);
		$this->setParametro('id_caja','id_caja','int4');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('fecha_fin','fecha_fin','date');		
		//Definicion de la lista del resultado del query
		$this->captura('id_solicitud_efectivo','int4');
		$this->captura('fecha','date');
		$this->captura('monto_ingreso','numeric');
		$this->captura('monto_salida','numeric');		
		$this->captura('estado','varchar');
		$this->captura('monto','numeric');
		$this->captura('nro_tramite','varchar');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function repMensualFechas(){
		$this->procedimiento='tes.ft_caja_sel';
		$this->transaccion='TES_REPMENFEC_SEL';
		$this->tipo_procedimiento='SEL';
		$this->setCount(false);
		$this->setParametro('id_caja','id_caja','int4');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('fecha_fin','fecha_fin','date');		
		//Definicion de la lista del resultado del query
		$this->captura('saldo','numeric');
		$this->captura('nro_tramite','varchar');
		$this->captura('desc_plantilla','varchar');
		
		$this->captura('fecha','date');		
		$this->captura('nit','varchar');
		$this->captura('razon_social','varchar');
		
		$this->captura('nro_autorizacion','varchar');
		$this->captura('nro_documento','varchar');
		$this->captura('codigo_control','varchar');
		
		$this->captura('monto','numeric');
		$this->captura('importe_pago_liquido','numeric');
		$this->captura('importe_iva','numeric');
		$this->captura('importe_descuento','numeric');			
		$this->captura('importe_descuento_ley','numeric');
		$this->captura('importe_excento','numeric');
		
		$this->captura('motivo','varchar');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}
	//cabecera
	function recuperarDatos(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_caja_sel';
		$this->transaccion='TES_DATOS_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this-> setCount(false);
		$this->setParametro('id_caja','id_caja','int4');
		$this->setParametro('id_proceso_caja','id_proceso_caja','int4');
		//Definicion de la lista del resultado del query
		
		$this->captura('cajero','varchar');
		$this->captura('codigo','varchar');
		$this->captura('salida','numeric');
		$this->captura('ingreso','numeric');
		$this->captura('nombre','varchar');	
		$this->captura('saldo','numeric');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		return $this->respuesta;
	}
	//
	//
	function listDatArq(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_caja_sel';
		$this->transaccion='TES_CAJARQ_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this-> setCount(false);
		$this->setParametro('id_caja','id_caja','int4');
		$this->setParametro('id_proceso_caja','id_proceso_caja','int4');		
		$this->setParametro('nro_tramite','nro_tramite','varchar');
		
		$this->setParametro('fecha','fecha','date');	
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		$this->setParametro('nombre','nombre','varchar');	
		//Definicion de la lista del resultado del query
		
		$this->captura('nro_tramite','varchar');
		$this->captura('tipo','varchar');
		$this->captura('motivo','varchar');
		$this->captura('monto','numeric');
		$this->captura('nombre','varchar');
		$this->captura('id_moneda','int4');	
		$this->captura('razon_social','varchar');
		$this->captura('importe_pago_liquido','numeric');
		$this->captura('fecha','date');
		$this->captura('nombre_fun','varchar');
		$this->captura('fecha_reg','date');
	    $this->captura('estado_r','varchar');		
		$this->captura('nit','varchar');
		$this->captura('nro_autorizacion','varchar');	
		$this->captura('nro_documento','varchar');	
		$this->captura('codigo_control','varchar');
		$this->captura('importe_doc','numeric');	
		$this->captura('importe_iva','numeric');
		$this->captura('nom_proceso','varchar');	
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		return $this->respuesta;
	}
	
}
?>