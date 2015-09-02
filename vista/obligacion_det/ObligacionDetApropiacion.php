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
    bnew:true,
    bsave:false,
    bdel:true,
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
	    this.iniciarEventos();	    	    
    },
    
     ActSave:'../../sis_tesoreria/control/ObligacionDet/guardarObligacionDetApropiacion', 
     ActDel:'../../sis_tesoreria/control/ObligacionDet/eliminarObligacionDetApropiacion',  
    
     
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
	  Phx.vista.ObligacionDetApropiacion.superclass.onButtonEdit.call(this);
	  this.Cmp.id_concepto_ingas.store.load({params:{start:0,limit:this.tam_pag,id_concepto_ingas:this.Cmp.id_concepto_ingas.getValue()}, 
           callback : function (r) {
                if (r.length == 1 ) {                       
                    this.Cmp.id_concepto_ingas.setValue(r[0].data.id_concepto_ingas);
                    this.Cmp.id_orden_trabajo.store.baseParams = Ext.apply(this.Cmp.id_orden_trabajo.store.baseParams, {
			        		                                           filtro_ot:r[0].data.filtro_ot,
			        		 										   requiere_ot:r[0].data.requiere_ot,
			        		 										   id_grupo_ots:r[0].data.id_grupo_ots
			        		 										});
			        
			        this.Cmp.id_orden_trabajo.modificado = true;
			        this.Cmp.id_orden_trabajo.enable();
			        if(r[0].data.requiere_ot =='obligatorio'){
			        	this.Cmp.id_orden_trabajo.allowBlank = false;
			        }
			        else{
			        	this.Cmp.id_orden_trabajo.allowBlank = true;
			        }
                } 
                   
                                
            }, scope : this
        });	
	}
     
    
    
};
</script>
