<?php
/**
*@package pXP
*@file gen-ReportePagosSimple.php
*@author  (admin)
*@date 16-12-2013 20:43:44
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ReportePagosSimple=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
		this.initButtons=[this.cmbGestion];
    	//llama al constructor de la clase padre
		Phx.vista.ReportePagosSimple.superclass.constructor.call(this,config);
		this.init();
		this.bloquearOrdenamientoGrid();
		this.cmbGestion.on('select', function(){
		    
		    if(this.validarFiltros()){
                  this.capturaFiltros();
           }
		    
		    
		},this);
		
		this.addButton('btnChequeoDocumentosWf',
            {
                text: 'Documentos',
                grupo:[0,1,2],
                iconCls: 'bchecklist',
                disabled: true,
                handler: this.loadCheckDocumentosSolWf,
                tooltip: '<b>Documentos de la Solicitud</b><br/>Subir los documetos requeridos en la solicitud seleccionada.'
            }
        );
        
        
        this.addBotonesGantt();
		
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
   },
	
	
	addBotonesGantt: function() {
        this.menuAdqGantt = new Ext.Toolbar.SplitButton({
            id: 'b-diagrama_gantt-' + this.idContenedor,
            text: 'Gantt',
            disabled: true,
            grupo:[0,1,2],
            iconCls : 'bgantt',
            handler:this.diagramGanttDinamico,
            scope: this,
            menu:{
            items: [{
                id:'b-gantti-' + this.idContenedor,
                text: 'Gantt Imagen',
                tooltip: '<b>Mues un reporte gantt en formato de imagen</b>',
                handler:this.diagramGantt,
                scope: this
            }, {
                id:'b-ganttd-' + this.idContenedor,
                text: 'Gantt Dinámico',
                tooltip: '<b>Muestra el reporte gantt facil de entender</b>',
                handler:this.diagramGanttDinamico,
                scope: this
            }
        ]}
        });
		this.tbar.add(this.menuAdqGantt);
    },
    
    diagramGanttDinamico : function(){			
		var data=this.sm.getSelected().data.id_proceso_wf;
		window.open('../../../sis_workflow/reportes/gantt/gantt_dinamico.html?id_proceso_wf='+data)		
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
	
	
	
	validarFiltros:function(){
        if(this.cmbGestion.isValid()){
            return true;
        }
        else{
            return false;
        }
        
    },
    
     capturaFiltros:function(combo, record, index){
        this.desbloquearOrdenamientoGrid();
        this.store.baseParams.id_gestion=this.cmbGestion.getValue();
        this.load(); 
            
        
    },
    onButtonAct:function(){
        if(!this.validarFiltros()){
            alert('Especifique los filtros antes')
         }
        else{
            this.store.baseParams.id_gestion=this.cmbGestion.getValue();
            Phx.vista.ReportePagosSimple.superclass.onButtonAct.call(this);
        }
    },
	tam_pag:50,
	cmbGestion:new Ext.form.ComboBox({
				fieldLabel: 'Gestion',
				allowBlank: true,
				emptyText:'Gestion...',
				store:new Ext.data.JsonStore(
				{
					url: '../../sis_parametros/control/Gestion/listarGestion',
					id: 'id_gestion',
					root: 'datos',
					sortInfo:{
						field: 'gestion',
						direction: 'DESC'
					},
					totalProperty: 'total',
					fields: ['id_gestion','gestion'],
					// turn on remote sorting
					remoteSort: true,
					baseParams:{par_filtro:'gestion'}
				}),
				valueField: 'id_gestion',
				triggerAction: 'all',
				displayField: 'gestion',
			    hiddenName: 'id_gestion',
    			mode:'remote',
				pageSize:50,
				queryDelay:500,
				listWidth:'280',
				width:80
			}),		
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
				name: 'num_tramite',
				fieldLabel: 'Tramite',
				gwidth: 150
			},
			type:'Field',
			filters:{pfiltro:'num_tramite',type:'string'},
			id_grupo:1,
			bottom_filter: true,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'desc_contrato',
				fieldLabel: 'Contrato Nro',
				gwidth: 240
			},
			type:'Field',
			filters:{pfiltro:'desc_contrato',type:'string'},
			grid:true,
			bottom_filter: true,
			form:false
		},
		{
			config:{
				name: 'tipo_obligacion',
				fieldLabel: 'Tipo OP',
				gwidth: 70
			},
			type:'Field',
			filters:{	
	       		       type: 'list',
	       		       pfiltro:'tipo_obligacion',
	       			   options: ['adquisiciones', 'pago_directo', 'pago_unico','rrhh' ]	
	       		 	},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'desc_proveedor',
				fieldLabel: 'Proveedor',
				gwidth: 250
			},
			type:'Field',
			filters:{ pfiltro:'desc_proveedor',type:'string' },
			
			id_grupo:1,
			 bottom_filter: true,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'desc_funcionario1',
				fieldLabel: 'Funcionario Solicitante',
				gwidth: 250
			},
			type:'Field',
			filters:{ pfiltro:'desc_funcionario1',type:'string' },
			
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'desc_plantilla',
				fieldLabel: 'Tipo Doc',
				gwidth: 250
			},
			type:'Field',
			filters:{ pfiltro:'desc_plantilla',type:'string' },
			
			id_grupo:1,
			grid:true,
			form:false
		},
		
		{
			config:{
				name: 'pago_variable',
				fieldLabel: 'Variable',
				gwidth: 50
			},
			type:'Field',
			filters:{pfiltro:'pago_variable',type:'string'},
			grid:true,
			form:false
		},
		{
			config:{
				name: 'fecha',
				fieldLabel: 'Fecha OP',
				gwidth: 70,
				format: 'd/m/Y', 
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'fecha',type:'date'},
			grid:true,
			form:false
		},
		{
			config:{
				name: 'usuario_reg',
				fieldLabel: 'Usu. Reg.',
				gwidth: 80
			},
			type:'Field',
			filters:{pfiltro:'usuario_reg',type:'string'},
			grid:true,
			form:false
		},
		{
			config:{
				name: 'ob_obligacion_pago',
				fieldLabel: 'Obs. OP.',
				gwidth: 50
			},
			type:'Field',
			filters:{pfiltro:'ob_obligacion_pago',type:'string'},
			grid:true,
			form:false
		},
		{
			config:{
				name: 'tipo_informe',
				fieldLabel: 'Informe',
				gwidth: 50
			},
			type:'Field',
			filters:{pfiltro:'tipo_informe',type:'string'},
			grid:true,
			form:false
		},
		{
			config:{
				name: 'nro_cuota',
				fieldLabel: 'Nro Cuota',
				gwidth: 50
			},
			type:'Field',
			filters:{pfiltro:'nro_cuota',type:'string'},
			grid:true,
			form:false
		},
		{
			config:{
				name: 'fecha_tentativa_de_pago',
				fieldLabel: 'Fecha Ten PP.',
				gwidth: 100,
				format: 'd/m/Y', 
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'fecha_tentativa_de_pago',type:'date'},
			grid:true,
			form:false
		},
		{
			config:{
				name: 'tipo_plan_pago',
				fieldLabel: 'Tipo Pago.',
				gwidth: 100
			},
			type:'Field',
			filters:{	
	       		         type: 'list',
	       				 options: ['det_rendicion', 'dev_garantia', 'ant_aplicado' , 'pagado_rrh', 'pagado', 'ant_parcial', 'anticipo', 'rendicion', 'devengado_rrhh', 'devengado','devengado_pagado','devengado_pagado_1c']	
	       		 	},
			grid:true,
			bottom_filter: true,
			form:false
		},
		{
			config:{
				name: 'estado_plan_pago',
				fieldLabel: 'Estado Pago.',
				gwidth: 100
			},
			type:'Field',
			filters:{pfiltro:'estado_plan_pago',type:'string'},
			grid:true,
			form:false
		},
		{
			config:{
				name: 'obs_monto_no_pagado',
				fieldLabel: 'Obs. Pago',
				gwidth: 200
			},
			type:'Field',
			filters:{pfiltro:'obs_monto_no_pagado',type:'string'},
			grid:true,
			form:false
		},
		{
			config:{
				name: 'codigo',
				fieldLabel: 'Moneda',
				gwidth: 50
			},
			type:'Field',
			filters:{pfiltro:'codigo',type:'string'},
			grid:true,
			form:false
		},
		
		{
			config:{
				name: 'monto_cuota',
				fieldLabel: 'Monto Pago',
				gwidth: 100
			},
			type:'Field',
			filters:{pfiltro:'liquido_pagable', type:'numeric'},
			grid:true,
			form:false
		},
		{
			config:{
				name: 'liquido_pagable',
				fieldLabel: 'Liquido Pago',
				gwidth: 100
			},
			type:'Field',
			filters:{pfiltro:'liquido_pagable', type:'numeric'},
			grid:true,
			form:false
		},
		{
			config:{
				name: 'monto_excento',
				fieldLabel: 'Exento',
				gwidth: 100
			},
			type:'Field',
			filters:{pfiltro:'monto_excento',type:'numeric'},
			grid:true,
			form:false
		}
		
		
		
	],
	pdfOrientacion: 'L',
	title:'Pagos por Proveedor',
	ActList:'../../sis_tesoreria/control/PlanPago/listarPagos',
	id_store:'id_caja',
	fields: [
                'id_plan_pago',
                'id_gestion',
                'gestion',
                'id_obligacion_pago',
                'num_tramite',
                'orden_compra',
                'tipo_obligacion',
                'pago_variable',
                'desc_proveedor',
                'estado',
                'usuario_reg',
                {name:'fecha', type: 'date',dateFormat:'Y-m-d'},
                {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                
                'ob_obligacion_pago',
                {name:'fecha_tentativa_de_pago', type: 'date',dateFormat:'Y-m-d'},
              
                'nro_cuota',
                'tipo_plan_pago',
                'estado_plan_pago',
                'obs_descuento_inter_serv',
                'obs_descuentos_anticipo',
                'obs_descuentos_ley',
                'obs_monto_no_pagado',
                'obs_otros_descuentos',
                'codigo',
                'monto_cuota',
                'monto_anticipo',
                'monto_excento',
                'monto_retgar_mo',
                'monto_ajuste_ag',
                'monto_ajuste_siguiente_pago','liquido_pagable',
                'monto_presupuestado','desc_contrato', 'desc_funcionario1','id_proceso_wf',
                'id_plantilla','desc_plantilla', 'tipo_informe' ],
	sortInfo:{
		field: 'id_gestion',
		direction: 'desc'
	},
	bdel:  false,
	bsave: false,
	bedit: false,
	bnew:  false,
	
	preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;
          Phx.vista.ReportePagosSimple.superclass.preparaMenu.call(this,n); 
          this.getBoton('diagrama_gantt').enable();
          this.getBoton('btnChequeoDocumentosWf').enable();
          
     },
     
     
     liberaMenu:function(){
        var tb = Phx.vista.ReportePagosSimple.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('diagrama_gantt').disable();
			this.getBoton('btnChequeoDocumentosWf').disable();
			
        }
        
        
       return tb
    }, 
	
	
})
</script>
		
		