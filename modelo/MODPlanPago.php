<?php
/**
*@package pXP
*@file gen-MODPlanPago.php
*@author  (admin)
*@date 10-04-2013 15:43:23
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODPlanPago extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarPlanPago(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.f_plan_pago_sel';
		$this->transaccion='TES_PLAPA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_plan_pago','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('nro_cuota','numeric');
		$this->captura('monto_ejecutar_total_mb','numeric');
		$this->captura('nro_sol_pago','varchar');
		$this->captura('tipo_cambio','numeric');
		$this->captura('fecha_pag','date');
		$this->captura('id_proceso_wf','int4');
		$this->captura('fecha_dev','date');
		$this->captura('estado','varchar');
		$this->captura('tipo_pago','varchar');
		$this->captura('monto_ejecutar_total_mo','numeric');
		$this->captura('descuento_anticipo_mb','numeric');
		$this->captura('obs_descuentos_anticipo','text');
		$this->captura('id_plan_pago_fk','int4');
		$this->captura('id_obligacion_pago','int4');
		$this->captura('id_plantilla','int4');
		$this->captura('descuento_anticipo','numeric');
		$this->captura('otros_descuentos','numeric');
		$this->captura('tipo','varchar');
		$this->captura('obs_monto_no_pagado','text');
		$this->captura('obs_otros_descuentos','text');
		$this->captura('monto','numeric');
		$this->captura('id_comprobante','int4');
		$this->captura('nombre_pago','varchar');
		$this->captura('monto_no_pagado_mb','numeric');
		$this->captura('monto_mb','numeric');
		$this->captura('id_estado_wf','int4');
		$this->captura('id_cuenta_bancaria','int4');
		$this->captura('otros_descuentos_mb','numeric');
		$this->captura('forma_pago','varchar');
		$this->captura('monto_no_pagado','numeric');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('fecha_tentativa','date');
		$this->captura('desc_plantilla','varchar');
		$this->captura('liquido_pagable','numeric');
		$this->captura('total_prorrateado','numeric');
		$this->captura('total_pagado','numeric');
        $this->captura('desc_cuenta_bancaria','text');
        $this->captura('sinc_presupuesto','varchar'); 
        $this->captura('monto_retgar_mb','numeric');
        $this->captura('monto_retgar_mo','numeric');   
        
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarPlanPago(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.f_plan_pago_ime';
		
		if ($this->objParam->getParametro('id_plan_pago_fk') != ''){
		   //insercion de cuota de pago         
		    $this->transaccion='TES_PLAPAPA_INS';    
		    
		}
        else{
          //insercion de cuota de devengado        
          $this->transaccion='TES_PLAPA_INS';      
            
        }
			
		
		
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		
		
		$this->setParametro('tipo_pago','tipo_pago','varchar');
		$this->setParametro('monto_ejecutar_total_mo','monto_ejecutar_total_mo','numeric');
		$this->setParametro('obs_descuentos_anticipo','obs_descuentos_anticipo','text');
		$this->setParametro('id_plan_pago_fk','id_plan_pago_fk','int4');
		$this->setParametro('id_obligacion_pago','id_obligacion_pago','int4');
		$this->setParametro('id_plantilla','id_plantilla','int4');
		$this->setParametro('descuento_anticipo','descuento_anticipo','numeric');
		$this->setParametro('otros_descuentos','otros_descuentos','numeric');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('obs_monto_no_pagado','obs_monto_no_pagado','text');
		$this->setParametro('obs_otros_descuentos','obs_otros_descuentos','text');
		$this->setParametro('monto','monto','numeric');
		$this->setParametro('nombre_pago','nombre_pago','varchar');
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('forma_pago','forma_pago','varchar');
		$this->setParametro('monto_no_pagado','monto_no_pagado','numeric');
		$this->setParametro('fecha_tentativa','fecha_tentativa','date');
		$this->setParametro('tipo_cambio','tipo_cambio','numeric');
		$this->setParametro('monto_retgar_mo','monto_retgar_mo','numeric');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarPlanPago(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.f_plan_pago_ime';
		$this->transaccion='TES_PLAPA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_plan_pago','id_plan_pago','int4');
		
		
		$this->setParametro('tipo_pago','tipo_pago','varchar');
		$this->setParametro('monto_ejecutar_total_mo','monto_ejecutar_total_mo','numeric');
		$this->setParametro('obs_descuentos_anticipo','obs_descuentos_anticipo','text');
		$this->setParametro('id_plan_pago_fk','id_plan_pago_fk','int4');
		$this->setParametro('id_obligacion_pago','id_obligacion_pago','int4');
		$this->setParametro('id_plantilla','id_plantilla','int4');
		$this->setParametro('descuento_anticipo','descuento_anticipo','numeric');
		$this->setParametro('otros_descuentos','otros_descuentos','numeric');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('obs_monto_no_pagado','obs_monto_no_pagado','text');
		$this->setParametro('obs_otros_descuentos','obs_otros_descuentos','text');
		$this->setParametro('monto','monto','numeric');
		$this->setParametro('id_comprobante','id_comprobante','int4');
		$this->setParametro('nombre_pago','nombre_pago','varchar');
		$this->setParametro('monto_no_pagado_mb','monto_no_pagado_mb','numeric');
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('forma_pago','forma_pago','varchar');
		$this->setParametro('monto_no_pagado','monto_no_pagado','numeric');
        $this->setParametro('fecha_tentativa','fecha_tentativa','date');
        $this->setParametro('tipo_cambio','tipo_cambio','numeric');
        $this->setParametro('monto_retgar_mo','monto_retgar_mo','numeric');
        
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarPlanPago(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='tes.f_plan_pago_ime';
		$this->transaccion='TES_PLAPA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_plan_pago','id_plan_pago','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function solicitarDevPag(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='tes.f_plan_pago_ime';
        $this->transaccion='TES_SOLDEVPAG_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_plan_pago','id_plan_pago','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    
    function sincronizarPresupuesto(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='tes.f_plan_pago_ime';
        $this->transaccion='TES_SINPRE_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_plan_pago','id_plan_pago','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
				
				function listarPlanesPagoPorObligacion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.f_plan_pago_sel';
		$this->transaccion='TES_PLAPAOB_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		$this->setParametro('id_obligacion_pago','id_obligacion_pago','int4');
		//Definicion de la lista del resultado del query
		$this->captura('id_plan_pago','int4');
		$this->captura('nro_cuota','numeric');
		$this->captura('monto_ejecutar_total_mb','numeric');
		$this->captura('nro_sol_pago','varchar');
		$this->captura('tipo_cambio','numeric');
		$this->captura('fecha_pag','date');
		$this->captura('fecha_dev','date');
		$this->captura('estado','varchar');
		$this->captura('tipo_pago','varchar');
		$this->captura('monto_ejecutar_total_mo','numeric');
		$this->captura('descuento_anticipo_mb','numeric');
		$this->captura('obs_descuentos_anticipo','text');
		$this->captura('id_plan_pago_fk','int4');
		$this->captura('descuento_anticipo','numeric');
		$this->captura('otros_descuentos','numeric');
		$this->captura('tipo','varchar');
		$this->captura('obs_monto_no_pagado','text');
		$this->captura('obs_otros_descuentos','text');
		$this->captura('monto','numeric');
		$this->captura('nombre_pago','varchar');
		$this->captura('monto_no_pagado_mb','numeric');
		$this->captura('monto_mb','numeric');
		$this->captura('otros_descuentos_mb','numeric');
		$this->captura('forma_pago','varchar');
		$this->captura('monto_no_pagado','numeric');
		$this->captura('fecha_tentativa','date');
		$this->captura('desc_plantilla','varchar');
		$this->captura('liquido_pagable','numeric');
		$this->captura('total_prorrateado','numeric');
		$this->captura('total_pagado','numeric');
  $this->captura('desc_cuenta_bancaria','text');
  $this->captura('sinc_presupuesto','varchar'); 
  $this->captura('monto_retgar_mb','numeric');
  $this->captura('monto_retgar_mo','numeric');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function reportePlanPago(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='tes.f_plan_pago_sel';
		$this->transaccion='TES_PLAPAREP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('id_plan_pago','id_plan_pago','int4');
		
		$this->captura('estado','varchar');
		$this->captura('numero_oc','varchar');
		$this->captura('proveedor','varchar');
		$this->captura('nro_cuota','numeric');
		$this->captura('fecha_devengado','date');
		$this->captura('fecha_pag','date');
		$this->captura('forma_pago','varchar');
		$this->captura('tipo_pago','varchar');
		$this->captura('modalidad','varchar');
		$this->captura('moneda','varchar');
		$this->captura('tipo_cambio','numeric');
		$this->captura('importe','numeric');
		$this->captura('monto_no_pagado','numeric');
		$this->captura('otros_descuentos','numeric');
		$this->captura('monto_ejecutado_total','numeric');
		$this->captura('liquido_pagable','numeric');
		$this->captura('total_pagado','numeric');
		$this->captura('fecha_reg','timestamp');
		
		$this->captura('nombre_uo','varchar');
		$this->captura('nombre_programa','varchar');
		$this->captura('nombre_regional','varchar');
		$this->captura('nombre_proyecto','varchar');
		$this->captura('nombre_financiador','varchar');
		$this->captura('nombre_actividad','varchar');
		$this->captura('nombre_partida','varchar');
		$this->captura('total_pago','numeric');
		//Ejecuta la respuesta
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;		
		
	}
}
?>