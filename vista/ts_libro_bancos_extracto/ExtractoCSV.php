<?php
/**
 *@package pXP
 *@file    SubirArchivo.php
 *@author  Grover Velasquez Colque
 *@date    22-03-2012
 *@description permite subir archivos csv con el extracto bancario de una cuenta en la tabla de ts_libro_bancos_extracto
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.ConsumoCsv=Ext.extend(Phx.frmInterfaz,{

            constructor:function(config)
            {
                Phx.vista.ConsumoCsv.superclass.constructor.call(this,config);
                this.init();
                this.loadValoresIniciales();
            },

            loadValoresIniciales:function()
            {
                Phx.vista.ConsumoCsv.superclass.loadValoresIniciales.call(this);
                this.getComponente('id_cuenta_bancaria').setValue(this.id_cuenta_bancaria);
            },

            successSave:function(resp)
            {
                Phx.CP.loadingHide();
                Phx.CP.getPagina(this.idContenedorPadre).reload();
                this.panel.close();
            },


            Atributos:[
                {
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
                        name:'codigo',
                        fieldLabel:'Codigo Archivo',
                        allowBlank:false,
                        emptyText:'Codigo Archivo...',
                        store: new Ext.data.JsonStore({
                            url: '../../sis_parametros/control/PlantillaArchivoExcel/listarPlantillaArchivoExcel',
                            id: 'id_plantilla_archivo_excel',
                            root: 'datos',
                            sortInfo:{
                                field: 'codigo',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_plantilla_archivo_excel','nombre','codigo'],
                            // turn on remote sorting
                            remoteSort: true,
                            baseParams:{par_filtro:'codigo', vista: 'vista'}
                        }),
                        valueField: 'codigo',
                        displayField: 'codigo',
                        tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{nombre}</b></p><p>{codigo}</p></div></tpl>',
                        hiddenName: 'codigo',
                        forceSelection:true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender:true,
                        mode:'remote',
                        pageSize:10,
                        queryDelay:1000,
                        listWidth:260,
                        resizable:true,
                        anchor:'90%'
                    },
                    type:'ComboBox',
                    id_grupo:0,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        fieldLabel: "Documento",
                        gwidth: 130,
                        inputType:'file',
                        name: 'archivo',
                        buttonText: '',
                        maxLength:150,
                        anchor:'100%'
                    },
                    type:'Field',
                    form:true
                }
            ],
            title:'Subir Archivo',
            fileUpload:true,
            ActSave:'../../sis_tesoreria/control/TsLibroBancosExtracto/cargarExtractoCsv'
        }
    )
</script>