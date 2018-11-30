<?php

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
var caja=null;
Phx.vista.FormReporteCaja=Ext.extend(Phx.frmInterfaz,{
		
	layout:'fit',
	constructor:function(config){
		Phx.vista.FormReporteCaja.superclass.constructor.call(this,config);
		this.init(); 
		this.iniciarEventos();		
		this.loadValoresIniciales();
		caja=this.data.id_caja;
	},

	Atributos:[
		{
			config:{
				name: 'id_caja',
				fieldLabel: 'Caja',
				allowBlank: true,
				valueField: 'id_caja',
				anchor: '80%',
				gwidth: 50	
			},
			type:'ComboBox',
			form:false,		
		},{
			config:{
				name:'mes',
				fieldLabel:'Mes',
				typeAhead: true,
				triggerAction: 'all',
				lazyRender:true,
				mode: 'local',
				//valueField: 'mes',
				gwidth: 15,
				store:new Ext.data.ArrayStore({
					fields: ['variable', 'valor'],
					data : 
					[ 
						['1','Enero'],
						['2','Febrero'],
						['3','Marzo'],
						['4','Abril'],						
						['5','Mayo'],
						['6','Junio'],
						['7','Julio'],
						['8','Agosto'],
						['9','Septiembre'],
						['10','Octubre'],
						['11','Noviembre'],
						['12','Diciembre']
					]
				}),
				valueField: 'variable',
				displayField: 'valor',
				listeners: {
					'afterrender': function(combo){			  
						combo.setValue('2');
					}
				}
			},
			type:'ComboBox',
			form:true
		}
	],

	title:'Filtro',
	onSubmit:function(){
		//TODO passar los datos obtenidos del wizard y pasar  el evento save		
		if (this.form.getForm().isValid()) {
			this.fireEvent('beforesave',this,this.getValues());
			this.getValues();
		}
	},
		
	getValues:function(){				
		var resp = {			
			mes:this.Cmp.mes.getValue(),
			id_caja:caja
		}
		return resp;
	}

})
</script>
