<?php
/**
*@package pXP
*@file gen-MODSolicitudEfectivo.php
*@author  (gsarmiento)
*@date 24-11-2015 12:59:51
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODSolicitudEfectivo extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarSolicitudEfectivo(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_solicitud_efectivo_sel';
		$this->transaccion='TES_SOLEFE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
		$this->setParametro('tipo_interfaz','tipo_interfaz','varchar');
				
		//Definicion de la lista del resultado del query
		$this->captura('id_solicitud_efectivo','int4');
		$this->captura('id_caja','int4');
		$this->captura('codigo','varchar');		
		$this->captura('id_depto','int4');
		$this->captura('id_estado_wf','int4');
		$this->captura('monto','numeric');
		$this->captura('monto_rendido','numeric');
		$this->captura('monto_devuelto','numeric');
		$this->captura('monto_repuesto','numeric');
		$this->captura('id_proceso_wf','int4');
		$this->captura('nro_tramite','varchar');
		$this->captura('estado','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('motivo','text');
		$this->captura('id_funcionario','int4');
		$this->captura('desc_funcionario','text');
		$this->captura('fecha','date');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('solicitud_efectivo_padre','varchar');
		$this->captura('saldo','numeric');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarSolicitudEfectivo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_solicitud_efectivo_ime';
		$this->transaccion='TES_SOLEFE_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_caja','id_caja','int4');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('monto','monto','numeric');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		$this->setParametro('nro_tramite','nro_tramite','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('motivo','motivo','text');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('fecha','fecha','date');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarSolicitudEfectivo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_solicitud_efectivo_ime';
		$this->transaccion='TES_SOLEFE_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_solicitud_efectivo','id_solicitud_efectivo','int4');
		$this->setParametro('id_caja','id_caja','int4');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('monto','monto','numeric');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		$this->setParametro('nro_tramite','nro_tramite','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('motivo','motivo','text');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('fecha','fecha','date');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarSolicitudEfectivo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_solicitud_efectivo_ime';
		$this->transaccion='TES_SOLEFE_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_solicitud_efectivo','id_solicitud_efectivo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function siguienteEstadoSolicitudEfectivo(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='tes.ft_solicitud_efectivo_ime';
        $this->transaccion='TES_SIGESOLEFE_IME';
        $this->tipo_procedimiento='IME';
        
        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
        $this->setParametro('id_estado_wf_act','id_estado_wf_act','int4');
        $this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
        $this->setParametro('id_depto_wf','id_depto_wf','int4');
        $this->setParametro('obs','obs','text');
		
        $this->setParametro('saldo','saldo','numeric');
        $this->setParametro('devolucion_dinero','devolucion_dinero','varchar');		

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
	
	function anteriorEstadoSolicitudEfectivo(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='tes.ft_solicitud_efectivo_ime';
        $this->transaccion='TES_ANTESOLEFE_IME';
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
	
	function insertarSolicitudEfectivoCompleta(){
		
		//Abre conexion con PDO
		$cone = new conexion();
		$link = $cone->conectarpdo();
		$copiado = false;			
		try {
			$link->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);		
		  	$link->beginTransaction();
			
			/////////////////////////
			//  inserta cabecera de la solicitud de compra
			///////////////////////
			
			
			//Definicion de variables para ejecucion del procedimiento
			$this->procedimiento = 'tes.ft_solicitud_efectivo_ime';
			$this->transaccion = 'TES_SOLEFE_INS';
			$this->tipo_procedimiento = 'IME';
					
			//Define los parametros para la funcion
			$this->setParametro('id_caja','id_caja','int4');
			$this->setParametro('id_estado_wf','id_estado_wf','int4');
			$this->setParametro('monto','monto','numeric');
			$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
			$this->setParametro('nro_tramite','nro_tramite','varchar');
			$this->setParametro('estado','estado','varchar');
			$this->setParametro('estado_reg','estado_reg','varchar');
			$this->setParametro('motivo','motivo','text');
			$this->setParametro('id_funcionario','id_funcionario','int4');
			$this->setParametro('tipo_solicitud','tipo_solicitud','varchar');
			$this->setParametro('fecha','fecha','date');
			
			//Ejecuta la instruccion
            $this->armarConsulta();			
			$stmt = $link->prepare($this->consulta);		  
		  	$stmt->execute();
			$result = $stmt->fetch(PDO::FETCH_ASSOC);				
			
			//recupera parametros devuelto depues de insertar ... (id_obligacion_pago)
			$resp_procedimiento = $this->divRespuesta($result['f_intermediario_ime']);
			if ($resp_procedimiento['tipo_respuesta']=='ERROR') {
				throw new Exception("Error al ejecutar en la bd", 3);
			}
			$respuesta = $resp_procedimiento['datos'];
			
			$id_solicitud_efectivo = $respuesta['id_solicitud_efectivo'];
			
			//////////////////////////////////////////////
			//inserta detalle de la solicitud de compra
			/////////////////////////////////////////////
			
			
			
			//decodifica JSON  de detalles 
			$json_detalle = $this->aParam->_json_decode($this->aParam->getParametro('json_new_records'));			
			
			//var_dump($json_detalle)	;
			foreach($json_detalle as $f){
				
				$this->resetParametros();
				//Definicion de variables para ejecucion del procedimiento
			    $this->procedimiento='tes.ft_solicitud_efectivo_det_ime';
				$this->transaccion='TES_SOLDET_INS';
				$this->tipo_procedimiento='IME';
				//modifica los valores de las variables que mandaremos
				
				$this->arreglo['id_solicitud_efectivo'] = $id_solicitud_efectivo;
				$this->arreglo['id_cc'] = $f['id_cc'];
				$this->arreglo['id_concepto_ingas'] = $f['id_concepto_ingas'];
				$this->arreglo['id_partida_ejecucion'] = $f['id_partida_ejecucion'];
				$this->arreglo['estado_reg'] = $f['estado_reg'];
				$this->arreglo['monto'] = $f['monto'];
						
				//Define los parametros para la funcion
				$this->setParametro('id_solicitud_efectivo','id_solicitud_efectivo','int4');
				$this->setParametro('id_cc','id_cc','int4');
				$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
				$this->setParametro('id_partida_ejecucion','id_partida_ejecucion','text');
				$this->setParametro('estado_reg','estado_reg','numeric');
				$this->setParametro('monto','monto','int4');
				
				//Ejecuta la instruccion
	            $this->armarConsulta();
				$stmt = $link->prepare($this->consulta);		  
			  	$stmt->execute();
				$result = $stmt->fetch(PDO::FETCH_ASSOC);				
				
				//recupera parametros devuelto depues de insertar ... (id_solicitud)
				$resp_procedimiento = $this->divRespuesta($result['f_intermediario_ime']);
				if ($resp_procedimiento['tipo_respuesta']=='ERROR') {
					throw new Exception("Error al insertar detalle  en la bd", 3);
				}
                    
                        
            }
			
			
			
			//si todo va bien confirmamos y regresamos el resultado
			$link->commit();
			$this->respuesta=new Mensaje();
			$this->respuesta->setMensaje($resp_procedimiento['tipo_respuesta'],$this->nombre_archivo,$resp_procedimiento['mensaje'],$resp_procedimiento['mensaje_tec'],'base',$this->procedimiento,$this->transaccion,$this->tipo_procedimiento,$this->consulta);
			$this->respuesta->setDatos($respuesta);
		} 
	    catch (Exception $e) {			
		    	$link->rollBack();
				$this->respuesta=new Mensaje();
				if ($e->getCode() == 3) {//es un error de un procedimiento almacenado de pxp
					$this->respuesta->setMensaje($resp_procedimiento['tipo_respuesta'],$this->nombre_archivo,$resp_procedimiento['mensaje'],$resp_procedimiento['mensaje_tec'],'base',$this->procedimiento,$this->transaccion,$this->tipo_procedimiento,$this->consulta);
				} else if ($e->getCode() == 2) {//es un error en bd de una consulta
					$this->respuesta->setMensaje('ERROR',$this->nombre_archivo,$e->getMessage(),$e->getMessage(),'modelo','','','','');
				} else {//es un error lanzado con throw exception
					throw new Exception($e->getMessage(), 2);
				}
				
		}    
	    
	    return $this->respuesta;
	}
}
?>