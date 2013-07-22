<?php
require_once dirname(__FILE__).'/../../pxp/pxpReport/Report.php';

 class CustomReport extends TCPDF {
    
    private $dataSource;
    
    public function setDataSource(DataSource $dataSource) {
        $this->dataSource = $dataSource;
    }
    
    public function getDataSource() {
        return $this->dataSource;
    }
    
    public function Header() {
    	
        $height = 20;
								$this->Image(dirname(__FILE__).'/../../pxp/lib'.$_SESSION['_DIR_LOGO'], $x+10, $y+10, 36);
        $this->Cell(20, $height, '', 0, 0, 'C', false, '', 1, false, 'T', 'C');
								
        $this->SetFontSize(16);
        $this->SetFont('','B'); 
        $this->Cell(145, $height, 'Solicitud de Pago '. ucfirst($this->getDataSource()->getParameter('estado')) , 0, 0, 'C', false, '', 1, false, 'T', 'C');        
        $this->Ln();
    }
    
    public function Footer() {
        $this->SetFontSize(5);
								$this->setY(-10);
								$ormargins = $this->getOriginalMargins();
								$this->SetTextColor(0, 0, 0);
								//set style for cell border
								$line_width = 0.85 / $this->getScaleFactor();
								$this->SetLineStyle(array('width' => $line_width, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
								$ancho = round(($this->getPageWidth() - $ormargins['left'] - $ormargins['right']) / 3);
								$this->Ln(2);
								$cur_y = $this->GetY();
								//$this->Cell($ancho, 0, 'Generado por XPHS', 'T', 0, 'L');
								$this->Cell($ancho, 0, 'Usuario: '.$_SESSION['_LOGIN'], '', 1, 'L');
								$pagenumtxt = 'Página'.' '.$this->getAliasNumPage().' de '.$this->getAliasNbPages();
								//$this->Cell($ancho, 0, '', '', 0, 'C');
								$fecha_rep = date("d-m-Y H:i:s");
								$this->Cell($ancho, 0, "Fecha impresión: ".$fecha_rep, '', 0, 'L');
								$this->Ln($line_width);
			 }
}

Class RSolicitudPlanPago extends Report {

    function write($fileName) {
        $pdf = new CustomReport('P', PDF_UNIT, "LETTER", true, 'UTF-8', false);
        $pdf->setDataSource($this->getDataSource());
        // set document information
        $pdf->SetCreator(PDF_CREATOR);
        
        // set default monospaced font
        $pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);
        
        //set margins
        $pdf->SetMargins(PDF_MARGIN_LEFT, 40, PDF_MARGIN_RIGHT);
        $pdf->SetHeaderMargin(10);
        $pdf->SetFooterMargin(PDF_MARGIN_FOOTER);
        
        //set auto page breaks
        $pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);
        
        //set image scale factor
        $pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
        
        //set some language-dependent strings
        
        // add a page
        $pdf->AddPage();
        
        $height = 5;
        $width1 = 15;
        $width2 = 25;
        $width3 = 40;
        $width4 = 75;
        
								$white = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(255, 255, 255)));
								$black = array('T' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
								
								$pdf->Cell(185, $height, 'Agradeceremos proceder con la emisión de una Orden de Pago, de acuerdo con la siguiente información:', 0, 1, 'L', false, '', 1, false, 'T', 'C');
								$pdf->Ln();
								$pdf->SetFontSize(8);
								$pdf->SetFont('', 'B');
        $pdf->Cell($width2*2, $height, 'Numero Orden de Compra: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('numero_oc'), 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
        $pdf->SetFont('', 'B');
        $pdf->Cell($width2*2, $height, 'Proveedor: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('proveedor'), 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
        $pdf->SetFont('', 'B');
        $pdf->Cell($width2*2, $height, 'Nº Cuota: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('nro_cuota'), 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
        $pdf->SetFont('', 'B');
        $pdf->Cell($width2*2, $height, 'Fecha de Devengado: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('fecha_devengado'), 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
								$pdf->SetFont('', 'B');
        $pdf->Cell($width2*2, $height, 'Fecha de Pago: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('fecha_pag'), 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
								$pdf->SetFont('', 'B');
        $pdf->Cell($width2*2, $height, 'Forma de Pago: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('forma_pago'), 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
								$pdf->SetFont('', 'B');
        $pdf->Cell($width2*2, $height, 'Tipo de Pago: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('tipo_pago'), 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
								$pdf->SetFont('', 'B');
        $pdf->Cell($width2*2, $height, 'Modalidad: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('modalidad'), 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
								$pdf->Ln();
								$pdf->Cell($width2+$width3, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
								$pdf->SetFont('', 'B');
        $pdf->Cell($width2*2, $height, 'Importe ('.$this->getDataSource()->getParameter('moneda').'):', 0, 0, 'R', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('importe'), 0, 0, 'R', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
								$pdf->Cell($width2+$width3, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
								$pdf->SetFont('', 'B');
        $pdf->Cell($width2*2, $height, 'Monto no Pagado ('.$this->getDataSource()->getParameter('moneda').'):', 0, 0, 'R', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('monto_no_pagado'), 0, 0, 'R', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
								$pdf->Cell($width2+$width3, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
								$pdf->SetFont('', 'B');
        $pdf->Cell($width2*2, $height, 'Otros Descuentos ('.$this->getDataSource()->getParameter('moneda').'):', 0, 0, 'R', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('otros_descuentos'), 0, 0, 'R', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
								$pdf->Cell($width2+$width3, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
								$pdf->SetFont('', 'B');
        $pdf->Cell($width2*2, $height, 'Monto Ejecutado Total ('.$this->getDataSource()->getParameter('moneda').'):', 0, 0, 'R', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('monto_ejecutado_total'), 0, 0, 'R', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
								$pdf->Cell($width2+$width3, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
								$pdf->SetFont('', 'B');
        $pdf->Cell($width2*2, $height, 'Liquido Pagable ('.$this->getDataSource()->getParameter('moneda').'):', 0, 0, 'R', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('liquido_pagable'), 0, 0, 'R', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
								$pdf->Cell($width2+$width3, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
								$pdf->SetFont('', 'B');
        $pdf->Cell($width2*2, $height, 'Total Pagado ('.$this->getDataSource()->getParameter('moneda').'):', 0, 0, 'R', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('total_pagado'), 0, 0, 'R', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
								
								$this->writeDetalles($this->getDataSource(), $pdf,$tipo);
        								
        $pdf->Output($fileName, 'F');
    }
    
    function writeDetalles (DataSource $dataSource, TCPDF $pdf,$tipo) {
        $widthMarginLeft = 1;
        $height = 5;
        $width1 = 15;
        $width2 = 30;
        $width3 = 30;
        $width4 = 75;
        
        $pdf->Ln();
        $pdf->SetFontSize(7.5);
        $pdf->SetFont('', 'B');
        $height = 5;
								$pdf->Ln();
								$pdf->Cell(185, $height, 'DETALLE DE APROBACIÓN', 0, 1, 'C', false, '', 1, false, 'T', 'C');								
								$pdf->Cell(185, $height, '', 'B', 1, 'L', false, '', 1, true, 'T', 'C');
								$pdf->Ln();
								
								$white = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(255, 255, 255)));
								$black = array('T' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
								$pdf->SetFontSize(7);
								$pdf->SetFont('', 'B');
        $pdf->Cell($width2, $height, 'Unidad Organizacional: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->SetFillColor(192,192,192, true);
        $pdf->Cell($width3*2, $height, $this->getDataSource()->getParameter('nombre_uo'), $white, 0, 'L', true, '', 0, false, 'T', 'C');
        $pdf->SetFont('', 'B');
								$pdf->Cell(5, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width2, $height, 'Programa: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
								$pdf->SetFillColor(192,192,192, true);
        $pdf->Cell($width3*2, $height, $this->getDataSource()->getParameter('nombre_programa'), $white, 0, 'L', true, '', 0, false, 'T', 'C');
        $pdf->Ln();
        $pdf->SetFont('', 'B');
        $pdf->Cell($width2, $height, 'Regional: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->SetFillColor(192,192,192, true);
        $pdf->Cell($width3*2, $height, $this->getDataSource()->getParameter('nombre_regional'), $white, 0, 'L', true, '', 0, false, 'T', 'C');
        $pdf->SetFont('', 'B');
								$pdf->Cell(5, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width2, $height, 'Proyecto: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
								$pdf->SetFillColor(192,192,192, true);
        $pdf->Cell($width3*2, $height, $this->getDataSource()->getParameter('nombre_proyecto'), $white, 0, 'L', true, '', 0, false, 'T', 'C');
        $pdf->Ln();
								$pdf->SetFont('', 'B');
        $pdf->Cell($width2, $height, 'Financiador: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->SetFillColor(192,192,192, true);
        $pdf->Cell($width3*2, $height, $this->getDataSource()->getParameter('nombre_financiador'), $white, 0, 'L', true, '', 0, false, 'T', 'C');
        $pdf->SetFont('', 'B');
								$pdf->Cell(5, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width2, $height, 'Actividad: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
								$pdf->SetFillColor(192,192,192, true);
        $pdf->Cell($width3*2, $height, $this->getDataSource()->getParameter('nombre_actividad'), $white, 0, 'L', true, '', 0, false, 'T', 'C');
        $pdf->Ln();
								$pdf->SetFont('', 'B');
        $pdf->Cell($width2, $height, 'Partida: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->SetFillColor(192,192,192, true);
        $pdf->Cell($width3*2, $height, $this->getDataSource()->getParameter('nombre_partida'), $white, 0, 'L', true, '', 0, false, 'T', 'C');
        $pdf->SetFont('', 'B');
								$pdf->Cell(5, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width2, $height, 'Importe: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
								$pdf->SetFillColor(192,192,192, true);
        $pdf->Cell($width3*2, $height, $this->getDataSource()->getParameter('total_pago'), $white, 0, 'L', true, '', 0, false, 'T', 'C');
        $pdf->Ln();				
    }      
}
?>