<?php
/**
 *@package pXP
 *@file    GenerarReporteExistencias.php
 *@author  Ariel Ayaviri Omonte
 *@date    02-05-2013
 *@description Archivo con la interfaz para generación de reporte
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
	Phx.vista.WizardProrrateo = Ext.extend(Phx.frmInterfaz, {
		Atributos : [
		{
			config: {
				name: 'id_tipo_prorrateo',
				fieldLabel: 'Tipo Prorrateo',
				typeAhead: false,
				forceSelection: false,
				hiddenName: 'id_tipo_prorrateo',
				allowBlank: false,
				emptyText: 'Lista de Tipos...',
				store: new Ext.data.JsonStore({
					url: '../../sis_tesoreria/control/TipoProrrateo/listarTipoProrrateo',
					id: 'id_tipo_prorrateo',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_tipo_prorrateo', 'nombre', 'codigo', 'tiene_cuenta','tiene_lugar'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: {par_filtro: 'tipo.nombre#tipo.codigo'}
				}),
				valueField: 'id_tipo_prorrateo',
				displayField: 'nombre',
				gdisplayField: 'nombre',
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 200,
				listWidth:280,
				anchor:'50%', 
				minChars: 2,
				gwidth: 120,
				tpl: '<tpl for="."><div class="x-combo-list-item"><p>{codigo}</p><strong>{nombre}</strong> </div></tpl>'
			},
			type: 'ComboBox',
			id_grupo: 0,			
			form: true
		},
		
		{
	   			config:{
	   				name : 'id_gestion',
	   				origen : 'GESTION',
	   				fieldLabel : 'Gestion',
	   				allowBlank : false,
	   				gdisplayField : 'gestion',//mapea al store del grid
	   				gwidth : 100,
		   			renderer : function (value, p, record){return String.format('{0}', record.data['gestion']);}
	       	     },
	   			type : 'ComboRec',
	   			id_grupo : 0,
	   			filters : {	
			        pfiltro : 'ges.gestion',
					type : 'numeric'
				},
	   		   
	   			grid : true,
	   			form : true
	   	},
		{
	   			config:{
	   				name : 'id_periodo',
	   				origen : 'PERIODO',
	   				fieldLabel : 'Periodo',
	   				allowBlank : true,
	   				gdisplayField : 'periodo',//mapea al store del grid
	   				gwidth : 100,
	   				disabled:true,
		   			renderer : function (value, p, record){return String.format('{0}', record.data['periodo']);}
	       	     },
	   			type : 'ComboRec',
	   			id_grupo : 0,
	   			filters : {	
			        pfiltro : 'per.periodo',
					type : 'numeric'
				},
	   		   
	   			grid : true,
	   			form : true
	   	},
		{
            config:{
                name:'id_concepto_ingas',
                fieldLabel:'Concepto Ingreso Gasto',
                allowBlank:true,
                emptyText:'Concepto Ingreso Gasto...',
                store: new Ext.data.JsonStore({
                         url: '../../sis_parametros/control/ConceptoIngas/listarConceptoIngasMasPartida',
                         id: 'id_concepto_ingas',
                         root: 'datos',
                         sortInfo:{
                            field: 'desc_ingas',
                            direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_concepto_ingas','tipo','desc_ingas','movimiento','desc_partida'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams:{par_filtro:'desc_ingas#par.codigo#par.nombre_partida',movimiento:'gasto'}
                    }),
                valueField: 'id_concepto_ingas',
                displayField: 'desc_ingas',
                gdisplayField:'nombre_ingas',
                tpl:'<tpl for="."><div class="x-combo-list-item"><p>{desc_ingas}</p><p>TIPO:{tipo}</p><p>MOVIMIENTO:{movimiento}</p> <p>PARTIDA:{desc_partida}</p></div></tpl>',
                hiddenName: 'id_concepto_ingas',
                forceSelection:true,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:10,
                queryDelay:1000,
                 listWidth:350,
                resizable:true,
                anchor:'50%', 
                gwidth: 200,      
                renderer:function(value, p, record){return String.format('{0}', record.data['nombre_ingas']);}
            },
            type:'ComboBox',
            id_grupo:0,
            filters:{   
                        pfiltro:'cig.movimiento#cig.desc_ingas',
                        type:'string'
                    },
            grid:true,
            form:true
        },
		{
			config:{
				name: 'monto',
				currencyChar:' ',
				fieldLabel: 'Monto Factura',
				allowBlank: false,
				anchor: '35%',
				gwidth: 100,
				maxLength:1245184
			},
			type:'MoneyField',			
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config: {
				name: 'id_oficina_cuenta',
				fieldLabel: 'Cuenta',
				typeAhead: false,
				forceSelection: false,
				hiddenName: 'id_oficina_cuenta',
				allowBlank: true,
				emptyText: 'Cuenta...',
				store: new Ext.data.JsonStore({
					url: '../../sis_organigrama/control/OficinaCuenta/listarOficinaCuenta',
					id: 'id_oficina_cuenta',
					root: 'datos',
					sortInfo: {
						field: 'nro_cuenta',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_oficina_cuenta', 'nombre_cuenta','nro_cuenta', 'nro_medidor','oficina','lugar'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: {par_filtro: 'ofcu.nro_cuenta#ofcu.nombre_cuenta#ofcu.nro_medidor#of.nombre#lug.nombre'}
				}),
				valueField: 'id_oficina_cuenta',
				displayField: 'nombre_cuenta',
				gdisplayField: 'nombre_cuenta',
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 200,
				listWidth:280,
				anchor:'50%', 
				disabled:true,
				minChars: 2,
				gwidth: 120,
				tpl: '<tpl for="."><div class="x-combo-list-item"><p>No Cuenta : <b>{nro_cuenta}</b></p><p><b>{nombre_cuenta}</b></p><p>No Medidor : <b>{nro_medidor}</b></p> <p>Oficina : <b>{oficina}</b></p><p>Lugar : <b>{lugar}</b></p></div></tpl>'
			},
			type: 'ComboBox',
			id_grupo: 0,			
			form: true
		},
		{
			config:{
				name: 'id_lugar',
				fieldLabel: 'Lugar',
				allowBlank: true,
				emptyText:'Lugar...',
				store:new Ext.data.JsonStore(
				{
					url: '../../sis_parametros/control/Lugar/listarLugar',
					id: 'id_lugar',
					root: 'datos',
					sortInfo:{
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_lugar','id_lugar_fk','codigo','nombre','tipo','sw_municipio','sw_impuesto','codigo_largo'],
					// turn on remote sorting
					remoteSort: true,
					baseParams:{par_filtro:'lug.nombre',tipos:"''departamento'',''pais''"}
				}),
				valueField: 'id_lugar',
				displayField: 'nombre',
				gdisplayField:'nombre_lugar',
				hiddenName: 'id_lugar',
    			triggerAction: 'all',
    			lazyRender:true,
				mode:'remote',
				pageSize:50,
				queryDelay:500,
				anchor:"50%",
				gwidth:150,
				minChars:2,
				disabled:true,
				renderer:function (value, p, record){return String.format('{0}', record.data['nombre_lugar']);}
			},
			type:'ComboBox',
			filters:{pfiltro:'lug.nombre',type:'string'},
			id_grupo:0,
			grid:true,
			form:true
		},		
			],
		title : 'Wizard de Prorrateo',
		ActSave : '../../sis_tesoreria/control/TipoProrrateo/ejecutarTipoProrrateo',
		topBar : true,
		botones : false,
		labelSubmit : 'Generar Prorrateo',
		tooltipSubmit : '<b>Ejecutar Prorrateo</b>',

		constructor : function(config) {
			Phx.vista.WizardProrrateo.superclass.constructor.call(this, config);
			this.config = config;
			this.init();	
			
			this.iniciarEventosFormulario();		
		},
		
		loadValoresIniciales : function() {
			Phx.vista.WizardProrrateo.superclass.loadValoresIniciales.call(this, config);
			this.Cmp.id_oficina_cuenta.setDisabled(true);
			this.Cmp.id_oficina_cuenta.allowBlank = true;
			this.Cmp.id_lugar.setDisabled(true);
			this.Cmp.id_lugar.allowBlank = true;			
		},
				
		iniciarEventosFormulario : function () {
			this.Cmp.id_tipo_prorrateo.on('select', function (i,r,c) {
				if (r.data.tiene_cuenta == 'si') {
					this.Cmp.id_oficina_cuenta.setDisabled(false);
					this.Cmp.id_oficina_cuenta.allowBlank = false;
				} else {
					this.Cmp.id_oficina_cuenta.setDisabled(true);
					this.Cmp.id_oficina_cuenta.allowBlank = true;
				}
				
				if (r.data.tiene_lugar == 'si') {
					this.Cmp.id_lugar.setDisabled(false);
					this.Cmp.id_lugar.allowBlank = false;
				} else {
					this.Cmp.id_lugar.setDisabled(true);
					this.Cmp.id_lugar.allowBlank = true;
				}
				
				
			}, this);
			
			this.Cmp.id_gestion.on('select',function(c,r,i){
				this.Cmp.id_periodo.enable();
				this.Cmp.id_periodo.reset();
				this.Cmp.id_periodo.store.baseParams.id_gestion = r.data.id_gestion;
			},this);
		},
		agregarArgsExtraSubmit: function(){
			//Inicializa el objeto de los argumentos extra
			this.argumentExtraSubmit={
				id_valor : this.config.id_valor,
				nombre_id : this.config.nombre_id,
				nombre_monto : this.config.nombre_monto,
				nombre_monto_mb : this.config.nombre_monto_mb,
				nombre_tabla : this.config.nombre_tabla,				
				tiene_tipo_cambio : this.config.tiene_tipo_cambio,
				tipo_cambio : this.config.tipo_cambio,
			};				
		},
		
		successSave:function(resp){
			
			Phx.CP.loadingHide();
			var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
	        var menProrrateo=objRes.ROOT.datos.mensaje_prorrateo;
	        if (menProrrateo != 'exito') {
				Ext.Msg.alert('Información',"Proceso Generado <br><br>" + menProrrateo);
			} else {
				Ext.Msg.alert('Información',this.mensajeExito);
			}
			
		},

})
</script>