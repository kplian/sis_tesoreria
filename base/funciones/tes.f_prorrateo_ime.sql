--------------- SQL ---------------

CREATE OR REPLACE FUNCTION tes.f_prorrateo_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Tesoreria
 FUNCION:         tes.f_prorrateo_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'tes.tprorrateo'
 AUTOR:          (admin)
 FECHA:            16-04-2013 01:45:48
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
* ISSUE       AUTHOR          FECHA           DESCRIPCION
   #66         EGS             30/07/2020      Se puede editar cuando el plan de pago este en pago y borrador
***************************************************************************/

DECLARE

    v_nro_requerimiento        integer;
    v_parametros               record;
    v_id_requerimiento         integer;
    v_resp                    varchar;
    v_nombre_funcion        text;
    v_mensaje_error         text;
    v_id_prorrateo    integer;
    v_registros record;
    v_monto_registrado numeric;
    v_pago_variable varchar;
    v_monto_ejecutar_total_mo numeric;
    v_tipo varchar;
    v_estado varchar;
    v_tipo_cambio numeric;

BEGIN

    v_nombre_funcion = 'tes.f_prorrateo_ime';
    v_parametros = pxp.f_get_record(p_tabla);



    /*********************************
     #TRANSACCION:  'TES_PRO_MOD'
     #DESCRIPCION:    Modificacion de registros
     #AUTOR:        admin
     #FECHA:        16-04-2013 01:45:48
    ***********************************/

    if(p_transaccion='TES_PRO_MOD')then

        begin

            select
             pro.monto_ejecutar_mo
            into
            v_registros
            from tes.tprorrateo pro
            where pro.id_prorrateo = v_parametros.id_prorrateo;


            select
             op.pago_variable,
             pp.monto_ejecutar_total_mo,
             pp.tipo,
             pp.estado,
             pp.estado
            into
             v_pago_variable,
             v_monto_ejecutar_total_mo,
             v_tipo,
             v_estado
            from tes.tobligacion_pago op
            inner join tes.tplan_pago pp  on op.id_obligacion_pago = pp.id_obligacion_pago
            where pp.id_plan_pago = v_parametros.id_plan_pago;


            -- la edicion del prorrateo solo es valido para obligaciones variables
            IF v_tipo = 'pagado' and v_estado <> 'borrador' THEN --#66

             raise exception 'No puede editarce el prorrateo de cuotas de pago';

           END IF;

           IF v_pago_variable = 'no' and v_tipo <> 'pagado' THEN --#66

             raise exception 'Solo se admite edicion de prorrateo en pago variables';

           END IF;

            IF v_estado = 'devengado'  or v_estado = 'pagado' or v_estado = 'pendiente' THEN

             raise exception 'Solo puede editarce cuotas en estado  borrador';

           END IF;


            -- controlar que el monto asignado + el total ya prorrateao no supere el total de la obigacion para este concepto
            --    RAC, comentamos esta validacion por solo los pagos variables admiten edicion
            --  y los pagos variables pueden ser menor o mayor el monto estimado inicialmente

           /*
             v_monto_registrado=COALESCE(tes.f_determinar_total_prorrateo_faltante( v_parametros.id_obligacion_det, 'registrado'),0);

            IF  (v_monto_registrado + COALESCE(v_registros.monto_ejecutar_mo,0))  <  COALESCE(v_parametros.monto_ejecutar_mo,0) THEN

             -- raise exception 'El monto no puede ser mayor que % para   de este item', v_monto_registrado + v_registros.monto_ejecutar_mo;



            ELSE

             -- raise exception '   % ,% , %',v_monto_registrado,v_registros.monto_ejecutar_mo,v_parametros.monto_ejecutar_mo;

            END IF;*/


            --la suma del prorrateo no puede sobrepasar el monto a ejcutar en la cuota


            select
              sum( pro.monto_ejecutar_mo )
            into
              v_monto_registrado

            from tes.tprorrateo pro
            where pro.id_plan_pago = v_parametros.id_plan_pago
              and pro.estado_reg='activo' ;


            IF  (v_monto_registrado - COALESCE(v_registros.monto_ejecutar_mo,0) + COALESCE(v_parametros.monto_ejecutar_mo,0)  )  >  v_monto_ejecutar_total_mo THEN

              raise exception 'El total prorrateado no puede ser mayor que el monto a ejecutar para la cuota. (Total %, faltan %)',v_monto_ejecutar_total_mo,v_monto_ejecutar_total_mo-(v_monto_registrado - COALESCE(v_registros.monto_ejecutar_mo,0));


            END IF;

            --asumimos que el tipo de cambio del pagado es igual al tipo de cambio del devengado
            --recupera el tipo de cambio del devengado
              select
                ppd.tipo_cambio
              into
                v_tipo_cambio
              from tes.tplan_pago ppd
              inner join tes.tprorrateo pro on pro.id_plan_pago = ppd.id_plan_pago
              where pro.id_prorrateo=v_parametros.id_prorrateo;




            --Sentencia de la modificacion
            update tes.tprorrateo set
            monto_ejecutar_mo = COALESCE(v_parametros.monto_ejecutar_mo,0),
            monto_ejecutar_mb = round(COALESCE(v_parametros.monto_ejecutar_mo*v_tipo_cambio,0),2),
            fecha_mod = now(),
            id_usuario_mod = p_id_usuario
            where id_prorrateo=v_parametros.id_prorrateo;


            --actualizar el monto prorrateado en el plan de pago

            select
                sum(COALESCE(pro.monto_ejecutar_mo,0))
            into
               v_monto_registrado
            from tes.tprorrateo pro
            where pro.estado_reg = 'activo'   and pro.id_plan_pago = v_parametros.id_plan_pago ;



            --

              update  tes.tplan_pago pp SET
                total_prorrateado =  v_monto_registrado
              where pp.id_plan_pago=v_parametros.id_plan_pago;



            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Prorrateo modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_prorrateo',v_parametros.id_prorrateo::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;



    else

        raise exception 'Transaccion inexistente: %',p_transaccion;

    end if;

EXCEPTION

    WHEN OTHERS THEN
        v_resp='';
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
        v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
        raise exception '%',v_resp;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;