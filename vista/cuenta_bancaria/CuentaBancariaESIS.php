<?php
/**
*@package pXP
*@file MovimientoAlm.php
*@author  Gonzalo Sarmiento
*@date 10-07-2013 10:22:05
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CuentaBancariaESIS = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
	require:'../../../sis_tesoreria/vista/cuenta_bancaria/CuentaBancaria.php',
	requireclase:'Phx.vista.CuentaBancaria',
	title:'Cuenta Bancaria ENDESIS',
	nombreVista: 'cuentaBancariaESIS',
	
	constructor: function(config) {
	    this.maestro=config.maestro;
    	Phx.vista.CuentaBancariaESIS.superclass.constructor.call(this,config);
	    this.load({params:{start:0, limit:this.tam_pag}});
	},
      
	preparaMenu:function(n){
      var data = this.getSelectedData();
      var tb =this.tbar;
      Phx.vista.CuentaBancariaESIS.superclass.preparaMenu.call(this,n);  
      return tb 
     }, 

     liberaMenu:function(){
        var tb = Phx.vista.CuentaBancariaESIS.superclass.liberaMenu.call(this);
        return tb
    },
    
    south:
          { 
          url:'../../../sis_migracion/vista/ts_libro_bancos/TsLibroBancos.php',
          title:'Detalle', 
          height:'50%',
          cls:'TsLibroBancos'
         }
};
</script>
