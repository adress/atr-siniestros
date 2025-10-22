-- ============================================================================
-- Ejemplo de construcción manual de un objeto OBJ_SAP_CXP_SINIESTROS
-- Basado en el archivo ejemplo_trama_broker.xml
-- Autor: Jaime Andres Ortiz - aXet (Laboratorio)
-- Fecha de actualización: 2025-09-15
-- Descripción: Script para crear y enviar un siniestro de laboratorio a la cola asíncrona.
-- ============================================================================

declare
   l_siniestro      obj_sap_cxp_siniestros;
   l_doc            obj_sap_documento_cxp_sini;
   l_ret1           obj_sap_dato_retencion;
   l_ret2           obj_sap_dato_retencion;
   l_ret3           obj_sap_dato_retencion;
   l_detalle        obj_sap_detalle_cxp_sini;
   l_condicion      obj_sap_condicion_pago_sini;
   l_cuenta         obj_sap_cuenta;
   l_tercero        obj_sap_tercero;
   l_cuenta_tercero obj_sap_cuenta;
   l_info_fiscal    obj_sap_info_fiscal;
   l_map            obj_sap_dtmap;
   l_mapitem        obj_sap_dtmapitem;
   l_cabecera       obj_sap_cabecera_cxp_sini;
   l_datos_conv     obj_sap_datos_conversion;
   l_obj_cxp        obj_sap_cxp_siniestros;
   l_obj_caus       OBJ_CPI_CAUSACION_CONTABLE;
begin
  -- CABECERA
   l_datos_conv := obj_sap_datos_conversion(
      'SIN', -- CDFUENTE
      79,    -- NMAPLICACION
      'SEG'  -- CDCANAL
   );
   l_cabecera := obj_sap_cabecera_cxp_sini(
      l_datos_conv,
      to_date('08/09/2025 00:00:00',
                          'DD/MM/YYYY HH24:MI:SS'), -- feFactura
      '02', -- cdCompania
      to_date('08/09/2025 00:00:00',
                          'DD/MM/YYYY HH24:MI:SS'), -- feRegistroSap
      9,    -- nmPeriodo
      '0',  -- cdMoneda
      null, -- ptTasaCambio
      null, -- feTasaCambio
      '122281849', -- nmOrdenPago
      'IRD25153'   -- nmFactura
   );
  -- DOCUMENTO PRINCIPAL
   l_condicion := obj_sap_condicion_pago_sini(
      '0025', -- cdCondicionPago
      10,     -- nmDias
      0.75,   -- poDescuento
      null    -- ptImporteDpp
   );
   l_cuenta := obj_sap_cuenta(
      '57',
      null,
      null,
      null,
      null
   );
   l_ret1 := obj_sap_dato_retencion(
      'SH',
      'R',
      411200,
      0
   );
   l_ret2 := obj_sap_dato_retencion(
      'SH',
      'I',
      0,
      0
   );
   l_ret3 := obj_sap_dato_retencion(
      'SH',
      '834',
      411200,
      0
   );
   l_detalle := obj_sap_detalle_cxp_sini(
      '090',
      '090000303616',
      '5776',
      '0900049419337',
      '31943346',
      411200,
      '2393',
      to_date('19/08/2025 00:00:00',
                         'DD/MM/YYYY HH24:MI:SS'),
      to_date('19/08/2025 00:00:00',
                         'DD/MM/YYYY HH24:MI:SS'),
      '0000',
      '2393',
      '02',
      'N',
      'T',
      '907',
      '1',
      null,
      '0900049419337-'
   );
   l_doc := obj_sap_documento_cxp_sini(
      '8903072005',
      'A',
      '2532',
      411200,
      'S',
      null,
      to_date('01/09/2025 00:00:00',
                           'DD/MM/YYYY HH24:MI:SS'),
      l_condicion,
      'CA',
      l_cuenta,
      'A',
      'AUTORIZACIONES SINIESTROS',
      '090000303616',
      '090',
      '907P',
      '1',
      'T',
      tab_sap_datos_retenciones(
         l_ret1,
         l_ret2,
         l_ret3
      ),
      tab_sap_detalles_cxp_sini(l_detalle)
   );
  -- TERCERO
   l_cuenta_tercero := obj_sap_cuenta(
      '57',
      null,
      null,
      null,
      null
   );
   l_info_fiscal := obj_sap_info_fiscal(
      '8903072005',
      'A'
   );
   l_tercero := obj_sap_tercero(
      null,
      'Clinica Imbanaco S.A.S',
      null,
      'Clinica Imbanaco S.A.S',
      'CR 38 BIS # 5 B2 04',
      null,
      '57',
      '76',
      '76001',
      'S',
      l_cuenta_tercero,
      l_info_fiscal
   );
  -- PARAMETROS ADICIONALES
   l_mapitem := obj_sap_dtmapitem(
      'VALORFACTURA',
      '411200'
   );
   l_map := obj_sap_dtmap(tab_sap_dtmapitem(l_mapitem));
  -- OBJETO SINIESTRO: usar constructor vacío y asignar atributos
   l_siniestro := obj_sap_cxp_siniestros();
   l_siniestro.cabecera := l_cabecera;
   l_siniestro.documentoscxp := tab_sap_documento_cxp_sini(l_doc);
   l_siniestro.tercero := l_tercero;
   l_siniestro.parametrosadicionales := l_map;
  -- Inicializar TYINF usando el constructor adecuado
   l_siniestro.tyinf := obj_sbk_mensaje_inf(
      'SINIESTROS',             -- CDCONSUMIDOR
      'SiniestrosCxP',          -- CDSERVICIO
      'SI_os_WS_SiniestrosCxP', -- CDOPERACION
      '122281849',              -- DSCLAVE
      sysdate,                  -- FECREACION
      '1',                      -- NMPRIORIDAD (varchar2)
      null,                     -- CDTOKEN
      '1.0',                    -- CDVERSION_SERVICIO
      null                      -- DSNAME_SPACE
   );
   l_siniestro.tyinf.dspuerto := 'HTTP_Port';

  -- Remplazo envio a la firma asíncrona de surabroker
  -- PCK_SBK_CORE.SP_EJECUTAR_SERVICIO_ASINCRONO(l_siniestro);

    --- Cast explícito y envio a la cola asincrona
   l_obj_cxp := treat(l_siniestro as OBJ_SAP_CXP_SINIESTROS);
   l_obj_caus := PCK_SIN_ADAPTADOR_CPI.MAP_SAP_CXP_TO_CAUSACION(l_obj_cxp); --convierte el objeto sap a causacion contable
   PCK_INTEGRATION_CPI.SP_EJECUTAR_SERVICIO_ASINCRONO(l_obj_caus, 'TATR_ASYNC_TX_1'); --convierte la causacion en JSON y guarda en la tabla

   --dbms_output.put_line('Siniestro enviado a la cola asíncrona.');
end;
/