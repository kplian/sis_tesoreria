<?php
/**
*@package pXP
*@file ProcesoCajaVbConta.php
*@author  Gonzalo Sarmiento Sejas
*@date 24-12-2015
*@description Archivo con la interfaz de usuario que permite
*dar el visto a Rendiciones y Reposiciones en Contabilidad
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ProcesoCajaVbConta = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
	require:'../../../sis_tesoreria/vista/proceso_caja/ProcesoCajaVb.php',
	requireclase:'Phx.vista.ProcesoCajaVb',
	title:'Visto Bueno Rendiciones Caja Contabilidad',
	nombreVista: 'ProcesoCajaVbConta',
	/*
	 *  Interface heredada en el sistema de tesoreria para que el responsable
	 *  de rendiciones apruebe las rendiciones , y pase por los pasos configurados en el WF
	 *  de validacion, aprobacion
	 * */
	 
	gruposBarraTareas:[{name:'no_contabilizados',title:'<H1 align="center"><i class="fa fa-thumbs-o-down"></i> No Contabilizados</h1>',grupo:0,height:0},
                       {name:'contabilizados',title:'<H1 align="center"><i class="fa fa-thumbs-o-up"></i> Contabilizados</h1>',grupo:1,height:0}],
	
	actualizarSegunTab: function(name, indice){
		
    	if(this.finCons){
    		 this.store.baseParams.pes_estado = name;
    	     this.load({params:{start:0, limit:this.tam_pag, tipo_interfaz: this.nombreVista}});
    	   }
    },

	bactGroups:  [0,1],
	
	constructor: function(config) {

	   this.finCons = true;
	   Phx.vista.ProcesoCajaVbConta.superclass.constructor.call(this,config);	   
	   
    },
	
	preparaMenu:function(){
	  
	   Phx.vista.ProcesoCajaVbConta.superclass.preparaMenu.call(this);

	   }
};
</script>
