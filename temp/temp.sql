-- Si tienes privilegios de DBA:
SELECT owner, object_type, object_name, status
FROM   dba_objects
WHERE  owner = 'OPS$PROCEDIM'
AND    object_name = 'PCK_SIN_GESTOR_SAP';


SELECT line, position, text
FROM   all_errors
WHERE  owner = 'OPS$PROCEDIM'
AND    name = 'PCK_GNL_INTEGRATION_UTILS'
ORDER  BY sequence;
