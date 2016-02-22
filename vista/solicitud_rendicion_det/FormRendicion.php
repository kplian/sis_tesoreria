<?php
/**
*@package pXP
*@file FormRendicion.php
*@author  Gonzalo Sarmiento 
*@date 16-02-2016
*@description Archivo con la interfaz de usuario que permite 
*ingresar el documento a rendir
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.FormRendicion = {
	require:'../../../sis_contabilidad/vista/doc_compra_venta/FormCompraVenta.php',
	ActSave:'../../sis_tesoreria/control/SolicitudRendicionDet/insertarRendicionDocCompleto',
	requireclase:'Phx.vista.FormCompraVenta',
	mostrarFormaPago : false,
		
	constructor: function(config) {
	      
	   Phx.vista.FormRendicion.superclass.constructor.call(this,config);
                 
    },
    
	onNew: function(){    	
    	Phx.vista.FormRendicion.superclass.onNew.call(this);
        this.Cmp.id_solicitud_efectivo.setValue(this.data.id_solicitud_efectivo);	 
	},
	
	onEdit: function(){    	
    	Phx.vista.FormRendicion.superclass.onEdit.call(this);
        this.Cmp.id_solicitud_efectivo.setValue(this.data.id_solicitud_efectivo);	 
	},
	
	iniciarEventos: function(){
		
		this.Cmp.dia.hide();
		this.Cmp.fecha.setReadOnly(false);
		
		this.Cmp.id_depto_conta.store = new Ext.data.JsonStore({
			url: '../../sis_parametros/control/DeptoDepto/listarDeptoDepto',
			id: 'id_depto',
			root: 'datos',
			sortInfo: {
				field: 'nombre',
				direction: 'ASC'
			},
			totalProperty: 'total',
			fields: ['id_depto_depto', 'id_depto_destino'],
			remoteSort: true,
			baseParams: {id_depto: this.data.id_depto}
		});
		
		this.Cmp.id_depto_conta.store.load({params:{start:0,limit:this.tam_pag}, 
		   callback : function (r) {
				Phx.CP.loadingHide();  
				if (r.length == 1 ) {                        
					this.Cmp.id_depto_conta.setValue(r[0].data.id_depto_destino);
				}else{
					alert('Depto Conta no recuperado');
				}     								
			}, scope : this
		});
		
		this.Cmp.fecha.on('change', this.cargarPeriodo, this);
		
		this.Cmp.nro_autorizacion.on('select', function(cmb,rec,i){
			this.Cmp.nit.setValue(rec.data.nit);
			this.Cmp.razon_social.setValue(rec.data.razon_social);
		} ,this);
		
		this.Cmp.nit.on('select', function(cmb,rec,i){
			this.Cmp.razon_social.setValue(rec.data.razon_social);
		} ,this);
		
		//this.Cmp.nro_autorizacion .on('blur',this.cargarRazonSocial,this);
		this.Cmp.id_plantilla.on('select',function(cmb,rec,i){
				
				this.esconderImportes();
				
				//si es el formulario para nuevo reseteamos los valores ...
				if(this.accionFormulario == 'NEW'){
				    this.iniciarImportes();	
					this.Cmp.importe_excento.reset();
					
					this.Cmp.nro_autorizacion.reset();
					this.Cmp.codigo_control.reset();
					this.Cmp.importe_descuento.reset();
		         }     
	            this.getDetallePorAplicar(rec.data.id_plantilla);
	            if(rec.data.sw_monto_excento=='si'){
	               this.mostrarComponente(this.Cmp.importe_excento);
	            }
	            else{
	                this.ocultarComponente(this.Cmp.importe_excento);
	            }
	           
	            if(rec.data.sw_descuento=='si'){
	               this.mostrarComponente(this.Cmp.importe_descuento);
	            }
	            else{
	                this.ocultarComponente(this.Cmp.importe_descuento);
	            }
	          
	            if(rec.data.sw_autorizacion == 'si'){
	               this.mostrarComponente(this.Cmp.nro_autorizacion);
	            }
	            else{
	                this.ocultarComponente(this.Cmp.nro_autorizacion);
	            }
	            
	            if(rec.data.sw_codigo_control == 'si'){
	               this.mostrarComponente(this.Cmp.codigo_control);
	            }
	            else{
	                this.ocultarComponente(this.Cmp.codigo_control);
	            }
	            
	            console.log('NRO DUI', rec.data.sw_nro_dui)
	            if(rec.data.sw_nro_dui == 'si'){
	               this.Cmp.nro_dui.allowBlank =false;
	               this.mostrarComponente(this.Cmp.nro_dui);
	               this.Cmp.nro_documento.setValue(0);
	               this.Cmp.nro_documento.setReadOnly(true);
	               
	            }
	            else{
	            	this.Cmp.nro_dui.allowBlank = true;
	                this.ocultarComponente(this.Cmp.nro_dui);
	                this.Cmp.nro_documento.setReadOnly(false);
	            }
			
        },this);
        
        this.Cmp.importe_doc.on('change',this.calculaMontoPago,this);
        this.Cmp.importe_excento.on('change',this.calculaMontoPago,this);  
        this.Cmp.importe_descuento.on('change',this.calculaMontoPago,this);
        this.Cmp.importe_descuento_ley.on('change',this.calculaMontoPago,this);
        
        
        this.Cmp.nro_autorizacion.on('change',function(fild, newValue, oldValue){
        	if (newValue[3] == '4'){
        		this.mostrarComponente(this.Cmp.codigo_control);
	            this.Cmp.codigo_control.allowBlank = false;
        	}
        	else{
        		this.Cmp.codigo_control.allowBlank = true;
        		this.ocultarComponente(this.Cmp.codigo_control);
        		
        	};
        	
        },this);
		        
		this.Cmp.nro_autorizacion.on('blur',this.cargarRazonSocial,this);	       
	},	
    
	cargarPeriodo: function(obj){
	//Busca en la base de datos la razon social en función del NIT digitado. Si Razon social no esta vacío, entonces no hace nada
		if(this.getComponente('fecha').getValue()!=''){
		Phx.CP.loadingShow();
		Ext.Ajax.request({
			url:'../../sis_parametros/control/Periodo/listarPeriodo',
			params:{ start:0, limit:30, 'fecha': this.getComponente('fecha').getValue().format('d-m-Y')},
			success: function(resp){
				Phx.CP.loadingHide();
				var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));								
				var idGestion=objRes.datos[0].id_gestion;
				this.Cmp.id_gestion.setValue(idGestion);
				this.Cmp.dia.setValue(this.getComponente('fecha').getValue().getDate());
			},
			failure: this.conexionFailure,
			timeout: this.timeout,
			scope:this
		});
		}
	}	
};
</script>
