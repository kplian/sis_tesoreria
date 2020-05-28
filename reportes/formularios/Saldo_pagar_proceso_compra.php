<?php
/**
 *@package pXP
 *@file    GenerarLibroBancos.php
 *@author  Gonzalo Sarmiento Sejas
 *@date    01-12-2014
 *@description Archivo con la interfaz para generaci�n de reporte

HISTORIAL DE MODIFICACIONES:


ISSUE            FECHA:          AUTOR       DESCRIPCION
#65 ENDETR      25/05/2020       JUAN            SALDO POR PAGAR DE PROCESOS DE COMPRA
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.Saldo_pagar_proceso_compra = Ext.extend(Phx.frmInterfaz, {

        Atributos : [

            /*{
                config:{
                    name: 'id_entidad',
                    fieldLabel: 'Entidad',
                    qtip: 'entidad a la que pertenese el depto, ',
                    allowBlank: false,
                    emptyText:'Entidad...',
                    store:new Ext.data.JsonStore(
                        {
                            url: '../../sis_parametros/control/Entidad/listarEntidad',
                            id: 'id_entidad',
                            root: 'datos',
                            sortInfo:{
                                field: 'nombre',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_entidad','nit','nombre'],
                            // turn on remote sorting
                            remoteSort: true,
                            baseParams: { par_filtro:'nit#nombre' }
                        }),
                    valueField: 'id_entidad',
                    displayField: 'nombre',
                    gdisplayField:'desc_entidad',
                    hiddenName: 'id_entidad',
                    triggerAction: 'all',
                    lazyRender:true,
                    mode:'remote',
                    pageSize:50,
                    queryDelay:500,
                    anchor:"90%",
                    listWidth:280,
                    gwidth:150,
                    minChars:2,
                    renderer:function (value, p, record){return String.format('{0}', record.data['desc_entidad']);}

                },
                type:'ComboBox',
                filters:{pfiltro:'ENT.nombre',type:'string'},
                id_grupo:0,
                egrid: true,
                grid:true,
                form:true
            },*/
			{
	            config:{
	                name:'id_gestion',
	                fieldLabel:'Gestión',
	                allowBlank:true,
	                emptyText:'Gestión...',
	                store: new Ext.data.JsonStore({
	                         url: '../../sis_parametros/control/Gestion/listarGestion',
	                         id: 'id_gestion',
	                         root: 'datos',
	                         sortInfo:{
	                            field: 'gestion',
	                            direction: 'DESC'
	                    },
	                    totalProperty: 'total',
	                    fields: ['id_gestion','gestion','moneda','codigo_moneda'],
	                    // turn on remote sorting
	                    remoteSort: true,
	                    baseParams:{par_filtro:'gestion'}
	                    }),
	                valueField: 'id_gestion',
	                displayField: 'gestion',
	                //tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{nro_cuenta}</b></p><p>{denominacion}</p></div></tpl>',
	                hiddenName: 'id_gestion',
	                forceSelection:true,
	                typeAhead: false,
	                triggerAction: 'all',
	                lazyRender:true,
	                mode:'remote',
	                pageSize:10,
	                queryDelay:1000,
	                listWidth:600,
	                resizable:true,
	                anchor:'100%'
	                
	            },
	            type:'ComboBox',
	            id_grupo:0,
	            filters:{   
	                        pfiltro:'gestion',
	                        type:'string'
	                    },
	            grid:true,
	            form:true
	        },
	        {
	            config:{
	                name:'id_periodo',
	                fieldLabel:'Periodo',
	                allowBlank:true,
	                emptyText:'Periodo...',
	                store: new Ext.data.JsonStore({
	                         url: '../../sis_parametros/control/Periodo/listarPeriodo',
	                         id: 'id_periodo',
	                         root: 'datos',
	                         sortInfo:{
	                            field: 'id_periodo',
	                            direction: 'ASC'
	                    },
	                    totalProperty: 'total',
	                    fields: ['id_periodo','literal','periodo','fecha_ini','fecha_fin'],
	                    // turn on remote sorting
	                    remoteSort: true,
	                    baseParams:{par_filtro:'periodo#literal'}
	                    }),
	                valueField: 'id_periodo',
	                displayField: 'literal',
	                //tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{nro_cuenta}</b></p><p>{denominacion}</p></div></tpl>',
	                hiddenName: 'id_periodo',
	                forceSelection:true,
	                typeAhead: false,
	                triggerAction: 'all',
	                lazyRender:true,
	                mode:'remote',
	                pageSize:12,
	                queryDelay:1000,
	                listWidth:600,
	                resizable:true,
	                anchor:'100%'
	                
	            },
	            type:'ComboBox',
	            id_grupo:0,
	            filters:{   
	                        pfiltro:'literal',
	                        type:'string'
	                    },
	            grid:true,
	            form:true
	        },
			{
		   		config:{
		   				name:'id_tipo_cc',
		   				qtip: 'Tipo de centro de costos, cada tipo solo puede tener un centro por gestión',	   				
		   				origen:'TIPOCC',
		   				fieldLabel:'Tipo Centro',
		   				gdisplayField: 'desc_tipo_cc',
		   				url:  '../../sis_parametros/control/TipoCc/listarTipoCcAll',
		   				baseParams: {movimiento:''},	   				
		   				allowBlank:true,
		   				width: 150 
		   				
		      		},
	   			type:'ComboRec',
	   			id_grupo:0,
	   			form:true
		    },


        ],

        topBar : true,
        botones : false,
        labelSubmit : 'Generar',
        tooltipSubmit : '<b>Ejecución de proyecto</b>',

        constructor : function(config) {
            Phx.vista.Saldo_pagar_proceso_compra.superclass.constructor.call(this, config);
            this.init();
            /*this.mostrarComponente(this.Cmp.fecha_fin);
            this.mostrarComponente(this.Cmp.fecha_ini);*/
            this.iniciarEventos();
        },

        iniciarEventos:function(){
            /*this.mostrarComponente(this.Cmp.fecha_fin);
            this.mostrarComponente(this.Cmp.fecha_ini);*/
        },

        tipo : 'reporte',
        clsSubmit : 'bprint',

        Grupos : [{
            layout : 'column',
            items : [{
                xtype : 'fieldset',
                layout : 'form',
                border : true,
                title : 'Datos para el reporte',
                bodyStyle : 'padding:0 10px 0;',
                columnWidth : '500px',
                items : [],
                id_grupo : 0,
                collapsible : true
            }]
        }],

        //ActSave:'../../sis_contabilidad/control/DocCompraVentaForm/reporteComparacion',
        ActSave:'../../sis_tesoreria/control/PlanPago/ReporteSaldoPagarProcesoCompra',
        successSave :function(resp){

            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if (reg.ROOT.error) {
                alert('error al procesar');
                return
            }
            var nomRep = reg.ROOT.detalle.archivo_generado;
            if(Phx.CP.config_ini.x==1){
                nomRep = Phx.CP.CRIPT.Encriptar(nomRep);
            }

            window.open('../../../reportes_generados/'+nomRep+'?t='+new Date().toLocaleTimeString())
        }
    })
</script>
