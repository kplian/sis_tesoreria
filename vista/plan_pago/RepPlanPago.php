<?php
/**
*@package pXP
*@file gen-RepPlanPago.php
*@author  (admin)
*@date 10-04-2013 15:43:23
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.RepPlanPago=Ext.extend(Phx.gridInterfaz,{
	bnew: false,
	bsave: false,
	bedit: false,
	bdel: false,
    constructor:function(config){
		//definicion de grupos para fomrulario
		var me = this;
		//llama al constructor de la clase padre
		Phx.vista.RepPlanPago.superclass.constructor.call(this,config);
		this.grid.getTopToolbar().disable();
		this.grid.getBottomToolbar().disable();
		this.init();
		this.grid.addListener('cellclick', this.oncellclick,this);
		/*this.addButton('btnChequeoDocumentosWf',
            {
                text: 'Documentos',
                grupo:[0,1], 
                iconCls: 'bchecklist',
                disabled: true,
                handler: this.loadCheckDocumentosSolWf,
                tooltip: '<b>Documentos de la Solicitud</b><br/>Subir los documetos requeridos en la solicitud seleccionada.'
            }
        );*/
       
	},
	tam_pag:50,
	
	
	
	Atributos:[
		
        {
            config:{
                name: 'id_plan_pago',
                fieldLabel: 'Docs.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 40,
                scope: this,
                renderer:function (value, p, record, rowIndex, colIndex){  
                	    return "<div style='text-align:center'><img border='0' style='-webkit-user-select:auto;cursor:pointer;' title='Documentos del pago' src = '../../../lib/imagenes/icono_awesome/awe_documents.png' align='center' width='30' height='30'></div>";
                }            
            },
            type:'Field',
            grid:true,
            form:false
        },
	
	/*
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_plan_pago'
			},
			type:'Field',
			form:true 
		},*/
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
            filters:{pfiltro:'num_tramite',type:'string'},
            id_grupo:1,
            bottom_filter: true,
            grid:true,
            form:false
        },
        
        {
            config:{
                name: 'nro_cuota',
                fieldLabel: 'Cuo. N#',
                allowBlank: true,
                gwidth: 50,
                maxLength:4
            },
            type:'NumberField',
            filters:{pfiltro:'nro_cuota',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'estado',
                fieldLabel: 'Estado - (Rev)',
                allowBlank: true,
                renderer:function(value_ori,p,record){
                        
                        var value = value_ori;
                        if(value_ori == 'pagado'){
                        	value = 'contabilizado '
                        }
                        
                        if(record.data.total_prorrateado!=record.data.monto_ejecutar_total_mo || record.data.contador_estados > 1){
                             return String.format('<div title="Número de revisiones: {1}"><b><font color="red">{0} </font></b></div>', value);
                         }
                          else{
                            return String.format('<div title="Número de revisiones: {1}">{0} </div>', value);
                        }},
                anchor: '80%',
                gwidth: 100,
                maxLength:60
            },
            type:'Field',
            filters:{pfiltro:'estado',type:'string'},
            bottom_filter: true,
            id_grupo:1,
            grid:true
        },
       {
            config:{
                name: 'fecha_tentativa',
                fieldLabel: 'Fecha Tent.',
                allowBlank: false,
                gwidth: 80,
                        format: 'd/m/Y', 
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'fecha_tentativa',type:'date'},
            id_grupo:0,
            grid:true,
            form:false
        },
        {
            config:{
                name:'codigo',
                fieldLabel:'Mon.',
                gwidth: 40,
            },
            type:'Field',
            id_grupo:1,
            filters:{   
                pfiltro:'codigo',
                type:'string'
            },
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
            filters:{pfiltro:'monto',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:false
        },
         {
            config:{
                name: 'desc_proveedor',
                fieldLabel: 'Proveedor',
                allowBlank: true,
                anchor: '80%',
                gwidth: 250,
                maxLength:255
            },
            type:'TextField',
            filters:{pfiltro:'desc_proveedor',type:'string'},
            bottom_filter: true,
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'tipo',
                fieldLabel: 'Tipo de Cuota',
                emptyText:'Tipo de Cuoata',
                renderer:function (value, p, record){
                        var dato='';
                        dato = (dato==''&&value=='devengado')?'Devengar':dato;
                        dato = (dato==''&&value=='devengado_rrhh')?'Devengar':dato;
                        dato = (dato==''&&value=='devengado_pagado')?'Devengar y pagar (2 cbte)':dato;
                        dato = (dato==''&&value=='devengado_pagado_1c')?'Devengar y pagar (1 cbte)':dato;
                        dato = (dato==''&&value=='pagado')?'Pagar':dato;
                        dato = (dato==''&&value=='pagado_rrhh')?'Pagar':dato;
                        dato = (dato==''&&value=='anticipo')?'Anticipo Fact/Rec':dato;
                        dato = (dato==''&&value=='ant_parcial')?'Anticipo Parcial':dato;
                        dato = (dato==''&&value=='ant_rendicion')?'Ant. por Rendir':dato;
                        dato = (dato==''&&value=='dev_garantia')?'Devolucion de Garantia':dato;
                        dato = (dato==''&&value=='ant_aplicado')?'Aplicacion de Anticipo':dato;
                        dato = (dato==''&&value=='rendicion')?'Rendicion Ant.':dato;
                        dato = (dato==''&&value=='ret_rendicion')?'Detalle de Rendicion':dato;
                        dato = (dato==''&&value=='especial')?'Pago simple (s/p)':dato;
                        return String.format('{0}', dato);
                    },
                
                wisth: 420,
                gwidth: 150,
                },
            type:'Field',
            filters:{pfiltro:'tipo',type:'string'},
            id_grupo:0,
            grid:true,
            form:true
        },
        {
            config:{
                name:'obs',
                fieldLabel:'Obs OP.',
                gwidth: 150,
            },
            type:'Field',
            id_grupo:1,
            filters:{pfiltro:'obs',type:'string'},
            bottom_filter: true,
            grid:true,
            form:false
        },
        {
            config:{
                name:'conceptos',
                fieldLabel:'Conceptos.',
                gwidth: 150,
            },
            type:'Field',
            id_grupo:1,
            filters:{pfiltro:'conceptos',type:'string'},
            bottom_filter: true,
            grid:true,
            form:false
        },
        {
            config:{
                name:'ordenes',
                fieldLabel:'Ordenes.',
                gwidth: 150,
            },
            type:'Field',
            id_grupo:1,
            filters:{pfiltro:'ordenes',type:'string'},
            bottom_filter: true,
            grid:true,
            form:false
        }
        
      
	],
	
	title:'Plan Pago',
	ActList:'../../sis_tesoreria/control/PlanPago/listadosPagosRelacionados',
	id_store:'id_plan_pago',
	fields: ['id_plan_pago',
	          'desc_proveedor',
	          'num_tramite',
	          'estado',
	          {name:'fecha_tentativa', type: 'date',dateFormat:'Y-m-d'},
	          'nro_cuota',
	          'monto',
	          'codigo',
	          'conceptos',
	          'ordenes',
	          'id_proceso_wf',
	          'id_estado_wf',
	          'id_proveedor',
	          'obs',
	          'tipo'],

   arrayDefaultColumHidden:['obs','conceptos','ordenes'],
    
   
   rowExpander: new Ext.ux.grid.RowExpander({
	        tpl : new Ext.Template(
	            '<br>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Conceptos:&nbsp;&nbsp;</b> {conceptos}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Ordenes:&nbsp;&nbsp;</b> {ordenes}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Obs OP:&nbsp;&nbsp;</b> {obs}</p>'
	            
	        )
    }),
   
   
    sortInfo:{
		field: 'fecha_tentativa',
		direction: 'DESC'
	},
   
    
	onReloadPage:function(param){
		//Se obtiene la gestión en función de la fecha del comprobante para filtrar partidas, cuentas, etc.
		var me = this;
		this.initFiltro(param);
	},
	
	initFiltro: function(param){
		this.store.baseParams=param;
		this.load( { params: { start:0, limit: this.tam_pag } });
	},
	oncellclick : function(grid, rowIndex, columnIndex, e) {
		
	    var record = this.store.getAt(rowIndex),
	        fieldName = grid.getColumnModel().getDataIndex(columnIndex); // Get field name

	    if (fieldName == 'id_plan_pago' ) {
	    	this.loadCheckDocumentosSolWf()
	    		
	    } 
		
	},
	loadCheckDocumentosSolWf:function() {
            var rec=this.sm.getSelected();
            rec.data.nombreVista = this.nombreVista;
            rec.data.lblDocProcCf = 'Solo doc de Pago';
     		rec.data.lblDocProcSf = 'Todo del Trámite';
     		rec.data.modoConsulta = 'si';
     		rec.data.todos_documentos ='no'; 
             
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
    }
	
})
</script>