<?php
/**
*@package pXP
*@file CajaVB.php
*@author  gsarmiento
*@date 03-12-2015
*@description Archivo con la interfaz de usuario que permite 
*dar el visto a solicitudes de apertura, rendicion de caja chica
*
*/
header("content-type: text/javascript; charset=UTF-8"); 
?>
<script>
Phx.vista.CajaCajero = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
    require:'../../../sis_tesoreria/vista/caja/Caja.php',
    requireclase:'Phx.vista.Caja',
    title:'Caja',
    nombreVista: 'cajaCajero',
    
    constructor: function(config) {
      
       Phx.vista.CajaCajero.superclass.constructor.call(this,config);
       
	   this.iniciarEventos(); 
	   
	   this.addButton('btnRendicion', {
			text : 'Rendicion Caja',
			iconCls : 'bballot',
			disabled : false,
			handler : this.onBtnRendicion,
			tooltip : '<b>Rendicion</b>'
	   });
		
       this.store.baseParams={tipo_interfaz:this.nombreVista};
       if(config.filtro_directo){
           this.store.baseParams.filtro_valor = config.filtro_directo.valor;
           this.store.baseParams.filtro_campo = config.filtro_directo.campo;
       }
       
       this.load({params:{
           start:0, 
           limit:this.tam_pag
        }});
       
    },
	
	
	onBtnRendicion : function() {
		var rec = this.sm.getSelected();
		console.log(rec.data);
		Phx.CP.loadWindows('../../../sis_tesoreria/vista/proceso_caja/ProcesoCaja.php', 'Rendicion Caja', {
			modal : true,
			width : '95%',
			height : '95%',
		}, rec.data, this.idContenedor, 'ProcesoCaja');
	},
	
	preparaMenu:function(n){
         var data = this.getSelectedData();
         		 
		 if(data.estado == 'abierto'){  
		    this.getBoton('btnRendicion').enable();
         }
		 else{
			 this.getBoton('btnRendicion').disable();
		 }
     },
    
};
</script>
