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
Phx.vista.ObligacionDetApropiacion = {
    bedit:true,
    bnew:false,
    bsave:false,
    bdel:false,
	require:'../../../sis_tesoreria/vista/obligacion_det/ObligacionDet.php',
	requireclase:'Phx.vista.ObligacionDet',
	title:'Cambio de Apropiación',
	nombreVista: 'ObligacionDetApropiacion',
	/*
	 *  Interface heredada para el sistema de adquisiciones para que el reposnable 
	 *  de adqusiciones registro los planes de pago , y ase por los pasos configurados en el WF
	 *  de validacion, aprobacion y registro contable
	 * */
	
	constructor: function(config) {
	   	this.maestro=config.maestro; 
	   	Phx.vista.ObligacionDet.superclass.constructor.call(this,config);
	    this.init();
	    this.Cmp.monto_pago_mo.setDisabled(true);
	    this.Cmp.descripcion.setDisabled(true);
	    	    
    },
    
     ActSave:'../../sis_tesoreria/control/ObligacionDet/guardarObligacionDetApropiacion',  
    
     
     preparaMenu : function (n) {
     	
     	Phx.vista.ObligacionDet.superclass.preparaMenu.call(this,n); 
     },
     liberaMenu : function () {
     	var tb = Phx.vista.ObligacionDet.superclass.liberaMenu.call(this);
     },
     onReloadPage:function(m){       
        this.maestro=m;          
        this.store.baseParams={id_obligacion_pago:this.maestro.id_obligacion_pago};
        this.load({params:{start:0, limit:50}});
        this.Cmp.id_centro_costo.store.baseParams.id_gestion=this.maestro.id_gestion
        this.Cmp.id_centro_costo.store.baseParams.id_depto =this.maestro.id_depto;
        this.Cmp.id_centro_costo.modificado=true;
        
        this.Cmp.id_concepto_ingas.store.baseParams.id_gestion=this.maestro.id_gestion
        this.Cmp.id_concepto_ingas.modificado=true;
        
        this.Cmp.id_orden_trabajo.store.baseParams.fecha_solicitud = this.maestro.fecha.dateFormat('d/m/Y');
        this.Cmp.id_orden_trabajo.modificado = true;
       
    },
    onButtonEdit:function(){	    
	  Phx.vista.ObligacionDet.superclass.onButtonEdit.call(this);	
	}
     
    
    
};
</script>
