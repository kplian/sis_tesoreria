<?php
/**
*@package pXP
*@file SolicitudEfectivoSinDet.php
*@author  (gsarmiento)
*@date 24-11-2015 12:59:51
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.SolicitudEfectivoSinDet=Ext.extend(Phx.gridInterfaz,{

	vista:'SinDetalle',
	
	gruposBarraTareas:[{name:'borrador',title:'<H1 align="center"><i class="fa fa-thumbs-o-down"></i> Borradores</h1>',grupo:0,height:0},
                       {name:'iniciado',title:'<H1 align="center"><i class="fa fa-eye"></i> Iniciados</h1>',grupo:1,height:0},
					   {name:'entregado',title:'<H1 align="center"><i class="fa fa-file-o"></i> Entregados</h1>',grupo:2,height:0},
                       {name:'finalizado',title:'<H1 align="center"><i class="fa fa-thumbs-o-up"></i> Finalizados</h1>',grupo:3,height:0}],
	
	actualizarSegunTab: function(name, indice){
		
    	if(this.finCons){
    		 this.store.baseParams.pes_estado = name;
    	     this.load({params:{start:0, limit:this.tam_pag}});
    	   }
    },
	
	beditGroups: [0],
    bdelGroups:  [0],
    bactGroups:  [0,1,2,3],
    btestGroups: [0],
    bexcelGroups: [0,1,2,3],
	
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
		
		this.Atributos[this.getIndAtributo('tiempo_rendicion')].config.renderer = function(value, p, record) {
					
					if (record.data.estado == 'entregado' || record.data.estado == 'finalizado') {
						if(record.data.dias_no_rendido < 0){
							return String.format("<font color = 'red'>Dias máximo rendir: {0}</font><br>"+
											 "<font color = 'red' >Dias restantes:{1}</font><br>"											 
											 ,record.data.dias_maximo_rendicion, record.data.dias_no_rendido
											 );
						}else{
							return String.format("<font color = 'green'>Dias máximo rendir: {0}</font><br>"+
											 "<font color = 'green' >Dias restantes:{1}</font><br>"											 
											 ,record.data.dias_maximo_rendicion, record.data.estado == 'finalizado'?0:record.data.dias_no_rendido
											 );
						}
					} 
					else {
						return String.format('');
					}
			};
			
    	//llama al constructor de la clase padre
		Phx.vista.SolicitudEfectivoSinDet.superclass.constructor.call(this,config);		
		this.iniciarEventos();
		
		this.addButton('fin_registro',
			{	text:'Siguiente',
				iconCls: 'badelante',
				grupo:[0,2],
				disabled:true,
				handler:this.sigEstado,
				tooltip: '<b>Siguiente</b><p>Pasa al siguiente estado</p>'
			}
		);
		
		this.addButton('btnRendicion', {
			text : 'Rendicion Efectivo',
			iconCls : 'bballot',
			grupo:[2],
			disabled : true,
			handler : this.onBtnRendicion,
			tooltip : '<b>Rendicion</b>'
		});

		this.addButton('btnDevol', {
			text : 'Devolucion Efectivo',
			iconCls : 'bballot',
			grupo:[2],
			disabled : true,
			handler : this.onBtnDevolucion,
			tooltip : '<b>Devolucion Sin Añadir Facturas</b>'
		});

		this.addButton('btnRendiciones', {
			text : 'Rendiciones Enviadas',
			iconCls : 'bballot',
			grupo:[2,3],
			disabled : true,
			handler : this.onBtnRendiciones,
			tooltip : '<b>Rendiciones</b>'
		});

		this.addButton('btnChequeoDocumentosWf',
			{
				text: 'Documentos',
				iconCls: 'bchecklist',
				grupo:[0,1,2,3],
				disabled: true,
				handler: this.loadCheckDocumentosSolWf,
				tooltip: '<b>Documentos de la Solicitud</b><br/>Los documetos de la solicitud seleccionada.'
			}
		);
		
		this.addButton('ant_estado',
			{	text:'Anterior',
				argument: {estado: 'anterior'},
				iconCls: 'batras',
				disabled:true,
				grupo:[3],
				handler:this.antEstado,
				tooltip: '<b>Anterior</b><p>Pasa al anterior estado</p>'
			}
		);

		this.addButton('diagrama_gantt',
            {
                grupo:[0,1,2,3],
                text:'Gant',
                iconCls: 'bgantt',
                disabled:true,
                handler:this.diagramGantt,
                tooltip: '<b>Diagrama Gantt de Solicitud de Efectivo</b>'
            }
		);

		/*
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
		
		this.addButton('btnRendicionEfectivo', {
			text : 'Rendicion Efectivo',
			iconCls : 'bpdf',
			disabled : false,
			handler : this.onBtnRendicionEfectivo,
			tooltip : '<b>Rendicion Efectivo</b>'
		});
		*/
		this.init();
		this.store.baseParams.pes_estado = 'borrador';
		this.store.baseParams.tipo_interfaz = this.vista;
		
		this.load({params:{start:0, limit:this.tam_pag, tipo_interfaz:this.vista}})
		
		this.finCons = true;
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
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'tipo_solicitud'
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
					baseParams: {par_filtro: 'caja.codigo', tipo_interfaz:'cajaAbierto', con_detalle:'no'}
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
				anchor: '80%',
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
			grid: false,
			form: false
		},		
		{
			config:{
				name: 'fecha',
				fieldLabel: 'Fecha Solicitud',
				allowBlank: false,
				anchor: '80%',
				gwidth: 90,
				format: 'd/m/Y',
				value : new Date(),
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
				name: 'fecha_entrega',
				fieldLabel: 'Fecha Entrega',
				allowBlank: false,
				anchor: '80%',
				gwidth: 90,
				format: 'd/m/Y',
				value : new Date(),
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'solefe.fecha_entrega',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'tiempo_rendicion',
				fieldLabel: 'Dias Rendicion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 120,
				maxLength:1179650
			},
				type:'NumberField',
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'nro_tramite',
				fieldLabel: 'Num Tramite',
				allowBlank: false,
				anchor: '80%',
				gwidth: 150,
				maxLength:50
			},
				type:'TextField',
				filters:{pfiltro:'solefe.nro_tramite',type:'string'},
				bottom_filter:true,
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
				anchor: '80%',
   				valueField: 'id_funcionario',
   			    gdisplayField: 'desc_funcionario',
				baseParams: { es_combo_solicitud : 'si' },   			    
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
				grid:true,
				form:true
		},
		{
			config:{
				name: 'monto',
				fieldLabel: 'Solicitado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 60,
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
	title:'Solicitud Efectivo Sin Detalle',
	ActSave:'../../sis_tesoreria/control/SolicitudEfectivo/insertarSolicitudEfectivo',
	ActDel:'../../sis_tesoreria/control/SolicitudEfectivo/eliminarSolicitudEfectivo',
	ActList:'../../sis_tesoreria/control/SolicitudEfectivo/listarSolicitudEfectivo',
	id_store:'id_solicitud_efectivo',
	fields: [
		{name:'id_solicitud_efectivo', type: 'numeric'},
		{name:'id_caja', type: 'numeric'},
		{name:'codigo', type: 'string'},
		{name:'id_moneda', type: 'numeric'},
		{name:'id_depto', type: 'numeric'},
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
		{name:'fecha_entrega', type: 'date',dateFormat:'Y-m-d'},
		{name:'dias_maximo_rendicion', type: 'numeric'},
		{name:'dias_no_rendido', type: 'numeric'},
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
		 
	 preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;

          this.getBoton('btnChequeoDocumentosWf').enable();
          Phx.vista.SolicitudEfectivoSinDet.superclass.preparaMenu.call(this,n);
          if (data['estado'] == 'borrador'){
              this.getBoton('fin_registro').enable();
			  this.getBoton('edit').enable();
			  this.getBoton('del').enable();
			  this.getBoton('btnRendicion').disable();
			  this.getBoton('diagrama_gantt').enable();
			  //this.getBoton('btnReciboEntrega').disable();
			  //this.getBoton('btnRendicionEfectivo').disable();
          }else if (data['estado'] == 'entregado'){
              this.getBoton('fin_registro').enable();
			  this.getBoton('edit').disable();
			  this.getBoton('del').disable();
			  this.getBoton('diagrama_gantt').enable();
			  this.getBoton('btnRendiciones').enable();
			  //this.getBoton('btnRendicionEfectivo').enable();
			  if(data.dias_no_rendido < 0)
				//this.getBoton('btnRendicion').disable();
			  //else
				this.getBoton('btnRendicion').enable();
			  //this.getBoton('btnReciboEntrega').enable();
			  
          }else if (data['estado'] == 'finalizado'){
			  this.getBoton('fin_registro').disable();
			  this.getBoton('edit').disable();
			  this.getBoton('del').disable();
			  this.getBoton('btnRendicion').disable();
			  this.getBoton('btnRendiciones').enable();
              this.getBoton('diagrama_gantt').enable();
		  }else if(data['estado'] == 'vbjefe'){
			  this.getBoton('fin_registro').disable();
			  this.getBoton('edit').disable();
			  this.getBoton('del').disable();
			  this.getBoton('btnRendicion').disable();
			  this.getBoton('diagrama_gantt').enable();
			  //this.getBoton('btnReciboEntrega').disable();
			  //this.getBoton('btnRendicionEfectivo').disable();
		  }else{
              this.getBoton('fin_registro').disable();
			  this.getBoton('edit').disable();
			  this.getBoton('del').disable();
			  this.getBoton('btnRendicion').disable();
			  this.getBoton('diagrama_gantt').enable();
			  //this.getBoton('btnReciboEntrega').disable();
			  //this.getBoton('btnRendicionEfectivo').disable();
          }

		  if(data['saldo'] == 0.00){
			  this.getBoton('btnDevol').disable();
			  this.getBoton('btnRendicion').disable();
		  }else{
			  this.getBoton('btnDevol').enable();
			  this.getBoton('btnRendicion').enable();
		  }
     },

	liberaMenu:function(){
		var tb = Phx.vista.SolicitudEfectivoSinDet.superclass.liberaMenu.call(this);
		if(tb) {
			this.getBoton('btnChequeoDocumentosWf').disable();
			this.getBoton('diagrama_gantt').disable();
			this.getBoton('fin_registro').disable();
			this.getBoton('btnRendicion').disable();
			this.getBoton('btnRendiciones').disable();
			this.getBoton('btnDevol').disable();
		}
	},
	 
	 iniciarEventos : function(){		 
		this.cmpFecha=this.getComponente('fecha');
		this.cmpFuncionario=this.getComponente('id_funcionario');
		this.cmpFuncionario.store.baseParams.fecha = this.cmpFecha.getValue().dateFormat(this.cmpFecha.format);
	 },
	 
	 onButtonEdit: function(){
		Phx.vista.SolicitudEfectivoSinDet.superclass.onButtonEdit.call(this);
		this.Cmp.tipo_solicitud.setValue('solicitud');
	 },
	 
	 onButtonNew: function(){
		Phx.vista.SolicitudEfectivoSinDet.superclass.onButtonNew.call(this);
		this.cmpFecha.setValue(new Date());
		this.Cmp.tipo_solicitud.setValue('solicitud');
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

	onBtnRendiciones : function() {
		var rec = this.sm.getSelected();
		Phx.CP.loadWindows('../../../sis_tesoreria/vista/rendicion_efectivo/RendicionEfectivoSolicitante.php', 'RendicionEfectivoSolicitante', {
			modal : true,
			width : '95%',
			height : '95%',
		}, rec.data, this.idContenedor, 'RendicionEfectivoSolicitante');
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
		
	onBtnSolicitud : function() {
		var rec=this.sm.getSelected();
        Ext.Ajax.request({
            url:'../../sis_tesoreria/control/SolicitudEfectivo/reporteSolicitudEfectivo',
            params:{'id_proceso_wf':rec.data.id_proceso_wf,'estado':rec.data.estado},
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
            params:{'id_proceso_wf':rec.data.id_proceso_wf},
            success: this.successExport,
            failure: this.conexionFailure,
            timeout:this.timeout,
            scope:this
        }); 
	},
	
	onBtnRendicionEfectivo : function() {
		var rec=this.sm.getSelected();
        Ext.Ajax.request({
            url:'../../sis_tesoreria/control/SolicitudEfectivo/reporteRendicionEfectivo',
            params:{'id_proceso_wf':rec.data.id_proceso_wf},
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
	 
	 antEstado:function(res){
         var rec=this.sm.getSelected();
         Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/AntFormEstadoWf.php',
            'Estado de Wf',
            {
                modal:true,
                width:450,
                height:250
            }, { data:rec.data, estado_destino: res.argument.estado }, this.idContenedor,'AntFormEstadoWf',
            {
                config:[{
                          event:'beforesave',
                          delegate: this.onAntEstado,
                        }
                        ],
               scope:this
             })
     },
   
     onAntEstado: function(wizard,resp){
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url:'../../sis_tesoreria/control/SolicitudEfectivo/anteriorEstadoSolicitudEfectivo',
                params:{
                        id_proceso_wf: resp.id_proceso_wf,
                        id_estado_wf:  resp.id_estado_wf,  
                        obs: resp.obs,
                        estado_destino: resp.estado_destino
                 },
                argument:{wizard:wizard},  
                success:this.successEstadoSinc,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });
           
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
	 
	 successEstadoSinc:function(resp){
        Phx.CP.loadingHide();
        resp.argument.wizard.panel.destroy()
        this.reload();
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
	 
	bdel:true,
	bsave:true
	}
)
</script>
		
		