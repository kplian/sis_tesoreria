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
		this.addButton('fin_registro',
			{	text:'Siguiente',
				iconCls: 'badelante',
				disabled:false,
				handler:this.sigEstado,
				tooltip: '<b>Siguiente</b><p>Pasa al siguiente estado</p>'
			}
		);
		/*
		this.addButton('relacionar_deposito',
			{	text:'Relacionar Depósito',
				iconCls: 'btransfer',
				disabled:false,
				handler:this.relacionarDeposito,
				tooltip: '<b>Relacionar Depósito</b><p>Relacionar Deposito</p>'
			}
		);
		*/
		this.addButton('chkpresupuesto',
			{	text:'Chk Presupuesto',
				iconCls: 'blist',
				disabled:false,
				grupo:[0,1],
				handler:this.checkPresupuesto,
				tooltip: '<b>Revisar Presupuesto</b><p>Revisar estado de ejecución presupeustaria para el tramite</p>'
			}
		);
		
		this.addButton('consolidado_rendicion',
			{	text:'Reporte Rendicion',
				iconCls: 'blist',
				disabled:false,
				grupo:[0,1],
				handler:this.consolidado_rendicion,
				tooltip: '<b>Consolidado Rendicion</b><p>Consolidado por Rendicion</p>'
			}
		);
		
		this.addButton('consolidado_reposicion',
			{	text:'Reporte Reposicion',
				iconCls: 'blist',
				disabled:false,
				grupo:[0,1],
				handler:this.consolidado_reposicion,
				tooltip: '<b>Consolidado Reposicion</b><p>Consolidado por Reposicion</p>'
			}
		);
		
		//carga de grilla
		if(this.nombreVista == 'ProcesoCaja'){
			this.load({params:{start:0, limit: this.tam_pag, tipo_interfaz:this.nombreVista, id_caja:this.id_caja}});
		}

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
				gwidth: 130,
				maxLength:50
			},
				type:'TextField',
				filters:{pfiltro:'ren.nro_tramite',type:'string'},
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
				grid:true,
				form:true
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
				grid:true,
				form:true
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
				gwidth: 120,

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
                renderer : function(value, p, record) {
					return String.format('{0}', record.data['nombre']);
				}
			},
			type:'ComboBox',
			id_grupo:1,
			filters:{pfiltro:'ren.tipo',type:'string'},
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
				name: 'monto_reposicion',
				fieldLabel: 'Monto',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'ren.monto_reposicion',type:'numeric'},
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
		}
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
		{name:'monto_reposicion', type: 'numeric'},
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
		{name:'nombre', type: 'string'}

	],
	sortInfo:{
		field: 'id_proceso_caja',
		direction: 'DESC'
	},
	bdel:true,
	bedit:false,
	bsave:true,

	onButtonNew: function(){
    	Phx.vista.ProcesoCaja.superclass.onButtonNew.call(this);
        this.Cmp.id_caja.setValue(this.id_caja);

		this.Cmp.tipo.reset();
        this.Cmp.tipo.store.baseParams = Ext.apply(this.Cmp.tipo.store.baseParams,{estado_caja: this.estado} )
        this.Cmp.tipo.modificado = true;

		if(this.estado=='cerrado'){
			this.ocultarComponente(this.Cmp.fecha_inicio);
			this.ocultarComponente(this.Cmp.fecha_fin);
		}
	},

	sigEstado:function(){
	  var rec=this.sm.getSelected();
	  var configExtra = [];
	  console.log(rec.data.tipo);
	  if(rec.data.estado == 'vbconta' || rec.data.estado == 'revision' || rec.data.estado == 'vbfondos'){
		  configExtra = [
							{
								config:{
									name: 'id_cuenta_bancaria',
									fieldLabel: 'Cuenta Bancaria',
									allowBlank: false,
									emptyText:'Elija una Cuenta...',
									store:new Ext.data.JsonStore(
										{
										url: '../../sis_tesoreria/control/CuentaBancaria/listarCuentaBancariaUsuario',
										id: 'id_cuenta_bancaria',
										root:'datos',
										sortInfo:{
											field:'id_cuenta_bancaria',
											direction:'ASC'
										},
										totalProperty:'total',
										fields: ['id_cuenta_bancaria','nro_cuenta','nombre_institucion','codigo_moneda','centro','denominacion'],
										remoteSort: true,
										baseParams : {
											par_filtro :'nro_cuenta', id_depto_lb: rec.data.id_depto_lb, permiso: 'todos'
										}
										}),
									tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{nro_cuenta}</b></p><p>Moneda: {codigo_moneda}, {nombre_institucion}</p><p>{denominacion}, Centro: {centro}</p></div></tpl>',
									valueField: 'id_cuenta_bancaria',
									hiddenValue: 'id_cuenta_bancaria',
									displayField: 'nro_cuenta',
									gdisplayField:'desc_cuenta_bancaria',
									listWidth:'280',
									forceSelection:true,
									typeAhead: false,
									triggerAction: 'all',
									lazyRender:true,
									mode:'remote',
									pageSize:20,
									queryDelay:500,
									gwidth: 550,
									anchor: '80%',
									minChars:2,
									renderer:function(value, p, record){return String.format('{0}', record.data['desc_cuenta_bancaria']);}
							},
							type:'ComboBox',
							filters:{pfiltro:'cb.nro_cuenta',type:'string'},
							id_grupo:1,
							grid:true,
							form:true
						},
						{
            config:{
                name: 'id_cuenta_bancaria_mov',
                fieldLabel: 'Fondo',
                allowBlank: true,
                emptyText : 'Fondo...',
                store: new Ext.data.JsonStore({
                    url:'../../sis_tesoreria/control/TsLibroBancos/listarTsLibroBancosDepositosConSaldo',
                    id : 'id_cuenta_bancaria_mov',
                    root: 'datos',
                    sortInfo:{
                            field: 'fecha',
                            direction: 'DESC'
                    },
                    totalProperty: 'total',
                    fields: ['id_libro_bancos','id_cuenta_bancaria','fecha','detalle','observaciones','importe_deposito','saldo'],
                    remoteSort: true,
                    baseParams:{par_filtro:'detalle#observaciones#fecha'}
               }),
               valueField: 'id_libro_bancos',
               displayField: 'importe_deposito',
               gdisplayField: 'desc_deposito',
               hiddenName: 'id_cuenta_bancaria_mov',
               forceSelection:true,
               typeAhead: false,
               triggerAction: 'all',
               listWidth:350,
               lazyRender:true,
               mode:'remote',
               pageSize:10,
               queryDelay:1000,
               anchor: '80%',
               gwidth:200,
               minChars:2,
               tpl: '<tpl for="."><div class="x-combo-list-item"><p>{detalle}</p><p>Fecha:<strong>{fecha}</strong></p><p>Importe:<strong>{importe_deposito}</strong></p><p>Saldo:<strong>{saldo}</strong></p></div></tpl>',
               renderer:function(value, p, record){return String.format('{0}', record.data['desc_deposito']);}
            },
            type:'ComboBox',
            filters:{pfiltro:'cbanmo.detalle#cbanmo.nro_doc_tipo',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        }];
		
		this.eventosExtra = function(obj){								 
								 //Evento para filtrar los depósitos a partir de la cuenta bancaria
						        obj.Cmp.id_cuenta_bancaria.on('select',function(data,rec,ind){
						        	//si es de una regional nacional
								    this.Cmp.id_cuenta_bancaria_mov.reset();
						            this.Cmp.id_cuenta_bancaria_mov.modificado=true;
						            Ext.apply(this.Cmp.id_cuenta_bancaria_mov.store.baseParams,{id_cuenta_bancaria: rec.id});
						        },obj);   	
								    			
						};
	  }
	  
	  this.objWizard = Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php',
							'Estado de Wf',
							{
								modal:true,
								width:700,
								height:450
							}, {
								configExtra: configExtra,
								eventosExtra: this.eventosExtra,
								data:{
								   id_estado_wf:rec.data.id_estado_wf,
								   id_proceso_wf:rec.data.id_proceso_wf
								}}, this.idContenedor,'FormEstadoWf',
							{
								config:[{
										  event:'beforesave',
										  delegate: this.onSaveWizard
										}],

								scope:this
							 });
	 },
	 /*	
	 relacionarDeposito:function(){ 
		var rec=this.sm.getSelected();
		
		var NumSelect=this.sm.getCount();
		
		if(NumSelect != 0)
		{						
			Phx.CP.loadWindows('../../../sis_tesoreria/vista/deposito/FormRelacionarDeposito.php',
			'Relacionar Deposito',
			{
				modal:true,
				width:500,
				height:250
			}, {data:rec.data}, this.idContenedor,'FormRelacionarDeposito',
			{
				config:[{
						  event:'beforesave',
						  delegate: this.transferir,
						}
						],
			   scope:this
			 })
		}
		else
		{
			Ext.MessageBox.alert('Alerta', 'Antes debe seleccionar un item.');
		}
							   
	},
	
	transferir:function(wizard,resp){
		Phx.CP.loadingShow();
		Ext.Ajax.request({
			url:'../../sis_tesoreria/control/ProcesoCaja/relacionarDeposito',
			params:{
					id_cuenta_bancaria:resp.id_cuenta_bancaria,
					id_libro_bancos:resp.id_libro_bancos,
					tabla:'tes.tproceso_caja', 
					columna_pk:'id_proceso_caja',
					columna_pk_valor:resp.id_proceso_caja					
			 },
			argument:{wizard:wizard},  
			success:this.successWizard,
			failure: this.conexionFailure,
			timeout:this.timeout,
			scope:this
		});
	   
	},*/

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

	 },


	 onSaveWizard:function(wizard,resp){
			Phx.CP.loadingShow();
			Ext.Ajax.request({
				url:'../../sis_tesoreria/control/ProcesoCaja/siguienteEstadoProcesoCaja',
				params:{

					id_proceso_wf_act:  resp.id_proceso_wf_act,
					id_estado_wf_act:   resp.id_estado_wf_act,
					id_tipo_estado:     resp.id_tipo_estado,
					id_funcionario_wf:  resp.id_funcionario_wf,
					id_depto_wf:        resp.id_depto_wf,
					obs:                resp.obs,
					id_cuenta_bancaria:	resp.id_cuenta_bancaria,
					id_cuenta_bancaria_mov : resp.id_cuenta_bancaria_mov,
					json_procesos:      Ext.util.JSON.encode(resp.procesos)
					},
				success:this.successWizard,
				failure: this.conexionFailure,
				argument:{wizard:wizard},
				timeout:this.timeout,
				scope:this
			});
		},
	
	enableTabDepositos:function(){
     	if(this.TabPanelSouth.get(1)){
     		      this.TabPanelSouth.get(1).enable();	
		          this.TabPanelSouth.setActiveTab(1)
		        }
     },
	 
	disableTabDepositos:function(){
     	if(this.TabPanelSouth.get(1)){
     		      this.TabPanelSouth.get(1).disable();	
		          this.TabPanelSouth.setActiveTab(0)
		          
		}
     },

	preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;
		
          Phx.vista.ProcesoCaja.superclass.preparaMenu.call(this,n);
          if (data['estado']== 'borrador'){
              this.getBoton('fin_registro').enable();
			  this.getBoton('del').enable();
          }
          else{
              this.getBoton('fin_registro').disable();
			  this.getBoton('del').disable();
          }
		  
		  if(data['tipo']=='CIERRE'){
			  //habilitar pestaña depositos
			  this.enableTabDepositos();
		  }else{
			  //deshabilitar pestaña depositos
			  this.disableTabDepositos();
		  }
		  	
          this.getBoton('chkpresupuesto').enable();

     },

     liberaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;

          Phx.vista.ProcesoCaja.superclass.liberaMenu.call(this,n);
          this.getBoton('chkpresupuesto').disable();
     },

	successWizard:function(resp){
			Phx.CP.loadingHide();
			resp.argument.wizard.panel.destroy()
			this.reload();
		 },
		 
	consolidado_rendicion : function() {
		var rec = this.getSelectedData();
		var NumSelect=this.sm.getCount();
		
		if(NumSelect != 0)
		{		
			var data ='id_proceso_caja='+ rec.id_proceso_caja;  			
			data += '&nro_tramite=' + rec.nro_tramite;
			data += '&fecha_inicio=' + rec.fecha_inicio.format('d-m-Y');
			data += '&fecha_fin=' + rec.fecha_fin.format('d-m-Y');
			data += '&reporte=rendicion';
			console.log(data);
			//window.open('http://sms.obairlines.bo/ReportesPXP/Home/MemorandumFondosEnAvance?'+data);				
			//window.open('http://localhost:22021/Home/ReporteConsolidadoRendicionesCajaChica?'+data);
			window.open('http://sms.obairlines.bo/ReportesPXP/Home/ReporteConsolidadoRendicionesCajaChica?'+data);							
		}
		else
		{
			Ext.MessageBox.alert('Alerta', 'Antes debe seleccionar un item.');
		}
	},
	
	consolidado_reposicion : function() {
		var rec = this.getSelectedData();
		var NumSelect=this.sm.getCount();
		
		if(NumSelect != 0)
		{		
			var data ='id_proceso_caja='+ rec.id_proceso_caja;  			
			data += '&nro_tramite=' + rec.nro_tramite;
			data += '&fecha_inicio=' + rec.fecha_inicio.format('d-m-Y');
			data += '&fecha_fin=' + rec.fecha_fin.format('d-m-Y');			
			data += '&reporte=reposicion';
			console.log(data);
			//window.open('http://sms.obairlines.bo/ReportesPXP/Home/MemorandumFondosEnAvance?'+data);				
			//window.open('http://localhost:22021/Home/ReporteConsolidadoRendicionesCajaChica?'+data);				
			window.open('http://sms.obairlines.bo/ReportesPXP/Home/ReporteConsolidadoRendicionesCajaChica?'+data);				
		}
		else
		{
			Ext.MessageBox.alert('Alerta', 'Antes debe seleccionar un item.');
		}
	},

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
