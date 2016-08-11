<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (fprudencio)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite 
*dar el visto a solicitudes de compra
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ObligacionPagoVbPoa = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:true,
	require:'../../../sis_tesoreria/vista/obligacion_pago/ObligacionPago.php',
	requireclase:'Phx.vista.ObligacionPago',
	title:'Obligacion de Pago (POA)',
	nombreVista: 'ObligacionPagoVbPoa',
	/*
	 *  Interface heredada para el sistema de adquisiciones para que el reposnable 
	 *  de adqusiciones registro los planes de pago , y ase por los pasos configurados en el WF
	 *  de validacion, aprobacion y registro contable
	 * */
	
	constructor: function(config) {
	   
	   
	    //funcionalidad para listado de historicos
        this.historico = 'no';
        this.tbarItems = ['-',{
            text: 'Histórico',
            enableToggle: true,
            pressed: false,
            toggleHandler: function(btn, pressed) {
               
                if(pressed){
                    this.historico = 'si';
                     this.desBotoneshistorico();
                }
                else{
                   this.historico = 'no' 
                }
                
                this.store.baseParams.historico = this.historico;
                this.reload();
             },
            scope: this
           }];
           
           
	   Phx.vista.ObligacionPagoVbPoa.superclass.constructor.call(this,config);
       this.addButton('obs_poa',{text:'Datos. POA', disabled:true, handler: this.initObs, tooltip: '<b>Registro de datos del área de POA</b>'});
       this.crearFormObs();
        
        
       this.formEstado = new Ext.form.FormPanel({
            baseCls: 'x-plain',
            autoDestroy: true,
           
            border: false,
            layout: 'form',
            autoHeight: true,
            items: [
            
                {
					//configuracion del componente
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_estado_wf',
					xtype:'field'
					
				},
                
                {
                    name: 'obs',
                    xtype: 'textarea',
                    fieldLabel: 'Obs',
                    allowBlank: false,
                    grow: true,
                    growMin : '80%',
                    qtip: 'Por que esta retrocediendo?',
                    value:'',
                    anchor: '80%',
                    maxLength:500
                }]
        });
        
       
       this.wEstado = new Ext.Window({
            title: 'Estados',
            collapsible: true,
            maximizable: true,
             autoDestroy: true,
            width: 380,
            height: 290,
            layout: 'fit',
            plain: true,
            bodyStyle: 'padding:5px;',
            buttonAlign: 'center',
            items: this.formEstado,
            modal:true,
             closeAction: 'hide',
            buttons: [
             {
                    text: 'Guardar',
                    handler: this.antEstadoSubmmit,
                    scope:this,
                    argument: {estado: 'anterior'}
                    
             },
             {
                text: 'Guardar',
                handler:this.submitSigEstado,
                scope:this
                
             },
             {
                text: 'Cancelar',
                handler:function(){this.wEstado.hide()},
                scope:this
            }]
        });
        
        this.cmpObs=this.formEstado.getForm().findField('obs');
         
    },
    
    submitSigEstado:function(){
    	var d= this.sm.getSelected().data;
        Phx.CP.loadingShow();
        Ext.Ajax.request({
            // form:this.form.getForm().getEl(),
            url:'../../sis_tesoreria/control/ObligacionPago/finalizarRegistro',
            params:{id_obligacion_pago: d.id_obligacion_pago, operacion:'fin_registro', obs:this.cmpObs.getValue()}  ,
            success: function(r1,r2,r3){
            	this.wEstado.hide();
            	this.successSinc(r1,r2,r3)
            },
            failure: function(r1,r2,r3){
            	this.conexionFailure(r1,r2,r3);
            	var d= this.sm.getSelected().data;
            } ,
            timeout:this.timeout,
            scope:this
        });
    	
    },
    
    showObsEstado:function(){
    	this.wEstado.buttons[0].hide();
        this.wEstado.buttons[1].show();
       
        var d = this.sm.getSelected().data;
        
        this.cmpObs.setValue(d.obs_presupuestos);
    	this.wEstado.show();
    	
    },
    
     antEstado:function(res,eve) {  
    	
    	    this.wEstado.buttons[1].hide();
            this.wEstado.buttons[0].show();
            this.cmpObs.setValue('');
            this.wEstado.show();
           
               
     },
        
     antEstadoSubmmit:function(res,eve){                   
            var d= this.sm.getSelected().data;
            if(this.formEstado.getForm().isValid()){
		            Phx.CP.loadingShow();
		            var operacion = 'cambiar';
		            operacion = res.argument.estado == 'inicio'?'inicio':operacion; 
		            
		            Ext.Ajax.request({
		                url:'../../sis_tesoreria/control/ObligacionPago/anteriorEstadoObligacion',
		                params:{id_obligacion_pago:d.id_obligacion_pago, 
		                        operacion: operacion,
		                        obs:this.cmpObs.getValue()},
		                success:this.successSinc,
		                failure: this.conexionFailure,
		                timeout:this.timeout,
		                scope:this
		            }); 	
            }
                
      },    
   
    
     tabsouth:[
            { 
             url:'../../../sis_tesoreria/vista/obligacion_det/ObligacionDet.php',
             title:'Detalle', 
             height:'50%',
             cls:'ObligacionDet'
            },
            {
              //carga la interface de registro inicial  
              url:'../../../sis_tesoreria/vista/plan_pago/PlanPagoRegIni.php',
              title:'Plan de Pagos (Reg. Adq.)', 
              height:'50%',
              cls:'PlanPagoRegIni'
            }
    
       ],
       
       crearFormObs:function(){
		
		this.formObs = new Ext.form.FormPanel({
            baseCls: 'x-plain',
            autoDestroy: true,
            border: false,
            layout: 'form',
            autoHeight: true,
            items: [
                {
                    name: 'codigo_poa',
                    xtype: 'awesomecombo',
                    fieldLabel: 'Código POA',
                    allowBlank: false,
                    emptyText : 'Actividad...',
                    store : new Ext.data.JsonStore({
                        url : '../../sis_presupuestos/control/Objetivo/listarObjetivo',
                        id : 'codigo',
                        root : 'datos',
                        sortInfo : {
                            field : 'codigo',
                            direction : 'ASC'
                        },
                        totalProperty : 'total',
                        fields : ['codigo', 'descripcion','sw_transaccional','detalle_descripcion'],
                        remoteSort : true,
                        baseParams : {
                            par_filtro : 'obj.codigo#obj.descripcion'
                        }
                    }),
                    valueField : 'codigo',
                    displayField : 'detalle_descripcion',
                    forceSelection : true,
                    typeAhead : false,
                    triggerAction : 'all',
                    lazyRender : true,
                    mode : 'remote',
                    pageSize : 10,
                    queryDelay : 1000,
                    gwidth : 150,
                    minChars : 2,
                    enableMultiSelect:true
                },
                 
                 {
                    name: 'obs_poa',
                    xtype: 'textarea',
                    fieldLabel: 'Obs POA',
                    allowBlank: true,
                    grow: true,
                    growMin : '80%',
                    value:'',
                    anchor: '80%',
                    maxLength:500
                }]
        });
        
        
         this.wObs = new Ext.Window({
            title: 'Obs de Presupuestos ... ',
            collapsible: true,
            maximizable: true,
            autoDestroy: true,
            width: 380,
            height: 290,
            layout: 'fit',
            plain: true,
            bodyStyle: 'padding:5px;',
            buttonAlign: 'center',
            items: this.formObs,
            modal:true,
            closeAction: 'hide',
            buttons: [{
                    text: 'Guardar',
                    handler: this.submitObsPoa,
                    scope: this
                    
             },
             {
                text: 'Cancelar',
                handler:function(){this.wObs.hide()},
                scope:this
            }]
        });
        
        this.cmbObsPoa = this.formObs.getForm().findField('obs_poa');
        this.cmbCodigoPoa = this.formObs.getForm().findField('codigo_poa');
	},
	
	initObs:function(){
		var d= this.sm.getSelected().data;
        this.cmbCodigoPoa.setValue(d.codigo_poa);
        this.cmbCodigoPoa.store.baseParams.id_gestion = d.id_gestion;
        this.cmbCodigoPoa.store.baseParams.sw_transaccional = 'movimiento';
        this.cmbObsPoa.setValue(d.obs_poa);
		this.wObs.show()
	},
	
	submitObsPoa:function(){
		    Phx.CP.loadingShow();
		    var d= this.sm.getSelected().data;
            Ext.Ajax.request({
                url: '../../sis_tesoreria/control/ObligacionPago/modificarObsPoa',
                params: {
                    id_obligacion_pago: d.id_obligacion_pago,
                    obs_poa: this.cmbObsPoa.getValue(),
                    codigo_poa: this.cmbCodigoPoa.getValue()
                    },
                success: function(resp){
                           Phx.CP.loadingHide();
			               var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
			               if(!reg.ROOT.error){
			            	  this.reload();
                              this.wObs.hide();
			               }
			             },
                failure: function(resp1,resp2,resp3){
       	  
			       	   this.conexionFailure(resp1,resp2,resp3);
			       	   var d= this.sm.getSelected().data;
			       	   
			       	  
			       },
                timeout:this.timeout,
                scope:this
            }); 
		
	},
	
   preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;
          Phx.vista.ObligacionPagoVbPoa.superclass.preparaMenu.call(this,n); 
          this.getBoton('obs_poa').enable();
          if(this.historico != 'no'){
          	this.desBotoneshistorico();
          }
	
  },
  liberaMenu:function(){
	  	
        var tb = Phx.vista.ObligacionPagoVbPoa.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('obs_poa').enable();
        }
	    
       return tb
   },
   desBotoneshistorico:function(){
      
        this.getBoton('fin_registro').disable();
        this.getBoton('ant_estado').disable();
        this.getBoton('reporte_com_ejec_pag').enable();
		this.getBoton('reporte_plan_pago').enable();
		this.getBoton('diagrama_gantt').disable();
		this.getBoton('btnChequeoDocumentosWf').enable();
		this.getBoton('ajustes').disable();
		this.getBoton('est_anticipo').disable();
		this.getBoton('extenderop').disable();
		this.getBoton('btnCheckPresupeusto').enable();
      
   },
   tabsouth:[
            { 
             url:'../../../sis_tesoreria/vista/obligacion_det/ObligacionDet.php',
             title:'Detalle', 
             height:'50%',
             cls:'ObligacionDet'
            }
    
       ],
    
};
</script>
