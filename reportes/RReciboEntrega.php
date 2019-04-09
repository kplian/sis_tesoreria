<?php
require_once dirname(__FILE__).'/../../pxp/lib/lib_reporte/ReportePDFFormulario.php';
require_once dirname(__FILE__).'/../../pxp/pxpReport/Report.php';
 class CustomReporte extends ReportePDFFormulario{
    
    private $dataSource;
    
    public function setDataSource(DataSource $dataSource) {
        $this->dataSource = $dataSource;
    }
    
    public function getDataSource() {
        return $this->dataSource;
    }
    
    public function Header() {
		
		$x= $this->getX();
		$y= $this->getY();
        $height = 20;
		$this->Image(dirname(__FILE__).'/../../pxp/lib'.$_SESSION['_DIR_LOGO'], $x, $y+10, 36);
		$this->Cell(20, $height, '', 0, 0, 'C', false, '', 0, false, 'T', 'C');
		
		$this->SetFont('','B');  
		if($this->getDataSource()->getParameter('codigo_proc') == 'INGEFE' ){
			$this->Cell(145, $height, 'RECIBO DE INGRESO DE CAJA', 0, 0, 'C', false, '', 1, false, 'T', 'C');
		}   
		else{
			$this->Cell(145, $height, 'RECIBO DE ENTREGA EN CAJA', 0, 0, 'C', false, '', 1, false, 'T', 'C');
		}   
        								
		$this->SetFontSize(14);
		
		$x=$this->getX();
		$y=$this->getY();
		$this->setXY($x-10,$y+5);
		$this->SetFontSize(8);
		$this->SetFont('', 'B');
		//$this->Cell(30, $height, $this->getDataSource()->getParameter('nro_tramite'), 0, 0, 'L', false, '', 1, false, 'T', 'C');		
    }  
    
}

