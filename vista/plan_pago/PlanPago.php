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
		
    	//llama al constructor de la clase padre
		Phx.vista.PlanPago.superclass.constructor.call(this,config);
		this.init();
		
		this.addButton('ant_estado',{argument: {estado: 'anterior'},text:'Anterior',iconCls: 'batras',disabled:true,handler:this.antEstado,tooltip: '<b>Pasar al Anterior Estado</b>'});
        
		this.addButton('sig_estado',{text:'Siguiente',iconCls: 'badelante',disabled:true,handler:this.sigEstado,tooltip: '<b>Pasar al Siguiente Estado</b>'});
        
		this.addButton('SolPlanPago',{text:'Sol. Plan Pago.',iconCls: 'bpdf32',disabled:true,handler:this.onBtnSolPlanPago,tooltip: '<b>Solicitud Plan Pago</b><br/> Incremeta el presupuesto exacto para proceder con el pago'});
		
		    
       
		
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
        },
        {
            config:{
                name: 'numero_op',
                fieldLabel: 'Obl. Pago',
                allowBlank: true,
                anchor: '80%',
                gwidth: 130,
                maxLength:4
            },
            type:'NumberField',
            filters:{pfiltro:'op.numero',type:'string'},
            id_grupo:1,
            grid:false,
            form:false
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
                fieldLabel: 'Tipo de Cuota',
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
           form:false
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
            form:false
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
            form:false
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
            form:false
        },
        {
            config:{
                name: 'id_cuenta_bancaria_mov',
                fieldLabel: 'Depósito',
                allowBlank: true,
                emptyText : 'Depósito...',
                store: new Ext.data.JsonStore({
                    url:'../../sis_migracion/control/TsLibroBancos/listarDepositosENDESIS',
                    id : 'id_cuenta_bancaria_mov',
                    root: 'datos',
                    sortInfo:{
                            field: 'nro_doc_tipo',
                            direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_cuenta_bancaria_mov','id_cuenta_bancaria','fecha','detalle','observaciones','importe_deposito','saldo'],
                    remoteSort: true,
                    baseParams:{par_filtro:'detalle#observaciones#fecha'}
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
               tpl: '<tpl for="."><div class="x-combo-list-item"><p>{detalle}</p><p>Fecha:<strong>{fecha}</strong></p><p>Importe:<strong>{importe_deposito}</strong></p><p>Saldo:<strong>{saldo}</strong></p></div></tpl>',
               renderer:function(value, p, record){return String.format('{0}', record.data['desc_deposito']);}
            },
            type:'ComboBox',
            filters:{pfiltro:'cbanmo.detalle#cbanmo.nro_doc_tipo',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
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
		{name:'desc_deposito', type: 'string'},
		'numero_op',
		'id_estado_wf',
		'id_depto_conta',
		'id_moneda','tipo_moneda','desc_moneda'
		
	],
	
   crearFormularioEstados:function(){
        
          this.formEstado = new Ext.form.FormPanel({
                baseCls: 'x-plain',
                autoDestroy: true,
               
                border: false,
                layout: 'form',
                 autoHeight: true,
               
        
                items: [
                    {
                        xtype: 'combo',
                        name: 'id_tipo_estado',
                          hiddenName: 'id_tipo_estado',
                        fieldLabel: 'Siguiente Estado',
                        listWidth:280,
                        allowBlank: false,
                        emptyText:'Elija el estado siguiente',
                        store:new Ext.data.JsonStore(
                        {
                            url: '../../sis_workflow/control/TipoEstado/listarTipoEstado',
                            id: 'id_tipo_estado',
                            root:'datos',
                            sortInfo:{
                                field:'tipes.codigo',
                                direction:'ASC'
                            },
                            totalProperty:'total',
                            fields: ['id_tipo_estado','codigo_estado','nombre_estado'],
                            // turn on remote sorting
                            remoteSort: true,
                            baseParams:{par_filtro:'tipes.nombre_estado#tipes.codigo'}
                        }),
                        valueField: 'id_tipo_estado',
                        displayField: 'codigo_estado',
                        forceSelection:true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender:true,
                        mode:'remote',
                        pageSize:50,
                        queryDelay:500,
                        width:210,
                        gwidth:220,
                        minChars:2,
                        tpl: '<tpl for="."><div class="x-combo-list-item"><p>{codigo_estado}</p>Prioridad: <strong>{nombre_estado}</strong> </div></tpl>'
                    
                    },
                    {
                        xtype: 'combo',
                        name: 'id_funcionario_wf',
                        hiddenName: 'id_funcionario_wf',
                        fieldLabel: 'Funcionario Resp.',
                        allowBlank: false,
                        emptyText:'Elija un funcionario',
                        listWidth:280,
                        store:new Ext.data.JsonStore(
                        {
                            url: '../../sis_workflow/control/TipoEstado/listarFuncionarioWf',
                            id: 'id_funcionario',
                            root:'datos',
                            sortInfo:{
                                field:'prioridad',
                                direction:'ASC'
                            },
                            totalProperty:'total',
                            fields: ['id_funcionario','desc_funcionario','prioridad'],
                            // turn on remote sorting
                            remoteSort: true,
                            baseParams:{par_filtro:'fun.desc_funcionario1'}
                        }),
                        valueField: 'id_funcionario',
                        displayField: 'desc_funcionario',
                        forceSelection:true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender:true,
                        mode:'remote',
                        pageSize:50,
                        queryDelay:500,
                        width:210,
                        gwidth:220,
                        minChars:2,
                        tpl: '<tpl for="."><div class="x-combo-list-item"><p>{desc_funcionario}</p>Prioridad: <strong>{prioridad}</strong> </div></tpl>'
                    
                    },
                        {
                            name: 'obs',
                            xtype: 'textarea',
                            fieldLabel: 'Obs',
                            allowBlank: false,
                            anchor: '80%',
                            maxLength:500
                        }
                   ]
            });
            
            
             this.wEstado = new Ext.Window({
                title: 'Estados',
                collapsible: true,
                maximizable: true,
                 autoDestroy: true,
                width: 380,
                height: 290,
                layout: 'fit',
                plain: true,
                bodyStyle: 'padding:5px;',
                buttonAlign: 'center',
                items: this.formEstado,
                modal:true,
                 closeAction: 'hide',
                buttons: [{
                    text: 'Guardar',
                    handler:this.confSigEstado,
                     scope:this
                    
                 },
                 {
                    text: 'Guardar',
                    handler:this.antEstadoSubmmit,
                    scope:this
                        
                 },
                 {
                    text: 'Cancelar',
                    handler:function(){this.wEstado.hide()},
                    scope:this
                }]
            });
            
            
           
            
            this.cmbTipoEstado =this.formEstado.getForm().findField('id_tipo_estado');
            this.cmbTipoEstado.store.on('loadexception', this.conexionFailure,this);
         
            this.cmbFuncionarioWf = this.formEstado.getForm().findField('id_funcionario_wf');
            
            this.cmbFuncionarioWf.store.on('loadexception', this.conexionFailure,this);
          
            this.cmpObs=this.formEstado.getForm().findField('obs');
            
            //this.cmbIntrucRPC =this.formEstado.getForm().findField('instruc_rpc');
           
            
            this.cmbTipoEstado.on('select',function(){
                
                this.cmbFuncionarioWf.enable();
                this.cmbFuncionarioWf.store.baseParams.id_tipo_estado = this.cmbTipoEstado.getValue();
                this.cmbFuncionarioWf.modificado=true;
                
                this.cmbFuncionarioWf.store.load({params:{start:0,limit:this.tam_pag}, 
                           callback : function (r) {
                               if (r.length >= 1 ) {                       
                                    this.cmbFuncionarioWf.setValue(r[0].data.id_funcionario);
                                    this.cmbFuncionarioWf.fireEvent('select', r[0]);
                                }    
                                                
                            }, scope : this
                        });
                
            },this);  
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
   
    
   sigEstado:function(){                   
            var d= this.sm.getSelected().data;
            if(d){
                
                Phx.CP.loadingShow();
                this.cmbTipoEstado.reset();
                this.cmbFuncionarioWf.reset();
                this.cmbFuncionarioWf.store.baseParams.id_estado_wf=d.id_estado_wf;
                this.cmbFuncionarioWf.store.baseParams.fecha= d.fecha_tentativa;
                
                this.cmbTipoEstado.show();
                this.cmbFuncionarioWf.show();
                this.cmbTipoEstado.enable();
             
                Ext.Ajax.request({
                    // form:this.form.getForm().getEl(),
                    url:'../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago',
                    params:{id_plan_pago:d.id_plan_pago,
                            operacion:'verificar'},
                    success:this.successEstadoSinc,
                    argument:{data:d},
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
                }); 
                
                
            }
               
     },
     
     
     successEstadoSinc:function(resp){
            
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
                
                if (reg.ROOT.datos.operacion=='preguntar_todo'){
                  
                      if(reg.ROOT.datos.num_estados==1 && reg.ROOT.datos.num_funcionarios==1){
                               //directamente mandamos los datos
                               Phx.CP.loadingShow();
                               var d= this.sm.getSelected().data;
                               Ext.Ajax.request({
                                // form:this.form.getForm().getEl(),
                                url:'../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago',
                                params:{id_plan_pago:d.id_plan_pago,
                                    operacion:'cambiar',
                                    id_tipo_estado:reg.ROOT.datos.id_tipo_estado,
                                    id_funcionario:reg.ROOT.datos.id_funcionario_estado,
                                    id_depto:reg.ROOT.datos.id_depto_estado,
                                    id_plan_pago:d.id_plan_pago
                                    },
                                success:this.successEstadoSinc,
                                failure: this.conexionFailure,
                                timeout:this.timeout,
                                scope:this
                            }); 
                    }
                    else{
                       
                         this.cmbTipoEstado.store.baseParams.estados= reg.ROOT.datos.estados;
                         this.cmbTipoEstado.modificado=true;
                         this.cmbFuncionarioWf.disable();
                         this.wEstado.buttons[1].hide();
                         this.wEstado.buttons[0].show();
                         this.wEstado.show();  
                     
                     
                         //precarga combo de estado
                         this.cmbTipoEstado.store.load({params:{start:0,limit:this.tam_pag}, 
                           callback : function (r) {
                                if (r.length == 1 ) {                       
                                    this.cmbTipoEstado.setValue(r[0].data.id_tipo_estado);
                                    this.cmbTipoEstado.fireEvent('select', r[0]);
                                }    
                                                
                            }, scope : this
                        });
                     
                    }
                   
               }
               
               if (reg.ROOT.datos.operacion=='cambio_exitoso'){
                  this.reload();
                  this.wEstado.hide();
                }
            }
            else{
                
                alert('ocurrio un error durante el proceso')
            
            }
           
            
        },
    
      confSigEstado :function() {                   
            var d= this.sm.getSelected().data;
           
            if ( this.formEstado .getForm().isValid()){
                 Phx.CP.loadingShow();
                    Ext.Ajax.request({
                        // form:this.form.getForm().getEl(),
                        url:'../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago',
                        params:{
                            id_plan_pago:d.id_plan_pago,
                            operacion:'cambiar',
                            id_tipo_estado:this.cmbTipoEstado.getValue(),
                            id_funcionario:this.cmbFuncionarioWf.getValue(),
                            obs:this.cmpObs.getValue()
                            },
                        success:this.successEstadoSinc,
                        failure: this.conexionFailure,
                        timeout:this.timeout,
                        scope:this
                    }); 
              }    
     },
     
      antEstado:function(res,eve) {                   
            this.wEstado.buttons[0].hide();
            this.wEstado.buttons[1].show();
            this.wEstado.show();
            this.cmbTipoEstado.hide();
            this.cmbFuncionarioWf.hide();
            this.cmbTipoEstado.disable();
            this.cmbFuncionarioWf.disable();
            this.cmpObs.setValue('');
            
            this.sw_estado =res.argument.estado;
           
               
        },
        
        antEstadoSubmmit:function(res){
            var d= this.sm.getSelected().data;
           
            Phx.CP.loadingShow();
            var operacion = 'cambiar';
            operacion=  this.sw_estado == 'inicio'?'inicio':operacion; 
            
            Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url:'../../sis_tesoreria/control/PlanPago/anteriorEstadoPlanPago',
                params:{
                        id_plan_pago:d.id_plan_pago, 
                        id_estado_wf:d.id_estado_wf, 
                        operacion: operacion,
                        obs:this.cmpObs.getValue()
                 },
                success:this.successEstadoSinc,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });  
            
            
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
     
     enableDisable:function(val){
      
      
      if(val=='devengado'){
            
            //this.Cmp.id_plantilla.enable();
            //this.ocultarComponente(this.Cmp.id_plantilla);
            
            this.Cmp.nombre_pago.disable();
            this.ocultarComponente(this.Cmp.nombre_pago);
            
            this.Cmp.forma_pago.disable();
            this.ocultarComponente(this.Cmp.forma_pago);
            
                      
            
            
            this.Cmp.nro_cheque.disable()
            this.ocultarComponente(this.Cmp.nro_cheque);
            
            this.Cmp.nro_cuenta_bancaria.disable()
            this.ocultarComponente(this.Cmp.nro_cuenta_bancaria);
            
            //RCM, deshabilita deposito
            if(this.Cmp.id_cuenta_bancaria_mov){
               this.Cmp.id_cuenta_bancaria_mov.disable()
               this.ocultarComponente(this.Cmp.id_cuenta_bancaria_mov);
               this.Cmp.id_cuenta_bancaria.disable()
               this.ocultarComponente(this.Cmp.id_cuenta_bancaria);
                
            }
                       
            
            
            this.deshabilitarDescuentos()
            
        }
        else{
            
            //this.Cmp.id_plantilla.enable();
            //this.mostrarComponente(this.Cmp.id_plantilla);
            
            this.Cmp.nombre_pago.enable();
            this.mostrarComponente(this.Cmp.nombre_pago);
            
            this.Cmp.forma_pago.enable();
            this.mostrarComponente(this.Cmp.forma_pago);
            
            
            
            this.Cmp.nro_cheque.enable()
            this.mostrarComponente(this.Cmp.nro_cheque);
            
            this.Cmp.nro_cuenta_bancaria.enable()
            this.mostrarComponente(this.Cmp.nro_cuenta_bancaria);
            
            //RCM, habilita deposito
            if(this.Cmp.id_cuenta_bancaria_mov){
               this.Cmp.id_cuenta_bancaria_mov.enable()
               this.mostrarComponente(this.Cmp.id_cuenta_bancaria_mov);
               this.Cmp.id_cuenta_bancaria.enable()
               this.mostrarComponente(this.Cmp.id_cuenta_bancaria);
            }
            
            this.habilitarDescuentos();
            
         }
          
          this.Cmp.monto_no_pagado.setValue(0);
          this.Cmp.otros_descuentos.setValue(0);
          this.Cmp.liquido_pagable.setValue(0);
          this.Cmp.monto_ejecutar_total_mo.setValue(0);
          this.Cmp.monto_retgar_mo.setValue(0);
          this.Cmp.descuento_ley.setValue(0)
          this.calculaMontoPago()
         
     },
     
    habilitarDescuentos:function(){
        //this.cmpDescuentoAnticipo.enable();
        //this.mostrarComponente(this.cmpDescuentoAnticipo);
        
        this.Cmp.otros_descuentos.enable();
        this.mostrarComponente(this.Cmp.otros_descuentos);
        
        //calcular retenciones segun documento
        
        this.mostrarComponente(this.Cmp.descuento_ley);
        
        this.Cmp.monto_retgar_mo.enable();
        this.mostrarComponente(this.Cmp.monto_retgar_mo);
        
        
        
        //this.cmpObsDescuentoAnticipo.enable();
        //this.mostrarComponente(this.cmpObsDescuentoAnticipo);
        this.Cmp.obs_otros_descuentos.enable();
        this.mostrarComponente(this.Cmp.obs_otros_descuentos);
        
        this.mostrarComponente(this.Cmp.obs_descuentos_ley);
        
    } ,
     deshabilitarDescuentos:function(){
       // this.cmpDescuentoAnticipo.disable();
       // this.ocultarComponente(this.cmpDescuentoAnticipo);
        this.Cmp.otros_descuentos.disable();
        this.ocultarComponente(this.Cmp.otros_descuentos);
        
        this.Cmp.monto_retgar_mo.disable();
        this.ocultarComponente(this.Cmp.monto_retgar_mo);
        
        this.ocultarComponente(this.Cmp.descuento_ley);
        
        
         
        //this.cmpObsDescuentoAnticipo.disable();
        //this.ocultarComponente(this.cmpObsDescuentoAnticipo);
        this.Cmp.obs_otros_descuentos.disable();
        this.ocultarComponente(this.Cmp.obs_otros_descuentos);
        
         this.ocultarComponente(this.Cmp.obs_descuentos_ley);
            
        
    } ,
     
    onBtnSolPlanPago:function(){        
        var rec=this.sm.getSelected();
        Ext.Ajax.request({
            url:'../../sis_tesoreria/control/PlanPago/solicitudPlanPago',
            params:{'id_plan_pago':rec.data.id_plan_pago,id_obligacion_pago:rec.data.id_obligacion_pago},
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
    
    calculaMontoPago:function(){
        var descuento_ley = this.Cmp.monto.getValue()*this.Cmp.porc_descuento_ley.getValue();
         this.Cmp.descuento_ley.setValue(descuento_ley);
         var liquido = this.Cmp.monto.getValue()  -  this.Cmp.monto_no_pagado.getValue() -  this.Cmp.otros_descuentos.getValue() - this.Cmp.monto_retgar_mo.getValue() -  this.Cmp.descuento_ley.getValue();
        this.Cmp.liquido_pagable.setValue(liquido>0?liquido:0);
        var eje = this.Cmp.monto.getValue()  -  this.Cmp.monto_no_pagado.getValue()
        this.Cmp.monto_ejecutar_total_mo.setValue(eje>0?eje:0);
     }, 
    
    sortInfo:{
		field: 'nro_cuota',
		direction: 'ASC'
	},
	onButtonNew: function(){
		Phx.vista.PlanPago.superclass.onButtonNew.call(this);
		//this.Cmp.f.store.baseParams={id_cuenta_bancaria:-1,fecha:new Date()}
	}
	
})
</script>
		
		