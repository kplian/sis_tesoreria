<?php
/**
*@package pXP
*@file gen-Finalidad.php
*@author  (gsarmiento)
*@date 02-12-2014 13:11:02
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Finalidad=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Finalidad.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag, vista:''}})
		this.crearFormTipoInterfaz();
		this.addButton('inserInterfaz',{ text: 'Configurar Interfaz', iconCls: 'blist', disabled: false, handler: this.mostarFormTipoInterfaz, tooltip: '<b>Configurar interfaces</b><br/>Permite seleccionar que interfaces manejara la finalidad'});
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_finalidad'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'estado',
				fieldLabel: 'estado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:20
			},
				type:'TextField',
				filters:{pfiltro:'fin.estado',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'color',
				fieldLabel: 'color',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:50
			},
				type:'TextField',
				filters:{pfiltro:'fin.color',type:'string'},
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
				filters:{pfiltro:'fin.estado_reg',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'nombre_finalidad',
				fieldLabel: 'Nombre Finalidad',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
				type:'TextField',
				filters:{pfiltro:'fin.nombre_finalidad',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
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
				filters:{pfiltro:'fin.id_usuario_ai',type:'numeric'},
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
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'fin.fecha_reg',type:'date'},
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
				filters:{pfiltro:'fin.usuario_ai',type:'string'},
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
				filters:{pfiltro:'fin.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Finalidad',
	ActSave:'../../sis_tesoreria/control/Finalidad/insertarFinalidad',
	ActDel:'../../sis_tesoreria/control/Finalidad/eliminarFinalidad',
	ActList:'../../sis_tesoreria/control/Finalidad/listarFinalidad',
	id_store:'id_finalidad',
	fields: [
		{name:'id_finalidad', type: 'numeric'},
		{name:'estado', type: 'string'},
		{name:'color', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'nombre_finalidad', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'sw_tipo_interfaz', type: 'string'}
		
	],
	sortInfo:{
		field: 'id_finalidad',
		direction: 'ASC'
	},
	bdel:true,
	bsave:false,
	bedit:true,
	bnew:true,
	/*
	onReloadPage:function(m)
	{
		this.maestro=m;						
		//this.store.baseParams={id_cuenta_bancaria:this.maestro.id_cuenta_bancaria,vista:'cuenta_bancaria'};
		this.load({params:{start:0, limit:50}});			
	},*/
	
	//formulario de operaciones
	crearFormTipoInterfaz:function(){
		  this.formTipoInterfaz = new Ext.form.FormPanel({
            baseCls: 'x-plain',
            autoDestroy: true,
           
            border: false,
            layout: 'form',
             autoHeight: true,
           
    
            items: [
                 {
       				name:'sw_tipo_interfaz',
       				xtype:"awesomecombo",
       				fieldLabel:'Modulos',
       				allowBlank: true,
       				emptyText:'Modulos...',
       				store: new Ext.data.ArrayStore({
                        fields: ['variable', 'valor'],
                        data : [ ['caja_chica', 'Caja Chica'],
                                 ['fondos_avance', 'Fondos con Cargo a Rendición de Cuentas']
                               ]
                        }),
       				valueField: 'variable',
				    displayField: 'valor',
				    mode: 'local',
	       		    forceSelection:true,
       				typeAhead: true,
           			triggerAction: 'all',
           			lazyRender: true,
       				queryDelay: 1000,
       				width: 250,
       				minChars: 2 ,
	       			enableMultiSelect: true
       			}]
        });
        
		
		
		this.wTipoInterfaz = new Ext.Window({
            title: 'Configuracion',
            collapsible: true,
            maximizable: true,
            autoDestroy: true,
            width: 380,
            height: 170,
            layout: 'fit',
            plain: true,
            bodyStyle: 'padding:5px;',
            buttonAlign: 'center',
            items: this.formTipoInterfaz,
            modal:true,
             closeAction: 'hide',
            buttons: [{
                text: 'Guardar',
                handler: this.saveTipoInterfaz,
                scope: this
                
            },
             {
                text: 'Cancelar',
                handler: function(){ this.wTipoInterfaz.hide() },
                scope: this
            }]
        });
        
         this.cmpTipoInterfaz = this.formTipoInterfaz.getForm().findField('sw_tipo_interfaz');
                  
	},
	
	mostarFormTipoInterfaz:function(){
		var data = this.getSelectedData();
		if(data){
			this.cmpTipoInterfaz.setValue(data.sw_tipo_interfaz);
			this.wTipoInterfaz.show();
		}		
	},
	
	saveTipoInterfaz: function(){
		    var d = this.getSelectedData();
		    Phx.CP.loadingShow();
            Ext.Ajax.request({
                url: '../../sis_tesoreria/control/Finalidad/editTipoInterfaz',
                params: { 
                	      sw_tipo_interfaz: this.cmpTipoInterfaz.getValue(),
                	      id_finalidad: d.id_finalidad
                	    },
                success: this.successSinc,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });		
	},
	
	successSinc:function(resp){
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
            	if(this.wTipoInterfaz){
            		this.wTipoInterfaz.hide(); 
            	}                
                this.reload();
             }else{
                alert('ocurrio un error durante el proceso')
            }
    }

}
	
	
)
</script>
		
		