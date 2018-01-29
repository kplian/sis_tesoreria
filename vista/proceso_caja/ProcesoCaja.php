<?php
/**
*@package pXP
*@file gen-ProcesoCaja.php
*@author  (gsarmiento)
*@date 21-12-2015 20:15:22
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ProcesoCaja=Ext.extend(Phx.gridInterfaz,{
	
	nombreVista: 'ProcesoCaja',

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre    	
		Phx.vista.ProcesoCaja.superclass.constructor.call(this,config);
		this.init();
		this.crearFormAuto();
		this.addButton('diagrama_gantt',
            {
                text:'Gant',
                iconCls: 'bgantt',
                disabled:false,
                handler: this.diagramGantt,
                tooltip: '<b>Diagrama Gantt de Solicitud de Efectivo</b>'
            }
        );
 
		this.addButton('agregarmonto',{ 
			text: 'Agregar monto', 
			iconCls: 'blist', 
			disabled: false, 
			handler: this.agregarmonto, 
			tooltip: '<b>Agregar monto</b>'
		});
	},

	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_proceso_caja'
			},
			type:'Field',
			form:true
		},
		{
			config: {
				name: 'id_comprobante_diario',
				fieldLabel: 'id_comprobante_diario',
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
				hiddenName: 'id_comprobante_diario',
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
				name: 'nro_tramite',
				fieldLabel: 'Nro Tramite',
				allowBlank: false,
				anchor: '80%',
				gwidth: 180,
				maxLength:50
			},
				type:'TextField',
				filters:{pfiltro:'ren.nro_tramite',type:'string'},
				bottom_filter: true,
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'fecha_inicio',
				fieldLabel: 'Fecha Ini Rend.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y',
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'ren.fecha_inicio',type:'date'},
				id_grupo:1,
				grid:false,
				form:false
		},
		{
			config:{
				name: 'fecha_fin',
				fieldLabel: 'Fecha Fin Rend.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y',
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'ren.fecha_fin',type:'date'},
				id_grupo:1,
				grid:false,
				form:false
		},
		{
			config:{
				name:'tipo',
				fieldLabel:'Tipo',
				allowBlank:false,
				emptyText:'Tipo...',
				typeAhead: true,
				triggerAction: 'all',
				lazyRender:true,
				mode: 'local',
				valueField: 'estilo',
				gwidth: 140,

				store: new Ext.data.JsonStore({
                         url: '../../sis_tesoreria/control/TipoProcesoCaja/listarTipoProcesoCaja',
                         id: 'id_tipo_proceso_caja',
                         root: 'datos',
                         sortInfo:{
                            field: 'nombre',
                            direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_tipo_proceso_caja','nombre','codigo'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams:{par_filtro:'nombre'//, estado_caja: 'apertura'
					}
                    }),
				valueField: 'codigo',
				displayField: 'nombre',
				hiddenName: 'codigo',
                forceSelection:true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:10,
                queryDelay:1000,
                listWidth:300,
                resizable:true,
                anchor:'80%',
				renderer:function(value,p,record){
					if (record.data['nombre'].match(/Apertura.*/)) {
						return String.format('{0}', '<FONT COLOR="blue"><b>'+record.data['nombre']+'</b></FONT>');
					}else{
						return String.format('{0}', '<FONT COLOR="green"><b>'+record.data['nombre']+'</b></FONT>');
					}
				}
			},
			type:'ComboBox',
			id_grupo:1,
			filters:{pfiltro:'ren.tipo',type:'string'},
			bottom_filter: true,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'estado',
				fieldLabel: 'Estado',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:50
			},
				type:'TextField',
				filters:{pfiltro:'ren.estado',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'motivo',
				fieldLabel: 'Motivo',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'ren.motivo',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_caja'
			},
			type:'Field',
			form:true
		},
		{
			config:{
				name: 'fecha',
				fieldLabel: 'Fecha Proceso',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y',
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'ren.fecha',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config: {
				name: 'id_proceso_wf',
				fieldLabel: 'id_proceso_wf',
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
				hiddenName: 'id_proceso_wf',
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
				filters:{pfiltro:'ren.monto',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:false
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
				filters:{pfiltro:'ren.estado_reg',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config: {
				name: 'id_comprobante_pago',
				fieldLabel: 'id_comprobante_pago',
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
				hiddenName: 'id_comprobante_pago',
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
			config: {
				name: 'id_estado_wf',
				fieldLabel: 'id_estado_wf',
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
				hiddenName: 'id_estado_wf',
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
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y',
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'ren.fecha_reg',type:'date'},
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
				filters:{pfiltro:'ren.usuario_ai',type:'string'},
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
				name: 'id_usuario_ai',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'ren.id_usuario_ai',type:'numeric'},
				id_grupo:1,
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
				filters:{pfiltro:'ren.fecha_mod',type:'date'},
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
				name: 'monto_rep',	
				fieldLabel: 'Monto a reponer',
				allowBlank: true,
				inputType:'hidden',
				anchor: '80%',
				gwidth: 200,
				maxLength:500
			},
			type:'NumberField',
			grid:true,
			form:false
		 },	
	],
	tam_pag:50,
	title:'Rendicion Caja',
	ActSave:'../../sis_tesoreria/control/ProcesoCaja/insertarProcesoCaja',
	ActDel:'../../sis_tesoreria/control/ProcesoCaja/eliminarProcesoCaja',
	ActList:'../../sis_tesoreria/control/ProcesoCaja/listarProcesoCaja',
	id_store:'id_proceso_caja',
	fields: [
		{name:'id_proceso_caja', type: 'numeric'},
		{name:'estado', type: 'string'},
		{name:'id_int_comprobante', type: 'numeric'},
		{name:'nro_tramite', type: 'string'},
		{name:'tipo', type: 'string'},
		{name:'motivo', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_caja', type: 'numeric'},
		{name:'id_moneda', type: 'numeric'},
		{name:'id_depto_lb', type: 'numeric'},
		{name:'fecha', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_proceso_wf', type: 'numeric'},
		{name:'monto', type: 'numeric'},
		{name:'id_estado_wf', type: 'numeric'},
		{name:'fecha_inicio', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'nombre', type: 'string'},
		'monto_rep'

	],
	sortInfo:{
		field: 'id_proceso_caja',
		direction: 'DESC'
	},
	bdel:true,
	bedit:false,
	bsave:true,


	preparaMenu:function(n){
		var data = this.getSelectedData();
		var tb =this.tbar;
		Phx.vista.ProcesoCaja.superclass.preparaMenu.call(this,n);
		if(data['tipo']=='SOLREP' && data['estado']=='borrador'){
			this.getBoton('agregarmonto').enable();
		}else{
			this.getBoton('agregarmonto').disable();
		}
		
     },

     liberaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;

          Phx.vista.ProcesoCaja.superclass.liberaMenu.call(this,n);
          this.getBoton('agregarmonto').disable();
     },
     
     diagramGantt : function (){
        var data=this.sm.getSelected().data.id_proceso_wf;
        if(data!=null){
			Phx.CP.loadingShow();
	        Ext.Ajax.request({
	            url: '../../sis_workflow/control/ProcesoWf/diagramaGanttTramite',
	            params: { 'id_proceso_wf': data },
	            success: this.successExport,
	            failure: this.conexionFailure,
	            timeout: this.timeout,
	            scope: this
	        });
        }
	},
	//
	crearFormAuto:function(){
		this.formAuto = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			autoDestroy: true,
			border: false,
			layout: 'form',
			autoHeight: true,
			items: 
			[{
				name:'monto_rep',
				xtype:'numberfield',
				fieldLabel:'Monto a Reponer',
				emptyText:'........',	
			}]
		});
		this.wAuto = new Ext.Window({
			title: 'Monto',
			collapsible: true,
			maximizable: true,
			autoDestroy: true,
			width: 380,
			height: 170,
			layout: 'fit',
			plain: true,
			bodyStyle: 'padding:5px;',
			buttonAlign: 'center',
			items: this.formAuto,
			modal:true,
			closeAction: 'hide',
			buttons: [{
				text: 'Guardar',
				handler: this.saveAuto,
				scope: this
			},
			{
				text: 'Cancelar',
				handler: function(){ this.wAuto.hide() },
				scope: this
			}]
		});
		this.cmpAuto = this.formAuto.getForm().findField('monto_rep');
	},
	//
	agregarmonto:function(){
		var data = this.getSelectedData();		
		if(data){		
			this.cmpAuto.setValue(data.monto);
			this.wAuto.show();
		}
	},
	//
	saveAuto: function(){
		var d = this.getSelectedData();
		Phx.CP.loadingShow();	
		console.log(d);	
		Ext.Ajax.request({
			url: '../../sis_tesoreria/control/Caja/editMonto',
			params: {
				id_caja:d.id_caja,
				monto_rep: this.cmpAuto.getValue(),
				estado:d.estado,
				id_proceso_caja:d.id_proceso_caja		
			},
			success: this.successSinc,
			failure: this.conexionFailure,
			timeout: this.timeout,
			scope: this
		});	
		this.wAuto.hide();					
	},
	//
	tabsouth:[
            {
             url:'../../../sis_tesoreria/vista/solicitud_rendicion_det/RendicionProcesoCaja.php',
             title:'Detalle',
             height:'50%',
             cls:'RendicionProcesoCaja'
			},
			{
				url:'../../../sis_tesoreria/vista/caja/CajaDeposito.php',
				title:'Depositos',
				height:'50%',
				cls:'CajaDeposito'
			}
       ]

	}
)
</script>
