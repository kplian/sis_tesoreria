<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (rarteaga)
*@date 20-09-2015 10:22:05
*@description consulta de  prorrateo
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ProrrateoConsulta = {
    
    bdel:false,
    bedit:false,
    bsave:false,
    bnew:false,
    
	require:'../../../sis_tesoreria/vista/prorrateo/Prorrateo.php',
	requireclase:'Phx.vista.Prorrateo',
	title:'Consulta de Prorrateo',
	nombreVista: 'ProrrateoConsulta',
	
	constructor: function(config) {
		
	    this.maestro=config.maestro;
	    Phx.vista.ProrrateoConsulta.superclass.constructor.call(this, config);
        
    }, 
    
     preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;
          Phx.vista.Prorrateo.superclass.preparaMenu.call(this,n); 
     },
    
     onReloadPage:function(m){
        this.maestro=m;
        this.store.baseParams={ id_plan_pago: this.maestro.id_plan_pago, tipo_interfaz: this.nombreVista };
        this.load({ params: { start:0, limit: this.tam_pag } });
         
     }
    
};
</script>
