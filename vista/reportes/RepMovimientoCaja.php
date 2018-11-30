<?php
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Ext.define('Phx.vista.RepMovimientoCaja', {
	extend: 'Ext.util.Observable',
	constructor: function(config){
		Ext.apply(this,config);
		this.callParent(arguments);
		this.panel = Ext.getCmp(this.idContenedor);
		this.createComponents();
		this.definirEventos();
		this.layout();
		this.render();
	},
	createComponents: function(){
		this.dteFechaDesde = new Ext.form.DateField({
			id: this.idContenedor+'_dteFechaDesde',
			fieldLabel: 'Desde',
			vtype: 'daterange',
			endDateField: this.idContenedor+'_dteFechaHasta',
			style: this.setBackgroundColor('dteFechaDesde')
		});
		this.dteFechaHasta = new Ext.form.DateField({
			id: this.idContenedor+'_dteFechaHasta',
			fieldLabel: 'Hasta',
			vtype: 'daterange',
			startDateField: this.idContenedor+'_dteFechaDesde',
			style: this.setBackgroundColor('dteFechaHasta')
		});

		this.cmbCaja = new Ext.form.AwesomeCombo({
				fieldLabel: 'Caja',
				anchor: '100%',
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_tesoreria/control/Caja/ListarCaja',
					id: 'id_caja',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_caja', 'codigo'],
					remoteSort: true,
					baseParams: {
						par_filtro: 'codigo',
						tipo_interfaz: 'caja'
					}
				}),
				valueField: 'id_caja',
				displayField: 'codigo',
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				minChars: 2,
				enableMultiSelect:true
		});

		this.radTipoMovimiento = new Ext.form.RadioGroup({
			fieldLabel: 'Tipo',
			items: [
				{boxLabel: 'Sólo Ingresos', name: 'rb-auto1', inputValue: 'ing'},
                {boxLabel: 'Sólo Egresos', name: 'rb-auto1', inputValue: 'sal'},
                {boxLabel: 'Ambos', name: 'rb-auto1', inputValue: 'ambos', checked: true}
            ]
		});

	},
	layout: function(){
		//Fieldsets
		this.fieldSetGeneral = new Ext.form.FieldSet({
        	collapsible: true,
        	title: 'General',
        	items: [this.dteFechaDesde,this.dteFechaHasta,this.cmbCaja,this.radTipoMovimiento]
        });

		//Formulario
		this.formParam = new Ext.form.FormPanel({
            layout: 'form',
            autoScroll: true,
            items: [this.fieldSetGeneral],
            tbar: [
                {xtype:'button', text:'<i class="fa fa-print" aria-hidden="true"></i> Generar', tooltip: 'Generar el reporte', handler: this.onSubmit, scope: this},
                {xtype:'button', text:'<i class="fa fa-undo" aria-hidden="true"></i> Reset', tooltip: 'Resetear los parámetros', handler: this.onReset, scope: this}
            ]
        });

		//Contenedor
		this.viewPort = new Ext.Container({
            layout: 'border',
            width: '80%',
            autoScroll: true,
            items: [{
            	region: 'west',
            	collapsible: true,
            	width: '70%',
            	split: true,
            	title: 'Parámetros',
            	items: this.formParam
            },{
            	xtype: 'panel',
            	region: 'center',
            	id: this.idContenedor+'_centerPanelCaja'
            }]
        });
	},
	render: function(){
		this.panel.add(this.viewPort);
        this.panel.doLayout();
        this.addEvents('init'); 
	},
	onReset: function(){
		this.dteFechaDesde.setValue('');
		this.dteFechaHasta.setValue('');
		this.cmbCaja.setValue('');
		this.radTipoMovimiento.setValue('ambos');
	},
	onSubmit: function(){
		if(this.formParam.getForm().isValid()){
			console.log('onSubmit')
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url: '../../sis_tesoreria/control/Caja/reporteMovimientoCaja',
                params: {
                    desde: this.dteFechaDesde.getValue(),
                    hasta: this.dteFechaHasta.getValue(),
                    id_caja: this.cmbCaja.getValue(),
                    tipo_movimiento: this.radTipoMovimiento.getValue().inputValue
                },
                success: this.successExport,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });
		}
	},
	getParams: function(){
		//Fechas
		var _fecha_desde,
			_fecha_hasta;

		if(this.dteFechaDesde.getValue()) _fecha_desde = this.dteFechaDesde.getValue().dateFormat('Y-m-d');
		if(this.dteFechaHasta.getValue()) _fecha_hasta = this.dteFechaHasta.getValue().dateFormat('Y-m-d');

		//Parametros
		var params = {
			fecha_desde: _fecha_desde,
			fecha_hasta: _fecha_hasta,
			id_caja: this.cmbCaja.getValue(),
			tipo_movimiento: this.radTipoMovimiento.getValue().inputValue
		};

		Ext.apply(params,this.getExtraParams());

		return params;
	},

	definirParametros: function(){

	},
	definirEventos: function(){

	},
	inicializarParametros: function(){
		this.configElement(this.dteFechaDesde,false,true);
		this.configElement(this.dteFechaHasta,false,true);
		this.configElement(this.cmbCaja,false,true);
		this.configElement(this.radTipoMovimiento,false,true);
	},
	configElement: function(elm,disable,allowBlank){
		elm.setVisible(disable);
		elm.allowBlank = allowBlank;
	},
	successExport: function(resp){
    	//Método para abrir el archivo generado
    	Phx.CP.loadingHide();
        var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
        var nomRep = objRes.ROOT.detalle.archivo_generado;
        if(Phx.CP.config_ini.x==1){  			
        	nomRep = Phx.CP.CRIPT.Encriptar(nomRep);
        }
        window.open('../../../lib/lib_control/Intermediario.php?r='+nomRep+'&t='+new Date().toLocaleTimeString())
    },
    setBackgroundColor: function(elm){
    	return String.format('background-color: {0}; background-image: none;', this.setPersonalBackgroundColor(elm));
    },
    setPersonalBackgroundColor: function(elm){
    	//Para sobreescribir
    	return '#FFF';
    }
});
</script>