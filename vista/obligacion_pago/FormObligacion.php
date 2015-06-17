<?php
/**
*@package pXP
*@file    FormObligacion.php
*@author  Rensi Arteaga Copari 
*@date    30-01-2014
*@description permites subir archivos a la tabla de documento_sol
*/
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
Phx.vista.FormObligacion=Ext.extend(Phx.frmInterfaz,{
    ActSave:'../../sis_tesoreria/control/ObligacionPago/insertarObligacionCompleta',
    tam_pag: 10,
    layout: 'fit',
    autoScroll: false,
    breset: false,
    constructor:function(config)
    {   
    	
    	//declaracion de eventos
        this.addEvents('beforesave');
        this.addEvents('successsave');
    	
    	this.buildComponentesDetalle();
        this.buildDetailGrid();
        this.buildGrupos();
        
        Phx.vista.FormObligacion.superclass.constructor.call(this,config);
        this.init();    
        this.iniciarEventos();
        this.iniciarEventosDetalle();
        this.onNew();
        
    },
    buildComponentesDetalle: function(){
    	this.detCmp = {
    		       'id_concepto_ingas': new Ext.form.ComboBox({
							                name: 'id_concepto_ingas',
							                msgTarget: 'title',
							                fieldLabel: 'Concepto',
							                allowBlank: false,
							                emptyText : 'Concepto...',
							                store : new Ext.data.JsonStore({
							                            url:'../../sis_parametros/control/ConceptoIngas/listarConceptoIngasMasPartida',
							                            id : 'id_concepto_ingas',
							                            root: 'datos',
							                            sortInfo:{
							                                    field: 'desc_ingas',
							                                    direction: 'ASC'
							                            },
							                            totalProperty: 'total',
							                            fields: ['id_concepto_ingas','tipo','desc_ingas','movimiento','desc_partida','id_grupo_ots','filtro_ot','requiere_ot'],
							                            remoteSort: true,
							                            baseParams:{par_filtro:'desc_ingas#par.codigo#par.nombre_partida',movimiento:'gasto', autorizacion: 'pago_unico',autorizacion_nulos: 'no'}
							                }),
							               valueField: 'id_concepto_ingas',
							               displayField: 'desc_ingas',
							               hiddenName: 'id_concepto_ingas',
							               forceSelection:true,
							               typeAhead: false,
							               triggerAction: 'all',
							               listWidth:500,
							               resizable:true,
							               lazyRender:true,
							               mode:'remote',
							               pageSize:10,
							               queryDelay:1000,
							               minChars:2,
							               qtip:'Si el conceto de gasto que necesita no existe por favor  comuniquese con el área de presupuestos para solictar la creación',
							               tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>{desc_ingas}</b></p><strong>{tipo}</strong><p>PARTIDA: {desc_partida}</p></div></tpl>',
							             }),
	              'id_centro_costo': new Ext.form.ComboRec({
						                    name:'id_c	entro_costo',
						                    msgTarget: 'title',
						                    origen:'CENTROCOSTO',
						                    fieldLabel: 'Centro de Costos',
						                    url: '../../sis_parametros/control/CentroCosto/listarCentroCostoFiltradoXDepto',
						                    emptyText : 'Centro Costo...',
						                    allowBlank: false,
						                    baseParams:{filtrar:'grupo_ep'}
						                }),
	               'id_orden_trabajo': new Ext.form.ComboRec({
						                    name:'id_orden_trabajo',
						                    msgTarget: 'title',
						                    sysorigen:'sis_contabilidad',
						                    fieldLabel: 'Orden Trabajo',
							       		    origen:'OT',
						                    allowBlank:true
						            }),
						            
					'descripcion': new Ext.form.TextField({
										name: 'descripcion',
										msgTarget: 'title',
										fieldLabel: 'descripcion',
										allowBlank: false,
										anchor: '80%',
										maxLength:1200
								}),
					
					'monto_pago_mo': new Ext.form.NumberField({
						                name: 'monto_pago_mo',
						                msgTarget: 'title',
						                currencyChar:' ',
						                fieldLabel: 'Precio.',
						                minValue: 0.0001, 
						                allowBlank: false,
						                allowDecimals: true,
						                allowNegative:false,
						                decimalPrecision:2
						            })
					
			  }
    		
    		
    }, 
    iniciarEventosDetalle: function(){
    	
        this.detCmp.id_concepto_ingas.on('change',function( cmb, rec, ind){
	        	    this.detCmp.id_orden_trabajo.reset();
	           },this);
	        
	    this.detCmp.id_concepto_ingas.on('select',function( cmb, rec, ind){
	        	
	        	    this.detCmp.id_orden_trabajo.store.baseParams = {
			        		                                           filtro_ot:rec.data.filtro_ot,
			        		 										   requiere_ot:rec.data.requiere_ot,
			        		 										   id_grupo_ots:rec.data.id_grupo_ots
			        		 										 };
			        this.detCmp.id_orden_trabajo.modificado = true;
			        if(rec.data.requiere_ot =='obligatorio'){
			        	this.detCmp.id_orden_trabajo.allowBlank = false;
			        	this.detCmp.id_orden_trabajo.setReadOnly(false);
			        }
			        else{
			        	this.detCmp.id_orden_trabajo.allowBlank = true;
			        	this.detCmp.id_orden_trabajo.setReadOnly(true);
			        }
			        this.detCmp.id_orden_trabajo.reset();
			        
        	
             },this);
    },
    
    onInitAdd: function(){
    	
    	
    },
    onCancelAdd: function(re,save){
    	if(this.sw_init_add){
    		this.mestore.remove(this.mestore.getAt(0));
    	}
    	
    	this.sw_init_add = false;
    	this.evaluaGrilla();
    },
    onUpdateRegister: function(){
    	this.sw_init_add = false;
    },
    
    onAfterEdit:function(re, o, rec, num){
    	//set descriptins values ...  in combos boxs
    	
    	var cmb_rec = this.detCmp['id_concepto_ingas'].store.getById(rec.get('id_concepto_ingas'));
    	if(cmb_rec){
    		rec.set('desc_concepto_ingas', cmb_rec.get('desc_ingas')); 
    	}
    	
    	var cmb_rec = this.detCmp['id_orden_trabajo'].store.getById(rec.get('id_orden_trabajo'));
    	if(cmb_rec){
    		rec.set('desc_orden_trabajo', cmb_rec.get('desc_orden')); 
    	}
    	
    	var cmb_rec = this.detCmp['id_centro_costo'].store.getById(rec.get('id_centro_costo'));
    	if(cmb_rec){
    		rec.set('desc_centro_costo', cmb_rec.get('codigo_cc')); 
    	}
    	
    },
    
    evaluaRequistos: function(){
    	//valida que todos los requistosprevios esten completos y habilita la adicion en el grid
     	var i = 0;
    	sw = true
    	while( i < this.Componentes.length) {
    		
    		if(!this.Componentes[i].isValid()){
    		   sw = false;
    		   //i = this.Componentes.length;
    		}
    		i++;
    	}
    	
   
    	
    	return sw
    },
    
    bloqueaRequisitos: function(sw){
    	this.Cmp.id_depto.setDisabled(sw);
    	this.Cmp.id_moneda.setDisabled(sw);
    	this.Cmp.id_funcionario.setDisabled(sw);
    	this.Cmp.fecha.setDisabled(sw);
    	this.cargarDatosMaestro();
    	
    },
    
    cargarDatosMaestro: function(){
    	
        
        this.detCmp.id_orden_trabajo.store.baseParams.fecha_solicitud = this.Cmp.fecha.getValue().dateFormat('d/m/Y');
        this.detCmp.id_orden_trabajo.modificado = true;
        
        this.detCmp.id_centro_costo.store.baseParams.id_gestion = this.Cmp.id_gestion.getValue();
        this.detCmp.id_centro_costo.store.baseParams.codigo_subsistema = 'ADQ';
        this.detCmp.id_centro_costo.store.baseParams.id_depto = this.Cmp.id_depto.getValue();
        this.detCmp.id_centro_costo.modificado = true;
        //cuando esta el la inteface de presupeustos no filtra por bienes o servicios
        this.detCmp.id_concepto_ingas.store.baseParams.id_gestion=this.Cmp.id_gestion.getValue();
        this.detCmp.id_concepto_ingas.modificado = true;
    	
    },
    
    evaluaGrilla: function(){
    	//al eliminar si no quedan registros en la grilla desbloquea los requisitos en el maestro
    	var  count = this.mestore.getCount();
    	if(count == 0){
    		this.bloqueaRequisitos(false);
    	} 
    },
    
    
    buildDetailGrid: function(){
    	
    	//cantidad,detalle,peso,totalo
        var Items = Ext.data.Record.create([{
                        name: 'cantidad_sol',
                        type: 'int'
                    }, {
                        name: 'id_concepto_ingas',
                        type: 'int'
                    }, {
                        name: 'id_centro_costo',
                        type: 'int'
                    }, {
                        name: 'id_orden_trabajo',
                        type: 'int'
                    },{
                        name: 'monto_pago_mo',
                        type: 'float'
                    }
                    ]);
        
        this.mestore = new Ext.data.JsonStore({
					url: '../../sis_adquisiciones/control/SolicitudDet/listarSolicitudDet',
					id: 'id_solicitud_det',
					root: 'datos',
					totalProperty: 'total',
					fields: ['id_solicitud_det','id_centro_costo','descripcion', 'precio_unitario',
					         'id_solicitud','id_orden_trabajo','id_concepto_ingas','precio_total','cantidad_sol',
							 'desc_centro_costo','desc_concepto_ingas','desc_orden_trabajo'
					],remoteSort: true,
					baseParams: {dir:'ASC',sort:'id_solicitud_det',limit:'50',start:'0'}
				});
    	
    	this.editorDetail = new Ext.ux.grid.RowEditor({
                saveText: 'Aceptar',
                name: 'btn_editor'
               
            });
            
        this.summary = new Ext.ux.grid.GridSummary();
        // al iniciar la edicion
        this.editorDetail.on('beforeedit', this.onInitAdd , this);
        
        //al cancelar la edicion
        this.editorDetail.on('canceledit', this.onCancelAdd , this);
        
        //al cancelar la edicion
        this.editorDetail.on('validateedit', this.onUpdateRegister, this);
        
        this.editorDetail.on('afteredit', this.onAfterEdit, this);
        
        
        
        
        
        
        
        this.megrid = new Ext.grid.GridPanel({
        	        layout: 'fit',
                    store:  this.mestore,
                    region: 'center',
                    split: true,
                    border: false,
                    plain: true,
                    //autoHeight: true,
                    plugins: [ this.editorDetail, this.summary ],
                    stripeRows: true,
                    tbar: [{
                        /*iconCls: 'badd',*/
                        text: '<i class="fa fa-plus-circle fa-lg"></i> Agregar Concepto',
                        scope: this,
                        width: '100',
                        handler: function(){
                        	if(this.evaluaRequistos() === true){
                        		
	                        		 var e = new Items({
	                        		 	id_concepto_ingas: undefined,
		                                cantidad_sol: 1,
		                                descripcion: '',
		                                precio_total: 0,
		                                precio_unitario: undefined
	                            });
	                            this.editorDetail.stopEditing();
	                            this.mestore.insert(0, e);
	                            this.megrid.getView().refresh();
	                            this.megrid.getSelectionModel().selectRow(0);
	                            this.editorDetail.startEditing(0);
	                            this.sw_init_add = true;
	                            
	                            this.bloqueaRequisitos(true);
                        	}
                        	else{
                        		//alert('Verifique los requisitos');
                        	}
                           
                        }
                    },{
                        ref: '../removeBtn',
                        text: '<i class="fa fa-trash fa-lg"></i> Eliminar',
                        scope:this,
                        handler: function(){
                            this.editorDetail.stopEditing();
                            var s = this.megrid.getSelectionModel().getSelections();
                            for(var i = 0, r; r = s[i]; i++){
                                this.mestore.remove(r);
                            }
                            this.evaluaGrilla();
                        }
                    }],
            
                    columns: [
                    new Ext.grid.RowNumberer(),
                    {
                        header: 'Concepto',
                        dataIndex: 'id_concepto_ingas',
                        width: 220,
                        sortable: false,
                        renderer:function(value, p, record){return String.format('{0}', record.data['desc_concepto_ingas']);},
                        editor: this.detCmp.id_concepto_ingas 
                    },
                    {
                       
                        header: 'Centro de costo',
                        dataIndex: 'id_centro_costo',
                        align: 'center',
                        width: 260,
                        renderer:function (value, p, record){return String.format('{0}', record.data['desc_centro_costo']);},
                        editor: this.detCmp.id_centro_costo 
                    },
                    {
                       
                        header: 'Orden de Trabajo',
                        dataIndex: 'id_orden_trabajo',
                        align: 'center',
                        width: 260,
                        renderer:function(value, p, record){return String.format('{0}', record.data['desc_orden_trabajo']?record.data['desc_orden_trabajo']:'');},
					    editor: this.detCmp.id_orden_trabajo 
                    },
                    {
                       
                        header: 'Description',
                        dataIndex: 'descripcion',
                        align: 'center',
                        width: 280,
                        editor: this.detCmp.descripcion 
                    },
                    
                    {
                       
                        header: 'Precio',
                        dataIndex: 'monto_pago_mo',
                        format: '$0,0.00',
                        align: 'center',
                        width: 70,
                        trueText: 'Yes',
                        falseText: 'No',
                        minValue: 0.001,
                        summaryType: 'sum',
                        editor: this.detCmp.monto_pago_mo
                    }]
                });
    },
    buildGrupos: function(){
    	this.Grupos = [{
    	           	    layout: 'border',
    	           	    border: false,
    	           	     frame:true,
	                    items:[
	                      {
                        	xtype: 'fieldset',
	                        border: false,
	                        split: true,
	                        layout: 'column',
	                        region: 'north',
	                        autoScroll: true,
	                        autoHeight: true,
	                        collapseFirst : false,
	                        collapsible: true,
	                        width: '100%',
	                        //autoHeight: true,
	                        padding: '0 0 0 10',
	    	                items:[
		    	                   {
							        bodyStyle: 'padding-right:5px;',
							       
							        autoHeight: true,
							        border: false,
							        items:[
			    	                   {
			                            xtype: 'fieldset',
			                            frame: true,
			                            border: false,
			                            layout: 'form',	
			                            title: 'Datos de la Solicitud',
			                            width: '33%',
			                            
			                            //margins: '0 0 0 5',
			                            padding: '0 0 0 10',
			                            bodyStyle: 'padding-left:5px;',
			                            id_grupo: 0,
			                            items: [],
			                         }]
			                     },
			                     {
			                      bodyStyle: 'padding-right:5px;',
			                    
			                      border: false,
			                      autoHeight: true,
							      items: [{
			                            xtype: 'fieldset',
			                            frame: true,
			                            layout: 'form',
			                            title: ' Datos del Pago ',
			                            width: '33%',
			                            border: false,
			                            //margins: '0 0 0 5',
			                            padding: '0 0 0 10',
			                            bodyStyle: 'padding-left:5px;',
			                            id_grupo: 1,
			                            items: [],
			                         }]
		                         }
    	                      ]
    	                  },
    	                    this.megrid
                         ]
                 }];
    	
    	
    },
    
    
    
    successSave:function(resp)
    {
        Phx.CP.loadingHide();
        Phx.CP.getPagina(this.idContenedorPadre).reload();
        this.panel.close();
    },
                
    
   
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_obligacion_pago'
			},
			type:'Field',
			form:true 
		},
        
       {
            config:{
                name: 'fecha',
                fieldLabel: 'Fecha Sol',
                qtip: 'Según esta fecha se escoje el formulario de solicitud', 
                allowBlank: false,
                gwidth: 100,
                format: 'd/m/Y'
            },
            type: 'DateField',
            id_grupo: 0,
            form: true
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
                baseParams: { es_combo_solicitud : 'si' } },
            type: 'ComboRec',//ComboRec
            id_grupo: 0,
            form:true
         },
        {
            config:{
                name: 'id_depto',
                url: '../../sis_parametros/control/Depto/listarDeptoFiltradoXUsuario',
                fieldLabel: 'Depto',
                allowBlank: false,
                anchor: '80%',
                origen: 'DEPTO',
                tinit: false,
                baseParams:{estado:'activo',codigo_subsistema:'TES',modulo:'OP'}//parametros adicionales que se le pasan al store
                
            },
            type:'ComboRec',
            id_grupo:0,
            form:true
        },
        		
		{
			config: {
				name: 'id_moneda',
				fieldLabel: 'Moneda',
				anchor: '80%',
				tinit: false,
				allowBlank: false,
				origen: 'MONEDA'
			},
			type: 'ComboRec',
			id_grupo: 1,
			form: true
		},
         {
            config:{
                name: 'tipo_cambio_conv',
                fieldLabel: 'Tipo Cambio',
                allowBlank: false,
                anchor: '80%',
                maxLength:131074
            },
            type:'NumberField',
            id_grupo:1,
            form:true
        },
	  
		{
			config: {
				name: 'id_proveedor',
				fieldLabel: 'Proveedor',
				anchor: '80%',
				tinit: false,
				allowBlank: false,
				origen: 'PROVEEDOR',
				listWidth: '280',
				resizable: true
			},
			type: 'ComboRec',
			id_grupo: 1,
			form: true
		},
		{
			config:{
				name: 'obs',
				fieldLabel: 'Desc',
				allowBlank: false,
				qtip: 'Descripcion del objetivo del pago, o Si el proveedor es PASAJEROS PERJUDICADOS aqui va el nombre del pasajero',
				anchor: '90%',
				maxLength:1000
			},
			type:'TextArea',
			id_grupo: 0,
			form: true
		},{
            config:{
                name: 'id_plantilla',
                fieldLabel: 'Tipo Documento',
                allowBlank: false,
                emptyText:'Elija una plantilla...',
                store:new Ext.data.JsonStore(
                {
                    url: '../../sis_parametros/control/Plantilla/listarPlantilla',
                    id: 'id_plantilla',
                    root:'datos',
                    sortInfo:{
                        field:'desc_plantilla',
                        direction:'ASC'
                    },
                    totalProperty:'total',
                    fields: ['id_plantilla','nro_linea','desc_plantilla','tipo','sw_tesoro', 'sw_compro'],
                    remoteSort: true,
                    baseParams:{par_filtro:'plt.desc_plantilla',sw_compro:'si',sw_tesoro:'si',sw_monto_excento:'no' }
                }),
                tpl:'<tpl for="."><div class="x-combo-list-item"><p>{desc_plantilla}</p></div></tpl>',
                valueField: 'id_plantilla',
                hiddenValue: 'id_plantilla',
                displayField: 'desc_plantilla',
                listWidth:'280',
                forceSelection:true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:20,
                queryDelay:500,
                minChars:2
             },
            type:'ComboBox',
            id_grupo:1,
            form:true
        },
        {
            config:{
                name: 'fecha_pp_ini',
                fieldLabel: 'Fecha pago.',
                qtip: 'Fecha tentativa para el pago',
                allowBlank: false,
                format: 'd/m/Y' 
            },
            type:'DateField',
            id_grupo:1,
            form:true
        },
        {
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'rotacion'
			},
			type:'Field',
			valorInicial:1,
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'total_nro_cuota'
			},
			type:'Field',
			valorInicial:1,
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'pago_variable'
			},
			type:'Field',
			valorInicial: 'no',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'tipo_anticipo'
			},
			type:'Field',
			valorInicial: 'no',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'tipo_obligacion'
			},
			type:'Field',
			valorInicial: 'pago_unico',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_gestion'
			},
			type:'Field',
			form:true 
		}
		
		
	],
	title: 'Frm obligación',
	
	iniciarEventos:function(){
		
		    this.cmpProveedor = this.getComponente('id_proveedor');
            this.cmpFuncionario = this.getComponente('id_funcionario');
            this.cmpFecha=this.getComponente('fecha');
            this.cmpMoneda=this.getComponente('id_moneda');
            this.cmpDepto=this.getComponente('id_depto');
            this.cmpTipoCambioConv=this.getComponente('tipo_cambio_conv');
            this.cmpTipoObligacion=this.getComponente('tipo_obligacion');
            
           
            this.cmpFecha.on('change',function(f){
                 Phx.CP.loadingShow();
                 
                 this.obtenerGestion(this.cmpFecha);
                 this.cmpFuncionario.reset();
                 this.cmpFuncionario.enable();             
                 this.cmpFuncionario.store.baseParams.fecha = this.cmpFecha.getValue().dateFormat(this.cmpFecha.format);
                 
                 this.cmpFuncionario.store.load({params:{start:0,limit:this.tam_pag}, 
                       callback : function (r) {
                            Phx.CP.loadingHide();  
                            if (r.length == 1 ) {                        
                                this.cmpFuncionario.setValue(r[0].data.id_funcionario);
                                this.cmpFuncionario.fireEvent('select',  this.cmpFuncionario, r[0]);
                            }     
                                            
                        }, scope : this
                    });
                 
                 
             },this);
             
            
            this.cmpMoneda.on('select',function(com,dat){
                  
                  if(dat.data.tipo_moneda == 'base'){
                     this.cmpTipoCambioConv.disable();
                     this.cmpTipoCambioConv.setValue(1); 
                      
                  }
                  else{
                       this.cmpTipoCambioConv.enable()
                     this.obtenerTipoCambio();  
                  }
                 
                  
              },this);
            
            this.cmpProveedor.enable();
            this.mostrarComponente(this.cmpProveedor);
            this.mostrarComponente(this.cmpFuncionario);
            this.cmpFuncionario.reset();
            
          
       
           
           this.Cmp.id_funcionario.on('select', function(combo, record, index){ 
            	
            	if(!record.data.id_lugar){
            		alert('El funcionario no tiene oficina definida');
            		return
            	}
            	
            	this.Cmp.id_depto.reset();
            	this.Cmp.id_depto.store.baseParams.id_lugar = record.data.id_lugar;
            	this.Cmp.id_depto.modificado = true;
            	this.Cmp.id_depto.enable();
            	
            	this.Cmp.id_depto.store.load({params:{start:0,limit:this.tam_pag}, 
		           callback : function (r) {
		                if (r.length == 1 ) {                       
		                    this.Cmp.id_depto.setValue(r[0].data.id_depto);
		                }    
		                                
		            }, scope : this
		        });
            	
            	
            }, this);
      
    },
    
   obtenerTipoCambio:function(){
         
         var fecha = this.cmpFecha.getValue().dateFormat(this.cmpFecha.format);
         var id_moneda = this.cmpMoneda.getValue();
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                    // form:this.form.getForm().getEl(),
                    url:'../../sis_parametros/control/TipoCambio/obtenerTipoCambio',
                    params:{fecha:fecha,id_moneda:id_moneda},
                    success:this.successTC,
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
             });
        }, 
    successTC:function(resp){
       Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
                
                this.cmpTipoCambioConv.setValue(reg.ROOT.datos.tipo_cambio);
            }else{
                
                alert('ocurrio al obtener el tipo de Cambio')
            } 
    },
   
   
    onEdit:function(){
       
    },
    
    onNew: function(){
    	
    	this.Cmp.id_depto.disable();
        this.mostrarComponente(this.cmpProveedor);
        this.mostrarComponente(this.cmpFuncionario);
        this.cmpFuncionario.reset();
        this.cmpFecha.enable(); 
        this.cmpTipoCambioConv.enable();
        this.cmpProveedor.enable();
        this.cmpMoneda.enable();
        this.cmpFuncionario.disable();
        this.cmpFecha.setValue(new Date());
        this.cmpFecha.fireEvent('change')
        this.cmpTipoObligacion.setValue('pago_unico');
        
        this.Cmp.tipo_anticipo.setValue('no');
        this.Cmp.pago_variable.setValue('no');
        this.Cmp.total_nro_cuota.setValue(1);
        this.Cmp.rotacion.setValue(0);
        
        
	    
	    
	    
		
           
    },
   
    onSubmit: function(o) {
    	//  validar formularios
        var arra = [], k, me = this;
        for (k = 0; k < me.megrid.store.getCount(); k++) {
    		record = me.megrid.store.getAt(k);
    		arra[k] = record.data;
    		arra[k].precio_ga = record.data.precio_total;
    		arra[k].precio_sg = 0.0; 
		}
   	    me.argumentExtraSubmit = { 'json_new_records': JSON.stringify(arra, function replacer(key, value) {
   	    	
							    if (typeof value === 'string') {
							        //return Ext.util.Format.htmlEncode(value);
							        return String(value).replace(/&/g, "%26")
							    }
							    return value;
							}) };
   	    if(this.evaluaRequistos()){
   	    	
   	    	if( k > 0 &&  !this.editorDetail.isVisible()){
	   	    	 Phx.vista.FormObligacion.superclass.onSubmit.call(this,o, true);
	   	    }
	   	    else{
	   	    	if(confirm("No tiene ningun concepto  para comprar. ¿Desea continuar?")){
	   	    		
	   	    		Phx.vista.FormObligacion.superclass.onSubmit.call(this,o);
	   	    	}
	   	    	
	   	    }	
   	    }
   	    
   	    
   	},
   
   successSave: function(resp){
   	
      	Phx.CP.loadingHide();
   	    var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
   	    this.fireEvent('successsave',this,objRes);
   	    
   	},
   	
   	obtenerGestion:function(x){
         
         var fecha = x.getValue().dateFormat(x.format);
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                    // form:this.form.getForm().getEl(),
                    url:'../../sis_parametros/control/Gestion/obtenerGestionByFecha',
                    params:{fecha:fecha},
                    success:this.successGestion,
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
             });
        }, 
    successGestion:function(resp){
       Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
                
                this.Cmp.id_gestion.setValue(reg.ROOT.datos.id_gestion);
                
               
            }else{
                
                alert('ocurrio al obtener la gestion')
            } 
    },
	
	loadCheckDocumentosSolWf:function(data) {
		   //TODO Eventos para cuando ce cierre o destruye la interface de documentos
            Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
                    'Documentos de la solicitu de compra',
                    {
                        width:'90%',
                        height:500
                    },
                    data,
                    this.idContenedor,
                   'DocumentoWf'
       );
       
    }
	
    
})    
</script>