<?php
/*
***************************************************************************
  ISSUE    SIS      EMPRESA     FECHA           AUTOR               DESCRIPCION
  #61      TES      ETR         01/08/2019      RCM                 Actualizacion PHP 7, error al generar reporte de solicitud de efectivo
 ***************************************************************************
*/
require_once dirname(__FILE__).'/../../pxp/lib/lib_reporte/ReportePDFFormulario.php';
require_once dirname(__FILE__).'/../../pxp/pxpReport/Report.php';
 class CustomReport extends ReportePDFFormulario{

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
        $this->Cell(145, $height, 'FORMULARIO DE SOLICITUD DE EFECTIVO', 0, 0, 'C', false, '', 1, false, 'T', 'C');
		$this->SetFontSize(14);

		$x=$this->getX();
		$y=$this->getY();
		$this->setXY($x-10,$y+5);
		$this->SetFontSize(8);
		$this->SetFont('', 'B');
		$this->Cell(30, $height, $this->getDataSource()->getParameter('nro_tramite'), 0, 0, 'L', false, '', 1, false, 'T', 'C');

    }

}


Class RSolicitudEfectivo extends CustomReport {
	var $objParam;
	function __construct(CTParametro $objParam) {
		$this->objParam = $objParam;
	}
    function write1() { //#61 se cambia el nombre de la función write por conflicto con función de la librería

        $pdf = new CustomReport($this->objParam);
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

		// add a page
        $pdf->AddPage();

        $height = 5;
        $width1 = 15;
        $width2 = 20;
        $width3 = 35;
        $width4 = 75;
		$width5 = 110;

        $pdf->SetFontSize(8.5);
        $pdf->setTextColor(0,0,0);

        $pdf->SetFont('', 'B');
        $pdf->Cell($width3, $height, 'Fecha :', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
        $pdf->SetFont('', '');
		$pdf->Cell($width2, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('fecha'), 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
        $pdf->Ln();

        $pdf->SetFont('', 'B');
        $pdf->Cell($width3, $height, 'Solicitante :', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
        $pdf->SetFont('', '');
		$pdf->Cell($width2, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('desc_funcionario'), 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
        $pdf->Ln();

		$pdf->SetFont('', 'B');
        $pdf->Cell($width2, $height, $this->getDataSource()->getParameter('codigo_moneda').'.', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$pdf->SetFont('', '');
		$pdf->Cell($width2+5, $height, $this->getDataSource()->getParameter('monto'), 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$pdf->SetFont('', 'B');
		$pdf->Cell(10, $height, 'Son : ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$pdf->SetFont('', '');
		$pdf->Cell($width5, $height, $this->getDataSource()->getParameter('monto_literal'), 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$pdf->SetFont('', 'B');
		$pdf->Cell($width3, $height, $this->getDataSource()->getParameter('moneda'), 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
        $pdf->Ln();

		$pdf->SetFont('', 'B');
        $pdf->Cell($width4, $height, 'Destinado a la compra y/o contratacion de :', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
        $pdf->SetFont('', '');
		if($this->getDataSource()->getParameter('motivo')!=''){
			$pdf->Cell($width2, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$pdf->Cell($width3, $height, $this->getDataSource()->getParameter('motivo'), 0, 0, 'L', false, '', 1, false, 'T', 'C');
		}else{
			$this->writeDetalles($this->getDataSource()->getParameter('detalleDataSource'), $pdf);
		}
        $pdf->Ln();
        $pdf->Ln();
        $pdf->Ln();
        $pdf->Ln();
        $pdf->Ln();
        $pdf->Ln();
        $pdf->Ln();
        $pdf->Ln();
		$pdf->Ln();
        $pdf->Ln();
        $pdf->Ln();
        $pdf->Ln();
		$pdf->Ln();

        $style = array(
            'border' => 2,
            'vpadding' => 'auto',
            'hpadding' => 'auto',
            'fgcolor' => array(0,0,0),
            'bgcolor' => false, //array(255,255,255)
            'module_width' => 1, // width of a single module in points
            'module_height' => 1 // height of a single module in points
        );

        $x = 40;
        $y = 120;
        $pdf->write2DBarcode($this->getDataSource()->getParameter('desc_funcionario'), 'QRCODE,L',$x, $y, 25, 25, $style, 'T');
        $pdf->write2DBarcode($this->getDataSource()->getParameter('vbjefe'), 'QRCODE,L',$x+55, $y, 25, 25, $style, 'T');
        $pdf->write2DBarcode($this->getDataSource()->getParameter('vbfinanzas'), 'QRCODE,L',$x+110, $y, 25, 25, $style, 'T');
        $pdf->setY(140);
        $pdf->Ln();
        $pdf->SetFont('', 'B');
        $pdf->Cell($width2, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('desc_funcionario'), 0, 0, 'L', false, '', 1, false, 'T', 'C');
        $pdf->Cell($width2, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('vbjefe'), 0, 0, 'L', false, '', 1, false, 'T', 'C');
        $pdf->Cell($width2, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('vbfinanzas'), 0, 0, 'L', false, '', 1, false, 'T', 'C');
        $pdf->Ln();
		$pdf->Cell($width2, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width3, $height, 'SOLICITANTE', 0, 0, 'C', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width2, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width3, $height, 'VB JEFE DEPARTAMENTO/AREA', 0, 0, 'C', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width2, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width3, $height, 'AUTORIZACION FINANZAS', 0, 0, 'C', false, '', 0, false, 'T', 'C');
        $pdf->Ln();

		$pdf->Output($pdf->url_archivo, 'F');
    }

	function writeDetalles (DataSource $dataSource, TCPDF $pdf) {

         $pdf->setTextColor(0,0,0);
         $pdf->setFont('','B');
         $pdf->setFont('','');

        //cambia el color de lineas
        $pdf->SetDrawColor    (  0,-1,-1,-1,false,'');

        $width1 = 15;
        $width2 = 25;
        $width3 = 20;

        $height = 5;
        $pdf->Ln();

        $conf_par_tablewidths=array($width2*3,$width2*2+10,$width2+$width2);
        $conf_par_tablealigns=array('L','L','R');
        $conf_par_tablenumbers=array(0,0,0);
        $conf_tableborders=array();
        $conf_tabletextcolor=array();

        $conf_det_tablewidths=array($width2*6,$width3*2-5);
        $conf_det_tablealigns=array('L','R');
        $conf_det_tablenumbers=array(0,0);

        $conf_det2_tablewidths=array($width2*6,$width3*2-5);
        $conf_det2_tablealigns=array('L','R');
        $conf_det2_tablenumbers=array(0,2);

        $conf_tp_tablewidths=array(($width2*2)+$width1+30+($width3*2)+$width1,$width3*2-5);
        $conf_tp_tablealigns=array('R','R');
        $conf_tp_tablenumbers=array(0,2);
        $conf_tp_tableborders=array(0,1);

        $total_solicitud = 0;
        $count_partidas = 0;

        foreach($dataSource->getDataset() as $row) {

            $pdf->tablewidths=$conf_par_tablewidths;
            $pdf->tablealigns=$conf_par_tablealigns;
            $pdf->tablenumbers=$conf_par_tablenumbers;
            $pdf->tableborders=$conf_tableborders;
            $pdf->tabletextcolor=$conf_tabletextcolor;

            $RowArray = array(
                        'desc_centro_costo'    => 'Centro de Costo'
                    );

             $pdf-> MultiRow($RowArray,false,0);

            $RowArray = array(
                        'desc_centro_costo'    => $row['groupeddata'][0]['codigo_cc']
                    );

            $pdf-> MultiRow($RowArray,false,0);

            /////////////////////////////////
            //agregar detalle de la solicitud
            //////////////////////////////////

            $pdf->tablewidths=$conf_det_tablewidths;
            $pdf->tablealigns=$conf_det_tablealigns;
            $pdf->tablenumbers=$conf_det_tablenumbers;
            $pdf->tableborders=$conf_tableborders;
            $pdf->tabletextcolor=$conf_tabletextcolor;

            $RowArray = array(
            			'desc_ingas'  => 'Concepto Gasto',
                        'precio_total' => 'Precio Total'
                    );

            $pdf-> MultiRow($RowArray,false,1);

            $totalRef=0;
            $xEnd=0;
            $yEnd=0;

            $pdf->tablewidths=$conf_det2_tablewidths;
            $pdf->tablealigns=$conf_det2_tablealigns;
            $pdf->tablenumbers=$conf_det2_tablenumbers;
            $pdf->tableborders=$conf_tableborders;

            foreach ($row['groupeddata'] as $solicitudDetalle) {

                $RowArray = array(
                        'desc_concepto_ingas'  => $solicitudDetalle['desc_ingas'],
                        'precio_total' => $solicitudDetalle['monto']
                    );

                $pdf-> MultiRow($RowArray,false,1) ;

                $totalRef=$totalRef+$solicitudDetalle['monto'];
            }
           //coloca el total de la partida
           $pdf->tablewidths=$conf_tp_tablewidths;
           $pdf->tablealigns=$conf_tp_tablealigns;
           $pdf->tablenumbers=$conf_tp_tablenumbers;
           $pdf->tableborders=$conf_tp_tableborders;

           $RowArray = array(
                        'precio_unitario' => '('.$this->getDataSource()->getParameter('moneda').')',
                        'precio_total' => $totalRef
                    );

           $pdf-> MultiRow($RowArray,false,1);

           $total_solicitud = $total_solicitud + $totalRef;
           $count_partidas = $count_partidas + 1;
           $pdf->Ln();

        }

        //coloca el gran total de la solicitud

        if($count_partidas > 1){
           $pdf->tablewidths=$conf_tp_tablewidths;
           $pdf->tablealigns=$conf_tp_tablealigns;
           $pdf->tablenumbers=$conf_tp_tablenumbers;
           $pdf->tableborders=array(0,0);

           $RowArray = array(
                        'precio_unitario' => 'Total Solicitud ('.$this->getDataSource()->getParameter('moneda').')',
                        'precio_total' => $total_solicitud
                    );

           $pdf-> MultiRow($RowArray,false,1);
           $pdf->Ln();
           $pdf->Ln();

        }

    }
}
?>