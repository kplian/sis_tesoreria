<?php
/**
*@package pXP
*@file    FormRelacionarDeposito.php
*@author  Gonzalo Sarmiento Sejas
*@date    28-06-2016
*@description muestra un formulario que muestra el deposito al cual sera asociado
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.FormRelacionarDeposito=Ext.extend(Phx.frmInterfaz,{
    ActSave:'../../sis_tesoreria/control/ACTProcesoCaja/relacionarDeposito',
    layout:'fit',
    maxCount:0,
    constructor:function(config){   
        Phx.vista.FormRelacionarDeposito.superclass.constructor.call(this,config);
        this.init(); 
		this.iniciarEventos();
		
		Ext.apply(this.Cmp.id_cuenta_bancaria_mov.store.baseParams,{id_cuenta_bancaria: this.data.id_cuenta_bancaria, mycls:"RelacionDeposito"});
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
        /*
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
		}, */
		{
            config:{
                name: 'id_cuenta_bancaria',
                fieldLabel: 'Cuenta Bancaria',
                allowBlank: false,
                emptyText:'Elija una Cuenta...',
                store:new Ext.data.JsonStore(
                {
                    url: '../../sis_tesoreria/control/CuentaBancaria/listarCuentaBancariaUsuario',
                    id: 'id_cuenta_bancaria',
                    root:'datos',
                    sortInfo:{
                        field:'id_cuenta_bancaria',
                        direction:'ASC'
                    },
                    totalProperty:'total',
                    fields: ['id_cuenta_bancaria','nro_cuenta','nombre_institucion','codigo_moneda','centro','denominacion'],
                    remoteSort: true,
                    baseParams : {
						par_filtro :'nro_cuenta'
					}
                }),
                tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{nro_cuenta}</b></p><p>Moneda: {codigo_moneda}, {nombre_institucion}</p><p>{denominacion}, Centro: {centro}</p></div></tpl>',
                valueField: 'id_cuenta_bancaria',
                hiddenValue: 'id_cuenta_bancaria',
                displayField: 'nro_cuenta',
                gdisplayField:'desc_cuenta_bancaria',
                listWidth:'300',
                forceSelection:true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:20,
                queryDelay:500,
				anchor: '95%',
                gwidth: 200,
                minChars:2,
                renderer:function(value, p, record){return String.format('{0}', record.data['desc_cuenta_bancaria']);}
             },
            type:'ComboBox',
            filters:{pfiltro:'cb.nro_cuenta',type:'string'},
            id_grupo:1,
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
                    baseParams:{par_filtro:'detalle#nro_comprobante#importe_deposito#comprobante_sigma'}
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
               tpl: '<tpl for="."><div class="x-combo-list-item"><p>{detalle}</p><p>Fecha:<strong>{fecha}</strong></p><p>Importe:<strong>{importe_deposito}</strong></p><p>Cbte:<strong>{nro_comprobante}</strong></p>			   <p>Cbte Sigma:<strong>{comprobante_sigma}</strong></p><p>Saldo:<strong>{saldo_deposito}</strong></p></div></tpl>',
               renderer:function(value, p, record){return String.format('{0}', record.data['desc_deposito']);}
            },
            type:'ComboBox',
            filters:{pfiltro:'cbanmo.detalle#cbanmo.nro_doc_tipo',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        }
    ],
    
    title:'Transferencia de Deposito',
    
	iniciarEventos:function(){
	
		//this.cmpTipo = this.getComponente('tipo');	
		this.cmpImporteTransferencia = this.getComponente('importe_transferencia');	
		/*		
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
		 */
		this.Cmp.id_cuenta_bancaria.store.baseParams.id_depto_lb = this.data.id_depto_lb;
		this.Cmp.id_cuenta_bancaria.store.baseParams.permiso = 'todos';
		
		this.Cmp.id_cuenta_bancaria.on('select',function(data,rec,ind){            
            /*if(rec.data.centro=='no'){
				if(this.Cmp.desc_depto_conta_pp.value='CON-CBB'){
					this.Cmp.id_cuenta_bancaria_mov.allowBlank= true;                
				}else{
					this.Cmp.id_cuenta_bancaria_mov.allowBlank= false;                
				}
            }
            else{				
               this.Cmp.id_cuenta_bancaria_mov.allowBlank = true;
            }*/
            this.Cmp.id_cuenta_bancaria_mov.setValue('');
            this.Cmp.id_cuenta_bancaria_mov.modificado=true;
            this.Cmp.id_cuenta_bancaria_mov.store.baseParams = Ext.apply(this.Cmp.id_cuenta_bancaria_mov.store.baseParams,{id_cuenta_bancaria: rec.id});
        },this);
		//this.Cmp.id_cuenta_bancaria.modificado=true;
	},
	
    onSubmit:function(){
       //TODO passar los datos obtenidos del wizard y pasar  el evento save 
       if (this.form.getForm().isValid()) {
		   this.fireEvent('beforesave',this,this.getValues());
		   this.getValues();
       }
    },
    
    
    id_clave: 'id_proceso_caja',
    valor_clave: 0,
	
    getValues:function(){
		var me = this;
		
        var resp = {
                   id_cuenta_bancaria:this.Cmp.id_cuenta_bancaria.getValue(),
				   id_libro_bancos:this.Cmp.id_cuenta_bancaria_mov.getValue(),
				   id_clave: me.id_clave,
				   valor_clave: me.data[me.id_clave]				   
            }   
         return resp;   
     }    
    
})    
</script>
