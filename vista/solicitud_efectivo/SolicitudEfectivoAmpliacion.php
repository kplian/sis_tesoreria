<?php
/**
 *@package pXP
 *@file SolicitudEfectivoAmpliacion.php
 *@author  (gsarmiento)
 *@date 24-11-2015 12:59:51
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.SolicitudEfectivoAmpliacion=Ext.extend(Phx.gridInterfaz,{

            vista:'SinDetalle',

            gruposBarraTareas:[{name:'entregado',title:'<H1 align="center"><i class="fa fa-file-o"></i> Entregados</h1>',grupo:0,height:0}],

            actualizarSegunTab: function(name, indice){

                if(this.finCons){
                    this.store.baseParams.pes_estado = name;
                    this.load({params:{start:0, limit:this.tam_pag}});
                }
            },

            beditGroups: [1],
            bdelGroups:  [1],
            bactGroups:  [0],
            btestGroups: [1],
            bsaveGroups: [1],
            bnewGroups: [1],
            bexcelGroups: [0],

            constructor:function(config){
                this.maestro=config.maestro;

                this.Atributos[this.getIndAtributo('monto_rendido')].config.renderer = function(value, p, record) {
                    var saldo = parseFloat(record.data.monto) + parseFloat(record.data.monto_repuesto) - parseFloat(record.data.monto_rendido) - parseFloat(record.data.monto_devuelto);
                    if (record.data.estado == 'entregado' || record.data.estado == 'finalizado') {
                        return String.format("<font color = 'red'>Rendido: {0}</font><br>"+
                            "<font color = 'slategray' >Devuelto a Caja:{1}</font><br>"+
                            "<font color = 'green' >Devuelto a Solicitante:{2}</font><br>"
                            ,record.data.monto_rendido, record.data.monto_devuelto, record.data.monto_repuesto
                        );
                    }
                    else {
                        return String.format('');
                    }
                };

                this.Atributos[this.getIndAtributo('tiempo_rendicion')].config.renderer = function(value, p, record) {

                    if (record.data.estado == 'entregado' || record.data.estado == 'finalizado') {
                        if(record.data.dias_no_rendido < 0){
                            return String.format("<font color = 'red'>Dias máximo rendir: {0}</font><br>"+
                                "<font color = 'red' >Dias restantes:{1}</font><br>"
                                ,record.data.dias_maximo_rendicion, record.data.dias_no_rendido
                            );
                        }else{
                            return String.format("<font color = 'green'>Dias máximo rendir: {0}</font><br>"+
                                "<font color = 'green' >Dias restantes:{1}</font><br>"
                                ,record.data.dias_maximo_rendicion, record.data.estado == 'finalizado'?0:record.data.dias_no_rendido
                            );
                        }
                    }
                    else {
                        return String.format('');
                    }
                };

                //llama al constructor de la clase padre
                Phx.vista.SolicitudEfectivoAmpliacion.superclass.constructor.call(this,config);

                this.addButton('btnAmpliarDias',
                    {
                        text: 'Ampliar Dias',
                        iconCls: 'blist',
                        grupo:[0],
                        disabled: true,
                        handler: this.ampliarDias,
                        tooltip: '<b>Ampliar Dias Rendicion</b><br/>Ampliar dias a la rendición.'
                    }
                );

                this.addButton('btnChequeoDocumentosWf',
                    {
                        text: 'Documentos',
                        iconCls: 'bchecklist',
                        grupo:[0],
                        disabled: true,
                        handler: this.loadCheckDocumentosSolWf,
                        tooltip: '<b>Documentos de la Solicitud</b><br/>Los documetos de la solicitud seleccionada.'
                    }
                );

                this.addButton('diagrama_gantt',
                    {
                        grupo:[0],
                        text:'Gant',
                        iconCls: 'bgantt',
                        disabled:true,
                        handler:this.diagramGantt,
                        tooltip: '<b>Diagrama Gantt de Solicitud de Efectivo</b>'
                    }
                );

                this.init();
                this.store.baseParams.pes_estado = 'entregado';
                this.store.baseParams.tipo_interfaz = this.vista;

                this.load({params:{start:0, limit:this.tam_pag, tipo_interfaz:this.vista}})

                this.finCons = true;
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
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'tipo_solicitud'
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
                                field: 'codigo',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_caja', 'codigo', 'desc_moneda','cajero'],
                            remoteSort: true,
                            baseParams: {par_filtro: 'caja.codigo', tipo_interfaz:'cajaAbierto', con_detalle:'no'}
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
                        anchor: '80%',
                        gwidth: 100,
                        minChars: 2,
                        tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>{codigo}</b></p><p>CAJERO: {cajero}</p></div></tpl>',
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
                    grid: false,
                    form: false
                },
                {
                    config:{
                        name: 'fecha',
                        fieldLabel: 'Fecha Solicitud',
                        allowBlank: false,
                        anchor: '80%',
                        gwidth: 90,
                        format: 'd/m/Y',
                        value : new Date(),
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
                        name: 'fecha_entrega',
                        fieldLabel: 'Fecha Entrega',
                        allowBlank: false,
                        anchor: '80%',
                        gwidth: 90,
                        format: 'd/m/Y',
                        value : new Date(),
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                    },
                    type:'DateField',
                    filters:{pfiltro:'solefe.fecha_entrega',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'tiempo_rendicion',
                        fieldLabel: 'Dias Rendicion',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 120,
                        maxLength:1179650
                    },
                    type:'NumberField',
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'nro_tramite',
                        fieldLabel: 'Num Tramite',
                        allowBlank: false,
                        anchor: '80%',
                        gwidth: 150,
                        maxLength:50
                    },
                    type:'TextField',
                    filters:{pfiltro:'solefe.nro_tramite',type:'string'},
                    bottom_filter:true,
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
                        anchor: '80%',
                        valueField: 'id_funcionario',
                        gdisplayField: 'desc_funcionario',
                        baseParams: { es_combo_solicitud : 'si' },
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
                    form:true
                },
                {
                    config:{
                        name: 'monto',
                        fieldLabel: 'Solicitado',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 60,
                        maxLength:1179650
                    },
                    type:'NumberField',
                    filters:{pfiltro:'solefe.monto',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'monto_rendido',
                        fieldLabel: 'Montos',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 150,
                        maxLength:1179650
                    },
                    type:'NumberField',
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'monto_devuelto',
                        fieldLabel: 'Monto Devuelto',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:1179650
                    },
                    type:'NumberField',
                    id_grupo:1,
                    grid:false,
                    form:false
                },
                {
                    config:{
                        name: 'monto_repuesto',
                        fieldLabel: 'Monto Repuesto',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:1179650
                    },
                    type:'NumberField',
                    id_grupo:1,
                    grid:false,
                    form:false
                },
                {
                    config:{
                        name: 'saldo',
                        fieldLabel: 'Saldo',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 70,
                        maxLength:1179650
                    },
                    type:'NumberField',
                    id_grupo:1,
                    grid:true,
                    form:false
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
            title:'Solicitud Efectivo Sin Detalle',
            ActSave:'../../sis_tesoreria/control/SolicitudEfectivo/insertarSolicitudEfectivo',
            ActDel:'../../sis_tesoreria/control/SolicitudEfectivo/eliminarSolicitudEfectivo',
            ActList:'../../sis_tesoreria/control/SolicitudEfectivo/listarSolicitudEfectivo',
            id_store:'id_solicitud_efectivo',
            fields: [
                {name:'id_solicitud_efectivo', type: 'numeric'},
                {name:'id_caja', type: 'numeric'},
                {name:'codigo', type: 'string'},
                {name:'id_moneda', type: 'numeric'},
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
                {name:'fecha_entrega', type: 'date',dateFormat:'Y-m-d'},
                {name:'dias_maximo_rendicion', type: 'numeric'},
                {name:'dias_no_rendido', type: 'numeric'},
                {name:'id_usuario_ai', type: 'numeric'},
                {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'usuario_ai', type: 'string'},
                {name:'id_usuario_reg', type: 'numeric'},
                {name:'id_usuario_mod', type: 'numeric'},
                {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'usr_reg', type: 'string'},
                {name:'usr_mod', type: 'string'},
                {name:'monto_rendido', type: 'numeric'},
                {name:'monto_repuesto', type: 'numeric'},
                {name:'monto_devuelto', type: 'numeric'},
                {name:'saldo', type: 'numeric'}
            ],
            sortInfo:{
                field: 'solefe.id_solicitud_efectivo',
                direction: 'DESC'
            },

            preparaMenu:function(n){
                var data = this.getSelectedData();
                var tb =this.tbar;

                if(data.dias_no_rendido < 0)
                    this.getBoton('btnAmpliarDias').enable();
                else
                    this.getBoton('btnAmpliarDias').disable();

                this.getBoton('diagrama_gantt').enable();
                this.getBoton('btnChequeoDocumentosWf').enable();
                Phx.vista.SolicitudEfectivoAmpliacion.superclass.preparaMenu.call(this,n);
                console.log(data)
            },

            liberaMenu:function(){
                var tb = Phx.vista.SolicitudEfectivoAmpliacion.superclass.liberaMenu.call(this);
                if(tb) {
                    this.getBoton('btnChequeoDocumentosWf').disable();
                    this.getBoton('diagrama_gantt').disable();
                    this.getBoton('btnAmpliarDias').disable();
                }
            },

            loadCheckDocumentosSolWf:function() {
                var rec=this.sm.getSelected();
                rec.data.nombreVista = this.nombreVista;
                Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
                    'Chequear documento del WF',
                    {
                        width:'90%',
                        height:500
                    },
                    rec.data,
                    this.idContenedor,
                    'DocumentoWf'
                )
            },

            diagramGantt : function (){
                var data=this.sm.getSelected().data.id_proceso_wf;
                Phx.CP.loadingShow();
                Ext.Ajax.request({
                    url: '../../sis_workflow/control/ProcesoWf/diagramaGanttTramite',
                    params: { 'id_proceso_wf': data },
                    success: this.successExport,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            },

            ampliarDias : function() {
                var rec = this.sm.getSelected();
                var data = rec.data;

                var selection, sw = true;
                do{
                    var selection = window.prompt("Introuzca los dias de ampliación");
                    var sw = selection?isNaN(selection):false;

                    //console.log('......',selection, sw  , parseInt(selection, 10) > 15 , parseInt(selection, 10) < -15)

                }while( selection <= 0 );

                if(selection){
                    Phx.CP.loadingShow();
                    Ext.Ajax.request({
                        url : '../../sis_tesoreria/control/SolicitudEfectivo/ampliarDiasRendicion',
                        params: {
                            id_solicitud_efectivo: data.id_solicitud_efectivo,
                            dias_ampliado: parseInt(selection)
                        },
                        success: this.successRep,
                        failure: this.conexionFailure,
                        timeout: this.timeout,
                        scope: this
                    });
                }
            },

            successRep:function(resp){
                Phx.CP.loadingHide();
                var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                if(!reg.ROOT.error){
                    this.reload();
                }else{
                    alert('Ocurrió un error durante el proceso')
                }
            },

            bdel:true,
            bsave:true
        }
    )
</script>