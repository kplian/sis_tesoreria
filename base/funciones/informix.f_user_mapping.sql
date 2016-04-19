CREATE OR REPLACE FUNCTION informix.f_user_mapping (
)
RETURNS void AS
$body$
DECLARE
v_user varchar;
v_pass varchar;
v_te varchar;
BEGIN

v_user = pxp.f_get_variable_global('INFORMIX_DB_USER');
v_pass = pxp.f_get_variable_global('INFORMIX_DB_PASS');

--raise exception 'us %',current_user;
execute 'DROP USER MAPPING IF EXISTS FOR "' || current_user ||'" SERVER sai1'; 
                       
execute 'CREATE USER MAPPING FOR "' || current_user || '"
SERVER sai1
OPTIONS (username ''' || v_user || ''' , password ''' || v_pass || ''')';


 
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;