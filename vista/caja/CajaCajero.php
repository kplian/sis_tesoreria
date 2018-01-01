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
       
	   this.addButton('btnRendicion', {
			text : 'Procesos Caja',
			iconCls : 'bballot',
			disabled : true,
			handler : this.onBtnRendicion,
			tooltip : '<b>Procesos Caja</b>'
	   });
		
       this.store.baseParams={tipo_interfaz:this.nombreVista};
       if(config.filtro_directo){
           this.store.baseParams.filtro_valor = config.filtro_directo.valor;
           this.store.baseParams.filtro_campo = config.filtro_directo.campo;
       }
       this.iniciarEventos(); 
	   
       this.load({params:{
           start:0, 
           limit:this.tam_pag
        }});
       
    },
	
	
	onBtnRendicion : function() {
		var rec = this.sm.getSelected();
		Phx.CP.loadWindows('../../../sis_tesoreria/vista/proceso_caja/ProcesoCajaCajero.php', 'Proceso Caja', {
			modal : true,
			width : '95%',
			height : '95%',
		}, rec.data, this.idContenedor, 'ProcesoCajaCajero');
	},
	
	preparaMenu:function(n){
         var data = this.getSelectedData();
         		 
		 /*if(data.estado == 'abierto'){
             this.enableTabCajero();
         }
		 else{
             this.disableTabCajero();
		 }	*/

		this.getBoton('diagrama_gantt').enable();	 
		this.getBoton('btnRendicion').enable();
     },

    enableTabCajero:function(){
        if(this.TabPanelSouth.get(1) && this.TabPanelSouth.get(2)){
            this.TabPanelSouth.get(0).disable();
            this.TabPanelSouth.get(1).enable();
            this.TabPanelSouth.get(2).enable();
            this.TabPanelSouth.setActiveTab(2)
        }
    },

    disableTabCajero:function(){
        if(this.TabPanelSouth.get(1) && this.TabPanelSouth.get(2)){
            this.TabPanelSouth.get(0).enable();
            this.TabPanelSouth.get(1).disable();
            this.TabPanelSouth.get(2).disable();
            this.TabPanelSouth.setActiveTab(0)

        }
    },
    
};
</script>
