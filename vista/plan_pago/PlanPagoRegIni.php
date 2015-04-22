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
	    //this.creaFormularioConformidad();
        ////formulario de departamentos
        //this.crearFormularioEstados();
        //si la interface es pestanha este código es para iniciar 
          var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
          if(dataPadre){
             this.onEnablePanel(this, dataPadre);
          }
          else
          {
             this.bloquearMenus();
          }
          
          //this.addButton('btnConformidad',{text:'Conformidad',iconCls: 'bok',disabled:true,handler:this.onButtonConformidad,tooltip: 'Generar conformidad para el pago (Firma acta de conformidad)'});
          /*this.addButton('btnVerifPresup', {
                text : 'Disponibilidad',
                iconCls : 'bassign',
                
                disabled : true,
                handler : this.onBtnVerifPresup,
                tooltip : '<b>Verificación de la disponibilidad presupuestaria</b>'
            });*/
            
                    
         
         this.iniciarEventos();
         //escode boton para mandar a borrador 
          this.getBoton('ini_estado').hide();  
        
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
        
       
        //evento para definir los tipos de pago
        this.Cmp.tipo.on('select',function(cmb,rec,i){
        	 var data = this.getSelectedData();
             //segun el tipo define los campo visibles y no visibles
             this.setTipoPago[rec.data.variable](this,data);
             this.unblockGroup(1);
             this.window.doLayout();
             
             if(this.accionFormulario == 'NEW'){
               
                 if(rec.data.variable == 'devengado'||
                    rec.data.variable =='devengado_pagado'||
                    rec.data.variable =='devengado_pagado_1c'||
                    rec.data.variable =='rendicion'||
                    rec.data.variable =='anticipo'){
                    this.obtenerFaltante('registrado,ant_parcial_descontado');
                 }
                 
                
                 if(rec.data.variable == 'ant_parcial'){
                     this.obtenerFaltante('ant_parcial');
                 }
                 
                 if(rec.data.variable == 'dev_garantia'){
                     this.obtenerFaltante('dev_garantia');
                 }
              }
              if (this.accionFormulario == 'NEW_PAGO' || this.accionFormulario == 'NEW' || this.accionFormulario ==  'NEW_ANT_APLI'){
              	if(rec.data.variable == 'pagado'){
                     this.iniciaPagoDelDevengado(data);
                 }
                 
                 if(rec.data.variable == 'ant_aplicado'){
                    this.iniciaAplicacion(data);
                 }
              }
        },this);
        
        
        this.Cmp.monto_ajuste_ag.on('change',function(cmp, newValue, oldValue){
        	
        	if(newValue > this.Cmp.monto_ejecutar_total_mo.getValue()){
        		cmp.setValue(oldValue);
        	}
        	
        },this);
       
    },
    
    onBtnSolPlanPago:function(){        
        var rec=this.sm.getSelected();
        Ext.Ajax.request({
            url:'../../sis_tesoreria/control/PlanPago/solicitudPlanPago',
            params:{'id_plan_pago':rec.data.id_plan_pago,id_obligacion_pago:this.maestro.id_obligacion_pago},
            success: this.successExport,
            failure: function() {
                //console.log("fail");
            },
            timeout: function() {
                //console.log("timeout");  
            },
            scope:this
        });  
    },
    
    setTipoPagoNormal:function(){
      
       this.mostrarComponente(this.Cmp.monto_ejecutar_total_mo)
       this.habilitarDescuentos();
        
    },
    
    
     
     enableDisable:function(val){
          //devengado
      
          this.Cmp.nombre_pago.disable();
          this.ocultarComponente(this.Cmp.nombre_pago);
            
          //pago 
            
          this.deshabilitarDescuentos()
          this.Cmp.nombre_pago.enable();
          this.mostrarComponente(this.Cmp.nombre_pago);
          this.habilitarDescuentos();
            
        
          this.Cmp.monto_no_pagado.setValue(0);
          this.Cmp.otros_descuentos.setValue(0);
          this.Cmp.liquido_pagable.setValue(0);
          this.Cmp.monto_ejecutar_total_mo.setValue(0);
          this.Cmp.monto_retgar_mo.setValue(0);
          this.Cmp.descuento_ley.setValue(0)
          this.calculaMontoPago()
         
     },
     
    iniciaAplicacion:function(data){
    	    //carga la plantilla con el mismo documento que el devengado
    	    var me = this;
            this.Cmp.id_plantilla.store.load({
                 params:{start:0,limit:1,id_plantilla:data.id_plantilla},
                 callback:function(){
                     me.Cmp.id_plantilla.setValue(data.id_plantilla);
                     me.Cmp.id_plantilla.modificado = true;
                     me.getDecuentosPorAplicar(data.id_plantilla);
                 }  
              });
                
             
            this.inicioValores();
            this.tmp_porc_monto_excento_var = data.porc_monto_excento_var;
            //obtiene el monto de apgo que falta registrar
            //y el monto de anticpo parcial que falta por descontar
            if(data.pago_variable == 'si'){
            	this.obtenerFaltante('ant_aplicado_descontado_op_variable',data.id_plan_pago);	
            }
            else{
                this.obtenerFaltante('ant_aplicado_descontado',data.id_plan_pago);	
            }
    },
    iniciaPagoDelDevengado:function(data){
    	//carga la plantilla con el mismo documento que el devengado
	    var me = this;
	    this.Cmp.id_plantilla.store.load({
	         params:{start:0, limit:1, id_plantilla: data.id_plantilla},
	         callback:function(){
	             me.Cmp.id_plantilla.setValue(data.id_plantilla);
	             me.Cmp.id_plantilla.modificado = true;
	             me.getDecuentosPorAplicar(data.id_plantilla);
	         }  
	      });
	        
	     
	    this.inicioValores();
	    
	    //calcula el porcentaje de retencio de garantia si en el 
	    //devengado es mayor a cero, se utiliza en la funcion calculaMontoPago
	    this.Cmp.porc_monto_retgar.setValue(data.porc_monto_retgar);
	    this.porc_ret_gar =  data.porc_monto_retgar;
	    this.tmp_porc_monto_excento_var = data.porc_monto_excento_var;
	    
	    //obtiene el monto de apgo que falta registrar
	    //y el monto de anticpo parcial que falta por descontar
	    this.obtenerFaltante('registrado_pagado,ant_parcial_descontado',data.id_plan_pago);
    },
    
    onButtonNew:function(){
        
             this.porc_ret_gar = 0; //resetea valor por defecto de retencion de garantia
             var data = this.getSelectedData();
             this.ocultarGrupo(2); //ocultar el grupo de ajustes
             
             //variables temporales
             this.tmp_porc_monto_excento_var = undefined;
             if(data){
                   
                    // para habilitar registros de cuotas de pago 
                    //sobre los devengados
                    Phx.vista.PlanPagoRegIni.superclass.onButtonNew.call(this); 
                    this.Cmp.tipo.enable();
                    this.blockGroup(1)//bloqueaos el grupo , detalle de pago
                    this.Cmp.id_obligacion_pago.setValue(this.maestro.id_obligacion_pago);
                    this.Cmp.id_plan_pago_fk.setValue(data.id_plan_pago);
                       
                    if( data.tipo == 'devengado'||data.tipo == 'devengado_pagado'){
                        //
                        this.accionFormulario = 'NEW_PAGO';  //esta bandera modifica el ,  obtenerFaltante
                        if(data.estado =='devengado'){
                           if(data.monto*1  > data.total_pagado*1){
                                
                                this.Cmp.tipo.store.loadData(this.arrayStore.DEVENGAR);
                                
                                
                                
                           }else{
                             alert('No queda nada por pagar');
                          } 
                        }
                        else{
                           alert('El devengado no fue completado'); 
                        }
                        
                    }
                    else{
                        if(data.tipo == 'anticipo'){
                            this.accionFormulario = 'NEW_ANT_APLI';
                            
                            if(data.monto*1  > data.total_pagado*1  && data.estado =='anticipado'){
                                
                                this.Cmp.tipo.store.loadData(this.arrayStore.ANTICIPO);
                                
                                
                            }
                        }
                    }
              }
             else{
                    this.accionFormulario = 'NEW';  
                   //para habilitar registros de cuota de devengado  
                   Phx.vista.PlanPagoRegIni.superclass.onButtonNew.call(this); 
                   this.Cmp.tipo.enable();
                   this.Cmp.id_obligacion_pago.setValue(this.maestro.id_obligacion_pago);
                   this.blockGroup(1)//bloqueaos el grupo , detalle de pago
                   //tipo pago (OPERACION)
                   
                   if(this.maestro.nro_cuota_vigente == 0 && this.maestro.tipo_anticipo == 'si'){
                       //prepara pagos de enticipo
                       this.Cmp.tipo.store.loadData(this.arrayStore.ANT_PARCIAL)
                       
                   }
                   else{
                       
                       //prepara pagos iniciales
                       this.Cmp.tipo.store.loadData(this.arrayStore.INICIAL)
                       
                   }
                   
                   this.inicioValores()
           }     
              
      },
     
     onButtonEdit:function(){
         Phx.vista.PlanPagoRegIni.superclass.onButtonEdit.call(this); 
         
                       
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
                    
                    
                    //si se trata de un nuevo pago
                    if(this.accionFormulario == 'NEW_PAGO'){
                        this.Cmp.monto_retgar_mo.setValue(this.porc_ret_gar*reg.ROOT.datos.monto_total_faltante);
                        
                    }
                    
                    if (this.tmp_porc_monto_excento_var > 0 ){
                    	this.Cmp.monto_excento.setValue(reg.ROOT.datos.monto_total_faltante*this.tmp_porc_monto_excento_var);
                    }
                    
                    
                    if(this.Cmp.tipo.getValue()=='devengado_pagado'||this.Cmp.tipo.getValue()=='devengado_pagado_1c'||this.Cmp.tipo.getValue()=='pagado'){
                        //si es un pago calculamos el descuento de anticipo
                        this.Cmp.descuento_anticipo.setValue(reg.ROOT.datos.ant_parcial_descontado);
                        this.Cmp.descuento_anticipo.maxValue=reg.ROOT.datos.ant_parcial_descontado;
                    }
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
          
          //alert('pasa el constructor ....')
          
          //alert(data['estado'])
          
          if (data['estado'] == 'borrador'){
              this.getBoton('edit').enable();
              
              this.getBoton('del').enable(); 
              this.getBoton('new').disable(); 
              this.getBoton('SolPlanPago').enable(); 
              this.getBoton('sig_estado').enable();   
          }
          else{
          	
          	//alert('lega ......')
          	
          	
            if ((data['tipo'] == 'devengado'||data['tipo']== 'devengado_pagado') && data['estado']== 'devengado'&& (data.monto*1)  > (data.total_pagado*1) ){ 
                this.getBoton('new').enable();
            }
            else{
                this.getBoton('new').disable();
            }
            
            if(data['estado']== 'anticipado' && data['tipo']== 'anticipo'&& (data.monto*1)  > (data.total_pagado*1)){
                this.getBoton('new').enable();
            }
             
             this.getBoton('edit').disable();
             this.getBoton('del').disable();
             this.getBoton('SolPlanPago').enable(); 
          }
          
          if(data['sinc_presupuesto']=='si'&& (data['estado']== 'vbconta'||data['estado']== 'borrador')){
               this.getBoton('SincPresu').enable();
          }
          else{
               this.getBoton('SincPresu').disable();
          }
          
         
          //if (data['fecha_conformidad'] == '' || data['fecha_conformidad'] == undefined || data['fecha_conformidad'] == null) {
         	//this.getBoton('btnConformidad').enable();
         //} else {
         	//this.getBoton('btnConformidad').disable();
         //}
          
         // this.getBoton('btnVerifPresup').enable();
          this.getBoton('btnChequeoDocumentosWf').enable();  
     },
     
    liberaMenu:function(){
        var tb = Phx.vista.PlanPagoRegIni.superclass.liberaMenu.call(this);
        if(tb){          
           this.getBoton('SincPresu').disable();
           this.getBoton('SolPlanPago').disable();
           //this.getBoton('btnVerifPresup').disable();
           this.getBoton('ant_estado').disable();
           this.getBoton('sig_estado').disable();
         
           //this.getBoton('btnConformidad').disable();
           this.getBoton('btnChequeoDocumentosWf').disable();   
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

  
    onBtnVerifPresup : function() {
        var rec = this.sm.getSelected();
        //Se define el nombre de la columna de la llave primaria
        rec.tabla_id = this.tabla_id;
        rec.tabla = this.tabla;
        
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
	tabla: 'tes.tplan_pago' 
};
</script>