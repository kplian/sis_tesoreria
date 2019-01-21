<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (fprudencio)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite 
*dar el visto a solicitudes de compra
 * *Issue			Fecha        Author				Descripcion
 * #1			21/09/2018		EGS					Se modifico el edit para q los campos igualen con el new
  #12        10/01/2019      MMV ENDETRAN       Considerar restar el iva al comprometer obligaciones de pago
  #17         18/01/2019      MMV ENDETRAN       Plan de pago consulta obligaciones de pago
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ObligacionPagoEspecial = {
    bedit: true,
    bnew: true,
    bsave: false,
    bdel: true,
	require: '../../../sis_tesoreria/vista/obligacion_pago/ObligacionPago.php',
	requireclase: 'Phx.vista.ObligacionPago',
	title: 'Pago sin presupuesto (Garantias, impuestos, otros)',
	nombreVista: 'obligacionPagoEspecial',
	ActList:'../../sis_tesoreria/control/ObligacionPago/listarObligacionPagoSol',
	/*
	 *  Interface heredada para de ObligacionPago 	 * */
	
	constructor: function(config) {
	    
	   Phx.vista.ObligacionPagoEspecial.superclass.constructor.call(this,config);
       
        
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
            },
            {                                                                           //#17
                url:'../../../sis_tesoreria/vista/plan_pago/PlanPagosConsulta.php',
                title:'Plan de Pagos (Consulta)',
                height:'50%',
                cls:'PlanPagosConsulta'
            }
    
       ], 
    onButtonEdit:function(){
      
       var data= this.sm.getSelected().data;
       this.cmpTipoObligacion.disable();
       this.cmpDepto.disable(); 
       this.cmpFecha.disable(); 
       this.cmpTipoCambioConv.disable();
       this.Cmp.id_moneda.disable();
      
                 //#1			21/09/2018		EGS	
      this.ocultarComponente(this.cmpTipoObligacion);
      this.ocultarComponente(this.cmpIdContrato);
      this.ocultarComponente(this.cmpPagoVariable);
      this.ocultarComponente(this.cmpTipoAnticipo);
      this.ocultarComponente(this.cmpTotalNroCuota);
          //#1			21/09/2018		EGS	
       
       
       this.mostrarComponente(this.Cmp.id_funcionario);
       this.Cmp.id_funcionario.disable();
       
       
       Phx.vista.ObligacionPagoEspecial.superclass.onButtonEdit.call(this);
       
       this.Cmp.id_contrato.store.baseParams.filter = "[{\"type\":\"numeric\",\"comparison\":\"eq\", \"value\":\""+ this.Cmp.id_proveedor.getValue()+"\",\"field\":\"CON.id_proveedor\"}]";
	   this.Cmp.id_contrato.modificado = true;
	   
       this.cmpFuncionario.store.baseParams.fecha = this.Cmp.fecha.getValue().dateFormat(this.Cmp.fecha.format);
       
       
       	if(data.estado != 'borrador'){
       	  this.Cmp.tipo_anticipo.disable();
       	  this.Cmp.id_proveedor.disable();
       	  this.Cmp.comprometer_iva.disable();//#12
       }
       else{
       
       	this.Cmp.id_proveedor.enable();
       	this.mostrarComponente(this.Cmp.id_proveedor);
       	this.Cmp.comprometer_iva.enable();//#12
       }
       
         //#1			21/09/2018		EGS	
     	 this.Cmp.id_proveedor.disable();
         //#1			21/09/2018		EGS	
       
           
    },
    
    onButtonNew:function(){
        //abrir formulario de solicitud
	       var me = this;
		   me.objSolForm = Phx.CP.loadWindows('../../../sis_tesoreria/vista/obligacion_pago/FormObligacionEspecial.php',
	                                'Formulario de pagos especiales sin efecto presupuestario',
	                                {
	                                    modal:true,
	                                    width:'90%',
	                                    height:'90%'
	                                }, { data: { objPadre: me }
	                                }, 
	                                this.idContenedor,
	                                'FormObligacionEspecial',
	                                {
	                                    config:[{
	                                              event: 'successsave',
	                                              delegate: this.onSaveForm,
	                                              
	                                            }],
	                                    
	                                    scope:this
	                                 });
    },
    onSaveForm: function(form,  objRes){
    	var me = this;
    	//muestra la ventana de documentos para este proceso wf
	    Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
                    'Documentos del pago especial',
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
