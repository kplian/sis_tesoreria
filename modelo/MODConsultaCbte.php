<?php
/**
 * @package pXP
 * @file gen-MODConceptoExcepcion.php
 * @author  (admin)
 * @date 12-06-2015 13:02:07
 * @description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */

class MODConsultaCbte extends MODbase
{

    function __construct(CTParametro $pParam)
    {
        parent::__construct($pParam);
    }

    function listaConsultaCbte()
    {
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento = 'tes.f_consulta_cbte_sel';
        $this->transaccion = 'TES_CAJERO_SEL';
        $this->tipo_procedimiento = 'SEL';//tipo de transaccion

        $this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');

        //Definicion de la lista del resultado del query
        $this->captura('manual', 'varchar');
        $this->captura('estado_reg', 'varchar');
        $this->captura('id_int_comprobante', 'integer');
        $this->captura('fecha', 'date');
        $this->captura('nro_tramite', 'varchar');
        $this->captura('beneficiario', 'varchar');
        $this->captura('tipo_cambio', 'numeric');
        $this->captura('liquido_pagable', 'numeric');
        $this->captura('glosa', 'varchar');
        $this->captura('fecha_documento', 'date');
        $this->captura('cento_consto', 'text');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
}

?>