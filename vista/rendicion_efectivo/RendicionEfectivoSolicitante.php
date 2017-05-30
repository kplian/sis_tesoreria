<?php
/**
 *@package pXP
 *@file RendicionEfectivoSolicitante.php
 *@author  gsarmiento
 *@date 03-12-2015
 *@description Archivo con la interfaz de usuario que permite
 *dar el visto a solicitudes de apertura, rendicion de caja chica
 *
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.RendicionEfectivoSolicitante = {
        bedit:false,
        bnew:false,
        bsave:false,
        bdel:false,
        require:'../../../sis_tesoreria/vista/rendicion_efectivo/RendicionEfectivo.php',
        requireclase:'Phx.vista.RendicionEfectivo',
        title:'Caja',
        nombreVista: 'RendicionEfectivoSolicitante',

        constructor: function(config) {

            Phx.vista.RendicionEfectivoSolicitante.superclass.constructor.call(this,config);

            this.load({params:{start:0, limit: this.tam_pag, tipo_interfaz:this.nombreVista, id_solicitud_efectivo_fk:this.id_solicitud_efectivo}});
        },

        preparaMenu:function(n) {
            var data = this.getSelectedData();
            var tb = this.tbar;

            Phx.vista.RendicionEfectivoSolicitante.superclass.preparaMenu.call(this, n);
            this.getBoton('fin_registro').setVisible(false);
            this.bloquearMenusHijo();

            Phx.CP.getPagina(this.idContenedor + '-south-0').getBoton('dev_factura').disable();
            var boton = Phx.CP.getPagina(this.idContenedor + '-south-0').getBoton('dev_factura');
            if (data.estado == 'revision'){
                console.log('entra');
                boton.enable();
            }else{
                boton.disable();
                console.log('sale');
            }
            /*}else{
                this.bloquearMenusHijo();
                console.log(Phx.CP.getPagina(this.idContenedor+'-south-0'));

                this.getBoton('fin_registro').disable();
                this.getBoton('del').disable();
                Phx.CP.getPagina(this.idContenedor+'-south-0').getBoton('dev_factura').disable();
                var boton = Phx.CP.getPagina(this.idContenedor+'-south-0').getBoton('dev_factura');
                boton.disable();
            }*/
        },

        liberaMenu:function(n){
            Phx.vista.RendicionEfectivoSolicitante.superclass.liberaMenu.call(this,n);
            this.getBoton('fin_registro').setVisible(false);
        },

        tabsouth:[
            {
                url:'../../../sis_tesoreria/vista/solicitud_rendicion_det/AprobacionFacturasSolicitante.php',
                title:'Detalle',
                height:'50%',
                cls:'AprobacionFacturasSolicitante'
            }
        ]
    };
</script>
