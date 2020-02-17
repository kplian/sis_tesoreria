<!--
*	ISSUE   FORK	     Fecha 		     Autor		        Descripcion
*  #56     ENDETR       17/02/2020      Manuel Guerra      cambio de fechas(periodo) de un documento en la rendcion
-->
<?php

class rEntregaEfectivo extends ReportePDF{

    //
    function datosHeader () {
        $this->ancho_hoja = $this->getPageWidth() - PDF_MARGIN_LEFT - PDF_MARGIN_RIGHT-10;
        $this->SetMargins(10, 17, 10,10);
    }
    //
    function Header() {
    }
    //
    function generarReporte($datos) {
        $this->AddPage();
        if ($datos->getParameter('codigo_proc') == 'INGEFE'){
            $this->datos= 'RECIBO DE INGRESO DE CAJA';
            $this->de = 'PAGADO POR:';
            $this->a ='RECIBIDO POR:';
        }else{
            $this->datos= 'RECIBO DE ENTREGA EN CAJA';
            $this->de = 'A FAVOR DE:';
            $this->a ='PAGADO POR:';
        }

        $this->fecha = $datos->getParameter('fecha_entrega');
        $this->moneda = $datos->getParameter('moneda');
        $this->nro_tramite = $datos->getParameter('nro_tramite');
        $this->codigo = $datos->getParameter('codigo');
        $this->cajero = $datos->getParameter('cajero');
        $this->nombre_unidad = $datos->getParameter('nombre_unidad');
        $this->solicitante = $datos->getParameter('solicitante');
        $this->motivo = $datos->getParameter('motivo');
        $this->monto = $datos->getParameter('monto');
        if($datos->getParameter('superior') != null){
            $this->mensaje = 'El funcionario solicitante esta inactivo, el responsable sera el inmediato superior  '. $datos->getParameter('superior') ;
            $this->superior = $datos->getParameter('superior');
            $this->cajero = $datos->getParameter('cajero');
            $this->solicitante = $datos->getParameter('solicitante');
        }else{
            $this->mensaje = '';
            $this->cajero = $datos->getParameter('cajero');
            $this->solicitante = $datos->getParameter('solicitante');
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
?>