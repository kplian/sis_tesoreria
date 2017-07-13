<?php
/**
*@package pXP
*@file gen-CajaFuncionario.php
*@author  (gsarmiento)
*@date 15-03-2017 20:10:37
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CajaFuncionario=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.CajaFuncionario.superclass.constructor.call(this,config);
		this.init();
		var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
		if(dataPadre){
			this.onEnablePanel(this, dataPadre);
		}
		else{
			this.bloquearMenus();
		}
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_caja_funcionario'
			},
			type:'Field',
			form:true 
		},
		{
			config: {
				name: 'id_caja',
				fieldLabel: 'Caja',
				allowBlank: false,
				inputType:'hidden',
				hiddenName: 'id_caja',
				gwidth: 150
			},
			type: 'Field',
			id_grupo: 0,
			grid: false,
			form: true
		},
		{
			config:{
				name:'id_funcionario',
				origen:'FUNCIONARIO',
				tinit:false,
				fieldLabel: 'Funcionario',
				gdisplayField:'desc_funcionario',
				gwidth: 250,
				anchor: '100%',
				allowBlank:true,
				renderer: function (value, p, record){return String.format('{0}', record.data['desc_funcionario1']);}
			},
			type:'ComboRec',
			id_grupo:8,
			filters:{
				pfiltro:'fun.desc_funcionario1',
				type:'string'
			},
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
			filters:{pfiltro:'cajusu.estado_reg',type:'string'},
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
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'cajusu.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'cajusu.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'cajusu.usuario_ai',type:'string'},
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
				filters:{pfiltro:'cajusu.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Usuario',
	ActSave:'../../sis_tesoreria/control/CajaFuncionario/insertarCajaFuncionario',
	ActDel:'../../sis_tesoreria/control/CajaFuncionario/eliminarCajaFuncionario',
	ActList:'../../sis_tesoreria/control/CajaFuncionario/listarCajaFuncionario',
	id_store:'id_caja_funcionario',
	fields: [
		{name:'id_caja_funcionario', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_caja', type: 'numeric'},
		{name:'id_funcionario', type: 'numeric'},
		{name:'desc_funcionario1', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_caja_funcionario',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,

	onReloadPage : function(m) {
		this.maestro = m;
		this.Atributos[1].valorInicial = this.maestro.id_caja;
		this.store.baseParams = { id_caja : this.maestro.id_caja };
		this.load({ params : { start : 0, limit : 50 }})
	},
}
)
</script>
		
		