<?php
/**
*@package pXP
*@file gen-TsLibroBancos.php
*@author  (admin)
*@date 01-12-2013 09:10:17
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.TsLibroBancos=Ext.extend(Phx.gridInterfaz,{
	
	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.TsLibroBancos.superclass.constructor.call(this,config);
		this.init();
		this.grid.getTopToolbar().disable();
		this.grid.getBottomToolbar().disable();
		this.iniciarEventos();
		
		this.addButton('btnClonar',
			{
				text: 'Clonar',
				iconCls: 'bdocuments',
				disabled: false,
				handler: this.clonar,
				tooltip: '<b>Clonar</b><br/>Clonar Registro'
			}
		);
		
		this.addButton('btnCheque',
			{
				text: 'Cheque 1',
				iconCls: 'bprintcheck',
				disabled: false,
				handler: this.imprimirCheque,
				tooltip: '<b>Cheque</b><br/>Imprimir cheque en el tamaño antiguo'
			}
		);
		
		
		this.addButton('btnCheque2',
			{
				text: 'Cheque 2',
				iconCls: 'bprintcheck',
				disabled: false,
				handler: this.imprimirCheque2,
				tooltip: '<b>Cheque</b><br/>Imprimir cheque en el tamaño nuevo'
			}
		);
		
		this.addButton('btnCheque3',
			{
				text: 'Cheque 3',
				iconCls: 'bprintcheck',
				disabled: false,
				handler: this.imprimirCheque3,
				tooltip: '<b>Cheque</b><br/>Imprimir cheque en el tamaño nuevo'
			}
		);
		
		this.addButton('btnMemoramdum',
			{
				text: 'Memo',
				iconCls: 'bword',
				disabled: false,
				handler: this.memoramdum,
				tooltip: '<b>Memo</b><br/>Imprimir memoramdum de asignacion de fondo'
			}
		);
		
		this.addButton('btnNotificacion',
			{
				text: 'Notificacion',
				iconCls: 'bsendmail',
				disabled: false,
				handler: this.enviarNotificacion,
				tooltip: '<b>Notificacion</b><br/>Envia email de notificacion al solicitante'
			}
		);
		
		this.addButton('ant_estado',{
		  argument: {estado: 'anterior'},
		  text:'Anterior',
		  iconCls: 'batras',
		  disabled:true,
		  handler:this.antEstado,
		  tooltip: '<b>Pasar al Anterior Estado</b>'
		  }
		);
		
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
				disabled: true,
				handler: this.loadCheckDocumentosSolWf,
				tooltip: '<b>Documentos de la Solicitud</b><br/>Subir los documetos requeridos en la solicitud seleccionada.'
			}
		);
		
		this.addButton('btnVistaPrevia',
			{
				text: 'Cheque Vista Previa',
				iconCls: 'bprintcheck',
				disabled: true,
				handler: this.vistaPrevia,
				tooltip: '<b>Vista Previa Cheque</b><br/>Vista Previa Cheque'
			}
		);

		this.addButton('diagrama_gantt',{text:'',iconCls: 'bgantt',disabled:true,handler:this.diagramGantt,tooltip: '<b>Diagrama Gantt de proceso macro</b>'});
		
		this.addButton('btnChequesAsociados',
		{
			text: 'Cheques Asociados',
			iconCls: 'bmoney',
			disabled: true,
			handler: this.onChequesAsociados,
			tooltip: '<b>Cheques Asociados</b><br/>Cheques Asociados'
		}
		);
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_libro_bancos'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_cuenta_bancaria'
			},
			type:'Field',
			form:true 
		},
		{
            config:{
                name: 'id_depto',
                fieldLabel: 'Depto',
                allowBlank: false,
                anchor: '80%',
                origen: 'DEPTO',
                tinit: false,
                baseParams:{tipo_filtro:'DEPTO_UO',estado:'activo',codigo_subsistema:'TES',modulo:'LB'},//parametros adicionales que se le pasan al store
                gdisplayField:'nombre',
                gwidth: 100
            },
            type:'ComboRec',
            filters:{pfiltro:'dep.nombre',type:'string'},
            id_grupo:1,
            grid:false,
            form:true
        },
		{
			config:{
				name: 'fecha',
				fieldLabel: 'Fecha',
				allowBlank: false,
				anchor: '80%',
				gwidth: 90,
				format: 'd/m/Y', 
				renderer:function (value,p,record){
					//return value?value.dateFormat('d/m/Y'):''
					if(value == null)
						value = '';
					else 
						value = value.dateFormat('d/m/Y');
					
					if(record.data['sistema_origen']=='FONDOS_AVANCE'){
						return String.format('{0}', '<FONT COLOR="'+record.data['color']+'"><b>'+'F.A. '+value+'</b></FONT>');
					}else{
						if(record.data['sistema_origen']=='KERP')						
							return String.format('{0}', '<FONT COLOR="'+record.data['color']+'"><b>'+'PG '+value+'</b></FONT>');					
						else
							return String.format('{0}', '<FONT COLOR="'+record.data['color']+'"><b>'+value+'</b></FONT>');
					}
				}
			},
				type:'DateField',
				filters:{pfiltro:'lban.fecha',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'a_favor',
				fieldLabel: 'A favor de',
				allowBlank: false,
				anchor: '80%',
				gwidth: 125,
				maxLength:100
			},
				type:'TextField',
				filters:{pfiltro:'lban.a_favor',type:'string'},
				bottom_filter: true,
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'detalle',
				fieldLabel: 'Detalle',
				allowBlank: false,
				anchor: '80%',
				gwidth: 125,
				maxLength:400
			},
				type:'TextArea',
				filters:{pfiltro:'lban.detalle',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},		
		{
			config:{
				name: 'observaciones',
				fieldLabel: 'Observaciones',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
				type:'TextArea',
				filters:{pfiltro:'lban.observaciones',type:'string'},
				id_grupo:1,				
				bottom_filter: true,
				grid:true,
				form:true
		},		
		{
			config:{
				name: 'nro_liquidacion',
				fieldLabel: 'Nro Liquidacion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:20
			},
				type:'TextField',
				filters:{pfiltro:'lban.nro_liquidacion',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'nro_comprobante',
				fieldLabel: 'Nro Comprobante',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:20
			},
				type:'TextField',
				filters:{pfiltro:'lban.nro_comprobante',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'comprobante_sigma',
				fieldLabel: 'Comprobante Sigma',
				allowBlank: true,
				anchor: '80%',
				gwidth: 125,
				maxLength:50
			},
				type:'TextField',
				filters:{pfiltro:'lban.comprobante_sigma',type:'string'},
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
				gwidth: 100,
				store:new Ext.data.ArrayStore({
                            fields: ['variable', 'valor'],
                            data : [ ['cheque','Cheque'],
									 ['deposito','Depósito'],
									 ['debito_automatico','Débito Automativo'],
									 ['transferencia_carta','Transferencia con Carta']
                                    ]
                                    }),
				valueField: 'variable',
				displayField: 'valor'
			},
			type:'ComboBox',
			id_grupo:1,
			filters:{	
					 type: 'list',
					  pfiltro:'lban.tipo',
					 options: ['cheque','deposito','debito_automatico','transferencia_carta'],	
				},
			grid:true,
			form:true
		},
		{
			config:{
				name: 'nro_cheque',
				fieldLabel: 'Nro Cheque',
				allowBlank: true,
				anchor: '80%',
				gwidth: 80,
				maxLength:6
			},
				type:'NumberField',
				filters:{pfiltro:'lban.nro_cheque',type:'numeric'},
				bottom_filter: true,
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'importe_deposito',
				fieldLabel: 'Importe Debe',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:1310722
			},
				type:'NumberField',
				filters:{pfiltro:'lban.importe_deposito',type:'numeric'},
				bottom_filter: true,
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'importe_cheque',
				fieldLabel: 'Importe Haber',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:1310722
			},
				type:'NumberField',
				filters:{pfiltro:'lban.importe_cheque',type:'numeric'},
				bottom_filter: true,
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'saldo_deposito',
				fieldLabel: 'Saldo Depósito',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:1310722
			},
				type:'NumberField',
				filters:{pfiltro:'lban.importe_cheque',type:'numeric'},
				bottom_filter: true,
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name:'origen',
				fieldLabel:'Origen',
				allowBlank:false,
				emptyText:'Tipo...',
				typeAhead: true,
				triggerAction: 'all',
				lazyRender:true,
				mode: 'local',
				valueField: 'estilo',
				gwidth: 60,
				store:['CBB','SRZ','LPB','TJA','SRE','CIJ','TDD','UYU','MIA','MAD']
			},
			type:'ComboBox',
			id_grupo:1,
			filters:{	
					 type: 'list',
					  pfiltro:'lban.origen',
					 options: ['CBB','SRZ','TJA','SRE','CIJ','TDD','UYU','ENDESIS','MIA','MAD'],	
				},
			grid:true,
			form:true
		},
		{
			config:{
				name: 'estado',
				fieldLabel: 'estado',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:20
			},
				type:'TextField',
				filters:{pfiltro:'lban.estado',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
            config:{
                name:'id_finalidad',
                fieldLabel:'Finalidad',
                allowBlank:false,
                emptyText:'Finalidad...',
                store: new Ext.data.JsonStore({
                         url: '../../sis_tesoreria/control/Finalidad/listarFinalidadCuentaBancaria',
                         id: 'id_finalidad',
                         root: 'datos',
                         sortInfo:{
                            field: 'nombre_finalidad',
                            direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_finalidad','nombre_finalidad','color'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams:{par_filtro:'nombre_finalidad', vista: 'vista'}
                    }),
                valueField: 'id_finalidad',
                displayField: 'nombre_finalidad',
                //tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{nro_cuenta}</b></p><p>{denominacion}</p></div></tpl>',
                hiddenName: 'id_finalidad',
                forceSelection:true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:10,
                queryDelay:1000,
                listWidth:600,
                resizable:true,
                anchor:'80%',
                renderer : function(value, p, record) {
					//return String.format(record.data['nombre_finalidad']);
					return String.format('{0}', '<FONT COLOR="'+record.data['color']+'"><b>'+record.data['nombre_finalidad']+'</b></FONT>');
				}
            },
            type:'ComboBox',
            id_grupo:0,
            /*filters:{   
                        pfiltro:'fin.nombre_finalidad',
                        type:'string'
                    },*/
            grid:true,
            form:true
        },
		{
			config: {
				name: 'id_libro_bancos_fk',
				fieldLabel: 'Deposito Asociado',
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
				hiddenName: 'id_libro_bancos_fk',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 110,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', (record.data['id_libro_bancos_fk']==null)?'':record.data['id_libro_bancos_fk']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'lban.id_libro_bancos_fk',type: 'string'},
			grid: true,
			form: true
		},		
		{
            config:{
                name: 'num_tramite',
                fieldLabel: 'Num. Tramite',
                allowBlank: true,
                anchor: '80%',
                gwidth: 150,
                maxLength:200
            },
            type:'TextField',
            filters:{pfiltro:'lban.num_tramite',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
		{
			config:{
				name: 'indice',
				fieldLabel: 'indice',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1310722
			},
				type:'NumberField',
				filters:{pfiltro:'lban.indice',type:'numeric'},
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
				filters:{pfiltro:'lban.estado_reg',type:'string'},
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
				filters:{pfiltro:'lban.fecha_reg',type:'date'},
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
				type:'NumberField',
				filters:{pfiltro:'usr_reg',type:'string'},
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
				filters:{pfiltro:'lban.fecha_mod',type:'date'},
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
				type:'NumberField',
				filters:{pfiltro:'usu2.cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Depósitos',
	ActSave:'../../sis_tesoreria/control/TsLibroBancos/insertarTsLibroBancos',
	ActDel:'../../sis_tesoreria/control/TsLibroBancos/eliminarTsLibroBancos',
	ActList:'../../sis_tesoreria/control/TsLibroBancos/listarTsLibroBancos',
	id_store:'id_libro_bancos',
	fields: [
		{name:'id_libro_bancos', type: 'numeric'},
		{name:'num_tramite', type: 'string'},
		{name:'id_cuenta_bancaria', type: 'numeric'},
		{name:'num_tramite', type: 'string'},
		{name:'fecha', type: 'date',dateFormat:'Y-m-d'},
		{name:'a_favor', type: 'string'},
		{name:'id_proceso_wf', type: 'numeric'},
		{name:'id_estado_wf', type: 'numeric'},
		{name:'id_depto', type: 'numeric'},
		{name:'nombre', type: 'string'},
		{name:'nro_cheque', type: 'numeric'},
		{name:'importe_deposito', type: 'numeric'},
		{name:'nro_liquidacion', type: 'string'},
		{name:'detalle', type: 'string'},
		{name:'origen', type: 'string'},
		{name:'observaciones', type: 'string'},
		{name:'importe_cheque', type: 'numeric'},
		{name:'id_libro_bancos_fk', type: 'numeric'},
		{name:'estado', type: 'string'},
		{name:'nro_comprobante', type: 'string'},
		{name:'comprobante_sigma', type: 'string'},
		{name:'indice', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'tipo', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'id_depto', type: 'numeric'},
		{name:'nombre', type: 'string'},
		{name:'fecha_cheque_literal', type: 'string'},
		{name:'id_finalidad', type: 'numeric'},
		{name:'nombre_finalidad', type: 'string'},
		{name:'color', type: 'string'},
		{name:'saldo_deposito', type: 'numeric'},
		{name:'nombre_regional', type: 'string'},
		{name:'sistema_origen', type: 'string'}
	],
	sortInfo:{
		field: 'fecha',
		direction: 'DESC'
	},
	bdel:true,
	bsave:false,
	bnew:true,
	bedit:true,
	fheight:'80%',
	
	loadValoresIniciales:function(){
		Phx.vista.TsLibroBancos.superclass.loadValoresIniciales.call(this);
		this.cmpIdCuentaBancaria.setValue(this.maestro.id_cuenta_bancaria);		
	},
	
	onButtonNew:function(){
		Phx.vista.TsLibroBancos.superclass.onButtonNew.call(this); 	    
		this.cmpIdLibroBancosFk.setValue(this.maestro.id_libro_bancos);
		this.cmpDepto.enable();
		this.cmpFecha.enable();
		this.cmpTipo.enable();
	},
		
	clonar:function(){
		
		var data = this.getSelectedData();
		var NumSelect=this.sm.getCount();
		
		if(NumSelect != 0)
		{
			this.onButtonNew();
			
			this.cmpAFavor = this.getComponente('a_favor');
			this.cmpObservaciones = this.getComponente('observaciones');
			this.cmpDetalle = this.getComponente('detalle');		
			this.cmpNroLiquidacion = this.getComponente('nro_liquidacion');
			this.cmpIdLibroBancosFk = this.getComponente('id_libro_bancos_fk');				
			
			this.cmpTipo.setValue(data.tipo);
			this.cmpAFavor.setValue(data.a_favor);
			this.cmpObservaciones.setValue(data.observaciones);
			this.cmpDetalle.setValue(data.detalle);
			this.cmpNroLiquidacion.setValue(data.nro_liquidacion);
			this.cmpIdLibroBancosFk.setValue(data.id_libro_bancos_fk);
			this.cmpImporteDeposito.setValue(0);
			this.cmpImporteCheque.setValue(0);
			var record = this.cmpTipo.getStore();
			record.data.variable = data.tipo;
			
			this.cmpTipo.fireEvent('select',this,record);
			
			if(data.tipo=='deposito'){			
				this.ocultarComponente(this.cmpImporteCheque);
				this.mostrarComponente(this.cmpImporteDeposito);				
			}
			else{
				this.mostrarComponente(this.cmpImporteCheque);
				this.ocultarComponente(this.cmpImporteDeposito);
			}
		}
		else
		{
			Ext.MessageBox.alert('Alerta', 'Antes debe seleccionar un item a clonar.');
		}
	},
	
	preparaMenu:function(n){
		  var data = this.getSelectedData();
		  //var tb =this.tbar;
		  
		  Phx.vista.TsLibroBancos.superclass.preparaMenu.call(this,n); 
		  
		  if(data['id_proceso_wf'] !== null){
			
			  if(data['tipo'] == 'cheque'){				  
				  this.getBoton('btnChequeoDocumentosWf').enable();
				  if(data['estado']=='borrador'){
					this.getBoton('btnMemoramdum').disable();
					this.getBoton('btnNotificacion').disable();				  
					this.getBoton('btnCheque').disable();
					this.getBoton('btnCheque2').disable();				
					this.getBoton('btnVistaPrevia').disable();
					this.getBoton('edit').enable();
					this.getBoton('del').enable();
					this.getBoton('ant_estado').disable();
					this.getBoton('fin_registro').enable();					
				  }else{
					this.getBoton('del').disable();
					this.getBoton('btnVistaPrevia').enable();
					if(data['estado']=='cobrado'||data['estado']=='reingresado'||data['estado']=='anulado'){
						this.getBoton('edit').disable();							
						this.getBoton('btnCheque').disable();
						this.getBoton('btnCheque2').disable();						
						this.getBoton('ant_estado').enable();
						this.getBoton('fin_registro').disable();
					}else{
						this.getBoton('edit').enable();						
						this.getBoton('btnCheque').enable();
						this.getBoton('btnCheque2').enable();						
						this.getBoton('ant_estado').enable();
						this.getBoton('fin_registro').enable();
					}  
					if(data['sistema_origen']=='FONDOS_AVANCE'){						
						this.getBoton('btnMemoramdum').enable();
						if(data['notificado']=='no')
							this.getBoton('btnNotificacion').enable();
						else
							this.getBoton('btnNotificacion').disable();
					}else{
						this.getBoton('btnMemoramdum').disable();
						this.getBoton('btnNotificacion').disable();
					}
				  }
				  
			  }else{
				  this.getBoton('btnMemoramdum').disable();
				  this.getBoton('btnNotificacion').disable();				  
				  this.getBoton('btnCheque').disable();
				  this.getBoton('btnCheque2').disable();				
				  this.getBoton('btnVistaPrevia').disable();
				  this.getBoton('btnChequeoDocumentosWf').enable();
				  if(data['estado']=='borrador'){
					this.getBoton('edit').enable();
					this.getBoton('del').enable();
					this.getBoton('ant_estado').disable();
					this.getBoton('fin_registro').enable();
				  }else{
					this.getBoton('del').disable();
					this.getBoton('fin_registro').disable();

					if(data['estado']=='transferido'){
						this.getBoton('edit').disable();
						this.getBoton('ant_estado').disable();
					}else{
						this.getBoton('edit').enable();
						this.getBoton('ant_estado').enable();
					}

				  	if(data['estado']=='sigep_swift'){
					  	this.getBoton('fin_registro').enable();
				  	}
				  }
			  }
			  
		  }else{
				this.getBoton('btnChequeoDocumentosWf').disable();
				this.getBoton('fin_registro').disable();
				this.getBoton('btnMemoramdum').disable();
				this.getBoton('btnNotificacion').disable();
				this.getBoton('ant_estado').disable();
				this.getBoton('btnCheque').disable();
				this.getBoton('btnCheque2').disable();				
				this.getBoton('btnVistaPrevia').disable();
				this.getBoton('edit').disable();
				this.getBoton('del').disable();
		  }		  
	 },
	 
	 onButtonEdit:function(){
		Phx.vista.TsLibroBancos.superclass.onButtonEdit.call(this);
		//this.cmpTipo.disable();
		var data = this.getSelectedData();			
		
		if(data.tipo=='cheque'){
			this.mostrarComponente(this.cmpNroCheque);
			this.mostrarComponente(this.cmpImporteCheque);
		}
		else{
			this.ocultarComponente(this.cmpNroCheque);
			if(data.tipo=='deposito'){
				this.mostrarComponente(this.cmpImporteDeposito);
				this.ocultarComponente(this.cmpImporteCheque);
			}
			else{
				this.mostrarComponente(this.cmpImporteCheque);
				this.ocultarComponente(this.cmpImporteDeposito);
			}
		}
		if(data.estado=='impreso' || data.estado=='entregado' || data.estado=='cobrado'|| data.estado=='depositado'){
			this.cmpDepto.disable();
			this.cmpFecha.disable();
			this.cmpImporteCheque.disable();
			this.cmpImporteDeposito.disable();
			this.cmpNroCheque.disable();
		}else{
			this.cmpDepto.enable();
			this.cmpFecha.enable();
			this.cmpImporteCheque.enable();
			this.cmpNroCheque.enable();
		}
	},
		
	antEstado:function(res,eve)
	{                   
		var d= this.sm.getSelected().data;
		Phx.CP.loadingShow();
		var operacion = 'cambiar';
		operacion=  res.argument.estado == 'inicio'?'inicio':operacion; 
		
		Ext.Ajax.request({
			url:'../../sis_tesoreria/control/TsLibroBancos/anteriorEstadoLibroBancos',
			params:{id_libro_bancos:d.id_libro_bancos,
					id_proceso_wf:d.id_proceso_wf,
					id_estado_wf:d.id_estado_wf, 				
					operacion: operacion},
			success:this.successSinc,
			failure: this.conexionFailure,
			timeout:this.timeout,
			scope:this
		});     
	},
		
	successSinc:function(resp){
		Phx.CP.loadingHide();
		var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
		
		if(reg.ROOT.datos.resultado!='falla'){                
			this.reload();
		 }else{
			alert(reg.ROOT.datos.mensaje)
		}
	},
	
	enviarNotificacion:function(res,eve)
	{                   
		var d= this.sm.getSelected().data;
		Phx.CP.loadingShow();
		
		Ext.Ajax.request({
			url:'../../sis_tesoreria/control/TsLibroBancos/enviarNotificacion',
			params:{id_libro_bancos:d.id_libro_bancos,				
					operacion: 'notificar'},
			success:this.successSinc,
			failure: this.conexionFailure,
			timeout:this.timeout,
			scope:this
		});     
	},

	diagramGantt:function (){
		var data=this.sm.getSelected().data.id_proceso_wf;
		Phx.CP.loadingShow();
		Ext.Ajax.request({
			url:'../../sis_workflow/control/ProcesoWf/diagramaGanttTramite',
			params:{'id_proceso_wf':data},
			success:this.successExport,
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
									   id_proceso_wf:rec.data.id_proceso_wf,
									   fecha_ini:rec.data.fecha_tentativa
									  
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
			url:'../../sis_tesoreria/control/TsLibroBancos/siguienteEstadoLibroBancos',
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
	
	successWizard:function(resp){
		Phx.CP.loadingHide();
		resp.argument.wizard.panel.destroy()
		this.reload();
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
		
	memoramdum : function(){
		var data = this.getSelectedData();
		var NumSelect=this.sm.getCount();
		
		if(NumSelect != 0)
		{		
			var data='id='+ data.id_libro_bancos;  			
			window.open('http://sms.obairlines.bo/ReportesPXP/Home/MemorandumFondosEnAvance?'+data);				
		}
		else
		{
			Ext.MessageBox.alert('Alerta', 'Antes debe seleccionar un item.');
		}
	},
	
	imprimirCheque : function(){
		var NumSelect=this.sm.getCount();
		
		if(NumSelect!=0)
		{
			if(confirm('¿Está seguro de imprimir el cheque?'))
			{
				var data=this.sm.getSelected().data;
				Phx.CP.loadingShow();
				Ext.Ajax.request({
				url:'../../sis_tesoreria/control/TsLibroBancos/imprimirCheque',
				params:{
					'a_favor':data.a_favor , 
					'importe_cheque' : data.importe_cheque ,
					'fecha_cheque_literal' : data.fecha_cheque_literal,
					'nombre_regional' : data.nombre_regional
				},
				success:this.successExport,
				failure: this.conexionFailure,
				timeout:this.timeout,
				scope:this
			});
			}
		}
		else
		{
			Ext.MessageBox.alert('Estado', 'Antes debe seleccionar un item.');
		}
	},
	
	imprimirCheque2 : function(){
		var NumSelect=this.sm.getCount();
		
		if(NumSelect!=0)
		{
			if(confirm('¿Está seguro de imprimir el cheque?'))
			{
				var data=this.sm.getSelected().data;
				Phx.CP.loadingShow();
				Ext.Ajax.request({
				url:'../../sis_tesoreria/control/TsLibroBancos/imprimirCheque2',
				params:{
					'a_favor':data.a_favor , 
					'importe_cheque' : data.importe_cheque ,
					'fecha_cheque_literal' : data.fecha_cheque_literal,
					'nombre_regional' : data.nombre_regional
				},
				success:this.successExport,
				failure: this.conexionFailure,
				timeout:this.timeout,
				scope:this
			});
			}
		}
		else
		{
			Ext.MessageBox.alert('Estado', 'Antes debe seleccionar un item.');
		}
	},
	//
	imprimirCheque3 : function(){
		var NumSelect=this.sm.getCount();		
		if(NumSelect!=0)
		{
			if(confirm('¿Está seguro de imprimir el cheque?'))
			{
				var data=this.sm.getSelected().data;
				Phx.CP.loadingShow();
				Ext.Ajax.request({
				url:'../../sis_tesoreria/control/TsLibroBancos/imprimirCheque3',
				params:{
					'a_favor':data.a_favor , 
					'importe_cheque' : data.importe_cheque ,
					'fecha_cheque_literal' : data.fecha_cheque_literal,
					'nombre_regional' : data.nombre_regional
				}, 
				success:this.successExport,
				failure: this.conexionFailure,
				timeout:this.timeout,
				scope:this
			});
			} 
		}
		else
		{
			Ext.MessageBox.alert('Estado', 'Antes debe seleccionar un item.');
		}
	},
	//
	onChequesAsociados:function() {
			var rec=this.sm.getSelected();
			rec.data.nombreVista = 'ChequesAsociados';
			Phx.CP.loadWindows('../../../sis_tesoreria/vista/ts_libro_bancos_cheques_asociados/TsLibroBancosChequesAsociados.php',
					'Cheques Asociados',
					{
						width:'90%',
						height:500
					},
					rec.data,
					this.idContenedor,
					'TsLibroBancosCheque'
		)
	},
		
	vistaPrevia : function(){
		var NumSelect=this.sm.getCount();
		
		if(NumSelect!=0)
		{
			var data=this.sm.getSelected().data;
			Phx.CP.loadingShow();
			Ext.Ajax.request({
			url:'../../sis_tesoreria/control/TsLibroBancos/vistaPrevia',
			params:{
				'a_favor':data.a_favor , 
				'importe_cheque' : data.importe_cheque ,
				'fecha_cheque_literal' : data.fecha_cheque_literal,
				'nombre_regional' : data.nombre_regional
			},
			success:this.successExport,
			failure: this.conexionFailure,
			timeout:this.timeout,
			scope:this
			});
		}
		else
		{
			Ext.MessageBox.alert('Estado', 'Antes debe seleccionar un item.');
		}
	},
	
	successImprimirCheque:function(resp){
            
		Phx.CP.loadingHide();
		var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
		if(!reg.ROOT.error){
			
			this.reload();
		   
		}else{
			
			alert('ocurrio un error durante el proceso')
		}
	},
		
	iniciarEventos:function(){
		
		this.cmpTipo = this.getComponente('tipo');		
		this.cmpNroCheque = this.getComponente('nro_cheque');
		this.cmpImporteDeposito = this.getComponente('importe_deposito');
		this.cmpImporteCheque = this.getComponente('importe_cheque');
	    this.cmpIdLibroBancosFk = this.getComponente('id_libro_bancos_fk');
		this.cmpIdFinalidad = this.getComponente('id_finalidad');
		this.cmpIdCuentaBancaria = this.getComponente('id_cuenta_bancaria');
		this.cmpDepto = this.getComponente('id_depto');
		this.cmpFecha = this.getComponente('fecha');
		
		this.ocultarComponente(this.cmpNroCheque);
		this.ocultarComponente(this.cmpImporteDeposito);
		this.ocultarComponente(this.cmpImporteCheque);
		this.ocultarComponente(this.cmpIdLibroBancosFk);	

		this.cmpNroCheque.on('focus',function(componente){

				var cta_bancaria = this.cmpIdCuentaBancaria.getValue();

				Ext.Ajax.request({
					url:'../../sis_tesoreria/control/TsLibroBancos/listarTsLibroBancos',
					params:{start:0, limit:this.tam_pag, m_id_cuenta_bancaria:cta_bancaria,m_nro_cheque:'si'},
					success: function (resp){
						var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
						this.cmpNroCheque.setValue(parseInt(reg.datos[0].nro_cheque)+1);
					},
					failure: this.conexionFailure,
					timeout:this.timeout,
					scope:this
				});
				
			},this);
		
		this.cmpTipo.on('select',function(com,dat){
		
			switch(dat.data.variable){
				case 'cheque':
					this.mostrarComponente(this.cmpNroCheque);
					this.cmpImporteDeposito.setValue(0.00);
					this.ocultarComponente(this.cmpImporteDeposito);
					this.cmpImporteCheque.setValue('');
					this.mostrarComponente(this.cmpImporteCheque);
					
					var cta_bancaria = this.cmpIdCuentaBancaria.getValue();
					
					Ext.Ajax.request({
						url:'../../sis_tesoreria/control/TsLibroBancos/listarTsLibroBancos',
						params:{start:0, limit:this.tam_pag, m_id_cuenta_bancaria:cta_bancaria,m_nro_cheque:'si'},
						success: function (resp){
							var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
							this.cmpNroCheque.setValue(parseInt(reg.datos[0].nro_cheque)+1);
						},
						failure: this.conexionFailure,
						timeout:this.timeout,
						scope:this
					});
					
					break;
				case  'deposito':
					this.ocultarComponente(this.cmpNroCheque);
					this.cmpImporteDeposito.setValue('');
					this.mostrarComponente(this.cmpImporteDeposito);
					this.cmpImporteCheque.setValue(0.00);
					this.ocultarComponente(this.cmpImporteCheque);
					this.cmpNroCheque.reset();
					break;
				case  'debito_automatico':
					this.ocultarComponente(this.cmpNroCheque);
					this.cmpImporteDeposito.setValue(0.00);
					this.ocultarComponente(this.cmpImporteDeposito);
					this.cmpImporteCheque.setValue('');
					this.mostrarComponente(this.cmpImporteCheque);
					this.cmpNroCheque.reset();
					break;	
				case 'transferencia_carta':
					this.ocultarComponente(this.cmpNroCheque);
					this.cmpImporteDeposito.setValue(0.00);
					this.ocultarComponente(this.cmpImporteDeposito);
					this.cmpImporteCheque.setValue('');
					this.mostrarComponente(this.cmpImporteCheque);
					this.cmpNroCheque.reset();
					break;
			  }
          },this);
	},	
	
	onReloadPage:function(m){
		this.maestro=m;			
		this.cmpIdFinalidad.store.baseParams.id_cuenta_bancaria =this.maestro.id_cuenta_bancaria;		
		this.store.baseParams={id_cuenta_bancaria:this.maestro.id_cuenta_bancaria, mycls:this.cls};
		this.load({params:{start:0, limit:this.tam_pag}});			
	}
})
</script>
		
		