<?php
/**
*@package pXP
*@file gen-Caja.php
*@author  (admin)
*@date 16-12-2013 20:43:44
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Caja=Ext.extend(Phx.gridInterfaz,{
		
	nombreVista: 'caja',
	
	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Caja.superclass.constructor.call(this,config);
		this.init();
		this.iniciarEventos();
		
		this.addButton('btnAbrirCerrar',
			{
				text: 'Cerrar/Abrir',
				iconCls: 'block',
				disabled: false,
				handler: this.abrirCerrarCaja,
				tooltip: '<b>Cerrar/Abrir</b><br/>Cerrar/Abrir caja'
			}
		);
		
		this.load({params:{start:0, limit:this.tam_pag, tipo_interfaz: this.nombreVista}})
	},
	tam_pag:50,
			
	Atributos:[
		{
			//configuracion del componente
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
				name: 'codigo',
				fieldLabel: 'Código',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:20
			},
			type:'TextField',
			filters:{pfiltro:'caja.codigo',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
            config:{
                name: 'nro_tramite',
                fieldLabel: 'Num. Tramite',
                allowBlank: true,
                anchor: '80%',
                gwidth: 130,
                maxLength:200
            },
            type:'TextField',
            filters:{pfiltro:'lban.num_tramite',type:'string'},
			bottom_filter: true,
            id_grupo:1,
            grid:true,
            form:false
        },
		{     
			config:{
				    name:'id_depto',
        origen:'DEPTO',
        fieldLabel: 'Departamento',
        url: '../../sis_parametros/control/Depto/listarDepto',
        emptyText : 'Departamento...',
        allowBlank:false,
        gdisplayField:'desc_depto',//mapea al store del grid
        gwidth:200,
		baseParams:{tipo_filtro:'DEPTO_UO',estado:'activo',codigo_subsistema:'TES',modulo:'OP'},
        renderer:function (value, p, record){return String.format('{0}', record.data['desc_depto']);}
   },   
        type:'ComboRec',
        id_grupo:0,
        filters:{pfiltro:'cc.codigo_cc',type:'string'},
        grid:true,
        form:true
			},
		{
			config:{
				name: 'tipo',
				fieldLabel: 'Tipo',
				allowBlank: false,
				emptyText:'Tipo...',
				typeAhead: true,
				triggerAction: 'all',
				lazyRender:true,
				mode: 'local',
				anchor: '80%',
				gwidth: 100,
				store:['fondo_rotativo','caja_chica']
			},
			type:'ComboBox',
			filters:{type: 'list',
					 pfiltro:'caja.tipo',
					 options: ['fondo_rotativo','caja_chica']},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'tipo_ejecucion',
				fieldLabel: 'Tipo Ejecucion',
				allowBlank: false,
				emptyText:'Tipo Ejecucion...',
				typeAhead: true,
				triggerAction: 'all',
				lazyRender:true,
				mode: 'local',
				anchor: '80%',
				gwidth: 100,
				store:['con_detalle','sin_detalle']
			},
			type:'ComboBox',
			filters:{pfiltro:'caja.tipo_ejecucion',
					 type:'list',
					 options: ['con_detalle','sin_detalle']},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
            config:{
                name: 'id_cuenta_bancaria',
                fieldLabel: 'Cuenta Bancaria',
                allowBlank: false,
                emptyText:'Elija una Cuenta...',
                store:new Ext.data.JsonStore(
                {
                    url: '../../sis_tesoreria/control/CuentaBancaria/listarCuentaBancariaUsuario',
                    id: 'id_cuenta_bancaria',
                    root:'datos',
                    sortInfo:{
                        field:'id_cuenta_bancaria',
                        direction:'ASC'
                    },
                    totalProperty:'total',
                    fields: ['id_cuenta_bancaria','nro_cuenta','nombre_institucion','codigo_moneda','centro','denominacion'],
                    remoteSort: true,
                    baseParams : {
						par_filtro :'nro_cuenta', permiso:'libro_bancos'
					}
                }),
                tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{nro_cuenta}</b></p><p>Moneda: {codigo_moneda}, {nombre_institucion}</p><p>{denominacion}, Centro: {centro}</p></div></tpl>',
                valueField: 'id_cuenta_bancaria',
                hiddenValue: 'id_cuenta_bancaria',
                displayField: 'nro_cuenta',
                gdisplayField:'desc_cuenta_bancaria',
                listWidth:'280',
                forceSelection:true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:20,
                queryDelay:500,
                gwidth: 250,
                minChars:2,
                renderer:function(value, p, record){return String.format('{0}', record.data['desc_cuenta_bancaria']);}
             },
            type:'ComboBox',
            filters:{pfiltro:'cb.nro_cuenta',type:'string'},
            id_grupo:1,
            grid:false,
            form:true
        },
		{
			config:{
				name: 'importe_maximo',
				fieldLabel: 'Importe máximo',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
			type:'NumberField',
			filters:{pfiltro:'caja.importe_maximo',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'porcentaje_compra',
				fieldLabel: 'Porcentaje  compra',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:393218
			},
			type:'NumberField',
			filters:{pfiltro:'caja.porcentaje_compra',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
     config:{
        name:'id_moneda',
        origen:'MONEDA',
        fieldLabel: 'Moneda',
        url: '../../sis_parametros/control/Moneda/listarMoneda',
        emptyText : 'Moneda...',
        allowBlank:false,
        gdisplayField:'desc_moneda',//mapea al store del grid
        gwidth:100,
        renderer:function (value, p, record){return String.format('{0}', record.data['desc_moneda']);}
     },
        type:'ComboRec',
        id_grupo:0,
        filters:{pfiltro:'cc.codigo_cc',type:'string'},
        grid:true,
        form:true
  },    
		{
			config:{
				name: 'estado',
				fieldLabel: 'Estado',
				allowBlank: false,
				emptyText:'Estado...',
				typeAhead: true,
				triggerAction: 'all',
				lazyRender:true,
				mode: 'local',
				anchor: '80%',
				gwidth: 100,
				store:['abierto','cerrado']
			},
			type:'ComboBox',
			filters:{pfiltro:'caja.estado',
					 type:'list',
					 options: ['abierto','cerrado']},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'estado_proceso',
				fieldLabel: 'Estado Proceso',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
			type:'TextField',
			filters:{pfiltro:'caja.estado_reg',type:'string'},
			id_grupo:1,
			grid:true,
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
			filters:{pfiltro:'caja.estado_reg',type:'string'},
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
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'caja.fecha_reg',type:'date'},
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
			filters:{pfiltro:'caja.fecha_mod',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		}
	],
	
	title:'Solicitud Apertura Cierre Caja',
	ActSave:'../../sis_tesoreria/control/Caja/insertarCaja',
	ActDel:'../../sis_tesoreria/control/Caja/eliminarCaja',
	ActList:'../../sis_tesoreria/control/Caja/listarCaja',
	id_store:'id_caja',
	fields: [
		{name:'id_caja', type: 'numeric'},
		{name:'nro_tramite', type: 'string'},
		{name:'estado', type: 'string'},
		{name:'importe_maximo', type: 'numeric'},
		{name:'tipo', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'estado_proceso', type: 'string'},
		{name:'porcentaje_compra', type: 'numeric'},
		{name:'id_moneda', type: 'numeric'},
		{name:'fecha', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_depto', type: 'numeric'},
		{name:'id_cuenta_bancaria', type: 'numeric'},
		{name:'cuenta_bancaria', type: 'string'},
		{name:'id_proceso_wf', type: 'numeric'},
		{name:'id_estado_wf', type: 'numeric'},
		{name:'codigo', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'desc_moneda', type: 'string'},
		{name:'desc_depto', type: 'string'},
		{name:'tipo_ejecucion', type: 'string'}
	],
	sortInfo:{
		field: 'id_caja',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	
	preparaMenu:function(n){
         var data = this.getSelectedData();
         
         if(data.estado_proceso == 'borrador'){  
		    this.getBoton('btnAbrirCerrar').enable();
			this.getBoton('edit').enable();
			this.getBoton('del').enable();
         }
		 else{
			 this.getBoton('edit').disable();
			 this.getBoton('del').disable();
			 if(data.estado_proceso =='abierto')
				 this.getBoton('btnAbrirCerrar').enable();			 
			 else
				this.getBoton('btnAbrirCerrar').disable();
		 }		 
     },
    /*
    liberaMenu:function(){
        var tb = Phx.vista.Caja.superclass.liberaMenu.call(this);
        
        if(tb){
           this.getBoton('ant_estado').disable();
           this.getBoton('ini_estado').disable();
           this.getBoton('sig_estado').disable();     
        }
       return tb
    }, 
	*/
	/*	
	abrirCerrarCaja:function(){ 
		var rec=this.sm.getSelected();
		var NumSelect=this.sm.getCount();
		
		if(NumSelect != 0)
		{	
			if(rec.data.estado=='cerrado'){
				Phx.CP.loadWindows('../../../sis_tesoreria/vista/apertura_caja/AperturaCaja.php',
				'Apertura Caja',
				{
					modal:true,
					width:450,
					height:450
				}, {data:rec.data}, this.idContenedor,'AperturaCaja',
				{
					config:[{
							  event:'beforesave',
							  delegate: this.transferir,
							}
							],
				   scope:this
				 })
			}
		}
		else
		{
			Ext.MessageBox.alert('Alerta', 'Antes debe seleccionar un item.');
		}							   
	},
	*/
	
	abrirCerrarCaja:function(){
		var rec=this.sm.getSelected();
		var NumSelect=this.sm.getCount();
		
		if(NumSelect != 0)
		{	
		  if(rec.data.estado=='cerrado'){
			  this.objWizard = Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php',
							'Estado de Wf',
							{
								modal:true,
								width:700,
								height:450
							}, {data:{
								   id_estado_wf:rec.data.id_estado_wf,
								   id_proceso_wf:rec.data.id_proceso_wf								  
								}}, this.idContenedor,'FormEstadoWf',
							{
								config:[{
										  event:'beforesave',
										  delegate: this.onSaveWizard												  
										}],
								
								scope:this
							 });
		  }
		}
		else
		{
			Ext.MessageBox.alert('Alerta', 'Antes debe seleccionar un item.');
		}					   
	},
		
	onSaveWizard:function(wizard,resp){
		Phx.CP.loadingShow();
		
		Ext.Ajax.request({
			url:'../../sis_tesoreria/control/Caja/siguienteEstadoCaja',
			params:{
					
				id_proceso_wf_act:  resp.id_proceso_wf_act,
				id_estado_wf_act:   resp.id_estado_wf_act,
				id_tipo_estado:     resp.id_tipo_estado,
				id_funcionario_wf:  resp.id_funcionario_wf,
				id_depto_wf:        resp.id_depto_wf,
				obs:                resp.obs,
				json_procesos:      Ext.util.JSON.encode(resp.procesos)
				},
			success:this.successWizard,
			failure: this.conexionFailure,
			argument:{wizard:wizard},
			timeout:this.timeout,
			scope:this
		});
	},
	/*
	successWizard:function(resp){
		Phx.CP.loadingHide();
		resp.argument.wizard.panel.destroy()
		Phx.CP.getPagina(this.idContenedorPadre).reload();  
		//this.reload();
	},*/
	
	transferir:function(wizard,resp){
		Phx.CP.loadingShow();
		Ext.Ajax.request({
			url:'../../sis_tesoreria/control/Caja/abrirCerrarCaja',
			params:{					
                   id_depto_lb:resp.id_depto,
				   id_cuenta_bancaria:resp.id_cuenta_bancaria,
				   fecha:resp.fecha,
				   a_favor:resp.a_favor,
				   detalle:resp.detalle,
				   importe:resp.importe,
				   id_finalidad:resp.id_finalidad,
				   estado:resp.estado,
				   id_caja: resp.id_caja
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
	
	successAbrirCerrarCaja:function(resp){
       Phx.CP.loadingHide();
       var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
       if(!reg.ROOT.error){
         this.reload();
       }
    },
		
	south : {
			url : '../../../sis_tesoreria/vista/cajero/Cajero.php',
			title : 'Cajero',
			height : '50%',
			cls : 'Cajero'
		},
	}
	
)
</script>
		
		