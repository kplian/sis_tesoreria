<?php
// Extend the TCPDF class to create custom MultiRow
class RConformidad extends  ReportePDF {
	var $datos_titulo;
	var $datos_detalle;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	function Header() {
		//cabecera del reporte
		$this->Image(dirname(__FILE__).'/../../lib/imagenes/logos/logo.jpg', 70, 2, 67, 37);
		$this->SetFont('','B',12);
		$this->Ln(30);
		$this->Cell(175,30,'ACTA DE CONFORMIDAD',0,1,'C');
		$this->Ln(10);
	}
	
	function generarReporte($maestro) {
		
		$nombre_solicitante = $maestro[0]['nombre_solicitante'];	
		$proveedor = $maestro[0]['proveedor'];
		$fecha_conformidad = $maestro[0]['fecha_conformidad'];
		$conformidad = $maestro[0]['conformidad'];
		$numero_oc = $maestro[0]['numero_oc'];	
		$numero_op = $maestro[0]['numero_op'];	
		$numero_cuota = $maestro[0]['numero_cuota'];	
				
		$this->AddPage();
		/*Se requiere obtener nombre_solicitante, fecha_conformidad,factura, proveedor,conformidad,numero_oc,numero_op, numero_cuota*/
		$html = <<<EOF
		<style>
		table, th, td {
   			border: 1px solid black;
   			border-collapse: collapse; 
   			font-family: "Times New Roman";
   			font-size: 11pt;
		}
		</style>
		<body>
		<table border="1">
        	<tr>
            	<td><b>Responsable del  Proceso :</b><br><br>$nombre_solicitante</td> 
            	<td><b>Fecha de Entrega/Informe : </b><br><br>$fecha_conformidad</td> 
        	</tr>
        	
        	<tr>
            	<td> <b>Nro OC/Contrato</b> : $numero_oc<br> <b>Nro Obligación Pago : </b>$numero_op</td> 
                <td><b> Nro Cuota : </b>$numero_cuota</td> 
        	</tr>
        	<tr>
            	<td> <b>Pagado con cheque Nº: ---------<br> Factura:</b></td> 
                <td><b> Proveedor: </b>$proveedor</td> 
        	</tr>
        	<tr>
            	<td align="justify"  colspan="2">En cumplimiento al Reglamento Específico de las Normas Básicas del Sistema de Administración de Bienes y Servicios de la Empresa,  doy conformidad del bien o servicio, solicitado, el mismo cumple con las características y condiciones requeridas, en calidad y cantidad. La cuál fue adquirida considerando criterios de economía para la obtención de los mejores precios del mercado.<br><br><b>**Nota : $conformidad </b><br><br>En conformidad de lo anteriormente mencionado firmo a continuación:</td>
        	</tr>
        	<tr>
            	<td align="center"  colspan="2"><b>Nombre completo y firma del solicitante:</b><br><br><br><br>$nombre_solicitante</td>
        	</tr>
    	</table>
    	</body>
EOF;
		$this->writeHTMLCell (175,30,20,70,$html);		
			
	}
	
    
}
?>