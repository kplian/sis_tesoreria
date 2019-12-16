
<!--
 *	ISSUE   FORK	     Fecha 		     Autor		 Descripcion	
 *  #41     ENDETR       16/12/2019      JUAN        Reporte de información de pago
* * -->

<!-- INICIO #41 -->
<table border="1" style="padding: 5px 5px 5px 5px">
	<tr>		
		<td style="width: 234px;text-align: center;">
			<img style="width: 130px;" src="./../../../lib/<?php echo $_SESSION['_DIR_LOGO'];?>" alt="Logo">
		</td>
		<td style="width: 424px;text-align: center; vertical-align: middle; ">
			<strong >
				<font size="15" style="padding: 60px; " >Proceso de adquisición de Bienes /<br> Servicio y otros</font>
			</strong>
		</td>
	</tr>	
</table>
<br><br>


<table border="1" style="padding: 7px 7px 7px 7px">
	<tr>
		<td size="13" style="font-size:11px; height: 25px; text-align: left; vertical-align: middle;">
			<?php if(($this->datos[0]["requiere_contrato"])=='no' ){ ?>
			           <b>Orden de Compra</b> :
		    <?php  } else{ ?>
			           <b>N° Contrato</b> :
		    <?php  }?>
		    <?php echo $this->datos[0]["orden_compra"];?> 
		</td>
	</tr>
	<tr>
		<td style="font-size:11px; height: 25px; text-align: left; vertical-align: middle;"><b>Tramite</b> : <?php echo $this->datos[0]["num_tramite"];?></td>
	</tr>
	<tr>
		<td style="font-size:11px; height: 25px; text-align: left; vertical-align: middle;"><b>N° Proceso</b> : <?php echo $this->datos[0]["codigo_proceso"];?></td>
	</tr>
	<tr>
		<?php  
		    $numero_cuota;
			$var= $this->datos[0]["nro_cuota"];
			$partes = explode(".",$var);
			if ($partes[1] > 0) {
			   $numero_cuota =$this->datos[0]["nro_cuota"];
			}else{
			   $numero_cuota =(integer)$var;
			}
		?>
		<td style="font-size:11px; height: 25px; text-align: left; vertical-align: middle;"><b>N° Cuota</b> : <?php echo $numero_cuota;?></td>
	</tr>
	<tr>
		<td style="font-size:11px; height: 25px; text-align: left; vertical-align: middle;"><b>Beneficiario</b> : <?php echo $this->datos[0]["des_funcionario"];?> </td>
	</tr>
	<tr >
		<td style=" font-size:11px; height: 100%;text-align: justify; vertical-align: middle;"><b>Descripción</b> : <?php echo $this->datos[0]["descripcion"];?></td>
	</tr>
	
	<tr>
	    <td style="font-size:11px; height: 25px; text-align: left; vertical-align: middle; " colspan="2"><b>Centro de Costo</b> : <?php echo $this->datos[0]["codigo_cc"];?> </td>
	</tr>
	<tr>
		<td style="font-size:11px; height: 40px; text-align:left vertical-align: middle; "> <?php echo $this->datos[0]["descripcion_techo"];?>  </td>
	</tr>
	<tr>
		<table border="1" style="padding: 5px 5px 5px 5px">

			<tr style="background-color: #D6ECFF">
		       <td style="font-size:11px; height: 25px; text-align: center; vertical-align: middle;"><b>Concepto</b></td>
		       <td style="font-size:11px; height: 25px; text-align: center; vertical-align: middle;"><b>Moneda</b></td>
		       <td style="font-size:11px; height: 25px; text-align: center; vertical-align: middle;"><b>Importe</b></td>
	        </tr>
			<tr >
		       <td style="font-size:11px; height: 25px; text-align: left; vertical-align: middle;">Importe </td>
		       <td style="font-size:11px; height: 25px; text-align: center; vertical-align: middle;"><?php echo $this->datos[0]["moneda"];?></td>
		       <td style="font-size:11px; height: 25px; text-align: center; vertical-align: middle;"><?php echo $this->datos[0]["importe"];?></td>
	        </tr>
			<tr >
		       <td style="font-size:11px; height: 25px; text-align: left; vertical-align: middle;">Retención de Garantía </td>
		       <td style="font-size:11px; height: 25px; text-align: center; vertical-align: middle;"><?php echo $this->datos[0]["moneda"];?></td>
		       <td style="font-size:11px; height: 25px; text-align: center; vertical-align: middle;"><?php echo $this->datos[0]["monto_retgar_mb"];?></td>
	        </tr>
			<tr >
		       <td style="font-size:11px; height: 25px; text-align: left; vertical-align: middle;">Descuentos de Ley </td>
		       <td style="font-size:11px; height: 25px; text-align: center; vertical-align: middle;"><?php echo $this->datos[0]["moneda"];?></td>
		       <td style="font-size:11px; height: 25px; text-align: center; vertical-align: middle;"><?php echo $this->datos[0]["descuento_ley"];?></td>
	        </tr>
			<tr>
		       <td style="font-size:11px; height: 25px; text-align: left; vertical-align: middle;">Descuentos de Anticipo </td>
		       <td style="font-size:11px; height: 25px; text-align: center; vertical-align: middle;"><?php echo $this->datos[0]["moneda"];?></td>
		       <td style="font-size:11px; height: 25px; text-align: center; vertical-align: middle;"><?php echo $this->datos[0]["descuento_anticipo"];?></td>
	        </tr>
			<tr>
		       <td style="font-size:11px; height: 25px; text-align: left; vertical-align: middle;">Otros Descuentos</td>
		       <td style="font-size:11px; height: 25px; text-align: center; vertical-align: middle;"><?php echo $this->datos[0]["moneda"];?></td>
		       <td style="font-size:11px; height: 25px; text-align: center; vertical-align: middle;"><?php echo $this->datos[0]["otros_descuentos"];?></td>
	        </tr>
			<tr>
		       <td style="font-size:11px; height: 25px; text-align: left; vertical-align: middle;">Liquido Pagable</td>
		       <td style="font-size:11px; height: 25px; text-align: center; vertical-align: middle;"><?php echo $this->datos[0]["moneda"];?></td>
		       <td style="font-size:11px; height: 25px; text-align: center; vertical-align: middle;"><?php echo $this->datos[0]["liquido_pagable"];?></td>
	        </tr>
		</table>
	</tr>
