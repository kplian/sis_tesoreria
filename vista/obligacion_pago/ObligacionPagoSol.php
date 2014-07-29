<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (rarteaga)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite 
*dar el visto a solicitudes de compra
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ObligacionPagoSol = {
    require:'../../../sis_tesoreria/vista/obligacion_pago/ObligacionPago.php',
	requireclase:'Phx.vista.ObligacionPago',
	title:'Obligacion de Pago (Solicitudes individuales)',
	nombreVista: 'obligacionPagoSol',
	ActList:'../../sis_tesoreria/control/ObligacionPago/listarObligacionPagoSol',
	
	/*
	 *  Interface heredada para solicitantes individuales
	 *  de tesoreria
	 * */
	
	constructor: function(config) {
	   
	  
	   this.Atributos[this.getIndAtributo('id_depto')].config.url= '../../sis_parametros/control/Depto/listarDeptoFiltradoXUsuario';
       this.Atributos[this.getIndAtributo('id_depto')].config.baseParams={estado:'activo',codigo_subsistema:'TES'},
       this.Atributos[this.getIndAtributo('id_funcionario')].grid= true;
       this.Atributos[this.getIndAtributo('id_funcionario')].form= true;
       
       
       Phx.vista.ObligacionPagoSol.superclass.constructor.call(this,config);
    },
    
        
     tabsouth:[
            { 
                 url:'../../../sis_tesoreria/vista/obligacion_det/ObligacionDet.php',
                 title:'Detalle', 
                 height:'50%',
                 cls:'ObligacionDet'
            },
            {
                  //carga la interface de registro inicial  
                  url:'../../../sis_tesoreria/vista/plan_pago/PlanPagoRegIni.php',
                  title:'Plan de Pagos (Reg. Adq.)', 
                  height:'50%',
                  cls:'PlanPagoRegIni'
            }
    
       ],
       
       iniciarEventos:function(){
            this.cmpProveedor = this.getComponente('id_proveedor');
            this.cmpFuncionario = this.getComponente('id_funcionario');
            this.cmpFuncionarioProveedor = this.getComponente('funcionario_proveedor');
            this.cmpFecha=this.getComponente('fecha');
            this.cmpTipoObligacion=this.getComponente('tipo_obligacion');
            this.cmpMoneda=this.getComponente('id_moneda');
            this.cmpDepto=this.getComponente('id_depto');
            this.cmpTipoCambioConv=this.getComponente('tipo_cambio_conv');
            
           
            this.cmpFecha.on('change',function(f){
                 Phx.CP.loadingShow();
                 this.cmpFuncionario.reset();
                 this.cmpFuncionario.enable();             
                 this.cmpFuncionario.store.baseParams.fecha = this.cmpFecha.getValue().dateFormat(this.cmpFecha.format);
                 
                 this.cmpFuncionario.store.load({params:{start:0,limit:this.tam_pag}, 
                       callback : function (r) {
                            Phx.CP.loadingHide();                        
                            if (r.length == 1 ) {                        
                                this.cmpFuncionario.setValue(r[0].data.id_funcionario);
                            }     
                                            
                        }, scope : this
                    });
                 
                 
             },this);
             
            
            
            this.ocultarComponente(this.cmpProveedor);
            this.mostrarComponente(this.cmpFuncionario);
            this.ocultarComponente(this.cmpFuncionarioProveedor);
            
             this.cmpMoneda.on('select',function(com,dat){
                  
                  if(dat.data.tipo_moneda=='base'){
                     this.cmpTipoCambioConv.disable();
                     this.cmpTipoCambioConv.setValue(1); 
                      
                  }
                  else{
                       this.cmpTipoCambioConv.enable()
                     this.obtenerTipoCambio();  
                  }
                 
                  
              },this);
            
            this.cmpTipoObligacion.on('select',function(c,rec,ind){
                    
                    n=rec.data.variable;
                    
                    if(n=='adquisiciones' ||n=='pago_directo'){
                        this.cmpProveedor.enable();
                        this.mostrarComponente(this.cmpProveedor);
                        this.mostrarComponente(this.cmpFuncionario);
                        this.ocultarComponente(this.cmpFuncionarioProveedor);
                        this.cmpFuncionario.reset();
                    }else{
                        if(n=='viatico' || n=='fondo_en_avance'){
                                this.cmpFuncionario.enable();
                                this.mostrarComponente(this.cmpFuncionario);
                                this.ocultarComponente(this.cmpProveedor);
                                this.ocultarComponente(this.cmpFuncionarioProveedor);                               
                                this.cmpProveedor.reset();
                            }
                            else{                          
                                 this.cmpFuncionarioProveedor.reset();
                                 this.cmpFuncionarioProveedor.enable();
                                 this.mostrarComponente(this.cmpFuncionarioProveedor);                          
                                 this.mostrarComponente(this.cmpFuncionario);
                                 this.ocultarComponente(this.cmpProveedor);
                                 this.cmpFuncionarioProveedor.on('change',function(groupRadio,radio){
                                 this.enableDisable(radio.inputValue);
                                },this);
                            }
                    }               
            },this);
            
            
            //validaciones para registro de plan de pagos por defecto
            //this.Cmp.total_nro_cuota.setValue(0);
            
            this.ocultarComponente(this.Cmp.id_plantilla);
            this.ocultarComponente(this.Cmp.fecha_pp_ini);
            this.ocultarComponente(this.Cmp.rotacion);
            
            this.Cmp.total_nro_cuota.on('change',function(cmp,newValue, oldValue ){
                
                if(newValue > 0){
                    this.mostrarComponente(this.Cmp.id_plantilla);
                    this.mostrarComponente(this.Cmp.fecha_pp_ini);
                    this.mostrarComponente(this.Cmp.rotacion);
                }
                else{
                    this.ocultarComponente(this.Cmp.id_plantilla);
                    this.ocultarComponente(this.Cmp.fecha_pp_ini);
                    this.ocultarComponente(this.Cmp.rotacion);
                }
                
            },this);
            
            
            
    
    },
    
    onButtonEdit:function(){
       
       var data= this.sm.getSelected().data;
       this.cmpTipoObligacion.disable();
       this.cmpDepto.disable(); 
       this.cmpFecha.disable(); 
       this.cmpTipoCambioConv.disable();
       
       Phx.vista.ObligacionPagoSol.superclass.onButtonEdit.call(this);
       
       if(data.tipo_obligacion=='adquisiciones'){
            this.mostrarComponente(this.cmpProveedor);
            this.mostrarComponente(this.cmpFuncionario);
            this.ocultarComponente(this.cmpFuncionarioProveedor);
            this.cmpFuncionario.reset();
            this.cmpProveedor.disable();
            this.cmpMoneda.disable();
       }
       
       if(data.tipo_obligacion=='pago_directo'){
           
           this.cmpProveedor.enable();
           this.mostrarComponente(this.cmpProveedor);
           this.cmpMoneda.enable();
           this.cmpFuncionario.store.baseParams.fecha = this.cmpFecha.getValue().dateFormat(this.cmpFecha.format);
                 
       }
       
       //segun el total nro cuota cero, ocultamos los componentes
       if(data.total_nro_cuota=='0'){
           this.ocultarComponente(this.Cmp.id_plantilla);
           this.ocultarComponente(this.Cmp.fecha_pp_ini);
           this.ocultarComponente(this.Cmp.rotacion);
       }
       else{
           this.cmpProveedor.enable();
           this.mostrarComponente(this.cmpProveedor);
           this.cmpMoneda.enable();
       }
           
    },
    
    onButtonNew:function(){
        Phx.vista.ObligacionPagoSol.superclass.onButtonNew.call(this);
       
        
        this.cmpTipoObligacion.enable();
        this.cmpDepto.enable(); 
        this.mostrarComponente(this.cmpProveedor);
        this.mostrarComponente(this.cmpFuncionario);
        this.ocultarComponente(this.cmpFuncionarioProveedor);
        this.cmpFuncionario.reset();
        this.cmpFecha.enable(); 
        this.cmpTipoCambioConv.enable();
        this.cmpProveedor.enable();
        this.cmpDepto.enable(); 
        this.cmpMoneda.enable();
        
        this.cmpFuncionario.disable();
        //defecto total nro cuota cero, entoces ocultamos los componentes
        this.ocultarComponente(this.Cmp.id_plantilla);
        this.ocultarComponente(this.Cmp.fecha_pp_ini);
        this.ocultarComponente(this.Cmp.rotacion);
        
        this.cmpFecha.setValue(new Date());
        this.cmpFecha.fireEvent('change')
        this.cmpTipoObligacion.setValue('pago_directo');
        
        
        
    },
    
       
};
</script>
