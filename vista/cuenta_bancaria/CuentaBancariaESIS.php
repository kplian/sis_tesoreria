<?php
/**
*@package pXP
*@file MovimientoAlm.php
*@author  Gonzalo Sarmiento
*@date 10-07-2013 10:22:05
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CuentaBancariaESIS = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
	require:'../../../sis_tesoreria/vista/cuenta_bancaria/CuentaBancaria.php',
	requireclase:'Phx.vista.CuentaBancaria',
	title:'Cuenta Bancaria ENDESIS',
	nombreVista: 'cuentaBancariaESIS',
	
	constructor: function(config) {
	    this.maestro=config.maestro;
		
		this.initButtons=[this.cmbDepto];
    	Phx.vista.CuentaBancariaESIS.superclass.constructor.call(this,config);
		
		this.cmbDepto.on('select',this.capturaFiltros,this);
		
		this.addButton('trans_cuenta',
			{	text:'Transfer Cuenta',
				iconCls: 'btransfer',
				disabled:false,
				handler:this.transCuenta,
				tooltip: '<b>Transferencia Cuenta</b><p>Transferencia entre cuentas bancarias</p>'
			}
		);
	    //this.load({params:{start:0, limit:this.tam_pag, permiso : 'todos,libro_bancos'}});
	},
	
	capturaFiltros:function(combo, record, index){
		this.store.baseParams.id_depto_lb=this.cmbDepto.getValue();
		this.store.load({params:{start:0, limit:this.tam_pag, permiso : 'libro_bancos'}});	
	},
      
	preparaMenu:function(n){
      var data = this.getSelectedData();
      var tb =this.tbar;
      Phx.vista.CuentaBancariaESIS.superclass.preparaMenu.call(this,n);  
      return tb 
     }, 

     liberaMenu:function(){
        var tb = Phx.vista.CuentaBancariaESIS.superclass.liberaMenu.call(this);
        return tb
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
	
	transCuenta:function(){ 
		var rec=this.sm.getSelected();
		var NumSelect=this.sm.getCount();
		
		if(NumSelect != 0)
		{						
			Phx.CP.loadWindows('../../../sis_tesoreria/vista/transferencia_cuenta/FormTransferenciaCuenta.php',
			'Transferencia Cuenta',
			{
				modal:true,
				width:450,
				height:450
			}, {data:rec.data, id_depto_lb:this.store.baseParams.id_depto_lb}, this.idContenedor,'FormTransferenciaCuenta',
			{
				config:[{
						  event:'beforesave',
						  delegate: this.transferir,
						}
						],
			   scope:this
			 })
		}
		else
		{
			Ext.MessageBox.alert('Alerta', 'Antes debe seleccionar un item.');
		}							   
	},
	
	transferir:function(wizard,resp){
		Phx.CP.loadingShow();
		Ext.Ajax.request({
			url:'../../sis_tesoreria/control/TsLibroBancos/transferirCuenta',
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
		
    south:
          { 
          url:'../../../sis_tesoreria/vista/ts_libro_bancos/TsLibroBancos.php',
          title:'Detalle', 
          height:'50%',
          cls:'TsLibroBancos'
         }
};
</script>
