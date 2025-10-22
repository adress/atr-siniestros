-- ============================================================================
-- Archivo: script_general_parametrico.sql
-- Descripcion:
--   Script maestro para la creacion y despliegue de todos los objetos necesarios
--   para el proceso asincrono del habilitador de integracion. Este script es una
--   compilacion integral que incluye la creacion de tablas principales, tablas
--   de errores, historicos, secuencias, indices, paquetes utilitarios y
--   procedimientos asociados al flujo asincrono.
--
--   Mejora destacada: El paquete utilitario permite especificar como parametro
--   el nombre de la tabla destino donde se insertara el payload, facilitando la
--   reutilizacion y parametrizacion del proceso.
--
-- Componentes creados:
--   - Tablas principales de transacciones asincronas, errores e historico.
--   - Secuencias e indices asociados.
--   - Paquete utilitario OPS$PROCEDIM.PCK_ATR_INTEGRATION_UTILS con funciones
--     para validacion, insercion asincrona parametrizada, integracion HTTP, etc.
--   - Procedimiento para mover registros a historico.
--   - Job programado para automatizar el movimiento a historico.
--
-- Uso:
--   Ejecutar este script en el esquema destino para desplegar todos los objetos
--   requeridos para el habilitador asincrono.
--
-- Autor: 
-- Fecha: 2025-09-22
-- Version: 1.1.0
--
-- Cambios:
--   - 2025-09-22: Mejora para parametrizar la tabla de insercion de payload.
-- ============================================================================


-- ========= TABLA PRINCIPAL REGISTRO DE TRANSACCIONES ASINCRONAS =========

CREATE SEQUENCE OPS$PROCEDIM.SEQ_ATR_ASYNC_TX_NMID_1  --@review se cambia TART por ATR debido al estandar Sura
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 999999999
NOCYCLE
CACHE 20
NOORDER;


CREATE TABLE OPS$PROCEDIM.TATR_ASYNC_TX_1 (
    NMID NUMBER(20),                        -- @review se quita el auto incrementable por estandar Sura (se agrega trigger al final del script)
    CDCORRELATION_ID VARCHAR2(36),
    CDREQUEST_ID VARCHAR2(50),
    DSTARGET_SYSTEM VARCHAR2(50),
    DSTARGET_SYSTEM_PROCESS VARCHAR2(100),
    DSSOURCE_APPLICATION_NAME VARCHAR2(100),
    SNIS_BATCH_OPERATION NUMBER(1),           -- @review Orignal boolean pero no compatible con oracle 19c
    NMSTATUS NUMBER(2),                       -- @review Se cambia a NMSTATUS debido al estandar Sura  
    DSREQUEST_CLOB CLOB,
    FECREATED_AT TIMESTAMP,
    FEIN_PROGRESS_AT TIMESTAMP,
    FEREQ_COMPLETED_AT TIMESTAMP,
    FERES_COMPLETED_AT TIMESTAMP,
    DSRESPONSE_CLOB CLOB                     
);                                           -- @review Se eliminan los constraints de la tabla debido al estandar Sura (se agregan al final del script)

--  @review se crean los comentarios de la tabla y las columnas debido al estandar sura
COMMENT ON TABLE OPS$PROCEDIM.TATR_ASYNC_TX_1 IS 'Tabla que almacena las transacciones asincronas procesadas por el habilitador de integracion. Cada registro representa una solicitud enviada entre sistemas.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_1.NMID IS 'Identificador unico de la transaccion asincrona. Clave primaria generada por secuencia.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_1.CDCORRELATION_ID IS 'Identificador de correlacion para rastrear la transaccion entre sistemas.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_1.CDREQUEST_ID IS 'Identificador de la solicitud original enviada al sistema destino.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_1.DSTARGET_SYSTEM IS 'Nombre del sistema destino al que se envia la transaccion.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_1.DSTARGET_SYSTEM_PROCESS IS 'Nombre del proceso especifico en el sistema destino.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_1.DSSOURCE_APPLICATION_NAME IS 'Nombre de la aplicacion fuente que origina la transaccion.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_1.SNIS_BATCH_OPERATION IS 'Indicador numerico que señala si la transaccion es parte de un proceso por lotes (1) o individual (0).';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_1.NMSTATUS IS 'Estado numerico de la transaccion (ejemplo: 1=pendiente, 2=en progreso, 3=error, 4=completada).';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_1.DSREQUEST_CLOB IS 'Datos de la solicitud en formato CLOB, puede contener payloads extensos.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_1.FECREATED_AT IS 'Fecha y hora de creacion del registro de transaccion.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_1.FEIN_PROGRESS_AT IS 'Fecha y hora en que la transaccion paso a estado en progreso.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_1.FEREQ_COMPLETED_AT IS 'Fecha y hora en que la solicitud fue completada.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_1.FERES_COMPLETED_AT IS 'Fecha y hora en que la respuesta fue completada.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_1.DSRESPONSE_CLOB IS 'Datos de la respuesta en formato CLOB, puede contener payloads extensos.';


