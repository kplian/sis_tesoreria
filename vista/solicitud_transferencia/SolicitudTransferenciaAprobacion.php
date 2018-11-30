<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (fprudencio)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.SolicitudTransferenciaAprobacion = {
    require:'../../../sis_tesoreria/vista/solicitud_transferencia/SolicitudTransferencia.php',
	requireclase:'Phx.vista.SolicitudTransferencia',
	title:'Funcionario Planilla',
	nombreVista: 'SolicitudTransferenciaAprobacion',
	
	constructor: function(config) {	    
        Phx.vista.SolicitudTransferencia.superclass.constructor.call(this,config);
        this.store.baseParams.id_planilla = this.maestro.id_planilla;
        this.load({params:{start:0, limit:this.tam_pag}});
        
  },
  constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.SolicitudTransferencia.superclass.constructor.call(this,config);
		this.init();
		
		this.addButton('sig_estado',{grupo:[0],text:'Siguiente',iconCls: 'badelante',disabled:true,handler:this.sigEstado,tooltip: '<b>Pasar al Siguiente Estado</b>'});
		this.addButton('diagrama_gantt',{grupo:[0,1],text:'Gant',iconCls: 'bgantt',disabled:true,handler:diagramGantt,tooltip: '<b>Diagrama Gantt de proceso macro</b>'});
  		function diagramGantt(){            
            var data=this.sm.getSelected().data.id_proceso_wf;
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url:'../../sis_workflow/control/ProcesoWf/diagramaGanttTramite',
                params:{'id_proceso_wf':data},
                success:this.successExport,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });         
        } 
        this.store.baseParams.interfaz = 'aprobacion';
		this.store.baseParams.pes_estado = 'pendiente_validacion';
		this.load({params:{start:0, limit:this.tam_pag}});
		this.finCons = true;
	},
	beditGroups: [0],
    bdelGroups:  [0],
    bactGroups:  [0,1],
    btestGroups: [0],
    bexcelGroups: [0,1],
    
    gruposBarraTareas:[
						{name:'pendiente_validacion',title:'<H1 align="center"><i class="fa fa-eye"></i> Pendiente Aprobacion</h1>',grupo:0,height:0},
                       {name:'validado',title:'<H1 align="center"><i class="fa fa-eye"></i> Aprobada</h1>',grupo:1,height:0}
                       
                       ],
  bnew:false,
  bedit:true,
  bsave:false,
  bdel:false,
  onButtonEdit : function () {
    	this.mostrarComponente(this.Cmp.id_cuenta_origen);  
    	this.Cmp.id_cuenta_origen.allowBlank = false; 
    	this.ocultarComponente(this.Cmp.id_cuenta_destino);
    	this.ocultarComponente(this.Cmp.monto);
    	this.ocultarComponente(this.Cmp.motivo); 	
    	Phx.vista.SolicitudTransferencia.superclass.onButtonEdit.call(this);
    	
    },
   
	
};
</script>
