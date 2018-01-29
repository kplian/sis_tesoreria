<?php
/**
*@package pXP
*@file PlanPagoDocCompra.php
*@author  RCM
*@date 25-01-2018
*@description Archivo con la interfaz de usuario que permite registrar facturas y recibos
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PlanPagoDocCompra = {
    
	require: '../../../sis_contabilidad/vista/doc_compra_venta/DocCompraVenta.php',
    ActList:'../../sis_tesoreria/control/PlanPagoDocCompra/listarPlanPagoDocCompra',
    ActSave:'../../sis_tesoreria/control/PlanPagoDocCompra/insertarPlanPagoDocCompra',
    ActDel:'../../sis_tesoreria/control/PlanPagoDocCompra/eliminarDocCompraVenta',
	requireclase: 'Phx.vista.DocCompraVenta',
	title: 'Libro de Compras',
	nombreVista: 'PlanPagoDocCompra',
	tipoDoc: 'compra',
	
	formTitulo: 'Facturas/Recibos',
	regitrarDetalle: 'no',
	
	constructor: function(config) {
		
	    Phx.vista.PlanPagoDocCompra.superclass.constructor.call(this,config);
	    this.regitrarDetalle='no';
	    
	    this.Atributos.push({
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_plan_pago_doc_compra'
			},
			type:'Field',
			form:true 
		},);
		
		this.Atributos.push({
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_plan_pago'
			},
			type:'Field',
			form:true 
		});
	   

        this.cmbDepto.setVisible(false);
        this.cmbGestion.setVisible(false);
        this.cmbPeriodo.setVisible(false);
        this.getBoton('btnWizard').setVisible(false);
        this.getBoton('btnImprimir').setVisible(false);
        this.getBoton('btnExpTxt').setVisible(false);
        //this.Cmp.id_plantilla.store.baseParams = Ext.apply(this.Cmp.id_plantilla.store.baseParams, {tipo_plantilla:this.tipoDoc});

        this.init();
		this.grid.getTopToolbar().disable();
        this.grid.getBottomToolbar().disable();

        var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
        if(dataPadre){
            this.onEnablePanel(this, dataPadre);
        } else {
           this.bloquearMenus();
        }


    },
   
    
    loadValoresIniciales: function() {
    	Phx.vista.PlanPagoDocCompra.superclass.loadValoresIniciales.call(this);
        //this.Cmp.tipo.setValue(this.tipoDoc); 
        
   },
   capturaFiltros:function(combo, record, index){
        this.store.baseParams.tipo = this.tipoDoc;
        Phx.vista.PlanPagoDocCompra.superclass.capturaFiltros.call(this,combo, record, index);
   },
   
    cmbDepto: new Ext.form.ComboBox({
                name: 'id_depto',
                fieldLabel: 'Depto',
                blankText: 'Depto',
                typeAhead: false,
                forceSelection: true,
                allowBlank: false,
                disableSearchButton: true,
                emptyText: 'Depto Contable',
                store: new Ext.data.JsonStore({
                    url: '../../sis_parametros/control/Depto/listarDeptoFiltradoXUsuario',
                    id: 'id_depto',
					root: 'datos',
					sortInfo:{
						field: 'deppto.nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_depto','nombre','codigo'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: { par_filtro:'deppto.nombre#deppto.codigo', estado:'activo', codigo_subsistema: 'CONTA'}
                }),
                valueField: 'id_depto',
   				displayField: 'nombre',
   				hiddenName: 'id_depto',
                enableMultiSelect: true,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 20,
                queryDelay: 200,
                anchor: '80%',
                listWidth:'280',
                resizable:true,
                minChars: 2
            }),
    

   onReloadPage: function(m) {
        //var me = this;
        this.maestro = m;
        this.Atributos[this.getIndAtributo('id_plan_pago')].valorInicial = this.maestro.id_plan_pago;
        this.regitrarDetalle='no';
        this.id_plantilla = this.maestro.id_plantilla;

        //Filtro para los datos
        this.store.baseParams = {
            id_plan_pago: this.maestro.id_plan_pago
        };
        this.load({
            params: {
                start: 0,
                limit: 50
            }
        });

        
    },

	validarFiltros: function(){
    	return true;
    },   

    preparaMenu:function(tb){
    	Phx.vista.PlanPagoDocCompra.superclass.preparaMenu.call(this,tb)
    },
   
	abrirFormulario: function(tipo, record){
		var me = this;

		me.objSolForm = Phx.CP.loadWindows('../../../sis_contabilidad/vista/doc_compra_venta/FormCompraVentaCustom.php',
            me.formTitulo,
            {
                modal:true,
                width:'90%',
				height:(me.regitrarDetalle == 'si')? '100%':'60%',
            }, { data: { 
                	 objPadre: me ,
                	 tipoDoc: me.tipoDoc,	                                	 
                	 id_gestion: this.maestro.id_gestion,
                	 id_periodo: this.maestro.id_periodo,
                	 id_depto: this.maestro.id_depto_conta,
                	 tmpPeriodo: me.tmpPeriodo,
                     tmpGestion: me.tmpGestion,
                	 tipo_form : tipo,
                	 datosOriginales: record,
                	 id_plantilla: this.id_plantilla,
                     extraSubmitCampo: 'id_plan_pago',
                     extraSubmitValor: this.maestro.id_plan_pago
                },
                regitrarDetalle: 'no'
            }, 
            this.idContenedor,
            'FormCompraVentaCustom',
            {
                config:[{
                          event:'successsave',
                          delegate: this.onSaveForm,
                          
                        }],
                
                scope:this
             });  
	}
};
</script>
