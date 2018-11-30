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
        $height2 = 4;
		$this->Image(dirname(__FILE__).'/../../pxp/lib'.$_SESSION['_DIR_LOGO'], 10, 10, 36);
        $this->Cell(20, $height, '', 0, 0, 'C', false, '', 1, false, 'T', 'C');
								
        $this->SetFontSize(16);
        $this->SetFont('','B'); 
		if($this->getDataSource()->getParameter('estado') == 'impreso y entregado' )
		{	
			$this->Cell(145, $height2, 'CHEQUES EN TRANSITO', 0, 0, 'C', false, '', 1, false, 'T', 'C');
		}else{
			$this->Cell(145, $height2, 'LIBRO DE BANCOS', 0, 0, 'C', false, '', 1, false, 'T', 'C');
		} 
		//var_dump($this->getDataSource()->getParameter('estado')); exit;
        $this->Ln();
		$this->SetFontSize(6);
		$this->Cell(185, $height2, 'Cuenta Corriente Nº '.$this->getDataSource()->getParameter('nro_cuenta'), 0, 0, 'C', false, '', 1, false, 'T', 'C');
		$this->Ln(3.5);
		$this->Cell(185, $height2, 'Del '.$this->getDataSource()->getParameter('fecha_ini'). ' al '.$this->getDataSource()->getParameter('fecha_fin'), 0, 0, 'C', false, '', 1, false, 'T', 'C');
		$this->Ln(3.5);
		$this->Cell(185, $height2, 'Finalidad: '.$this->getDataSource()->getParameter('finalidad'), 0, 0, 'C', false, '', 1, false, 'T', 'C');
		$this->Ln(3.5);
		$this->Cell(185, $height2, 'Tipo: '.$this->getDataSource()->getParameter('tipo'), 0, 0, 'C', false, '', 1, false, 'T', 'C');
		$this->Ln(3.5);
		$this->Cell(185, $height2, 'Estado: '.$this->getDataSource()->getParameter('estado'), 0, 0, 'C', false, '', 1, false, 'T', 'C');
		$this->Ln();
		
		$width1 = 14;
		$width2 = 40;
        $width3 = 59;
		$width4 = 11;
		$width5 = 16;
		$width6 = 51;
		$width7 = 12;
		$width8 = 13;
		$width9 = 32;
		
		$height = 5;
		$blackAll = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
		$this->SetFillColor(224,224,224, true);
        $this->setTextColor(0,0,0);
		
		if($this->getDataSource()->getParameter('estado') != 'Todos' )
		{	
			$this->Cell($width1, $height, 'Fecha', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$this->Cell($width2, $height, 'A Favor', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$this->Cell($width3, $height, 'Detalle', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$this->Cell($width7, $height, 'Nº Liq/Cite', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$this->Cell($width4, $height, 'Nº Com.', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$this->Cell($width8, $height, 'Com. Sigma', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$this->Cell($width4, $height, 'Nº Cheque', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');								
			$this->Cell($width5, $height, 'Debe', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$this->Cell($width5, $height, 'Haber', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
		}else{
			$this->Cell($width1, $height, 'Fecha', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$this->Cell($width9, $height, 'A Favor', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$this->Cell($width6, $height, 'Detalle', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$this->Cell($width7, $height, 'Nº Liq/Cite', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$this->Cell($width4, $height, 'Nº Com.', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$this->Cell($width8, $height, 'Com. Sigma', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$this->Cell($width4, $height, 'Nº Cheque', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');								
			$this->Cell($width5, $height, 'Debe', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$this->Cell($width5, $height, 'Haber', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');
			$this->Cell($width5, $height, 'Saldos', $blackAll, 0, 'C', true, '', 1, false, 'T', 'C');			
		}
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
    			$this->Cell($ancho, 0, 'Usuario: '.$_SESSION['_LOGIN'], '', 0, 'L');
    			$pagenumtxt = 'Página'.' '.$this->getAliasNumPage().' de '.$this->getAliasNbPages();
    			$this->Cell($ancho, 0, $pagenumtxt, '', 0, 'C');
    			//$fecha_rep = date("d-m-Y H:i:s");
				//$nuevafecha = strtotime ( '-10 days' , strtotime ($fecha_rep) ) ;
				//$fecha_rep = date("d-m-Y H:i:s", $nuevafecha);
    			//$this->Cell($ancho, 0, "Fecha impresión: ".$fecha_rep, '', 0, 'R');
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
		
		$this->writeDetalles($this->getDataSource(), $pdf);
        								
        $pdf->Output($fileName, 'F');
    }
    
    function writeDetalles (DataSource $dataSource, TCPDF $pdf) {
    	$blackAll = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
        $widthMarginLeft = 1;
        $width1 = 14;
		$width2 = 40;
        $width3 = 59;
		$width4 = 11;
		$width5 = 16;
		$width6 = 51;
		$width7 = 12;
		$width8 = 13;
		$width9 = 32;

        $pdf->Ln();
        $pdf->SetFontSize(7.5);
        $pdf->SetFont('', 'B');
        //$height = 5;
        $pdf->SetFillColor(224,224,224, true);
        $pdf->setTextColor(0,0,0);
		
        $pdf->Ln();
		$pdf->SetFontSize(6);
		$pdf->SetFont('','');
		
		if($this->getDataSource()->getParameter('estado') != 'Todos' )
		{	
			$pdf->SetFillColor(255,255,255, true);
			$pdf->tablewidths=array($width1,$width2,$width3,$width7,$width4,$width8,$width4,$width5,$width5);
			$pdf->tablealigns=array('L','L','L','C','C','C','C','R','R');
			$pdf->tablenumbers=array(0,0,0,0,0,0,0,0,0);
		}else{
			$pdf->SetFillColor(255,255,255, true);
			$pdf->tablewidths=array($width1,$width9,$width6,$width7,$width4,$width8,$width4,$width5,$width5,$width5);
			$pdf->tablealigns=array('L','L','L','C','C','C','C','R','R','R');
			$pdf->tablenumbers=array(0,0,0,0,0,0,0,0,0,0);
		}
        $saldo_final=0;
		$total_debe=0;
		$total_haber=0;
		$RowArray;
		foreach($dataSource->getDataset() as $row) {
            
			if($this->getDataSource()->getParameter('estado') != 'Todos' )
			{
				$RowArray = array(
							'fecha_reporte'  =>  $row['fecha_reporte'],
							'a_favor'  => $row['a_favor'],
							'detalle'    => $row['detalle'],
							'nro_liquidacion' => $row['nro_liquidacion'],
							'nro_comprobante' => $row['nro_comprobante'],
							'comprobante_sigma' => $row['comprobante_sigma'],
							'nro_cheque' => $row['nro_cheque'],
							'importe_deposito' => number_format($row['importe_deposito'], 2 , '.' , ',' ) ,
							'importe_cheque' => number_format($row['importe_cheque'], 2 , '.' , ',' ) 
						);
			}else{
				$RowArray = array(
							'fecha_reporte'  =>  $row['fecha_reporte'],
							'a_favor'  => $row['a_favor'],
							'detalle'    => $row['detalle'],
							'nro_liquidacion' => $row['nro_liquidacion'],
							'nro_comprobante' => $row['nro_comprobante'],
							'comprobante_sigma' => $row['comprobante_sigma'],
							'nro_cheque' => $row['nro_cheque'],
							'importe_deposito' => number_format($row['importe_deposito'], 2 , '.' , ',' ) ,
							'importe_cheque' => number_format($row['importe_cheque'], 2 , '.' , ',' ) ,
							'saldo' => number_format($row['saldo'] , 2 , '.' , ',' )  
						);
			}
                         
            $pdf-> MultiRow($RowArray, $fill = false, $border = 1) ; 
			$saldo_final= number_format($row['saldo'] , 2 , '.' , ',' )  ;
			$total_debe= number_format($row['total_debe'] , 2 , '.' , ',' )  ;
			$total_haber= number_format($row['total_haber'] , 2 , '.' , ',' )  ;           
        }
		$pdf->SetFont('','B');
		if($this->getDataSource()->getParameter('estado') == 'impreso y entregado' )
		{			
			$pdf->Cell(171,7,'SALDO CHEQUES EN TRANSITO AL '.$this->getDataSource()->getParameter('fecha_fin').'  ' ,0,0,'R'); 
			$pdf->Cell(28, 7, $total_haber, 0, 1, 'L'); 			
		}
		else
		{
			if($this->getDataSource()->getParameter('estado') == 'Todos' )
			{
				$pdf->Cell(171,7,'SALDO AL '.$this->getDataSource()->getParameter('fecha_fin').'  ' ,0,0,'R'); 
				$pdf->Cell(28, 7, $saldo_final, 0, 1, 'L'); 
			}				
			$pdf->Cell(15, 6, 'SALDO DEBE: ', 0, 0, 'L'); 
			$pdf->Cell(25, 6, $total_debe, 0, 1, 'R'); 
			$pdf->Cell(15, 6, 'SALDO HABER: ', 0, 0, 'L'); 
			$pdf->Cell(25, 6, $total_haber, 0, 1, 'R'); 
		}		
    }      
}
?>