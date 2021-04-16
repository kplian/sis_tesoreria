<?php
/**
*@package pXP
*@file gen-Cajero.php
*@author  (admin)
*@date 18-12-2013 19:39:02
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Cajero=Ext.extend(Phx.gridInterfaz,{
    
	constructor:function(config){
		this.maestro=config.maestro;
		//llama al constructor de la clase padre
		Phx.vista.Cajero.superclass.constructor.call(this,config);
		this.init();
		this.iniciarEventos();
	},
	tam_pag:50,
	Atributos:[
		{
			config:{
				labelSeparator:'',
				inputType:'hidden',
				name: 'id_cajero'
			},
			type:'Field',
			form:true 
		},
		{
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
				name: 'tipo',
				fieldLabel: 'Tipo',
				allowBlank: false,
				emptyText:'Tipo Ejecucion...',
				typeAhead: true,
				triggerAction: 'all',
				lazyRender:true,
				mode: 'local',
				anchor: '80%',
				gwidth: 100,
				store:['responsable','auxiliar','administrador']
			},
			type:'ComboBox',
			filters:{
			pfiltro:'cajero.tipo',
			type:'list',
			options: ['responsable','auxiliar','administrador']},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name:'id_funcionario',
				hiddenName: 'id_funcionario',
				origen:'FUNCIONARIOCAR',
				fieldLabel:'Funcionario',
				allowBlank:false,
				gwidth:200,
				anchor: '80%',
				valueField: 'id_funcionario',
				gdisplayField: 'desc_funcionario',
				renderer:function(value, p, record){return String.format('{0}', record.data['desc_funcionario']);}
			},
			type:'ComboRec',//ComboRec
			id_grupo:0,
			filters:{pfiltro:'fun.desc_funcionario1',type:'string'},
			grid:true,
			form:true
		},
		{
			config:{
				name: 'estado',
				fieldLabel: 'estado',
				allowBlank: false,
				emptyText:'Estado...',
				typeAhead: true,
				triggerAction: 'all',
				lazyRender:true,
				mode: 'local',
				anchor: '80%',
				gwidth: 100,
				store:['activo','inactivo']
				},
			type:'ComboBox',
			filters:{
			pfiltro:'cajero.estado',
			type:'string',
			options: ['activo','inactivo']},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'fecha_inicio',
				fieldLabel: 'Fecha inicio',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y', 
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'cajero.fecha_inicio',type:'date'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'fecha_fin',
				fieldLabel: 'Fecha fin',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y', 
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'cajero.fecha_fin',type:'date'},
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
			filters:{pfiltro:'cajero.estado_reg',type:'string'},
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
			filters:{pfiltro:'cajero.fecha_reg',type:'date'},
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
			filters:{pfiltro:'cajero.fecha_mod',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		}
	],
	
	title:'Cajero',
	ActSave:'../../sis_tesoreria/control/Cajero/insertarCajero',
	ActDel:'../../sis_tesoreria/control/Cajero/eliminarCajero',
	ActList:'../../sis_tesoreria/control/Cajero/listarCajero',
	id_store:'id_cajero',
	fields: [
		{name:'id_cajero', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'tipo', type: 'string'},
		{name:'estado', type: 'string'},
		{name:'id_funcionario', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'desc_funcionario', type: 'string'},
		{name:'id_caja', type: 'numeric'},
		{name:'fecha_inicio', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'}
	],
	
	sortInfo:{
		field: 'id_cajero',
		direction: 'ASC'
	},
	
	bdel:true,
	bnew:true,
	bedit:true,
	bdel:true,
	onReloadPage : function(m) {
		this.maestro = m;
		this.Atributos[1].valorInicial = this.maestro.id_caja;
		this.store.baseParams = { id_caja : this.maestro.id_caja };
		this.load({ params : { start : 0, limit : 50 }})
	},
	
	iniciarEventos : function(){
		this.cmpFuncionario=this.getComponente('id_funcionario');
		this.cmpFuncionario.store.baseParams.fecha = new Date();
		/*if(Phx.CP.getPagina(this.idContenedorPadre).nombreVista == 'cajaCajero'){
			this.getBoton('save').setVisible(true);
			this.getBoton('new').setVisible(true);
			this.getBoton('edit').setVisible(true);
			this.getBoton('del').setVisible(true);
		}else {
			this.getBoton('save').setVisible(true);
			this.getBoton('new').setVisible(true);
			this.getBoton('edit').setVisible(true);
			this.getBoton('del').setVisible(true);
		}*/
	},

	preparaMenu : function(){
		Phx.vista.Cajero.superclass.preparaMenu.call();
		if (this.maestro.estado_proceso == 'aprobado' || this.maestro.estado_proceso == 'anulado'){
		}
		this.getBoton('edit').enable();
		this.getBoton('del').enable();
	}
}
)
</script>