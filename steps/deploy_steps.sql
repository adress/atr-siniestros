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
commit;

-- insert credentials for ATR Siniestros crendciales de laboratorio
INSERT INTO T999_PARAMETROS (CDRAMO, CDSUBRAMO, CDCLAVE1, CDCLAVE2, CDCLAVE3, CDCLAVE4, CDCLAVE5, DSPARAMETRO, PTPARAMETRO, FEALTA, FEBAJA, DSVALOR_PARAMETRO)
VALUES ('%', '%', '%', '%', '%', '%', '%', 'CLIENT_ID_ATR', NULL, SYSDATE, NULL, 'UnSead4Nq9KcxpqGvgYAABKOp7sVGtEnqJk5c1sfQ8DQ9UQm');
INSERT INTO T999_PARAMETROS (CDRAMO, CDSUBRAMO, CDCLAVE1, CDCLAVE2, CDCLAVE3, CDCLAVE4, CDCLAVE5, DSPARAMETRO, PTPARAMETRO, FEALTA, FEBAJA, DSVALOR_PARAMETRO)
VALUES ('%', '%', '%', '%', '%', '%', '%', 'SECRET_ATR', NULL, SYSDATE, NULL, 'gAAAAABpKiIWKg04wVl5wdMR_G7w4t7DpdkrzG6STwtw_UeTwvd3Ca6mgJr5zebFUy8hvx_f1zjRNxasCun3nskf0U_wAJyz6rYhOI_G9tHhwtU7Q1_JDEcEvbu5Ko5f1cSr2zn_JCdXgk6x0QYza6K1QOSQiQe4QO6_NZQsa3To9eaz9Lzt9xc=');
commit;


--**********************************************************
--*  CREATE objects (using analizador de requerimientos)   *
--**********************************************************

--1. create tables use file script_tablas_estandar.sql:
--    OPS$PROCEDIM.TATR_ASYNC_TX_1
--    OPS$PROCEDIM.TATR_ASYNC_TX_ERRORS_1
--    OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1

-- 2. creacion de los types de consulta obj_cpi_causacion_contable.sql

-- 4. create adapter using the file pck_sin_adaptador_cpi.sql
--  pck_sin_adaptador_cpi


--5. add permissions to tables, types and packages to MAPEOINFO, OPS$ADM_ATRSURA, ADM_ATRSURA, OPS$SINI