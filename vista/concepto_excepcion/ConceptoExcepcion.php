<?php
/**
*@package pXP
*@file gen-ConceptoExcepcion.php
*@author  (admin)
*@date 12-06-2015 13:02:07
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ConceptoExcepcion=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.ConceptoExcepcion.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_concepto_excepcion'
			},
			type:'Field',
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
                    fields: ['id_concepto_ingas','tipo','desc_ingas','movimiento','desc_partida','id_grupo_ots','filtro_ot','requiere_ot'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams:{par_filtro:'desc_ingas#par.codigo#par.nombre_partida',movimiento:'gasto', autorizacion: 'pago_directo',autorizacion_nulos: 'no'}
                    }),
                valueField: 'id_concepto_ingas',
                displayField: 'desc_ingas',
                gdisplayField:'nombre_ingas',
                tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{desc_ingas}</b></p><p>TIPO:{tipo}</p><p>MOVIMIENTO:{movimiento}</p> <p>PARTIDA:{desc_partida}</p></div></tpl>',
                hiddenName: 'id_concepto_ingas',
                forceSelection:true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:10,
                queryDelay:1000,
                listWidth:600,
                resizable:true,
                anchor:'80%', 
                gwidth: 200,      
                renderer:function(value, p, record){return String.format('{0}', record.data['desc_ingas']);}
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
                    name:'id_uo',
                    origen:'UO',
                    fieldLabel:'Unidad',
                    allowBlank:false,
                    gdisplayField:'desc_uo',//mapea al store del grid
                    gwidth:200,
                    baseParams:{presupuesta:'si'},
                    renderer:function (value, p, record){return String.format('{0}', record.data['desc_uo']);}
                },
            type:'ComboRec',
            id_grupo:0,
            filters:{pfiltro:'uo.nombre_unidad',type:'string'},
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
				filters:{pfiltro:'conex.estado_reg',type:'string'},
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
				filters:{pfiltro:'conex.usuario_ai',type:'string'},
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
				filters:{pfiltro:'conex.fecha_reg',type:'date'},
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
				name: 'id_usuario_ai',
				fieldLabel: '',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'conex.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'conex.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Excepciónes',
	ActSave:'../../sis_tesoreria/control/ConceptoExcepcion/insertarConceptoExcepcion',
	ActDel:'../../sis_tesoreria/control/ConceptoExcepcion/eliminarConceptoExcepcion',
	ActList:'../../sis_tesoreria/control/ConceptoExcepcion/listarConceptoExcepcion',
	id_store:'id_concepto_excepcion',
	fields: [
		{name:'id_concepto_excepcion', type: 'numeric'},
		{name:'id_uo', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_concepto_ingas', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'desc_ingas','desc_uo'
		
	],
	sortInfo:{
		field: 'id_concepto_excepcion',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true
	}
)
</script>
		
		