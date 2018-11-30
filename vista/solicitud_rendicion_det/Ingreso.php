<?php
/**
*@package pXP
*@file Ingreso.php
*@author  (mguerra)
*@date 16-12-2015 15:14:01
*@description Muestra los ingresos de caja
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Ingreso=Ext.extend(Phx.gridInterfaz,{
	//tipoDoc: 'Ingreso',
	constructor:function(config){
		this.maestro=config.maestro;
		//llama al constructor de la clase padre
		Phx.vista.Ingreso.superclass.constructor.call(this,config);
		this.init();		
		this.iniciarEventos();
		var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
		if(dataPadre){
			this.onEnablePanel(this, dataPadre);
		}
		else
		{
			this.bloquearMenus();
		}
	},
			
	Atributos:[		
		{
			config:{
				labelSeparator:'',
				inputType:'hidden',
				name: 'id_solicitud_efectivo'
			},
			type:'Field',
			id_grupo:0,
			form:false,
			grid:false
		},		
		{
			config:{
				name: 'nro_tramite',
				fieldLabel: 'Nro Tramite',
				allowBlank: false,
				anchor: '100%',
				gwidth: 150,
				maxLength:150
			},
			type:'TextField',
			filters:{pfiltro:'tesa.nro_tramite',type:'string'},
			id_grupo:1,
			bottom_filter: true,
			grid:true,
			form:false
		},	
		{
			config:{
				name: 'fecha',
				fieldLabel: 'Fecha',
				allowBlank: true,
				anchor: '100%',
				gwidth: 100,
				format: 'd/m/Y', 
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			id_grupo:1,
			filters:{pfiltro:'tesa.fecha',type:'date'},
			grid:true,
			form:true
		},
		{
			config:{
				name: 'monto',
				fieldLabel: 'Liquido Pagable',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
			type:'NumberField',
			id_grupo:1,
			filters:{pfiltro:'tesa.monto',type:'numeric'},
			grid:true,
			form:false
		},			
		{
			config:{
				name: 'usr_reg',
				fieldLabel: 'Creado por',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextField',
			filters:{pfiltro:'usu1.cuenta',type:'string'},
			bottom_filter: true,
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'usr_mod',
				fieldLabel: 'Usu Modif.',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
				type:'TextField',
				filters:{pfiltro:'usu2.cuenta',type:'string'},
				bottom_filter: true,
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'estado',
				fieldLabel: 'Estado',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
				type:'TextField',
				filters:{pfiltro:'a.estado',type:'string'},
				bottom_filter: true,
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Ingreso',
	ActList:'../../sis_tesoreria/control/SolicitudRendicionDet/listarSolicitudIngresoDet',
	id_store:'id_solicitud_efectivo',
	fields: [
		{name:'id_solicitud_efectivo', type: 'numeric'},
		{name:'id_proceso_caja', type: 'numeric'},
		{name:'id_solicitud_efectivo', type: 'numeric'},				
		{name:'fecha', type: 'date',dateFormat:'Y-m-d'},	
		{name:'nro_tramite', type: 'string'},
		{name:'monto', type: 'numeric'},	
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},	
		{name:'estado', type: 'string'}			
	],
	sortInfo:{
		field: 'id_solicitud_efectivo',
		direction: 'ASC'
	},
		
	onReloadPage : function(m) {
		this.maestro = m;
		this.store.baseParams={id_proceso_caja:this.maestro.id_proceso_caja};
		this.load({params:{start:0, limit:this.tam_pag}});			
	},

	preparaMenu:function(n){
		Phx.vista.Ingreso.superclass.preparaMenu.call(this,n);
		 if(this.maestro.estado == 'rendido'){
			 this.getBoton('excluir').disable();
		 }else{
			 this.getBoton('excluir').enable();
		 }
	},

	iniciarEventos:function(){		
		var vistaPadre = Phx.CP.getPagina(this.idContenedorPadre).nombreVista;		
	},
	
	loadValoresIniciales:function()
	{
		Phx.vista.RendicionProcesoCaja.superclass.loadValoresIniciales.call(this);
		this.Cmp.id_proceso_caja.setValue(this.maestro.id_proceso_caja);  
	},
	
	bnew:false,
	bedit:false,
	bdel:false,
	bsave:false
	}
)
</script>
		
		