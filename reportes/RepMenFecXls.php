<?php
class RepMenFecXls
{
	private $docexcel;
	private $objWriter;
	private $numero;
	private $equivalencias=array();
	private $objParam;
	public  $url_archivo;
	function __construct(CTParametro $objParam)
	{
		$this->objParam = $objParam;
		$this->url_archivo = "../../../reportes_generados/".$this->objParam->getParametro('nombre_archivo');
		set_time_limit(400);
		$cacheMethod = PHPExcel_CachedObjectStorageFactory:: cache_to_phpTemp;
		$cacheSettings = array('memoryCacheSize'  => '10MB');
		PHPExcel_Settings::setCacheStorageMethod($cacheMethod, $cacheSettings);
		$this->docexcel = new PHPExcel();
		$this->docexcel->getProperties()->setCreator("PXP")
			->setLastModifiedBy("PXP")
			->setTitle($this->objParam->getParametro('titulo_archivo'))
			->setSubject($this->objParam->getParametro('titulo_archivo'))
			->setDescription('Reporte "'.$this->objParam->getParametro('titulo_archivo').'", generado por el framework PXP')
			->setKeywords("office 2007 openxml php")
			->setCategory("Report File");
		$this->equivalencias=array( 0=>'A',1=>'B',2=>'C',3=>'D',4=>'E',5=>'F',6=>'G',7=>'H',8=>'I',
									9=>'J',10=>'K',11=>'L',12=>'M',13=>'N',14=>'O',15=>'P',16=>'Q',17=>'R',
									18=>'S',19=>'T',20=>'U',21=>'V',22=>'W',23=>'X',24=>'Y',25=>'Z',
									26=>'AA',27=>'AB',28=>'AC',29=>'AD',30=>'AE',31=>'AF',32=>'AG',33=>'AH',
									34=>'AI',35=>'AJ',36=>'AK',37=>'AL',38=>'AM',39=>'AN',40=>'AO',41=>'AP',
									42=>'AQ',43=>'AR',44=>'AS',45=>'AT',46=>'AU',47=>'AV',48=>'AW',49=>'AX',
									50=>'AY',51=>'AZ',
									52=>'BA',53=>'BB',54=>'BC',55=>'BD',56=>'BE',57=>'BF',58=>'BG',59=>'BH',
									60=>'BI',61=>'BJ',62=>'BK',63=>'BL',64=>'BM',65=>'BN',66=>'BO',67=>'BP',
									68=>'BQ',69=>'BR',70=>'BS',71=>'BT',72=>'BU',73=>'BV',74=>'BW',75=>'BX',
									76=>'BY',77=>'BZ');
	}
	//
	function imprimeCabecera() {
		$this->docexcel->createSheet();		
		$this->docexcel->getActiveSheet()->setTitle('Libro de Bancos');	
		$this->docexcel->setActiveSheetIndex(0);
		$datos = $this->objParam->getParametro('datos');
        $styleTitulos1 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 12,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
        );
        $styleTitulos2 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial',
                'color' => array(
					'rgb' => 'FFFFFF'
                )
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '0066CC'
                )
            ),
            'borders' => array(
                'allborders' => array(
					'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));
		$styleTitulos3 = array(
			'font'  => array(
				'bold'  => true,
				'size'  => 11,
				'name'  => 'Arial'
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
			),
		);
		
		$this->docexcel->getActiveSheet()->getStyle('B2:F2')->applyFromArray($styleTitulos1);
		$this->docexcel->getActiveSheet()->mergeCells('B2:F2');
		
		$this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(12);
		$this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(60);
		$this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(30);
		$this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(30);
		

		$this->docexcel->getActiveSheet()->getStyle('B5:F5')->getAlignment()->setWrapText(true);
		$this->docexcel->getActiveSheet()->getStyle('B5:F5')->applyFromArray($styleTitulos2);
		//*************************************Cabecera*****************************************
		$this->docexcel->getActiveSheet()->setCellValue('B5','Nº');
		$this->docexcel->getActiveSheet()->setCellValue('C5','FECHA');
		$this->docexcel->getActiveSheet()->setCellValue('D5','NRO TRAMITE');
		$this->docexcel->getActiveSheet()->setCellValue('E5','MONTO INGRESO');
		$this->docexcel->getActiveSheet()->setCellValue('F5','MONTO SALIDA');
		
	}
	//
	function generarDatos()
	{
		$styleTitulos3 = array(
			'font'  => array(
				'bold'  => true,
				'size'  => 12,
				'name'  => 'Arial',
				'color' => array(
					'rgb' => 'FFFFFF'
				)
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
			),
			'fill' => array(
				'type' => PHPExcel_Style_Fill::FILL_SOLID,
				'color' => array(
					'rgb' => '707A82'
				)
			),
			'borders' => array(
				'allborders' => array(
					'style' => PHPExcel_Style_Border::BORDER_THIN
				)
			)
		);
		$this->numero = 1;
		$fila = 6;
		$datos = $this->objParam->getParametro('datos');
		
		$this->imprimeCabecera(0);
		
		foreach ($datos as $value){

			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $this->numero);
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['fecha']);
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, trim($value['nro_tramite']));
			if($value['nro_tramite']=='SALDO ANTERIOR'){
				if($value['monto']>=0){
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['monto']);	
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, 0);	
				}else{
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, 0);	
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['monto']*-1);	
				}			
			}else{							
				if($value['motivo']=='contabilizado' || $value['motivo']=='ingresado'){					
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['monto']);		
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, 0);
				}else{
					if($value['motivo']=='rendido'){
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, 0);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['monto']);	
					}				
				}
			}
			$fila++;
			$this->numero++;
			
		}
				
		$this->docexcel->getActiveSheet()->getStyle('B'.($fila+1).':F'.($fila+1).'')->applyFromArray($styleTitulos3);				
								
		$this->docexcel->getActiveSheet()->getStyle('E'.(6).':E'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->getStyle('F'.(6).':F'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
		
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,$fila+1,'TOTAL');
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,$fila+1,'=SUM(E6:E'.($fila-1).')');
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,$fila+1,'=SUM(F6:F'.($fila-1).')');

		
		$deb = 'SUM(E6:E'.($fila-1).')';	
		$hab = 'SUM(F6:F'.($fila-1).')';	
		$vari = '=+'.$deb.'-'.$hab;
	
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,$fila+3,'SALDO');
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,$fila+3,$vari);
		
		//var_dump($fila-1);				
	}
	//
	function generarReporte(){
		//$this->docexcel->setActiveSheetIndex(0);
		$this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
		$this->objWriter->save($this->url_archivo);
		$this->imprimeCabecera(0);
	}
	
	function generarResultado ($sheet,$a){
		$this->docexcel->createSheet($sheet);
		$this->docexcel->setActiveSheetIndex(0);
		$this->imprimeCabecera($sheet,'TOTAL');
		$this->docexcel->getActiveSheet()->setTitle('TOTALES');
		$this->docexcel->getActiveSheet()->setCellValue('E5','TOTAL');
		$this->docexcel->getActiveSheet()->setCellValue('F5',$a);
		
		
		
		
	}
}
?>