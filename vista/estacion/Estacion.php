<?php
/**
*@package pXP
*@file gen-Estacion.php
*@author  (admin)
*@date 25-08-2015 15:36:34
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Estacion=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Estacion.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_estacion'
			},
			type:'Field',
			form:true 
		},
		
		{
			config:{
				name: 'codigo',
				fieldLabel: 'codigo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100
			},
				type:'TextField',
				filters:{pfiltro:'est.codigo',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'host',
				fieldLabel: 'host',
				allowBlank: true,
				anchor: '80%',
				gwidth: 130
			},
				type:'TextField',
				filters:{pfiltro:'est.host',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'puerto',
				fieldLabel: 'puerto',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100
			},
				type:'TextField',
				filters:{pfiltro:'est.puerto',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'dbname',
				fieldLabel: 'dbname',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150
			},
				type:'TextField',
				filters:{pfiltro:'est.dbname',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'usuario',
				fieldLabel: 'usuario',
				allowBlank: true,
				anchor: '80%',
				gwidth: 200
			},
				type:'TextField',
				filters:{pfiltro:'est.usuario',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'password',
				fieldLabel: 'password',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100
			},
				type:'TextField',
				filters:{pfiltro:'est.password',type:'string'},
				id_grupo:1,
				grid:false,
				form:true
		},
		
		{
	   			config:{
				    name:'id_depto_lb',
				    hiddenName: 'id_depto_lb',
				    //url: '../../sis_parametros/control/Depto/listarDepto',
	   				origen: 'DEPTO',
	   				allowBlank: false,
	   				fieldLabel: 'Libro de bancos destino',
	   				disabled: false,
	   				width: '80%',
			        baseParams: { estado:'activo', codigo_subsistema: 'TES',modulo:'LB',tipo_filtro:'DEPTO_UO' },
			        gdisplayField:'desc_depto_lb',
                    gwidth: 150
	   			},
	   			//type:'TrigguerCombo',
	   			filters:{pfiltro:'depto.nombre',type:'string'},
	   			type:'ComboRec',
	   			id_grupo: 1,
	   			form: true,
	   			grid: true
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
				filters:{pfiltro:'est.estado_reg',type:'string'},
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
				filters:{pfiltro:'est.fecha_reg',type:'date'},
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
				filters:{pfiltro:'est.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'est.usuario_ai',type:'string'},
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
				filters:{pfiltro:'est.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Estación',
	ActSave:'../../sis_tesoreria/control/Estacion/insertarEstacion',
	ActDel:'../../sis_tesoreria/control/Estacion/eliminarEstacion',
	ActList:'../../sis_tesoreria/control/Estacion/listarEstacion',
	id_store:'id_estacion',
	fields: [
		{name:'id_estacion', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'codigo', type: 'string'},
		{name:'desc_depto_lb', type: 'string'},
		{name:'host', type: 'string'},
		{name:'puerto', type: 'string'},
		{name:'dbname', type: 'string'},
		{name:'usuario', type: 'string'},		
		{name:'id_depto_lb', type: 'numeric'},
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
		field: 'id_estacion',
		direction: 'ASC'
	},
	south:{
		  url:'../../../sis_tesoreria/vista/estacion_tipo_pago/EstacionTipoPago.php',
		  title:'Tipo de Pago por Estacion', 
		  height:'50%',
		  cls:'EstacionTipoPago'
	}, 
	bdel:true,
	bsave:true
	}
)
</script>
		
		