<?php
/**
 *@package pXP
 *@file    RepLibroBanco.php
 *@author  mp
 *@date    01-12-2014
 *@description Archivo con la interfaz para generación de reporte
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
	Phx.vista.RepLibroBanco = Ext.extend(Phx.frmInterfaz, {
	Atributos : [
		{
			config:{
				name:'id_cuenta_bancaria',
				fieldLabel:'Cuenta Bancaria',
				allowBlank:true,
				emptyText:'Cuenta Bancaria...',
				store: new Ext.data.JsonStore({
					url: '../../sis_tesoreria/control/CuentaBancaria/listarCuentaBancariaUsuario',
					id: 'id_cuenta_bancaria',
					root: 'datos',
					sortInfo:{
						field: 'nro_cuenta',
					direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_cuenta_bancaria','nro_cuenta','denominacion','centro', 'nombre_institucion'],
					remoteSort: true,
					baseParams:{par_filtro:'nro_cuenta#denominacion#centro', permiso:'libro_bancos'}
				}),
				valueField: 'id_cuenta_bancaria',
				displayField: 'nro_cuenta',
				tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{nro_cuenta}</b></p><p>{denominacion}</p></div></tpl>',
				hiddenName: 'id_cuenta_bancaria',
				forceSelection:true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender:true,
				mode:'remote',
				pageSize:10,
				queryDelay:1000,
				listWidth:600,
				resizable:true,
				anchor:'100%'
			},
			type:'ComboBox',
			id_grupo:0,
			filters:
			{
				pfiltro:'nro_cuenta#denominacion',
				type:'string'
			},
			grid:true,
			form:true
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
	ActSave : '../../sis_tesoreria/control/TsLibroBancos/repLibroBanco',
	timeout : 1500000,
	
	topBar : true,
	botones : false,
	labelSubmit : 'Imprimir',
	
	constructor : function(config) {
		Phx.vista.RepLibroBanco.superclass.constructor.call(this, config);
		this.init();			
		this.iniciarEventos();
	},
	
	iniciarEventos:function(){        
		this.cmpFechaIni = this.getComponente('fecha_ini');			
		this.cmpFechaFin = this.getComponente('fecha_fin');
		this.cmpIdCuentaBancaria = this.getComponente('id_cuenta_bancaria');
	},	
	onSubmit:function(o){			
		var idcuentaBancaria = this.cmpIdCuentaBancaria.getValue();
		var ini = this.cmpFechaIni.getValue().format('d-m-Y');			
		var fin = this.cmpFechaFin.getValue().format('d-m-Y');			
		
		Phx.CP.loadingShow();		
		Ext.Ajax.request({
			url:'../../sis_tesoreria/control/TsLibroBancos/repLibroBanco',
			params:
			{	
				'id_cuenta_bancaria' : idcuentaBancaria,
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