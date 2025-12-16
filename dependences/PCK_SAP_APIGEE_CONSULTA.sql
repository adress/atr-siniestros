
  CREATE OR REPLACE PACKAGE OPS$PROCEDIM.PCK_SAP_APIGEE_CONSULTA AS
  /*
    ********************************************************************************************
    * ESPECIFICACIÓN DEL PAQUETE (PCK_SAP_APIGEE_CONSULTA)
    * Creado para manejar la lógica de integración con servicios externos a través de APIGEE.
    * #author Santiago Gonzales (creado el 28/10/2025)
    * #version 1.0.0
    ********************************************************************************************
  */

  ----------------------------------------------------------------------------
  -- Constantes
  ----------------------------------------------------------------------------
  C_DEFAULT_WALLET_PATH CONSTANT VARCHAR2(500) := 'file:/oracle/app/oracle/wallet3';

  /*
    * Procedimiento: SP_GENERAR_JSON_HEADER_FENIX_APIGEE
    * Descripción  : Genera el JSON de header para integración APIGEE.
    *               Obtiene el access_token vía OAuth2 usando usuario/clave de TCOB_PARAMETROS_SAP,
    *               y lo coloca en el header "token".
    *               Además, obtiene la URL de destino (DSNAME_SPACE) y la URL de OAuth (DSNAME_CREDENTIALS)
    *               desde la tabla y las incluye en el header como "url-destino" y "oauth-url".
  */
  PROCEDURE SP_GENERAR_JSON_HEADER_FENIX_APIGEE (
    ivaTargetSystem           IN  VARCHAR2,
    ivaTargetSystemProcess    IN  VARCHAR2,
    ivaSourceApplicationName  IN  VARCHAR2,
    ivaIntegrationMethod      IN  VARCHAR2,
    ivaCorrelationId          IN  VARCHAR2,
    ivaIsBatchOperation       IN  VARCHAR2 DEFAULT NULL,
    ivaRefSrc1                IN  VARCHAR2,
    ivaOauthUrl               IN  VARCHAR2,
    ocaJsonHeader             OUT CLOB,
    ovaMensajeTecnico         OUT VARCHAR2,
    ovaMensajeUsuario         OUT VARCHAR2
  );

  /*
    * Procedimiento: SP_GENERAR_JSON_BODY_FENIX_APIGEE
    * Descripción  : Genera el JSON de body de consultas para integración via APIGEE
  */
  PROCEDURE SP_GENERAR_JSON_BODY_FENIX_APIGEE (
    ivaSistemaOrigen          IN  VARCHAR2,
    ivaClaseCuenta            IN  VARCHAR2,
    ivaEstado                 IN  VARCHAR2,
    ivaSeleccion              IN  CLOB,
    ocaJsonBody               OUT CLOB,
    ovaMensajeTecnico         OUT VARCHAR2,
    ovaMensajeUsuario         OUT VARCHAR2
  );

  /*
    * Procedimiento: SP_LLAMAR_GNL_CALL_SYNC_FENIX_APIGEE
    * Descripción  : Llama a FN_GNL_CALL_SYNC usando los headers (en CLOB), el token recibido,
    *                y el body. La URL de destino se obtiene del campo "url-destino" del header.
    *                Actualiza el campo "token" en los headers antes de la llamada.
  */
  PROCEDURE SP_LLAMAR_GNL_CALL_SYNC_FENIX_APIGEE (
    ivaMetodo          IN VARCHAR2,
    ivaHeaders         IN CLOB,
    ivaToken           IN VARCHAR2,
    ivaBody            IN CLOB,
    ivaTimeout         IN NUMBER DEFAULT 30,
    ivaWalletPath      IN VARCHAR2 DEFAULT C_DEFAULT_WALLET_PATH,
    ocaRespuesta       OUT CLOB,
    ovaMensajeTecnico  OUT VARCHAR2,
    ovaMensajeUsuario  OUT VARCHAR2
  );

