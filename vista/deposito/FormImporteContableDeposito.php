<?php
/**
*@package pXP
*@file    FormImporteContableDeposito.php
*@author  Gonzalo Sarmiento Sejas
*@date    19-08-2016
*@description muestra un formulario que muestra el importe contable con el cual sera registrado el deposito
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.FormImporteContableDeposito=Ext.extend(Phx.frmInterfaz,{
    ActSave:'../../sis_tesoreria/control/ACTProcesoCaja/importeContableDeposito',
    layout:'fit',
    maxCount:0,
    constructor:function(config){   
        Phx.vista.FormImporteContableDeposito.superclass.constructor.call(this,config);
        this.init();		
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
				name: 'importe_contable_deposito',
				fieldLabel: 'Importe Contable Deposito',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,				
				decimalPrecision:2,
				maxLength:1310722
			},
				type:'NumberField',
				filters:{pfiltro:'lban.importe_contable_deposito',type:'numeric'},
				id_grupo:1,
				grid:false,
				form:true
		}
    ],
    
    title:'Importe Contable Deposito',
	
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
				   importe_contable_deposito:this.Cmp.importe_contable_deposito.getValue(),
				   id_cuenta_doc: me.data.id_cuenta_doc,
				   id_libro_bancos: me.rec.id_libro_bancos
            }   
         return resp;   
     }    
    
})    
</script>
