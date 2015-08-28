<?php
/**
*@package pXP
*@file    SolModPresupuesto.php
*@author  Rensi Arteaga Copari 
*@date    30-01-2014
*@description permites subir archivos a la tabla de documento_sol
*/
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
Phx.vista.RepFilPlanPago=Ext.extend(Phx.frmInterfaz,{
	constructor:function(config)
    {   
    	this.panelResumen = new Ext.Panel({html:''});
    	/*this.Grupos = [{

	                    xtype: 'fieldset',
	                    border: false,
	                    autoScroll: true,
	                    layout: 'form',
	                    items: [],
	                    id_grupo: 0
				               
				    },
				     this.panelResumen
				    ];*/
				    
        Phx.vista.RepFilPlanPago.superclass.constructor.call(this,config);
        this.init();   
       
        //si tenemos datos de maestro cargamos el filtro con valroes por defecto
        if(config.id_obligacion_pago > 0){
        	this.cargarDatosFiltro(config.id_obligacion_pago);
        }
    },
    
    cargarDatosFiltro: function(id_obligacion_pago){
    	Phx.CP.loadingShow();	
		Ext.Ajax.request({
				url:'../../sis_tesoreria/control/ObligacionPago/recuperarDatosFiltro',
				success: this.successAplicarFiltro,
				failure: this.conexionFailure,
				params: {'id_obligacion_pago' :id_obligacion_pago},
				timeout: this.timeout,
				scope: this
		});
    	
    },
    successAplicarFiltro: function(resp){
    	    Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(reg.ROOT.datos.resultado!='falla'){
                
                 //cargar datos en el filtro
                 console.log(reg.ROOT);
                 
                 this.Cmp.id_proveedors.setValue(reg.ROOT.datos.id_proveedor);
                 this.Cmp.id_concepto_ingas.setValue(reg.ROOT.datos.id_concepto_ingas);
                 this.Cmp.id_orden_trabajos.setValue(reg.ROOT.datos.id_orden_trabajos);
                 this.Cmp.nro_tramite.setValue(reg.ROOT.datos.num_tramite);
                 var me = this;
                 Phx.CP.loadingShow();	
                 setTimeout(function () {
                 	  Phx.CP.loadingHide();
                 	  me.onSubmit()
                 	}, 500);
                 
             }else{
                alert(reg.ROOT.datos.mensaje)
            }
    },
    
    Atributos:[
         {
			config:{
				name: 'id_proveedors',
				fieldLabel: 'Proveedor',
				allowBlank: true,
				emptyText: 'Proveedor ...',
				store: new Ext.data.JsonStore({
							url: '../../sis_parametros/control/Proveedor/listarProveedorCombos',
	    					id: 'id_proveedor',
	    					root: 'datos',
	    					sortInfo:{
	    						field: 'desc_proveedor',
	    						direction: 'ASC'
	    					},
	    					totalProperty: 'total',
	    					fields: ['id_proveedor','codigo','desc_proveedor'],
	    					// turn on remote sorting
	    					remoteSort: true,
	    					baseParams:{par_filtro:'codigo#desc_proveedor'}
	    				}),
        	    valueField: 'id_proveedor',
        	    displayField: 'desc_proveedor',
        	    gdisplayField: 'desc_proveedor',
        	    hiddenName: 'id_proveedor',
        	    triggerAction: 'all',
        	    pageSize:10,
				forceSelection: true,
				typeAhead: true,
				listWidth:'280',
				width: 150,
				mode: 'remote'
			},
	           			
			type:'ComboBox',
			id_grupo:1,
			form:true
		},   
        {
            config:{
			 origen: 'OT',
			 tinit:false,
			 tasignacion:true,
			 resizable:true,
			 name: 'id_orden_trabajos',
             fieldLabel: 'Orden Trabajo',
             allowBlank: true,
             emptyText : 'OT...',
             store : new Ext.data.JsonStore({
                            url:'../../sis_contabilidad/control/OrdenTrabajo/listarOrdenTrabajo',
                            id : 'id_orden_trabajo',
                            root: 'datos',
                            sortInfo:{
                                    field: 'motivo_orden',
                                    direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_orden_trabajo','motivo_orden','desc_orden','motivo_orden'],
                            remoteSort: true,
                            baseParams:{par_filtro:'desc_orden#motivo_orden'}
                }),
               valueField: 'id_orden_trabajo',
               displayField: 'desc_orden',
               hiddenName: 'id_orden_trabajo',
               forceSelection:true,
               typeAhead: false,
               triggerAction: 'all',
               listWidth:350,
               lazyRender:true,
               mode:'remote',
               pageSize:10,
               queryDelay:1000,
               width: 150,
               listWidth:'280',
               gwidth:350,
               minChars:2,
	       	   enableMultiSelect: true
            },
            type: 'AwesomeCombo',
            id_grupo: 0,
            form: true
        },
		
        {
            config:{
                name: 'id_concepto_ingas',
                fieldLabel: 'Concepto',
                allowBlank: true,
                emptyText : 'Concepto...',
                store : new Ext.data.JsonStore({
                            url:'../../sis_parametros/control/ConceptoIngas/listarConceptoIngas',
                            id : 'id_concepto_ingas',
                            root: 'datos',
                            sortInfo:{
                                    field: 'desc_ingas',
                                    direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_concepto_ingas','tipo','desc_ingas','movimiento','desc_partida','id_grupo_ots','filtro_ot','requiere_ot'],
                            remoteSort: true,
                            baseParams:{par_filtro:'desc_ingas',movimiento:'gasto'}
                }),
                valueField: 'id_concepto_ingas',
               displayField: 'desc_ingas',
               gdisplayField: 'desc_concepto_ingas',
               hiddenName: 'id_concepto_ingas',
               forceSelection:true,
               typeAhead: false,
               triggerAction: 'all',
                listWidth:500,
               resizable:true,
               lazyRender:true,
               mode:'remote',
               pageSize:10,
               queryDelay:1000,
               width: 150,
               gwidth:200,
               minChars:2,
	       	   enableMultiSelect:true
            },
            type:'AwesomeCombo',
            id_grupo:1,
            form:true
        },
        {
			config: {
				name: 'nro_tramite',
				allowBlank: true,
				fieldLabel: 'Nro. Trámite',
				width: 150
			},
			type: 'Field',
			id_grupo: 0,
			form: true
		}

    ],
    labelSubmit: '<i class="fa fa-check"></i> Aplicar Filtro',
    east: {
          url: '../../../sis_tesoreria/vista/plan_pago/RepPlanPago.php',
          title: undefined, 
          width: '73%',
          cls: 'RepPlanPago'
         },
    title: 'Filtro de mayores',
    // Funcion guardar del formulario
    onSubmit: function(o) {
    	var me = this;
    	if (me.form.getForm().isValid()) {

             var parametros = me.getValForm()
             
             console.log('parametros ....', parametros);
             
             this.onEnablePanel(this.idContenedor + '-east', parametros)
                    
        }

    }
    
})    
</script>