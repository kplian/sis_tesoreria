<?php
// Extend the TCPDF class to create custom MultiRow
/**
 *	ISSUE   FORK	     Fecha 		     Autor		 Descripcion	
 *  #41     ENDETR       16/12/2019      JUAN        Reporte de información de pago
* * */
class RInfPago extends ReportePDF {//#41
	var $cabecera;
	var $datos;	
	function datosHeader ($getCertPre) {
	
		$this->datos =$getCertPre->getParameter('cabecera');

		$this->ancho_hoja = $this->getPageWidth() - PDF_MARGIN_LEFT - PDF_MARGIN_RIGHT-10;
		
		$this->dato_CertPre = $getCertPre;
			
		$this->SetMargins(15, 17, 15,15);
	}
	
	function Header() {	#41		
	}

	function generarReporte() {	#41
		$this->AddPage();		
		$dataSource = $this->datos_detalle; 
		
		ob_start();
		include(dirname(__FILE__).'/../reportes/tpl/tplInfPago.php');
		$content = ob_get_clean();
		$this->writeHTML($content, false, false, false, false, '');		
	}
	
	function Footer() {#41
	    $this->setY(-15);
		$ormargins = $this->getOriginalMargins();
		$this->SetTextColor(0, 0, 0);
		//set style for cell border
		$line_width = 0.85 / $this->getScaleFactor();
		$this->SetLineStyle(array('width' => $line_width, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
		$ancho = round(($this->getPageWidth() - $ormargins['left'] - $ormargins['right']) / 3);
		$this->Ln(2);
		$cur_y = $this->GetY();
		$this->Cell($ancho, 0, 'Usuario: '.$_SESSION['_LOGIN'], '', 0, 'L');
		$pagenumtxt = 'Página'.' '.$this->getAliasNumPage().' de '.$this->getAliasNbPages();
		$this->Cell($ancho, 0, $pagenumtxt, '', 0, 'C');
		$this->Cell($ancho, 0, $_SESSION['_REP_NOMBRE_SISTEMA'], '', 0, 'R');
		$this->Ln();
		$fecha_rep = date("d-m-Y H:i:s");
		$this->Cell($ancho, 0, "Fecha Impresion : ".$fecha_rep, '', 0, 'L');
		$this->Ln($line_width);
		$this->Ln();
		$barcode = $this->getBarcode();
		$style = array(
					'position' => $this->rtl?'R':'L',
					'align' => $this->rtl?'R':'L',
					'stretch' => false,
					'fitwidth' => true,
					'cellfitalign' => '',
					'border' => false,
					'padding' => 0,
					'fgcolor' => array(0,0,0),
					'bgcolor' => false,
					'text' => false,
					'position' => 'R'
				);
		$this->write1DBarcode($barcode, 'C128B', $ancho*2, $cur_y + $line_width+5, '', (($this->getFooterMargin() / 3) - $line_width), 0.3, $style, '');
	}

}
?>