-- @review se agregan los constrain fuera de la tabla por estandar Sura
ALTER TABLE OPS$PROCEDIM.TATR_ASYNC_TX_1 ADD CONSTRAINT "TATR_ASYNC_TX_1_PK" PRIMARY KEY (NMID) USING INDEX;
ALTER TABLE OPS$PROCEDIM.TATR_ASYNC_TX_1 ADD CONSTRAINT "TATR_ASYNC_TX_1_UK01" UNIQUE (CDCORRELATION_ID) USING INDEX;
ALTER TABLE OPS$PROCEDIM.TATR_ASYNC_TX_1 ADD CONSTRAINT "TATR_ASYNC_TX_1_CK01" CHECK ("NMID" IS NOT NULL);
ALTER TABLE OPS$PROCEDIM.TATR_ASYNC_TX_1 ADD CONSTRAINT "TATR_ASYNC_TX_1_CK02" CHECK ("CDCORRELATION_ID" IS NOT NULL);
ALTER TABLE OPS$PROCEDIM.TATR_ASYNC_TX_1 ADD CONSTRAINT "TATR_ASYNC_TX_1_CK03" CHECK ("DSTARGET_SYSTEM" IS NOT NULL);
ALTER TABLE OPS$PROCEDIM.TATR_ASYNC_TX_1 ADD CONSTRAINT "TATR_ASYNC_TX_1_CK04" CHECK ("DSTARGET_SYSTEM_PROCESS" IS NOT NULL);
ALTER TABLE OPS$PROCEDIM.TATR_ASYNC_TX_1 ADD CONSTRAINT "TATR_ASYNC_TX_1_CK05" CHECK ("DSSOURCE_APPLICATION_NAME" IS NOT NULL);
ALTER TABLE OPS$PROCEDIM.TATR_ASYNC_TX_1 ADD CONSTRAINT "TATR_ASYNC_TX_1_CK06" CHECK ("NMSTATUS" IS NOT NULL);
ALTER TABLE OPS$PROCEDIM.TATR_ASYNC_TX_1 ADD CONSTRAINT "TATR_ASYNC_TX_1_CK07" CHECK ("DSREQUEST_CLOB" IS NOT NULL);
ALTER TABLE OPS$PROCEDIM.TATR_ASYNC_TX_1 ADD CONSTRAINT "TATR_ASYNC_TX_1_CK08" CHECK ("FECREATED_AT" IS NOT NULL);


CREATE INDEX OPS$PROCEDIM.TATR_ASYNC_TX_1_I01 ON OPS$PROCEDIM.TATR_ASYNC_TX_1 (NMSTATUS);

-- @review creacion de un trigger para campo auto incremental 
CREATE OR REPLACE TRIGGER OPS$PROCEDIM.TRG_ATR_BEF_INS_TX_1NMID
BEFORE INSERT ON OPS$PROCEDIM.TATR_ASYNC_TX_1
FOR EACH ROW
BEGIN
  IF :NEW.NMID IS NULL THEN
    :NEW.NMID := OPS$PROCEDIM.SEQ_ATR_ASYNC_TX_NMID_1.NEXTVAL;
  END IF;
END TRG_ATR_BEF_INS_TX_1NMID;
/
ALTER TRIGGER OPS$PROCEDIM.TRG_ATR_BEF_INS_TX_1NMID ENABLE;

-- ========= TABLA PRINCIPAL REGISTRO DE TRANSACCIONES ASINCRONAS ERRORES =========

