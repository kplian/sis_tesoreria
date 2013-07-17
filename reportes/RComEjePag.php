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
        $this->Cell(145, $height, 'Reporte ...', 0, 0, 'C', false, '', 1, false, 'T', 'C');        
        
								$x=$this->getX();
								$y=$this->getY();
								$this->setXY($x,$y-4);
								$this->SetFontSize(8);
								$this->SetFont('', 'B');
								$this->Cell(20, $height, $this->getDataSource()->getParameter('numero'), 0, 0, 'L', false, '', 1, false, 'T', 'C');
								
								
								$this->setXY($x,$y+8);
								$this->setFont('','');
								$this->Cell(6, $height/5, 'Dia', 1, 0, 'L', false, '', 1, false, 'T', 'C');
								$this->Cell(6, $height/5, 'Mes', 1, 0, 'L', false, '', 1, false, 'T', 'C');
								$this->Cell(7, $height/5, 'Año', 1, 0, 'L', false, '', 1, false, 'T', 'C');
								$this->setXY($x,$y+12);
								$fecha = explode('-', $this->getDataSource()->getParameter('fecha'));
								$this->Cell(6, $height/4, $fecha[2], 1, 0, 'C', false, '', 1, false, 'T', 'C');
								$this->Cell(6, $height/4, $fecha[1], 1, 0, 'C', false, '', 1, false, 'T', 'C');
								$this->Cell(7, $height/4, $fecha[0], 1, 0, 'C', false, '', 1, false, 'T', 'C');
								$this->Ln();
								
								$this->Cell(185, $height/5, 'Expresado en '.$this->getDataSource()->getParameter('moneda'), 0, 0, 'C', false, '', 1, false, 'T', 'C');
								$this->Ln();
								$this->Cell(185, $height/5, 'Tipo de Cambio '.$this->getDataSource()->getParameter('tipo_cambio_conv'), 0, 0, 'C', false, '', 1, false, 'T', 'C');
								$this->Ln();    
								$this->Cell(185, $height/5, 'Pago Variable '.$this->getDataSource()->getParameter('pago_variable'), 0, 0, 'C', false, '', 1, false, 'T', 'C');
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

