<?php
/**
*@package pXP
*@file SolicitudEfectivoCaja.php
*@author  (gsarmiento)
*@date 24-11-2015 12:59:51
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.SolicitudEfectivoCaja=Ext.extend(Phx.gridInterfaz,{
	
	vista:'efectivoCaja',
	
	constructor:function(config){
		this.maestro=config.maestro;
    	
		this.Atributos[this.getIndAtributo('monto_rendido')].config.renderer = function(value, p, record) {			
				    var saldo = parseFloat(record.data.monto) + parseFloat(record.data.monto_repuesto) - parseFloat(record.data.monto_rendido) - parseFloat(record.data.monto_devuelto);
					if (record.data.estado == 'entregado' || record.data.estado == 'finalizado') {
						return String.format("<font color = 'red'>Rendido: {0}</font><br>"+
											 "<font color = 'slategray' >Devuelto a Caja:{1}</font><br>"+
											 "<font color = 'green' >Devuelto a Solicitante:{2}</font><br>"											 
											 ,record.data.monto_rendido, record.data.monto_devuelto, record.data.monto_repuesto											 
											 );
					} 
					else {
						return String.format('');
					}
			};
			
		//llama al constructor de la clase padre
		Phx.vista.SolicitudEfectivoCaja.superclass.constructor.call(this,config);
		this.init();
		
		//recargar valores segunda pestaña
		var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()			  
			  if(dataPadre){
				 this.onEnablePanel(this, dataPadre);
			  }
			  else
			  {
				 this.bloquearMenus();
			  }
			  
		this.iniciarEventos();
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_solicitud_efectivo'
			},
			type:'Field',
			form:true 
		},
		{
			config: {
				name: 'id_caja',
				fieldLabel: 'Caja',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_tesoreria/control/Caja/listarCaja',
					id: 'id_caja',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_caja', 'codigo', 'desc_moneda','cajero'],
					remoteSort: true,
					baseParams: {par_filtro: 'caja.codigo', tipo_interfaz:'cajaAbierto', con_detalle:'si'}
				}),
				valueField: 'id_caja',
				displayField: 'codigo',
				gdisplayField: 'codigo',
				hiddenName: 'id_caja',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 100,
				minChars: 2,
				tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>{codigo}</b></p><p>CAJERO: {cajero}</p></div></tpl>',
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['codigo']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'caja.codigo',type: 'string'},
			grid: true,
			form: true
		},	
		{
			config:{
				name: 'fecha',
				fieldLabel: 'Fecha',
				allowBlank: false,
				anchor: '80%',
				gwidth: 80,
				format: 'd/m/Y',
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'solefe.fecha',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},	
		{
			config:{
				name: 'nro_tramite',
				fieldLabel: 'Num Tramite',
				allowBlank: false,
				anchor: '80%',
				gwidth: 170,
				maxLength:50
			},
				type:'TextField',
				filters:{pfiltro:'solefe.nro_tramite',type:'string'},
				id_grupo:1,
				bottom_filter:true,
				grid:true,
				form:false
		},	
		{
   			config:{
       		    name:'id_funcionario',
       		     hiddenName: 'id_funcionario',
   				origen:'FUNCIONARIOCAR',
   				fieldLabel:'Funcionario',
   				allowBlank:false,
                gwidth:200,
   				valueField: 'id_funcionario',
   			    gdisplayField: 'desc_funcionario',   			    
      			renderer:function(value, p, record){return String.format('{0}', record.data['desc_funcionario']);}
       	     },
   			type:'ComboRec',//ComboRec
   			id_grupo:0,
   			filters:{pfiltro:'fun.desc_funcionario1',type:'string'},
   			bottom_filter:true,
   		    grid:true,
   			form:true
		 },
		{
			config: {
				name: 'id_estado_wf',
				fieldLabel: 'id_estado_wf',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_/control/Clase/Metodo',
					id: 'id_',
					root: 'datos',
					sortInfo: {
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_', 'nombre', 'codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'movtip.nombre#movtip.codigo'}
				}),
				valueField: 'id_',
				displayField: 'nombre',
				gdisplayField: 'desc_',
				hiddenName: 'id_estado_wf',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 150,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'movtip.nombre',type: 'string'},
			grid: false,
			form: false
		},
		{
			config:{
				name: 'monto',
				fieldLabel: 'Monto Solicitado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'solefe.monto',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'monto_rendido',
				fieldLabel: 'Montos',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
				maxLength:1179650
			},
				type:'NumberField',
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'monto_devuelto',
				fieldLabel: 'Monto Devuelto',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				id_grupo:1,
				grid:false,
				form:false
		},
		{
			config:{
				name: 'monto_repuesto',
				fieldLabel: 'Monto Repuesto',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				id_grupo:1,
				grid:false,
				form:false
		},
		{
			config:{
				name: 'saldo',
				fieldLabel: 'Saldo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 80,
				maxLength:1179650
			},
				type:'NumberField',
				id_grupo:1,
				grid:true,
				form:false
		},		
		{
			config: {
				name: 'id_proceso_wf',
				fieldLabel: 'id_proceso_wf',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_/control/Clase/Metodo',
					id: 'id_',
					root: 'datos',
					sortInfo: {
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_', 'nombre', 'codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'movtip.nombre#movtip.codigo'}
				}),
				valueField: 'id_',
				displayField: 'nombre',
				gdisplayField: 'desc_',
				hiddenName: 'id_proceso_wf',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 150,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'movtip.nombre',type: 'string'},
			grid: false,
			form: false
		},
		{
			config:{
				name: 'estado',
				fieldLabel: 'Estado',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:50
			},
				type:'TextField',
				filters:{pfiltro:'solefe.estado',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'motivo',
				fieldLabel: 'Motivo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
				type:'TextField',
				filters:{pfiltro:'solefe.motivo',type:'string'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'solefe.estado_reg',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: '',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'solefe.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'solefe.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'solefe.usuario_ai',type:'string'},
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
				type:'Field',
				filters:{pfiltro:'usu1.cuenta',type:'string'},
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
				type:'Field',
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
				filters:{pfiltro:'solefe.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Solicitud Efectivo Con Detalle',
	ActSave:'../../sis_tesoreria/control/SolicitudEfectivo/insertarSolicitudEfectivo',
	ActDel:'../../sis_tesoreria/control/SolicitudEfectivo/eliminarSolicitudEfectivo',
	ActList:'../../sis_tesoreria/control/SolicitudEfectivo/listarSolicitudEfectivo',
	id_store:'id_solicitud_efectivo',
	fields: [
		{name:'id_solicitud_efectivo', type: 'numeric'},
		{name:'id_caja', type: 'numeric'},
		{name:'codigo', type: 'string'},
		{name:'id_depto', type: 'numeric'},
		{name:'id_moneda', type: 'numeric'},
		{name:'id_estado_wf', type: 'numeric'},
		{name:'monto', type: 'numeric'},
		{name:'id_proceso_wf', type: 'numeric'},
		{name:'nro_tramite', type: 'string'},
		{name:'estado', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'motivo', type: 'string'},
		{name:'id_funcionario', type: 'numeric'},
		{name:'desc_funcionario', type: 'string'},
		{name:'fecha', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'monto_rendido', type: 'numeric'},		
		{name:'monto_repuesto', type: 'numeric'},		
		{name:'monto_devuelto', type: 'numeric'},		
		{name:'saldo', type: 'numeric'}		
	],
	sortInfo:{
		field: 'solefe.id_solicitud_efectivo',
		direction: 'DESC'
	},
	bdel:false,
	bsave:false,
	bedit:false,
	bnew:false,
		
	iniciarEventos:function(){
		this.cmpMonto=this.getComponente('monto');
		this.cmpMonto.disable();
	},
	
	onReloadPage : function(m) {
		this.maestro = m;
		this.Atributos[1].valorInicial = this.maestro.id_caja;
		this.store.baseParams = { id_caja : this.maestro.id_caja, tipo_interfaz: this.vista};
        this.load({ params : { start : 0, limit : 50 }})    
	}	
}
)
</script>