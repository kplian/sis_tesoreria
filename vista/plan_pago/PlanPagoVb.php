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
Phx.vista.PlanPagoVb = {
    bedit:true,
    bnew:false,
    bsave:false,
    bdel:false,
	require:'../../../sis_tesoreria/vista/plan_pago/PlanPago.php',
	requireclase:'Phx.vista.PlanPago',
	title:'Plan de Pagos',
	nombreVista: 'planpagoVb',
	
	constructor: function(config) {
	    
	   this.Atributos[this.getIndAtributo('numero_op')].grid=true; 
	   
	    this.Atributos[this.getIndAtributo('nro_cuota')].form=false; 
	    
	    this.Atributos[this.getIndAtributo('forma_pago')].form=true; 
	    this.Atributos[this.getIndAtributo('nro_cheque')].form=true; 
	    this.Atributos[this.getIndAtributo('nro_cuenta_bancaria')].form=true; 
	    this.Atributos[this.getIndAtributo('id_cuenta_bancaria')].form=true; 
	    
	    this.Atributos[this.getIndAtributo('id_cuenta_bancaria_mov')].form=true; 
	    
	    
	    
	    
	    
	    
       Phx.vista.PlanPagoVb.superclass.constructor.call(this,config);
        this.iniciarEventos();
       
       this.addButton('SolDevPag',{text:'Solicitar Devengado/Pago',iconCls: 'bpagar',disabled:true,handler:this.onBtnDevPag,tooltip: '<b>Solicitar Devengado/Pago</b><br/>Genera en cotabilidad el comprobante Correspondiente, devengado o pago  '});
        
       
       this.crearFormularioEstados();
       this.crearFomularioDepto()
       
       
       this.store.baseParams={tipo_interfaz:this.nombreVista};
       this.load({params:{start:0, limit:this.tam_pag}});
       
       
        
    },
    
    crearFomularioDepto:function(){
      
                this.cmpDeptoConta = new Ext.form.ComboBox({
                            xtype: 'combo',
                            name: 'id_depto_conta',
                            hiddenName: 'id_depto_conta',
                            fieldLabel: 'Depto. Conta.',
                            allowBlank: false,
                            emptyText:'Elija un Depto',
                            store:new Ext.data.JsonStore(
                            {
                                url: '../../sis_tesoreria/control/ObligacionPago/listarDeptoFiltradoObligacionPago',
                                id: 'id_depto',
                                root: 'datos',
                                sortInfo:{
                                    field: 'deppto.nombre',
                                    direction: 'ASC'
                                },
                                totalProperty: 'total',
                                fields: ['id_depto','nombre'],
                                // turn on remote sorting
                                remoteSort: true,
                                baseParams:{par_filtro:'deppto.nombre#deppto.codigo',estado:'activo',codigo_subsistema:'CONTA',tipo_filtro:'DEP_EP-DEP_EP'}
                            }),
                            valueField: 'id_depto',
                            displayField: 'nombre',
                            tpl:'<tpl for="."><div class="x-combo-list-item"><p>{nombre}</p></div></tpl>',
                            hiddenName: 'id_depto_tes',
                            forceSelection:true,
                            typeAhead: true,
                            triggerAction: 'all',
                            lazyRender:true,
                            mode:'remote',
                            pageSize:10,
                            queryDelay:1000,
                            width:250,
                            listWidth:'280',
                            minChars:2
                        });
                
                this.formDEPTO = new Ext.form.FormPanel({
                    baseCls: 'x-plain',
                    autoDestroy: true,
                    layout: 'form',
                    items: [this.cmpDeptoConta]
                });
                
               
                
                this.wDEPTO= new Ext.Window({
                    title: 'Depto Tesoreria',
                    collapsible: true,
                    maximizable: true,
                     autoDestroy: true,
                    width: 400,
                    height: 200,
                    layout: 'fit',
                    plain: true,
                    bodyStyle: 'padding:5px;',
                    buttonAlign: 'center',
                    items: this.formDEPTO,
                    modal:true,
                     closeAction: 'hide',
                    buttons: [{
                        text: 'Guardar',
                         handler:this.onSubmitDepto,
                        scope:this
                        
                    },{
                        text: 'Cancelar',
                        handler:function(){this.wDEPTO.hide()},
                        scope:this
                    }]
                });   
        
    },
    
   
   onButtonEdit:function(){
       
         var data = this.getSelectedData();
        
         
         if(data.tipo=='pagado'){
             
                this.Cmp.tipo_pago.disable();
                this.ocultarComponente(this.Cmp.tipo_pago);
                
                this.Cmp.tipo.disable();
                this.ocultarComponente(this.Cmp.tipo);
                
                this.Cmp.id_plantilla.disable();
                this.ocultarComponente(this.Cmp.id_plantilla);
                
                this.Cmp.nombre_pago.enable();
                this.mostrarComponente(this.Cmp.nombre_pago);
                
                /*this.Cmp.forma_pago.enable();
                this.mostrarComponente(this.Cmp.forma_pago);*/
                
                this.Cmp.id_cuenta_bancaria.enable()
                this.mostrarComponente(this.Cmp.id_cuenta_bancaria);
                this.habilitarDescuentos();
                
                this.Cmp.monto_no_pagado.disable();
                this.ocultarComponente(this.Cmp.monto_no_pagado);
                
                this.Cmp.obs_monto_no_pagado.disable();
                this.ocultarComponente(this.Cmp.obs_monto_no_pagado);
                
                this.Cmp.tipo_cambio.disable();
                this.ocultarComponente(this.Cmp.tipo_cambio);
                
                
         
         
         }
         else{
                this.mostrarComponente(this.Cmp.tipo_pago);
                this.Cmp.tipo.enable();
                
                this.mostrarComponente(this.Cmp.tipo);
               
                
                this.Cmp.id_plantilla.enable();
                this.mostrarComponente(this.Cmp.id_plantilla);
                
                this.Cmp.monto_no_pagado.enable();
                this.mostrarComponente(this.Cmp.monto_no_pagado);
                 
                this.Cmp.obs_monto_no_pagado.enable();
                this.mostrarComponente(this.Cmp.obs_monto_no_pagado);
                
                if(data.tipo_moneda=='base'){
                 
                   this.Cmp.tipo_cambio.disable();
                   this.ocultarComponente(this.Cmp.tipo_cambio);
                }
                else{
                    this.Cmp.tipo_cambio.enable();
                    this.mostrarComponente(this.Cmp.tipo_cambio);
                  
                }
                
         }
         
         if(data.tipo=='devengado'){
             this.enableDisable('devengado')
             
         }
         else{
            this.enableDisable('devengado_pagado') 
            //Verifica si habilita o no el cheque y la cuenta bancaria destino
            this.ocultarCheCue(data.forma_pago);
         }
         
       
           this.Cmp.fecha_tentativa.disable();
           this.Cmp.tipo.disable();
           this.Cmp.tipo_pago.disable(); 
           
            Phx.vista.PlanPagoVb.superclass.onButtonEdit.call(this);
           
       },
    
    
    
    onBtnDevPag:function()
        {                   
            var data = this.getSelectedData();
            
            console.log('depto_conta',data.id_depto_conta)
            if(data.id_depto_conta > 0){
           
                this.onSubmitDepto(undefined,undefined,data.id_depto_conta);  
            }
            else{
              
                this.wDEPTO.show();
                this.cmpDeptoConta.reset();
                this.cmpDeptoConta.store.baseParams.id_plan_pago = data.id_plan_pago;
                this.cmpDeptoConta.store.baseParams.id_obligacion_pago = data.id_obligacion_pago;
                this.cmpDeptoConta.modificado = true;
              
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
                    success:this.successSinc,
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
                })
            }
        
    }, 
    
    iniciarEventos:function(){
        
        this.Cmp.monto.on('change',this.calculaMontoPago,this); 
        //this.cmpDescuentoAnticipo.on('change',this.calculaMontoPago,this);
        this.Cmp.monto_no_pagado.on('change',this.calculaMontoPago,this);
        this.Cmp.otros_descuentos.on('change',this.calculaMontoPago,this);
        this.Cmp.monto_retgar_mo.on('change',this.calculaMontoPago,this);
        this.Cmp.descuento_ley.on('change',this.calculaMontoPago,this);
        
        this.Cmp.id_plantilla.on('select',function(cmb,rec,i){
            
            console.log(rec.data)
            this.getDecuentosPorAplicar(rec.data.id_plantilla);
            
        },this);
        
        this.Cmp.tipo.on('change',function(groupRadio,radio){
                                this.enableDisable(radio.inputValue);
                            },this); 
          
        
      /* this.cmpFechaDev.on('change',function(com,dat){
              
              if(this.maestro.tipo_moneda=='base'){
                 this.cmpTipoCambio.disable();
                 this.cmpTipoCambio.setValue(1); 
                  
              }
              else{
                   this.cmpTipoCambio.enable()
                 this.obtenerTipoCambio();  
              }
             
              
          },this);*/
         
       
       
       this.Cmp.tipo_pago.on('select',function(cmb,rec,i){
           if(rec.data.variable=='anticipo' || rec.data.variable=='adelanto'){
               this.Cmp.tipo.disable();
               this.ocultarComponente(this.Cmp.tipo);
               
               this.deshabilitarDescuentos();
               
               if(rec.data.variable=='anticipo'){
                   this.ocultarComponente(this.Cmp.monto_ejecutar_total_mo);
                   this.Cmp.id_plantilla.disable();
                   this.ocultarComponente(this.Cmp.id_plantilla);
               }
               else{
                   this.mostrarComponente(this.Cmp.monto_ejecutar_total_mo);
                   this.Cmp.id_plantilla.enable();
                   this.mostrarComponente(this.Cmp.id_plantilla);
                   
               }
               
           
           
           }
           else{
               this.Cmp.tipo.enable();
               this.mostrarComponente(this.Cmp.tipo);
               this.mostrarComponente(this.Cmp.monto_ejecutar_total_mo)
               this.habilitarDescuentos();
           }
           
           
       },this);
       
       //Evento para filtrar los depósitos a partir de la cuenta bancaria
        this.Cmp.id_cuenta_bancaria.on('select',function(data,rec,ind){
            this.Cmp.id_cuenta_bancaria_mov.setValue('');
            this.Cmp.id_cuenta_bancaria_mov.modificado=true;
            Ext.apply(this.Cmp.id_cuenta_bancaria_mov.store.baseParams,{id_cuenta_bancaria: rec.id});
        },this);
        
        //Evento para ocultar/motrar componentes por cheque o transferencia
        this.Cmp.forma_pago.on('change',function(groupRadio,radio){
            this.ocultarCheCue(radio.inputValue);
        },this);           
    
    }, 
    
    
    preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;
          Phx.vista.PlanPagoVb.superclass.preparaMenu.call(this,n); 
          if (data['estado']== 'borrador' || data['estado']== 'pendiente' || data['estado']== 'devengado' || data['estado']== 'pagado' ){
                  this.getBoton('ant_estado').disable();
                  this.getBoton('sig_estado').disable();
                  this.getBoton('SolDevPag').disable(); 
                  this.getBoton('edit').disable();   
          }
          else{
                   if (data['estado']== 'vbconta'){
                       this.getBoton('ant_estado').enable();
                       this.getBoton('sig_estado').disable();
                       this.getBoton('SolDevPag').enable();
                        this.getBoton('edit').enable(); 
                   }
                   else{
                       this.getBoton('ant_estado').enable();
                       this.getBoton('sig_estado').enable();
                       this.getBoton('SolDevPag').disable();
                       this.getBoton('edit').disable(); 
                     
                   }
                   
                   
           }
           this.getBoton('SolPlanPago').enable(); 
           
     },
    
    liberaMenu:function(){
        var tb = Phx.vista.PlanPagoVb.superclass.liberaMenu.call(this);
        
        if(tb){
           this.getBoton('ant_estado').disable();
           this.getBoton('sig_estado').disable();
           this.getBoton('SolDevPag').disable();
           this.getBoton('SolPlanPago').disable();
           
           
           
           
        }
       return tb
    }, 
    
    ocultarCheCue: function(pFormaPago){
        console.log('pFormaPago',pFormaPago)
        if(pFormaPago=='transferencia'){
            //Deshabilita campo cheque
            this.Cmp.nro_cheque.allowBlank=true;
            this.Cmp.nro_cheque.setValue('');
            this.Cmp.nro_cheque.disable();
           
            //Habilita nrocuenta bancaria destino
            this.Cmp.nro_cuenta_bancaria.allowBlank=false;
            this.Cmp.nro_cuenta_bancaria.enable();
        } else{
            
            //cheque
            //Habilita campo cheque
            this.Cmp.nro_cheque.allowBlank=false;
            this.Cmp.nro_cheque.enable();
            //Habilita nrocuenta bancaria destino
            this.Cmp.nro_cuenta_bancaria.allowBlank=true;
            this.Cmp.nro_cuenta_bancaria.setValue('');
            this.Cmp.nro_cuenta_bancaria.disable();
        }
        
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
