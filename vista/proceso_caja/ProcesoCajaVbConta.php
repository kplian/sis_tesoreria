<?php
/**
*@package pXP
*@file ProcesoCajaVbConta.php
*@author  Gonzalo Sarmiento Sejas
*@date 24-12-2015
*@description Archivo con la interfaz de usuario que permite
*dar el visto a Rendiciones y Reposiciones en Contabilidad
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ProcesoCajaVbConta = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
	require:'../../../sis_tesoreria/vista/proceso_caja/ProcesoCajaVb.php',
	requireclase:'Phx.vista.ProcesoCajaVb',
	title:'Visto Bueno Rendiciones Caja Contabilidad',
	nombreVista: 'ProcesoCajaVbConta',
	/*
	 *  Interface heredada en el sistema de tesoreria para que el responsable
	 *  de rendiciones apruebe las rendiciones , y pase por los pasos configurados en el WF
	 *  de validacion, aprobacion
	 * */

	constructor: function(config) {

	   Phx.vista.ProcesoCajaVbConta.superclass.constructor.call(this,config);	   

    }
};
</script>
