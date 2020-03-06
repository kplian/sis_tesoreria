<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (rarteaga)
*@date 20-09-2011 10:22:05
*@description consulta de planes de pago
 * 
 * 
 * 
 * Issue			Fecha        Author				Descripcion
#1			0-09-2011		 RAC KPLIAN          creacion
#55         13/02/2020       RAC KPLIAN          fix bug al desplegar pal de pago consulta, no se muestra la interface 
 *********************************************************************************************************************************************/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PlanPagoConsulta = {
    
    bdel:false,
    bedit:false,
    bsave:false,
    bnew: false,
    
	require:'../../../sis_tesoreria/vista/plan_pago/PlanPago.php',
	requireclase:'Phx.vista.PlanPago',
	title:'Consulta de Planes de Pago',
	nombreVista: 'PlanPagoConsulta',
	
	constructor: function(config) {
		
	    this.maestro=config.maestro;
	    Phx.vista.PlanPagoConsulta.superclass.constructor.call(this,config);
	    this.init();	
        ////formulario de departamentos
        //this.crearFormularioEstados();
        //si la interface es pestanha este código es para iniciar 
        var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
        if(dataPadre){
             this.onEnablePanel(this, dataPadre);
        } else {
             this.bloquearMenus();
        }
          
          
        
    }, 
    
     onReloadPage:function(m){
        this.maestro=m;
        this.store.baseParams={id_obligacion_pago:this.maestro.id_obligacion_pago,tipo_interfaz:this.nombreVista};
        this.load({params:{start:0, limit:this.tam_pag}})
         
     },
    preparaMenu:function(n){
           var data = this.getSelectedData();
           var tb =this.tbar;          
           this.getBoton('ant_estado').disable();
           this.getBoton('sig_estado').disable();
           Phx.vista.PlanPagoConsulta.superclass.preparaMenu.call(this,n); 
           this.getBoton('SincPresu').disable();
	       this.getBoton('SolPlanPago').disable();
	     
	       this.getBoton('ant_estado').disable();
	       this.getBoton('sig_estado').disable();
	       this.getBoton('btnChequeoDocumentosWf').enable();
	       this.getBoton('btnPagoRel').enable(); 
	       this.getBoton('btnObs').enable(); 
     },
     
    liberaMenu:function(){
        var tb = Phx.vista.PlanPagoConsulta.superclass.liberaMenu.call(this);
        if(tb){          
           this.getBoton('SincPresu').disable();
           this.getBoton('SolPlanPago').disable();
          
           this.getBoton('ant_estado').disable();
           this.getBoton('sig_estado').disable();
           this.getBoton('btnChequeoDocumentosWf').disable();
           this.getBoton('btnPagoRel').disable(); 
           this.getBoton('btnObs').disable();   
          }
       return tb
    }, 
    
    east:{
          url:'../../../sis_tesoreria/vista/prorrateo/ProrrateoConsulta.php',
          title:'Prorrateo', 
          width:400,
          cls:'ProrrateoConsulta'
     },
    
	tabla_id: 'id_plan_pago',
	tabla: 'tes.tplan_pago' 
    
    
    
};
</script>
