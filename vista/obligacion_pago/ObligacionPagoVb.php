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
Phx.vista.ObligacionPagoVb = {
    bedit:true,
    bnew:false,
    bsave:false,
    bdel:true,
	require:'../../../sis_tesoreria/vista/obligacion_pago/ObligacionPago.php',
	requireclase:'Phx.vista.ObligacionPago',
	title:'Obligacion de Pago(Adquisiciones)',
	nombreVista: 'ObligacionPagoVb',
	/*
	 *  Interface heredada para el sistema de adquisiciones para que el reposnable 
	 *  de adqusiciones registro los planes de pago , y ase por los pasos configurados en el WF
	 *  de validacion, aprobacion y registro contable
	 * */
	
	constructor: function(config) {
	    
	   Phx.vista.ObligacionPagoVb.superclass.constructor.call(this,config);
       
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
                    allowBlank: true,
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
                    handler:this.antEstadoSubmmit,
                    scope:this,
                    argument: {estado: 'anterior'}
                    
             },
             {
                text: 'Cancelar',
                handler:function(){this.wEstado.hide()},
                scope:this
            }]
        });
        
        this.cmpObs=this.formEstado.getForm().findField('obs');
         
    },
    
    antEstado:function(res,eve) {                   
            this.wEstado.show();
            
           
            this.cmpObs.setValue('');
            
           
               
        },
        
     antEstadoSubmmit:function(res,eve){                   
            var d= this.sm.getSelected().data;
            Phx.CP.loadingShow();
            var operacion = 'cambiar';
            operacion=  res.argument.estado == 'inicio'?'inicio':operacion; 
            
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
    
       ]
    
    
};
</script>
