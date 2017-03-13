<?php
/**
*@package pXP
*@file ProcesoCajaVbConta.php
*@author  Gonzalo Sarmiento Sejas
*@date 24-12-2015
*@description Archivo con la interfaz de usuario que permite
*dar el visto a Rendiciones y Reposiciones en Contabilidad
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ProcesoCajaVbConta = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
	require:'../../../sis_tesoreria/vista/proceso_caja/ProcesoCajaVbPresup.php',
	requireclase:'Phx.vista.ProcesoCajaVbPresup',
	title:'Visto Bueno Rendiciones Caja Contabilidad',
	nombreVista: 'ProcesoCajaVbConta',
	/*
	 *  Interface heredada en el sistema de tesoreria para que el responsable
	 *  de rendiciones apruebe las rendiciones , y pase por los pasos configurados en el WF
	 *  de validacion, aprobacion
	 * */
	 
	gruposBarraTareas:[{name:'no_contabilizados',title:'<H1 align="center"><i class="fa fa-thumbs-o-down"></i> No Contabilizados</h1>',grupo:0,height:0},
                       {name:'contabilizados',title:'<H1 align="center"><i class="fa fa-thumbs-o-up"></i> Contabilizados</h1>',grupo:1,height:0}],
	
	actualizarSegunTab: function(name, indice){
		
    	if(this.finCons){
    		 this.store.baseParams.pes_estado = name;
    	     this.load({params:{start:0, limit:this.tam_pag, tipo_interfaz: this.nombreVista}});
    	   }
    },

	bactGroups:  [0,1],
	
	constructor: function(config) {

	   this.finCons = true;

	   Phx.vista.ProcesoCajaVbConta.superclass.constructor.call(this,config);
		/*
		this.addButton('consolidado_rendicion',
				{	text:'Reporte Rendicion',
					iconCls: 'blist',
					disabled:false,
					grupo:[0,1],
					handler:this.consolidado_rendicion,
					tooltip: '<b>Consolidado Rendicion</b><p>Consolidado por Rendicion</p>'
				}
		);

		this.addButton('chkpresupuesto',
				{	text:'Chk Presupuesto',
					iconCls: 'blist',
					disabled:false,
					grupo:[0,1],
					handler:this.checkPresupuesto,
					tooltip: '<b>Revisar Presupuesto</b><p>Revisar estado de ejecución presupeustaria para el tramite</p>'
				}
		);*/
    },
	
	preparaMenu:function(){
	   var data = this.getSelectedData();
	   Phx.vista.ProcesoCajaVbConta.superclass.preparaMenu.call(this);
		if(data['tipo']=='CIERRE'){
			  //habilitar pestaña depositos
			  this.enableTabDepositos();
		  }else{
			  //deshabilitar pestaña depositos
			  this.disableTabDepositos();
		  }		
	},

	sigEstado:function() {
		var rec = this.sm.getSelected();
		var configExtra = [];

		if (rec.data.tipo == 'SOLREP' || rec.data.tipo == 'REPO') {
			if (rec.data.estado == 'vbconta' || rec.data.estado == 'revision' || rec.data.estado == 'vbfondos') {
				configExtra = [
					{
						config: {
							name: 'id_cuenta_bancaria',
							fieldLabel: 'Cuenta Bancaria',
							allowBlank: false,
							emptyText: 'Elija una Cuenta...',
							store: new Ext.data.JsonStore(
									{
										url: '../../sis_tesoreria/control/CuentaBancaria/listarCuentaBancariaUsuario',
										id: 'id_cuenta_bancaria',
										root: 'datos',
										sortInfo: {
											field: 'id_cuenta_bancaria',
											direction: 'ASC'
										},
										totalProperty: 'total',
										fields: ['id_cuenta_bancaria', 'nro_cuenta', 'nombre_institucion', 'codigo_moneda', 'centro', 'denominacion'],
										remoteSort: true,
										baseParams: {
											par_filtro: 'nro_cuenta',
											id_depto_lb: rec.data.id_depto_lb,
											permiso: 'todos'
										}
									}),
							tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>{nro_cuenta}</b></p><p>Moneda: {codigo_moneda}, {nombre_institucion}</p><p>{denominacion}, Centro: {centro}</p></div></tpl>',
							valueField: 'id_cuenta_bancaria',
							hiddenValue: 'id_cuenta_bancaria',
							displayField: 'nro_cuenta',
							gdisplayField: 'desc_cuenta_bancaria',
							listWidth: '280',
							forceSelection: true,
							typeAhead: false,
							triggerAction: 'all',
							lazyRender: true,
							mode: 'remote',
							pageSize: 20,
							queryDelay: 500,
							gwidth: 550,
							anchor: '80%',
							minChars: 2,
							renderer: function (value, p, record) {
								return String.format('{0}', record.data['desc_cuenta_bancaria']);
							}
						},
						type: 'ComboBox',
						filters: {pfiltro: 'cb.nro_cuenta', type: 'string'},
						id_grupo: 1,
						grid: true,
						form: true
					},
					{
						config: {
							name: 'id_cuenta_bancaria_mov',
							fieldLabel: 'Fondo',
							allowBlank: true,
							emptyText: 'Fondo...',
							store: new Ext.data.JsonStore({
								url: '../../sis_tesoreria/control/TsLibroBancos/listarTsLibroBancosDepositosConSaldo',
								id: 'id_cuenta_bancaria_mov',
								root: 'datos',
								sortInfo: {
									field: 'fecha',
									direction: 'DESC'
								},
								totalProperty: 'total',
								fields: ['id_libro_bancos', 'id_cuenta_bancaria', 'fecha', 'detalle', 'observaciones', 'importe_deposito', 'saldo'],
								remoteSort: true,
								baseParams: {par_filtro: 'detalle#observaciones#fecha'}
							}),
							valueField: 'id_libro_bancos',
							displayField: 'importe_deposito',
							gdisplayField: 'desc_deposito',
							hiddenName: 'id_cuenta_bancaria_mov',
							forceSelection: true,
							typeAhead: false,
							triggerAction: 'all',
							listWidth: 350,
							lazyRender: true,
							mode: 'remote',
							pageSize: 10,
							queryDelay: 1000,
							anchor: '80%',
							gwidth: 200,
							minChars: 2,
							tpl: '<tpl for="."><div class="x-combo-list-item"><p>{detalle}</p><p>Fecha:<strong>{fecha}</strong></p><p>Importe:<strong>{importe_deposito}</strong></p><p>Saldo:<strong>{saldo}</strong></p></div></tpl>',
							renderer: function (value, p, record) {
								return String.format('{0}', record.data['desc_deposito']);
							}
						},
						type: 'ComboBox',
						filters: {pfiltro: 'cbanmo.detalle#cbanmo.nro_doc_tipo', type: 'string'},
						id_grupo: 1,
						grid: true,
						form: true
					}];

				this.eventosExtra = function (obj) {
					//Evento para filtrar los depósitos a partir de la cuenta bancaria
					obj.Cmp.id_cuenta_bancaria.on('select', function (data, rec, ind) {
						//si es de una regional nacional
						this.Cmp.id_cuenta_bancaria_mov.reset();
						this.Cmp.id_cuenta_bancaria_mov.modificado = true;
						Ext.apply(this.Cmp.id_cuenta_bancaria_mov.store.baseParams, {id_cuenta_bancaria: rec.id});
					}, obj);

				};
			}
		}
	},

	checkPresupuesto:function(){
		var rec=this.sm.getSelected();
		var configExtra = [];
		this.objChkPres = Phx.CP.loadWindows('../../../sis_presupuestos/vista/presup_partida/ChkPresupuesto.php',
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
