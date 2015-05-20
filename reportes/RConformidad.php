<?php
require_once dirname(__FILE__).'/../../pxp/lib/lib_reporte/ReportePDFFormulario.php';
// Extend the TCPDF class to create custom MultiRow
class RConformidad extends  ReportePDFFormulario {
	var $datos_titulo;
	var $datos_detalle;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	function Header() {
		$this->ln(25);
		$height = 20; 
		//cabecera del reporte
		$this->Cell(40, $height, '', 0, 0, 'C', false, '', 0, false, 'T', 'C');
        $this->SetFontSize(16);
        $this->SetFont('','B');        
        $this->Cell(105, $height, 'ACTA DE CONFORMIDAD', 0, 0, 'C', false, '', 0, false, 'T', 'C');								
		$x=$this->getX();
		$y=$this->getY();
		$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], $x, $y, 36);
		//$this->firmar();
	}
	
	function generarActa($maestro) {
		
		$nombre_solicitante = $maestro[0]['nombre_solicitante'];	
		$proveedor = $maestro[0]['proveedor'];
		$fecha_conformidad = $maestro[0]['fecha_conformidad'];
		$conformidad = $maestro[0]['conformidad'];
		$numero_oc = $maestro[0]['numero_oc'];	
		$numero_op = $maestro[0]['numero_op'];	
		$numero_cuota = $maestro[0]['numero_cuota'];
		$numero_tramite = $maestro[0]['numero_tramite'];
		$detalle = $maestro[0]['detalle'];
		$tipo = str_replace(',', '/', $maestro[0]['tipo']);
		
		$this->firma['datos_documento']['numero_tramite'] = $numero_tramite;
		$this->firma['datos_documento']['solicitante'] = $nombre_solicitante;
		$this->firma['datos_documento']['proveedor'] = $proveedor;
		$this->firma['datos_documento']['numero_cuota'] = $numero_cuota;
		$this->firma['datos_documento']['fecha_conformidad'] = $fecha_conformidad;
		$this->firma['datos_documento']['conformidad'] = $conformidad;
		
		
				
		$this->AddPage();
		$url_firma = $this->crearFirma2();
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
            	<td><b>Número de Trámite : </b><br><br>$numero_tramite</td> 
        	</tr>
        	
        	<tr>
            	<td> <b>Nro OC/Contrato</b> : $numero_oc<br> <b>Nro Obligación Pago : </b>$numero_op</td> 
                <td><b> Fecha de Conformidad : </b>$fecha_conformidad</td> 
        	</tr>
        	<tr>
            	<td> <b>Nro de Cuota :</b> $numero_cuota</td> 
                <td><b> Proveedor: </b>$proveedor</td> 
        	</tr>
        	<tr>
            	<td align="justify"  colspan="2">En cumplimiento al Reglamento Específico de las Normas Básicas del Sistema de Administración de Bienes y Servicios de la Empresa,  doy conformidad del $tipo, solicitado. 
            	<br><br>
            	<table border="0">$detalle</table><br><br>
            	El mismo cumple con las características y condiciones requeridas, en calidad y cantidad. La cuál fue adquirida considerando criterios de economía para la obtención de los mejores precios del mercado.<br><br><b>**Nota : $conformidad </b><br><br>En conformidad de lo anteriormente mencionado firmo a continuación:</td>
        	</tr>
        	<tr>
            	<td align="center"  colspan="2">   <br><br>
            	<img  style="width: 150px;" src="$url_firma" alt="Logo">
            	<br><br>$nombre_solicitante</td>
        	</tr>
    	</table>
    	</body>
EOF;
		$this->writeHTMLCell (175,30,20,70,$html);		
		return $this->firma;
			
	}
	
    
}
?>