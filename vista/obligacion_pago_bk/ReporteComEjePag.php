<?php
/**
*@package pXP
*@file ReporteObligacionComEjePag.php
*@author  Gonzalo Sarmiento Sejas
*@date    02-01-2013
*@description Archivo con la interfaz para generación de reporte
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ReporteComEjePag=Ext.extend(Phx.frmInterfaz,{
    Atributos:[                  
        {
            config:{
                name:'id_moneda',
                origen:'MONEDA',
                 allowBlank:false,
                fieldLabel:'Moneda',
                gdisplayField:'desc_moneda',//mapea al store del grid
                gwidth:50,
                 renderer:function (value, p, record){return String.format('{0}', record.data['desc_moneda']);}
             },
            type:'ComboRec',
            id_grupo:1,
            filters:{   
                pfiltro:'mon.codigo',
                type:'string'
            },
            grid:true,
            form:true
          },
		        {
		          config:{
		                    labelSeparator:'',
		                    inputType:'hidden',
		                    name: 'id_obligacion_pago'
		            },
		            type:'Field',
		            form:true 
		        }        
    ],
    title:'Reporte Comp Ejec Pag',
    ActSave:'../../sis_tesoreria/control/ObligacionPago/reporteComEjePag',
    topBar:true,
    botones:false,
    labelSubmit:'Imprimir',
    tooltipSubmit:'<b>Reporte Comp Ejec Pag</b>',    
    
    constructor: function(config){
        Phx.vista.ReporteComEjePag.superclass.constructor.call(this,config);
        this.init();           
        this.getComponente('id_obligacion_pago').setValue(this.id_obligacion_pago);
    },
    
    loadValoresIniciales:function(){       
        this.getComponente('id_obligacion_pago').setValue(this.id_obligacion_pago);
    },
    tipo:'reporte',
    clsSubmit:'bprint'
    
})
</script>