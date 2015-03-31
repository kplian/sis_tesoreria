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
Phx.vista.ObligacionPagoUnico = {
    bedit: true,
    bnew: true,
    bsave: false,
    bdel: true,
	require: '../../../sis_tesoreria/vista/obligacion_pago/ObligacionPago.php',
	requireclase: 'Phx.vista.ObligacionPago',
	title: 'Pago Únicos Excepcionales (Sin Proceso)',
	nombreVista: 'obligacionPagoUnico',
	ActList:'../../sis_tesoreria/control/ObligacionPago/listarObligacionPagoSol',
	/*
	 *  Interface heredada para el sistema de adquisiciones para que el reposnable 
	 *  de adqusiciones registro los planes de pago , y ase por los pasos configurados en el WF
	 *  de validacion, aprobacion y registro contable
	 * */
	
	constructor: function(config) {
	    
	   Phx.vista.ObligacionPagoUnico.superclass.constructor.call(this,config);
       
        
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
    onButtonEdit:function(){
       
       var data= this.sm.getSelected().data;
       this.cmpTipoObligacion.disable();
       this.cmpDepto.disable(); 
       this.cmpFecha.disable(); 
       this.cmpTipoCambioConv.disable();
       
       Phx.vista.ObligacionPagoUnico.superclass.onButtonEdit.call(this);
       
           
    },
    
    onButtonNew:function(){
        //abrir formulario de solicitud
	       var me = this;
		   me.objSolForm = Phx.CP.loadWindows('../../../sis_tesoreria/vista/obligacion_pago/FormObligacion.php',
	                                'Formulario de obligacion de pago único',
	                                {
	                                    modal:true,
	                                    width:'90%',
	                                    height:'90%'
	                                }, {data:{objPadre: me}
	                                }, 
	                                this.idContenedor,
	                                'FormObligacion',
	                                {
	                                    config:[{
	                                              event:'successsave',
	                                              delegate: this.onSaveForm,
	                                              
	                                            }],
	                                    
	                                    scope:this
	                                 }); 
        
    },
    onSaveForm: function(form,  objRes){
    	var me = this;
    	//muestra la ventana de documentos para este proceso wf
	    Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
                    'Documentos del pago único',
                    {
                        width:'90%',
                        height:500
                    },
                    {
				    	id_obligacion_pago: objRes.ROOT.datos.id_obligacion_pago,
				    	id_proceso_wf: objRes.ROOT.datos.id_proceso_wf,
				    	num_tramite: objRes.ROOT.datos.num_tramite,
				    	estao: objRes.ROOT.datos.estado,
				    	nombreVista: 'Formulario de solicitud de compra',
				    	tipo: 'solcom'  //para crear un boton de guardar directamente en la ventana de documentos
				    	
				    },
                    this.idContenedor,
                    'DocumentoWf',
                    {
                        config:[{
                                  event:'finalizarsol',
                                  delegate: this.onCloseDocuments,
                                  
                                }],
                        
                        scope:this
                     }
        )
    	
    	form.panel.destroy();
        me.reload();
    	
    },
     onCloseDocuments: function(paneldoc, data){
     	var newrec = this.store.getById(data.id_obligacion_pago);
    	if(newrec){
	    	this.sm.selectRecords([newrec]);
	    	this.fin_registro( undefined, undefined, undefined,  paneldoc);
	    	
	    }
    },
    rowExpander: new Ext.ux.grid.RowExpander({
		        tpl : new Ext.Template('<br>',
		            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Obligación de pago:&nbsp;&nbsp;</b> {numero}</p>',
		            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Depto:&nbsp;&nbsp;</b> {nombre_depto}</p>',
		            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Justificación:&nbsp;&nbsp;</b> {obs}</p>',
		            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Obs del área de presupeustos:&nbsp;&nbsp;</b> {obs_presupuestos}</p><br>'
		       )
	    }),
    
};
</script>
