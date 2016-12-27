<?php
class RProcesosPendientesXLS
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
        //ini_set('memory_limit','512M');
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
    function imprimeCabecera() {
        $this->docexcel->createSheet();
        $this->docexcel->getActiveSheet()->setTitle('Procesos Pendientes');
        $this->docexcel->setActiveSheetIndex(0);

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
        $styleTitulos4 = array(
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
                    'rgb' => '808080'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));

        //titulos

        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'PROCESOS PENDIENTES CONTABILIDAD' );
        $this->docexcel->getActiveSheet()->getStyle('A2:N2')->applyFromArray($styleTitulos1);
        $this->docexcel->getActiveSheet()->mergeCells('A2:N2');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,4,'Del: '.  $this->objParam->getParametro('fecha_ini').'   Al: '.  $this->objParam->getParametro('fecha_fin') );
        $this->docexcel->getActiveSheet()->getStyle('A4:N4')->applyFromArray($styleTitulos3);
        $this->docexcel->getActiveSheet()->mergeCells('A4:N4');

        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,5,'OBLIGACIONES DE PAGO' );
        $this->docexcel->getActiveSheet()->getStyle('A5:K5')->applyFromArray($styleTitulos2);
        $this->docexcel->getActiveSheet()->mergeCells('A5:K5');

        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11,5,'PLAN DE PAGO' );
        $this->docexcel->getActiveSheet()->getStyle('L5:O5')->applyFromArray($styleTitulos4);
        $this->docexcel->getActiveSheet()->mergeCells('L5:O5');

        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(45);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(45);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(45);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(45);
        $this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(45);
        $this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(19);
        $this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(23);
        $this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(25);



        $this->docexcel->getActiveSheet()->getStyle('A6:N6')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A6:K6')->applyFromArray($styleTitulos2);
        $this->docexcel->getActiveSheet()->getStyle('L6:O6')->applyFromArray($styleTitulos4);



        //*************************************Cabecera*****************************************
        $this->docexcel->getActiveSheet()->setCellValue('A6','Nº');
        $this->docexcel->getActiveSheet()->setCellValue('B6','N° TRAMITE');
        $this->docexcel->getActiveSheet()->setCellValue('C6','PROVEEDOR');
        $this->docexcel->getActiveSheet()->setCellValue('D6','FUNCIONARIO SOLICITANTE');
        $this->docexcel->getActiveSheet()->setCellValue('E6','JUSTIFICACION');
        $this->docexcel->getActiveSheet()->setCellValue('F6','TOTAL');
        $this->docexcel->getActiveSheet()->setCellValue('G6','MONEDA');
        $this->docexcel->getActiveSheet()->setCellValue('H6','FECHA');
        $this->docexcel->getActiveSheet()->setCellValue('I6','ESTADO');
        $this->docexcel->getActiveSheet()->setCellValue('J6','USUARIO REGISTRO');
        $this->docexcel->getActiveSheet()->setCellValue('K6','DEPARTAMENTO');
        $this->docexcel->getActiveSheet()->setCellValue('L6','N° CUOTA');
        $this->docexcel->getActiveSheet()->setCellValue('M6','ESTADO PLAN DE PAGO');
        $this->docexcel->getActiveSheet()->setCellValue('N6','LIQUIDO PAGABLE');
        $this->docexcel->getActiveSheet()->setCellValue('O6','FECHA TENTATIVA DE PAGO');


    }
    function generarDatos()
    {
        $styleTitulos3 = array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
        );
        $this->numero = 1;
        $fila = 7;
        $datos = $this->objParam->getParametro('datos');
        $this->imprimeCabecera(0);

        foreach ( $datos  as $value)
        {
            if($value['estado_pago'] != 'devengado' && $value['estado_pago'] != 'pagado'&&
                $value['estado_pago'] != '' && $value['estado_pago'] != 'pago_exterior') {
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $this->numero);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['num_tramite']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['desc_proveedor']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['desc_funcionario1']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['obs']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['total_pago']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['moneda']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['fecha']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['estado']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $value['nombre']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $value['nombre_depto']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, $value['nro_cuota']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, $value['estado_pago']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila, $value['liquido_pagable']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila, $value['fecha_tentativa']);
                $this->docexcel->getActiveSheet()->getStyle("H$fila:H$fila")->applyFromArray($styleTitulos3);
                $this->docexcel->getActiveSheet()->getStyle("M$fila:M$fila")->applyFromArray($styleTitulos3);
                $this->docexcel->getActiveSheet()->getStyle("O$fila:O$fila")->applyFromArray($styleTitulos3);

                $fila++;

                $this->docexcel->getActiveSheet()->getStyle("F$fila:F$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat :: FORMAT_NUMBER_COMMA_SEPARATED1);
                $this->docexcel->getActiveSheet()->getStyle("N$fila:N$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat :: FORMAT_NUMBER_COMMA_SEPARATED1);

                $this->numero++;
            }

        }

    }
    function generarReporte(){

        //$this->docexcel->setActiveSheetIndex(0);
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);


    }
}
?>