-- 1 **************** PACKAGE: utilitario de consulta

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

-- 1 **************** PACKAGE: intermedio de consulta


  CREATE OR REPLACE  PACKAGE OPS$PROCEDIM.PCK_CXP_CONSULTA_EST_ATR AS
  PROCEDURE PR_CONSULTAR_ESTADO(
    i_cdCompania            IN  VARCHAR2,
    i_dsNitAcreedor         IN  VARCHAR2,
    i_cdTipoIdentificacion  IN  VARCHAR2,
    i_dsReferencia          IN  VARCHAR2,
    i_sistema_origen        IN  VARCHAR2,
    i_estado                IN  VARCHAR2,
    o_estado                OUT VARCHAR2,
    o_fecha_compensacion    OUT DATE,
    o_importe               OUT NUMBER,
    o_usuario               OUT VARCHAR2,
    o_fecha_posible_pago    OUT DATE,
    o_msj_tecnico           OUT VARCHAR2,
    o_msj_usuario           OUT VARCHAR2
  );
END PCK_CXP_CONSULTA_EST_ATR;
/
CREATE OR REPLACE  PACKAGE BODY OPS$PROCEDIM.PCK_CXP_CONSULTA_EST_ATR AS
  c_len_msg CONSTANT PLS_INTEGER := 255;

  ---------------------------------------------------------------------------
  -- Utilitarios (respuesta)
  ---------------------------------------------------------------------------
  FUNCTION get_str_any(p_obj JSON_OBJECT_T, p_k1 VARCHAR2, p_k2 VARCHAR2 DEFAULT NULL)
    RETURN VARCHAR2
  IS
  BEGIN
    IF p_obj IS NULL THEN
      RETURN NULL;
    END IF;

    IF p_k1 IS NOT NULL AND p_obj.has(p_k1) THEN
      RETURN p_obj.get_string(p_k1);
    ELSIF p_k2 IS NOT NULL AND p_obj.has(p_k2) THEN
      RETURN p_obj.get_string(p_k2);
    END IF;

    RETURN NULL;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END get_str_any;

  FUNCTION get_num_any(p_obj JSON_OBJECT_T, p_k1 VARCHAR2, p_k2 VARCHAR2 DEFAULT NULL)
    RETURN NUMBER
  IS
    v_txt VARCHAR2(4000);
  BEGIN
    v_txt := get_str_any(p_obj, p_k1, p_k2);
    IF v_txt IS NULL THEN
      RETURN NULL;
    END IF;

    RETURN TO_NUMBER(
             REPLACE(TRIM(v_txt), ',', '.'),
             'FM9999999999990D9999999MI',
             'NLS_NUMERIC_CHARACTERS=''.,'''
           );
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END get_num_any;

  FUNCTION parse_fecha(p_txt IN VARCHAR2) RETURN DATE IS
    v VARCHAR2(200) := TRIM(p_txt);
  BEGIN
    IF v IS NULL THEN
      RETURN NULL;
    END IF;

    BEGIN
      RETURN TO_DATE(v,'YYYY-MM-DD"T"HH24:MI:SS"Z"');
    EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN
      RETURN TO_DATE(v,'YYYY-MM-DD"T"HH24:MI:SS');
    EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN
      RETURN TO_DATE(v,'YYYY-MM-DD');
    EXCEPTION WHEN OTHERS THEN NULL; END;

    RETURN NULL;
  END parse_fecha;

  ---------------------------------------------------------------------------
  -- Fechas YYYYMMDD y montos con signo a la derecha (p.ej. '600.0-')
  ---------------------------------------------------------------------------
  FUNCTION f_parse_yyyymmdd(p IN VARCHAR2) RETURN DATE IS
    v VARCHAR2(20) := TRIM(p);
  BEGIN
    IF v IS NULL OR v = '00000000' THEN
      RETURN NULL;
    END IF;

    RETURN TO_DATE(v, 'YYYYMMDD');
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END f_parse_yyyymmdd;

  FUNCTION f_to_number_sap(p IN VARCHAR2) RETURN NUMBER IS
    s VARCHAR2(2000);
  BEGIN
    s := REPLACE(TRIM(p), ',', '.');
    IF s IS NULL THEN
      RETURN NULL;
    END IF;

    RETURN TO_NUMBER(
             s,
             'FM9999999999990D9999999MI',   -- acepta signo al final (ej. 40000.0-)
             'NLS_NUMERIC_CHARACTERS=''.,'''
           );
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END f_to_number_sap;

  ---------------------------------------------------------------------------
  -- Utilitario peque?o para escapar valores JSON (por si entra " o \)
  ---------------------------------------------------------------------------
  FUNCTION jesc(p IN VARCHAR2) RETURN VARCHAR2 IS
    v VARCHAR2(4000);
  BEGIN
    IF p IS NULL THEN
      RETURN NULL;
    END IF;

    v := REPLACE(p, '\', '\\');
    v := REPLACE(v, '"', '\"');
    v := REPLACE(v, CHR(13), '\r');
    v := REPLACE(v, CHR(10), '\n');
    RETURN v;
  END jesc;

  ---------------------------------------------------------------------------
  -- Principal
  ---------------------------------------------------------------------------
  PROCEDURE PR_CONSULTAR_ESTADO(
    i_cdCompania            IN  VARCHAR2,
    i_dsNitAcreedor         IN  VARCHAR2,
    i_cdTipoIdentificacion  IN  VARCHAR2,
    i_dsReferencia          IN  VARCHAR2,
    i_sistema_origen        IN  VARCHAR2,
    i_estado                IN  VARCHAR2,
    o_estado                OUT VARCHAR2,
    o_fecha_compensacion    OUT DATE,
    o_importe               OUT NUMBER,
    o_usuario               OUT VARCHAR2,
    o_fecha_posible_pago    OUT DATE,
    o_msj_tecnico           OUT VARCHAR2,
    o_msj_usuario           OUT VARCHAR2
  ) IS
    v_seleccion   CLOB;
    l_sel         CLOB := '[';
    l_sep         VARCHAR2(1) := '';

    v_json_header CLOB;
    v_json_body   CLOB;
    v_token       VARCHAR2(4000);

    v_msj_th VARCHAR2(4000);
    v_msj_uh VARCHAR2(4000);
    v_msj_tb VARCHAR2(4000);
    v_msj_ub VARCHAR2(4000);
    v_msj_ts VARCHAR2(4000);
    v_msj_us VARCHAR2(4000);

    v_resp_sync   CLOB;

    -- Parse respuesta
    v_env_obj     JSON_OBJECT_T;
    v_body_clob   CLOB;
    v_body_obj    JSON_OBJECT_T;
    v_docs_arr    JSON_ARRAY_T;
    v_doc0        JSON_OBJECT_T;
    v_cabecera    JSON_OBJECT_T;

    v_estado_req  VARCHAR2(10) := NVL(TRIM(i_estado), 'X');
    v_sist_origen VARCHAR2(10) := NVL(TRIM(i_sistema_origen), 'ATR');
    v_cd_comp     VARCHAR2(50) := TRIM(i_cdCompania);
    v_nit         VARCHAR2(50) := TRIM(i_dsNitAcreedor);
    v_tipo_id     VARCHAR2(50) := TRIM(i_cdTipoIdentificacion);
    v_ref         VARCHAR2(50) := TRIM(i_dsReferencia);
  BEGIN
    o_estado := NULL;
    o_fecha_compensacion := NULL;
    o_importe := NULL;
    o_usuario := NULL;
    o_fecha_posible_pago := NULL;
    o_msj_tecnico := NULL;
    o_msj_usuario := NULL;

    ------------------------------------------------------------------------
    -- 1) SELECCI?N (se arma igual que en el legado)
    ------------------------------------------------------------------------
    IF v_cd_comp IS NOT NULL THEN
      l_sel := l_sel || l_sep
               || '{"filtro":"BUKRS","indicador":"D","opciones":[{"Sign":"I","Option":"EQ","Low":"'
               || jesc(LPAD(v_cd_comp, 4, '0'))
               || '","High":""}]}';
      l_sep := ',';
    END IF;

    IF v_nit IS NOT NULL THEN
      l_sel := l_sel || l_sep
               || '{"filtro":"STCD1","indicador":"T","opciones":[{"Sign":"I","Option":"EQ","Low":"'
               || jesc(v_nit)
               || '","High":""}]}';
      l_sep := ',';
    END IF;

    IF v_tipo_id IS NOT NULL THEN
      l_sel := l_sel || l_sep
               || '{"filtro":"STCDT","indicador":"T","opciones":[{"Sign":"I","Option":"EQ","Low":"'
               || jesc(v_tipo_id)
               || '","High":""}]}';
      l_sep := ',';
    END IF;

    IF v_ref IS NOT NULL THEN
      l_sel := l_sel || l_sep
               || '{"filtro":"XBLNR","indicador":"D","opciones":[{"Sign":"I","Option":"EQ","Low":"'
               || jesc(v_ref)
               || '","High":""}]}';
      l_sep := ',';
    END IF;

    l_sel := l_sel || ']';
    v_seleccion := l_sel;

    ------------------------------------------------------------------------
    -- 2) HEADER
    ------------------------------------------------------------------------
    PCK_SAP_APIGEE_CONSULTA.SP_GENERAR_JSON_HEADER_FENIX_APIGEE(
      ivaTargetSystem           => 'sap',
      ivaTargetSystemProcess    => 'consultasdoc_cxp',
      ivaSourceApplicationName  => 'ATR',
      ivaIntegrationMethod      => 'bd-sync',
      ivaCorrelationId          => NULL,
      ivaIsBatchOperation       => 'false',
      ivaRefSrc1                => 'REF-001',
      ivaOauthUrl               => NULL,
      ocaJsonHeader             => v_json_header,
      ovaMensajeTecnico         => v_msj_th,
      ovaMensajeUsuario         => v_msj_uh
    );
    IF v_msj_th IS NOT NULL THEN
      o_estado      := 'Error';
      o_msj_tecnico := SUBSTR('HEADER: '||v_msj_th,1,c_len_msg);
      o_msj_usuario := SUBSTR(NVL(v_msj_uh,'Error al generar header'),1,c_len_msg);
      RETURN;
    END IF;

    DECLARE
      v_hdr JSON_OBJECT_T;
    BEGIN
      v_hdr := JSON_OBJECT_T.parse(v_json_header);
      IF v_hdr.has('token') THEN
        v_token := v_hdr.get_string('token');
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        v_token := NULL;
    END;
    IF v_token IS NULL OR TRIM(v_token) IS NULL THEN
      o_estado      := 'Error';
      o_msj_tecnico := 'HEADER: access_token vac?o o ausente';
      o_msj_usuario := 'No se obtuvo token de autenticaci?n.';
      RETURN;
    END IF;

    ------------------------------------------------------------------------
    -- 3) BODY
    ------------------------------------------------------------------------
    IF v_estado_req IS NULL THEN
      o_estado      := 'Error';
      o_msj_tecnico := 'BODY: estado no puede ser nulo';
      o_msj_usuario := 'Debe indicar el estado de la consulta.';
      RETURN;
    END IF;

    v_json_body :=
        TO_CLOB('{"control":{"sistemaOrigen":"') || jesc(v_sist_origen)
      || TO_CLOB('"},"datosConsulta":{"TipoConsulta":{"claseCuenta":"K","estado":"')
      || jesc(v_estado_req)
      || TO_CLOB('"},"seleccion":')
      || v_seleccion
      || TO_CLOB('}}');

    ------------------------------------------------------------------------
    -- 4) LLAMADA S?NCRONA
    ------------------------------------------------------------------------
    PCK_SAP_APIGEE_CONSULTA.SP_LLAMAR_GNL_CALL_SYNC_FENIX_APIGEE(
      ivaMetodo         => 'POST',
      ivaHeaders        => v_json_header,
      ivaToken          => v_token,
      ivaBody           => v_json_body,
      ivaTimeout        => 30,
      ivaWalletPath     => NULL,
      ocaRespuesta      => v_resp_sync,
      ovaMensajeTecnico => v_msj_ts,
      ovaMensajeUsuario => v_msj_us
    );
    IF v_msj_ts IS NOT NULL THEN
      o_estado      := 'Error';
      o_msj_tecnico := SUBSTR('SYNC: '||v_msj_ts,1,c_len_msg);
      o_msj_usuario := SUBSTR(NVL(v_msj_us,'Error en llamada s?ncrona'),1,c_len_msg);
      RETURN;
    END IF;

    ------------------------------------------------------------------------
    -- 5) Des-envolver (response_body si existe)
    ------------------------------------------------------------------------
    BEGIN
      v_env_obj := JSON_OBJECT_T.parse(v_resp_sync);
      BEGIN
        v_body_clob := v_env_obj.get_clob('response_body');
      EXCEPTION WHEN OTHERS THEN
        BEGIN
          v_body_clob := TO_CLOB(v_env_obj.get_string('response_body'));
        EXCEPTION WHEN OTHERS THEN
          v_body_clob := NULL;
        END;
      END;

      IF v_body_clob IS NULL THEN
        v_body_clob := v_resp_sync;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        v_body_clob := v_resp_sync;
    END;

    ------------------------------------------------------------------------
    -- 6) Parseo del body JSON y mapeo de OUTs
    ------------------------------------------------------------------------
    BEGIN
      v_body_obj := JSON_OBJECT_T.parse(v_body_clob);

      IF v_body_obj.has('documentos') THEN
        v_docs_arr := v_body_obj.get_array('documentos');
      END IF;

      IF v_docs_arr IS NOT NULL AND v_docs_arr.get_size > 0 THEN
        v_doc0 := TREAT(v_docs_arr.get(0) AS JSON_OBJECT_T);
      END IF;

      IF v_doc0 IS NOT NULL THEN
        IF v_doc0.has('datosCabecera') THEN
          v_cabecera := v_doc0.get_object('datosCabecera');
        ELSIF v_doc0.has('datoscabecera') THEN
          v_cabecera := v_doc0.get_object('datoscabecera');
        END IF;

        IF v_cabecera IS NOT NULL THEN
          o_usuario := get_str_any(v_cabecera,'usuario','dsUsuario');
        END IF;
      END IF;

      DECLARE
        v_pos_arr    JSON_ARRAY_T;
        v_pos0       JSON_OBJECT_T;
        v_imp_txt    VARCHAR2(100);
        v_estado_txt VARCHAR2(100);
      BEGIN
        IF v_doc0 IS NOT NULL THEN
          IF v_doc0.has('datosPosicion') THEN
            v_pos_arr := v_doc0.get_array('datosPosicion');
          ELSIF v_doc0.has('datosposicion') THEN
            v_pos_arr := v_doc0.get_array('datosposicion');
          END IF;
        END IF;

        IF v_pos_arr IS NOT NULL AND v_pos_arr.get_size > 0 THEN
          v_pos0 := TREAT(v_pos_arr.get(0) AS JSON_OBJECT_T);

          v_estado_txt := get_str_any(v_pos0, 'estado');

          IF v_estado_txt IS NULL OR TRIM(v_estado_txt) IS NULL THEN
            o_estado := 'N';
          ELSE
            CASE UPPER(TRIM(v_estado_txt))
              WHEN 'A' THEN
                o_estado := 'P';
              WHEN 'C' THEN
                o_estado := 'L';
              WHEN 'R' THEN
                o_estado := 'A';
              ELSE
                o_estado := TRIM(v_estado_txt);
            END CASE;
          END IF;

          o_fecha_compensacion :=
            COALESCE(
              parse_fecha(get_str_any(v_pos0,'fechacompensacion','fechaCompensacion')),
              f_parse_yyyymmdd(get_str_any(v_pos0,'fechacompensacion','fechaCompensacion'))
            );

          o_fecha_posible_pago :=
            COALESCE(
              parse_fecha(get_str_any(v_pos0,'fechabase','fechaBase')),
              parse_fecha(get_str_any(v_pos0,'fechavalor','fechaValor')),
              parse_fecha(get_str_any(v_pos0,'fechaposiblepago','fechaPosiblePago')),
              f_parse_yyyymmdd(get_str_any(v_pos0,'fechabase','fechaBase'))
            );

          IF o_fecha_posible_pago IS NULL AND v_cabecera IS NOT NULL THEN
            o_fecha_posible_pago :=
              COALESCE(
                parse_fecha(get_str_any(v_cabecera,'fechaposiblepago','fechaPosiblePago')),
                parse_fecha(get_str_any(v_cabecera,'fechaconversion','fechaConversion')),
                f_parse_yyyymmdd(get_str_any(v_cabecera,'fechaposiblepago','fechaPosiblePago'))
              );
          END IF;

          v_imp_txt := get_str_any(v_pos0,'importedocumento','importeDocumento');
          IF v_imp_txt IS NULL THEN
            v_imp_txt := get_str_any(v_pos0,'importelocal','importeLocal');
          END IF;
          o_importe := f_to_number_sap(v_imp_txt);

          o_msj_tecnico := NULL;
          o_msj_usuario := NULL;
        ELSE
          o_estado      := 'Error';
          o_msj_tecnico := 'RESPONSE: No se encontraron posiciones en documentos[0]';
          o_msj_usuario := 'No se encontraron posiciones para el documento consultado.';
          RETURN;
        END IF;
      END;

      -- *** IMPORTANTE: ya no normalizamos a 'X' cuando o_estado es NULL ***
      -- (El SP se encarga de la mensajer?a estilo legado cuando estado llega NULL)

    EXCEPTION
      WHEN OTHERS THEN
        o_estado      := 'Error';
        o_msj_tecnico := SUBSTR('RESPONSE: '||SQLERRM,1,c_len_msg);
        o_msj_usuario := 'Error al interpretar la respuesta del servicio.';
        RETURN;
    END;

  EXCEPTION
    WHEN OTHERS THEN
      o_estado      := 'Error';
      o_msj_tecnico := SUBSTR('UNEXPECTED: '||SQLERRM,1,c_len_msg);
      o_msj_usuario := 'Ocurri? un error inesperado en el camino Apigee.';
  END PR_CONSULTAR_ESTADO;

