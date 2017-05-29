<?php
/**
*@package pXP
*@file ProcesoCajaVb.php
*@author  Gonzalo Sarmiento Sejas
*@date 24-12-2015
*@description Archivo con la interfaz de usuario que permite
*dar el visto a Rendiciones y Reposiciones
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ProcesoCajaVb = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
	require:'../../../sis_tesoreria/vista/proceso_caja/ProcesoCaja.php',
	requireclase:'Phx.vista.ProcesoCaja',
	title:'Visto Bueno Rendiciones Caja',
	nombreVista: 'ProcesoCajaVb',
	/*
	 *  Interface heredada en el sistema de tesoreria para que el responsable
	 *  de rendiciones apruebe las rendiciones , y pase por los pasos configurados en el WF
	 *  de validacion, aprobacion
	 * */

	constructor: function(config) {

	   Phx.vista.ProcesoCajaVb.superclass.constructor.call(this,config);

	   this.addButton('ant_estado',
			{	text:'Anterior',
				argument: {estado: 'anterior'},
				iconCls: 'batras',
				disabled:true,
				handler:this.antEstado,
				tooltip: '<b>Anterior</b><p>Pasa al anterior estado</p>'
			}
		);

        this.addButton('fin_registro',
            {	text:'Siguiente',
                iconCls: 'badelante',
                disabled:true,
                handler:this.sigEstado,
                tooltip: '<b>Siguiente</b><p>Pasa al siguiente estado</p>'
            }
        );

		  this.store.baseParams={tipo_interfaz:this.nombreVista};
    },


   preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;
          //Phx.vista.ProcesoCajaVb.superclass.preparaMenu.call(this,n);

		  if (data['estado']!= 'pendiente' && data['estado']!= 'contabilizado' && data['estado']!= 'cerrado' && data['estado']!= 'rendido'){
              this.getBoton('fin_registro').enable();
              this.getBoton('ant_estado').enable();
          }
          else{
              this.getBoton('fin_registro').disable();
              this.getBoton('ant_estado').disable();
          }
		  		  
		  if(data['tipo']=='SOLREN'){
			//this.getBoton('consolidado_rendicion').enable();
			//this.getBoton('consolidado_reposicion').disable();
		  }else if(data['tipo']=='SOLREP'){
			//this.getBoton('consolidado_rendicion').disable();
			//this.getBoton('consolidado_reposicion').enable();
		  }else{
			//this.getBoton('consolidado_rendicion').disable();
			//this.getBoton('consolidado_reposicion').disable();
		  }

       if(data['tipo']=='CIERRE'){
           //habilitar pestaña depositos
           this.enableTabDepositos();
       }else{
           //deshabilitar pestaña depositos
           this.disableTabDepositos();
       }
		  
        //this.getBoton('chkpresupuesto').enable();
	},

    enableTabDepositos:function(){
        if(this.TabPanelSouth.get(1)){
            this.TabPanelSouth.get(1).enable();
            this.TabPanelSouth.setActiveTab(1)
        }
    },

    disableTabDepositos:function(){
        if(this.TabPanelSouth.get(1)){
            this.TabPanelSouth.get(1).disable();
            this.TabPanelSouth.setActiveTab(0)

        }
    },

	antEstado:function(res){
         var rec=this.sm.getSelected();
         Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/AntFormEstadoWf.php',
            'Estado de Wf',
            {
                modal:true,
                width:450,
                height:250
            }, { data:rec.data, estado_destino: res.argument.estado }, this.idContenedor,'AntFormEstadoWf',
            {
                config:[{
                          event:'beforesave',
                          delegate: this.onAntEstado,
                        }
                        ],
               scope:this
             })
   },

   onAntEstado: function(wizard,resp){
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url:'../../sis_tesoreria/control/ProcesoCaja/anteriorEstadoProcesoCaja',
                params:{
                        id_proceso_wf: resp.id_proceso_wf,
                        id_estado_wf:  resp.id_estado_wf,
                        obs: resp.obs,
                        estado_destino: resp.estado_destino
                 },
                argument:{wizard:wizard},
                success:this.successEstadoSinc,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });

     },

   successEstadoSinc:function(resp){
        Phx.CP.loadingHide();
        resp.argument.wizard.panel.destroy()
        this.reload();
     },

    liberaMenu:function(){

        var tb = Phx.vista.ProcesoCajaVb.superclass.liberaMenu.call(this);

       return tb
    },

    sigEstado:function(){
        var rec=this.sm.getSelected();
        var configExtra = [];

        if(rec.data.tipo == 'SOLREP' || rec.data.tipo=='REPO') {
            if (rec.data.estado == 'vbconta' || rec.data.estado == 'revision' || rec.data.estado == 'vbfondos') {
                configExtra = [
                    {
                        config: {
                            name: 'id_cuenta_bancaria',
                            fieldLabel: 'Cuenta Bancaria',
                            allowBlank: false,
                            emptyText: 'Elija una Cuenta...',
                            store: new Ext.data.JsonStore(
                                {
                                    url: '../../sis_tesoreria/control/CuentaBancaria/listarCuentaBancariaUsuario',
                                    id: 'id_cuenta_bancaria',
                                    root: 'datos',
                                    sortInfo: {
                                        field: 'id_cuenta_bancaria',
                                        direction: 'ASC'
                                    },
                                    totalProperty: 'total',
                                    fields: ['id_cuenta_bancaria', 'nro_cuenta', 'nombre_institucion', 'codigo_moneda', 'centro', 'denominacion'],
                                    remoteSort: true,
                                    baseParams: {
                                        par_filtro: 'nro_cuenta', id_depto_lb: rec.data.id_depto_lb, permiso: 'todos'
                                    }
                                }),
                            tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>{nro_cuenta}</b></p><p>Moneda: {codigo_moneda}, {nombre_institucion}</p><p>{denominacion}, Centro: {centro}</p></div></tpl>',
                            valueField: 'id_cuenta_bancaria',
                            hiddenValue: 'id_cuenta_bancaria',
                            displayField: 'nro_cuenta',
                            gdisplayField: 'desc_cuenta_bancaria',
                            listWidth: '280',
                            forceSelection: true,
                            typeAhead: false,
                            triggerAction: 'all',
                            lazyRender: true,
                            mode: 'remote',
                            pageSize: 20,
                            queryDelay: 500,
                            gwidth: 550,
                            anchor: '80%',
                            minChars: 2,
                            renderer: function (value, p, record) {
                                return String.format('{0}', record.data['desc_cuenta_bancaria']);
                            }
                        },
                        type: 'ComboBox',
                        filters: {pfiltro: 'cb.nro_cuenta', type: 'string'},
                        id_grupo: 1,
                        grid: true,
                        form: true
                    },
                    {
                        config: {
                            name: 'id_cuenta_bancaria_mov',
                            fieldLabel: 'Fondo',
                            allowBlank: true,
                            emptyText: 'Fondo...',
                            store: new Ext.data.JsonStore({
                                url: '../../sis_tesoreria/control/TsLibroBancos/listarTsLibroBancosDepositosConSaldo',
                                id: 'id_cuenta_bancaria_mov',
                                root: 'datos',
                                sortInfo: {
                                    field: 'fecha',
                                    direction: 'DESC'
                                },
                                totalProperty: 'total',
                                fields: ['id_libro_bancos', 'id_cuenta_bancaria', 'fecha', 'detalle', 'observaciones', 'importe_deposito', 'saldo'],
                                remoteSort: true,
                                baseParams: {par_filtro: 'detalle#observaciones#fecha'}
                            }),
                            valueField: 'id_libro_bancos',
                            displayField: 'importe_deposito',
                            gdisplayField: 'desc_deposito',
                            hiddenName: 'id_cuenta_bancaria_mov',
                            forceSelection: true,
                            typeAhead: false,
                            triggerAction: 'all',
                            listWidth: 350,
                            lazyRender: true,
                            mode: 'remote',
                            pageSize: 10,
                            queryDelay: 1000,
                            anchor: '80%',
                            gwidth: 200,
                            minChars: 2,
                            tpl: '<tpl for="."><div class="x-combo-list-item"><p>{detalle}</p><p>Fecha:<strong>{fecha}</strong></p><p>Importe:<strong>{importe_deposito}</strong></p><p>Saldo:<strong>{saldo}</strong></p></div></tpl>',
                            renderer: function (value, p, record) {
                                return String.format('{0}', record.data['desc_deposito']);
                            }
                        },
                        type: 'ComboBox',
                        filters: {pfiltro: 'cbanmo.detalle#cbanmo.nro_doc_tipo', type: 'string'},
                        id_grupo: 1,
                        grid: true,
                        form: true
                    }];

                this.eventosExtra = function (obj) {
                    //Evento para filtrar los depósitos a partir de la cuenta bancaria
                    obj.Cmp.id_cuenta_bancaria.on('select', function (data, rec, ind) {
                        //si es de una regional nacional
                        this.Cmp.id_cuenta_bancaria_mov.reset();
                        this.Cmp.id_cuenta_bancaria_mov.modificado = true;
                        Ext.apply(this.Cmp.id_cuenta_bancaria_mov.store.baseParams, {id_cuenta_bancaria: rec.id});
                    }, obj);

                };
            }
        }
        this.objWizard = Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php',
            'Estado de Wf',
            {
                modal:true,
                width:700,
                height:450
            }, {
                configExtra: configExtra,
                eventosExtra: this.eventosExtra,
                data:{
                    id_estado_wf:rec.data.id_estado_wf,
                    id_proceso_wf:rec.data.id_proceso_wf
                }}, this.idContenedor,'FormEstadoWf',
            {
                config:[{
                    event:'beforesave',
                    delegate: this.onSaveWizard
                }],

                scope:this
            });
    },
    onSaveWizard:function(wizard,resp){
        Phx.CP.loadingShow();
        Ext.Ajax.request({
            url:'../../sis_tesoreria/control/ProcesoCaja/siguienteEstadoProcesoCaja',
            params:{

                id_proceso_wf_act:  resp.id_proceso_wf_act,
                id_estado_wf_act:   resp.id_estado_wf_act,
                id_tipo_estado:     resp.id_tipo_estado,
                id_funcionario_wf:  resp.id_funcionario_wf,
                id_depto_wf:        resp.id_depto_wf,
                obs:                resp.obs,
                id_cuenta_bancaria:	resp.id_cuenta_bancaria,
                id_cuenta_bancaria_mov : resp.id_cuenta_bancaria_mov,
                json_procesos:      Ext.util.JSON.encode(resp.procesos)
            },
            success:this.successWizard,
            failure: this.conexionFailure,
            argument:{wizard:wizard},
            timeout:this.timeout,
            scope:this
        });
    },

    successWizard:function(resp){
        Phx.CP.loadingHide();
        resp.argument.wizard.panel.destroy()
        this.reload();
    }
};
</script>
