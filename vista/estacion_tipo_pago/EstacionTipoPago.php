<?php
/**
*@package pXP
*@file gen-EstacionTipoPago.php
*@author  (admin)
*@date 25-08-2015 15:36:37
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.EstacionTipoPago=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.EstacionTipoPago.superclass.constructor.call(this,config);
		this.init();
		
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_estacion_tipo_pago'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_estacion'
			},
			type:'Field',
			form:true 
		},
		
		
		{
			config: {
				name: 'id_tipo_plan_pago',
				fieldLabel: 'Tipo de Pago',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_tesoreria/control/TipoPlanPago/listarTipoPlanPago',
					id: 'id_tipo_plan_pago',
					root: 'datos',
					sortInfo: {
						field: 'descripcion',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_tipo_plan_pago', 'descripcion'],
					remoteSort: true,
					baseParams: {par_filtro: 'tpp.descripcion'}
				}),
				valueField: 'id_tipo_plan_pago',
				displayField: 'descripcion',
				gdisplayField: 'desc_tipo_pago',
				hiddenName: 'id_tipo_plan_pago',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 200,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_tipo_pago']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'tpp.descripcion',type: 'string'},
			grid: true,
			form: true
		},
		{
			config:{
				name: 'codigo_plantilla_comprobante',
				fieldLabel: 'Código Plantilla Comprobante',
				allowBlank: false,
				anchor: '80%',
				gwidth: 180,
				maxLength:50
			},
				type:'TextField',
				filters:{pfiltro:'etp.codigo_plantilla_comprobante',type:'string'},
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
				filters:{pfiltro:'etp.estado_reg',type:'string'},
				id_grupo:1,
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
				filters:{pfiltro:'etp.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'etp.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'etp.usuario_ai',type:'string'},
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
				filters:{pfiltro:'etp.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Estación Tipo Pago',
	ActSave:'../../sis_tesoreria/control/EstacionTipoPago/insertarEstacionTipoPago',
	ActDel:'../../sis_tesoreria/control/EstacionTipoPago/eliminarEstacionTipoPago',
	ActList:'../../sis_tesoreria/control/EstacionTipoPago/listarEstacionTipoPago',
	id_store:'id_estacion_tipo_pago',
	fields: [
		{name:'id_estacion_tipo_pago', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'desc_tipo_pago', type: 'string'},
		{name:'id_estacion', type: 'numeric'},
		{name:'id_tipo_plan_pago', type: 'numeric'},
		{name:'id_tipo_plan_pago', type: 'numeric'},
		{name:'codigo_plantilla_comprobante', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_estacion_tipo_pago',
		direction: 'ASC'
	},
	onReloadPage:function(m){       
		this.maestro=m;
		this.store.baseParams.id_estacion = this.maestro.id_estacion;
		this.load({params:{start:0, limit:this.tam_pag}});

	},
	loadValoresIniciales:function()
    {
        this.Cmp.id_estacion.setValue(this.maestro.id_estacion); 
               
        Phx.vista.EstacionTipoPago.superclass.loadValoresIniciales.call(this);
    },
	bdel:true,
	bsave:true
	}
)
</script>
		
		