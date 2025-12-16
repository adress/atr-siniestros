-- Si tienes privilegios de DBA:
SELECT owner, object_type, object_name, status
FROM   dba_objects
WHERE  owner = 'OPS$PROCEDIM'
AND    object_name = 'PCK_CPI_INTEGRATION_V2';




SELECT line, position, text
FROM   all_errors
WHERE  owner = 'OPS$PROCEDIM'
AND    name = 'PCK_GNL_INTEGRATION_UTILS'
ORDER  BY sequence;




-- para duplicar el bug
-- VARIAS RESERVAS

SELECT s.EXPEDIENTE, s.FECHA_APERTURA, COUNT(*) AS cantidad_reservas
  FROM SINIESTROS s
  JOIN RESERVAS r ON r.EXPEDIENTE = s.EXPEDIENTE
WHERE S.SITUACION = 'A' AND (S.CDRAMO != '083' AND R.CDGARANTIA NOT IN ('VID', 'ITP')) AND S.CDRAMO IN ('081', '083', '084', '085', '086', '181')
GROUP BY s.EXPEDIENTE, s.FECHA_APERTURA
HAVING COUNT(*) > 1
ORDER BY s.FECHA_APERTURA DESC;



--error  obtenido

 0810099711056
 
Fecha/Hora: 2025-12-15 14:24:08Expediente: 0810099700864SQLCODE: -1422SQLERRM: ORA-01422: exact fetch returns more than requested number of rowsError Stack: ORA-01422: exact fetch returns more than requested number of rowsCall Stack: ----- PL/SQL Call Stack -----object      line  objecthandle    number  name7000100bd0fdab8       150  package body OPS$PROCEDIM.PCK_SIN_GESTOR_SAP.SP_ENVIAR_MENSAJE_CXP7000100c0fa3a90     23629  package body OPS$PROCEDIM.PCK_SIN_ATR.SP_PAGOS_MANUALES700010057bb75f0         1  anonymous blockBacktrace: ORA-06512: at "OPS$PROCEDIM.PCK_SIN_GESTOR_SAP", line 96- usu:Ocurri?? error inesperado. Por favor contacte al administrador | Mensaje usuario: Error llevando a SAP