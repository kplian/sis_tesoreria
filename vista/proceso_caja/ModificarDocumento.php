<!--
*	ISSUE   FORK	     Fecha 		     Autor		        Descripcion
*  #56     ENDETR       17/02/2020      Manuel Guerra      cambio de fechas(periodo) de un documento en la rendcion
-->
<?php
/**
*@package pXP
*@file    ModificarDocumento.php
*@author  Manuel Guerra
*@date    22-03-2012
*@description permites subir archivos a la tabla de documento_sol
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ModificarDocumento=Ext.extend(Phx.frmInterfaz,{
    constructor:function(config)
    {   
        Phx.vista.ModificarDocumento.superclass.constructor.call(this,config);
        this.init();    
        this.loadValoresIniciales();
    },
    
    loadValoresIniciales:function()
    {        
        Phx.vista.ModificarDocumento.superclass.loadValoresIniciales.call(this);        
        this.getComponente('id_doc_compra_venta').setValue(this.id_doc_compra_venta);
        this.getComponente('id_solicitud_rendicion_det').setValue(this.id_solicitud_rendicion_det);
        this.getComponente('fecha_original').setValue(this.fecha);
        this.getComponente('nro_documento').setValue(this.nro_documento);
    },

    Atributos:[
		{
			config:{
				labelSeparator:'',
				inputType:'hidden',
				name: 'id_solicitud_rendicion_det'
			},
			type:'Field',
			form:true
		}, {
			config:{
				labelSeparator:'',
				inputType:'hidden',
				name: 'id_doc_compra_venta',
			},
			type:'Field',
			form:true
		},{
			config:{
				name: 'nro_documento',
				fieldLabel: 'Nro Factura',
				allowBlank: false,
				disabled:true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextField',			
			grid:true,
		},{
			config : {
				name : 'fecha_original',
				fieldLabel : 'Fecha Original',
				allowBlank : false,
				disabled:true,
				anchor : '80%',
				gwidth : 100,
				format : 'd/m/Y',
				renderer : function(value, p, record) {
					return value ? value.dateFormat('d/m/Y') : ''
				}
			},
			type : 'DateField',			
			form : true
		}, {
			config : {
				name : 'fecha',
				fieldLabel : 'Fecha',
				allowBlank : false,
				anchor : '80%',
				gwidth : 100,
				format : 'd/m/Y',
				renderer : function(value, p, record) {
					return value ? value.dateFormat('d/m/Y') : ''
				}
			},
			type : 'DateField',			
			form : true
		}
    ],
    //
    onSubmit: function(o) {
        var me = this;
        if (me.form.getForm().isValid()) {
            var parametros = me.getValForm()
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url : '../../sis_tesoreria/control/SolicitudRendicionDet/ModificarDocumento',
                params : parametros,
                success : this.successGen,
                failure : this.conexionFailure,
                timeout : this.timeout,
                scope : this
            })
        }
    },

    successGen: function(resp){
        Phx.CP.loadingHide();
        Phx.CP.getPagina(this.idContenedorPadre).reload();
        this.panel.destroy();
    }
    
})
</script>
