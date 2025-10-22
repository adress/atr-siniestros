SET SERVEROUTPUT ON SIZE UNLIMITED;

DECLARE
  l_response_json   CLOB;               -- salida cruda (JSON completo)
  l_response_obj    JSON_OBJECT_T;      -- salida parseada (objeto JSON)
  l_msg_tec         VARCHAR2(4000);
  l_msg_usr         VARCHAR2(4000);
  l_sel             CLOB := '{"cliente":{"indicador":"C123","opciones":[{"campo":"valor"}]}}';
BEGIN
  DBMS_OUTPUT.PUT_LINE('=== 🔄 INICIO PRUEBA SP_ORQUESTAR_CONSULTA_S ===');

  PCK_FENIX2_APIGEE_CONSULTA.SP_ORQUESTAR_CONSULTA_S(
    ivaTargetSystem           => 'sap',
    ivaTargetSystemProcess    => 'consultasdoc_cxc',
    ivaSourceApplicationName  => 'glo',
    ivaIntegrationMethod      => 'bd-sync',
    ivaCorrelationId          => NULL,
    ivaIsBatchOperation       => 'false',
    ivaRefSrc1                => 'REF-001',
    ivaOauthUrl               => NULL,
    ivaSistemaOrigen          => 'P8',
    ivaClaseCuenta            => 'CXC',
    ivaEstado                 => 'ACTIVO',
    ivaSeleccion              => l_sel,
    ivaMetodoHttp             => 'POST',
    ivaTimeout                => 10,
    ocaRespuestaJSON          => l_response_json,  -- <== ahora se llama así
    ocoRespuestaObj           => l_response_obj,   -- <== nuevo OUT tipo JSON_OBJECT_T
    ovaMensajeTecnico         => l_msg_tec,
    ovaMensajeUsuario         => l_msg_usr
  );

  DBMS_OUTPUT.PUT_LINE('--- 🧾 RESULTADO FINAL ---');
  DBMS_OUTPUT.PUT_LINE('Mensaje Técnico : ' || NVL(l_msg_tec, '(sin error)'));
  DBMS_OUTPUT.PUT_LINE('Mensaje Usuario : ' || NVL(l_msg_usr, '(sin error)'));
  DBMS_OUTPUT.PUT_LINE('--- 📦 JSON COMPLETO ---');
  IF l_response_json IS NOT NULL THEN
    DBMS_OUTPUT.PUT_LINE(DBMS_LOB.SUBSTR(l_response_json, 4000, 1));
  ELSE
    DBMS_OUTPUT.PUT_LINE('(sin respuesta JSON)');
  END IF;

  DBMS_OUTPUT.PUT_LINE('--- 🔍 CAMPOS CLAVE DEL OBJETO PARSEADO ---');
  IF l_response_obj IS NOT NULL THEN
    -- Ejemplo: leer algunos campos si existen
    IF l_response_obj.has('control') THEN
      DBMS_OUTPUT.PUT_LINE('Sistema Origen: ' ||
        l_response_obj.get_Object('control').get_String('sistemaOrigen'));
    END IF;

    IF l_response_obj.has('documentos') THEN
      DBMS_OUTPUT.PUT_LINE('Número de documentos: ' ||
        TO_CHAR(l_response_obj.get_Array('documentos').get_size));
    END IF;
  ELSE
    DBMS_OUTPUT.PUT_LINE('(no se generó objeto parseado)');
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('❌ EXCEPCIÓN EN BLOQUE DE PRUEBA: ' || SQLERRM);
END;
/
 