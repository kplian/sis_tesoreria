<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (fprudencio)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite 
*dar el visto a solicitudes de compra
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ObligacionPagoApropiacion = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
	require:'../../../sis_tesoreria/vista/obligacion_pago/ObligacionPago.php',
	requireclase:'Phx.vista.ObligacionPago',
	title:'Cambio de Apropiación',
	nombreVista: 'ObligacionPagoApropiacion',
	/*
	 *  Interface heredada para el sistema de adquisiciones para que el reposnable 
	 *  de adqusiciones registro los planes de pago , y ase por los pasos configurados en el WF
	 *  de validacion, aprobacion y registro contable
	 * */
	
	constructor: function(config) {
	   	this.maestro=config.maestro; 
	   	Phx.vista.ObligacionPago.superclass.constructor.call(this,config);
	    this.init();
	    this.store.baseParams = {tipo_interfaz: this.nombreVista,
                   id_obligacion_pago: this.maestro.id_obligacion_pago}
		this.load({params:{start:0, limit:this.tam_pag}});
    },
    
       
    
     tabsouth:[
            { 
             url:'../../../sis_tesoreria/vista/obligacion_det/ObligacionDetApropiacion.php',
             title:'Detalle', 
             height:'50%',
             cls:'ObligacionDetApropiacion'
            } 
    
       ],
     preparaMenu : function (n) {
     	Phx.vista.ObligacionPago.superclass.preparaMenu.call(this,n); 
     },
     liberaMenu : function () {
     	var tb = Phx.vista.ObligacionPago.superclass.liberaMenu.call(this);
     }
     
    
    
};
</script>
