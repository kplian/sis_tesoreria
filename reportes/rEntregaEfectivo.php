<?php
/*
ISSUE      FORK       FECHA:              AUTOR                 DESCRIPCION
#64      ETR       18/03/2020        MANUEL GUERRA           mejora en reporte de entrega de efectivo
*/
class rEntregaEfectivo extends ReportePDF {

    //
    function datosHeader ($detalle) {
        $this->ancho_hoja = $this->getPageWidth() - PDF_MARGIN_LEFT - PDF_MARGIN_RIGHT-10;
        $this->SetMargins(10, 17, 10,10);
        $this->detalle = $detalle;

    }
    //
    function Header() {
    }
    //
    function generarReporte() {

        $this->AddPage();
        $datos = $this->detalle;
       // var_dump($this->detalle[0]['fecha_entrega']);
        if ($this->detalle[0]['codigo_proc'] == 'INGEFE'){
            $this->datos= 'RECIBO DE INGRESO DE CAJA';
            $this->de = 'PAGADO POR:';
            $this->a ='RECIBIDO POR:';
        }else{
            $this->datos= 'RECIBO DE ENTREGA EN CAJA';
            $this->de = 'A FAVOR DE:';
            $this->a ='PAGADO POR:';
        }

        $this->fecha = $this->detalle[0]['fecha_entrega'];
        $this->moneda = $this->detalle[0]['moneda'];
        $this->nro_tramite = $this->detalle[0]['nro_tramite'];
        $this->codigo = $this->detalle[0]['codigo'];
        $this->cajero = $this->detalle[0]['cajero'];
        $this->nombre_unidad = $this->detalle[0]['nombre_unidad'];
        $this->solicitante = $this->detalle[0]['solicitante'];
        $this->motivo = $this->detalle[0]['motivo'];
        $this->monto =$this->detalle[0]['monto'];
        if($this->detalle[0]['superior'] != null){
            $this->mensaje = 'El funcionario solicitante esta inactivo, el responsable sera el inmediato superior  '. $this->detalle[0]['superior'];;
            $this->superior = $this->detalle[0]['superior'];
            $this->cajero = $this->detalle[0]['cajero'];
            $this->solicitante = $this->detalle[0]['solicitante'];
        }else{
            $this->mensaje = '';
            $this->cajero = $this->detalle[0]['cajero'];
            $this->solicitante = $this->detalle[0]['solicitante'];
        }
        ob_start();
        include(dirname(__FILE__).'/../reportes/tpl/EntregaEfect.php');
        $content = ob_get_clean();
        $this->writeHTML($content, false, false, false, false, '');
    }
    //
    function Footer() {
        $this->setY(-15);
        $ormargins = $this->getOriginalMargins();
        $this->SetTextColor(0, 0, 0);
        //set style for cell border
        $line_width = 0.85 / $this->getScaleFactor();
        $this->SetLineStyle(array('width' => $line_width, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
        $ancho = round(($this->getPageWidth() - $ormargins['left'] - $ormargins['right']) / 3);
        $this->Ln(2);
        $cur_y = $this->GetY();
        $this->Cell($ancho, 0, 'Usuario: '.$_SESSION['_LOGIN'], '', 0, 'L');
        $pagenumtxt = 'Página'.' '.$this->getAliasNumPage().' de '.$this->getAliasNbPages();
        $this->Cell($ancho, 0, $pagenumtxt, '', 0, 'C');
        $this->Cell($ancho, 0, $_SESSION['_REP_NOMBRE_SISTEMA'], '', 0, 'R');
        $this->Ln();
        $fecha_rep = date("d-m-Y H:i:s");
        $this->Cell($ancho, 0, "Fecha Impresion : ".$fecha_rep, '', 0, 'L');
        $this->Ln($line_width);
        $this->Ln();
        $barcode = $this->getBarcode();
        $style = array(
            'position' => $this->rtl?'R':'L',
            'align' => $this->rtl?'R':'L',
            'stretch' => false,
            'fitwidth' => true,
            'cellfitalign' => '',
            'border' => false,
            'padding' => 0,
            'fgcolor' => array(0,0,0),
            'bgcolor' => false,
            'text' => false,
            'position' => 'R'
        );
        $this->write1DBarcode($barcode, 'C128B', $ancho*2, $cur_y + $line_width+5, '', (($this->getFooterMargin() / 3) - $line_width), 0.3, $style, '');
    }

}