CREATE SEQUENCE OPS$PROCEDIM.SEQ_ATR_ASYNC_TX_ERRORS_NMID_1 --@review se cambia TART por ATR debido al estandar Sura
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 999999999
NOCYCLE
CACHE 20
NOORDER;


CREATE TABLE OPS$PROCEDIM.TATR_ASYNC_TX_ERRORS_1 (
    NMID NUMBER(38),
    NMPROCESS_ID NUMBER(20),
    CDCORRELATION_ID VARCHAR2(36),
    DSERROR_MESSAGE CLOB,
    FECREATED_AT TIMESTAMP
);

--@review El valor por defecto de FECREATED_AT se asigna en el trigger BEFORE INSERT por compatibilidad y estandar Oracle.

--@review Comentarios de tabla y columnas para TATR_ASYNC_TX_ERRORS_1
COMMENT ON TABLE OPS$PROCEDIM.TATR_ASYNC_TX_ERRORS_1 IS 'Tabla que almacena los errores ocurridos durante el procesamiento de transacciones asincronas.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_ERRORS_1.NMID IS 'Identificador unico del error. Clave primaria generada por secuencia y trigger.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_ERRORS_1.NMPROCESS_ID IS 'Identificador de la transaccion asincrona asociada al error.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_ERRORS_1.CDCORRELATION_ID IS 'Identificador de correlacion para rastrear la transaccion entre sistemas.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_ERRORS_1.DSERROR_MESSAGE IS 'Mensaje de error detallado en formato CLOB.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_ERRORS_1.FECREATED_AT IS 'Fecha y hora de creacion del registro de error.';

--@review Constraints fuera de la tabla por estandar
ALTER TABLE OPS$PROCEDIM.TATR_ASYNC_TX_ERRORS_1 ADD CONSTRAINT "TATR_ASYNC_TX_ERRORS_1_PK" PRIMARY KEY (NMID) USING INDEX;
ALTER TABLE OPS$PROCEDIM.TATR_ASYNC_TX_ERRORS_1 ADD CONSTRAINT "TATR_ASYNC_TX_ERRORS_1_CK01" CHECK ("NMID" IS NOT NULL);
ALTER TABLE OPS$PROCEDIM.TATR_ASYNC_TX_ERRORS_1 ADD CONSTRAINT "TATR_ASYNC_TX_ERRORS_1_CK02" CHECK ("NMPROCESS_ID" IS NOT NULL);
ALTER TABLE OPS$PROCEDIM.TATR_ASYNC_TX_ERRORS_1 ADD CONSTRAINT "TATR_ASYNC_TX_ERRORS_1_CK03" CHECK ("CDCORRELATION_ID" IS NOT NULL);
ALTER TABLE OPS$PROCEDIM.TATR_ASYNC_TX_ERRORS_1 ADD CONSTRAINT "TATR_ASYNC_TX_ERRORS_1_CK04" CHECK ("DSERROR_MESSAGE" IS NOT NULL);
ALTER TABLE OPS$PROCEDIM.TATR_ASYNC_TX_ERRORS_1 ADD CONSTRAINT "TATR_ASYNC_TX_ERRORS_1_CK05" CHECK ("FECREATED_AT" IS NOT NULL);

--@review Trigger para autonumerico y fecha de creacion
CREATE OR REPLACE TRIGGER OPS$PROCEDIM.TRG_ATR_BEF_INS_TX_ERRORS_1
BEFORE INSERT ON OPS$PROCEDIM.TATR_ASYNC_TX_ERRORS_1
FOR EACH ROW
BEGIN
  IF :NEW.NMID IS NULL THEN
    :NEW.NMID := OPS$PROCEDIM.SEQ_ATR_ASYNC_TX_ERRORS_NMID_1.NEXTVAL;
  END IF;
  IF :NEW.FECREATED_AT IS NULL THEN
    :NEW.FECREATED_AT := CURRENT_TIMESTAMP;
  END IF;
END TRG_ATR_BEF_INS_TX_ERRORS_1;
/
ALTER TRIGGER OPS$PROCEDIM.TRG_ATR_BEF_INS_TX_ERRORS_1 ENABLE;


-- ========= TABLA PRINCIPAL REGISTRO DE TRANSACCIONES ASINCRONAS HISTORICO =========

