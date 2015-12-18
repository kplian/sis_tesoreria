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
Phx.vista.SolicitudEfectivoDetVb = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
	require:'../../../sis_tesoreria/vista/solicitud_efectivo_det/SolicitudEfectivoDet.php',
	requireclase:'Phx.vista.SolicitudEfectivoDet',
	title:'Solicitud Efectivo Vb',
	nombreVista: 'SolicitudEfectivoDetVb',
	/*
	 *  Interface heredada para el sistema de adquisiciones para que el reposnable 
	 *  de adqusiciones registro los planes de pago , y ase por los pasos configurados en el WF
	 *  de validacion, aprobacion y registro contable
	 * */
	
	constructor: function(config) {
	      
	   Phx.vista.SolicitudEfectivoDetVb.superclass.constructor.call(this,config);
                 
    },
       
       
	
   preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;
          Phx.vista.SolicitudEfectivoDetVb.superclass.preparaMenu.call(this,n);         
	},
	
    liberaMenu:function(){
	  	
        var tb = Phx.vista.SolicitudEfectivoDetVb.superclass.liberaMenu.call(this);      
	    
       return tb
   },	
};
</script>
