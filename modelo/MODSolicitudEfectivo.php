<?php
/*
  ISSUE      FORK       FECHA:              AUTOR                 DESCRIPCION
  #29      ETR     01/04/2019      MANUEL GUERRA           el inmediato superior sera responsable de los funcionarios inactivos
#62      ETR       18/03/2020        MANUEL GUERRA           envio de param, para la paginacion, toolbar ayuda, botones de envio de correo y rechazo de sol por tiempo
*/

class MODSolicitudEfectivo extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
	//	#62
	function listarSolicitudEfectivo(){
		//Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='tes.ft_solicitud_efectivo_sel';
		$this->transaccion='TES_SOLEFE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
		$this->setParametro('tipo_interfaz','tipo_interfaz','varchar');
		$this->setParametro('historico','historico','varchar');
		$this->setParametro('pes_estado','pes_estado','varchar');	
		//Definicion de la lista del resultado del query
		$this->captura('id_solicitud_efectivo','int4');
		$this->captura('id_caja','int4');
		$this->captura('codigo','varchar');		
		$this->captura('id_depto','int4');
		$this->captura('id_moneda','int4');
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
		$this->captura('fecha_entrega','date');
		$this->captura('dias_maximo_rendicion','int4');
		$this->captura('dias_no_rendido','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('solicitud_efectivo_padre','varchar');
        $this->captura('fecha_mov','date');
        $this->captura('diferencia','int4');
        $this->captura('id_tipo_solicitud','int4');
        $this->captura('nombre','varchar');
		$this->captura('saldo','numeric');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}

   function listarSolicitudIngreso(){
        //Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_solicitud_efectivo_sel';
		$this->transaccion='TES_INGRESOL_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
		$this->setParametro('tipo_interfaz','tipo_interfaz','varchar');
		$this->setParametro('historico','historico','varchar');

		//Definicion de la lista del resultado del query
		$this->captura('id_solicitud_efectivo','int4');
		$this->captura('id_caja','int4');
		$this->captura('codigo','varchar');		
		$this->captura('id_depto','int4');
		$this->captura('id_moneda','int4');
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
		$this->captura('fecha_entrega','date');
		$this->captura('dias_maximo_rendicion','int4');
		$this->captura('dias_no_rendido','int4');
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
		$this->setParametro('tipo_solicitud','tipo_solicitud','varchar');
		$this->setParametro('id_solicitud_efectivo_fk','id_solicitud_efectivo_fk','int4');

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
		$this->setParametro('tipo_solicitud','tipo_solicitud','varchar');
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

	function ampliarDiasRendicion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_solicitud_efectivo_ime';
		$this->transaccion='TES_AMPREN_IME';
		$this->tipo_procedimiento='IME';//tipo de transaccion
		//Define los parametros para la funcion
		$this->setParametro('id_solicitud_efectivo','id_solicitud_efectivo','int4');
		$this->setParametro('dias_ampliado','dias_ampliado','int4');
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
	
	function devolucionSolicitudEfectivo(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='tes.ft_solicitud_efectivo_ime';
        $this->transaccion='TES_DEVSOLEFE_IME';
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
	
	function reporteSolicitudEfectivo(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_solicitud_efectivo_sel';
		$this->transaccion='TES_REPEFE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		//Definicion de la lista del resultado del query
		$this->captura('codigo','varchar');
		$this->captura('monto','numeric');		
		$this->captura('moneda','varchar');
		$this->captura('codigo_moneda','varchar');
		$this->captura('monto_literal','varchar');		
		$this->captura('nro_tramite','varchar');
		$this->captura('estado','varchar');
		$this->captura('motivo','text');
		$this->captura('desc_funcionario','text');
		$this->captura('fecha','date');
		$this->captura('vbjefe','text');
		$this->captura('vbfinanzas','text');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function reporteReciboEntrega(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_solicitud_efectivo_sel';
		$this->transaccion='TES_SOLENT_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		//Definicion de la lista del resultado del query		
		$this->captura('codigo_proc','varchar');
		$this->captura('fecha_entrega','date');
		$this->captura('moneda','varchar');		
		$this->captura('nro_tramite','varchar');
		$this->captura('codigo','varchar');
		$this->captura('cajero','text');		
		$this->captura('nombre_unidad','varchar');
		$this->captura('solicitante','text');
		$this->captura('superior','varchar');
		$this->captura('motivo','text');
		$this->captura('monto','numeric');
		$this->captura('fecha_rendicion','date');
		$this->captura('monto_dev','numeric');
		//Ejecuta la instruccion
		$this->armarConsulta();
		//var_dump($this->consulta); exit;
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function memoCajaChica(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_solicitud_efectivo_sel';
		$this->transaccion='TES_MEMOCJ_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		//$this->setParametro('id_libro_bancos','id_libro_bancos','int4');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		//Definicion de la lista del resultado del query
		$this->captura('fecha','date');
		$this->captura('nro_cheque','int4');		
		$this->captura('codigo','varchar');
		$this->captura('aprobador','text');
		$this->captura('cargo_aprobador','varchar');		
		$this->captura('cajero','text');
		$this->captura('cargo_cajero','varchar');
		$this->captura('importe_cheque','numeric');
		$this->captura('num_memo','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function reporteRendicionEfectivo(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_solicitud_efectivo_sel';
		$this->transaccion='TES_RNDEFE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
	
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		//Definicion de la lista del resultado del query
		$this->captura('fecha_entrega','date');
		$this->captura('desc_plantilla','varchar');		
		$this->captura('rendicion','text');
		$this->captura('importe_neto','numeric');
		$this->captura('impuesto_descuento_ley','numeric');		
		$this->captura('cargo','numeric');
		$this->captura('descargo','numeric');
		$this->captura('importe_pago_liquido','numeric');
		$this->captura('motivo','varchar');
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
    //#62
    function rechazarSol(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='tes.ft_solicitud_efectivo_ime';
        $this->transaccion='TES_RECSOL_IME';
        $this->tipo_procedimiento='IME';

        $this->setParametro('id_solicitud_efectivo','id_solicitud_efectivo','int4');
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }
    //#62
    function envioCorreo(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='tes.ft_solicitud_efectivo_ime';
        $this->transaccion='TES_ENVCOR_IME';
        $this->tipo_procedimiento='IME';

        $this->setParametro('id_solicitud_efectivo','id_solicitud_efectivo','int4');
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('id_usuario_reg','id_usuario_reg','int4');
        $this->setParametro('nro_tramite','nro_tramite','varchar');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }
    //#62
    function devolverSol(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='tes.ft_solicitud_efectivo_ime';
        $this->transaccion='TES_DEVSOL_IME';
        $this->tipo_procedimiento='IME';

        $this->setParametro('id_solicitud_efectivo','id_solicitud_efectivo','int4');
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }
}
?>