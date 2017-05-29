<?php
/**
 *@package pXP
 *@file    ConsultaApropiacionesCaja.php
 *@author  Gonzalo Sarmiento Sejas
 *@date    21-09-2016
 *@description Archivo con la interfaz para generaci�n del reporte consulta de apropiaciones de Caja Chica
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.ConsultaApropiacionesCaja = Ext.extend(Phx.frmInterfaz, {

        Atributos : [
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
                    anchor: '110%',
                    gwidth: 220,
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
                config:{
                    name: 'fecha_ini',
                    fieldLabel: 'Fecha Inicio',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    format: 'd/m/Y',
                    renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                },
                type:'DateField',
                filters:{pfiltro:'fecha_ini',type:'date'},
                id_grupo:1,
                grid:true,
                form:true
            },
            {
                config:{
                    name: 'fecha_fin',
                    fieldLabel: 'Fecha Fin',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    format: 'd/m/Y',
                    renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                },
                type:'DateField',
                filters:{pfiltro:'fecha_fin',type:'date'},
                id_grupo:1,
                grid:true,
                form:true
            }],
        title : 'Consulta Apropiaciones Caja Chica',
        //ActSave : '../../sis_tesoreria/control/TsLibroBancos/pagosSinFacturasAsociadas',

        topBar : true,
        botones : false,
        labelSubmit : 'Imprimir',
        tooltipSubmit : '<b>Generar Reporte Consulta Apropiaciones Caja Chica</b>',

        constructor : function(config) {
            Phx.vista.ConsultaApropiacionesCaja.superclass.constructor.call(this, config);
            this.init();
            this.iniciarEventos();
        },

        iniciarEventos:function(){
            this.cmpIdCaja = this.getComponente('id_caja');
            this.cmpFechaIni = this.getComponente('fecha_ini');
            this.cmpFechaFin = this.getComponente('fecha_fin');
        },

        onSubmit:function(o){
            var data = 'id_caja=' + this.cmpIdCaja.getValue();
            data = data + '&fecha_inicio=' + this.cmpFechaIni.getValue().format('d-m-Y');
            data = data + '&fecha_fin=' + this.cmpFechaFin.getValue().format('d-m-Y');

            console.log(data);
            window.open('http://sms.obairlines.bo/ReportesPXP2/Home/ConsultaApropiacionesCajaChica?'+data);
            //window.open('http://localhost:22021/Home/ReportePagosSinFacturasAsociadas?'+data);
        },

        tipo : 'reporte',
        clsSubmit : 'bprint',

        Grupos : [{
            layout : 'column',
            items : [{
                xtype : 'fieldset',
                layout : 'form',
                border : true,
                title : 'Generar Reporte',
                bodyStyle : 'padding:0 10px 0;',
                columnWidth : '500px',
                items : [],
                id_grupo : 0,
                collapsible : true
            }]
        }]
    })
</script>