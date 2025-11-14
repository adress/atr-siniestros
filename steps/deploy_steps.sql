-- Usuarios Laboratorio 
-- (tener en cuenta que estos usarios deben tener permisos de ejecucion de los paquetes
-- y en los registros de las tablas permisos de SELECT, INSERT, UPDATE, DELETE): 
-- MAPEOINFO: es el usario que se tiene en laboratorio para hacer las pruerbas y los inserts
-- OPS$PROCEDIM: basicamemte es el usaurio propietario
-- OPS$ADM_ATRSURA, ADM_ATRSURA,  y OPS$SINI: son los usuarios de las aplicaciones de ART



--***************************************************
--*  INSERTS (direct connection user mapeoinfo)     *
--***************************************************

-- 1. insert used for switch in t999_parametros
INSERT INTO T999_PARAMETROS (CDRAMO, CDSUBRAMO, CDCLAVE1, CDCLAVE2, CDCLAVE3, CDCLAVE4, CDCLAVE5, DSPARAMETRO, PTPARAMETRO, FEALTA, FEBAJA, DSVALOR_PARAMETRO)
VALUES ('081', '%', '%', '%', '%', '%', '%', 'USA_API_SINICXP', NULL, SYSDATE, NULL, 'S');
INSERT INTO T999_PARAMETROS (CDRAMO, CDSUBRAMO, CDCLAVE1, CDCLAVE2, CDCLAVE3, CDCLAVE4, CDCLAVE5, DSPARAMETRO, PTPARAMETRO, FEALTA, FEBAJA, DSVALOR_PARAMETRO)
VALUES ('083', '%', '%', '%', '%', '%', '%', 'USA_API_SINICXP', NULL, SYSDATE, NULL, 'S');
INSERT INTO T999_PARAMETROS (CDRAMO, CDSUBRAMO, CDCLAVE1, CDCLAVE2, CDCLAVE3, CDCLAVE4, CDCLAVE5, DSPARAMETRO, PTPARAMETRO, FEALTA, FEBAJA, DSVALOR_PARAMETRO)
VALUES ('084', '%', '%', '%', '%', '%', '%', 'USA_API_SINICXP', NULL, SYSDATE, NULL, 'S');
INSERT INTO T999_PARAMETROS (CDRAMO, CDSUBRAMO, CDCLAVE1, CDCLAVE2, CDCLAVE3, CDCLAVE4, CDCLAVE5, DSPARAMETRO, PTPARAMETRO, FEALTA, FEBAJA, DSVALOR_PARAMETRO)
VALUES ('181', '%', '%', '%', '%', '%', '%', 'USA_API_SINICXP', NULL, SYSDATE, NULL, 'S');
INSERT INTO T999_PARAMETROS (CDRAMO, CDSUBRAMO, CDCLAVE1, CDCLAVE2, CDCLAVE3, CDCLAVE4, CDCLAVE5, DSPARAMETRO, PTPARAMETRO, FEALTA, FEBAJA, DSVALOR_PARAMETRO)
VALUES ('BAN', '%', '%', '%', '%', '%', '%', 'USA_API_SINICXP', NULL, SYSDATE, NULL, 'S');


-- 2. insert user and password for art siniestros
insert into tcob_parametros_sap (
   cdproceso,
   cdconsumidor,
   cdservicio,
   cdoperacion,
   cdversion,
   dsname_space,
   dspuerto,
   cdusuario,
   cdclave
) values ( 'ART_SINI',
           'n/a',
           'sap',
           'siniestros_cxp',
           '1.0',
           'n/a',
           'n/a',
           '57W1hRyXRLSiswMg9RSL6DOGymReG9paAKY33CkGBltwBGMz',
           'gAAAAABo1avf8BCP-W3xacUJPQXwJ9tE9Fqb7i3ifloNOQSxkz-94Yi1Kn77g0FgeWc8Ev30UpwTi4eHZqo_1OKRV8i9xHE2mMT9RzVoWBpmIz8zuPQFKh4qsL6jf5Xasqf72gcyn7_i1yNDD7k2LotUCQzkCPmZbTFgU34YjhY2jxjMkr_M_o4='
           );


--**********************************************************
--*  CREATE objects (using analizador de requerimientos)   *
--**********************************************************

--3. create tables use file script_tablas_estandar.sql:
--    OPS$PROCEDIM.TATR_ASYNC_TX_1
--    OPS$PROCEDIM.TATR_ASYNC_TX_ERRORS_1
--    OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1


-- 4. create adapter using the file pck_sin_adaptador_cpi.sql
--  pck_sin_adaptador_cpi


--5. add permissions to tables, types and packages to MAPEOINFO, OPS$ADM_ATRSURA, ADM_ATRSURA, OPS$SINI