<?php
/**
*@package pXP
*@file gen-Prorrateo.php
*@author  (admin)
*@date 16-04-2013 01:45:48
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Prorrateo=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Prorrateo.superclass.constructor.call(this,config);
	    this.grid.getTopToolbar().disable();
        this.grid.getBottomToolbar().disable();
        this.init();
       
	},
	tam_pag:50,
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_prorrateo'
			},
			type:'Field',
			form:true 
		},
        {
            config:{
                name: 'id_plan_pago',
                inputType:'hidden'
            },
           type:'Field',
           form:true
        },
        {
            config:{
                name: 'id_obligacion_det',
                inputType:'hidden'
            },
           type:'Field',
           form:true
        },
		{
			config:{
				name: 'desc_ingas',
				fieldLabel: 'Concepto de Gasto',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'Field',
			filters:{pfiltro:'cig.desc_ingas',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:false
		},
        {
            config:{
                name: 'descripcion',
                fieldLabel: 'descripción',
                allowBlank: false,
                anchor: '80%',
                gwidth: 200,
                maxLength:4
            },
            type:'Field',
            filters:{pfiltro:'od.descripcion',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:false
        },
		
        {
            config:{
                name: 'codigo_cc',
                fieldLabel: 'Centro de Costo',
                allowBlank: true,
                anchor: '80%',
                gwidth: 300,
                maxLength:10
            },
            type:'Text',
            filters:{pfiltro:'codigo_cc',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
		{
			config:{
				name: 'monto_ejecutar_mo',
				fieldLabel: 'Monto a Ejecutar',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1245186
			},
			type:'NumberField',
			filters:{pfiltro:'pro.monto_ejecutar_mo',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
        {
            config:{
                name: 'monto_ejecutar_mb',
                fieldLabel: 'Monto a Ejecutar MB',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:1245186
            },
            type:'NumberField',
            filters:{pfiltro:'pro.monto_ejecutar_mb',type:'numeric'},
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
			filters:{pfiltro:'pro.estado_reg',type:'string'},
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
			filters:{pfiltro:'pro.fecha_reg',type:'date'},
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
			filters:{pfiltro:'pro.fecha_mod',type:'date'},
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
	
	title:'Prorrateo',
	ActSave:'../../sis_tesoreria/control/Prorrateo/insertarProrrateo',
	ActDel:'../../sis_tesoreria/control/Prorrateo/eliminarProrrateo',
	ActList:'../../sis_tesoreria/control/Prorrateo/listarProrrateo',
	id_store:'id_prorrateo',
	fields: [
		{name:'id_prorrateo', type: 'numeric'},
		{name:'id_obligacion_det', type: 'numeric'},
		{name:'monto_ejecutar_mb', type: 'numeric'},
		{name:'id_partida_ejecucion_dev', type: 'numeric'},
		{name:'id_plan_pago', type: 'numeric'},
		{name:'id_transaccion_dev', type: 'numeric'},
		{name:'id_transaccion_pag', type: 'numeric'},
		{name:'id_partida_ejecucion_pag', type: 'numeric'},
		{name:'monto_ejecutar_mo', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},'descripcion',
		{name:'usr_mod', type: 'string'},'codigo_cc','desc_ingas','total_prorrateado'
		
	],
	successSave: function(resp) {
	    
	    this.store.rejectChanges();
        Phx.CP.loadingHide();
        if(resp.argument && resp.argument.news){
            if(resp.argument.def=='reset'){
              this.form.getForm().reset();
            }
            
            this.loadValoresIniciales()
        }
        else{
            this.window.hide();
        }

       Phx.CP.getPagina(this.idContenedorPadre).reload();  
       
        
        
      },
	 onReloadPage:function(m){
       
        this.maestro=m;
        
        this.store.baseParams={id_plan_pago:this.maestro.id_plan_pago};
        this.load({params:{start:0, limit:this.tam_pag}})
       
    },
    
     preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;
          Phx.vista.Prorrateo.superclass.preparaMenu.call(this,n); 
          
          if(this.maestro.estado == 'borrador'  && this.maestro.tipo != 'pagado'){
              
               this.getBoton('edit').enable();
          }
          else{
               this.getBoton('edit').disable();
              
          }
          
          
    },
	sortInfo:{
		field: 'id_prorrateo',
		direction: 'ASC'
	},
	bdel:false,
	bsave:false,
	bnew:false
	}
)
</script>
		
		