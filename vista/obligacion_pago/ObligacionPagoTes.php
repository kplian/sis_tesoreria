<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (rarteaga)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite 
*dar el visto a solicitudes de compra
*
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
    
    preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;
          
          
          Phx.vista.ObligacionPagoTes.superclass.preparaMenu.call(this,n); 
          if (data['estado']== 'borrador'){
              this.getBoton('edit').enable();
              this.getBoton('new').enable();
              this.getBoton('del').enable();    
              this.getBoton('fin_registro').enable();
              this.getBoton('ant_estado').disable();
              this.TabPanelSouth.get(1).disable();
          
          }
          else{
              
              
               if (data['estado']== 'registrado'){   
                  this.getBoton('ant_estado').enable();
                  this.getBoton('fin_registro').disable();
                  this.TabPanelSouth.get(1).enable()
                }
                
                if (data['estado']== 'en_pago'){
                    this.TabPanelSouth.get(1).enable()
                    this.getBoton('ant_estado').enable();
                    this.getBoton('fin_registro').enable();
                    
                }
                
               
                
               if (data['estado']== 'anulado'){
                    this.getBoton('fin_registro').disable();
                    this.TabPanelSouth.get(1).disable();
               }
              
              this.getBoton('edit').disable();
              this.getBoton('del').disable();
          }
          
          
          //RCM: menú de reportes de adquisiciones
          this.menuAdq.enable();
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
    
    
};
</script>
