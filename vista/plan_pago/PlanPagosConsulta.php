<?php
/**
 *@package pXP
 *@file gen-SistemaDist.php
 *@author  (fprudencio)
 *@date 20-09-2011 10:22:05
 *@description Archivo con la interfaz de usuario que permite
 *dar el visto a solicitudes de compra
 * ISSUE        FECHA           AUTOR           DESCRIPCION
 *#ETR-3653     2004/2021       EGS             Se habilito el boton de sol plan pago
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.PlanPagosConsulta = {
        bdel:false,
        bedit:false,
        bsave:false,
        bnew:false,
        require:'../../../sis_tesoreria/vista/plan_pago/PlanPago.php',
        requireclase:'Phx.vista.PlanPago',
        title:'Registro de Planes de Pago',
        nombreVista: 'PlanPagosConsulta',

        constructor: function(config) {
            this.Atributos[this.getIndAtributo('numero_op')].grid=true;
            this.Atributos[this.getIndAtributo('nro_cuota')].form=false;
            this.Atributos[this.getIndAtributo('forma_pago')].form=true;
            this.Atributos[this.getIndAtributo('nro_cheque')].form=true;
            this.Atributos[this.getIndAtributo('nro_cuenta_bancaria')].form=true;
            this.Atributos[this.getIndAtributo('id_depto_lb')].form=true;
            this.Atributos[this.getIndAtributo('id_cuenta_bancaria')].form=true;
            this.Atributos[this.getIndAtributo('id_cuenta_bancaria_mov')].form=true;
            this.maestro = config.maestro;
            Phx.vista.PlanPagosConsulta.superclass.constructor.call(this,config);

            this.getBoton('ini_estado').setVisible(false);
            this.getBoton('ant_estado').setVisible(false);
            this.getBoton('sig_estado').setVisible(false);
            //this.getBoton('SolPlanPago').setVisible(false);//#ETR-3653
            this.getBoton('btnChequeoDocumentosWf').setVisible(false);
            this.getBoton('btnPagoRel').setVisible(false);
            this.getBoton('btnObs').setVisible(false);
            this.getBoton('SincPresu').setVisible(false);
            //si la interface es pestanha este código es para iniciar
            var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData();
            if(dataPadre){
                this.onEnablePanel(this, dataPadre);
            }
            else{
                this.bloquearMenus();
            }

        },
        onReloadPage:function(m){
            this.maestro = m;
            this.store.baseParams={id_obligacion_pago:this.maestro.id_obligacion_pago,tipo_interfaz:this.nombreVista};
            this.load({params:{start:0, limit:this.tam_pag}});
        },
        east:{
            url:'../../../sis_tesoreria/vista/prorrateo/ProrrateoConsulta.php',
            title:'Prorrateo',
            width:400,
            cls:'ProrrateoConsulta'
        },
        tabla_id: 'id_plan_pago',
        tabla:'tes.tplan_pago'
    };
</script>
