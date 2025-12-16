-- ============================================================================
-- Ejemplo de construccion manual de un objeto OBJ_SAP_CXP_SINIESTROS
-- Basado en el archivo atr_siniestro_multiple_pago_trama.xml
-- Autor: aXet (Generado automaticamente)
-- Fecha de actualizacion: 2025-12-16
-- Descripcion: Script para crear y enviar un siniestro de laboratorio a la cola
--              asincrona usando los datos de atr_siniestro_multiple_pago_trama.xml.
-- ============================================================================

declare
   l_siniestro      OPS$PROCEDIM.OBJ_SAP_CXP_SINIESTROS;
   l_doc            OPS$PROCEDIM.obj_sap_documento_cxp_sini;
   l_ret1           OPS$PROCEDIM.obj_sap_dato_retencion;
   l_detalle1       OPS$PROCEDIM.obj_sap_detalle_cxp_sini;
   l_detalle2       OPS$PROCEDIM.obj_sap_detalle_cxp_sini;
   l_detalle3       OPS$PROCEDIM.obj_sap_detalle_cxp_sini;
   l_condicion      OPS$PROCEDIM.obj_sap_condicion_pago_sini;
   l_cuenta         OPS$PROCEDIM.obj_sap_cuenta;
   l_tercero        OPS$PROCEDIM.obj_sap_tercero;
   l_cuenta_tercero OPS$PROCEDIM.obj_sap_cuenta;
   l_info_fiscal    OPS$PROCEDIM.obj_sap_info_fiscal;
   l_map            OPS$PROCEDIM.obj_sap_dtmap;
   l_cabecera       OPS$PROCEDIM.obj_sap_cabecera_cxp_sini;
   l_datos_conv     OPS$PROCEDIM.obj_sap_datos_conversion;
   l_obj_cxp        OPS$PROCEDIM.obj_sap_cxp_siniestros;
   l_obj_caus       OPS$PROCEDIM.OBJ_CPI_CAUSACION_CONTABLE;
begin
   -- Cabecera
   l_datos_conv := obj_sap_datos_conversion(
      'SIN',
      79,
      'SEG'
   );
   l_cabecera := obj_sap_cabecera_cxp_sini(
      l_datos_conv,
      to_date('16/12/2025 16:38:17', 'DD/MM/YYYY HH24:MI:SS'),
      '02',
      to_date('16/12/2025 16:38:17', 'DD/MM/YYYY HH24:MI:SS'),
      12,
      '0',
      null,
      null,
      '1014337',
      null
   );

   -- Condicion de pago y cuenta
   l_condicion := obj_sap_condicion_pago_sini(
      '0001',
      null,
      null,
      null
   );
   l_cuenta := obj_sap_cuenta(
      '57',
      null,
      null,
      null,
      null
   );

   -- Retenciones
   l_ret1 := obj_sap_dato_retencion(
      null,
      null,
      null,
      null
   );

   -- Detalles de siniestro
   l_detalle1 := obj_sap_detalle_cxp_sini(
      '084',
      '084000541679',
      '6886',
      '0840099501091',
      '1073230498',
      250000000,
      '4030',
      to_date('20/06/2025 00:00:00', 'DD/MM/YYYY HH24:MI:SS'),
      to_date('11/06/2025 00:00:00', 'DD/MM/YYYY HH24:MI:SS'),
      '0000',
      '4030',
      '02',
      'N',
      'T',
      '907',
      '1',
      null,
      '0840099501091-LINAJATE'
   );
   l_detalle2 := obj_sap_detalle_cxp_sini(
      '084',
      '084000541679',
      '6886',
      '0840099501091',
      '1073230498',
      250000000,
      '4030',
      to_date('20/06/2025 00:00:00', 'DD/MM/YYYY HH24:MI:SS'),
      to_date('11/06/2025 00:00:00', 'DD/MM/YYYY HH24:MI:SS'),
      '0000',
      '4030',
      '02',
      'N',
      'T',
      '907',
      '1',
      null,
      '0840099501091-LINAJATE'
   );
   l_detalle3 := obj_sap_detalle_cxp_sini(
      '084',
      '084000541679',
      '6886',
      '0840099501091',
      '1073230498',
      300000000,
      '4030',
      to_date('20/06/2025 00:00:00', 'DD/MM/YYYY HH24:MI:SS'),
      to_date('11/06/2025 00:00:00', 'DD/MM/YYYY HH24:MI:SS'),
      '0000',
      '4030',
      '02',
      'N',
      'T',
      '907',
      '1',
      null,
      '0840099501091-LINAJATE'
   );

   -- Documento principal
   l_doc := obj_sap_documento_cxp_sini(
      '1073230498',
      'C',
      '4030',
      800000000,
      'S',
      null,
      to_date('16/12/2025 00:00:00', 'DD/MM/YYYY HH24:MI:SS'),
      l_condicion,
      'CA',
      l_cuenta,
      '6',
      'AUTORIZACIONES SINIESTROS',
      '084000541679',
      '084',
      '907',
      '1',
      'T',
      tab_sap_datos_retenciones(l_ret1),
      tab_sap_detalles_cxp_sini(
         l_detalle1,
         l_detalle2,
         l_detalle3
      )
   );

   -- Tercero
   l_cuenta_tercero := obj_sap_cuenta(
      '57',
      null,
      null,
      null,
      null
   );
   l_info_fiscal := obj_sap_info_fiscal(
      '1073230498',
      'C'
   );
   l_tercero := obj_sap_tercero(
      null,
      'Carlos Cecilia Uribe Delgado',
      'Uribe Delgado',
      'Carlos Cecilia',
      'CR 63 # 69 63',
      null,
      '57',
      '05',
      '05001',
      null,
      l_cuenta_tercero,
      l_info_fiscal
   );

   -- Parametros adicionales (vacio en la trama)
   l_map := obj_sap_dtmap(
      tab_sap_dtmapitem()
   );

   -- Objeto siniestro
   l_siniestro := obj_sap_cxp_siniestros();
   l_siniestro.cabecera := l_cabecera;
   l_siniestro.documentoscxp := tab_sap_documento_cxp_sini(l_doc);
   l_siniestro.tercero := l_tercero;
   l_siniestro.parametrosadicionales := l_map;

   -- Informacion de envio
   l_siniestro.tyinf := obj_sbk_mensaje_inf(
      'SINIESTROS',
      'SiniestrosCxP',
      'SI_os_WS_SiniestrosCxP',
      '1014337',
      sysdate,
      '4',
      null,
      '1.0',
      null
   );
   l_siniestro.tyinf.dspuerto := 'HTTP_Port';

   -- Envio asincrono (mantener comentado o ajustarlo segun ambiente)
   l_obj_cxp := treat(l_siniestro as OBJ_SAP_CXP_SINIESTROS);
   l_obj_caus := PCK_SIN_ADAPTADOR_CPI.MAP_SAP_CXP_TO_CAUSACION(
      l_obj_cxp,
      'CLIENT_ID_ATR',
      'SECRET_ATR',
      'ATRSINIEST',
      'atr'
   );
   PCK_CPI_INTEGRATION_V2.SP_ENVIAR_DOCUMENTO_ASYNC(
      l_obj_caus,
      OBJ_CPI_JSON_CAUSACION_STRATEGY(1),
      'TATR_ASYNC_TX_1'
   );

   -- dbms_output.put_line('Siniestro (multiple pagos broker) enviado a la cola asincrona.');
end;
/
