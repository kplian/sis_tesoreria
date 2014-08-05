<?php
/**
*@package pXP
*@file ObligacionDet.php
*@author  Gonzalo Sarmiento Sejas
*@date 02-04-2013 20:27:35
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ObligacionDet=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.ObligacionDet.superclass.constructor.call(this,config);
		this.grid.getTopToolbar().disable();
		this.grid.getBottomToolbar().disable();
		this.init();
		this.iniciarEventos();
		
		this.addButton('btnProrrateo',
            {
                text: 'Prorrateo',
                iconCls: 'bchecklist',
                disabled: true,
                handler: this.cargarProrrateo,
                tooltip: '<b>Prorrateo</b><br/>Esta funcionalidad ayuda a cargar el prorrateo (servicios basicos)'
            }
        );
		
	},
	
	cargarProrrateo:function() {
	    
	    	var data ={
	           nombre_tabla:'tes.tobligacion_det',
	           nombre_id:'id_obligacion_pago',
	           nombre_monto:'monto_pago_mo',
	           tiene_tipo_cambio:'si',
	           id_valor:this.maestro.id_obligacion_pago,
	           nombre_monto_mb:'monto_pago_mb',
	           tipo_cambio:this.maestro.tipo_cambio_conv
	       };
	    
	    
            Phx.CP.loadWindows('../../../sis_tesoreria/vista/tipo_prorrateo/WizardProrrateo.php',
                    'Prorrateo ...',
                    {
                        width:'90%',
                        height:500
                    },
                    data,
                    this.idContenedor,
                    'WizardProrrateo'
            );
    },
	
	tam_pag:50,
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_obligacion_det'
			},
			type:'Field',
			form:true 
		},
        {
            config:{
                labelSeparator:'',
                name: 'id_obligacion_pago',
                fieldLabel: 'id_obligacion_pago',
                inputType:'hidden'
            },
            type:'Field',
            form:true
        },
         {
            config:{
                    name:'id_centro_costo',
                    origen:'CENTROCOSTO',
                   // baseParams:{filtrar:'grupo_ep'},
                    fieldLabel: 'Centro de Costos',
                    url: '../../sis_parametros/control/CentroCosto/listarCentroCostoFiltradoXDepto',
                    emptyText : 'Centro Costo...',
                    allowBlank:false,
                    gdisplayField:'codigo_cc',//mapea al store del grid
                    gwidth:200,
                },
            type:'ComboRec',
            id_grupo:0,
            filters:{pfiltro:'cc.codigo_cc',type:'string'},
            grid:true,
            form:true
        },                    
        {
            config:{
                name:'id_concepto_ingas',
                fieldLabel:'Concepto Ingreso Gasto',
                allowBlank:true,
                emptyText:'Concepto Ingreso Gasto...',
                store: new Ext.data.JsonStore({
                         url: '../../sis_parametros/control/ConceptoIngas/listarConceptoIngasMasPartida',
                         id: 'id_concepto_ingas',
                         root: 'datos',
                         sortInfo:{
                            field: 'desc_ingas',
                            direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_concepto_ingas','tipo','desc_ingas','movimiento','desc_partida'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams:{par_filtro:'desc_ingas#par.codigo#par.nombre_partida',movimiento:'gasto'}
                    }),
                valueField: 'id_concepto_ingas',
                displayField: 'desc_ingas',
                gdisplayField:'nombre_ingas',
                tpl:'<tpl for="."><div class="x-combo-list-item"><p>{desc_ingas}</p><p>TIPO:{tipo}</p><p>MOVIMIENTO:{movimiento}</p> <p>PARTIDA:{desc_partida}</p></div></tpl>',
                hiddenName: 'id_concepto_ingas',
                forceSelection:true,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:10,
                queryDelay:1000,
                 listWidth:350,
                resizable:true,
                anchor:'80%', 
                gwidth: 200,      
                renderer:function(value, p, record){return String.format('{0}', record.data['nombre_ingas']);}
            },
            type:'ComboBox',
            id_grupo:0,
            filters:{   
                        pfiltro:'cig.movimiento#cig.desc_ingas',
                        type:'string'
                    },
            grid:true,
            form:true
        },
        {
            config:{
                name: 'descripcion',
                fieldLabel: 'Descripión',
                allowBlank: true,
                anchor: '80%',
                gwidth: 200,
                maxLength:1245184
            },
            type:'TextArea',
            filters:{pfiltro:'obdet.descripcion',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        }
        ,
		{
 			config:{
 				name:'id_cuenta',
 				fieldLabel:'Cuenta',
 				allowBlank:true,
 				emptyText:'Cuenta...',
 				store: new Ext.data.JsonStore({
						 url: '../../sis_contabilidad/control/Cuenta/listarCuenta',
						 id: 'id_cuenta',
						 root: 'datos',
						 sortInfo:{
							field: 'nombre_cuenta',
							direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_cuenta','nombre_cuenta','desc_cuenta'],
					// turn on remote sorting
					remoteSort: true,
					baseParams:{par_filtro:'nombre_cuenta#desc_cuenta',sw_transaccional:'movimiento'}
					}),
 				valueField: 'id_cuenta',
 				displayField: 'nombre_cuenta',
 				hiddenName: 'id_cuenta',
 				forceSelection:true,
 				typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
 				mode:'remote',
 				pageSize:10,
 				listWidth:350,
                resizable:true,
 				queryDelay:1000,
 				anchor:'80%',		
 				renderer:function(value, p, record){return String.format('{0}', record.data['nombre_cuenta']);}
 			},
 			type:'ComboBox',
 			id_grupo:0,
 			filters:{   
 						pfiltro:'cta.nombre_cuenta',
 						type:'string'
 					},
 			grid:false,
 			form:false
 	    },		
		{
 			config:{
 				name:'id_partida',
 				fieldLabel:'Partida',
 				allowBlank:true,
 				emptyText:'Partida...',
 				store: new Ext.data.JsonStore({
						 url: '../../sis_presupuestos/control/Partida/listarPartida',
						 id: 'id_partida',
						 root: 'datos',
						 sortInfo:{
							field: 'codigo',
							direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_partida','codigo','nombre_partida'],
					// turn on remote sorting
					remoteSort: true,
					baseParams:{par_filtro:'codigo#nombre_partida',sw_transaccional:'movimiento'}
					}),
 				valueField: 'id_partida',
 				displayField: 'nombre_partida',
 				tpl:'<tpl for="."><div class="x-combo-list-item"><p>CODIGO:{codigo}</p><p>{nombre_partida}</p></div></tpl>',
 				hiddenName: 'id_partida',
 				forceSelection:true,
 				typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
 				mode:'remote',
 				pageSize:10,
 				listWidth:350,
                resizable:true,
 				queryDelay:1000,
 				anchor:'80%',		
 				renderer:function(value, p, record){return String.format('{0}', record.data['nombre_partida']);}
 			},
 			type:'ComboBox',
 			id_grupo:0,
 			filters:{   
 						pfiltro:'codigo#nombre_partida',
 						type:'string'
 					},
 			grid:true,
 			form:false
 	    },			
		{
 			config:{
 				name:'id_auxiliar',
 				fieldLabel:'Auxiliar',
 				allowBlank:true,
 				emptyText:'Auxiliar...',
 				store: new Ext.data.JsonStore({
						 url: '../../sis_contabilidad/control/Auxiliar/listarAuxiliar',
						 id: 'id_auxiliar',
						 root: 'datos',
						 sortInfo:{
							field: 'codigo_auxiliar',
							direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_auxiliar','codigo_auxiliar','nombre_auxiliar'],
					// turn on remote sorting
					remoteSort: true,
					baseParams:{par_filtro:'codigo_auxiliar#nombre_auxiliar'}
					}),
 				valueField: 'id_auxiliar',
 				displayField: 'nombre_auxiliar',
 				tpl:'<tpl for="."><div class="x-combo-list-item"><p>CODIGO:{codigo_auxiliar}</p><p>{nombre_auxiliar}</p></div></tpl>',
 				hiddenName: 'id_auxiliar',
 				forceSelection:true,
 				typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
 				mode:'remote',
 				pageSize:10,
 				listWidth:350,
                resizable:true,
 				queryDelay:1000,
 				anchor:'80%',		
 				renderer:function(value, p, record){return String.format('{0}', record.data['nombre_auxiliar']);}
 			},
 			type:'ComboBox',
 			id_grupo:0,
 			filters:{   
 						pfiltro:'codigo_auxiliar#nombre_auxiliar',
 						type:'string'
 					},
 			grid:false,
 			form:false
 	    },
		{
			config:{
				name: 'monto_pago_mo',
				currencyChar:' ',
				fieldLabel: 'Monto Total Pago',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:1245184
			},
			type:'MoneyField',
			filters:{pfiltro:'obdet.monto_pago_mo',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'monto_pago_mb',
				fieldLabel: 'Monto Pago Bs.',
				currencyChar:'Bs. ',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:123456778
			},
			type:'MoneyField',
			filters:{pfiltro:'obdet.monto_pago_mb',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'factor_porcentual',
				fieldLabel: 'Factor Porcentual',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1245184
			},
			type:'NumberField',
			filters:{pfiltro:'obdet.factor_porcentual',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'id_partida_ejecucion_com',
				fieldLabel: 'Partida Ejecucion Com',
				allowBlank: true,
				inputType:'hidden',
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'NumberField',
			filters:{pfiltro:'obdet.id_partida_ejecucion_com',type:'numeric'},
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
			filters:{pfiltro:'obdet.estado_reg',type:'string'},
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
			filters:{pfiltro:'obdet.fecha_reg',type:'date'},
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
			filters:{pfiltro:'obdet.fecha_mod',type:'date'},
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
		}
	],
	
	title:'Detalle',
	ActSave:'../../sis_tesoreria/control/ObligacionDet/insertarObligacionDet',
	ActDel:'../../sis_tesoreria/control/ObligacionDet/eliminarObligacionDet',
	ActList:'../../sis_tesoreria/control/ObligacionDet/listarObligacionDet',
	id_store:'id_obligacion_det',
	fields: [
		{name:'id_obligacion_det', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_cuenta', type: 'numeric'},
		{name:'nombre_cuenta', type: 'string'},
		{name:'id_partida', type: 'numeric'},
		{name:'nombre_partida', type: 'string'},
		{name:'id_auxiliar', type: 'numeric'},
		{name:'nombre_auxiliar', type: 'string'},
		{name:'id_concepto_ingas', type: 'numeric'},
		{name:'nombre_ingas', type: 'string'},
		{name:'monto_pago_mo', type: 'numeric'},
		{name:'id_obligacion_pago', type: 'numeric'},
		{name:'id_centro_costo', type: 'numeric'},
		{name:'codigo_cc', type: 'string'},
		{name:'monto_pago_mb', type: 'numeric'},
		{name:'factor_porcentual', type: 'numeric'},
		{name:'id_partida_ejecucion_com', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'desc_ingas','nombre_ingas','descripcion'
	],
	onButtonEdit:function(){
	    
	  Phx.vista.ObligacionDet.superclass.onButtonEdit.call(this);   
	  
	  if(this.maestro.tipo_obligacion=='adquisiciones'){
	  
	     this.cmpMontoPagoMo.disable();
	     this.cmpConceptoIngas.disable();
	     this.cmpCentroCostos.disable();
	  
	  }
	  else{
	      this.cmpMontoPagoMo.enable();
	      this.cmpConceptoIngas.enable();
	       this.cmpCentroCostos.enable();
	  }
	
	
	},
	onButtonNew:function(){
	    Phx.vista.ObligacionDet.superclass.onButtonNew.call(this); 
	    this.cmpMontoPagoMo.enable(); 
	    this.cmpObligacionPago.setValue(this.maestro.id_obligacion_pago)
	    
	},
	iniciarEventos:function(){
	    
	    this.cmpMontoPagoMo=this.getComponente('monto_pago_mo');
	    this.cmpConceptoIngas=this.getComponente('id_concepto_ingas');
	    this.cmpCentroCostos=this.getComponente('id_centro_costo');
        //this.cmpPartida=this.getComponente('id_partida');
        //this.cmpCuenta=this.getComponente('id_cuenta');
        //this.cmpAuxiliar=this.getComponente('id_auxiliar');
        this.cmpObligacionPago=this.getComponente('id_obligacion_pago');
	    
	},
	onReloadPage:function(m){
       
        this.maestro=m;
        
        this.getBoton('new').disable();
        
        this.Cmp.id_centro_costo.store.baseParams.id_gestion=this.maestro.id_gestion
        this.Cmp.id_centro_costo.store.baseParams.id_depto =this.maestro.id_depto;
        this.Cmp.id_centro_costo.modificado=true;
        
        this.Cmp.id_concepto_ingas.store.baseParams.id_gestion=this.maestro.id_gestion
        this.Cmp.id_concepto_ingas.modificado=true;
        
        
        
        
        /*this.cmpPartida.store.baseParams.id_gestion=this.maestro.id_gestion
        this.cmpPartida.modificado=true;*/
        
       /* this.cmpCuenta.store.baseParams.id_gestion=this.maestro.id_gestion
        this.cmpCuenta.modificado=true;*/
        
        
        this.store.baseParams={id_obligacion_pago:this.maestro.id_obligacion_pago};
        this.load({params:{start:0, limit:50}})
       
    },
	

  preparaMenu:function(n){
         
         Phx.vista.ObligacionDet.superclass.preparaMenu.call(this,n); 
          if(this.maestro.estado ==  'borrador'){
               this.getBoton('edit').enable();
               this.getBoton('new').enable();
               this.getBoton('del').enable();
               
               this.getBoton('bchecklist').enable();
               
               
         }
         else{
             
               this.getBoton('edit').disable();
               this.getBoton('new').disable();
               this.getBoton('del').disable();
               this.getBoton('bchecklist').disable();
         }
         
          if(this.maestro&&(this.maestro.estado ==  'borrador' && this.maestro.tipo_obligacion=='adquisiciones')){
               
               this.getBoton('edit').enable();
               this.getBoton('new').disable();
               this.getBoton('del').disable();
               this.getBoton('bchecklist').disable();
         }
          
        
          
     },
     
     liberaMenu: function() {
         Phx.vista.ObligacionDet.superclass.liberaMenu.call(this); 
           if(this.maestro&&(this.maestro.estado !=  'borrador')){
               
               this.getBoton('edit').disable();
               this.getBoton('new').disable();
               this.getBoton('del').disable();
         }
          if(this.maestro&&(this.maestro.estado ==  'borrador' && this.maestro.tipo_obligacion=='adquisiciones')){
               
               this.getBoton('edit').disable();
               this.getBoton('new').disable();
               this.getBoton('del').disable();
         }
         
    },
    sortInfo:{
		field: 'id_obligacion_det',
		direction: 'ASC'
	},
	bdel:true,
	bsave:false
	}
)
</script>	