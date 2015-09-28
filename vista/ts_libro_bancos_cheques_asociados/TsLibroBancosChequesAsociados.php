<?php
/**
 *@package pXP
 *@file TsLibroBancosCheque.php
 *@author  Gonzalo Sarmiento
 *@date 01-10-2012
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.TsLibroBancosCheque = Ext.extend(Phx.gridInterfaz, {

        constructor : function(config) {
            this.maestro = config.maestro;
            Phx.vista.TsLibroBancosCheque.superclass.constructor.call(this, config);
            this.init();
			this.iniciarEventos();
            this.grid.getTopToolbar().disable();
            this.grid.getBottomToolbar().disable();            
						
			this.addButton('btnChequeoDocumentosWf',
				{
					text: 'Documentos',
					iconCls: 'bchecklist',
					disabled: true,
					handler: this.loadCheckDocumentosSolWf,
					tooltip: '<b>Documentos de la Solicitud</b><br/>Subir los documetos requeridos en la solicitud seleccionada.'
				}
			);
			
			this.addButton('diagrama_gantt',{text:'',iconCls: 'bgantt',disabled:true,handler:this.diagramGantt,tooltip: '<b>Diagrama Gantt de proceso macro</b>'});
						
			//this.Cmp.tipo.on('select', this.onTipoSelect, this);
			
			if(this.nombreVista=='ChequesAsociados'){
				this.store.baseParams={
						id_cuenta_bancaria : this.id_cuenta_bancaria,
						id_libro_bancos:this.id_libro_bancos,
						mycls:this.mycls};
				this.load({
					params : {
						start : 0,
						limit : 50
					}
				});   
			}
			
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
				grid:false,
				form:true
		},
		{
			config:{
				name: 'a_favor',
				fieldLabel: 'A Favor',
				allowBlank: false,
				anchor: '80%',
				gwidth: 145,
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
				gwidth: 145,
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
				gwidth: 170,
				maxLength:500
			},
				type:'TextArea',
				filters:{pfiltro:'lban.observaciones',type:'string'},
				id_grupo:1,
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
				grid:false,
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
				bottom_filter: true,
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
				gwidth: 100,
				store:new Ext.data.ArrayStore({
                            fields: ['variable', 'valor'],
                            data : [ ['cheque','Cheque'],
									 ['debito_automatico','Debito Automatico'],
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
					 options: ['cheque','debito_automatico','transferencia_carta']
				},
			grid:true,
			valorInicial:'cheque',
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
				grid:false,
				form:true
		},
		{
			config:{
				name: 'importe_deposito',
				fieldLabel: 'Importe Deposito',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:1310722
			},
				type:'NumberField',
				filters:{pfiltro:'lban.importe_deposito',type:'numeric'},
				id_grupo:1,
				grid:false,
				form:true
		},
		{
			config:{
				name: 'importe_cheque',
				fieldLabel: 'Importe',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:1310722
			},
				type:'NumberField',
				filters:{pfiltro:'lban.importe_cheque',type:'numeric'},
				bottom_filter: true,
				id_grupo:1,
				grid:false,
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
				id_grupo:1,
				grid:false,
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
				store:['CBB','SRZ','LPB','TJA','SRE','CIJ','TDD','UYU']
			},
			type:'ComboBox',
			id_grupo:1,
			filters:{	
					 type: 'list',
					  pfiltro:'lban.origen',
					 options: ['CBB','SRZ','TJA','SRE','CIJ','TDD','UYU','ENDESIS']
				},
			grid:false,
			form:true
		},
		{
			config:{
				name: 'estado',
				fieldLabel: 'Estado',
				allowBlank: false,
				anchor: '80%',
				gwidth: 80,
				maxLength:20
			},
				type:'TextField',
				filters:{pfiltro:'lban.estado',type:'string'},
				id_grupo:1,
				grid:false,
				form:false
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
			bottom_filter: true,
            id_grupo:1,
            grid:true,
            form:false
        },
		{
            config:{
                name:'id_finalidad',
                fieldLabel:'Finalidad',
                allowBlank:true,
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
                    baseParams:{par_filtro:'nombre_finalidad'}
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
                        pfiltro:'nombre_finalidad',
                        type:'string'
                    },*/
            grid:false,
            form:true
        },	
		{
			config: {
				name: 'id_libro_bancos_fk',
				fieldLabel: 'Deposito Asociado',
				allowBlank: true,
				emptyText: 'Elija una opcion',
				store: new Ext.data.JsonStore({
					url: '../../sis_/control/Clase/Metodo',
					id: 'id_',
					root: 'datos',
					sortInfo: {
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_libro_bancos_fk', 'nombre', 'codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'movtip.nombre#movtip.codigo'}
				}),
				valueField: 'id_libro_bancos_fk',
				displayField: 'nombre',
				gdisplayField: 'nombre',
				hiddenName: 'id_libro_bancos_fk',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 120,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['id_libro_bancos_fk']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'movtip.nombre',type: 'string'},
			grid: false,
			form: true
		},
		{
			config:{
				name: 'indice',
				fieldLabel: 'Indice',
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
				grid:false,
				form:false
		},
		{
			config:{
				name: 'fecha_reg',
				fieldLabel: 'Fecha creacion',
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
        title : 'Cheques',
        ActSave:'../../sis_tesoreria/control/TsLibroBancos/insertarTsLibroBancos',
	ActDel:'../../sis_tesoreria/control/TsLibroBancos/eliminarTsLibroBancos',
	ActList:'../../sis_tesoreria/control/TsLibroBancos/listarTsLibroBancos',
        id_store : 'id_libro_bancos',
        fields: [
		{name:'id_libro_bancos', type: 'numeric'},
		{name:'num_tramite', type: 'string'},
		{name:'id_cuenta_bancaria', type: 'numeric'},
		{name:'fecha', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_proceso_wf', type: 'numeric'},
		{name:'id_estado_wf', type: 'numeric'},
		{name:'a_favor', type: 'string'},
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
		{name:'sistema_origen', type: 'string'},
		{name:'notificado', type: 'string'}
	],
        sortInfo : {
            field : 'fecha DESC , nro_cheque',
            direction : 'DESC'
        },
		bnew : false,
		bedit : false,
		bacr : false,
        bdel : false,
        bsave : false,
		fheight:'80%',
		
		iniciarEventos:function(){
		
			this.cmpTipo = this.getComponente('tipo');		
			this.cmpNroCheque = this.getComponente('nro_cheque');
			this.cmpImporteDeposito = this.getComponente('importe_deposito');
			this.cmpImporteCheque = this.getComponente('importe_cheque');
			this.cmpIdLibroBancosFk = this.getComponente('id_libro_bancos_fk');
			this.cmpIdFinalidad = this.getComponente('id_finalidad');
			this.cmpAFavor = this.getComponente('a_favor');
			this.cmpObservaciones = this.getComponente('observaciones');
			this.cmpDetalle = this.getComponente('detalle');		
			this.cmpNroLiquidacion = this.getComponente('nro_liquidacion');
			this.cmpIdCuentaBancaria = this.getComponente('id_cuenta_bancaria');
			this.cmpNroComprobante = this.getComponente('nro_comprobante');
			this.cmpDepto = this.getComponente('id_depto');
			this.cmpFecha = this.getComponente('fecha');
						
			this.ocultarComponente(this.cmpIdFinalidad);
			this.ocultarComponente(this.cmpNroCheque);
			this.ocultarComponente(this.cmpImporteDeposito);
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
					case  'debito_automatico':
						this.ocultarComponente(this.cmpNroCheque);
						this.cmpImporteDeposito.setValue(0.00);
						this.ocultarComponente(this.cmpImporteDeposito);
						//this.cmpImporteCheque.setValue(0.00);
						this.mostrarComponente(this.cmpImporteCheque);
						this.cmpNroCheque.reset();
						break;	
					case 'cheque':
						this.mostrarComponente(this.cmpNroCheque);
						this.cmpImporteDeposito.setValue(0.00);
						this.ocultarComponente(this.cmpImporteDeposito);
						//this.cmpImporteCheque.setValue(0.00);
						this.mostrarComponente(this.cmpImporteCheque);
						/*
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
						});*/
						break;
					
					case 'transferencia_carta':
						this.ocultarComponente(this.cmpNroCheque);
						this.cmpImporteDeposito.setValue(0.00);
						this.ocultarComponente(this.cmpImporteDeposito);
						//this.cmpImporteCheque.setValue(0.00);
						this.mostrarComponente(this.cmpImporteCheque);
						this.cmpNroCheque.reset();
						break;
				  }
			  },this);
			  
			  this.cmpTipo.on('focus',function(com,dat){
			  },this);
			  
		},		
		
		preparaMenu:function(n){
			  var data = this.getSelectedData();
			  //var tb =this.tbar;
			  
			  Phx.vista.TsLibroBancosCheque.superclass.preparaMenu.call(this,n); 
			  
			  if(data['id_proceso_wf'] !== null){
			
				  if(data['tipo'] == 'cheque'){				  
					  this.getBoton('btnChequeoDocumentosWf').enable();
					  this.getBoton('diagrama_gantt').enable();
									  
				  }else{;
					  this.getBoton('btnChequeoDocumentosWf').disable();				  
				  }
			  
			  }else{
					this.getBoton('btnChequeoDocumentosWf').disable();
					this.getBoton('diagrama_gantt').disable();
			  }
			  
		  if(this.nombreVista=='ChequesAsociados'){
			this.getBoton('btnChequeoDocumentosWf').enable();
			this.getBoton('diagrama_gantt').enable();			
		  }
		 },
					
		successSinc:function(resp){
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
			console.log(reg.ROOT.datos);
            if(reg.ROOT.datos.resultado!='falla'){                
                this.reload();
             }else{
                alert(reg.ROOT.datos.mensaje)
            }
		},   
			
		
		successWizard:function(resp){
			Phx.CP.loadingHide();
			resp.argument.wizard.panel.destroy()
			Phx.CP.getPagina(this.idContenedorPadre).reload();  
			//this.reload();
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
		 
		loadValoresIniciales:function(){
			Phx.vista.TsLibroBancosCheque.superclass.loadValoresIniciales.call(this);
			this.Cmp.id_cuenta_bancaria.setValue(this.maestro.id_cuenta_bancaria);		
		},	
		
		successSave: function(resp) {		   
		   Phx.vista.TsLibroBancosCheque.superclass.successSave.call(this,resp);        
		   Phx.CP.getPagina(this.idContenedorPadre).reload();  
		},
				
        onReloadPage : function(m) {
            this.maestro = m;
			this.store.baseParams={id_libro_bancos:this.maestro.id_libro_bancos, mycls:this.cls};
			this.load({params:{start:0, limit:this.tam_pag}});	
            
        }
    })
</script>