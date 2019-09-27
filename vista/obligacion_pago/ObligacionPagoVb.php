<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (fprudencio)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite 
*dar el visto a solicitudes de compra
* Issue Autor  fecha       Descripcion
*  #32  Juan   27/09/2019  Corrección de close de estado Wf 
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ObligacionPagoVb = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:true,
	require:'../../../sis_tesoreria/vista/obligacion_pago/ObligacionPago.php',
	requireclase:'Phx.vista.ObligacionPago',
	title:'Obligacion de Pago (Vistos buenos)',
	nombreVista: 'ObligacionPagoVb',
	
	gruposBarraTareas:[{name:'pago_unico',title:'<H1 align="center"><i class="fa fa-paper-plane"></i> Pago excepcional</h1>',grupo:0,height:0},
                       {name:'pago_directo',title:'<H1 align="center"><i class="fa fa-paper-plane-o"></i> Pago Recurrentes</h1>',grupo:1,height:0},
                       {name:'otros',title:'<H1 align="center"><i class="fa fa-plus-circle"></i> Otros</h1>',grupo:2,height:0}],
	
	
	actualizarSegunTab: function(name, indice){
    	if(this.finCons){
    		 this.store.baseParams.pes_estado = name;
    	     this.load({params:{start:0, limit:this.tam_pag}});
    	   }
    },
	beditGroups: [0,1,2],
    bdelGroups:   [0,1,2],
    bactGroups:  [0,1,2],
    btestGroups:  [0,1,2],
    bexcelGroups: [0,1,2],
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
           
           
	   Phx.vista.ObligacionPagoVb.superclass.constructor.call(this,config);
       this.addButton('obs_presu',{grupo:[0,1,2],text:'Obs. Presupuestos', disabled:true, handler: this.initObs, tooltip: '<b>Observacioens del área de presupuesto</b>'});
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
        this.store.baseParams.pes_estado = 'pago_unico';
        this.load({params:{start:0, limit:this.tam_pag}});
        this.finCons = true;
		 
    },
    
    submitSigEstado: function(){
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
    showObsEstado: function(){
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
      successSinc:function (){ //#32
        Phx.CP.loadingHide(); //#32
        this.wEstado.hide(); //#32
        this.reload(); //#32
      }, //#32
    
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
                    name: 'obs',
                    xtype: 'textarea',
                    fieldLabel: 'Obs',
                    grow: true,
                    growMin : '80%',
                    allowBlank: true,
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
                    handler: this.submitObsPresupuestos,
                    scope: this
                    
             },
             {
                text: 'Cancelar',
                handler:function(){this.wObs.hide()},
                scope:this
            }]
        });
        
        this.cmbObsPres = this.formObs.getForm().findField('obs');
	},
	
	initObs:function(){
		var d= this.sm.getSelected().data;
        this.cmbObsPres.setValue(d.obs_presupuestos);
		this.wObs.show()
	},
	
	submitObsPresupuestos:function(){
		    Phx.CP.loadingShow();
		    var d= this.sm.getSelected().data;
            Ext.Ajax.request({
                url: '../../sis_tesoreria/control/ObligacionPago/modificarObsPresupuestos',
                params: {
                    id_obligacion_pago: d.id_obligacion_pago,
                    obs: this.cmbObsPres.getValue()
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
          Phx.vista.ObligacionPagoVb.superclass.preparaMenu.call(this,n); 
          
          if(this.historico == 'no'){
          	this.getBoton('obs_presu').enable();
          }
	      else{
	    	this.desBotoneshistorico()
	      }	
	
  },
  liberaMenu:function(){
	  	
        var tb = Phx.vista.ObligacionPagoVb.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('obs_presu').disable();
        }
	    
       return tb
   },
   desBotoneshistorico:function(){
      
        this.getBoton('fin_registro').disable();
        this.getBoton('ant_estado').disable();
        this.getBoton('reporte_com_ejec_pag').enable();
		this.getBoton('reporte_plan_pago').enable();
		this.getBoton('diagrama_gantt').enable();
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
