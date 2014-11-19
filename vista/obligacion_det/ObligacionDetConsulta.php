<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (rarteaga)
*@date 17-11-2014 10:22:05
*@description Archivo con la interfaz de usuario que permite 
*dar el visto a solicitudes de compra
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ObligacionDetConsulta = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
	require:'../../../sis_tesoreria/vista/obligacion_det/ObligacionDet.php',
	requireclase:'Phx.vista.ObligacionDet',
	title:'Cambio de Apropiación',
	nombreVista: 'ObligacionDetConsulta',
	/*
	 *  Interface heredada para el sistema de adquisiciones para que el reposnable 
	 *  de adqusiciones registro los planes de pago , y ase por los pasos configurados en el WF
	 *  de validacion, aprobacion y registro contable
	 * */
	
	constructor: function(config) {
	   	this.maestro=config.maestro; 
	   	Phx.vista.ObligacionDetConsulta.superclass.constructor.call(this, config);
	    this.init();    	    
    },
    
    preparaMenu:function(n){
         
         Phx.vista.ObligacionDet.superclass.preparaMenu.call(this,n); 
          this.getBoton('btnProrrateo').disable();
         
    },
     
     liberaMenu: function() {
         Phx.vista.ObligacionDet.superclass.liberaMenu.call(this); 
         this.getBoton('btnProrrateo').disable();
         
         
    },
     
     
     onReloadPage:function(m){       
        this.maestro=m;          
        this.store.baseParams={id_obligacion_pago: this.maestro.id_obligacion_pago};
        this.load({params:{start:0, limit:50}});
    }
    
    
};
</script>
