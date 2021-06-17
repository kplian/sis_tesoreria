<?php
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
Phx.vista.agregarDocumentos = Ext.extend(Phx.frmInterfaz,{
	constructor:function(config)
	{	
		Phx.vista.agregarDocumentos.superclass.constructor.call(this,config);
		this.init(); 
        //this.loadValoresIniciales();
	},
	
	loadValoresIniciales:function(){    	
		Phx.vista.agregarDocumentos.superclass.loadValoresIniciales.call(this);
		//iniciar valroes de comprobantes seleccionados 
		this.Cmp.id_proceso_caja.setValue(this.id_proceso_caja);
        this.Cmp.id_caja.setValue(this.id_caja);
        this.Cmp.id_solicitud_rendicion_det.store.baseParams.id_caja = this.id_caja;
	},

	Atributos:[
		{
			//configuracion del componente
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'id_caja'
			},
			type : 'Field',
			form : true,
		},{
			//configuracion del componente
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'id_proceso_caja'
			},
			type : 'Field',
			form : true,
		},{
			config: {
				name: 'id_solicitud_rendicion_det',
                enableMultiSelect : true,
				fieldLabel: 'Nro Tramite',
				
				allowBlank: true,
				emptyText: 'Tramite...',
				store: new Ext.data.JsonStore({
					url: '../../sis_tesoreria/control/SolicitudRendicionDet/listarRendicion',
					id: 'id_solicitud_rendicion_det',
					root: 'datos',
					sortInfo: {
						field: 'nro_tramite',
						direction: 'ASC'
					},					
					fields: ['id_solicitud_rendicion_det', 'nro_tramite','nro_documento','desc_plantilla', 'razon_social','monto','fecha'],
					totalProperty: 'total',						
					remoteSort: true,
				}),
				tpl : new Ext.XTemplate('<tpl for="."><div class="awesomecombo-5item {checked}">', '<p>(ID: {nro_tramite}), Tpo: {desc_plantilla} </p>', '<p>Fecha: <strong>{fecha}</strong></p>', '<p>RS: {razon_social}</p>', '<p>Monto: {monto}</p>', '</div></tpl>'),
				itemSelector : 'div.awesomecombo-5item',
				valueField : 'id_solicitud_rendicion_det',
				displayField : 'nro_tramite',
				gdisplayField : 'nro_tramite',
				forceSelection : true,
				typeAhead : false,
				triggerAction : 'all',
				lazyRender : true,
				mode : 'remote',
				pageSize : 15,
				queryDelay : 1000,
				width : 250,
				anchor : '100%',
				listWidth : '320',
				gwidth : 150,
				minChars : 2,
				resizable : true,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['nro_tramite']);
				}
			},
			type: 'AwesomeCombo',
			id_grupo: 0,
			form: true
		},	
	],
	labelSubmit: '<i class="fa fa-check"></i> Guardar',
	title: 'Documentos',
	// Funcion guardar del formulario
	onSubmit: function(o) {
		var me = this;
		if (me.form.getForm().isValid()) {
			var parametros = me.getValForm();
            console.log('==',parametros);
			Phx.CP.loadingShow();
			Ext.Ajax.request({
				url : '../../sis_tesoreria/control/SolicitudRendicionDet/insertarDocumentos',
				params : parametros,
				success : this.successGen,
				failure : this.conexionFailure,
				timeout : this.timeout,
				scope : this
			});
		}
	},
	
	successGen: function(resp){
		Phx.CP.loadingHide();
		Phx.CP.getPagina(this.idContenedorPadre).reload();
		this.panel.close();
	},
    //

})
</script>