Class RComEjePag extends Report {

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
        $width3 = 32.5;
        $width4 = 75;
        
								$white = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(255, 255, 255)));
								$black = array('T' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
								$pdf->SetFontSize(8);
								$pdf->SetFont('', 'B');
        $pdf->Cell($width2, $height, 'Numero Tramite: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->SetFillColor(192,192,192, true);
        $pdf->Cell($width3*2, $height, $this->getDataSource()->getParameter('num_tramite'), $white, 0, 'L', true, '', 0, false, 'T', 'C');
        $pdf->SetFont('', 'B');
								$pdf->Cell(5, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width2, $height, 'Tipo Obligacion: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
								$pdf->SetFillColor(192,192,192, true);
        $pdf->Cell($width3*2, $height, $this->getDataSource()->getParameter('tipo_obligacion'), $white, 0, 'L', true, '', 0, false, 'T', 'C');
        $pdf->Ln();
        $pdf->SetFont('', 'B');
        $pdf->Cell($width2, $height, 'Comprometido: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->SetFillColor(192,192,192, true);
        $pdf->Cell($width3*2, $height, $this->getDataSource()->getParameter('comprometido'), $white, 0, 'L', true, '', 0, false, 'T', 'C');
        $pdf->SetFont('', 'B');
								$pdf->Cell(5, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width2, $height, 'Estado: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
								$pdf->SetFillColor(192,192,192, true);
        $pdf->Cell($width3*2, $height, $this->getDataSource()->getParameter('estado'), $white, 0, 'L', true, '', 0, false, 'T', 'C');
        $pdf->Ln();
        $pdf->SetFont('', 'B');
        $pdf->Cell($width2, $height, 'Porc. Retgar: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->SetFillColor(192,192,192, true);
        $pdf->Cell($width3*2, $height, $this->getDataSource()->getParameter('porc_retgar'), $white, 0, 'L', true, '', 0, false, 'T', 'C');
        $pdf->SetFont('', 'B');
								$pdf->Cell(5, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width2, $height, 'Porc. Anticipo: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
								$pdf->SetFillColor(192,192,192, true);
        $pdf->Cell($width3*2, $height, $this->getDataSource()->getParameter('porc_anticipo'), $white, 0, 'L', true, '', 0, false, 'T', 'C');
        $pdf->Ln();
        $pdf->SetFont('', 'B');
        $pdf->Cell($width2, $height, 'Subsistema: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->SetFillColor(192,192,192, true);
        $pdf->Cell($width3*2, $height, $this->getDataSource()->getParameter('nombre_subsistema'), $white, 0, 'L', true, '', 0, false, 'T', 'C');
        $pdf->SetFont('', 'B');
								$pdf->Cell(5, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width2, $height, 'Departamento: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
								$pdf->SetFillColor(192,192,192, true);
        $pdf->Cell($width3*2, $height, $this->getDataSource()->getParameter('nombre_depto'), $white, 0, 'L', true, '', 0, false, 'T', 'C');
        $pdf->Ln();
								$pdf->SetFont('', 'B');
        $pdf->Cell($width2, $height, 'Proveedor: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->SetFillColor(192,192,192, true);
        $pdf->Cell($width3*2, $height, $this->getDataSource()->getParameter('desc_proveedor'), $white, 0, 'L', true, '', 0, false, 'T', 'C');
        $pdf->Ln();
        $pdf->SetFont('', 'B');
        $pdf->Cell($width2, $height, 'Obs: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->SetFillColor(192,192,192, true);
        $pdf->MultiCell(0, $height, $this->getDataSource()->getParameter('obs'), 1,'L', true ,1);
								$pdf->Ln();
								$this->writeDetalles($this->getDataSource(), $pdf,$tipo);
        								
        $pdf->Output($fileName, 'F');
    }
    
    function writeDetalles (DataSource $dataSource, TCPDF $pdf,$tipo) {
    				$blackAll = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
        $widthMarginLeft = 1;
        $width1 = 15;
								$width2 = 30;
        $width3 = 80;
        $pdf->Ln();
        $pdf->SetFontSize(7.5);
        $pdf->SetFont('', 'B');
        $height = 5;
        $pdf->SetFillColor(255,255,255, true);
        $pdf->setTextColor(0,0,0);
								
								$pdf->Cell($width2, $height, 'Centro de Costo', $blackAll, 0, 'l', true, '', 1, false, 'T', 'C');
								$pdf->Cell($width2, $height, 'Partida', $blackAll, 0, 'L', true, '', 1, false, 'T', 'C');
        $pdf->Cell($width3, $height, 'Concepto Ingreso Gasto', $blackAll, 0, 'L', true, '', 1, false, 'T', 'C');
        $pdf->Cell($width1, $height, 'Comprometido', $blackAll, 0, 'L', true, '', 1, false, 'T', 'C');
        $pdf->Cell($width1, $height, 'Ejecutado', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
        $pdf->Cell($width1, $height, 'Pagado', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
        
        $pdf->Ln();
        $pdf->SetFontSize(7);
        foreach($dataSource->getDataset() as $row) {
        				$pdf->SetFont('', '');												
												$xAntesMultiCell = $pdf->getX();
												$yAntesMultiCell = $pdf->getY();												
            //$totalItem
            $pdf->setX($xAntesMultiCell+$width2*2);
            $pdf->MultiCell($width3, $height, $row['nombre_ingas']."\r\n".'  - '.$row['descripcion'], 1,'L', false ,1);
												$yDespuesMultiCell= $pdf->getY();
												$height = $yDespuesMultiCell-$yAntesMultiCell;
												$pdf->setXY($xAntesMultiCell,$yAntesMultiCell);	
            $pdf->MultiCell($width2, $height, $row['codigo_cc'], 1,'L', false ,0);
            $pdf->MultiCell($width2, $height, $row['nombre_partida'], 1,'L', false ,0);
												$pdf->setX($xAntesMultiCell+$width2*2+$width3);
            $pdf->Cell($width1, $height, $row['comprometido'], $blackAll, 0, 'L', true, '', 1, false, 'T', 'C');
				        $pdf->Cell($width1, $height, $row['ejecutado'], $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
				        $pdf->Cell($width1, $height, $row['pagado'], $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
												$pdf->Ln();
        }        									
    }      
}
?>