</table>

<br><br><br><br><br><br><br><br><br><br><br>
<table border="1" style="padding: 5px 5px 5px 5px">
	<tr>
       <td style="font-size:11px; left: 25px; text-align: left; vertical-align: middle;">Tipo solicitud</td>
       <td style="font-size:11px; left: 25px; text-align: left; vertical-align: middle;" colspan="2"> <?php echo $this->datos[0]["tipo"];?></td>
    </tr>
	<tr>
       <td style="font-size:11px; height: 25px; text-align: left; vertical-align: middle;">N° Cheque</td>
       <td style="font-size:11px; height: 25px; text-align: center; vertical-align: middle;" colspan="2"> </td>
    </tr>
</table>

<br><br>
<table border="1" style="padding: 10px 10px 10px 10px">
	<tr >
       <td style="font-size:11px; height: 25px; text-align: center; vertical-align: middle;"><b>DPTO. ADQUISICIONES</b></td>
       <td style="font-size:11px; height: 25px; text-align: center; vertical-align: middle;"><b>DPTO. CONTABILIDAD</b></td>
       <td style="font-size:11px; height: 25px; text-align: center; vertical-align: middle;"><b>DPTO. FINANZAS</b></td>
    </tr>
	<tr >
       <td style="height: 60px; text-align: left; vertical-align: middle;"></td>
       <td style="height: 60px; text-align: left; vertical-align: middle;"></td>
       <td style="height: 60px; text-align: left; vertical-align: middle;"></td>
    </tr>
</table>

<!-- FIN #41 -->