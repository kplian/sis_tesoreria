<?php
/**
 * @package pxP
 * @file 	repkardex.php
 * @author 	RCM
 * @date	10/07/2013
 * @description	Archivo con la interfaz de usuario que permite la ejecucion de las funcionales del sistema
 */
header("content-type:text/javascript; charset=UTF-8");
?>
<script>
	Phx.vista.PagosConceptoVista = Ext.extend(Phx.gridInterfaz, {
		constructor : function(config) {
			this.maestro = config;
			this.title = "PAGOS X CONCEPTO";
			this.description = this.maestro.concepto + "-" + this.maestro.gestion;
			Phx.vista.PagosConceptoVista.superclass.constructor.call(this, config);
			this.init();
			this.load({
				params : {
					start: 0,
					limit: 1000,
					id_gestion:this.maestro.id_gestion,					
					id_concepto:this.maestro.id_concepto
				}
			});
		},
		tam_pag:1000,
		Atributos : [{
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'id_plan_pago'
			},
			type : 'Field',
			form : true
		},
		{
			config : {
				name : 'orden_trabajo',
				fieldLabel : 'Orden de Trabajo',				
				gwidth : 170
			},
			type : 'Field',
			filters : {
			    pfiltro : 'opc.desc_orden#ot.desc_orden',
				type : 'string'
			},
			grid : true,
			form : false
		}, 
		{
			config : {
				name : 'num_tramite',
				fieldLabel : 'No Tramite',				
				gwidth : 150
			},
			type : 'Field',
			filters : {
			    pfiltro : 'op.num_tramite',
				type : 'string'
			},
			grid : true,
			form : false
		}, 
		
		{
			config : {
				name : 'nro_cuota',
				fieldLabel : 'No Cuota',				
				gwidth : 80
			},
			type : 'Field',
			filters : {
			    pfiltro : 'pp.nro_cuota',
				type : 'string'
			},
			grid : true,
			form : false
		}, 
		
		{
			config : {
				name : 'desc_proveedor',
				fieldLabel : 'Proveedor',				
				gwidth : 170
			},
			type : 'Field',
			filters : {
			    pfiltro : 'prov.rotulo_comercial',
				type : 'string'
			},
			grid : true,
			form : false
		},
		{
			config : {
				name : 'id_centro_costo',
				fieldLabel : 'Centro Costo',				
				gwidth : 150
			},
			type : 'Field',
			filters : {
			    pfiltro : 'od.id_centro_costo',
				type : 'string'
			},
			grid : true,
			form : false
		}, 		
		{
			config : {
				name : 'estado',
				fieldLabel : 'Estado',				
				gwidth : 80,
				renderer:function(value, p, record) {
					var aux;
					if(record.data.estado == 'borrador'){
						aux='<b><font color="brown">';
					}
					else {
						aux='<b><font color="green">';
					}
					aux = aux +value+'</font></b>';
					return String.format('{0}', aux);
				}
			},
			type : 'Field',
			filters : {
			    pfiltro : 'pp.estado',
				type : 'string'
			},
			grid : true,
			form : false
		}, 		
		{
			config : {
				name : 'fecha_costo_ini',
				fieldLabel : 'Fecha Inicio',				
				gwidth : 80,
				renderer : function(value, p, record) {
					return value ? value.dateFormat('d/m/Y') : ''
				}
			},
			type : 'Field',
			filters : {
			    pfiltro : 'pp.fecha_costo_ini',
				type : 'date'
			},
			grid : true,
			form : false
		},
		{
			config : {
				name : 'fecha_costo_fin',
				fieldLabel : 'Fecha Fin',				
				gwidth : 80,
				renderer : function(value, p, record) {
					return value ? value.dateFormat('d/m/Y') : ''
				}
			},
			type : 'Field',
			filters : {
			    pfiltro : 'pp.fecha_costo_fin',
				type : 'date'
			},
			grid : true,
			form : false
		},		
		{
			config : {
				name : 'fecha',
				fieldLabel : 'Fecha',				
				gwidth : 80,
				renderer : function(value, p, record) {
					return value ? value.dateFormat('d/m/Y') : ''
				}
			},
			type : 'Field',
			filters : {
			    pfiltro : 'pp.fecha_tentativa#com.fecha',
				type : 'date'
			},
			grid : true,
			form : false
		}, 
		
		{
			config : {
				name : 'moneda',
				fieldLabel : 'Moneda',				
				gwidth : 120
			},
			type : 'Field',
			filters : {
			    pfiltro : 'mon.moneda',
				type : 'string'
			},
			grid : true,
			form : false
		}, 
		
		{
			config : {
				name : 'monto',
				fieldLabel : 'Monto',				
				gwidth : 100,				
				renderer:function(value, p, record) {
					var aux;
					if(record.data.estado == 'borrador'){
						aux='<b><font color="brown">';
					}
					else {
						aux='<b><font color="green">';
					}
					aux = aux +value+'</font></b>';
					return String.format('{0}', aux);
				}
			},
			type : 'NumberField',
			filters : {
			    pfiltro : 'pp.monto',
				type : 'numeric'
			},			
			grid : true,
			form : false
		},
		
		{
			config : {
				name : 'monto_ejecutar_mo',
				fieldLabel : 'Monto Ejecucion OT',				
				gwidth : 130,				
				renderer:function(value, p, record) {
					var aux;
					if(record.data.estado == 'borrador'){
						aux='<b><font color="brown">';
					}
					else {
						aux='<b><font color="green">';
					}
					aux = aux +value+'</font></b>';
					return String.format('{0}', aux);
				}
			},
			type : 'NumberField',
			filters : {
			    pfiltro : 'pro.monto_ejecutar_mo',
				type : 'numeric'
			},			
			grid : true,
			form : false
		}
		],
		title : 'Pagos por Concepto',
		ActList : '../../sis_tesoreria/control/PlanPago/listarPagosXConcepto',
		id_store : 'id',
		fields : [{
			name : 'id_plan_pago'
		},{
			name : 'orden_trabajo',
			type : 'string'
		},{
			name : 'num_tramite',
			type : 'string'
		},{
			name : 'nro_cuota',
			type : 'string'
		},{
			name : 'desc_proveedor',
			type : 'string'
		},{
			name : 'estado',
			type : 'string'
		},{
			name : 'moneda',
			type : 'string'
		},{
			name : 'monto',
			type : 'numeric'
		},{
			name : 'id_centro_costo',
			type : 'numeric'
		},{
			name : 'monto_ejecutar_mo',
			type : 'numeric'
		}, {
			name : 'fecha_costo_ini',
			type : 'date',
			dateFormat : 'Y-m-d'
		}, {
			name : 'fecha_costo_fin',
			type : 'date',
			dateFormat : 'Y-m-d'
		}, {
			name : 'fecha',
			type : 'date',
			dateFormat : 'Y-m-d'
		}],
		sortInfo : {
			field : 'id',
			direction : 'ASC'
		},
		bdel : false,
		bnew: false,
		bedit: false,
		fwidth : '90%',
		fheight : '80%'
	}); 
</script>
