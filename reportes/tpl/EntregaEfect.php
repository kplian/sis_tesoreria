<!--
*	ISSUE   FORK	     Fecha 		     Autor		        Descripcion
*  #56     ENDETR       17/02/2020      Manuel Guerra      cambio de fechas(periodo) de un documento en la rendcion
-->

<div align="center">
    <table style="width: 585.617px; margin-left: auto; margin-right: auto;">
        <tbody>
            <tr style="height: 43px;">
                <td style="width: 88px; text-align: right; height: 43px;">
                    <img align="left" style="width: 85px;" src="./../../../lib/<?php echo $_SESSION['_DIR_LOGO'];?>" alt="Logo">
                </td>
                <td valign="top" style="width: 481.617px; height: 43px; text-align: center;">
                    <h2> <em><?php echo $this->datos;?></em></h2>
                </td>
            </tr>
        </tbody>
    </table>
</div>

<div align="center">
    <table style="height: 55px; width: 583.8px; margin-left: auto; margin-right: auto;" border="1" >
        <tbody>
            <tr>
                <td style="width: 220px; text-align: center; font-size:12px;"><strong>FECHA ENTREGA</strong></td>
                <td style="width: 195px; text-align: center; font-size:12px;"><strong>MONEDA</strong></td>
                <td style="width: 240px; text-align: center; font-size:12px;"><strong>NRO TRAMITE </strong></td>
            </tr>
            <tr>
                <td style="width: 220px; text-align: center; font-size:13px; "><?php echo $this->fecha ?></td>
                <td style="width: 195px; text-align: center; font-size:13px; "><?php echo $this->moneda;?></td>
                <td style="width: 240px; text-align: center; font-size:13px; "><?php echo $this->nro_tramite;?></td>
            </tr>
        </tbody>
    </table>
</div>
<div>
    <table style="height: 252px; width: 674px;" border="1">
        <tbody>
            <tr>
                <td style="width: 213.05px; font-size:12px;"><strong>CAJA:</strong></td>
                <td style="width: 440.95px; text-align: justify; font-size:13px;"><?php echo $this->codigo;?></td>
            </tr>
            <tr>
                <td style="width: 213.05px; font-size:12px;"><strong>CAJERO:</strong></td>
                <td style="width: 440.95px; text-align: justify; font-size:13px;"><?php echo $this->cajero;?></td>
            </tr>
            <tr>
                <td style="width: 213.05px; font-size:12px;"><strong>UNIDAD SOLICITANTE:</strong></td>
                <td style="width: 440.95px; text-align: justify; font-size:13px;"><?php echo $this->nombre_unidad;?></td>
            </tr>
            <tr>
                <td style="width: 213.05px; font-size:12px;"><strong>FUNCIONARIO:</strong></td>
                <td style="width: 440.95px; text-align: justify; font-size:13px;"><?php echo $this->solicitante;?></td>
            </tr>
            <tr>
                <td style="width: 213.05px; font-size:12px;"><strong>MOTIVO:</strong></td>
                <td style="width: 440.95px; text-align: justify; font-size:13px;"><?php echo $this->motivo;?><br />
                    <?php
                        if (!empty($this->superior)) {
                            echo $this->mensaje;
                        }
                    ?>
                </td>
            </tr>
            <tr>
                <td style="width: 213.05px; font-size:12px;"><strong>IMPORTE ENTREGADO:</strong></td>
                <td style="width: 440.95px; text-align: justify; font-size:13px;"><?php echo $this->monto;?></td>
            </tr>
        </tbody>
    </table>
</div>

<div>
    <table style="height: 128px; margin-left: auto; margin-right: auto; vertical-align: middle;" border="1" width="676">
        <tbody>
            <tr style="height: 25px;">
                <td style="width: 330px; text-align: center; font-size:12px;"><?php echo $this->de;?></td>
                <td style="width: 330px; text-align: center; font-size:12px;"><?php echo $this->a;?></td>
            </tr>
            <tr style="height: 65px;">
                <td style="width: 330px; height: 65px; text-align: center; font-size:15px;">&nbsp;</td>
                <td style="width: 330px; height: 65px; text-align: center; font-size:15px;">&nbsp;</td>
            </tr>
            <tr style="height: 25px; ">
                <td style="width: 330px; text-align: center; font-size:13px;">
                    <strong>
                        <?php echo $this->solicitante;?>
                        <br />
                        <?php
                            if (!empty($this->superior)) {
                                echo $this->superior;
                            }
                        ?>
                    </strong>
                </td>
                <td style="width: 330px; text-align: center; font-size:13px; ">
                    <strong> <?php echo $this->cajero; ?></strong>
                </td>
            </tr>
        </tbody>
    </table>
</div>
