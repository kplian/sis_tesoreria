<?php
/**
*@package pXP
*@file ObligacionPago.php
*@author  Gonzalo Sarmiento Sejas
*@date 02-04-2013 16:01:32
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ObligacionPago=Ext.extend(Phx.gridInterfaz,{

    nombreVista: 'obligacionPago',
	constructor: function(config){
		this.maestro=config;
    	//llama al constructor de la clase padre
		Phx.vista.ObligacionPago.superclass.constructor.call(this,config);
		this.init();
		
		this.load({params:{start:0, 
		           limit:this.tam_pag, 
		           tipo_interfaz: this.nombreVista,
		           id_obligacion_pago: this.maestro.id_obligacion_pago}});
		           
		this.iniciarEventos();
	    
         this.addButton('ant_estado',{
              argument: {estado: 'anterior'},
              text:'Anterior',
              iconCls: 'batras',
              disabled:true,
              handler:this.antEstado,
              tooltip: '<b>Pasar al Anterior Estado</b>'
          });
          
        this.addButton('fin_registro',{text:'Fin Reg.',iconCls: 'badelante',disabled:true,handler:this.fin_registro,tooltip: '<b>Finalizar</b><p>Finalizar registro de cotización</p>'});
        this.addButton('reporte_com_ejec_pag',{text:'Rep.',iconCls: 'bpdf32',disabled:true,handler:this.repComEjePag,tooltip: '<b>Reporte</b><p>Reporte Obligacion de Pago</p>'});
        this.addButton('reporte_plan_pago',{text:'Planes de Pago',iconCls: 'bpdf32',disabled:true,handler:this.repPlanPago,tooltip: '<b>Reporte Plan Pago</b><p>Reporte Planes de Pago</p>'});
        this.TabPanelSouth.get(1).disable()
        
        //RCM: Se agrega menú de reportes de adquisiciones
        this.addBotones();
        
        //RCM: reporte de verificacion presupeustaria
        this.addButton('btnVerifPresup', {
                text : 'Disponibilidad',
                iconCls : 'bassign',
                disabled : true,
                handler : this.onBtnVerifPresup,
                tooltip : '<b>Verificación de la disponibilidad presupuestaria</b>'
            });
	
	
	},
	tam_pag:50,
			
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
				name: 'estado',
				fieldLabel: 'estado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:50
			},
			type:'TextField',
			filters:{pfiltro:'obpg.estado',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
        {
        config:{
                name: 'numero',
                fieldLabel: 'Numero',
                allowBlank: true,
                anchor: '80%',
                gwidth: 180,
                renderer: function(value,p,record){
                         if(record.data.comprometido=='si'){
                             return String.format('<b><font color="green">{0}</font></b>', value);
                        }
                        else{
                            return String.format('{0}', value);
                        }},
                maxLength:50
            },
            type:'Field',
            filters:{pfiltro:'obpg.numero',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
		{
			config:{
				name: 'tipo_obligacion',
				fieldLabel: 'Tipo Obligacion',
				allowBlank: false,
				anchor: '80%',
				emptyText:'Tipo Obligacion',
				renderer:function (value, p, record){
                        var dato='';
                        dato = (dato==''&&value=='pago_directo')?'Pago Directo':dato;
                        //dato = (dato==''&&value=='caja_chica')?'Caja Chica':dato;
                        //dato = (dato==''&&value=='viaticos')?'Viáticos':dato;
                        //dato = (dato==''&&value=='fondo_en_avance')?'Fondo en Avance':dato;
                        dato = (dato==''&&value=='aduisiciones')?'Adquisiciones':dato;
                        return String.format('{0}', dato);
                    },
            
                    store:new Ext.data.ArrayStore({
                            fields: ['variable', 'valor'],
                            data : [ ['pago_directo','Pago Directo']
                                     //,['caja_chica','Caja Chica'],
                                     //['viaticos','Viáticos'],
                                    // ['fondo_en_avance','Fondo en Avance']
                                    ]
                                    }),
			    valueField: 'variable',
				displayField: 'valor',
				forceSelection: true,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'local',
				wisth: 250
			},
			type:'ComboBox',
			filters:{pfiltro:'obpg.tipo_obligacion',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
        {
            config:{
                name: 'fecha',
                fieldLabel: 'Fecha',
                allowBlank: false,
                gwidth: 100,
                        format: 'd/m/Y', 
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'obpg.fecha',type:'date'},
            id_grupo:1,
            grid:true,
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
                baseParams:{tipo_filtro:'DEPTO_UO',estado:'activo',codigo_subsistema:'TES'},//parametros adicionales que se le pasan al store
                gdisplayField:'nombre_depto',
                gwidth: 100
            },
            type:'ComboRec',
            filters:{pfiltro:'dep.nombre',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'total_pago',
                currencyChar:' ',
                fieldLabel: 'Total a Pagar',
                allowBlank: false,
                gwidth: 130,
                maxLength:1245184
            },
            type:'MoneyField',
            filters:{pfiltro:'obdet.monto_pago_mo',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:false
        },		
		{
			config: {
				name: 'id_moneda',
				fieldLabel: 'Moneda',
				anchor: '80%',
				tinit: true,
				allowBlank: false,
				origen: 'MONEDA',
				gdisplayField: 'moneda',
				gwidth: 100,
			},
			type: 'ComboRec',
			id_grupo: 1,
			filters:{pfiltro:'mn.moneda',type:'string'},
			grid: true,
			form: true
		},{
           config:{
               name: 'pago_variable',
               fieldLabel: 'Pago Variable',
               gwidth: 100,
               maxLength:30,
               items: [
                   {boxLabel: 'Si',name: 'pg-var',  inputValue: 'si'},
                   {boxLabel: 'No',name: 'pg-var', inputValue: 'no', checked:true}
               ]
           },
           type:'RadioGroupField',
           filters:{pfiltro:'pago_variable',type:'string'},
           id_grupo:1,
           grid:true,
           form:true
          },
         {
            config:{
                name: 'tipo_cambio_conv',
                fieldLabel: 'Tipo Cambio',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:131074
            },
            type:'NumberField',
            filters:{pfiltro:'obpg.tipo_cambio_conv',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
	  {
       config:{
           name: 'funcionario_proveedor',
           fieldLabel: 'Funcionario/<br/>Proveedor',
           anchor: '80%',
           gwidth: 100,
           maxLength:30,
           items: [
               {boxLabel: 'Funcionario', name: 'rg-auto', inputValue: 'funcionario', checked:true},
               {boxLabel: 'Proveedor', name: 'rg-auto', inputValue: 'proveedor'}
           ]
       },
       type:'RadioGroup',
       id_grupo:1,
       grid:false,
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
				gdisplayField: 'desc_proveedor',
				gwidth: 100,
			},
			type: 'ComboRec',
			id_grupo: 1,
			filters:{pfiltro:'pv.desc_proveedor',type:'string'},
			grid: true,
			form: true
		},
		{
			config:{
				name: 'id_funcionario',
				fieldLabel: 'Funcionario',
				tinit: false,
				allowBlank: false,
				anchor: '80%',
				origen: 'FUNCIONARIO',				
				gdisplayField: 'desc_funcionario1',
				gwidth: 100
			},
			type:'ComboRec',
			filters:{pfiltro:'fun.desc_funcionario1',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},		
		{
			config:{
				name: 'obs',
				fieldLabel: 'Obs',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1000
			},
			type:'TextArea',
			filters:{pfiltro:'obpg.obs',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'porc_anticipo',
				fieldLabel: 'Porc. Anticipo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:131074,
				maxValue:100
			},
			type:'NumberField',
			filters:{pfiltro:'obpg.porc_anticipo',type:'numeric'},
			id_grupo:1,
			grid:false,
			form:false
		},
		{
			config:{
				name: 'porc_retgar',
				fieldLabel: '%. Retgar',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:131074,
				maxValue:100
			},
			type:'NumberField',
			filters:{pfiltro:'obpg.porc_retgar',type:'numeric'},
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
                gwidth: 100,
                maxLength:200
            },
            type:'TextField',
            filters:{pfiltro:'obpg.num_tramite',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },		
		{
			config:{
				labelSeparator:'Estado Reg.',
				name: 'estado_reg'
			},
			type:'Field',
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
			filters:{pfiltro:'obpg.fecha_reg',type:'date'},
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
			filters:{pfiltro:'usu1.cuenta',type:'string'},
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
			filters:{pfiltro:'obpg.fecha_mod',type:'date'},
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
	
	title:'Obligaciones de Pago',
	ActSave:'../../sis_tesoreria/control/ObligacionPago/insertarObligacionPago',
	ActDel:'../../sis_tesoreria/control/ObligacionPago/eliminarObligacionPago',
	ActList:'../../sis_tesoreria/control/ObligacionPago/listarObligacionPago',
	id_store:'id_obligacion_pago',
	fields: [
		{name:'id_obligacion_pago', type: 'numeric'},
		{name:'id_proveedor', type: 'numeric'},
		{name:'desc_proveedor', type: 'string'},
		{name:'estado', type: 'string'},
		{name:'tipo_obligacion', type: 'string'},
		{name:'id_moneda', type: 'numeric'},
		{name:'moneda', type: 'string'},
		{name:'obs', type: 'string'},
		{name:'porc_retgar', type: 'numeric'},
		{name:'id_subsistema', type: 'numeric'},
		{name:'nombre_subsistema', type: 'string'},
		{name:'id_funcionario', type: 'numeric'},
		{name:'desc_funcionario1', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'porc_anticipo', type: 'numeric'},
		{name:'id_estado_wf', type: 'numeric'},
		{name:'id_depto', type: 'numeric'},
		{name:'nombre_depto', type: 'string'},
		{name:'num_tramite', type: 'string'},
		{name:'id_proceso_wf', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'fecha', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'tipo_cambio_conv', type: 'numeric'},
		{name:'id_depto_conta', type: 'numeric'},
		'numero','pago_variable','total_pago',
		'id_gestion','comprometido','nro_cuota_vigente','tipo_moneda'
		
	],
	
	sortInfo:{
		field: 'id_obligacion_pago',
		direction: 'ASC'
	},
	
	repComEjePag: function(){
            var rec = this.sm.getSelected();        
            if(rec){
                Phx.CP.loadWindows('../../../sis_tesoreria/vista/obligacion_pago/ReporteComEjePag.php',
                        'Reporte de Obligacion',
                        {
                            width:400,
                            height:200
                        },
                        rec.data,this.idContenedor,'ReporteComEjePag')
           }
        },
	
		repPlanPago:function(){
        var rec=this.sm.getSelected();
                Ext.Ajax.request({
                    url:'../../sis_tesoreria/control/ObligacionPago/reportePlanesPago',
                    params:{'id_obligacion_pago':rec.data.id_obligacion_pago},
                    success: this.successExport,
                    failure: function() {
                        console.log("fail");
                    },
                    timeout: function() {
                        console.log("timeout");
                    },
                    scope:this
                });  
    },

	
	iniciarEventos:function(){
			
		this.cmpProveedor = this.getComponente('id_proveedor');
		this.cmpFuncionario = this.getComponente('id_funcionario');
		this.cmpFuncionarioProveedor = this.getComponente('funcionario_proveedor');
	    this.cmpFecha=this.getComponente('fecha');
	    this.cmpTipoObligacion=this.getComponente('tipo_obligacion');
	    this.cmpMoneda=this.getComponente('id_moneda');
	    this.cmpDepto=this.getComponente('id_depto');
	    this.cmpTipoCambioConv=this.getComponente('tipo_cambio_conv');
	    
	   // this.cmpPorcAnticipo=this.getComponente('porc_anticipo');
	   // this.cmpPorcRetgar=this.getComponente('porc_retgar');
		
		this.ocultarComponente(this.cmpProveedor);
		this.ocultarComponente(this.cmpFuncionario);
		this.ocultarComponente(this.cmpFuncionarioProveedor);
		
		 this.cmpMoneda.on('select',function(com,dat){
              
              if(dat.data.tipo_moneda=='base'){
                 this.cmpTipoCambioConv.disable();
                 this.cmpTipoCambioConv.setValue(1); 
                  
              }
              else{
                   this.cmpTipoCambioConv.enable()
                 this.obtenerTipoCambio();  
              }
             
              
          },this);
		
		this.cmpTipoObligacion.on('select',function(c,rec,ind){
				
				n=rec.data.variable;
				
				if(n=='adquisiciones' ||n=='pago_directo'){
					this.cmpProveedor.enable();
					this.mostrarComponente(this.cmpProveedor);
					this.ocultarComponente(this.cmpFuncionario);
					this.ocultarComponente(this.cmpFuncionarioProveedor);
					this.cmpFuncionario.reset();
				}else{
					if(n=='viatico' || n=='fondo_en_avance'){
								this.cmpFuncionario.enable();
								this.mostrarComponente(this.cmpFuncionario);
								this.ocultarComponente(this.cmpProveedor);
								this.ocultarComponente(this.cmpFuncionarioProveedor);								
								this.cmpProveedor.reset();
						}else{							
							 this.cmpFuncionarioProveedor.reset();
							 this.cmpFuncionarioProveedor.enable();
							 this.mostrarComponente(this.cmpFuncionarioProveedor);							
							 this.mostrarComponente(this.cmpFuncionario);
							 this.ocultarComponente(this.cmpProveedor);
							
                            this.cmpFuncionarioProveedor.on('change',function(groupRadio,radio){
                                this.enableDisable(radio.inputValue);
                            },this);
						}
				}				
		},this);
		
	},
	
	onButtonEdit:function(){
       
       var data= this.sm.getSelected().data;
       this.cmpTipoObligacion.disable();
       this.cmpDepto.disable(); 
       this.cmpFecha.disable(); 
       this.cmpTipoCambioConv.disable();
       
        
       if(data.tipo_obligacion=='adquisiciones'){
            this.mostrarComponente(this.cmpProveedor);
            this.ocultarComponente(this.cmpFuncionario);
            this.ocultarComponente(this.cmpFuncionarioProveedor);
            this.cmpFuncionario.reset();
            this.cmpProveedor.disable();
            this.cmpMoneda.disable();
       }
       
       if(data.tipo_obligacion=='pago_directo'){
           
           this.cmpProveedor.enable();
           this.mostrarComponente(this.cmpProveedor);
           this.cmpMoneda.enable();
       }
       
       
       Phx.vista.ObligacionPago.superclass.onButtonEdit.call(this);
           
    },
    
    onButtonNew:function(){
        Phx.vista.ObligacionPago.superclass.onButtonNew.call(this);
        //this.cmpPorcAnticipo.setValue(0);
        //this.cmpPorcRetgar.setValue(0);
       
        this.ocultarComponente(this.cmpProveedor);
        this.ocultarComponente(this.cmpFuncionario);
        this.ocultarComponente(this.cmpFuncionarioProveedor);
        
        this.cmpTipoObligacion.enable();
        this.cmpDepto.enable(); 
        
        
        this.mostrarComponente(this.cmpProveedor);
        this.ocultarComponente(this.cmpFuncionario);
        this.ocultarComponente(this.cmpFuncionarioProveedor);
        this.cmpFuncionario.reset();
        this.cmpFecha.enable(); 
        this.cmpTipoCambioConv.enable();
        this.cmpProveedor.enable();
        this.cmpDepto.enable(); 
        this.cmpMoneda.enable();
        
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
	
	enableDisable: function(val){
       var cmbIt = this.getComponente('id_funcionario');
       var cmbServ = this.getComponente('id_proveedor');
       if(val=='funcionario'){   	   	
			cmbServ.reset();
			cmbIt.reset();
			this.mostrarComponente(cmbIt);
			this.ocultarComponente(cmbServ);
       } else{   	
			cmbServ.reset();
            cmbIt.reset();
			this.mostrarComponente(cmbServ);
			this.ocultarComponente(cmbIt);
       }   
     },
     fin_registro:function()
        {                   
            var d= this.sm.getSelected().data;
           
            if(d.estado !='en_pago'){
            //if(confirm('¿Está seguro de eliminar el registro?')){
            Phx.CP.loadingShow();
            
                Ext.Ajax.request({
                    // form:this.form.getForm().getEl(),
                    url:'../../sis_tesoreria/control/ObligacionPago/finalizarRegistro',
                    params:{id_obligacion_pago:d.id_obligacion_pago,operacion:'fin_registro'},
                    success:this.successSinc,
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
                }); 
            
            }
            else{
                if(d.estado =='en_pago'){
                    if(confirm('¿Está seguro finalizar la obligacion?. \n Esta acción no  puede revertirse')){
                            Ext.Ajax.request({
                            // form:this.form.getForm().getEl(),
                            url:'../../sis_tesoreria/control/ObligacionPago/finalizarRegistro',
                            params:{id_obligacion_pago:d.id_obligacion_pago,operacion:'fin_registro'},
                            success:this.successSinc,
                            failure: this.conexionFailure,
                            timeout:this.timeout,
                            scope:this
                        }); 
                     }
                } 
           }  
      }, 
     successSinc:function(resp){
            Phx.CP.loadingHide();
             var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
                
                this.reload();
             }else{
                alert('ocurrio un error durante el proceso')
            }
     },
     antEstado:function(res,eve)
     {                   
            var d= this.sm.getSelected().data;
            Phx.CP.loadingShow();
            var operacion = 'cambiar';
            operacion=  res.argument.estado == 'inicio'?'inicio':operacion; 
            
            Ext.Ajax.request({
                url:'../../sis_tesoreria/control/ObligacionPago/anteriorEstadoObligacion',
                params:{id_obligacion_pago:d.id_obligacion_pago, 
                        operacion: operacion},
                success:this.successSinc,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });     
      },
     
      preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;
          
          
          Phx.vista.ObligacionPago.superclass.preparaMenu.call(this,n); 
          if (data['estado']== 'borrador'){
              this.getBoton('edit').enable();
              if(this.getBoton('new'))
                this.getBoton('new').enable();
              
              this.getBoton('del').enable();    
              this.getBoton('fin_registro').enable();
               this.getBoton('ant_estado').disable();
          
              this.TabPanelSouth.get(1).disable();
          
          }
          else{
              
              
               if (data['estado']== 'registrado'){   
                  this.getBoton('ant_estado').enable();
                  this.getBoton('fin_registro').disable();
                  this.TabPanelSouth.get(1).enable()
                }
                
                if (data['estado']== 'en_pago'){
                    this.TabPanelSouth.get(1).enable()
                    this.getBoton('ant_estado').enable();
                    this.getBoton('fin_registro').enable();
                    
                }
                
               
                
                if (data['estado']== 'anulado'){
                    this.getBoton('fin_registro').disable();
                    this.TabPanelSouth.get(1).disable();
                }
              
              this.getBoton('edit').disable();
              this.getBoton('del').disable();
          }
          this.getBoton('reporte_com_ejec_pag').enable();
          this.getBoton('reporte_plan_pago').enable();
          
          if(data.tipo_obligacion=='adquisiciones'){
              //RCM: menú de reportes de adquisiciones
              this.menuAdq.enable();
              //Inhabilita el reporte de disponibilidad
              this.getBoton('btnVerifPresup').disable();
              
          }
          else{
              //RCM: menú de reportes de adquisiciones
              this.menuAdq.disable();
              
              //Habilita el reporte de disponibilidad si está en estado borrador
              if (data['estado']== 'borrador'){
              	this.getBoton('btnVerifPresup').enable();
              } else{
              	//Inhabilita el reporte de disponibilidad
              	this.getBoton('btnVerifPresup').disable();
              }
              
          }
     },
     
     
     liberaMenu:function(){
        var tb = Phx.vista.ObligacionPago.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('fin_registro').disable();
            this.getBoton('ant_estado').disable();
            this.getBoton('reporte_com_ejec_pag').disable();
			this.getBoton('reporte_plan_pago').disable();
			//Inhabilita el reporte de disponibilidad
            this.getBoton('btnVerifPresup').disable();
        }
       this.TabPanelSouth.get(1).disable();
       
       //RCM: menú de reportes de adquisiciones
       this.menuAdq.disable();
        
       return tb
    }, 
    
    tabsouth:[
            { 
             url:'../../../sis_tesoreria/vista/obligacion_det/ObligacionDet.php',
             title:'Detalle', 
             height:'50%',
             cls:'ObligacionDet'
            },
            {
              url:'../../../sis_tesoreria/vista/plan_pago/PlanPagoReq.php',
              title:'Plan de Pagos', 
              height:'50%',
              cls:'PlanPagoReq'
            }
    
       ], 
       
      
     
    bdel:true,
    bedit:true,
	bsave:false,
	addBotones: function() {
        this.menuAdq = new Ext.Toolbar.SplitButton({
            id: 'btn-adq-' + this.idContenedor,
            text: 'Orden de Compra',
            handler: this.onBtnAdq,
            disabled: true,
            scope: this,
            menu:{
            items: [{
                id:'btn-cot-' + this.idContenedor,
                text: 'Cotización',
                tooltip: '<b>Reporte de la Cotización</b>',
                handler:this.onBtnCot,
                scope: this
            }, {
                id:'btn-proc-' + this.idContenedor,
                text: 'Cuadro Comparativo',
                tooltip: '<b>Reporte de Cuadro Comparativo</b>',
                handler:this.onBtnProc,
                scope: this
            }, {
                id:'btn-sol-' + this.idContenedor,
                text: 'Solicitud de Compra',
                tooltip: '<b>Reporte de la Solicitud de Compra</b>',
                handler:this.onBtnSol,
                scope: this
            }, {
                id:'btn-docsol-' + this.idContenedor,
                text: 'Documentos',
                tooltip: '<b>Documentos anexos a la solicitud de compra</b>',
                handler:this.onBtnDocSol,
                scope: this
            }
        ]}
        });
        
        //Adiciona el menú a la barra de herramientas
        this.tbar.add(this.menuAdq);
    },
    
    onBtnAdq: function(){
        Phx.CP.loadingShow();
        var rec = this.sm.getSelected();
        var data = rec.data;
        if(data){
            //Obtiene los IDS
            this.auxFuncion='onBtnAdq';
            this.obtenerIDS(data);
        } else {
            alert('Seleccione un registro y vuelta a intentarlo');
        }
    },
    
    onBtnCot: function(){
        Phx.CP.loadingShow();
        var rec = this.sm.getSelected();
        var data = rec.data;
        if(data){
            //Obtiene los IDS
            this.auxFuncion='onBtnCot';
            this.obtenerIDS(data);
        } else {
            alert('Seleccione un registro y vuelta a intentarlo');
        }
    },
    
    onBtnSol: function(){
        Phx.CP.loadingShow();
        var rec = this.sm.getSelected();
        var data = rec.data;
        if(data){
            //Obtiene los IDS
            this.auxFuncion='onBtnSol';
            this.obtenerIDS(data);
        } else {
            alert('Seleccione un registro y vuelta a intentarlo');
        }
    },
    
    onBtnProc: function(){
        Phx.CP.loadingShow();
        var rec = this.sm.getSelected();
        var data = rec.data;
        if(data){
            //Obtiene los IDS
            this.auxFuncion='onBtnProc';
            this.obtenerIDS(data);
        } else {
            alert('Seleccione un registro y vuelta a intentarlo');
        }
    },
     onBtnDocSol: function(){
        Phx.CP.loadingShow();
        var rec = this.sm.getSelected();
        var data = rec.data;
        if(data){
            //Obtiene los IDS
            this.auxFuncion='onBtnDocSol';
            this.obtenerIDS(data);
        } else {
            alert('Seleccione un registro y vuelta a intentarlo');
        }
    },
    
    obtenerIDS: function(data){
        Ext.Ajax.request({
            url: '../../sis_tesoreria/control/ObligacionPago/obtenerIdsExternos',
            params: {
                id_obligacion_pago: data.id_obligacion_pago,
                sistema: this.sistema
            },
            success: this.successobtenerIDS,
            failure: this.conexionFailure,
            timeout: this.timeout,
            scope: this
        });
    },
    successobtenerIDS: function(resp) {
        Phx.CP.loadingHide();
        var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
        if (!reg.ROOT.error) {
            //Setea los valores a variables locales
            var ids=reg.ROOT.datos;
            this.id_cotizacion = ids.id_cotizacion,
            this.id_proceso_compra = ids.id_proceso_compra,
            this.id_solicitud = ids.id_solicitud
            
            //Genera el reporte en función del botón presionado
            if(this.auxFuncion=='onBtnAdq'){
                Ext.Ajax.request({
                    url:'../../sis_adquisiciones/control/Cotizacion/reporteOC',
                    params:{'id_cotizacion':this.id_cotizacion},
                    success: this.successExport,
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
                });
                
            } else if(this.auxFuncion=='onBtnCot'){
                Ext.Ajax.request({
                    url:'../../sis_adquisiciones/control/Cotizacion/reporteCotizacion',
                    params:{'id_cotizacion':this.id_cotizacion,tipo:'cotizado'},
                    success: this.successExport,
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
                });  
                
            } else if(this.auxFuncion=='onBtnSol'){
                Ext.Ajax.request({
                    url:'../../sis_adquisiciones/control/Solicitud/reporteSolicitud',
                    params:{'id_solicitud':this.id_solicitud},
                    success: this.successExport,
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
                });  
                
            } else if(this.auxFuncion=='onBtnProc'){
                Ext.Ajax.request({
                     url:'../../sis_adquisiciones/control/ProcesoCompra/cuadroComparativo',
                     params:{id_proceso_compra:this.id_proceso_compra},
                     success: this.successExport,
                     success: this.successExport,
                     failure: this.conexionFailure,
                     scope:this
                 });
                 
             } else if(this.auxFuncion=='onBtnDocSol'){   
                Phx.CP.loadWindows('../../../sis_adquisiciones/vista/documento_sol/ChequeoDocumentoSol.php',
                            'Chequeo de documentos de la solicitud',
                            {
                                width:700,
                                height:450
                            },
                            {'id_solicitud':this.id_solicitud},  
                            this.idContenedor,
                            'ChequeoDocumentoSol')      
                
            } else{
                alert('Reporte no reconocido');
            }

        } else {

            alert('ocurrio un error durante el proceso')
        }

	},
	
	onBtnVerifPresup : function() {
        var rec = this.sm.getSelected();
        //Se define el nombre de la columna de la llave primaria
        rec.data.tabla_id = this.tabla_id;
        rec.data.tabla = this.tabla;
        
        Phx.CP.loadWindows('../../../sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 'Disponibilidad Presupuestaria', {
            modal : true,
            width : '80%',
            height : '50%',
        }, rec.data, this.idContenedor, 'VerificacionPresup');
    },
	
	sistema: 'ADQ',
	id_cotizacion: 0,
	id_proceso_compra: 0,
	id_solicitud: 0,
	auxFuncion:'onBtnAdq',
	tabla_id: 'id_obligacion_pago',
	tabla:'tes.tobligacion_pago'
	
})
</script>
		
		