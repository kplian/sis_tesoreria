<?php
/**
*@package pXP
*@file gen-SolicitudTransferencia.php
*@author  (admin)
*@date 22-02-2018 03:43:11
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.SolicitudTransferencia=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.SolicitudTransferencia.superclass.constructor.call(this,config);
		this.init();
		
		this.addButton('sig_estado',{grupo:[0],text:'Siguiente',iconCls: 'badelante',disabled:true,handler:this.sigEstado,tooltip: '<b>Pasar al Siguiente Estado</b>'});
		this.addButton('diagrama_gantt',{grupo:[0,1,2],text:'Gant',iconCls: 'bgantt',disabled:true,handler:diagramGantt,tooltip: '<b>Diagrama Gantt de proceso macro</b>'});
  		function diagramGantt(){            
            var data=this.sm.getSelected().data.id_proceso_wf;
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url:'../../sis_workflow/control/ProcesoWf/diagramaGanttTramite',
                params:{'id_proceso_wf':data},
                success:this.successExport,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });         
        } 
        this.store.baseParams.interfaz = 'solicitud';
		this.store.baseParams.pes_estado = 'borrador';
		this.load({params:{start:0, limit:this.tam_pag}});
		this.finCons = true;
	},
	beditGroups: [0],
    bdelGroups:  [0],
    bactGroups:  [0,1,2],
    btestGroups: [0],
    bexcelGroups: [0,1,2],
    
    gruposBarraTareas:[{name:'borrador',title:'<H1 align="center"><i class="fa fa-eye"></i> Solicitud</h1>',grupo:0,height:0},
						{name:'pendiente_validacion',title:'<H1 align="center"><i class="fa fa-eye"></i> Pendiente Aprobacion</h1>',grupo:1,height:0},
                       {name:'validado',title:'<H1 align="center"><i class="fa fa-eye"></i> Aprobada</h1>',grupo:2,height:0}
                       
                       ],
    actualizarSegunTab: function(name, indice){
        if(this.finCons) {        	 
             this.store.baseParams.pes_estado = name;                           
             this.load({params:{start:0, limit:this.tam_pag}});
        }
    },
		                    	
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_solicitud_transferencia'
			},
			type:'Field',
			form:true 
		},
		
		{
			config:{
				name: 'num_tramite',
				fieldLabel: 'No Tramite',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:25
			},
				type:'TextField',
				filters:{pfiltro:'soltra.num_tramite',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
          config:{
            name: 'id_cuenta_origen',
            fieldLabel: 'Cuenta Origen',
            allowBlank: true,
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
                par_filtro :'nro_cuenta#denominacion', permiso: 'todos'
              }
              }),
            tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{nro_cuenta}</b></p><p>Moneda: {codigo_moneda}, {nombre_institucion}</p><p>{denominacion}, Centro: {centro}</p></div></tpl>',
            valueField: 'id_cuenta_bancaria',
            hiddenValue: 'id_cuenta_origen',
            displayField: 'nro_cuenta',
            gdisplayField:'desc_cuenta_origen',
            listWidth:'280',
            forceSelection:true,
            typeAhead: false,
            triggerAction: 'all',
            lazyRender:true,
            mode:'remote',
            pageSize:20,
            queryDelay:500,
            gwidth: 250,
            anchor: '70%',
            minChars:2,
            renderer:function(value, p, record){return String.format('{0}', record.data['desc_cuenta_origen']);}
        },
        type:'ComboBox',
        filters:{pfiltro:'cbo.nro_cuenta',type:'string'},
        id_grupo:1,
        grid:true,
        form:true
      },
		{
          config:{
            name: 'id_cuenta_destino',
            fieldLabel: 'Cuenta Destino',
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
                par_filtro :'nro_cuenta#denominacion', permiso: 'todos'
              }
              }),
            tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{nro_cuenta}</b></p><p>Moneda: {codigo_moneda}, {nombre_institucion}</p><p>{denominacion}, Centro: {centro}</p></div></tpl>',
            valueField: 'id_cuenta_bancaria',
            hiddenValue: 'id_cuenta_destino',
            displayField: 'nro_cuenta',
            gdisplayField:'desc_cuenta_destino',
            listWidth:'280',
            forceSelection:true,
            typeAhead: false,
            triggerAction: 'all',
            lazyRender:true,
            mode:'remote',
            pageSize:20,
            queryDelay:500,
            gwidth: 250,
            anchor: '70%',
            minChars:2,
            renderer:function(value, p, record){return String.format('{0}', record.data['desc_cuenta_destino']);}
        },
        type:'ComboBox',
        filters:{pfiltro:'cbd.nro_cuenta',type:'string'},
        id_grupo:1,
        grid:true,
        form:true
      },
		
		{
			config:{
				name: 'monto',
				fieldLabel: 'Monto',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'soltra.monto',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'motivo',
				fieldLabel: 'Motivo',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100
			},
				type:'TextArea',
				filters:{pfiltro:'soltra.motivo',type:'string'},
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
				filters:{pfiltro:'soltra.estado_reg',type:'string'},
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
				filters:{pfiltro:'soltra.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'soltra.fecha_reg',type:'date'},
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
				filters:{pfiltro:'soltra.usuario_ai',type:'string'},
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
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'soltra.fecha_mod',type:'date'},
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
		}
	],
	tam_pag:50,	
	title:'Solicitud Transferencia',
	ActSave:'../../sis_tesoreria/control/SolicitudTransferencia/insertarSolicitudTransferencia',
	ActDel:'../../sis_tesoreria/control/SolicitudTransferencia/eliminarSolicitudTransferencia',
	ActList:'../../sis_tesoreria/control/SolicitudTransferencia/listarSolicitudTransferencia',
	id_store:'id_solicitud_transferencia',
	fields: [
		{name:'id_solicitud_transferencia', type: 'numeric'},
		{name:'id_cuenta_origen', type: 'numeric'},
		{name:'id_cuenta_destino', type: 'numeric'},
		{name:'desc_cuenta_origen', type: 'string'},
		{name:'desc_cuenta_destino', type: 'string'},
		{name:'id_proceso_wf', type: 'numeric'},
		{name:'id_estado_wf', type: 'numeric'},
		{name:'monto', type: 'numeric'},
		{name:'motivo', type: 'string'},
		{name:'estado', type: 'string'},
		{name:'num_tramite', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_solicitud_transferencia',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	
	onButtonNew : function () {
    	this.ocultarComponente(this.Cmp.id_cuenta_origen);    	
    	Phx.vista.SolicitudTransferencia.superclass.onButtonNew.call(this);
    	
    },
    onButtonEdit : function () {
    	this.ocultarComponente(this.Cmp.id_cuenta_origen);    	
    	Phx.vista.SolicitudTransferencia.superclass.onButtonEdit.call(this);
    	
    },
    
	preparaMenu:function()
    {	var rec = this.sm.getSelected();
        this.getBoton('diagrama_gantt').enable();        
        this.getBoton('sig_estado').enable();      
        Phx.vista.SolicitudTransferencia.superclass.preparaMenu.call(this);   	        
        
    },
    liberaMenu:function()
    {	
        this.getBoton('diagrama_gantt').disable();        
        this.getBoton('sig_estado').disable();      
        Phx.vista.SolicitudTransferencia.superclass.liberaMenu.call(this);
    },
	sigEstado:function(){                   
      var rec=this.sm.getSelected();
      this.objWizard = Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php',
                                'Estado de Wf',
                                {
                                    modal:true,
                                    width:700,
                                    height:450
                                }, {data:{
                                       id_estado_wf:rec.data.id_estado_wf,
                                       id_proceso_wf:rec.data.id_proceso_wf,
                                    
                                    }}, this.idContenedor,'FormEstadoWf',
                                {
                                    config:[{
                                              event:'beforesave',
                                              delegate: this.onSaveWizard,
                                              
                                            }],
                                    
                                    scope:this
                                 });        
               
     },
     
    
     onSaveWizard:function(wizard,resp){
        Phx.CP.loadingShow();
        
        Ext.Ajax.request({
            url:'../../sis_tesoreria/control/SolicitudTransferencia/siguienteEstadoSolicitud',
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
     
    successWizard:function(resp){
        Phx.CP.loadingHide();
        resp.argument.wizard.panel.destroy()
        this.reload();
     },
	}
)
</script>
		
		