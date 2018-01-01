<?php
require_once dirname(__FILE__).'/../../pxp/lib/lib_reporte/ReportePDFFormulario.php';
require_once dirname(__FILE__).'/../../pxp/pxpReport/Report.php';
//
class CustomReporte extends ReportePDFFormulario {
	private $dataSource;
	
	public function setDataSource(DataSource $dataSource) {
		$this->dataSource = $dataSource;
	}
	
	public function getDataSource() {
		$this->dataSource;
	}
	
	public function Header() {		
		$x= $this->getX();
		$y= $this->getY();
		$height = 20;
		$this->Image(dirname(__FILE__).'/../../pxp/lib'.$_SESSION['_DIR_LOGO'], $x, $y+10, 36);
		$this->Cell(20, $height, '', 0, 0, 'C', false, '', 0, false, 'T', 'C');
		
		$this->SetFont('','B');
	    $this->Cell(145, $height, 'REPOSICION EN CAJA CHICA', 0, 0, 'C', false, '', 1, false, 'T', 'C');								
		$this->SetFontSize(14);
		
		$x=$this->getX();
		$y=$this->getY();
		$this->setXY($x-10,$y+5);
		$this->SetFontSize(8);
		$this->SetFont('', 'B');			
	}		
}
Class RVoBoRepoCaja extends Report {
	var $objParam;
	function __construct(CTParametro $objParam) {
		$this->objParam = $objParam;
	}
	//
	function write() {
			
		$pdf = new CustomReporte($this->objParam);
		$pdf->setDataSource($this->getDataSource());
		$pdf->SetCreator(PDF_CREATOR);		
		$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);
		$pdf->SetMargins(PDF_MARGIN_LEFT, 40, PDF_MARGIN_RIGHT);
		$pdf->SetHeaderMargin(10);
		$pdf->SetFooterMargin(PDF_MARGIN_FOOTER);
		$pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);
		$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
		$pdf->AddPage();
		$height = 5;
		$width1 = 15;
		$width2 = 40;
		$width3 = 62;
		$width4 = 150;
		$pdf->SetFontSize(8.5);		
		$pdf->setTextColor(0,0,0);
		
		
		$pdf->Ln();
		
		$pdf->SetFont('', 'B');
		$pdf->Cell($width2, $height, 'NRO TRAMITE: ', 1, 0, 'L', false, '', 0, false, 'T', 'C');
		$pdf->SetFont('', '');
		$pdf->Cell($width4, $height, $this->getDataSource()->getParameter('nro_tramite'), 1, 1, 'L', false, '', 0, false, 'T', 'C');
		$pdf->SetFont('', 'B');
		$pdf->Cell($width2, $height, 'IMPORTE ENTREGADO : ', 1, 0, 'L', false, '', 0, false, 'T', 'C');
		$pdf->SetFont('', '');
		$pdf->Cell($width4, $height, $this->getDataSource()->getParameter('monto'), 1, 1, 'L', false, '', 0, false, 'T', 'C');
		$pdf->SetFont('', 'B');
		$pdf->Cell($width2, $height, 'MOTIVO : ', 1, 0, 'L', false, '', 0, false, 'T', 'C');
		$pdf->SetFont('', '');		
		$pdf->Cell($width4, $height, $this->getDataSource()->getParameter('motivo'), 1, 1, 'L', false, '', 0, false, 'T', 'C');
		$pdf->SetFont('', 'B');		
		
		$pdf->Ln();
		$pdf->Ln();
			
		$pdf->SetFont('', 'B');
		$pdf->Cell($width3+31, $height, 'RESPONSABLE DE CAJA:', 1, 0, 'C', false, '', 0, false, 'T', 'T');
		$pdf->Ln();
		$pdf->Cell($width3+31, $height*5, $this->getDataSource()->getParameter('motivo'),1, 1, 'L', false, '', 0, false, 'T', 'C');		
		$pdf->Output($pdf->url_archivo, 'F');
	}
}
?>