END PCK_CXP_CONSULTA_EST_ATR;
/


--3 **************** adaptador

/*
    ============================================================================
    Archivo: pck_sin_ban_adaptador_cpi.sql
    Descripcion: Paquete adaptador que mapea objetos origen (por ejemplo,
                 OBJ_SAP_CXP_SINIESTROS) a OBJ_CPI_CAUSACION_CONTABLE.
    Autor: Jaime Andres Ortiz
    Fecha: 2025-09-17
    Version: 1.0.0
    Notas:
      - Depende de los tipos OBJ_CPI_CAUSACION_CONTABLE y tipos relacionados.
      - Usado para transformar mensajes de origen a la estructura estandar CPI.

    Cambios:
      - 2025-09-17: Cabecera anadida.
      - 2025-12-05: Ajustes para Siniestros de global.
    ============================================================================
*/
CREATE OR REPLACE PACKAGE OPS$PROCEDIM.PCK_SIN_BAN_ADAPTADOR_CPI is
  -- Mapea un objeto OBJ_SAP_CXP_SINIESTROS a OBJ_CPI_CAUSACION_CONTABLE
   function map_sap_cxp_to_causacion (
      i_obj                     IN obj_sap_cxp_siniestros,
      p_param_client_id         IN  VARCHAR2,
      p_param_client_secret     IN  VARCHAR2,
      p_sistema_origen          IN  VARCHAR2,
      p_source_application_name IN  VARCHAR2
   ) return obj_cpi_causacion_contable;
end PCK_SIN_BAN_ADAPTADOR_CPI;
/

