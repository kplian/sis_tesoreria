<?php
/**
 *@package pXP
 *@file    RepMensualFechas.php
 *@author  mp
 *@date    01-12-2014
 *@description Archivo con la interfaz para generación de reporte
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
	Phx.vista.RepMensualFechas = Ext.extend(Phx.frmInterfaz, {
	Atributos : [
		{
			config: {
				name: 'id_caja',
				fieldLabel: 'Caja',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_tesoreria/control/Caja/listarCajas',
					id: 'id_caja',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_caja', 'tipo','codigo'],
					remoteSort: true,				
				}),
				valueField: 'id_caja',
				displayField: 'codigo',
				gdisplayField: 'codigo',
				hiddenName: 'id_caja',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 50,
				listWidth:400,
				resizable:true,
				minChars: 2				
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'caja.codigo',type: 'string'},
			grid: true,
			form: true
		},
		{
			config:{
				name: 'fecha_ini',
				fieldLabel: 'Fecha Inicio',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'fecha_ini',type:'date'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'fecha_fin',
				fieldLabel: 'Fecha Fin',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'fecha_fin',type:'date'},
			id_grupo:1,
			grid:true,
			form:true
		}
	],
	ActSave : '../../sis_tesoreria/control/Caja/repMensualFechas',
	timeout : 1500000,
	
	topBar : true,
	botones : false,
	labelSubmit : 'Imprimir',
	
	constructor : function(config) {
		Phx.vista.RepMensualFechas.superclass.constructor.call(this, config);
		this.init();			
		this.iniciarEventos();
	},
	
	iniciarEventos:function(){        
		this.cmpFechaIni = this.getComponente('fecha_ini');			
		this.cmpFechaFin = this.getComponente('fecha_fin');
		this.cmpIdCaja = this.getComponente('id_caja');
	},	
	onSubmit:function(o){			
		var idcaja = this.cmpIdCaja.getValue();
		var ini = this.cmpFechaIni.getValue().format('d-m-Y');			
		var fin = this.cmpFechaFin.getValue().format('d-m-Y');			
		
		Phx.CP.loadingShow();		
		Ext.Ajax.request({
			url:'../../sis_tesoreria/control/Caja/repMensualFechas',
			params:
			{	
				'id_caja' : idcaja,
				'fecha_ini' : ini,
				'fecha_fin' : fin
			},
			success: this.successExport,		
			failure: this.conexionFailure,
			timeout:this.timeout,
			scope:this
		});			
	},
	tipo : 'reporte',
	clsSubmit : 'bprint',
	Grupos : [{
		layout : 'column',
		items : [{
			xtype : 'fieldset',
			layout : 'form',
			border : true,
			title : 'Generar Reporte',
			bodyStyle : 'padding:0 15px 0;',
			columnWidth : '500px',
			items : [],
			id_grupo : 0,
			collapsible : true
		}]
	}]
})
</script>