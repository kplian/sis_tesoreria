<?php
/**
ISSUE      FORK       FECHA:              AUTOR                 DESCRIPCION
 #62      ETR       18/03/2020        MANUEL GUERRA           envio de param, para la paginacion, toolbar ayuda, botones de envio de correo y rechazo de sol por tiempo
 *
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.SolicitudEfectivoVb=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.SolicitudEfectivoVb.superclass.constructor.call(this,config);
		this.init();
        this.store.baseParams = {tipo_interfaz: 'vbSolicitudEfectivo'};
        this.load({params:{start:0, limit:50}});
		this.addButton('ant_estado',
			{	text:'Anterior',
				argument: {estado: 'anterior'},
				iconCls: 'batras',
				disabled:true,
				handler:this.antEstado,
				tooltip: '<b>Anterior</b><p>Pasa al anterior estado</p>'
			}
		);	
		
		this.addButton('fin_registro',
			{	text:'Siguientes',
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
                disabled: true,
                handler: this.loadCheckDocumentosSolWf,
                tooltip: '<b>Documentos de la Solicitud</b><br/>Los documetos de la solicitud seleccionada.'
            }
		);

		this.addButton('diagrama_gantt',
            {
                text:'Gant',
                iconCls: 'bgantt',
                disabled:true,
                handler: this.diagramGantt,
                tooltip: '<b>Diagrama Gantt de Solicitud de Efectivo</b>'
            }
        );
        //
        this.addButton('btnImprimir', {
            text : 'Imprimir',
            iconCls : 'bprint',
            disabled : true,
            handler : this.imprimirCbte,
            tooltip : '<b>Imprimir Comprobante de Caja</b><br/>Imprime el Comprobante en el formato oficial'
        });
        //#62
        this.addButton('btnRechazar', {
            text : 'Rechaza Solicitud',
            iconCls : 'bven1',
            disabled : false,
            handler : this.rechazarSol,
            tooltip : '<b>Rechaza la solicitud</b><br/>Dias desde la aprobacion de su proceso'
        });
        //#62
        this.addButton('btnEnvioCorreo', {
            text : 'Envio de correo',
            iconCls : 'bven1',
            disabled : false,
            handler : this.envioCorreo,
            tooltip : '<b>Envio de correo</b><br/>solicitudes pendientes'
        });
        //#62
        this.addButton('btnDevRep', {
            text : 'Devolver un FA/VI a banco',
            iconCls : 'bven1',
            disabled : false,
            handler : this.devBanco,
            tooltip : '<b>Devolucion a la vista Reposicion y Devolucion</b>'
        });
		if(config.filtro_directo){
			this.store.baseParams.filtro_valor = config.filtro_directo.valor;
			this.store.baseParams.filtro_campo = config.filtro_directo.campo;
		}
        this.addHelp();//#62

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
					fields: ['id_caja', 'codigo', 'desc_moneda'],
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
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['codigo']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'caja.codigo',type: 'string'},
			grid: true,
			form: true
		},	{
            config:{
                name: 'fecha_mov',
                fieldLabel: 'Fecha Aprobaciones',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                format: 'd/m/Y',
                //#62
                renderer: function (value, p, record){
                    if(record.data.diferencia == 0 || record.data.diferencia == -1 ){
                        return String.format('<h1 style="color: #008042;">{0}</h1>', value?value.dateFormat('d/m/Y'):'');
                    } else{
                        if(record.data.diferencia == -2 ) {
                            return String.format('<h1 style="color: #807f12;">{0}</h1>', value?value.dateFormat('d/m/Y'):'');
                        }else{
                            if(record.data.diferencia < -2 ) {
                                return String.format('<h1 style="color: #ff0005;">{0}</h1>', value?value.dateFormat('d/m/Y'):'');
                            }
                        }
                    }
                }
            },
            type:'DateField',
            filters:{pfiltro:'ewf.fecha_reg',type:'date'},
            id_grupo:1,
            grid:true,
            form:false
        },{
            config:{
                name: 'diferencia',
                fieldLabel: 'Dias Transcurridos',
                allowBlank: false,
                anchor: '20%',
                gwidth: 55,
                renderer: function (value, p, record){
                    if(record.data.diferencia == 0 || record.data.diferencia == -1 ){
                        return String.format('<h1 style="color: #008042;">{0}</h1>', value);
                    } else{
                        if(record.data.diferencia == -2 ) {
                            return String.format('<h1 style="color: #807f12;">{0}</h1>', value);
                        }else{
                            if(record.data.diferencia < -2 ) {
                                return String.format('<h1 style="color: #ff0005;">{0}</h1>', value);
                            }
                        }
                    }
                }
            },
            type:'Field',
            id_grupo:1,
            grid:true,
            form:false
        },
		{
			config:{
				name: 'fecha',
				fieldLabel: 'Fecha Solicitud',
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
				name: 'nro_tramite',
				fieldLabel: 'Num Tramite',
				allowBlank: false,
				anchor: '100%',
				gwidth: 200,
				maxLength:300
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
      			renderer:function(value, p, record)
                {
                    return String.format('{0}', record.data['desc_funcionario']);
                }
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
				fieldLabel: 'Monto',
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
				gwidth: 150,
				maxLength:500,
				renderer:function(value,p,record){
					if (record.data['motivo'].match(/Reposición.*/)) {
						return String.format('{0}', '<FONT COLOR="blue"><b>'+value+'</b></FONT>');
					}else{
						return String.format('{0}', '<FONT COLOR="green"><b>'+value+'</b></FONT>');
					}
				}
			},
            type:'TextField',
            filters:{pfiltro:'solefe.motivo',type:'string'},
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
		},
		{
			config:{
				name: 'id_tipo_solicitud',
				fieldLabel: 'Tipo Solicitud',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength: 10,
				renderer: function(value, p, record) {
					return String.format('{0}', record.data['nombre']);
				},
				//hidden: true
			},
            type:'TextField',
            id_grupo:1,
            grid:true,
            form:false
		},

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
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
        {name:'nombre', type: 'string'},
		{name:'id_tipo_solicitud', type: 'numeric'},
		{name:'codigo_tipo_solicitud', type: 'string'},
		{name:'nombre_tipo_solicitud', type: 'string'},
        {name:'fecha_mov', type: 'date',dateFormat:'Y-m-d'},
        {name:'diferencia', type: 'numeric'},
	],
	sortInfo:{
		field: 'id_solicitud_efectivo',
		direction: 'DESC'
	},
	bdel:false,
	bsave:false,
	bedit:false,
	bnew:false,
	preparaMenu:function(n){
        var data = this.getSelectedData();
        var tb =this.tbar;
        Phx.vista.SolicitudEfectivoVb.superclass.preparaMenu.call(this,n);
        this.getBoton('btnDevRep').hide();
        this.getBoton('diagrama_gantt').enable();
        if (data['estado']!= 'borrador'){
            this.getBoton('fin_registro').enable();
            this.getBoton('ant_estado').enable();
            this.getBoton('btnChequeoDocumentosWf').enable();
        }
        else{
            this.getBoton('fin_registro').disable();
            this.getBoton('ant_estado').disable();
        }

        if (data['estado']== 'vbcajero'){
            this.getBoton('btnImprimir').enable();
        }
        else{
            this.getBoton('btnImprimir').disable();
        }
     },

	liberaMenu:function() {
		var tb = Phx.vista.SolicitudEfectivoVb.superclass.liberaMenu.call(this);
		if (tb) {
            this.getBoton('btnDevRep').hide();
			this.getBoton('fin_registro').disable();
			this.getBoton('ant_estado').disable();
			this.getBoton('btnChequeoDocumentosWf').disable();
			this.getBoton('diagrama_gantt').disable();
			this.getBoton('btnImprimir').disable();
		}
	},
	
	antEstado:function(res){
         var rec=this.sm.getSelected();
         Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 'Estado de Wf',
        {
            modal:true,
            width:450,
            height:250
        }, { data:rec.data, estado_destino: res.argument.estado }, this.idContenedor,'AntFormEstadoWf',
        {
            config:
                [{
                    event:'beforesave',
                    delegate: this.onAntEstado,
                }],
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
     
    successEstadoSinc:function(resp){
        Phx.CP.loadingHide();
        resp.argument.wizard.panel.destroy()
        this.reload();
    },
	 
	sigEstado:function(){
		var rec=this.sm.getSelected();
		this.objWizard = Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php',
		'Estado de Wf',
		{
			modal:true,
			width:700,
			height:450
		},{data:{
			estado_wf:rec.estado,
			id_estado_wf:rec.data.id_estado_wf,
			id_proceso_wf:rec.data.id_proceso_wf									  
			}},this.idContenedor,'FormEstadoWf',
		{
			config:
			[{
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
	},
		
	successWizard:function(resp){
		Phx.CP.loadingHide();
		resp.argument.wizard.panel.destroy();
		this.reload();
		//console.log(resp.argument.wizard.Cmp.id_tipo_estado.lastSelectionText);
		if(resp.argument.wizard.Cmp.id_tipo_estado.lastSelectionText=='entregado'
		|| resp.argument.wizard.Cmp.id_tipo_estado.lastSelectionText=='ingresado'){
			if (resp.argument.id_proceso_wf) {
				Phx.CP.loadingShow();
				Ext.Ajax.request({
					url : '../../sis_tesoreria/control/SolicitudEfectivo/rEntregaEfectivo',
					params : {
						'id_proceso_wf' : resp.argument.id_proceso_wf,
						'id_estado_wf':   resp.argument.id_estado_wf,
					},
					success : this.successExport,
					failure : this.conexionFailure,
					timeout : this.timeout,
					scope : this
				});
			}
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
    
    imprimirCbte : function() {
        var rec = this.sm.getSelected();
        var data = rec.data;
        if (data) {
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url : '../../sis_tesoreria/control/SolicitudEfectivo/rEntregaEfectivo',
                params : {
                    'id_proceso_wf' : data.id_proceso_wf
                },
                success : this.successExport,
                failure : this.conexionFailure,
                timeout : this.timeout,
                scope : this
            });
        }
	},
    //#62
    rechazarSol : function() {
        var rec = this.sm.getSelected();
        var data = rec.data;
        console.log(data.nombre);
        if (data.nombre==='solicitud') {
            Ext.Msg.show({
                title:'Confirmación',
                scope: this,
                msg: 'Esta seguro de devolver a borrador? Tramite: '+ data.nro_tramite + ' Si esta de acuerdo presione el botón "Si"',
                buttons: Ext.Msg.YESNO,
                fn: function(id, value, opt) {
                    if (id == 'yes') {
                        Phx.CP.loadingShow();
                        Ext.Ajax.request({
                            url:'../../sis_tesoreria/control/SolicitudEfectivo/rechazarSol',
                            params:{
                                'id_solicitud_efectivo' : data.id_solicitud_efectivo,
                                'id_proceso_wf' : data.id_proceso_wf
                            },
                            success:this.successActual,
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
        }else{
            alert('Solo aplica a las solicitudes ');
        }
    },
    //#62
    envioCorreo : function() {
        var rec = this.sm.getSelected();
        var data = rec.data;
        console.log(data);
        //alert('ssss');
        Ext.Msg.show({
            title:'Confirmación',
            scope: this,
            msg: 'Esta seguro de enviar una notifiacion? Tramite: '+ data.nro_tramite + ' Si esta de acuerdo presione el botón "Si"',
            buttons: Ext.Msg.YESNO,
            fn: function(id, value, opt) {
                if (id == 'yes') {
                    Phx.CP.loadingShow();
                    Ext.Ajax.request({
                        url : '../../sis_tesoreria/control/SolicitudEfectivo/envioCorreo',
                        params : {
                            'id_solicitud_efectivo' : data.id_solicitud_efectivo,
                            'id_proceso_wf' : data.id_proceso_wf,
                            'id_funcionario' : data.id_funcionario,
                            'id_usuario_reg' : data.id_usuario_reg,
                            'nro_tramite': data.nro_tramite,
                        },
                        success : this.successActual,
                        failure : this.conexionFailure,
                        timeout : this.timeout,
                        scope : this
                    });
                } else {
                    opt.hide;
                }
            },
            animEl: 'elId',
            icon: Ext.MessageBox.WARNING
        }, this);
    },
    successActual:function(){
        Phx.CP.loadingHide();
        this.reload();
    },
    //#62
    addHelp: function () {
        this.addButton('lbl-color', {
            xtype: 'label',
            disabled: false,
            style: {
                position: 'absolute',
                top: '5px',
                right: 0,
                width: '90px',
                'margin-right': '10px',
                float: 'right'
            },
            html: '<div style="display: inline-flex">&nbsp;<div>Fechas de Aprobacion</div></div><br/>' +
                '<div style="display: inline-flex"><div style="background-color:#008042;width:10px;height:10px;"></div>&nbsp;<div>En proceso</div></div><br/>' +
                '<div style="display: inline-flex"><div style="background-color:#807f12;width:10px;height:10px;"></div>&nbsp;<div>Por fenecer</div></div><br/>' +
                '<div style="display: inline-flex"><div style="background-color:#ff0005;width:10px;height:10px;"></div>&nbsp;<div>Vencidos</div></div>'
        });
    },
    //devBanco
    devBanco : function() {
        var rec = this.sm.getSelected();
        var data = rec.data;
        console.log(data);
        if (data.nombre!=='solicitud') {
            Ext.Msg.show({
                title:'Confirmación',
                scope: this,
                msg: 'Esta seguro de devolver a banco? Tramite: '+ data.nro_tramite + ' Si esta de acuerdo presione el botón "Si"',
                buttons: Ext.Msg.YESNO,
                fn: function(id, value, opt) {
                    if (id == 'yes') {
                        Phx.CP.loadingShow();
                        Ext.Ajax.request({
                            url:'../../sis_tesoreria/control/SolicitudEfectivo/devolverSol',
                            params:{
                                'id_solicitud_efectivo' : data.id_solicitud_efectivo,
                                'id_proceso_wf' : data.id_proceso_wf
                            },
                            success:this.successActual,
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
        }else{
            alert('Solo aplica a las solicitudes ');
        }
    },
    //
	tabsouth:[
            { 
             url:'../../../sis_tesoreria/vista/solicitud_efectivo_det/SolicitudEfectivoDetVb.php',
             title:'Detalle', 
             height:'50%',
             cls:'SolicitudEfectivoDetVb'
            }    
       ]
	}
)
</script>
		
		