CREATE OR REPLACE PACKAGE BODY OPS$PROCEDIM.PCK_SIN_BAN_ADAPTADOR_CPI is

   function map_sap_cxp_to_causacion (
      i_obj                     IN obj_sap_cxp_siniestros,
      p_param_client_id         IN  VARCHAR2,
      p_param_client_secret     IN  VARCHAR2,
      p_sistema_origen          IN  VARCHAR2,
      p_source_application_name IN  VARCHAR2
   ) return obj_cpi_causacion_contable is
      v_header            obj_cpi_headers;
      v_control           obj_cpi_causa_control;
      v_cabecera          obj_cpi_causa_cabecera;
      v_posiciones        tab_cpi_causa_posicion := tab_cpi_causa_posicion();
      v_param_adicionales tab_cpi_causa_param_adicional := tab_cpi_causa_param_adicional();
      v_param_adicional   obj_cpi_causa_param_adicional;
      v_resumen           obj_cpi_causa_pos_resumen;
      v_detalles          tab_cpi_causa_pos_detalle;
      v_descuento         obj_cpi_causa_pos_descuento;
      v_retenciones       tab_cpi_causa_pos_retencion;
      v_tercero           obj_cpi_causa_pos_tercero;
      v_doc               obj_sap_documento_cxp_sini;
      v_ret               obj_sap_dato_retencion;
      v_detalle_cxp       obj_sap_detalle_cxp_sini;
      v_idx_doc           pls_integer;
      v_idx_ret           pls_integer;
      v_idx_param         pls_integer;
      v_idx_param_pos     pls_integer;
      v_idx_pos           pls_integer;
      o_obj               obj_cpi_causacion_contable;

      v_codigo_municipio  varchar2(100);
      v_correlation_id     varchar2(100);
      v_key    tcob_parametros_sap.cdusuario%type;
      v_secret tcob_parametros_sap.cdclave%type;
   begin

      v_correlation_id := pck_gnl_integration_utils.fn_gnl_get_correlation_id();
      -- Obtener key y secret desde parametros
      begin
          v_key    := NVL(PCK_PARAMETROS.FN_GET_PARAMETROV2('%', '%', p_param_client_id, SYSDATE, '*','*','*','*','*'), '');
          v_secret := NVL(PCK_PARAMETROS.FN_GET_PARAMETROV2('%', '%', p_param_client_secret,   SYSDATE, '*','*','*','*','*'), '');

          -- Validar que key y secret no sean nulos o vacios
          if v_key is null or trim(v_key) is null then
              raise_application_error(-20001, 'ERROR: El parametro CLIENT_ID esta nulo o vacio');
          end if;

          if v_secret is null or trim(v_secret) is null then
              raise_application_error(-20002, 'ERROR: El parametro SECRET esta nulo o vacio');
          end if;
      exception
          when others then
              raise_application_error(-20003, 'ERROR obteniendo parametros de seguridad: ' || SQLERRM);
      end;

    -- HEADERS
      v_header := obj_cpi_headers(
         request_id              => v_correlation_id,
         ref_src_1               => 'ref-001',
         target_system           => 'sap',
         target_system_process   => 'siniestros_cxp',
         source_application_name => p_source_application_name,
         integration_method      => 'bd-async',
         key                     => v_key,
         secret                  => v_secret,
         correlation_id          => v_correlation_id,
         its_batch_operation     => 0
      );

    -- CONTROL
      v_control := obj_cpi_causa_control(
         sistemaorigen => p_sistema_origen,
         identificador => pck_gnl_integration_utils.fn_gnl_get_correlation_id()  --i_obj.cabecera.nmordenpago
      );

      -- CABECERA: determinacionContable, datosGenerales, parametrosAdicionales
      v_cabecera := obj_cpi_causa_cabecera(
         determinacioncontable => obj_cpi_causa_det_contable(
            canal      => i_obj.cabecera.datosconversionorigen.cdcanal,
            fuente     => i_obj.cabecera.datosconversionorigen.cdfuente,
            operacion  => 'CXP', 
            aplicacion => i_obj.cabecera.datosconversionorigen.nmaplicacion
         ),
         datosgenerales        => obj_cpi_causa_cab_datos_generales(
            sociedad         => i_obj.cabecera.cdcompania,
            fechadocumento   => to_char(i_obj.cabecera.fefactura,'YYYY-MM-DD'),
            fechacontable    => to_char(i_obj.cabecera.feregistrosap,'YYYY-MM-DD'),
            moneda           => i_obj.cabecera.cdmoneda,
            referencia       => i_obj.cabecera.nmordenpago,
            clavereferencia1 => i_obj.documentoscxp(i_obj.documentoscxp.first)
                                 .detalleSiniestros(i_obj.documentoscxp(i_obj.documentoscxp.first)
                                 .detalleSiniestros.first).nmpoliza,
            clavereferencia2 => i_obj.documentoscxp(i_obj.documentoscxp.first)
                                 .detalleSiniestros(i_obj.documentoscxp(i_obj.documentoscxp.first)
                                 .detalleSiniestros.first).cdramo,
            texto            => NVL(i_obj.cabecera.nmfactura, 'REGISTRO SINIESTRO SEGURO'), --si no tiene factura, esta en blanco enviar "REGISTRO SINIESTRO SEGURO"
            tipocambio       => '',
            fechatipocambio  => ''
         ),
         parametrosadicionales => tab_cpi_causa_param_adicional(obj_cpi_causa_param_adicional('', ''))
      );

    -- POSICIONES[]: posiciones[i].resumen, posiciones[i].detalle[m]

      -- Se itera sobre documetnos documentoscxp
      v_idx_doc := i_obj.documentoscxp.first;
      while v_idx_doc is not null loop
         v_doc := i_obj.documentoscxp(v_idx_doc);

      -- Retenciones
      -- posiciones[i].resumen.retenciones[j]
         v_retenciones := tab_cpi_causa_pos_retencion();
         v_codigo_municipio := null;
         v_idx_ret := v_doc.retenciones.first;
         while v_idx_ret is not null loop
            v_ret := v_doc.retenciones(v_idx_ret);
            -- Si el indicador no es R ni I, guardar el codigo de municipio
            if v_ret.cdIndicadorRetencion not in ('R', 'I') then
               v_codigo_municipio := v_ret.cdIndicadorRetencion;
            end if;
            v_retenciones.extend;
            v_retenciones(v_retenciones.last) := obj_cpi_causa_pos_retencion(
               tipoRetencion         => 
                  case 
                     when v_ret.cdIndicadorRetencion = 'R' then i_obj.cabecera.cdcompania || v_ret.cdTipoRetencion || '_RF'
                     when v_ret.cdIndicadorRetencion = 'I' then i_obj.cabecera.cdcompania || v_ret.cdTipoRetencion || '_RI'
                     else i_obj.cabecera.cdcompania || v_codigo_municipio || v_ret.cdTipoRetencion  || '_RC'
                  end,
               indicadorRetencion    => 
                  case 
                     when v_ret.cdIndicadorRetencion = 'R' then i_obj.cabecera.cdcompania || v_ret.cdTipoRetencion || '_RF'
                     when v_ret.cdIndicadorRetencion = 'I' then i_obj.cabecera.cdcompania || v_ret.cdTipoRetencion || '_RI'
                     else i_obj.cabecera.cdcompania || v_codigo_municipio || v_ret.cdTipoRetencion  || '_RC'
                  end,
               valorBaseRetencion    => to_char(v_ret.ptBaseRetencion),
               valorRetencion        => to_char(v_ret.ptRetencion)
            );
            v_idx_ret := v_doc.retenciones.next(v_idx_ret);
         end loop;

      -- Tercero
      -- POSICIONES[I].RESUMEN.TERCERO: general, pagadorAlternativo, datosBancarios, determinacionBancaria, parametrosAdicionales

         v_tercero := obj_cpi_causa_pos_tercero(
            general               => obj_cpi_causa_pos_tercero_general(
               codigotercero      => '',
               tipoidentificacion => i_obj.tercero.informacionfiscal.cdtipoidentificacion,
               identificacion     => i_obj.tercero.informacionfiscal.nmidentificacion
            ),
            pagadoralternativo    => obj_cpi_causa_pos_tercero_pagador(
               tipoidentificacion => '',  --enviar vacio
               identificacion     => ''   --enviar vacio
            ),
            datosbancarios        => obj_cpi_causa_pos_tercero_bancario(
               paisbanco          => i_obj.tercero.cuentabancaria.cdpaisbanco,
               banco              => i_obj.tercero.cuentabancaria.cdbanco,
               cuenta             => i_obj.tercero.cuentabancaria.nmcuenta,
               tipocuenta         => i_obj.tercero.cuentabancaria.cdtipocuenta, -- (01 Cuenta corriente, 02 Cuenta de ahorros, 03 TC, 04 Libro mayor)
               tipoidentificacion => i_obj.tercero.informacionfiscal.cdtipoidentificacion,
               identificacion     => i_obj.tercero.informacionfiscal.nmidentificacion,
               nombretitular      => i_obj.tercero.cuentabancaria.dsTitular,
               apuntadorcuenta    => '' -- enviar vacio
            ),
            determinacionbancaria => obj_cpi_causa_pos_tercero_det_bancaria(
               tipoidentificacion => i_obj.tercero.informacionfiscal.cdtipoidentificacion,
               identificacion     => i_obj.tercero.informacionfiscal.nmidentificacion,
               clavereferencia1   => v_doc.nmpoliza,
               clavereferencia2   => v_doc.cdramo
            )
         );

      -- POSICIONES[I].RESUMEN.DESCUENTO
         v_descuento := obj_cpi_causa_pos_descuento(
            condicionpago  => v_doc.condicionpago.cdcondicionpago,
            base           => v_doc.condicionpago.ptimportedpp,
            valor          => '',
            dias01         => v_doc.condicionpago.nmdias,
            dias02         => '',
            dias03         => '',
            porcentaje01   => v_doc.condicionpago.podescuento,
            porcentaje02   => ''
         );

      -- POSICIONES[I].RESUMEN
         v_resumen := obj_cpi_causa_pos_resumen(
            -- posiciones[i].resumen.parametrosContables
            parametroscontables   => obj_cpi_causa_pos_param_contable(
               parametro01 => i_obj.cabecera.cdcompania,
               parametro02 => null,
               parametro03 => case
                  when substr(v_doc.cdConcepto, -1) in ('A', 'M') then v_doc.cdTipoReserva || 'A'
                  else v_doc.cdTipoReserva
               end,
               parametro04 => v_doc.cdoperacion,
               parametro05 => null,
               parametro06 => null,
               parametro07 => null,
               parametro08 => null,
               parametro09 => null,
               parametro10 => null
            ),
            -- posiciones[i].resumen.datosgenerales
            datosgenerales        => obj_cpi_causa_pos_datos_generales(
               clasecuenta       => 'K',                       --  K = acreedor
               sociedad          => '',                        
               valor             => to_char(v_doc.ptimporte),  
               indicadorimpuesto => v_doc.cdiva,
               oficina           => i_obj.cabecera.cdcompania || v_doc.detalleSiniestros(v_doc.detalleSiniestros.first).cdoficinaradicacion,
               centrocostos      => i_obj.cabecera.cdcompania || v_doc.detalleSiniestros(v_doc.detalleSiniestros.first).cdoficinaradicacion,
               indicadorbloqueo  => v_doc.cdbloqueopago,
               viapago           => v_doc.cdviapago,
               fechainicio       => to_char(v_doc.detalleSiniestros(v_doc.detalleSiniestros.first).feaviso, 'YYYY-MM-DD'),
               clavereferencia1  => i_obj.tercero.informacionfiscal.nmidentificacion,         --numero de identificacion fiscal del tercero enviar nmIdentificacion del tercero
               clavereferencia2  => v_doc.cdramo,           
               clavereferencia3  => '',                     -- Enviar vacio
               asignacion        => i_obj.tercero.informacionfiscal.nmidentificacion,                   -- #Enviar nmIdentificacion del tercero
               texto             => v_doc.detalleSiniestros(v_doc.detalleSiniestros.first).dsTextoPosicion, -- dsTextoPosicion del primer detalle
               contrato          => '',                     
               lineadenegocio    => v_doc.cdramo,          
               asesor            => v_doc.detalleSiniestros(v_doc.detalleSiniestros.first).cdIntermediario, -- Primer detalle: cdIntermediario
               zreferencia01     => v_doc.nmpoliza,         
               zreferencia02     => null,                   
               zreferencia03     => i_obj.tercero.dsNombre,
               zreferencia04     => i_obj.tercero.informacionfiscal.nmIdentificacion,
               zreferencia05     => v_codigo_municipio,
               zreferencia06     => v_doc.detalleSiniestros(v_doc.detalleSiniestros.first).nmExpediente, -- Primer NMEXPEDIENTE
               zreferencia07     => null,                   
               zreferencia08     => null,                   
               zreferencia09     => null,                   
               zreferencia10     => '',
               zfecha01          => to_char(v_doc.detalleSiniestros(v_doc.detalleSiniestros.first).feOcurrencia, 'YYYY-MM-DD') 
            ),
            descuento             => v_descuento,
            retenciones           => v_retenciones,
            tercero               => v_tercero,
            parametrosadicionales => tab_cpi_causa_param_adicional(obj_cpi_causa_param_adicional('', ''))
         );

         v_posiciones.extend;

         
         -- posiciones[i]detalle[m]: parametrosContables, datosGenerales, parametrosAdicionales[n]
         v_detalles := tab_cpi_causa_pos_detalle();
         if v_doc.detalleSiniestros is not null then
            for idx_det in 1 .. v_doc.detalleSiniestros.count loop
               v_detalle_cxp := v_doc.detalleSiniestros(idx_det);
               v_detalles.extend;

               -- posiciones[i].detalle[m].parametrosContables
               v_detalles(v_detalles.last) := obj_cpi_causa_pos_detalle(
                  parametroscontables => obj_cpi_causa_pos_param_contable(
                     parametro01 => v_detalle_cxp.cdCompaniaParametro,
                     parametro02 => case
                        when i_obj.cabecera.cdCompania = '30' and v_detalle_cxp.cdConcepto = '1C' then 'N'
                        else v_detalle_cxp.cdRamoParametro
                     end,
                     parametro03 => v_detalle_cxp.cdTipoReserva,
                     parametro04 => v_detalle_cxp.cdOperacion,
                     parametro05 => v_detalle_cxp.cdConcepto,
                     parametro06 => null,
                     parametro07 => null,
                     parametro08 => null,
                     parametro09 => null,
                     parametro10 => null
                  ),
                  -- posiciones[i].detalle[m].datosGenerales
                  datosgenerales => obj_cpi_causa_pos_datos_generales(
                     clasecuenta       => 'S',                                  
                     sociedad          => '',                                    
                     valor             => to_char(v_detalle_cxp.ptImporte),
                     indicadorimpuesto => i_obj.cabecera.cdcompania || v_detalle_cxp.cdIndicadorImpuesto,
                     oficina           => i_obj.cabecera.cdcompania || v_doc.detalleSiniestros(v_doc.detalleSiniestros.first).cdoficinaradicacion,
                     centrocostos      => i_obj.cabecera.cdcompania || v_doc.detalleSiniestros(v_doc.detalleSiniestros.first).cdoficinaradicacion,
                     indicadorbloqueo  => null,
                     viapago           => null,
                     fechainicio       => to_char(v_detalle_cxp.feAviso, 'YYYY-MM-DD'),
                     clavereferencia1  => i_obj.tercero.informacionfiscal.nmidentificacion, --NUMERO IDENTIFICACION TERCERO
                     clavereferencia2  => v_detalle_cxp.cdRamo,
                     clavereferencia3  => v_detalle_cxp.cdIntermediario,
                     asignacion        => i_obj.tercero.informacionfiscal.nmidentificacion, --NUMERO IDENTIFICACION TERCERO
                     texto             => v_detalle_cxp.dsTextoPosicion,
                     contrato          => null,
                     lineadenegocio    => null,
                     asesor            => null,
                     zreferencia01     => v_detalle_cxp.nmPoliza,
                     zreferencia02     => '',                                                      
                     zreferencia03     => i_obj.tercero.dsNombre,                                
                     zreferencia04     => i_obj.tercero.informacionfiscal.nmIdentificacion,        
                     zreferencia05     => v_codigo_municipio,                                                    
                     zreferencia06     => v_detalle_cxp.nmExpediente,
                     zreferencia07     => null,                                                    
                     zreferencia08     => null,                                                    
                     zreferencia09     => null,                                                    
                     zreferencia10     => '',
                     zfecha01          => to_char(v_detalle_cxp.feOcurrencia, 'YYYY-MM-DD')
                  ),
                  -- posiciones[i].detalle[m].parametrosAdicionales[n]
                  parametrosadicionales => tab_cpi_causa_param_adicional(obj_cpi_causa_param_adicional('', ''))
               );
            end loop;
         end if;

         -- Agregar la posicion
         -- posiciones[i]
         v_posiciones(v_posiciones.last) := obj_cpi_causa_posicion(
            resumen => v_resumen,
            detalle => v_detalles
         );

         v_idx_doc := i_obj.documentoscxp.next(v_idx_doc);
      end loop;

      -- construir el objeto  causacion contable
      o_obj := obj_cpi_causacion_contable(
         headers    => v_header,
         control    => v_control,
         cabecera   => v_cabecera,
         posiciones => v_posiciones
      );

      return o_obj;
   end map_sap_cxp_to_causacion;

end PCK_SIN_BAN_ADAPTADOR_CPI;
/


