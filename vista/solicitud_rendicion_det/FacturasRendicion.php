<?php
/**
*@package pXP
*@file AprobacionFacturas.php
*@author  (gsarmiento)
*@date 15-02-2016 15:14:01
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.AprobacionFacturas=Ext.extend(Phx.gridInterfaz,{
	nombre_vista: 'facturas_rendicion',
	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		
		Phx.vista.AprobacionFacturas.superclass.constructor.call(this,config);
		this.init();
		//recargar valores segunda pestaña
		var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()			  
			  if(dataPadre){
				 this.onEnablePanel(this, dataPadre);
			  }
			  else
			  {
				 this.bloquearMenus();
			  }
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_solicitud_rendicion_det'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_solicitud_efectivo'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'desc_plantilla',
				fieldLabel: 'Tipo Documento',
				allowBlank: false,
				anchor: '80%',
				gwidth: 150,
				maxLength:100
			},
				type:'TextField',
				filters:{pfiltro:'pla.desc_plantilla',type:'string'},
				bottom_filter: true,
				id_grupo:0,
				grid:true,
				form:false
		},		
		{
			config:{
				name: 'fecha',
				fieldLabel: 'Fecha',
				allowBlank: false,
				anchor: '80%',
				gwidth: 80,
				format: 'd/m/Y',
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'dc.fecha',type:'date'},
				id_grupo:0,
				grid:true,
				form:false
		},
		{
			config: {
				name: 'id_doc_compra_venta',
				fieldLabel: 'Razon Social',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_/control/Clase/Metodo',
					id: 'id_',
					root: 'datos',
					sortInfo: {
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_', 'nombre', 'codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'movtip.nombre#movtip.codigo'}
				}),
				valueField: 'id_',
				displayField: 'nombre',
				gdisplayField: 'desc_',
				hiddenName: 'id_doc_compra_venta',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 150,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['razon_social']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'dc.razon_social',type: 'string'},
			grid: true,
			form: true
		},		
		{
			config:{
				name: 'nit',
				fieldLabel: 'Nit',
				allowBlank: false,
				anchor: '80%',
				gwidth: 80,
				maxLength:100
			},
				type:'TextField',
				filters:{pfiltro:'dc.nit',type:'string'},
				bottom_filter: true,
				id_grupo:0,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'nro_documento',
				fieldLabel: 'Nro Factura',
				allowBlank: false,
				anchor: '80%',
				gwidth: 80,
				maxLength:100
			},
				type:'TextField',
				filters:{pfiltro:'dc.nro_documento',type:'string'},
				bottom_filter: true,
				id_grupo:0,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'nro_autorizacion',
				fieldLabel: 'Nro Autorizacion',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
				type:'TextField',
				filters:{pfiltro:'dc.nro_autorizacion',type:'string'},
				bottom_filter: true,
				id_grupo:0,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'importe_doc',
				fieldLabel: 'Importe Total',
				allowBlank: true,
				anchor: '80%',
				gwidth: 80,
				maxLength:1179650,				
				renderer:function (value,p,record){
					return  String.format('{0}', value);
				}
			},
			type:'NumberField',
			id_grupo:0,
			grid:true,
			form:true
		},		
		{
			config:{
				name: 'importe_descuento',
				fieldLabel: 'Descuento',
				allowBlank: true,
				anchor: '80%',
				gwidth: 80,
				maxLength:1179650,				
				renderer:function (value,p,record){
					return  String.format('{0}', value);
				}
			},
			type:'NumberField',
			id_grupo:0,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'importe_descuento_ley',
				fieldLabel: 'Descuento Ley',
				allowBlank: true,
				anchor: '80%',
				gwidth: 90,
				maxLength:1179650,				
				renderer:function (value,p,record){
					return  String.format('{0}', value);
				}
			},
			type:'NumberField',
			id_grupo:0,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'importe_excento',
				fieldLabel: 'Excento',
				allowBlank: true,
				anchor: '80%',
				gwidth: 70,
				maxLength:1179650,				
				renderer:function (value,p,record){
					return  String.format('{0}', value);
				}
			},
			type:'NumberField',
			id_grupo:0,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'monto',
				fieldLabel: 'Liquido Pagable',
				allowBlank: true,
				anchor: '80%',
				gwidth: 80,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'rend.monto',type:'numeric'},
				id_grupo:0,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'estado_reg',
				fieldLabel: 'Estado Reg.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
				type:'TextField',
				filters:{pfiltro:'rend.estado_reg',type:'string'},
				id_grupo:0,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'usr_reg',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'usu1.cuenta',type:'string'},
				id_grupo:0,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'rend.fecha_reg',type:'date'},
				id_grupo:0,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'rend.usuario_ai',type:'string'},
				id_grupo:0,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'rend.id_usuario_ai',type:'numeric'},
				id_grupo:0,
				grid:false,
				form:false
		},
		{
			config:{
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'rend.fecha_mod',type:'date'},
				id_grupo:0,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'usr_mod',
				fieldLabel: 'Modificado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'usu2.cuenta',type:'string'},
				id_grupo:0,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Rendicion',
	ActList:'../../sis_tesoreria/control/SolicitudRendicionDet/listarSolicitudRendicionDet',
	id_store:'id_solicitud_rendicion_det',
	fields: [
		{name:'id_solicitud_rendicion_det', type: 'numeric'},
		{name:'id_proceso_caja', type: 'numeric'},
		{name:'id_solicitud_efectivo', type: 'numeric'},
		{name:'id_doc_compra_venta', type: 'numeric'},
		{name:'desc_plantilla', type: 'string'},
		{name:'desc_moneda', type: 'string'},
		{name:'tipo', type: 'string'},
		{name:'id_plantilla', type: 'numeric'},
		{name:'id_moneda', type: 'numeric'},
		{name:'fecha', type: 'date'},
		{name:'nit', type: 'string'},
		{name:'razon_social', type: 'string'},
		{name:'nro_autorizacion', type: 'string'},
		{name:'nro_documento', type: 'string'},
		{name:'nro_dui', type: 'string'},
		{name:'obs', type: 'string'},
		{name:'importe_doc', type: 'string'},
		{name:'importe_pago_liquido', type: 'string'},
		{name:'importe_iva', type: 'string'},
		{name:'importe_descuento', type: 'string'},
		{name:'importe_descuento_ley', type: 'string'},
		{name:'importe_excento', type: 'string'},
		{name:'importe_ice', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'monto', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'id_proceso_wf', type: 'numeric'},
		{name:'id_estado_wf', type: 'numeric'},
		{name:'id_depto', type:'numeric'}
	],
	sortInfo:{
		field: 'id_solicitud_rendicion_det',
		direction: 'ASC'
	},
			
	onReloadPage : function(m) {
		this.maestro = m;
		this.store.baseParams={id_solicitud_efectivo:this.maestro.id_solicitud_efectivo, interfaz:this.nombre_vista};
		this.load({params:{start:0, limit:this.tam_pag}});			
	},
	
	onReloadPadre : function(){
		Phx.CP.getPagina(this.idContenedorPadre).reload();
	},
	
	bdel:false,
	bsave:false,
	bnew:false,
	bedit:false
	}
)
</script>