END PCK_SAP_APIGEE_CONSULTA;
/
CREATE OR REPLACE PACKAGE BODY OPS$PROCEDIM.PCK_SAP_APIGEE_CONSULTA AS

  ----------------------------------------------------------------------------
  -- Helpers locales
  ----------------------------------------------------------------------------
  FUNCTION F_NVL(v IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN NVL(v, '');
  END F_NVL;

  ----------------------------------------------------------------------------
  -- HEADER
  ----------------------------------------------------------------------------
  PROCEDURE SP_GENERAR_JSON_HEADER_FENIX_APIGEE (
    ivaTargetSystem           IN  VARCHAR2,
    ivaTargetSystemProcess    IN  VARCHAR2,
    ivaSourceApplicationName  IN  VARCHAR2,
    ivaIntegrationMethod      IN  VARCHAR2,
    ivaCorrelationId          IN  VARCHAR2,
    ivaIsBatchOperation       IN  VARCHAR2 DEFAULT NULL,
    ivaRefSrc1                IN  VARCHAR2,
    ivaOauthUrl               IN  VARCHAR2,
    ocaJsonHeader             OUT CLOB,
    ovaMensajeTecnico         OUT VARCHAR2,
    ovaMensajeUsuario         OUT VARCHAR2
  ) IS
    --------------------------------------------------------------------
    -- Variables de credenciales y token
    --------------------------------------------------------------------
    v_usuario          VARCHAR2(200);
    v_clave            CLOB;
    v_url_destino      VARCHAR2(500);
    v_oauth_url        VARCHAR2(500);
    v_token            VARCHAR2(4000);
    v_correlation_id   VARCHAR2(100);
    v_response         CLOB;
    v_json_resp        JSON_OBJECT_T;
   
    v_req              UTL_HTTP.REQ;
    v_resp             UTL_HTTP.RESP;
    v_line             VARCHAR2(32767);

    v_missing_fields   VARCHAR2(4000);

    --------------------------------------------------------------------
    -- Función inline para chequear campos obligatorios
    --------------------------------------------------------------------
    FUNCTION check_flag(p_val VARCHAR2, p_name VARCHAR2, p_accum VARCHAR2) RETURN VARCHAR2 IS
      BEGIN
          IF TRIM(F_NVL(p_val)) IS NULL OR TRIM(F_NVL(p_val)) = '' THEN
              RETURN p_accum || p_name || ', ';
          ELSE
              RETURN p_accum;
          END IF;
      END;

  BEGIN
      ovaMensajeTecnico := NULL;
      ovaMensajeUsuario := NULL;
      ocaJsonHeader     := NULL;

      --------------------------------------------------------------------
      -- 1) Obtener credenciales desde tabla
      --------------------------------------------------------------------
      BEGIN
          SELECT CDUSUARIO, CDCLAVE, DSNAME_SPACE, DSPUERTO
            INTO v_usuario, v_clave, v_url_destino, v_oauth_url
            FROM TCOB_PARAMETROS_SAP
          WHERE CDSERVICIO = ivaTargetSystem
            AND CDPROCESO = ivaSourceApplicationName;

    DBMS_OUTPUT.PUT_LINE('v_clave=' || v_clave);


          -- Decodificar clave Base64
          BEGIN
              v_clave := UTL_RAW.CAST_TO_VARCHAR2(
                          UTL_ENCODE.BASE64_DECODE(
                              UTL_RAW.CAST_TO_RAW(v_clave)
                          )
                        );
          EXCEPTION
              WHEN OTHERS THEN NULL; -- Ignorar fallo de decode
          END;

      EXCEPTION
          WHEN NO_DATA_FOUND THEN
              ovaMensajeTecnico := 'No se encontraron credenciales/URLs para los parámetros proporcionados.';
              ovaMensajeUsuario := 'No se encontraron credenciales/URLs para la integración solicitada.';
              RETURN;
          WHEN OTHERS THEN
              ovaMensajeTecnico := 'Error inesperado al obtener credenciales/URLs: ' || SQLERRM;
              ovaMensajeUsuario := 'Ocurrió un error al obtener credenciales/URLs.';
              RETURN;
      END;

      DBMS_OUTPUT.PUT_LINE('v_clave 1 =' || v_clave);

      --------------------------------------------------------------------
      -- 2) Obtener token OAuth2
      --------------------------------------------------------------------
      BEGIN
          DECLARE
              v_post_body VARCHAR2(4000);
          BEGIN
              v_post_body := 'client_id=' || v_usuario || CHR(38) || 'client_secret=' || v_clave;

              UTL_HTTP.SET_WALLET(C_DEFAULT_WALLET_PATH);

              v_req := UTL_HTTP.BEGIN_REQUEST(v_oauth_url, 'POST');
              UTL_HTTP.SET_HEADER(v_req, 'Content-Type', 'application/x-www-form-urlencoded');
              UTL_HTTP.SET_HEADER(v_req, 'Accept', 'application/json');
              UTL_HTTP.SET_HEADER(v_req, 'Content-Length', LENGTH(v_post_body));
              UTL_HTTP.WRITE_TEXT(v_req, v_post_body);

              v_resp := UTL_HTTP.GET_RESPONSE(v_req);

              DBMS_LOB.CREATETEMPORARY(v_response, TRUE);
              LOOP
                  BEGIN
                      UTL_HTTP.READ_LINE(v_resp, v_line, TRUE);
                      DBMS_LOB.WRITEAPPEND(v_response, LENGTH(v_line || CHR(10)), v_line || CHR(10));
                  EXCEPTION
                      WHEN UTL_HTTP.END_OF_BODY THEN EXIT;
                  END;
              END LOOP;
              UTL_HTTP.END_RESPONSE(v_resp);

              -- Parsear JSON y obtener access_token
              v_json_resp    := JSON_OBJECT_T.PARSE(v_response);
              v_token        := v_json_resp.get_String('access_token');

          EXCEPTION
              WHEN OTHERS THEN
                  v_token := NULL;
                  ovaMensajeTecnico := 'Error al obtener access_token: ' || SQLERRM;
                  ovaMensajeUsuario := 'Error al obtener token de autenticación.';
          END;
      END;

      --------------------------------------------------------------------
      -- 3) Validar token
      --------------------------------------------------------------------
      IF v_token IS NULL OR TRIM(v_token) = '' THEN
          ovaMensajeTecnico := NVL(ovaMensajeTecnico, 'No se pudo obtener el token OAuth2.');
          ovaMensajeUsuario := NVL(ovaMensajeUsuario, 'Error de autenticación: token inválido.');
          RETURN;
      END IF;

      v_correlation_id := PCK_GNL_INTEGRATION_UTILS.FN_GNL_GET_CORRELATION_ID;

      --------------------------------------------------------------------
      -- 4) Validar header obligatorios
      --------------------------------------------------------------------
      v_missing_fields := '';
      v_missing_fields := check_flag(ivaTargetSystem, 'target-system', v_missing_fields);
      v_missing_fields := check_flag(ivaTargetSystemProcess, 'target-system-process', v_missing_fields);
      v_missing_fields := check_flag(ivaSourceApplicationName, 'source-application-name', v_missing_fields);
      v_missing_fields := check_flag(ivaIntegrationMethod, 'integration-method', v_missing_fields);
      v_missing_fields := check_flag(v_correlation_id, 'correlation-id/request-id', v_missing_fields);
      v_missing_fields := check_flag(ivaIsBatchOperation, 'is-batch-operation', v_missing_fields);
      v_missing_fields := check_flag(ivaRefSrc1, 'ref-src-1', v_missing_fields);

      IF LENGTH(TRIM(v_missing_fields)) > 0 THEN
          v_missing_fields := RTRIM(v_missing_fields, ', ');
          ovaMensajeTecnico := 'Falta información obligatoria en los headers: ' || v_missing_fields || '.';
          ovaMensajeUsuario := 'Falta información obligatoria para la integración: ' || v_missing_fields || '.';
          RETURN;
      END IF;

      --------------------------------------------------------------------
      -- 5) Construir JSON header con JSON_OBJECT_T
      --------------------------------------------------------------------
      DECLARE
          v_json_obj JSON_OBJECT_T := JSON_OBJECT_T();
      BEGIN
          v_json_obj.put('target-system',           F_NVL(ivaTargetSystem));
          v_json_obj.put('target-system-process',   F_NVL(ivaTargetSystemProcess));
          v_json_obj.put('source-application-name', F_NVL(ivaSourceApplicationName));
          v_json_obj.put('integration-method',      F_NVL(ivaIntegrationMethod));
          v_json_obj.put('correlation-id',          F_NVL(v_correlation_id));
          v_json_obj.put('request-id',              F_NVL(v_correlation_id));
          v_json_obj.put('ref-src-1',               F_NVL(ivaRefSrc1));
          v_json_obj.put('token',                   F_NVL(v_token));
          v_json_obj.put('Content-Type',            'application/json');
          v_json_obj.put('User-Agent',              'insomnia/11.0.2');
          v_json_obj.put('is-batch-operation',      F_NVL(ivaIsBatchOperation));

          ocaJsonHeader := v_json_obj.to_clob;
      END;

  EXCEPTION
      WHEN OTHERS THEN
          ocaJsonHeader     := NULL;
          ovaMensajeTecnico := 'Error inesperado (HEADER): ' || SQLERRM;
          ovaMensajeUsuario := 'Ocurrió un error al generar el header de integración.';
  END SP_GENERAR_JSON_HEADER_FENIX_APIGEE;

  ----------------------------------------------------------------------------
  -- BODY
  ----------------------------------------------------------------------------
  PROCEDURE SP_GENERAR_JSON_BODY_FENIX_APIGEE (
      ivaSistemaOrigen          IN  VARCHAR2,
      ivaClaseCuenta            IN  VARCHAR2,
      ivaEstado                 IN  VARCHAR2,
      ivaSeleccion              IN  CLOB,
      ocaJsonBody               OUT CLOB,
      ovaMensajeTecnico         OUT VARCHAR2,
      ovaMensajeUsuario         OUT VARCHAR2
  ) IS
      v_seleccion_elem  JSON_ELEMENT_T;
      v_seleccion_array JSON_ARRAY_T := JSON_ARRAY_T();
      v_body_obj        JSON_OBJECT_T := JSON_OBJECT_T();

      --------------------------------------------------------------------
      -- Función auxiliar: convertir JSON_ELEMENT_T a VARCHAR2
      --------------------------------------------------------------------
      FUNCTION element_to_varchar(p_elem JSON_ELEMENT_T) RETURN VARCHAR2 IS
      BEGIN
          IF p_elem IS NULL THEN
              RETURN NULL;
          ELSIF p_elem IS OF (JSON_SCALAR_T) THEN
              RETURN TREAT(p_elem AS JSON_SCALAR_T).to_string;
          ELSE
              RETURN p_elem.to_string;
          END IF;
      END;

      --------------------------------------------------------------------
      -- Función auxiliar: normalizar "opciones"
      --------------------------------------------------------------------
      FUNCTION normalize_opciones(p_elem JSON_ELEMENT_T) RETURN JSON_ARRAY_T IS
          v_array JSON_ARRAY_T := JSON_ARRAY_T();
          v_obj   JSON_OBJECT_T;
          v_keys  JSON_KEY_LIST;
          v_item  JSON_OBJECT_T;
      BEGIN
          IF p_elem IS NULL THEN
              RETURN JSON_ARRAY_T();
          ELSIF p_elem IS OF (JSON_ARRAY_T) THEN
              RETURN TREAT(p_elem AS JSON_ARRAY_T);
          ELSIF p_elem IS OF (JSON_OBJECT_T) THEN
              v_obj := TREAT(p_elem AS JSON_OBJECT_T);
              v_keys := v_obj.get_keys;
              v_item := JSON_OBJECT_T();

              IF v_keys IS NOT NULL THEN
                  FOR i IN 1 .. v_keys.count LOOP
                      v_item.put(v_keys(i), v_obj.get(v_keys(i)));
                  END LOOP;
              END IF;

              IF v_item.get_size > 0 THEN
                  v_array.append(v_item);
              END IF;

              RETURN v_array;
          ELSE
              v_obj := JSON_OBJECT_T();
              v_obj.put('valor', p_elem);
              v_array.append(v_obj);
              RETURN v_array;
          END IF;
      END;

      --------------------------------------------------------------------
      -- Función auxiliar: normalizar un item (filtro)
      --------------------------------------------------------------------
      FUNCTION normalize_item(p_filter VARCHAR2, p_value JSON_ELEMENT_T) RETURN JSON_OBJECT_T IS
          v_item        JSON_OBJECT_T := JSON_OBJECT_T();
          v_value_obj   JSON_OBJECT_T;
          v_options     JSON_ARRAY_T;
          v_extra_obj   JSON_OBJECT_T;
          v_keys        JSON_KEY_LIST;
          v_indicator   VARCHAR2(4000) := '';
      BEGIN
          v_item.put('filtro', NVL(p_filter, ''));
          v_item.put('indicador', '');
          v_item.put('opciones', JSON_ARRAY_T());

          IF p_value IS NULL THEN
              RETURN v_item;
          ELSIF p_value IS OF (JSON_OBJECT_T) THEN
              v_value_obj := TREAT(p_value AS JSON_OBJECT_T);

              IF v_value_obj.has('indicador') THEN
                  BEGIN
                      v_indicator := NVL(v_value_obj.get_string('indicador'), '');
                  EXCEPTION
                      WHEN OTHERS THEN
                          v_indicator := NVL(element_to_varchar(v_value_obj.get('indicador')), '');
                  END;
                  v_item.put('indicador', v_indicator);
              END IF;

              v_options := normalize_opciones(v_value_obj.get('opciones'));
              IF v_options IS NULL THEN
                  v_options := JSON_ARRAY_T();
              END IF;

              v_keys := v_value_obj.get_keys;
              v_extra_obj := JSON_OBJECT_T();

              IF v_keys IS NOT NULL THEN
                  FOR i IN 1 .. v_keys.count LOOP
                      IF v_keys(i) NOT IN ('indicador', 'opciones') THEN
                          v_extra_obj.put(v_keys(i), v_value_obj.get(v_keys(i)));
                      END IF;
                  END LOOP;
              END IF;

              IF v_extra_obj.get_size > 0 THEN
                  v_options.append(v_extra_obj);
              END IF;

              v_item.put('opciones', v_options);
          ELSE
              v_indicator := NVL(element_to_varchar(p_value), '');
              v_item.put('indicador', v_indicator);
              v_item.put('opciones', JSON_ARRAY_T());
          END IF;

          RETURN v_item;
      END;

      --------------------------------------------------------------------
      -- Función auxiliar: normalizar "seleccion"
      --------------------------------------------------------------------
      FUNCTION normalize_seleccion(p_elem JSON_ELEMENT_T) RETURN JSON_ARRAY_T IS
          v_result JSON_ARRAY_T := JSON_ARRAY_T();
          v_obj    JSON_OBJECT_T;
          v_keys   JSON_KEY_LIST;
      BEGIN
          IF p_elem IS NULL THEN
              RETURN JSON_ARRAY_T();
          ELSIF p_elem IS OF (JSON_ARRAY_T) THEN
              RETURN TREAT(p_elem AS JSON_ARRAY_T);
          ELSIF p_elem IS OF (JSON_OBJECT_T) THEN
              v_obj := TREAT(p_elem AS JSON_OBJECT_T);
              v_keys := v_obj.get_keys;

              IF v_keys IS NOT NULL THEN
                  FOR i IN 1 .. v_keys.count LOOP
                      v_result.append(normalize_item(v_keys(i), v_obj.get(v_keys(i))));
                  END LOOP;
              END IF;

              RETURN v_result;
          ELSE
              v_result.append(normalize_item('valor', p_elem));
              RETURN v_result;
          END IF;
      END;

  BEGIN
      ovaMensajeTecnico := NULL;
      ovaMensajeUsuario := NULL;
      ocaJsonBody       := NULL;

      --------------------------------------------------------------------
      -- Parsear y normalizar seleccion
      --------------------------------------------------------------------
      IF ivaSeleccion IS NOT NULL THEN
          BEGIN
              v_seleccion_elem := JSON_ELEMENT_T.parse(ivaSeleccion);
              v_seleccion_array := normalize_seleccion(v_seleccion_elem);
          EXCEPTION
              WHEN OTHERS THEN
                  ovaMensajeTecnico := 'Error al interpretar la estructura de seleccion (BODY): ' || SQLERRM;
                  ovaMensajeUsuario := 'La estructura de filtros de la consulta no es válida.';
                  RETURN;
          END;
      END IF;

      --------------------------------------------------------------------
      -- Construir JSON final usando JSON_OBJECT_T
      --------------------------------------------------------------------
      DECLARE
          v_control_obj      JSON_OBJECT_T := JSON_OBJECT_T();
          v_tipoConsulta_obj JSON_OBJECT_T := JSON_OBJECT_T();
          v_datosConsulta_obj JSON_OBJECT_T := JSON_OBJECT_T();
      BEGIN
          -- Control
          v_control_obj.put('sistemaOrigen', NVL(ivaSistemaOrigen, ''));

          -- tipoConsulta
          v_tipoConsulta_obj.put('claseCuenta', NVL(ivaClaseCuenta, ''));
          v_tipoConsulta_obj.put('estado', NVL(ivaEstado, ''));

          -- datosConsulta
          v_datosConsulta_obj.put('tipoConsulta', v_tipoConsulta_obj);
          v_datosConsulta_obj.put('seleccion', v_seleccion_array);

          -- Body final
          v_body_obj.put('control', v_control_obj);
          v_body_obj.put('datosConsulta', v_datosConsulta_obj);

          ocaJsonBody := v_body_obj.to_clob;
      END;

  EXCEPTION
      WHEN OTHERS THEN
          ocaJsonBody       := NULL;
          ovaMensajeTecnico := 'Error inesperado (BODY): ' || SQLERRM;
          ovaMensajeUsuario := 'Ocurrió un error al generar el body de integración.';
  END SP_GENERAR_JSON_BODY_FENIX_APIGEE;

  ----------------------------------------------------------------------------
  -- PROCEDIMIENTO: LLAMAR FN_GNL_CALL_SYNC CON TOKEN Y HEADERS
  ----------------------------------------------------------------------------
  PROCEDURE SP_LLAMAR_GNL_CALL_SYNC_FENIX_APIGEE (
    ivaMetodo          IN VARCHAR2,
    ivaHeaders         IN CLOB,
    ivaToken           IN VARCHAR2,
    ivaBody            IN CLOB,
    ivaTimeout         IN NUMBER DEFAULT 30,
    ivaWalletPath      IN VARCHAR2 DEFAULT C_DEFAULT_WALLET_PATH,
    ocaRespuesta       OUT CLOB,
    ovaMensajeTecnico  OUT VARCHAR2,
    ovaMensajeUsuario  OUT VARCHAR2
  ) IS
      --------------------------------------------------------------------
      -- Variables
      --------------------------------------------------------------------
      v_headers_obj  JSON_OBJECT_T;
      v_headers_str  CLOB;
      v_result       CLOB;
      v_url_destino  VARCHAR2(500);
      v_wallet_path  VARCHAR2(500);
      v_target_system VARCHAR2(100);
      v_source_app    VARCHAR2(100);

  BEGIN
      ovaMensajeTecnico := NULL;
      ovaMensajeUsuario := NULL;
      ocaRespuesta      := NULL;

      v_wallet_path := NVL(ivaWalletPath, C_DEFAULT_WALLET_PATH);

      --------------------------------------------------------------------
      -- 1) Parsear headers y actualizar token
      --------------------------------------------------------------------
      BEGIN
          v_headers_obj := JSON_OBJECT_T.parse(ivaHeaders);
          v_headers_obj.put('token', ivaToken);
          v_headers_str := v_headers_obj.to_clob;

          -- Validar campos obligatorios
          IF NOT v_headers_obj.has('target-system') OR NOT v_headers_obj.has('source-application-name') THEN
              ovaMensajeTecnico := 'Headers JSON no contienen "target-system" o "source-application-name".';
              ovaMensajeUsuario := 'Faltan datos obligatorios en los headers.';
              RETURN;
          END IF;

          v_target_system := v_headers_obj.get_string('target-system');
          v_source_app    := v_headers_obj.get_string('source-application-name');
      EXCEPTION
          WHEN OTHERS THEN
              ovaMensajeTecnico := 'Error al procesar headers JSON: ' || SQLERRM;
              ovaMensajeUsuario := 'Ocurrió un error al preparar los headers para la integración.';
              RETURN;
      END;

      --------------------------------------------------------------------
      -- 2) Obtener URL destino desde tabla de parámetros
      --------------------------------------------------------------------
      BEGIN
          SELECT DSNAME_SPACE
            INTO v_url_destino
            FROM TCOB_PARAMETROS_SAP
          WHERE CDSERVICIO = v_target_system
            AND CDPROCESO = v_source_app;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
              ovaMensajeTecnico := 'No se encontró URL destino (DSNAME_SPACE) para TARGET_SYSTEM='
                                  || v_target_system || ' y SOURCE_APPLICATION_NAME=' || v_source_app || '.';
              ovaMensajeUsuario := 'No se encontró configuración de URL destino.';
              RETURN;
          WHEN OTHERS THEN
              ovaMensajeTecnico := 'Error inesperado al obtener URL destino: ' || SQLERRM;
              ovaMensajeUsuario := 'Ocurrió un error al obtener URL destino.';
              RETURN;
      END;

      --------------------------------------------------------------------
      -- 3) Llamada sincrónica usando FN_GNL_CALL_SYNC
      --------------------------------------------------------------------
      BEGIN
          v_result := PCK_GNL_INTEGRATION_UTILS.FN_GNL_CALL_SYNC(
                          p_url         => v_url_destino,
                          p_method      => ivaMetodo,
                          p_headers     => v_headers_str,
                          p_body        => ivaBody,
                          p_timeout     => ivaTimeout,
                          p_wallet_path => v_wallet_path
                      );
          ocaRespuesta := v_result;
      EXCEPTION
          WHEN OTHERS THEN
              ovaMensajeTecnico := 'Error al invocar FN_GNL_CALL_SYNC: ' || SQLERRM;
              ovaMensajeUsuario := 'Error al realizar la integración sincrónica.';
              RETURN;
      END;

  END SP_LLAMAR_GNL_CALL_SYNC_FENIX_APIGEE;

END PCK_SAP_APIGEE_CONSULTA;
/