CREATE TABLE OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1 (
    NMID NUMBER(38),
    CDCORRELATION_ID VARCHAR2(36),
    CDREQUEST_ID VARCHAR2(50),
    DSTARGET_SYSTEM VARCHAR2(50),
    DSTARGET_SYSTEM_PROCESS VARCHAR2(100),
    DSSOURCE_APPLICATION_NAME VARCHAR2(100),
    SNIS_BATCH_OPERATION NUMBER(1),       -- Orignal boolean pero no compatible con oracle 19c
    NMSTATUS NUMBER(2),
    DSREQUEST_CLOB CLOB,
    FECREATED_AT TIMESTAMP,
    FEIN_PROGRESS_AT TIMESTAMP,
    FEREQ_COMPLETED_AT TIMESTAMP,
    FERES_COMPLETED_AT TIMESTAMP,
    DSRESPONSE_CLOB CLOB,
    DSMOVE_REASON VARCHAR2(10),
    FEMOVED_TO_HISTORY_AT TIMESTAMP
);

--@review Comentarios de tabla y columnas para TATR_ASYNC_TX_HISTORY_1
COMMENT ON TABLE OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1 IS 'Tabla historica que almacena las transacciones asincronas que han sido completadas o movidas por exceso de errores.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1.NMID IS 'Identificador unico de la transaccion historica. Clave primaria.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1.CDCORRELATION_ID IS 'Identificador de correlacion para rastrear la transaccion entre sistemas.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1.CDREQUEST_ID IS 'Identificador de la solicitud original enviada al sistema destino.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1.DSTARGET_SYSTEM IS 'Nombre del sistema destino al que se envio la transaccion.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1.DSTARGET_SYSTEM_PROCESS IS 'Nombre del proceso especifico en el sistema destino.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1.DSSOURCE_APPLICATION_NAME IS 'Nombre de la aplicacion fuente que origino la transaccion.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1.SNIS_BATCH_OPERATION IS 'Indicador numerico de proceso por lotes (1) o individual (0).';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1.NMSTATUS IS 'Estado numerico de la transaccion historica.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1.DSREQUEST_CLOB IS 'Datos de la solicitud original en formato CLOB.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1.FECREATED_AT IS 'Fecha y hora de creacion del registro original.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1.FEIN_PROGRESS_AT IS 'Fecha y hora en que la transaccion paso a estado en progreso.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1.FEREQ_COMPLETED_AT IS 'Fecha y hora en que la solicitud fue completada.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1.FERES_COMPLETED_AT IS 'Fecha y hora en que la respuesta fue completada.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1.DSRESPONSE_CLOB IS 'Datos de la respuesta en formato CLOB.';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1.DSMOVE_REASON IS 'Motivo del movimiento a historico (COMPLETED/MAX_ERRORS).';
COMMENT ON COLUMN OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1.FEMOVED_TO_HISTORY_AT IS 'Fecha y hora en que el registro fue movido a historico.';

--@review Constraints fuera de la tabla por estandar
ALTER TABLE OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1 ADD CONSTRAINT "TATR_ASYNC_TX_HISTORY_1_PK" PRIMARY KEY (NMID) USING INDEX;
ALTER TABLE OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1 ADD CONSTRAINT "TATR_ASYNC_TX_HISTORY_1_CK01" CHECK ("NMID" IS NOT NULL);

CREATE INDEX OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1_I01 ON OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1 (NMSTATUS);

--@review Trigger para asignar fecha de movimiento a historico
CREATE OR REPLACE TRIGGER OPS$PROCEDIM.TRG_ATR_BEF_INS_TX_HISTORY_1
BEFORE INSERT ON OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1
FOR EACH ROW
BEGIN
  IF :NEW.FEMOVED_TO_HISTORY_AT IS NULL THEN
    :NEW.FEMOVED_TO_HISTORY_AT := CURRENT_TIMESTAMP;
  END IF;
END TRG_ATR_BEF_INS_TX_HISTORY_1;
/
ALTER TRIGGER OPS$PROCEDIM.TRG_ATR_BEF_INS_TX_HISTORY_1 ENABLE;

