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
Phx.vista.ObligacionPagoAdq = {
    bedit:true,
    bnew:false,
    bsave:false,
    bdel:true,
	require:'../../../sis_tesoreria/vista/obligacion_pago/ObligacionPago.php',
	requireclase:'Phx.vista.ObligacionPago',
	title:'Obligacion de Pago(Adquisiciones)',
	nombreVista: 'obligacionPagoAdq',
	/*
	 *  Interface heredada para el sistema de adquisiciones para que el reposnable 
	 *  de adqusiciones registro los planes de pago , y ase por los pasos configurados en el WF
	 *  de validacion, aprobacion y registro contable
	 * */
	
	constructor: function(config) {
	   Phx.vista.ObligacionPagoAdq.superclass.constructor.call(this,config);
       this.Cmp.id_contrato.allowBlank = true; 
        
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
       this.Cmp.id_contrato.enable();
       
       Phx.vista.ObligacionPagoAdq.superclass.onButtonEdit.call(this);
       
       if(data.tipo_obligacion=='adquisiciones'){
            this.mostrarComponente(this.cmpProveedor);
            this.ocultarComponente(this.cmpFuncionario);
            this.ocultarComponente(this.cmpFuncionarioProveedor);
            this.cmpFuncionario.reset();
            this.cmpProveedor.disable();
            this.cmpMoneda.disable();
       }
       
       this.cmpProveedor.disable();
       this.cmpMoneda.disable();
       
       //segun el total nro cuota cero, ocultamos los componentes
       if(data.total_nro_cuota=='0'){
           this.ocultarComponente(this.Cmp.id_plantilla);
           this.ocultarComponente(this.Cmp.fecha_pp_ini);
           this.ocultarComponente(this.Cmp.rotacion);
       }
       else{
           this.mostrarComponente(this.Cmp.id_plantilla);
           this.mostrarComponente(this.Cmp.fecha_pp_ini);
           this.mostrarComponente(this.Cmp.rotacion);
       }
       
       if(data.estado != 'borrador'){
       	  this.Cmp.tipo_anticipo.disable();
       	  this.Cmp.total_nro_cuota.disable();
       }
       else{
       	   this.Cmp.tipo_anticipo.disable();
       	   this.Cmp.total_nro_cuota.disable();
       	   
       }
       
       this.Cmp.id_contrato.store.baseParams.filter = "[{\"type\":\"numeric\",\"comparison\":\"eq\", \"value\":\""+ this.Cmp.id_proveedor.getValue()+"\",\"field\":\"CON.id_proveedor\"}]";
	   this.Cmp.id_contrato.modificado = true;
           
    },
    
    onButtonNew:function(){
        Phx.vista.ObligacionPagoAdq.superclass.onButtonNew.call(this);
        //this.cmpPorcAnticipo.setValue(0);
        //this.cmpPorcRetgar.setValue(0);
       
        
        this.cmpTipoObligacion.enable();
        this.cmpDepto.enable(); 
        this.mostrarComponente(this.cmpProveedor);
        this.ocultarComponente(this.cmpFuncionario);
        this.ocultarComponente(this.cmpFuncionarioProveedor);
        this.cmpFuncionario.reset();
        this.cmpFecha.enable(); 
        this.cmpTipoCambioConv.enable();
        this.cmpProveedor.enable();
        this.cmpDepto.enable(); 
        this.cmpMoneda.enable();
        //defecto total nro cuota cero, entoces ocultamos los componentes
        this.ocultarComponente(this.Cmp.id_plantilla);
        this.ocultarComponente(this.Cmp.fecha_pp_ini);
        this.ocultarComponente(this.Cmp.rotacion);
        
    },
    
};
</script>
