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

		this.addButton('consolidado_reposicion',
				{	text:'Reporte Reposicion',
					iconCls: 'blist',
					disabled:false,
					grupo:[0,1],
					handler:this.consolidado_reposicion,
					tooltip: '<b>Consolidado Reposicion</b><p>Consolidado por Reposicion</p>'
				}
		);

		if(config.filtro_directo){
			this.store.baseParams.filtro_valor = config.filtro_directo.valor;
			this.store.baseParams.filtro_campo = config.filtro_directo.campo;
		}
		
	   this.load({params:{start:0, limit:this.tam_pag}})
    },

	preparaMenu:function(){

		Phx.vista.ProcesoCajaVbFondos.superclass.preparaMenu.call(this);
		var data = this.getSelectedData();
		if(data['tipo']=='SOLREN'){
			this.getBoton('consolidado_reposicion').disable();
		}else if(data['tipo']=='SOLREP'){
			this.getBoton('consolidado_reposicion').enable();
		}else{
			this.getBoton('consolidado_reposicion').disable();
		}
		//this.getBoton('relacionar_deposito').disable();

	},

	consolidado_reposicion : function() {
		var rec = this.getSelectedData();
		var NumSelect=this.sm.getCount();

		if(NumSelect != 0)
		{
			var data ='id_proceso_caja='+ rec.id_proceso_caja;
			data += '&nro_tramite=' + rec.nro_tramite;
			//data += '&fecha_inicio=' + rec.fecha_inicio.format('d-m-Y');
			//data += '&fecha_fin=' + rec.fecha_fin.format('d-m-Y');
			data += '&reporte=reposicion';
			console.log(data);
			
			//window.open('http://localhost:14659/Home/ReporteConsolidadoRendicionesCajaChica?'+data);
			window.open('http://sms.obairlines.bo/ReportesPXP2/Home/ReporteConsolidadoRendicionesCajaChica?'+data);
		}
		else
		{
			Ext.MessageBox.alert('Alerta', 'Antes debe seleccionar un item.');
		}
	},
};
</script>
