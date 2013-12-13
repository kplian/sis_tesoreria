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
		this.addButton('SolDevPag',{text:'Solicitar Devengado/Pago',iconCls: 'bpagar',disabled:true,handler:this.onBtnDevPag,tooltip: '<b>Solicitar Devengado/Pago</b><br/>Genera en cotabilidad el comprobante Correspondiente, devengado o pago  '});
        this.addButton('SincPresu',{text:'Inc. Pres.',iconCls: 'balert',disabled:true,handler:this.onBtnSincPresu,tooltip: '<b>Incrementar Presupuesto</b><br/> Incremeta el presupuesto exacto para proceder con el pago'});
        this.addButton('SolPlanPago',{text:'Sol. Plan Pago.',iconCls: 'bpdf32',disabled:true,handler:this.onBtnSolPlanPago,tooltip: '<b>Solicitud Plan Pago</b><br/> Incremeta el presupuesto exacto para proceder con el pago'});      
		////formulario de departamentos
        
        this.cmpDeptoConta = new Ext.form.ComboBox({
                    xtype: 'combo',
                    name: 'id_depto_conta',
                    hiddenName: 'id_depto_conta',
                    fieldLabel: 'Depto. Conta.',
                    allowBlank: false,
                    emptyText:'Elija un Depto',
                    store:new Ext.data.JsonStore(
                    {
                        url: '../../sis_tesoreria/control/ObligacionPago/listarDeptoFiltradoObligacionPago',
                        id: 'id_depto',
                        root: 'datos',
                        sortInfo:{
                            field: 'deppto.nombre',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_depto','nombre'],
                        // turn on remote sorting
                        remoteSort: true,
                        baseParams:{par_filtro:'deppto.nombre#deppto.codigo',estado:'activo',codigo_subsistema:'CONTA',tipo_filtro:'DEP_EP-DEP_EP'}
                    }),
                    valueField: 'id_depto',
                    displayField: 'nombre',
                    tpl:'<tpl for="."><div class="x-combo-list-item"><p>{nombre}</p></div></tpl>',
                    hiddenName: 'id_depto_tes',
                    forceSelection:true,
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode:'remote',
                    pageSize:10,
                    queryDelay:1000,
                    width:250,
                    listWidth:'280',
                    minChars:2
                });
        
        this.formDEPTO = new Ext.form.FormPanel({
            baseCls: 'x-plain',
            autoDestroy: true,
            layout: 'form',
            items: [this.cmpDeptoConta]
        });
        
       
        
        this.wDEPTO= new Ext.Window({
            title: 'Depto Tesoreria',
            collapsible: true,
            maximizable: true,
             autoDestroy: true,
            width: 400,
            height: 200,
            layout: 'fit',
            plain: true,
            bodyStyle: 'padding:5px;',
            buttonAlign: 'center',
            items: this.formDEPTO,
            modal:true,
             closeAction: 'hide',
            buttons: [{
                text: 'Guardar',
                 handler:this.onSubmitDepto,
                scope:this
                
            },{
                text: 'Cancelar',
                handler:function(){this.wDEPTO.hide()},
                scope:this
            }]
        }); 
		
		
		
		
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
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'porc_descuento_ley'
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
            type:'Field',
            form:true
        } ,
        {
            config:{
                name: 'nro_cuota',
                fieldLabel: 'Cuo. N#',
                allowBlank: true,
                gwidth: 100,
                renderer:function(value,p,record){
                       if(record.data.total_pagado==record.data.monto_ejecutar_total_mo ){
                             return String.format('<b><font color="green">{0}</font></b>', value);
                         }
                        else {
                            
                                if(record.data.total_prorrateado!=record.data.monto_ejecutar_total_mo ){
                                  return String.format('<b><font color="red">{0}</font></b>', value);
                                 }
                                 else{
                                         if(record.data.total_pagado!=record.data.monto_ejecutar_total_mo 
                                             && (record.data.tipo=='devengado'  || record.data.tipo=='devengado_pagado')){
                                             return String.format('<b><font color="orange">{0}</font></b>', value);
                                         }
                                         else{
                                             if(record.data.tipo=='pagado'){
                                                 return String.format('--> {0}', value);  
                                             } 
                                             else{
                                                return String.format('{0}', value);   
                                             }
                                           
                                         }
                                   
                                }
                        }
                      },
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
			grid:false,
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
                name: 'tipo_cambio',
                fieldLabel: 'Tipo Cambio',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:131074
            },
            type:'NumberField',
            filters:{pfiltro:'tipo_cambio',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
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
                name: 'nro_cheque',
                fieldLabel: 'Número Cheque',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:255
            },
            type:'NumberField',
            filters:{pfiltro:'plapa.nro_cheque',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'nro_cuenta_bancaria',
                fieldLabel: 'Banco y Cuenta Bancaria Dest.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:50,
                disabled:true
            },
            type:'TextField',
            filters:{pfiltro:'plapa.nro_cuenta_bancaria',type:'string'},
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
                name: 'monto_retgar_mo',
                currencyChar:' ',
                fieldLabel: 'Ret. Garantia',
                allowBlank: true,
                allowNegative:false,
                gwidth: 100,
                maxLength:1245186
            },
            type:'MoneyField',
            filters:{pfiltro:'plapa.monto_retgar_mo',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
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
                name: 'descuento_ley',
                currencyChar:' ',
                fieldLabel: 'Decuentos deLey',
                allowBlank: true,
                disabled:true,
                allowNegative:false,
                gwidth: 100,
                maxLength:1245186
            },
            type:'MoneyField',
            filters:{pfiltro:'plapa.descuento_ley',type:'numeric'},
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
                disabled:true,
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
                disabled:true,
                gwidth: 100,
                maxLength:1245186
            },
            type:'MoneyField',
            filters:{pfiltro:'plapa.liquido_pagable',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'id_cuenta_bancaria',
                fieldLabel: 'Cuenta Bancaria Pago',
                allowBlank: false,
                emptyText:'Elija una Cuenta...',
                store:new Ext.data.JsonStore(
                {
                    url: '../../sis_tesoreria/control/CuentaBancaria/listarCuentaBancaria',
                    id: 'id_cuenta_bancaria',
                    root:'datos',
                    sortInfo:{
                        field:'id_cuenta_bancaria',
                        direction:'ASC'
                    },
                    totalProperty:'total',
                    fields: ['id_cuenta_bancaria','nro_cuenta','nombre_institucion','codigo_moneda'],
                    remoteSort: true,
                    baseParams : {
						par_filtro : 'ctaban.nro_cuenta#inst.nombre'
					}
                }),
                tpl:'<tpl for="."><div class="x-combo-list-item"><p>{nombre_institucion}</p>{nro_cuenta} - {codigo_moneda}</div></tpl>',
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
                gwidth: 250,
                minChars:2,
                renderer:function(value, p, record){return String.format('{0}', record.data['desc_cuenta_bancaria']);}
             },
            type:'ComboBox',
            filters:{pfiltro:'cb.nro_cuenta',type:'string'},
            id_grupo:0,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'id_cuenta_bancaria_mov',
                fieldLabel: 'Depósito',
                allowBlank: true,
                emptyText : 'Depósito...',
                store: new Ext.data.JsonStore({
                            url:'../../sis_tesoreria/control/CuentaBancariaMov/listarCuentaBancariaMov',
                            id : 'id_cuenta_bancaria_mov',
                            root: 'datos',
                            sortInfo:{
                                    field: 'nro_doc_tipo',
                                    direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_cuenta_bancaria_mov','id_cuenta_bancaria','descripcion','observaciones','nro_doc_tipo','importe','estado'],
                            remoteSort: true,
                            baseParams:{par_filtro:'cbanmo.detalle#cbanmo.nro_doc_tipo#cbanmo.observaciones',tipo_mov:'ingreso'}
                }),
                valueField: 'id_cuenta_bancaria_mov',
               displayField: 'nro_doc_tipo',
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
               anchor: '100%',
               gwidth:200,
               minChars:2,
               tpl: '<tpl for="."><div class="x-combo-list-item"><p>Nro:{nro_doc_tipo}</p><p>Detalle:<strong>{descripcion}</strong></p><p>Observaciones:<strong>{observaciones}</strong></p></div></tpl>',
               renderer:function(value, p, record){return String.format('{0}', record.data['desc_deposito']);}
            },
            type:'ComboBox',
            filters:{pfiltro:'cbanmo.detalle#cbanmo.nro_doc_tipo',type:'string'},
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
                name: 'obs_descuentos_ley',
                fieldLabel: 'Obs. otros desc.',
                allowBlank: true,
                anchor: '80%',
                disabled:true,
                gwidth: 100,
                maxLength:300
            },
            type:'TextArea',
            filters:{pfiltro:'plapa.obs_descuentos_ley',type:'string'},
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
		{name:'usr_mod', type: 'string'},
		'liquido_pagable',
		{name:'total_pagado', type: 'numeric'},
		{name:'monto_retgar_mo', type: 'numeric'},
		{name:'descuento_ley', type: 'numeric'},
		{name:'porc_descuento_ley', type: 'numeric'},
		'desc_plantilla','desc_cuenta_bancaria','sinc_presupuesto','obs_descuentos_ley',
		{name:'nro_cheque', type: 'numeric'},
		{name:'nro_cuenta_bancaria', type: 'string'},
		{name:'id_cuenta_bancaria_mov', type: 'numeric'},
		{name:'desc_deposito', type: 'string'}
		
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
        this.Cmp.monto_retgar_mo.on('change',this.calculaMontoPago,this);
        this.Cmp.descuento_ley.on('change',this.calculaMontoPago,this);
        
        this.Cmp.id_plantilla.on('select',function(cmb,rec,i){
            
            console.log(rec.data)
            this.getDecuentosPorAplicar(rec.data.id_plantilla);
            
        },this);
        
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
       
       //Evento para filtrar los depósitos a partir de la cuenta bancaria
		this.Cmp.id_cuenta_bancaria.on('select',function(data,rec,ind){
			this.Cmp.id_cuenta_bancaria_mov.setValue('');
			this.Cmp.id_cuenta_bancaria_mov.modificado=true;
			Ext.apply(this.Cmp.id_cuenta_bancaria_mov.store.baseParams,{id_cuenta_bancaria: rec.id});
		},this);
		
		//Evento para ocultar/motrar componentes por cheque o transferencia
		this.Cmp.forma_pago.on('change',function(groupRadio,radio){
			this.ocultarCheCue(radio.inputValue);
		},this);		   
    
    },
    
    onBtnSolPlanPago:function(){    	
        var rec=this.sm.getSelected();
        Ext.Ajax.request({
            url:'../../sis_tesoreria/control/PlanPago/solicitudPlanPago',
            params:{'id_plan_pago':rec.data.id_plan_pago,id_obligacion_pago:this.maestro.id_obligacion_pago},
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
    
    setTipoPagoNormal:function(){
        this.cmpTipo.enable();
       this.mostrarComponente(this.cmpTipo);
       this.mostrarComponente(this.cmpMontoEjecutarTotalMo)
       this.habilitarDescuentos();
        
    },
    
     successAplicarDesc:function(resp){
            Phx.CP.loadingHide();
           var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
                
               this.Cmp.porc_descuento_ley.setValue(reg.ROOT.datos.descuento_porc*1);
               this.Cmp.obs_descuentos_ley.setValue(reg.ROOT.datos.observaciones);
               
               this.calculaMontoPago();
               
              
             
             }else{
                alert(reg.ROOT.mensaje)
            }
     },
     
   
    calculaMontoPago:function(){
        
         var descuento_ley = this.cmpMonto.getValue()*this.Cmp.porc_descuento_ley.getValue();
         this.Cmp.descuento_ley.setValue(descuento_ley);
         var liquido = this.cmpMonto.getValue()  -  this.cmpMontoNoPagado.getValue() -  this.cmpOtrosDescuentos.getValue() - this.Cmp.monto_retgar_mo.getValue() -  this.Cmp.descuento_ley.getValue();
        
        
        this.cmpLiquidoPagable.setValue(liquido>0?liquido:0);
        var eje = this.cmpMonto.getValue()  -  this.cmpMontoNoPagado.getValue()
        this.cmpMontoEjecutarTotalMo.setValue(eje>0?eje:0);
     },
     
     enableDisable:function(val){
      if(val =='devengado'){
            
            //this.cmpPlantilla.enable();
            //this.ocultarComponente(this.cmpPlantilla);
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
            //this.cmpPlantilla.enable();
            //this.mostrarComponente(this.cmpPlantilla);
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
          this.cmpMontoNoPagado.setValue(0);
          this.cmpOtrosDescuentos.setValue(0);
          this.cmpLiquidoPagable.setValue(0);
          this.cmpMontoEjecutarTotalMo.setValue(0);
          this.Cmp.monto_retgar_mo.setValue(0);
          this.Cmp.descuento_ley.setValue(0)
          this.calculaMontoPago()
         
     },
     
    habilitarDescuentos:function(){
        //this.cmpDescuentoAnticipo.enable();
        //this.mostrarComponente(this.cmpDescuentoAnticipo);
        this.cmpOtrosDescuentos.enable();
        this.mostrarComponente(this.cmpOtrosDescuentos);
        
        //calcular retenciones segun documento
        
        this.mostrarComponente(this.Cmp.descuento_ley);
        
        this.Cmp.monto_retgar_mo.enable();
        this.mostrarComponente(this.Cmp.monto_retgar_mo);
        
        
        
        //this.cmpObsDescuentoAnticipo.enable();
        //this.mostrarComponente(this.cmpObsDescuentoAnticipo);
        this.cmpObsOtrosDescuentos.enable();
        this.mostrarComponente(this.cmpObsOtrosDescuentos);
        
        this.mostrarComponente(this.Cmp.obs_descuentos_ley);
        
    } ,
     deshabilitarDescuentos:function(){
       // this.cmpDescuentoAnticipo.disable();
       // this.ocultarComponente(this.cmpDescuentoAnticipo);
        this.cmpOtrosDescuentos.disable();
        this.ocultarComponente(this.cmpOtrosDescuentos);
        
        this.Cmp.monto_retgar_mo.disable();
        this.ocultarComponente(this.Cmp.monto_retgar_mo);
        
        this.ocultarComponente(this.Cmp.descuento_ley);
        
        
         
        //this.cmpObsDescuentoAnticipo.disable();
        //this.ocultarComponente(this.cmpObsDescuentoAnticipo);
        this.cmpObsOtrosDescuentos.disable();
        this.ocultarComponente(this.cmpObsOtrosDescuentos);
        
         this.ocultarComponente(this.Cmp.obs_descuentos_ley);
            
        
    } ,
    
    
    onButtonNew:function(){
        
         var data = this.getSelectedData();
         if(data){
         // para habilitar registros de cuotas de pago    
            if(data.monto_ejecutar_total_mo*1  > data.total_pagado*1  && data.estado =='devengado'){
                Phx.vista.PlanPago.superclass.onButtonNew.call(this); 
                this.cmpObligacionPago.setValue(this.maestro.id_obligacion_pago);
                this.Cmp.id_plan_pago_fk.setValue(data.id_plan_pago);
                
              
                this.cmpTipoPago.disable();
                this.ocultarComponente(this.cmpTipoPago);
                
                this.cmpTipo.disable();
                this.ocultarComponente(this.cmpTipo);
                
                this.cmpPlantilla.disable();
                this.ocultarComponente(this.cmpPlantilla);
                
                this.cmpNombrePago.enable();
                this.mostrarComponente(this.cmpNombrePago);
                this.cmpFormaPago.enable();
                this.mostrarComponente(this.cmpFormaPago);
                this.cmpFormaPago.enable();
                this.mostrarComponente(this.cmpFormaPago);
                this.cmpCuentaBancaria.enable()
                this.mostrarComponente(this.cmpCuentaBancaria);
                this.habilitarDescuentos();
                
                this.cmpMontoNoPagado.disable();
                this.ocultarComponente(this.cmpMontoNoPagado);
                this.cmpObsMontoNoPagado.disable();
                this.ocultarComponente(this.cmpObsMontoNoPagado);
                
                this.obtenerFaltante('registrado_pagado',data.id_plan_pago);
                this.Cmp.tipo_cambio.setValue(0);
                this.Cmp.tipo_cambio.disable();
                this.ocultarComponente(this.Cmp.tipo_cambio);
                //calculo de descuentos por documento
                this.getDecuentosPorAplicar(data.id_plantilla);

            }
            else{
                if(data.estado!='devengado'){
                    
                    alert('El devengado no fue completado');
                }
                else{
                    alert('No queda nada por pagar');
                }
            
            }
            
             
         }
         else{
           //para habilitar registros de cuota de devengado  
                Phx.vista.PlanPago.superclass.onButtonNew.call(this); 
                this.cmpObligacionPago.setValue(this.maestro.id_obligacion_pago);
                 this.mostrarComponente(this.cmpTipoPago);
               if(this.maestro.nro_cuota_vigente ==0){
                    this.cmpTipoPago.setValue('normal');
                    this.cmpTipoPago.enable();
                }
                else{
                     this.cmpTipoPago.setValue('normal');
                      this.cmpTipoPago.disable();
                }
                this.setTipoPagoNormal();
               
                this.cmpTipo.enable();
                this.mostrarComponente(this.cmpTipo);
                this.cmpPlantilla.enable();
                this.mostrarComponente(this.cmpPlantilla);
                this.cmpMontoNoPagado.enable();
                this.mostrarComponente(this.cmpMontoNoPagado);
                this.cmpObsMontoNoPagado.enable();
                this.mostrarComponente(this.cmpObsMontoNoPagado);
                this.obtenerFaltante('registrado');
                if(this.maestro.tipo_moneda=='base'){
                   this.Cmp.tipo_cambio.setValue(1);  
                   this.Cmp.tipo_cambio.disable();
                   this.ocultarComponente(this.Cmp.tipo_cambio);
                }
                else{
                    this.Cmp.tipo_cambio.enable();
                    this.mostrarComponente(this.Cmp.tipo_cambio);
                    this.Cmp.tipo_cambio.setValue(this.maestro.tipo_cambio_conv);  
                }
       
              
                
           }
          
            this.cmpFechaTentativa.minValue=new Date();
            this.cmpFechaTentativa.setValue(new Date());
            this.cmpNombrePago.setValue(this.maestro.desc_proveedor);
            this.cmpMonto.setValue(0);
           // this.cmpDescuentoAnticipo.setValue(0);
            this.cmpMontoNoPagado.setValue(0);
            this.cmpOtrosDescuentos.setValue(0);
            this.cmpLiquidoPagable.setValue(0);
            this.cmpMontoEjecutarTotalMo.setValue(0);
            this.Cmp.monto_retgar_mo.setValue(0);
            this.cmpLiquidoPagable.disable();
            this.cmpMontoEjecutarTotalMo.disable();
            
            //calcular el descuento segun el documento
            this.Cmp.descuento_ley.setValue(0);
            
            //Verifica si habilita o no el cheque y la cuenta bancaria destino
			this.ocultarCheCue(data.forma_pago);
      },
     
      onButtonEdit:function(){
       
         var data = this.getSelectedData();
        
         Phx.vista.PlanPago.superclass.onButtonEdit.call(this); 
         if(data.tipo=='pagado'){
             
                this.cmpTipoPago.disable();
                this.ocultarComponente(this.cmpTipoPago);
                
                this.cmpTipo.disable();
                this.ocultarComponente(this.cmpTipo);
                
                this.cmpPlantilla.disable();
                this.ocultarComponente(this.cmpPlantilla);
                
                this.cmpNombrePago.enable();
                this.mostrarComponente(this.cmpNombrePago);
                this.cmpFormaPago.enable();
                this.mostrarComponente(this.cmpFormaPago);
                this.cmpFormaPago.enable();
                this.mostrarComponente(this.cmpFormaPago);
                this.cmpCuentaBancaria.enable()
                this.mostrarComponente(this.cmpCuentaBancaria);
                this.habilitarDescuentos();
                
                this.cmpMontoNoPagado.disable();
                this.ocultarComponente(this.cmpMontoNoPagado);
                this.cmpObsMontoNoPagado.disable();
                this.ocultarComponente(this.cmpObsMontoNoPagado);
                this.Cmp.tipo_cambio.disable();
                this.ocultarComponente(this.Cmp.tipo_cambio);
         
         
         }
         else{
                this.mostrarComponente(this.cmpTipoPago);
                this.cmpTipo.enable();
                this.mostrarComponente(this.cmpTipo);
               
                
                this.cmpPlantilla.enable();
                this.mostrarComponente(this.cmpPlantilla);
                
                this.cmpMontoNoPagado.enable();
                this.mostrarComponente(this.cmpMontoNoPagado);
                 
                this.cmpObsMontoNoPagado.enable();
                this.mostrarComponente(this.cmpObsMontoNoPagado);
                if(this.maestro.tipo_moneda=='base'){
                 
                   this.Cmp.tipo_cambio.disable();
                   this.ocultarComponente(this.Cmp.tipo_cambio);
                }
                else{
                    this.Cmp.tipo_cambio.enable();
                    this.mostrarComponente(this.Cmp.tipo_cambio);
                  
                }
                
         }
       
           this.cmpFechaTentativa.disable();
           this.cmpTipo.disable();
           this.cmpTipoPago.disable(); 
           
			//Verifica si habilita o no el cheque y la cuenta bancaria destino
			this.ocultarCheCue(data.forma_pago);
           
       },
    
    obtenerFaltante:function(_filtro,_id_plan_pago){
        
       Phx.CP.loadingShow();
          Ext.Ajax.request({
                    // form:this.form.getForm().getEl(),
                    url:'../../sis_tesoreria/control/ObligacionPago/obtenerFaltante',
                    params:{ope_filtro:_filtro, 
                            id_obligacion_pago: this.maestro.id_obligacion_pago,
                            id_plan_pago:_id_plan_pago},
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
    
    onReloadPage:function(m){
        this.maestro=m;
        this.store.baseParams={id_obligacion_pago:this.maestro.id_obligacion_pago};
      
        
        
        this.load({params:{start:0, limit:this.tam_pag}})
        this.Cmp.tipo_cambio.setValue(1);  
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
              this.getBoton('del').enable(); 
              this.getBoton('SolDevPag').enable(); 
              this.getBoton('new').disable(); 
              this.getBoton('SolPlanPago').enable();    
          }
          else{
              
            if (data['estado']== 'devengado'  && (data.monto_ejecutar_total_mo*1)  > (data.total_pagado*1) ){ 
                this.getBoton('new').enable();
                console.log('habilita new')
            }
            else{
                this.getBoton('new').disable(); 
                 console.log('deshabilita new')
            }
             this.getBoton('edit').disable();
             this.getBoton('del').disable();
             this.getBoton('SolDevPag').disable();
             
                this.getBoton('SolPlanPago').enable(); 
          }
          
          if(data['sinc_presupuesto']=='si'){
               this.getBoton('SincPresu').enable();
          }
          else{
               this.getBoton('SincPresu').disable();
          }
     },
     
      liberaMenu:function(){
        var tb = Phx.vista.PlanPago.superclass.liberaMenu.call(this);
        if(tb){
           this.getBoton('SolDevPag').disable();
           this.getBoton('SincPresu').disable();
           this.getBoton('SolPlanPago').disable();  
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
		field: 'nro_cuota',
		direction: 'ASC'
	},
	onBtnSincPresu:function()
        {                   
            var d= this.sm.getSelected().data;
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url:'../../sis_tesoreria/control/PlanPago/sincronizarPresupuesto',
                params:{id_plan_pago:d.id_plan_pago},
                success:this.successSinc,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });     
      },
      
    onSubmitDepto:function(x,y,id_depto_conta){
           var data = this.getSelectedData();
          
           if(this.formDEPTO.getForm().isValid() || id_depto_conta){
                Phx.CP.loadingShow();
               Ext.Ajax.request({
                    // form:this.form.getForm().getEl(),
                    url:'../../sis_tesoreria/control/PlanPago/solicitarDevPag',
                    params:{id_plan_pago:data.id_plan_pago, id_depto_conta:id_depto_conta?id_depto_conta:this.cmpDeptoConta.getValue()},
                    success:this.successSinc,
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
                })
            }
        
    },
	
    onBtnDevPag:function()
        {                   
            var data = this.getSelectedData();
            
            console.log('depto_conta',this.maestro.id_depto_conta)
            if(this.maestro.id_depto_conta > 0){
           
                this.onSubmitDepto(undefined,undefined,this.maestro.id_depto_conta);  
            }
            else{
              
                this.wDEPTO.show();
                this.cmpDeptoConta.reset();
                this.cmpDeptoConta.store.baseParams.id_plan_pago = data.id_plan_pago;
                this.cmpDeptoConta.store.baseParams.id_obligacion_pago = this.maestro.id_obligacion_pago;
                this.cmpDeptoConta.modificado = true;
              
            }  
      }, 
     successSinc:function(resp){
            Phx.CP.loadingHide();
            this.wDEPTO.hide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(reg.ROOT.datos.resultado!='falla'){
                
                this.reload();
             }else{
                alert(reg.ROOT.datos.mensaje)
            }
     },
     
     getDecuentosPorAplicar:function(id_plantilla){
         
         var data = this.getSelectedData();
           Phx.CP.loadingShow();
           
           Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url:'../../sis_contabilidad/control/PlantillaCalculo/recuperarDescuentosPlantillaCalculo',
                params:{id_plantilla:id_plantilla},
                success:this.successAplicarDesc,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            })
         
         
     },

	bdel:true,
	bedit:true,
	bsave:false,
	ocultarCheCue: function(pFormaPago){
		if(pFormaPago=='transferencia'){
			//Deshabilita campo cheque
			this.Cmp.nro_cheque.allowBlank=true;
			this.Cmp.nro_cheque.setValue('');
			this.Cmp.nro_cheque.disable();
			//Habilita nrocuenta bancaria destino
			this.Cmp.nro_cuenta_bancaria.allowBlank=false;
			this.Cmp.nro_cuenta_bancaria.enable();
		} else{
			//cheque
			//Habilita campo cheque
			this.Cmp.nro_cheque.allowBlank=false;
			this.Cmp.nro_cheque.enable();
			//Habilita nrocuenta bancaria destino
			this.Cmp.nro_cuenta_bancaria.allowBlank=true;
			this.Cmp.nro_cuenta_bancaria.setValue('');
			this.Cmp.nro_cuenta_bancaria.disable();
		}
		
	}
	
})
</script>
		
		