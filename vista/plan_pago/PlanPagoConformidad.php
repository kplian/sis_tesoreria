<?php
/**
*@package pXP
*@file gen-SistemaDist.phpt
*@author  (fprudencio)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite 
*dar el visto a solicitudes de compra
*
*/
header("content-type: text/javascript; charset=UTF-8"); 
?>
<script>
Phx.vista.PlanPagoConformidad = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
    beditGroups: [],
    bdelGroups:  [],
    bactGroups:  [0,1],
    btestGroups: [],
    bexcelGroups: [0,1],
    require:'../../../sis_tesoreria/vista/plan_pago/PlanPago.php',
    requireclase:'Phx.vista.PlanPago',
    title:'Plan de Pagos',
    nombreVista: 'PlanPagoConformidad',
    gruposBarraTareas:[{name:'pendiente',title:'<H1 align="center"><i class="fa fa-thumbs-o-down"></i>Actas sin firma</h1>',grupo:0,height:0},
                       {name:'realizada',title:'<H1 align="center"><i class="fa fa-eye"></i>Actas con firma</h1>',grupo:1,height:0}],
	
	actualizarSegunTab: function(name, indice){
    	if(this.finCons){
    		if (name=='pendiente') {
    			this.store.baseParams.tipo_interfaz='planpagoconformidadpendiente';
    		} else {
    			this.store.baseParams.tipo_interfaz='planpagoconformidadrealizada';
    		}
    		 
    	     this.load({params:{start:0, limit:this.tam_pag}});
    	   }
    },
    constructor: function(config) {
        
       this.Atributos[this.getIndAtributo('num_tramite')].grid=true;
       this.Atributos[this.getIndAtributo('desc_moneda')].grid=true;
       this.Atributos[this.getIndAtributo('revisado_asistente')].grid=true; 
       
       this.Atributos[this.getIndAtributo('numero_op')].grid=true; 
       this.Atributos[this.getIndAtributo('nro_cuota')].form=false; 
       this.Atributos[this.getIndAtributo('forma_pago')].form=true; 
       this.Atributos[this.getIndAtributo('nro_cheque')].form=true; 
       this.Atributos[this.getIndAtributo('nro_cheque')].valorInicial=0;
       this.Atributos[this.getIndAtributo('nro_cuenta_bancaria')].form=true; 
       this.Atributos[this.getIndAtributo('id_depto_lb')].form=true; 
       this.Atributos[this.getIndAtributo('id_cuenta_bancaria')].form=true; 
       this.Atributos[this.getIndAtributo('id_cuenta_bancaria_mov')].form=true; 
       
       this.Atributos[this.getIndAtributo('num_tramite')].bottom_filter=true;
       this.Atributos[this.getIndAtributo('nombre_pago')].bottom_filter=true;
       this.Atributos[this.getIndAtributo('desc_funcionario1')].bottom_filter=true;
        
       Phx.vista.PlanPagoConformidad.superclass.constructor.call(this,config);
       this.creaFormularioConformidad();
       this.iniciarEventos();
       this.addButton('btnConformidad',{text:'Conformidad',grupo:[0,1],iconCls: 'bok',disabled:true,handler:this.onButtonConformidad,tooltip: 'Generar conformidad para el pago (Firma acta de conformidad)'});
       this.addButton('diagrama_gantt',{text:'Gantt',grupo:[0,1],iconCls: 'bgantt',disabled:true,handler:diagramGantt,tooltip: '<b>Diagrama Gantt de proceso macro</b>'});
  
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
               
                   
       
       
       this.store.baseParams.tipo_interfaz='planpagoconformidadpendiente';
              
       this.load({params:{
           start:0, 
           limit:this.tam_pag
        }});
        this.finCons = true;
       
    },
    iniciarEventos:function(){
        
    }, 
    
    
    preparaMenu:function(n){
         var data = this.getSelectedData();
         var tb =this.tbar;
         Phx.vista.PlanPagoConformidad.superclass.preparaMenu.call(this,n); 
         this.getBoton('diagrama_gantt').enable();
        
         if (data.tipo=='devengado'  || data.tipo=='devengado_pagado' || data.tipo=='devengado_pagado_1c') {
         	this.getBoton('btnConformidad').enable();
         } else {
         	this.getBoton('btnConformidad').disable();
         }
         this.getBoton('btnChequeoDocumentosWf').enable();
         this.getBoton('btnPagoRel').enable(); 
           
     },
    
    liberaMenu:function(){
        var tb = Phx.vista.PlanPagoConformidad.superclass.liberaMenu.call(this);
        
        if(tb){
           this.getBoton('ant_estado').disable();
           this.getBoton('ini_estado').disable();
           this.getBoton('sig_estado').disable();           
           this.getBoton('diagrama_gantt').disable();
           this.getBoton('btnChequeoDocumentosWf').disable(); 
           this.getBoton('btnPagoRel').disable();          
           this.getBoton('btnConformidad').disable();
        }
       return tb
    },     
    south:{
          url:'../../../sis_tesoreria/vista/prorrateo/Prorrateo.php',
          title:'Prorrateo', 
          height:'40%',
          cls:'Prorrateo'
     },
    sortInfo:{
        field: 'numero_op',
        direction: 'ASC'
    }
};
</script>
