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
Phx.vista.PlanPagoRegIni = {
    
    bdel:true,
    bedit:true,
    bsave:false,
    
	require:'../../../sis_tesoreria/vista/plan_pago/PlanPago.php',
	requireclase:'Phx.vista.PlanPago',
	title:'Registro de Planes de Pago',
	nombreVista: 'PlanPagoRegIni',
	
	constructor: function(config) {
	    
	    this.maestro=config.maestro;
	    
       Phx.vista.PlanPagoRegIni.superclass.constructor.call(this,config);
       
       
        
        this.addButton('SincPresu',{text:'Inc. Pres.',iconCls: 'balert',disabled:true,handler:this.onBtnSincPresu,tooltip: '<b>Incrementar Presupuesto</b><br/> Incremeta el presupuesto exacto para proceder con el pago'});
        
        
        
        ////formulario de departamentos
        
        
        this.crearFormularioEstados();
        
       
        
        
        //si la interface es pestanha este código es para iniciar 
          var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
          if(dataPadre){
             this.onEnablePanel(this, dataPadre);
          }
          else
          {
             this.bloquearMenus();
          }
          
          this.addButton('btnVerifPresup', {
                text : 'Disponibilidad',
                iconCls : 'bassign',
                disabled : true,
                handler : this.onBtnVerifPresup,
                tooltip : '<b>Verificación de la disponibilidad presupuestaria</b>'
            });
       
         
         this.iniciarEventos();
         
        // this.store.baseParams={tipo_interfaz:this.nombreVista};
         //this.store.baseParams={tipo_interfaz:this.nombreVista};
         //this.load({params:{start:0, limit:this.tam_pag}}); 
       
         //this.store.baseParams={tipo_interfaz:this.nombreVista,tipo_interfaz:'vistobueno'};
      
        
    }, 
    
     
       
    
    
    
    iniciarEventos:function(){
        
        this.cmpObligacionPago=this.getComponente('id_obligacion_pago');
        this.cmpFechaTentativa=this.getComponente('fecha_tentativa');
      
        this.cmpTipoPago=this.getComponente('tipo_pago');
       
        this.cmpPlantilla=this.getComponente('id_plantilla');
        this.cmpNombrePago=this.getComponente('nombre_pago');
        this.cmpFormaPago=this.getComponente('forma_pago');
        this.cmpTipo=this.getComponente('tipo');
        this.cmpCuentaBancaria=this.getComponente('id_cuenta_bancaria');
        
        
        this.cmpMonto=this.getComponente('monto');
        //this.cmpDescuentoAnticipo=this.getComponente('descuento_anticipo');
        this.cmpMontoNoPagado=this.getComponente('monto_no_pagado');
        this.cmpOtrosDescuentos=this.getComponente('otros_descuentos');
        this.cmpLiquidoPagable=this.getComponente('liquido_pagable');
        this.cmpMontoEjecutarTotalMo=this.getComponente('monto_ejecutar_total_mo');
        
       // this.cmpObsDescuentoAnticipo=this.getComponente('obs_descuentos_anticipo');
        this.cmpObsMontoNoPagado=this.getComponente('obs_monto_no_pagado');
        this.cmpObsOtrosDescuentos=this.getComponente('obs_otros_descuentos');
       
       
        
        this.cmpMonto.on('change',this.calculaMontoPago,this); 
        //this.cmpDescuentoAnticipo.on('change',this.calculaMontoPago,this);
        this.cmpMontoNoPagado.on('change',this.calculaMontoPago,this);
        this.cmpOtrosDescuentos.on('change',this.calculaMontoPago,this);
        this.Cmp.monto_retgar_mo.on('change',this.calculaMontoPago,this);
        this.Cmp.descuento_ley.on('change',this.calculaMontoPago,this);
        
        this.Cmp.id_plantilla.on('select',function(cmb,rec,i){
            
            console.log(rec.data)
            this.getDecuentosPorAplicar(rec.data.id_plantilla);
            
        },this);
        
        this.cmpTipo.on('change',function(groupRadio,radio){
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
         
       
       
       this.cmpTipoPago.on('select',function(cmb,rec,i){
           if(rec.data.variable=='anticipo' || rec.data.variable=='adelanto'){
               this.cmpTipo.disable();
               this.ocultarComponente(this.cmpTipo);
               
               this.deshabilitarDescuentos();
               
               if(rec.data.variable=='anticipo'){
                   this.ocultarComponente(this.cmpMontoEjecutarTotalMo);
                   this.cmpPlantilla.disable();
                   this.ocultarComponente(this.cmpPlantilla);
               }
               else{
                   this.mostrarComponente(this.cmpMontoEjecutarTotalMo);
                   this.cmpPlantilla.enable();
                   this.mostrarComponente(this.cmpPlantilla);
                   
               }
               
           
           
           }
           else{
               this.cmpTipo.enable();
               this.mostrarComponente(this.cmpTipo);
               this.mostrarComponente(this.cmpMontoEjecutarTotalMo)
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
    
    onBtnSolPlanPago:function(){        
        var rec=this.sm.getSelected();
        Ext.Ajax.request({
            url:'../../sis_tesoreria/control/PlanPago/solicitudPlanPago',
            params:{'id_plan_pago':rec.data.id_plan_pago,id_obligacion_pago:this.maestro.id_obligacion_pago},
            success: this.successExport,
            failure: function() {
                console.log("fail");
            },
            timeout: function() {
                console.log("timeout");
            },
            scope:this
        });  
    },
    
    setTipoPagoNormal:function(){
        this.cmpTipo.enable();
       this.mostrarComponente(this.cmpTipo);
       this.mostrarComponente(this.cmpMontoEjecutarTotalMo)
       this.habilitarDescuentos();
        
    },
    
     successAplicarDesc:function(resp){
            Phx.CP.loadingHide();
           var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
                
               this.Cmp.porc_descuento_ley.setValue(reg.ROOT.datos.descuento_porc*1);
               this.Cmp.obs_descuentos_ley.setValue(reg.ROOT.datos.observaciones);
               
               this.calculaMontoPago();
               
              
             
             }else{
                alert(reg.ROOT.mensaje)
            }
     },
     
   
    calculaMontoPago:function(){
        
         var descuento_ley = this.cmpMonto.getValue()*this.Cmp.porc_descuento_ley.getValue();
         this.Cmp.descuento_ley.setValue(descuento_ley);
         var liquido = this.cmpMonto.getValue()  -  this.cmpMontoNoPagado.getValue() -  this.cmpOtrosDescuentos.getValue() - this.Cmp.monto_retgar_mo.getValue() -  this.Cmp.descuento_ley.getValue();
        
        
        this.cmpLiquidoPagable.setValue(liquido>0?liquido:0);
        var eje = this.cmpMonto.getValue()  -  this.cmpMontoNoPagado.getValue()
        this.cmpMontoEjecutarTotalMo.setValue(eje>0?eje:0);
     },
     
     enableDisable:function(val){
      if(val =='devengado'){
            
            //this.cmpPlantilla.enable();
            //this.ocultarComponente(this.cmpPlantilla);
            this.cmpNombrePago.disable();
            this.ocultarComponente(this.cmpNombrePago);
            this.cmpFormaPago.disable();
            this.ocultarComponente(this.cmpFormaPago);
            this.cmpFormaPago.disable();
            this.ocultarComponente(this.cmpFormaPago);
            this.cmpCuentaBancaria.disable()
            this.ocultarComponente(this.cmpCuentaBancaria);
            
           this.deshabilitarDescuentos()
            
        }
        else{
            //this.cmpPlantilla.enable();
            //this.mostrarComponente(this.cmpPlantilla);
            this.cmpNombrePago.enable();
            this.mostrarComponente(this.cmpNombrePago);
            this.cmpFormaPago.enable();
            this.mostrarComponente(this.cmpFormaPago);
            this.cmpFormaPago.enable();
            this.mostrarComponente(this.cmpFormaPago);
            this.cmpCuentaBancaria.enable()
            this.mostrarComponente(this.cmpCuentaBancaria);
            
            this.habilitarDescuentos();
            
         }
          this.cmpMontoNoPagado.setValue(0);
          this.cmpOtrosDescuentos.setValue(0);
          this.cmpLiquidoPagable.setValue(0);
          this.cmpMontoEjecutarTotalMo.setValue(0);
          this.Cmp.monto_retgar_mo.setValue(0);
          this.Cmp.descuento_ley.setValue(0)
          this.calculaMontoPago()
         
     },
     
    habilitarDescuentos:function(){
        //this.cmpDescuentoAnticipo.enable();
        //this.mostrarComponente(this.cmpDescuentoAnticipo);
        this.cmpOtrosDescuentos.enable();
        this.mostrarComponente(this.cmpOtrosDescuentos);
        
        //calcular retenciones segun documento
        
        this.mostrarComponente(this.Cmp.descuento_ley);
        
        this.Cmp.monto_retgar_mo.enable();
        this.mostrarComponente(this.Cmp.monto_retgar_mo);
        
        
        
        //this.cmpObsDescuentoAnticipo.enable();
        //this.mostrarComponente(this.cmpObsDescuentoAnticipo);
        this.cmpObsOtrosDescuentos.enable();
        this.mostrarComponente(this.cmpObsOtrosDescuentos);
        
        this.mostrarComponente(this.Cmp.obs_descuentos_ley);
        
    } ,
     deshabilitarDescuentos:function(){
       // this.cmpDescuentoAnticipo.disable();
       // this.ocultarComponente(this.cmpDescuentoAnticipo);
        this.cmpOtrosDescuentos.disable();
        this.ocultarComponente(this.cmpOtrosDescuentos);
        
        this.Cmp.monto_retgar_mo.disable();
        this.ocultarComponente(this.Cmp.monto_retgar_mo);
        
        this.ocultarComponente(this.Cmp.descuento_ley);
        
        
         
        //this.cmpObsDescuentoAnticipo.disable();
        //this.ocultarComponente(this.cmpObsDescuentoAnticipo);
        this.cmpObsOtrosDescuentos.disable();
        this.ocultarComponente(this.cmpObsOtrosDescuentos);
        
         this.ocultarComponente(this.Cmp.obs_descuentos_ley);
            
        
    } ,
    
    
    onButtonNew:function(){
        
         var data = this.getSelectedData();
         if(data){
                console.log('data..',data)
             // para habilitar registros de cuotas de pago    
                if(data.monto_ejecutar_total_mo*1  > data.total_pagado*1  && data.estado =='devengado'){
                    Phx.vista.PlanPagoRegIni.superclass.onButtonNew.call(this); 
                    this.cmpObligacionPago.setValue(this.maestro.id_obligacion_pago);
                    this.Cmp.id_plan_pago_fk.setValue(data.id_plan_pago);
                    
                  
                    this.cmpTipoPago.disable();
                    this.ocultarComponente(this.cmpTipoPago);
                    
                    this.cmpTipo.disable();
                    this.ocultarComponente(this.cmpTipo);
                    
                    this.cmpPlantilla.disable();
                    this.ocultarComponente(this.cmpPlantilla);
                    
                    this.cmpNombrePago.enable();
                    this.mostrarComponente(this.cmpNombrePago);
                    this.cmpFormaPago.enable();
                    this.mostrarComponente(this.cmpFormaPago);
                    this.cmpFormaPago.enable();
                    this.mostrarComponente(this.cmpFormaPago);
                    this.cmpCuentaBancaria.enable()
                    this.mostrarComponente(this.cmpCuentaBancaria);
                    this.habilitarDescuentos();
                    
                    this.cmpMontoNoPagado.disable();
                    this.ocultarComponente(this.cmpMontoNoPagado);
                    this.cmpObsMontoNoPagado.disable();
                    this.ocultarComponente(this.cmpObsMontoNoPagado);
                    
                    this.obtenerFaltante('registrado_pagado',data.id_plan_pago);
                    this.Cmp.tipo_cambio.setValue(0);
                    this.Cmp.tipo_cambio.disable();
                    this.ocultarComponente(this.Cmp.tipo_cambio);
                    //calculo de descuentos por documento
                    this.getDecuentosPorAplicar(data.id_plantilla);
                    
                    //TODO ....
                    //Verifica si habilita o no el cheque y la cuenta bancaria destino
                    this.ocultarCheCue(data.forma_pago);
                    
    
                }
                else{
                    if(data.estado!='devengado'){
                        
                        alert('El devengado no fue completado');
                    }
                    else{
                        alert('No queda nada por pagar');
                    }
                
                }
            
             
         }
         else{
             
              console.log('data..',data)
              
              
           //para habilitar registros de cuota de devengado  
                Phx.vista.PlanPagoRegIni.superclass.onButtonNew.call(this); 
                this.cmpObligacionPago.setValue(this.maestro.id_obligacion_pago);
                 this.mostrarComponente(this.cmpTipoPago);
               if(this.maestro.nro_cuota_vigente ==0){
                    this.cmpTipoPago.setValue('normal');
                    this.cmpTipoPago.enable();
                }
                else{
                     this.cmpTipoPago.setValue('normal');
                      this.cmpTipoPago.disable();
                }
                this.setTipoPagoNormal();
               
                this.cmpTipo.enable();
                this.mostrarComponente(this.cmpTipo);
                this.cmpPlantilla.enable();
                this.mostrarComponente(this.cmpPlantilla);
                this.cmpMontoNoPagado.enable();
                this.mostrarComponente(this.cmpMontoNoPagado);
                this.cmpObsMontoNoPagado.enable();
                this.mostrarComponente(this.cmpObsMontoNoPagado);
                this.obtenerFaltante('registrado');
                if(this.maestro.tipo_moneda=='base'){
                   this.Cmp.tipo_cambio.setValue(1);  
                   this.Cmp.tipo_cambio.disable();
                   this.ocultarComponente(this.Cmp.tipo_cambio);
                }
                else{
                    this.Cmp.tipo_cambio.enable();
                    this.mostrarComponente(this.Cmp.tipo_cambio);
                    this.Cmp.tipo_cambio.setValue(this.maestro.tipo_cambio_conv);  
                }
       
              
                
           }
          
            this.cmpFechaTentativa.minValue=new Date();
            this.cmpFechaTentativa.setValue(new Date());
            this.cmpNombrePago.setValue(this.maestro.desc_proveedor);
            this.cmpMonto.setValue(0);
           // this.cmpDescuentoAnticipo.setValue(0);
            this.cmpMontoNoPagado.setValue(0);
            this.cmpOtrosDescuentos.setValue(0);
            this.cmpLiquidoPagable.setValue(0);
            this.cmpMontoEjecutarTotalMo.setValue(0);
            this.Cmp.monto_retgar_mo.setValue(0);
            this.cmpLiquidoPagable.disable();
            this.cmpMontoEjecutarTotalMo.disable();
            
            //calcular el descuento segun el documento
            this.Cmp.descuento_ley.setValue(0);
            
            
      },
     
      onButtonEdit:function(){
       
         var data = this.getSelectedData();
        
         Phx.vista.PlanPagoRegIni.superclass.onButtonEdit.call(this); 
         if(data.tipo=='pagado'){
             
                this.cmpTipoPago.disable();
                this.ocultarComponente(this.cmpTipoPago);
                
                this.cmpTipo.disable();
                this.ocultarComponente(this.cmpTipo);
                
                this.cmpPlantilla.disable();
                this.ocultarComponente(this.cmpPlantilla);
                
                this.cmpNombrePago.enable();
                this.mostrarComponente(this.cmpNombrePago);
                this.cmpFormaPago.enable();
                this.mostrarComponente(this.cmpFormaPago);
                this.cmpFormaPago.enable();
                this.mostrarComponente(this.cmpFormaPago);
                this.cmpCuentaBancaria.enable()
                this.mostrarComponente(this.cmpCuentaBancaria);
                this.habilitarDescuentos();
                
                this.cmpMontoNoPagado.disable();
                this.ocultarComponente(this.cmpMontoNoPagado);
                this.cmpObsMontoNoPagado.disable();
                this.ocultarComponente(this.cmpObsMontoNoPagado);
                this.Cmp.tipo_cambio.disable();
                this.ocultarComponente(this.Cmp.tipo_cambio);
         
         
         }
         else{
                this.mostrarComponente(this.cmpTipoPago);
                this.cmpTipo.enable();
                this.mostrarComponente(this.cmpTipo);
               
                
                this.cmpPlantilla.enable();
                this.mostrarComponente(this.cmpPlantilla);
                
                this.cmpMontoNoPagado.enable();
                this.mostrarComponente(this.cmpMontoNoPagado);
                 
                this.cmpObsMontoNoPagado.enable();
                this.mostrarComponente(this.cmpObsMontoNoPagado);
                if(this.maestro.tipo_moneda=='base'){
                 
                   this.Cmp.tipo_cambio.disable();
                   this.ocultarComponente(this.Cmp.tipo_cambio);
                }
                else{
                    this.Cmp.tipo_cambio.enable();
                    this.mostrarComponente(this.Cmp.tipo_cambio);
                  
                }
                
         }
       
           this.cmpFechaTentativa.disable();
           this.cmpTipo.disable();
           this.cmpTipoPago.disable(); 
           
            //Verifica si habilita o no el cheque y la cuenta bancaria destino
            this.ocultarCheCue(data.forma_pago);
           
       },
    
    obtenerFaltante:function(_filtro,_id_plan_pago){
        
       Phx.CP.loadingShow();
          Ext.Ajax.request({
                    // form:this.form.getForm().getEl(),
                    url:'../../sis_tesoreria/control/ObligacionPago/obtenerFaltante',
                    params:{ope_filtro:_filtro, 
                            id_obligacion_pago: this.maestro.id_obligacion_pago,
                            id_plan_pago:_id_plan_pago},
                    success:this.successOF,
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
             });
    },
    
     successOF:function(resp){
       Phx.CP.loadingHide();
        var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
                if(reg.ROOT.datos.monto_total_faltante > 0){
                    this.cmpMonto.setValue(reg.ROOT.datos.monto_total_faltante);
                }
                else{
                    this.cmpMonto.setValue(0);
                }
               this.calculaMontoPago();
            }else{
                
                alert('error al obtener saldo por registrar')
            } 
    },
    
    onReloadPage:function(m){
        this.maestro=m;
        this.store.baseParams={id_obligacion_pago:this.maestro.id_obligacion_pago,tipo_interfaz:this.nombreVista};
      
        
        
        this.load({params:{start:0, limit:this.tam_pag}})
        this.Cmp.tipo_cambio.setValue(1);  
    },
    
    successSave: function(resp) {
       Phx.CP.getPagina(this.idContenedorPadre).reload();  
       Phx.vista.PlanPagoRegIni.superclass.successSave.call(this,resp);
        
        
    },
    successDel:function(resp){
       Phx.CP.getPagina(this.idContenedorPadre).reload(); 
       Phx.vista.PlanPagoRegIni.superclass.successDel.call(this,resp);
     },
     
      preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;
          this.getBoton('ant_estado').disable();
          this.getBoton('sig_estado').disable();
          Phx.vista.PlanPagoRegIni.superclass.preparaMenu.call(this,n); 
          if (data['estado']== 'borrador'){
              this.getBoton('edit').enable();
              this.getBoton('del').enable(); 
            
              this.getBoton('new').disable(); 
              this.getBoton('SolPlanPago').enable(); 
              this.getBoton('sig_estado').enable();   
          }
          else{
            if (data['estado']== 'devengado'  && (data.monto_ejecutar_total_mo*1)  > (data.total_pagado*1) ){ 
                this.getBoton('new').enable();
                console.log('habilita new')
            }
            else{
                this.getBoton('new').disable(); 
                 console.log('deshabilita new')
            }
             this.getBoton('edit').disable();
             this.getBoton('del').disable();
            
             
                this.getBoton('SolPlanPago').enable(); 
          }
          
          if(data['sinc_presupuesto']=='si'){
               this.getBoton('SincPresu').enable();
          }
          else{
               this.getBoton('SincPresu').disable();
          }
          this.getBoton('btnVerifPresup').enable();
     },
     
      liberaMenu:function(){
        var tb = Phx.vista.PlanPagoRegIni.superclass.liberaMenu.call(this);
        if(tb){
          
           this.getBoton('SincPresu').disable();
           this.getBoton('SolPlanPago').disable();
           this.getBoton('btnVerifPresup').disable();
           this.getBoton('ant_estado').disable();
           this.getBoton('sig_estado').disable();  
          }
       return tb
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

  
    ocultarCheCue: function(pFormaPago){
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
    onBtnVerifPresup : function() {
        var rec = this.sm.getSelected();
        Phx.CP.loadWindows('../../../sis_tesoreria/vista/plan_pago/PlanPagoVerifPresup.php', 'Disponibilidad Presupuestaria', {
            modal : true,
            width : '80%',
            height : '50%',
        }, rec.data, this.idContenedor, 'PlanPagoVerifPresup');
    } ,
    
    east:{
          url:'../../../sis_tesoreria/vista/prorrateo/Prorrateo.php',
          title:'Prorrateo', 
          width:400,
          cls:'Prorrateo'
     },
    
    
    
};
</script>
