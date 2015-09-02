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
Phx.vista.PlanPagoVbCostos = {
    bedit:true,
    bnew:false,
    bsave:false,
    bdel:false,
    require:'../../../sis_tesoreria/vista/plan_pago/PlanPago.php',
    requireclase:'Phx.vista.PlanPago',
    title:'Plan de Pagos',
    nombreVista: 'planpagoVb',
    
    gruposBarraTareas:[{name:'nacional',title:'<H1 align="center"><i class="fa fa-paper-plane"></i> Nacionales</h1>',grupo:0,height:0},
                       {name:'internacional',title:'<H1 align="center"><i class="fa fa-paper-plane-o"></i> Internacionales</h1>',grupo:1,height:0}],
	
	
    
    actualizarSegunTab: function(name, indice){
    	if(this.finCons){
    		 this.store.baseParams.pes_estado = name;
    	     this.load({params:{start:0, limit:this.tam_pag}});
    	   }
    },
    beditGroups: [0,1],
    bdelGroups:   [0,1],
    bactGroups:  [0,1],
    btestGroups:  [0,1],
    bexcelGroups: [0,1],
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
      
       
       
        
       //funcionalidad para listado de historicos
       this.historico = 'no';
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
        
        
        
        
       Phx.vista.PlanPagoVbCostos.superclass.constructor.call(this,config);
       this.creaFormularioConformidad();
       this.iniciarEventos();
       this.addButton('btnConformidad',{ grupo:[0,1], text:'Conformidad',iconCls: 'bok',disabled:true,handler:this.onButtonConformidad,tooltip: 'Generar conformidad para el pago (Firma acta de conformidad)'});
       this.addButton('SolDevPag',{ grupo:[0,1], text:'Generar Cbte',iconCls: 'bpagar',disabled:true,handler:this.onBtnDevPag,tooltip: '<b>Solicitar Devengado/Pago</b><br/>Genera en cotabilidad el comprobante Correspondiente'});
       this.addButton('ModAprop',{ grupo:[0,1], text:'Modificar Apropiación',iconCls: 'bengine',disabled:true,handler:this.onBtnApropiacion,tooltip: 'Modificar la apropiación (solo cuando es el primer pago de un pago directo y el estado es vbconta)'});
       this.addButton('diagrama_gantt',{ grupo:[0,1], text:'Gantt',iconCls: 'bgantt',disabled:true,handler:diagramGantt,tooltip: '<b>Diagrama Gantt de proceso macro</b>'});
  
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
               
                   
       //this.crearFormularioEstados();
       this.crearFomularioDepto()
       //RAC: Se agrega menú de reportes de adquisiciones
       this.addBotones();
       this.store.baseParams={tipo_interfaz:this.nombreVista};
       if(config.filtro_directo){
           this.store.baseParams.filtro_valor = config.filtro_directo.valor;
           this.store.baseParams.filtro_campo = config.filtro_directo.campo;
       }
       this.store.baseParams.pes_estado = 'nacional';
       this.load({params:{
           start:0, 
           limit:this.tam_pag
        }});
        
        this.finCons = true;
       
    },
    //deshabilitas botones para informacion historica
    desBotoneshistorico:function(){
          this.getBoton('ant_estado').disable();
          this.getBoton('ini_estado').disable();          
          this.getBoton('sig_estado').disable();
          this.getBoton('SolDevPag').disable(); 
          this.getBoton('edit').disable(); 
          this.getBoton('SincPresu').disable();
          
     }, 
    
    
   onBtnApropiacion : function() {
    	var rec = {maestro: this.sm.getSelected().data};
						      
            Phx.CP.loadWindows('../../../sis_tesoreria/vista/obligacion_pago/ObligacionPagoApropiacion.php',
                    'Cambio de Apropiación',
                    {
                        width:800,
                        height:'90%'
                    },
                    rec,
                    this.idContenedor,
                    'ObligacionPagoApropiacion');
    },
   onButtonEdit:function(){
         var data = this.getSelectedData();
         if (data.estado == 'vbfin') {
         	this.Cmp.id_cuenta_bancaria.allowBlank = true;
         } else {
         	this.Cmp.id_cuenta_bancaria.allowBlank = false;
         }
         
         Phx.vista.PlanPagoVbCostos.superclass.onButtonEdit.call(this);
         
         if(this.Cmp.id_depto_lb.getValue() > 0){
             this.Cmp.id_cuenta_bancaria.store.baseParams = Ext.apply(this.Cmp.id_cuenta_bancaria.store.baseParams,{ id_depto_lb:this.Cmp.id_depto_lb.getValue(), permiso: 'todos'});
             this.Cmp.id_cuenta_bancaria.modificado = true;
         }
                
         //RCM, resetea store del deposito para no mostrar datos al hacer nuevo
         if(this.Cmp.id_cuenta_bancaria.getValue() > 0){
             this.Cmp.id_cuenta_bancaria_mov.store.baseParams= Ext.apply(this.Cmp.id_cuenta_bancaria_mov.store.baseParams,{ id_cuenta_bancaria:-1,
                                                                fecha:this.Cmp.fecha_tentativa.getValue()});
         }
         else{
            //RCM, resetea store del deposito para no mostrar datos al hacer nuevo
            this.Cmp.id_cuenta_bancaria_mov.store.baseParams=Ext.apply(this.Cmp.id_cuenta_bancaria_mov.store.baseParams, {id_cuenta_bancaria:-1,fecha:this.Cmp.fecha_tentativa.getValue()});
         }
          
         if(data.estado == 'vbsolicitante' || data.estado == 'vbfin' ||data.estado == 'vbdeposito'   || (data.estado == 'vbcostos' && data['prioridad_lp']!= 3)){
               this.Cmp.fecha_tentativa.disable();               
               this.Cmp.forma_pago.disable();
               this.Cmp.nombre_pago.disable();
               this.Cmp.nro_cheque.disable();
               this.Cmp.nro_cuenta_bancaria.disable();               
               this.Cmp.monto_no_pagado.disable();
               
               if(data.estado == 'vbfin' ||data.estado == 'vbdeposito'){
                	this.Cmp.id_depto_lb.enable();
                	this.Cmp.monto_retgar_mo.disable();
                	this.Cmp.id_plantilla.disable();
               }
               else{
                	this.Cmp.id_depto_lb.disable();
                	this.Cmp.monto_retgar_mo.enable();
                	this.Cmp.id_plantilla.enable();
               }
              
               this.Cmp.id_cuenta_bancaria.disable();
               this.Cmp.id_cuenta_bancaria_mov.disable();
               this.Cmp.obs_monto_no_pagado.disable();
               this.Cmp.obs_descuentos_ley.disable();
          }
         
     },
    
    
    
   
      
    
    
    onSubmitDepto:function(x,y,id_depto_conta){
           var data = this.getSelectedData();
          
           if(this.formDEPTO.getForm().isValid() || id_depto_conta){
                Phx.CP.loadingShow();
               Ext.Ajax.request({
                    // form:this.form.getForm().getEl(),
                    url:'../../sis_tesoreria/control/PlanPago/solicitarDevPag',
                    params:{ id_plan_pago:data.id_plan_pago, 
                             id_depto_conta:id_depto_conta?id_depto_conta:this.cmpDeptoConta.getValue()},
                    success:this.successSincGC,
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
                })
            }
        
    }, 
    
    successSincGC:function(resp){
            Phx.CP.loadingHide();
            this.wDEPTO.hide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(reg.ROOT.datos.resultado!='falla'){
                
                this.reload();
             }else{
                alert(reg.ROOT.datos.mensaje)
            }
     },
    
    getDecuentosPorAplicar:function(id_plantilla){
        var data = this.getSelectedData();
           Phx.CP.loadingShow();
           
           Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url:'../../sis_contabilidad/control/PlantillaCalculo/recuperarDescuentosPlantillaCalculo',
                params:{id_plantilla:id_plantilla},
                success:this.successAplicarDesc,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });
     },
     
     
    
    iniciarEventos:function(){
        
        this.Cmp.monto.on('change',this.calculaMontoPago,this); 
        this.Cmp.descuento_anticipo.on('change',this.calculaMontoPago,this);
        this.Cmp.monto_no_pagado.on('change',this.calculaMontoPago,this);
        this.Cmp.otros_descuentos.on('change',this.calculaMontoPago,this);
        this.Cmp.monto_retgar_mo.on('change',this.calculaMontoPago,this);
        this.Cmp.descuento_ley.on('change',this.calculaMontoPago,this);
        this.Cmp.descuento_inter_serv.on('change',this.calculaMontoPago,this);
        this.Cmp.monto_anticipo.on('change',this.calculaMontoPago,this);
        this.Cmp.monto_excento.on('change',this.calculaMontoPago,this);
        
        this.Cmp.id_plantilla.on('select',function(cmb,rec,i){
            this.getDecuentosPorAplicar(rec.data.id_plantilla);
            this.Cmp.monto_excento.reset();
            if(rec.data.sw_monto_excento=='si'){
               this.Cmp.monto_excento.enable();
            }
            else{
               this.Cmp.monto_excento.disable();
            }
            
        },this);
        
        this.Cmp.tipo.on('change',function(groupRadio,radio){
                                this.enableDisable(radio.inputValue);
                            },this); 
                            
                            
        //Eventos
       /* this.Cmp.id_cuenta_bancaria.on('select',function(a,b,c){
            this.Cmp.id_cuenta_bancaria_mov.setValue('');
            this.Cmp.id_cuenta_bancaria_mov.store.baseParams.id_cuenta_bancaria = this.Cmp.id_cuenta_bancaria.getValue();
            Ext.apply(this.Cmp.id_cuenta_bancaria_mov.store.baseParams,{id_cuenta_bancaria: this.Cmp.id_cuenta_bancaria.getValue()})
            this.Cmp.id_cuenta_bancaria_mov.modificado=true;
        },this);
       */
            
        this.Cmp.fecha_tentativa.on('blur',function(a){
            this.Cmp.id_cuenta_bancaria_mov.setValue('');
            Ext.apply(this.Cmp.id_cuenta_bancaria_mov.store.baseParams,{fecha: this.Cmp.fecha_tentativa.getValue()})
            this.Cmp.id_cuenta_bancaria_mov.modificado=true;
        },this); 
         
        
        
       this.Cmp.id_depto_lb.on('select',function(a,b,c){
            this.Cmp.id_cuenta_bancaria.setValue('');
            this.Cmp.id_cuenta_bancaria.store.baseParams.id_depto_lb = this.Cmp.id_depto_lb.getValue();
			this.Cmp.id_cuenta_bancaria.store.baseParams.permiso = 'todos';
            this.Cmp.id_cuenta_bancaria.modificado=true;
        },this);
        
       //Evento para filtrar los depósitos a partir de la cuenta bancaria
        this.Cmp.id_cuenta_bancaria.on('select',function(data,rec,ind){
            
            if(rec.data.centro=='no'){
                this.Cmp.id_cuenta_bancaria_mov.allowBlank= false;
                
            }
            else{
               this.Cmp.id_cuenta_bancaria_mov.allowBlank = true;
            }
            this.Cmp.id_cuenta_bancaria_mov.setValue('');
            this.Cmp.id_cuenta_bancaria_mov.modificado=true;
            Ext.apply(this.Cmp.id_cuenta_bancaria_mov.store.baseParams,{id_cuenta_bancaria: rec.id});
        },this);
        
        //Evento para ocultar/motrar componentes por cheque o transferencia
        this.Cmp.forma_pago.on('change',function(groupRadio,radio){
            this.ocultarCheCue(this,radio.inputValue);
        },this);   
        
                
    
    }, 
    
    
    preparaMenu:function(n){
         var data = this.getSelectedData();
         var tb =this.tbar;
         Phx.vista.PlanPagoVbCostos.superclass.preparaMenu.call(this,n); 
         if(this.historico == 'no'){    
          	  
              if (data['estado']== 'borrador' || data['estado']== 'pendiente' || data['estado']== 'devengado' || data['estado']== 'pagado'|| data['estado']== 'anticipado'|| data['estado']== 'aplicado'|| data['estado']== 'devuelto' ){
                      this.getBoton('ant_estado').disable();
                      this.getBoton('ini_estado').disable();
                      this.getBoton('sig_estado').disable();
                      this.getBoton('SolDevPag').disable(); 
                      this.getBoton('edit').disable();
                      this.getBoton('ModAprop').disable();    
              }
              else{
                       if (data['estado']== 'vbconta'){
                           this.getBoton('ant_estado').enable();
                           this.getBoton('ini_estado').enable();
                           this.getBoton('sig_estado').disable();
                           this.getBoton('SolDevPag').enable();
                           this.getBoton('edit').enable();
                           if (data['nro_cuota']== 1.00 && data['tipo_obligacion']== 'pago_directo') {
                           		this.getBoton('ModAprop').enable();                           		
                           } else {
                           		this.getBoton('ModAprop').disable(); 
                           }
                       }
                       else{
                       	
                       	   if(data['estado']== 'vbcostos'){
                       	   	  
	                       	   this.getBoton('ant_estado').enable();
	                           this.getBoton('ini_estado').enable();
	                           //si la prioridad de lb es internacional ...  3 interancional, 2 nacional 0 central
	                           if(data['prioridad_lp']== 3){
	                               this.getBoton('sig_estado').disable();
		                           this.getBoton('SolDevPag').enable();
	                           }
	                           else{
	                           	   this.getBoton('sig_estado').enable();
		                           this.getBoton('SolDevPag').disable();
	                           }
	                           this.getBoton('edit').enable();
	                           if (data['nro_cuota']== 1.00 && data['tipo_obligacion']== 'pago_directo') {
	                           		this.getBoton('ModAprop').enable();                           		
	                           } else {
	                           		this.getBoton('ModAprop').disable(); 
	                           }
                       	   
                       	   }
                       	   else{
                       	   	this.getBoton('ant_estado').enable();
                            this.getBoton('ini_estado').enable();
                            this.getBoton('sig_estado').enable();
                            this.getBoton('SolDevPag').disable();
                           
	                           if (data['estado']== 'vbsolicitante' || data['estado'] == 'vbdeposito' || data['estado'] == 'vbfin'){
	                              this.getBoton('edit').enable();
	                           }
	                           else{
	                              this.getBoton('edit').disable();  
	                           }
                       	   }
                       	
                       	
                           
                       }
               }
               this.getBoton('SolPlanPago').enable(); 
              
               if(data['sinc_presupuesto']=='si' && (data['estado'] == 'vbconta' || data['estado'] == 'vbcostos')){
                    this.getBoton('SincPresu').enable();
               }
               else{
                    this.getBoton('SincPresu').disable();
               }
               
         } 
         else{
            this.desBotoneshistorico();
         } 
         
         this.menuAdq.enable();
         this.getBoton('diagrama_gantt').enable();
        
         if (data.tipo=='devengado'  || data.tipo=='devengado_pagado' || data.tipo=='devengado_pagado_1c') {
         	this.getBoton('btnConformidad').enable();
         } else {
         	this.getBoton('btnConformidad').disable();
         }
         this.getBoton('btnChequeoDocumentosWf').enable();
         this.getBoton('btnPagoRel').enable(); 
         this.getBoton('btnObs').enable();
           
     },
    
    liberaMenu:function(){
        var tb = Phx.vista.PlanPagoVbCostos.superclass.liberaMenu.call(this);
        
        if(tb){
           this.getBoton('ant_estado').disable();
           this.getBoton('ini_estado').disable();
           this.getBoton('sig_estado').disable();
           this.getBoton('SolDevPag').disable();
           this.getBoton('SolPlanPago').disable();
           this.getBoton('diagrama_gantt').disable();
           this.getBoton('btnChequeoDocumentosWf').disable();
           this.getBoton('btnPagoRel').disable(); 
           this.getBoton('SincPresu').disable();          
           this.getBoton('ModAprop').disable(); 
           this.getBoton('btnObs').disable();
           this.getBoton('btnConformidad').disable();
           this.menuAdq.disable();
           
           
           
           
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
