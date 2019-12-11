CREATE OR REPLACE FUNCTION tes.f_plan_pago_gcc_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
declare
    v_nombre_function varchar='ads.f_plan_pago_gcc_sel';
    v_resp            varchar;
    v_consulta        varchar;
    v_parametros      record;
begin
    v_parametros = pxp.f_get_record(p_tabla);
    if (p_transaccion = 'TES_PLAPAGCCREP_SEL') then
        begin
            v_consulta := 'SELECT DISTINCT cc.nombre_proyecto::varchar, cc.codigo_cc::varchar
                            FROM tes.tobligacion_pago op
                                 join tes.tobligacion_det opd on opd.id_obligacion_pago = op.id_obligacion_pago
                                 left join param.vcentro_costo cc on cc.id_centro_costo = opd.id_centro_costo
                       where   op.id_obligacion_pago = ' || v_parametros.id_obligacion_pago;
            return v_consulta;
        end;
    end if;
exception
    when others then
        v_resp = '';
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp, 'codigo_error', SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp, 'procedimiento', v_nombre_function);
        raise exception '%',v_resp;
end;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;

ALTER FUNCTION tes.f_plan_pago_gcc_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;