-- ========= PROCEDIMIENTO PARA MOVER REGISTROS A HISTORICO =========
--@review se cambia el nombre demaciado largo de SP_ATR_ASYNC_TX_MOVE_TO_HISTORY_1 a SP_ATR_ASYNC_TX_MOVE_HISTORY_1
CREATE OR REPLACE PROCEDURE OPS$PROCEDIM.SP_ATR_ASYNC_TX_MOVE_HISTORY_1
IS
    v_success_count     NUMBER := 0;
    v_error_count       NUMBER := 0;
    v_error_message     VARCHAR2(4000);
    v_error_count_by_process NUMBER := 0;
BEGIN
    -- Cursor para registros completados (STATUS = 4)
    FOR rec IN (
        SELECT * FROM OPS$PROCEDIM.TATR_ASYNC_TX_1
        WHERE FEREQ_COMPLETED_AT IS NOT NULL
          AND NMSTATUS = 4
    )
    LOOP
        BEGIN
            INSERT INTO OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1 (
                NMID,
                CDCORRELATION_ID,
                CDREQUEST_ID,
                DSTARGET_SYSTEM,
                DSTARGET_SYSTEM_PROCESS,
                DSSOURCE_APPLICATION_NAME,
                SNIS_BATCH_OPERATION,
                NMSTATUS,
                DSREQUEST_CLOB,
                FECREATED_AT,
                FEIN_PROGRESS_AT,
                FEREQ_COMPLETED_AT,
                FERES_COMPLETED_AT,
                DSRESPONSE_CLOB,
                DSMOVE_REASON,
                FEMOVED_TO_HISTORY_AT
            ) VALUES (
                rec.NMID,
                rec.CDCORRELATION_ID,
                rec.CDREQUEST_ID,
                rec.DSTARGET_SYSTEM,
                rec.DSTARGET_SYSTEM_PROCESS,
                rec.DSSOURCE_APPLICATION_NAME,
                rec.SNIS_BATCH_OPERATION,
                rec.NMSTATUS,
                rec.DSREQUEST_CLOB,
                rec.FECREATED_AT,
                rec.FEIN_PROGRESS_AT,
                rec.FEREQ_COMPLETED_AT,
                rec.FERES_COMPLETED_AT,
                rec.DSRESPONSE_CLOB,
                'COMPLETED', SYSTIMESTAMP
            );

            DELETE FROM OPS$PROCEDIM.TATR_ASYNC_TX_1 WHERE NMID = rec.NMID;
            
            v_success_count := v_success_count + 1;
        EXCEPTION
            WHEN OTHERS THEN
                v_error_count := v_error_count + 1;
                v_error_message := 'Error moviendo ID=' || rec.NMID || ': ' || SQLERRM;
                DBMS_OUTPUT.PUT_LINE(v_error_message);
        END;
    END LOOP;

    -- Cursor para registros con mas de 10 errores
    FOR rec IN (
        SELECT t.* FROM OPS$PROCEDIM.TATR_ASYNC_TX_1 t
        WHERE EXISTS (
            SELECT 1 
            FROM OPS$PROCEDIM.TATR_ASYNC_TX_ERRORS_1 e
            WHERE e.NMPROCESS_ID = t.NMID
            GROUP BY e.NMPROCESS_ID
            HAVING COUNT(*) > 10
        )
    )
    LOOP
        BEGIN
            -- Contar errores para este proceso
            SELECT COUNT(*)
            INTO v_error_count_by_process
            FROM OPS$PROCEDIM.TATR_ASYNC_TX_ERRORS_1
            WHERE NMPROCESS_ID = rec.NMID;


             INSERT INTO OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1 (
                NMID,
                CDCORRELATION_ID,
                CDREQUEST_ID,
                DSTARGET_SYSTEM,
                DSTARGET_SYSTEM_PROCESS,
                DSSOURCE_APPLICATION_NAME,
                SNIS_BATCH_OPERATION,
                NMSTATUS,
                DSREQUEST_CLOB,
                FECREATED_AT,
                FEIN_PROGRESS_AT,
                FEREQ_COMPLETED_AT,
                FERES_COMPLETED_AT,
                DSRESPONSE_CLOB,
                DSMOVE_REASON,
                FEMOVED_TO_HISTORY_AT
            ) VALUES (
                rec.NMID,
                rec.CDCORRELATION_ID,
                rec.CDREQUEST_ID,
                rec.DSTARGET_SYSTEM,
                rec.DSTARGET_SYSTEM_PROCESS,
                rec.DSSOURCE_APPLICATION_NAME,
                rec.SNIS_BATCH_OPERATION,
                rec.NMSTATUS,
                rec.DSREQUEST_CLOB,
                rec.FECREATED_AT,
                rec.FEIN_PROGRESS_AT,
                rec.FEREQ_COMPLETED_AT,
                rec.FERES_COMPLETED_AT,
                rec.DSRESPONSE_CLOB,
                'MAX_ERRORS', SYSTIMESTAMP
            );


            DELETE FROM OPS$PROCEDIM.TATR_ASYNC_TX_1 WHERE NMID = rec.NMID;
            
            v_success_count := v_success_count + 1;
            
            DBMS_OUTPUT.PUT_LINE('Movido por exceso de errores - ID: ' || rec.NMID || 
                               ', Total errores: ' || v_error_count_by_process);
        EXCEPTION
            WHEN OTHERS THEN
                v_error_count := v_error_count + 1;
                v_error_message := 'Error moviendo por errores ID=' || rec.NMID || ': ' || SQLERRM;
                DBMS_OUTPUT.PUT_LINE(v_error_message);
        END;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Proceso completado. Exitos: ' || v_success_count || ', Errores: ' || v_error_count);
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error general en el procedimiento: ' || SQLERRM);
        RAISE;
