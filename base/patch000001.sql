/************************************I-SCP-JRR-INFORMIX-0-19/04/2016*************************************************/
CREATE EXTENSION  IF NOT EXISTS informix_fdw;

CREATE SERVER sai1
FOREIGN DATA WRAPPER informix_fdw
OPTIONS (informixserver 'sai1');

--ejemplo creacion de user mapping

--CREATE USER MAPPING FOR CURRENT_USER
--SERVER sai1
--OPTIONS (username 'ejemplo', password 'ejemplo');

--ejemplo creacion tabla foranea

--CREATE FOREIGN TABLE informix.prueba (
--  a varchar(3),
--  b varchar(3),
--  c varchar(6),
-- d varchar(20),
--  e date,
--  f varchar(1),
--  g varchar(1),
--  h varchar(1)
--
--) SERVER sai1
--
--OPTIONS ( query 'SELECT a,b,c,d,e,f,g,h FROM ejemplo where a = ''1'' and b = ''N'' AND c=''N'' ',
--database 'ejemplo',
--  informixdir '/opt/informix',
--  client_locale 'en_US.utf8',
--  informixserver 'sai1');

--ejempplo eliminacion tabla foranea

--DROP FOREIGN TABLE  IF EXISTS informix.prueba
/************************************F-SCP-JRR-INFORMIX-0-19/04/2016*************************************************/