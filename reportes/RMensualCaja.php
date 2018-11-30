<?php
// Extend the TCPDF class to create custom MultiRow
class RMensualCaja extends ReportePDF {
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
		$this->SetMargins(7, 15, 5);
	
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
		$this->SetFont('','',5);
		$conf_par_tablewidths=array(5,35,13,12,12,30,15,12,10,14,14,12,10,10,10,10,10,30);
		$conf_par_tablenumbers=array(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
		$conf_par_tablealigns=array('C','C','C','C','C','C','C','C','C','C','C','C','C','C','C','C','C','C');
		$conf_tabletextcolor=array();
		$this->tablewidths=$conf_par_tablewidths;
		$this->tablealigns=$conf_par_tablealigns;
		$this->tablenumbers=$conf_par_tablenumbers;
		$this->tableborders=$conf_tableborders;
		$this->tabletextcolor=$conf_tabletextcolor;
		$valor=$a;
		$RowArray = array(
							's0' => 'Nº',
							's1' => 'NRO TRAMITE ',
							's2' => 'TIPO',
							's3' => 'FECHA SOLICITUD',							
							's4' => 'NIT',				
							's5' => 'RAZON SOCIAL',
							's6' => 'NRO AUTORIZACION',							
							's7' => 'NRO DOC',
							's8' => 'CODIGO CONTROL',							
							's9' => 'INGRESO',	
							's10' => 'SALIDA',							
							's11' => 'LIQUIDO PAGABLE',
							's12' => 'IMPORTE IVA',
							's13' => 'IMPORTE DESCUENTO',
							's14' => 'DESCTO LEY',
							's15' => 'EXENTO',
							's16' => 'MOTIVO',
							's17' => 'RENDICION'
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
		$this->Ln(5);
		$this->SetFont('', 'B',7);				
		$this->Cell(150, $height, 'Saldo:   '.number_format(($this->t9-$this->t11),2), 0, 0, 'R', false, '', 0, false, 'T', 'R');
	}
	//
	function imprimirLinea($val,$count,$fill){
		$this->SetFillColor(224, 235, 255);
		$this->SetTextColor(0);
		$this->SetFont('','',5);			
		$i=1;
		foreach ($this->getDataSource() as $datarow) {
			$this->tablenumbers=array(0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,2,0);
			$this->tablewidths=array(5,35,13,12,12,30,15,12,10,14,14,12,10,10,10,10,10,30);
			$this->tablealigns=array('C','L','L','L','L','L','R');			
			$this->tableborders=array('RLTB','RLTB','RLTB','RLTB','RLTB','RLTB','RLTB','RLTB','RLTB','RLTB','RLTB','RLTB','RLTB','RLTB','RLTB','RLTB','RLTB','RLTB');
			$this->tabletextcolor=array();							
			if($datarow['nro_tramite']!='SALDO MES ANTERIOR')
			{								
				if($datarow['motivo']!='rendido'){
					$var= $datarow['monto'];			
					$RowArray = array(
						's0' => $i,
						's1' => $datarow['nro_tramite'],
						's2' => $datarow['desc_plantilla'],					
						's3' => $datarow['fecha'],			
						's4' => $datarow['nit'],
						's5' => $datarow['razon_social'],			
						's6' => $datarow['nro_autorizacion'],
						's7' => $datarow['nro_documento'],														
						's8' => $datarow['codigo_control'],
						's9' => number_format($var,2),
						's10' => '0',
						's11' => number_format($datarow['importe_pago_liquido'],2),
						's12' => number_format($datarow['importe_iva'],2),
						's13' => number_format($datarow['importe_descuento'],2),
						's14' => number_format($datarow['importe_descuento_ley'],2),
						's15' => number_format($datarow['importe_excento'],2),
						's16' => $datarow['motivo'],
						's17' => $datarow['tramite']
					);
				}else{
					$var1= $datarow['monto'];
					$RowArray = array(
						's0' => $i,
						's1' => $datarow['nro_tramite'],
						's2' => $datarow['desc_plantilla'],					
						's3' => $datarow['fecha'],			
						's4' => $datarow['nit'],
						's5' => $datarow['razon_social'],			
						's6' => $datarow['nro_autorizacion'],
						's7' => $datarow['nro_documento'],														
						's8' => $datarow['codigo_control'],
						's9' => '0',
						's10' => number_format($var1,2),
						's11' => number_format($datarow['importe_pago_liquido'],2),
						's12' => number_format($datarow['importe_iva'],2),
						's13' => number_format($datarow['importe_descuento'],2),
						's14' => number_format($datarow['importe_descuento_ley'],2),
						's15' => number_format($datarow['importe_excento'],2),
						's16' => $datarow['motivo'],
						's17' => $datarow['tramite']
					);
				}
			}else{
				$RowArray = array(
					's0' => $i,
					's1' => $datarow['nro_tramite'],
					's2' => $datarow['desc_plantilla'],					
					's3' => $datarow['fecha'],			
					's4' => $datarow['nit'],
					's5' => $datarow['razon_social'],			
					's6' => $datarow['nro_autorizacion'],
					's7' => $datarow['nro_documento'],														
					's8' => $datarow['codigo_control'],
					's9' => number_format($datarow['saldo'],2),
					's10' => '0',
					's11' => number_format($datarow['importe_pago_liquido'],2),
					's12' => number_format($datarow['importe_iva'],2),
					's13' => number_format($datarow['importe_descuento'],2),
					's14' => number_format($datarow['importe_descuento_ley'],2),
					's15' => number_format($datarow['importe_excento'],2),
					's16' => $datarow['motivo'],
					's17' => $datarow['tramite']
				);
			}
			$var=0;
			$var1=0;
			$fill = !$fill;					
			$this->total = $this->total -1;								
			$this-> MultiRow($RowArray,$fill,0);			
			$this->revisarfinPagina($datarow);			
			$i++;					
		}			
		//$this->cerrarCuadro();
		$this->cerrarCuadroTotal();	
	}
	
	//
	function revisarfinPagina($a){
		$dimensions = $this->getPageDimensions();
		$hasBorder = false;
		$startY = $this->GetY();
		$this->getNumLines($row['cell1data'], 90);
		$this->calcularMontos($a);			
		if ($startY > 175) {			
			//$this->cerrarCuadro();
			$this->cerrarCuadroTotal();				
			if($this->total!= 0){
				$this->AddPage();
				$this->generarCabecera();
			}				
		}
	}
	//
	function calcularMontos($val){
		if($val['nro_tramite']='SALDO MES ANTERIOR'){
				
			$this->t9 = $this->t9 + $val['saldo'];	
		}
		if($val['motivo']!='rendido'){
			$this->t9 = $this->t9 + $val['monto'];	
		}else{
			$this->t10 = $this->t10 + $val['monto'];			
		}
		$this->t11 = $this->t11 + $val['importe_pago_liquido'];
	}		
	//revisarfinPagina pie
	function cerrarCuadroTotal(){
		$conf_par_tablewidths=array(5,30,13,15,12,30,15,12,10,14,14,12,10,10,10,10,12);			
		$this->tablealigns=array('R','R','R','R','R','R','R');		
		$this->tablenumbers=array(0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,2);
		$this->tableborders=array('','','','','','','','','LRTB');									
		$RowArray = array(
					't0' => '', 
					't1' => '',					
					't2' => '',
					't3' => '',
					't4' => '',	
					't5' => '',	
					't6' => '',	
					't7' => '',															
					'espacio' => 'TOTAL: ',
					't9' => $this->t9,
					't10' => $this->t10,
					't11' => $this->t11
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
		$this->Cell(0,5,"RENDICION MENSUAL DE CAJA",0,1,'C');					
		$this->Ln(3);
		/*
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
		$this->Cell($width_c2, $height, $this->objParam->getParametro('codigo'), 0, 0, 'L', true, '', 0, false, 'T', 'C');
		$this->Ln(5);
		
		$this->SetFont('', 'B',7);
		$this->SetFillColor(192,192,192, true);	
		$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->Cell($width_c1, $height, 'FECHA :', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->SetFont('', '',7);				
		$fecha=date_format(date_create($this->objParam->getParametro('fecha')),'d/m/Y');
		$this->Cell($width_c2, $height, $fecha, 0, 0, 'L', true, '', 0, false, 'T', 'C');
		$this->Ln(3);
		*/
		$this->Ln(6);
		$this->SetFont('','',4);
		$this->generarCabecera();
	}		
}
?>