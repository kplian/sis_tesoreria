<?php
/**
*@package pXP
*@file CajaSolicitud.php
*@author  gsarmiento
*@date 29-01-2016
*@description Archivo con la interfaz de usuario que permite 
*solicitar la apertura de caja chica
*
*/
header("content-type: text/javascript; charset=UTF-8"); 
?>
<script>
Phx.vista.CajaSolicitud = {
    require:'../../../sis_tesoreria/vista/caja/Caja.php',
    requireclase:'Phx.vista.Caja',
    title:'Solicitud Caja',
    nombreVista: 'caja',
	
	gruposBarraTareas:[{name:'borrador',title:'<H1 align="center"><i class="fa fa-thumbs-o-down"></i> Borradores</h1>',grupo:0,height:0},
                       {name:'proceso',title:'<H1 align="center"><i class="fa fa-eye"></i> Iniciados</h1>',grupo:1,height:0},
                       {name:'finalizados',title:'<H1 align="center"><i class="fa fa-thumbs-o-up"></i> Finalizados</h1>',grupo:2,height:0}],
	
	actualizarSegunTab: function(name, indice){
		
    	if(this.finCons){
    		 this.store.baseParams.pes_estado = name;
    	     this.load({params:{start:0, limit:this.tam_pag, tipo_interfaz: this.nombreVista}});
    	   }
    },
	
	beditGroups: [0],
    bdelGroups:  [0],
    bactGroups:  [0,1,2],
    btestGroups: [0],
    bexcelGroups: [0,1,2],
    
    constructor: function(config) {
      
       Phx.vista.CajaSolicitud.superclass.constructor.call(this,config);
          
	   
	   this.addButton('diagrama_gantt',
						{text:'Gantt',
						grupo:[0,1,2],
						iconCls: 'bgantt',
						disabled:false,
						handler:diagramGantt,
						tooltip: '<b>Diagrama Gantt de proceso macro</b>'});
						
       this.addButton('btnAbrirCerrar',
			{
				text: 'Crear',
				iconCls: 'badelante',
				disabled: false,
				handler: this.abrirCerrarCaja,
				tooltip: '<b>Crear</b><br/>Crear caja'
			}
		);
		
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
		
		this.store.baseParams.pes_estado = 'borrador';
		
        this.load({params:{start:0, limit:this.tam_pag, tipo_interfaz: this.nombreVista}});
		
		this.finCons = true;
    },
	
		
	preparaMenu:function(n){
         var data = this.getSelectedData();
         
         if(data.estado_proceso == 'borrador'){  
		    this.getBoton('btnAbrirCerrar').enable();
			this.getBoton('edit').enable();
			this.getBoton('del').enable();
         }
		 else{
			 this.getBoton('edit').disable();
			 this.getBoton('del').disable();
			 if(data.estado =='abierto')
				 this.getBoton('btnAbrirCerrar').enable();			 
			 else
				this.getBoton('btnAbrirCerrar').disable();
		 }		 
     },
    
	 abrirCerrarCaja:function(){
		var rec=this.sm.getSelected();
		var NumSelect=this.sm.getCount();
		
		if(NumSelect != 0)
		{	
		  if(rec.data.estado=='creando'){
			  this.objWizard = Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php',
							'Estado de Wf',
							{
								modal:true,
								width:700,
								height:450
							}, {data:{
								   id_estado_wf:rec.data.id_estado_wf,
								   id_proceso_wf:rec.data.id_proceso_wf								  
								}}, this.idContenedor,'FormEstadoWf',
							{
								config:[{
										  event:'beforesave',
										  delegate: this.onSaveWizard												  
										}],
								
								scope:this
							 });
		  }else{
			  Ext.MessageBox.alert('Alerta', 'La caja no se encuentra en estado creando.');
		  }
		}
		else
		{
			Ext.MessageBox.alert('Alerta', 'Antes debe seleccionar un item.');
		}					   
	},
		
	onSaveWizard:function(wizard,resp){
		Phx.CP.loadingShow();
		
		Ext.Ajax.request({
			url:'../../sis_tesoreria/control/Caja/siguienteEstadoCaja',
			params:{
					
				id_proceso_wf_act:  resp.id_proceso_wf_act,
				id_estado_wf_act:   resp.id_estado_wf_act,
				id_tipo_estado:     resp.id_tipo_estado,
				id_funcionario_wf:  resp.id_funcionario_wf,
				id_depto_wf:        resp.id_depto_wf,
				obs:                resp.obs,
				json_procesos:      Ext.util.JSON.encode(resp.procesos)
				},
			success:this.successWizard,
			failure: this.conexionFailure,
			argument:{wizard:wizard},
			timeout:this.timeout,
			scope:this
		});
	},
	
	successWizard:function(resp){
		Phx.CP.loadingHide();
		resp.argument.wizard.panel.destroy()
		this.reload();
	 },
};
</script>
