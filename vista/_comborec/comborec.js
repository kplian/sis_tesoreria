Ext.namespace('Phx','Phx.comborec.sis_presupuestos');		

Phx.comborec.sis_presupuestos.configini = function (config){
	
	if (config.origen == 'PARTIDA') {
		return {
			 origen: 'PARTIDA',
			 tinit:false,
			 tasignacion:true,
			 tname:'id_partida',
			 tdisplayField:'nombre_partida',
			 pid:this.idContenedor,
			 name:'id_partida',
 				fieldLabel:'Partida',
 				allowBlank:true,
 				emptyText:'Partida...',
				store: new Ext.data.JsonStore({
						 url: '../../sis_presupuestos/control/Partida/listarPartida',
						 id: 'id_partida',
						 root: 'datos',
						 sortInfo:{
							field: 'nombre_partida',
							direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_partida','codigo','nombre_partida'],
					// turn on remote sorting
					remoteSort: true,
					baseParams:{par_filtro:'codigo#nombre_partida',sw_transaccional:'movimiento'}
					}),
				valueField: 'id_partida',
 				displayField: 'nombre_partida',
 				hiddenName: 'id_partida',
				tpl:'<tpl for="."><div class="x-combo-list-item"><p>{codigo}</p><p>Nombre:{nombre_partida}</p> </div></tpl>',
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
		}
		
	}
	
}
	    		

	    