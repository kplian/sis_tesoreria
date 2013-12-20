<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (fprudencio)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite 
*dar el visto a solicitudes de compra
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PlanPagoVb = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
	require:'../../../sis_tesoreria/vista/plan_pago/PlanPago.php',
	requireclase:'Phx.vista.PlanPago',
	title:'Plan de Pagos',
	nombreVista: 'planpagoVb',
	
	constructor: function(config) {
	    
	   this.Atributos[this.getIndAtributo('numero_op')].grid=true; 
	    
       Phx.vista.PlanPagoVb.superclass.constructor.call(this,config);
       
       
       this.addButton('SolDevPag',{text:'Solicitar Devengado/Pago',iconCls: 'bpagar',disabled:true,handler:this.onBtnDevPag,tooltip: '<b>Solicitar Devengado/Pago</b><br/>Genera en cotabilidad el comprobante Correspondiente, devengado o pago  '});
        
       
       this.crearFormularioEstados();
       this.crearFomularioDepto()
       
       
       this.store.baseParams={tipo_interfaz:this.nombreVista};
       this.load({params:{start:0, limit:this.tam_pag}});
       
       
        
    },
    
    crearFomularioDepto:function(){
      
                this.cmpDeptoConta = new Ext.form.ComboBox({
                            xtype: 'combo',
                            name: 'id_depto_conta',
                            hiddenName: 'id_depto_conta',
                            fieldLabel: 'Depto. Conta.',
                            allowBlank: false,
                            emptyText:'Elija un Depto',
                            store:new Ext.data.JsonStore(
                            {
                                url: '../../sis_tesoreria/control/ObligacionPago/listarDeptoFiltradoObligacionPago',
                                id: 'id_depto',
                                root: 'datos',
                                sortInfo:{
                                    field: 'deppto.nombre',
                                    direction: 'ASC'
                                },
                                totalProperty: 'total',
                                fields: ['id_depto','nombre'],
                                // turn on remote sorting
                                remoteSort: true,
                                baseParams:{par_filtro:'deppto.nombre#deppto.codigo',estado:'activo',codigo_subsistema:'CONTA',tipo_filtro:'DEP_EP-DEP_EP'}
                            }),
                            valueField: 'id_depto',
                            displayField: 'nombre',
                            tpl:'<tpl for="."><div class="x-combo-list-item"><p>{nombre}</p></div></tpl>',
                            hiddenName: 'id_depto_tes',
                            forceSelection:true,
                            typeAhead: true,
                            triggerAction: 'all',
                            lazyRender:true,
                            mode:'remote',
                            pageSize:10,
                            queryDelay:1000,
                            width:250,
                            listWidth:'280',
                            minChars:2
                        });
                
                this.formDEPTO = new Ext.form.FormPanel({
                    baseCls: 'x-plain',
                    autoDestroy: true,
                    layout: 'form',
                    items: [this.cmpDeptoConta]
                });
                
               
                
                this.wDEPTO= new Ext.Window({
                    title: 'Depto Tesoreria',
                    collapsible: true,
                    maximizable: true,
                     autoDestroy: true,
                    width: 400,
                    height: 200,
                    layout: 'fit',
                    plain: true,
                    bodyStyle: 'padding:5px;',
                    buttonAlign: 'center',
                    items: this.formDEPTO,
                    modal:true,
                     closeAction: 'hide',
                    buttons: [{
                        text: 'Guardar',
                         handler:this.onSubmitDepto,
                        scope:this
                        
                    },{
                        text: 'Cancelar',
                        handler:function(){this.wDEPTO.hide()},
                        scope:this
                    }]
                });   
        
    },
    
    
    
    onBtnDevPag:function()
        {                   
            var data = this.getSelectedData();
            
            console.log('depto_conta',data.id_depto_conta)
            if(data.id_depto_conta > 0){
           
                this.onSubmitDepto(undefined,undefined,data.id_depto_conta);  
            }
            else{
              
                this.wDEPTO.show();
                this.cmpDeptoConta.reset();
                this.cmpDeptoConta.store.baseParams.id_plan_pago = data.id_plan_pago;
                this.cmpDeptoConta.store.baseParams.id_obligacion_pago = data.id_obligacion_pago;
                this.cmpDeptoConta.modificado = true;
              
            }  
      },
      
    
    
    onSubmitDepto:function(x,y,id_depto_conta){
           var data = this.getSelectedData();
          
           if(this.formDEPTO.getForm().isValid() || id_depto_conta){
                Phx.CP.loadingShow();
               Ext.Ajax.request({
                    // form:this.form.getForm().getEl(),
                    url:'../../sis_tesoreria/control/PlanPago/solicitarDevPag',
                    params:{ id_plan_pago:data.id_plan_pago, 
                             id_depto_conta:id_depto_conta?id_depto_conta:this.cmpDeptoConta.getValue()},
                    success:this.successSinc,
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
                })
            }
        
    },  
    
    
    preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;
          Phx.vista.PlanPagoVb.superclass.preparaMenu.call(this,n); 
         
         
          if (data['estado']== 'borrador' || data['estado']== 'pendiente' || data['estado']== 'devengado' || data['estado']== 'pagado' ){
                  this.getBoton('ant_estado').disable();
                  this.getBoton('sig_estado').disable();
                  this.getBoton('SolDevPag').disable();    
          }
           else{
                   if (data['estado']== 'vbconta'){
                       this.getBoton('ant_estado').enable();
                       this.getBoton('sig_estado').disable();
                        this.getBoton('SolDevPag').enable();
                       
                   }
                   else{
                       this.getBoton('ant_estado').enable();
                       this.getBoton('sig_estado').enable();
                       this.getBoton('SolDevPag').disable();
                       
                   }
                  
                  
                  
          }
              
          
          
     },
    
    liberaMenu:function(){
        var tb = Phx.vista.PlanPagoVb.superclass.liberaMenu.call(this);
        
        if(tb){
           this.getBoton('ant_estado').disable();
           this.getBoton('sig_estado').disable();
           this.getBoton('SolDevPag').disable();
           
        }
       return tb
    }, 
    
    south:{
          url:'../../../sis_tesoreria/vista/prorrateo/Prorrateo.php',
          title:'Prorrateo', 
          height:'40%',
          cls:'Prorrateo'
     },
   sortInfo:{
        field: 'numero_op',
        direction: 'ASC'
    }
    
    
};
</script>
