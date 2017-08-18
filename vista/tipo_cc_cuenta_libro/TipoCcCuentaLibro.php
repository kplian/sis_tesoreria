<?php
/**
*@package pXP
*@file gen-TipoCcCuentaLibro.php
*@author  (admin)
*@date 18-08-2017 14:06:50
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.TipoCcCuentaLibro=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.TipoCcCuentaLibro.superclass.constructor.call(this,config);
		this.init();
		var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
        if(dataPadre){
            this.onEnablePanel(this, dataPadre);
        }
        else
        {
           this.bloquearMenus();
        }
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_ttipo_cc_cuenta_libro'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_depto'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_cuenta_bancaria'
			},
			type:'Field',
			form:true 
		},
		
		{
	   		config:{
	   				name:'id_tipo_cc',
	   				qtip: 'Tipo de centro de costos, cada tipo solo puede tener un centro por gestión',	 
	   				url: '../../sis_parametros/control/TipoCc/listarTipoCcAll',  				
	   				origen:'TIPOCC',
	   				fieldLabel:'Tipo Centro',
	   				gdisplayField: 'desc_tcc',	   				
	   				allowBlank:false,
	   				width:250,
	   				gwidth:400,
	   				baseParams:{control_techo:'si'},
	   				renderer:function (value, p, record){return String.format('{0}', record.data['desc_tcc']);}
	   				
	      		},
   			type:'ComboRec',
   			id_grupo:0,
   			filters:{pfiltro:'cec.codigo_tcc#cec.descripcion_tcc',type:'string'},
   		    grid:true,
   			form:true
	    },
	    {
			config:{
				name: 'obs',
				fieldLabel: 'obs',
				allowBlank: true,
				anchor: '80%',
				gwidth: 400,
				maxLength:500
			},
				type:'TextArea',
				filters:{pfiltro:'tcl.obs',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		}
		
		
	],
	tam_pag:50,	
	title:'Configuracion',
	ActSave:'../../sis_tesoreria/control/TipoCcCuentaLibro/insertarTipoCcCuentaLibro',
	ActDel:'../../sis_tesoreria/control/TipoCcCuentaLibro/eliminarTipoCcCuentaLibro',
	ActList:'../../sis_tesoreria/control/TipoCcCuentaLibro/listarTipoCcCuentaLibro',
	id_store:'id_ttipo_cc_cuenta_libro',
	fields: [
		{name:'id_ttipo_cc_cuenta_libro', type: 'numeric'},
		{name:'obs', type: 'string'},
		{name:'id_tipo_cc', type: 'numeric'},
		{name:'id_depto', type: 'numeric'},
		{name:'id_cuenta_bancaria', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'desc_tcc'
		
	],
	
	onReloadPage:function(m){
		this.maestro=m;
		this.id_depto_lb = Phx.CP.getPagina(this.idContenedorPadre).cmbDepto.getValue();
		
		
        this.store.baseParams={id_cuenta_bancaria: this.maestro.id_cuenta_bancaria, id_depto: this.id_depto_lb};
        this.load({params:{start:0, limit:50}})
    },
    loadValoresIniciales:function()
    {
        Phx.vista.TipoCcCuentaLibro.superclass.loadValoresIniciales.call(this);
        this.Cmp.id_cuenta_bancaria.setValue(this.maestro.id_cuenta_bancaria); 
        this.Cmp.id_depto.setValue(this.id_depto_lb);   
    },
	
	sortInfo:{
		field: 'id_ttipo_cc_cuenta_libro',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true
	}
)
</script>