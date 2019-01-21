<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (rarteaga)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite dar el visto a solicitudes de compra
Issue			Fecha        Author				Descripcion
#12        10/01/2019      NMMV ENDETRAN       Considerar restar el iva al comprometer obligaciones de pago
#17         18/01/2019      MMV ENDETRAN       Plan de pago consulta obligaciones de pago
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ObligacionPagoSol = {
    require:'../../../sis_tesoreria/vista/obligacion_pago/ObligacionPago.php',
	requireclase: 'Phx.vista.ObligacionPago',
	title:'Obligacion de Pago (Solicitudes individuales)',
	nombreVista: 'obligacionPagoSol',
	ActList:'../../sis_tesoreria/control/ObligacionPago/listarObligacionPagoSol',
	
	/*
	 *  Interface heredada para solicitantes individuales
	 *  de tesoreria
	 * */
	
	constructor: function(config) {
	   
	  
	   this.Atributos[this.getIndAtributo('id_depto')].config.url = '../../sis_parametros/control/Depto/listarDeptoFiltradoXUsuario';
       this.Atributos[this.getIndAtributo('id_depto')].config.baseParams = {estado:'activo',codigo_subsistema:'TES',modulo:'OP'},
       this.Atributos[this.getIndAtributo('id_funcionario')].grid = true;
       this.Atributos[this.getIndAtributo('id_funcionario')].form = true;
       
       
       Phx.vista.ObligacionPagoSol.superclass.constructor.call(this, config);
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
            },
             {                                                                      //#17
                 url:'../../../sis_tesoreria/vista/plan_pago/PlanPagosConsulta.php',
                 title:'Plan de Pagos (Consulta)',
                 height:'50%',
                 cls:'PlanPagosConsulta'
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
                                this.cmpFuncionario.fireEvent('select',  this.cmpFuncionario, r[0]);
                            }     
                                            
                        }, scope : this
                    });
                 
                 
             },this);
             
             
           this.Cmp.id_funcionario.on('select', function(combo, record, index){ 
            	
            	if(!record.data.id_lugar){
            		alert('El funcionario no tiene oficina definida');
            		return
            	}
            	
            	this.Cmp.id_depto.reset();
            	this.Cmp.id_depto.store.baseParams.id_lugar = record.data.id_lugar;
            	this.Cmp.id_depto.modificado = true;
            	this.Cmp.id_depto.enable();
            	
            	this.Cmp.id_depto.store.load({params:{start:0,limit:this.tam_pag}, 
		           callback : function (r) {
		                if (r.length == 1 ) {                       
		                    this.Cmp.id_depto.setValue(r[0].data.id_depto);
		                }    
		                                
		            }, scope : this
		        });
            	
            	
            }, this);
            
            this.ocultarComponente(this.cmpProveedor);
            this.mostrarComponente(this.cmpFuncionario);
            this.ocultarComponente(this.cmpFuncionarioProveedor);
            
             this.cmpMoneda.on('select',function(com,dat){
                  
                  if(dat.data.tipo_moneda == 'base'){
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
                    
                    if(n == 'adquisiciones' || n == 'pago_directo'){
                        this.cmpProveedor.enable();
                        this.mostrarComponente(this.cmpProveedor);
                        this.mostrarComponente(this.cmpFuncionario);
                        this.ocultarComponente(this.cmpFuncionarioProveedor);
                        this.cmpFuncionario.reset();
                    }else{
                        if(n =='viatico' || n == 'fondo_en_avance'){
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
            
            
       
		this.Cmp.id_proveedor.on('select', function(cmb,rec,ind){
			this.Cmp.id_contrato.enable();
			this.Cmp.id_contrato.reset();
			this.Cmp.id_contrato.store.baseParams.filter = "[{\"type\":\"numeric\",\"comparison\":\"eq\", \"value\":\""+cmb.getValue()+"\",\"field\":\"CON.id_proveedor\"}]";
			//this.Cmp.id_contrato.store.baseParams.filtro_directo = "((CON.fecha_fin is null) or ((con.fecha_fin + interval ''3 month'')::date >= now()::date))";
            //calvarez 31/01/2018 solo para listar los contratos que están vencidos, para regularizar obligaciones de pago 
			//RESTAURAR ESTA FILA O IGNORAR EL MERGE this.Cmp.id_contrato.store.baseParams.filtro_directo = "((CON.fecha_fin is null) or ((con.fecha_fin)::date >= now()::date))";
            
            this.Cmp.id_contrato.modificado = true;
		}, this);
		
		
	this.Cmp.id_funcionario.on('select', function(combo, record, index){ 
        	if(!record.data.id_lugar){
        		alert('El funcionario no tiene oficina definida');
        	}
        	this.Cmp.id_depto.reset();
        	this.Cmp.id_depto.store.baseParams.id_lugar = record.data.id_lugar;
        	this.Cmp.id_depto.modificado = true;
        	this.Cmp.id_depto.enable();
        }, this);
    
    },
    
    onButtonEdit:function(){
       
       var data= this.sm.getSelected().data;
       this.cmpTipoObligacion.disable();
       this.cmpDepto.disable(); 
       this.cmpFecha.disable(); 
       this.cmpTipoCambioConv.disable();
       this.cmpMoneda.disable();
       this.Cmp.id_funcionario.disable()
       this.mostrarComponente(this.cmpProveedor);
       
       Phx.vista.ObligacionPagoSol.superclass.onButtonEdit.call(this);
       
       if(data.tipo_obligacion == 'adquisiciones'){
            
            this.mostrarComponente(this.cmpFuncionario);
            this.cmpFuncionario.store.baseParams.fecha = this.cmpFecha.getValue().dateFormat(this.cmpFecha.format);
            this.ocultarComponente(this.cmpFuncionarioProveedor);
            this.cmpProveedor.disable();
           
       }
       
       if(data.tipo_obligacion=='pago_directo'){
           
           this.cmpProveedor.enable();
           this.mostrarComponente(this.cmpProveedor);
           this.cmpFuncionario.store.baseParams.fecha = this.cmpFecha.getValue().dateFormat(this.cmpFecha.format);
                 
       }
       
       //segun el total nro cuota cero, ocultamos los componentes
       if(data.total_nro_cuota=='0'){
           this.ocultarComponente(this.Cmp.id_plantilla);
           this.ocultarComponente(this.Cmp.fecha_pp_ini);
           this.ocultarComponente(this.Cmp.rotacion);
       }
       
       
       this.Cmp.id_contrato.store.baseParams.filter = "[{\"type\":\"numeric\",\"comparison\":\"eq\", \"value\":\""+ this.Cmp.id_proveedor.getValue()+"\",\"field\":\"CON.id_proveedor\"}]";
	   this.Cmp.id_contrato.modificado = true;
	   
	   if(data.estado != 'borrador'){
       	  this.Cmp.tipo_anticipo.disable();
       	  this.Cmp.total_nro_cuota.disable();
       	  this.Cmp.id_funcionario.disable();
       	  this.cmpProveedor.disable();
       	  this.Cmp.comprometer_iva.disable();//#12
       }
       else{
       	this.Cmp.total_nro_cuota.enable();
       	this.Cmp.comprometer_iva.enable();//#12
       }
           
    },
    
    onButtonNew:function(){
        Phx.vista.ObligacionPagoSol.superclass.onButtonNew.call(this);
       
        
        this.cmpTipoObligacion.enable();
        this.cmpDepto.disable(); 
        this.mostrarComponente(this.cmpProveedor);
        this.mostrarComponente(this.cmpFuncionario);
        this.ocultarComponente(this.cmpFuncionarioProveedor);
        this.cmpFuncionario.reset();
        this.cmpFecha.enable(); 
        this.cmpTipoCambioConv.enable();
        this.cmpProveedor.enable();
        this.cmpMoneda.enable();
        
        this.cmpFuncionario.disable();
        //defecto total nro cuota cero, entoces ocultamos los componentes
        this.ocultarComponente(this.Cmp.id_plantilla);
        this.ocultarComponente(this.Cmp.fecha_pp_ini);
        this.ocultarComponente(this.Cmp.rotacion);
        
        this.cmpFecha.setValue(new Date());
        this.cmpFecha.fireEvent('change')
        this.cmpTipoObligacion.setValue('pago_directo');
        this.Cmp.comprometer_iva.enable();//#12
        
        
    },
    
       
};
</script>
