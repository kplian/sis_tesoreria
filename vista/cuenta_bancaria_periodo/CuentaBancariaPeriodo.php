<?php
/**
*@package pXP
*@file gen-CuentaBancariaPeriodo.php
*@author  (gsarmiento)
*@date 09-04-2015 18:40:04
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CuentaBancariaPeriodo=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.CuentaBancariaPeriodo.superclass.constructor.call(this,config);
		this.init();
		
		this.addButton('btnAbrirCerrarPeriodo',
			{
				text: 'Cerrar/Abrir',
				iconCls: 'block',
				disabled: false,
				handler: this.abrirCerrarPeriodo,
				tooltip: '<b>Cerrar/Abrir</b><br/>Cerrar/Abrir el periodo de una cuenta bancaria'
			}
		);
		//this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_cuenta_bancaria_periodo'
			},
			type:'Field',
			form:true 
		},
		{
			config: {
				name: 'id_cuenta_bancaria',
				fieldLabel: 'id_cuenta_bancaria',
				allowBlank: true,
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
				hiddenName: 'id_cuenta_bancaria',
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
			form: true
		},
		{
			config:{
				name: 'gestion',
				fieldLabel: 'Gestion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:-5
			},
				type:'TextField',
				filters:{pfiltro:'perctab.gestion',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},		
		{
			config:{
				name: 'nombre_periodo',
				fieldLabel: 'Mes',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:-5
			},
				type:'TextField',
				filters:{pfiltro:'perctab.estado',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config: {
				name: 'id_periodo',
				fieldLabel: 'Periodo',
				allowBlank: true,
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
				hiddenName: 'id_periodo',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 80,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['periodo']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'movtip.nombre',type: 'string'},
			grid: true,
			form: true
		},
		{
			config:{
				name: 'estado',
				fieldLabel: 'estado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:-5
			},
				type:'TextField',
				filters:{pfiltro:'perctab.estado',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
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
				filters:{pfiltro:'perctab.estado_reg',type:'string'},
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
				filters:{pfiltro:'perctab.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'perctab.fecha_reg',type:'date'},
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
				filters:{pfiltro:'perctab.usuario_ai',type:'string'},
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
				filters:{pfiltro:'perctab.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Periodos por Cuenta Bancaria',
	ActSave:'../../sis_tesoreria/control/CuentaBancariaPeriodo/insertarCuentaBancariaPeriodo',
	ActDel:'../../sis_tesoreria/control/CuentaBancariaPeriodo/eliminarCuentaBancariaPeriodo',
	ActList:'../../sis_tesoreria/control/CuentaBancariaPeriodo/listarCuentaBancariaPeriodo',
	id_store:'id_cuenta_bancaria_periodo',
	fields: [
		{name:'id_cuenta_bancaria_periodo', type: 'numeric'},
		{name:'id_cuenta_bancaria', type: 'numeric'},
		{name:'estado', type: 'string'},
		{name:'id_periodo', type: 'numeric'},
		{name:'periodo', type: 'string'},
		{name:'nombre_periodo', type: 'string'},
		{name:'gestion', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	
	preparaMenu:function(tb){
        Phx.vista.CuentaBancariaPeriodo.superclass.preparaMenu.call(this,tb)
        
		var data = this.getSelectedData();
		if(data['estado']== 'cerrado'){
			this.getBoton('btnAbrirCerrarPeriodo').setIconClass('bunlock');
		}
		else{
			this.getBoton('btnAbrirCerrarPeriodo').setIconClass('block');
		}        
    },
	
	onReloadPage:function(m)
	{
		this.maestro=m;						
		this.store.baseParams={id_cuenta_bancaria:this.maestro.id_cuenta_bancaria};
		this.load({params:{start:0, limit:50}});			
	},
	
	abrirCerrarPeriodo:function(){
	    Phx.CP.loadingShow();
	    var d = this.sm.getSelected().data;
        Ext.Ajax.request({
            url:'../../sis_tesoreria/control/CuentaBancariaPeriodo/abrirCerrarCuentaBancariaPeriodo',
            params:{id_cuenta_bancaria_periodo:d.id_cuenta_bancaria_periodo, estado:d.estado},
            success:this.successAbrirCerrarPeriodo,
            failure: this.conexionFailure,
            timeout:this.timeout,
            scope:this
        }); 
	    
	},
	
	successAbrirCerrarPeriodo:function(resp){
       Phx.CP.loadingHide();
       var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
       if(!reg.ROOT.error){
         this.reload();
       }
    },
	
	sortInfo:{
		field: 'per.id_gestion DESC, per.periodo',
		direction: 'DESC'
	},
	bdel:false,
	bsave:false,
	bnew:false,
	bedit:false
	}
)
</script>
		
		