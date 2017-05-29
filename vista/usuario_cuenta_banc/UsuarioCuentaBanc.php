<?php
/**
*@package pXP
*@file gen-UsuarioCuentaBanc.php
*@author  (admin)
*@date 24-03-2017 15:30:36
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.UsuarioCuentaBanc=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.UsuarioCuentaBanc.superclass.constructor.call(this,config);
		this.init();
		var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
        if(dataPadre){
            this.onEnablePanel(this, dataPadre);
        }
        else
        {
           this.bloquearMenus();
        }
		
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_usuario_cuenta_banc'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_cuenta_bancaria'
			},
			type:'Field',
			form:true 
		},
		{
   			config:{
   				name:'id_usuario',
   				fieldLabel:'Usuario',
   				allowBlank:false,
   				emptyText:'Usuario...',
   				store: new Ext.data.JsonStore({

					url: '../../sis_seguridad/control/Usuario/listarUsuario',
					id: 'id_persona',
					root: 'datos',
					sortInfo:{
						field: 'desc_person',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_usuario','desc_person','cuenta'],
					// turn on remote sorting
					remoteSort: true,
					baseParams:{par_filtro:'PERSON.nombre_completo2#cuenta'}
				}),
   				valueField: 'id_usuario',
   				displayField: 'desc_person',
   				gdisplayField:'desc_persona',//dibuja el campo extra de la consulta al hacer un inner join con orra tabla
   				tpl:'<tpl for="."><div class="x-combo-list-item"><p>{desc_person}</p><p>CI:{ci}</p> </div></tpl>',
   				hiddenName: 'id_usuario',
   				forceSelection:true,
   				typeAhead: true,
       			triggerAction: 'all',
       			lazyRender:true,
   				mode:'remote',
   				pageSize:10,
   				queryDelay:1000,
   				width:250,
   				gwidth:280,
   				minChars:2,
   				turl:'../../../sis_seguridad/vista/usuario/Usuario.php',
   			    ttitle:'Usuarios',
   			   // tconfig:{width:1800,height:500},
   			    tdata:{},
   			    tcls:'usuario',
   			    pid:this.idContenedor,
   			
   				renderer:function (value, p, record){return String.format('{0}', record.data['desc_persona']);}
   			},
   			//type:'TrigguerCombo',
   			type:'ComboBox',
   			bottom_filter: true,
   			id_grupo:0,
   			filters:{	
   				        pfiltro:'nombre_completo1',
   						type:'string'
   					},
   		   
   			grid:true,
   			form:true
        },
        {
	       		config:{
	       			name:'tipo_permiso',
	       			tinit: false,
	       			fieldLabel:'Permiso',
	       			allowBlank:false,
	       			emptyText:'Auten...',
	       			typeAhead: true,
	       		    triggerAction: 'all',
	       		    lazyRender:true,
	       		    mode: 'local',
	       		    //readOnly:true,
	       		    valueField: 'autentificacion',
	       		   // displayField: 'descestilo',
	       		    store:['todos','libro_bancos','fondo_avance']
	       		    
	       		},
	       		type:'ComboBox',
	       		bottom_filter: true,
	       		id_grupo:0,
	       		filters:{pfiltro:'ucu.tipo_permiso',type:'string'},
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
				filters:{pfiltro:'ucu.estado_reg',type:'string'},
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
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'ucu.usuario_ai',type:'string'},
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
				filters:{pfiltro:'ucu.fecha_reg',type:'date'},
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
				filters:{pfiltro:'ucu.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'ucu.fecha_mod',type:'date'},
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
	title:'Permisos',
	ActSave:'../../sis_tesoreria/control/UsuarioCuentaBanc/insertarUsuarioCuentaBanc',
	ActDel:'../../sis_tesoreria/control/UsuarioCuentaBanc/eliminarUsuarioCuentaBanc',
	ActList:'../../sis_tesoreria/control/UsuarioCuentaBanc/listarUsuarioCuentaBanc',
	id_store:'id_usuario_cuenta_banc',
	fields: [
		{name:'id_usuario_cuenta_banc', type: 'numeric'},
		{name:'id_usuario', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_cuenta_bancaria', type: 'numeric'},
		{name:'tipo_permiso', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'desc_persona'
		
	],
	sortInfo:{
		field: 'id_usuario_cuenta_banc',
		direction: 'ASC'
	},
	
	onReloadPage:function(m){
		this.maestro=m;
        this.store.baseParams={id_cuenta_bancaria:this.maestro.id_cuenta_bancaria};
        this.load({params:{start:0, limit:50}})
    },
    loadValoresIniciales:function()
    {
        Phx.vista.UsuarioCuentaBanc.superclass.loadValoresIniciales.call(this);
        this.Cmp.id_cuenta_bancaria.setValue(this.maestro.id_cuenta_bancaria);   
    },
	
	bdel:true,
	bsave:true
	}
)
</script>
		
		