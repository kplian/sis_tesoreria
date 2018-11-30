<?php
/**
*@package pXP
*@file RendicionEfectivo.php
*@author  (gsarmiento)
*@date 12-02-2016
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.RendicionEfectivo=Ext.extend(Phx.gridInterfaz,{
	
	nombreVista: 'RendicionEfectivo',

	constructor:function(config){

		this.historico = 'no';
		this.tbarItems = ['-',{
			text: 'Histórico',
			enableToggle: true,
			pressed: false,
			toggleHandler: function(btn, pressed) {

				if(pressed){
					this.historico = 'si';
					this.desBotoneshistorico();
				}
				else{
					this.historico = 'no'
				}

				this.store.baseParams.historico = this.historico;
				this.reload();
			},
			scope: this
		}];

		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.RendicionEfectivo.superclass.constructor.call(this,config);
		this.init();
		this.addButton('fin_registro',
			{	text:'Siguiente',
				iconCls: 'badelante',
				disabled:true,
				handler:this.sigEstado,
				tooltip: '<b>Siguiente</b><p>Pasa al siguiente estado</p>'
			}
		);
		this.addButton('btnChequeoDocumentosWf',
			{
				text: 'Documentos',
				iconCls: 'bchecklist',
				disabled: false,
				handler: this.loadCheckDocumentosSolWf,
				tooltip: '<b>Documentos de la Solicitud</b><br/>Los documetos de la solicitud seleccionada.'
			}
		);
		this.addButton('diagrama_gantt',{
			grupo:[0],
			text:'Gantt',
			iconCls: 'bgantt',
			disabled:false,
			handler:this.diagramGantt,
			tooltip: '<b>Diagrama Gantt de Solicitud de Efectivo</b>'
		});
		//carga de grilla
		if(this.nombreVista == 'RendicionEfectivo'){
			this.load({params:{start:0, limit: this.tam_pag, tipo_interfaz:this.nombreVista, id_caja:this.id_caja}});
		}
		
	},
	
	Atributos:[
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
			config: {
				name: 'id_caja',
				fieldLabel: 'Caja',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_tesoreria/control/Caja/listarCaja',
					id: 'id_caja',
					root: 'datos',
					sortInfo: {
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_caja', 'codigo', 'desc_moneda','cajero'],
					remoteSort: true,
					baseParams: {par_filtro: 'caja.codigo', tipo_interfaz:'cajaAbierto', con_detalle:'si'}
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
				gwidth: 100,
				minChars: 2,
				tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>{codigo}</b></p><p>CAJERO: {cajero}</p></div></tpl>',
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['codigo']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'caja.codigo',type: 'string'},
			grid: true,
			form: true
		},	
		{
			config:{
				name: 'fecha',
				fieldLabel: 'Fecha',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y',
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'solefe.fecha',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'solicitud_efectivo_padre',
				fieldLabel: 'Num Tramite Solicitud Efectivo',
				allowBlank: false,
				anchor: '80%',
				gwidth: 180,
				maxLength:50
			},
				type:'TextField',
				filters:{pfiltro:'solefe.nro_tramite',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},		
		{
   			config:{
       		    name:'id_funcionario',
       		     hiddenName: 'id_funcionario',
   				origen:'FUNCIONARIOCAR',
   				fieldLabel:'Funcionario',
   				allowBlank:false,
                gwidth:200,
   				valueField: 'id_funcionario',
   			    gdisplayField: 'desc_funcionario',   			    
      			renderer:function(value, p, record){return String.format('{0}', record.data['desc_funcionario']);}
       	     },
   			type:'ComboRec',//ComboRec
   			id_grupo:0,
   			filters:{pfiltro:'fun.desc_funcionario1',type:'string'},
   			bottom_filter:true,
   		    grid:true,
   			form:true
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
				name: 'monto',
				fieldLabel: 'Monto Rendicion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 120,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'solefe.monto',type:'numeric'},
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
				name: 'estado',
				fieldLabel: 'Estado',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:50
			},
				type:'TextField',
				filters:{pfiltro:'solefe.estado',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'motivo',
				fieldLabel: 'Motivo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
				type:'TextField',
				filters:{pfiltro:'solefe.motivo',type:'string'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'solefe.estado_reg',type:'string'},
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
				filters:{pfiltro:'solefe.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'solefe.fecha_reg',type:'date'},
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
				filters:{pfiltro:'solefe.usuario_ai',type:'string'},
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
				filters:{pfiltro:'solefe.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Rendicion Efectivo',
	ActList:'../../sis_tesoreria/control/SolicitudEfectivo/listarSolicitudEfectivo',
	ActDel:'../../sis_tesoreria/control/SolicitudEfectivo/eliminarSolicitudEfectivo',
	id_store:'id_solicitud_efectivo',
	fields: [
		{name:'id_solicitud_efectivo', type: 'numeric'},
		{name:'estado', type: 'string'},
		{name:'id_comprobante_diario', type: 'numeric'},
		{name:'nro_tramite', type: 'string'},
		{name:'tipo', type: 'string'},
		{name:'motivo', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_caja', type: 'numeric'},
		{name:'codigo', type:'string'},
		{name:'desc_funcionario', type:'string'},
		{name:'fecha', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_proceso_wf', type: 'numeric'},
		//{name:'monto_reposicion', type: 'numeric'},
		{name:'id_comprobante_pago', type: 'numeric'},
		{name:'id_estado_wf', type: 'numeric'},
		{name:'monto', type:'numeric'},
		{name:'fecha_inicio', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'solicitud_efectivo_padre', type: 'string'},
		{name:'saldo', type: 'string'}		
	],
	sortInfo:{
		field: 'id_solicitud_efectivo',
		direction: 'DESC'
	},	
	bdel:true,
	bedit:false,
	bsave:false,
	bnew:false,
	
	onButtonNew: function(){    	
    	Phx.vista.RendicionEfectivo.superclass.onButtonNew.call(this);		
        this.Cmp.id_caja.setValue(this.id_caja);	 
	},

	desBotoneshistorico: function(){
		console.log(this);
		this.liberaMenu();
	},
	
	sigEstado:function(){                   
	  var rec=this.sm.getSelected();	  
	  var configExtra = [];
	  /*if(rec.data.saldo > 0 ){
		  configExtra = [{
							config:{
								name: 'saldo',
								fieldLabel: 'Saldo Efectivo',
								allowBlank: true,
								disabled: true,
								anchor: '50%',
								value : rec.data.saldo
							},
							type:'NumberField',
							id_grupo:1,
							form:true
							},
							{
							config:{
								name: 'devolucion_dinero',
								fieldLabel: 'Devolucion dinero?',
								allowBlank: false,
								emptyText:'Elija una opcion...',
								typeAhead: true,
								triggerAction: 'all',
								lazyRender:true,
								mode: 'local',
								anchor: '50%',
								store:['si']
							},
							type:'ComboBox',						
							form:true
						}];
	  }
	  
	  if(rec.data.saldo < 0 ){
		  */
	  if(rec.data.saldo != 0){
		  configExtra = [{
							config:{
								name: 'saldo',
								fieldLabel: 'Saldo Efectivo',
								allowBlank: true,
								disabled: true,
								anchor: '50%',
								value : rec.data.saldo
							},
							type:'NumberField',
							id_grupo:1,
							form:true
							},
							{
							config:{
								name: 'devolucion_dinero',
								inputType:'hidden',
								value: 'si'
							},
							type:'Field',						
							form:true
						},
						{
							config:{
								name: 'estado',
								fieldLabel: 'estado',
								inputType:'hidden',
								value : rec.data.estado
							},
							type:'Field',						
							form:true
						}];
	  }else{
		  configExtra = [
						{
							config:{
								name: 'saldo',
								fieldLabel: 'Saldo Efectivo',
								inputType:'hidden',
								value : rec.data.saldo
							},
							type:'NumberField',
							id_grupo:1,
							form:true
						},
						{
							config:{
								name: 'estado',
								fieldLabel: 'estado',
								inputType:'hidden',
								value : rec.data.estado
							},
							type:'Field',						
							form:true
						}];
	  }
	  
	  this.objWizard = Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php',
								'Estado de Wf',
								{
									modal:true,
									width:700,
									height:450
								}, {
									configExtra: configExtra,
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
	 
	 onSaveWizard:function(wizard,resp){
			//Phx.CP.loadingShow();
			if(resp.estado == 'revision' && resp.saldo == 0 ){				
				Ext.Msg.show({
				   title:'Confirmación',
				   scope: this,
				   msg: 'Esta seguro de comprometer presupuesto?',
				   buttons: Ext.Msg.YESNO,
				   fn: function(id, value, opt) {
						if (id == 'yes') {
							Ext.Ajax.request({
								url:'../../sis_tesoreria/control/SolicitudEfectivo/siguienteEstadoSolicitudEfectivo',
								params:{
										
									id_proceso_wf_act:  resp.id_proceso_wf_act,
									id_estado_wf_act:   resp.id_estado_wf_act,
									id_tipo_estado:     resp.id_tipo_estado,
									id_funcionario_wf:  resp.id_funcionario_wf,
									id_depto_wf:        resp.id_depto_wf,
									obs:                resp.obs,
									saldo:				resp.saldo,
									devolucion_dinero:	resp.devolucion_dinero
									},
								success:this.successWizard,
								failure: this.conexionFailure,
								argument:
								{
									wizard:wizard, 
									id_proceso_wf : resp.id_proceso_wf_act,
									id_estado_wf:   resp.id_estado_wf_act,
									resp : resp
								},
								timeout:this.timeout,
								scope:this
							});							
						} else {
							opt.hide;
						}
				   },	
				   animEl: 'elId',
				   icon: Ext.MessageBox.WARNING
				}, this);
			}
			else if	(resp.estado == 'revision' && resp.saldo > 0 ){
				Ext.Msg.show({
				   title:'Confirmación',
				   scope: this,
				   msg: 'Esta seguro de comprometer presupuesto? y devolver el saldo a CAJA? Si esta de acuerdo presione el botón "Si"',
				   buttons: Ext.Msg.YESNO,
				   fn: function(id, value, opt) {
						if (id == 'yes') {
							Ext.Ajax.request({
								url:'../../sis_tesoreria/control/SolicitudEfectivo/siguienteEstadoSolicitudEfectivo',
								params:{
										
									id_proceso_wf_act:  resp.id_proceso_wf_act,
									id_estado_wf_act:   resp.id_estado_wf_act,
									id_tipo_estado:     resp.id_tipo_estado,
									id_funcionario_wf:  resp.id_funcionario_wf,
									id_depto_wf:        resp.id_depto_wf,
									obs:                resp.obs,
									saldo:				resp.saldo,
									devolucion_dinero:	resp.devolucion_dinero
									},
								success:this.successWizard,
								failure: this.conexionFailure,
								argument:
								{
									wizard:wizard, 
									id_proceso_wf : resp.id_proceso_wf_act,
									id_estado_wf:   resp.id_estado_wf_act,
									resp : resp
								},
													timeout:this.timeout,
								scope:this
							});							
						} else {
							opt.hide;
						}
				   },	
				   animEl: 'elId',
				   icon: Ext.MessageBox.WARNING
				}, this);
			} else if(resp.estado == 'revision' && resp.saldo < 0 ){
				Ext.Msg.show({
				   title:'Confirmación',
				   scope: this,
				   msg: 'Esta seguro de comprometer presupuesto? y reponer la diferencia al SOLICITANTE? Si esta de acuerdo presione el botón "Si"',
				   buttons: Ext.Msg.YESNO,
				   fn: function(id, value, opt) {	
						if (id == 'yes') {
							Ext.Ajax.request({
								url:'../../sis_tesoreria/control/SolicitudEfectivo/siguienteEstadoSolicitudEfectivo',
								params:{
										
									id_proceso_wf_act:  resp.id_proceso_wf_act,
									id_estado_wf_act:   resp.id_estado_wf_act,
									id_tipo_estado:     resp.id_tipo_estado,
									id_funcionario_wf:  resp.id_funcionario_wf,
									id_depto_wf:        resp.id_depto_wf,
									obs:                resp.obs,
									saldo:				resp.saldo,
									devolucion_dinero:	resp.devolucion_dinero
									},
								success:this.successWizard,
								failure: this.conexionFailure,
								argument:
								{
									wizard:wizard, 
									id_proceso_wf : resp.id_proceso_wf_act,
									id_estado_wf:   resp.id_estado_wf_act,
									resp : resp
								},
								timeout:this.timeout,
								scope:this
							});							
						} else {
							opt.hide;
						}
				   },	
				   animEl: 'elId',
				   icon: Ext.MessageBox.WARNING
				}, this);
			}else{
				Ext.Ajax.request({
								url:'../../sis_tesoreria/control/SolicitudEfectivo/siguienteEstadoSolicitudEfectivo',
								params:{
										
									id_proceso_wf_act:  resp.id_proceso_wf_act,
									id_estado_wf_act:   resp.id_estado_wf_act,
									id_tipo_estado:     resp.id_tipo_estado,
									id_funcionario_wf:  resp.id_funcionario_wf,
									id_depto_wf:        resp.id_depto_wf,
									obs:                resp.obs,
									saldo:				resp.saldo,
									devolucion_dinero:	resp.devolucion_dinero
									},
								success:this.successWizard,
								failure: this.conexionFailure,
								argument:
								{
									wizard:wizard, 
									id_proceso_wf : resp.id_proceso_wf_act,
									id_estado_wf:   resp.id_estado_wf_act,
									resp : resp
								},
								timeout:this.timeout,
								scope:this
							});	
			}
		},		
	
	preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;          
          		  
          Phx.vista.RendicionEfectivo.superclass.preparaMenu.call(this,n);
		  if(this.historico == 'no') {
			  if (data['estado'] == 'revision' || data['estado'] == 'vbjefedevsol') {
				  this.getBoton('fin_registro').enable();
			  }
			  else {
				  this.getBoton('fin_registro').disable();
			  }
		  }else{
			  this.bloquearMenusHijo();
			  //console.log(Phx.CP.getPagina(this.idContenedor+'-south-0'));

			  this.getBoton('fin_registro').disable();
			  this.getBoton('del').disable();
			  Phx.CP.getPagina(this.idContenedor+'-south-0').getBoton('dev_factura').disable();
			  var boton = Phx.CP.getPagina(this.idContenedor+'-south-0').getBoton('dev_factura');
			  boton.disable();
		  }
     },
     
     loadCheckDocumentosSolWf:function() {
		var rec=this.sm.getSelected();
		rec.data.nombreVista = this.nombreVista;
		Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
			'Chequear documento del WF',
			{
				width:'90%',
				height:500
			},
			rec.data,
			this.idContenedor,
			'DocumentoWf'
		)
	},
	diagramGantt : function (){
		var data=this.sm.getSelected().data.id_proceso_wf;
		Phx.CP.loadingShow();
		Ext.Ajax.request({
			url: '../../sis_workflow/control/ProcesoWf/diagramaGanttTramite',
			params: { 'id_proceso_wf': data },
			success: this.successExport,
			failure: this.conexionFailure,
			timeout: this.timeout,
			scope: this
		});
	},
		
	successWizard:function(resp){
		Phx.CP.loadingHide();
		resp.argument.wizard.panel.destroy()
		this.reload();
		
		if(resp.argument.wizard.Cmp.id_tipo_estado.lastSelectionText=='rendido'){
			if (resp.argument.id_proceso_wf) {
				Phx.CP.loadingShow();
				Ext.Ajax.request({
					url : '../../sis_tesoreria/control/SolicitudEfectivo/reporteRendicionEfectivo',
					params : {
						'id_proceso_wf' : resp.argument.id_proceso_wf
					},
					success : this.successExport,
					failure : this.conexionFailure,
					timeout : this.timeout,
					scope : this
				});
			}
		}
	},
	
	tabsouth:
	[
		{
			url:'../../../sis_tesoreria/vista/solicitud_rendicion_det/AprobacionFacturas.php',
			title:'Detalle', 
			height:'50%',
			cls:'AprobacionFacturas'
		}
	]
	}
)
</script>
		
		