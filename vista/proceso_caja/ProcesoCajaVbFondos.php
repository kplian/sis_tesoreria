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
	},

	consolidado_reposicion : function() {
		var data = this.getSelectedData();
		console.log('=>'+data);
		Phx.CP.loadingShow();
		Ext.Ajax.request({
			url:'../../sis_tesoreria/control/ProcesoCaja/VoBoRepoCajaRepo',
			params:{
				'id_proceso_caja':data.id_proceso_caja,
				'nro_tramite':data.nro_tramite,
				'fecha_inicio':data.fecha_inicio,
				'motivo':data.motivo,
				'tipo':data.tipo,
				'monto':data.monto				
			},
			success:this.successExport,
			failure: this.conexionFailure,
			timeout:this.timeout,
			scope:this
		});	
	}
};
</script>
