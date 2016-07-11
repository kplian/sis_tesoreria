<?php
/**
*@package pXP
*@file SolicitudEfectivoVb.php
*@author  (gsarmiento)
*@date 14-12-2015 12:59:51
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.SolicitudEfectivoVb=Ext.extend(Phx.gridInterfaz,{
		
	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.SolicitudEfectivoVb.superclass.constructor.call(this,config);
		this.init();
					
		this.addButton('ant_estado',
			{	text:'Anterior',
				argument: {estado: 'anterior'},
				iconCls: 'batras',
				disabled:false,
				handler:this.antEstado,
				tooltip: '<b>Anterior</b><p>Pasa al anterior estado</p>'
			}
		);	
		
		this.addButton('fin_registro',
			{	text:'Siguiente',
				iconCls: 'badelante',
				disabled:false,
				handler:this.sigEstado,
				tooltip: '<b>Siguiente</b><p>Pasa al siguiente estado</p>'
			}
		);
				
		this.iniciarEventos();
		this.load({params:{start:0, limit:this.tam_pag, tipo_interfaz:'vbSolicitudEfectivo'}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_solicitud_efectivo'
			},
			type:'Field',
			form:true 
		},
		{
			config: {
				name: 'id_caja',
				fieldLabel: 'Caja',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_tesoreria/control/Caja/listarCaja',
					id: 'id_caja',
					root: 'datos',
					sortInfo: {
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_caja', 'codigo', 'desc_moneda'],
					remoteSort: true,
					baseParams: {par_filtro: 'caja.codigo', tipo_interfaz:'cajaAbierto', con_detalle:'si'}
				}),
				valueField: 'id_caja',
				displayField: 'codigo',
				gdisplayField: 'codigo',
				hiddenName: 'id_caja',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 100,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['codigo']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'caja.codigo',type: 'string'},
			grid: true,
			form: true
		},	
		{
			config:{
				name: 'fecha',
				fieldLabel: 'Fecha',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y',
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'solefe.fecha',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},	
		{
			config:{
				name: 'nro_tramite',
				fieldLabel: 'Num Tramite',
				allowBlank: false,
				anchor: '100%',
				gwidth: 150,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'solefe.nro_tramite',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},	
		{
   			config:{
       		    name:'id_funcionario',
       		     hiddenName: 'id_funcionario',
   				origen:'FUNCIONARIOCAR',
   				fieldLabel:'Funcionario',
   				allowBlank:false,
                gwidth:200,
   				valueField: 'id_funcionario',
   			    gdisplayField: 'desc_funcionario',   			    
      			renderer:function(value, p, record){return String.format('{0}', record.data['desc_funcionario']);}
       	     },
   			type:'ComboRec',//ComboRec
   			id_grupo:0,
   			filters:{pfiltro:'fun.desc_funcionario1',type:'string'},
   			bottom_filter:true,
   		    grid:true,
   			form:true
		 },
		{
			config: {
				name: 'id_estado_wf',
				fieldLabel: 'id_estado_wf',
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
				hiddenName: 'id_estado_wf',
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
			form: false
		},
		{
			config:{
				name: 'monto',
				fieldLabel: 'Monto',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'solefe.monto',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},	
		{
			config: {
				name: 'id_proceso_wf',
				fieldLabel: 'id_proceso_wf',
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
				hiddenName: 'id_proceso_wf',
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
			form: false
		},
		{
			config:{
				name: 'estado',
				fieldLabel: 'Estado',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:50
			},
				type:'TextField',
				filters:{pfiltro:'solefe.estado',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'motivo',
				fieldLabel: 'Motivo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
				type:'TextField',
				filters:{pfiltro:'solefe.motivo',type:'string'},
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
				filters:{pfiltro:'solefe.estado_reg',type:'string'},
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
				filters:{pfiltro:'solefe.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'solefe.fecha_reg',type:'date'},
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
				filters:{pfiltro:'solefe.usuario_ai',type:'string'},
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
				filters:{pfiltro:'solefe.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Solicitud Efectivo Con Detalle',
	ActSave:'../../sis_tesoreria/control/SolicitudEfectivo/insertarSolicitudEfectivo',
	ActDel:'../../sis_tesoreria/control/SolicitudEfectivo/eliminarSolicitudEfectivo',
	ActList:'../../sis_tesoreria/control/SolicitudEfectivo/listarSolicitudEfectivo',
	id_store:'id_solicitud_efectivo',
	fields: [
		{name:'id_solicitud_efectivo', type: 'numeric'},
		{name:'id_caja', type: 'numeric'},
		{name:'codigo', type: 'string'},
		{name:'id_depto', type: 'numeric'},
		{name:'id_estado_wf', type: 'numeric'},
		{name:'monto', type: 'numeric'},
		{name:'id_proceso_wf', type: 'numeric'},
		{name:'nro_tramite', type: 'string'},
		{name:'estado', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'motivo', type: 'string'},
		{name:'id_funcionario', type: 'numeric'},
		{name:'desc_funcionario', type: 'string'},
		{name:'fecha', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_solicitud_efectivo',
		direction: 'DESC'
	},
	bdel:false,
	bsave:false,
	bedit:false,
	bnew:false,
	
	preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;          
          		  
          Phx.vista.SolicitudEfectivoVb.superclass.preparaMenu.call(this,n); 
          if (data['estado']!= 'borrador'){    
              this.getBoton('fin_registro').enable();
			  this.getBoton('ant_estado').enable();
          }
          else{            
              this.getBoton('fin_registro').disable();
			  this.getBoton('ant_estado').disable();
          }
     },
	
	antEstado:function(res){
         var rec=this.sm.getSelected();
         Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/AntFormEstadoWf.php',
            'Estado de Wf',
            {
                modal:true,
                width:450,
                height:250
            }, { data:rec.data, estado_destino: res.argument.estado }, this.idContenedor,'AntFormEstadoWf',
            {
                config:[{
                          event:'beforesave',
                          delegate: this.onAntEstado,
                        }
                        ],
               scope:this
             })
   },
   
   onAntEstado: function(wizard,resp){
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url:'../../sis_tesoreria/control/SolicitudEfectivo/anteriorEstadoSolicitudEfectivo',
                params:{
                        id_proceso_wf: resp.id_proceso_wf,
                        id_estado_wf:  resp.id_estado_wf,  
                        obs: resp.obs,
                        estado_destino: resp.estado_destino
                 },
                argument:{wizard:wizard},  
                success:this.successEstadoSinc,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });
           
     },
     
   successEstadoSinc:function(resp){
        Phx.CP.loadingHide();
        resp.argument.wizard.panel.destroy()
        this.reload();
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
									   id_proceso_wf:rec.data.id_proceso_wf									  
									}}, this.idContenedor,'FormEstadoWf',
								{
									config:[{
											  event:'beforesave',
											  delegate: this.onSaveWizard												  
											}],
									
									scope:this
								 });        
			   
	 },
	 
	 onSaveWizard:function(wizard,resp){
			Phx.CP.loadingShow();
			console.log(resp);
			Ext.Ajax.request({
				url:'../../sis_tesoreria/control/SolicitudEfectivo/siguienteEstadoSolicitudEfectivo',
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
	
	tabsouth:[
            { 
             url:'../../../sis_tesoreria/vista/solicitud_efectivo_det/SolicitudEfectivoDetVb.php',
             title:'Detalle', 
             height:'50%',
             cls:'SolicitudEfectivoDetVb'
            }    
       ]
	}
)
</script>
		
		