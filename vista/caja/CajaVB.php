<?php
/**
*@package pXP
*@file CajaVB.php
*@author  gsarmiento
*@date 03-12-2015
*@description Archivo con la interfaz de usuario que permite 
*dar el visto a solicitudes de apertura, rendicion de caja chica
*
*/
header("content-type: text/javascript; charset=UTF-8"); 
?>
<script>
Phx.vista.CajaVb = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
    require:'../../../sis_tesoreria/vista/caja/Caja.php',
    requireclase:'Phx.vista.Caja',
    title:'Caja',
    nombreVista: 'cajaVb',
    
    constructor: function(config) {
      
       this.Atributos[this.getIndAtributo('codigo')].config.disabled=true; 
       this.Atributos[this.getIndAtributo('nro_tramite')].config.disabled=true; 
       this.Atributos[this.getIndAtributo('id_cuenta_bancaria')].form=true;
	   this.Atributos[this.getIndAtributo('id_depto')].config.disabled=true; 
       this.Atributos[this.getIndAtributo('tipo')].config.disabled=true; 
       this.Atributos[this.getIndAtributo('tipo_ejecucion')].config.disabled=true; 
       this.Atributos[this.getIndAtributo('id_moneda')].config.disabled=true; 
	   
       this.Atributos[this.getIndAtributo('nro_tramite')].bottom_filter=true;
       this.Atributos[this.getIndAtributo('codigo')].bottom_filter=true;
              
       //funcionalidad para listado de historicos
       /*this.historico = 'no';
       this.tbarItems = [{
            text: 'Histórico',
            enableToggle: true,
            pressed: false,
            toggleHandler: function(btn, pressed) {
               
                if(pressed){
                    this.historico = 'si';
                     this.desBotoneshistorico();
                }
                else{
                   this.historico = 'no' 
                }
                this.store.baseParams.historico = this.historico;
                this.reload();
             },
            scope: this
        }];
        */
       Phx.vista.CajaVb.superclass.constructor.call(this,config);
       
	   this.iniciarEventos();
       //this.grid.addListener('cellclick', this.oncellclick,this);
       this.addButton('diagrama_gantt',{text:'Gantt',iconCls: 'bgantt',disabled:false,handler:diagramGantt,tooltip: '<b>Diagrama Gantt de proceso macro</b>'});
	   this.addButton('ant_estado',{ grupo:[0,1], argument: {estado: 'anterior'},text:'Anterior',iconCls: 'batras',disabled:true,handler:this.antEstado,tooltip: '<b>Pasar al Anterior Estado</b>'});
	   this.addButton('sig_estado',{ grupo:[0,1], text:'Aprobar/Sig.',iconCls: 'badelante',disabled:true,handler:this.sigEstado,tooltip: '<b>Apueba y pasar al Siguiente Estado</b>'});
		      
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
                   
       this.store.baseParams={tipo_interfaz:this.nombreVista};
       if(config.filtro_directo){
           this.store.baseParams.filtro_valor = config.filtro_directo.valor;
           this.store.baseParams.filtro_campo = config.filtro_directo.campo;
       }
       
       this.load({params:{start:0, limit:this.tam_pag, tipo_interfaz: this.nombreVista}})
    },
    //deshabilitas botones para informacion historica
    desBotoneshistorico:function(){
          this.getBoton('ant_estado').disable();         
          this.getBoton('sig_estado').disable();
          //this.getBoton('edit').disable();           
     }, 
    
   onButtonEdit:function(){
         var data = this.getSelectedData();
         Phx.vista.CajaVb.superclass.onButtonEdit.call(this);         
     },
    
    iniciarEventos:function(){
		
		this.CmpIdCuentaBancaria = this.getComponente('id_cuenta_bancaria');
							
		Ext.apply(this.CmpIdCuentaBancaria.store.baseParams,{permiso : 'libro_bancos'});
    }, 
    
    
    preparaMenu:function(n){
         var data = this.getSelectedData();
         var tb =this.tbar;
         //Phx.vista.CajaVb.superclass.preparaMenu.call(this,n); 
         //if(this.historico == 'no'){  
		    this.getBoton('ant_estado').enable();         
            this.getBoton('sig_estado').enable();
            //this.getBoton('edit').enable(); 
         //} 
         //else{
         //   this.desBotoneshistorico();
         //} 
     },
    
    liberaMenu:function(){
        var tb = Phx.vista.CajaVb.superclass.liberaMenu.call(this);
        
        if(tb){
           this.getBoton('ant_estado').disable();
           this.getBoton('sig_estado').disable();     
        }
       return tb
    }, 
    
	antEstado:function(res){
         var rec=this.sm.getSelected();
         Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/AntFormEstadoWf.php',
            'Estado de Wf',
            {
                modal:true,
                width:450,
                height:250
            }, { data:rec.data, estado_destino: res.argument.estado }, this.idContenedor,'AntFormEstadoWf',
            {
                config:[{
                          event:'beforesave',
                          delegate: this.onAntEstado,
                        }
                        ],
               scope:this
             })
   },
   
   onAntEstado: function(wizard,resp){
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url:'../../sis_tesoreria/control/Caja/anteriorEstadoCaja',
                params:{
                        id_proceso_wf: resp.id_proceso_wf,
                        id_estado_wf:  resp.id_estado_wf,  
                        obs: resp.obs,
                        estado_destino: resp.estado_destino
                 },
                argument:{wizard:wizard},  
                success:this.successEstadoSinc,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });
           
     },
     
   successEstadoSinc:function(resp){
        Phx.CP.loadingHide();
        resp.argument.wizard.panel.destroy()
        this.reload();
     },  
	 
    sortInfo:{
        field: 'nro_tramite',
        direction: 'ASC'
    },
	/*
	sigEstado:function(){                   
      	var rec=this.sm.getSelected();
      	
      	if ((rec.data.estado == 'vbsolicitante' && rec.data.tipo_obligacion == 'adquisiciones') && 
      				(rec.data['fecha_conformidad'] == '' || rec.data['fecha_conformidad'] == undefined || rec.data['fecha_conformidad'] == null)
      				&& (rec.data.tipo=='devengado'  || rec.data.tipo=='devengado_pagado' || rec.data.tipo=='devengado_pagado_1c')) {
      		Ext.Msg.show({
			   title:'Confirmación',
			   scope: this,
			   msg: 'Esta segur@ de solicitar el pago sin generar la conformidad? Para generarla presione el botón "Conformidad"',
			   buttons: Ext.Msg.YESNO,
			   fn: function(id, value, opt) {			   		
			   		if (id == 'yes') {
			   			this.mostrarWizard(rec);
			   		} else {
			   			opt.hide;
			   		}
			   },	
			   animEl: 'elId',
			   icon: Ext.MessageBox.WARNING
			}, this);
      	} else if ((rec.data.estado == 'borrador' && rec.data.tipo_obligacion != 'adquisiciones') && 
      				(rec.data['fecha_conformidad'] == '' || rec.data['fecha_conformidad'] == undefined || rec.data['fecha_conformidad'] == null)
      				&& (rec.data.tipo=='devengado'  || rec.data.tipo=='devengado_pagado' || rec.data.tipo=='devengado_pagado_1c')
      				&& this.maestro.uo_ex == 'no') {
      		Ext.Msg.show({
			   title:'Confirmación',
			   scope: this,
			   msg: 'Al solicitar el pago se generará una conformidad implícita bajo responsabilidad del funcionario solicitante. Desea Continuar?',
			   buttons: Ext.Msg.YESNO,
			   fn: function(id, value, opt) {			   		
			   		if (id == 'yes') {
			   			this.mostrarWizard(rec);
			   		} else {
			   			opt.hide;
			   		}
			   },	
			   animEl: 'elId',
			   icon: Ext.MessageBox.WARNING
			}, this);
      	
      	} else {
      		this.mostrarWizard(rec);
      	}
               
     },*/
     
     sigEstado : function() {
		var rec=this.sm.getSelected();
     	var configExtra = [];
     	//si el estado es vbfinanzas agregamos la opcion para selecionar el depto de Libro bancos
     	
      	this.objWizard = Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php',
                                'Estado de Wf',
                                {
                                    modal:true,
                                    width:700,
                                    height:450
                                }, {
                                	//configExtra: configExtra,
                                	data:{
                                       id_estado_wf:rec.data.id_estado_wf,
                                       id_proceso_wf:rec.data.id_proceso_wf
                                       //url_verificacion:'../../sis_tesoreria/control/Caja/siguienteEstadoCaja'                                                                         
                                    
                                    }}, this.idContenedor,'FormEstadoWf',
                                {
                                    config:[{
                                              event:'beforesave',
                                              delegate: this.onSaveWizard                                              
                                            }/*,
					                        {											
					                          event:'requirefields',
					                          delegate: function (wizard,mensaje) {
						                          	this.onButtonEdit();
													console.log(mensaje);
													console.log("entra");
						                          	
						                          	if (mensaje.indexOf("Fecha Inicio,Fecha Fin") != -1) {						                          		
						                          		this.Cmp.fecha_costo_ini.allowBlank = false;
						                          		this.Cmp.fecha_costo_fin.allowBlank = false;
						                          		this.form.getForm().isValid();						                          		
						                          	} else {
						                          		alert(mensaje);
						                          	}
						                          	
										        	this.window.setTitle('Registre los campos antes de pasar al siguiente estado');
										        	
													this.formulario_wizard = 'si';
					                          }
					                          
					                        }*/],
                                    
                                    scope:this
                                 });        
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
                //id_depto_lb:		resp.id_depto_lb,
                json_procesos:      Ext.util.JSON.encode(resp.procesos)
                },
            success:this.successWizard,
            failure: this.conexionFailure,
            argument:{wizard:wizard},
            timeout:this.timeout,
            scope:this
        });
    },
    /*    
    oncellclick : function(grid, rowIndex, columnIndex, e) {
		
	    var record = this.store.getAt(rowIndex),
	        fieldName = grid.getColumnModel().getDataIndex(columnIndex); // Get field name

	    if (fieldName == 'revisado_asistente' ) {
	    	this.loadPagosRelacionados()
	    		
	    } 
		
	},*/
    /*
    sistema: 'ADQ',
    id_cotizacion: 0,
    id_proceso_compra: 0,
    id_solicitud: 0,
    auxFuncion:'onBtnAdq'*/
    
    
};
</script>
