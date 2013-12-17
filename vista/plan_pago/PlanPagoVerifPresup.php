<?php
/**
 *@package   pXP
 *@file      PlanPagoVerifPresup.php
 *@author    RCM
 *@date      15/12/2013
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
	Phx.vista.PlanPagoVerifPresup = Ext.extend(Phx.gridInterfaz, {
		
		constructor: function(config) {
			this.maestro = config.maestro;
			Phx.vista.PlanPagoVerifPresup.superclass.constructor.call(this, config);
			this.init();
			this.load({
				params : {
					start : 0,
					limit : 50,
					id_plan_pago: this.id_plan_pago
				}
			});
			this.Atributos[1].valorInicial = this.id_plan_pago;
		},
		Atributos : [{
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'id_partida'
			},
			type : 'Field',
			form : true
		}, {
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'id_presupuesto'
			},
			type : 'Field',
			form : true
		},{
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'id_moneda'
			},
			type : 'Field',
			form : true
		},{
			config : {
				name : 'disponibilidad',
				fieldLabel : 'Disponibilidad Presup.',
				allowBlank : true,
				anchor : '80%',
				gwidth : 130,
				maxLength : 10
			},
			type : 'TextField',
			filters : {
				pfiltro : 'disponibilidad',
				type : 'string'
			},
			id_grupo : 1,
			grid : true,
			form : false
		},
		 {
			config : {
				name : 'desc_partida',
				fieldLabel : 'Partida',
				allowBlank : true,
				anchor : '80%',
				gwidth : 200,
				maxLength : 10
			},
			type : 'TextField',
			filters : {
				pfiltro : 'desc_partida',
				type : 'string'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'desc_cc',
				fieldLabel : 'Presupuesto',
				allowBlank : true,
				anchor : '80%',
				gwidth : 200,
				maxLength : 10
			},
			type : 'TextField',
			filters : {
				pfiltro : 'desc_cc',
				type : 'string'
			},
			id_grupo : 1,
			grid : true,
			form : false
		},{
			config : {
				name : 'importe',
				fieldLabel : 'Importe',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				maxLength : 10
			},
			type : 'TextField',
			filters : {
				pfiltro : 'importe',
				type : 'string'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}],
		title : 'Verificación presupuestaria',
		ActList : '../../sis_tesoreria/control/PlanPago/verificarDisponibilidad',
		fields : [{
			name : 'id_partida',
			type : 'numeric'
		}, {
			name : 'id_presupuesto',
			type : 'numeric'
		}, {
			name : 'id_moneda',
			type : 'numeric'
		}, {
			name : 'importe',
			type : 'numeric'
		}, {
			name : 'disponibilidad',
			type : 'string'
		}, {
			name : 'desc_partida',
			type : 'string'
		}, {
			name : 'desc_cc',
			type : 'string'
		}],
		sortInfo : {
			field : 'desc_partida',
			direction : 'ASC'
		},
		bdel : false,
		bsave : false,
		bnew: false,
		bedit:false
	}); 
</script>