<?php
/**
*@package pXP
*@file gen-TipoPlanPago.php
*@author  (admin)
*@date 08-07-2014 13:12:03
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.TipoPlanPago=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.TipoPlanPago.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_tipo_plan_pago'
			},
			type:'Field',
			form:true 
		},
		
		{
            config:{
                name: 'codigo',
                fieldLabel: 'codigo',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:50
            },
                type:'TextField',
                filters:{pfiltro:'tpp.codigo',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
        },
		
		{
            config:{
                name: 'descripcion',
                fieldLabel: 'descripcion',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:150
            },
                type:'TextField',
                filters:{pfiltro:'tpp.descripcion',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
        },
		
		
		{
            config: {
                name: 'codigo_proceso_llave_wf',
                fieldLabel: 'Tipo Proceso WF',
                allowBlank: true,
                emptyText: 'Elija un proceso WF..',
                store: new Ext.data.JsonStore({
                    url: '../../sis_workflow/control/TipoProceso/listarTipoProceso',
                    id: 'id_tipo_proceso',
                    root: 'datos',
                    sortInfo: {
                        field: 'codigo',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_tipo_proceso','codigo','nombre','codigo_llave'],
                    remoteSort: true,
                    baseParams: {par_filtro:'tipproc.codigo#tipproc.nombre#tipproc.codigo_llave'}
                }),
                valueField: 'codigo',
                displayField: 'codigo',
                gdisplayField: 'codigo_proceso_llave_wf',
                //tpl:'<tpl for="."><div class="x-combo-list-item"><p>Código: {codigo_llave}-{codigo}</p><p>Nombre: {nombre}</p></div></tpl>',
                
                
                
                forceSelection: true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 20,
                queryDelay: 100,
                anchor: '100%',
                gwidth: 120,
                enableMultiSelect:true,
                minChars: 2
            },
            type:'AwesomeCombo',
            filters:{pfiltro:'codigo_proceso_llave_wf',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        
        {
            config: {
                name: 'codigo_plantilla_comprobante',
                fieldLabel: 'Plantilla Comprobante',
                allowBlank: true,
                emptyText: 'Plantilla Comprobante..',
                store: new Ext.data.JsonStore({
                    url: '../../sis_contabilidad/control/PlantillaComprobante/listarPlantillaComprobante',
                    id: 'id_plantilla_comprobante',
                    root: 'datos',
                    sortInfo: {
                        field: 'codigo',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_plantilla_comprobante','codigo'],
                    remoteSort: true,
                    baseParams: {par_filtro:'codigo'}
                }),
                valueField: 'codigo',
                displayField: 'codigo',
                gdisplayField: 'codigo_plantilla_comprobante',
                tpl:'<tpl for="."><div class="x-combo-list-item"><p>Código: {codigo}</p></div></tpl>',
                forceSelection: true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 20,
                queryDelay: 100,
                anchor: '100%',
                gwidth: 120,
                minChars: 2
            },
            type: 'ComboBox',
            filters:{pfiltro:'codigo_plantilla_comprobante',type:'string'},
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
				filters:{pfiltro:'tpp.estado_reg',type:'string'},
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
				filters:{pfiltro:'tpp.fecha_reg',type:'date'},
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
				filters:{pfiltro:'tpp.fecha_mod',type:'date'},
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
                filters:{pfiltro:'tpp.id_usuario_ai',type:'numeric'},
                id_grupo:1,
                grid:false,
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
                filters:{pfiltro:'tpp.usuario_ai',type:'string'},
                id_grupo:1,
                grid:true,
                form:false
        }
	],
	tam_pag:50,	
	title:'Tipo Plan Pago',
	ActSave:'../../sis_tesoreria/control/TipoPlanPago/insertarTipoPlanPago',
	ActDel:'../../sis_tesoreria/control/TipoPlanPago/eliminarTipoPlanPago',
	ActList:'../../sis_tesoreria/control/TipoPlanPago/listarTipoPlanPago',
	id_store:'id_tipo_plan_pago',
	fields: [
		{name:'id_tipo_plan_pago', type: 'numeric'},
		{name:'codigo_proceso_llave_wf', type: 'string'},
		{name:'descripcion', type: 'string'},
		{name:'codigo_plantilla_comprobante', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'codigo', type: 'string'},
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
		field: 'id_tipo_plan_pago',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true
	}
)
</script>
		
		