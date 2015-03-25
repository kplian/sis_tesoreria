<?php
/**
 * @package pxP
 * @file 	CuentaBancariaENDESIS.php
 * @author 	Gonzalo Sarmiento
 * @date	21-09-2012
 * @description	Archivo con la interfaz de usuario que permite la ejecucion de las funcionales del sistema
 */
header("content-type:text/javascript; charset=UTF-8");
?>
<script>
	Phx.vista.CuentaBancariaENDESIS = Ext.extend(Phx.gridInterfaz, {
		constructor : function(config) {
			this.maestro = config.maestro;
			this.initButtons=[this.cmbDepto];
			Phx.vista.CuentaBancariaENDESIS.superclass.constructor.call(this, config);
			this.init();
			this.cmbDepto.on('select',this.capturaFiltros,this);
			/*this.load({
				params : {
					start : 0,
					limit : 50,
					permiso : 'todos,libro_bancos'
				}
			});*/
			this.addButton('btnDepositosCheques', {
				text : 'Depositos y Cheques',
				iconCls : 'bmoney',
				disabled : true,
				handler : this.onBtnDepositosCheques,
				tooltip : '<b>Despositos y cheques</b>'
			});
		},
		
		capturaFiltros:function(combo, record, index){
			this.store.baseParams.id_depto_lb=this.cmbDepto.getValue();
			this.store.load({params:{start:0, limit:50, permiso : 'libro_bancos'}});	
		},
		
		cmbDepto:new Ext.form.ComboBox({
			fieldLabel: 'Departamento',
			allowBlank: true,
			emptyText:'Departamento...',
			store:new Ext.data.JsonStore(
			{
				url: '../../sis_parametros/control/Depto/listarDeptoFiltradoDeptoUsuario',
				id: 'id_depto',
				root: 'datos',
				sortInfo:{
					field: 'deppto.nombre',
					direction: 'ASC'
				},
				totalProperty: 'total',
				fields: ['id_depto','nombre'],
				// turn on remote sorting
				remoteSort: true,
				baseParams:{par_filtro:'nombre',tipo_filtro:'DEPTO_UO',estado:'activo',codigo_subsistema:'TES',modulo:'LB'}
			}),
			valueField: 'id_depto',
			triggerAction: 'all',
			displayField: 'nombre',
			hiddenName: 'id_depto',
			mode:'remote',
			pageSize:50,
			queryDelay:500,
			listWidth:'280',
			width:250
		}),
		
		onBtnDepositosCheques : function() {
			var rec = this.sm.getSelected();
			Phx.CP.loadWindows('../../../sis_migracion/vista/ts_libro_bancos_depositos/TsLibroBancosDeposito.php', 'Depositos', {
				modal : true,
				width : '95%',
				height : '95%',
			}, rec.data, this.idContenedor, 'TsLibroBancosDeposito');
		},
		
		Atributos : [{
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'id_cuenta_bancaria'
			},
			type : 'Field',
			form : true
			},
			{
			config: {
				name: 'id_institucion',
				fieldLabel: 'Institucion',
				tinit: true,
				allowBlank: false,
				origen: 'INSTITUCION',
				baseParams:{es_banco:'si'},
				gdisplayField: 'nombre_institucion',
				gwidth: 200,
				renderer:function (value, p, record){return String.format('{0}', record.data['nombre_institucion']);}
			},
			type: 'ComboRec',
			id_grupo: 0,
			filters:{pfiltro:'inst.nombre',type:'string'},
			grid: true,
			form: true
		},
		
		{
			config:{
				name: 'nro_cuenta',
				fieldLabel: 'Nro Cuenta',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:50
			},
			type:'TextField',
			filters:{pfiltro:'ctaban.nro_cuenta',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		
		{
			config:{
				name: 'denominacion',
				fieldLabel: 'Denominación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 250,
				maxLength:100
			},
			type:'TextField',
			filters:{pfiltro:'ctaban.denominacion',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'centro',
				fieldLabel: 'Central',
				allowBlank: false,
				anchor: '60%',
				gwidth: 100,
				maxLength:25,
				typeAhead:true,
				triggerAction:'all',
				mode:'local',
				store:['si','no']
			},
			valorInicial:'no',
			type:'ComboBox',
			filters:{pfiltro:'ctaban.centro',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'fecha_alta',
				fieldLabel: 'Fecha Alta',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'ctaban.fecha_alta',type:'date'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
            config:{
                name:'id_moneda',
                origen:'MONEDA',
                allowBlank:true,
                fieldLabel:'Moneda',
                gdisplayField:'codigo_moneda',//mapea al store del grid
                gwidth:50,
              //   renderer:function (value, p, record){return String.format('{0}', record.data['codigo_moenda']);}
             },
            type:'ComboRec',
            id_grupo:1,
            filters:{   
                pfiltro:'mon.codigo',
                type:'string'
            },
            grid:true,
            form:true
          },
		{
			config:{
				name: 'fecha_baja',
				fieldLabel: 'Fecha Baja',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'ctaban.fecha_baja',type:'date'},
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
			filters:{pfiltro:'ctaban.estado_reg',type:'string'},
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
			filters:{pfiltro:'ctaban.fecha_reg',type:'date'},
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
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'ctaban.fecha_mod',type:'date'},
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
		}],
		title : 'Depositos y Cheques',
		ActSave:'../../sis_tesoreria/control/CuentaBancaria/insertarCuentaBancaria',
		ActDel:'../../sis_tesoreria/control/CuentaBancaria/eliminarCuentaBancaria',
		ActList:'../../sis_tesoreria/control/CuentaBancaria/listarCuentaBancariaUsuario',
		id_store : 'id_cuenta_bancaria',
		fields: [
		{name:'id_cuenta_bancaria', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'fecha_baja', type: 'date',dateFormat:'Y-m-d'},
		{name:'nro_cuenta', type: 'string'},
		{name:'denominacion', type: 'string'},
		{name:'centro', type: 'string'},
		{name:'fecha_alta', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_institucion', type: 'numeric'},
		{name:'nombre_institucion', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'id_moneda','codigo_moneda'
		
	],
		sortInfo : {
			field : 'id_cuenta_bancaria',
			direction : 'ASC'
		},
		bdel:false,
		bsave:false,
		bnew:false,
		bedit:false,
	
		fwidth : 420,
		fheight : 250,
		
		preparaMenu : function(tb) {
			Phx.vista.CuentaBancariaENDESIS.superclass.preparaMenu.call(this, tb);
			var rec = this.sm.getSelected();
			var data = rec.data;
			
			if (data['id_moneda']==null){
				this.getBoton('btnDepositosCheques').disable();
			  }else{
				this.getBoton('btnDepositosCheques').enable();
			  }
		},
		/*
		liberaMenu : function() {
			Phx.vista.CuentaBancariaENDESIS.superclass.liberaMenu.call(this);
			this.getBoton('btnCuentaBancariaENDESISUsuario').disable();
			this.getBoton('btnSwitchEstado').disable();
			this.getBoton('btnGestion').disable();
		}*/
}); 
</script>