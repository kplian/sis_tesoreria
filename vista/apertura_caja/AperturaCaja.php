<?php
/**
*@package pXP
*@file    AperturaCaja.php
*@author  Gonzalo Sarmiento Sejas
*@date    09-10-2015
*@description muestra un formulario que muestra la cuenta y el monto de la transferencia
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.AperturaCaja=Ext.extend(Phx.frmInterfaz,{
    //ActSave:'../../sis_tesoreria/control/TsLibroBancos/transferirCuenta',
    layout:'fit',
    maxCount:0,
    constructor:function(config){   
        Phx.vista.AperturaCaja.superclass.constructor.call(this,config);
        this.init(); 
		this.iniciarEventos();		
        this.loadValoresIniciales();		
    },
   
    Atributos:[
        {
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_cuenta_bancaria_origen'
            },
            type:'Field',
            form:true 
        },
		{
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'estado'
            },
            type:'Field',
            form:true 
        },
		{
            config:{
                name: 'id_depto',
                fieldLabel: 'Depto',
                allowBlank: false,
                anchor: '80%',
                origen: 'DEPTO',
                tinit: false,
                baseParams:{tipo_filtro:'DEPTO_UO',estado:'activo',codigo_subsistema:'TES',modulo:'LB'},//parametros adicionales que se le pasan al store
                gdisplayField:'nombre',
                gwidth: 100
            },
            type:'ComboRec',
            filters:{pfiltro:'dep.nombre',type:'string'},
            id_grupo:1,
            grid:false,
            form:true
        },		
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
                listWidth:'280',
                forceSelection:true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:20,
                queryDelay:500,
                gwidth: 250,
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
				name: 'fecha',
				fieldLabel: 'Fecha',
				allowBlank: false,
				anchor: '80%',
				gwidth: 90,
				format: 'd/m/Y', 
				renderer:function (value,p,record){
					//return value?value.dateFormat('d/m/Y'):''
					if(value == null)
						value = '';
					else 
						value = value.dateFormat('d/m/Y');					
				}
			},
				type:'DateField',
				filters:{pfiltro:'lban.fecha',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'a_favor',
				fieldLabel: 'A favor de',
				allowBlank: false,
				anchor: '80%',
				gwidth: 125,
				maxLength:100
			},
				type:'TextField',
				filters:{pfiltro:'lban.a_favor',type:'string'},
				bottom_filter: true,
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'detalle',
				fieldLabel: 'Detalle',
				allowBlank: false,
				anchor: '80%',
				gwidth: 125,
				maxLength:400
			},
				type:'TextArea',
				filters:{pfiltro:'lban.detalle',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},	
		{
			config:{
				name: 'importe',
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
		},
		{
            config:{
                name:'id_finalidad',
                fieldLabel:'Finalidad',
                allowBlank:false,
                emptyText:'Finalidad...',
                store: new Ext.data.JsonStore({
                         url: '../../sis_tesoreria/control/Finalidad/listarFinalidadCuentaBancaria',
                         id: 'id_finalidad',
                         root: 'datos',
                         sortInfo:{
                            field: 'nombre_finalidad',
                            direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_finalidad','nombre_finalidad','color'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams:{par_filtro:'nombre_finalidad', vista: 'vista'}
                    }),
                valueField: 'id_finalidad',
                displayField: 'nombre_finalidad',
                //tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{nro_cuenta}</b></p><p>{denominacion}</p></div></tpl>',
                hiddenName: 'id_finalidad',
                forceSelection:true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:10,
                queryDelay:1000,
                listWidth:600,
                resizable:true,
                anchor:'80%',
                renderer : function(value, p, record) {
					//return String.format(record.data['nombre_finalidad']);
					return String.format('{0}', '<FONT COLOR="'+record.data['color']+'"><b>'+record.data['nombre_finalidad']+'</b></FONT>');
				}
            },
            type:'ComboBox',
            id_grupo:0,
            grid:true,
            form:true
        }
    ],
    
    title:'Transferencia Cuenta',
    
	iniciarEventos:function(){
		this.cmpIdCuentaBancariaOrigen = this.getComponente('id_cuenta_bancaria_origen');	
		this.cmpIdCuentaBancariaOrigen.setValue(this.data.id_cuenta_bancaria);
		
		this.Cmp.id_depto.on('select',function(a,b,c){
            this.Cmp.id_cuenta_bancaria.store.baseParams.id_depto = this.Cmp.id_depto.getValue();
            Ext.apply(this.Cmp.id_cuenta_bancaria.store.baseParams,{id_depto_lb: this.Cmp.id_depto.getValue(),permiso : 'libro_bancos'})
            this.Cmp.id_cuenta_bancaria.modificado=true;
        },this);
		
		this.cmpImporte = this.getComponente('importe');	
		this.cmpImporte.setValue(this.data.importe_maximo);
		this.cmpImporte.disable();
		
		this.cmpDetalle = this.getComponente('detalle');	
		this.cmpDetalle.setValue('Para apertura de caja chica');
		
		this.cmpEstado = this.getComponente('estado');	
		this.cmpEstado.setValue('abierto');		
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
                   id_depto:this.Cmp.id_depto.getValue(),
				   id_cuenta_bancaria:this.Cmp.id_cuenta_bancaria.getValue(),
				   fecha:this.Cmp.fecha.getValue().dateFormat('d/m/Y'),
				   a_favor:this.Cmp.a_favor.getValue(),
				   detalle:this.Cmp.detalle.getValue(),
				   importe:this.Cmp.importe.getValue(),
				   estado:this.data.estado,
				   id_finalidad:this.Cmp.id_finalidad.getValue(),
				   id_caja:this.data.id_caja
            }   
         return resp;   
     }
    
})    
</script>
