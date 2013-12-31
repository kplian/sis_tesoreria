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
