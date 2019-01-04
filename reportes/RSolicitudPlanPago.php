<?php
/*
*@date 30/08/2018
*@description añadida la columna retenciones de garantía para mostrar el reporte de solicitud de pago
		ISSUE	FORK 	   FECHA			AUTHOR			DESCRIPCION
 		  #5	EndeETR		27/12/2018		EGS				Se añadio el dato de codigo de proveedor
 * 
 * */
require_once dirname(__FILE__).'/../../pxp/pxpReport/Report.php';

 class CustomReport extends TCPDF {
    
    private $dataSource;
    
    public function setDataSource(DataSource $dataSource) {
        $this->dataSource = $dataSource;
    }
    
    public function getDataSource() {
        return $this->dataSource;
    }
    
    public function Header($titulo='Pago') {
    	
        $height = 20;
		$this->Image(dirname(__FILE__).'/../../pxp/lib'.$_SESSION['_DIR_LOGO'], $x+10, $y+10, 36);
        $this->Cell(20, $height, '', 0, 0, 'C', false, '', 1, false, 'T', 'C');
								
        $this->SetFontSize(16);
        $this->SetFont('','B'); 
        
       
        if($this->getDataSource()->getParameter('tipo')=='devengado_pagado'&& $this->getDataSource()->getParameter('pago_borrador')=='no'){
                
             $titulo='Devengado y Pago';
        }
        elseif(($this->getDataSource()->getParameter('tipo'))=='devengado'|| $this->getDataSource()->getParameter('pago_borrador')=='si'){
                
             $titulo='Devengado';
        }
        else
        {
            $titulo='Pago';
        }
        
        $this->Cell(145, $height, 'Solicitud de '.ucfirst($titulo), 0, 0, 'C', false, '', 1, false, 'T', 'C');        
        $this->Ln();
        
        $x=$this->getX();
        $y=$this->getY();
        $this->setXY($x,$y-4);
        $this->SetFontSize(8);
        $this->SetFont('', 'B');
        
        //$this->setXY($x,$y+8);
        $this->setFont('','');
        
             
        
        $this->Cell(185, $height/5, 'Expresado en '.$this->getDataSource()->getParameter('moneda'), 0, 0, 'C', false, '', 1, false, 'T', 'C');
        $this->Ln();
        $this->Cell(185, $height/5, 'Tipo de Cambio '.$this->getDataSource()->getParameter('tipo_cambio'), 0, 0, 'C', false, '', 1, false, 'T', 'C');
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
		$pdf->SetFontSize(8);
		$pdf->SetFont('', 'B');
        $pdf->Cell($width2*2, $height, 'Numero Tramite: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('num_tramite'), 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
        $pdf->SetFont('', 'B');
        $pdf->Cell($width2*2, $height, 'Proveedor: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('codigo_proveedor').' - '.$this->getDataSource()->getParameter('proveedor'), 0, 0, 'L', false, '', 0, false, 'T', 'C');
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
		if($this->getDataSource()->getParameter('nro_contrato') != ''){
		        $pdf->SetFont('', 'B');
		        $pdf->Cell($width2*2, $height, 'Nro contrato: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		        $pdf->SetFont('', '');
		        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('nro_contrato'), 0, 0, 'L', false, '', 0, false, 'T', 'C');        $pdf->Ln();
        }
		
		
		$pdf->Ln();
		
		
		//$pdf->Cell($width2*2, $height, 'Conformidad de recepcion: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		/*$pdf->SetFont('', 'B');
		$pdf->Cell(40, $height, 'Conformidad de recepcion: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->Cell($width2, $height, 'El material, suministro o servicio ha sido recibido en conformidad de acuerdo a condiciones según pedido, se adjunta', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$pdf->Ln();
		$pdf->Cell(40, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$pdf->Cell($width3, $height, 'factura y/o recibo de pago.', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		*/
		
		
        $pdf->Ln();
		$pdf->Ln();
		$pdf->Cell($width2+$width3, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$pdf->SetFont('', 'B');
        $pdf->Cell($width2*2, $height, 'Importe ('.$this->getDataSource()->getParameter('codigo_moneda').'):', 0, 0, 'R', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('importe'), 0, 0, 'R', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
        
		$pdf->Cell($width2+$width3, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$pdf->SetFont('', 'B');
        $pdf->Cell($width2*2, $height, 'Monto no Pagado ('.$this->getDataSource()->getParameter('codigo_moneda').'):', 0, 0, 'R', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('monto_no_pagado'), 0, 0, 'R', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
		
		$pdf->Cell($width2+$width3, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$pdf->SetFont('', 'B');
        $pdf->Cell($width2*2, $height, 'Ret. Garantia ('.$this->getDataSource()->getParameter('codigo_moneda').'):', 0, 0, 'R', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('monto_retgar_mo'), 0, 0, 'R', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
        
        $pdf->Cell($width2+$width3, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$pdf->SetFont('', 'B');
        $pdf->Cell($width2*2, $height, 'Otros Descuentos ('.$this->getDataSource()->getParameter('codigo_moneda').'):', 0, 0, 'R', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('otros_descuentos'), 0, 0, 'R', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
        
        //si tiene monto excento de impuestos
        if ($this->getDataSource()->getParameter('monto_excento') > 0){
             $pdf->Cell($width2+$width3, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
            $pdf->SetFont('', 'B');
            $pdf->Cell($width2*2, $height, 'Monto Excento de Impustos ('.$this->getDataSource()->getParameter('codigo_moneda').'):', 0, 0, 'R', false, '', 0, false, 'T', 'C');
            $pdf->SetFont('', '');
            $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('monto_excento'), 0, 0, 'R', false, '', 0, false, 'T', 'C');
            $pdf->Ln();       
        }
        
        
        $pdf->Cell($width2+$width3, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', 'B');
        $pdf->Cell($width2*2, $height, ' Descuentos de Ley ('.$this->getDataSource()->getParameter('codigo_moneda').'):', 0, 0, 'R', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('descuento_ley'), 0, 0, 'R', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
        
		$pdf->Cell($width2+$width3, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$pdf->SetFont('', 'B');
        $pdf->Cell($width2*2, $height, 'Monto Ejecutado Total ('.$this->getDataSource()->getParameter('codigo_moneda').'):', 0, 0, 'R', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('monto_ejecutado_total'), 0, 0, 'R', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
		$pdf->Cell($width2+$width3, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$pdf->SetFont('', 'B');
        $pdf->Cell($width2*2, $height, 'Liquido Pagable ('.$this->getDataSource()->getParameter('codigo_moneda').'):', 0, 0, 'R', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('liquido_pagable'), 0, 0, 'R', false, '', 0, false, 'T', 'C');
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
        
        if($this->getDataSource()->getParameter('tipo') != 'pagado'){
            $momento = 'DEVENGADO';
        }
        else{
            $momento =  'PAGADO';
        }
        
       
        
        $pdf->Ln();
        $pdf->SetFontSize(7.5);
        $pdf->SetFont('', 'B');
        $height = 5;
		$pdf->Ln();
		$pdf->Cell(185, $height, 'DETALLE DE '.$momento, 0, 1, 'C', false, '', 1, false, 'T', 'C');								
		$pdf->Cell(185, $height, '', 'B', 1, 'L', false, '', 1, true, 'T', 'C');
		$pdf->Ln();
		$white = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(255, 255, 255)));
		$black = array('T' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
		$pdf->SetFontSize(7);
		$pdf->SetFont('', 'B');
		
		//iniciar un FOR
		 foreach($dataSource->getDataset() as $row) {
		
                $pdf->Cell($width2, $height, 'Unidad Organizacional: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
                $pdf->SetFont('', '');
                $pdf->SetFillColor(192,192,192, true);
                $pdf->Cell($width3*2, $height, $row['nombre_uo'], $white, 0, 'L', true, '', 0, false, 'T', 'C');
                $pdf->SetFont('', 'B');
        		
        		$pdf->Cell(5, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
                $pdf->Cell($width2, $height, 'Programa: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
                $pdf->SetFont('', '');
        								$pdf->SetFillColor(192,192,192, true);
                $pdf->Cell($width3*2, $height, $row['nombre_programa'], $white, 0, 'L', true, '', 0, false, 'T', 'C');
                $pdf->Ln();
                $pdf->SetFont('', 'B');
                $pdf->Cell($width2, $height, 'Regional: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
                $pdf->SetFont('', '');
                
                $pdf->SetFillColor(192,192,192, true);
                $pdf->Cell($width3*2, $height, $row['nombre_regional'], $white, 0, 'L', true, '', 0, false, 'T', 'C');
                $pdf->SetFont('', 'B');
        		$pdf->Cell(5, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
                $pdf->Cell($width2, $height, 'Proyecto: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
                $pdf->SetFont('', '');
        		
        		$pdf->SetFillColor(192,192,192, true);
                $pdf->Cell($width3*2, $height, $row['nombre_proyecto'], $white, 0, 'L', true, '', 0, false, 'T', 'C');
                $pdf->Ln();
        		$pdf->SetFont('', 'B');
                $pdf->Cell($width2, $height, 'Financiador: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
                $pdf->SetFont('', '');
                $pdf->SetFillColor(192,192,192, true);
                $pdf->Cell($width3*2, $height, $row['nombre_financiador'], $white, 0, 'L', true, '', 0, false, 'T', 'C');
                $pdf->SetFont('', 'B');
        		$pdf->Cell(5, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
                $pdf->Cell($width2, $height, 'Actividad: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
                $pdf->SetFont('', '');
        		$pdf->SetFillColor(192,192,192, true);
                $pdf->Cell($width3*2, $height, $row['nombre_actividad'], $white, 0, 'L', true, '', 0, false, 'T', 'C');
                $pdf->Ln();
        		$pdf->SetFont('', 'B');
                $pdf->Cell($width2, $height, 'Partida: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
                $pdf->SetFont('', '');
                $pdf->SetFillColor(192,192,192, true);
                $pdf->Cell($width3*2, $height, $row['nombre_partida'], $white, 0, 'L', true, '', 0, false, 'T', 'C');
                $pdf->SetFont('', 'B');
        		$pdf->Cell(5, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
                $pdf->Cell($width2, $height, 'Importe: ', 0, 0, 'L', false, '', 0, false, 'T', 'C');
                $pdf->SetFont('', '');
                
        		//$pdf->Cell($width3*2,  $row['nombre_partida'], $white, 0, 'L', true, '', 0, false, 'T', 'C');
        		$pdf->Cell($width3*2, $height, $row['monto_ejecutar_mo'], $white, 0, 'L', true, '', 0, false, 'T', 'C');
                $pdf->Ln();	
                $pdf->Ln(); 
                $pdf->Ln(); 
                
          }      			
    }      
}
?>