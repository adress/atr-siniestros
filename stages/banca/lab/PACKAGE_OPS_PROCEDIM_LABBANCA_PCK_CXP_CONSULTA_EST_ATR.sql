
  CREATE OR REPLACE PACKAGE OPS$PROCEDIM.PCK_CXP_CONSULTA_EST_ATR AS
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
CREATE OR REPLACE PACKAGE BODY OPS$PROCEDIM.PCK_CXP_CONSULTA_EST_ATR AS
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
  s := TRIM(p);
  s := REPLACE(s, ',', '.');
  IF s IS NULL THEN
    RETURN NULL;
  END IF;

  IF REGEXP_LIKE(s, '[+-]$') THEN
    RETURN TO_NUMBER(s,
                     'FM9999999999990D9999999MI',
                     'NLS_NUMERIC_CHARACTERS=''.,''');
  ELSE
    RETURN TO_NUMBER(s,
                     'FM9999999999990D9999999',
                     'NLS_NUMERIC_CHARACTERS=''.,''');
  END IF;
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

   -- Default: si no llega estado ni documentos, devolver N
    o_estado := 'N';
    ------------------------------------------------------------------------
    -- 1) SELECCI?N (se arma igual que en el legado)
    ------------------------------------------------------------------------
    IF v_cd_comp IS NOT NULL THEN
      l_sel := l_sel || l_sep
               || '{"filtro":"BUKRS","indicador":"D","opciones":[{"Sign":"I","Option":"EQ","Low":"'
               || jesc(v_cd_comp)
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

    --@ivan si lo vas a cosnultar desde una tabla usa este bloque
      -- BEGIN
      --     SELECT CDUSUARIO, CDCLAVE, DSNAME_SPACE, DSPUERTO
      --       INTO v_usuario, v_clave, v_url_destino, v_oauth_url
      --       FROM TCOB_PARAMETROS_SAP
      --     WHERE CDSERVICIO = ivaTargetSystem
      --       AND CDPROCESO = ivaSourceApplicationName;
      -- EXCEPTION
      --     WHEN NO_DATA_FOUND THEN
      --         ovaMensajeTecnico := 'No se encontraron credenciales/URLs para los parámetros proporcionados.';
      --         ovaMensajeUsuario := 'No se encontraron credenciales/URLs para la integración solicitada.';
      --         RETURN;
      --     WHEN OTHERS THEN
      --         ovaMensajeTecnico := 'Error inesperado al obtener credenciales/URLs: ' || SQLERRM;
      --         ovaMensajeUsuario := 'Ocurrió un error al obtener credenciales/URLs.';
      --         RETURN;
      -- END;



    PCK_SAP_APIGEE_CONSULTA_V2.SP_GENERAR_JSON_HEADER_FENIX_APIGEE(
      ivaTargetSystem           => 'sap',
      ivaTargetSystemProcess    => 'consultasdoc_cxp',
      ivaSourceApplicationName  => 'ATR',
      ivaIntegrationMethod      => 'bd-sync',
      ivaCorrelationId          => NULL,
      ivaIsBatchOperation       => 'false',
      ivaRefSrc1                => 'REF-001',
      ivaOauthUrl               => 'https://apiinternal.labsura.com/oauth/v1/clientcredential/accesstoken?grant_type=client_credentials',
      ivaOauthClientId          => 'UnSead4Nq9KcxpqGvgYAABKOp7sVGtEnqJk5c1sfQ8DQ9UQm',
      ivaOauthClientSecret      => 'aXk5TGFETk5EejFEdDBsSHlDMGJHVTZ0cVFKbVhzQTQwVlhCb05Bbnh2dkNxcHJ6RnlkWnFFMVFJNDVmMkFaVw==',
      ivaOauthSecretIsBase64    => 'S',
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
      o_msj_tecnico := 'HEADER: access_token vacio o ausente';
      o_msj_usuario := 'No se obtuvo token de autenticacion.';
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
    --
    PCK_SAP_APIGEE_CONSULTA_V2.SP_LLAMAR_GNL_CALL_SYNC_FENIX_APIGEE(
      ivaMetodo         => 'POST',
      ivaHeaders        => v_json_header,
      ivaToken          => v_token,
      ivaBody           => v_json_body,
      ivaTimeout        => 30,
      ivaWalletPath     => NULL,
      ivaUrlDestino     => 'https://apiinternal.labsura.com/sap/v1/contabilizacion/consulta',
      ocaRespuesta      => v_resp_sync,
      ovaMensajeTecnico => v_msj_ts,
      ovaMensajeUsuario => v_msj_us
    );
    IF v_msj_ts IS NOT NULL THEN
      o_estado      := 'Error';
      o_msj_tecnico := SUBSTR('SYNC: '||v_msj_ts,1,c_len_msg);
      o_msj_usuario := SUBSTR(NVL(v_msj_us,'Error en llamada sincrona'),1,c_len_msg);
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
          -- Sin posiciones/documentos: devolver N sin marcar error
          o_estado      := 'N';
          o_msj_tecnico := NULL;
          o_msj_usuario := NULL;
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