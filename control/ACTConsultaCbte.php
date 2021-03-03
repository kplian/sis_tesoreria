<?php
/**
 * @package pXP
 * @file ACTChequera.php
 * @author  Gonzalo Sarmiento Sejas
 * @date 24-04-2013 18:54:03
 * @description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */

class ACTConsultaCbte extends ACTbase
{

    function listaConsultaCbte()
    {
        $this->objParam->defecto('ordenacion', 'id_int_comprobante');
        $this->objParam->defecto('dir_ordenacion', 'asc');
        $this->objParam->addFiltro("(incbte.temporal = ''no'' or (incbte.temporal = ''si'' and vbregional = ''si''))");

        if($this->objParam->getParametro('id_deptos')!=''){
            $this->objParam->addFiltro("incbte.id_depto in (".$this->objParam->getParametro('id_deptos').")");
        }
        if($this->objParam->getParametro('id_gestion')!=''){
            $this->objParam->addFiltro("incbte.id_gestion in (".$this->objParam->getParametro('id_gestion').")");
        }
        $this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]);

        if ($this->objParam->getParametro('tipoReporte') == 'excel_grid' || $this->objParam->getParametro('tipoReporte') == 'pdf_grid') {
            $this->objReporte = new Reporte($this->objParam, $this);
            $this->res = $this->objReporte->generarReporteListado('MODConsultaCbte', 'listaConsultaCbte');
        } else {
            $this->objFunc = $this->create('MODConsultaCbte');

            $this->res = $this->objFunc->listaConsultaCbte($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }


}

?>