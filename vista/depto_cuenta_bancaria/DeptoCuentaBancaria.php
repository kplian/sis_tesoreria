<?php
/**
*@package pXP
*@file gen-DeptoCuentaBancaria.php
*@author  (gsarmiento)
*@date 03-03-2015 19:10:38
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.DeptoCuentaBancaria=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		console.log(config);
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.DeptoCuentaBancaria.superclass.constructor.call(this,config);
		this.init();
		 if(Phx.CP.getPagina(this.idContenedorPadre)){
      	 var dataMaestro=Phx.CP.getPagina(this.idContenedorPadre).getSelectedData();
	 	 if(dataMaestro){ 
	 	 	this.onEnablePanel(this,dataMaestro)
	 	 }
		 }
		 this.iniciarEventos();
		//this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_depto_cuenta_bancaria'
			},
			type:'Field',
			form:true 
		},
		{
			config: {
				name: 'id_cuenta_bancaria',
				fieldLabel: 'Cuenta Bancaria',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_tesoreria/control/CuentaBancaria/listarCuentaBancaria',
					id: 'id_cuenta_bancaria',
					root: 'datos',
					sortInfo: {
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_cuenta_bancaria', 'nro_cuenta', 'denominacion'],
					remoteSort: true,
					baseParams: {par_filtro: 'ctaban.nro_cuenta#ctaban.denominacion'}
				}),
				valueField: 'id_cuenta_bancaria',
				displayField: 'nro_cuenta',
				gdisplayField: 'denominacion',
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
				tpl: '<tpl for="."><div class="x-combo-list-item"><p>{detalle}</p><p><strong>{denominacion}</strong></p><p><strong>{nro_cuenta}</strong></p></div></tpl>',
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['denominacion']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'movtip.nombre',type: 'string'},
			grid: true,
			form: true
		},
		{
			config: {
				name: 'id_depto',
				fieldLabel: 'Departamento',
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
				hiddenName: 'id_depto',
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
				name: 'estado_reg',
				fieldLabel: 'Estado Reg.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
				type:'TextField',
				filters:{pfiltro:'dcb.estado_reg',type:'string'},
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
				filters:{pfiltro:'dcb.fecha_reg',type:'date'},
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
				filters:{pfiltro:'dcb.usuario_ai',type:'string'},
				id_grupo:1,
				grid:false,
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
				name: 'id_usuario_ai',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'dcb.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'dcb.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Cuenta Bancaria',
	ActSave:'../../sis_tesoreria/control/DeptoCuentaBancaria/insertarDeptoCuentaBancaria',
	ActDel:'../../sis_tesoreria/control/DeptoCuentaBancaria/eliminarDeptoCuentaBancaria',
	ActList:'../../sis_tesoreria/control/DeptoCuentaBancaria/listarDeptoCuentaBancaria',
	id_store:'id_depto_cuenta_bancaria',
	fields: [
		{name:'id_depto_cuenta_bancaria', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_cuenta_bancaria', type: 'numeric'},
		{name:'denominacion', type: 'string'},
		{name:'id_depto', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_depto_cuenta_bancaria',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	iniciarEventos:function(){			
		this.cmpIdDepto = this.getComponente('id_depto');		
		this.ocultarComponente(this.cmpIdDepto);		
	},
	
	onReloadPage:function(m){
		this.maestro=m;
		this.Atributos[2].valorInicial=this.maestro.id_depto;
		// this.Atributos.config['id_subsistema'].setValue(this.maestro.id_subsistema);

       if(m.id != 'id'){
    	//   this.grid.getTopToolbar().enable();
     	//	 this.grid.getBottomToolbar().enable();  
//alert("entra aqui"+ console.log(this.maestro.id_depto));
		this.store.baseParams={id_depto:this.maestro.id_depto};
		this.load({params:{start:0, limit:50}})
       
       }
       else{//alert("else");
    	 this.grid.getTopToolbar().disable();
   		 this.grid.getBottomToolbar().disable(); 
   		 this.store.removeAll(); 
    	   
       }
	}
	}
)
</script>
		
		