Class RReciboEntrega extends Report {
	var $objParam;
	function __construct(CTParametro $objParam) {
		$this->objParam = $objParam;
	}
    function write() {
    	
        $this->pdf = new CustomReporte($this->objParam);
        $this->pdf->setDataSource($this->getDataSource());
        // set document information
        $this->pdf->SetCreator(PDF_CREATOR);
        
        // set default monospaced font
        $this->pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);
        
        //set margins
        $this->pdf->SetMargins(PDF_MARGIN_LEFT, 40, PDF_MARGIN_RIGHT);
        $this->pdf->SetHeaderMargin(10);
        $this->pdf->SetFooterMargin(PDF_MARGIN_FOOTER);
        
        //set auto page breaks
        $this->pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);
        
        //set image scale factor
        $this->pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
        
		// add a page
        $this->pdf->AddPage();
        
        $height = 5;
        $width1 = 15;
        $width2 = 40;
        $width3 = 62;
        $width4 = 146;
        
        $this->pdf->SetFontSize(8.5);		
        $this->pdf->setTextColor(0,0,0);

        $this->pdf->SetFont('', 'B');       
        $this->pdf->Cell($width3, $height, 'FECHA ENTREGA', 1, 0, 'C', false, '', 0, false, 'T', 'C');
        $this->pdf->Cell($width3, $height, 'MONEDA', 1, 0, 'C', false, '', 0, false, 'T', 'C');
        $this->pdf->Cell($width3, $height, 'NRO TRAMITE', 1, 1, 'C', false, '', 0, false, 'T', 'C');     
        $this->pdf->SetFont('', '');        
        $this->pdf->Cell($width3, $height, $this->getDataSource()->getParameter('fecha_entrega'), 1, 0, 'C', false, '', 0, false, 'T', 'C');
        $this->pdf->Cell($width3, $height, $this->getDataSource()->getParameter('moneda'), 1, 0, 'C', false, '', 0, false, 'T', 'C');
        $this->pdf->Cell($width3, $height, $this->getDataSource()->getParameter('nro_tramite'), 1, 1, 'C', false, '', 0, false, 'T', 'C');
		$this->pdf->Ln();
		
		$this->pdf->SetFont('', 'B');
        $this->pdf->Cell($width2, $height, 'CAJA: ', 1, 0, 'L', false, '', 0, false, 'T', 'C');
		
		$this->pdf->SetFont('', '');      		
        $this->pdf->Cell($width4, $height, $this->getDataSource()->getParameter('codigo'), 1, 1, 'L', false, '', 0, false, 'T', 'C');
		
		$this->pdf->SetFont('', 'B');
        $this->pdf->Cell($width2, $height, 'CAJERO: ', 1, 0, 'L', false, '', 0, false, 'T', 'C');
		
		$this->pdf->SetFont('', '');
		$this->pdf->Cell($width4, $height, $this->getDataSource()->getParameter('cajero'), 1, 1, 'L', false, '', 0, false, 'T', 'C');
		
		$this->pdf->SetFont('', 'B');
        $this->pdf->Cell($width2, $height, 'UNIDAD SOLICITANTE: ', 1, 0, 'L', false, '', 0, false, 'T', 'C');
		
		$this->pdf->SetFont('', '');		
        $this->pdf->Cell($width4, $height, $this->getDataSource()->getParameter('nombre_unidad'), 1, 1, 'L', false, '', 0, false, 'T', 'C');
        $this->pdf->SetFont('', 'B');
        $this->pdf->Cell($width2, $height, 'A FAVOR DE: ', 1, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->pdf->SetFont('', '');		
        $this->pdf->Cell($width4, $height, $this->getDataSource()->getParameter('solicitante'), 1, 1, 'L', false, '', 0, false, 'T', 'C');
        $this->pdf->SetFont('', 'B');
        $this->pdf->Cell($width2, $height, 'MOTIVO: ', 1, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->pdf->SetFont('', '');	
			

		$this->pdf->Cell($width4, $height, $this->getDataSource()->getParameter('motivo'), 1, 1, 'L', false, '', 1, false, 'T', 'C');  
        /*$this->pdf->Ln();
		$this->pdf->MultiCell($width4, $height, $this->getDataSource()->getParameter('motivo'), 1, 1, 'L', false, '', 0, true, 'T', 'C');
        $this->pdf->Ln();*/
		
        $this->pdf->SetFont('', 'B');
        $this->pdf->Cell($width2, $height, 'IMPORTE ENTREGADO: ', 1, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->pdf->SetFont('', '');		
        $this->pdf->Cell($width4, $height, $this->getDataSource()->getParameter('monto'), 1, 1, 'L', false, '', 0, false, 'T', 'C');
        
        $this->pdf->Ln();
        $this->pdf->Ln();
    		
		$this->pdf->SetFont('', 'B');   
		  
        
		if($this->getDataSource()->getParameter('codigo_proc') == 'INGEFE' ){
			$this->pdf->Cell($width3+31, $height*5, 'PAGADO POR:', 1, 0, 'C', false, '', 0, false, 'T', 'T');
			$this->pdf->Cell($width3+31, $height*5, 'RECIBIDO POR:', 1, 0, 'C', false, '', 0, false, 'T', 'T');
		}  
		else{
			$this->pdf->Cell($width3+31, $height*5, 'A FAVOR DE:', 1, 0, 'C', false, '', 0, false, 'T', 'T');			
			$this->pdf->Cell($width3+31, $height*5, 'PAGADO POR:', 1, 0, 'C', false, '', 0, false, 'T', 'T');
		}
        
        $this->pdf->Ln();
		$this->pdf->Cell($width3+31, $height, $this->getDataSource()->getParameter('solicitante'),0,0,'C');
		$this->pdf->Cell($width3+31, $height, $this->getDataSource()->getParameter('cajero'),0,0,'C');
		//$this->Cell(145, $height, 'RECIBO DE ENTREGA DE EFECTIVO', 0, 0, 'C', false, '', 1, false, 'T', 'C');
		$this->pdf->Output($this->pdf->url_archivo, 'F');			
    }
}
?>