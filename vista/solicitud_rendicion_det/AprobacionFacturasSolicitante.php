<?php
/**
 *@package pXP
 *@file AprobacionFacturasSolicitante.php
 *@author  gsarmiento
 *@date 20-04-2017
 *@description Archivo con la interfaz de usuario que permite
 *visualizar las facturas rendidas
 *
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.AprobacionFacturasSolicitante = {
        bedit: false,
        bnew: false,
        bsave: false,
        bdel: false,
        require: '../../../sis_tesoreria/vista/solicitud_rendicion_det/AprobacionFacturas.php',
        requireclase: 'Phx.vista.AprobacionFacturas',
        title: 'Caja',
        nombreVista: 'AprobacionFacturasSolicitante',

        constructor: function (config) {
            Phx.vista.AprobacionFacturasSolicitante.superclass.constructor.call(this, config);
        },

        preparaMenu:function(n){
            var data = this.getSelectedData();
            var tb =this.tbar;
            if (this.maestro.estado == 'revision'){
                this.getBoton('dev_factura').enable();
            }else{
                this.getBoton('dev_factura').disable();
            }
        },

        liberaMenu:function(n) {
            this.getBoton('dev_factura').disable();
        }
    }
</script>