<?php
/**
 * @package pXP
 * @file ConsultaContables.php
 * @author  MMV
 * @date 18-12-2013 19:39:02
 * @description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.ConsultaContables = Ext.extend(Phx.gridInterfaz, {

            constructor: function (config) {
                this.maestro = config.maestro;
                this.initButtons = [this.cmbDepto, this.cmbGestion];
                //llama al constructor de la clase padre
                Phx.vista.ConsultaContables.superclass.constructor.call(this, config);
                this.init();

                this.cmbDepto.on('clearcmb', function () {
                    this.DisableSelect();
                    this.store.removeAll();
                }, this);

                this.cmbDepto.on('valid', function () {
                    if (this.cmbGestion.validate()) {
                        this.capturaFiltros();
                    }


                }, this);

                this.cmbGestion.on('select', function () {
                    if (this.validarFiltros()) {
                        this.capturaFiltros();
                    }
                }, this);

            },
            Atributos: [
                {
                    config: {
                        name: 'manual',
                        fieldLabel: 'Manual',
                        gwidth: 50,
                        renderer: function (value, p, record) {
                            if (value == 'si') {
                                return String.format('<b><font color="green">{0}</font></b>', value);
                            } else {
                                return String.format('<b><font color="orange">{0}</font></b>', value);
                            }
                        }
                    },
                    type: 'Field',
                    id_grupo: 0,
                    filters: {
                        pfiltro: 'incbte.manual',
                        type: 'string'
                    },
                    grid: true,
                    form: false
                },
                {
                    config: {
                        name: 'id_int_comprobante',
                        fieldLabel: 'ID.',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 10
                    },
                    type: 'TextField',
                    filters:{pfiltro:'incbte.id_int_comprobante',type:'numeric'},
                    id_grupo: 1,
                    grid: true,
                    form: false,
                    bottom_filter: true,

                },
                {
                    config: {
                        name: 'fecha',
                        fieldLabel: 'Fecha',
                        allowBlank: false,
                        anchor: '80%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer: function (value, p, record) {
                            return value ? value.dateFormat('d/m/Y') : ''
                        }
                    },
                    type: 'DateField',
                    filters: {
                        pfiltro: 'incbte.fecha',
                        type: 'date'
                    },
                    id_grupo: 2,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'nro_tramite',
                        gwidth: 150,
                        fieldLabel: 'Nro. Trámite',
                        renderer: function (value, p, record) {
                            if (record.data.cbte_reversion == 'si') {
                                return String.format('<div title="Cbte de Reversión"><b><font color="#0000FF">{0}</font></b></div>', value);
                            }
                            if (record.data.volcado == 'si') {
                                return String.format('<div title="Cbte Revertido/Volcado"><b><font color="red">{0}</font></b></div>', value);
                            }
                            return String.format('{0}', value);

                        }
                    },
                    type: 'Field',
                    id_grupo: 0,
                    filters: {
                        pfiltro: 'incbte.nro_tramite',
                        type: 'string'
                    },
                    grid: true,
                    bottom_filter: true,
                    form: false,
                },
                {
                    config: {
                        name: 'beneficiario',
                        fieldLabel: 'Beneficiario',
                        allowBlank: false,
                        anchor: '100%',
                        gwidth: 250,
                        maxLength: 100
                    },
                    type: 'TextField',
                    filters: {
                        pfiltro: 'incbte.beneficiario',
                        type: 'string'
                    },
                    id_grupo: 0,
                    bottom_filter: true,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'codigo',
                        fieldLabel: 'Moneda',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 10
                    },
                    type: 'TextField',
                    // filters:{pfiltro:'cajero.estado_reg',type:'string'},
                    id_grupo: 1,
                    grid: true,
                    form: false
                },
                {
                    config: {
                        name: 'liquido_pagable',
                        fieldLabel: 'Liquido Pagable',
                        gwidth: 50,
                        renderer: function (value, p, record) {
                            return String.format('{0}', Ext.util.Format.number(value, '0,000.00'));
                        }
                    },
                    type: 'Field',
                    id_grupo: 0,
                    filters: {
                        pfiltro: 'incbte.liquido_pagable',
                        type: 'string'
                    },
                    grid: true,
                    form: false
                },
                {
                    config: {
                        name: 'glosa',
                        fieldLabel: 'Glosa',
                        allowBlank: false,
                        anchor: '100%',
                        gwidth: 100,
                        maxLength: 1500
                    },
                    type: 'TextArea',
                    filters: {
                        pfiltro: 'incbte.glosa',
                        type: 'string'
                    },
                    id_grupo: 0,
                    bottom_filter: true,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'fecha_documento',
                        fieldLabel: 'Fecha Documento',
                        allowBlank: false,
                        anchor: '80%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer: function (value, p, record) {
                            return value ? value.dateFormat('d/m/Y') : ''
                        }
                    },
                    type: 'DateField',
                    // filters:{pfiltro:'cajero.fecha_inicio',type:'date'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'cento_consto',
                        fieldLabel: 'Cento Consto',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 300,
                        maxLength: 10
                    },
                    type: 'TextField',
                    filters:{pfiltro:'incbte.cento_consto',type:'string'},
                    id_grupo: 1,
                    grid: true,
                    form: false,
                    bottom_filter: true,
                }
            ],
            title: 'Reporte',
            tam_pag: 50,
            ActList: '../../sis_tesoreria/control/ConsultaCbte/listaConsultaCbte',
            id_store: 'id_int_comprobante',
            fields: [
                {name: 'manual', type: 'string'},
                {name: 'estado_reg', type: 'string'},
                {name: 'id_int_comprobante', type: 'numeric'},
                {name: 'fecha', type: 'date', dateFormat: 'Y-m-d'},
                {name: 'nro_tramite', type: 'string'},
                {name: 'beneficiario', type: 'string'},
                {name: 'tipo_cambio', type: 'string'},
                {name: 'liquido_pagable', type: 'numeric'},
                {name: 'glosa', type: 'string'},
                {name: 'fecha_documento', type: 'date', dateFormat: 'Y-m-d'},
                {name: 'cento_consto', type: 'string'},
                {name: 'codigo', type: 'string'}
            ],

            sortInfo: {
                field: 'id_int_comprobante',
                direction: 'ASC'
            },
            bdel: false,
            bsave: false,
            bnew: false,
            bedit: false,
            cmbDepto: new Ext.form.AwesomeCombo({
                name: 'id_depto',
                fieldLabel: 'Depto',
                typeAhead: false,
                forceSelection: true,
                allowBlank: false,
                disableSearchButton: true,
                emptyText: 'Depto Contable',
                store: new Ext.data.JsonStore({
                    url: '../../sis_parametros/control/Depto/listarDeptoFiltradoDeptoUsuario',
                    id: 'id_depto',
                    root: 'datos',
                    sortInfo: {
                        field: 'deppto.nombre',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_depto', 'nombre', 'codigo'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams: {
                        par_filtro: 'deppto.nombre#deppto.codigo',
                        estado: 'activo',
                        codigo_subsistema: 'CONTA'
                    }
                }),
                valueField: 'id_depto',
                displayField: 'nombre',
                hiddenName: 'id_depto',
                enableMultiSelect: true,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 20,
                queryDelay: 200,
                anchor: '80%',
                listWidth: '280',
                resizable: true,
                minChars: 2
            }),
            cmbGestion: new Ext.form.ComboBox({
                fieldLabel: 'Gestion',
                grupo: [0, 1, 2],
                allowBlank: false,
                blankText: '... ?',
                emptyText: 'Gestion...',
                name: 'id_gestion',
                store: new Ext.data.JsonStore(
                    {
                        url: '../../sis_parametros/control/Gestion/listarGestion',
                        id: 'id_gestion',
                        root: 'datos',
                        sortInfo: {
                            field: 'gestion',
                            direction: 'DESC'
                        },
                        totalProperty: 'total',
                        fields: ['id_gestion', 'gestion'],
                        // turn on remote sorting
                        remoteSort: true,
                        baseParams: {par_filtro: 'gestion'}
                    }),
                valueField: 'id_gestion',
                triggerAction: 'all',
                displayField: 'gestion',
                hiddenName: 'id_gestion',
                mode: 'remote',
                pageSize: 50,
                queryDelay: 500,
                listWidth: '280',
                width: 80
            }),

            capturaFiltros: function (combo, record, index) {
                this.store.baseParams.id_deptos = this.cmbDepto.getValue();
                this.store.baseParams.id_gestion = this.cmbGestion.getValue();

                this.store.baseParams.nombreVista = this.nombreVista
                this.load();
            },
            validarFiltros: function () {
                return !!(this.cmbDepto.getValue() !== '' && this.cmbGestion.validate());
            },
            onButtonAct: function () {
                if (!this.validarFiltros()) {
                    alert('Especifique los filtros antes')
                } else {
                    this.capturaFiltros();
                }
            },
        }
    )
</script>