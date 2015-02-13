<?php
require_once dirname(__FILE__).'/../../pxp/lib/lib_reporte/mypdf.php';
require_once dirname(__FILE__).'/../../pxp/pxpReport/Report.php';

 class CustomReportLibroBancos extends MYPDF {
    
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
		if($this->getDataSource()->getParameter('estado') == 'impreso y entregado' )
		{	
			$this->Cell(145, $height/5, 'CHEQUES EN TRANSITO', 0, 0, 'C', false, '', 1, false, 'T', 'C');        
		}else{
			$this->Cell(145, $height/5, 'LIBRO DE BANCOS', 0, 0, 'C', false, '', 1, false, 'T', 'C');        
		} 
		//var_dump($this->getDataSource()->getParameter('estado')); exit;
        $this->Ln();
		$this->SetFontSize(6);
		$this->Cell(185, $height/5, 'Cuenta Corriente Nº '.$this->getDataSource()->getParameter('nro_cuenta'), 0, 0, 'C', false, '', 1, false, 'T', 'C');
		$this->Ln();
		$this->Cell(185, $height/5, 'Del '.$this->getDataSource()->getParameter('fecha_ini'). ' al '.$this->getDataSource()->getParameter('fecha_fin'), 0, 0, 'C', false, '', 1, false, 'T', 'C');
		$this->Ln();
		$this->Cell(185, $height/5, 'Finalidad: '.$this->getDataSource()->getParameter('finalidad'), 0, 0, 'C', false, '', 1, false, 'T', 'C');
		$this->Ln();
		$this->Cell(185, $height/5, 'Tipo: '.$this->getDataSource()->getParameter('tipo'), 0, 0, 'C', false, '', 1, false, 'T', 'C');
		$this->Ln();
		$this->Cell(185, $height/5, 'Estado: '.$this->getDataSource()->getParameter('estado'), 0, 0, 'C', false, '', 1, false, 'T', 'C');
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

Class RLibroBancos extends Report {

    function write($fileName) {
        $pdf = new CustomReportLibroBancos('P', PDF_UNIT, "LETTER", true, 'UTF-8', false);
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
		
		$this->writeDetalles($this->getDataSource(), $pdf,$tipo);
        								
        $pdf->Output($fileName, 'F');
    }
    
    function writeDetalles (DataSource $dataSource, TCPDF $pdf,$tipo) {
    	$blackAll = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
        $widthMarginLeft = 1;
        $width1 = 15;
		$width2 = 40;
        $width3 = 60;
		$width4 = 11;
		$width5 = 16;
        $pdf->Ln();
        $pdf->SetFontSize(7.5);
        $pdf->SetFont('', 'B');
        $height = 5;
        $pdf->SetFillColor(224,224,224, true);
        $pdf->setTextColor(0,0,0);
		
		if($this->getDataSource()->getParameter('estado') == 'impreso y entregado' )
		{	
			$pdf->Cell($width1, $height, 'Fecha', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$pdf->Cell($width2+4, $height, 'A Favor', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$pdf->Cell($width3+4, $height, 'Detalle', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$pdf->Cell($width4, $height, 'Nº Liq/Cite', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$pdf->Cell($width1, $height, 'Nº Com.', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$pdf->Cell($width4, $height, 'Nº Cheque', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');								
			$pdf->Cell($width1, $height, 'Debe', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$pdf->Cell($width1, $height, 'Haber', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
		}else{
			$pdf->Cell($width1, $height, 'Fecha', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$pdf->Cell($width2, $height, 'A Favor', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$pdf->Cell($width3, $height, 'Detalle', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$pdf->Cell($width4, $height, 'Nº Liq/Cite', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$pdf->Cell($width1, $height, 'Nº Com.', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$pdf->Cell($width4, $height, 'Nº Cheque', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');								
			$pdf->Cell($width1, $height, 'Debe', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$pdf->Cell($width1, $height, 'Haber', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$pdf->Cell($width5, $height, 'Saldos', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');			
		} 
		
        $pdf->Ln();        
		$pdf->SetFontSize(6);
		$pdf->SetFont('','');
		
		if($this->getDataSource()->getParameter('estado') == 'impreso y entregado' )
		{	
			$pdf->SetFillColor(255,255,255, true);
			$pdf->tablewidths=array($width1,$width2+4,$width3+4,$width4,$width1,$width4,$width1,$width1);
			$pdf->tablealigns=array('L','L','L','C','C','C','R','R');
			$pdf->tablenumbers=array(0,0,0,0,0,0,0,0);
		}else{
			$pdf->SetFillColor(255,255,255, true);
			$pdf->tablewidths=array($width1,$width2,$width3,$width4,$width1,$width4,$width1,$width1,$width5);
			$pdf->tablealigns=array('L','L','L','C','C','C','R','R','R');
			$pdf->tablenumbers=array(0,0,0,0,0,0,0,0,0);
		}
        $saldo_final=0;
		$total_debe=0;
		$total_haber=0;
		$RowArray;
		foreach($dataSource->getDataset() as $row) {
            
			if($this->getDataSource()->getParameter('estado') == 'impreso y entregado' )
			{
				$RowArray = array(
							'fecha_reporte'  =>  $row['fecha_reporte'],
							'a_favor'  => $row['a_favor'],
							'detalle'    => $row['detalle'],
							'nro_liquidacion' => $row['nro_liquidacion'],
							'nro_comprobante' => $row['nro_comprobante'],
							'nro_cheque' => $row['nro_cheque'],
							'importe_deposito' => $row['importe_deposito'],
							'importe_cheque' => $row['importe_cheque']
						);
			}else{
				$RowArray = array(
							'fecha_reporte'  =>  $row['fecha_reporte'],
							'a_favor'  => $row['a_favor'],
							'detalle'    => $row['detalle'],
							'nro_liquidacion' => $row['nro_liquidacion'],
							'nro_comprobante' => $row['nro_comprobante'],
							'nro_cheque' => $row['nro_cheque'],
							'importe_deposito' => $row['importe_deposito'],
							'importe_cheque' => $row['importe_cheque'],
							'saldo' => $row['saldo']
						);
			}
                         
            $pdf-> MultiRow($RowArray, $fill = false, $border = 1) ; 
			$saldo_final=$row['saldo'];
			$total_debe=$row['total_debe'];
			$total_haber=$row['total_haber'];           
        }
		$pdf->SetFont('','B');
		if($this->getDataSource()->getParameter('estado') == 'impreso y entregado' )
		{	
			$pdf->Cell(181,7,'SALDO CHEQUES EN TRANSITO AL '.$this->getDataSource()->getParameter('fecha_fin').'  ' ,0,0,'R'); 
			$pdf->Cell(18, 7, $total_haber, 0, 1, 'R'); 
			
		}
		else
		{
			$pdf->Cell(181,7,'SALDO AL '.$this->getDataSource()->getParameter('fecha_fin').'  ' ,0,0,'R'); 
			$pdf->Cell(18, 7, $saldo_final, 0, 1, 'R'); 
						
			$pdf->Cell(15, 6, 'SALDO DEBE: ', 0, 0, 'L'); 
			$pdf->Cell(25, 6, $total_debe, 0, 1, 'R'); 
			$pdf->Cell(15, 6, 'SALDO HABER: ', 0, 0, 'L'); 
			$pdf->Cell(25, 6, $total_haber, 0, 1, 'R'); 
		}		
    }      
}
?>