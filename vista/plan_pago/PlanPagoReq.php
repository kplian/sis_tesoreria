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
Phx.vista.PlanPagoReq = {
    
    bdel:true,
    bedit:true,
    bsave:false,
    
	require:'../../../sis_tesoreria/vista/plan_pago/PlanPago.php',
	requireclase:'Phx.vista.PlanPago',
	title:'Registro de Planes de Pago',
	nombreVista: 'planpagoReq',
	
	constructor: function(config) {
	    
	    this.Atributos[this.getIndAtributo('numero_op')].grid=true; 
       
        this.Atributos[this.getIndAtributo('nro_cuota')].form=false; 
        
        this.Atributos[this.getIndAtributo('forma_pago')].form=true; 
        this.Atributos[this.getIndAtributo('nro_cheque')].form=true; 
        this.Atributos[this.getIndAtributo('nro_cuenta_bancaria')].form=true; 
        this.Atributos[this.getIndAtributo('id_cuenta_bancaria')].form=true; 
        
        this.Atributos[this.getIndAtributo('id_cuenta_bancaria_mov')].form=true; 
        
	    
	    this.maestro=config.maestro;
	    
        Phx.vista.PlanPagoReq.superclass.constructor.call(this,config);
       
       
        
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
    
   
    
    setTipoPagoNormal:function(){
        this.Cmp.tipo.enable();
       this.mostrarComponente(this.Cmp.tipo);
       this.mostrarComponente(this.Cmp.monto_ejecutar_total_mo)
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
     
   
    
     
     
    
    
    onButtonNew:function(){
        
         var data = this.getSelectedData();
         if(data){
                console.log('data..',data)
             // para habilitar registros de cuotas de pago    
                if(data.monto_ejecutar_total_mo*1  > data.total_pagado*1  && data.estado =='devengado'){
                    Phx.vista.PlanPagoReq.superclass.onButtonNew.call(this); 
                    this.Cmp.id_obligacion_pago.setValue(this.maestro.id_obligacion_pago);
                    this.Cmp.id_plan_pago_fk.setValue(data.id_plan_pago);
                    
                  
                    this.Cmp.tipo_pago.disable();
                    this.ocultarComponente(this.Cmp.tipo_pago);
                    
                    this.Cmp.tipo.disable();
                    this.ocultarComponente(this.Cmp.tipo);
                    
                    this.Cmp.id_plantilla.disable();
                    this.ocultarComponente(this.Cmp.id_plantilla);
                    
                    this.Cmp.nombre_pago.enable();
                    this.mostrarComponente(this.Cmp.nombre_pago);
                    this.Cmp.forma_pago.enable();
                    this.mostrarComponente(this.Cmp.forma_pago);
                 
                    this.Cmp.id_cuenta_bancaria.enable()
                    this.mostrarComponente(this.Cmp.id_cuenta_bancaria);
                    this.habilitarDescuentos();
                    
                    this.Cmp.monto_no_pagado.disable();
                    this.ocultarComponente(this.Cmp.monto_no_pagado);
                    this.Cmp.obs_monto_no_pagado.disable();
                    this.ocultarComponente(this.Cmp.obs_monto_no_pagado);
                    
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
                Phx.vista.PlanPagoReq.superclass.onButtonNew.call(this); 
                this.Cmp.id_obligacion_pago.setValue(this.maestro.id_obligacion_pago);
                 this.mostrarComponente(this.Cmp.tipo_pago);
               
               if(this.maestro.nro_cuota_vigente ==0){
                    this.Cmp.tipo_pago.setValue('normal');
                    this.Cmp.tipo_pago.enable();
                }
                else{
                     this.Cmp.tipo_pago.setValue('normal');
                      this.Cmp.tipo_pago.disable();
                }
                this.setTipoPagoNormal();
               
                
                this.Cmp.tipo.enable();
                this.mostrarComponente(this.Cmp.tipo);
                
                
                this.Cmp.id_plantilla.enable();
                this.mostrarComponente(this.Cmp.id_plantilla);
                this.Cmp.monto_no_pagado.enable();
                this.mostrarComponente(this.Cmp.monto_no_pagado);
                this.Cmp.obs_monto_no_pagado.enable();
                this.mostrarComponente(this.Cmp.obs_monto_no_pagado);
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
          
            this.Cmp.fecha_tentativa.minValue=new Date();
            this.Cmp.fecha_tentativa.setValue(new Date());
            this.Cmp.nombre_pago.setValue(this.maestro.desc_proveedor);
            this.Cmp.monto.setValue(0);
           // this.cmpDescuentoAnticipo.setValue(0);
            this.Cmp.monto_no_pagado.setValue(0);
            this.Cmp.otros_descuentos.setValue(0);
            this.Cmp.liquido_pagable.setValue(0);
            this.Cmp.monto_ejecutar_total_mo.setValue(0);
            this.Cmp.monto_retgar_mo.setValue(0);
            this.Cmp.liquido_pagable.disable();
            this.Cmp.monto_ejecutar_total_mo.disable();
            
            //calcular el descuento segun el documento
            this.Cmp.descuento_ley.setValue(0);
            
            
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
                if(this.maestro.tipo_moneda=='base'){
                 
                   this.Cmp.tipo_cambio.disable();
                   this.ocultarComponente(this.Cmp.tipo_cambio);
                }
                else{
                    this.Cmp.tipo_cambio.enable();
                    this.mostrarComponente(this.Cmp.tipo_cambio);
                  
                }
                
         }
       
           this.Cmp.fecha_tentativa.disable();
           this.Cmp.tipo.disable();
           this.Cmp.tipo_pago.disable(); 
           
           
            
            if(data.tipo=='devengado'){
                this.enableDisable('devengado')
             
            }
            else{
                this.enableDisable('devengado_pagado') 
                //Verifica si habilita o no el cheque y la cuenta bancaria destino
                this.ocultarCheCue(data.forma_pago);  
                
            }
            
            
                
            Phx.vista.PlanPagoReq.superclass.onButtonEdit.call(this);
            
           
            
           
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
                    this.Cmp.monto.setValue(reg.ROOT.datos.monto_total_faltante);
                }
                else{
                    this.Cmp.monto.setValue(0);
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
       Phx.vista.PlanPagoReq.superclass.successSave.call(this,resp);
        
        
    },
    successDel:function(resp){
       Phx.CP.getPagina(this.idContenedorPadre).reload(); 
       Phx.vista.PlanPagoReq.superclass.successDel.call(this,resp);
     },
     
      preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;
          this.getBoton('ant_estado').disable();
          this.getBoton('sig_estado').disable();
          Phx.vista.PlanPagoReq.superclass.preparaMenu.call(this,n); 
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
        var tb = Phx.vista.PlanPagoReq.superclass.liberaMenu.call(this);
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
        //Se define el nombre de la columna de la llave primaria
        rec.data.tabla_id = this.tabla_id;
        rec.data.tabla = this.tabla;
        
        Phx.CP.loadWindows('../../../sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 'Disponibilidad Presupuestaria', {
            modal : true,
            width : '80%',
            height : '50%',
        }, rec.data, this.idContenedor, 'VerificacionPresup');
    },
    
    east:{
          url:'../../../sis_tesoreria/vista/prorrateo/Prorrateo.php',
          title:'Prorrateo', 
          width:400,
          cls:'Prorrateo'
    },

	tabla_id: 'id_plan_pago',
	tabla:'tes.tplan_pago'    

};
</script>