-- 3 **************** paquete de intervencion


  CREATE OR REPLACE PACKAGE OPS$PROCEDIM.PCK_SIN_GESTOR_SAP IS

  gvaPackage             VARCHAR2(30):= 'PCK_SIN_GESTOR_SAP';

	PROCEDURE SP_ENVIAR_MENSAJE_CXP(ivaNmExpediente        IN SIN_PAGOS_DET.EXPEDIENTE%TYPE,
																	ivaNmPagoAutorizacion  IN SIN_PAGOS_DET.NUMERO_PAGO_AUTORIZACION%TYPE,
																	ovaMensajeTecnico      OUT VARCHAR2,
																	ovaMensajeUsuario      OUT VARCHAR2
																	);

	PROCEDURE SP_CONSULTAR_EST_CXP(ivaClave1         IN VARCHAR2,           -- Para Siniestros es el Expediente
																 ivaClave2         IN VARCHAR2,    -- Para Todos La Orden de Pago
																 ivaConsumidor     IN VARCHAR2,
																 ovaEstado         OUT VARCHAR2,
																 odaFechaEst       OUT DATE,
																 onuValor          OUT NUMBER,
																 ovaUsuario        OUT VARCHAR2,
																 odaFePosiblePago  OUT DATE,
																 ovaMensajeTecnico OUT VARCHAR2,
																 ovaMensajeUsuario OUT VARCHAR2
																 );

  PROCEDURE SP_DESAUTORIZAR_CXP( ivaNmExpediente        IN VARCHAR2,
                                 ivaNmPagoAutorizacion  IN SIN_PAGOS_DET.NUMERO_PAGO_AUTORIZACION%TYPE,
                                 ovaResultado           OUT VARCHAR2,
                                 ovaMensajeTecnico      OUT VARCHAR2,
                                 ovaMensajeUsuario      OUT VARCHAR2
                                 );

-----------------------------------------------------------------------------------------------------------
-- SALVAMENTOS
-- SALVAMENTOS
-- SALVAMENTOS
-----------------------------------------------------------------------------------------------------------

	PROCEDURE SP_ENVIAR_MENSAJE_CXC(ivaNmExpediente        IN SIN_PAGOS_DET.EXPEDIENTE%TYPE,
																	ivaNmPagoAutorizacion  IN SIN_PAGOS_DET.NUMERO_PAGO_AUTORIZACION%TYPE,
																	ovaMensajeTecnico      OUT VARCHAR2,
																	ovaMensajeUsuario      OUT VARCHAR2,
                                  ivaNmPagoVelru         IN NUMBER DEFAULT 0                               
																	);

  PROCEDURE SP_DESAUTORIZAR_CXC( ivaNmExpediente        IN VARCHAR2,
                                 ivaNmPagoAutorizacion  IN SIN_PAGOS_DET.NUMERO_PAGO_AUTORIZACION%TYPE,
                                 ovaResultado           OUT VARCHAR2,
                                 ovaMensajeTecnico      OUT VARCHAR2,
                                 ovaMensajeUsuario      OUT VARCHAR2
                                 );

/*  PROCEDURE SP_CREAR_MENSAJE_RETENCIONES(ivaCdSociedad           IN VARCHAR2,
                                         ivaDniBenePago          IN VARCHAR2,
                                         inuPtImporte            IN NUMBER,
                                         inuPtDeducible          IN NUMBER,
                                         ivaCdMoneda             IN VARCHAR2,
                                         inuPoIVA                IN VARCHAR2,
                                         iarrRetenciones         IN TAB_SAP_RETENCIONES_SINI,
                                         oarrRetenciones        OUT TAB_SAP_RETENCIONES_SINI,
--                                         ivaCdCodigoRetencion    IN VARCHAR2,
--                                         ivaCdIndicadorRetencion IN VARCHAR2,
--																         onuPtRetencion         OUT NUMBER,
--                                         onuPtBaseRetencion     OUT NUMBER,
--                                         onuPoRetencion         OUT NUMBER,
        																 ovaMensajeTecnico      OUT VARCHAR2,
				        												 ovaMensajeUsuario      OUT VARCHAR2);                                  

\**-----------------------------------------------------------------------------------------
  Procedure que entrega los valores calculados para poblar el modelo de Impuestos y enviar a SAP
  #author Juan Guillermo Henao Montoya
  Fecha Creación: 2013/07/06
  Fecha Modificación:
  Motivo Modificación:

  #param ivaCdSociedad           Código de la compañía sobre la cual se calcula el impuesto
  #param ivaDniBenePago          Documento Nacional de Identificación del beneficiario de pago
  #param inuPtImporte            Valor bruto de la orden de pago
  #param inuPtDeducible          Valor del deducible a descontarle al asegurado
  #param ivaCdMoneda             Código de la moneda sobre la cual se hace el pago
  #param inuPoIVA                porcentaje de IVA calculado
  #param ivaCdCodigoRetencion    Código de la retención a aplicar.  #param ivaCdIndicadorRetencion Tipo de retencion a Calcular R Retefiemte, I ReteIVA, 
  #param ovaMensajeTecnico       Mensaje tecnico en caso de error
  #param ovaMensajeUsuario       Mensaje para el usuario en caso de error
  *\
  PROCEDURE SP_INVOCAR_MENSAJE_RETENCIONES (ivaCdSociedad                IN VARCHAR2,
                                            ivaDniBenePago               IN VARCHAR2,
                                            inuPtImporte                 IN NUMBER,
                                            inuPtDeducible               IN NUMBER,
                                            ivaCdMoneda                  IN VARCHAR2,
                                            inuPoIVA                     IN VARCHAR2,
                                            ivaCdTipoRetencionFTE        IN VARCHAR2,
                                            ivaCdIndicadorRetencionFTE   IN VARCHAR2,
                                            ivaCdTipoRetencionIVA        IN VARCHAR2,
                                            ivaCdIndicadorRetencionIVA   IN VARCHAR2,
                                            ivaCdTipoRetencionICA        IN VARCHAR2,
                                            ivaCdIndicadorRetencionICA   IN VARCHAR2,
                                            ovaCdTipoRetencionFTE       OUT VARCHAR2,
                                            ovaCdIndicadorRetencionFTE  OUT VARCHAR2,
                                            onuPtRetencionFTE           OUT NUMBER,                
                                            onuPtBaseRetencionFTE       OUT NUMBER,
                                            onuPoRetencionFTE           OUT NUMBER,
                                            ovaCdTipoRetencionCREE      OUT VARCHAR2,
                                            ovaCdIndicadorRetencionCREE OUT VARCHAR2,
                                            onuPtRetencionCREE          OUT NUMBER,                
                                            onuPtBaseRetencionCREE      OUT NUMBER,
                                            onuPoRetencionCREE          OUT NUMBER,
                                            ovaCdTipoRetencionIVA       OUT VARCHAR2,
                                            ovaCdIndicadorRetencionIVA  OUT VARCHAR2,
                                            onuPtRetencionIVA           OUT NUMBER,                
                                            onuPtBaseRetencionIVA       OUT NUMBER,
                                            onuPoRetencionIVA           OUT NUMBER,
                                            ovaCdTipoRetencionICA       OUT VARCHAR2,
                                            ovaCdIndicadorRetencionICA  OUT VARCHAR2,
                                            onuPtRetencionICA           OUT NUMBER,                
                                            onuPtBaseRetencionICA       OUT NUMBER,
                                            onuPoRetencionICA           OUT NUMBER,
                                            ovaCdTipoValorIVA           OUT VARCHAR2,
                                            ovaCdIndicadorValorIVA      OUT VARCHAR2,
                                            onuPtValorIVA               OUT NUMBER,                
                                            onuPtBaseValorIVA           OUT NUMBER,
                                            onuPoValorIVA               OUT NUMBER,
                                            ovaCdTipoValorIVADesc       OUT VARCHAR2,
                                            ovaCdIndicadorValorIVADesc  OUT VARCHAR2,
                                            onuPtValorIVADesc           OUT NUMBER,                
                                            onuPtBaseValorIVADesc       OUT NUMBER,
                                            onuPoValorIVADesc           OUT NUMBER,
                                            ovaMensajeTecnico           OUT VARCHAR2,
                                            ovaMensajeUsuario           OUT VARCHAR2); 
 
*/
END PCK_SIN_GESTOR_SAP;
/
CREATE OR REPLACE PACKAGE BODY OPS$PROCEDIM.PCK_SIN_GESTOR_SAP IS

	PROCEDURE SP_ENVIAR_MENSAJE_CXP(ivaNmExpediente        IN SIN_PAGOS_DET.EXPEDIENTE%TYPE,
																	ivaNmPagoAutorizacion  IN SIN_PAGOS_DET.NUMERO_PAGO_AUTORIZACION%TYPE,
																	ovaMensajeTecnico      OUT VARCHAR2,
																	ovaMensajeUsuario      OUT VARCHAR2
																	) IS
  --Variables para el manejo de Errores
  lvaMensajeTecnico           VARCHAR2(255)  := NULL;
	lvaMensajeTecnicoExt        VARCHAR2(255)  := NULL;
	lvaMensajeUsuario           VARCHAR2(255)  := NULL;
	lvaMensajeUsuarioExt        VARCHAR2(255)  := NULL;
	lexErrorProcedimiento       EXCEPTION;
	lexErrorProcedimientoExt    EXCEPTION;
	lvaNombreObjeto             VARCHAR2(30)   :='SP_ENVIAR_MENSAJE_CXP';
  v_xml                       XMLTYPE;
  lvaSnContabilizarPago       VARCHAR(1);
	lvaErrorLog                 VARCHAR2(255)  := NULL;

	--Variables para funcionamiento
	lobjPago                    OBJ_SAP_CXP_SINIESTROS := NULL;
  lobjCaus                    OBJ_CPI_CAUSACION_CONTABLE := NULL;
  
  CURSOR lcuContabilizarPagoSap IS
    SELECT P.DSVALOR_PARAMETRO
      FROM T999_PARAMETROS P
     WHERE P.DSPARAMETRO = 'PAGO_SURABROKER';
  
  lvaUsaApiGeeSiniCxP VARCHAR2(10);
	BEGIN
	   lobjPago := PCK_SIN_ADAPTADOR_SAP.FN_CREAR_MENSAJE_CXP(ivaNmExpediente,
		                                                        ivaNmPagoAutorizacion,
																														lvaMensajeTecnicoExt,
																														lvaMensajeUsuarioExt);
                                                            
		 IF lvaMensajeTecnicoExt IS NOT NULL THEN
		    lvaErrorLog := lvaMensajeTecnicoExt;
     ELSE
          IF lvaMensajeUsuarioExt IS NOT NULL THEN
            lvaErrorLog := lvaMensajeUsuarioExt;
          END IF;
		 END IF;
                                                            
    OPEN lcuContabilizarPagoSap;
    FETCH lcuContabilizarPagoSap
      INTO lvaSnContabilizarPago;
    CLOSE lcuContabilizarPagoSap;
    
    IF lvaSnContabilizarPago = 'S' THEN
     lobjPago.Tyinf := null;
     v_xml := XMLTYPE(lobjPago);
     --DBMS_OUTPUT.put_line(v_xml.getstringval);
     
     INSERT INTO TSIN_CONTABILIZAR_PAGOSAP (NMEXPEDIENTE, NMORDENPAGO, DSESTADO, DSMENSAJE, DSLOG)
     VALUES(ivaNmExpediente, ivaNmPagoAutorizacion, 'Pendiente', v_xml.getClobval(), lvaErrorLog);

    ELSE
      lvaUsaApiGeeSiniCxP := PCK_PARAMETROS.FN_GET_PARAMETROV2('%', '%', 'USA_API_SINICXP', SYSDATE, '*', '*', '*', '*', '*');
      IF NVL(lvaUsaApiGeeSiniCxP, 'N') = 'S' THEN
        lobjCaus := PCK_SIN_BAN_ADAPTADOR_CPI.MAP_SAP_CXP_TO_CAUSACION(lobjPago, 'CLIENT_ID_ATR', 'SECRET_ATR', 'ATRSINIEST', 'atr');
        PCK_CPI_INTEGRATION_V2.SP_ENVIAR_DOCUMENTO_ASYNC(lobjCaus, OBJ_CPI_JSON_CAUSACION_STRATEGY(1), 'TATR_ASYNC_TX_1'); 
      ELSE
        PCK_SBK_SURABROKER.SP_EJECUTAR_SERVICIO_ASINCRONO(lobjPago);
      END IF;
    END IF;

     UPDATE SIN_PAGOS_DET
     SET CDENSAP = 'S'
     WHERE EXPEDIENTE             = ivaNmExpediente
     AND NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion;
     
  EXCEPTION
      WHEN lexErrorProcedimientoExt THEN
        ovaMensajeTecnico:=lvaMensajeTecnicoExt;
        ovaMensajeUsuario:=lvaMensajeUsuarioExt;
      WHEN lexErrorProcedimiento THEN
        ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
        ovaMensajeUsuario:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeUsuario;
      WHEN OTHERS THEN
        ovaMensajeTecnico := gvaPackage || '.' || lvaNombreObjeto || ':' || CHR(13) ||
                                  'Fecha/Hora: ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || CHR(13) ||
                                  'Expediente: ' || ivaNmExpediente || CHR(13) ||
                                  'SQLCODE: ' || TO_CHAR(SQLCODE) || CHR(13) ||
                                  'SQLERRM: ' || SQLERRM || CHR(13) ||
                                  'Error Stack: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || CHR(13) ||
                                  'Call Stack: ' || DBMS_UTILITY.FORMAT_CALL_STACK || CHR(13) ||
                                  'Backtrace: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        ovaMensajeUsuario := 'Ocurrió error inesperado. Por favor contacte al administrador';

	END SP_ENVIAR_MENSAJE_CXP;

	PROCEDURE SP_CONSULTAR_EST_CXP(ivaClave1         IN VARCHAR2,           -- Para Siniestros es el Expediente
																 ivaClave2         IN VARCHAR2,    -- Para Todos La Orden de Pago
																 ivaConsumidor     IN VARCHAR2,
																 ovaEstado         OUT VARCHAR2,
																 odaFechaEst       OUT DATE,
																 onuValor          OUT NUMBER,
																 ovaUsuario        OUT VARCHAR2,
																 odaFePosiblePago  OUT DATE,
																 ovaMensajeTecnico OUT VARCHAR2,
																 ovaMensajeUsuario OUT VARCHAR2
																 ) IS
  ---------------------------------------------------------------------------
  -- Aux / errores (legado)
  ---------------------------------------------------------------------------
  lvaMensajeTecnico           VARCHAR2(255)  := NULL;
	lvaMensajeTecnicoExt        VARCHAR2(255)  := NULL;
	lvaMensajeUsuario           VARCHAR2(255)  := NULL;
	lvaMensajeUsuarioExt        VARCHAR2(255)  := NULL;
	lexErrorProcedimiento       EXCEPTION;
	lexErrorProcedimientoExt    EXCEPTION;
	lvaNombreObjeto             VARCHAR2(30)   :='FN_CONSULTAR_EST_CXP';

	lvaerror                    VARCHAR2(2000)  := NULL;

  ---------------------------------------------------------------------------
  -- Objetos mensaje/respuesta (legado)
  ---------------------------------------------------------------------------	
  lobjMensaje                 OBJ_SAP_CONSULTA_EST_CXP := NULL;
  lobjResultados		          TAB_SBK_ANYDATA;
  lobjTransaccion	            OBJ_SAP_RESP_CONSULTA_EST_CXP := OBJ_SAP_RESP_CONSULTA_EST_CXP();
  linStatus			                INTEGER;

