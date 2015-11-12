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
Phx.vista.Caja=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Caja.superclass.constructor.call(this,config);
		this.init();
		
		this.addButton('btnAbrirCerrar',
			{
				text: 'Cerrar/Abrir',
				iconCls: 'block',
				disabled: false,
				handler: this.abrirCerrarCaja,
				tooltip: '<b>Cerrar/Abrir</b><br/>Cerrar/Abrir caja'
			}
		);
		
		this.load({params:{start:0, limit:this.tam_pag}})
	},
	tam_pag:50,
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_caja'
			},
			type:'Field',
			form:true 
		},
				{
			config:{
				name: 'codigo',
				fieldLabel: 'Código',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:20
			},
			type:'TextField',
			filters:{pfiltro:'caja.codigo',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{     
			config:{
				    name:'id_depto',
        origen:'DEPTO',
        fieldLabel: 'Departamento',
        url: '../../sis_parametros/control/Depto/listarDepto',
        emptyText : 'Departamento...',
        allowBlank:false,
        gdisplayField:'desc_depto',//mapea al store del grid
        gwidth:200,
        renderer:function (value, p, record){return String.format('{0}', record.data['desc_depto']);}
   },   
        type:'ComboRec',
        id_grupo:0,
        filters:{pfiltro:'cc.codigo_cc',type:'string'},
        grid:true,
        form:true
			},
		{
			config:{
				name: 'tipo',
				fieldLabel: 'Tipo',
				allowBlank: false,
				emptyText:'Tipo...',
				typeAhead: true,
				triggerAction: 'all',
				lazyRender:true,
				mode: 'local',
				anchor: '80%',
				gwidth: 100,
				store:['fondo_rotativo','caja_chica']
			},
			type:'ComboBox',
			filters:{type: 'list',
					 pfiltro:'caja.tipo',
					 options: ['fondo_rotativo','caja_chica']},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'tipo_ejecucion',
				fieldLabel: 'Tipo Ejecucion',
				allowBlank: false,
				emptyText:'Tipo Ejecucion...',
				typeAhead: true,
				triggerAction: 'all',
				lazyRender:true,
				mode: 'local',
				anchor: '80%',
				gwidth: 100,
				store:['con_detalle','sin_detalle']
			},
			type:'ComboBox',
			filters:{pfiltro:'caja.tipo_ejecucion',
					 type:'list',
					 options: ['con_detalle','sin_detalle']},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'importe_maximo',
				fieldLabel: 'Importe máximo',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
			type:'NumberField',
			filters:{pfiltro:'caja.importe_maximo',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'porcentaje_compra',
				fieldLabel: 'Porcentaje  compra',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:393218
			},
			type:'NumberField',
			filters:{pfiltro:'caja.porcentaje_compra',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
     config:{
        name:'id_moneda',
        origen:'MONEDA',
        fieldLabel: 'Moneda',
        url: '../../sis_parametros/control/Moneda/listarMoneda',
        emptyText : 'Moneda...',
        allowBlank:false,
        gdisplayField:'desc_moneda',//mapea al store del grid
        gwidth:100,
        renderer:function (value, p, record){return String.format('{0}', record.data['desc_moneda']);}
     },
        type:'ComboRec',
        id_grupo:0,
        filters:{pfiltro:'cc.codigo_cc',type:'string'},
        grid:true,
        form:true
  },    
		{
			config:{
				name: 'estado',
				fieldLabel: 'Estado',
				allowBlank: false,
				emptyText:'Estado...',
				typeAhead: true,
				triggerAction: 'all',
				lazyRender:true,
				mode: 'local',
				anchor: '80%',
				gwidth: 100,
				store:['abierto','cerrado']
			},
			type:'ComboBox',
			filters:{pfiltro:'caja.estado',
					 type:'list',
					 options: ['abierto','cerrado']},
			id_grupo:1,
			grid:true,
			form:false
		},		
		{
			config:{
				name: 'estado_reg',
				fieldLabel: 'Estado Reg.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
			type:'TextField',
			filters:{pfiltro:'caja.estado_reg',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'usr_reg',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'NumberField',
			filters:{pfiltro:'usu1.cuenta',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'caja.fecha_reg',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'usr_mod',
				fieldLabel: 'Modificado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'NumberField',
			filters:{pfiltro:'usu2.cuenta',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'caja.fecha_mod',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		}
	],
	
	title:'Caja',
	ActSave:'../../sis_tesoreria/control/Caja/insertarCaja',
	ActDel:'../../sis_tesoreria/control/Caja/eliminarCaja',
	ActList:'../../sis_tesoreria/control/Caja/listarCaja',
	id_store:'id_caja',
	fields: [
		{name:'id_caja', type: 'numeric'},
		{name:'estado', type: 'string'},
		{name:'importe_maximo', type: 'numeric'},
		{name:'tipo', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'porcentaje_compra', type: 'numeric'},
		{name:'id_moneda', type: 'numeric'},
		{name:'id_depto', type: 'numeric'},
		{name:'codigo', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'desc_moneda', type: 'string'},
		{name:'desc_depto', type: 'string'},
		{name:'tipo_ejecucion', type: 'string'}
	],
	sortInfo:{
		field: 'id_caja',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	/*
	abrirCerrarCaja:function(){
	    Phx.CP.loadingShow();
	    var d = this.sm.getSelected().data;
        Ext.Ajax.request({
            url:'../../sis_tesoreria/control/Caja/abrirCerrarCaja',
            params:{id_caja:d.id_caja, estado:d.estado},
            success:this.successAbrirCerrarCaja,
            failure: this.conexionFailure,
            timeout:this.timeout,
            scope:this
        }); 	    
	},
	*/
	
	abrirCerrarCaja:function(){ 
		var rec=this.sm.getSelected();
		var NumSelect=this.sm.getCount();
		
		if(NumSelect != 0)
		{	
			if(rec.data.estado=='cerrado'){
				Phx.CP.loadWindows('../../../sis_tesoreria/vista/apertura_caja/AperturaCaja.php',
				'Apertura Caja',
				{
					modal:true,
					width:450,
					height:450
				}, {data:rec.data}, this.idContenedor,'AperturaCaja',
				{
					config:[{
							  event:'beforesave',
							  delegate: this.transferir,
							}
							],
				   scope:this
				 })
			}
		}
		else
		{
			Ext.MessageBox.alert('Alerta', 'Antes debe seleccionar un item.');
		}							   
	},
	
	transferir:function(wizard,resp){
		Phx.CP.loadingShow();
		Ext.Ajax.request({
			url:'../../sis_tesoreria/control/Caja/abrirCerrarCaja',
			params:{					
				   id_cuenta_bancaria_origen:resp.id_cuenta_bancaria_origen,
                   id_depto_lb:resp.id_depto_lb,
				   id_cuenta_bancaria:resp.id_cuenta_bancaria,
				   fecha:resp.fecha,
				   a_favor:resp.a_favor,
				   detalle:resp.detalle,
				   importe_transferencia:resp.importe_transferencia,
				   id_finalidad:resp.id_finalidad
			 },
			argument:{wizard:wizard},  
			success:this.successWizard,
			failure: this.conexionFailure,
			timeout:this.timeout,
			scope:this
		});
	   
	},
	
	successWizard:function(resp){
		Phx.CP.loadingHide();
		resp.argument.wizard.panel.destroy()
		this.reload();
	 },
	
	successAbrirCerrarCaja:function(resp){
       Phx.CP.loadingHide();
       var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
       if(!reg.ROOT.error){
         this.reload();
       }
    },
	
	south : {
			url : '../../../sis_tesoreria/vista/cajero/Cajero.php',
			title : 'Cajero',
			height : '50%',
			cls : 'Cajero'
		},
	}
	
)
</script>
		
		