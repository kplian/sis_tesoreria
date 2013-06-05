<?php
/**
*@package pXP
*@file gen-PlanPago.php
*@author  (admin)
*@date 10-04-2013 15:43:23
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PlanPago=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.PlanPago.superclass.constructor.call(this,config);
		this.init();
		this.iniciarEventos();
		 //si la interface es pestanha este código es para iniciar 
          var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
          if(dataPadre){
             this.onEnablePanel(this, dataPadre);
          }
          else
          {
             this.bloquearMenus();
          }
	},
	tam_pag:50,

	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_plan_pago'
			},
			type:'Field',
			form:true 
		},
        {
            config:{
                name: 'id_obligacion_pago',
                inputType:'hidden'
            },
            type:'Field',
            form:true
        },
        {
            config:{
                name: 'id_plan_pago_fk',
                inputType:'hidden',
            },
            type:'NumberField',
            form:true
        } ,
        {
            config:{
                name: 'nro_cuota',
                fieldLabel: 'Cuo. N#',
                allowBlank: true,
                gwidth: 100,
                renderer:function(value,p,record){
                       if(record.data.total_prorrateado!=record.data.monto_ejecutar_total_mo ){
                             return String.format('<b><font color="red">{0}</font></b>', value);
                         }
                          else{
                            return String.format('{0}', value);
                        }},
                maxLength:4
            },
            type:'NumberField',
            filters:{pfiltro:'plapa.nro_cuota',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'estado',
                fieldLabel: 'Estado',
                allowBlank: true,
                renderer:function(value,p,record){
                        if(record.data.total_prorrateado!=record.data.monto_ejecutar_total_mo ){
                             return String.format('<b><font color="red">{0}</font></b>', value);
                         }
                          else{
                            return String.format('{0}', value);
                        }},
                anchor: '80%',
                gwidth: 100,
                maxLength:60
            },
            type:'Field',
            filters:{pfiltro:'plapa.estado',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
         {
            config:{
                name: 'tipo_pago',
                fieldLabel: 'Tipo de Cuoata',
                allowBlank: false,
                 emptyText:'Tipo de Cuoata',
                renderer:function (value, p, record){
                        var dato='';
                        dato = (dato==''&&value=='anticipo')?'Anticipo':dato;
                        dato = (dato==''&&value=='adelanto')?'Adelanto':dato;
                        dato = (dato==''&&value=='normal')?'Normal':dato;
                        return String.format('{0}', dato);
                    },
            
                    store:new Ext.data.ArrayStore({
                            fields: ['variable', 'valor'],
                            data : [ //['anticipo','Anticipo (No ejecuta Presupuesto)'],
                                     ['adelanto','Adelanto (Ejecuta Presupueto)'],
                                     ['normal','Normal']]
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
            filters:{pfiltro:'tipo_pago',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },{
           config:{
               name: 'tipo',
               fieldLabel: 'Operación',
               gwidth: 100,
               maxLength:30,
               renderer:this.renderFunction,
               items: [
                   {boxLabel: 'Devengar y Pagar',name: 'rg-auto',  inputValue: 'devengado_pagado', checked:true},
                   {boxLabel: 'Devengar',name: 'rg-auto', inputValue: 'devengado'}
               ]
           },
           type:'RadioGroupField',
           filters:{pfiltro:'plapa.tipo',type:'string'},
           id_grupo:1,
           grid:false,
           form:true
          }
         ,
		{
			config:{
				name: 'nro_sol_pago',
				fieldLabel: 'Número',
				allowBlank: true,
				renderer:function(value,p,record){
                        if(record.data.total_prorrateado!=record.data.monto_ejecutar_total_mo ){
                             return String.format('<b><font color="red">{0}</font></b>', value);
                         }
                          else{
                            return String.format('{0}', value);
                        }},
				anchor: '80%',
				gwidth: 100,
				maxLength:60
			},
			type:'TextField',
			filters:{pfiltro:'plapa.nro_sol_pago',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
        {
            config:{
                name: 'fecha_tentativa',
                fieldLabel: 'Fecha Tent.',
                allowBlank: false,
                gwidth: 100,
                        format: 'd/m/Y', 
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'plapa.fecha_dev',type:'date'},
            id_grupo:1,
            grid:true,
            form:true
        },
		{
			config:{
				name: 'fecha_dev',
				fieldLabel: 'Fecha Dev.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'plapa.fecha_dev',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		},
        {
            config:{
                name: 'fecha_pag',
                fieldLabel: 'Fecha Pago',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                        format: 'd/m/Y', 
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'plapa.fecha_pag',type:'date'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'tipo_cambio',
                fieldLabel: 'Tip Cambio',
                allowBlank: false,
                gwidth: 100,
                maxLength:1245186
            },
            type:'NumberField',
            filters:{pfiltro:'plapa.tipo_cambio',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:false
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
                    baseParams:{par_filtro:'plt.desc_plantilla',sw_compro:'si',sw_tesoro:'si'}
                }),
                tpl:'<tpl for="."><div class="x-combo-list-item"><p>{desc_plantilla}</p></div></tpl>',
                valueField: 'id_plantilla',
                hiddenValue: 'id_plantilla',
                displayField: 'desc_plantilla',
                gdisplayField:'desc_plantilla',
                listWidth:'280',
                forceSelection:true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:20,
                queryDelay:500,
               
                gwidth: 250,
                minChars:2,
                renderer:function (value, p, record){return String.format('{0}', record.data['desc_plantilla']);}
            },
            type:'ComboBox',
            filters:{pfiltro:'pla.desc_plantilla',type:'string'},
            id_grupo:0,
            grid:true,
            form:true
        },{
           config:{
               name: 'forma_pago',
               fieldLabel: 'Forma de Pago',
               gwidth: 100,
               maxLength:30,
               items: [
                   {boxLabel: 'Cheque',name: 'fp-auto',  inputValue: 'cheque', checked:true},
                   {boxLabel: 'Transferencia',name: 'fp-auto', inputValue: 'transferencia'}
                   //,{boxLabel: 'Caja',name: 'fp-auto', inputValue: 'Caja'}
               ]
           },
           type:'RadioGroupField',
           filters:{pfiltro:'plapa.forma_pago',type:'string'},
           id_grupo:1,
           grid:false,
           form:true
          },
		 {
            config:{
                name: 'nombre_pago',
                fieldLabel: 'Nombre Pago',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:255
            },
            type:'TextField',
            filters:{pfiltro:'plapa.nombre_pago',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'id_cuenta_bancaria',
                fieldLabel: 'Cuenta Bancaria Origen',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:4
            },
            type:'NumberField',
            filters:{pfiltro:'plapa.id_cuenta_bancaria',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'monto',
                currencyChar:' ',
                allowNegative:false,
                fieldLabel: 'Monto a Pagar',
                allowBlank: false,
                gwidth: 100,
                maxLength:1245186
            },
            type:'MoneyField',
            filters:{pfiltro:'plapa.monto',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
		/*{
			config:{
				name: 'descuento_anticipo',
				currencyChar:' ',
				fieldLabel: 'Desc. Anticipo',
				allowBlank: true,
				allowNegative:false,
				gwidth: 100,
				maxLength:1245186
			},
			type:'MoneyField',
			filters:{pfiltro:'plapa.descuento_anticipo',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},*/
		{
			config:{
				name: 'monto_no_pagado',
				currencyChar:' ',
				fieldLabel: 'Monto no pagado',
				allowBlank: true,
				allowNegative:false,
				gwidth: 100,
				maxLength:1245186
			},
			type:'MoneyField',
			filters:{pfiltro:'plapa.monto_no_pagado',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
        {
            config:{
                name: 'otros_descuentos',
                currencyChar:' ',
                fieldLabel: 'Otros Decuentos',
                allowBlank: true,
                allowNegative:false,
                gwidth: 100,
                maxLength:1245186
            },
            type:'MoneyField',
            filters:{pfiltro:'plapa.otros_descuentos',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'monto_ejecutar_total_mo',
                currencyChar:' ',
                fieldLabel: 'Monto a Ejecutar',
                allowBlank: true,
                gwidth: 100,
                maxLength:1245186
            },
            type:'MoneyField',
            filters:{pfiltro:'plapa.monto_ejecutar_total_mo',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'liquido_pagable',
                currencyChar:' ',
                fieldLabel: 'Liquido Pagable',
                allowBlank: true,
                gwidth: 100,
                maxLength:1245186
            },
            type:'MoneyField',
            filters:{pfiltro:'plapa.liquido_pagable',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        /*{
            config:{
                name: 'obs_descuentos_anticipo',
                fieldLabel: 'Obs. Desc. Antic.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:300
            },
            type:'TextArea',
            filters:{pfiltro:'plapa.obs_descuentos_anticipo',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },*/
        {
            config:{
                name: 'obs_monto_no_pagado',
                fieldLabel: 'Obs. Monto no Pagado',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:300
            },
            type:'TextArea',
            filters:{pfiltro:'plapa.obs_monto_no_pagado',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'obs_otros_descuentos',
                fieldLabel: 'Obs. otros desc.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:300
            },
            type:'TextArea',
            filters:{pfiltro:'plapa.obs_otros_descuentos',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
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
            filters:{pfiltro:'plapa.estado_reg',type:'string'},
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
			filters:{pfiltro:'plapa.fecha_reg',type:'date'},
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
			filters:{pfiltro:'plapa.fecha_mod',type:'date'},
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
	
	title:'Plan Pago',
	ActSave:'../../sis_tesoreria/control/PlanPago/insertarPlanPago',
	ActDel:'../../sis_tesoreria/control/PlanPago/eliminarPlanPago',
	ActList:'../../sis_tesoreria/control/PlanPago/listarPlanPago',
	id_store:'id_plan_pago',
	fields: [
		{name:'id_plan_pago', type: 'numeric'},
		'id_obligacion_pago',
		{name:'estado_reg', type: 'string'},
		{name:'nro_cuota', type: 'numeric'},
		{name:'monto_ejecutar_totamonto_ejecutar_totall_mb', type: 'numeric'},
		{name:'nro_sol_pago', type: 'string'},
		{name:'tipo_cambio', type: 'numeric'},
		{name:'fecha_pag', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_proceso_wf', type: 'numeric'},
		{name:'fecha_tentativa', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_dev', type: 'date',dateFormat:'Y-m-d'},
		{name:'estado', type: 'string'},
		{name:'tipo_pago', type: 'string'},
		
		{name:'descuento_anticipo_mb', type: 'numeric'},
		{name:'obs_descuentos_anticipo', type: 'string'},
		{name:'id_plan_pago_fk', type: 'numeric'},
		
		{name:'id_plantilla', type: 'numeric'},
		{name:'descuento_anticipo', type: 'numeric'},
		{name:'otros_descuentos', type: 'numeric'},
		{name:'tipo', type: 'string'},
		{name:'obs_monto_no_pagado', type: 'string'},
		{name:'obs_otros_descuentos', type: 'string'},
		{name:'monto', type: 'numeric'},
		{name:'id_comprobante', type: 'numeric'},
		{name:'nombre_pago', type: 'string'},
		{name:'monto_no_pagado_mb', type: 'numeric'},
		{name:'monto_mb', type: 'numeric'},
		{name:'id_estado_wf', type: 'numeric'},
		{name:'id_cuenta_bancaria', type: 'numeric'},
		{name:'otros_descuentos_mb', type: 'numeric'},
		{name:'total_prorrateado', type: 'numeric'},
		{name:'monto_ejecutar_total_mo', type: 'numeric'},
		{name:'forma_pago', type: 'string'},
		{name:'monto_no_pagado', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'liquido_pagable','desc_plantilla'
		
	],
	iniciarEventos:function(){
        
        this.cmpObligacionPago=this.getComponente('id_obligacion_pago');
        this.cmpFechaTentativa=this.getComponente('fecha_tentativa');
      
        this.cmpTipoPago=this.getComponente('tipo_pago');
       
        this.cmpPlantilla=this.getComponente('id_plantilla');
        this.cmpNombrePago=this.getComponente('nombre_pago');
        this.cmpFormaPago=this.getComponente('forma_pago');
        this.cmpTipo=this.getComponente('tipo');
        this.cmpCuentaBancaria=this.getComponente('id_cuenta_bancaria');
        
        
        this.cmpMonto=this.getComponente('monto');
        //this.cmpDescuentoAnticipo=this.getComponente('descuento_anticipo');
        this.cmpMontoNoPagado=this.getComponente('monto_no_pagado');
        this.cmpOtrosDescuentos=this.getComponente('otros_descuentos');
        this.cmpLiquidoPagable=this.getComponente('liquido_pagable');
        this.cmpMontoEjecutarTotalMo=this.getComponente('monto_ejecutar_total_mo');
        
       // this.cmpObsDescuentoAnticipo=this.getComponente('obs_descuentos_anticipo');
        this.cmpObsMontoNoPagado=this.getComponente('obs_monto_no_pagado');
        this.cmpObsOtrosDescuentos=this.getComponente('obs_otros_descuentos');
       
       
        
        this.cmpMonto.on('change',this.calculaMontoPago,this); 
        //this.cmpDescuentoAnticipo.on('change',this.calculaMontoPago,this);
        this.cmpMontoNoPagado.on('change',this.calculaMontoPago,this);
        this.cmpOtrosDescuentos.on('change',this.calculaMontoPago,this);
        
        this.cmpTipo.on('change',function(groupRadio,radio){
                                this.enableDisable(radio.inputValue);
                            },this); 
          
        
      /* this.cmpFechaDev.on('change',function(com,dat){
              
              if(this.maestro.tipo_moneda=='base'){
                 this.cmpTipoCambio.disable();
                 this.cmpTipoCambio.setValue(1); 
                  
              }
              else{
                   this.cmpTipoCambio.enable()
                 this.obtenerTipoCambio();  
              }
             
              
          },this);*/
         
       
       
       this.cmpTipoPago.on('select',function(cmb,rec,i){
           if(rec.data.variable=='anticipo' || rec.data.variable=='adelanto'){
               this.cmpTipo.disable();
               this.ocultarComponente(this.cmpTipo);
               
               this.deshabilitarDescuentos();
               
               if(rec.data.variable=='anticipo'){
                   this.ocultarComponente(this.cmpMontoEjecutarTotalMo);
                   this.cmpPlantilla.disable();
                   this.ocultarComponente(this.cmpPlantilla);
               }
               else{
                   this.mostrarComponente(this.cmpMontoEjecutarTotalMo);
                   this.cmpPlantilla.enable();
                   this.mostrarComponente(this.cmpPlantilla);
                   
               }
               
           
           
           }
           else{
               this.cmpTipo.enable();
               this.mostrarComponente(this.cmpTipo);
               this.mostrarComponente(this.cmpMontoEjecutarTotalMo)
               this.habilitarDescuentos();
           }
           
           
       },this);   
    
    
    
    },
    
    setTipoPagoNormal:function(){
        this.cmpTipo.enable();
       this.mostrarComponente(this.cmpTipo);
       this.mostrarComponente(this.cmpMontoEjecutarTotalMo)
       this.habilitarDescuentos();
        
    },
     
    
    calculaMontoPago:function(){
        this.cmpLiquidoPagable.setValue(this.cmpMonto.getValue()  -  this.cmpMontoNoPagado.getValue() -  this.cmpOtrosDescuentos.getValue());
        this.cmpMontoEjecutarTotalMo.setValue(this.cmpMonto.getValue()  -  this.cmpMontoNoPagado.getValue());
     },
     
     enableDisable:function(val){
      if(val =='devengado'){
            
            this.cmpPlantilla.disable();
            this.ocultarComponente(this.cmpPlantilla);
            this.cmpNombrePago.disable();
            this.ocultarComponente(this.cmpNombrePago);
            this.cmpFormaPago.disable();
            this.ocultarComponente(this.cmpFormaPago);
            this.cmpFormaPago.disable();
            this.ocultarComponente(this.cmpFormaPago);
            this.cmpCuentaBancaria.disable()
            this.ocultarComponente(this.cmpCuentaBancaria);
            
           this.deshabilitarDescuentos()
            
        }
        else{
            this.cmpPlantilla.enable();
            this.mostrarComponente(this.cmpPlantilla);
            this.cmpNombrePago.enable();
            this.mostrarComponente(this.cmpNombrePago);
            this.cmpFormaPago.enable();
            this.mostrarComponente(this.cmpFormaPago);
            this.cmpFormaPago.enable();
            this.mostrarComponente(this.cmpFormaPago);
            this.cmpCuentaBancaria.enable()
            this.mostrarComponente(this.cmpCuentaBancaria);
            
            this.habilitarDescuentos();
            
         }
         
     },
     
    habilitarDescuentos:function(){
        //this.cmpDescuentoAnticipo.enable();
        //this.mostrarComponente(this.cmpDescuentoAnticipo);
        this.cmpOtrosDescuentos.enable();
        this.mostrarComponente(this.cmpOtrosDescuentos);
        
        //this.cmpObsDescuentoAnticipo.enable();
        //this.mostrarComponente(this.cmpObsDescuentoAnticipo);
        this.cmpObsOtrosDescuentos.enable();
        this.mostrarComponente(this.cmpObsOtrosDescuentos);
        
    } ,
     deshabilitarDescuentos:function(){
       // this.cmpDescuentoAnticipo.disable();
       // this.ocultarComponente(this.cmpDescuentoAnticipo);
        this.cmpOtrosDescuentos.disable();
        this.ocultarComponente(this.cmpOtrosDescuentos);
        
         
        //this.cmpObsDescuentoAnticipo.disable();
        //this.ocultarComponente(this.cmpObsDescuentoAnticipo);
        this.cmpObsOtrosDescuentos.disable();
        this.ocultarComponente(this.cmpObsOtrosDescuentos);
            
        
    } ,
    
    
    onButtonNew:function(){
        Phx.vista.PlanPago.superclass.onButtonNew.call(this); 
        this.cmpObligacionPago.setValue(this.maestro.id_obligacion_pago);
        
        if(this.maestro.nro_cuota_vigente ==0){
            this.cmpTipoPago.setValue('normal');
            this.cmpTipoPago.enable();
        }
        else{
             this.cmpTipoPago.setValue('normal');
              this.cmpTipoPago.disable();
        }
         this.setTipoPagoNormal();
        this.cmpFechaTentativa.minValue=new Date();
        this.cmpFechaTentativa.setValue(new Date());
        this.cmpNombrePago.setValue(this.maestro.desc_proveedor);
        this.cmpMonto.setValue(0);
       // this.cmpDescuentoAnticipo.setValue(0);
        this.cmpMontoNoPagado.setValue(0);
        this.cmpOtrosDescuentos.setValue(0);
        this.cmpLiquidoPagable.setValue(0);
        this.cmpMontoEjecutarTotalMo.setValue(0);
        this.cmpLiquidoPagable.disable();
        this.cmpMontoEjecutarTotalMo.disable();
        this.obtenerFaltante('registrado');
     },
     
      onButtonEdit:function(){
       
          Phx.vista.PlanPago.superclass.onButtonEdit.call(this); 
          this.cmpFechaTentativa.disable();
          this.cmpTipo.disable();
          this.cmpTipo.disable();
          this.cmpTipoPago.disable();
          
          
          
      
      
      },
    
    obtenerFaltante:function(filtro){
       Phx.CP.loadingShow();
            Ext.Ajax.request({
                    // form:this.form.getForm().getEl(),
                    url:'../../sis_tesoreria/control/ObligacionPago/obtenerFaltante',
                    params:{ope_filtro:filtro, id_obligacion_pago: this.maestro.id_obligacion_pago},
                    success:this.successOF,
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
             });
    
        
    },
    
     successOF:function(resp){
       Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
                if(reg.ROOT.datos.monto_total_faltante > 0){
                    this.cmpMonto.setValue(reg.ROOT.datos.monto_total_faltante);
                }
                else{
                    
                    this.cmpMonto.setValue(0);
                }
                this.calculaMontoPago();
            }else{
                
                alert('error al obtener saldo por registrar')
            } 
    },
    
     obtenerTipoCambio:function(){
         
         var fecha = this.cmpFechaDev.getValue().dateFormat(this.cmpFechaDev.format);
         var id_moneda = this.maestro.id_moneda;
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
                
                this.cmpTipoCambio.setValue(reg.ROOT.datos.tipo_cambio);
            }else{
                
                alert('ocurrio al obtener el tipo de Cambio')
            } 
    },
	onReloadPage:function(m){
        this.maestro=m;
        this.store.baseParams={id_obligacion_pago:this.maestro.id_obligacion_pago};
        this.load({params:{start:0, limit:this.tam_pag}})
       
    },
    
    successSave: function(resp) {
       Phx.CP.getPagina(this.idContenedorPadre).reload();  
      Phx.vista.PlanPago.superclass.successSave.call(this,resp);
        
        
    },
    successDel:function(resp){
       Phx.CP.getPagina(this.idContenedorPadre).reload(); 
       Phx.vista.PlanPago.superclass.successDel.call(this,resp);
     },
     
      preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;
          Phx.vista.PlanPago.superclass.preparaMenu.call(this,n); 
          if (data['estado']== 'borrador'){
              this.getBoton('edit').enable();
              this.getBoton('new').enable();
              this.getBoton('del').enable();    
          }
          else{
              this.getBoton('edit').disable();
              this.getBoton('new').disable();
              this.getBoton('del').disable();
          }
     },
     
      liberaMenu:function(){
        var tb = Phx.vista.PlanPago.superclass.liberaMenu.call(this);
        if(tb){
           
           

        }
      
       return tb
    }, 
    east:{
          url:'../../../sis_tesoreria/vista/prorrateo/Prorrateo.php',
          title:'Prorrateo', 
          width:400,
          cls:'Prorrateo'
     },

    
	sortInfo:{
		field: 'id_plan_pago',
		direction: 'ASC'
	},
	bdel:true,
	bedit:true,
	bsave:true
	}
)
</script>
		
		