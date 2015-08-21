<?php
/**
*@package pXP
*@file    FormTransferencia.php
*@author  Gonzalo Sarmiento Sejas
*@date    05-02-2015
*@description muestra un formulario que muestra el deposito al cual sera asociado
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.FormTransferencia=Ext.extend(Phx.frmInterfaz,{
    ActSave:'../../sis_tesoreria/control/ACTTsLibroBancos/transferirDeposito',
    layout:'fit',
    maxCount:0,
    constructor:function(config){   
        Phx.vista.FormTransferencia.superclass.constructor.call(this,config);
        this.init(); 
		this.iniciarEventos();
		Ext.apply(this.Cmp.id_cuenta_bancaria_mov.store.baseParams,{id_cuenta_bancaria: this.data.id_cuenta_bancaria, mycls:"TsLibroBancosDeposito"});
        this.loadValoresIniciales();
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
				name:'tipo',
				fieldLabel:'Tipo',
				allowBlank:false,
				emptyText:'Tipo...',
				typeAhead: true,
				triggerAction: 'all',
				lazyRender:true,
				mode: 'local',
				valueField: 'estilo',
				gwidth: 100,
				store:new Ext.data.ArrayStore({
                            fields: ['variable', 'valor'],
                            data : [ ['saldo','Saldo'],
									 ['parcial','Parcial']
                                    ]
                                    }),
				valueField: 'variable',
				displayField: 'valor'
			},
			type:'ComboBox',
			id_grupo:1,
			filters:{	
					 type: 'list',
					  pfiltro:'lban.tipo',
					 options: ['total','saldo'],	
				},
			grid:true,
			form:true
		}, 
		{
            config:{
                name: 'id_cuenta_bancaria_mov',
                fieldLabel: 'Depósito',
                allowBlank: false,
                emptyText : 'Depósito...',
                store: new Ext.data.JsonStore({
                    url:'../../sis_tesoreria/control/TsLibroBancos/listarTsLibroBancos',
                    id : 'id_cuenta_bancaria_mov',
                    root: 'datos',
                    sortInfo:{
                            field: 'fecha',
                            direction: 'DESC'
                    },
                    totalProperty: 'total',
                    fields: ['id_libro_bancos','id_cuenta_bancaria','fecha','detalle','observaciones','nro_comprobante','importe_deposito','saldo_deposito','comprobante_sigma'],
                    remoteSort: true,
                    baseParams:{par_filtro:'detalle#nro_comprobante#importe_deposito'}
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
               anchor: '100%',
               gwidth:200,
               minChars:2,
               tpl: '<tpl for="."><div class="x-combo-list-item"><p>{detalle}</p><p>Fecha:<strong>{fecha}</strong></p><p>Importe:<strong>{importe_deposito}</strong></p><p>Cbte:<strong>{nro_comprobante}</strong></p>			   <p>Cbte Sigma:<strong>{comprobante_sigma}</strong></p><p>Saldo:<strong>{saldo_deposito}</strong></p></div></tpl>',
               renderer:function(value, p, record){return String.format('{0}', record.data['desc_deposito']);}
            },
            type:'ComboBox',
            filters:{pfiltro:'cbanmo.detalle#cbanmo.nro_doc_tipo',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
		{
			config:{
				name: 'importe_transferencia',
				fieldLabel: 'Importe',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:1310722
			},
			type:'NumberField',
			//filters:{pfiltro:'lban.importe_cheque',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		}
    ],
    
    title:'Transferencia de Deposito',
    
	iniciarEventos:function(){
	
		this.cmpTipo = this.getComponente('tipo');	
		this.cmpImporteTransferencia = this.getComponente('importe_transferencia');	
				
		 this.cmpTipo.on('select',function(com,dat){
		 
			  switch(dat.data.variable){
				case  'parcial':
					this.cmpImporteTransferencia.reset();
					this.mostrarComponente(this.cmpImporteTransferencia);					
					break;	
				
				default:
					this.ocultarComponente(this.cmpImporteTransferencia);
					this.cmpImporteTransferencia.reset();
					break;
			  }
		  },this);
	},
	
    onSubmit:function(){
       //TODO passar los datos obtenidos del wizard y pasar  el evento save 
       if (this.form.getForm().isValid()) {
		   this.fireEvent('beforesave',this,this.getValues());
		   this.getValues();
       }
    },
    getValues:function(){
        var resp = {
                   id_libro_bancos:this.data.id_libro_bancos,
                   tipo:this.Cmp.tipo.getValue(),
				   importe_transferencia:this.Cmp.importe_transferencia.getValue(),
				   id_libro_bancos_fk:this.Cmp.id_cuenta_bancaria_mov.getValue()				   
            }   
         return resp;   
     }
    
    
})    
</script>
