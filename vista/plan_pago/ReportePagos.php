<?php
/**
*@package pXP
*@file gen-ReportePagos.php
*@author  (admin)
*@date 16-12-2013 20:43:44
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ReportePagos=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
		this.initButtons=[this.cmbGestion];
    	//llama al constructor de la clase padre
		Phx.vista.ReportePagos.superclass.constructor.call(this,config);
		this.init();
		this.bloquearOrdenamientoGrid();
		this.cmbGestion.on('select', function(){
		    
		    if(this.validarFiltros()){
                  this.capturaFiltros();
           }
		    
		    
		},this);
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
            Phx.vista.ReportePagos.superclass.onButtonAct.call(this);
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
				name: 'gestion',
				fieldLabel: 'Gestion',  
				gwidth: 60
			},
			type:'Field',
			filters:{pfiltro:'gestion',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'num_tramite',
				fieldLabel: 'Tramite',
				gwidth: 100
			},
			type:'Field',
			filters:{pfiltro:'num_tramite',type:'string'},
			id_grupo:1,
			grid:true,
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
			grid:true,
			form:false
		},
		{
			config:{
				name: 'orden_compra',
				fieldLabel: 'OC',
				gwidth: 150
			},
			type:'Field',
			filters:{pfiltro:'orden_compra',type:'string'},
			grid:true,
			form:false
		},
		{
			config:{
				name: 'desc_contrato',
				fieldLabel: 'Contrato Nro',
				gwidth: 150
			},
			type:'Field',
			filters:{pfiltro:'desc_contrato',type:'string'},
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
				gwidth: 70
			},
			type:'Field',
			filters:{pfiltro:'fecha',type:'string'},
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
				gwidth: 100
			},
			type:'Field',
			filters:{pfiltro:'fecha_tentativa_de_pago',type:'string'},
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
				name: 'monto_presupuestado',
				fieldLabel: 'Comprometido',
				gwidth: 100
			},
			type:'Field',
			filters:{pfiltro:'liquido_pagable', type:'numeric'},
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
	ActList:'../../sis_tesoreria/control/PlanPago/listarPagosXProveedor',
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
                'fecha',
                'fecha_reg',
                'ob_obligacion_pago',
                'fecha_tentativa_de_pago',
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
                'monto_presupuestado','desc_contrato' ],
	sortInfo:{
		field: 'id_gestion',
		direction: 'desc'
	},
	bdel:  false,
	bsave: false,
	bedit: false,
	bnew:  false
	}
)
</script>
		
		