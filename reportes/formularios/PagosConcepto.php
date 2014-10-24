<?php
/**
 *@package pXP
 *@file    GenerarReporteExistencias.php
 *@author  Ariel Ayaviri Omonte
 *@date    02-05-2013
 *@description Archivo con la interfaz para generación de reporte
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
	Phx.vista.PagosConcepto = Ext.extend(Phx.frmInterfaz, {
		Atributos : [
		{
            config:{
                name:'id_concepto_ingas',
                fieldLabel:'Concepto Ingreso Gasto',
                allowBlank:true,
                emptyText:'Concepto Ingreso Gasto...',
                store: new Ext.data.JsonStore({
                         url: '../../sis_parametros/control/ConceptoIngas/listarConceptoIngasMasPartida',
                         id: 'id_concepto_ingas',
                         root: 'datos',
                         sortInfo:{
                            field: 'desc_ingas',
                            direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_concepto_ingas','tipo','desc_ingas','movimiento','desc_partida','id_grupo_ots','filtro_ot','requiere_ot'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams:{par_filtro:'desc_ingas#par.codigo#par.nombre_partida',movimiento:'gasto'}
                    }),
                valueField: 'id_concepto_ingas',
                displayField: 'desc_ingas',
                tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{desc_ingas}</b></p><p>TIPO:{tipo}</p><p>MOVIMIENTO:{movimiento}</p> <p>PARTIDA:{desc_partida}</p></div></tpl>',
                hiddenName: 'id_concepto_ingas',
                forceSelection:true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:10,
                queryDelay:1000,
                listWidth:600,
                resizable:true,
                anchor:'100%'
                
            },
            type:'ComboBox',
            id_grupo:0,
            filters:{   
                        pfiltro:'cig.movimiento#cig.desc_ingas',
                        type:'string'
                    },
            grid:true,
            form:true
        },
		{
	   			config:{
	   				name : 'id_gestion',
	   				origen : 'GESTION',
	   				fieldLabel : 'Gestion',
	   				allowBlank : false,
	   				gdisplayField : 'gestion',//mapea al store del grid
	   				gwidth : 100,
		   			renderer : function (value, p, record){return String.format('{0}', record.data['gestion']);}
	       	     },
	   			type : 'ComboRec',
	   			id_grupo : 0,
	   			filters : {	
			        pfiltro : 'ges.gestion',
					type : 'numeric'
				},
	   		   
	   			grid : false,
	   			form : true
	   	},],
		title : 'Generar Reporte de Pagos X Fechas',		
		topBar : true,
		botones : false,
		labelSubmit : 'Imprimir',
		tooltipSubmit : '<b>Generar Reporte de Existencias</b>',

		constructor : function(config) {
			Phx.vista.PagosConcepto.superclass.constructor.call(this, config);
			this.init();			
			
			
			
		},
		tipo : 'reporte',
		clsSubmit : 'bprint',
		onSubmit: function(){
			if (this.form.getForm().isValid()) {
				var data={};
				
				data.id_gestion=this.getComponente('id_gestion').getValue();
				data.concepto=this.getComponente('id_concepto_ingas').getRawValue();
				data.gestion=this.getComponente('id_gestion').getRawValue();				
				data.id_concepto=this.getComponente('id_concepto_ingas').getValue();
				
				
				Phx.CP.loadWindows('../../../sis_tesoreria/reportes/grillas/PagosConceptoVista.php', 'Kardex por Item: '+this.desc_item, {
						width : '90%',
						height : '80%'
					}, data	, this.idContenedor, 'PagosConceptoVista')
			}
		},
		Grupos : [{
			layout : 'column',
			items : [{
				xtype : 'fieldset',
				layout : 'form',
				border : true,
				title : 'Generar Reporte',
				bodyStyle : 'padding:0 10px 0;',
				columnWidth : '500px',
				items : [],
				id_grupo : 0,
				collapsible : true
			}]
		}]
		
		

})
</script>