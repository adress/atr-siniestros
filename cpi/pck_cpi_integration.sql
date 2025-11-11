/*
    ============================================================================
    Archivo: pck_integration_cpi.sql
    Descripcion: Paquete de integracion CPI que expone procedimientos para
                 ejecucion de servicios sincronos y asincronos y utilidades
                 de serializacion a JSON para el tipo OBJ_CPI_CAUSACION_CONTABLE.
    Autor: Jaime Andres Ortiz
    Fecha: 2025-09-17
    Version: 1.0.0
    Notas:
      - Depende de los tipos definidos en obj_cpi_causacion_contable.sql
        (OBJ_CPI_CAUSACION_CONTABLE y tipos relacionados).
      - No modifica datos; imprime JSON a DBMS_OUTPUT y prepara payload para
        almacenamiento/consumo asincrono.

    Cambios:
      - 2025-09-17: Cabecera anadida.
      - 2025-09-25: Serializacion a JSON usando JSON_OBJECT_T/JSON_ARRAY_T.
      - 2025-09-25: Permite parametrizar la tabla destino para el payload asincrono.
    ============================================================================
*/

create or replace PACKAGE OPS$PROCEDIM.PCK_CPI_INTEGRATION IS
  PROCEDURE SP_EJECUTAR_SERVICIO_ASINCRONO(ityMensaje IN OUT NOCOPY OBJ_CPI_CAUSACION_CONTABLE, iTablaDestino IN VARCHAR2);
  PROCEDURE SP_EJECUTAR_SERVICIO_ASINCRONO(ityMensaje IN OUT NOCOPY CLOB, iTablaDestino IN VARCHAR2);
  PROCEDURE SP_EJECUTAR_SERV_ASINC_CBACK(ityMensaje IN OUT NOCOPY OBJ_SBK_MENSAJE);
  --FUNCTION FN_EJECUTAR_SERVICIO_SINCRONO(ityMensaje IN OUT NOCOPY OBJ_SBK_MENSAJE) RETURN TAB_SBK_ANYDATA;

  -- Fachada para PCK_SAP_APIGEE_CONSULTA
  PROCEDURE CPI_GENERAR_JSON_HEADER_FENIX_APIGEE(
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

  PROCEDURE CPI_GENERAR_JSON_BODY_FENIX_APIGEE(
    ivaSistemaOrigen          IN  VARCHAR2,
    ivaClaseCuenta            IN  VARCHAR2,
    ivaEstado                 IN  VARCHAR2,
    ivaSeleccion              IN  CLOB,
    ocaJsonBody               OUT CLOB,
    ovaMensajeTecnico         OUT VARCHAR2,
    ovaMensajeUsuario         OUT VARCHAR2
  );

  PROCEDURE CPI_LLAMAR_GNL_CALL_SYNC_FENIX_APIGEE(
    ivaMetodo          IN VARCHAR2,
    ivaHeaders         IN CLOB,
    ivaToken           IN VARCHAR2,
    ivaBody            IN CLOB,
    ivaTimeout         IN NUMBER DEFAULT 30,
    ivaWalletPath      IN VARCHAR2 DEFAULT NULL,
    ocaRespuesta       OUT CLOB,
    ovaMensajeTecnico  OUT VARCHAR2,
    ovaMensajeUsuario  OUT VARCHAR2
  );

END PCK_CPI_INTEGRATION;
/

CREATE OR REPLACE PACKAGE BODY OPS$PROCEDIM.PCK_CPI_INTEGRATION IS

  -- Serializacion de OBJ_CPI_CAUSACION_CONTABLE a JSON usando JSON_OBJECT_T/JSON_ARRAY_T
  FUNCTION CAUSACION_TO_JSON_OBJ(p_obj IN OBJ_CPI_CAUSACION_CONTABLE) RETURN JSON_OBJECT_T IS
    v_headers_obj           JSON_OBJECT_T;
    v_control_obj           JSON_OBJECT_T;
    v_cabecera_obj          JSON_OBJECT_T;
    v_det_cont_obj          JSON_OBJECT_T;
    v_datos_gen_obj         JSON_OBJECT_T;
    v_param_adic_cab_array  JSON_ARRAY_T;
    v_posiciones_array      JSON_ARRAY_T;
    v_posicion_obj          JSON_OBJECT_T;
    v_resumen_obj           JSON_OBJECT_T;
    v_param_cont_obj        JSON_OBJECT_T;
    v_datos_gen_pos_obj     JSON_OBJECT_T;
    v_descuento_obj         JSON_OBJECT_T;
    v_retenciones_array     JSON_ARRAY_T;
    v_tercero_obj           JSON_OBJECT_T;
    v_general_tercero_obj   JSON_OBJECT_T;
    v_pagador_alt_obj       JSON_OBJECT_T;
    v_datos_bancarios_obj   JSON_OBJECT_T;
    v_det_bancaria_obj      JSON_OBJECT_T;
    v_param_adic_pos_array  JSON_ARRAY_T;
    v_detalle_array         JSON_ARRAY_T;
    v_json_obj              JSON_OBJECT_T;
    v_idx                   PLS_INTEGER;
    v_idx_ret               PLS_INTEGER;
    v_idx_param             PLS_INTEGER;
  BEGIN
    -- HEADERS
    v_headers_obj := JSON_OBJECT_T();
    v_headers_obj.put('request-id', NVL(p_obj.headers.request_id, ''));
    v_headers_obj.put('ref-src-1', NVL(p_obj.headers.ref_src_1, ''));
    v_headers_obj.put('target-system', NVL(p_obj.headers.target_system, ''));
    v_headers_obj.put('target-system-process', NVL(p_obj.headers.target_system_process, ''));
    v_headers_obj.put('source-application-name', NVL(p_obj.headers.source_application_name, ''));
    v_headers_obj.put('integration-method', NVL(p_obj.headers.integration_method, ''));
    v_headers_obj.put('key', NVL(p_obj.headers.key, ''));
    v_headers_obj.put('secret', NVL(p_obj.headers.secret, ''));
    v_headers_obj.put('correlation-id', NVL(p_obj.headers.correlation_id, ''));

    -- CONTROL
    v_control_obj := JSON_OBJECT_T();
    v_control_obj.put('sistemaOrigen', 'ATRSINIEST'); --NVL(p_obj.control.sistemaOrigen, '')
    v_control_obj.put('identificador', NVL(p_obj.control.identificador, ''));

    -- CABECERA
    v_det_cont_obj := JSON_OBJECT_T();
    v_det_cont_obj.put('canal', NVL(p_obj.cabecera.determinacionContable.canal, ''));
    v_det_cont_obj.put('fuente', NVL(p_obj.cabecera.determinacionContable.fuente, ''));
    v_det_cont_obj.put('operacion', NVL(p_obj.cabecera.determinacionContable.operacion, ''));
    v_det_cont_obj.put('aplicacion', NVL(p_obj.cabecera.determinacionContable.aplicacion, ''));

    v_datos_gen_obj := JSON_OBJECT_T();
    v_datos_gen_obj.put('sociedad', NVL(p_obj.cabecera.datosGenerales.sociedad, ''));
    v_datos_gen_obj.put('fechaDocumento', NVL(p_obj.cabecera.datosGenerales.fechaDocumento, ''));
    v_datos_gen_obj.put('fechaContable', NVL(p_obj.cabecera.datosGenerales.fechaContable, ''));
    v_datos_gen_obj.put('moneda', NVL(p_obj.cabecera.datosGenerales.moneda, ''));
    v_datos_gen_obj.put('referencia', NVL(p_obj.cabecera.datosGenerales.referencia, ''));
    v_datos_gen_obj.put('claveReferencia1', NVL(p_obj.cabecera.datosGenerales.claveReferencia1, ''));
    v_datos_gen_obj.put('claveReferencia2', NVL(p_obj.cabecera.datosGenerales.claveReferencia2, ''));
    v_datos_gen_obj.put('texto', NVL(p_obj.cabecera.datosGenerales.texto, ''));
    v_datos_gen_obj.put('tipoCambio', NVL(p_obj.cabecera.datosGenerales.tipoCambio, ''));           --solo se llena cuando esta es diferente a pesos 0:pesos 1:dolares
    v_datos_gen_obj.put('fechaTipoCambio', NVL(p_obj.cabecera.datosGenerales.fechaTipoCambio, ''));

    v_param_adic_cab_array := JSON_ARRAY_T();
    IF p_obj.cabecera.parametrosAdicionales.COUNT > 0 THEN
      FOR v_idx_param IN 1..p_obj.cabecera.parametrosAdicionales.COUNT LOOP
        DECLARE
          v_param_obj JSON_OBJECT_T;
        BEGIN
          v_param_obj := JSON_OBJECT_T();
          v_param_obj.put('clave', NVL(p_obj.cabecera.parametrosAdicionales(v_idx_param).clave, ''));
          v_param_obj.put('valor', NVL(p_obj.cabecera.parametrosAdicionales(v_idx_param).valor, ''));
          v_param_adic_cab_array.append(v_param_obj);
        END;
      END LOOP;
    END IF;

    v_cabecera_obj := JSON_OBJECT_T();
    v_cabecera_obj.put('determinacionContable', v_det_cont_obj);
    v_cabecera_obj.put('datosGenerales', v_datos_gen_obj);
    v_cabecera_obj.put('parametrosAdicionales', v_param_adic_cab_array);

    -- POSICIONES
    v_posiciones_array := JSON_ARRAY_T();
    v_idx := p_obj.posiciones.FIRST;
    WHILE v_idx IS NOT NULL LOOP
      -- RESUMEN
      v_param_cont_obj := JSON_OBJECT_T();
      v_param_cont_obj.put('parametro01', NVL(p_obj.posiciones(v_idx).resumen.parametrosContables.parametro01, ''));
      v_param_cont_obj.put('parametro02', NVL(p_obj.posiciones(v_idx).resumen.parametrosContables.parametro02, ''));
      v_param_cont_obj.put('parametro03', NVL(p_obj.posiciones(v_idx).resumen.parametrosContables.parametro03, ''));
      v_param_cont_obj.put('parametro04', NVL(p_obj.posiciones(v_idx).resumen.parametrosContables.parametro04, ''));
      v_param_cont_obj.put('parametro05', NVL(p_obj.posiciones(v_idx).resumen.parametrosContables.parametro05, ''));
      v_param_cont_obj.put('parametro06', NVL(p_obj.posiciones(v_idx).resumen.parametrosContables.parametro06, ''));
      v_param_cont_obj.put('parametro07', NVL(p_obj.posiciones(v_idx).resumen.parametrosContables.parametro07, ''));
      v_param_cont_obj.put('parametro08', NVL(p_obj.posiciones(v_idx).resumen.parametrosContables.parametro08, ''));
      v_param_cont_obj.put('parametro09', NVL(p_obj.posiciones(v_idx).resumen.parametrosContables.parametro09, ''));
      v_param_cont_obj.put('parametro10', NVL(p_obj.posiciones(v_idx).resumen.parametrosContables.parametro10, ''));

      v_datos_gen_pos_obj := JSON_OBJECT_T();
      v_datos_gen_pos_obj.put('claseCuenta', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.claseCuenta, ''));
      v_datos_gen_pos_obj.put('sociedad', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.sociedad, ''));
      v_datos_gen_pos_obj.put('valor', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.valor, ''));
      v_datos_gen_pos_obj.put('indicadorImpuesto', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.indicadorImpuesto, ''));
      v_datos_gen_pos_obj.put('oficina', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.oficina, ''));
      v_datos_gen_pos_obj.put('centroCostos', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.centroCostos, ''));
      v_datos_gen_pos_obj.put('indicadorBloqueo', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.indicadorBloqueo, ''));
      v_datos_gen_pos_obj.put('viaPago', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.viaPago, ''));
      v_datos_gen_pos_obj.put('fechaInicio', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.fechaInicio, ''));
      v_datos_gen_pos_obj.put('claveReferencia1', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.claveReferencia1, ''));
      v_datos_gen_pos_obj.put('claveReferencia2', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.claveReferencia2, ''));
      v_datos_gen_pos_obj.put('claveReferencia3', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.claveReferencia3, ''));
      v_datos_gen_pos_obj.put('asignacion', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.asignacion, ''));
      v_datos_gen_pos_obj.put('texto', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.texto, ''));
      v_datos_gen_pos_obj.put('contrato', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.contrato, ''));
      v_datos_gen_pos_obj.put('lineaDeNegocio', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.lineaDeNegocio, ''));
      v_datos_gen_pos_obj.put('asesor', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.asesor, ''));
      v_datos_gen_pos_obj.put('zReferencia01', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.zReferencia01, ''));
      v_datos_gen_pos_obj.put('zReferencia02', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.zReferencia02, ''));
      v_datos_gen_pos_obj.put('zReferencia03', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.zReferencia03, ''));
      v_datos_gen_pos_obj.put('zReferencia04', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.zReferencia04, ''));
      v_datos_gen_pos_obj.put('zReferencia05', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.zReferencia05, ''));
      v_datos_gen_pos_obj.put('zReferencia06', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.zReferencia06, ''));
      v_datos_gen_pos_obj.put('zReferencia07', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.zReferencia07, ''));
      v_datos_gen_pos_obj.put('zReferencia08', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.zReferencia08, ''));
      v_datos_gen_pos_obj.put('zReferencia09', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.zReferencia09, ''));
      v_datos_gen_pos_obj.put('zReferencia10', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.zReferencia10, ''));
      v_datos_gen_pos_obj.put('zFecha01', NVL(p_obj.posiciones(v_idx).resumen.datosGenerales.zFecha01, ''));

      v_descuento_obj := JSON_OBJECT_T();
      v_descuento_obj.put('condicionPago', NVL(p_obj.posiciones(v_idx).resumen.descuento.condicionPago, ''));
      v_descuento_obj.put('base', NVL(p_obj.posiciones(v_idx).resumen.descuento.base, ''));
      v_descuento_obj.put('valor', NVL(p_obj.posiciones(v_idx).resumen.descuento.valor, ''));
      v_descuento_obj.put('dias01', NVL(p_obj.posiciones(v_idx).resumen.descuento.dias01, ''));
      v_descuento_obj.put('dias02', NVL(p_obj.posiciones(v_idx).resumen.descuento.dias02, ''));
      v_descuento_obj.put('dias03', NVL(p_obj.posiciones(v_idx).resumen.descuento.dias03, ''));
      v_descuento_obj.put('porcentaje01', NVL(p_obj.posiciones(v_idx).resumen.descuento.porcentaje01, ''));
      v_descuento_obj.put('porcentaje02', NVL(p_obj.posiciones(v_idx).resumen.descuento.porcentaje02, ''));

      v_retenciones_array := JSON_ARRAY_T();
      IF p_obj.posiciones(v_idx).resumen.retenciones.COUNT > 0 THEN
        FOR v_idx_ret IN 1..p_obj.posiciones(v_idx).resumen.retenciones.COUNT LOOP
          DECLARE
            v_ret_obj JSON_OBJECT_T;
          BEGIN
            v_ret_obj := JSON_OBJECT_T();
            v_ret_obj.put('TipoRetencion', NVL(p_obj.posiciones(v_idx).resumen.retenciones(v_idx_ret).TipoRetencion, ''));
            v_ret_obj.put('IndicadorRetencion', NVL(p_obj.posiciones(v_idx).resumen.retenciones(v_idx_ret).IndicadorRetencion, ''));
            v_ret_obj.put('valorBaseRetencion', NVL(p_obj.posiciones(v_idx).resumen.retenciones(v_idx_ret).valorBaseRetencion, ''));
            v_ret_obj.put('valorRetencion', NVL(p_obj.posiciones(v_idx).resumen.retenciones(v_idx_ret).valorRetencion, ''));
            v_retenciones_array.append(v_ret_obj);
          END;
        END LOOP;
      END IF;

      v_general_tercero_obj := JSON_OBJECT_T();
      v_general_tercero_obj.put('codigoTercero', NVL(p_obj.posiciones(v_idx).resumen.tercero.general.codigoTercero, ''));
      v_general_tercero_obj.put('tipoIdentificacion', NVL(p_obj.posiciones(v_idx).resumen.tercero.general.tipoIdentificacion, ''));
      v_general_tercero_obj.put('identificacion', NVL(p_obj.posiciones(v_idx).resumen.tercero.general.identificacion, ''));

      v_tercero_obj := JSON_OBJECT_T();
      v_tercero_obj.put('general', v_general_tercero_obj);
      -- Se pueden agregar pagadorAlternativo, datosBancarios, determinacionBancaria si se requiere

      v_param_adic_pos_array := JSON_ARRAY_T();
      IF p_obj.posiciones(v_idx).resumen.parametrosAdicionales.COUNT > 0 THEN
        FOR v_idx_param IN 1..p_obj.posiciones(v_idx).resumen.parametrosAdicionales.COUNT LOOP
          DECLARE
            v_param_obj JSON_OBJECT_T;
          BEGIN
            v_param_obj := JSON_OBJECT_T();
            v_param_obj.put('clave', NVL(p_obj.posiciones(v_idx).resumen.parametrosAdicionales(v_idx_param).clave, ''));
            v_param_obj.put('valor', NVL(p_obj.posiciones(v_idx).resumen.parametrosAdicionales(v_idx_param).valor, ''));
            v_param_adic_pos_array.append(v_param_obj);
          END;
        END LOOP;
      END IF;

      v_resumen_obj := JSON_OBJECT_T();
      v_resumen_obj.put('parametrosContables', v_param_cont_obj);
      v_resumen_obj.put('datosGenerales', v_datos_gen_pos_obj);
      v_resumen_obj.put('descuento', v_descuento_obj);
      v_resumen_obj.put('retenciones', v_retenciones_array);
      v_resumen_obj.put('tercero', v_tercero_obj);
      v_resumen_obj.put('parametrosAdicionales', v_param_adic_pos_array);

      -- Serializar detalles
      v_detalle_array := JSON_ARRAY_T();
      IF p_obj.posiciones(v_idx).detalle.COUNT > 0 THEN
        FOR v_idx_param IN 1..p_obj.posiciones(v_idx).detalle.COUNT LOOP
          DECLARE
            v_detalle_obj JSON_OBJECT_T;
            v_detalle_param_cont_obj JSON_OBJECT_T;
            v_detalle_datos_gen_obj JSON_OBJECT_T;
            v_detalle_param_adic_array JSON_ARRAY_T;
            v_detalle_item obj_cpi_causa_pos_detalle;
            v_idx_param_adic PLS_INTEGER;
          BEGIN
            v_detalle_item := p_obj.posiciones(v_idx).detalle(v_idx_param);
            -- Parametros contables
            v_detalle_param_cont_obj := JSON_OBJECT_T();
            v_detalle_param_cont_obj.put('parametro01', NVL(v_detalle_item.parametrosContables.parametro01, ''));
            v_detalle_param_cont_obj.put('parametro02', NVL(v_detalle_item.parametrosContables.parametro02, ''));
            v_detalle_param_cont_obj.put('parametro03', NVL(v_detalle_item.parametrosContables.parametro03, ''));
            v_detalle_param_cont_obj.put('parametro04', NVL(v_detalle_item.parametrosContables.parametro04, ''));
            v_detalle_param_cont_obj.put('parametro05', NVL(v_detalle_item.parametrosContables.parametro05, ''));
            v_detalle_param_cont_obj.put('parametro06', NVL(v_detalle_item.parametrosContables.parametro06, ''));
            v_detalle_param_cont_obj.put('parametro07', NVL(v_detalle_item.parametrosContables.parametro07, ''));
            v_detalle_param_cont_obj.put('parametro08', NVL(v_detalle_item.parametrosContables.parametro08, ''));
            v_detalle_param_cont_obj.put('parametro09', NVL(v_detalle_item.parametrosContables.parametro09, ''));
            v_detalle_param_cont_obj.put('parametro10', NVL(v_detalle_item.parametrosContables.parametro10, ''));
            -- Datos generales
            v_detalle_datos_gen_obj := JSON_OBJECT_T();
            v_detalle_datos_gen_obj.put('claseCuenta', NVL(v_detalle_item.datosGenerales.claseCuenta, ''));
            v_detalle_datos_gen_obj.put('sociedad', NVL(v_detalle_item.datosGenerales.sociedad, ''));
            v_detalle_datos_gen_obj.put('valor', NVL(v_detalle_item.datosGenerales.valor, ''));
            v_detalle_datos_gen_obj.put('indicadorImpuesto', NVL(v_detalle_item.datosGenerales.indicadorImpuesto, ''));
            v_detalle_datos_gen_obj.put('oficina', NVL(v_detalle_item.datosGenerales.oficina, ''));
            v_detalle_datos_gen_obj.put('centroCostos', NVL(v_detalle_item.datosGenerales.centroCostos, ''));
            v_detalle_datos_gen_obj.put('indicadorBloqueo', NVL(v_detalle_item.datosGenerales.indicadorBloqueo, ''));
            v_detalle_datos_gen_obj.put('viaPago', NVL(v_detalle_item.datosGenerales.viaPago, ''));
            v_detalle_datos_gen_obj.put('fechaInicio', NVL(v_detalle_item.datosGenerales.fechaInicio, ''));
            v_detalle_datos_gen_obj.put('claveReferencia1', NVL(v_detalle_item.datosGenerales.claveReferencia1, ''));
            v_detalle_datos_gen_obj.put('claveReferencia2', NVL(v_detalle_item.datosGenerales.claveReferencia2, ''));
            v_detalle_datos_gen_obj.put('claveReferencia3', NVL(v_detalle_item.datosGenerales.claveReferencia3, ''));
            v_detalle_datos_gen_obj.put('asignacion', NVL(v_detalle_item.datosGenerales.asignacion, ''));
            v_detalle_datos_gen_obj.put('texto', NVL(v_detalle_item.datosGenerales.texto, ''));
            v_detalle_datos_gen_obj.put('contrato', NVL(v_detalle_item.datosGenerales.contrato, ''));
            v_detalle_datos_gen_obj.put('lineaDeNegocio', NVL(v_detalle_item.datosGenerales.lineaDeNegocio, ''));
            v_detalle_datos_gen_obj.put('asesor', NVL(v_detalle_item.datosGenerales.asesor, ''));
            v_detalle_datos_gen_obj.put('zReferencia01', NVL(v_detalle_item.datosGenerales.zReferencia01, ''));
            v_detalle_datos_gen_obj.put('zReferencia02', NVL(v_detalle_item.datosGenerales.zReferencia02, ''));
            v_detalle_datos_gen_obj.put('zReferencia03', NVL(v_detalle_item.datosGenerales.zReferencia03, ''));
            v_detalle_datos_gen_obj.put('zReferencia04', NVL(v_detalle_item.datosGenerales.zReferencia04, ''));
            v_detalle_datos_gen_obj.put('zReferencia05', NVL(v_detalle_item.datosGenerales.zReferencia05, ''));
            v_detalle_datos_gen_obj.put('zReferencia06', NVL(v_detalle_item.datosGenerales.zReferencia06, ''));
            v_detalle_datos_gen_obj.put('zReferencia07', NVL(v_detalle_item.datosGenerales.zReferencia07, ''));
            v_detalle_datos_gen_obj.put('zReferencia08', NVL(v_detalle_item.datosGenerales.zReferencia08, ''));
            v_detalle_datos_gen_obj.put('zReferencia09', NVL(v_detalle_item.datosGenerales.zReferencia09, ''));
            v_detalle_datos_gen_obj.put('zReferencia10', NVL(v_detalle_item.datosGenerales.zReferencia10, ''));
            v_detalle_datos_gen_obj.put('zFecha01', NVL(v_detalle_item.datosGenerales.zFecha01, ''));
            -- Parametros adicionales
            v_detalle_param_adic_array := JSON_ARRAY_T();
            IF v_detalle_item.parametrosAdicionales.COUNT > 0 THEN
              FOR v_idx_param_adic IN 1..v_detalle_item.parametrosAdicionales.COUNT LOOP
                DECLARE
                  v_param_obj JSON_OBJECT_T;
                BEGIN
                  v_param_obj := JSON_OBJECT_T();
                  v_param_obj.put('clave', NVL(v_detalle_item.parametrosAdicionales(v_idx_param_adic).clave, ''));
                  v_param_obj.put('valor', NVL(v_detalle_item.parametrosAdicionales(v_idx_param_adic).valor, ''));
                  v_detalle_param_adic_array.append(v_param_obj);
                END;
              END LOOP;
            END IF;
            -- Armar objeto detalle
            v_detalle_obj := JSON_OBJECT_T();
            v_detalle_obj.put('parametrosContables', v_detalle_param_cont_obj);
            v_detalle_obj.put('datosGenerales', v_detalle_datos_gen_obj);
            v_detalle_obj.put('parametrosAdicionales', v_detalle_param_adic_array);
            v_detalle_array.append(v_detalle_obj);
          END;
        END LOOP;
      END IF;

      v_posicion_obj := JSON_OBJECT_T();
      v_posicion_obj.put('resumen', v_resumen_obj);
      v_posicion_obj.put('detalle', v_detalle_array);

      v_posiciones_array.append(v_posicion_obj);
      v_idx := p_obj.posiciones.NEXT(v_idx);
    END LOOP;

    v_json_obj := JSON_OBJECT_T();
    v_json_obj.put('headers', v_headers_obj);
    v_json_obj.put('control', v_control_obj);
    v_json_obj.put('cabecera', v_cabecera_obj);
    v_json_obj.put('posiciones', v_posiciones_array);

    RETURN v_json_obj;
  END CAUSACION_TO_JSON_OBJ;

  -- Serializacion a CLOB usando la funcion anterior
  FUNCTION CAUSACION_TO_JSON(p_obj IN OBJ_CPI_CAUSACION_CONTABLE) RETURN CLOB IS
    v_json_obj JSON_OBJECT_T;
  BEGIN
    v_json_obj := CAUSACION_TO_JSON_OBJ(p_obj);
    RETURN v_json_obj.to_clob();--CONVERT(v_json_obj.to_clob(), 'AL32UTF8');
  END CAUSACION_TO_JSON;

  PROCEDURE SP_EJECUTAR_SERVICIO_ASINCRONO(
    ityMensaje IN OUT NOCOPY OBJ_CPI_CAUSACION_CONTABLE,
    iTablaDestino IN VARCHAR2
  ) IS
    l_json_clob CLOB;
    v_response PCK_GNL_INTEGRATION_UTILS.t_message_response;
  BEGIN
    -- Serializar a JSON completo usando JSON_OBJECT_T/JSON_ARRAY_T
    l_json_clob := CAUSACION_TO_JSON(ityMensaje);
    DBMS_OUTPUT.PUT_LINE('  - Mensaje | JSON: ' || l_json_clob);
    
    -- Enviar el JSON usando el paquete utilitario
    v_response := PCK_GNL_INTEGRATION_UTILS.FN_GNL_CALL_ASYNC(l_json_clob, iTablaDestino);
    DBMS_OUTPUT.PUT_LINE('  - Mensaje: ' || v_response.message);
  EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error en la construccion del JSON: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('Detalle del error: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        RAISE;
  END SP_EJECUTAR_SERVICIO_ASINCRONO;

  PROCEDURE SP_EJECUTAR_SERVICIO_ASINCRONO(ityMensaje IN OUT NOCOPY CLOB, iTablaDestino IN VARCHAR2) IS
    v_response PCK_GNL_INTEGRATION_UTILS.t_message_response;
  BEGIN
    v_response := PCK_GNL_INTEGRATION_UTILS.FN_GNL_CALL_ASYNC(ityMensaje, iTablaDestino);
    DBMS_OUTPUT.PUT_LINE('  - Mensaje: ' || v_response.message);
  EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error en la construccion del JSON: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('Detalle del error: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        RAISE;
  END SP_EJECUTAR_SERVICIO_ASINCRONO;

  -- Firmas vacias para las otras operaciones
  PROCEDURE SP_EJECUTAR_SERV_ASINC_CBACK(ityMensaje IN OUT NOCOPY OBJ_SBK_MENSAJE) IS
  BEGIN
    NULL;
  END SP_EJECUTAR_SERV_ASINC_CBACK;

  FUNCTION FN_EJECUTAR_SERVICIO_SINCRONO(ityMensaje IN OUT NOCOPY OBJ_SBK_MENSAJE) RETURN TAB_SBK_ANYDATA IS
  BEGIN
    RETURN NULL;
  END FN_EJECUTAR_SERVICIO_SINCRONO;

  -- =============================================================
  -- Fachadas para PCK_SAP_APIGEE_CONSULTA
  -- =============================================================

  PROCEDURE CPI_GENERAR_JSON_HEADER_FENIX_APIGEE(
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
  BEGIN
    PCK_SAP_APIGEE_CONSULTA.SP_GENERAR_JSON_HEADER_FENIX_APIGEE(
      ivaTargetSystem,
      ivaTargetSystemProcess,
      ivaSourceApplicationName,
      ivaIntegrationMethod,
      ivaCorrelationId,
      ivaIsBatchOperation,
      ivaRefSrc1,
      ivaOauthUrl,
      ocaJsonHeader,
      ovaMensajeTecnico,
      ovaMensajeUsuario
    );
  END CPI_GENERAR_JSON_HEADER_FENIX_APIGEE;

  PROCEDURE CPI_GENERAR_JSON_BODY_FENIX_APIGEE(
    ivaSistemaOrigen          IN  VARCHAR2,
    ivaClaseCuenta            IN  VARCHAR2,
    ivaEstado                 IN  VARCHAR2,
    ivaSeleccion              IN  CLOB,
    ocaJsonBody               OUT CLOB,
    ovaMensajeTecnico         OUT VARCHAR2,
    ovaMensajeUsuario         OUT VARCHAR2
  ) IS
  BEGIN
    PCK_SAP_APIGEE_CONSULTA.SP_GENERAR_JSON_BODY_FENIX_APIGEE(
      ivaSistemaOrigen,
      ivaClaseCuenta,
      ivaEstado,
      ivaSeleccion,
      ocaJsonBody,
      ovaMensajeTecnico,
      ovaMensajeUsuario
    );
  END CPI_GENERAR_JSON_BODY_FENIX_APIGEE;

  PROCEDURE CPI_LLAMAR_GNL_CALL_SYNC_FENIX_APIGEE(
    ivaMetodo          IN VARCHAR2,
    ivaHeaders         IN CLOB,
    ivaToken           IN VARCHAR2,
    ivaBody            IN CLOB,
    ivaTimeout         IN NUMBER DEFAULT 30,
    ivaWalletPath      IN VARCHAR2 DEFAULT NULL,
    ocaRespuesta       OUT CLOB,
    ovaMensajeTecnico  OUT VARCHAR2,
    ovaMensajeUsuario  OUT VARCHAR2
  ) IS
  BEGIN
    PCK_SAP_APIGEE_CONSULTA.SP_LLAMAR_GNL_CALL_SYNC_FENIX_APIGEE(
      ivaMetodo,
      ivaHeaders,
      ivaToken,
      ivaBody,
      ivaTimeout,
      ivaWalletPath,
      ocaRespuesta,
      ovaMensajeTecnico,
      ovaMensajeUsuario
    );
  END CPI_LLAMAR_GNL_CALL_SYNC_FENIX_APIGEE;

END PCK_CPI_INTEGRATION;
/
