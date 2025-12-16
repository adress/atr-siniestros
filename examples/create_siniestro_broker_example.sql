-- ============================================================================
-- Ejemplo de construcción manual de un objeto OBJ_SAP_CXP_SINIESTROS
-- Basado en el archivo ejemplo_trama_broker.xml
-- Autor: aXet (Generado automáticamente)
-- Fecha de actualización: 2025-10-15
-- Descripción: Script para crear y enviar un siniestro de laboratorio a la cola asíncrona,
--              usando los datos de ejemplo_trama_broker.xml.
-- ============================================================================

declare
   l_siniestro      OPS$PROCEDIM.OBJ_SAP_CXP_SINIESTROS;
   l_doc            OPS$PROCEDIM.obj_sap_documento_cxp_sini;
   l_ret1           OPS$PROCEDIM.obj_sap_dato_retencion;
   l_ret2           OPS$PROCEDIM.obj_sap_dato_retencion;
   l_ret3           OPS$PROCEDIM.obj_sap_dato_retencion;
   l_detalle        OPS$PROCEDIM.obj_sap_detalle_cxp_sini;
   l_condicion      OPS$PROCEDIM.obj_sap_condicion_pago_sini;
   l_cuenta         OPS$PROCEDIM.obj_sap_cuenta;
   l_tercero        OPS$PROCEDIM.obj_sap_tercero;
   l_cuenta_tercero OPS$PROCEDIM.obj_sap_cuenta;
   l_info_fiscal    OPS$PROCEDIM.obj_sap_info_fiscal;
   l_map            OPS$PROCEDIM.obj_sap_dtmap;
   l_mapitem        OPS$PROCEDIM.obj_sap_dtmapitem;
   l_cabecera       OPS$PROCEDIM.obj_sap_cabecera_cxp_sini;
   l_datos_conv     OPS$PROCEDIM.obj_sap_datos_conversion;
   l_obj_cxp        OPS$PROCEDIM.obj_sap_cxp_siniestros;
   l_obj_caus       OPS$PROCEDIM.OBJ_CPI_CAUSACION_CONTABLE;
begin
  -- CABECERA
   l_datos_conv := obj_sap_datos_conversion(
      'SIN', -- CDFUENTE
      79,    -- NMAPLICACION
      'BAN'  -- CDCANAL
   );
   l_cabecera := obj_sap_cabecera_cxp_sini(
      l_datos_conv,
      to_date('03/03/2025 14:45:44', 'DD/MM/YYYY HH24:MI:SS'), -- feFactura
      '02', -- cdCompania
      to_date('03/03/2025 14:45:44', 'DD/MM/YYYY HH24:MI:SS'), -- feRegistroSap
      3,    -- nmPeriodo
      '0',  -- cdMoneda
      null, -- ptTasaCambio
      null, -- feTasaCambio
      '6575268', -- nmOrdenPago
      null       -- nmFactura
   );
  -- DOCUMENTO PRINCIPAL
   l_condicion := obj_sap_condicion_pago_sini(
      '0001', -- cdCondicionPago
      null,   -- nmDias
      null,   -- poDescuento
      null    -- ptImporteDpp
   );
   l_cuenta := obj_sap_cuenta(
      '57',   -- cdPaisBanco
      '07',   -- cdBanco
      '24244396100', -- nmCuenta
      '01',  -- cdTipoCuenta
      null   -- dsTitular
   );
   l_ret1 := obj_sap_dato_retencion(
      '0028', -- cdtipoRetencion
      'R',    -- cdindicadorRetencion
      105437, -- ptBaseRetencion
      0       -- ptRetencion
   );
   l_ret2 := obj_sap_dato_retencion(
      '0028', -- cdtipoRetencion
      'I',    -- cdindicadorRetencion
      0,      -- ptBaseRetencion
      0       -- ptRetencion
   );
   l_ret3 := obj_sap_dato_retencion(
      '0028', -- cdtipoRetencion
      '5608', -- cdindicadorRetencion
      105437, -- ptBaseRetencion
      0       -- ptRetencion
   );
   l_detalle := obj_sap_detalle_cxp_sini(
      '081',           -- cdRamo
      'BAN108787784',  -- nmPoliza
      '4999',          -- cdIntermediario
      'BAN0089341835', -- nmExpediente
      '34545936',      -- nmAsegurado
      105437,          -- ptImporte
      '255',           -- cdCentroCostos
      to_date('28/02/2025 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), -- feAviso
      to_date('27/02/2025 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), -- feOcurrencia
      '0000',          -- cdIndicadorImpuesto
      '255',           -- cdOficinaRadicacion
      '02',            -- cdCompaniaParametro
      'N',             -- cdRamoParametro
      'M',             -- cdTipoReserva
      '907',           -- cdOperacion
      '2',             -- cdConcepto
      null,            -- cdConceptoAdicional
      'BAN0089341835-ATRSURA1' -- dsTextoPosicion
   );
   l_doc := obj_sap_documento_cxp_sini(
      '34545936',      -- nmBeneficiarioPago
      'C',             -- cdTipoIdentificacion
      '255',           -- cdOficinaRegistro
      105437,          -- ptImporte
      'S',             -- snCalcularImpuestos
      null,            -- cdIva
      to_date('03/03/2025 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), -- fePosiblePago
      l_condicion,     -- condicionPago
      'GE',            -- cdViaPago
      l_cuenta,        -- cuentaBancaria
      '6',             -- cdBloqueoPago
      'AUTORIZACIONES SINIESTROS', -- dsTextoPosicion
      'BAN108787784',  -- nmPoliza
      'BANVMR',        -- cdRamo
      '907',           -- cdOperacion
      '2',             -- cdConcepto
      'M',             -- cdTipoReserva
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
      '07',
      '24244396100',
      '01',
      null
   );
   l_info_fiscal := obj_sap_info_fiscal(
      '34545936',
      'C'
   );
   l_tercero := obj_sap_tercero(
      null,
      'Daly Ceneth Muñoz Campo',
      'Muñoz Campo',
      'Daly Ceneth',
      null,
      null,
      '57',
      '05',
      '05001',
      null,
      l_cuenta_tercero,
      l_info_fiscal
   );
  -- PARAMETROS ADICIONALES (vacío en este caso)
   l_map := obj_sap_dtmap(tab_sap_dtmapitem());
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
      '6575268',                -- DSCLAVE
      sysdate,                  -- FECREACION
      '4',                      -- NMPRIORIDAD (varchar2)
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
   PCK_CPI_INTEGRATION.SP_EJECUTAR_SERVICIO_ASINCRONO(l_obj_caus, 'TATR_ASYNC_TX_1'); --convierte la causacion en JSON y guarda en la tabla

   --dbms_output.put_line('Siniestro (ejemplo broker) enviado a la cola asíncrona.');
end;
/
