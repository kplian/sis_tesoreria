<?php

include_once(dirname(__FILE__).'/../../lib/PHPWord/src/PhpWord/Autoloader.php');
\PhpOffice\PhpWord\Autoloader::register();
Class RMemoCajaChica {
	
	private $dataSource;
    
    public function setDataSource(DataSource $dataSource) {
        $this->dataSource = $dataSource;
    }
    
    public function getDataSource() {
        return $this->dataSource;
    }

    function write($fileName) {
    	
		$phpWord = new \PhpOffice\PhpWord\PhpWord();
		$document = $phpWord->loadTemplate(dirname(__FILE__).'/template_memo_caja_chica.docx');
		setlocale(LC_ALL,"es_ES@euro","es_ES","esp");
		$document->setValue('CITE', $this->getDataSource()->getParameter('num_memo')); // On section/content
		$document->setValue('FECHA', $this->getDataSource()->getParameter('fecha')); // On section/content
		$document->setValue('NUMEROCHEQUE', $this->getDataSource()->getParameter('nro_cheque')); // On section/content
		$document->setValue('CODIGO', $this->getDataSource()->getParameter('codigo')); // On section/content
		$document->setValue('APROBADOR', $this->getDataSource()->getParameter('aprobador')); // On section/content
		$document->setValue('CARGOAPROBADOR', $this->getDataSource()->getParameter('cargo_aprobador')); // On section/content
		$document->setValue('CAJERO', $this->getDataSource()->getParameter('cajero')); // On section/content
		$document->setValue('CARGOCAJERO', $this->getDataSource()->getParameter('cargo_cajero')); // On section/content
		$document->setValue('IMPORTECHEQUE', $this->getDataSource()->getParameter('importe_cheque')); // On section/content
		$document->setValue('IMPORTELITERAL', $this->getDataSource()->getParameter('importe_literal')); // On section/content
		$document->setValue('BANCO', 'BANCO UNION S.A.'); // On section/content
		
		$document->saveAs($fileName);
		        
    }
    
        
}
?>