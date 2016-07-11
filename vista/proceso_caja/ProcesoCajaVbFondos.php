<?php
/**
*@package pXP
*@file ProcesoCajaVbFondos.php
*@author  Gonzalo Sarmiento Sejas
*@date 24-12-2015
*@description Archivo con la interfaz de usuario que permite
*dar el visto a solicitudes de compra
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ProcesoCajaVbFondos = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
	require:'../../../sis_tesoreria/vista/proceso_caja/ProcesoCajaVb.php',
	requireclase:'Phx.vista.ProcesoCajaVb',
	title:'Visto Bueno Rendiciones Caja Tesoreria',
	nombreVista: 'ProcesoCajaVbFondos',
	/*
	 *  Interface heredada en el sistema de tesoreria para que el responsable
	 *  de rendiciones apruebe las rendiciones , y pase por los pasos configurados en el WF
	 *  de validacion, aprobacion
	 * */

	constructor: function(config) {

	   Phx.vista.ProcesoCajaVbFondos.superclass.constructor.call(this,config);
	   this.load({params:{start:0, limit:this.tam_pag}})
    }
};
</script>
