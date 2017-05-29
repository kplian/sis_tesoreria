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
Phx.vista.CajaDeposito = {
    
	require:'../../../sis_tesoreria/vista/deposito/Deposito.php',
	requireclase:'Phx.vista.Deposito',
	title:'Depositos',
	nombreVista: 'CajaDeposito',
	
	tablaOrigen: 'tes.tproceso_caja',
	idOrigen: 'id_proceso_caja',
	tipo_interfaz : 'caja_chica',
	
	constructor: function(config) {
	   	Phx.vista.CajaDeposito.superclass.constructor.call(this,config);
	  	this.init();
	    this.grid.getBottomToolbar().disable();
		var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
		if(dataPadre){
			 this.onEnablePanel(this, dataPadre);
		}
		else{
			 this.bloquearMenus();
		  }
        
   },
   
    liberaMenu:function(){
        var tb = Phx.vista.CajaDeposito.superclass.liberaMenu.call(this);
		if(this.maestro.estado ==  'pendiente'){
			this.getBoton('relacionar_deposito').disable();
			this.getBoton('quitar_relacion_deposito').disable();
			this.getBoton('corregir_importe_contable').disable();
		 } 
		 else{
			this.getBoton('relacionar_deposito').enable();
			//this.getBoton('quitar_relacion_deposito').enable();
			//this.getBoton('corregir_importe_contable').enable();
		 }
		 
       return tb
    }
};
</script>

