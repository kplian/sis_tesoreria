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
Phx.vista.PlanPagoVbAsistente = {
    bedit:true,
    bnew:false,
    bsave:false,
    bdel:false,
    //checkGrid:true,
    require:'../../../sis_tesoreria/vista/plan_pago/PlanPago.php',
    requireclase:'Phx.vista.PlanPago',
    title:'Plan de Pagos',
    nombreVista: 'PlanPagoVbAsistente',
    
    constructor: function(config) {
        
       this.Atributos[this.getIndAtributo('num_tramite')].grid=true;
       this.Atributos[this.getIndAtributo('desc_moneda')].grid=true;
       this.Atributos[this.getIndAtributo('numero_op')].grid=true;
       this.Atributos[this.getIndAtributo('revisado_asistente')].grid=true; 
       
       
       //funcionalidad para listado de historicos
       this.historico = 'no';
       this.tbarItems = [{
            text: 'Histórico',
            enableToggle: true,
            pressed: false,
            toggleHandler: function(btn, pressed) {
               
                if(pressed){
                    this.historico = 'si';
                   
                }
                else{
                   this.historico = 'no' 
                }
                
                this.store.baseParams.historico = this.historico;
                this.reload();
             },
            scope: this
        }];
        
        
       Phx.vista.PlanPagoVbAsistente.superclass.constructor.call(this,config);
       
       this.iniciarEventos();
       this.addButton('btnRev', {
                text : 'Revisado',
                iconCls : 'bball_green',
                disabled : true,
                handler : this.cambiarRev,
                tooltip : '<b>Revisado</b><br/>Sirve como un indicador de que la documentacion fue revisada por el asistente'
        });
       this.addButton('diagrama_gantt',{text:'Gant',iconCls: 'bgantt',disabled:true,handler:diagramGantt,tooltip: '<b>Diagrama Gantt de proceso macro</b>'});
  
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
        
       
      
       //RAC: Se agrega menú de reportes de adquisiciones
       this.addBotones();
       this.store.baseParams={tipo_interfaz:this.nombreVista};
       if(config.filtro_directo){
           this.store.baseParams.filtro_valor = config.filtro_directo.valor;
           this.store.baseParams.filtro_campo = config.filtro_directo.campo;
       }
       
       this.load({params:{
           start:0, 
           limit:this.tam_pag
        }});
       
    },
   
   cambiarRev:function(){
	    Phx.CP.loadingShow();
	    var d = this.sm.getSelected().data;
        Ext.Ajax.request({
            url:'../../sis_tesoreria/control/PlanPago/marcarRevisadoPlanPago',
            params:{id_plan_pago:d.id_plan_pago},
            success:this.successRev,
            failure: this.conexionFailure,
            timeout:this.timeout,
            scope:this
        }); 
	    
	},
	successRev:function(resp){
       Phx.CP.loadingHide();
       var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
       if(!reg.ROOT.error){
         this.reload();
       }
    },
	
    
   preparaMenu:function(n){
   	  Phx.vista.PlanPagoVbAsistente.superclass.preparaMenu.call(this,n);
   	  this.getBoton('edit').disable(); 
   	  this.getBoton('diagrama_gantt').enable();
      this.getBoton('btnChequeoDocumentosWf').enable();
      
      var data = this.getSelectedData();
        if(data['revisado_asistente']== 'si'){
            this.getBoton('btnRev').setIconClass('bball_white')
        }
        else{
            this.getBoton('btnRev').setIconClass('bball_green')
        }
       this.getBoton('btnRev').enable();
       this.getBoton('btnObs').enable();   
   },
   
   liberaMenu:function(){
        var tb = Phx.vista.PlanPagoVbAsistente.superclass.liberaMenu.call(this);
        this.getBoton('diagrama_gantt').disable();
        this.getBoton('btnChequeoDocumentosWf').disable();
        this.getBoton('btnRev').disable();
        this.getBoton('btnObs').disable();   
        
    
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
    },
    
    //funciones adiconales para boton de reportes
    
    addBotones: function() {
        this.menuAdq = new Ext.Toolbar.SplitButton({
          
            id:'btn-docsol-' + this.idContenedor,
            text: 'Documentos',
            tooltip: '<b>Documentos anexos a la solicitud de compra</b>',
            handler:this.onBtnDocSol,
            scope: this,
            disabled: true,
            menu:{
            items: [{
                id:'btn-cot-' + this.idContenedor,
                text: 'Cotización',
                tooltip: '<b>Reporte de la Cotización</b>',
                handler:this.onBtnCot,
                scope: this
            }, {
                id:'btn-proc-' + this.idContenedor,
                text: 'Cuadro Comparativo',
                tooltip: '<b>Reporte de Cuadro Comparativo</b>',
                handler:this.onBtnProc,
                scope: this
            }, {
                id:'btn-sol-' + this.idContenedor,
                text: 'Solicitud de Compra',
                tooltip: '<b>Reporte de la Solicitud de Compra</b>',
                handler:this.onBtnSol,
                scope: this
            },
             {
                id: 'btn-adq-' + this.idContenedor,
                text: 'Orden de Compra',
                tooltip: '<b>Orden de Compra</b>',
                handler:this.onBtnAdq,
                scope: this
            }
        ]}
        });
        
        //Adiciona el menú a la barra de herramientas
        this.tbar.add(this.menuAdq);
    },
    
    onBtnAdq: function(){
        Phx.CP.loadingShow();
        var rec = this.sm.getSelected();
        var data = rec.data;
        if(data){
            //Obtiene los IDS
            this.auxFuncion='onBtnAdq';
            this.obtenerIDS(data);
        } else {
            alert('Seleccione un registro y vuelta a intentarlo');
        }
    },
    
    onBtnCot: function(){
        Phx.CP.loadingShow();
        var rec = this.sm.getSelected();
        var data = rec.data;
        if(data){
            //Obtiene los IDS
            this.auxFuncion='onBtnCot';
            this.obtenerIDS(data);
        } else {
            alert('Seleccione un registro y vuelta a intentarlo');
        }
    },
    
    onBtnSol: function(){
        Phx.CP.loadingShow();
        var rec = this.sm.getSelected();
        var data = rec.data;
        if(data){
            //Obtiene los IDS
            this.auxFuncion='onBtnSol';
            this.obtenerIDS(data);
        } else {
            alert('Seleccione un registro y vuelta a intentarlo');
        }
    },
    
    onBtnDocSol: function(){
        Phx.CP.loadingShow();
        var rec = this.sm.getSelected();
        var data = rec.data;
        if(data){
            //Obtiene los IDS
            this.auxFuncion='onBtnDocSol';
            this.obtenerIDS(data);
        } else {
            alert('Seleccione un registro y vuelta a intentarlo');
        }
    },
    
    
    onBtnProc: function(){
        Phx.CP.loadingShow();
        var rec = this.sm.getSelected();
        var data = rec.data;
        if(data){
            //Obtiene los IDS
            this.auxFuncion='onBtnProc';
            this.obtenerIDS(data);
        } else {
            alert('Seleccione un registro y vuelta a intentarlo');
        }
    },
    
    obtenerIDS: function(data){
        Ext.Ajax.request({
            url: '../../sis_tesoreria/control/ObligacionPago/obtenerIdsExternos',
            params: {
                id_obligacion_pago: data.id_obligacion_pago,
                sistema: this.sistema
            },
            success: this.successobtenerIDS,
            failure: this.conexionFailure,
            timeout: this.timeout,
            scope: this
        });
    },
    successobtenerIDS: function(resp) {
        Phx.CP.loadingHide();
        var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
        if (!reg.ROOT.error) {
            //Setea los valores a variables locales
            var ids=reg.ROOT.datos;
            this.id_cotizacion = ids.id_cotizacion,
            this.id_proceso_compra = ids.id_proceso_compra,
            this.id_solicitud = ids.id_solicitud
            
            //Genera el reporte en función del botón presionado
            if(this.auxFuncion=='onBtnAdq'){
                Ext.Ajax.request({
                    url:'../../sis_adquisiciones/control/Cotizacion/reporteOC',
                    params:{'id_cotizacion':this.id_cotizacion},
                    success: this.successExport,
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
                });
                
            } else if(this.auxFuncion=='onBtnCot'){
                Ext.Ajax.request({
                    url:'../../sis_adquisiciones/control/Cotizacion/reporteCotizacion',
                    params:{'id_cotizacion':this.id_cotizacion,tipo:'cotizado'},
                    success: this.successExport,
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
                });  
                
            } else if(this.auxFuncion=='onBtnSol'){
                Ext.Ajax.request({
                    url:'../../sis_adquisiciones/control/Solicitud/reporteSolicitud',
                    params:{'id_solicitud':this.id_solicitud},
                    success: this.successExport,
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
                });  
                
            } else if(this.auxFuncion=='onBtnProc'){
                Ext.Ajax.request({
                     url:'../../sis_adquisiciones/control/ProcesoCompra/cuadroComparativo',
                     params:{id_proceso_compra:this.id_proceso_compra},
                     success: this.successExport,
                     failure: this.conexionFailure,
                     scope:this
                 });
                 
                 
            } else if(this.auxFuncion=='onBtnDocSol'){   
                
                Phx.CP.loadWindows('../../../sis_adquisiciones/vista/documento_sol/ChequeoDocumentoSol.php',
                            'Chequeo de documentos de la solicitud',
                            {
                                width:700,
                                height:450
                            },
                            {'id_solicitud':this.id_solicitud},  
                            this.idContenedor,
                            'ChequeoDocumentoSol')  
                 
            } else{
                alert('Reporte no reconocido');
            }

        } else {

            alert('ocurrio un error durante el proceso')
        }

    },
    
    sistema: 'ADQ',
    id_cotizacion: 0,
    id_proceso_compra: 0,
    id_solicitud: 0,
    auxFuncion:'onBtnAdq'
    
    
};
</script>
