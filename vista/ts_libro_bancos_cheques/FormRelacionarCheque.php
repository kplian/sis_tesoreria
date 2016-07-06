<?php
/**
*@package pXP
*@file    FormRelacionarCheque.php
*@author  Gonzalo Sarmiento Sejas
*@date    28-06-2016
*@description muestra un formulario que muestra los cheques sin tramites asociados el cual sera asociado a un tramite
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.FormRelacionarCheque=Ext.extend(Phx.frmInterfaz,{
    layout:'fit',
    maxCount:0,
    constructor:function(config){   
        Phx.vista.FormRelacionarCheque.superclass.constructor.call(this,config);
        this.init(); 
		Ext.apply(this.Cmp.id_cuenta_bancaria_mov.store.baseParams,{id_cuenta_bancaria: this.data.id_cuenta_bancaria, mycls:"RelacionarCheque"});
    },
   
    Atributos:[
        {
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_libro_bancos'
            },
            type:'Field',
            form:true 
        },
		{
            config:{
                name: 'id_cuenta_bancaria_mov',
                fieldLabel: 'Cheque',
                allowBlank: false,
                emptyText : 'Cheque...',
                store: new Ext.data.JsonStore({
                    url:'../../sis_tesoreria/control/TsLibroBancos/listarTsLibroBancos',
                    id : 'id_cuenta_bancaria_mov',
                    root: 'datos',
                    sortInfo:{
                            field: 'fecha',
                            direction: 'DESC'
                    },
                    totalProperty: 'total',
                    fields: ['id_libro_bancos','id_cuenta_bancaria','fecha','detalle','observaciones','nro_comprobante','importe_cheque','comprobante_sigma','nro_cheque'],
                    remoteSort: true,
                    baseParams:{par_filtro:'detalle#nro_comprobante#importe_cheque#nro_cheque'}
               }),
               valueField: 'id_libro_bancos',
               displayField: 'detalle',
               gdisplayField: 'observaciones',
               hiddenName: 'id_cuenta_bancaria_mov',
               forceSelection:true,
               typeAhead: false,
               triggerAction: 'all',
               listWidth:350,
               lazyRender:true,
               mode:'remote',
               pageSize:10,
               queryDelay:1000,
               anchor: '95%',
               gwidth:200,
               minChars:2,
               tpl: '<tpl for="."><div class="x-combo-list-item"><p>{detalle}</p><p>Fecha:<strong>{fecha}</strong></p><p>Nro Cheque:<strong>{nro_cheque}</strong></p><p>Importe:<strong>{importe_cheque}</strong></p><p>Cbte:<strong>{nro_comprobante}</strong></p><p>Cbte Sigma:<strong>{comprobante_sigma}</strong></p></div></tpl>',
               renderer:function(value, p, record){return String.format('{0}', record.data['desc_deposito']);}
            },
            type:'ComboBox',
            filters:{pfiltro:'cbanmo.detalle#cbanmo.nro_doc_tipo',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        }
    ],
    
    title:'Cambio Cheque',
    	
    onSubmit:function(){
       //TODO passar los datos obtenidos del wizard y pasar  el evento save 
       if (this.form.getForm().isValid()) {
		   this.fireEvent('beforesave',this,this.getValues());
		   this.getValues();
       }
    },
    	
    getValues:function(){
		var me = this;
		
        var resp = {
				   id_libro_bancos:this.Cmp.id_cuenta_bancaria_mov.getValue()		   
            }   
         return resp;   
     }    
    
})    
</script>
