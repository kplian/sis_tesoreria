<?php
require_once dirname(__FILE__).'/../../pxp/lib/lib_reporte/ReportePDFFormulario.php';
require_once dirname(__FILE__).'/../../pxp/pxpReport/Report.php';
 class CustomReporterer extends ReportePDFFormulario{
    
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
        $this->Cell(145, $height, 'RENDICION DE EFECTIVO', 0, 0, 'C', false, '', 1, false, 'T', 'C');								
		$this->SetFontSize(14);
		
		$x=$this->getX();
		$y=$this->getY();
		$this->setXY($x-10,$y+5);
		$this->SetFontSize(8);
		$this->SetFont('', 'B');
		//$this->Cell(30, $height, $this->getDataSource()->getParameter('nro_tramite'), 0, 0, 'L', false, '', 1, false, 'T', 'C');		
    }  
	public function Footer(){
		$this->SetFontSize(5.5);
		$this->setY(-15);
		$ormargins = $this->getOriginalMargins();
		$this->SetTextColor(0, 0, 0);
		//set style for cell border
		$line_width = 0.85 / $this->getScaleFactor();
		$this->SetLineStyle(array('width' => $line_width, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
		$ancho = round(($this->getPageWidth() - $ormargins['left'] - $ormargins['right']) / 3);
		$this->Ln(2);
		$cur_y = $this->GetY();
		//$this->Cell($ancho, 0, 'Generado por XPHS', 'T', 0, 'L');
		if ($this->usuario_firma == '') {
			$this->Cell($ancho, 0, 'Usuario: '.$_SESSION['_LOGIN'], '', 0, 'L');
		} else {
			$this->Cell($ancho, 0, 'Usuario Firma: '.$this->usuario_firma, '', 0, 'L');
		}
		$pagenumtxt = 'Página'.' '.$this->getAliasNumPage().' de '.$this->getAliasNbPages();
		$this->Cell($ancho, 0, $pagenumtxt, '', 0, 'C');
		$this->Cell($ancho, 0, $_SESSION['_REP_NOMBRE_SISTEMA'], '', 0, 'R');
		$this->Ln();
		$fec = date("d-m-Y H:i:s");
		if ($this->fecha_rep == '') {			
			$this->Cell($ancho, 0, "Fecha : " . $fec, '', 0, 'L');
		} else {
			//$this->Cell($ancho, 0, "Fecha Firma: " . $this->fecha_rep, '', 0, 'L');
		}	
		
	}
    
}

Class RRendicionEfectivo extends Report {
	var $objParam;
	function __construct(CTParametro $objParam) {
		$this->objParam = $objParam;
	}
    function write() {
    	
        $pdf = new CustomReporterer($this->objParam);
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
        $width2 = 40;
        $width3 = 62;
        $width4 = 146;
        
        $pdf->SetFontSize(8.5);		
        $pdf->setTextColor(0,0,0);

        $pdf->SetFont('', 'B');       
        $pdf->Cell($width3, $height, 'FECHA RENDICION', 1, 0, 'C', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width3, $height, 'MONEDA', 1, 0, 'C', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width3, $height, 'NRO TRAMITE', 1, 1, 'C', false, '', 0, false, 'T', 'C');     
        $pdf->SetFont('', '');        
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('fecha_rendicion'), 1, 0, 'C', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('moneda'), 1, 0, 'C', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('nro_tramite'), 1, 1, 'C', false, '', 0, false, 'T', 'C');
		$pdf->Ln();
		
		$pdf->SetFont('', 'B');
        $pdf->Cell($width2, $height, 'CAJA: ', 1, 0, 'L', false, '', 0, false, 'T', 'C');
		$pdf->SetFont('', '');      		
        $pdf->Cell($width4, $height, $this->getDataSource()->getParameter('codigo'), 1, 1, 'L', false, '', 0, false, 'T', 'C');
		$pdf->SetFont('', 'B');
        $pdf->Cell($width2, $height, 'CAJERO: ', 1, 0, 'L', false, '', 0, false, 'T', 'C');
		$pdf->SetFont('', '');
		$pdf->Cell($width4, $height, $this->getDataSource()->getParameter('cajero'), 1, 1, 'L', false, '', 0, false, 'T', 'C');
		$pdf->SetFont('', 'B');
        $pdf->Cell($width2, $height, 'UNIDAD SOLICITANTE: ', 1, 0, 'L', false, '', 0, false, 'T', 'C');
		$pdf->SetFont('', '');		
        $pdf->Cell($width4, $height, $this->getDataSource()->getParameter('nombre_unidad'), 1, 1, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', 'B');
        $pdf->Cell($width2, $height, 'A FAVOR DE: ', 1, 0, 'L', false, '', 0, false, 'T', 'C');
		$pdf->SetFont('', '');		
        $pdf->Cell($width4, $height, $this->getDataSource()->getParameter('solicitante'), 1, 1, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', 'B');
        $pdf->Cell($width2, $height*2, 'POR CONCEPTO : ', 1, 0, 'L', false, '', 0, false, 'T', 'C');
		$pdf->SetFont('', '');		
        $pdf->Cell($width4, $height*2, $this->getDataSource()->getParameter('motivo'), 1, 1, 'L', false, '', 1, false, 'T', 'C');
        
        $pdf->Ln();
        $pdf->Ln();
		
		$this->writeDetalles($this->getDataSource()->getParameter('detalleDataSource'), $pdf);
    	/*	
		$pdf->SetFont('', 'B');       
        $pdf->Cell($width3+31, $height*5, 'RECIBIDO POR:', 1, 0, 'C', false, '', 0, false, 'T', 'T');
        $pdf->Cell($width3+31, $height*5, 'PAGADO POR:', 1, 0, 'C', false, '', 0, false, 'T', 'T');                               
        $pdf->Ln();
		*/
		$pdf->Output($pdf->url_archivo, 'F');			
    }
	
	function writeDetalles (DataSource $dataSource, TCPDF $pdf) {
            
         $pdf->setTextColor(0,0,0);
         $pdf->setFont('','B');
         $pdf->setFont('','');
        
        //cambia el color de lineas
        $pdf->SetDrawColor    (  0,-1,-1,-1,false,'');   
        
        $width1 = 12;
        $width2 = 25;
        $width3 = 20;
        
        $height = 5;
        $pdf->Ln();       
        /*        
        $conf_par_tablewidths=array($width2*3,$width2*2+10,$width2+$width2);
        $conf_par_tablealigns=array('L','L','R');
        $conf_par_tablenumbers=array(0,0,0);
		*/
        $conf_tableborders=array();
        $conf_tabletextcolor=array();
                
        $conf_det_tablewidths=array($width1+6,$width1*3+2,$width1*3+19,$width1*2-5,$width1*2-5,$width1*2-5,$width1*2-5);
        $conf_det_tablealigns=array('C','C','C','C','C','C','C');
        $conf_det_tablenumbers=array(0,0,0,0,0,0,0);
        
        $conf_det2_tablewidths=array($width1+6,$width1*3+2,$width1*3+19,$width1*2-5,$width1*2-5,$width1*2-5,$width1*2-5);
        $conf_det2_tablealigns=array('L','L','L','C','C','C','C');
        $conf_det2_tablenumbers=array(0,0,0,0,0,0,0);
        
        $conf_tp_tablewidths=array($width1*9+3,$width1*2-5,$width1*2-5,$width1*2-5);
        $conf_tp_tablealigns=array('L','C','C','C','C');
        $conf_tp_tablenumbers=array(0,0,0,0,0);
        $conf_tp_tableborders=array(0,0,0,0,0);
        
        $total_rendicion = 0;
        $total_retencion = 0;
        $total_cargo = 0;
        $total_descargo = 0;
        $count_facturas = 0;
		$total_dev = 0;
		$total_rep = 0;
		$total_importe = 0;
		$aux = 0;
		$pdf->tablewidths=$conf_det_tablewidths;
		$pdf->tablealigns=$conf_det_tablealigns;
		$pdf->tablenumbers=$conf_det_tablenumbers;
		$pdf->tableborders=$conf_tableborders;
		$pdf->tabletextcolor=$conf_tabletextcolor;
		
        $RowArray = array(
            			'fecha_entrega'  => 'Fecha',
                        'desc_plantilla' => 'Tipo Documento',
						'rendicion' => 'Documento',
						'importe_neto' => 'Total',
						'impuesto_descuento_ley' => 'Retencion',
						'cargo' => 'Cargo',
						'descargo' => 'Descargo',
                    );     
                         
            $pdf-> MultiRow($RowArray,false,1); 
		foreach($dataSource->getDataset() as $row) {
	
			$pdf->tablewidths=$conf_par_tablewidths;
			$pdf->tablealigns=$conf_par_tablealigns;
			$pdf->tablenumbers=$conf_par_tablenumbers;
			$pdf->tableborders=$conf_tableborders;
			$pdf->tabletextcolor=$conf_tabletextcolor;
			$pdf->tablewidths=$conf_det_tablewidths;
			$pdf->tablealigns=$conf_det_tablealigns;
			$pdf->tablenumbers=$conf_det_tablenumbers;
			$pdf->tableborders=$conf_tableborders;
			$pdf->tabletextcolor=$conf_tabletextcolor;
			
			$RowArray = array(
				'fecha_entrega'  => 'Fecha',
				'desc_plantilla' => 'Tipo Documento',
				'rendicion' => 'Documento',
				'importe_neto' => 'Total',
				'impuesto_descuento_ley' => 'Retencion',
				'cargo' => 'Cargo',
				'descargo' => 'Descargo',
            );
            $pdf->tablewidths=$conf_det2_tablewidths;
            $pdf->tablealigns=$conf_det2_tablealigns;
            $pdf->tablenumbers=$conf_det2_tablenumbers;
            $pdf->tableborders=$conf_tableborders;
			
            $RowArray = array(
                'fecha_entrega'  => $row['fecha_entrega'],
                'desc_plantilla' => $row['desc_plantilla'],
                'rendicion' => $row['rendicion'],
                'importe_neto' => $row['importe_neto'],
                'impuesto_descuento_ley' => $row['impuesto_descuento_ley'],
                'cargo' => $row['cargo'],
                'descargo' => $row['importe_neto'] - $row['impuesto_descuento_ley'],
                //'importe_pago_liquido' => $row['importe_pago_liquido']
            );     
            $pdf-> MultiRow($RowArray,false,1); 

           $total_rendicion = $total_rendicion + $row['importe_neto']; 
           $total_retencion = $total_retencion + $row['impuesto_descuento_ley'];
           $total_cargo = $total_cargo + $row['cargo'];
           $total_descargo = $total_descargo + $row['descargo'];
           $count_facturas = $count_facturas + 1;
		   $total_rep=$row['monto_dev'];
		   $total_dev=$row['rendicion'];
		   $total_importe+=$row['importe_pago_liquido'];
		  
		}
		if(($total_cargo-$total_importe)>0){
			$total_dev=$total_cargo-$total_importe;
			$total_rep=0;
		}else{
			$total_rep=$total_importe-$total_cargo;	
			$total_dev=	0;	
		}
		
        //coloca el gran total de la solicitud 
               
        if($count_facturas > 1){
           $pdf->tablewidths=$conf_tp_tablewidths;
           $pdf->tablealigns=$conf_tp_tablealigns;
           $pdf->tablenumbers=$conf_tp_tablenumbers;
           $pdf->tableborders=array(0,1);
           $pdf->SetFont('', 'B');
           $RowArray = array(
                        'leyenda' => 'Total Rendicion ('.$this->getDataSource()->getParameter('moneda').')',
                        'total_rendicion' => number_format($total_rendicion,2),
                        'total_retencion' => number_format($total_retencion,2),
                        'total_cargo' => number_format($total_cargo,2),
                        'total_descargo' => number_format($total_importe,2)
                    );     
           $saldo_caja = $total_cargo - $total_descargo; 
		   $saldo_caja = $saldo_caja > 0 ? $saldo_caja : 0;
           $saldo_solicitante = $total_descargo - $total_cargo;
		   $saldo_solicitante = $saldo_solicitante > 0 ? $saldo_solicitante : 0;
           $pdf-> MultiRow($RowArray,false,1); 
		   
		   $pdf->tableborders=array(0,0,0,1,1);
		   $RowArray = array(
                        'leyenda' => 'Saldo a Favor de la Caja ('.$this->getDataSource()->getParameter('moneda').')',
                        'total_rendicion' => null,
                        'total_retencion' => null,
                        'total_cargo' => number_format(0,2),
                        //'total_descargo' => number_format($saldo_caja,2)
                        'total_descargo' => number_format($total_dev,2)
                    ); 
		   $pdf-> MultiRow($RowArray,false,1); 
		   
		   $RowArray = array(
                        'leyenda' => 'Saldo a Favor del Solicitante ('.$this->getDataSource()->getParameter('moneda').')',
                        'total_rendicion' => null,
                        'total_retencion' => null,
                        //'total_cargo' => number_format($total_retencion-$saldo_solicitante,2),
                        'total_cargo' => number_format(0,2),
                        //'total_descargo' => number_format(0,2)
                        'total_descargo' => number_format($total_rep,2)
                    ); 
		   $pdf-> MultiRow($RowArray,false,1); 
		   
		   $RowArray = array(
                        'leyenda' => 'Sumas Iguales ('.$this->getDataSource()->getParameter('moneda').')',
                        'total_rendicion' => null,
                        'total_retencion' => null,
                        //'total_cargo' => number_format($total_cargo + $saldo_solicitante,2),
                        'total_cargo' => number_format($total_cargo,2),
                        //'total_descargo' => number_format($total_descargo + $saldo_caja,2)
                        'total_descargo' => number_format($total_cargo,2)
                    ); 
		   $pdf-> MultiRow($RowArray,false,1); 
		   $pdf->Ln();
		   $pdf->Ln();
		   
		   $pdf->SetFont('', 'B');       
		   $pdf->Cell($width2*3+18, $height*5, 'SOLICITANTE:', 1, 0, 'C', false, '', 0, false, 'T', 'T');
           $pdf->Cell($width2*3+18, $height*5, 'RESPONSABLE CAJA CHICA:', 1, 0, 'C', false, '', 0, false, 'T', 'T');                               
           
           $pdf->Ln();
           $pdf->Ln();  
                
        }
        
    }
}
?>