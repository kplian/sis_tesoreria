<?php
// Extend the TCPDF class to create custom MultiRow
class RProcesoCaja extends ReportePDF {
	var $datos_titulo;
	var $datos_detalle;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $s1;
	var $s2;
	var $s3;
	var $s4;
	var $s5;
	var $s6;
	var $t1;
	var $t2;
	var $t3;
	var $t4;
	var $t5;
	var $t6;
	var $total;
	var $datos_entidad;
	var $datos_periodo;
	var $cant;
	var $valor;
	var $rz;
	var $fun;
	var $fec;
	function datosHeader ($detalle,$resultado,$caja,$fecha) {
		$this->SetHeaderMargin(10);
		$this->SetAutoPageBreak(TRUE, 10);
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;
		$this->datos_titulo = $resultado;	
		$this->SetMargins(25, 15, 5,10);
	}
	//
	function getDataSource(){
		return  $this->datos_detalle;		
	}	
	//
	function Header() {		
	}
	//	
	function generarCabecera(){
		$conf_par_tablewidths=array(7,20,40,40,20,20,15);
		$conf_par_tablenumbers=array(0,0,0,0,0,0,0);
		$conf_par_tablealigns=array('C','C','C','C','C','C','C');
		$conf_tabletextcolor=array();
		$this->tablewidths=$conf_par_tablewidths;
		$this->tablealigns=$conf_par_tablealigns;
		$this->tablenumbers=$conf_par_tablenumbers;
		$this->tableborders=$conf_tableborders;
		$this->tabletextcolor=$conf_tabletextcolor;
		$valor=$a;
		$RowArray = array(
							's0' => 'Nº',
							's1' => 'FECHA',
							's2' => 'NRO TRAMITE',
							's3' => 'MOTIVO',
							's4' => 'ESTADO',				
							's5' => 'INGRESO',
							's6' => 'SALIDA',
						);
		$this->MultiRow($RowArray, false, 1);
	}
	//
	function generarReporte() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		$this->generarCuerpo($this->datos_detalle);
	}
	//		
	function generarCuerpo($detalle){		
		//function		
		$this->cab();
		$count = 1;
		$count1 = 1;
		$sw = 0;
		$ult_region = '';
		$fill = 0;
		$fill1 = 0;
		$this->total = count($detalle);
		$this->s1 = 0;
		$this->s2 = 0;
		$this->s3 = 0;
		$this->s4 = 0;
		$this->imprimirLinea($val,$count,$fill);
	}
	//
	function imprimirLinea($val,$count,$fill){
		$this->SetFillColor(224, 235, 255);
		$this->SetTextColor(0);
		$this->SetFont('','',6);
		$this->tablenumbers=array(0,0,0,0,0,2,2);
		$this->tablealigns=array('C','L','L','L','L','R','R');			
		$this->tableborders=array('RLTB','RLTB','RLTB','RLTB','RLTB','RLTB','RLTB');
		$this->tabletextcolor=array();	
		$i=0;
		foreach ($this->getDataSource() as $datarow) {
			if($datarow['monto']==0.00){
				$datarow['monto']= 0;
			}
			if($datarow['importe_pago_liquido']== 0.00){
				$datarow['importe_pago_liquido']= 0;
			}
			
			if($i==0){				
				$fec=$datarow['fecha'];
			}else{			
				$RowArray = array(
					's0' => $i,
					's1' => trim($datarow['fecha_reg']),
					's2' => trim($datarow['nro_tramite']),					
					's3' => trim($datarow['motivo'].$datarow['razon_social']),			
					's4' => trim($datarow['estado_r'].$datarow['estado']),
					's5' => $datarow['monto'],				
					's6' => $datarow['importe_pago_liquido']
				);
				$fill = !$fill;					
				$this->total = $this->total -1;								
				$this-> MultiRow($RowArray,$fill,0);			
				$this->revisarfinPagina($datarow);
			}	
			$i++;			
		}			
		$this->cerrarCuadro();
		$this->cerrarCuadroTotal();	
		$this->Ln(5);
		$this->SetFont('', 'B',7);				
		$this->Cell(150, $height, 'Saldo:   '.number_format($this->t2-$this->t3), 0, 0, 'R', false, '', 0, false, 'T', 'R');
					
		$this->tablewidths=$conf_par_tablewidths;
		$this->tablealigns=$conf_par_tablealigns;
		$this->tablenumbers=$conf_par_tablenumbers;
		$this->tableborders=$conf_tableborders;
		$this->tabletextcolor=$conf_tabletextcolor;		
	}
	
	//
	function revisarfinPagina($a){
		$dimensions = $this->getPageDimensions();
		$hasBorder = false;
		$startY = $this->GetY();
		$this->getNumLines($row['cell1data'], 90);
		$this->calcularMontos($a);			
		if ($startY > 237) {			
			$this->cerrarCuadro();
			$this->cerrarCuadroTotal();				
			if($this->total!= 0){
				$this->AddPage();
				$this->generarCabecera();
			}				
		}
	}
	//
	function calcularMontos($val){
		$this->s2 = $this->s2 + $val['monto'];
		$this->s3 = $this->s3 + $val['importe_pago_liquido'];
		
		$this->t2 = $this->t2 + $val['monto'];	
		$this->t3 = $this->t3 + $val['importe_pago_liquido'];
				
	}	
	//revisarfinPagina pie
	function cerrarCuadro(){
		//si noes inicio termina el cuardro anterior
		$conf_par_tablewidths=array(7,20,40,40,20,20,15);				
		$this->tablealigns=array('R','R','R','R','R','R','R');		
		$this->tablenumbers=array(0,0,0,0,0,2,2);
		$this->tableborders=array('T','T','T','T','LRTB','LRTB');								
		$RowArray = array(  's0' => '',
							's1' => '',
							's2' => '',
							's3' => '',							
							'espacio' => 'Subtotal',
							's4' => $this->s2,
							's5' => $this->s3
						);		
		$this-> MultiRow($RowArray,false,1);
		$this->s1 = 0;
		$this->s2 = 0;
		$this->s3 = 0;
		$this->s4 = 0;
		$this->s5 = 0;
	}
	//revisarfinPagina pie
	function cerrarCuadroTotal(){
		$conf_par_tablewidths=array(7,20,40,40,20,20,15);			
		$this->tablealigns=array('R','R','R','R','R','R','R');		
		$this->tablenumbers=array(0,0,0,0,0,2,2);
		$this->tableborders=array('','','','','LRTB','LRTB','LRTB');									
		$RowArray = array(
					't0' => '', 
					't1' => '',					
					't2' => '',
					't3' => '',					
					'espacio' => 'TOTAL: ',
					't4' => $this->t2,
					't5' => $this->t3
				);
		$this-> MultiRow($RowArray,false,1);	
	}
	//
	function Footer() {
				
		$this->setY(-15);
		$ormargins = $this->getOriginalMargins();
		$this->SetTextColor(0, 0, 0);
		$line_width = 0.85 / $this->getScaleFactor();
		$this->SetLineStyle(array('width' => $line_width, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
		$ancho = round(($this->getPageWidth() - $ormargins['left'] - $ormargins['right']) / 3);
		$this->Ln(2);
		$cur_y = $this->GetY();
		$this->Cell($ancho, 0, '', '', 0, 'L');
		$pagenumtxt = 'Página'.' '.$this->getAliasNumPage().' de '.$this->getAliasNbPages();
		$this->Cell($ancho, 0, $pagenumtxt, '', 0, 'C');
		$this->Cell($ancho, 0, '', '', 0, 'R');
		$this->Ln();
		$fecha_rep = date("d-m-Y H:i:s");
		$this->Cell($ancho, 0, '', '', 0, 'L');
		$this->Ln($line_width);
	}
	//
	function cab() {
		$white = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(255, 255, 255)));
		$black = array('T' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
		$this->Ln(3);
		$this->Image(dirname(__FILE__).'/../../lib/imagenes/logos/logo.jpg', 10,5,40,20);
		$this->ln(5);
		$this->SetFont('','B',12);		
		$this->Cell(0,5,"RENDICION DE CAJA",0,1,'C');					
		$this->Ln(3);
		
		$height = 2;
		$width1 = 5;
		$esp_width = 10;
		$width_c1= 30;
		$width_c2= 40;		
		
		$fechaactual = date("d-m-Y H:i:s");
				
		$this->SetFont('', 'B',7);
		$this->SetFillColor(192,192,192, true);	
		$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->Cell($width_c1, $height, 'CAJA :', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->SetFont('', '',7);				
		$this->Cell($width_c2, $height, $this->objParam->getParametro('caja'), 0, 0, 'L', true, '', 0, false, 'T', 'C');
		$this->Ln(5);
		
		$this->SetFont('', 'B',7);
		$this->SetFillColor(192,192,192, true);	
		$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->Cell($width_c1, $height, 'FECHA :', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->SetFont('', '',7);				
		 $fecha=date_format(date_create($this->objParam->getParametro('fecha')),'d/m/Y');
		$this->Cell($width_c2, $height, $fecha, 0, 0, 'L', true, '', 0, false, 'T', 'C');
		$this->Ln(3);
		
		$this->Ln(6);
		$this->SetFont('','B',6);
		$this->generarCabecera();
	}		
}
?>