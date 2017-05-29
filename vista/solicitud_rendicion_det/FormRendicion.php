<?php
/**
*@package pXP
*@file FormRendicion.php
*@author  Gonzalo Sarmiento 
*@date 16-02-2016
*@description Archivo con la interfaz de usuario que permite 
*ingresar el documento a rendir
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.FormRendicion = {
	require:'../../../sis_contabilidad/vista/doc_compra_venta/FormCompraVenta.php',
	ActSave:'../../sis_tesoreria/control/SolicitudRendicionDet/insertarRendicionDocCompleto',
	requireclase:'Phx.vista.FormCompraVenta',
	mostrarFormaPago : false,
	autorizacion: 'caja_chica',
	autorizacion_nulos: 'no',
		
	constructor: function(config) {		
	   Phx.vista.FormRendicion.superclass.constructor.call(this,config);
	   this.addEvents('aftersave');
    },
    
	onNew: function(){    	
    	Phx.vista.FormRendicion.superclass.onNew.call(this);
        this.Cmp.id_solicitud_efectivo.setValue(this.data.id_solicitud_efectivo);	 
	},
	
	onEdit: function(){    	
    	Phx.vista.FormRendicion.superclass.onEdit.call(this);		
        this.Cmp.id_solicitud_efectivo.setValue(this.data.id_solicitud_efectivo);
		this.cargarPeriodo();		
	},
	
	iniciarEventos: function(config){
		
		Phx.vista.FormRendicion.superclass.iniciarEventos.call(this,config);
		
		this.Cmp.dia.hide();
		this.Cmp.fecha.setReadOnly(false);
		
		this.Cmp.id_depto_conta.store = new Ext.data.JsonStore({
			url: '../../sis_parametros/control/DeptoDepto/listarDeptoDepto',
			id: 'id_depto',
			root: 'datos',
			sortInfo: {
				field: 'nombre',
				direction: 'ASC'
			},
			totalProperty: 'total',
			fields: ['id_depto_depto', 'id_depto_destino'],
			remoteSort: true,
			baseParams: {id_depto: this.data.id_depto, id_subsistema : 10}
		});
		
		this.Cmp.id_depto_conta.store.load({params:{start:0,limit:this.tam_pag}, 
		   callback : function (r) {
				Phx.CP.loadingHide();  
				if (r.length == 1 ) {                        
					this.Cmp.id_depto_conta.setValue(r[0].data.id_depto_destino);
				}else{
					alert('Depto Conta no recuperado');
				}     								
			}, scope : this
		});
		
		this.Cmp.fecha.on('change', this.cargarPeriodo, this);
		
		       
	},	
    
	cargarPeriodo: function(obj){
	//Busca en la base de datos la razon social en funci�n del NIT digitado. Si Razon social no esta vac�o, entonces no hace nada
		if(this.getComponente('fecha').getValue()!=''){
		Phx.CP.loadingShow();
		Ext.Ajax.request({
			url:'../../sis_parametros/control/Periodo/listarPeriodo',
			params:{ start:0, limit:30, 'fecha': this.getComponente('fecha').getValue().format('d-m-Y')},
			success: function(resp){
				Phx.CP.loadingHide();
				var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));								
				var idGestion=objRes.datos[0].id_gestion;
				this.Cmp.id_gestion.setValue(idGestion);
				this.Cmp.dia.setValue(this.getComponente('fecha').getValue().getDate());
			},
			failure: this.conexionFailure,
			timeout: this.timeout,
			scope:this
		});
		}
	},
	successSave:function(resp)
    {
		Phx.CP.loadingHide();
		//if(typeof(Phx.CP.getPagina(this.idContenedorPadre).onReloadPadre) !='undefined'){
		//	Phx.CP.getPagina(this.idContenedorPadre).onReloadPadre();
		//}
		//else{
		Phx.CP.getPagina(this.idContenedorPadre).reload();
		//}

		if(Phx.CP.getPagina(this.idContenedorPadre).cls =='AprobacionFacturas'){
			//console.log(Phx.CP.getPagina(this.idContenedorPadre));
			Phx.CP.getPagina(this.idContenedorPadre).onReloadPadre();
			console.log('gonzalo');
			console.log(Phx.CP.getPagina(this.idContenedorPadre));
		}
		//console.log('jose');
		//var padre = Phx.CP.getPagina(this.idContenedorPadre);
		//padre.reload();
		//padre.onReloadPadre();
		//console.log(Phx.CP.getPagina(this.idContenedorPadre));
		//console.log(Phx.CP.getPagina(this.idContenedorPadre));
        this.panel.close();
		//this.fireEvent('beforesave',this);
    },	
};
</script>
