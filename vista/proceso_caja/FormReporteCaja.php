<?php

/*
 ISSUE      FORK         FECHA:		         AUTOR                              DESCRIPCION
 #20     endeETR      01/02/2019         MANUEL GUERRA        			agregacion del combo gestion  
*/ 
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
				valueField: 'id_caja',
				anchor: '80%',
				gwidth: 50	
			},
			type:'ComboBox',
			form:false,		
		},{
			config:{
				name : 'id_gestion',
				origen : 'GESTION',
				fieldLabel : 'Gestion',
				gdisplayField: 'desc_gestion',
				allowBlank : false,
				width: 150
			},
			type : 'ComboRec',
			id_grupo : 0,
			form : true
		},{
			config:{
				name:'mes',
				fieldLabel:'Mes',
				typeAhead: true,
				triggerAction: 'all',
				lazyRender:true,
				mode: 'local',
				allowBlank : false,
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
			id_gestion:this.Cmp.id_gestion.getValue(),
			id_caja:caja
		}
		return resp;
	}

})
</script>
