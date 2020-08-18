<?php
/**
*@package pXP
*@file gen-MODTsLibroBancos.php
*@author  (admin)
*@date 01-12-2013 09:10:17
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 HISTORIAL DE MODIFICACIONES:
     ISSUE 		   FECHA   			 AUTOR				 		DESCRIPCION:
 * * #67           14/08/2020		 Mercedes Zambrana KPLIAN	Adicion de correo proveedor
*/

class MODTsLibroBancos extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarTsLibroBancos(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_ts_libro_bancos_sel';
		$this->transaccion='TES_LBAN_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_libro_bancos','int4');
		$this->captura('num_tramite','varchar');
		$this->captura('id_cuenta_bancaria','int4');
		$this->captura('fecha','date');
		$this->captura('a_favor','varchar');
		$this->captura('nro_cheque','int4');
		$this->captura('importe_deposito','numeric');
		$this->captura('nro_liquidacion','varchar');
		$this->captura('detalle','text');
		$this->captura('origen','varchar');
		$this->captura('observaciones','text');
		$this->captura('importe_cheque','numeric');
		$this->captura('id_libro_bancos_fk','int4');
		$this->captura('estado','varchar');
		$this->captura('nro_comprobante','varchar');
		$this->captura('comprobante_sigma','varchar');
		$this->captura('indice','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('tipo','varchar');
		$this->captura('nro_deposito','integer');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('id_depto','int4');
		$this->captura('nombre','varchar');
		$this->captura('id_proceso_wf','int4');
		$this->captura('id_estado_wf','int4');
		$this->captura('fecha_cheque_literal','text');
		$this->captura('id_finalidad','int4');
		$this->captura('nombre_finalidad','varchar');
		$this->captura('color','varchar');
		$this->captura('saldo_deposito','numeric');
		$this->captura('nombre_regional','varchar');
		$this->captura('sistema_origen','varchar');
		$this->captura('notificado','varchar');
		$this->captura('fondo_devolucion_retencion','varchar');
		
		$this->captura('correo_proveedor','varchar');//#67
		$this->captura('id_proveedor','integer');//#67
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		//echo $this->getConsulta(); exit;
		return $this->respuesta;
	}
		
	function listarTsLibroBancosDepositosConSaldo(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_ts_libro_bancos_sel';
		$this->transaccion='TES_LBANSAL_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		//Definicion de la lista del resultado del query
		$this->captura('id_libro_bancos','int4');
		$this->captura('fecha','date');
		$this->captura('a_favor','varchar');
		$this->captura('detalle','text');
		$this->captura('observaciones','text');
		$this->captura('importe_deposito','numeric');
		$this->captura('saldo','numeric');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	
    function reporteLibroBancos(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_ts_libro_bancos_sel';
		$this->transaccion='TES_RELIBA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('id_finalidad','id_finalidad','int4');
		
		$this->setParametro('fecha_ini_reg','fecha_ini_reg','date');
		$this->setParametro('fecha_fin_reg','fecha_fin_reg','date');
		$this->setCount(false);
		
		//Definicion de la lista del resultado del query
		$this->captura('fecha_reporte','text');
		$this->captura('fecha_reg','text');
		$this->captura('a_favor','varchar');
		$this->captura('detalle','text');
		$this->captura('nro_liquidacion','varchar');
		$this->captura('nro_comprobante','varchar');
		$this->captura('comprobante_sigma','varchar');
		$this->captura('nro_cheque','integer');
		$this->captura('importe_deposito','numeric');
		$this->captura('importe_cheque','numeric');
		$this->captura('saldo','numeric');
		$this->captura('total_debe','numeric');
		$this->captura('total_haber','numeric');
		$this->captura('indice','numeric');
		$this->captura('fecha','date');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function insertarTsLibroBancos(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_ts_libro_bancos_ime';
		$this->transaccion='TES_LBAN_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('id_depto','id_depto','int4');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('a_favor','a_favor','varchar');
		$this->setParametro('nro_cheque','nro_cheque','int4');
		$this->setParametro('nro_deposito','nro_deposito','int4');
		$this->setParametro('importe_deposito','importe_deposito','numeric');
		$this->setParametro('nro_liquidacion','nro_liquidacion','varchar');
		$this->setParametro('detalle','detalle','text');
		$this->setParametro('origen','origen','varchar');
		$this->setParametro('observaciones','observaciones','text');
		$this->setParametro('importe_cheque','importe_cheque','numeric');
		$this->setParametro('id_libro_bancos_fk','id_libro_bancos_fk','int4');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('nro_comprobante','nro_comprobante','varchar');
		$this->setParametro('comprobante_sigma','comprobante_sigma','varchar');
		$this->setParametro('indice','indice','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('id_finalidad','id_finalidad','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarTsLibroBancos(){ 
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_ts_libro_bancos_ime';
		$this->transaccion='TES_LBAN_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_libro_bancos','id_libro_bancos','int4');
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('a_favor','a_favor','varchar');
		$this->setParametro('nro_cheque','nro_cheque','int4');
		$this->setParametro('importe_deposito','importe_deposito','numeric');
		$this->setParametro('nro_liquidacion','nro_liquidacion','varchar');
		$this->setParametro('detalle','detalle','text');
		$this->setParametro('origen','origen','varchar');
		$this->setParametro('observaciones','observaciones','text');
		$this->setParametro('importe_cheque','importe_cheque','numeric');
		$this->setParametro('id_libro_bancos_fk','id_libro_bancos_fk','int4');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('nro_comprobante','nro_comprobante','varchar');
		$this->setParametro('comprobante_sigma','comprobante_sigma','varchar');
		$this->setParametro('indice','indice','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('id_finalidad','id_finalidad','int4');
		$this->setParametro('nro_deposito','nro_deposito','int4');
		//#67
		$this->setParametro('id_proveedor','id_proveedor','int4');
		$this->setParametro('correo_proveedor','correo_proveedor','varchar');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
//echo $this->getConsulta(); exit;
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarTsLibroBancos(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.ft_ts_libro_bancos_ime';
		$this->transaccion='TES_LBAN_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_libro_bancos','id_libro_bancos','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function anteriorEstadoLibroBancos(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='tes.ft_ts_libro_bancos_ime';
        $this->transaccion='TES_ANTELB_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_libro_bancos','id_libro_bancos','int4');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        $this->setParametro('operacion','operacion','varchar');
		$this->setParametro('obs','obs','varchar');
        
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
	
	function siguienteEstadoLibroBancos(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='tes.ft_ts_libro_bancos_ime';
        $this->transaccion='TES_SIGELB_IME';
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
	
	function fondoDevolucionRetencion(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='tes.ft_ts_libro_bancos_ime';
        $this->transaccion='TES_DEVRET_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_libro_bancos','id_libro_bancos','int4');
		$this->setParametro('operacion','operacion','varchar');
		
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
	
	function transferirDeposito(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='tes.ft_ts_libro_bancos_ime';
        $this->transaccion='TES_TRALB_IME';
        $this->tipo_procedimiento='IME';
        
        //Define los parametros para la funcion
        $this->setParametro('id_libro_bancos','id_libro_bancos','int4');
        $this->setParametro('id_libro_bancos_fk','id_libro_bancos_fk','int4');
        $this->setParametro('tipo','tipo','varchar');		
		$this->setParametro('importe_transferencia','importe_transferencia','numeric');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

	function transferirCuenta(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='tes.ft_ts_libro_bancos_ime';
        $this->transaccion='TES_TRACUEN_IME';
        $this->tipo_procedimiento='IME';
        
        //Define los parametros para la funcion
        $this->setParametro('id_depto_lb','id_depto_lb','int4');
		$this->setParametro('id_cuenta_bancaria_origen','id_cuenta_bancaria_origen','int4');
        $this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('importe_transferencia','importe_transferencia','numeric');
		$this->setParametro('a_favor','a_favor','varchar');
		$this->setParametro('detalle','detalle','varchar');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('id_finalidad','id_finalidad','int4');
		
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
	
	function relacionarCheque(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='tes.ft_ts_libro_bancos_ime';
        $this->transaccion='TES_RELCHQ_IME';
        $this->tipo_procedimiento='IME';
        
        //Define los parametros para la funcion
        $this->setParametro('id_libro_bancos_old','id_libro_bancos_old','int4');
        $this->setParametro('id_libro_bancos_new','id_libro_bancos_new','int4');
		
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
	
	function listarDepositosENDESIS(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='migra.ft_ts_libro_bancos_endesis_sel';
		$this->transaccion='MIG_CBANESIS_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		$this->setTipoRetorno('record');
		
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('fecha','fecha','date');
		
		$this->captura('id_cuenta_bancaria_mov','int4');
		$this->captura('id_cuenta_bancaria','int4');
		$this->captura('fecha','date');
		$this->captura('a_favor','varchar');
		$this->captura('detalle','text');
		$this->captura('observaciones','text');
		$this->captura('nro_liquidacion','varchar');
		$this->captura('nro_comprobante','varchar');
		$this->captura('nro_cheque','int4');
		$this->captura('tipo','varchar');
		$this->captura('importe_deposito','numeric');
		$this->captura('importe_cheque','numeric');
		$this->captura('saldo','numeric');
		$this->captura('origen','varchar');
		$this->captura('estado','varchar');
		$this->captura('usr_reg','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usr_mod','varchar');
		$this->captura('fecha_mod','timestamp');
		$this->captura('fk_libro_bancos','int4');
		$this->captura('fecha_cheque_literal','text');
		$this->captura('emparejado','varchar');
		$this->captura('origen_cbte','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		//echo $this->consulta;exit; 
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function obtenerDatosSolicitanteFondoAvance(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.ft_ts_libro_bancos_sel';
		$this->transaccion='TES_SOLFONAVA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setCount(false);
		$this->setParametro('id_libro_bancos','id_libro_bancos','int4');
		//Definicion de la lista del resultado del query
		$this->captura('email','varchar');
		$this->captura('nombre_completo','text');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}	


	function repLibroBancos(){
		$this->procedimiento='tes.ft_ts_libro_bancos_sel';
		$this->transaccion='TES_REBAN_SEL';
		$this->tipo_procedimiento='SEL';
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('fecha_fin','fecha_fin','date');		
		$this->setCount(false);
		
		//Definicion de la lista del resultado del query
		/*
		
		$this->captura('fecha_reporte','text');
		$this->captura('fecha_reg','text');
		*/
		$this->captura('fecha','date');
		$this->captura('id_int_comprobante','int4');
		$this->captura('nro_cuenta','varchar');
		$this->captura('nombre_cuenta','varchar');
		$this->captura('nro_cheque','varchar');
		
		$this->captura('importe_debe_mb','numeric');
		$this->captura('importe_haber_mb','numeric');
		$this->captura('importe_gasto_mb','numeric');
		$this->captura('importe_recurso_mb','numeric');

		$this->captura('importe_debe_mt','numeric');
		$this->captura('importe_haber_mt','numeric');
		$this->captura('importe_gasto_mt','numeric');
		$this->captura('importe_recurso_mt','numeric');
		
		$this->captura('importe_debe_ma','numeric');
		$this->captura('importe_haber_ma','numeric');
		$this->captura('importe_gasto_ma','numeric');
		$this->captura('importe_recurso_ma','numeric');
		
		$this->captura('saldo','numeric');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
}
?>