---------------------------------------------------------------------------
  -- Control On/Off
  ---------------------------------------------------------------------------
  v_cnuevo         CHAR(1) := 'N';
  lbEjecutarLegado BOOLEAN := TRUE;

  ---------------------------------------------------------------------------
  -- Helpers
  ---------------------------------------------------------------------------
  FUNCTION f255(p_text IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN SUBSTR(p_text, 1, 255);
  END;

BEGIN
  ---------------------------------------------------------------------------
  -- Inicializo OUTs
  ---------------------------------------------------------------------------
  ovaEstado         := NULL;
  odaFechaEst       := NULL;
  onuValor          := NULL;
  ovaUsuario        := NULL;
  odaFePosiblePago  := NULL;
  ovaMensajeTecnico := NULL;
  ovaMensajeUsuario := NULL;

  ---------------------------------------------------------------------------
  -- Construyo mensaje legacy (intacto) v?a Adaptador
  ---------------------------------------------------------------------------

	   lvaMensajeTecnico := 'Llamando al Adaptador';
     lobjMensaje := PCK_SIN_ADAPTADOR_SAP.FN_CREAR_MENSAJE_CONSULTA_CXP(ivaClave1,
		                                                                    ivaClave2,
																																				ivaConsumidor,
																																				lvaMensajeTecnicoExt,
																																				lvaMensajeUsuarioExt);
		 IF lvaMensajeTecnicoExt IS NOT NULL OR lvaMensajeUsuarioExt IS NOT NULL THEN
		    RAISE lexErrorProcedimientoExt;
		 END IF;

  ---------------------------------------------------------------------------
  -- Leo switch On/Off desde tu función
  ---------------------------------------------------------------------------
  v_cnuevo := NVL(PCK_PARAMETROS.FN_GET_PARAMETROV2('%','%','USA_API_CONCXP',SYSDATE,'*','*','*','*','*'),'N');

  ---------------------------------------------------------------------------
  -- Camino Apigee con validaciones de legado
  ---------------------------------------------------------------------------
  IF v_cnuevo = 'S' THEN
    BEGIN
      lvaMensajeTecnico := 'Llamando a Apigee';

      -- Capturo salidas en variables locales para poder evaluar como en legado
      DECLARE
        v_a_estado          VARCHAR2(10);
        v_a_fecha_comp      DATE;
        v_a_importe         NUMBER;
        v_a_usuario         VARCHAR2(100);
        v_a_fecha_pos_pago  DATE;
        v_a_msj_tec         VARCHAR2(255);
        v_a_msj_usr         VARCHAR2(255);
      BEGIN
        PCK_CXP_CONSULTA_EST_ATR.PR_CONSULTAR_ESTADO(
          i_cdCompania           => lobjMensaje.cdCompania,
          i_dsNitAcreedor        => lobjMensaje.dsNitAcreedor,
          i_cdTipoIdentificacion => lobjMensaje.cdTipoIdentificacion,
          i_dsReferencia         => lobjMensaje.dsReferencia,
          i_sistema_origen       => 'ATR',
          i_estado               => 'X',   -- requerido por SAP
          o_estado               => v_a_estado,
          o_fecha_compensacion   => v_a_fecha_comp,
          o_importe              => v_a_importe,
          o_usuario              => v_a_usuario,
          o_fecha_posible_pago   => v_a_fecha_pos_pago,
          o_msj_tecnico          => v_a_msj_tec,
          o_msj_usuario          => v_a_msj_usr
        );

        -- ======== Validaciones estilo legado ========

        -- Copio salidas de negocio a OUTs finales
        ovaEstado         := v_a_estado;
        odaFechaEst       := v_a_fecha_comp;
        onuValor          := v_a_importe;
        ovaUsuario        := v_a_usuario;
        odaFePosiblePago  := v_a_fecha_pos_pago;

        -- Si estado viene NULL => mensajes "Error: <clave2> <detalle>" (sin forzar fallback)
        IF v_a_estado IS NULL THEN
          ovaMensajeTecnico := f255('Error: ' || ivaClave2 || ' ' || NVL(v_a_msj_tec, v_a_msj_usr));
          ovaMensajeUsuario := f255('Error: ' || ivaClave2 || ' ' || NVL(v_a_msj_usr, v_a_msj_tec));
        ELSE
          -- Respeto mensajes de Apigee si vienen
          ovaMensajeTecnico := f255(NVL(v_a_msj_tec, ovaMensajeTecnico));
          ovaMensajeUsuario := f255(NVL(v_a_msj_usr, ovaMensajeUsuario));
        END IF;

        -- 'ERROR' como estado => error controlado (se preservan salidas, sin fallback)
        IF UPPER(TRIM(NVL(v_a_estado,'x'))) = 'ERROR' THEN
          IF ovaMensajeTecnico IS NULL AND ovaMensajeUsuario IS NULL THEN
            ovaMensajeTecnico := f255('Error: ' || ivaClave2 || ' Respuesta de negocio con ERROR');
            ovaMensajeUsuario := ovaMensajeTecnico;
          END IF;
        END IF;

        -- === Decisión de fallback técnico/estructural por prefijos del paquete ===
        IF v_a_msj_tec IS NOT NULL THEN
          IF    UPPER(v_a_msj_tec) LIKE 'HEADER:%'
             OR UPPER(v_a_msj_tec) LIKE 'SYNC:%'
             OR UPPER(v_a_msj_tec) LIKE 'UNEXPECTED:%'
             OR UPPER(v_a_msj_tec) LIKE 'RESPONSE:%' THEN
            lbEjecutarLegado := TRUE;   -- fallo técnico/estructural => fallback
          ELSE
            lbEjecutarLegado := FALSE;  -- mensaje de negocio => nos quedamos
          END IF;
        ELSE
          lbEjecutarLegado := FALSE;    -- OK técnico
        END IF;
      END;

    EXCEPTION
      WHEN OTHERS THEN
        -- Excepción técnica (timeout, HTTP no 2xx, etc.) => fallback legado
        ovaMensajeTecnico := f255('Apigee: ' || SQLERRM);
        ovaMensajeUsuario := f255('Apigee: ' || SQLERRM);
        lbEjecutarLegado  := TRUE;
    END;
  END IF;

  ---------------------------------------------------------------------------
  -- Camino SuraBroker (legado) - solo si se requiere fallback
  ---------------------------------------------------------------------------
  IF lbEjecutarLegado THEN
    lvaMensajeTecnico := 'Llamando a SuraBroker';
    lobjResultados := PCK_SBK_SURABROKER.FN_EJECUTAR_SERVICIO_SINCRONO(lobjMensaje);
    lvaMensajeTecnico := 'Obteniendo los resultados';
    linStatus := lobjResultados(1).GetObject(lobjTransaccion);
    IF NVL(lobjTransaccion.dsError, 'E') != 'E' THEN
      ovaEstado   := lobjTransaccion.dsEstado;
      odaFechaEst := lobjTransaccion.feCompensacion;
      onuValor    := lobjTransaccion.ptImporte;
      ovaUsuario  := lobjTransaccion.dsUsuario;
      odaFePosiblePago := lobjTransaccion.fePosiblePago;
      IF ovaEstado IS NULL THEN
          ovaMensajeTecnico := substr('Error: '||ivaClave2||' '||lobjTransaccion.dsError,1,255);
          ovaMensajeUsuario := substr('Error: '||ivaClave2||' '||lobjTransaccion.dsError,1,255);
      END IF;
    ELSE
      ovaEstado   := lobjTransaccion.dsEstado;
      odaFechaEst := lobjTransaccion.feCompensacion;
      onuValor    := lobjTransaccion.ptImporte;
      ovaUsuario  := lobjTransaccion.dsUsuario;
      odaFePosiblePago := lobjTransaccion.fePosiblePago;
    END IF;
	END IF;
  EXCEPTION
      WHEN lexErrorProcedimientoExt THEN
				ovaMensajeTecnico := SUBSTR(TRIM(lpad(to_char(abs(SQLCODE)),7,'0' )||':'|| ' - '||lvaMensajeTecnicoExt),1,255);
				ovaMensajeUsuario := SUBSTR(TRIM(lvaMensajeUsuarioExt),1,255);
      WHEN lexErrorProcedimiento THEN
        ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
        ovaMensajeUsuario:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeUsuario;
      WHEN OTHERS THEN
        ovaMensajeTecnico := gvaPackage || '.' || lvaNombreObjeto || ':' || CHR(13) ||
                           'Fecha/Hora: ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || CHR(13) ||
                           'Expediente: ' || ivaClave1 || '-' || ivaClave2 || CHR(13) ||
                           'SQLCODE: ' || TO_CHAR(SQLCODE) || CHR(13) ||
                           'SQLERRM: ' || SQLERRM || CHR(13) ||
                           'Error Stack: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || CHR(13) ||
                           'Call Stack: ' || DBMS_UTILITY.FORMAT_CALL_STACK || CHR(13) ||
                           'Backtrace: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        ovaMensajeUsuario := 'Ocurrió un error inesperado. Por favor contacte al administrador';

	END SP_CONSULTAR_EST_CXP;
------------------------------------------------------------------------------------------------------------------------

	PROCEDURE SP_DESAUTORIZAR_CXP( ivaNmExpediente        IN VARCHAR2,
																 ivaNmPagoAutorizacion  IN SIN_PAGOS_DET.NUMERO_PAGO_AUTORIZACION%TYPE,
																 ovaResultado           OUT VARCHAR2,
																 ovaMensajeTecnico      OUT VARCHAR2,
																 ovaMensajeUsuario      OUT VARCHAR2
																 ) IS

	--Variables para el manejo de Errores
  lvaMensajeTecnico           VARCHAR2(255)  := NULL;
	lvaMensajeTecnicoExt        VARCHAR2(255)  := NULL;
	lvaMensajeUsuario           VARCHAR2(255)  := NULL;
	lvaMensajeUsuarioExt        VARCHAR2(255)  := NULL;
	lexErrorProcedimiento       EXCEPTION;
	lexErrorProcedimientoExt    EXCEPTION;
	lvaNombreObjeto             VARCHAR2(30)   :='SP_DESAUTORIZAR_CXP';

	lvaerror                    VARCHAR2(2000)  := NULL;

	lobjMensaje                 OBJ_SAP_ANULACION_CXP := NULL;
  lobjResultados		          TAB_SBK_ANYDATA;
  lobjTransaccion	            OBJ_SAP_RESPUESTA_OP := OBJ_SAP_RESPUESTA_OP();
  linStatus			              INTEGER;

	BEGIN

	   lvaMensajeTecnico := 'Llamando al Adaptador';
     lobjMensaje := PCK_SIN_ADAPTADOR_SAP.FN_CREAR_MENSAJE_ANULAR_CXP(ivaNmExpediente,
																																			ivaNmPagoAutorizacion,
																																			lvaMensajeTecnicoExt,
																																			lvaMensajeUsuarioExt);
		 IF lvaMensajeTecnicoExt IS NOT NULL OR lvaMensajeUsuarioExt IS NOT NULL THEN
		    RAISE lexErrorProcedimientoExt;
		 END IF;

		 lvaMensajeTecnico := 'Llamando a SuraBroker';
		 lobjResultados := PCK_SBK_SURABROKER.FN_EJECUTAR_SERVICIO_SINCRONO(lobjMensaje);
		 lvaMensajeTecnico := 'Obteniendo los resultados';
		 linStatus := lobjResultados(1).GetObject(lobjTransaccion);
		 IF NVL(lobjTransaccion.ERROR, 'E') != 'E' THEN
				ovaMensajeTecnico := substr('Error: '||ivaNmPagoAutorizacion||' '||lobjTransaccion.ERROR,1,255);
				ovaMensajeUsuario := substr('Error: '||ivaNmPagoAutorizacion||' '||lobjTransaccion.ERROR,1,255);
		 END IF;
     
     /*
     - Modificado por: Sergio Garcia 2016/03/28
     - Asunto: Llamar al nuevo adaptador que se encarga de enviar la 
     -         información de PDN a SINFO
     - Proyecto: [Rediseño Cierre de Seguros]
     */
     
     BEGIN
         PCK_RCD_EJECUTA_CIERRE_DIARIO.SP_PROCESA_ANULADOS(ivaNmExpediente,
                                                            ivaNmPagoAutorizacion,
                                                            lvaMensajeTecnicoExt,
                                                            lvaMensajeUsuarioExt);
     EXCEPTION
         WHEN OTHERS THEN
           ovaMensajeTecnico:=lvaMensajeTecnicoExt;
           ovaMensajeUsuario:=lvaMensajeUsuarioExt;
     END;
     --Fin modificación Sergio Garcia.     
     
     
     
  EXCEPTION
      WHEN lexErrorProcedimientoExt THEN
				ovaMensajeTecnico := SUBSTR(TRIM(lpad(to_char(abs(SQLCODE)),7,'0' )||':'|| ' - '||lvaMensajeTecnicoExt),1,255);
				ovaMensajeUsuario := SUBSTR(TRIM(lvaMensajeUsuarioExt),1,255);
      WHEN lexErrorProcedimiento THEN
        ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
        ovaMensajeUsuario:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeUsuario;
      WHEN OTHERS THEN
			 --Llamado a Cronos
			 lvaerror := SQLERRM;
			 WHILE(length(lvaerror)>255) LOOP
       			 dbms_output.put_line(substr(lvaerror,1,255));
						 lvaerror := substr(lvaerror,255,length(lvaerror));
			 END LOOP;
			 dbms_output.put_line(lvaerror);
       ovaMensajeTecnico:= substr(gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico,1,255);
       ovaMensajeUsuario:= substr(SQLERRM,1,255);--'TRANSACCION NO DISPONIBLE ' ;

			 PCKCRO_INTERFAZ_CRONOS.SPCRO_ERROR('SINIESTROS',
																					'GestorSiniestros',
																					lpad(to_char(abs(SQLCODE)),7,'0' ),
																					'SINIESTROS',
																					SUBSTR(ivaNmExpediente||'-'||ivaNmPagoAutorizacion||'-'||lvaMensajeUsuario,1,255),
																					lvaMensajeTecnico);

	END SP_DESAUTORIZAR_CXP;

	PROCEDURE SP_ENVIAR_MENSAJE_CXC(ivaNmExpediente        IN SIN_PAGOS_DET.EXPEDIENTE%TYPE,
																	ivaNmPagoAutorizacion  IN SIN_PAGOS_DET.NUMERO_PAGO_AUTORIZACION%TYPE,
																	ovaMensajeTecnico      OUT VARCHAR2,
																	ovaMensajeUsuario      OUT VARCHAR2,
                                  ivaNmPagoVelru         IN NUMBER DEFAULT 0
																	) IS
  --Variables para el manejo de Errores
  lvaMensajeTecnico           VARCHAR2(255)  := NULL;
	lvaMensajeTecnicoExt        VARCHAR2(255)  := NULL;
	lvaMensajeUsuario           VARCHAR2(255)  := NULL;
	lvaMensajeUsuarioExt        VARCHAR2(255)  := NULL;
	lexErrorProcedimiento       EXCEPTION;
	lexErrorProcedimientoExt    EXCEPTION;
	lvaNombreObjeto             VARCHAR2(30)   :='SP_ENVIAR_MENSAJE_CXP';

	--Variables para funcionamiento
	lobjPago                    OBJ_SAP_CXC_SALVAMENTOS := NULL;

	BEGIN
	   lobjPago := PCK_SIN_ADAPTADOR_SAP.FN_CREAR_MENSAJE_CXC(ivaNmExpediente,
		                                                        ivaNmPagoAutorizacion,
																														lvaMensajeTecnicoExt,
																														lvaMensajeUsuarioExt,
                                                            ivaNmPagoVelru);
		 IF lvaMensajeTecnicoExt IS NOT NULL OR lvaMensajeUsuarioExt IS NOT NULL THEN
		    RAISE lexErrorProcedimientoExt;
		 END IF;

		 PCK_SBK_SURABROKER.SP_EJECUTAR_SERVICIO_ASINCRONO(lobjPago);

     UPDATE SIN_PAGOS_DET
     SET CDENSAP = 'S'
     WHERE EXPEDIENTE             = ivaNmExpediente
     AND NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion;

     /*
     - Modificado por: Sergio Garcia 2016/03/28
     - Asunto: Llamar al nuevo adaptador que se encarga de enviar la 
     -         información de PDN a SINFO
     - Proyecto: [Rediseño Cierre de Seguros]
     */

     BEGIN
         PCK_RCD_EJECUTA_CIERRE_DIARIO.SP_PROCESA_ANULADOS(ivaNmExpediente,
                                                          ivaNmPagoAutorizacion,
                                                          lvaMensajeTecnicoExt,
                                                          lvaMensajeUsuarioExt);
     EXCEPTION
         WHEN OTHERS THEN
           ovaMensajeTecnico:=lvaMensajeTecnicoExt;
           ovaMensajeUsuario:=lvaMensajeUsuarioExt;
     END;
     --Fin modificación Sergio Garcia.
     
  EXCEPTION
      WHEN lexErrorProcedimientoExt THEN
        ovaMensajeTecnico:=lvaMensajeTecnicoExt;
        ovaMensajeUsuario:=lvaMensajeUsuarioExt;
      WHEN lexErrorProcedimiento THEN
        ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
        ovaMensajeUsuario:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeUsuario;
      WHEN OTHERS THEN
			 --Llamado a Cronos
       ovaMensajeTecnico:= substr(gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico,1,255);
       ovaMensajeUsuario:= substr(SQLERRM,1,255);-- 'TRANSACCION NO DISPONIBLE ' ;
			 PCKCRO_INTERFAZ_CRONOS.SPCRO_ERROR('SINIESTROS',
																					'GestorSiniestros',
																					lpad(to_char(abs(SQLCODE)),7,'0' ),
																					'SINIESTROS',
																					SUBSTR(ivaNmExpediente||'-'||ivaNmPagoAutorizacion||'-'||lvaMensajeUsuario,1,255),
																					lvaMensajeTecnico);

	END SP_ENVIAR_MENSAJE_CXC;
------------------------------------------------------------------------------------------------------------------------

  PROCEDURE SP_DESAUTORIZAR_CXC( ivaNmExpediente        IN VARCHAR2,
                                 ivaNmPagoAutorizacion  IN SIN_PAGOS_DET.NUMERO_PAGO_AUTORIZACION%TYPE,
                                 ovaResultado           OUT VARCHAR2,
                                 ovaMensajeTecnico      OUT VARCHAR2,
                                 ovaMensajeUsuario      OUT VARCHAR2) IS
	--Variables para el manejo de Errores
  lvaMensajeTecnico           VARCHAR2(255)  := NULL;
	lvaMensajeTecnicoExt        VARCHAR2(255)  := NULL;
	lvaMensajeUsuario           VARCHAR2(255)  := NULL;
	lvaMensajeUsuarioExt        VARCHAR2(255)  := NULL;
	lexErrorProcedimiento       EXCEPTION;
	lexErrorProcedimientoExt    EXCEPTION;
	lvaNombreObjeto             VARCHAR2(30)   :='SP_DESAUTORIZAR_CXC_SEG';

	lvaerror                    VARCHAR2(2000)  := NULL;

	lobjMensaje                 OBJ_SAP_ANULACION_CXC_SEG := NULL;
  lobjResultados		          TAB_SBK_ANYDATA;
  lobjTransaccion	            OBJ_SAP_RESPUESTA_OP := OBJ_SAP_RESPUESTA_OP();
  linStatus			              INTEGER;

	BEGIN

	   lvaMensajeTecnico := 'Llamando al Adaptador';
     lobjMensaje := PCK_SIN_ADAPTADOR_SAP.FN_CREAR_MENSAJE_ANULAR_CXC(ivaNmExpediente,
																																			ivaNmPagoAutorizacion,
																																			lvaMensajeTecnicoExt,
																																			lvaMensajeUsuarioExt);
		 IF lvaMensajeTecnicoExt IS NOT NULL OR lvaMensajeUsuarioExt IS NOT NULL THEN
		    RAISE lexErrorProcedimientoExt;
		 END IF;

		 lvaMensajeTecnico := 'Llamando a SuraBroker';
		 lobjResultados := PCK_SBK_SURABROKER.FN_EJECUTAR_SERVICIO_SINCRONO(lobjMensaje);
		 lvaMensajeTecnico := 'Obteniendo los resultados';
		 linStatus := lobjResultados(1).GetObject(lobjTransaccion);
		 IF NVL(lobjTransaccion.ERROR, 'E') != 'E' THEN
				ovaMensajeTecnico := substr('Error: '||ivaNmPagoAutorizacion||' '||lobjTransaccion.ERROR,1,255);
				ovaMensajeUsuario := substr('Error: '||ivaNmPagoAutorizacion||' '||lobjTransaccion.ERROR,1,255);
		 END IF;
     
     /*
     - Modificado por: Sergio Garcia 2016/03/28
     - Asunto: Llamar al nuevo adaptador que se encarga de enviar la 
     -         información de PDN a SINFO
     - Proyecto: [Rediseño Cierre de Seguros]
     */
     
     BEGIN
         PCK_RCD_EJECUTA_CIERRE_DIARIO.SP_PROCESA_ANULADOS(ivaNmExpediente,
                                                            ivaNmPagoAutorizacion,
                                                            lvaMensajeTecnicoExt,
                                                            lvaMensajeUsuarioExt);
     EXCEPTION
         WHEN OTHERS THEN
           ovaMensajeTecnico:=lvaMensajeTecnicoExt;
           ovaMensajeUsuario:=lvaMensajeUsuarioExt;
     END;
     --Fin modificación Sergio Garcia. 
          
  EXCEPTION
      WHEN lexErrorProcedimientoExt THEN
				ovaMensajeTecnico := SUBSTR(TRIM(lpad(to_char(abs(SQLCODE)),7,'0' )||':'|| ' - '||lvaMensajeTecnicoExt),1,255);
				ovaMensajeUsuario := SUBSTR(TRIM(lvaMensajeUsuarioExt),1,255);
      WHEN lexErrorProcedimiento THEN
        ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
        ovaMensajeUsuario:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeUsuario;
      WHEN OTHERS THEN
			 --Llamado a Cronos
			 lvaerror := SQLERRM;
			 WHILE(length(lvaerror)>255) LOOP
       			 dbms_output.put_line(substr(lvaerror,1,255));
						 lvaerror := substr(lvaerror,255,length(lvaerror));
			 END LOOP;
			 dbms_output.put_line(lvaerror);
       ovaMensajeTecnico:= substr(gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico,1,255);
       ovaMensajeUsuario:= substr(SQLERRM,1,255);--'TRANSACCION NO DISPONIBLE ' ;

			 PCKCRO_INTERFAZ_CRONOS.SPCRO_ERROR('SINIESTROS',
																					'GestorSiniestros',
																					lpad(to_char(abs(SQLCODE)),7,'0' ),
																					'SINIESTROS',
																					SUBSTR(ivaNmExpediente||'-'||ivaNmPagoAutorizacion||'-'||lvaMensajeUsuario,1,255),
																					lvaMensajeTecnico);

  END SP_DESAUTORIZAR_CXC;

--------------------------------------------------------------------------------------------------------------------

/*	PROCEDURE SP_CREAR_MENSAJE_RETENCIONES(ivaCdSociedad           IN VARCHAR2,
                                         ivaDniBenePago          IN VARCHAR2,
                                         inuPtImporte            IN NUMBER,
                                         inuPtDeducible          IN NUMBER,
                                         ivaCdMoneda             IN VARCHAR2,
                                         inuPoIVA                IN VARCHAR2,
                                         iarrRetenciones         IN TAB_SAP_RETENCIONES_SINI,
                                         oarrRetenciones        OUT TAB_SAP_RETENCIONES_SINI,
--                                         ivaCdCodigoRetencion    IN VARCHAR2,
--                                         ivaCdIndicadorRetencion IN VARCHAR2,
--																         onuPtRetencion         OUT NUMBER,
--                                         onuPtBaseRetencion     OUT NUMBER,
 --                                        onuPoRetencion         OUT NUMBER,
        																 ovaMensajeTecnico      OUT VARCHAR2,
				        												 ovaMensajeUsuario      OUT VARCHAR2) IS
	
	 --Variables para el manejo de Errores
   lvaMensajeTecnico           VARCHAR2(1000)  := NULL;
	 lvaMensajeTecnicoExt        VARCHAR2(1000)  := NULL;
	 lvaMensajeUsuario           VARCHAR2(1000)  := NULL;
	 lvaMensajeUsuarioExt        VARCHAR2(1000)  := NULL;
	 lexErrorProcedimiento       EXCEPTION;
	 lexErrorProcedimientoExt    EXCEPTION;
	 lvaNombreObjeto             VARCHAR2(30)   :='SP_CREAR_MENSAJE_RETENCIONES';		
	                                      
	 lvaerror                    VARCHAR2(2000)  := NULL;
 	
   lobjSimulaRetencionReq      OBJ_SAP_SIMULA_RETENC_SINI_REQ := OBJ_SAP_SIMULA_RETENC_SINI_REQ();
   lobjResultados		           TAB_SBK_ANYDATA;
   lobjTransaccion	           OBJ_SAP_SIMULA_RETENC_SINI_RES := OBJ_SAP_SIMULA_RETENC_SINI_RES(); 
--   ltabTransaccion	           TAB_SAP_SIMULA_RETENC_SINI_RES := TAB_SAP_SIMULA_RETENC_SINI_RES(OBJ_SAP_SIMULA_RETENC_SINI_RES()); 
   lobjRetenciones             OBJ_SAP_RETENCIONES_SINI       := OBJ_SAP_RETENCIONES_SINI();
   ltabRetenciones             TAB_SAP_RETENCIONES_SINI       := TAB_SAP_RETENCIONES_SINI(OBJ_SAP_RETENCIONES_SINI());
   ltabDatoRetencionSini       TAB_SAP_DATO_RETENCION_SINI    := TAB_SAP_DATO_RETENCION_SINI(OBJ_SAP_DATO_RETENCION_SINI());
   linStatus			             INTEGER;	

	BEGIN 
	   
	 lvaMensajeTecnico := 'Llamando al Adaptador';
   lobjSimulaRetencionReq := PCK_SIN_ADAPTADOR_SAP.FN_CREAR_MENSAJE_RETENCIONES(ivaCdSociedad,
                                                                                ivaDniBenePago,
                                                                                inuPtImporte,
                                                                                inuPtDeducible,
                                                                                ivaCdMoneda,
                                                                                inuPoIVA,
                                                                                iarrRetenciones,
--                                                                                ivaCdCodigoRetencion,
--                                                                                ivaCdIndicadorRetencion,
																																		            lvaMensajeTecnicoExt,
																																				        lvaMensajeUsuarioExt);  
	 IF lvaMensajeTecnicoExt IS NOT NULL OR lvaMensajeUsuarioExt IS NOT NULL THEN
    RAISE lexErrorProcedimientoExt;
	 END IF;
		 
	 lvaMensajeTecnico := 'Llamando a SuraBroker';
	 lobjResultados := PCK_SBK_SURABROKER.FN_EJECUTAR_SERVICIO_SINCRONO(lobjSimulaRetencionReq);
     
	 lvaMensajeTecnico := 'Obteniendo los resultados';
	 linStatus := lobjResultados(1).GetObject(lobjTransaccion);
   
   ltabDatoRetencionSini := lobjTransaccion.datosRetenciones;
   ltabRetenciones       := ltabDatoRetencionSini(1).retenciones;
   
   oarrRetenciones    := ltabRetenciones;
--   onuPtRetencion     := ltabRetenciones(1).ptRetencion;  --lobjRetenciones.ptRetencion;
--   onuPtBaseRetencion := ltabRetenciones(1).ptBaseRetencion;
-- 	 onuPoRetencion     := ltabRetenciones(1).poRetencion;

  EXCEPTION
   WHEN lexErrorProcedimientoExt THEN
		ovaMensajeTecnico := SUBSTR(TRIM(lpad(to_char(abs(SQLCODE)),7,'0' )||':'|| ' - '||lvaMensajeTecnicoExt),1,255);
		ovaMensajeUsuario := SUBSTR(TRIM(lvaMensajeUsuarioExt),1,255);
   WHEN lexErrorProcedimiento THEN
    ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
    ovaMensajeUsuario:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeUsuario;
   WHEN OTHERS THEN
    --Llamado a Cronos   
		lvaerror := SQLERRM;
		WHILE(length(lvaerror)>1000) LOOP
     dbms_output.put_line(substr(lvaerror,1,1000));   
		 lvaerror := substr(lvaerror,255,length(lvaerror));
		END LOOP;   
		 dbms_output.put_line(lvaerror);   
     ovaMensajeTecnico:= substr(gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico,1,255);
     ovaMensajeUsuario:= substr(SQLERRM,1,255);--'TRANSACCION NO DISPONIBLE ' ;	
			 
		 PCKCRO_INTERFAZ_CRONOS.SPCRO_ERROR('SINIESTROS',
																				'GestorSiniestros',
																				lpad(to_char(abs(SQLCODE)),7,'0' ),
																				'SINIESTROS',
																				SUBSTR(ivaCdSociedad||'-'||ivaDniBenePago||'-'||inuPtImporte||'-'||lvaMensajeUsuario,1,255),                                        
--																				SUBSTR(ivaCdCodigoRetencion||'-'||ivaCdIndicadorRetencion||'-'||lvaMensajeUsuario,1,255),
																				lvaMensajeTecnico||' TRACE DE ERROR:' || DBMS_UTILITY.format_error_backtrace||' INFORMACION DE ERROR:' || DBMS_UTILITY.format_error_stack); 
		 
	END SP_CREAR_MENSAJE_RETENCIONES;
--------------------------------------------------------------------------------------------------------  
  PROCEDURE SP_INVOCAR_MENSAJE_RETENCIONES (ivaCdSociedad                IN VARCHAR2,
                                            ivaDniBenePago               IN VARCHAR2,
                                            inuPtImporte                 IN NUMBER,
                                            inuPtDeducible               IN NUMBER,
                                            ivaCdMoneda                  IN VARCHAR2,
                                            inuPoIVA                     IN VARCHAR2,
                                            ivaCdTipoRetencionFTE        IN VARCHAR2,
                                            ivaCdIndicadorRetencionFTE   IN VARCHAR2,
                                            ivaCdTipoRetencionIVA        IN VARCHAR2,
                                            ivaCdIndicadorRetencionIVA   IN VARCHAR2,
                                            ivaCdTipoRetencionICA        IN VARCHAR2,
                                            ivaCdIndicadorRetencionICA   IN VARCHAR2,
                                            ovaCdTipoRetencionFTE       OUT VARCHAR2,
                                            ovaCdIndicadorRetencionFTE  OUT VARCHAR2,
                                            onuPtRetencionFTE           OUT NUMBER,                
                                            onuPtBaseRetencionFTE       OUT NUMBER,
                                            onuPoRetencionFTE           OUT NUMBER,
                                            ovaCdTipoRetencionCREE      OUT VARCHAR2,
                                            ovaCdIndicadorRetencionCREE OUT VARCHAR2,
                                            onuPtRetencionCREE          OUT NUMBER,                
                                            onuPtBaseRetencionCREE      OUT NUMBER,
                                            onuPoRetencionCREE          OUT NUMBER,
                                            ovaCdTipoRetencionIVA       OUT VARCHAR2,
                                            ovaCdIndicadorRetencionIVA  OUT VARCHAR2,
                                            onuPtRetencionIVA           OUT NUMBER,                
                                            onuPtBaseRetencionIVA       OUT NUMBER,
                                            onuPoRetencionIVA           OUT NUMBER,
                                            ovaCdTipoRetencionICA       OUT VARCHAR2,
                                            ovaCdIndicadorRetencionICA  OUT VARCHAR2,
                                            onuPtRetencionICA           OUT NUMBER,                
                                            onuPtBaseRetencionICA       OUT NUMBER,
                                            onuPoRetencionICA           OUT NUMBER,
                                            ovaCdTipoValorIVA           OUT VARCHAR2,
                                            ovaCdIndicadorValorIVA      OUT VARCHAR2,
                                            onuPtValorIVA               OUT NUMBER,                
                                            onuPtBaseValorIVA           OUT NUMBER,
                                            onuPoValorIVA               OUT NUMBER,
                                            ovaCdTipoValorIVADesc       OUT VARCHAR2,
                                            ovaCdIndicadorValorIVADesc  OUT VARCHAR2,
                                            onuPtValorIVADesc           OUT NUMBER,                
                                            onuPtBaseValorIVADesc       OUT NUMBER,
                                            onuPoValorIVADesc           OUT NUMBER,
                                            ovaMensajeTecnico           OUT VARCHAR2,
                                            ovaMensajeUsuario           OUT VARCHAR2) IS

  lvaMensajeTecnico        VARCHAR2(1000)  := NULL;
  lvaMensajeTecnicoExt     VARCHAR2(1000)  := NULL;
  lvaMensajeUsuario        VARCHAR2(1000)  := NULL;
  lvaMensajeUsuarioExt     VARCHAR2(1000)  := NULL;
  lexErrorProcedimiento    EXCEPTION;
  lexErrorProcedimientoExt EXCEPTION;
  lvaNombreObjeto          VARCHAR2(30)   :='SP_INVOCAR_MENSAJE_RETENCIONES';

  iarrretenciones          tab_sap_retenciones_sini := tab_sap_retenciones_sini(obj_sap_retenciones_sini() );
  oarrretenciones          tab_sap_retenciones_sini := tab_sap_retenciones_sini(obj_sap_retenciones_sini());
  lobjretenciones          obj_sap_retenciones_sini := obj_sap_retenciones_sini();
  lnuContRetenciones       NUMBER(2) := 0;
   
  lvaCdTipoRetencionStr    SIN_TIPOS_RETENCIONES.CDTIPO_RETENCION%TYPE;
  lvaTipoIdentBenePago     VARCHAR2(3);
  lvaSnPersonaNatural      TPER_TIPOS_PERSONAS.SNNATURAL%TYPE; 

  CURSOR lcuPersonaNatural IS
   SELECT p.SNNATURAL
   FROM TPER_TIPOS_PERSONAS p
   WHERE p.CDTIPO_PERSONA = lvaTipoIdentBenePago;
   
  CURSOR lcuTipoRetencion IS
   SELECT CDTIPO_RETENCION
   FROM SIN_TIPOS_RETENCIONES
   WHERE CDRETENCION = ivaCdTipoRetencionFTE;

 BEGIN
  lvaTipoIdentBenePago := PCK_SIC_UTILITARIOS_I.FN_SIC_CDTIPO_IDENTIFICACION(ivaDniBenePago);
 
  OPEN lcuPersonaNatural;
  FETCH lcuPersonaNatural INTO lvaSnPersonaNatural;
  IF lcuPersonaNatural%NOTFOUND THEN
   lvaSnPersonaNatural := 'S';
  END IF;
  CLOSE lcuPersonaNatural;

  OPEN lcuTipoRetencion;
  FETCH lcuTipoRetencion INTO lvaCdTipoRetencionStr;
  IF lcuTipoRetencion%NOTFOUND THEN
   lvaCdTipoRetencionStr := ' ';
  END IF;
  CLOSE lcuTipoRetencion; 

--  IF lvaSnPersonaNatural = 'S' AND (lvaCdTipoRetencionStr LIKE 'H%' OR lvaCdTipoRetencionStr IN ('CF','SM')) THEN
  IF ivaCdTipoRetencionFTE IS NOT NULL THEN
   lnuContRetenciones                   := lnuContRetenciones + 1;
   lobjretenciones.cdTipoRetencion      := ivaCdTipoRetencionFTE;
   lobjretenciones.cdIndicadorRetencion := ivaCdIndicadorRetencionFTE;
   IF lnuContRetenciones = 1 THEN
    iarrretenciones(lnuContRetenciones) := lobjRetenciones;
   ELSE
    iarrretenciones.Extend;
    iarrretenciones(lnuContRetenciones) := lobjRetenciones;
   END IF;   
  END IF;

  IF ivaCdTipoRetencionIVA IS NOT NULL THEN
   lnuContRetenciones                   := lnuContRetenciones + 1;
   lobjretenciones.cdTipoRetencion      := ivaCdTipoRetencionIVA;
   lobjretenciones.cdIndicadorRetencion := ivaCdIndicadorRetencionIVA;
   IF lnuContRetenciones = 1 THEN
    iarrretenciones(lnuContRetenciones) := lobjRetenciones;
   ELSE
    iarrretenciones.Extend;
    iarrretenciones(lnuContRetenciones) := lobjRetenciones;
   END IF;   
  END IF;

  IF ivaCdTipoRetencionICA IS NOT NULL THEN
   lnuContRetenciones                   := lnuContRetenciones + 1;  
   lobjretenciones.cdTipoRetencion      := ivaCdTipoRetencionICA;
   lobjretenciones.cdIndicadorRetencion := ivaCdIndicadorRetencionICA;
   IF lnuContRetenciones = 1 THEN
    iarrretenciones(lnuContRetenciones) := lobjRetenciones;
   ELSE
    iarrretenciones.Extend;
    iarrretenciones(lnuContRetenciones) := lobjRetenciones;
   END IF;   
  END IF;
     
 	PCK_SIN_GESTOR_SAP.SP_CREAR_MENSAJE_RETENCIONES(ivaCdSociedad,
                                                  ivaDniBenePago,
                                                  inuPtImporte,
                                                  inuPtDeducible,
                                                  ivaCdMoneda,
                                                  inuPoIVA,
                                                  iarrretenciones,
                                                  oarrretenciones,
                                                  lvaMensajeTecnicoExt,--ovaMensajeTecnicoExt
	                                                lvaMensajeUsuarioExt); --ovaMensajeUsuarioExt
  IF lvaMensajeTecnicoExt IS NOT NULL OR lvaMensajeUsuarioExt IS NOT NULL THEN
   lvaMensajeUsuario:= 'EXISTE UN ERROR EN SAP CALCULANDO LAS RETENCIONES.  FAVOR AVISAR AL PUESTO DE AYUDA';
   RAISE lexErrorProcedimientoExt;
  ELSE 
   FOR lnuRecord IN oarrRetenciones.FIRST..oarrRetenciones.LAST  LOOP
    IF oarrRetenciones(lnuRecord).cdIndicadorRetencion = 'R' THEN
     ovaCdTipoRetencionFTE      := oarrRetenciones(lnuRecord).cdTipoRetencion; 
     ovaCdIndicadorRetencionFTE := oarrRetenciones(lnuRecord).cdIndicadorRetencion;
     onuPtRetencionFTE          := oarrRetenciones(lnuRecord).ptRetencion;
     onuPtBaseRetencionFTE      := oarrRetenciones(lnuRecord).ptBaseRetencion;
     onuPoRetencionFTE          := oarrRetenciones(lnuRecord).poRetencion;
    ELSIF oarrRetenciones(lnuRecord).cdIndicadorRetencion IN ('FB','FC','FD') THEN
     ovaCdTipoRetencionCREE     := oarrRetenciones(lnuRecord).cdTipoRetencion;
     ovaCdIndicadorRetencionCREE:= oarrRetenciones(lnuRecord).cdIndicadorRetencion;
     onuPtRetencionCREE         := oarrRetenciones(lnuRecord).ptRetencion;
     onuPtBaseRetencionCREE     := oarrRetenciones(lnuRecord).ptBaseRetencion;
     onuPoRetencionCREE         := oarrRetenciones(lnuRecord).poRetencion;
    ELSIF oarrRetenciones(lnuRecord).cdIndicadorRetencion = 'I' THEN
     ovaCdTipoRetencionIVA      := oarrRetenciones(lnuRecord).cdTipoRetencion;
     ovaCdIndicadorRetencionIVA := oarrRetenciones(lnuRecord).cdIndicadorRetencion;
     onuPtRetencionIVA          := oarrRetenciones(lnuRecord).ptRetencion;
     onuPtBaseRetencionIVA      := oarrRetenciones(lnuRecord).ptBaseRetencion;
     onuPoRetencionIVA          := oarrRetenciones(lnuRecord).poRetencion;
    ELSE -- Es porque viene reteICA que el indicador es un codigo de ciudad
     ovaCdTipoRetencionICA      := oarrRetenciones(lnuRecord).cdTipoRetencion;
     ovaCdIndicadorRetencionICA := oarrRetenciones(lnuRecord).cdIndicadorRetencion;
     onuPtRetencionICA          := oarrRetenciones(lnuRecord).ptRetencion;
     onuPtBaseRetencionICA      := oarrRetenciones(lnuRecord).ptBaseRetencion;
     onuPoRetencionICA          := oarrRetenciones(lnuRecord).poRetencion;
    END IF;
  END LOOP;
  
  
  END IF;

--  END IF;
 EXCEPTION
   WHEN lexErrorProcedimientoExt THEN
    ovaMensajeTecnico:=lvaMensajeTecnicoExt;
    ovaMensajeUsuario:=lvaMensajeUsuarioExt;
   WHEN lexErrorProcedimiento THEN
    ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
    ovaMensajeUsuario:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeUsuario;
   WHEN OTHERS THEN
    ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
    ovaMensajeUsuario:= 'TRANSACCION NO DISPONIBLE ' ;

 END SP_INVOCAR_MENSAJE_RETENCIONES;
*/--------------------------------------------------------------------------------------------------------------------

END PCK_SIN_GESTOR_SAP;
/

-- ***************** permisos

-- ************ USER OPS$ADM_ATRSURA ************
GRANT SELECT, INSERT, UPDATE, DELETE ON OPS$PROCEDIM.TATR_ASYNC_TX_1 TO OPS$ADM_ATRSURA;
GRANT SELECT, INSERT, UPDATE, DELETE ON OPS$PROCEDIM.TATR_ASYNC_TX_ERRORS_1 TO OPS$ADM_ATRSURA;
GRANT SELECT, INSERT, UPDATE, DELETE ON OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1 TO OPS$ADM_ATRSURA;
--packages
GRANT EXECUTE ON OPS$PROCEDIM.pck_sin_ban_adaptador_cpi TO OPS$ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.pck_cpi_integration_v2 TO OPS$ADM_ATRSURA;
--types
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_HEADERS TO OPS$ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_PARAM_ADICIONAL TO OPS$ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.TAB_CPI_CAUSA_PARAM_ADICIONAL TO OPS$ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_CONTROL TO OPS$ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_DET_CONTABLE TO OPS$ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_CAB_DATOS_GENERALES TO OPS$ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_CABECERA TO OPS$ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_PARAM_CONTABLE TO OPS$ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_DATOS_GENERALES TO OPS$ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_DESCUENTO TO OPS$ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_RETENCION TO OPS$ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.TAB_CPI_CAUSA_POS_RETENCION TO OPS$ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_TERCERO_GENERAL TO OPS$ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_TERCERO_PAGADOR TO OPS$ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_TERCERO_BANCARIO TO OPS$ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_TERCERO_DET_BANCARIA TO OPS$ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_TERCERO TO OPS$ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_RESUMEN TO OPS$ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_DETALLE TO OPS$ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.TAB_CPI_CAUSA_POS_DETALLE TO OPS$ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POSICION TO OPS$ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.TAB_CPI_CAUSA_POSICION TO OPS$ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSACION_CONTABLE TO OPS$ADM_ATRSURA;


-- ************ USER ADM_ATRSURA ************
GRANT SELECT, INSERT, UPDATE, DELETE ON OPS$PROCEDIM.TATR_ASYNC_TX_1 TO ADM_ATRSURA;
GRANT SELECT, INSERT, UPDATE, DELETE ON OPS$PROCEDIM.TATR_ASYNC_TX_ERRORS_1 TO ADM_ATRSURA;
GRANT SELECT, INSERT, UPDATE, DELETE ON OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1 TO ADM_ATRSURA;
--packages
GRANT EXECUTE ON OPS$PROCEDIM.pck_sin_ban_adaptador_cpi TO ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.pck_cpi_integration_v2 TO ADM_ATRSURA;
--types
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_HEADERS TO ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_PARAM_ADICIONAL TO ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.TAB_CPI_CAUSA_PARAM_ADICIONAL TO ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_CONTROL TO ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_DET_CONTABLE TO ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_CAB_DATOS_GENERALES TO ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_CABECERA TO ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_PARAM_CONTABLE TO ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_DATOS_GENERALES TO ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_DESCUENTO TO ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_RETENCION TO ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.TAB_CPI_CAUSA_POS_RETENCION TO ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_TERCERO_GENERAL TO ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_TERCERO_PAGADOR TO ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_TERCERO_BANCARIO TO ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_TERCERO_DET_BANCARIA TO ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_TERCERO TO ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_RESUMEN TO ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_DETALLE TO ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.TAB_CPI_CAUSA_POS_DETALLE TO ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POSICION TO ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.TAB_CPI_CAUSA_POSICION TO ADM_ATRSURA;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSACION_CONTABLE TO ADM_ATRSURA;


-- ************ USER OPS$SINI ************
GRANT SELECT, INSERT, UPDATE, DELETE ON OPS$PROCEDIM.TATR_ASYNC_TX_1 TO OPS$SINI;
GRANT SELECT, INSERT, UPDATE, DELETE ON OPS$PROCEDIM.TATR_ASYNC_TX_ERRORS_1 TO OPS$SINI;
GRANT SELECT, INSERT, UPDATE, DELETE ON OPS$PROCEDIM.TATR_ASYNC_TX_HISTORY_1 TO OPS$SINI;
--packages
GRANT EXECUTE ON OPS$PROCEDIM.pck_sin_ban_adaptador_cpi TO OPS$SINI;
GRANT EXECUTE ON OPS$PROCEDIM.pck_cpi_integration_v2 TO OPS$SINI;
--types
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_HEADERS TO OPS$SINI;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_PARAM_ADICIONAL TO OPS$SINI;
GRANT EXECUTE ON OPS$PROCEDIM.TAB_CPI_CAUSA_PARAM_ADICIONAL TO OPS$SINI;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_CONTROL TO OPS$SINI;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_DET_CONTABLE TO OPS$SINI;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_CAB_DATOS_GENERALES TO OPS$SINI;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_CABECERA TO OPS$SINI;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_PARAM_CONTABLE TO OPS$SINI;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_DATOS_GENERALES TO OPS$SINI;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_DESCUENTO TO OPS$SINI;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_RETENCION TO OPS$SINI;
GRANT EXECUTE ON OPS$PROCEDIM.TAB_CPI_CAUSA_POS_RETENCION TO OPS$SINI;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_TERCERO_GENERAL TO OPS$SINI;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_TERCERO_PAGADOR TO OPS$SINI;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_TERCERO_BANCARIO TO OPS$SINI;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_TERCERO_DET_BANCARIA TO OPS$SINI;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_TERCERO TO OPS$SINI;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_RESUMEN TO OPS$SINI;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_DETALLE TO OPS$SINI;
GRANT EXECUTE ON OPS$PROCEDIM.TAB_CPI_CAUSA_POS_DETALLE TO OPS$SINI;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSA_POSICION TO OPS$SINI;
GRANT EXECUTE ON OPS$PROCEDIM.TAB_CPI_CAUSA_POSICION TO OPS$SINI;
GRANT EXECUTE ON OPS$PROCEDIM.OBJ_CPI_CAUSACION_CONTABLE TO OPS$SINI;