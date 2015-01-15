<?php
/**
 *@package pXP
 *@file    GenerarLibroBancos.php
 *@author  Gonzalo Sarmiento Sejas
 *@date    01-12-2014
 *@description Archivo con la interfaz para generación de reporte
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
	Phx.vista.ReporteLibroBancos = Ext.extend(Phx.frmInterfaz, {
		
		Atributos : [
		{
            config:{
                name:'id_cuenta_bancaria',
                fieldLabel:'Cuenta Bancaria',
                allowBlank:true,
                emptyText:'Cuenta Bancaria...',
                store: new Ext.data.JsonStore({
                         url: '../../sis_tesoreria/control/CuentaBancaria/listarCuentaBancariaUsuario',
                         id: 'id_cuenta_bancaria',
                         root: 'datos',
                         sortInfo:{
                            field: 'nro_cuenta',
                            direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_cuenta_bancaria','nro_cuenta','denominacion','centro', 'nombre_institucion'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams:{par_filtro:'nro_cuenta#denominacion#centro', permiso:'todos'}
                    }),
                valueField: 'id_cuenta_bancaria',
                displayField: 'nro_cuenta',
                tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{nro_cuenta}</b></p><p>{denominacion}</p></div></tpl>',
                hiddenName: 'id_cuenta_bancaria',
                forceSelection:true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:10,
                queryDelay:1000,
                listWidth:600,
                resizable:true,
                anchor:'100%'
                
            },
            type:'ComboBox',
            id_grupo:0,
            filters:{   
                        pfiltro:'nro_cuenta#denominacion',
                        type:'string'
                    },
            grid:true,
            form:true
        },
		{
			config:{
				name: 'nro_cuenta',
				fieldLabel: 'Cuenta Bancaria',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100, 
				renderer:function (value,p,record){return value}
			},
			type:'Field',
			filters:{pfiltro:'nro_cuenta',type:'string'},
			id_grupo:1,
			form:true
		},
		{
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'nombre_banco'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'fecha_ini',
				fieldLabel: 'Fecha Inicio',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'fecha_ini',type:'date'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'fecha_fin',
				fieldLabel: 'Fecha Fin',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'fecha_fin',type:'date'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name:'tipo',
				fieldLabel:'Tipo',
				typeAhead: true,
				allowBlank:false,
	    		triggerAction: 'all',
	    		emptyText:'Tipo...',
	    		selectOnFocus:true,
				mode:'local',
				store:new Ext.data.ArrayStore({
	        	fields: ['ID', 'valor'],
	        	data :	[['Todos','Todos'],	
						['cheque','Cheque'],
						['deposito','Depósito'],
						['debito_automatico','Débito Automático'],
	        			['transferencia_carta','Transferencia con carta']]	        				
	    		}),
				valueField:'ID',
				displayField:'valor',
				width:250,			
				
			},
			type:'ComboBox',
			id_grupo:1,
			form:true
		},
		{
			config:{
				name:'estado',
				fieldLabel:'Estado',
				typeAhead: true,
				allowBlank:false,
	    		triggerAction: 'all',
	    		emptyText:'Estado...',
	    		selectOnFocus:true,
				mode:'local',
				store:new Ext.data.ArrayStore({
	        	fields: ['ID', 'valor'],
	        	data :	[['Todos','Todos'],	
						['impreso y entregado','En transito'],
						['borrador','Borrador'],
						['pendiente','Pendiente'],
	        			['impreso','Impreso'],
						['entregado','Entregado'],
						['cobrado','Cobrado'],
						['anulado','Anulado'],
						['reingresado','Reingresado'],
						['depositado','Depositado']]	        				
	    		}),
				valueField:'ID',
				displayField:'valor',
				width:250,			
				
			},
			type:'ComboBox',
			id_grupo:1,
			form:true
		},
		{
            config:{
                name:'id_finalidad',
                fieldLabel:'Finalidad',
                allowBlank:true,
                emptyText:'Finalidad...',
                store: new Ext.data.JsonStore({
                         url: '../../sis_tesoreria/control/Finalidad/listarFinalidadCuentaBancaria',
                         id: 'id_finalidad',
                         root: 'datos',
                         sortInfo:{
                            field: 'id_finalidad',
                            direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_finalidad','nombre_finalidad','color'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams:{par_filtro:'nombre_finalidad'}
                    }),
                valueField: 'id_finalidad',
                displayField: 'nombre_finalidad',
                //tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{nro_cuenta}</b></p><p>{denominacion}</p></div></tpl>',
                hiddenName: 'id_finalidad',
                forceSelection:true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:10,
                queryDelay:1000,
                listWidth:600,
                resizable:true,
                anchor:'100%'
                
            },
            type:'ComboBox',
            id_grupo:0,
            filters:{   
                        pfiltro:'nombre_finalidad',
                        type:'string'
                    },
            grid:true,
            form:true
        },
		{
			config:{
				name: 'finalidad',
				fieldLabel: 'Finalidad',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100, 
				renderer:function (value,p,record){return value}
			},
			type:'Field',
			filters:{pfiltro:'finalidad',type:'string'},
			id_grupo:1,
			form:true
		},
		{
			config:{
				name:'formato_reporte',
				fieldLabel:'Formato del Reporte',
				typeAhead: true,
				allowBlank:false,
	    		triggerAction: 'all',
	    		emptyText:'Formato...',
	    		selectOnFocus:true,
				mode:'local',
				store:new Ext.data.ArrayStore({
	        	fields: ['ID', 'valor'],
	        	data :	[['1','PDF'],	
						['2','Excel']]	        				
	    		}),
				valueField:'ID',
				displayField:'valor',
				width:250,			
				
			},
			type:'ComboBox',
			id_grupo:1,
			form:true
		}],
		title : 'Reporte Libro Bancos',		
		ActSave : '../../sis_migracion/control/TsLibroBancos/reporteLibroBancos',
		//ActSave : window.open('http://172.17.45.11/LibroBancos/Home/VerLibroBancosDeposito?'),
		topBar : true,
		botones : false,
		labelSubmit : 'Imprimir',
		tooltipSubmit : '<b>Generar Reporte Libro Bancos</b>',
		
		constructor : function(config) {
			Phx.vista.ReporteLibroBancos.superclass.constructor.call(this, config);
			this.init();			
			this.iniciarEventos();
		},
		
		iniciarEventos:function(){        
			this.cmpFormatoReporte = this.getComponente('formato_reporte');
			this.cmpFechaIni = this.getComponente('fecha_ini');
			this.cmpFechaFin = this.getComponente('fecha_fin');
			this.cmpIdCuentaBancaria = this.getComponente('id_cuenta_bancaria');
			this.cmpEstado = this.getComponente('estado');
			this.cmpTipo = this.getComponente('tipo');
			this.cmpNombreBanco = this.getComponente('nombre_banco');
			this.cmpNroCuenta = this.getComponente('nro_cuenta');
			
			this.getComponente('finalidad').hide(true);
			this.cmpNroCuenta.hide(true);
			this.getComponente('id_finalidad').on('change',function(c,r,n){
				this.getComponente('finalidad').setValue(c.lastSelectionText);
			},this);
			
			this.cmpIdCuentaBancaria.on('select',function(c,r,n){
				this.cmpNombreBanco.setValue(r.data.nombre_institucion);
				this.cmpNroCuenta.setValue(c.lastSelectionText);
				this.getComponente('id_finalidad').reset();
				this.getComponente('id_finalidad').store.baseParams={id_cuenta_bancaria:c.value, vista: 'reporte'};				
				this.getComponente('id_finalidad').modificado=true;
			},this);
		},
		
		onSubmit:function(o){
			if(this.cmpFormatoReporte.getValue()==2){
				var data = 'FechaIni=' + this.cmpFechaIni.getValue().format('d-m-Y');
				data = data + '&FechaFin=' + this.cmpFechaFin.getValue().format('d-m-Y');
				data = data + '&IdCuentaBancaria=' + this.cmpIdCuentaBancaria.getValue();
				data = data + '&Estado=' + this.cmpEstado.getValue();
				data = data + '&Tipo=' + this.cmpTipo.getValue();
				data = data + '&NombreBanco=' + this.cmpNombreBanco.getValue();
				data = data + '&NumeroCuenta=' + this.cmpNroCuenta.getValue();
				
				window.open('http://172.17.45.11/LibroBancos/Home/VerLibroBancos?'+data);
				//window.open('http://localhost:2309/Home/VerLibroBancos?'+data);				
			}else{
				Phx.vista.ReporteLibroBancos.superclass.onSubmit.call(this,o);				
			}
		},
		
		tipo : 'reporte',
		clsSubmit : 'bprint',
		
		Grupos : [{
			layout : 'column',
			items : [{
				xtype : 'fieldset',
				layout : 'form',
				border : true,
				title : 'Generar Reporte',
				bodyStyle : 'padding:0 10px 0;',
				columnWidth : '500px',
				items : [],
				id_grupo : 0,
				collapsible : true
			}]
		}]
})
</script>