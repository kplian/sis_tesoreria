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
Phx.vista.ObligacionPagoConsulta = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
	require:'../../../sis_tesoreria/vista/obligacion_pago/ObligacionPago.php',
	requireclase:'Phx.vista.ObligacionPago',
	title:'Obligacion de Pago (Consulta)',
	nombreVista: 'ObligacionPagoConsulta',
	/*
	 *  Interface heredada para el sistema consulta de obligaciones de pago
	 *  solo para el ver el estado de los diferente procesos
	 * 
	 * */
	
	constructor: function(config) {
	   Phx.vista.ObligacionPagoConsulta.superclass.constructor.call(this,config);
    },
    
    preparaMenu:function(n){
         	var data = this.getSelectedData();
         	var tb =this.tbar;
          
            Phx.vista.ObligacionPago.superclass.preparaMenu.call(this,n); 
          	this.getBoton('fin_registro').disable();
          	this.getBoton('ant_estado').disable();
	        this.getBoton('reporte_com_ejec_pag').enable();
	        this.getBoton('reporte_plan_pago').enable();
			this.getBoton('diagrama_gantt').enable();
			this.getBoton('btnChequeoDocumentosWf').enable();
			this.getBoton('ajustes').disable();
			this.getBoton('est_anticipo').disable();
			this.getBoton('extenderop').disable();
			this.TabPanelSouth.get(1).enable();
		    if(data.tipo_obligacion == 'adquisiciones'){
              this.getBoton('btnVerifPresup').disable();
              this.menuAdq.enable();
            }
            else{
              //RCM: menú de reportes de adquisiciones
              this.menuAdq.disable();
              //Habilita el reporte de disponibilidad si está en estado borrador
              if (data['estado'] == 'borrador'){
              	this.getBoton('btnVerifPresup').enable();
              } else{
              	//Inhabilita el reporte de disponibilidad
              	this.getBoton('btnVerifPresup').disable();
              }
            }
          
     },
     
     
     liberaMenu:function(){
        var tb = Phx.vista.ObligacionPago.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('fin_registro').disable();
            this.getBoton('ant_estado').disable();
            this.getBoton('reporte_com_ejec_pag').disable();
			this.getBoton('reporte_plan_pago').disable();
			this.getBoton('diagrama_gantt').disable();
			this.getBoton('btnChequeoDocumentosWf').disable();
			this.getBoton('ajustes').disable();
			this.getBoton('est_anticipo').disable();
			this.getBoton('extenderop').disable();
			
			//Inhabilita el reporte de disponibilidad
            this.getBoton('btnVerifPresup').disable();
        }
       this.TabPanelSouth.get(1).disable();
       
       //RCM: menú de reportes de adquisiciones
       this.menuAdq.disable();
        
       return tb
    }, 
    
   
    
     tabsouth:[
            { 
             url:'../../../sis_tesoreria/vista/obligacion_det/ObligacionDetConsulta.php',
             title:'Detalle', 
             height:'50%',
             cls:'ObligacionDetConsulta'
            },
            {
              //carga la interface de registro inicial  
              url:'../../../sis_tesoreria/vista/plan_pago/PlanPagoConsulta.php',
              title:'Plan de Pagos (Consulta)', 
              height:'50%',
              cls:'PlanPagoConsulta'
            }
    
       ]
    
};
</script>
