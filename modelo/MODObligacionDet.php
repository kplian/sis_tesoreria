<?php
/**
*@package pXP
*@file MODObligacionDet.php
*@author  Gonzalo Sarmiento Sejas
*@date 02-04-2013 20:27:35
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODObligacionDet extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarObligacionDet(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_obligacion_det_sel';
		$this->transaccion='TES_OBDET_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
			
		$this->setParametro('id_obligacion_pago','id_obligacion_pago','int4');
		//Definicion de la lista del resultado del query
		$this->captura('id_obligacion_det','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_cuenta','int4');
		$this->captura('nombre_cuenta','varchar');
		$this->captura('id_partida','int4');
		$this->captura('nombre_partida','text');
		$this->captura('id_auxiliar','int4');
		$this->captura('nombre_auxiliar','text');
		$this->captura('id_concepto_ingas','int4');
		$this->captura('nombre_ingas','text');
		$this->captura('monto_pago_mo','numeric');
		$this->captura('id_obligacion_pago','int4');
		$this->captura('id_centro_costo','int4');
		$this->captura('codigo_cc','text');
		$this->captura('monto_pago_mb','numeric');
		$this->captura('factor_porcentual','numeric');
		$this->captura('id_partida_ejecucion_com','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('descripcion','text');
		$this->captura('id_orden_trabajo','int4');
		$this->captura('desc_orden','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarObligacionDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_obligacion_det_ime';
		$this->transaccion='TES_OBDET_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
		$this->setParametro('monto_pago_mo','monto_pago_mo','numeric');
		$this->setParametro('id_obligacion_pago','id_obligacion_pago','int4');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('factor_porcentual','factor_porcentual','numeric');
		$this->setParametro('id_partida_ejecucion_com','id_partida_ejecucion_com','int4');
        $this->setParametro('descripcion','descripcion','text');
		$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
        
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarObligacionDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_obligacion_det_ime';
		$this->transaccion='TES_OBDET_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_obligacion_det','id_obligacion_det','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
		$this->setParametro('monto_pago_mo','monto_pago_mo','numeric');
		$this->setParametro('id_obligacion_pago','id_obligacion_pago','int4');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('factor_porcentual','factor_porcentual','numeric');
		$this->setParametro('id_partida_ejecucion_com','id_partida_ejecucion_com','int4');
        $this->setParametro('descripcion','descripcion','text');
		$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
        
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

	    //Devuelve la respuesta
		return $this->respuesta;
	}

	function modificarObligacionDetApropiacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_obligacion_det_ime';
		$this->transaccion='TES_OBDETAPRO_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_obligacion_det','id_obligacion_det','int4');		
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');		
		$this->setParametro('id_centro_costo','id_centro_costo','int4');		
		$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
		$this->setParametro('monto_pago_mo','monto_pago_mo','numeric');
		$this->setParametro('id_obligacion_pago','id_obligacion_pago','int4');		
        $this->setParametro('descripcion','descripcion','text');
		
        
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

	    //Devuelve la respuesta
		return $this->respuesta;
	}
	
	function insertarObligacionDetApropiacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_obligacion_det_ime';
		$this->transaccion='TES_OBDETAPRO_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_obligacion_det','id_obligacion_det','int4');		
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');		
		$this->setParametro('id_centro_costo','id_centro_costo','int4');		
		$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
		$this->setParametro('monto_pago_mo','monto_pago_mo','numeric');
		$this->setParametro('id_obligacion_pago','id_obligacion_pago','int4');		
        $this->setParametro('descripcion','descripcion','text');
		
        
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

	    //Devuelve la respuesta
		return $this->respuesta;
	}
	
			
	function eliminarObligacionDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_obligacion_det_ime';
		$this->transaccion='TES_OBDET_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_obligacion_det','id_obligacion_det','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function eliminarObligacionDetApropiacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_obligacion_det_ime';
		$this->transaccion='TES_OBDETAPRO_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_obligacion_det','id_obligacion_det','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>