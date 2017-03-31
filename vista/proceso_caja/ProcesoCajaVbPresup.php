<?php
/**
*@package pXP
*@file ProcesoCajaVbPresup.php
*@author  Gonzalo Sarmiento Sejas
*@date 24-12-2015
*@description Archivo con la interfaz de usuario que permite
*dar el visto a Rendiciones y Reposiciones en Presupuestos
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ProcesoCajaVbPresup = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
	require:'../../../sis_tesoreria/vista/proceso_caja/ProcesoCajaVb.php',
	requireclase:'Phx.vista.ProcesoCajaVb',
	title:'Visto Bueno Rendiciones Caja Presupuestos',
	nombreVista: 'ProcesoCajaVbPresup',
	/*
	 *  Interface heredada en el sistema de tesoreria para que el responsable
	 *  de rendiciones apruebe las rendiciones , y pase por los pasos configurados en el WF
	 *  de validacion, aprobacion
	 * */

	constructor: function(config) {

	   Phx.vista.ProcesoCajaVbPresup.superclass.constructor.call(this,config);

		this.addButton('consolidado_rendicion',
				{	text:'Reporte Rendicion',
					iconCls: 'blist',
					disabled:true,
					grupo:[0,1],
					handler:this.consolidado_rendicion,
					tooltip: '<b>Consolidado Rendicion</b><p>Consolidado por Rendicion</p>'
				}
		);

		this.addButton('chkpresupuesto',
				{	text:'Chk Presupuesto',
					iconCls: 'blist',
					disabled:true,
					grupo:[0,1],
					handler:this.checkPresupuesto,
					tooltip: '<b>Revisar Presupuesto</b><p>Revisar estado de ejecución presupeustaria para el tramite</p>'
				}
		);

		if(typeof this.finCons == 'undefined')
		this.load({params:{start:0, limit:this.tam_pag}})
    },
	
	preparaMenu:function(){
	  
	   Phx.vista.ProcesoCajaVbPresup.superclass.preparaMenu.call(this);
		var data = this.getSelectedData();

		this.getBoton('consolidado_rendicion').enable();
		this.getBoton('chkpresupuesto').enable();

		if(data['tipo']=='SOLREN'){
			//this.getBoton('consolidado_reposicion').disable();
		}else if(data['tipo']=='SOLREP'){
			//this.getBoton('consolidado_reposicion').enable();
		}else{
			//this.getBoton('consolidado_reposicion').disable();
		}
	   //this.getBoton('relacionar_deposito').disable();

     },

	consolidado_rendicion : function() {
		var rec = this.getSelectedData();
		var NumSelect=this.sm.getCount();

		if(NumSelect != 0)
		{
			var data ='id_proceso_caja='+ rec.id_proceso_caja;
			data += '&nro_tramite=' + rec.nro_tramite;
			data += '&reporte=rendicion';
			
			//window.open('http://localhost:14659/Home/ReporteConsolidadoRendicionesCajaChica?'+data);
			window.open('http://sms.obairlines.bo/ReportesPXP2/Home/ReporteConsolidadoRendicionesCajaChica?'+data);
		}
		else
		{
			Ext.MessageBox.alert('Alerta', 'Antes debe seleccionar un item.');
		}
	},

	checkPresupuesto:function(){
		var rec=this.sm.getSelected();
		var configExtra = [];
		this.objChkPres = Phx.CP.loadWindows('../../../sis_presupuestos/vista/presup_partida/ChkPresupuestoRendicion.php',
				'Estado del Presupuesto',
				{
					modal:true,
					width:700,
					height:450
				}, {
					data:{
						nro_tramite: rec.data.nro_tramite
					}}, this.idContenedor,'ChkPresupuesto',
				{
					config:[{
						event:'onclose',
						delegate: this.onCloseChk
					}],

					scope:this
				});

	}
};
</script>