END;
/

-- JOB PARA EJECUTAR EL PROCEDIMIENTO DE MOVIMIENTO A HISTORICO
-- NOTA: Por estandar, la creacion del job debe ejecutarse manualmente o en un script de post-deploy.
-- Ejemplo de bloque a ejecutar aparte:

-- BEGIN
--     DBMS_SCHEDULER.CREATE_JOB (
--         job_name        => 'OPS$PROCEDIM.JOB_ATR_ASYNC_TX_MOVE_TO_HISTORY_1',
--         job_type        => 'STORED_PROCEDURE',
--         job_action      => 'OPS$PROCEDIM.SP_ATR_ASYNC_TX_MOVE_HISTORY_1',
--         repeat_interval => 'FREQ=SECONDLY; INTERVAL=5',
--         enabled         => TRUE,
--         comments       => 'Job para mover registros completados a la tabla historica cada minuto'
--     );
-- END;

-- GRANTS DE SEGURIDAD PARA USUARIOS OPS$ADM_ATR, ADM_ATR, OPS$PROCEDIM, OPS$SINI

GRANT SELECT, INSERT, UPDATE, DELETE ON OPS$PROCEDIM.TATR_ASYNC_TX_1 TO OPS$ADM_ATR;
GRANT SELECT, INSERT, UPDATE, DELETE ON OPS$PROCEDIM.TATR_ASYNC_TX_1 TO ADM_ATR;
GRANT SELECT, INSERT, UPDATE, DELETE ON OPS$PROCEDIM.TATR_ASYNC_TX_1 TO OPS$PROCEDIM;
GRANT SELECT, INSERT, UPDATE, DELETE ON OPS$PROCEDIM.TATR_ASYNC_TX_1 TO OPS$SINI;

GRANT SELECT, INSERT, UPDATE, DELETE ON OPS$PROCEDIM.TATR_ASYNC_TX_ERRORS_1 TO OPS$ADM_ATR;
GRANT SELECT, INSERT, UPDATE, DELETE ON OPS$PROCEDIM.TATR_ASYNC_TX_ERRORS_1 TO ADM_ATR;
GRANT SELECT, INSERT, UPDATE, DELETE ON OPS$PROCEDIM.TATR_ASYNC_TX_ERRORS_1 TO OPS$PROCEDIM;
GRANT SELECT, INSERT, UPDATE, DELETE ON OPS$PROCEDIM.TATR_ASYNC_TX_ERRORS_1 TO OPS$SINI;

GRANT SELECT, INSERT, UPDATE, DELETE ON OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1 TO OPS$ADM_ATR;
GRANT SELECT, INSERT, UPDATE, DELETE ON OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1 TO ADM_ATR;
GRANT SELECT, INSERT, UPDATE, DELETE ON OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1 TO OPS$PROCEDIM;
GRANT SELECT, INSERT, UPDATE, DELETE ON OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1 TO OPS$SINI;
