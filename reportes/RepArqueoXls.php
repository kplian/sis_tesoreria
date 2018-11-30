<?php
class RepArqueoXls
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
		$this->printerConfiguration();
	}
	function datosHeader ($detalle) {
		$this->datos_detalle = $detalle;
	}	
	//
	function imprimeCabecera() {
		$this->docexcel->createSheet();		
		$this->docexcel->getActiveSheet()->setTitle('Arqueo');	
		$this->docexcel->setActiveSheetIndex(0);
		$styleTitulos1 = array(
			'font'  => array(
				'bold'  => true,
				'size'  => 16,
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
				'size'  => 12,
				'name'  => 'Arial',
				/*'color' => array(
					'rgb' => '0066CC'
				)*/
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_RIGHT,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
			),
			
			'borders' => array(
				'allborders' => array(
					'style' => PHPExcel_Style_Border::BORDER_THIN
				),
				'outline' => array(
					'style' => PHPExcel_Style_Border::BORDER_THIN
				),
			)
		);
		$styleTitulos3 = array(
			'font'  => array(
				'bold'  => FALSE,
				'size'  => 12,
				'name'  => 'Arial'
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_RIGHT,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
			),
		);
		$styleTitulos4 = array(
			'font'  => array(
				'bold'  => true,
				'size'  => 12,
				'name'  => 'Arial',
				'underline' => PHPExcel_Style_Font::UNDERLINE_SINGLE
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_RIGHT,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
			),
		);
		$styleTitulos5 = array(
			'font'  => array(
				'bold'  => true,
				'size'  => 11
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
			),
		);
		$styleTitulos6 = array(
			'font'  => array(
				'bold'  => true,
				'size'  => 11,
				'color' => array(
					'rgb' => '0F66CF'
				)	
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
			),
		);
		$datos = $this->datos_detalle;
		//var_dump($datos[0]);
		$ciudad = explode(" ", $datos[0]['nombre']);
		$this->docexcel->getActiveSheet()->getStyle('E3:E3')->applyFromArray($styleTitulos1);
		$this->docexcel->getActiveSheet()->setCellValue('E3','ARQUEO FONDO ROTATORIO');	
		$this->docexcel->getActiveSheet()->getStyle('D5:G7')->applyFromArray($styleTitulos3);	
		
		$this->docexcel->getActiveSheet()->setCellValue('D5','Arqueo del fondo rotatorio en poder del Sr.(a):');		
		$this->docexcel->getActiveSheet()->mergeCells('E5:H5');
		$this->docexcel->getActiveSheet()->getStyle('E5:H5')->applyFromArray($styleTitulos5);
		$this->docexcel->getActiveSheet()->setCellValue('E5',$datos[0]['cajero']);
		
		$this->docexcel->getActiveSheet()->setCellValue('D6','Efectuado por:');
		$this->docexcel->getActiveSheet()->mergeCells('E6:G6');
		$this->docexcel->getActiveSheet()->getStyle('E6:G6')->applyFromArray($styleTitulos5);
		$this->docexcel->getActiveSheet()->setCellValue('E6',$datos[0]['codigo']);
		
		$this->docexcel->getActiveSheet()->setCellValue('D7','Practicando en la ciudad de:');
		$this->docexcel->getActiveSheet()->mergeCells('E7:F7');
		$this->docexcel->getActiveSheet()->getStyle('E7:F7')->applyFromArray($styleTitulos5);
		$this->docexcel->getActiveSheet()->setCellValue('E7',$ciudad[count($ciudad)-1]);
		
		
		$this->docexcel->getActiveSheet()->setCellValue('G7','A horas:');
		$this->docexcel->getActiveSheet()->mergeCells('H7:H7');
		$this->docexcel->getActiveSheet()->getStyle('H7:H7')->applyFromArray($styleTitulos5);
		$this->docexcel->getActiveSheet()->setCellValue('H7',date("h:i"));
		
		$this->docexcel->getActiveSheet()->getStyle('B9:G11')->applyFromArray($styleTitulos4);
		$this->docexcel->getActiveSheet()->setCellValue('B9','EFECTIVO:');		
		$this->docexcel->getActiveSheet()->setCellValue('B11','BILLETES');
		$this->docexcel->getActiveSheet()->setCellValue('G11','MONEDAS:');
		$this->docexcel->getActiveSheet()->getStyle('B12:K12')->applyFromArray($styleTitulos3);
		$this->docexcel->getActiveSheet()->setCellValue('B12','Cantidad');		
		$this->docexcel->getActiveSheet()->setCellValue('C12','Denominacion');
		$this->docexcel->getActiveSheet()->setCellValue('D12','Importe');
		$this->docexcel->getActiveSheet()->setCellValue('E12','En caja fuerte');
		
		$this->docexcel->getActiveSheet()->setCellValue('F12','Cantidad');		
		$this->docexcel->getActiveSheet()->setCellValue('G12','Denominacion');
		$this->docexcel->getActiveSheet()->setCellValue('H12','Importe');
		$this->docexcel->getActiveSheet()->setCellValue('I12','En caja fuerte');
		
		$this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(15);
		
		$this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(15);	
		$this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(15);
		
		$this->docexcel->getActiveSheet()->getStyle('B13:B21')->applyFromArray($styleTitulos2);		
		$this->docexcel->getActiveSheet()->getStyle('C13:C21')->applyFromArray($styleTitulos2);
		$this->docexcel->getActiveSheet()->getStyle('D13:D21')->applyFromArray($styleTitulos2);
		$this->docexcel->getActiveSheet()->getStyle('E13:E21')->applyFromArray($styleTitulos2);
		$this->docexcel->getActiveSheet()->getStyle('F13:F21')->applyFromArray($styleTitulos2);	
		
		$this->docexcel->getActiveSheet()->getStyle('C13:C13')->getNumberFormat()->setFormatCode('#,##0.00');				
		$this->docexcel->getActiveSheet()->setCellValue('C13','10,00');
		$this->docexcel->getActiveSheet()->getStyle('C15:C15')->getNumberFormat()->setFormatCode('#,##0.00');		
		$this->docexcel->getActiveSheet()->setCellValue('C15','20,00');
		$this->docexcel->getActiveSheet()->getStyle('C17:C17')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->setCellValue('C17','50,00');
		$this->docexcel->getActiveSheet()->getStyle('C19:C19')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->setCellValue('C19','100,00');
		$this->docexcel->getActiveSheet()->getStyle('C21:C21')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->setCellValue('C21','200,00');
		
		$this->docexcel->getActiveSheet()->getStyle('G13:G23')->applyFromArray($styleTitulos2);
		$this->docexcel->getActiveSheet()->getStyle('H13:H23')->applyFromArray($styleTitulos2);
		$this->docexcel->getActiveSheet()->getStyle('I13:I23')->applyFromArray($styleTitulos2);
		
		$this->docexcel->getActiveSheet()->getStyle('G13:G13')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->setCellValue('G13','0,10');
		$this->docexcel->getActiveSheet()->getStyle('G15:G15')->getNumberFormat()->setFormatCode('#,##0.00');		
		$this->docexcel->getActiveSheet()->setCellValue('G15','0,20');
		$this->docexcel->getActiveSheet()->getStyle('G17:G17')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->setCellValue('G17','0,50');
		$this->docexcel->getActiveSheet()->getStyle('G19:G19')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->setCellValue('G19','1,00');
		$this->docexcel->getActiveSheet()->getStyle('G21:G21')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->setCellValue('G21','2,00');
		$this->docexcel->getActiveSheet()->getStyle('G23:G23')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->setCellValue('G23','5,00');
		//
		$this->docexcel->getActiveSheet()->setCellValue('C25','TOTAL BILLETES');
		$this->docexcel->getActiveSheet()->getStyle('D25:D25')->applyFromArray($styleTitulos5);
		$this->docexcel->getActiveSheet()->getStyle('D25:D25')->getNumberFormat()->setFormatCode('#,##0.00');							
		$this->docexcel->getActiveSheet()->getStyle('D13:D13')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->setCellValue('D13','=(B13*C13)');	
		$this->docexcel->getActiveSheet()->getStyle('D15:D15')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->setCellValue('D15','=(B15*C15)');
		$this->docexcel->getActiveSheet()->getStyle('D17:D17')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->setCellValue('D17','=(B17*C17)');
		$this->docexcel->getActiveSheet()->getStyle('D19:D19')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->setCellValue('D19','=(B19*C19)');
		$this->docexcel->getActiveSheet()->getStyle('D21:D21')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->setCellValue('D21','=(B21*C21)');		
		$this->docexcel->getActiveSheet()->setCellValue('D25','=SUM(D13:D21)');
		//
		$this->docexcel->getActiveSheet()->getStyle('E13:E25')->applyFromArray($styleTitulos6);
		$this->docexcel->getActiveSheet()->getStyle('E13:E13')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->getStyle('E15:E15')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->getStyle('E17:E17')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->getStyle('E19:E19')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->getStyle('E21:E21')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->setCellValue('E25','=SUM(E13:E21)');		
		//
		$this->docexcel->getActiveSheet()->setCellValue('G25','TOTAL MONEDAS');
		$this->docexcel->getActiveSheet()->getStyle('H25:H25')->applyFromArray($styleTitulos5);
		$this->docexcel->getActiveSheet()->getStyle('H25:H25')->getNumberFormat()->setFormatCode('#,##0.00');		
		$this->docexcel->getActiveSheet()->getStyle('H13:H13')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->setCellValue('H13','=(F13*G13)');
		$this->docexcel->getActiveSheet()->getStyle('H15:H15')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->setCellValue('H15','=(F15*G15)');
		$this->docexcel->getActiveSheet()->getStyle('H17:H17')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->setCellValue('H17','=(F17*G17)');
		$this->docexcel->getActiveSheet()->getStyle('H19:H19')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->setCellValue('H19','=(F19*G19)');
		$this->docexcel->getActiveSheet()->getStyle('H21:H21')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->setCellValue('H21','=(F21*G21)');
		$this->docexcel->getActiveSheet()->getStyle('H23:H23')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->setCellValue('H23','=(F23*G23)');
		$this->docexcel->getActiveSheet()->setCellValue('H25','=SUM(H13:H23)');
		//
		$this->docexcel->getActiveSheet()->getStyle('I13:I25')->applyFromArray($styleTitulos6);
		$this->docexcel->getActiveSheet()->getStyle('I13:I13')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->getStyle('I15:I15')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->getStyle('I17:I17')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->getStyle('I19:I19')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->getStyle('I21:I21')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->getStyle('I23:I23')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->setCellValue('I25','=SUM(I13:I23)');
		//TOTAL EFECTIVO SUMA MONEDAS -BILLETES
		$bil = 'SUM(D13:D21)';	
		$mon = 'SUM(H13:H23)';	
		$total = '=+'.$bil.'+'.$mon;		
		$this->docexcel->getActiveSheet()->setCellValue('D27','TOTAL EFECTIVO');
		$this->docexcel->getActiveSheet()->getStyle('F27:F27')->applyFromArray($styleTitulos5);
		$this->docexcel->getActiveSheet()->getStyle('F27:F27')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->setCellValue('F27',$total);
		//
		$this->docexcel->getActiveSheet()->setCellValue('D29','SALDO ANTERIOR');
		
		$this->docexcel->getActiveSheet()->setCellValue('D31','SALDO DESCARGO SALIDAS');
		$this->docexcel->getActiveSheet()->mergeCells('F31:F31');
		$this->docexcel->getActiveSheet()->getStyle('F31:F31')->applyFromArray($styleTitulos5);
		$this->docexcel->getActiveSheet()->getStyle('F31:F31')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->setCellValue('F31',$datos[0]['salida']);
		//
		$this->docexcel->getActiveSheet()->setCellValue('D33','SALDO DESCARGO INGRESOS');
		$this->docexcel->getActiveSheet()->mergeCells('F33:F33');
		$this->docexcel->getActiveSheet()->getStyle('F33:F33')->applyFromArray($styleTitulos5);
		$this->docexcel->getActiveSheet()->getStyle('F33:F33')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->setCellValue('F33',$datos[0]['ingreso']);
		//
		$this->docexcel->getActiveSheet()->setCellValue('D35','OTROS');
		$this->docexcel->getActiveSheet()->getStyle('F35:F35')->applyFromArray($styleTitulos5);
		$this->docexcel->getActiveSheet()->getStyle('F35:F35')->getNumberFormat()->setFormatCode('#,##0.00');
		//
		$this->docexcel->getActiveSheet()->setCellValue('D37','IMPORTE DE SISTEMA');
		$this->docexcel->getActiveSheet()->getStyle('F37:F37')->applyFromArray($styleTitulos5);
		$this->docexcel->getActiveSheet()->getStyle('F37:F37')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->setCellValue('F37',$datos[0]['saldo']);
		//
		$this->docexcel->getActiveSheet()->setCellValue('D39','DIFERENCIA');
		//$this->docexcel->getActiveSheet()->setCellValue('D41','DIFERENCIA');		
		$this->docexcel->getActiveSheet()->setCellValue('B43','EXPLICACION DE LA DIFERENCIA');
		//setlocale(LC_ALL,"es_ES");
		//$this->docexcel->getActiveSheet()->setCellValue('H71', strftime("%H:%M"));
		//
	}
	
	//
	function generarReporte(){
		$this->docexcel->setActiveSheetIndex(0);
		$this->imprimeTitulo($sheet,0);
		$this->imprimeCabecera(0);
		$this->firmas();
		//ingresos
		$this->docexcel->setActiveSheetIndex(1);
		$this->imprimeTitulo($sheet,1);
		$this->imprimeCabeceraB();
		$this->generarDatos();
		//salidas
		$this->docexcel->setActiveSheetIndex(2);
		$this->imprimeTitulo($sheet,2);
		$this->imprimeCabeceraC();
		$this->generarDatosC();
		//pendientes
		$this->docexcel->setActiveSheetIndex(3);
		$this->imprimeTitulo($sheet,3);
		$this->imprimeCabeceraD();
		$this->generarDatosD();
		// Set active sheet index to the first sheet, so Excel opens this as the first sheet
		//$this->docexcel->setActiveSheetIndex(0);
		$this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
		$this->objWriter->save($this->url_archivo);
	}
	//
	function printerConfiguration(){
		$this->docexcel->setActiveSheetIndex(0)->getPageSetup()->setOrientation(PHPExcel_Worksheet_PageSetup::ORIENTATION_PORTRAIT);
		$this->docexcel->setActiveSheetIndex(0)->getPageSetup()->setPaperSize(PHPExcel_Worksheet_PageSetup::PAPERSIZE_LETTER);
		$this->docexcel->setActiveSheetIndex(0)->getPageSetup()->setFitToWidth(1);
		$this->docexcel->setActiveSheetIndex(0)->getPageSetup()->setFitToHeight(0);
	}
	
	function firmas(){
		$styleTitulos3 = array(
			'font'  => array(
				'bold'  => true,
				'size'  => 10,
				'name'  => 'Arial',				
			),						
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
			),
		);		
		$this->docexcel->getActiveSheet()->setCellValue('B50','El fondo indicado representa la totalidad de los valores propiedad de ETR, confiados a mi custodia, los cuales');
		$this->docexcel->getActiveSheet()->setCellValue('B51','fueron contados en mi presencia y devueltos a mi entera satisfacción');
		
		setlocale(LC_ALL,"es_ES");
		$this->docexcel->getActiveSheet()->setCellValue('G54', strftime("%A %d de %B del %Y"));
		
		$this->docexcel->getActiveSheet()->getStyle('D60:G60')->applyFromArray($styleTitulos3);	
		$this->docexcel->getActiveSheet()->setCellValue('D60','RESPONSABLE DEL ARQUEO');
		$this->docexcel->getActiveSheet()->setCellValue('G60','RESPONSABLE DEL FONDO');
	}
	
	function imprimeTitulo($sheet,$i) {
		//Logo
		$objDrawing = new PHPExcel_Worksheet_Drawing();
		$objDrawing->setName('Logo');
		$objDrawing->setDescription('Logo');
		$objDrawing->setPath(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO']);
		$objDrawing->setHeight(50);
		$objDrawing->setWorksheet($this->docexcel->setActiveSheetIndex($i));
	}
	//
	function imprimeCabeceraB() {
		$this->docexcel->createSheet();		
		$this->docexcel->getActiveSheet()->setTitle('Salidas');	
		$this->docexcel->setActiveSheetIndex(1);		
        $styleTitulos1 = array(
            'font'  => array(
                'bold'  => false,
                'size'  => 15
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
        );
        $styleTitulos2 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 11,
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
		$this->docexcel->getActiveSheet()->getStyle('B3:E3')->applyFromArray($styleTitulos1);
		$this->docexcel->getActiveSheet()->mergeCells('D3:E3');
		$this->docexcel->getActiveSheet()->setCellValue('D3','ARQUEO FONDO ROTATORIO');	
		$this->docexcel->getActiveSheet()->getStyle('B4:E4')->applyFromArray($styleTitulos1);
		$this->docexcel->getActiveSheet()->mergeCells('D4:E4');
		$this->docexcel->getActiveSheet()->setCellValue('D4','DOCUMENTOS DE DESCARGO-SALIDAS');	
		$this->docexcel->getActiveSheet()->getStyle('F1:F1')->applyFromArray($styleTitulos1);
		$this->docexcel->getActiveSheet()->setCellValue('F1','ANEXO 1');
		$this->docexcel->getActiveSheet()->getStyle('B7:F7')->getAlignment()->setWrapText(true);
		$this->docexcel->getActiveSheet()->getStyle('B7:F7')->applyFromArray($styleTitulos2);
		//*************************************Cabecera*****************************************
		$this->docexcel->getActiveSheet()->setCellValue('B7','Nº');
		$this->docexcel->getActiveSheet()->setCellValue('C7','FECHA');
		$this->docexcel->getActiveSheet()->setCellValue('D7','NRO TRAMITE');
		$this->docexcel->getActiveSheet()->setCellValue('E7','MOTIVO');
		$this->docexcel->getActiveSheet()->setCellValue('F7','SALIDAS');
		//$this->docexcel->getActiveSheet()->setCellValue('G7','MONTO SALIDA');
			
		$this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(12);
		$this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(35);
		$this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(55);
		$this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(20);
		//$this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(25);	
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
		$fila = 8;
		$datos = $this->objParam->getParametro('datos');	
		//var_dump($datos);	
		$this->imprimeCabeceraB(0);
		
		foreach ($datos as $value){			
			if ($value['estado_r']!='ingreso' && $value['nom_proceso']!='proceso') {
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $this->numero);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['fecha']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['nro_tramite']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, trim($value['motivo']));				
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, trim($value['monto']));	
				$fila++;
				$this->numero++;
			}			
		}				
		$this->docexcel->getActiveSheet()->getStyle('B'.($fila+1).':F'.($fila+1).'')->applyFromArray($styleTitulos3);										
		$this->docexcel->getActiveSheet()->getStyle('F'.(8).':F'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');

		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,$fila+1,'TOTAL');
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,$fila+1,'=SUM(F8:F'.($fila-1).')');	
	}
	//
	function imprimeCabeceraC() {
		//$this->docexcel->createSheet();		
		$this->docexcel->getActiveSheet()->setTitle('Ingresos');	
		$this->docexcel->setActiveSheetIndex(2);		
        $styleTitulos1 = array(
            'font'  => array(
                'bold'  => false,
                'size'  => 15
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
        );
        $styleTitulos2 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 11,
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
		$this->docexcel->getActiveSheet()->getStyle('B3:E3')->applyFromArray($styleTitulos1);
		$this->docexcel->getActiveSheet()->mergeCells('D3:E3');
		$this->docexcel->getActiveSheet()->setCellValue('D3','ARQUEO FONDO ROTATORIO');	
		$this->docexcel->getActiveSheet()->getStyle('B4:E4')->applyFromArray($styleTitulos1);
		$this->docexcel->getActiveSheet()->mergeCells('D4:E4');
		$this->docexcel->getActiveSheet()->setCellValue('D4','DOCUMENTOS DE DESCARGO-INGRESOS');	
		$this->docexcel->getActiveSheet()->getStyle('F1:F1')->applyFromArray($styleTitulos1);
		$this->docexcel->getActiveSheet()->setCellValue('F1','ANEXO 2');
		$this->docexcel->getActiveSheet()->getStyle('B7:F7')->getAlignment()->setWrapText(true);
		$this->docexcel->getActiveSheet()->getStyle('B7:F7')->applyFromArray($styleTitulos2);
		//*************************************Cabecera*****************************************
		$this->docexcel->getActiveSheet()->setCellValue('B7','Nº');
		$this->docexcel->getActiveSheet()->setCellValue('C7','FECHA');
		$this->docexcel->getActiveSheet()->setCellValue('D7','NRO TRAMITE');
		$this->docexcel->getActiveSheet()->setCellValue('E7','MOTIVO');
		$this->docexcel->getActiveSheet()->setCellValue('F7','INGRESOS');
		//$this->docexcel->getActiveSheet()->setCellValue('G7','MONTO SALIDA');
			
		$this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(12);
		$this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(35);
		$this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(50);
		$this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(20);
		//$this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(25);	
	}
	//
	function generarDatosC()
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
		$fila = 8;
		$datos = $this->objParam->getParametro('datos');
		//var_dump($datos);		
		$this->imprimeCabeceraC(0);
		foreach ($datos as $value){			
			if ($value['estado_r']=='ingreso' && $value['nom_proceso']!='proceso') {
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $this->numero);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['fecha']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['nro_tramite']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, trim($value['motivo_ing']));				
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, trim($value['monto']));	
				$fila++;
				$this->numero++;
			}			
		}				
		$this->docexcel->getActiveSheet()->getStyle('B'.($fila+1).':F'.($fila+1).'')->applyFromArray($styleTitulos3);										
		$this->docexcel->getActiveSheet()->getStyle('F'.(8).':F'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');

		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,$fila+1,'TOTAL');
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,$fila+1,'=SUM(F8:F'.($fila-1).')');	
	}
	//
	function imprimeCabeceraD() {
		//$this->docexcel->createSheet();		
		$this->docexcel->getActiveSheet()->setTitle('Entregados');	
		$this->docexcel->setActiveSheetIndex(3);		
		$styleTitulos1 = array(
			'font'  => array(
			    'bold'  => false,
			    'size'  => 15
			),
			'alignment' => array(
			    'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
			    'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
			),
		);
		$styleTitulos2 = array(
			'font'  => array(
			    'bold'  => true,
			    'size'  => 11,
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
			)
		);
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
		$this->docexcel->getActiveSheet()->getStyle('B3:E3')->applyFromArray($styleTitulos1);
		$this->docexcel->getActiveSheet()->mergeCells('D3:E3');
		$this->docexcel->getActiveSheet()->setCellValue('D3','ARQUEO FONDO ROTATORIO');	
		$this->docexcel->getActiveSheet()->getStyle('B4:E4')->applyFromArray($styleTitulos1);
		$this->docexcel->getActiveSheet()->mergeCells('D4:E4');
		$this->docexcel->getActiveSheet()->setCellValue('D4','ENTREGADOS');	
		$this->docexcel->getActiveSheet()->getStyle('F1:F1')->applyFromArray($styleTitulos1);
		$this->docexcel->getActiveSheet()->setCellValue('F1','ANEXO 3');
		$this->docexcel->getActiveSheet()->getStyle('B7:F7')->getAlignment()->setWrapText(true);
		$this->docexcel->getActiveSheet()->getStyle('B7:F7')->applyFromArray($styleTitulos2);
		//*************************************Cabecera*****************************************
		$this->docexcel->getActiveSheet()->setCellValue('B7','Nº');
		$this->docexcel->getActiveSheet()->setCellValue('C7','FECHA');
		$this->docexcel->getActiveSheet()->setCellValue('D7','NRO TRAMITE');
		$this->docexcel->getActiveSheet()->setCellValue('E7','MOTIVO');
		$this->docexcel->getActiveSheet()->setCellValue('F7','MONTO');
		//$this->docexcel->getActiveSheet()->setCellValue('G7','MONTO SALIDA');
			
		$this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(12);
		$this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(35);
		$this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(50);
		$this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(20);
		//$this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(25);	
	}
	//
	function generarDatosD()
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
		$fila = 8;
		$datos = $this->objParam->getParametro('datos');
		//var_dump($datos);		
		$this->imprimeCabeceraD(0);
		foreach ($datos as $value){			
			if ($value['nom_proceso']=='proceso') {
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $this->numero);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['fecha']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['nro_tramite']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, trim($value['motivo']));				
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, trim($value['monto']));	
				$fila++;
				$this->numero++;
			}			
		}				
		$this->docexcel->getActiveSheet()->getStyle('B'.($fila+1).':F'.($fila+1).'')->applyFromArray($styleTitulos3);										
		$this->docexcel->getActiveSheet()->getStyle('F'.(8).':F'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');

		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,$fila+1,'TOTAL');
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,$fila+1,'=SUM(F8:F'.($fila-1).')');	
	}
}
?>