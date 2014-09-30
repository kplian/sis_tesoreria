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
    fheight: '80%',
    fwidth: '80%',
    accionFormulario:undefined, //define la accion que se ejcuta en formulario new o edit
    porc_ret_gar:0,//valor por defecto de retencion de garantia
	constructor:function(config){
		//llama al constructor de la clase padre
		Phx.vista.PlanPago.superclass.constructor.call(this,config);
		this.init();
		this.addButton('ant_estado',{argument: {estado: 'anterior'},text:'Anterior',iconCls: 'batras',disabled:true,handler:this.antEstado,tooltip: '<b>Pasar al Anterior Estado</b>'});
        this.addButton('sig_estado',{text:'Siguiente',iconCls: 'badelante',disabled:true,handler:this.sigEstado,tooltip: '<b>Pasar al Siguiente Estado</b>'});
        this.addButton('SolPlanPago',{text:'Sol. Plan Pago.',iconCls: 'bpdf32',disabled:true,handler:this.onBtnSolPlanPago,tooltip: '<b>Solicitud Plan Pago</b><br/> Incremeta el presupuesto exacto para proceder con el pago'});
		this.addButton('btnChequeoDocumentosWf',
            {
                text: 'Chequear Documentos',
                iconCls: 'bchecklist',
                disabled: true,
                handler: this.loadCheckDocumentosSolWf,
                tooltip: '<b>Documentos de la Solicitud</b><br/>Subir los documetos requeridos en la solicitud seleccionada.'
            }
        );
        this.addButton('SincPresu',{text:'Inc. Pres.',iconCls: 'balert',disabled:true,handler:this.onBtnSincPresu,tooltip: '<b>Incrementar Presupuesto</b><br/> Incremeta el presupuesto exacto para proceder con el pago'});
        
	},
	tam_pag:50,
	
	arrayStore :{
                	'TODOS':[
                	            ['devengado_pagado','Devengar y pagar (2 comprobantes)'],
                                ['devengado_pagado_1c','Devengar y pagar (1 comprobante)'],
                                ['devengado','Devengar'],
                                ['rendicion','Agrupar Dev y Pagar (Agrupa varios documentos)'], //es similr a un devengar y pagar pero no genera prorrateo directamente
                                ['anticipo','Anticipo Fact/Rec (No ejecuta presupuesto, necesita Documento)'],
                                ['ant_parcial','Anticipo Parcial(No ejecuta presupuesto, Con retenciones parciales en cada pago)'],
                                ['pagado','Pagar'],
                                ['ant_aplicado','Aplicacion de Anticipo'],
                                ['dev_garantia','Devolucion de Garantia'],
                                ['det_rendicion','Rendicion Ant']
                     ],
                	
                	'INICIAL':[
                	            ['devengado_pagado','Devengar y pagar (2 comprobantes)'],
                	            ['devengado_pagado_1c','Devengar y pagar (1 comprobante)'],
                                ['devengado','Devengar'],
                                ['dev_garantia','Devolucion de Garantia'], //es similr a un devengar y pagar pero no genera prorrateo directamente
                                ['anticipo','Anticipo Fact/Rec (No ejecuta presupuesto, necesita Documento)']
                               ],
                    
                    'ANT_PARCIAL':[
                               ['ant_parcial','Anticipo Parcial(No ejecuta presupuesto, Con retenciones parciales en cada pago)'],
                               ],
                    
                    'DEVENGAR':[['pagado','Pagar']],
                    
                    'ANTICIPO':[['ant_aplicado','Aplicacion de Anticipo']],
                    
                    'RENDICION':[['det_rendicion','Rendicion Ant']]
                                          
	},
	
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
                    name: 'porc_monto_retgar'
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
                name: 'revisado_asistente',
                fieldLabel: 'Rev',
                allowBlank: true,
                anchor: '80%',
                gwidth: 65,
                renderer:function (value, p, record){  
                            if(record.data['revisado_asistente'] == 'si')
                                return  String.format('{0}',"<div style='text-align:center'><img src = '../../../lib/imagenes/ball_green.png' align='center' width='24' height='24'/></div>");
                            else
                                return  String.format('{0}',"<div style='text-align:center'><img src = '../../../lib/imagenes/ball_white.png' align='center' width='24' height='24'/></div>");
                        },
            },
            type:'Checkbox',
            filters:{pfiltro:'plapa.revisado_asistente',type:'string'},
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
                maxLength:200,
                renderer:function(value,p,record){
                	if(record.data.usr_reg=='vitalia.penia'|| record.data.usr_reg=='shirley.torrez'|| record.data.usr_reg=='patricia.lopez'|| record.data.usr_reg=='patricia.lopez'){
                        return String.format('<b><font color="orange">{0}</font></b>', value);
                    }
                    else {
                        return value;
                    }
                	
                }
            },
            type:'TextField',
            filters:{pfiltro:'op.num_tramite',type:'string'},
            id_grupo:1,
            grid:false,
            form:false
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
                                             if(record.data.tipo=='pagado' || record.data.tipo=='ant_aplicado'){
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
                name: 'tipo',
                fieldLabel: 'Tipo de Cuota',
                allowBlank: false,
                emptyText:'Tipo de Cuoata',
                renderer:function (value, p, record){
                        var dato='';
                        dato = (dato==''&&value=='devengado')?'Devengar':dato;
                        dato = (dato==''&&value=='devengado_pagado')?'Devengar y pagar (2 cbte)':dato;
                        dato = (dato==''&&value=='devengado_pagado_1c')?'Devengar y pagar (1 cbte)':dato;
                        dato = (dato==''&&value=='pagado')?'Pagar':dato;
                        dato = (dato==''&&value=='anticipo')?'Anticipo Fact/Rec':dato;
                        dato = (dato==''&&value=='ant_parcial')?'Anticipo Parcial':dato;
                        dato = (dato==''&&value=='ant_rendicion')?'Ant. por Rendir':dato;
                        dato = (dato==''&&value=='dev_garantia')?'Devolucion de Garantia':dato;
                        dato = (dato==''&&value=='ant_aplicado')?'Aplicacion de Anticipo':dato;
                        dato = (dato==''&&value=='rendicion')?'Rendicion Ant.':dato;
                        dato = (dato==''&&value=='ret_rendicion')?'Detalle de Rendicion':dato;
                        return String.format('{0}', dato);
                    },
                
                store:new Ext.data.ArrayStore({
                            fields :['variable','valor'],
                            data :  []}),
               
                valueField: 'variable',
                displayField: 'valor',
                forceSelection: true,
                triggerAction: 'all',
                lazyRender: true,
                resizable:true,
                listWidth:'500',
                mode: 'local',
                wisth: 380
                },
            type:'ComboBox',
            filters:{pfiltro:'tipo',type:'string'},
            id_grupo:0,
            grid:true,
            form:true
        },
         {
            config:{
                name: 'nombre_pago',
                fieldLabel: 'Nombre Pago',
                allowBlank: true,
                anchor: '80%',
                gwidth: 250,
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
            id_grupo:0,
            grid:true,
            form:true
        },
        {
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
                    fields: ['id_plantilla','nro_linea','desc_plantilla','tipo','sw_tesoro', 'sw_compro','sw_monto_excento'],
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
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'monto_excento',
                currencyChar:' ',
                allowNegative:false,
                fieldLabel: 'Monto exento',
                allowBlank: false,
                disabled:true,
                gwidth: 100,
                maxLength:1245186
            },
            type:'MoneyField',
            valorInicial:0,
            filters:{pfiltro:'plapa.monto_excento',type:'numeric'},
            id_grupo:1,
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
                name: 'nro_cheque',
                fieldLabel: 'Número Cheque',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:255
            },
            type: 'NumberField',
            filters: {pfiltro:'plapa.nro_cheque',type:'numeric'},
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
                name:'desc_moneda',
                fieldLabel:'Mon.',
                gwidth: 30,
            },
            type:'Field',
            id_grupo:1,
            filters:{   
                pfiltro:'mon.codigo',
                type:'string'
            },
            grid:false,
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
        {
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
        },
       
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
                fieldLabel: 'Multas',
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
                name: 'descuento_inter_serv',
                currencyChar:' ',
                fieldLabel: 'Desc. Inter Servicio',
                allowBlank: true,
                allowNegative:false,
                gwidth: 100,
                maxLength:1245186
            },
            type:'MoneyField',
            filters:{pfiltro:'plapa.descuento_inter_serv',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'descuento_ley',
                currencyChar:' ',
                fieldLabel: 'Decuentos de Ley',
                allowBlank: true,
                readOnly:true,
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
                readOnly:true,
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
                readOnly:true,
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
                    fields: ['id_cuenta_bancaria','nro_cuenta','nombre_institucion','codigo_moneda','centro','denominacion'],
                    remoteSort: true,
                    baseParams : {
						par_filtro : 'ctaban.nro_cuenta#inst.nombre#ctaban.denominacion'
					}
                }),
                tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{nro_cuenta}</b></p><p>Moneda: {codigo_moneda}, {nombre_institucion}</p><p>{denominacion}, Centro: {centro}</p></div></tpl>',
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
            id_grupo:1,
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
               displayField: 'detalle',
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
                name: 'obs_wf',
                fieldLabel: 'Obs',
                allowBlank: true,
                anchor: '80%',
                gwidth: 300,
                maxLength:1000
            },
            type:'TextArea',
            filters:{pfiltro:'ew.obs',type:'string'},
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
        {
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
        },
        {
            config:{
                name: 'obs_monto_no_pagado',
                fieldLabel: 'Obs. Pago',
                qtip:'Estas observaciones van a la glosa del comprobante que se genere',
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
                fieldLabel: 'Obs. desc. ley',
                allowBlank: true,
                anchor: '80%',
                readOnly:true,
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
                name: 'obs_descuento_inter_serv',
                fieldLabel: 'Obs. desc. inter. serv.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:300
            },
            type:'TextArea',
            filters:{pfiltro:'plapa.obs_descuento_inter_serv',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'desc_funcionario1',
                fieldLabel: 'Fun Solicitante',
                allowBlank: true,
                anchor: '80%',
                gwidth: 250,
                maxLength:255
            },
            type:'TextField',
            filters:{pfiltro:'fun.desc_funcionario1',type:'string'},
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
		'id_moneda','tipo_moneda','desc_moneda',
		'num_tramite','monto_excento',
		'proc_monto_excento_var','obs_wf','descuento_inter_serv',
		'obs_descuento_inter_serv','porc_monto_retgar','desc_funcionario1','revisado_asistente',
		{name:'fecha_conformidad', type: 'date',dateFormat:'Y-m-d'},'conformidad'
		
	],
	
   
    
   
   onBtnSincPresu:function() {                  
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
   
   
   antEstado:function(){
         var rec=this.sm.getSelected();
            Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/AntFormEstadoWf.php',
            'Estado de Wf',
            {
                modal:true,
                width:450,
                height:250
            }, {data:rec.data}, this.idContenedor,'AntFormEstadoWf',
            {
                config:[{
                          event:'beforesave',
                          delegate: this.onAntEstado,
                        }
                        ],
               scope:this
             })
   },
   
   onAntEstado:function(wizard,resp){
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url:'../../sis_tesoreria/control/PlanPago/anteriorEstadoPlanPago',
                params:{
                        id_proceso_wf:resp.id_proceso_wf,
                        id_estado_wf:resp.id_estado_wf,  
                        obs:resp.obs
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
                                }, {data:{
                                       id_estado_wf:rec.data.id_estado_wf,
                                       id_proceso_wf:rec.data.id_proceso_wf,
                                       fecha_ini:rec.data.fecha_tentativa,
                                       //url_verificacion:'../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago'
                                       
                                       
                                    
                                    }}, this.idContenedor,'FormEstadoWf',
                                {
                                    config:[{
                                              event:'beforesave',
                                              delegate: this.onSaveWizard,
                                              
                                            }],
                                    
                                    scope:this
                                 });
               
     },
     
    
     onSaveWizard:function(wizard,resp){
        Phx.CP.loadingShow();
        
        Ext.Ajax.request({
            url:'../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago',
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
    
    
     successSinc:function(resp){
            Phx.CP.loadingHide();
            //this.wDEPTO.hide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(reg.ROOT.datos.resultado!='falla'){
                
                this.reload();
             }else{
                alert(reg.ROOT.datos.mensaje)
            }
     },
     
     
     
    habilitarDescuentos:function(me){
        
        me.mostrarComponente(me.Cmp.otros_descuentos);
        me.mostrarComponente(me.Cmp.descuento_inter_serv);
        me.mostrarComponente(me.Cmp.descuento_anticipo);
        //me.mostrarComponente(me.Cmp.monto_retgar_mo);
        //me.mostrarComponente(me.Cmp.descuento_ley);
       
        
       
        me.mostrarComponente(me.Cmp.obs_descuento_inter_serv);
        me.mostrarComponente(me.Cmp.obs_descuentos_anticipo);
        me.mostrarComponente(me.Cmp.obs_otros_descuentos);
        //me.mostrarComponente(me.Cmp.obs_descuentos_ley);
        
    } ,
    deshabilitarDescuentos:function(me){
        
        me.ocultarComponente(me.Cmp.otros_descuentos);
        me.ocultarComponente(me.Cmp.descuento_inter_serv);
        me.ocultarComponente(me.Cmp.descuento_anticipo);
        //me.ocultarComponente(me.Cmp.monto_retgar_mo);
        //me.ocultarComponente(me.Cmp.descuento_ley);
        me.ocultarComponente(me.Cmp.obs_descuento_inter_serv);
        me.ocultarComponente(me.Cmp.obs_descuentos_anticipo);
        me.ocultarComponente(me.Cmp.obs_otros_descuentos);
        //me.ocultarComponente(me.Cmp.obs_descuentos_ley);
        
        
        
            
        
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
        var monto_ret_gar =  0;
        if(this.porc_ret_gar > 0  && this.Cmp.tipo.getValue()=='pagado')
        {
            this.Cmp.monto_retgar_mo.setValue(this.porc_ret_gar*this.Cmp.monto.getValue());
        } 
        
        monto_ret_gar =  this.Cmp.monto_retgar_mo.getValue();
        
       
        var liquido = this.Cmp.monto.getValue()  -  this.Cmp.monto_no_pagado.getValue() -  this.Cmp.otros_descuentos.getValue() - monto_ret_gar -  this.Cmp.descuento_ley.getValue() -  this.Cmp.descuento_inter_serv.getValue() -  this.Cmp.descuento_anticipo.getValue();
        this.Cmp.liquido_pagable.setValue(liquido>0?liquido:0);
        var eje = this.Cmp.monto.getValue()  -  this.Cmp.monto_no_pagado.getValue()
        this.Cmp.monto_ejecutar_total_mo.setValue(eje>0?eje:0);
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
    
    creaFormularioConformidad:function(){
    	
        this.formConformidad = new Ext.form.FormPanel({
            id: this.idContenedor + '_CONFOR',            
            items: [new Ext.form.TextArea({
                fieldLabel: 'Conformidad',                 
                name: 'conformidad',
                height:150,
                allowBlank:false,
                width:'95%'
            }),
            new Ext.form.DateField({
                fieldLabel: 'Fecha Recepción/Informe',
                format: 'd/m/Y', 
                name: 'fecha_conformidad',
                allowBlank:false,
                width:'70%'
            })],
            autoScroll: false,
            //height: this.fheight,
            autoDestroy: true,
            autoScroll: true
        });
        
        
        // Definicion de la ventana que contiene al formulario
        this.windowConformidad = new Ext.Window({
            // id:this.idContenedor+'_W',
            title: 'Datos Acta Conformidad',
            modal: true,
            width: 400,
            height: 300,
            bodyStyle: 'padding:5px;',
            layout: 'fit',
            hidden: true,
            autoScroll: false,
            maximizable: true,
            buttons: [{
	                text: 'Guardar',
	                arrowAlign: 'bottom',
	                handler: this.onSubmitConformidad,
	                argument: {
	                    'news': false
	                },
	                scope: this

                },
                {
	                text: 'Declinar',
	                handler: this.onDeclinarConformidad,
					scope: this
               }],
            items: this.formConformidad,
            // autoShow:true,
            autoDestroy: true,
            closeAction: 'hide'
        });
     }, 
     
     onButtonConformidad : function () {
     	var d= this.sm.getSelected().data;
     	this.formConformidad.getForm().findField('conformidad').setValue(d.conformidad);
     	this.formConformidad.getForm().findField('fecha_conformidad').setValue(d.fecha_conformidad);
     	this.windowConformidad.show();
     },
     
     onSubmitConformidad : function () {
     	var d= this.sm.getSelected().data;
     	Phx.CP.loadingShow();	
		Ext.Ajax.request({
				url:'../../sis_tesoreria/control/PlanPago/generarConformidad',
				success:this.successConformidad,
				failure:this.failureConformidad,
				params:{
						'id_plan_pago' : d.id_plan_pago,
						'conformidad' : this.formConformidad.getForm().findField('conformidad').getValue(), 
						'fecha_conformidad' : this.formConformidad.getForm().findField('fecha_conformidad').getValue().dateFormat('d/m/Y')},
				timeout:this.timeout,
				scope:this
		});
     	
     },
     
     successConformidad : function (resp) {
     	this.windowConformidad.hide();
     	Phx.vista.PlanPago.superclass.successDel.call(this,resp); 
     	
     },
     
     failureConformidad : function (resp) {
     	Phx.CP.loadingHide();
     	Phx.vista.PlanPago.superclass.conexionFailure.call(this,resp);    	
     	
     },
     
     onDeclinarConformidad : function () {
     	this.windowConformidad.hide();
     },
    
    
    inicioValores:function(){
        
        this.Cmp.fecha_tentativa.minValue=new Date();
        this.Cmp.fecha_tentativa.setValue(new Date());
        this.Cmp.nombre_pago.setValue(this.maestro.desc_proveedor);
        this.Cmp.monto.setValue(0);
        this.Cmp.descuento_anticipo.setValue(0);
        this.Cmp.descuento_inter_serv.setValue(0);
        this.Cmp.monto_no_pagado.setValue(0);
        this.Cmp.otros_descuentos.setValue(0);
        this.Cmp.liquido_pagable.setValue(0);
        this.Cmp.monto_ejecutar_total_mo.setValue(0);
        this.Cmp.monto_retgar_mo.setValue(0);
        this.Cmp.descuento_ley.setValue(0);
        this.Cmp.liquido_pagable.setReadOnly(true);
        this.Cmp.monto_ejecutar_total_mo.setReadOnly(true);
        
    },
    
    ocultarCheCue: function(me,pFormaPago){
        
        if(pFormaPago=='transferencia'){
            
            //Deshabilita campo cheque
            me.Cmp.nro_cheque.allowBlank=true;
            me.Cmp.nro_cheque.setValue('');
            me.Cmp.nro_cheque.disable();
           
            //Habilita nrocuenta bancaria destino
            me.Cmp.nro_cuenta_bancaria.allowBlank=false;
            me.Cmp.nro_cuenta_bancaria.enable();
        
        } 
        else{
            
            //cheque
            //Habilita campo cheque
            me.Cmp.nro_cheque.allowBlank=false;
            me.Cmp.nro_cheque.enable();
            //Habilita nrocuenta bancaria destino
            me.Cmp.nro_cuenta_bancaria.allowBlank=true;
            me.Cmp.nro_cuenta_bancaria.setValue('');
            me.Cmp.nro_cuenta_bancaria.disable();
        }
        
    },
    
    
    /*
     * DATE    09/07/2014
     * Author  RAC
     * DESC    Prepara los componentes segun el tipo de pago
     */
     
    
    setTipoPago : {
         'devengado':function(me){
                //plantilla (TIPO DOCUMENTO)
                me.mostrarComponente(me.Cmp.id_plantilla);
                me.mostrarComponente(me.Cmp.monto_excento);
                me.mostrarComponente(me.Cmp.monto_no_pagado);
                me.mostrarComponente(me.Cmp.obs_monto_no_pagado);
                me.mostrarComponente(me.Cmp.liquido_pagable); 
                me.mostrarComponente(me.Cmp.monto_retgar_mo)   
                me.mostrarComponente(me.Cmp.descuento_ley);
                me.mostrarComponente(me.Cmp.obs_descuentos_ley);
                
                me.deshabilitarDescuentos(me);
                me.ocultarComponentesPago(me);
                
                me.Cmp.monto_retgar_mo.setReadOnly(false)
                
           },
           
          'devengado_pagado':function(me){
               //plantilla (TIPO DOCUMENTO)
               me.mostrarComponente(me.Cmp.id_plantilla);
               me.mostrarComponente(me.Cmp.monto_excento);
               me.mostrarComponente(me.Cmp.monto_no_pagado);
               me.mostrarComponente(me.Cmp.obs_monto_no_pagado);
               me.mostrarComponente(me.Cmp.liquido_pagable); 
               me.mostrarComponente(me.Cmp.monto_retgar_mo)
               me.mostrarComponente(me.Cmp.obs_descuentos_ley);
               me.mostrarComponente(me.Cmp.descuento_ley);
               
               me.habilitarDescuentos(me)
               me.mostrarComponentesPago(me);
               me.Cmp.monto_retgar_mo.setReadOnly(false)
              
        
        
           },
           
           'devengado_pagado_1c':function(me){
               //plantilla (TIPO DOCUMENTO)
               me.setTipoPago['devengado_pagado'](me);       
           },
           
           'rendicion':function(me){
               //plantilla (TIPO DOCUMENTO)
               me.mostrarComponente(me.Cmp.id_plantilla);
               me.mostrarComponente(me.Cmp.monto_excento);
               me.mostrarComponente(me.Cmp.monto_no_pagado);
               me.mostrarComponente(me.Cmp.obs_monto_no_pagado);
               me.habilitarDescuentos(me);
               },
           'dev_garantia':function(me){
              me.ocultarComponente(me.Cmp.id_plantilla);
              me.mostrarComponente(me.Cmp.liquido_pagable);
              me.mostrarComponentesPago(me);
              me.deshabilitarDescuentos(me);
              me.ocultarComponente(me.Cmp.descuento_ley);
              me.ocultarComponente(me.Cmp.obs_descuentos_ley);
              me.ocultarComponente(me.Cmp.monto_ejecutar_total_mo);
              me.ocultarComponente(me.Cmp.monto_no_pagado);
              me.ocultarComponente(me.Cmp.monto_retgar_mo);
              
           },
           
           'pagado':function(me){
               me.Cmp.id_plantilla.disable();
               me.habilitarDescuentos(me);
               me.mostrarComponentesPago(me);
               me.mostrarComponente(me.Cmp.liquido_pagable);
               me.Cmp.monto_retgar_mo.setReadOnly(true)
        },
        'ant_parcial':function(me){
                me.ocultarComponente(me.Cmp.id_plantilla);
                
                me.mostrarComponentesPago(me);              
                me.ocultarComponente(me.Cmp.descuento_anticipo);
                me.ocultarComponente(me.Cmp.descuento_inter_serv);
                me.ocultarComponente(me.Cmp.monto_no_pagado);
                me.ocultarComponente(me.Cmp.otros_descuentos);
                me.ocultarComponente(me.Cmp.monto_ejecutar_total_mo);
                me.ocultarComponente(me.Cmp.monto_retgar_mo);
                me.ocultarComponente(me.Cmp.descuento_ley);
                me.ocultarComponente(me.Cmp.monto_ejecutar_total_mo);
                me.ocultarComponente(me.Cmp.obs_descuento_inter_serv);
                me.ocultarComponente(me.Cmp.obs_descuentos_anticipo);
                me.ocultarComponente(me.Cmp.obs_otros_descuentos);
                me.ocultarComponente(me.Cmp.obs_descuentos_ley);
                me.mostrarComponente(me.Cmp.liquido_pagable);
            
        },
        
        'anticipo':function(me){
             
                me.mostrarComponente(me.Cmp.id_plantilla);
                
                me.mostrarComponentesPago(me);
                
                me.ocultarComponente(me.Cmp.descuento_anticipo);
                me.ocultarComponente(me.Cmp.descuento_inter_serv);
                me.ocultarComponente(me.Cmp.monto_no_pagado);
                me.ocultarComponente(me.Cmp.otros_descuentos);
                me.ocultarComponente(me.Cmp.monto_ejecutar_total_mo);
                me.ocultarComponente(me.Cmp.monto_retgar_mo);
                me.ocultarComponente(me.Cmp.monto_ejecutar_total_mo);
                me.ocultarComponente(me.Cmp.obs_descuento_inter_serv);
                me.ocultarComponente(me.Cmp.obs_descuentos_anticipo);
                me.ocultarComponente(me.Cmp.obs_otros_descuentos);
                
                me.mostrarComponente(me.Cmp.liquido_pagable);
                me.mostrarComponente(me.Cmp.descuento_ley);
                me.mostrarComponente(me.Cmp.obs_descuentos_ley);
         },
         'ant_aplicado':function(me){
                me.Cmp.id_plantilla.disable();
               
                me.ocultarComponente(me.Cmp.descuento_ley);
                me.ocultarComponente(me.Cmp.obs_descuentos_ley);
                me.ocultarComponente(me.Cmp.monto_retgar_mo);                
                me.ocultarComponente(me.Cmp.monto_no_pagado); 
                //me.ocultarComponente(me.Cmp.liquido_pagable);                 
                me.deshabilitarDescuentos(me);
                
                me.ocultarComponentesPago(me);
          }
    },
    
    mostrarComponentesPago:function(me){
        me.mostrarComponente(me.Cmp.nombre_pago);
        if(me.Cmp.id_cuenta_bancaria){
           me.mostrarComponente(me.Cmp.id_cuenta_bancaria); 
           me.mostrarComponente(me.Cmp.id_cuenta_bancaria_mov);
        }
        if(me.Cmp.forma_pago){
           me.mostrarComponente(me.Cmp.forma_pago); 
        }
        if(me.Cmp.nro_cuenta_bancaria){
           me.mostrarComponente(me.Cmp.nro_cuenta_bancaria); 
        } 
        if(me.Cmp.nro_cheque){
           me.mostrarComponente(me.Cmp.nro_cheque); 
        }
        
    },
    ocultarComponentesPago:function(me){
         me.ocultarComponente(me.Cmp.nombre_pago);
         
        if(me.Cmp.id_cuenta_bancaria){
           me.ocultarComponente(me.Cmp.id_cuenta_bancaria);
           me.ocultarComponente(me.Cmp.id_cuenta_bancaria_mov);
        }
        if(me.Cmp.forma_pago){
           me.ocultarComponente(me.Cmp.forma_pago); 
        }
        if(me.Cmp.nro_cuenta_bancaria){
           me.ocultarComponente(me.Cmp.nro_cuenta_bancaria); 
        }
        if(me.Cmp.nro_cheque){
           me.ocultarComponente(me.Cmp.nro_cheque); 
        }
        
    },
    
    Grupos: [
            {
                layout: 'hbox',
                border: false,
                defaults: {
                   border: true
                },            
                items: [
                              {
                                xtype: 'fieldset',
                                title: 'Tipo de Pago',
                                autoHeight: true,
                                //layout:'hbox',
                                items: [],
                                id_grupo:0,
                                margins:'2 2 2 2'
                             },
                              
                            {
                                xtype: 'fieldset',
                                title: 'Detalle de Pago',
                                autoHeight: true,
                                //layout:'hbox',
                                items: [],
                                margins:'2 10 2 2',
                                id_grupo:1,
                                flex:1
                             }
                       ]
                  
     }],
    
    onButtonNew:function(){
         this.accionFormulario = 'NEW';
         Phx.vista.PlanPago.superclass.onButtonNew.call(this); 
    },
    
    
    onButtonEdit:function(){
         this.accionFormulario = 'EDIT';
         var data = this.getSelectedData();
         //deshabilita el cambio del tipo de pago
         this.Cmp.tipo.disable();
         this.Cmp.fecha_tentativa.enable();
         this.Cmp.tipo.store.loadData(this.arrayStore.TODOS) 
         //segun el tipo define los campo visibles y no visibles
         this.setTipoPago[data.tipo](this);
         if(data.tipo == 'pagado'){
             this.accionFormulario = 'EDIT_PAGO';
             this.porc_ret_gar = data.porc_monto_retgar;
             
         }
        
        
        
        Phx.vista.PlanPago.superclass.onButtonEdit.call(this); 
    },
      
    sortInfo:{
		field: 'fecha_reg',
		direction: 'DESC'
	},
	onButtonNew: function(){
		Phx.vista.PlanPago.superclass.onButtonNew.call(this);
		//this.Cmp.f.store.baseParams={id_cuenta_bancaria:-1,fecha:new Date()}
	}
	
})
</script>
		
		