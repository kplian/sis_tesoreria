<?php
/**
*@package pXP
*@file SolicitudEfectivo.php
*@author  (gsarmiento)
*@date 24-11-2015 12:59:51
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.SolicitudEfectivo=Ext.extend(Phx.gridInterfaz,{

	vista:'ConDetalle',

	constructor:function(config){
		this.maestro=config.maestro;
		
		this.Atributos[this.getIndAtributo('monto_rendido')].config.renderer = function(value, p, record) {			
				    var saldo = parseFloat(record.data.monto) + parseFloat(record.data.monto_repuesto) - parseFloat(record.data.monto_rendido) - parseFloat(record.data.monto_devuelto);
					if (record.data.estado == 'entregado' || record.data.estado == 'finalizado') {
						return String.format("<font color = 'red'>Rendido: {0}</font><br>"+
											 "<font color = 'slategray' >Devuelto a Caja:{1}</font><br>"+
											 "<font color = 'green' >Devuelto a Solicitante:{2}</font><br>"											 
											 ,record.data.monto_rendido, record.data.monto_devuelto, record.data.monto_repuesto											 
											 );
					} 
					else {
						return String.format('');
					}
			};
    	//llama al constructor de la clase padre
		Phx.vista.SolicitudEfectivo.superclass.constructor.call(this,config);
		this.init();
		this.addButton('fin_registro',
			{	text:'Siguiente',
				iconCls: 'badelante',
				disabled:false,
				handler:this.sigEstado,
				tooltip: '<b>Siguiente</b><p>Pasa al siguiente estado</p>'
			}
		);
		this.iniciarEventos();

		this.addButton('btnRendicion', {
			text : 'Rendicion Efectivo',
			iconCls : 'bballot',
			disabled : false,
			handler : this.onBtnRendicion,
			tooltip : '<b>Rendicion</b>'
		});

		this.addButton('btnDevol', {
			text : 'Devolucion Efectivo',
			iconCls : 'bballot',
			disabled : true,
			handler : this.onBtnDevolucion,
			tooltip : '<b>Devolucion Sin Añadir Facturas</b>'
		});

		this.addButton('btnSolicitud', {
			text : 'Solicitud',
			iconCls : 'bpdf',
			disabled : false,
			handler : this.onBtnSolicitud,
			tooltip : '<b>Solicitud Gastos</b>'
		});

		this.addButton('btnReciboEntrega', {
			text : 'Recibo Entrega Efectivo',
			iconCls : 'bpdf',
			disabled : false,
			handler : this.onBtnReciboEntrega,
			tooltip : '<b>Recibo Entrega Efectivo</b>'
		});

		this.load({params:{start:0, limit:this.tam_pag, tipo_interfaz: this.vista}})
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
						field: 'codigo',
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
				gwidth: 80,
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
				name: 'nro_tramite',
				fieldLabel: 'Num Tramite',
				allowBlank: false,
				anchor: '80%',
				gwidth: 170,
				maxLength:50
			},
				type:'TextField',
				filters:{pfiltro:'solefe.nro_tramite',type:'string'},
				id_grupo:1,
				bottom_filter:true,
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
				fieldLabel: 'Monto Solicitado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'solefe.monto',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'monto_rendido',
				fieldLabel: 'Montos',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
				maxLength:1179650
			},
				type:'NumberField',
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'monto_devuelto',
				fieldLabel: 'Monto Devuelto',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				id_grupo:1,
				grid:false,
				form:false
		},
		{
			config:{
				name: 'monto_repuesto',
				fieldLabel: 'Monto Repuesto',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				id_grupo:1,
				grid:false,
				form:false
		},
		{
			config:{
				name: 'saldo',
				fieldLabel: 'Saldo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 70,
				maxLength:1179650
			},
				type:'NumberField',
				id_grupo:1,
				grid:true,
				form:false
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
	title:'Solicitud Efectivo Con Detalle',
	ActSave:'../../sis_tesoreria/control/SolicitudEfectivo/insertarSolicitudEfectivo',
	ActDel:'../../sis_tesoreria/control/SolicitudEfectivo/eliminarSolicitudEfectivo',
	ActList:'../../sis_tesoreria/control/SolicitudEfectivo/listarSolicitudEfectivo',
	id_store:'id_solicitud_efectivo',
	fields: [
		{name:'id_solicitud_efectivo', type: 'numeric'},
		{name:'id_caja', type: 'numeric'},
		{name:'codigo', type: 'string'},
		{name:'id_depto', type: 'numeric'},
		{name:'id_moneda', type: 'numeric'},
		{name:'id_estado_wf', type: 'numeric'},
		{name:'monto', type: 'numeric'},
		{name:'id_proceso_wf', type: 'numeric'},
		{name:'nro_tramite', type: 'string'},
		{name:'estado', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'motivo', type: 'string'},
		{name:'id_funcionario', type: 'numeric'},
		{name:'desc_funcionario', type: 'string'},
		{name:'fecha', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'monto_rendido', type: 'numeric'},
		{name:'monto_repuesto', type: 'numeric'},
		{name:'monto_devuelto', type: 'numeric'},
		{name:'saldo', type: 'numeric'}
	],
	sortInfo:{
		field: 'solefe.id_solicitud_efectivo',
		direction: 'DESC'
	},
	bdel:true,
	bsave:true,

	onButtonNew:function(){
        //abrir formulario de solicitud
	       var me = this;
		   me.objSolForm = Phx.CP.loadWindows('../../../sis_tesoreria/vista/solicitud_efectivo/FormSolicitudEfectivo.php',
	                                'Formulario de solicitud efectivo',
	                                {
	                                    modal:true,
	                                    width:'90%',
	                                    height:'90%'
	                                }, {data:{objPadre: me}
	                                },
	                                this.idContenedor,
	                                'FormSolicitudEfectivo',
									{
	                                    config:[{
	                                              event:'successsave',
	                                              delegate: this.onSaveForm,

	                                            }],

	                                    scope:this
	                                 });

    },

	onSaveForm: function(form,  objRes){
    	var me = this;
    	form.panel.destroy();
        me.reload();
    },

	iniciarEventos:function(){
		this.cmpMonto=this.getComponente('monto');
		this.cmpMonto.disable();
	},

	preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;

          Phx.vista.SolicitudEfectivo.superclass.preparaMenu.call(this,n);
          if (data['estado']== 'borrador'){
              this.getBoton('fin_registro').enable();
			  this.getBoton('edit').enable();
			  this.getBoton('del').enable();
          }
          else{
              this.getBoton('fin_registro').disable();
			  this.getBoton('edit').disable();
			  this.getBoton('del').disable();
          }

		  if (data['estado']== 'entregado'){
              this.getBoton('fin_registro').enable();
          }

		  if (data['estado'] == 'entregado' || data['estado'] == 'finalizado'){
			  this.getBoton('btnRendicion').enable();
				this.getBoton('btnReciboEntrega').enable();
		  }else{
			  this.getBoton('btnRendicion').disable();
				this.getBoton('btnReciboEntrega').disable();
		  }

		  if(data['saldo'] == 0.00){
			  this.getBoton('btnDevol').disable();
		  }else{
			  this.getBoton('btnDevol').enable();
		  }
     },

	onBtnRendicion : function() {
		var rec = this.sm.getSelected();
		Phx.CP.loadWindows('../../../sis_tesoreria/vista/solicitud_rendicion_det/SolicitudRendicionDet.php', 'Rendicion', {
			modal : true,
			width : '95%',
			height : '95%',
		}, rec.data, this.idContenedor, 'SolicitudRendicionDet');
	},

	onBtnDevolucion : function() {
		var rec=this.sm.getSelected();

		Ext.Msg.show({
		   title:'Confirmación',
		   scope: this,
		   msg: 'Esta seguro de SI devolver el dinero? Saldo: '+ rec.data.saldo + ' Si esta de acuerdo presione el botón "Si"',
		   buttons: Ext.Msg.YESNO,
		   fn: function(id, value, opt) {
				if (id == 'yes') {
					Ext.Ajax.request({
						url:'../../sis_tesoreria/control/SolicitudEfectivo/insertarSolicitudEfectivo',
						params:{
							'id_solicitud_efectivo_fk':rec.data.id_solicitud_efectivo,
							'id_caja':rec.data.id_caja,
							'monto':rec.data.saldo,
							'id_funcionario':rec.data.id_funcionario,
							'tipo_solicitud':'devolucion',
							'fecha':new Date()
							},
						success:this.successDevolucion,
						failure: this.conexionFailure,
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
	},

	onBtnSolicitud : function() {
		var rec=this.sm.getSelected();
        Ext.Ajax.request({
            url:'../../sis_tesoreria/control/SolicitudEfectivo/reporteSolicitudEfectivo',
            params:{'id_solicitud_efectivo':rec.data.id_solicitud_efectivo,'estado':rec.data.estado},
            success: this.successExport,
            failure: this.conexionFailure,
            timeout:this.timeout,
            scope:this
        });
	},

	onBtnReciboEntrega : function() {
		var rec=this.sm.getSelected();
        Ext.Ajax.request({
            url:'../../sis_tesoreria/control/SolicitudEfectivo/reporteReciboEntrega',
            params:{'id_solicitud_efectivo':rec.data.id_solicitud_efectivo},
            success: this.successExport,
            failure: this.conexionFailure,
            timeout:this.timeout,
            scope:this
        });
	},

	sigEstado:function(){
	  var rec=this.sm.getSelected();
	  this.objWizard = Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php',
								'Estado de Wf',
								{
									modal:true,
									width:700,
									height:450
								}, {data:{
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
			Phx.CP.loadingShow();
			Ext.Ajax.request({
				url:'../../sis_tesoreria/control/SolicitudEfectivo/siguienteEstadoSolicitudEfectivo',
				params:{

					id_proceso_wf_act:  resp.id_proceso_wf_act,
					id_estado_wf_act:   resp.id_estado_wf_act,
					id_tipo_estado:     resp.id_tipo_estado,
					id_funcionario_wf:  resp.id_funcionario_wf,
					id_depto_wf:        resp.id_depto_wf,
					obs:                resp.obs,
					json_procesos:      Ext.util.JSON.encode(resp.procesos)
					},
				success:this.successWizard,
				failure: this.conexionFailure,
				argument:{wizard:wizard},
				timeout:this.timeout,
				scope:this
			});
		},

	successDevolucion:function(resp){
			Phx.CP.loadingHide();
            this.reload();
	},

	successWizard:function(resp){
			Phx.CP.loadingHide();
			resp.argument.wizard.panel.destroy()
			this.reload();
		 },

	tabsouth:[
            {
             url:'../../../sis_tesoreria/vista/solicitud_efectivo_det/SolicitudEfectivoDet.php',
             title:'Detalle',
             height:'50%',
             cls:'SolicitudEfectivoDet'
            },
            {
              url:'../../../sis_tesoreria/vista/solicitud_rendicion_det/FacturasRendicion.php',
              title:'Facturas Rendidas',
              height:'50%',
              cls:'AprobacionFacturas'
            }
       ]
	}
)
</script>
