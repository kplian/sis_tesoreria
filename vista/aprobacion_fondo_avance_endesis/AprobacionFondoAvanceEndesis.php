<?php
/**
*@package pXP
*@file gen-Caja.php
*@author  (admin)
*@date 16-12-2013 20:43:44
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.AprobacionFondoAvanceEndesis=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.AprobacionFondoAvanceEndesis.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}});
		this.addButton('ant_estado',{
                    text:'Anterior',
                    iconCls:'batras',
                    argument: { accion: 'rechazar' },
                    disabled:true,
                    handler:this.aprobar,
                    tooltip: '<b>Rechazar</b>'});
        
        
        this.addButton('sig_estado',{
                    text:'Siguiente',
                    iconCls:'badelante',
                    argument: { accion: 'aprobar' },
                    disabled:true,
                    handler:this.aprobar,
                    tooltip: '<b>Aprobar</b>'});
	},
	tam_pag:50,
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_cuenta_doc'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'nro_documento',
				fieldLabel: 'Nro Documento',				
				gwidth: 80
			},
			type:'TextField',			
			grid:true,
			form:false
		},
		{
			config:{
				name: 'desc_empleado',
				fieldLabel: 'Solicitante',				
				gwidth: 130
			},
			type:'TextField',			
			grid:true,
			form:false
		},
		{
			config:{
				name: 'desc_presupuesto',
				fieldLabel: 'Unidad',				
				gwidth: 120
			},
			type:'TextField',			
			grid:true,
			form:false
		},
		{
			config:{
				name: 'fecha_sol',
				fieldLabel: 'Fecha',				
				gwidth: 80,
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'TextField',			
			grid:true,
			form:false
		},
		{
			config:{
				name: 'motivo',
				fieldLabel: 'Motivo',				
				gwidth: 150
			},
			type:'TextField',			
			grid:true,
			form:false
		},
		{
			config:{
				name: 'observaciones',
				fieldLabel: 'Justificacion',				
				gwidth: 150
			},
			type:'TextField',			
			grid:true,
			form:false
		},
		{
			config:{
				name: 'importe',
				fieldLabel: 'Importe',				
				gwidth: 90
			},
			type:'NumberField',			
			grid:true,
			form:false
		},
		{
			config:{
				name: 'desc_moneda',
				fieldLabel: 'Moneda',				
				gwidth: 90
			},
			type:'TextField',			
			grid:true,
			form:false
		},
		{
			config:{
				name: 'desc_depto',
				fieldLabel: 'Depto Tesoreria',				
				gwidth: 120
			},
			type:'TextField',			
			grid:true,
			form:false
		},
		{
			config:{
				name: 'nombre_cheque',
				fieldLabel: 'Nombre Cheque',				
				gwidth: 120
			},
			type:'TextField',			
			grid:true,
			form:false
		},
		{
			config:{
				name: 'tipo_pago',
				fieldLabel: 'Tipo Pago',				
				gwidth: 100
			},
			type:'TextField',			
			grid:true,
			form:false
		},
		{
			config:{
				name: 'resp_registro',
				fieldLabel: 'Resp Registro',				
				gwidth: 120
			},
			type:'TextField',			
			grid:true,
			form:false
		}
	],
	
	title:'Aprobación de Fondos en Avance',	
	ActList:'../../sis_tesoreria/control/CuentaDocumentadaEndesis/listarFondoAvance',
	ActCount:'../../sis_tesoreria/control/CuentaDocumentadaEndesis/contarFondoAvance',
	id_store:'id_cuenta_doc',
	fields: [
		{name:'id_cuenta_doc', type: 'numeric'},
		{name:'id_presupuesto', type: 'numeric'},
		{name:'desc_presupuesto', type: 'string'},
		{name:'id_empleado', type: 'numeric'},
		{name:'desc_empleado', type: 'string'},
		{name:'id_categoria', type: 'numeric'},
		{name:'desc_categoria', type: 'string'},
		{name:'fecha_ini', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'},		
		{name:'tipo_pago', type: 'string'},
		{name:'tipo_contrato', type: 'string'},
		{name:'id_usuario_rendicion', type: 'numeric'},
		{name:'desc_usuario', type: 'string'},
		{name:'estado', type: 'string'},
		{name:'nro_documento', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d'},
		{name:'motivo', type: 'string'},
		{name:'recorrido', type: 'string'},
		{name:'observaciones', type: 'string'},
		{name:'id_depto', type: 'numeric'},
		{name:'desc_depto', type: 'string'},
		{name:'id_moneda', type: 'numeric'},
		{name:'desc_moneda', type: 'string'},
		{name:'fecha_sol', type: 'date',dateFormat:'Y-m-d'},
		{name:'fa_solicitud', type: 'string'},
		{name:'id_caja', type: 'numeric'},
		{name:'desc_caja', type: 'string'},
		{name:'id_cajero', type: 'numeric'},
		{name:'desc_cajero', type: 'string'},
		{name:'importe', type: 'numeric'},
		{name:'id_parametro', type: 'numeric'},
		{name:'desc_parametro', type: 'string'},
		{name:'resp_registro', type: 'string'},
		{name:'tipo_pago_fin', type: 'string'},
		{name:'id_cuenta_bancaria', type: 'numeric'},
		{name:'id_cuenta_bancaria_fin', type: 'numeric'},
		{name:'id_caja_fin', type: 'numeric'},
		{name:'id_cajero_fin', type: 'numeric'},
		{name:'nro_deposito', type: 'string'},
		{name:'desc_cuenta_bancaria_fin', type: 'string'},
		{name:'desc_caja_fin', type: 'string'},
		{name:'desc_cajero_fin', type: 'string'},
		{name:'id_autorizacion', type: 'numeric'},
		{name:'desc_autorizacion', type: 'string'},
		{name:'nombre_cheque', type: 'string'},
		{name:'nro_cheque', type: 'string'},
		{name:'tipo_cuenta_doc', type: 'string'},
		{name:'fk_id_cuenta_doc', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_comprobante', type: 'numeric'},
		{name:'fecha_aut_rendicion', type: 'date',dateFormat:'Y-m-d'},
		{name:'cant_rend_registradas', type: 'numeric'},
		{name:'cant_rend_finalizadas', type: 'numeric'},
		{name:'cant_rend_contabilizadas', type: 'numeric'},
		{name:'codigo_caja', type: 'string'},
		{name:'respuesta_aprobador', type: 'string'},
		{name:'saldo_solicitante', type: 'numeric'},
		{name:'importe_detalle', type: 'numeric'},
		{name:'id_presupuesto_detalle', type: 'numeric'},
		{name:'saldo_rendiciones', type: 'numeric'},
		{name:'saldo_retenciones', type: 'numeric'},
		{name:'saldo_depositar', type: 'numeric'}			 
	],
	sortInfo:{
		field: 'id_cuenta_doc',
		direction: 'ASC'
	},
	aprobar : function (params){
    	this.accion = params.argument.accion;
    	Ext.MessageBox.show({
           title: 'Observaciones',
           msg: 'Por favor ingrese sus observaciones:',
           width:300,
           buttons: Ext.MessageBox.OKCANCEL,
           multiline: true,
           fn: this.afterAprobar,
           animEl: 'mb3',
           scope : this
        });	
        
    	
    	    	
    },
    afterAprobar : function (btn, text){
    	if (text == '' || text == undefined) {
    		if (this.accion == 'aprobar') {
    			text = 'aprobado';
    		} else {
    			text = 'rechazado';
    		}
    	}
    	var rec = this.sm.getSelected();
        Phx.CP.loadingShow();	
		Ext.Ajax.request({
				url:'../../sis_tesoreria/control/CuentaDocumentadaEndesis/aprobarFondoAvanceCorreo',
				success:this.successDel,
				failure:this.conexionFailure,
				params:{'id_cuenta_documentada':rec.data.id_cuenta_doc, 'accion':this.accion,'mensaje' : text},
				timeout:this.timeout,
				scope:this
			})
    },
	bdel:false,
	bsave:false,
	bnew:false,
	bedit:false,
	preparaMenu:function(n){
      var tb =this.tbar;
      Phx.vista.AprobacionFondoAvanceEndesis.superclass.preparaMenu.call(this,n);      
      this.getBoton('sig_estado').enable();
      this.getBoton('ant_estado').enable();      
          
      return tb;
    },
    liberaMenu:function(){
        var tb = Phx.vista.AprobacionFondoAvanceEndesis.superclass.liberaMenu.call(this);        
        if(tb){
            this.getBoton('sig_estado').disable();
            this.getBoton('ant_estado').disable();            
           
        }
        return tb
    },
	}
)
</script>
		
		