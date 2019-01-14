<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (rarteaga)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite dar el visto a solicitudes de compra
Issue			Fecha        Author				Descripcion
#12        10/01/2019      MMV ENDETRAN       Considerar restar el iva al comprometer obligaciones de pago
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ObligacionPagoTes = {
    require:'../../../sis_tesoreria/vista/obligacion_pago/ObligacionPago.php',
	requireclase:'Phx.vista.ObligacionPago',
	title:'Obligacion de Pago(Adquisiciones)',
	nombreVista: 'obligacionPagoTes',
	
	/*
	 *  Interface heredada para el sistema de adquisiciones para que el reposnable 
	 *  de tesoreria
	 * */
	
	constructor: function(config) {
	    
	  Phx.vista.ObligacionPagoTes.superclass.constructor.call(this,config);
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
       this.cmpMoneda.enable();
       
       Phx.vista.ObligacionPagoTes.superclass.onButtonEdit.call(this);
       
       if(data.tipo_obligacion=='adquisiciones'){
            this.mostrarComponente(this.cmpProveedor);
            this.ocultarComponente(this.cmpFuncionario);
            this.ocultarComponente(this.cmpFuncionarioProveedor);
            this.cmpFuncionario.reset();
            this.cmpProveedor.disable();
            
       }
       
       if(data.tipo_obligacion=='pago_unico'  ){
           
           this.cmpProveedor.enable();
           this.mostrarComponente(this.cmpProveedor);
           
       }
       if(data.tipo_obligacion=='pago_directo'){
           
           this.cmpProveedor.enable();
           this.mostrarComponente(this.cmpProveedor);
           this.cmpFuncionario.store.baseParams.fecha = this.cmpFecha.getValue().dateFormat(this.cmpFecha.format);
                 
       }
       
       //segun el total nro cuota cero, ocultamos los componentes
       if(data.total_nro_cuota=='0'){
           this.ocultarComponente(this.Cmp.id_plantilla);
           this.ocultarComponente(this.Cmp.fecha_pp_ini);
           this.ocultarComponente(this.Cmp.rotacion);
       }
       else{
           this.cmpProveedor.enable();
           this.mostrarComponente(this.cmpProveedor);
           this.cmpMoneda.enable();
       }
       if(data.estado != 'borrador'){
       	  this.Cmp.tipo_anticipo.disable();
       	  this.Cmp.total_nro_cuota.disable();
       	  this.Cmp.id_funcionario.disable();
       	  this.Cmp.comprometer_iva.disable(); //#12
       }
       else{
       	this.Cmp.total_nro_cuota.enable();
       	this.Cmp.comprometer_iva.enable();//#12
       }
           
    },
    
    onButtonNew:function(){
        Phx.vista.ObligacionPagoTes.superclass.onButtonNew.call(this);
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
        this.Cmp.comprometer_iva.enable();//#12
        
    },
};
</script>
