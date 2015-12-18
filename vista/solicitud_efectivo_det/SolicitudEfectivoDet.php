<?php
/**
*@package pXP
*@file gen-SolicitudEfectivoDet.php
*@author  (gsarmiento)
*@date 24-11-2015 14:14:27
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.SolicitudEfectivoDet=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.SolicitudEfectivoDet.superclass.constructor.call(this,config);
		this.init();		
		//this.load({params:{start:0, limit:this.tam_pag}})
	},
				
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_solicitud_efectivo_det'
			},
			type:'Field',
			form:true 
		},		
		{
			config: {
				name: 'id_solicitud_efectivo',
				fieldLabel: 'id_solicitud_efectivo',
				allowBlank: false,
				inputType:'hidden',
				hiddenName: 'id_solicitud_efectivo',
				gwidth: 150				
			},
			type: 'Field',
			id_grupo: 0,
			filters: {pfiltro: 'movtip.nombre',type: 'string'},
			grid: false,
			form: true
		},
		{
			config: {
				name: 'id_cc',
				fieldLabel: 'Centro de Costo',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_parametros/control/CentroCosto/listarCentroCostoFiltradoXDepto',
					id: 'id_centro_costo',
					root: 'datos',
					sortInfo: {
						field: 'codigo_cc',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_centro_costo', 'codigo_cc','desc_centro_costo'],
					remoteSort: true,
					baseParams: {par_filtro: 'cec.codigo_cc'}
				}),
				valueField: 'id_centro_costo',
				displayField: 'codigo_cc',
				gdisplayField: 'codigo_cc',
				hiddenName: 'id_cc',
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
					return String.format('{0}', record.data['codigo_cc']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'conig.desc_centro_costo',type: 'string'},
			grid: true,
			form: true
		},
		{
			config: {
				name: 'id_concepto_ingas',
				fieldLabel: 'Concepto de Gasto',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_parametros/control/ConceptoIngas/listarConceptoIngasMasPartida',
					id: 'id_concepto_ingas',
					root: 'datos',
					sortInfo: {
						field: 'desc_ingas',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_concepto_ingas', 'desc_partida', 'desc_ingas'],
					remoteSort: true,
					baseParams: {par_filtro: 'conig.desc_ingas'}
				}),
				valueField: 'id_concepto_ingas',
				displayField: 'desc_ingas',
				gdisplayField: 'desc_ingas',
				hiddenName: 'id_concepto_ingas',
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
					return String.format('{0}', record.data['desc_ingas']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'conig.desc_ingas',type: 'string'},
			grid: true,
			form: true
		},
		{
			config: {
				name: 'id_partida_ejecucion',
				fieldLabel: 'id_partida_ejecucion',
				allowBlank: false,
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
				hiddenName: 'id_partida_ejecucion',
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
					return String.format('{0}', record.data['desc_']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'movtip.nombre',type: 'string'},
			grid: false,
			form: false
		},		
		{
			config:{
				name: 'monto',
				fieldLabel: 'Monto',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'soldet.monto',type:'numeric'},
				id_grupo:1,
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
				filters:{pfiltro:'soldet.estado_reg',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: '',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'soldet.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				id_grupo:1,
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
				filters:{pfiltro:'soldet.usuario_ai',type:'string'},
				id_grupo:1,
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
				filters:{pfiltro:'soldet.fecha_reg',type:'date'},
				id_grupo:1,
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
				id_grupo:1,
				grid:true,
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
				filters:{pfiltro:'soldet.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Detalle',
	ActSave:'../../sis_tesoreria/control/SolicitudEfectivoDet/insertarSolicitudEfectivoDet',
	ActDel:'../../sis_tesoreria/control/SolicitudEfectivoDet/eliminarSolicitudEfectivoDet',
	ActList:'../../sis_tesoreria/control/SolicitudEfectivoDet/listarSolicitudEfectivoDet',
	id_store:'id_solicitud_efectivo_det',
	fields: [
		{name:'id_solicitud_efectivo_det', type: 'numeric'},
		{name:'id_solicitud_efectivo', type: 'numeric'},
		{name:'id_cc', type: 'numeric'},
		{name:'codigo_cc', type: 'string'},
		{name:'id_concepto_ingas', type: 'numeric'},
		{name:'desc_ingas', type: 'string'},
		{name:'id_partida_ejecucion', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'monto', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_solicitud_efectivo_det',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	onReloadPage : function(m) {
		this.maestro = m;
		this.Atributos[1].valorInicial = this.maestro.id_solicitud_efectivo;
		this.Atributos[2].config.store.baseParams.id_depto = this.maestro.id_depto;
		this.store.baseParams = { id_solicitud_efectivo : this.maestro.id_solicitud_efectivo };
		this.load({	params : {start : 0, limit : 50}})
	}
	}
)
</script>
		
		