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
				disabled:false,
				handler:this.antEstado,
				tooltip: '<b>Anterior</b><p>Pasa al anterior estado</p>'
			}
		);

		  this.store.baseParams={tipo_interfaz:this.nombreVista};

      this.load({params:{start:0, limit:this.tam_pag}})
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
        this.getBoton('chkpresupuesto').enable();
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
    }
};
</script>
