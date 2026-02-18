
  CREATE OR REPLACE EDITIONABLE PACKAGE "OPS$PROCEDIM"."PCK_SIN_ADAPTADOR_SAP" IS

  gvaPackage             VARCHAR2(30):= 'PCK_SIN_ADAPTADOR_SAP';

 /**-----------------------------------------------------------------------------------------
  Procedure que Genera la Cuenta por Pagar a ser llevada del modelo de Siniestros a SAP
  #author Juan Guillermo Henao Montoya - Johan Miguel Ruiz
  Fecha Creaci?n: 2009/09/23
  Fecha Modificaci?n: 2009/10/06
  Motivo Modificaci?n:  Cambiaron la definici?n del RICEF y del WSDL
  Fecha Modificaci?n: 2010/04/29
  Motivo Modificaci?n:  Se cambian los amparos adicionales de vida de MVI a AAV email de Mi?rcoles 2010/4/28 02:53 p.m.

  #param ivaNmExpediente       N?mero del siniestro sobre el cual se genera la CxP
  #param ivaNmPagoAutorizacion N?mero de la Orden de Pago asociada al siniestro sobre el cual se genera la CxP
  #param ovaMensajeTecnico     Mensaje tecnico en caso de error
  #param ovaMensajeUsuario     Mensaje para el usuario en caso de error
  */

  FUNCTION FN_CREAR_MENSAJE_CXP (ivaNmExpediente        IN SIN_PAGOS_DET.EXPEDIENTE%TYPE,
                                 ivaNmPagoAutorizacion  IN SIN_PAGOS_DET.NUMERO_PAGO_AUTORIZACION%TYPE,
                                 ovaMensajeTecnico      OUT VARCHAR2,
                                 ovaMensajeUsuario      OUT VARCHAR2  ) RETURN OBJ_SAP_CXP_SINIESTROS;

  -- 22/11/2024 josebuvi Desarrollo para verificacion de retencion ramos de vida                              
  FUNCTION FN_CREAR_MENSAJE_CXP_083 (ivaNmExpediente        IN SIN_PAGOS_DET.EXPEDIENTE%TYPE,
                                     ivaNmPagoAutorizacion  IN SIN_PAGOS_DET.NUMERO_PAGO_AUTORIZACION%TYPE,
                                     ovaMensajeTecnico      OUT VARCHAR2,
                                     ovaMensajeUsuario      OUT VARCHAR2  ) RETURN OBJ_SAP_CXP_SINIESTROS;

  FUNCTION FN_CREAR_MENSAJE_CONSULTA_CXP (ivaClave1         IN VARCHAR2,
                                          ivaClave2         IN VARCHAR2,
                                          ivaConsumidor     IN VARCHAR2,
                                          ovaMensajeTecnico OUT VARCHAR2,
                                          ovaMensajeUsuario OUT VARCHAR2) RETURN OBJ_SAP_CONSULTA_EST_CXP;

  FUNCTION FN_CREAR_MENSAJE_ANULAR_CXP (ivaNmExpediente        IN VARCHAR2,
                                        ivaNmPagoAutorizacion  IN SIN_PAGOS_DET.NUMERO_PAGO_AUTORIZACION%TYPE,
                                        ovaMensajeTecnico      OUT VARCHAR2,
                                        ovaMensajeUsuario      OUT VARCHAR2  ) RETURN OBJ_SAP_ANULACION_CXP;


  FUNCTION FN_CREAR_MENSAJE_CXP_v6_0 (ivaNmExpediente        IN SIN_PAGOS_DET.EXPEDIENTE%TYPE,
                                      ivaNmPagoAutorizacion  IN SIN_PAGOS_DET.NUMERO_PAGO_AUTORIZACION%TYPE,
                                      ovaMensajeTecnico      OUT VARCHAR2,
                                      ovaMensajeUsuario      OUT VARCHAR2  ) RETURN OBJ_SAP_CXP_SINIESTROS;
-----------------------------------------------------------------------------------------------------------
-- SALVAMENTOS
-- SALVAMENTOS
-- SALVAMENTOS
-----------------------------------------------------------------------------------------------------------

 /**-----------------------------------------------------------------------------------------
  Function que Genera la Cuenta por Cobrar de SALVAMENTOS a ser llevada del modelo de Siniestros a SAP
  #author Juan Guillermo Henao Montoya
  Fecha Creaci?n: 2009/12/01
  Fecha Modificaci?n:
  Motivo Modificaci?n:

  #param ivaNmExpediente       N?mero del siniestro sobre el cual se genera la CxP
  #param ivaNmPagoAutorizacion N?mero de la Orden de Pago asociada al siniestro sobre el cual se genera la CxP
  #param ovaMensajeTecnico     Mensaje tecnico en caso de error
  #param ovaMensajeUsuario     Mensaje para el usuario en caso de error
  */

  FUNCTION FN_CREAR_MENSAJE_CXC (ivaNmExpediente        IN SIN_PAGOS_DET.EXPEDIENTE%TYPE,
                                 ivaNmPagoAutorizacion  IN SIN_PAGOS_DET.NUMERO_PAGO_AUTORIZACION%TYPE,
                                 ovaMensajeTecnico      OUT VARCHAR2,
                                 ovaMensajeUsuario      OUT VARCHAR2,
                                 ivaNmPagoVelru         IN NUMBER DEFAULT 0) 
                                 RETURN OBJ_SAP_CXC_SALVAMENTOS;


 /**-----------------------------------------------------------------------------------------
  Function que Genera la Anulaci?n de CxC SALVAMENTOS a ser llevada del modelo de Siniestros a SAP
  #author Juan Guillermo Henao Montoya
  Fecha Creaci?n: 2009/12/14
  Fecha Modificaci?n:
  Motivo Modificaci?n:

  #param ivaNmExpediente       N?mero del siniestro sobre el cual se genera la CxP
  #param ivaNmPagoAutorizacion N?mero de la Orden de Pago asociada al siniestro sobre el cual se genera la CxP
  #param ovaMensajeTecnico     Mensaje tecnico en caso de error
  #param ovaMensajeUsuario     Mensaje para el usuario en caso de error
  */

  FUNCTION FN_CREAR_MENSAJE_ANULAR_CXC (ivaNmExpediente        IN VARCHAR2,
                                        ivaNmPagoAutorizacion  IN SIN_PAGOS_DET.NUMERO_PAGO_AUTORIZACION%TYPE,
                                        ovaMensajeTecnico      OUT VARCHAR2,
                                        ovaMensajeUsuario      OUT VARCHAR2  ) RETURN OBJ_SAP_ANULACION_CXC_SEG;


 /**-----------------------------------------------------------------------------------------
  Procedure que entrega el usuario y password de SuraBroker
  #author Juan Guillermo Henao Montoya
  Fecha Creaci?n: 2009/12/14
  Fecha Modificaci?n:
  Motivo Modificaci?n:

  #param ivaNmAplicacion       C?digo de la aplicaci?n seg?n SAP para siniestros es la 79
  #param ovaDsUsuario          C?digo del usuario de SuraBroker
  #param ovaDsClave            Password del usuario de SuraBroker
  #param ovaMensajeTecnico     Mensaje tecnico en caso de error
  #param ovaMensajeUsuario     Mensaje para el usuario en caso de error
  */

  PROCEDURE SP_USUARIO (ovaDsUsuario       OUT T999_PARAMETROS.DSVALOR_PARAMETRO%TYPE,
                       ovaDsClave         OUT T999_PARAMETROS.DSVALOR_PARAMETRO%TYPE,
                       ovaMensajeTecnico  OUT VARCHAR2,
                       ovaMensajeUsuario  OUT VARCHAR2  );


 /**-----------------------------------------------------------------------------------------
  Funcion que retorna si una p?liza o un riesgo de una p?liza est? contratado en el exterior.
  Si se env?a solo la p?liza, retorna que SI tiene riesgo en el exterior si alguno de los riesgos est? en el exterior.
  Si se env?a la p?liza y el riesgo trae si este riesgo est? ubicado en el exterior
  #author Juan Guillermo Henao Montoya
  Fecha Creaci?n: 2013/08/16
  Fecha Modificaci?n:
  Motivo Modificaci?n:

  #param ivaNmPoliza             N?mero de la p?liza a consultar
  #param ivaNmCertificado        N?mero del riesgo de la p?liza a consultar
  #param ovaMensajeTecnico       Mensaje tecnico en caso de error
  #param ovaMensajeUsuario       Mensaje para el usuario en caso de error
  */
  FUNCTION FN_RIESGO_EXTERIOR (ivaNmPoliza         IN VARCHAR2,
                               ivaNmCertificado    IN VARCHAR2,
                               ovaMensajeTecnico  OUT VARCHAR2,
                               ovaMensajeUsuario  OUT VARCHAR2) 
                               RETURN VARCHAR2;

 /**-----------------------------------------------------------------------------------------
  Procedimiento que es llamado desde Caja SAP para generar en el modelo el deducible y luego
  El procedimiento genera la contabilizaci?n.
  #author Juan Guillermo Henao Montoya
  Fecha Creaci?n: 2013/10/26
  Fecha Modificaci?n:
  Motivo Modificaci?n:

  #param ivaTipoMovimiento       Tipo de movimiento de acuerdo a la operaci?n a ejecutar D es deducible
  #param ivaExpediente           N?mero del siniestro a crearle el movimiento
  #param ivaDniBeneficiario      DNI completo Tipo y n?mero de la persona a la que se le va a crear el movimiento
  #param inuValorMovimiento      Valor del movimiento a generar
  #param onuNmPagoAutorizacion   N?mero de orden de pago o reintegro generada
  #param ovaMensajeTecnico       Mensaje tecnico en caso de error
  #param ovaMensajeUsuario       Mensaje para el usuario en caso de error
  */
  PROCEDURE SP_DEDUCIBLE_CAJA_SAP(ivaTipoMovimiento      IN VARCHAR2,
                                  ivaExpediente          IN SIN_PAGOS_DET.EXPEDIENTE%TYPE,
                                  inuValorMovimiento     IN SIN_PAGOS_DET.IMPORTE%TYPE,
                                  onuNmPagoAutorizacion OUT SIN_PAGOS_DET.NUMERO_PAGO_AUTORIZACION%TYPE,
                                  ovaMensajeTecnico     OUT VARCHAR2,
                                  ovaMensajeUsuario     OUT VARCHAR2,
                                  ivaDniSubrogacion      IN VARCHAR2 DEFAULT NULL);


  PROCEDURE SP_VALIDA_DEDUC_SUBROGA(ivaTipoMovimiento      IN VARCHAR2,
                                    ivaExpediente          IN SIN_PAGOS_DET.EXPEDIENTE%TYPE,
                                    ivaNmPoliza            IN SIN_PAGOS_DET.NPOLIZA%TYPE,
                                    ivaDniSubrogacion      IN VARCHAR2 DEFAULT NULL,
                                    ovaMensajeTecnico     OUT VARCHAR2,
                                    ovaMensajeUsuario     OUT VARCHAR2,
                                    ovaNnPoliza           OUT VARCHAR2);                                  
 /**-----------------------------------------------------------------------------------------
  Funcion que calcula las retenciones desde SAP
  #author Juan Guillermo Henao Montoya
  Fecha Creaci?n: 2013/04/18
  Fecha Modificaci?n:
  Motivo Modificaci?n:

  #param ivaCdSociedad           C?digo de la compa??a sobre la cual se calcula el impuesto
  #param ivaDniBenePago          Documento Nacional de Identificaci?n del beneficiario de pago
  #param inuPtImporte            Valor bruto de la orden de pago
  #param inuPtDeducible          Valor del deducible a descontarle al asegurado
  #param ivaCdMoneda             C?digo de la moneda sobre la cual se hace el pago
  #param inuPoIVA                porcentaje de IVA calculado
  #param ivaCdCodigoRetencion    C?digo de la retenci?n a aplicar.  #param ivaCdIndicadorRetencion Tipo de retencion a Calcular R Retefiemte, I ReteIVA, 
  #param ovaMensajeTecnico       Mensaje tecnico en caso de error
  #param ovaMensajeUsuario       Mensaje para el usuario en caso de error
  */
/*  FUNCTION FN_CREAR_MENSAJE_RETENCIONES (ivaCdSociedad           IN VARCHAR2,
                                         ivaDniBenePago          IN VARCHAR2,
                                         inuPtImporte            IN NUMBER,
                                         inuPtDeducible          IN NUMBER,
                                         ivaCdMoneda             IN VARCHAR2,
                                         inuPoIVA                IN VARCHAR2,
                                         iarrRetenciones         IN TAB_SAP_RETENCIONES_SINI,
--                                         ivaCdCodigoRetencion    IN VARCHAR2,
--                                         ivaCdIndicadorRetencion IN VARCHAR2,
                                         ovaMensajeTecnico      OUT VARCHAR2,
                                         ovaMensajeUsuario      OUT VARCHAR2  ) 
                                         RETURN OBJ_SAP_SIMULA_RETENC_SINI_REQ;*/

END PCK_SIN_ADAPTADOR_SAP;
/
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "OPS$PROCEDIM"."PCK_SIN_ADAPTADOR_SAP" IS


-------------------------------------------------------------------------------------------------------------------------------------------------------
  FUNCTION FN_CREAR_MENSAJE_CXP(ivaNmExpediente        IN SIN_PAGOS_DET.EXPEDIENTE%TYPE,
                                ivaNmPagoAutorizacion  IN SIN_PAGOS_DET.NUMERO_PAGO_AUTORIZACION%TYPE,
                                ovaMensajeTecnico      OUT VARCHAR2,
                                ovaMensajeUsuario      OUT VARCHAR2) RETURN OBJ_SAP_CXP_SINIESTROS IS

  --Variables para el manejo de Errores
  lvaMensajeTecnico           VARCHAR2(1000)  := NULL;
  lvaMensajeTecnicoExt        VARCHAR2(1000)  := NULL;
  lvaMensajeUsuario           VARCHAR2(1000)  := NULL;
  lvaMensajeUsuarioExt        VARCHAR2(1000)  := NULL;
  lexErrorProcedimiento       EXCEPTION;
  lexErrorProcedimientoExt    EXCEPTION;
  lvaNombreObjeto             VARCHAR2(30)   :='FN_CREAR_MENSAJE_CXP';


  --Objeto para retornar con mensaje SAP
  lobjPago                          OBJ_SAP_CXP_SINIESTROS      := OBJ_SAP_CXP_SINIESTROS();
  lobjTyinf                         OBJ_SBK_MENSAJE_INF         := OBJ_SBK_MENSAJE_INF(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
  ltyEncabezadoMens                 TAB_SBK_ENC_MENSAJE         := TAB_SBK_ENC_MENSAJE(OBJ_SBK_ENC_MENSAJE(NULL, NULL));
  lobjCabecera                      OBJ_SAP_CABECERA_CXP_SINI   := OBJ_SAP_CABECERA_CXP_SINI();
  lobjDocumento                     OBJ_SAP_DOCUMENTO_CXP_SINI  := OBJ_SAP_DOCUMENTO_CXP_SINI();
  lobjDocumentos                    TAB_SAP_DOCUMENTO_CXP_SINI  := TAB_SAP_DOCUMENTO_CXP_SINI(OBJ_SAP_DOCUMENTO_CXP_SINI());
  lobjDetalle                       OBJ_SAP_DETALLE_CXP_SINI    := OBJ_SAP_DETALLE_CXP_SINI();
  lobjTabDetalles                   TAB_SAP_DETALLES_CXP_SINI   := TAB_SAP_DETALLES_CXP_SINI(OBJ_SAP_DETALLE_CXP_SINI());
  lobjRetencion                     OBJ_SAP_DATO_RETENCION      := OBJ_SAP_DATO_RETENCION();
  lobjRetenciones                   TAB_SAP_DATOS_RETENCIONES   := TAB_SAP_DATOS_RETENCIONES(OBJ_SAP_DATO_RETENCION());
  lobjDatosConversion               OBJ_SAP_DATOS_CONVERSION    := OBJ_SAP_DATOS_CONVERSION();
  lobjCuentaBancaria                OBJ_SAP_CUENTA              := OBJ_SAP_CUENTA();
  lobjtercero                       OBJ_SAP_TERCERO             := OBJ_SAP_TERCERO();
  lobjCondicionPago                 OBJ_SAP_CONDICION_PAGO_SINI := OBJ_SAP_CONDICION_PAGO_SINI();
  lobjInfoFiscal                    OBJ_SAP_INFO_FISCAL         := OBJ_SAP_INFO_FISCAL();
  ltyTercero                        PCK_SIC_SAP.regTercero;

  ltabMapItems                      TAB_SAP_DTMAPITEM           := TAB_SAP_DTMAPITEM(OBJ_SAP_DTMAPITEM());
  lobjMap                           OBJ_SAP_DTMAP               := OBJ_SAP_DTMAP();
  lobjItemMap                       OBJ_SAP_DTMAPITEM           := OBJ_SAP_DTMAPITEM();
/*  ltabMapItems                      TAB_SAP_MAPITEM           := TAB_SAP_MAPITEM(OBJ_SAP_MAPITEM());
  lobjMap                           OBJ_SAP_MAP               := OBJ_SAP_MAP();
  lobjItemMap                       OBJ_SAP_MAPITEM           := OBJ_SAP_MAPITEM();*/
  lvaDsUsuario                      T999_PARAMETROS.DSVALOR_PARAMETRO%TYPE;
  lvaDsClave                        T999_PARAMETROS.DSVALOR_PARAMETRO%TYPE;

  --Variables para llenar los Objetos
  lnuContadorDetalle                NUMBER                    := 0;
  lnuContadorRetencion              NUMBER                    := 0;
  lnuContadorDocumentos             NUMBER                    := 0;
  lnuContadorRetencionVida          NUMBER 					  := 0;

  --Variables propias del aplicativo
  lvaCdCompania                    DIC_ALIAS_RS.CDCIA%TYPE;
  lvaCdRamo                        SIN_PAGOS_DET.CDRAMO%TYPE;
  lvaCdSubRamo                     SIN_PAGOS_DET.CDSUBRAMO%TYPE;
  lvaCdGarantia                    SIN_PAGOS_DET.CDGARANTIA%TYPE;
  lvaCdSubGarantia                 SIN_PAGOS_DET.CDSUBGARANTIA%TYPE;
  lnuPoDescuento                   SIN_PAGOS_DET.PODESCUENTO%TYPE;

  lvaCdciaMatriz                   DIC_ALIAS_RS.CDCIA_MATRIZ%TYPE;
  -- juancagr 20160903 variables para el manejo de las facturas
  lnuVlrFactura                    SIN_FACTURAS.PTVALOR_FACTURA%TYPE;
  lvaNmFactura                     SIN_FACTURAS.NMFACTURA%TYPE;
  lvaNmPrefijo                     SIN_FACTURAS.NMPREFIJO%TYPE;
  lvaSnCalcularImpuestos           VARCHAR2(1)                := 'S';
  lvaNmExpediente                  SIN_PAGOS_DET.EXPEDIENTE%TYPE;
  lvaNmPoliza                      SIN_PAGOS_DET.NPOLIZA%TYPE;
  lvaNmCertificado                 SIN_PAGOS_DET.NCERTIFICADO%TYPE;
  lvaDniAsegurado                  PERSONAS.DNI%TYPE;
  lvaNmAsegurado                   PERSONAS.DNI%TYPE;
  lvaNmBeneficiarioPago            SIN_PAGOS_DET.DNI%TYPE;
  ldaFeOcurrencia                  SINIESTROS.FECHA_SINIESTRO%TYPE;
  ldaFenotificacion                SINIESTROS.FECHA_NOTIFICACION%TYPE;
  lvaFeposiblePago                 PAGOS.FEPOSIBLE_PAGO%TYPE;
  lvaCdViaPago                     PAGOS.CDVIAPAGO%TYPE;
  lvaCdbloqueoPago                 PAGOS.CDBLOQUEOPAGO%TYPE;
  lvaCdPaisBanco                   PAGOS.CDPAISBANCO%TYPE;
  lvaCdBanco                       PAGOS.CDBANCO%TYPE;
  lvaNmCuenta                      PAGOS.NMCUENTA%TYPE;
  cdTipoCuenta                     PAGOS.CDTIPOCUENTA%TYPE;
  lvaCdSucursalBanco               PAGOS.CDSUCURSALBANCO%TYPE;
  lvaDsTitular                     PAGOS.DSTITULAR%TYPE;
  lvaCdTipoReserva                 DIC_ALIAS_COBERTURAS.CDTIPO_RESERVA%TYPE;
  lvaCdramoContable                DIC_ALIAS_COBERTURAS.CDRAMO_CONTABLE%TYPE;
  lvaCdRetencion                   SIN_PAGOS_DET.CDRETENCION%TYPE;
  lnuImpIrc                        SIN_PAGOS_DET.IMPIRC%TYPE;
  lnuImpIrpfRetenido               SIN_PAGOS_DET.IMPIRPF_RETENIDO%TYPE;
  lnuImpIca                        SIN_PAGOS_DET.IMPICA%TYPE;
  lvaCdAgente                      CUERPOLIZA.CDAGENTE%TYPE;
  lvaCdDelegacionRadica            CUERPOLIZA.CDDELEGACION_RADICA%TYPE;
  lvaMunicipioIca                  SIN_RETENCION_ICA.CDMUNICIPIO%TYPE;

  lvaDsTextoPosicion               VARCHAR2(50);
  lvaCdOperacion                   PAGOS.CDOPERACION%TYPE;
  lvaCdOficinaRegistro             SIN_PAGOS_DET.CDENTIDAD%TYPE;
  lnuIvaDescontable                SIN_PAGOS_DET.IMPIRPF%TYPE;
  lnuDeducible                     SIN_PAGOS_DET.DEDUCIBLE%TYPE;
  lnuPtDescuento                   SIN_PAGOS_DET.PTDESCUENTO%TYPE;
  lvaCodIva                        SIN_RETENCIONES.CDRETENCION%TYPE;
  lvaCdConcepto                    VARCHAR2(10);
  lvaSnBancaseguros                DIC_ALIAS_RS.SNBANCASEGUROS%TYPE;
  lvaDni                           PERSONAS.DNI%TYPE;
  lvaCdUsuario                     HISTORICO.CODIGO_USUARIO%TYPE;
  lvaDsLoginUsuario                USUARIOS_1.DSLOGIN%TYPE;
  lvaCdCiaCoaseguradora            COA_TRATADO_DETALLE.CDCIA%TYPE;
  lvaIdSoloSura                    VARCHAR2(2) := '00';
  lnuPorepartoCoa                  COA_TRATADO_DETALLE.POREPARTO_COA%TYPE;
  lvaTipoCoaseguro                 COA_TRATADO.CDCOA%TYPE;

  lvaNumeroReserva                 SIN_PAGOS_DET.NUMERO_RESERVA%TYPE;
  lvaPoIrpf                        SIN_PAGOS_DET.POIRPF%TYPE;
  lvaPoirc                         SIN_PAGOS_DET.POIRC%TYPE;
  lvaPoIca                         SIN_PAGOS_DET.POICA%TYPE;
  ldaFePago                        SIN_PAGOS_DET.FEPAGO%TYPE;
  lnuPoBaseRetencion               SIN_RETENCIONES.PORETENCION%TYPE;
  lnuPoRetencion                   SIN_RETENCIONES.PORETENCION%TYPE;
  lnuReteIvaSimplificado           SIN_PAGOS_DET.IMPIRPF_RETENIDO%TYPE;
  lvaSnIva                         SIN_PAGOS_DET.SNIVA%TYPE;
  --20140728 Por historia de usuario 77550 solicitada por Mario Franco, ya no se lleva obligado por Caja la pretenci?n objetivada.
  --lvaSNPagoJuridico                VARCHAR2(1);

  --Panam?
  ldaFeFecto                       CUERPOLIZA.FEFECTO%TYPE;
  ldaFeFectoAnualidad              CUERPOLIZA.FEFECTO_ANUALIDAD%TYPE;
  lvaSnPrimerVigencia              VARCHAR2(1);
  lvaCdGrupoCobertura              DIC_ALIAS_COBERTURAS.CDGRUPO_COBERTURA%TYPE;
  lvaGrupoProducto                 DIC_ALIAS_RS.CDGRUPO_PRODUCTO%TYPE;
  lvaSnProveedorPanama             VARCHAR2(1);
  lvaSnRiesgoExterior              VARCHAR2(1)     := 'N';
  lvaDigitoVerificacion            PERSONAS.NMDIGITO_VER%TYPE;
  lvaDniCoaseguro                  PERSONAS.DNI%TYPE;
  lvaCodigoAceptacion              PAGOS.CODIGO_ACEPTACION%TYPE;
  lvaSnPagoCajaSura                VARCHAR2(1)     := 'N';
--  lnuTotalDeducible                SIN_PAGOS_DET.DEDUCIBLE%TYPE;
--  lnuTotalPtDescuento              SIN_PAGOS_DET.PTDESCUENTO%TYPE;

  -- Total de cuadre para Saldo en Moneda de transaccion.
  lnuTotalPago                     SIN_PAGOS_DET.IMPORTE%TYPE := 0;

  --fernavi - Identificar si el producto se contabiliza a una cuenta de personas en compa?ia 1000
  -- historia Cambios contabilizaci?n Productos Affinity- CXP
  lvaSnCuentaContable              DIC_ALIAS_RS.SNCUENTA_CONTABLE%TYPE;

  --Variable para identificar si de poliza de salud (ramos '090','091','085','183')
  lvaSnPolizaSalud                VARCHAR2(1)     := 'N';

  --linaduto - 2025/03/11 - HU756348 -Ajuste retenci?n en la fuente para ID NIT - subramos PCP y deudores
  lvaAplicaSinRetencion VARCHAR2(1) := 'N';
  
  -- luishure - 2025/12/10 - HU984785 - Exclusión de retención para Fondo de Ahorro
  lvaAplicaReservaSinRetencion VARCHAR2(1) := 'N';

  --Cursores para consultar la informacion

  -- Cursor base para el llenado de la Cabecera con el total de la CxP
  CURSOR lcuDatosCabecera IS
   SELECT s.CDRAMO, s.CDSUBRAMO,s.NPOLIZA, S.NCERTIFICADO, s.CDENTIDAD, s.DNI, NVL(s.CDMONEDA,0) CDMONEDA, s.FEPAGO,
          DECODE(S.CARGO_ABONO,'A','907','C','916','907') CDOPERACION,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(NVL(s.IMPIRPF,0))),2),
                 ROUND(ABS(SUM(NVL(s.IMPIRPF,0)))) ) impirpf,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(NVL(DEDUCIBLE,0))),2),
                 ROUND(ABS(SUM(NVL(DEDUCIBLE,0)))) ) deducible,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(NVL(s.PTDESCUENTO,0))),2),
                 ROUND(ABS(SUM(NVL(s.PTDESCUENTO,0)))) ) ptdescuento,
          MAX(s.PODESCUENTO) PODESCUENTO,
          MAX(s.numero_reserva) NUMERO_RESERVA
   FROM SIN_PAGOS_DET s
   WHERE s.EXPEDIENTE             = ivaNmExpediente
   AND s.NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   and s.numero_reserva <> 'P012100' --se eliminan las deducciones de primas
   GROUP BY s.CDRAMO, s.CDSUBRAMO, s.NPOLIZA, S.NCERTIFICADO,s.CDENTIDAD, s.DNI, NVL(s.CDMONEDA,0), s.FEPAGO,
            LPAD(REPLACE(TO_CHAR(RPAD(NVL(POIRPF,0),4,'0')),',',''),4,'0'),
            DECODE(S.CARGO_ABONO,'A','907','C','916','907'),
            EXPEDIENTE;

  -- Cursor base para el llenado con los datos del DOCUMENTO por cada tipo de reserva de Fondo de ahorro y Valores de Cesion
  CURSOR lcuDatosDocumentoFyC IS
   SELECT dac.CDTIPO_RESERVA,NUMERO_RESERVA, NVL(POIRPF,0) POIRPF, S.CDRETENCION,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(s.IMPORTE - NVL(s.PTDESCUENTO,0))),2),
                 ROUND(ABS(SUM(s.IMPORTE - NVL(s.PTDESCUENTO,0)))) ) IMPORTE,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(NVL(S.IMPIRC,0))),2),
                 ROUND(ABS(SUM(NVL(S.IMPIRC,0)))) ) IMPIRC,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(NVL(IMPIRPF_RETENIDO,0))),2),
                 ROUND(ABS(SUM(NVL(IMPIRPF_RETENIDO,0)))) ) IMPIRPF_RETENIDO,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(NVL(IMPICA,0))),2),
                 ROUND(ABS(SUM(NVL(IMPICA,0)))) ) IMPICA,
          NVL(POIRC,0) POIRC, NVL(POIRPF_RETENIDO,0) POIRPF_RETENIDO, NVL(POICA,0) POICA,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(((IMPORTE*100)/(100+NVL(POIRPF,0))))),2),
                 ROUND(ABS(SUM(((IMPORTE*100)/(100+NVL(POIRPF,0)))))) ) BASEIMPUESTOS,
          --Con el cambio de retenciones desde SAP en la devuelta, Se incluye este campo en la consulta, para tener la base del IVA
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(NVL(s.IMPIRPF,0))),2),
                 ROUND(ABS(SUM(NVL(s.IMPIRPF,0)))) ) IMPIRPF,
          s.CDTRIBUTARIA/*, s.SNIVA*/
   FROM SIN_PAGOS_DET s, DIC_ALIAS_COBERTURAS dac
   WHERE EXPEDIENTE               = ivaNmExpediente
   AND   NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND   s.CDRAMO                 = dac.CDRAMO
   AND   s.CDSUBRAMO              = dac.CDSUBRAMO
   AND   s.CDGARANTIA             = dac.CDGARANTIA
   AND   s.CDSUBGARANTIA          = dac.CDSUBGARANTIA
   AND   NUMERO_RESERVA          IN ('P012091','P012081','P012093','P012096')
   GROUP BY CDTIPO_RESERVA,NUMERO_RESERVA, NVL(POIRPF,0), S.CDRETENCION,NVL(POIRC,0), NVL(POIRPF_RETENIDO,0), NVL(POICA,0), /*ROUND(ABS(((IMPORTE*100)/(100+NVL(POIRPF,0))))),*/--Se cambia porque est? generando mas de un documento cuando no hay cambio de retenciones
            s.CDTRIBUTARIA/*, s.SNIVA*/,
            EXPEDIENTE;

  -- Cursor base para el llenado con los datos del DOCUMENTO por cada tipo de reserva Matem?tica o T?cnica
  CURSOR lcuDatosDocumentoRes IS
   SELECT dac.CDTIPO_RESERVA, NVL(POIRPF,0) POIRPF, S.CDRETENCION,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(s.IMPORTE - NVL(s.PTDESCUENTO,0))),2),
                 ROUND(ABS(SUM(s.IMPORTE - NVL(s.PTDESCUENTO,0)))) ) IMPORTE,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(s.IMPORTE)),2),
                 ROUND(ABS(SUM(s.IMPORTE))) ) IMPORTE_SIN_DESC,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(NVL(S.IMPIRC,0))),2),
                 ROUND(ABS(SUM(NVL(S.IMPIRC,0)))) ) IMPIRC,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(NVL(IMPIRPF_RETENIDO,0))),2),
                 ROUND(ABS(SUM(NVL(IMPIRPF_RETENIDO,0)))) ) IMPIRPF_RETENIDO,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(NVL(IMPICA,0))),2),
                 ROUND(ABS(SUM(NVL(IMPICA,0)))) ) IMPICA,
          NVL(POIRC,0) POIRC, NVL(POIRPF_RETENIDO,0) POIRPF_RETENIDO, NVL(POICA,0) POICA,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(((IMPORTE*100)/(100+NVL(POIRPF,0))))),2),
                 ROUND(ABS(SUM(((IMPORTE*100)/(100+NVL(POIRPF,0)))))) ) BASEIMPUESTOS,
          --Con el cambio de retenciones desde SAP en la devuelta, Se incluye este campo en la consulta, para tener la base del IVA
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(NVL(s.IMPIRPF,0))),2),
                 ROUND(ABS(SUM(NVL(s.IMPIRPF,0)))) ) IMPIRPF,
          s.CDTRIBUTARIA/*, s.SNIVA*/
   FROM SIN_PAGOS_DET s , DIC_ALIAS_COBERTURAS dac
   WHERE EXPEDIENTE               = ivaNmExpediente
   AND   NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND   s.CDRAMO                 = dac.CDRAMO
   AND   s.CDSUBRAMO              = dac.CDSUBRAMO
   AND   s.CDGARANTIA             = dac.CDGARANTIA
   AND   s.CDSUBGARANTIA          = dac.CDSUBGARANTIA
   AND   NUMERO_RESERVA      NOT IN ('P012091','P012081','P012093','P012096')
   GROUP BY CDTIPO_RESERVA, NVL(POIRPF,0), S.CDRETENCION,NVL(POIRC,0),
            NVL(POIRPF_RETENIDO,0), NVL(POICA,0),
            /*ROUND(ABS(((IMPORTE*100)/(100+NVL(POIRPF,0))))),*/
            s.CDTRIBUTARIA
            /*, s.SNIVA*/,
            EXPEDIENTE;

  CURSOR lcuDetalleSumadosDeducible IS
   SELECT s.CDRAMO, s.CDSUBRAMO, s.CDGARANTIA, s.CDSUBGARANTIA,NUMERO_RESERVA, DNI,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(DEDUCIBLE),2),
                 ROUND(ABS(DEDUCIBLE)) ) DEDUCIBLE,DECODE(S.CARGO_ABONO,'A','907','C','916','907') CDOPERACION
   FROM SIN_PAGOS_DET s, DIC_ALIAS_COBERTURAS dac
   WHERE EXPEDIENTE               = ivaNmExpediente
   AND   NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND   s.CDRAMO                 = dac.CDRAMO
   AND   s.CDSUBRAMO              = dac.CDSUBRAMO
   AND   s.CDGARANTIA             = dac.CDGARANTIA
   AND   s.CDSUBGARANTIA          = dac.CDSUBGARANTIA
   AND   dac.CDTIPO_RESERVA       = lvaCdTipoReserva
   AND   s.DEDUCIBLE              <> 0
   AND   NVL(POIRPF,0)            = lvaPoIrpf
   AND   NVL(POIRC,0)             = lvaPoirc
   AND   NVL(POICA,0)             = lvaPoIca
   AND   CDRETENCION              = lvaCdRetencion;

  CURSOR lcuDetalleSumadosDescuento IS
   SELECT s.CDRAMO, s.CDSUBRAMO, s.CDGARANTIA, s.CDSUBGARANTIA, NUMERO_RESERVA,s.DNI,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(s.PTDESCUENTO),2),
                 ROUND(ABS(s.PTDESCUENTO)) ) PTDESCUENTO ,DECODE(S.CARGO_ABONO,'A','907','C','916','907') CDOPERACION
   FROM SIN_PAGOS_DET s, DIC_ALIAS_COBERTURAS dac
   WHERE EXPEDIENTE               = ivaNmExpediente
   AND   NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND   s.CDRAMO                 = dac.CDRAMO
   AND   s.CDSUBRAMO              = dac.CDSUBRAMO
   AND   s.CDGARANTIA             = dac.CDGARANTIA
   AND   s.CDSUBGARANTIA          = dac.CDSUBGARANTIA
   AND   dac.CDTIPO_RESERVA       = lvaCdTipoReserva
   AND   s.PTDESCUENTO           <> 0
   AND   NVL(POIRPF,0)            = lvaPoIrpf
   AND   NVL(POIRC,0)             = lvaPoirc
   AND   NVL(POICA,0)             = lvaPoIca
   AND   CDRETENCION              = lvaCdRetencion;

  CURSOR lcuDetalleSumadosCoaseguro IS
   SELECT s.CDRAMO, s.CDSUBRAMO, s.CDGARANTIA, s.CDSUBGARANTIA,NUMERO_RESERVA, s.DNI,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(s.IMPORTE)*(ctd.POREPARTO_COA/100),2),
                 ROUND(ABS(s.IMPORTE)*(ctd.POREPARTO_COA/100)) ) COASEGURO,
          ctd.CDCIA ,DECODE(S.CARGO_ABONO,'A','907','C','916','907') CDOPERACION
   FROM SIN_PAGOS_DET s, DIC_ALIAS_COBERTURAS dac, COA_TRATADO_DETALLE ctd, COA_TRATADO CT
   WHERE EXPEDIENTE               = ivaNmExpediente
   AND   NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND   s.CDRAMO                 = dac.CDRAMO
   AND   s.CDSUBRAMO              = dac.CDSUBRAMO
   AND   s.CDGARANTIA             = dac.CDGARANTIA
   AND   s.CDSUBGARANTIA          = dac.CDSUBGARANTIA
   AND   dac.CDTIPO_RESERVA       = lvaCdTipoReserva
   AND   NVL(POIRPF,0)            = lvaPoIrpf
   AND   NVL(POIRC,0)             = lvaPoirc
   AND   NVL(POICA,0)             = lvaPoIca
   AND   CDRETENCION              = lvaCdRetencion
   AND   CTD.NPOLIZA              = S.NPOLIZA
--   AND   ctd.CDCIA               <> '00000'
  AND   ctd.CDCIA            NOT IN ('00000','30000')
   AND   ldaFeOcurrencia    BETWEEN CTD.FEALTA
                                AND NVL(CTD.FEBAJA,SYSDATE)
   AND   CT.NPOLIZA               = S.NPOLIZA
   AND   ldaFeOcurrencia    BETWEEN CT.FEALTA
                                AND NVL(CT.FEBAJA,SYSDATE)
   AND   CDCOA                    = 'C';



  -- Cursor base para el llenado del detalle OBJ_SAP_DETALLE_CXP_SINI por cada tipo de reserva de Fondo de ahorro y Valores de Cesion
  CURSOR lcuDatosPagosFyC IS
   SELECT CDRAMO, CDSUBRAMO, CDGARANTIA, CDSUBGARANTIA,
          DECODE(S.CARGO_ABONO,'A',DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS((s.IMPORTE * NVL((lnuPorepartoCoa/100),1)) + s.DEDUCIBLE),2),
                                          (ROUND(ABS((s.IMPORTE * NVL((lnuPorepartoCoa/100),1)) + s.DEDUCIBLE)))
                                         ),
                               'C',DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS((s.IMPORTE * NVL((lnuPorepartoCoa/100),1)) - s.DEDUCIBLE),2),
                                          (ROUND(ABS((s.IMPORTE * NVL((lnuPorepartoCoa/100),1)) - s.DEDUCIBLE)))
                                         )
                )IMPORTE,
          DNI,DECODE(S.CARGO_ABONO,'A','907','C','916','907') CDOPERACION, s.NUMERO_RESERVA
   FROM SIN_PAGOS_DET s/*, COA_TRATADO_DETALLE CTD*/
   WHERE EXPEDIENTE               = ivaNmExpediente
   AND   NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND   NUMERO_RESERVA           = lvaNumeroReserva
   AND   NVL(POIRPF,0)            = lvaPoIrpf
   AND   NVL(POIRC,0)             = lvaPoirc
   AND   NVL(POICA,0)             = lvaPoIca
   AND   CDRETENCION              = lvaCdRetencion
/*   AND   ctd.NPOLIZA    (+)       = s.NPOLIZA
   AND   ctd.CDCIA      (+)       = '00000'
   AND   ctd.CDABRIDORA (+)       = 'A'
   AND   ldaFeOcurrencia    BETWEEN FEALTA
                                AND NVL(FEBAJA,SYSDATE)*/;


  -- Cursor base para el llenado del detalle OBJ_SAP_DETALLE_CXP_SINI por cada tipo de reserva Matematica o T?cnica
  CURSOR lcuDatosPagosRes IS
   SELECT s.CDRAMO, s.CDSUBRAMO, s.CDGARANTIA, s.CDSUBGARANTIA,
          DECODE(S.CARGO_ABONO,'A',DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS((s.IMPORTE * NVL((lnuPorepartoCoa/100),1)) + s.DEDUCIBLE),2),
                                          (ROUND(ABS((s.IMPORTE * NVL((lnuPorepartoCoa/100),1)) + s.DEDUCIBLE)))
                                         ),
                               'C',DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS((s.IMPORTE * NVL((lnuPorepartoCoa/100),1)) - s.DEDUCIBLE),2),
                                          (ROUND(ABS((s.IMPORTE * NVL((lnuPorepartoCoa/100),1)) - s.DEDUCIBLE)))
                                         )
                 ) IMPORTE,
          DNI, NUMERO_RESERVA,DECODE(S.CARGO_ABONO,'A','907','C','916','907') CDOPERACION
   FROM SIN_PAGOS_DET s, DIC_ALIAS_COBERTURAS dac/*, COA_TRATADO_DETALLE ctd*/
   WHERE EXPEDIENTE               = ivaNmExpediente
   AND   NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND   NUMERO_RESERVA      NOT IN ('P012091','P012081','P012093','P012096')
   AND   NVL(POIRPF,0)            = lvaPoIrpf
   AND   NVL(POIRC,0)             = lvaPoirc
   AND   NVL(POICA,0)             = lvaPoIca
   AND   CDRETENCION              = lvaCdRetencion
   AND   s.CDRAMO                 = dac.CDRAMO
   AND   s.CDSUBRAMO              = dac.CDSUBRAMO
   AND   s.CDGARANTIA             = dac.CDGARANTIA
   AND   s.CDSUBGARANTIA          = dac.CDSUBGARANTIA
   AND   dac.CDTIPO_RESERVA       = lvaCdTipoReserva
/*   AND   CTD.NPOLIZA    (+)       = S.NPOLIZA
   AND   ctd.CDCIA      (+)       = '00000'
   AND   ctd.CDABRIDORA (+)       = 'A'
   AND   ldaFeOcurrencia    BETWEEN FEALTA
                                AND NVL(FEBAJA,SYSDATE)*/;

 CURSOR lcuDatosCaja IS
  SELECT NVL(FEPOSIBLE_PAGO,P.FECHA_PAGO), CDVIAPAGO, CDBLOQUEOPAGO, CDPAISBANCO, CDBANCO, NMCUENTA,
         PCK_SIC_SAP.FN_SIC_MAPEO_TIPO_CUENTA(CDTIPOCUENTA) CDTIPOCUENTA,
         CDSUCURSALBANCO, SUBSTR(DSTITULAR,1,60) DSTITULAR, p.CODIGO_ACEPTACION
  FROM PAGOS p
  WHERE p.EXPEDIENTE        = ivaNmExpediente
  AND p.NMPAGO_AUTORIZACION = ivaNmPagoAutorizacion;

  CURSOR lcuDatosSiniestro IS
   SELECT TO_DATE(TO_CHAR(FECHA_SINIESTRO,'DDMMYYYY'),'DDMMYYYY'), TO_DATE(TO_CHAR(s.FECHA_NOTIFICACION,'DDMMYYYY'),'DDMMYYYY')
   FROM SINIESTROS S
   WHERE EXPEDIENTE = ivaNmExpediente;

  CURSOR lcuDatosFactura IS
   SELECT NMFACTURA, NMPREFIJO, PTVALOR_FACTURA
   FROM SIN_FACTURAS
   WHERE NMEXPEDIENTE      = ivaNmExpediente
   AND NMPAGO_AUTORIZACION = ivaNmPagoAutorizacion;

  CURSOR lcuAsegurado IS
   SELECT p.DNI
   FROM PERSONAS_PROD pp, PERSONAS p
   WHERE pp.NPOLIZA    = lvaNmPoliza
   AND pp.NCERTIFICADO = lvaNmCertificado
   AND pp.DNI          = p.DNI
   AND pp.CODIGO      IN ('020','120');

  CURSOR lcuDatosPoliza IS
   SELECT C.CDAGENTE, c.CDDELEGACION_RADICA, c.FEFECTO, c.FEFECTO_ANUALIDAD
   FROM CUERPOLIZA c
   WHERE c.NPOLIZA = lvaNmPoliza;

  CURSOR lcuTipoReserva IS
   SELECT D.CDTIPO_RESERVA,
          DECODE(NVL(D.SNTERREMOTO,'N'),'S',D.CDRAMO_CONTABLE,d.CDRAMO_HOST) CDRAMO_HOST
   FROM DIC_ALIAS_COBERTURAS D
   WHERE D.CDRAMO       = lvaCdRamo
   AND D.CDSUBRAMO      = lvaCdSubRamo
   AND d.CDGARANTIA     = lvaCdGarantia
   AND d.CDSUBGARANTIA  = lvaCdSubGarantia;

  CURSOR lcuMunicipioIca IS
   SELECT a.CDMUNICIPIO
   FROM AGE_DELEGACIONES a
   WHERE a.CDDELEGACION = lvaCdOficinaRegistro;

  CURSOR lcuSnBancaseguros IS
   SELECT SNBANCASEGUROS
   FROM DIC_ALIAS_RS
   WHERE CDRAMO  = lvaCdRamo
   AND CDSUBRAMO = lvaCdSubRamo;

  CURSOR lcuCdUsuario IS
   SELECT CODIGO_USUARIO
   FROM HISTORICO
   WHERE EXPEDIENTE             = ivaNmExpediente
   AND NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion;

  CURSOR lcuDsLoginUsuario IS
   SELECT UPPER(DSLOGIN)
   FROM USUARIOS_1
   WHERE CDN_EMPLE = lvaCdUsuario;

  CURSOR lcuPoBaseRetencion IS
   SELECT NVL(PORETENCION,0) PORETENCION
   FROM SIN_RETENCIONES
   WHERE CDRETENCION         = '9999'
   AND TRUNC(ldaFePago) BETWEEN TRUNC(FEALTA)
                            AND TRUNC(NVL(FEBAJA, ldaFePago +365))
   AND CDTIPO_RETENCION       = 'I';

  CURSOR lcuPoRetencion IS
   SELECT NVL(PORETENCION,0)
   FROM SIN_RETENCIONES
   WHERE CDRETENCION            = lvaCdRetencion
   AND ldaFePago          BETWEEN fealta
                              AND NVL(febaja,ldaFePago)
   AND CDTIPO_RETENCION         = 'I';

  CURSOR lcuSnIva IS
   SELECT SNIVA
   FROM SIN_PAGOS_DET
   WHERE EXPEDIENTE               = ivaNmExpediente
   AND   NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND   SNIVA                    = 'S';

  CURSOR lcuCiaCoaseguradora IS
   SELECT CIF
   FROM COMPANIAS
   WHERE CDCIA = lvaCdCiaCoaseguradora;

  CURSOR lcuSoloSuraCoaseguro IS
   SELECT CDCLASE
   FROM SIN_CLASES_HISTORICO
   WHERE EXPEDIENTE = ivaNmExpediente
   AND cdclase      = '01';

  CURSOR lcuPorcentajeCoaseguro IS
   SELECT POREPARTO_COA
   FROM COA_TRATADO_DETALLE
   WHERE NPOLIZA               = lvaNmPoliza
--   AND   CDCIA                 = '00000'
   AND   CDCIA            IN ('00000','30000')
   AND   CDABRIDORA            = 'A'
   AND   ldaFeOcurrencia BETWEEN FEALTA
                             AND NVL(FEBAJA,SYSDATE);
  -- Se omite gastos del proceso jur?dico de acuerdo a solicitud de Jose Libardo Cruz con CA 120293
  --20140728 Por historia de usuario 77550 solicitada por Mario Franco, ya no se lleva obligado por Caja la pretenci?n objetivada.

  --CURSOR lcuSNPagoJuridico IS
  -- SELECT 'S'
  -- FROM SIN_PAGOS_DET
  -- WHERE EXPEDIENTE               = ivaNmExpediente
  -- AND   NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
  -- AND   NUMERO_RESERVA          IN ('P010000','P010002','P010003'/*,'P012086'*/);
  -- Fin de 20140728 Por historia de usuario 77550 solicitada por Mario Franco, ya no se lleva obligado por Caja la pretenci?n objetivada.

  -- Panam?.  Para identificar el tipo de producto de acuerdo a la vigencia Si el siniestro est? en la priver vigencia
  --          para adicionar un 1 de lo contrario se adiciona una R
  CURSOR lcuPrimerVigencia IS
   SELECT 'S'
   FROM CUERPOLIZA cp, SINIESTROS s
   WHERE cp.NPOLIZA = s.POLIZA
   AND s.FECHA_SINIESTRO BETWEEN cp.NUEVA_FEFECTO AND ADD_MONTHS(cp.NUEVA_FEFECTO, 12)
   AND s.EXPEDIENTE = ivaNmExpediente;

  -- Panam?.  Se lee el tipo de producto por si es Tradicional o Universal.
  CURSOR lcuGrupoProducto IS
   SELECT CDGRUPO_PRODUCTO
   FROM DIC_ALIAS_RS
   WHERE CDRAMO  = lvaCdRamo
   AND CDSUBRAMO = lvaCdSubRamo;

  -- Panam?. Se lee el tipo de cobertura para determimar si la cobertura pertenece a Bancario, Fidelidad, o Construccion
  CURSOR lcuGrupoCobertura IS
   SELECT CDGRUPO_COBERTURA
   FROM DIC_ALIAS_COBERTURAS
   WHERE CDRAMO      = lvaCdRamo
   AND CDSUBRAMO     = lvaCdSubRamo
   AND CDGARANTIA    = lvaCdGarantia
   AND CDSUBGARANTIA = lvaCdSubGarantia;

  -- Panam?. Se lee Si es Proveedor de personas
  CURSOR lcuProveedor IS
   SELECT 'S'
   FROM PERSONAS
   WHERE DNI       = lvaDni
   AND SNPROVEEDOR = 'S';

  -- Panam?. Se El digito de verificacion
  CURSOR lcuDigitoVerificacion IS
   SELECT NMDIGITO_VER
   FROM PERSONAS
   WHERE DNI       = lvaDni;

  -- Panam?.  Tipo de Coaseguro para detectar cuando es Aceptado
  CURSOR lcuTipoCoaseguro IS
   SELECT CDCOA
   FROM COA_TRATADO
   WHERE NPOLIZA               = lvaNmPoliza
   AND   ldaFeOcurrencia BETWEEN FEALTA
                             AND NVL(FEBAJA,SYSDATE);

  -- fernsavi CURSOR PARA IDENTIFICAR SI EL PRODUCTO (RAMOCONTABLE) CONTABILIZA A CUENTA DE
  -- PERSONAS EN LA SOCIEDAD 1000
  CURSOR lcuSnCuentaContable IS
   SELECT NVL(D.SNCUENTA_CONTABLE,'N')
   FROM DIC_ALIAS_RS D
   WHERE D.CDRAMO = lvaCdramoContable
   AND D.CDSUBRAMO = lvaCdSubramo;

   --JuanAlNo Cursor temporal para obtener los datos de las garantias desde el detalle de los pagos, Asi validar condicion
   --unicamente para planes que no pagan copagos y coutas moderadores
   CURSOR lcuDatosTempGarantia IS
   SELECT CDGARANTIA, CDSUBGARANTIA 
   FROM SIN_PAGOS_DET 
	WHERE EXPEDIENTE = ivaNmExpediente 
	AND NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion;

  BEGIN

  --Datos generales del mensaje que necesita Surabroker ...
  --Parametrizables
  lvaMensajeTecnico            := 'Valores Iniciales';
  lobjTyinf.CDCONSUMIDOR       := 'SINIESTROS';
  lobjTyinf.CDSERVICIO         := 'SiniestrosCxP';
  lobjTyinf.CDOPERACION        := 'SI_os_WS_SiniestrosCxP';
  --lobjTyinf.CDTOKEN          := ''; hasta donde s?, no aplica
  lobjTyinf.CDVERSION_SERVICIO := '1.0';
  lobjTyinf.DSNAME_SPACE       := NULL;
  lobjTyinf.DSPUERTO           := 'HTTP_Port';

  --No Parametrizables
  lobjTyinf.DSCLAVE            := ivaNmPagoAutorizacion;
  lobjTyinf.FECREACION         := SYSDATE;
  lobjTyinf.NMPRIORIDAD        := NULL;

  SP_USUARIO (lvaDsUsuario, lvaDsClave, lvaMensajeTecnicoExt, lvaMensajeUsuarioExt);

  ltyEncabezadoMens            := TAB_SBK_ENC_MENSAJE(OBJ_SBK_ENC_MENSAJE( PCK_SBK_SURABROKER.HEADER_BASIC_AUTH_USER,lvaDsUsuario));
  ltyEncabezadoMens.EXTEND;
  ltyEncabezadoMens(2)         := OBJ_SBK_ENC_MENSAJE( PCK_SBK_SURABROKER.HEADER_BASIC_AUTH_PASSWORD,lvaDsClave);
  lobjTyinf.TYENCABEZADOS      := ltyEncabezadoMens;
----------------------------------------------------------------------------------------------------------------------
  --Datos de la cabecera de la Cuenta por pagar
  FOR cab IN lcuDatosCabecera LOOP
   lvaCdRamo    := cab.CDRAMO;
   lvaCdSubRamo := cab.CDSUBRAMO;
   lvaDni       := cab.DNI;
   ldaFePago    := cab.FEPAGO;
   lvaNmPoliza  := cab.NPOLIZA;
   lnuPoDescuento := cab.PODESCUENTO;

   IF cab.NUMERO_RESERVA = 'PSUSALUD' THEN
     lvaSnPolizaSalud := 'S';
   END IF;

   -- Panama Fecha para coaseguro Aceptado
   OPEN lcuDatosSiniestro;
   FETCH lcuDatosSiniestro INTO ldaFeOcurrencia, ldaFenotificacion;
   CLOSE lcuDatosSiniestro;

   --Panam?. Digito de verificaci?n
   OPEN lcuDigitoVerificacion;
   FETCH lcuDigitoVerificacion INTO lvaDigitoVerificacion;
   CLOSE lcuDigitoVerificacion;

   --Datos de conversi?n que solicita SAP
   lobjDatosConversion.cdFuente       := 'SIN';
   lobjDatosConversion.nmAplicacion   := '79';

   -- SE MODIFICA CURSOR PARA EVITAR HACER UNO NUEVO A DIC_ALIAS_RS
   OPEN lcuSnBancaseguros;
   FETCH lcuSnBancaseguros INTO lvaSnBancaseguros;
   CLOSE lcuSnBancaseguros;
   IF lvaSnBancaseguros = 'S' THEN
    lobjDatosConversion.cdCanal := 'BAN';
   ELSE
    lobjDatosConversion.cdCanal := 'SEG';
   END IF;

   --Datos del usuario que hace el pago
   OPEN lcuCdUsuario;
   FETCH lcuCdUsuario INTO lvaCdUsuario;
   CLOSE lcuCdUsuario;

   IF translate(lvaCdUsuario,'T 0123456789-+.','T') IS NULL THEN
    OPEN lcuDsLoginUsuario;
    FETCH lcuDsLoginUsuario INTO lvaDsLoginUsuario;
    CLOSE lcuDsLoginUsuario;
   END IF;

   lobjCabecera.datosConversionOrigen := lobjDatosConversion;


   PCK_GESTION_PRODUCTOS.SPGET_COMPANIA_PRODUCTO( cab.cdramo,cab.cdsubramo,lvaCdCompania,lvaCdciaMatriz,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);
   lobjCabecera.feFactura             := cab.FEPAGO;
   lobjCabecera.cdCompania            := lvaCdCompania;
   lobjCabecera.feRegistroSap         := cab.FEPAGO;
   lobjCabecera.nmPeriodo             := TO_CHAR(cab.FEPAGO,'MM');

   -- Todos los pagos de Sura se hacen en moneda pesos
   -- Panama.  la moneda base es 20
   IF lvaCdCompania IN ('01','02') THEN
    lobjCabecera.cdMoneda    := '0';
   ELSE
    IF lvaCdciaMatriz = '30' THEN
     lobjCabecera.cdMoneda   := '20';
     lobjCabecera.cdCompania := lvaCdciaMatriz;
    ELSE
     lobjCabecera.cdMoneda := cab.cdMoneda;
    END IF;
   END IF;

   lobjCabecera.ptTasaCambio          := NULL;
   lobjCabecera.feTasaCambio          := NULL;

   -- Para la referencia (dsFacturaOrdenPago) se toman la 8 primeras de la factura - las 7 primeras de la orden de pago
   OPEN lcuDatosFactura;
   FETCH lcuDatosFactura INTO lvaNmFactura,lvaNmPrefijo,lnuVlrFactura;
   CLOSE lcuDatosFactura;

   lobjCabecera.nmOrdenPago           := ivaNmPagoAutorizacion;
   IF LENGTH(TRIM(lvaNmPrefijo)) > 9 THEN
      lvaNmPrefijo                    := SUBSTR(lvaNmPrefijo,(LENGTH(TRIM(lvaNmPrefijo))-8));
   END IF;
   IF TRIM(lvaNmPrefijo) IS NOT NULL THEN
      lobjCabecera.nmFactura          := lvaNmPrefijo ||'-'||lvaNmFactura;
   ELSE
      lobjCabecera.nmFactura          := lvaNmFactura;
   END IF;
   ---juancagr 20160903 se a?ade como parametro el valor de la factura y el numero de factura
   IF lvaCdRamo IN ('090','091') THEN
      --ltabMapItems := TAB_SAP_MAPITEM();
      ltabMapItems := TAB_SAP_DTMAPITEM();
      lobjItemMap.KEY := 'VALORFACTURA';

      IF lnuPoDescuento > 0 THEN
        lobjItemMap.VALUE := PCK_GWB_ENVIO_SNTROS.FN_VALOR_FACTURA_SIN_DESCUENTO(ivaNmPagoAutorizacion);
      ELSE
        lobjItemMap.VALUE := lnuVlrFactura;
      END IF;

      ltabMapItems.EXTEND();
      ltabMapItems(1) := lobjItemMap;
      lobjMap.ITEMS := ltabMapItems;
      --dbms_output.put_line(lobjMap.ITEMS(1).key);
      lobjPago.parametrosAdicionales := lobjMap;
      --dbms_output.put_line(lobjPago.parametrosAdicionales.ITEMS(1).key);
   END IF;

   lvaSnCalcularImpuestos             := 'S';

   OPEN lcuDatosCaja;
   FETCH lcuDatosCaja INTO lvaFeposiblePago, lvaCdViaPago, lvaCdbloqueoPago,
                           lvaCdPaisBanco, lvaCdBanco, lvaNmCuenta, cdTipoCuenta,
                           lvaCdSucursalBanco, lvaDsTitular, lvaCodigoAceptacion;
   CLOSE lcuDatosCaja;
   -- Datos pago caja Sura
    lvaSnPagoCajaSura   := NVL(PCK_PARAMETROS.FN_GET_PARAMETROV2(lvaCdRamo,
                                                                 lvaCdSubRamo,
                                                                 'PAGOCAJASURA',
                                                                 SYSDATE,
                                                                 lvaNmPoliza,
                                                                 '%',
                                                                 '%',
                                                                 '%',
                                                                 '%'),
                                'N');

   IF lvaCdViaPago = 'CP' THEN
    lvaCdbloqueoPago := 'F';
    lvaCdViaPago     := 'CA';
   END IF;

   IF lvaCdRamo = 'BAN' AND lvaCdSubRamo = 'DES' THEN
    lvaCdViaPago     := '03';
   END IF;

   --Panam?.  Cuando para panam? se est? manejando GE, este par?metro va a venir en la tabla pagos
   IF lvaCdViaPago = 'IO' THEN
    lvaCdViaPago     := 'CA';
   END IF;
   --Fin Panam?

   IF lvaCdViaPago = 'CA' AND lvaSnPagoCajaSura = 'S' THEN
    lvaCdViaPago     := '2';
   END IF;

   -- Datos de la cuenta
   lobjCuentaBancaria.cdPaisBanco     := lvaCdPaisBanco;
   lobjCuentaBancaria.cdBanco         := lvaCdBanco;
   lobjCuentaBancaria.nmCuenta        := lvaNmCuenta;
   lobjCuentaBancaria.cdTipoCuenta    := cdTipoCuenta;
   lobjCuentaBancaria.dsTitular       := lvaDsTitular;

   lvaNmExpediente                    := ivaNmExpediente;
   lvaNmCertificado                   := cab.NCERTIFICADO;
   lobjCondicionPago.cdCondicionPago  := '0001';

   IF lvaSnPolizaSalud = 'S' THEN
     lobjCondicionPago.poDescuento      := lnuPoDescuento;
     lobjCondicionPago.nmDias           := PCK_GWB_ENVIO_SNTROS.FN_DIAS_PRONTO_PAGO(ivaNmPagoAutorizacion,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);

     IF lobjCondicionPago.nmDias > 0 THEN
       lobjCondicionPago.cdCondicionPago  := '0025';
     END IF;
   END IF;

   lvaDsTextoPosicion                 := 'AUTORIZACIONES SINIESTROS';
   -- calcular la operacion segun el neto del pago
   lvaCdOperacion                     := cab.CDOPERACION;
   lvaNmBeneficiarioPago              := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(cab.DNI);
   lvaCdOficinaRegistro               := cab.CDENTIDAD;
   lvaCdRamo                          := cab.CDRAMO;
   lnuIvaDescontable                  := cab.IMPIRPF;
   lnuDeducible                       := cab.DEDUCIBLE;
   lnuPtDescuento                     := cab.PTDESCUENTO;

   --Solicitud de German Duque 8000030708  CONTROL CAMBIO BANCASEGUROS RAMO-SUBRAMO, Componente BC-aba-FI

   --linaduto - 2025/03/11 - HU756348 -Ajuste retenci?n en la fuente para ID NIT - subramos PCP y deudores
   lvaAplicaSinRetencion := NVL(PCK_PARAMETROS.FN_GET_PARAMETROV2(lvaCdRamo,
                                                                 lvaCdSubRamo,
                                                                 'APLICASINRETEN',
                                                                 SYSDATE,
                                                                 '%',
                                                                 '%',
                                                                 '%',
                                                                 '%',
                                                                 '%'),
                                'N');

  END LOOP; --lcuDatosCabecera
--Fin de CABECERA
----------------------------------------------------------------------------------------------------------------------
-- Cursores de Documentos


  FOR doc IN lcuDatosDocumentoFyC LOOP

   lvaCodIva                          := LPAD(REPLACE(TO_CHAR(RPAD(DOC.POIRPF,4,'0')),'.',''),4,'0');
   -- 8/10/2025. HT918841 - Códigos de retención específicos. luishure 
   IF lvaCodIva = '1900' AND PCK_PARAMETROS.FN_GET_PARAMETROV2('%','%','GET_INDICADOR',SYSDATE, DOC.CDRETENCION ,'*','*','*','*') IS NOT NULL THEN
     lvaCodIva                        := PCK_PARAMETROS.FN_GET_PARAMETROV2('%','%','GET_INDICADOR',SYSDATE, DOC.CDRETENCION ,'*','*','*','*');
   END IF;
   lvaNumeroReserva                   := doc.NUMERO_RESERVA;
   lvaPoIrpf                          := doc.POIRPF;
   lvaPoirc                           := doc.POIRC;
   lvaPoIca                           := doc.POICA;
   lvaCdRetencion                     := doc.CDRETENCION;
   lvaCdTipoReserva                   := doc.CDTIPO_RESERVA;

   lnuContadorDocumentos              := lnuContadorDocumentos + 1;
   lobjDocumento                      := OBJ_SAP_DOCUMENTO_CXP_SINI();
   lobjDocumento.cdOficinaRegistro    := lvaCdOficinaRegistro;
   lobjDocumento.ptImporte            := doc.importe;
   lobjDocumento.snCalcularImpuestos  := lvaSnCalcularImpuestos;
   lobjDocumento.cdIva                := NULL;--lvaCodIva;
   lobjDocumento.fePosiblePago        := lvaFeposiblePago;

   lobjDocumento.condicionPago        := lobjCondicionPago;

   lobjDocumento.cdTipoIdentificacion := PCK_SIC_UTILITARIOS_I.FN_SIC_CDTIPO_IDENTIFICACION(lvaDni);

   -- 17/07/2025 Mateo Zapata - Homologacion de tipo de documento TT para SAP
   IF UPPER(lobjDocumento.cdTipoIdentificacion) = 'TT' THEN
     lobjDocumento.cdTipoIdentificacion := 'PT';
   END IF;

   lobjDocumento.nmBeneficiarioPago   := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(lvaDni);
   --Panama. Digito de verificacion
   IF lvaCdciaMatriz = '30' THEN
    IF lvaDigitoVerificacion IS NOT NULL THEN
--SAP va a poner el d?gito de verificaci?n.
NULL;
--     lobjDocumento.nmBeneficiarioPago := lobjDocumento.nmBeneficiarioPago||':'||lvaDigitoVerificacion;
    END IF;
   END IF;

   lobjDocumento.cdViaPago            := lvaCdViaPago;
   lobjDocumento.cdBloqueoPago        := lvaCdbloqueoPago;
   lobjDocumento.dsTextoPosicion      := lvaDsTextoPosicion;
   lobjDocumento.nmPoliza             := lvaNmPoliza;
   IF lvaCdRamo = 'BAN' THEN
    lobjDocumento.cdRamo               := lvaCdRamo||lvaCdSubRamo;
   ELSE
    lobjDocumento.cdRamo               := lvaCdRamo;
   END IF;
   lobjDocumento.cdOperacion          := lvaCdOperacion;
   lobjDocumento.cdTipoReserva        := doc.CDTIPO_RESERVA;
   -- Para atender la solicitud de catatalogo de servicio nro. 71527 de 02/04/2013 09:17:02 por Luis Gmo. Freyre
   IF lvaCdciaMatriz = '00' THEN
    IF doc.CDTRIBUTARIA = 'N' AND doc.CDRETENCION NOT IN ('0029','0028') THEN
     lobjDocumento.cdOperacion := lobjDocumento.cdOperacion||'P';
    END IF;
   ELSIF lvaCdciaMatriz = '30' THEN
   -- Panam? En la coexistencia, no se pregunta por reembolso.  Solo se lee de personas si es proveedor
--    IF doc.CDTRIBUTARIA = 'N' THEN
     OPEN lcuProveedor;
     FETCH lcuProveedor INTO lvaSnProveedorPanama;
     IF lcuProveedor%FOUND THEN
      lobjDocumento.cdOperacion := lobjDocumento.cdOperacion||'P';
     END IF;
     CLOSE lcuProveedor;
--    END IF;
   -- Panam?.  Riesgo del Exterior
     IF lvaCdRamo = '030' THEN
      lvaSnRiesgoExterior  := PCK_SIN_ADAPTADOR_SAP.FN_RIESGO_EXTERIOR (lvaNmPoliza,lvaNmCertificado,lvaMensajeTecnicoExt, lvaMensajeUsuarioExt);
      IF lvaSnRiesgoExterior = 'S' THEN
       lobjDocumento.cdOperacion := lobjDocumento.cdOperacion||'E';
      END IF;
     END IF;
   END IF;
    -- lobjDocumento.cdTipoReserva: Inicialmente ten?a NULL por requerimiento de las pruevas, con el mensaje: Va en null porque no aplica el tipo de reserva para Fondo y Cesion
    -- En correo de German Duque de Lunes 2010/1/18 07:50 a.m. Se informa que debe ir de acuerdo a lo que arroge el Cursor que debe ser (M)

   --Llenado de la tabla de Retenciones.
   -- Panam?. no se llevan las retenciones
   IF lvaCdciaMatriz = '00' THEN
    lvaCdRetencion                     := doc.CDRETENCION;
    lnuImpIrc                          := doc.IMPIRC;
    lnuImpIrpfRetenido                 := doc.IMPIRPF_RETENIDO;
    lnuImpIca                          := doc.IMPICA;

    lnuContadorRetencion               := 0;
    lobjRetenciones                    := TAB_SAP_DATOS_RETENCIONES(OBJ_SAP_DATO_RETENCION());
--Con el cambio de retenciones, en el legacy se llevan a cero y es SAP quien las calcula
--Se comenta como estaba anteriomente y se llevan solo si hay c?digo de retencion
--   IF NVL(lnuImpIrc,0) <> 0 THEN
    IF NVL(lvaCdRetencion,0) NOT IN ('0099','0000')  THEN
     lnuContadorRetencion                := lnuContadorRetencion + 1;
     lobjRetencion.cdtipoRetencion       := lvaCdRetencion;
     lobjRetencion.cdindicadorRetencion  := 'R';
     lobjRetencion.ptBaseRetencion       := doc.BASEIMPUESTOS;
     lobjRetencion.ptRetencion           := doc.IMPIRC;

     IF lnuContadorRetencion = 1 THEN
      lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
     ELSE
      lobjRetenciones.Extend;
      lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
     END IF;
    END IF;

--Con el cambio de retenciones, en el legacy se llevan a cero y es SAP quien las calcula
--Se comenta como estaba anteriomente y se llevan solo si hay c?digo de retencion
--      IF NVL(lnuImpIrpfRetenido,0) <> 0 THEN
    IF NVL(lvaCdRetencion,0) NOT IN ('0099','0000')  THEN
--   IF NVL(lnuImpIrpfRetenido,0) <> 0 THEN
     lnuContadorRetencion                := lnuContadorRetencion + 1;
     lobjRetencion.cdtipoRetencion       := lvaCdRetencion;
     lobjRetencion.cdindicadorRetencion  := 'I';
     --Se comenta esta l?nea por el cambio de calculo de retenci?n desde SAP y avisado desde la devuelta.
     --para la base se env?a el valor del IVA doc.IMPIRPF y no la base de toda la retenci?n como se ten?a acostumbrado.
     --    lobjRetencion.ptBaseRetencion       := doc.BASEIMPUESTOS;
     lobjRetencion.ptBaseRetencion       := doc.IMPIRPF;
     lobjRetencion.ptRetencion           := doc.IMPIRPF_RETENIDO;

     IF lnuContadorRetencion = 1 THEN
      lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
     ELSE
      lobjRetenciones.Extend;
      lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
     END IF;
    END IF;

    -- Retencion de IVA R?gimen Simplificado
    -- Por requerimiento de Fredy Rios enviado el Martes 2010/2/23 01:47 p.m.
    -- se elimina el regimen simplificado para los ramos de personas.
    IF lvaCdCompania IN ('01') THEN
     OPEN lcuSnIva;
     FETCH lcuSnIva INTO lvaSnIva;
     IF lcuSnIva%NOTFOUND THEN
      lvaSnIva := 'N';
     END IF;
     CLOSE lcuSnIva;
     IF NVL(lnuImpIrpfRetenido,0) = 0 AND lvaSnIva = 'N' AND doc.CDTRIBUTARIA = 'N'
        AND pck_sic_utilitarios.fn_sic_naturaleza_dni(lobjDocumento.cdTipoIdentificacion) <> 'JJURIDICO' THEN
      lnuPoBaseRetencion                  := 0;
      OPEN lcuPoBaseRetencion;
      FETCH lcuPoBaseRetencion INTO lnuPoBaseRetencion;
      CLOSE lcuPoBaseRetencion;

      lnuPoRetencion                      := 0;
      OPEN lcuPoRetencion;
      FETCH lcuPoRetencion INTO lnuPoRetencion;
      CLOSE lcuPoRetencion;

      --En el cambio del c?lculo de retenciones, el reteIVA regimen simplificado se calcula y se env?a a SAP calculado
      lnuReteIvaSimplificado              := doc.BASEIMPUESTOS * ((lnuPoRetencion*lnuPoBaseRetencion)/100);
      IF lnuReteIvaSimplificado <> 0 THEN
       lnuContadorRetencion                := lnuContadorRetencion + 1;
       lobjRetencion.cdtipoRetencion       := lvaCdRetencion;
       lobjRetencion.cdindicadorRetencion  := 'S';
       lobjRetencion.ptBaseRetencion       := doc.BASEIMPUESTOS;
       lobjRetencion.ptRetencion           := lnuReteIvaSimplificado;

       IF lnuContadorRetencion = 1 THEN
        lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
       ELSE
        lobjRetenciones.Extend;
        lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
       END IF;
      END IF;
     END IF;
    END IF;

--Con el cambio de retenciones, en el legacy se llevan a cero y es SAP quien las calcula
--Se comenta como estaba anteriomente y se llevan solo si hay c?digo de retencion
--   IF NVL(lnuImpIca,0) <> 0 THEN
    IF NVL(lvaCdRetencion,0) NOT IN ('0099','0000')  THEN
     OPEN lcuMunicipioIca;
     FETCH lcuMunicipioIca INTO lvaMunicipioIca;
     CLOSE lcuMunicipioIca;
     lnuContadorRetencion                := lnuContadorRetencion + 1;
     lobjRetencion.cdtipoRetencion       := lvaCdRetencion;
     lobjRetencion.cdindicadorRetencion  := lvaMunicipioIca;
     lobjRetencion.ptBaseRetencion       := doc.BASEIMPUESTOS;
     lobjRetencion.ptRetencion           := doc.IMPICA;

     IF lnuContadorRetencion = 1 THEN
      lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
     ELSE
      lobjRetenciones.Extend;
      lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
     END IF;
    END IF;

    lobjDocumento.retenciones        := lobjRetenciones;
   END IF;

   IF doc.NUMERO_RESERVA = 'P012091' THEN
   lvaCdConcepto  := '11';
   ELSIF doc.NUMERO_RESERVA = 'P012081' THEN
    lvaCdConcepto  := '5';
   ELSIF doc.NUMERO_RESERVA = 'P012093' THEN
    lvaCdConcepto  := '7';
   ELSIF doc.NUMERO_RESERVA = 'P012096' THEN
    lvaCdConcepto  := '3';
   END IF;

   -- Panama para Salvantos y Subrogaciones
   IF lvaCodigoAceptacion = 'D' THEN
    lvaCdConcepto  := '12';
   ELSIF lvaCodigoAceptacion = 'S' THEN
    lvaCdConcepto  := '10';
   END IF;

   lobjDocumento.cdConcepto := lvaCdConcepto;

  --Llenado de la tabla de Detalles para tipo de reserva de Fondo de ahorro y Valores de Cesion.
   lnuContadorDetalle := 0;
   lobjTabDetalles := tab_sap_detalles_cxp_sini(obj_sap_detalle_cxp_sini());

   OPEN lcuDatosSiniestro;
   FETCH lcuDatosSiniestro INTO ldaFeOcurrencia, ldaFenotificacion;
   CLOSE lcuDatosSiniestro;

   lnuPorepartoCoa := 100;
   OPEN lcuSoloSuraCoaseguro;
   FETCH lcuSoloSuraCoaseguro INTO lvaIdSoloSura;
   IF lcuSoloSuraCoaseguro%FOUND THEN
    lnuPorepartoCoa := 100;
   ELSE
    OPEN lcuPorcentajeCoaseguro;
    FETCH lcuPorcentajeCoaseguro INTO lnuPorepartoCoa;
    IF lcuPorcentajeCoaseguro%NOTFOUND THEN
     lnuPorepartoCoa := 100;
    END IF;
    CLOSE lcuPorcentajeCoaseguro;
   END IF;
   CLOSE lcuSoloSuraCoaseguro;


   FOR reg IN lcuDatosPagosFyC LOOP

    lvaCdRamo                       := reg.CDRAMO;
    lvaCdSubramo                    := reg.CDSUBRAMO;
    lvaCdGarantia                   := reg.CDGARANTIA;
    lvaCdSubGarantia                := reg.CDSUBGARANTIA;
    lvaAplicaReservaSinRetencion    := NVL(PCK_PARAMETROS.FN_GET_PARAMETROV2('%',
                                                                             '%',
                                                                             'RESERVASINRETEN',
                                                                             SYSDATE,
                                                                             reg.NUMERO_RESERVA,
                                                                             '%',
                                                                             '%',
                                                                             '%',
                                                                             '%'), 'N');

    lobjDetalle.cdIndicadorImpuesto := lvaCodIva;
    -- 01/12/2024 josebuvi VERIFICACION DE VIDA PARA INDICADOR IMPUESTO
    -- linaduto - 2025/03/11 - HU756348 -Ajuste retenci?n en la fuente para ID NIT - subramos PCP y deudores
    -- linaduto - 2025/03/20 - HU764049 -Ajuste retenci?n en la fuente para ID NIT - Ramo BAN
    -- luishure - 2025/12/10 - HU984785 - Exclusión de retención para Fondo de Ahorro   
    IF (lvaCdRamo = '081' OR lvaCdRamo = 'BAN') AND lvaCdGarantia = 'VID' AND lvaAplicaReservaSinRetencion = 'N' THEN
      IF (lvaAplicaSinRetencion = 'N' OR (lvaAplicaSinRetencion = 'S' AND substr(lvaDni,1,1) <> 'A')) THEN
            lnuContadorRetencionVida             := lnuContadorRetencionVida + 1;
            IF lnuContadorRetencionVida = 1 THEN
              lnuContadorRetencion               := lnuContadorRetencion + 1;
              lobjRetencion.cdtipoRetencion      := 'F5';
              lobjRetencion.cdindicadorRetencion := 'VI';
              IF lnuContadorRetencion = 1 THEN
                lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
              ELSE
                lobjRetenciones.Extend;
                lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
              END IF;
              lobjDocumento.retenciones := lobjRetenciones;
            END IF;
      END IF;	  
    END IF;
    lvaSnCuentaContable             := 'N';

    OPEN lcuTipoReserva;
    FETCH lcuTipoReserva INTO lvaCdTipoReserva,lvaCdramoContable;
    CLOSE lcuTipoReserva;

    lnuContadorDetalle              := lnuContadorDetalle + 1;
    lobjDetalle.cdTipoReserva       := lvaCdTipoReserva;

    OPEN lcuSnCuentaContable;
    FETCH lcuSnCuentaContable INTO lvaSnCuentaContable;
    CLOSE lcuSnCuentaContable;

    -- Panam? 20130722 Compa??a = 30 En Colombia es cdciaMatriz en SAP es 3000
    PCK_GESTION_PRODUCTOS.SPGET_COMPANIA_PRODUCTO( reg.cdramo,reg.cdsubramo,lvaCdCompania,lvaCdciaMatriz,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);
    -- Panam? 20130722 el ramo es el que viene de la fuente
    IF lvaCdciaMatriz = '00' THEN
     IF lvaCdRamo = '081' AND lvaCdTipoReserva = 'T' THEN
--     lobjDetalle.cdRamo  := 'MVI';
      lobjDetalle.cdRamo := 'AAV';
     ELSE
      lobjDetalle.cdRamo := lvaCdramoContable;
     END IF;
    ELSIF lvaCdciaMatriz = '30' THEN
     lobjDetalle.cdRamo  := lvaCdramoContable;
    END IF;
    lobjDetalle.nmPoliza            := lvaNmPoliza;

    OPEN lcuDatosPoliza;
    FETCH lcuDatosPoliza INTO lvaCdAgente, lvaCdDelegacionRadica, ldaFeFecto, ldaFeFectoAnualidad;
    CLOSE lcuDatosPoliza;

    lobjDetalle.cdIntermediario     := lvaCdAgente;
    lobjDetalle.cdOficinaRadicacion := lvaCdDelegacionRadica;
    lobjDetalle.nmExpediente        := lvaNmExpediente;

    OPEN lcuAsegurado;
    FETCH lcuAsegurado INTO lvaDniAsegurado;
    CLOSE lcuAsegurado;
    lvaNmAsegurado := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(lvaDniAsegurado);
    lobjDetalle.nmAsegurado         := lvaNmAsegurado;
    lobjDetalle.ptImporte           := REG.IMPORTE;

    lobjDetalle.cdCentroCostos      := lvaCdDelegacionRadica;

    OPEN lcuDatosSiniestro;
    FETCH lcuDatosSiniestro INTO ldaFeOcurrencia, ldaFenotificacion;
    CLOSE lcuDatosSiniestro;
    lobjDetalle.feAviso             := ldaFenotificacion;
    lobjDetalle.feOcurrencia        := ldaFeOcurrencia;

    -- Panam? 20130722 Compa??a = 30 En Colombia es cdciaMatriz en SAP es 3000
    IF lvaCdciaMatriz = '00' THEN
     lobjDetalle.cdCompaniaParametro := lvaCdCompania;
    ELSIF lvaCdciaMatriz = '30' THEN
     lobjDetalle.cdCompaniaParametro := lvaCdciaMatriz;
    ELSE
     lobjDetalle.cdCompaniaParametro := lvaCdCompania;
    END IF;

    IF lvaCdciaMatriz = '00' THEN
     IF lvaCdRamo = '041' THEN
      lobjDetalle.cdRamoParametro := '041';
     ELSIF lvaCdRamo = '092' THEN
      lobjDetalle.cdRamoParametro := '092';
     ELSIF lvaSnCuentaContable = 'S' THEN
      lobjDetalle.cdRamoParametro := lvaCdramoContable;
     ELSE
      lobjDetalle.cdRamoParametro := 'N';
     END IF;
    ELSIF lvaCdciaMatriz = '30' THEN
     IF lvaCdRamo = '081' THEN
      -- Moneda = 20 En SAP es PAB
      -- 081TA Vida individual tradicional 1 a?o
      -- 081TR Vida individual tradicional Renovacion
      -- 081UA Vida individual Universal 1 a?o
      -- 081UR Vida individual Universal Renovacion
      -- 012BR Fianza bienes raices (contruccion)
      -- 012FI Fianza Fidelidad
      -- 012BA Bancaria
      lvaSnPrimerVigencia := 'S';
      OPEN lcuPrimerVigencia;
      FETCH lcuPrimerVigencia INTO lvaSnPrimerVigencia;
      IF lcuPrimerVigencia%NOTFOUND THEN
       lvaSnPrimerVigencia := 'N';
      END IF;
      CLOSE lcuPrimerVigencia;

      --Para identificar si es Universal o tradicional.
      OPEN lcuGrupoProducto;
      FETCH lcuGrupoProducto INTO lvaGrupoProducto;
      CLOSE lcuGrupoProducto;

      IF lvaSnPrimerVigencia = 'S' THEN
       lobjDetalle.cdRamoParametro := lvaGrupoProducto||'A';
      ELSE
       lobjDetalle.cdRamoParametro := lvaGrupoProducto||'R';
      END IF;

     ELSIF lvaCdRamo = '012' THEN
      --Para identificar el tipo de cobertura Bancaria, Fidelidad, Construcci?n ...
      OPEN lcuGrupoCobertura;
      FETCH lcuGrupoCobertura INTO lvaCdGrupoCobertura;
      CLOSE lcuGrupoCobertura;
      lobjDetalle.cdRamoParametro := lvaCdRamo||lvaCdGrupoCobertura;
     ELSE
      -- Solicitud via email de German Duque y Manuel Guevara el viernes, 17 de abril de 2015 04:19 p.m.
      -- con titulo Seguimiento BI Panam?
      lobjDetalle.cdRamoParametro := lvaCdramoContable;
--      lobjDetalle.cdRamoParametro := lvaCdRamo;
     END IF;
    END IF;

    lobjDetalle.cdOperacion                := reg.cdoperacion;

    lobjDetalle.cdConcepto                 := lvaCdConcepto;

    --Se comenta por solicitud de cat?logo de servicio 85529 Solicitada por Mario Franco y afirmada por SAP
    -- y se deja concatenando el codigo del usuario
    lobjDetalle.dsTextoPosicion            := lvaNmExpediente||'-'||lvaDsLoginUsuario;
    --lobjDetalle.dsTextoPosicion            := lvaNmExpediente||'-'||'FONDO AHORRO Y VLR CESION';

    IF lnuContadorDetalle = 1 THEN
       lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
    ELSE
       lobjTabDetalles.Extend;
       lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
    END IF;
   END LOOP;

   FOR reg IN lcuDetalleSumadosDeducible LOOP
    IF reg.DEDUCIBLE <> 0 THEN
     lvaCdRamo                       := reg.CDRAMO;
     lvaCdSubramo                    := reg.CDSUBRAMO;
     lvaCdGarantia                   := reg.CDGARANTIA;
     lvaCdSubGarantia                := reg.CDSUBGARANTIA;
     lvaAplicaReservaSinRetencion    := NVL(PCK_PARAMETROS.FN_GET_PARAMETROV2('%',
                                                                              '%',
                                                                              'RESERVASINRETEN',
                                                                              SYSDATE,
                                                                              reg.NUMERO_RESERVA,
                                                                              '%',
                                                                              '%',
                                                                              '%',
                                                                              '%'), 'N');

     lobjDetalle.cdIndicadorImpuesto := lvaCodIva;
     -- 01/12/2024 josebuvi VERIFICACION DE VIDA PARA INDICADOR IMPUESTO
     -- linaduto - 2025/03/11 - HU756348 -Ajuste retenci?n en la fuente para ID NIT - subramos PCP y deudores
     -- linaduto - 2025/03/20 - HU764049 -Ajuste retenci?n en la fuente para ID NIT - Ramo BAN
     -- luishure - 2025/12/10 - HU984785 - Exclusión de retención para Fondo de Ahorro
     IF (lvaCdRamo = '081' OR lvaCdRamo = 'BAN') AND lvaCdGarantia = 'VID' AND lvaAplicaReservaSinRetencion = 'N' THEN
       IF (lvaAplicaSinRetencion = 'N' OR (lvaAplicaSinRetencion = 'S' AND substr(lvaDni,1,1) <> 'A')) THEN
          lnuContadorRetencionVida             := lnuContadorRetencionVida + 1;
          IF lnuContadorRetencionVida = 1 THEN
          lnuContadorRetencion               := lnuContadorRetencion + 1;
          lobjRetencion.cdtipoRetencion      := 'F5';
          lobjRetencion.cdindicadorRetencion := 'VI';
          IF lnuContadorRetencion = 1 THEN
            lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
          ELSE
            lobjRetenciones.Extend;
            lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
          END IF;
          lobjDocumento.retenciones := lobjRetenciones;
          END IF;	 
       END IF; 
     END IF;
     lobjDetalle.cdConcepto          := '8';
     lvaSnCuentaContable             := 'N';

     OPEN lcuTipoReserva;
     FETCH lcuTipoReserva INTO lvaCdTipoReserva,lvaCdramoContable;
     CLOSE lcuTipoReserva;

     lnuContadorDetalle              := lnuContadorDetalle + 1;
     lobjDetalle.cdTipoReserva       := lvaCdTipoReserva;

     OPEN lcuSnCuentaContable;
     FETCH lcuSnCuentaContable INTO lvaSnCuentaContable;
     CLOSE lcuSnCuentaContable;

     IF lvaCdRamo = '081' AND lvaCdTipoReserva = 'T' THEN
--      lobjDetalle.cdRamo              := 'MVI';
      lobjDetalle.cdRamo              := 'AAV';
     ELSE
      lobjDetalle.cdRamo              := lvaCdramoContable;
     END IF;

     lobjDetalle.nmPoliza            := lvaNmPoliza;

     lobjDetalle.cdIntermediario     := lvaCdAgente;
     lobjDetalle.cdOficinaRadicacion := lvaCdDelegacionRadica;
     lobjDetalle.nmExpediente        := lvaNmExpediente;

     lobjDetalle.nmAsegurado         := lvaNmAsegurado;
     lobjDetalle.ptImporte           := reg.DEDUCIBLE;

     lobjDetalle.cdCentroCostos      := lvaCdDelegacionRadica;

     lobjDetalle.feAviso             := ldaFenotificacion;
     lobjDetalle.feOcurrencia        := ldaFeOcurrencia;

     PCK_GESTION_PRODUCTOS.SPGET_COMPANIA_PRODUCTO( reg.cdramo,reg.cdsubramo,lvaCdCompania,lvaCdciaMatriz,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);
     -- Se comenta esta l?nea por cambio de Panam?.
--     lobjDetalle.cdCompaniaParametro := lvaCdCompania;

    -- Panam? 20130722 Compa??a = 30 En Colombia es cdciaMatriz en SAP es 3000
     IF lvaCdciaMatriz = '00' THEN
      lobjDetalle.cdCompaniaParametro := lvaCdCompania;
     ELSIF lvaCdciaMatriz = '30' THEN
      lobjDetalle.cdCompaniaParametro := lvaCdciaMatriz;
     ELSE
      lobjDetalle.cdCompaniaParametro := lvaCdCompania;
     END IF;

     IF lvaCdciaMatriz = '00' THEN
      IF lvaCdRamo = '041' THEN
       lobjDetalle.cdRamoParametro := '041';
      ELSIF lvaCdRamo = '092' THEN
       lobjDetalle.cdRamoParametro := '092';
      ELSIF lvaSnCuentaContable = 'S' THEN
       lobjDetalle.cdRamoParametro := lvaCdramoContable;
      ELSE
        lobjDetalle.cdRamoParametro := 'N';
      END IF;
     ELSIF lvaCdciaMatriz = '30' THEN
      --Para panam? el indicador de impuesto para el deducible es cero.
      lobjDetalle.cdIndicadorImpuesto := '0';
      IF lvaCdRamo = '081' THEN
       lvaSnPrimerVigencia := 'S';
       OPEN lcuPrimerVigencia;
       FETCH lcuPrimerVigencia INTO lvaSnPrimerVigencia;
       IF lcuPrimerVigencia%NOTFOUND THEN
        lvaSnPrimerVigencia := 'N';
       END IF;
       CLOSE lcuPrimerVigencia;
       --Para identificar si es Universal o tradicional.
       OPEN lcuGrupoProducto;
       FETCH lcuGrupoProducto INTO lvaGrupoProducto;
       CLOSE lcuGrupoProducto;

       IF lvaSnPrimerVigencia = 'S' THEN
        lobjDetalle.cdRamoParametro := lvaGrupoProducto||'A';
       ELSE
        lobjDetalle.cdRamoParametro := lvaGrupoProducto||'R';
       END IF;

      ELSIF lvaCdRamo = '012' THEN
       --Para identificar el tipo de cobertura Bancaria, Fidelidad, Construcci?n ...
       OPEN lcuGrupoCobertura;
       FETCH lcuGrupoCobertura INTO lvaCdGrupoCobertura;
       CLOSE lcuGrupoCobertura;
       lobjDetalle.cdRamoParametro := lvaCdRamo||lvaCdGrupoCobertura;
      ELSE
       -- Solicitud via email de German Duque y Manuel Guevara el viernes, 17 de abril de 2015 04:19 p.m.
       -- con titulo Seguimiento BI Panam?
       lobjDetalle.cdRamoParametro := lvaCdramoContable;
       --lobjDetalle.cdRamoParametro := lvaCdRamo;
      END IF;
     END IF;

     lobjDetalle.cdOperacion   := reg.cdoperacion;

--     lobjDetalle.cdConcepto    := lvaCdConcepto;

     --Se comenta por solicitud de cat?logo de servicio 85529 Solicitada por Mario Franco y afirmada por SAP
     -- y se deja concatenando el codigo del usuario
     lobjDetalle.dsTextoPosicion            := lvaNmExpediente||'-'||lvaDsLoginUsuario;
     --lobjDetalle.dsTextoPosicion             := lvaNmExpediente||'-'||'DEDUCIBLE';

     IF lnuContadorDetalle = 1 THEN
      lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
     ELSE
      lobjTabDetalles.Extend;
      lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
     END IF;
    END IF;
   END LOOP;

   --  Coaseguro
   -- Panam? Coaseguro Aceptado
   IF lvaCdciaMatriz = '30' THEN
    lvaTipoCoaseguro := NULL;
    OPEN lcuTipoCoaseguro;
    FETCH lcuTipoCoaseguro INTO lvaTipoCoaseguro;
    CLOSE lcuTipoCoaseguro;
    IF lvaTipoCoaseguro = 'A' THEN
     lobjDetalle.cdConcepto := lobjDetalle.cdConcepto||'A';
    END IF;
   END IF;
    -- Cedido
   IF lvaIdSoloSura <> '01' THEN
    FOR reg IN lcuDetalleSumadosCoaseguro LOOP
     IF reg.COASEGURO <> 0 THEN
      lvaCdRamo                       := reg.CDRAMO;
      lvaCdSubramo                    := reg.CDSUBRAMO;
      lvaCdGarantia                   := reg.CDGARANTIA;
      lvaCdSubGarantia                := reg.CDSUBGARANTIA;
      lvaAplicaReservaSinRetencion    := NVL(PCK_PARAMETROS.FN_GET_PARAMETROV2('%',
                                                                               '%',
                                                                               'RESERVASINRETEN',
                                                                               SYSDATE,
                                                                               reg.NUMERO_RESERVA,
                                                                               '%',
                                                                               '%',
                                                                               '%',
                                                                               '%'), 'N');

      lobjDetalle.cdIndicadorImpuesto := /*'0000';--*/lvaCodIva;
      -- 01/12/2024 josebuvi VERIFICACION DE VIDA PARA INDICADOR IMPUESTO
      -- linaduto - 2025/03/11 - HU756348 -Ajuste retenci?n en la fuente para ID NIT - subramos PCP y deudores
      -- linaduto - 2025/03/20 - HU764049 -Ajuste retenci?n en la fuente para ID NIT - Ramo BAN
      -- luishure - 2025/12/10 - HU984785 - Exclusión de retención para Fondo de Ahorro
      IF (lvaCdRamo = '081' OR lvaCdRamo = 'BAN') AND lvaCdGarantia = 'VID' AND lvaAplicaReservaSinRetencion = 'N' THEN
        IF (lvaAplicaSinRetencion = 'N' OR (lvaAplicaSinRetencion = 'S' AND substr(lvaDni,1,1) <> 'A')) THEN
          lnuContadorRetencionVida             := lnuContadorRetencionVida + 1;
          IF lnuContadorRetencionVida = 1 THEN
            lnuContadorRetencion               := lnuContadorRetencion + 1;
            lobjRetencion.cdtipoRetencion      := 'F5';
            lobjRetencion.cdindicadorRetencion := 'VI';
            IF lnuContadorRetencion = 1 THEN
              lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
            ELSE
              lobjRetenciones.Extend;
              lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
            END IF;
            lobjDocumento.retenciones := lobjRetenciones;
          END IF;	                    
        END IF;
      END IF;
      lobjDetalle.cdConcepto          := '1C';
      lvaSnCuentaContable             := 'N';

      OPEN lcuTipoReserva;
      FETCH lcuTipoReserva INTO lvaCdTipoReserva,lvaCdramoContable;
      CLOSE lcuTipoReserva;

      lnuContadorDetalle              := lnuContadorDetalle + 1;
      lobjDetalle.cdTipoReserva       := lvaCdTipoReserva;

      OPEN lcuSnCuentaContable;
      FETCH lcuSnCuentaContable INTO lvaSnCuentaContable;
      CLOSE lcuSnCuentaContable;

      IF lvaCdRamo = '081' AND lvaCdTipoReserva = 'T' THEN
       lobjDetalle.cdRamo              := 'AAV';
      ELSE
       lobjDetalle.cdRamo              := lvaCdramoContable;
      END IF;

      lobjDetalle.nmPoliza            := lvaNmPoliza;

      lobjDetalle.cdIntermediario     := lvaCdAgente;
      lobjDetalle.cdOficinaRadicacion := lvaCdDelegacionRadica;
      lobjDetalle.nmExpediente        := lvaNmExpediente;

      -- Para coaseguro, se tiene en el campo nmAsegurado el DNI de la Coaseguradora
      lvaCdCiaCoaseguradora := reg.CDCIA;
      OPEN lcuCiaCoaseguradora;
      FETCH lcuCiaCoaseguradora INTO lvaDniCoaseguro;--lobjDetalle.nmAsegurado;
      CLOSE lcuCiaCoaseguradora;
      lobjDetalle.nmAsegurado := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(lvaDniCoaseguro);


      lobjDetalle.ptImporte           := reg.COASEGURO;

      lobjDetalle.cdCentroCostos      := lvaCdDelegacionRadica;

      lobjDetalle.feAviso             := ldaFenotificacion;
      lobjDetalle.feOcurrencia        := ldaFeOcurrencia;

      -- Panam? 20130722 Compa??a = 30 En Colombia es cdciaMatriz en SAP es 3000
      PCK_GESTION_PRODUCTOS.SPGET_COMPANIA_PRODUCTO( reg.cdramo,reg.cdsubramo,lvaCdCompania,lvaCdciaMatriz,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);
      IF lvaCdciaMatriz = '00' THEN
       lobjDetalle.cdCompaniaParametro := lvaCdCompania;
      ELSIF lvaCdciaMatriz = '30' THEN
       lobjDetalle.cdCompaniaParametro := lvaCdciaMatriz;
      ELSE
       lobjDetalle.cdCompaniaParametro := lvaCdCompania;
      END IF;

      IF lvaCdciaMatriz = '00' THEN
       IF lvaCdRamo = '041' THEN
        lobjDetalle.cdRamoParametro := '041';
       ELSIF lvaCdRamo = '092' THEN
        lobjDetalle.cdRamoParametro := '092';
       ELSIF lvaSnCuentaContable = 'S' THEN
        lobjDetalle.cdRamoParametro := lvaCdramoContable;
       ELSE
        lobjDetalle.cdRamoParametro := 'N';
       END IF;
      ELSIF lvaCdciaMatriz = '30' THEN
       --20131023 De acuerdo a email de German Duque siempre va  lobjDetalle.cdRamoParametro = N
       -- por eso se comenta todo el IF para ramo 081 y 012
--       lobjDetalle.cdRamoParametro := 'N';
       IF lvaCdRamo = '081' THEN
        lvaSnPrimerVigencia := 'S';
        OPEN lcuPrimerVigencia;
        FETCH lcuPrimerVigencia INTO lvaSnPrimerVigencia;
        IF lcuPrimerVigencia%NOTFOUND THEN
         lvaSnPrimerVigencia := 'N';
        END IF;
        CLOSE lcuPrimerVigencia;
        --Para identificar si es Universal o tradicional.
        OPEN lcuGrupoProducto;
        FETCH lcuGrupoProducto INTO lvaGrupoProducto;
        CLOSE lcuGrupoProducto;

        IF lvaSnPrimerVigencia = 'S' THEN
         lobjDetalle.cdRamoParametro := lvaGrupoProducto||'A';
        ELSE
         lobjDetalle.cdRamoParametro := lvaGrupoProducto||'R';
        END IF;

       ELSIF lvaCdRamo = '012' THEN
        --Para identificar el tipo de cobertura Bancaria, Fidelidad, Construcci?n ...
        OPEN lcuGrupoCobertura;
        FETCH lcuGrupoCobertura INTO lvaCdGrupoCobertura;
        CLOSE lcuGrupoCobertura;
        lobjDetalle.cdRamoParametro := lvaCdRamo||lvaCdGrupoCobertura;
       ELSE
        -- Solicitud via email de German Duque y Manuel Guevara el viernes, 17 de abril de 2015 04:19 p.m.
        -- con titulo Seguimiento BI Panam?
        lobjDetalle.cdRamoParametro := lvaCdramoContable;
        --lobjDetalle.cdRamoParametro := lvaCdRamo;
       END IF;
      END IF;
      lobjDetalle.cdOperacion   := reg.cdoperacion;

      --Se comenta por solicitud de cat?logo de servicio 85529 Solicitada por Mario Franco y afirmada por SAP
      -- y se deja concatenando el codigo del usuario
      lobjDetalle.dsTextoPosicion            := lvaNmExpediente||'-'||lvaDsLoginUsuario;
      --lobjDetalle.dsTextoPosicion             := lvaNmExpediente||'-'||' COASEGURO CEDIDO';

      IF lnuContadorDetalle = 1 THEN
       lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
      ELSE
       lobjTabDetalles.Extend;
       lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
      END IF;
     END IF;
    END LOOP;
   END IF;
   -- Fin de coaseguro

   FOR reg IN lcuDetalleSumadosDescuento LOOP
    IF reg.PTDESCUENTO <> 0 THEN
     lvaCdRamo                       := reg.CDRAMO;
     lvaCdSubramo                    := reg.CDSUBRAMO;
     lvaCdGarantia                   := reg.CDGARANTIA;
     lvaCdSubGarantia                := reg.CDSUBGARANTIA;
     lvaAplicaReservaSinRetencion    := NVL(PCK_PARAMETROS.FN_GET_PARAMETROV2('%',
                                                                              '%',
                                                                              'RESERVASINRETEN',
                                                                              SYSDATE,
                                                                              reg.NUMERO_RESERVA,
                                                                              '%',
                                                                              '%',
                                                                              '%',
                                                                              '%'), 'N');

     lobjDetalle.cdIndicadorImpuesto := '0000';--lvaCodIva;
     -- 01/12/2024 josebuvi VERIFICACION DE VIDA PARA INDICADOR IMPUESTO
     -- linaduto - 2025/03/11 - HU756348 -Ajuste retenci?n en la fuente para ID NIT - subramos PCP y deudores
     -- linaduto - 2025/03/20 - HU764049 -Ajuste retenci?n en la fuente para ID NIT - Ramo BAN
     -- luishure - 2025/12/10 - HU984785 - Exclusión de retención para Fondo de Ahorro
     IF (lvaCdRamo = '081' OR lvaCdRamo = 'BAN') AND lvaCdGarantia = 'VID' AND lvaAplicaReservaSinRetencion = 'N' THEN
       IF (lvaAplicaSinRetencion = 'N' OR (lvaAplicaSinRetencion = 'S' AND substr(lvaDni,1,1) <> 'A')) THEN
          lnuContadorRetencionVida             := lnuContadorRetencionVida + 1;
          IF lnuContadorRetencionVida = 1 THEN
          lnuContadorRetencion               := lnuContadorRetencion + 1;
          lobjRetencion.cdtipoRetencion      := 'F5';
          lobjRetencion.cdindicadorRetencion := 'VI';
          IF lnuContadorRetencion = 1 THEN
            lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
          ELSE
            lobjRetenciones.Extend;
            lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
          END IF;
          lobjDocumento.retenciones := lobjRetenciones;
          END IF;	 
       END IF; 
     END IF;
     lobjDetalle.cdConcepto          := '9';
     lvaSnCuentaContable             := 'N';

     OPEN lcuTipoReserva;
     FETCH lcuTipoReserva INTO lvaCdTipoReserva,lvaCdramoContable;
     CLOSE lcuTipoReserva;

     lnuContadorDetalle              := lnuContadorDetalle + 1;
     lobjDetalle.cdTipoReserva       := lvaCdTipoReserva;

     OPEN lcuSnCuentaContable;
     FETCH lcuSnCuentaContable INTO lvaSnCuentaContable;
     CLOSE lcuSnCuentaContable;

     IF lvaCdRamo = '081' AND lvaCdTipoReserva = 'T' THEN
--      lobjDetalle.cdRamo              := 'MVI';
      lobjDetalle.cdRamo              := 'AAV';
     ELSE
      lobjDetalle.cdRamo              := lvaCdramoContable;
     END IF;

     lobjDetalle.nmPoliza            := lvaNmPoliza;

     lobjDetalle.cdIntermediario     := lvaCdAgente;
     lobjDetalle.cdOficinaRadicacion := lvaCdDelegacionRadica;
     lobjDetalle.nmExpediente        := lvaNmExpediente;

     lobjDetalle.nmAsegurado         := lvaNmAsegurado;
     lobjDetalle.ptImporte           := reg.PTDESCUENTO;

     lobjDetalle.cdCentroCostos      := lvaCdDelegacionRadica;

     lobjDetalle.feAviso             := ldaFenotificacion;
     lobjDetalle.feOcurrencia        := ldaFeOcurrencia;

     -- Panam? 20130722 Compa??a = 30 En Colombia es cdciaMatriz en SAP es 3000
     PCK_GESTION_PRODUCTOS.SPGET_COMPANIA_PRODUCTO( reg.cdramo,reg.cdsubramo,lvaCdCompania,lvaCdciaMatriz,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);
     IF lvaCdciaMatriz = '00' THEN
      lobjDetalle.cdCompaniaParametro := lvaCdCompania;
     ELSIF lvaCdciaMatriz = '30' THEN
      lobjDetalle.cdCompaniaParametro := lvaCdciaMatriz;
     ELSE
      lobjDetalle.cdCompaniaParametro := lvaCdCompania;
     END IF;

     IF lvaCdciaMatriz = '00' THEN
      IF lvaCdRamo = '041' THEN
       lobjDetalle.cdRamoParametro := '041';
      ELSIF lvaCdRamo = '092' THEN
       lobjDetalle.cdRamoParametro := '092';
      ELSIF lvaSnCuentaContable = 'S' THEN
       lobjDetalle.cdRamoParametro := lvaCdramoContable;
      ELSE
       lobjDetalle.cdRamoParametro := 'N';
      END IF;
     ELSIF lvaCdciaMatriz = '30' THEN
      IF lvaCdRamo = '081' THEN
       lvaSnPrimerVigencia := 'S';
       OPEN lcuPrimerVigencia;
       FETCH lcuPrimerVigencia INTO lvaSnPrimerVigencia;
       IF lcuPrimerVigencia%NOTFOUND THEN
        lvaSnPrimerVigencia := 'N';
       END IF;
       CLOSE lcuPrimerVigencia;
       --Para identificar si es Universal o tradicional.
       OPEN lcuGrupoProducto;
       FETCH lcuGrupoProducto INTO lvaGrupoProducto;
       CLOSE lcuGrupoProducto;

       IF lvaSnPrimerVigencia = 'S' THEN
        lobjDetalle.cdRamoParametro := lvaGrupoProducto||'A';
       ELSE
        lobjDetalle.cdRamoParametro := lvaGrupoProducto||'R';
       END IF;

      ELSIF lvaCdRamo = '012' THEN
       --Para identificar el tipo de cobertura Bancaria, Fidelidad, Construcci?n ...
       OPEN lcuGrupoCobertura;
       FETCH lcuGrupoCobertura INTO lvaCdGrupoCobertura;
       CLOSE lcuGrupoCobertura;
       lobjDetalle.cdRamoParametro := lvaCdRamo||lvaCdGrupoCobertura;
      ELSE
        -- Solicitud via email de German Duque y Manuel Guevara el viernes, 17 de abril de 2015 04:19 p.m.
        -- con titulo Seguimiento BI Panam?
        lobjDetalle.cdRamoParametro := lvaCdramoContable;
--      lobjDetalle.cdRamoParametro := lvaCdRamo;
      END IF;
     END IF;

     lobjDetalle.cdOperacion   := reg.cdoperacion;

--    lobjDetalle.cdConcepto    := lvaCdConcepto;

     --Se comenta por solicitud de cat?logo de servicio 85529 Solicitada por Mario Franco y afirmada por SAP
     -- y se deja concatenando el codigo del usuario
     lobjDetalle.dsTextoPosicion            := lvaNmExpediente||'-'||lvaDsLoginUsuario;
     --lobjDetalle.dsTextoPosicion             := lvaNmExpediente||'-'||' DESCUENTO FINANCIERO';

     IF lnuContadorDetalle = 1 THEN
      lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
     ELSE
      lobjTabDetalles.Extend;
      lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
     END IF;
    END IF;
   END LOOP;



   lobjDocumento.detalleSiniestros                   := lobjTabDetalles;

/*   FOR i IN lobjTabDetalles.FIRST..lobjTabDetalles.LAST LOOP
       DBMS_OUTPUT.put_line('Detalle 1: '||lobjTabDetalles(i).ptImporte);
   END LOOP;
*/
   lobjDocumento.cuentaBancaria := lobjCuentaBancaria;

   IF lnuContadorDocumentos = 1 THEN
    lobjDocumentos(lnuContadorDocumentos) := lobjDocumento;
   ELSE
    lobjDocumentos.Extend;
    lobjDocumentos(lnuContadorDocumentos) := lobjDocumento;
   END IF;
  lnuContadorRetencionVida := 0;
  END LOOP;-- lcuDatosDocumentoFyC

----------------------------------------------------------------------------------------------------------------------
  lobjTabDetalles := tab_sap_detalles_cxp_sini(obj_sap_detalle_cxp_sini());
  lobjRetenciones := tab_sap_datos_retenciones(obj_sap_dato_retencion());
  lobjDocumento   := obj_sap_documento_cxp_sini();
  lobjRetencion   := obj_sap_dato_retencion();
  lobjDetalle     := obj_sap_detalle_cxp_sini();
  FOR doc IN lcuDatosDocumentoRes LOOP

   lvaCodIva                          := LPAD(REPLACE(TO_CHAR(RPAD(DOC.POIRPF,4,'0')),'.',''),4,'0');
   -- 8/10/2025. HT918841 - Códigos de retención específicos. luishure 
   IF lvaCodIva = '1900' AND PCK_PARAMETROS.FN_GET_PARAMETROV2('%','%','GET_INDICADOR',SYSDATE, DOC.CDRETENCION ,'*','*','*','*') IS NOT NULL THEN
     lvaCodIva                        := PCK_PARAMETROS.FN_GET_PARAMETROV2('%','%','GET_INDICADOR',SYSDATE, DOC.CDRETENCION ,'*','*','*','*');
   END IF;
   lvaPoIrpf                          := doc.POIRPF;
   lvaPoirc                           := doc.POIRC;
   lvaPoIca                           := doc.POICA;
   lvaCdRetencion                     := doc.CDRETENCION;
   lvaCdTipoReserva                   := doc.CDTIPO_RESERVA;


   lnuContadorDocumentos              := lnuContadorDocumentos + 1;
   lobjDocumento                      := OBJ_SAP_DOCUMENTO_CXP_SINI();

   lobjDocumento.nmBeneficiarioPago   := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(lvaDni);
   lobjDocumento.cdTipoIdentificacion := PCK_SIC_UTILITARIOS_I.FN_SIC_CDTIPO_IDENTIFICACION(lvaDni);

   -- 17/07/2025 Mateo Zapata - Homologacion de tipo de documento TT para SAP
   IF UPPER(lobjDocumento.cdTipoIdentificacion) = 'TT' THEN
     lobjDocumento.cdTipoIdentificacion := 'PT';
   END IF;

   --Panam?. Digito Verificacion
   IF lvaCdciaMatriz = '30' THEN
    IF lvaDigitoVerificacion IS NOT NULL THEN
--SAP va a poner el d?gito de verificaci?n.
NULL;
--     lobjDocumento.nmBeneficiarioPago := lobjDocumento.nmBeneficiarioPago||':'||lvaDigitoVerificacion;
    END IF;
   END IF;
   lobjDocumento.cdOficinaRegistro    := lvaCdOficinaRegistro;

   IF lvaSnPolizaSalud = 'S' THEN
     lobjDocumento.ptImporte := doc.importe_sin_desc;
   ELSE
     lobjDocumento.ptImporte := doc.importe;
   END IF;

   lobjDocumento.snCalcularImpuestos  := lvaSnCalcularImpuestos;
   lobjDocumento.cdIva                := NULL;--lvaCodIva;
   lobjDocumento.fePosiblePago        := lvaFeposiblePago;

   -- Variable de control para evitar Saldo en moneda de transaccion
   lnuTotalPago                       := lobjDocumento.ptImporte;

   lobjDocumento.condicionPago        := lobjCondicionPago;
   lobjDocumento.cdViaPago            := lvaCdViaPago;
   lobjDocumento.cdBloqueoPago        := lvaCdbloqueoPago;
   lobjDocumento.dsTextoPosicion      := lvaDsTextoPosicion;
   lobjDocumento.nmPoliza             := lvaNmPoliza;
   IF lvaCdRamo = 'BAN' THEN
    lobjDocumento.cdRamo               := lvaCdRamo||lvaCdSubRamo;
   ELSE
    lobjDocumento.cdRamo               := lvaCdRamo;
   END IF;
   --se debe revisar como obtener la operacion del neto
   lobjDocumento.cdOperacion          := lvaCdOperacion;
   lobjDocumento.cdTipoReserva        := doc.CDTIPO_RESERVA;

   -- Para atender la solicitud de catatalogo de servicio nro. 71527 de 02/04/2013 09:17:02 por Luis Gmo. Freyre
   IF lvaCdciaMatriz = '00' THEN
    IF doc.CDTRIBUTARIA = 'N' AND doc.CDRETENCION NOT IN ('0029','0028') THEN
     lobjDocumento.cdOperacion          := lobjDocumento.cdOperacion ||'P';
    END IF;
   ELSIF lvaCdciaMatriz = '30' THEN
   -- Panam? En la coexistencia, no se pregunta por reembolso.  Solo se lee de personas si es proveedor
--    IF doc.CDTRIBUTARIA = 'N' THEN
     OPEN lcuProveedor;
     FETCH lcuProveedor INTO lvaSnProveedorPanama;
     IF lcuProveedor%FOUND THEN
      lobjDocumento.cdOperacion := lobjDocumento.cdOperacion ||'P';
     END IF;
     CLOSE lcuProveedor;
--    END IF;
     IF lvaCdRamo = '030' THEN
      lvaSnRiesgoExterior  := PCK_SIN_ADAPTADOR_SAP.FN_RIESGO_EXTERIOR (lvaNmPoliza,lvaNmCertificado,lvaMensajeTecnicoExt, lvaMensajeUsuarioExt);
      IF lvaSnRiesgoExterior = 'S' THEN
       lobjDocumento.cdOperacion := lobjDocumento.cdOperacion ||'E';
      END IF;
     END IF;

   END IF;

   --Llenado de la tabla de Retenciones.
   -- Panam?. no se llevan las retenciones
   IF lvaCdciaMatriz = '00' THEN

    lvaCdRetencion                   := doc.CDRETENCION;
    lnuImpIrc                        := doc.IMPIRC;
    lnuImpIrpfRetenido               := doc.IMPIRPF_RETENIDO;
    lnuImpIca                        := doc.IMPICA;

    lnuContadorRetencion             := 0;
    lobjRetenciones                  := TAB_SAP_DATOS_RETENCIONES(OBJ_SAP_DATO_RETENCION());

    --Con el cambio de retenciones, en el legacy se llevan a cero y es SAP quien las calcula
    --Se comenta como estaba anteriomente y se llevan solo si hay c?digo de retencion
    --IF NVL(lnuImpIrc,0) <> 0 THEN
    IF NVL(lvaCdRetencion,0) NOT IN ('0099','0000')  THEN
     lnuContadorRetencion                := lnuContadorRetencion + 1;
     lobjRetencion.cdtipoRetencion       := lvaCdRetencion;
     lobjRetencion.cdindicadorRetencion  := 'R';
     lobjRetencion.ptBaseRetencion       := doc.BASEIMPUESTOS;
     lobjRetencion.ptRetencion           := doc.IMPIRC;
     IF lnuContadorRetencion = 1 THEN
      lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
     ELSE
      lobjRetenciones.Extend;
      lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
     END IF;
    END IF;

    --Con el cambio de retenciones, en el legacy se llevan a cero y es SAP quien las calcula
    --Se comenta como estaba anteriomente y se llevan solo si hay c?digo de retencion
    --IF NVL(lnuImpIrpfRetenido,0) <> 0 THEN
    IF NVL(lvaCdRetencion,0) NOT IN ('0099','0000')  THEN
     lnuContadorRetencion                := lnuContadorRetencion + 1;
     lobjRetencion.cdtipoRetencion       := lvaCdRetencion;
     lobjRetencion.cdindicadorRetencion  := 'I';
     --Se comenta esta l?nea por el cambio de calculo de retenci?n desde SAP y avisado desde la devuelta.
     --para la base se env?a el valor del IVA doc.IMPIRPF y no la base de toda la retenci?n como se ten?a acostumbrado.
     --    lobjRetencion.ptBaseRetencion       := doc.BASEIMPUESTOS;
     lobjRetencion.ptBaseRetencion       := doc.IMPIRPF;
     lobjRetencion.ptRetencion           := doc.IMPIRPF_RETENIDO;
     IF lnuContadorRetencion = 1 THEN
      lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
     ELSE
      lobjRetenciones.Extend;
      lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
     END IF;
    END IF;

    -- Retencion de IVA R?gimen Simplificado
    -- Por requerimiento de Fredy Rios enviado el Martes 2010/2/23 01:47 p.m.
    -- se elimina el regimen simplificado para los ramos de personas.
    IF lvaCdCompania IN ('01') THEN
     OPEN lcuSnIva;
     FETCH lcuSnIva INTO lvaSnIva;
     IF lcuSnIva%NOTFOUND THEN
      lvaSnIva := 'N';
     END IF;
     CLOSE lcuSnIva;
     IF NVL(lnuImpIrpfRetenido,0) = 0 AND lvaSnIva = 'N' AND doc.CDTRIBUTARIA = 'N'
        AND pck_sic_utilitarios.fn_sic_naturaleza_dni(lobjDocumento.cdTipoIdentificacion) <> 'JJURIDICO' THEN
      lnuPoBaseRetencion                  := 0;
      OPEN lcuPoBaseRetencion;
      FETCH lcuPoBaseRetencion INTO lnuPoBaseRetencion;
      CLOSE lcuPoBaseRetencion;

      lnuPoRetencion                      := 0;
      OPEN lcuPoRetencion;
      FETCH lcuPoRetencion INTO lnuPoRetencion;
      CLOSE lcuPoRetencion;
      --Con el cambio de impuestos calculados desde SAP y que vienen en la devuelta,
      lnuReteIvaSimplificado               := doc.BASEIMPUESTOS * ((lnuPoRetencion*lnuPoBaseRetencion)/100);
      IF lnuReteIvaSimplificado <> 0 THEN
       lnuContadorRetencion                := lnuContadorRetencion + 1;
       lobjRetencion.cdtipoRetencion       := lvaCdRetencion;
       lobjRetencion.cdindicadorRetencion  := 'S';
       lobjRetencion.ptBaseRetencion       := doc.BASEIMPUESTOS;
       lobjRetencion.ptRetencion           := lnuReteIvaSimplificado;

       IF lnuContadorRetencion = 1 THEN
        lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
       ELSE
        lobjRetenciones.Extend;
        lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
       END IF;
      END IF;
     END IF;
    END IF;

    --Con el cambio de retenciones, en el legacy se llevan a cero y es SAP quien las calcula
    --Se comenta como estaba anteriomente y se llevan solo si hay c?digo de retencion
    --IF NVL(lnuImpIca,0) <> 0 THEN
    IF NVL(lvaCdRetencion,0) NOT IN ('0099','0000')  THEN
     OPEN lcuMunicipioIca;
     FETCH lcuMunicipioIca INTO lvaMunicipioIca;
     CLOSE lcuMunicipioIca;
     lnuContadorRetencion                := lnuContadorRetencion + 1;
     lobjRetencion.cdtipoRetencion       := lvaCdRetencion;
     lobjRetencion.cdindicadorRetencion  := lvaMunicipioIca;
     lobjRetencion.ptBaseRetencion       := doc.BASEIMPUESTOS;
     lobjRetencion.ptRetencion           := doc.IMPICA;
     IF lnuContadorRetencion = 1 THEN
      lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
     ELSE
      lobjRetenciones.Extend;
      lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
     END IF;
    END IF;
    lobjDocumento.retenciones        := lobjRetenciones;
   END IF;

   IF doc.CDTIPO_RESERVA = 'T' THEN
    lvaCdConcepto  := '1';
	-- JuanAlNo Se realiza validacion si son subramos que pertenecen a los productos de Salud para todos integral 
    IF lvaCdSubRamo in ('PVF','PVC') THEN
	 FOR cur IN lcuDatosTempGarantia LOOP
	  IF cur.CDGARANTIA = 'SK9' AND cur.CDSUBGARANTIA = 'NDX' THEN
	   lvaCdConcepto  := 'CO';
	  ELSIF cur.CDGARANTIA = 'SN4' AND cur.CDSUBGARANTIA = 'NDX' THEN
	   lvaCdConcepto  := 'MO';
	  END IF;
	 END LOOP;
    END IF;
   ELSE
    lvaCdConcepto  := '2';
   END IF;

   -- Para SOAT dar cumplimiento al FORMATO 350, German Duque en email de Jueves 2011/9/29 05:20 p.m.
   -- Nos define como actuar.  par?metro 1 = 01; par?metro 2 = 041, par?metro 3 = T, par?metro 4 = 907 o 916 y par?metro 5 = 23.
   -- El par?metro 5 es el concepto que es lo unico que cambia.
   IF lvaCdRamo = '041' AND lvaCdRetencion = '0023'  THEN
    lvaCdConcepto               := '23';
    lobjDocumento.cdBloqueoPago := 'B';
   END IF;

   -- Panama para Salvantos y Subrogaciones
   IF lvaCodigoAceptacion = 'D' THEN
    lvaCdConcepto  := '12';
   ELSIF lvaCodigoAceptacion = 'S' THEN
    lvaCdConcepto  := '10';
   END IF;

   -- Panam? Coaseguro Aceptado
   IF lvaCdciaMatriz = '30' THEN
    lvaTipoCoaseguro := NULL;
    OPEN lcuTipoCoaseguro;
    FETCH lcuTipoCoaseguro INTO lvaTipoCoaseguro;
    CLOSE lcuTipoCoaseguro;
    IF lvaTipoCoaseguro = 'A' THEN
     lvaCdConcepto := lvaCdConcepto||'A';
    END IF;
   END IF;


   lobjDocumento.cdConcepto := lvaCdConcepto;

  --Llenado de la tabla de Detalles para tipo de reserva Matematica y T?cnina.
   lnuContadorDetalle := 0;
   lobjTabDetalles := tab_sap_detalles_cxp_sini(obj_sap_detalle_cxp_sini());

   OPEN lcuDatosSiniestro;
   FETCH lcuDatosSiniestro INTO ldaFeOcurrencia, ldaFenotificacion;
   CLOSE lcuDatosSiniestro;

   lnuPorepartoCoa := 100;
   OPEN lcuSoloSuraCoaseguro;
   FETCH lcuSoloSuraCoaseguro INTO lvaIdSoloSura;
   IF lcuSoloSuraCoaseguro%FOUND THEN
    lnuPorepartoCoa := 100;
   ELSE
    OPEN lcuPorcentajeCoaseguro;
    FETCH lcuPorcentajeCoaseguro INTO lnuPorepartoCoa;
    IF lcuPorcentajeCoaseguro%NOTFOUND THEN
     lnuPorepartoCoa := 100;
    END IF;
    CLOSE lcuPorcentajeCoaseguro;
   END IF;
   CLOSE lcuSoloSuraCoaseguro;

   FOR reg IN lcuDatosPagosRes LOOP
    lvaCdRamo                       := reg.CDRAMO;
    lvaCdSubramo                    := reg.CDSUBRAMO;
    lvaCdGarantia                   := reg.CDGARANTIA;
    lvaCdSubGarantia                := reg.CDSUBGARANTIA;
    lvaAplicaReservaSinRetencion    := NVL(PCK_PARAMETROS.FN_GET_PARAMETROV2('%',
                                                                             '%',
                                                                             'RESERVASINRETEN',
                                                                             SYSDATE,
                                                                             reg.NUMERO_RESERVA,
                                                                             '%',
                                                                             '%',
                                                                             '%',
                                                                             '%'), 'N');

    lobjDetalle.cdIndicadorImpuesto := lvaCodIva;
    -- 01/12/2024 josebuvi VERIFICACION DE VIDA PARA INDICADOR IMPUESTO
    -- linaduto - 2025/03/11 - HU756348 -Ajuste retenci?n en la fuente para ID NIT - subramos PCP y deudores
    -- linaduto - 2025/03/20 - HU764049 -Ajuste retenci?n en la fuente para ID NIT - Ramo BAN
    -- luishure - 2025/12/10 - HU984785 - Exclusión de retención para Fondo de Ahorro
    IF (lvaCdRamo = '081' OR lvaCdRamo = 'BAN') AND lvaCdGarantia = 'VID' AND lvaAplicaReservaSinRetencion = 'N' THEN
      IF (lvaAplicaSinRetencion = 'N' OR (lvaAplicaSinRetencion = 'S' AND substr(lvaDni,1,1) <> 'A')) THEN  
        lnuContadorRetencionVida             := lnuContadorRetencionVida + 1;
        IF lnuContadorRetencionVida = 1 THEN
        lnuContadorRetencion               := lnuContadorRetencion + 1;
        lobjRetencion.cdtipoRetencion      := 'F5';
        lobjRetencion.cdindicadorRetencion := 'VI';
        IF lnuContadorRetencion = 1 THEN
          lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
        ELSE
          lobjRetenciones.Extend;
          lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
        END IF;
        lobjDocumento.retenciones := lobjRetenciones;
        END IF;	 
      END IF; 
    END IF;

    IF reg.numero_reserva = 'P012100' THEN
       lobjDetalle.cdConcepto          := '13';
    ELSE
       lobjDetalle.cdConcepto          := lvaCdConcepto;
    END IF;
    lvaSnCuentaContable             := 'N';


    OPEN lcuTipoReserva;
    FETCH lcuTipoReserva INTO lvaCdTipoReserva,lvaCdramoContable;
    CLOSE lcuTipoReserva;

    lnuContadorDetalle              := lnuContadorDetalle + 1;
    lobjDetalle.cdTipoReserva       := lvaCdTipoReserva;

    OPEN lcuSnCuentaContable;
    FETCH lcuSnCuentaContable INTO lvaSnCuentaContable;
    CLOSE lcuSnCuentaContable;

    IF lvaCdRamo = '081' AND lvaCdTipoReserva = 'T' THEN
--     lobjDetalle.cdRamo              := 'MVI';
     lobjDetalle.cdRamo              := 'AAV';
    ELSE
     lobjDetalle.cdRamo              := lvaCdramoContable;
    END IF;

    lobjDetalle.nmPoliza            := lvaNmPoliza;

    OPEN lcuDatosPoliza;
    FETCH lcuDatosPoliza INTO lvaCdAgente, lvaCdDelegacionRadica, ldaFeFecto, ldaFeFectoAnualidad;
    CLOSE lcuDatosPoliza;

    lobjDetalle.cdIntermediario     := lvaCdAgente;
    lobjDetalle.cdOficinaRadicacion := lvaCdDelegacionRadica;
    lobjDetalle.nmExpediente        := lvaNmExpediente;

    OPEN lcuAsegurado;
    FETCH lcuAsegurado INTO lvaDniAsegurado;
    CLOSE lcuAsegurado;
    lvaNmAsegurado := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(lvaDniAsegurado);
    lobjDetalle.nmAsegurado         := lvaNmAsegurado;
    lobjDetalle.ptImporte           := REG.IMPORTE;

    -- Variable de control para evitar Saldo en moneda de transaccion
       lnuTotalPago     := lnuTotalPago - lobjDetalle.ptImporte;


    lobjDetalle.cdCentroCostos      := lvaCdDelegacionRadica;

    OPEN lcuDatosSiniestro;
    FETCH lcuDatosSiniestro INTO ldaFeOcurrencia, ldaFenotificacion;
    CLOSE lcuDatosSiniestro;
    lobjDetalle.feAviso             := ldaFenotificacion;
    lobjDetalle.feOcurrencia        := ldaFeOcurrencia;

    -- Panam? 20130722 Compa??a = 30 En Colombia es cdciaMatriz en SAP es 3000
    PCK_GESTION_PRODUCTOS.SPGET_COMPANIA_PRODUCTO( reg.cdramo,reg.cdsubramo,lvaCdCompania,lvaCdciaMatriz,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);
    IF lvaCdciaMatriz = '00' THEN
     lobjDetalle.cdCompaniaParametro := lvaCdCompania;
    ELSIF lvaCdciaMatriz = '30' THEN
     lobjDetalle.cdCompaniaParametro := lvaCdciaMatriz;
    ELSE
     lobjDetalle.cdCompaniaParametro := lvaCdCompania;
    END IF;

    IF lvaCdciaMatriz = '00' THEN
     IF lvaCdRamo = '041' THEN
      lobjDetalle.cdRamoParametro := '041';
     ELSIF lvaCdRamo = '092' THEN
      lobjDetalle.cdRamoParametro := '092';
     ELSIF lvaSnCuentaContable = 'S' THEN
      lobjDetalle.cdRamoParametro := lvaCdramoContable;
     ELSE
      lobjDetalle.cdRamoParametro := 'N';
     END IF;
    ELSIF lvaCdciaMatriz = '30' THEN
     IF lvaCdRamo = '081' THEN
      lvaSnPrimerVigencia := 'S';
      OPEN lcuPrimerVigencia;
      FETCH lcuPrimerVigencia INTO lvaSnPrimerVigencia;
      IF lcuPrimerVigencia%NOTFOUND THEN
       lvaSnPrimerVigencia := 'N';
      END IF;
      CLOSE lcuPrimerVigencia;
      --Para identificar si es Universal o tradicional.
      OPEN lcuGrupoProducto;
      FETCH lcuGrupoProducto INTO lvaGrupoProducto;
      CLOSE lcuGrupoProducto;

      IF lvaSnPrimerVigencia = 'S' THEN
       lobjDetalle.cdRamoParametro := lvaGrupoProducto||'A';
      ELSE
       lobjDetalle.cdRamoParametro := lvaGrupoProducto||'R';
      END IF;

     ELSIF lvaCdRamo = '012' THEN
      --Para identificar el tipo de cobertura Bancaria, Fidelidad, Construcci?n ...
      OPEN lcuGrupoCobertura;
      FETCH lcuGrupoCobertura INTO lvaCdGrupoCobertura;
      CLOSE lcuGrupoCobertura;
      lobjDetalle.cdRamoParametro := lvaCdRamo||lvaCdGrupoCobertura;
     ELSE
      -- Solicitud via email de German Duque y Manuel Guevara el viernes, 17 de abril de 2015 04:19 p.m.
      -- con titulo Seguimiento BI Panam?
      lobjDetalle.cdRamoParametro := lvaCdramoContable;
--      lobjDetalle.cdRamoParametro := lvaCdRamo;
     END IF;
    END IF;

    lobjDetalle.cdOperacion         := reg.cdoperacion;


    --Se comenta por solicitud de cat?logo de servicio 85529 Solicitada por Mario Franco y afirmada por SAP
    -- y se deja concatenando el codigo del usuario
    lobjDetalle.dsTextoPosicion            := lvaNmExpediente||'-'||lvaDsLoginUsuario;
    --lobjDetalle.dsTextoPosicion             := lvaNmExpediente||'-'||'RESERVA MATEMATICA Y TECNICA';

    --Financiaciones de polizas
--    IF reg.NUMERO_RESERVA = 'P040099' THEN
-- Se modifica el if por solicitud de catalogo de servicio 77046 20/05/2013 10:27:38 por Luis Gmo. Freyre
    IF  lvaDni = 'A8110368755' OR reg.NUMERO_RESERVA = 'P040099' THEN
     lobjDetalle.cdConceptoAdicional := 'F';
    END IF;
    -- TRST-507- Modificacion gastos de siniestro (loregaar)
    -- se agrupan las reservas de gastos de siniestros en la variable: lva_rvas_gastossinsoat
    IF lvaDni = 'A8110368755' OR
       reg.NUMERO_RESERVA IN ('P012097',
                              'P012099',
                              'P012050',
                              'P012051',
                              'P012052',
                              'P012053',
                              'P012054',
                              'P012055') THEN
      lobjDetalle.cdConceptoAdicional := 'C';
    END IF;

    IF lnuContadorDetalle = 1 THEN
     lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
    ELSE
     lobjTabDetalles.Extend;
     lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
    END IF;

   END LOOP;

   FOR reg IN lcuDetalleSumadosDeducible LOOP
    IF NVL(REG.DEDUCIBLE,0) <> 0 THEN

     lvaCdRamo                       := reg.CDRAMO;
     lvaCdSubramo                    := reg.CDSUBRAMO;
     lvaCdGarantia                   := reg.CDGARANTIA;
     lvaCdSubGarantia                := reg.CDSUBGARANTIA;
     lvaAplicaReservaSinRetencion    := NVL(PCK_PARAMETROS.FN_GET_PARAMETROV2('%',
                                                                              '%',
                                                                              'RESERVASINRETEN',
                                                                              SYSDATE,
                                                                              reg.NUMERO_RESERVA,
                                                                              '%',
                                                                              '%',
                                                                              '%',
                                                                              '%'), 'N');

     lobjDetalle.cdIndicadorImpuesto := lvaCodIva;
     -- 01/12/2024 josebuvi VERIFICACION DE VIDA PARA INDICADOR IMPUESTO
     -- linaduto - 2025/03/11 - HU756348 -Ajuste retenci?n en la fuente para ID NIT - subramos PCP y deudores
     -- linaduto - 2025/03/20 - HU764049 -Ajuste retenci?n en la fuente para ID NIT - Ramo BAN
     -- luishure - 2025/12/10 - HU984785 - Exclusión de retención para Fondo de Ahorro
     IF (lvaCdRamo = '081' OR lvaCdRamo = 'BAN') AND lvaCdGarantia = 'VID' AND lvaAplicaReservaSinRetencion = 'N' THEN
       IF (lvaAplicaSinRetencion = 'N' OR (lvaAplicaSinRetencion = 'S' AND substr(lvaDni,1,1) <> 'A')) THEN
        lnuContadorRetencionVida             := lnuContadorRetencionVida + 1;
        IF lnuContadorRetencionVida = 1 THEN
        lnuContadorRetencion               := lnuContadorRetencion + 1;
        lobjRetencion.cdtipoRetencion      := 'F5';
        lobjRetencion.cdindicadorRetencion := 'VI';
        IF lnuContadorRetencion = 1 THEN
          lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
        ELSE
          lobjRetenciones.Extend;
          lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
        END IF;
        lobjDocumento.retenciones := lobjRetenciones;
        END IF;	
       END IF;  
     END IF;
     IF reg.numero_reserva = 'P012100' THEN
       lobjDetalle.cdConcepto          := '13';
     ELSE
       lobjDetalle.cdConcepto          := '8';
     END IF;
     lvaSnCuentaContable             := 'N';

     OPEN lcuTipoReserva;
     FETCH lcuTipoReserva INTO lvaCdTipoReserva,lvaCdramoContable;
     CLOSE lcuTipoReserva;

     lnuContadorDetalle              := lnuContadorDetalle + 1;
     lobjDetalle.cdTipoReserva       := lvaCdTipoReserva;

     OPEN lcuSnCuentaContable;
     FETCH lcuSnCuentaContable INTO lvaSnCuentaContable;
     CLOSE lcuSnCuentaContable;

     IF lvaCdRamo = '081' AND lvaCdTipoReserva = 'T' THEN
--      lobjDetalle.cdRamo              := 'MVI';
      lobjDetalle.cdRamo              := 'AAV';
     ELSE
      lobjDetalle.cdRamo              := lvaCdramoContable;
     END IF;

     lobjDetalle.nmPoliza            := lvaNmPoliza;

     lobjDetalle.cdIntermediario     := lvaCdAgente;
     lobjDetalle.cdOficinaRadicacion := lvaCdDelegacionRadica;
     lobjDetalle.nmExpediente        := lvaNmExpediente;

     lobjDetalle.nmAsegurado         := lvaNmAsegurado;
     lobjDetalle.ptImporte           := reg.DEDUCIBLE;

    -- Variable de control para evitar Saldo en moneda de transaccion
    lnuTotalPago                    := lnuTotalPago + lobjDetalle.ptImporte;

     lobjDetalle.cdCentroCostos      := lvaCdDelegacionRadica;

     lobjDetalle.feAviso             := ldaFenotificacion;
     lobjDetalle.feOcurrencia        := ldaFeOcurrencia;

     -- Panam? 20130722 Compa??a = 30 En Colombia es cdciaMatriz en SAP es 3000
     PCK_GESTION_PRODUCTOS.SPGET_COMPANIA_PRODUCTO( reg.cdramo,reg.cdsubramo,lvaCdCompania,lvaCdciaMatriz,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);
     IF lvaCdciaMatriz = '00' THEN
      lobjDetalle.cdCompaniaParametro := lvaCdCompania;
     ELSIF lvaCdciaMatriz = '30' THEN
      lobjDetalle.cdCompaniaParametro := lvaCdciaMatriz;
     ELSE
      lobjDetalle.cdCompaniaParametro := lvaCdCompania;
     END IF;

     IF lvaCdciaMatriz = '00' THEN
      IF lvaCdRamo = '041' THEN
       lobjDetalle.cdRamoParametro := '041';
      ELSIF lvaCdRamo = '092' THEN
       lobjDetalle.cdRamoParametro := '092';
      ELSIF lvaSnCuentaContable = 'S' THEN
       lobjDetalle.cdRamoParametro := lvaCdramoContable;
      ELSE
       lobjDetalle.cdRamoParametro := 'N';
      END IF;
     ELSIF lvaCdciaMatriz = '30' THEN
      --Para panam? el indicador de impuesto para el deducible es cero.
      lobjDetalle.cdIndicadorImpuesto := '0';
      IF lvaCdRamo = '081' THEN
       lvaSnPrimerVigencia := 'S';
       OPEN lcuPrimerVigencia;
       FETCH lcuPrimerVigencia INTO lvaSnPrimerVigencia;
       IF lcuPrimerVigencia%NOTFOUND THEN
        lvaSnPrimerVigencia := 'N';
       END IF;
       CLOSE lcuPrimerVigencia;
       --Para identificar si es Universal o tradicional.
       OPEN lcuGrupoProducto;
       FETCH lcuGrupoProducto INTO lvaGrupoProducto;
       CLOSE lcuGrupoProducto;

       IF lvaSnPrimerVigencia = 'S' THEN
        lobjDetalle.cdRamoParametro := lvaGrupoProducto||'A';
       ELSE
        lobjDetalle.cdRamoParametro := lvaGrupoProducto||'R';
       END IF;

      ELSIF lvaCdRamo = '012' THEN
       --Para identificar el tipo de cobertura Bancaria, Fidelidad, Construcci?n ...
       OPEN lcuGrupoCobertura;
       FETCH lcuGrupoCobertura INTO lvaCdGrupoCobertura;
       CLOSE lcuGrupoCobertura;
       lobjDetalle.cdRamoParametro := lvaCdRamo||lvaCdGrupoCobertura;
      ELSE
       -- Solicitud via email de German Duque y Manuel Guevara el viernes, 17 de abril de 2015 04:19 p.m.
       -- con titulo Seguimiento BI Panam?
       lobjDetalle.cdRamoParametro := lvaCdramoContable;
--      lobjDetalle.cdRamoParametro := lvaCdRamo;
      END IF;
     END IF;

     lobjDetalle.cdOperacion   := reg.cdoperacion;

--    lobjDetalle.cdConcepto    := lvaCdConcepto;

     --Se comenta por solicitud de cat?logo de servicio 85529 Solicitada por Mario Franco y afirmada por SAP
     -- y se deja concatenando el codigo del usuario
     lobjDetalle.dsTextoPosicion            := lvaNmExpediente||'-'||lvaDsLoginUsuario;
     --lobjDetalle.dsTextoPosicion             := lvaNmExpediente||'-'||'DEDUCIBLE';

     IF lnuContadorDetalle = 1 THEN
      lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
     ELSE
      lobjTabDetalles.Extend;
      lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
     END IF;
    END IF;
   END LOOP;

   FOR reg IN lcuDetalleSumadosDescuento LOOP
    IF reg.PTDESCUENTO <> 0 AND lvaSnPolizaSalud = 'N' THEN
     lvaCdRamo                       := reg.CDRAMO;
     lvaCdSubramo                    := reg.CDSUBRAMO;
     lvaCdGarantia                   := reg.CDGARANTIA;
     lvaCdSubGarantia                := reg.CDSUBGARANTIA;
     lvaAplicaReservaSinRetencion    := NVL(PCK_PARAMETROS.FN_GET_PARAMETROV2('%',
                                                                              '%',
                                                                              'RESERVASINRETEN',
                                                                              SYSDATE,
                                                                              reg.NUMERO_RESERVA,
                                                                              '%',
                                                                              '%',
                                                                              '%',
                                                                              '%'), 'N');

     lobjDetalle.cdIndicadorImpuesto := '0000';--lvaCodIva;
     -- 01/12/2024 josebuvi VERIFICACION DE VIDA PARA INDICADOR IMPUESTO
     -- linaduto - 2025/03/11 - HU756348 -Ajuste retenci?n en la fuente para ID NIT - subramos PCP y deudores
     -- linaduto - 2025/03/20 - HU764049 -Ajuste retenci?n en la fuente para ID NIT - Ramo BAN
     -- luishure - 2025/12/10 - HU984785 - Exclusión de retención para Fondo de Ahorro
     IF (lvaCdRamo = '081' OR lvaCdRamo = 'BAN') AND lvaCdGarantia = 'VID' AND lvaAplicaReservaSinRetencion = 'N' THEN
       IF (lvaAplicaSinRetencion = 'N' OR (lvaAplicaSinRetencion = 'S' AND substr(lvaDni,1,1) <> 'A')) THEN 
        lnuContadorRetencionVida             := lnuContadorRetencionVida + 1;
        IF lnuContadorRetencionVida = 1 THEN
        lnuContadorRetencion               := lnuContadorRetencion + 1;
        lobjRetencion.cdtipoRetencion      := 'F5';
        lobjRetencion.cdindicadorRetencion := 'VI';
        IF lnuContadorRetencion = 1 THEN
          lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
        ELSE
          lobjRetenciones.Extend;
          lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
        END IF;
        lobjDocumento.retenciones := lobjRetenciones;
        END IF;
      END IF;	  
     END IF;

     IF reg.numero_reserva = 'P012100' THEN
        lobjDetalle.cdConcepto          := '13';
     ELSE
        lobjDetalle.cdConcepto          := '9';
     END IF;
     lvaSnCuentaContable             := 'N';

     OPEN lcuTipoReserva;
     FETCH lcuTipoReserva INTO lvaCdTipoReserva,lvaCdramoContable;
     CLOSE lcuTipoReserva;

     lnuContadorDetalle              := lnuContadorDetalle + 1;
     lobjDetalle.cdTipoReserva       := lvaCdTipoReserva;

     OPEN lcuSnCuentaContable;
     FETCH lcuSnCuentaContable INTO lvaSnCuentaContable;
     CLOSE lcuSnCuentaContable;

     IF lvaCdRamo = '081' AND lvaCdTipoReserva = 'T' THEN
--      lobjDetalle.cdRamo              := 'MVI';
      lobjDetalle.cdRamo              := 'AAV';
     ELSE
      lobjDetalle.cdRamo              := lvaCdramoContable;
     END IF;

     lobjDetalle.nmPoliza            := lvaNmPoliza;

     lobjDetalle.cdIntermediario     := lvaCdAgente;
     lobjDetalle.cdOficinaRadicacion := lvaCdDelegacionRadica;
     lobjDetalle.nmExpediente        := lvaNmExpediente;

     lobjDetalle.nmAsegurado         := lvaNmAsegurado;
     lobjDetalle.ptImporte           := reg.PTDESCUENTO;

    -- Variable de control para evitar Saldo en moneda de transaccion
     lnuTotalPago                    := lnuTotalPago + lobjDetalle.ptImporte;

     lobjDetalle.cdCentroCostos      := lvaCdDelegacionRadica;

     lobjDetalle.feAviso             := ldaFenotificacion;
     lobjDetalle.feOcurrencia        := ldaFeOcurrencia;

     -- Panam? 20130722 Compa??a = 30 En Colombia es cdciaMatriz en SAP es 3000
     PCK_GESTION_PRODUCTOS.SPGET_COMPANIA_PRODUCTO( reg.cdramo,reg.cdsubramo,lvaCdCompania,lvaCdciaMatriz,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);
     IF lvaCdciaMatriz = '00' THEN
      lobjDetalle.cdCompaniaParametro := lvaCdCompania;
     ELSIF lvaCdciaMatriz = '30' THEN
      lobjDetalle.cdCompaniaParametro := lvaCdciaMatriz;
     ELSE
      lobjDetalle.cdCompaniaParametro := lvaCdCompania;
     END IF;

     IF lvaCdciaMatriz = '00' THEN
      IF lvaCdRamo = '041' THEN
       lobjDetalle.cdRamoParametro := '041';
      ELSIF lvaCdRamo = '092' THEN
       lobjDetalle.cdRamoParametro := '092';
      ELSIF lvaSnCuentaContable = 'S' THEN
       lobjDetalle.cdRamoParametro := lvaCdramoContable;
      ELSE
       lobjDetalle.cdRamoParametro := 'N';
      END IF;
     ELSIF lvaCdciaMatriz = '30' THEN
      IF lvaCdRamo = '081' THEN
       lvaSnPrimerVigencia := 'S';
       OPEN lcuPrimerVigencia;
       FETCH lcuPrimerVigencia INTO lvaSnPrimerVigencia;
       IF lcuPrimerVigencia%NOTFOUND THEN
        lvaSnPrimerVigencia := 'N';
       END IF;
       CLOSE lcuPrimerVigencia;
       --Para identificar si es Universal o tradicional.
       OPEN lcuGrupoProducto;
       FETCH lcuGrupoProducto INTO lvaGrupoProducto;
       CLOSE lcuGrupoProducto;

       IF lvaSnPrimerVigencia = 'S' THEN
        lobjDetalle.cdRamoParametro := lvaGrupoProducto||'A';
       ELSE
        lobjDetalle.cdRamoParametro := lvaGrupoProducto||'R';
       END IF;

      ELSIF lvaCdRamo = '012' THEN
       --Para identificar el tipo de cobertura Bancaria, Fidelidad, Construcci?n ...
       OPEN lcuGrupoCobertura;
       FETCH lcuGrupoCobertura INTO lvaCdGrupoCobertura;
       CLOSE lcuGrupoCobertura;
       lobjDetalle.cdRamoParametro := lvaCdRamo||lvaCdGrupoCobertura;
      ELSE
       -- Solicitud via email de German Duque y Manuel Guevara el viernes, 17 de abril de 2015 04:19 p.m.
       -- con titulo Seguimiento BI Panam?
       lobjDetalle.cdRamoParametro := lvaCdramoContable;
--      lobjDetalle.cdRamoParametro := lvaCdRamo;
      END IF;
     END IF;

     lobjDetalle.cdOperacion   := reg.cdoperacion;

--    lobjDetalle.cdConcepto    := lvaCdConcepto;

     --Se comenta por solicitud de cat?logo de servicio 85529 Solicitada por Mario Franco y afirmada por SAP
     -- y se deja concatenando el codigo del usuario
     lobjDetalle.dsTextoPosicion            := lvaNmExpediente||'-'||lvaDsLoginUsuario;
     --lobjDetalle.dsTextoPosicion             := lvaNmExpediente||'-'||' DESCUENTO FINANCIERO';

     IF lnuContadorDetalle = 1 THEN
      lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
     ELSE
      lobjTabDetalles.Extend;
      lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
     END IF;
    END IF;
   END LOOP;

   --  Coaseguro


    -- Cedido
   IF lvaIdSoloSura <> '01' THEN
    FOR reg IN lcuDetalleSumadosCoaseguro LOOP
     IF reg.COASEGURO <> 0 THEN
      lvaCdRamo                       := reg.CDRAMO;
      lvaCdSubramo                    := reg.CDSUBRAMO;
      lvaCdGarantia                   := reg.CDGARANTIA;
      lvaCdSubGarantia                := reg.CDSUBGARANTIA;
      lvaAplicaReservaSinRetencion    := NVL(PCK_PARAMETROS.FN_GET_PARAMETROV2('%',
                                                                               '%',
                                                                               'RESERVASINRETEN',
                                                                               SYSDATE,
                                                                               reg.NUMERO_RESERVA,
                                                                               '%',
                                                                               '%',
                                                                               '%',
                                                                               '%'), 'N');

      lobjDetalle.cdIndicadorImpuesto := /*'0000';--*/lvaCodIva;
      -- 01/12/2024 josebuvi VERIFICACION DE VIDA PARA INDICADOR IMPUESTO
      -- linaduto - 2025/03/11 - HU756348 -Ajuste retenci?n en la fuente para ID NIT - subramos PCP y deudores
      -- linaduto - 2025/03/20 - HU764049 -Ajuste retenci?n en la fuente para ID NIT - Ramo BAN
      -- luishure - 2025/12/10 - HU984785 - Exclusión de retención para Fondo de Ahorro
      IF (lvaCdRamo = '081' OR lvaCdRamo = 'BAN') AND lvaCdGarantia = 'VID' AND lvaAplicaReservaSinRetencion = 'N' THEN
        IF (lvaAplicaSinRetencion = 'N' OR (lvaAplicaSinRetencion = 'S' AND substr(lvaDni,1,1) <> 'A')) THEN   
          lnuContadorRetencionVida             := lnuContadorRetencionVida + 1;
          IF lnuContadorRetencionVida = 1 THEN
          lnuContadorRetencion               := lnuContadorRetencion + 1;
          lobjRetencion.cdtipoRetencion      := 'F5';
          lobjRetencion.cdindicadorRetencion := 'VI';
          IF lnuContadorRetencion = 1 THEN
            lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
          ELSE
            lobjRetenciones.Extend;
            lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
          END IF;
          lobjDocumento.retenciones := lobjRetenciones;
          END IF;
        END IF;	  
      END IF;
      IF reg.numero_reserva = 'P012100' THEN
        lobjDetalle.cdConcepto          := '13';
      ELSE
         lobjDetalle.cdConcepto          := '1C';
      END IF;
      lvaSnCuentaContable             := 'N';

      OPEN lcuTipoReserva;
      FETCH lcuTipoReserva INTO lvaCdTipoReserva,lvaCdramoContable;
      CLOSE lcuTipoReserva;

      lnuContadorDetalle              := lnuContadorDetalle + 1;
      lobjDetalle.cdTipoReserva       := lvaCdTipoReserva;

      OPEN lcuSnCuentaContable;
      FETCH lcuSnCuentaContable INTO lvaSnCuentaContable;
      CLOSE lcuSnCuentaContable;

      IF lvaCdRamo = '081' AND lvaCdTipoReserva = 'T' THEN
       lobjDetalle.cdRamo              := 'AAV';
      ELSE
       lobjDetalle.cdRamo              := lvaCdramoContable;
      END IF;

      lobjDetalle.nmPoliza            := lvaNmPoliza;

      lobjDetalle.cdIntermediario     := lvaCdAgente;
      lobjDetalle.cdOficinaRadicacion := lvaCdDelegacionRadica;
      lobjDetalle.nmExpediente        := lvaNmExpediente;

      -- Para coaseguro, se tiene en el campo nmAsegurado el DNI de la Coaseguradora
      lvaCdCiaCoaseguradora := reg.CDCIA;
      OPEN lcuCiaCoaseguradora;
      FETCH lcuCiaCoaseguradora INTO lvaDniCoaseguro;--lobjDetalle.nmAsegurado;
      CLOSE lcuCiaCoaseguradora;
      lobjDetalle.nmAsegurado := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(lvaDniCoaseguro);

      lobjDetalle.ptImporte           := reg.COASEGURO;

      -- Variable de control para evitar Saldo en moneda de transaccion
       lnuTotalPago     := lnuTotalPago - lobjDetalle.ptImporte;

      lobjDetalle.cdCentroCostos      := lvaCdDelegacionRadica;

      lobjDetalle.feAviso             := ldaFenotificacion;
      lobjDetalle.feOcurrencia        := ldaFeOcurrencia;

      -- Panam? 20130722 Compa??a = 30 En Colombia es cdciaMatriz en SAP es 3000
      PCK_GESTION_PRODUCTOS.SPGET_COMPANIA_PRODUCTO( reg.cdramo,reg.cdsubramo,lvaCdCompania,lvaCdciaMatriz,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);
      IF lvaCdciaMatriz = '00' THEN
       lobjDetalle.cdCompaniaParametro := lvaCdCompania;
      ELSIF lvaCdciaMatriz = '30' THEN
       lobjDetalle.cdCompaniaParametro := lvaCdciaMatriz;
      ELSE
       lobjDetalle.cdCompaniaParametro := lvaCdCompania;
      END IF;

      IF lvaCdciaMatriz = '00' THEN
       IF lvaCdRamo = '041' THEN
        lobjDetalle.cdRamoParametro := '041';
       ELSIF lvaCdRamo = '092' THEN
        lobjDetalle.cdRamoParametro := '092';
       ELSIF lvaSnCuentaContable = 'S' THEN
        lobjDetalle.cdRamoParametro := lvaCdramoContable;
       ELSE
        lobjDetalle.cdRamoParametro := 'N';
       END IF;
      ELSIF lvaCdciaMatriz = '30' THEN
       --20131023 De acuerdo a email de German Duque siempre va  lobjDetalle.cdRamoParametro = N
       -- por eso se comenta todo el IF para ramo 081 y 012
--       lobjDetalle.cdRamoParametro := 'N';
       IF lvaCdRamo = '081' THEN
        lvaSnPrimerVigencia := 'S';
        OPEN lcuPrimerVigencia;
        FETCH lcuPrimerVigencia INTO lvaSnPrimerVigencia;
        IF lcuPrimerVigencia%NOTFOUND THEN
         lvaSnPrimerVigencia := 'N';
        END IF;
        CLOSE lcuPrimerVigencia;
        --Para identificar si es Universal o tradicional.
        OPEN lcuGrupoProducto;
        FETCH lcuGrupoProducto INTO lvaGrupoProducto;
        CLOSE lcuGrupoProducto;

        IF lvaSnPrimerVigencia = 'S' THEN
         lobjDetalle.cdRamoParametro := lvaGrupoProducto||'A';
        ELSE
         lobjDetalle.cdRamoParametro := lvaGrupoProducto||'R';
        END IF;

       ELSIF lvaCdRamo = '012' THEN
        --Para identificar el tipo de cobertura Bancaria, Fidelidad, Construcci?n ...
        OPEN lcuGrupoCobertura;
        FETCH lcuGrupoCobertura INTO lvaCdGrupoCobertura;
        CLOSE lcuGrupoCobertura;
        lobjDetalle.cdRamoParametro := lvaCdRamo||lvaCdGrupoCobertura;
       ELSE
        -- Solicitud via email de German Duque y Manuel Guevara el viernes, 17 de abril de 2015 04:19 p.m.
        -- con titulo Seguimiento BI Panam?
        lobjDetalle.cdRamoParametro := lvaCdramoContable;
--      lobjDetalle.cdRamoParametro := lvaCdRamo;
       END IF;
      END IF;

      lobjDetalle.cdOperacion   := reg.cdoperacion;

      --Se comenta por solicitud de cat?logo de servicio 85529 Solicitada por Mario Franco y afirmada por SAP
      -- y se deja concatenando el codigo del usuario
      lobjDetalle.dsTextoPosicion            := lvaNmExpediente||'-'||lvaDsLoginUsuario;
      --lobjDetalle.dsTextoPosicion             := lvaNmExpediente||'-'||' COASEGURO CEDIDO';

      IF lnuContadorDetalle = 1 THEN
       lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
      ELSE
       lobjTabDetalles.Extend;
       lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
      END IF;
     END IF;
    END LOOP;
    -- Variable de control para evitar Saldo en moneda de transaccion
    IF lnuTotalPago <> 0 THEN
     lobjTabDetalles(lnuContadorDetalle).ptImporte  := lobjTabDetalles(lnuContadorDetalle).ptImporte + lnuTotalPago;
    END IF;
   END IF;
   -- Fin de coaseguro


   lobjDocumento.detalleSiniestros        := lobjTabDetalles;

/*   FOR i IN lobjTabDetalles.FIRST..lobjTabDetalles.LAST LOOP
       DBMS_OUTPUT.put_line('Detalle 2: '||lobjTabDetalles(i).ptImporte);
   END LOOP;
*/
   lobjDocumento.cuentaBancaria           := lobjCuentaBancaria;

   IF lnuContadorDocumentos = 1 THEN
    lobjDocumentos(lnuContadorDocumentos) := lobjDocumento;
   ELSE
    lobjDocumentos.Extend;
    lobjDocumentos(lnuContadorDocumentos) := lobjDocumento;
   END IF;

  lnuContadorRetencionVida := 0;
  END LOOP;-- lcuDatosDocumentoRes

----------------------------------------------------------------------------------------------------------------------
  --Datos de tercero
  OPEN lcuCdUsuario;
  FETCH lcuCdUsuario INTO lvaCdUsuario;
  CLOSE lcuCdUsuario;


  PCK_SIC_SAP.SP_SIC_POBLA_TERCERO_SAP(lvaDni,
                                       lvaCdUsuario,
                                       ltyTercero,
                                       lvaMensajeTecnicoExt,
                                       lvaMensajeUsuarioExt);
  IF lvaMensajeTecnicoExt IS NOT NULL OR lvaMensajeUsuarioExt IS NOT NULL THEN
   RAISE lexErrorProcedimientoExt;
  END IF;

  lobjtercero.dsTratamiento           := ltyTercero.dsTratamiento;
  lobjtercero.dsNombre                := ltyTercero.dsNombre;
  lobjtercero.dsApellidos             := ltyTercero.dsApellidos;
  lobjtercero.dsNombres               := ltyTercero.dsNombres;
  lobjtercero.dsDireccion             := ltyTercero.dsDireccion;
  lobjtercero.dsApartadoAereo         := ltyTercero.dsApartadoAereo;
  lobjtercero.cdPais                  := ltyTercero.cdPais;
  lobjtercero.cdRegion                := ltyTercero.cdRegion;
  lobjtercero.cdPoblacion             := ltyTercero.cdPoblacion;
  lobjtercero.cdIdioma                := ltyTercero.cdIdioma;

  lobjInfoFiscal.nmIdentificacion     := ltyTercero.nmIdentificacion;
  lobjInfoFiscal.cdTipoIdentificacion := ltyTercero.cdTipoId;

  -- 17/07/2025 Mateo Zapata - Homologacion de tipo de documento TT para SAP
   IF UPPER(lobjInfoFiscal.cdTipoIdentificacion) = 'TT' THEN
     lobjInfoFiscal.cdTipoIdentificacion := 'PT';
   END IF;

  lobjtercero.cuentaBancaria          := lobjCuentaBancaria;
  lobjtercero.informacionFiscal       := lobjInfoFiscal;

  --lobjPago                            := OBJ_SAP_CXP_SINIESTROS() ;
  lobjPago.Tyinf                      := lobjTyinf;
  lobjPago.cabecera                   := lobjCabecera;
  lobjPago.documentosCXP              := lobjDocumentos;
  lobjPago.tercero                    := lobjtercero;
--DBMS_OUTPUT.put_line('lvaTipoCoaseguro='|| lvaTipoCoaseguro||' lobjDetalle.cdConcepto='||lobjDetalle.cdConcepto);

  RETURN lobjPago;


  EXCEPTION
      WHEN lexErrorProcedimientoExt THEN
        ovaMensajeTecnico:=lvaMensajeTecnicoExt;
        ovaMensajeUsuario:=lvaMensajeUsuarioExt;
        RETURN NULL;
      WHEN lexErrorProcedimiento THEN
        ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
        ovaMensajeUsuario:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeUsuario;
        RETURN NULL;
      WHEN OTHERS THEN
       ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
       ovaMensajeUsuario:= SQLERRM;--'TRANSACCION NO DISPONIBLE ' ;
       RETURN NULL;
  END FN_CREAR_MENSAJE_CXP;

-------------------------------------------------------------------------------------------------------------------------------------------------

  FUNCTION FN_CREAR_MENSAJE_CONSULTA_CXP (ivaClave1         IN VARCHAR2,
                                          ivaClave2         IN VARCHAR2,
                                          ivaConsumidor     IN VARCHAR2,
                                          ovaMensajeTecnico OUT VARCHAR2,
                                          ovaMensajeUsuario OUT VARCHAR2  ) RETURN OBJ_SAP_CONSULTA_EST_CXP IS

  --Variables para el manejo de Errores
  lvaMensajeTecnico           VARCHAR2(1000)  := NULL;
  lvaMensajeTecnicoExt        VARCHAR2(1000)  := NULL;
  lvaMensajeUsuario           VARCHAR2(1000)  := NULL;
  lvaMensajeUsuarioExt        VARCHAR2(1000)  := NULL;
  lexErrorProcedimiento       EXCEPTION;
  lexErrorProcedimientoExt    EXCEPTION;
  lvaNombreObjeto             VARCHAR2(30)   :='FN_CREAR_MENSAJE_CONSULTA_CXP';

  lobjMensaje                 OBJ_SAP_CONSULTA_EST_CXP := NULL;
  lobjTyinf                   OBJ_SBK_MENSAJE_INF      := OBJ_SBK_MENSAJE_INF(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
  ltyEncabezadoMens           TAB_SBK_ENC_MENSAJE      := TAB_SBK_ENC_MENSAJE(OBJ_SBK_ENC_MENSAJE(NULL,NULL));
  lvaDsUsuario                T999_PARAMETROS.DSVALOR_PARAMETRO%TYPE;
  lvaDsClave                  T999_PARAMETROS.DSVALOR_PARAMETRO%TYPE;


  lvaCdCompania               DIC_ALIAS_RS.CDCIA%TYPE;
  lvaDni                      SIN_PAGOS_DET.DNI%TYPE;
  lvaCdTipoIdentificacion     VARCHAR2(2);
  lvadsIdentificacion         PERSONAS.DNI%TYPE;

  --jorgsamn 20130812 Creacion del cursor para consulta de datos de dni y compania
  --Se realiza la consulta en la tabla de pdn como en la vista de banca
  CURSOR lcurDatosPago(lvaExpediente VARCHAR2,lnuPagoAutorizacion NUMBER) IS
     SELECT DISTINCT D.CDCIA,S.DNI
     FROM   SIN_PAGOS_DET S,
            DIC_ALIAS_RS D
     WHERE  S.EXPEDIENTE = lvaExpediente
     AND    S.NUMERO_PAGO_AUTORIZACION = lnuPagoAutorizacion
     AND    D.CDRAMO = S.CDRAMO
     AND    D.CDSUBRAMO = S.CDSUBRAMO
     UNION
     SELECT DISTINCT D.CDCIA,S.DNI
     FROM   SIN_PAGOS_DET_BAN S,
            DIC_ALIAS_RS D
     WHERE  S.EXPEDIENTE = lvaExpediente
     AND    S.NUMERO_PAGO_AUTORIZACION = lnuPagoAutorizacion
     AND    D.CDRAMO = S.CDRAMO
     AND    D.CDSUBRAMO = S.CDSUBRAMO
     ;

  BEGIN

  IF ivaConsumidor IN ('SINIESTROS','CRW') THEN
     IF ivaClave1 IS NULL OR ivaClave2 IS NULL THEN
        lvaMensajeTecnico := 'Los datos No Pueden Ser vacios';
        RAISE lexErrorProcedimiento;
     END IF;
  ELSE
     IF ivaClave2 IS NULL THEN
        lvaMensajeTecnico := 'Los datos No Pueden Ser vacios';
        RAISE lexErrorProcedimiento;
     END IF;
  END IF;

  --Datos generales del mensaje que necesita Surabroker ...
  --Parametrizables
  lvaMensajeTecnico            := 'Valores Iniciales';
  lobjTyinf.CDCONSUMIDOR       := 'SINIESTROS';
  lobjTyinf.CDSERVICIO         := 'ConsultaCXPSiniestros';
  lobjTyinf.CDOPERACION        := 'SI_os_WS_ConsultaEstadoCxP';
  --lobjTyinf.CDTOKEN          := ''; hasta donde s?, no aplica
  lobjTyinf.CDVERSION_SERVICIO := '1.0';
  lobjTyinf.DSNAME_SPACE       := NULL;
  lobjTyinf.DSPUERTO           := 'HTTP_Port';

  --No Parametrizables
  lobjTyinf.DSCLAVE            := ivaClave2;
  lobjTyinf.FECREACION         := SYSDATE;
  lobjTyinf.NMPRIORIDAD        := NULL;

  SP_USUARIO (lvaDsUsuario, lvaDsClave, lvaMensajeTecnicoExt, lvaMensajeUsuarioExt);

  ltyEncabezadoMens            := TAB_SBK_ENC_MENSAJE(OBJ_SBK_ENC_MENSAJE( PCK_SBK_SURABROKER.HEADER_BASIC_AUTH_USER,lvaDsUsuario));
  ltyEncabezadoMens.EXTEND;
  ltyEncabezadoMens(2)         := OBJ_SBK_ENC_MENSAJE( PCK_SBK_SURABROKER.HEADER_BASIC_AUTH_PASSWORD,lvaDsClave);  lobjTyinf.TYENCABEZADOS      := ltyEncabezadoMens;

  IF ivaConsumidor = 'SINIESTROS' THEN
     lvaMensajeTecnico := 'Consultando los datos de DNI y CDCIA';
     --jorgsamn 20130812 Llamado al cursor para consultar los datos de dni y compania
     OPEN lcurDatosPago(ivaClave1,ivaClave2);
      FETCH lcurDatosPago
        INTO lvaCdCompania,lvaDni;
     CLOSE lcurDatosPago;
     /*SELECT DISTINCT D.CDCIA,S.DNI
     INTO   lvaCdCompania, lvaDni
     FROM   SIN_PAGOS_DET S,
            DIC_ALIAS_RS D
     WHERE  S.EXPEDIENTE = ivaClave1
     AND    S.NUMERO_PAGO_AUTORIZACION = ivaClave2
     AND    D.CDRAMO = S.CDRAMO
     AND    D.CDSUBRAMO = S.CDSUBRAMO;*/

--COMENTAR PARA BANCASEGUROS MIENTRAS SE REALIZA EL CAMBIO DEL PAQUETE
--COMENTAR PARA BANCASEGUROS MIENTRAS SE REALIZA EL CAMBIO DEL PAQUETE
--COMENTAR PARA BANCASEGUROS MIENTRAS SE REALIZA EL CAMBIO DEL PAQUETE


  ELSIF ivaConsumidor = 'FDI' THEN
      PCK_FDI_INTEGRACION_SAP.SP_DATOS_ORPA(ivaClave2,
                                            lvaCdCompania,
                                            lvadsIdentificacion,
                                            lvaCdTipoIdentificacion,
                                            lvaMensajeTecnicoExt,
                                            lvaMensajeUsuarioExt);
      IF lvaMensajeTecnicoExt IS NOT NULL OR lvaMensajeUsuarioExt IS NOT NULL THEN
         RAISE lexErrorProcedimientoExt;
      END IF;
      lvaDni := lvaCdTipoIdentificacion||lvadsIdentificacion;
  ELSIF ivaConsumidor = 'CRW' THEN
      PCKCRW_PAGOS.SP_info_OPA(ivaClave1,
                               ivaClave2,
                               lvaCdCompania,
                               lvaDni,
                               lvaMensajeTecnicoExt,
                               lvaMensajeUsuarioExt);
      IF lvaMensajeTecnicoExt IS NOT NULL OR lvaMensajeUsuarioExt IS NOT NULL THEN
         RAISE lexErrorProcedimientoExt;
      END IF;


-- FIN DE COMENTAR BAMCASEGUROS
-- FIN DE COMENTAR BAMCASEGUROS
-- FIN DE COMENTAR BAMCASEGUROS




  END IF;

  lobjMensaje                      := OBJ_SAP_CONSULTA_EST_CXP();
  lobjMensaje.Tyinf                := lobjTyinf;

  lobjMensaje.cdCompania           := lvaCdCompania;
  lobjMensaje.dsNitAcreedor        := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(lvaDni);
  lobjMensaje.cdTipoIdentificacion := PCK_SIC_UTILITARIOS_I.FN_SIC_CDTIPO_IDENTIFICACION(lvaDni);
  lobjMensaje.dsReferencia         := ivaClave2;



  RETURN lobjMensaje;

  EXCEPTION
      WHEN lexErrorProcedimientoExt THEN
        ovaMensajeTecnico:=lvaMensajeTecnicoExt;
        ovaMensajeUsuario:=lvaMensajeUsuarioExt;
        RETURN NULL;
      WHEN lexErrorProcedimiento THEN
        ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
        ovaMensajeUsuario:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeUsuario;
        RETURN NULL;
      WHEN OTHERS THEN
       ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
       ovaMensajeUsuario:= 'TRANSACCION NO DISPONIBLE ' ;
       RETURN NULL;
  END FN_CREAR_MENSAJE_CONSULTA_CXP;

  FUNCTION FN_CREAR_MENSAJE_ANULAR_CXP (ivaNmExpediente        IN VARCHAR2,
                                        ivaNmPagoAutorizacion  IN SIN_PAGOS_DET.NUMERO_PAGO_AUTORIZACION%TYPE,
                                        ovaMensajeTecnico      OUT VARCHAR2,
                                        ovaMensajeUsuario      OUT VARCHAR2  ) RETURN OBJ_SAP_ANULACION_CXP IS

  --Variables para el manejo de Errores
  lvaMensajeTecnico           VARCHAR2(1000)  := NULL;
  lvaMensajeTecnicoExt        VARCHAR2(1000)  := NULL;
  lvaMensajeUsuario           VARCHAR2(1000)  := NULL;
  lvaMensajeUsuarioExt        VARCHAR2(1000)  := NULL;
  lexErrorProcedimiento       EXCEPTION;
  lexErrorProcedimientoExt    EXCEPTION;
  lvaNombreObjeto             VARCHAR2(30)   :='FN_CREAR_MENSAJE_ANULAR_CXP';

  lobjMensaje                 OBJ_SAP_ANULACION_CXP := NULL;
  lobjTyinf                   OBJ_SBK_MENSAJE_INF      := OBJ_SBK_MENSAJE_INF(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
  ltyEncabezadoMens           TAB_SBK_ENC_MENSAJE      := TAB_SBK_ENC_MENSAJE(OBJ_SBK_ENC_MENSAJE(NULL,NULL));
  lvaDsUsuario                T999_PARAMETROS.DSVALOR_PARAMETRO%TYPE;
  lvaDsClave                  T999_PARAMETROS.DSVALOR_PARAMETRO%TYPE;

  lvaCdCompania               DIC_ALIAS_RS.CDCIA%TYPE;
  lvaCdCompaniaMatriz         DIC_ALIAS_RS.CDCIA_MATRIZ%TYPE;
  lvaDni                      SIN_PAGOS_DET.DNI%TYPE;
  lvaNmFactura                SIN_FACTURAS.NMFACTURA%TYPE;
  lvaNmPrefijo                SIN_FACTURAS.NMPREFIJO%TYPE;
  lvaFactura                  VARCHAR2(50);

  --Banco de Bogota
  lvaSnBancaseguros           DIC_ALIAS_RS.SNBANCASEGUROS%TYPE;
  lvaCdRamo                   SIN_PAGOS_DET.CDRAMO%TYPE;
  lvaCdSubramo                SIN_PAGOS_DET.CDSUBRAMO%TYPE;

  -- Panam?.  Se incluye en cursor CDCIA_MATRIZ
  -- Banco de Bogot?, se incluye en el cursor CDRAMO, CDSUBRAMO
  CURSOR lcurDatosFactura IS
   SELECT DISTINCT D.CDCIA,S.DNI, F.NMPREFIJO, F.NMFACTURA, D.CDCIA_MATRIZ,
                   S.CDRAMO, S.CDSUBRAMO
   FROM SIN_PAGOS_DET S, SIN_FACTURAS F, DIC_ALIAS_RS D
   WHERE S.EXPEDIENTE             = ivaNmExpediente
   AND S.NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND D.CDRAMO                   = S.CDRAMO
   AND D.CDSUBRAMO                = S.CDSUBRAMO
   AND s.EXPEDIENTE               = f.NMEXPEDIENTE        (+)
   AND s.NUMERO_PAGO_AUTORIZACION = f.NMPAGO_AUTORIZACION (+)
   AND s.DNI                      = f.DNI                 (+);

  --Pagos por Banco de Bogota, que en el motivo de anulacion se debe llevar diferente para Seguros y Bancaseguros
  CURSOR lcuSnBancaseguros IS
   SELECT SNBANCASEGUROS
   FROM DIC_ALIAS_RS
   WHERE CDRAMO  = lvaCdRamo
   AND CDSUBRAMO = lvaCdSubRamo;

  BEGIN

   IF ivaNmPagoAutorizacion IS NULL OR ivaNmExpediente IS NULL THEN
    lvaMensajeTecnico := 'Los datos No Pueden Ser vacios';
    RAISE lexErrorProcedimiento;
   END IF;

   --Datos generales del mensaje que necesita Surabroker ...
   --Parametrizables
   lvaMensajeTecnico            := 'Valores Iniciales';
   lobjTyinf.CDCONSUMIDOR       := 'SINIESTROS';
   lobjTyinf.CDSERVICIO         := 'SI_os_WS_AnulacionCxP.wsdl';
   lobjTyinf.CDOPERACION        := 'SI_os_WS_AnulacionCxP';
   --lobjTyinf.CDTOKEN          := '';
   lobjTyinf.CDVERSION_SERVICIO := '1.0';
   lobjTyinf.DSNAME_SPACE       := NULL;
   lobjTyinf.DSPUERTO           := 'HTTP_Port';

   --No Parametrizables
   lobjTyinf.DSCLAVE            := ivaNmPagoAutorizacion;
   lobjTyinf.FECREACION         := SYSDATE;
   lobjTyinf.NMPRIORIDAD        := NULL;

  SP_USUARIO (lvaDsUsuario, lvaDsClave, lvaMensajeTecnicoExt, lvaMensajeUsuarioExt);

  ltyEncabezadoMens            := TAB_SBK_ENC_MENSAJE(OBJ_SBK_ENC_MENSAJE( PCK_SBK_SURABROKER.HEADER_BASIC_AUTH_USER,lvaDsUsuario));
  ltyEncabezadoMens.EXTEND;
  ltyEncabezadoMens(2)         := OBJ_SBK_ENC_MENSAJE( PCK_SBK_SURABROKER.HEADER_BASIC_AUTH_PASSWORD,lvaDsClave);   lobjTyinf.TYENCABEZADOS      := ltyEncabezadoMens;

--   lvaMensajeTecnico := 'Consultando los datos de DNI y CDCIA';

   -- Panam?.  Se incluye en fetch lvaCdCompaniaMatriz
   -- Banco de Bogot?.  Se incluye en el fetch lvaCdRamo, lvaCdSubramo
   OPEN lcurDatosFactura;
   FETCH lcurDatosFactura INTO lvaCdCompania, lvaDni, lvaNmPrefijo,lvaNmFactura, lvaCdCompaniaMatriz, lvaCdRamo, lvaCdSubramo;
   CLOSE lcurDatosFactura;

   IF LENGTH(TRIM(lvaNmPrefijo)) > 9 THEN
    lvaNmPrefijo        := SUBSTR(lvaNmPrefijo,(LENGTH(TRIM(lvaNmPrefijo))-8));
   END IF;
   IF TRIM(lvaNmPrefijo) IS NOT NULL THEN
    lvaFactura          := lvaNmPrefijo ||'-'||lvaNmFactura;
   ELSE
    lvaFactura          := lvaNmFactura;
   END IF;

   lobjMensaje                      := OBJ_SAP_ANULACION_CXP();
   lobjMensaje.Tyinf                := lobjTyinf;


--   lobjMensaje.CDCOMPANIA           := lvaCdCompania;
   lobjMensaje.CDANO_CONTABLE       := TO_CHAR(SYSDATE,'YYYY');

   --Banco de Bogota.  Se cambia el motivo de anulaci?n que ven?a quemado en 04 a determinarlo de acuerdo al tipo de negocio Seguros o Bancaseguros.
--   lobjMensaje.CDMOTIVO_ANULACION   := '04';
   OPEN lcuSnBancaseguros;
   FETCH lcuSnBancaseguros INTO lvaSnBancaseguros;
   CLOSE lcuSnBancaseguros;
   IF lvaSnBancaseguros = 'S' THEN
    lobjMensaje.CDMOTIVO_ANULACION := 'BAN';
   ELSE
    lobjMensaje.CDMOTIVO_ANULACION := 'SEG';
   END IF;

   -- Panam?.  La compa??a es la Matriz
   IF lvaCdCompaniaMatriz = '00' THEN
    lobjMensaje.CDCOMPANIA := lvaCdCompania;
   ELSIF lvaCdCompaniaMatriz = '30' THEN
    lobjMensaje.CDCOMPANIA := lvaCdCompaniaMatriz;
   ELSE
    lobjMensaje.CDCOMPANIA := lvaCdCompania;
   END IF;

   lobjMensaje.FECONTABILIZACION    := SYSDATE;
   lobjMensaje.NMFACTURA            := lvaFactura;
   lobjMensaje.NMORDEN_PAGO         := ivaNmPagoAutorizacion;
   lobjMensaje.CDBENEFICIARIO       := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(lvaDni);
   lobjMensaje.CDTIPO_IDENTIFICACION:= PCK_SIC_UTILITARIOS_I.FN_SIC_CDTIPO_IDENTIFICACION(lvaDni);

   RETURN lobjMensaje;

  EXCEPTION
   WHEN lexErrorProcedimientoExt THEN
    ovaMensajeTecnico:=lvaMensajeTecnicoExt;
    ovaMensajeUsuario:=lvaMensajeUsuarioExt;
    RETURN NULL;
   WHEN lexErrorProcedimiento THEN
    ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
    ovaMensajeUsuario:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeUsuario;
    RETURN NULL;
   WHEN OTHERS THEN
    ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
    ovaMensajeUsuario:= 'TRANSACCION NO DISPONIBLE ' ;
    RETURN NULL;
  END FN_CREAR_MENSAJE_ANULAR_CXP;

----------------------------------------------------------------------------------------------------------------------------------------
  FUNCTION FN_CREAR_MENSAJE_CXP_v6_0(ivaNmExpediente        IN SIN_PAGOS_DET.EXPEDIENTE%TYPE,
                                ivaNmPagoAutorizacion  IN SIN_PAGOS_DET.NUMERO_PAGO_AUTORIZACION%TYPE,
                                ovaMensajeTecnico      OUT VARCHAR2,
                                ovaMensajeUsuario      OUT VARCHAR2) RETURN OBJ_SAP_CXP_SINIESTROS IS

  --Variables para el manejo de Errores
  lvaMensajeTecnico           VARCHAR2(1000)  := NULL;
  lvaMensajeTecnicoExt        VARCHAR2(1000)  := NULL;
  lvaMensajeUsuario           VARCHAR2(1000)  := NULL;
  lvaMensajeUsuarioExt        VARCHAR2(1000)  := NULL;
  lexErrorProcedimiento       EXCEPTION;
  lexErrorProcedimientoExt    EXCEPTION;
  lvaNombreObjeto             VARCHAR2(30)   :='FN_CREAR_MENSAJE_CXP';


  --Objeto para retornar con mensaje SAP
  lobjPago                          OBJ_SAP_CXP_SINIESTROS      := OBJ_SAP_CXP_SINIESTROS();
  lobjTyinf                         OBJ_SBK_MENSAJE_INF         := OBJ_SBK_MENSAJE_INF(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
  ltyEncabezadoMens                 TAB_SBK_ENC_MENSAJE         := TAB_SBK_ENC_MENSAJE(OBJ_SBK_ENC_MENSAJE(NULL, NULL));
  lobjCabecera                      OBJ_SAP_CABECERA_CXP_SINI   := OBJ_SAP_CABECERA_CXP_SINI();
  lobjDocumento                     OBJ_SAP_DOCUMENTO_CXP_SINI  := OBJ_SAP_DOCUMENTO_CXP_SINI();
  lobjDocumentos                    TAB_SAP_DOCUMENTO_CXP_SINI  := TAB_SAP_DOCUMENTO_CXP_SINI(OBJ_SAP_DOCUMENTO_CXP_SINI());
  lobjDetalle                       OBJ_SAP_DETALLE_CXP_SINI    := OBJ_SAP_DETALLE_CXP_SINI();
  lobjTabDetalles                   TAB_SAP_DETALLES_CXP_SINI   := TAB_SAP_DETALLES_CXP_SINI(OBJ_SAP_DETALLE_CXP_SINI());
  lobjRetencion                     OBJ_SAP_DATO_RETENCION      := OBJ_SAP_DATO_RETENCION();
  lobjRetenciones                   TAB_SAP_DATOS_RETENCIONES   := TAB_SAP_DATOS_RETENCIONES(OBJ_SAP_DATO_RETENCION());
  lobjDatosConversion               OBJ_SAP_DATOS_CONVERSION    := OBJ_SAP_DATOS_CONVERSION();
  lobjCuentaBancaria                OBJ_SAP_CUENTA              := OBJ_SAP_CUENTA();
  lobjtercero                       OBJ_SAP_TERCERO             := OBJ_SAP_TERCERO();
  lobjCondicionPago                 OBJ_SAP_CONDICION_PAGO_SINI := OBJ_SAP_CONDICION_PAGO_SINI();
  lobjInfoFiscal                    OBJ_SAP_INFO_FISCAL         := OBJ_SAP_INFO_FISCAL();
  ltyTercero                        PCK_SIC_SAP.regTercero;
  lvaDsUsuario                      T999_PARAMETROS.DSVALOR_PARAMETRO%TYPE;
  lvaDsClave                        T999_PARAMETROS.DSVALOR_PARAMETRO%TYPE;

  --Variables para llenar los Objetos
  lnuContadorDetalle                NUMBER                    := 0;
  lnuContadorRetencion              NUMBER                    := 0;
  lnuContadorDocumentos             NUMBER                    := 0;

  --Variables propias del aplicativo
  lvaCdCompania                    DIC_ALIAS_RS.CDCIA%TYPE;
  lvaCdRamo                        SIN_PAGOS_DET.CDRAMO%TYPE;
  lvaCdSubRamo                     SIN_PAGOS_DET.CDSUBRAMO%TYPE;
  lvaCdGarantia                    SIN_PAGOS_DET.CDGARANTIA%TYPE;
  lvaCdSubGarantia                 SIN_PAGOS_DET.CDSUBGARANTIA%TYPE;

  lvaCdciaMatriz                   DIC_ALIAS_RS.CDCIA_MATRIZ%TYPE;
  lvaNmFactura                     SIN_FACTURAS.NMFACTURA%TYPE;
  lvaNmPrefijo                     SIN_FACTURAS.NMPREFIJO%TYPE;
  lvaSnCalcularImpuestos           VARCHAR2(1)                := 'S';
  lvaNmExpediente                  SIN_PAGOS_DET.EXPEDIENTE%TYPE;
  lvaNmPoliza                      SIN_PAGOS_DET.NPOLIZA%TYPE;
  lvaNmCertificado                 SIN_PAGOS_DET.NCERTIFICADO%TYPE;
  lvaDniAsegurado                  PERSONAS.DNI%TYPE;
  lvaNmAsegurado                   PERSONAS.DNI%TYPE;
  lvacdTipoIdentificacionProv      VARCHAR2(2);
  lvanmIdentificacionProveedor     SIN_PAGOS_DET.DNI%TYPE;
  lvaNmBeneficiarioPago            SIN_PAGOS_DET.DNI%TYPE;
  ldaFeOcurrencia                  SINIESTROS.FECHA_SINIESTRO%TYPE;
  ldaFenotificacion                SINIESTROS.FECHA_NOTIFICACION%TYPE;
  lvaFeposiblePago                 PAGOS.FEPOSIBLE_PAGO%TYPE;
  lvaCdViaPago                     PAGOS.CDVIAPAGO%TYPE;
  lvaCdbloqueoPago                 PAGOS.CDBLOQUEOPAGO%TYPE;
  lvaCdPaisBanco                   PAGOS.CDPAISBANCO%TYPE;
  lvaCdBanco                       PAGOS.CDBANCO%TYPE;
  lvaNmCuenta                      PAGOS.NMCUENTA%TYPE;
  cdTipoCuenta                     PAGOS.CDTIPOCUENTA%TYPE;
  lvaCdSucursalBanco               PAGOS.CDSUCURSALBANCO%TYPE;
  lvaDsTitular                     PAGOS.DSTITULAR%TYPE;
  lvaCdTipoReserva                 DIC_ALIAS_COBERTURAS.CDTIPO_RESERVA%TYPE;
  lvaCdramoContable                DIC_ALIAS_COBERTURAS.CDRAMO_CONTABLE%TYPE;
  lvaCdRetencion                   SIN_PAGOS_DET.CDRETENCION%TYPE;
  lnuImpIrc                        SIN_PAGOS_DET.IMPIRC%TYPE;
  lnuImpIrpfRetenido               SIN_PAGOS_DET.IMPIRPF_RETENIDO%TYPE;
  lnuImpIca                        SIN_PAGOS_DET.IMPICA%TYPE;
  lvaCdAgente                      CUERPOLIZA.CDAGENTE%TYPE;
  lvaCdDelegacionRadica            CUERPOLIZA.CDDELEGACION_RADICA%TYPE;
  lvaMunicipioIca                  SIN_RETENCION_ICA.CDMUNICIPIO%TYPE;

  lvaDsTextoPosicion               VARCHAR2(50);
  lvaCdOperacion                   PAGOS.CDOPERACION%TYPE;
  lvaCdOficinaRegistro             SIN_PAGOS_DET.CDENTIDAD%TYPE;
  lnuIvaDescontable                SIN_PAGOS_DET.IMPIRPF%TYPE;
  lnuDeducible                     SIN_PAGOS_DET.DEDUCIBLE%TYPE;
  lnuPtDescuento                   SIN_PAGOS_DET.PTDESCUENTO%TYPE;
  lvaCodIva                        SIN_RETENCIONES.CDRETENCION%TYPE;
  lvaCdConcepto                    VARCHAR2(10);
  lvaSnBancaseguros                DIC_ALIAS_RS.SNBANCASEGUROS%TYPE;
  lvaDni                           PERSONAS.DNI%TYPE;
  lvaCdUsuario                     HISTORICO.CODIGO_USUARIO%TYPE;


  lvaNumeroReserva                 SIN_PAGOS_DET.NUMERO_RESERVA%TYPE;
  lvaPoIrpf                        SIN_PAGOS_DET.POIRPF%TYPE;

  lnuTotalDeducible                SIN_PAGOS_DET.DEDUCIBLE%TYPE;
  lnuTotalPtDescuento              SIN_PAGOS_DET.PTDESCUENTO%TYPE;
  lnuTotalIvaNoDescontable         SIN_PAGOS_DET.IMPIRPF%TYPE;

  --Cursores para consultar la informacion

  -- Cursor base para el llenado de la Cabecera con el total de la CxP
  CURSOR lcuDatosCabecera IS
   SELECT s.CDRAMO, s.CDSUBRAMO,s.NPOLIZA, S.NCERTIFICADO, s.CDENTIDAD, s.DNI, s.CDMONEDA, s.FEPAGO,
          DECODE(S.CARGO_ABONO,'A','907','C','916','907') CDOPERACION,
          ROUND(ABS(SUM(s.IMPIRPF))) impirpf, ROUND(ABS(SUM(DEDUCIBLE))) deducible, ROUND(ABS(SUM(s.PTDESCUENTO))) ptdescuento
   FROM SIN_PAGOS_DET s
   WHERE s.EXPEDIENTE             = ivaNmExpediente
   AND s.NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   GROUP BY s.CDRAMO, s.CDSUBRAMO, s.NPOLIZA, S.NCERTIFICADO,s.CDENTIDAD, s.DNI, s.CDMONEDA, s.FEPAGO,
            LPAD(REPLACE(TO_CHAR(RPAD(POIRPF,4,'0')),',',''),4,'0'),
            DECODE(S.CARGO_ABONO,'A','907','C','916','907');

  -- Cursor base para el llenado con los datos del DOCUMENTO por cada tipo de reserva de Fondo de ahorro y Valores de Cesion
  CURSOR lcuDatosDocumentoFyC IS
   SELECT NUMERO_RESERVA, POIRPF , S.CDRETENCION,
          DECODE(S.CARGO_ABONO,'A',(ROUND(ABS(SUM(s.IMPORTE)+ SUM(s.DEDUCIBLE)))),
                               'C',(ROUND(ABS(SUM(s.IMPORTE)- SUM(s.DEDUCIBLE))))) importe,
          ROUND(ABS(SUM(S.IMPIRC))) IMPIRC,
          ROUND(ABS(SUM(IMPIRPF_RETENIDO))) IMPIRPF_RETENIDO, ROUND(ABS(SUM(IMPICA))) IMPICA,
          POIRC, POIRPF_RETENIDO, POICA, ROUND(ABS(((IMPORTE*100)/(100+NVL(POIRPF,0))))) BASEIMPUESTOS
   FROM SIN_PAGOS_DET s
   WHERE EXPEDIENTE               = ivaNmExpediente
   AND   NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND   NUMERO_RESERVA          IN ('P012091','P012081','P012093','P012096')
   GROUP BY NUMERO_RESERVA, POIRPF, S.CDRETENCION,POIRC, POIRPF_RETENIDO, POICA, ROUND(ABS(((IMPORTE*100)/(100+NVL(POIRPF,0)))));

  -- Cursor base para el llenado con los datos del DOCUMENTO por cada tipo de reserva Matem?tica o T?cnica
  CURSOR lcuDatosDocumentoRes IS
   SELECT dac.CDTIPO_RESERVA, POIRPF , S.CDRETENCION,
          DECODE(S.CARGO_ABONO,'A',(ROUND(ABS(SUM(s.IMPORTE)+ SUM(s.DEDUCIBLE)))),
                               'C',(ROUND(ABS(SUM(s.IMPORTE)- SUM(s.DEDUCIBLE))))) importe,
          ROUND(ABS(SUM(S.IMPIRC))) IMPIRC,
          ROUND(ABS(SUM(IMPIRPF_RETENIDO))) IMPIRPF_RETENIDO, ROUND(ABS(SUM(IMPICA))) IMPICA,
          POIRC, POIRPF_RETENIDO, POICA, ROUND(ABS(((IMPORTE*100)/(100+NVL(POIRPF,0))))) BASEIMPUESTOS
   FROM SIN_PAGOS_DET s , DIC_ALIAS_COBERTURAS dac
   WHERE EXPEDIENTE               = ivaNmExpediente
   AND   NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND   s.CDRAMO                 = dac.CDRAMO
   AND   s.CDSUBRAMO              = dac.CDSUBRAMO
   AND   s.CDGARANTIA             = dac.CDGARANTIA
   AND   s.CDSUBGARANTIA          = dac.CDSUBGARANTIA
   AND   NUMERO_RESERVA      NOT IN ('P012091','P012081','P012093','P012096')
   GROUP BY CDTIPO_RESERVA, POIRPF, S.CDRETENCION,POIRC, POIRPF_RETENIDO, POICA, ROUND(ABS(((IMPORTE*100)/(100+NVL(POIRPF,0)))));


  -- Cursor base para el llenado con los datos del DOCUMENTO de Iva NO descontable, Deducible y Descuento Financiero
  CURSOR lcuDatosSumados IS
   SELECT dac.CDTIPO_RESERVA,
          ROUND(ABS(SUM(DECODE(s.CARGO_ABONO,'A',((NVL(IMPIRPF,0)*(NVL(IMPORTE,0) + NVL(DEDUCIBLE,0))/NVL(IMPORTE,0))-IMPIRPF),
                                             'C',((NVL(IMPIRPF,0)*(NVL(IMPORTE,0) - NVL(DEDUCIBLE,0))/NVL(IMPORTE,0))-IMPIRPF))))) IVANODESCONTABLE,
          ROUND(ABS(SUM(DEDUCIBLE))) DEDUCIBLE, ROUND(ABS(SUM(PTDESCUENTO))) PTDESCUENTO
   FROM SIN_PAGOS_DET s, DIC_ALIAS_COBERTURAS dac
   WHERE EXPEDIENTE               = ivaNmExpediente
   AND   NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND   s.CDRAMO                 = dac.CDRAMO
   AND   s.CDSUBRAMO              = dac.CDSUBRAMO
   AND   s.CDGARANTIA             = dac.CDGARANTIA
   AND   s.CDSUBGARANTIA          = dac.CDSUBGARANTIA
   GROUP BY dac.CDTIPO_RESERVA
   HAVING ROUND(ABS(SUM(DEDUCIBLE))) <> 0
          OR ROUND(ABS(SUM(PTDESCUENTO))) <> 0
          OR ROUND(ABS(SUM(DECODE(s.CARGO_ABONO,'A',((NVL(IMPIRPF,0)*(NVL(IMPORTE,0) + NVL(DEDUCIBLE,0))/NVL(IMPORTE,0))-IMPIRPF),
                                   'C',((NVL(IMPIRPF,0)*(NVL(IMPORTE,0) - NVL(DEDUCIBLE,0))/NVL(IMPORTE,0))-IMPIRPF))))) <> 0;

  -- Cursor base para el llenado del detalle de cada total Iva NO descontable, Deducible y Descuento Financiero
  CURSOR lcuDetalleSumadosIMPIRPF IS
   SELECT s.CDRAMO, s.CDSUBRAMO, s.CDGARANTIA, s.CDSUBGARANTIA, DNI,
          ROUND(ABS(DECODE(s.CARGO_ABONO,'A',((NVL(IMPIRPF,0)*(NVL(IMPORTE,0) + NVL(DEDUCIBLE,0))/NVL(IMPORTE,0))-IMPIRPF),
                               'C',((NVL(IMPIRPF,0)*(NVL(IMPORTE,0) - NVL(DEDUCIBLE,0))/NVL(IMPORTE,0))-IMPIRPF)))) IVANODESCONTABLE
   FROM SIN_PAGOS_DET s, DIC_ALIAS_COBERTURAS dac
   WHERE EXPEDIENTE               = ivaNmExpediente
   AND   NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND   s.CDRAMO                 = dac.CDRAMO
   AND   s.CDSUBRAMO              = dac.CDSUBRAMO
   AND   s.CDGARANTIA             = dac.CDGARANTIA
   AND   s.CDSUBGARANTIA          = dac.CDSUBGARANTIA
   AND   dac.CDTIPO_RESERVA       = lvaCdTipoReserva
   AND   s.IMPIRPF               <> 0;

  CURSOR lcuDetalleSumadosDeducible IS
   SELECT s.CDRAMO, s.CDSUBRAMO, s.CDGARANTIA, s.CDSUBGARANTIA, DNI,
          ROUND(ABS(DEDUCIBLE)) DEDUCIBLE
   FROM SIN_PAGOS_DET s, DIC_ALIAS_COBERTURAS dac
   WHERE EXPEDIENTE               = ivaNmExpediente
   AND   NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND   s.CDRAMO                 = dac.CDRAMO
   AND   s.CDSUBRAMO              = dac.CDSUBRAMO
   AND   s.CDGARANTIA             = dac.CDGARANTIA
   AND   s.CDSUBGARANTIA          = dac.CDSUBGARANTIA
   AND   dac.CDTIPO_RESERVA       = lvaCdTipoReserva
   AND   s.DEDUCIBLE             <> 0;

  CURSOR lcuDetalleSumadosDescuento IS
   SELECT s.CDRAMO, s.CDSUBRAMO, s.CDGARANTIA, s.CDSUBGARANTIA, s.DNI,
          ROUND(ABS(s.PTDESCUENTO)) PTDESCUENTO
   FROM SIN_PAGOS_DET s, DIC_ALIAS_COBERTURAS dac
   WHERE EXPEDIENTE               = ivaNmExpediente
   AND   NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND   s.CDRAMO                 = dac.CDRAMO
   AND   s.CDSUBRAMO              = dac.CDSUBRAMO
   AND   s.CDGARANTIA             = dac.CDGARANTIA
   AND   s.CDSUBGARANTIA          = dac.CDSUBGARANTIA
   AND   dac.CDTIPO_RESERVA       = lvaCdTipoReserva
   AND   s.PTDESCUENTO           <> 0;

  -- Cursor base para el llenado del detalle OBJ_SAP_DETALLE_CXP_SINI por cada tipo de reserva de Fondo de ahorro y Valores de Cesion
  CURSOR lcuDatosPagosFyC IS
   SELECT CDRAMO, CDSUBRAMO, CDGARANTIA, CDSUBGARANTIA, ROUND(ABS(IMPORTE)) IMPORTE, DNI
   FROM SIN_PAGOS_DET s
   WHERE EXPEDIENTE               = ivaNmExpediente
   AND   NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND   NUMERO_RESERVA           = lvaNumeroReserva
   AND   POIRPF                   = lvaPoIrpf
   AND   CDRETENCION              = lvaCdRetencion;

  -- Cursor base para el llenado del detalle OBJ_SAP_DETALLE_CXP_SINI por cada tipo de reserva Matematica o T?cnica
  CURSOR lcuDatosPagosRes IS
   SELECT s.CDRAMO, s.CDSUBRAMO, s.CDGARANTIA, s.CDSUBGARANTIA, ROUND(ABS(IMPORTE)) IMPORTE, DNI
   FROM SIN_PAGOS_DET s, DIC_ALIAS_COBERTURAS dac
   WHERE EXPEDIENTE               = ivaNmExpediente
   AND   NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND   NUMERO_RESERVA      NOT IN ('P012091','P012081','P012093','P012096')
   AND   POIRPF                   = lvaPoIrpf
   AND   CDRETENCION              = lvaCdRetencion
   AND   s.CDRAMO                 = dac.CDRAMO
   AND   s.CDSUBRAMO              = dac.CDSUBRAMO
   AND   s.CDGARANTIA             = dac.CDGARANTIA
   AND   s.CDSUBGARANTIA          = dac.CDSUBGARANTIA
   AND   dac.CDTIPO_RESERVA       = lvaCdTipoReserva;

  -- Cursor con los datos de las retenciones a nivel de la orden de pago, no del detalle.
  -- No se est? usando en el momento porque se van a tomar sumados del documento
  /*
  CURSOR lcuRetenciones IS
   SELECT S.CDRETENCION, s.CDENTIDAD, S.IMPIRC, IMPIRPF_RETENIDO, IMPICA
   FROM SIN_PAGOS_DET S
   WHERE s.EXPEDIENTE             = ivaNmExpediente
   AND s.NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND s.CDRETENCION           NOT IN ('0099','0000','9999','9998');
  */

 CURSOR lcuDatosCaja IS
  SELECT FEPOSIBLE_PAGO, CDVIAPAGO, CDBLOQUEOPAGO, CDPAISBANCO, CDBANCO, NMCUENTA,
         PCK_SIC_SAP.FN_SIC_MAPEO_TIPO_CUENTA(CDTIPOCUENTA) CDTIPOCUENTA,
         CDSUCURSALBANCO, SUBSTR(DSTITULAR,1,60) DSTITULAR
  FROM PAGOS p
  WHERE p.EXPEDIENTE        = ivaNmExpediente
  AND p.NMPAGO_AUTORIZACION = ivaNmPagoAutorizacion;

  CURSOR lcuDatosSiniestro IS
   SELECT TO_DATE(TO_CHAR(FECHA_SINIESTRO,'DDMMYYYY'),'DDMMYYYY'), TO_DATE(TO_CHAR(s.FECHA_NOTIFICACION,'DDMMYYYY'),'DDMMYYYY')
   FROM SINIESTROS S
   WHERE EXPEDIENTE = ivaNmExpediente;

  CURSOR lcuDatosFactura IS
   SELECT NMFACTURA, NMPREFIJO
   FROM SIN_FACTURAS
   WHERE NMEXPEDIENTE      = ivaNmExpediente
   AND NMPAGO_AUTORIZACION = ivaNmPagoAutorizacion;

  CURSOR lcuAsegurado IS
   SELECT p.DNI
   FROM PERSONAS_PROD pp, PERSONAS p
   WHERE pp.NPOLIZA    = lvaNmPoliza
   AND pp.NCERTIFICADO = lvaNmCertificado
   AND pp.DNI          = p.DNI
   AND pp.CODIGO      IN ('020','120');

  CURSOR lcuDatosPoliza IS
   SELECT C.CDAGENTE, c.CDDELEGACION_RADICA
   FROM CUERPOLIZA c
   WHERE c.NPOLIZA = lvaNmPoliza;

  CURSOR lcuTipoReserva IS
   SELECT D.CDTIPO_RESERVA, d.CDRAMO_CONTABLE
   FROM DIC_ALIAS_COBERTURAS D
   WHERE D.CDRAMO       = lvaCdRamo
   AND D.CDSUBRAMO      = lvaCdSubRamo
   AND d.CDGARANTIA     = lvaCdGarantia
   AND d.CDSUBGARANTIA  = lvaCdSubGarantia;

  CURSOR lcuMunicipioIca IS
   SELECT a.CDMUNICIPIO
   FROM AGE_DELEGACIONES a
   WHERE a.CDDELEGACION = lvaCdOficinaRegistro;

  CURSOR lcuSnBancaseguros IS
   SELECT SNBANCASEGUROS
   FROM DIC_ALIAS_RS
   WHERE CDRAMO  = lvaCdRamo
   AND CDSUBRAMO = lvaCdSubRamo;

  CURSOR lcuCdUsuario IS
   SELECT CODIGO_USUARIO
   FROM HISTORICO
   WHERE EXPEDIENTE             = ivaNmExpediente
   AND NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion;

      --JuanAlNo Cursor temporal para obtener los datos de las garantias desde el detalle de los pagos, Asi validar condicion
   --unicamente para planes que no pagan copagos y coutas moderadores
   CURSOR lcuDatosTempGarantia IS
   SELECT CDGARANTIA, CDSUBGARANTIA 
   FROM SIN_PAGOS_DET 
	WHERE EXPEDIENTE = ivaNmExpediente 
	AND NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion;

  BEGIN

  --Datos generales del mensaje que necesita Surabroker ...
  --Parametrizables
  lvaMensajeTecnico            := 'Valores Iniciales';
  lobjTyinf.CDCONSUMIDOR       := 'SINIESTROS';
  lobjTyinf.CDSERVICIO         := 'SiniestrosCxP';
  lobjTyinf.CDOPERACION        := 'SI_os_WS_SiniestrosCxP';
  --lobjTyinf.CDTOKEN          := ''; hasta donde s?, no aplica
  lobjTyinf.CDVERSION_SERVICIO := '1.0';
  lobjTyinf.DSNAME_SPACE       := NULL;
  lobjTyinf.DSPUERTO           := 'HTTP_Port';

  --No Parametrizables
  lobjTyinf.DSCLAVE            := ivaNmPagoAutorizacion;
  lobjTyinf.FECREACION         := SYSDATE;
  lobjTyinf.NMPRIORIDAD        := NULL;

  SP_USUARIO (lvaDsUsuario, lvaDsClave, lvaMensajeTecnicoExt, lvaMensajeUsuarioExt);

  ltyEncabezadoMens            := TAB_SBK_ENC_MENSAJE(OBJ_SBK_ENC_MENSAJE( PCK_SBK_SURABROKER.HEADER_BASIC_AUTH_USER,lvaDsUsuario));
  ltyEncabezadoMens.EXTEND;
  ltyEncabezadoMens(2)         := OBJ_SBK_ENC_MENSAJE( PCK_SBK_SURABROKER.HEADER_BASIC_AUTH_PASSWORD,lvaDsClave);  lobjTyinf.TYENCABEZADOS      := ltyEncabezadoMens;


----------------------------------------------------------------------------------------------------------------------
  --Datos de la cabecera de la Cuenta por pagar
  FOR cab IN lcuDatosCabecera LOOP
   lvaCdRamo    := cab.CDRAMO;
   lvaCdSubRamo := cab.CDSUBRAMO;
   lvaDni       := cab.DNI;

   --Datos de conversi?n que solicita SAP
   lobjDatosConversion.cdFuente       := 'SIN';
   lobjDatosConversion.nmAplicacion   := '79';
   OPEN lcuSnBancaseguros;
   FETCH lcuSnBancaseguros INTO lvaSnBancaseguros;
   CLOSE lcuSnBancaseguros;
   IF lvaSnBancaseguros = 'S' THEN
    lobjDatosConversion.cdCanal := 'BAN';
   ELSE
    lobjDatosConversion.cdCanal := 'SEG';
   END IF;

   lobjCabecera.datosConversionOrigen := lobjDatosConversion;


   PCK_GESTION_PRODUCTOS.SPGET_COMPANIA_PRODUCTO( cab.cdramo,cab.cdsubramo,lvaCdCompania,lvaCdciaMatriz,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);
   lobjCabecera.feFactura             := cab.FEPAGO;
   lobjCabecera.cdCompania            := lvaCdCompania;
   lobjCabecera.feRegistroSap         := cab.FEPAGO;
   lobjCabecera.nmPeriodo             := TO_CHAR(cab.FEPAGO,'MM');

   -- Todos los pagos de Sura se hacen en moneda pesos
   lobjCabecera.cdMoneda              := cab.cdMoneda;
   lobjCabecera.ptTasaCambio          := NULL;
   lobjCabecera.feTasaCambio          := NULL;

   -- Para la referencia (dsFacturaOrdenPago) se toman la 8 primeras de la factura - las 7 primeras de la orden de pago
   OPEN lcuDatosFactura;
   FETCH lcuDatosFactura INTO lvaNmFactura,lvaNmPrefijo;
   CLOSE lcuDatosFactura;

   lobjCabecera.nmOrdenPago           := ivaNmPagoAutorizacion;
   IF LENGTH(TRIM(lvaNmPrefijo)) > 9 THEN
      lvaNmPrefijo                    := SUBSTR(lvaNmPrefijo,(LENGTH(TRIM(lvaNmPrefijo))-8));
   END IF;
   IF TRIM(lvaNmPrefijo) IS NOT NULL THEN
      lobjCabecera.nmFactura          := lvaNmPrefijo ||'-'||lvaNmFactura;
   ELSE
      lobjCabecera.nmFactura          := lvaNmFactura;
   END IF;

   lvaSnCalcularImpuestos             := 'S';

   OPEN lcuDatosCaja;
   FETCH lcuDatosCaja INTO lvaFeposiblePago, lvaCdViaPago, lvaCdbloqueoPago,
                           lvaCdPaisBanco, lvaCdBanco, lvaNmCuenta, cdTipoCuenta,
                           lvaCdSucursalBanco, lvaDsTitular;
   CLOSE lcuDatosCaja;

   IF lvaCdViaPago = 'CP' THEN
    lvaCdbloqueoPago := 'F';
    lvaCdViaPago     := 'CA';
   END IF;


   -- Datos de la cuenta
   lobjCuentaBancaria.cdPaisBanco     := lvaCdPaisBanco;
   lobjCuentaBancaria.cdBanco         := lvaCdBanco;
   lobjCuentaBancaria.nmCuenta        := lvaNmCuenta;
   lobjCuentaBancaria.cdTipoCuenta    := cdTipoCuenta;
   lobjCuentaBancaria.dsTitular       := lvaDsTitular;

   lvaNmExpediente                    := ivaNmExpediente;
   lvaNmCertificado                   := cab.NCERTIFICADO;
   lobjCondicionPago.cdCondicionPago  := '0';
   lvaDsTextoPosicion                 := 'AUTORIZACIONES SINIESTROS';
   lvaCdOperacion                     := cab.CDOPERACION;
   lvaNmBeneficiarioPago              := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(cab.DNI);
   lvaCdOficinaRegistro               := cab.CDENTIDAD;
   lvaNmPoliza                        := cab.NPOLIZA;
    lvaCdRamo                          := cab.CDRAMO;
   lnuIvaDescontable                  := cab.IMPIRPF;
   lnuDeducible                       := cab.DEDUCIBLE;
   lnuPtDescuento                     := cab.PTDESCUENTO;



  END LOOP; --lcuDatosCabecera
--Fin de CABECERA
----------------------------------------------------------------------------------------------------------------------
-- Cursores de Documentos

  FOR doc IN lcuDatosDocumentoFyC LOOP

   lvaCodIva                          := LPAD(REPLACE(TO_CHAR(RPAD(DOC.POIRPF,4,'0')),',',''),4,'0');
   lvaNumeroReserva                   := doc.NUMERO_RESERVA;
   lvaPoIrpf                          := doc.POIRPF;
   lvaCdRetencion                     := doc.CDRETENCION;

   lnuContadorDocumentos              := lnuContadorDocumentos + 1;
   lobjDocumento                      := OBJ_SAP_DOCUMENTO_CXP_SINI();
   lobjDocumento.cdOficinaRegistro    := lvaCdOficinaRegistro;
   lobjDocumento.ptImporte            := doc.importe;
   lobjDocumento.snCalcularImpuestos  := lvaSnCalcularImpuestos;
   lobjDocumento.cdIva                := lvaCodIva;
   lobjDocumento.fePosiblePago        := lvaFeposiblePago;

   lobjDocumento.condicionPago        := lobjCondicionPago;

   lobjDocumento.nmBeneficiarioPago   := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(lvaDni);
   lobjDocumento.cdTipoIdentificacion := PCK_SIC_UTILITARIOS_I.FN_SIC_CDTIPO_IDENTIFICACION(lvaDni);

   lobjDocumento.cdViaPago            := lvaCdViaPago;
   lobjDocumento.cdBloqueoPago        := lvaCdbloqueoPago;
   lobjDocumento.dsTextoPosicion      := lvaDsTextoPosicion;
   lobjDocumento.nmPoliza             := lvaNmPoliza;
   lobjDocumento.cdRamo               := lvaCdRamo;
   lobjDocumento.cdOperacion          := lvaCdOperacion;
   lobjDocumento.cdTipoReserva        := NULL; -- Va en null porque no aplica el tipo de reserva para Fondo y Cesion

  --Llenado de la tabla de Retenciones.
   lvaCdRetencion                     := doc.CDRETENCION;
   lnuImpIrc                          := doc.IMPIRC;
   lnuImpIrpfRetenido                 := doc.IMPIRPF_RETENIDO;
   lnuImpIca                          := doc.IMPICA;

   lnuContadorRetencion               := 0;
   lobjRetenciones                    := TAB_SAP_DATOS_RETENCIONES(OBJ_SAP_DATO_RETENCION());
   IF NVL(lnuImpIrc,0) <> 0 THEN
    lnuContadorRetencion                := lnuContadorRetencion + 1;
    lobjRetencion.cdtipoRetencion       := lvaCdRetencion;
    lobjRetencion.cdindicadorRetencion  := 'R';
    lobjRetencion.ptBaseRetencion       := doc.BASEIMPUESTOS;
    lobjRetencion.ptRetencion           := doc.POIRC;

    IF lnuContadorRetencion = 1 THEN
     lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
    ELSE
     lobjRetenciones.Extend;
     lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
    END IF;
   END IF;

   IF NVL(lnuImpIrpfRetenido,0) <> 0 THEN
    lnuContadorRetencion                := lnuContadorRetencion + 1;
    lobjRetencion.cdtipoRetencion       := lvaCdRetencion;
    lobjRetencion.cdindicadorRetencion  := 'I';
    lobjRetencion.ptBaseRetencion       := doc.BASEIMPUESTOS;
    lobjRetencion.ptRetencion           := doc.POIRPF_RETENIDO;

    IF lnuContadorRetencion = 1 THEN
     lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
    ELSE
     lobjRetenciones.Extend;
     lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
    END IF;
   END IF;

   IF NVL(lnuImpIca,0) <> 0 THEN
    OPEN lcuMunicipioIca;
    FETCH lcuMunicipioIca INTO lvaMunicipioIca;
    CLOSE lcuMunicipioIca;
    lnuContadorRetencion                := lnuContadorRetencion + 1;
    lobjRetencion.cdtipoRetencion       := lvaCdRetencion;
    lobjRetencion.cdindicadorRetencion  := lvaMunicipioIca;
    lobjRetencion.ptBaseRetencion       := doc.BASEIMPUESTOS;
    lobjRetencion.ptRetencion           := doc.POICA;

    IF lnuContadorRetencion = 1 THEN
     lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
    ELSE
     lobjRetenciones.Extend;
     lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
    END IF;
   END IF;

   lobjDocumento.retenciones        := lobjRetenciones;

   IF doc.NUMERO_RESERVA = 'P012091' THEN
    lvaCdConcepto  := '11';
   ELSIF doc.NUMERO_RESERVA = 'P012081' THEN
    lvaCdConcepto  := '5';
   ELSIF doc.NUMERO_RESERVA = 'P012093' THEN
    lvaCdConcepto  := '7';
   ELSIF doc.NUMERO_RESERVA = 'P012096' THEN
    lvaCdConcepto  := '3';
   END IF;
   lobjDocumento.cdConcepto := lvaCdConcepto;

  --Llenado de la tabla de Detalles para tipo de reserva de Fondo de ahorro y Valores de Cesion.
   lnuContadorDetalle := 0;
   lobjTabDetalles := tab_sap_detalles_cxp_sini(obj_sap_detalle_cxp_sini());
   FOR reg IN lcuDatosPagosFyC LOOP

    lvaCdRamo                       := reg.CDRAMO;
    lvaCdSubramo                    := reg.CDSUBRAMO;
    lvaCdGarantia                   := reg.CDGARANTIA;
    lvaCdSubGarantia                := reg.CDSUBGARANTIA;

    OPEN lcuTipoReserva;
    FETCH lcuTipoReserva INTO lvaCdTipoReserva,lvaCdramoContable;
    CLOSE lcuTipoReserva;

    lnuContadorDetalle              := lnuContadorDetalle + 1;
    lobjDetalle.cdTipoReserva       := lvaCdTipoReserva;

    IF lvaCdRamo = '081' AND lvaCdTipoReserva = 'T' THEN
     lobjDetalle.cdRamo              := 'MVI';
    ELSE
     lobjDetalle.cdRamo              := lvaCdramoContable;
    END IF;

    lobjDetalle.nmPoliza            := lvaNmPoliza;

    OPEN lcuDatosPoliza;
    FETCH lcuDatosPoliza INTO lvaCdAgente, lvaCdDelegacionRadica;
    CLOSE lcuDatosPoliza;

    lobjDetalle.cdIntermediario     := lvaCdAgente;
    lobjDetalle.cdOficinaRadicacion := lvaCdDelegacionRadica;
    lobjDetalle.nmExpediente        := lvaNmExpediente;

    OPEN lcuAsegurado;
    FETCH lcuAsegurado INTO lvaDniAsegurado;
    CLOSE lcuAsegurado;
    lvaNmAsegurado := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(lvaDniAsegurado);
    lobjDetalle.nmAsegurado         := lvaNmAsegurado;
    lobjDetalle.ptImporte           := REG.IMPORTE;

    lobjDetalle.cdCentroCostos      := lvaCdDelegacionRadica;

    OPEN lcuDatosSiniestro;
    FETCH lcuDatosSiniestro INTO ldaFeOcurrencia, ldaFenotificacion;
    CLOSE lcuDatosSiniestro;
    lobjDetalle.feAviso             := ldaFenotificacion;
    lobjDetalle.feOcurrencia        := ldaFeOcurrencia;

    lobjDetalle.cdIndicadorImpuesto := lvaCodIva;

    PCK_GESTION_PRODUCTOS.SPGET_COMPANIA_PRODUCTO( reg.cdramo,reg.cdsubramo,lvaCdCompania,lvaCdciaMatriz,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);
    lobjDetalle.cdCompaniaParametro := lvaCdCompania;

    IF lvaCdRamo = '041' THEN
     lobjDetalle.cdRamoParametro := '041';
    ELSIF lvaCdRamo = '092' THEN
     lobjDetalle.cdRamoParametro := '092';
    ELSE
     lobjDetalle.cdRamoParametro := 'N';
    END IF;

    lobjDetalle.cdOperacion                := lvaCdOperacion;

    lobjDetalle.cdConcepto                 := lvaCdConcepto;

    lobjDetalle.dsTextoPosicion            := lvaNmExpediente||'-'||'FONDO AHORRO Y VLR CESION';

    IF lnuContadorDetalle = 1 THEN
       lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
    ELSE
       lobjTabDetalles.Extend;
       lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
    END IF;

   -----------------------------------------------------------------------------------------
    -- Se excluye la renta y lucro cesante para identificar si es un proveedor
    -- No se va a utilizar, dado que siempre se va a llenar la informaci?n del tercero.
    -- Se deja por el momento por si en las pruebas se requiere enviar solo los proveedores.
    IF lvaCdRetencion NOT IN (NULL,'0099','0028','0029','U','UL','S025','S026','S047') THEN
     lvanmIdentificacionProveedor := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(reg.DNI);
     lvacdTipoIdentificacionProv  := PCK_SIC_UTILITARIOS_I.FN_SIC_CDTIPO_IDENTIFICACION(reg.DNI);
    END IF;
   -----------------------------------------------------------------------------------------

   END LOOP;
   lobjDocumento.detalleSiniestros                   := lobjTabDetalles;

   lobjDocumento.cuentaBancaria := lobjCuentaBancaria;

   IF lnuContadorDocumentos = 1 THEN
    lobjDocumentos(lnuContadorDocumentos) := lobjDocumento;
   ELSE
    lobjDocumentos.Extend;
    lobjDocumentos(lnuContadorDocumentos) := lobjDocumento;
   END IF;

  END LOOP;-- lcuDatosDocumentoFyC

----------------------------------------------------------------------------------------------------------------------
  lobjTabDetalles := tab_sap_detalles_cxp_sini(obj_sap_detalle_cxp_sini());
  lobjRetenciones := tab_sap_datos_retenciones(obj_sap_dato_retencion());
  lobjDocumento   := obj_sap_documento_cxp_sini();
  lobjRetencion   := obj_sap_dato_retencion();
  lobjDetalle     := obj_sap_detalle_cxp_sini();
  FOR doc IN lcuDatosDocumentoRes LOOP

   lvaCodIva                        := LPAD(REPLACE(TO_CHAR(RPAD(DOC.POIRPF,4,'0')),',',''),4,'0');
   lvaPoIrpf                        := doc.POIRPF;
   lvaCdRetencion                   := doc.CDRETENCION;
   lvaCdTipoReserva                 := doc.CDTIPO_RESERVA;


   lnuContadorDocumentos            := lnuContadorDocumentos + 1;
   lobjDocumento                    := OBJ_SAP_DOCUMENTO_CXP_SINI();

   lobjDocumento.nmBeneficiarioPago := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(lvaDni);
   lobjDocumento.cdTipoIdentificacion := PCK_SIC_UTILITARIOS_I.FN_SIC_CDTIPO_IDENTIFICACION(lvaDni);

   lobjDocumento.cdOficinaRegistro  := lvaCdOficinaRegistro;
   lobjDocumento.ptImporte          := doc.importe;
   lobjDocumento.snCalcularImpuestos:= lvaSnCalcularImpuestos;
   lobjDocumento.cdIva              := lvaCodIva;
   lobjDocumento.fePosiblePago      := lvaFeposiblePago;

   lobjDocumento.condicionPago     := lobjCondicionPago;

   lobjDocumento.cdViaPago          := lvaCdViaPago;
   lobjDocumento.cdBloqueoPago      := lvaCdbloqueoPago;
   lobjDocumento.dsTextoPosicion    := lvaDsTextoPosicion;
   lobjDocumento.nmPoliza           := lvaNmPoliza;
   lobjDocumento.cdRamo             := lvaCdRamo;
   lobjDocumento.cdOperacion        := lvaCdOperacion;
   lobjDocumento.cdTipoReserva      := doc.CDTIPO_RESERVA;


  --Llenado de la tabla de Retenciones.
   lvaCdRetencion                   := doc.CDRETENCION;
   lnuImpIrc                        := doc.IMPIRC;
   lnuImpIrpfRetenido               := doc.IMPIRPF_RETENIDO;
   lnuImpIca                        := doc.IMPICA;

   lnuContadorRetencion             := 0;
   lobjRetenciones                  := TAB_SAP_DATOS_RETENCIONES(OBJ_SAP_DATO_RETENCION());

   IF NVL(lnuImpIrc,0) <> 0 THEN
    lnuContadorRetencion                := lnuContadorRetencion + 1;
    lobjRetencion.cdtipoRetencion       := lvaCdRetencion;
    lobjRetencion.cdindicadorRetencion  := 'R';
    lobjRetencion.ptBaseRetencion       := doc.BASEIMPUESTOS;
    lobjRetencion.ptRetencion           := doc.POIRC;
    IF lnuContadorRetencion = 1 THEN
     lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
    ELSE
     lobjRetenciones.Extend;
     lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
    END IF;
   END IF;

   IF NVL(lnuImpIrpfRetenido,0) <> 0 THEN
    lnuContadorRetencion                := lnuContadorRetencion + 1;
    lobjRetencion.cdtipoRetencion       := lvaCdRetencion;
    lobjRetencion.cdindicadorRetencion  := 'I';
    lobjRetencion.ptBaseRetencion       := doc.BASEIMPUESTOS;
    lobjRetencion.ptRetencion           := doc.POIRPF_RETENIDO;
    IF lnuContadorRetencion = 1 THEN
     lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
    ELSE
     lobjRetenciones.Extend;
     lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
    END IF;
   END IF;

   IF NVL(lnuImpIca,0) <> 0 THEN
    OPEN lcuMunicipioIca;
    FETCH lcuMunicipioIca INTO lvaMunicipioIca;
    CLOSE lcuMunicipioIca;
    lnuContadorRetencion                := lnuContadorRetencion + 1;
    lobjRetencion.cdtipoRetencion       := lvaCdRetencion;
    lobjRetencion.cdindicadorRetencion  := lvaMunicipioIca;
    lobjRetencion.ptBaseRetencion       := doc.BASEIMPUESTOS;
    lobjRetencion.ptRetencion           := doc.POICA;
    IF lnuContadorRetencion = 1 THEN
     lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
    ELSE
     lobjRetenciones.Extend;
     lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
    END IF;
   END IF;

   lobjDocumento.retenciones        := lobjRetenciones;

   IF doc.CDTIPO_RESERVA = 'T' THEN
    lvaCdConcepto  := '1';
	-- JuanAlNo Se realiza validacion si son subramos que pertenecen a los productos de Salud para todos integral 
    IF lvaCdSubRamo in ('PVF','PVC') THEN
	 FOR cur IN lcuDatosTempGarantia LOOP
	  IF cur.CDGARANTIA = 'SK9' AND cur.CDSUBGARANTIA = 'NDX' THEN
	   lvaCdConcepto  := 'CO';
	  ELSIF cur.CDGARANTIA = 'SN4' AND cur.CDSUBGARANTIA = 'NDX' THEN
	   lvaCdConcepto  := 'MO';
	  END IF;
	 END LOOP;
    END IF;
   ELSE
    lvaCdConcepto  := '2';
   END IF;
   lobjDocumento.cdConcepto := lvaCdConcepto;

  --Llenado de la tabla de Detalles para tipo de reserva Matematica y T?cnina.
   lnuContadorDetalle := 0;
   lobjTabDetalles := tab_sap_detalles_cxp_sini(obj_sap_detalle_cxp_sini());
   FOR reg IN lcuDatosPagosRes LOOP
    lvaCdRamo                       := reg.CDRAMO;
    lvaCdSubramo                    := reg.CDSUBRAMO;
    lvaCdGarantia                   := reg.CDGARANTIA;
    lvaCdSubGarantia                := reg.CDSUBGARANTIA;

    lobjDetalle.cdConcepto          := lvaCdConcepto;


    OPEN lcuTipoReserva;
    FETCH lcuTipoReserva INTO lvaCdTipoReserva,lvaCdramoContable;
    CLOSE lcuTipoReserva;

    lnuContadorDetalle              := lnuContadorDetalle + 1;
    lobjDetalle.cdTipoReserva       := lvaCdTipoReserva;

    IF lvaCdRamo = '081' AND lvaCdTipoReserva = 'T' THEN
     lobjDetalle.cdRamo              := 'MVI';
    ELSE
     lobjDetalle.cdRamo              := lvaCdramoContable;
    END IF;

    lobjDetalle.nmPoliza            := lvaNmPoliza;

    OPEN lcuDatosPoliza;
    FETCH lcuDatosPoliza INTO lvaCdAgente, lvaCdDelegacionRadica;
    CLOSE lcuDatosPoliza;

    lobjDetalle.cdIntermediario     := lvaCdAgente;
    lobjDetalle.cdOficinaRadicacion := lvaCdDelegacionRadica;
    lobjDetalle.nmExpediente        := lvaNmExpediente;

    OPEN lcuAsegurado;
    FETCH lcuAsegurado INTO lvaDniAsegurado;
    CLOSE lcuAsegurado;
    lvaNmAsegurado := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(lvaDniAsegurado);
    lobjDetalle.nmAsegurado         := lvaNmAsegurado;
    lobjDetalle.ptImporte           := REG.IMPORTE;

    lobjDetalle.cdCentroCostos      := lvaCdDelegacionRadica;

    OPEN lcuDatosSiniestro;
    FETCH lcuDatosSiniestro INTO ldaFeOcurrencia, ldaFenotificacion;
    CLOSE lcuDatosSiniestro;
    lobjDetalle.feAviso             := ldaFenotificacion;
    lobjDetalle.feOcurrencia        := ldaFeOcurrencia;

    lobjDetalle.cdIndicadorImpuesto := lvaCodIva;

    PCK_GESTION_PRODUCTOS.SPGET_COMPANIA_PRODUCTO( reg.cdramo,reg.cdsubramo,lvaCdCompania,lvaCdciaMatriz,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);
    lobjDetalle.cdCompaniaParametro := lvaCdCompania;

    IF lvaCdRamo = '041' THEN
     lobjDetalle.cdRamoParametro := '041';
    ELSIF lvaCdRamo = '092' THEN
     lobjDetalle.cdRamoParametro := '092';
    ELSE
     lobjDetalle.cdRamoParametro := 'N';
    END IF;

    lobjDetalle.cdOperacion         := lvaCdOperacion;


    lobjDetalle.dsTextoPosicion             := lvaNmExpediente||'-'||'RESERVA MATEMATICA Y TECNICA';

    IF lnuContadorDetalle = 1 THEN
       lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
    ELSE
       lobjTabDetalles.Extend;
       lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
    END IF;

   END LOOP;
   lobjDocumento.detalleSiniestros        := lobjTabDetalles;

   lobjDocumento.cuentaBancaria           := lobjCuentaBancaria;

   IF lnuContadorDocumentos = 1 THEN
    lobjDocumentos(lnuContadorDocumentos) := lobjDocumento;
   ELSE
    lobjDocumentos.Extend;
    lobjDocumentos(lnuContadorDocumentos) := lobjDocumento;
   END IF;

  END LOOP;-- lcuDatosDocumentoRes

----------------------------------------------------------------------------------------------------------------------
  -- Cursor para los documentos de totales de Deducible:8  Descuento financiero:9  Iva no descontable:10
  lobjTabDetalles := tab_sap_detalles_cxp_sini(obj_sap_detalle_cxp_sini());
  lobjDocumento   := obj_sap_documento_cxp_sini();
  lobjDetalle     := obj_sap_detalle_cxp_sini();
  FOR doc IN lcuDatosSumados LOOP

   lvaCodIva                        := '0000';

   lnuTotalDeducible                := doc.DEDUCIBLE;
   lnuTotalPtDescuento              := doc.PTDESCUENTO;
   lnuTotalIvaNoDescontable         := doc.IVANODESCONTABLE;

   OPEN lcuDatosPoliza;
   FETCH lcuDatosPoliza INTO lvaCdAgente, lvaCdDelegacionRadica;
   CLOSE lcuDatosPoliza;

   OPEN lcuAsegurado;
   FETCH lcuAsegurado INTO lvaDniAsegurado;
   CLOSE lcuAsegurado;
   lvaNmAsegurado := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(lvaDniAsegurado);

   OPEN lcuDatosSiniestro;
   FETCH lcuDatosSiniestro INTO ldaFeOcurrencia, ldaFenotificacion;
   CLOSE lcuDatosSiniestro;

   IF NVL(doc.DEDUCIBLE,0) <> 0 THEN
    -- Para DEDUCIBLE participaci?n del asegurado en el reclamo
    lnuContadorDocumentos            := lnuContadorDocumentos + 1;

    lobjDocumento                    := OBJ_SAP_DOCUMENTO_CXP_SINI();

    lobjDocumento.nmBeneficiarioPago   := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(lvaDni);
    lobjDocumento.cdTipoIdentificacion := PCK_SIC_UTILITARIOS_I.FN_SIC_CDTIPO_IDENTIFICACION(lvaDni);

    lobjDocumento.cdOficinaRegistro  := lvaCdOficinaRegistro;

    lobjDocumento.snCalcularImpuestos:= lvaSnCalcularImpuestos;
    lobjDocumento.cdIva              := lvaCodIva;
    lobjDocumento.fePosiblePago      := lvaFeposiblePago;

    lobjDocumento.condicionPago      := lobjCondicionPago;

    lobjDocumento.cdViaPago          := lvaCdViaPago;
    lobjDocumento.cdBloqueoPago      := lvaCdbloqueoPago;
    lobjDocumento.dsTextoPosicion    := lvaDsTextoPosicion;
    lobjDocumento.nmPoliza           := lvaNmPoliza;
    lobjDocumento.cdRamo             := lvaCdRamo;
    lobjDocumento.cdOperacion        := lvaCdOperacion;
    lobjDocumento.cdTipoReserva      := doc.CDTIPO_RESERVA;

    lobjDocumento.cdConcepto := '8';
    lobjDocumento.ptImporte  := lnuTotalDeducible;

    lnuContadorDetalle       := 0;
    FOR reg IN lcuDetalleSumadosDeducible LOOP
     lvaCdRamo                       := reg.CDRAMO;
     lvaCdSubramo                    := reg.CDSUBRAMO;
     lvaCdGarantia                   := reg.CDGARANTIA;
     lvaCdSubGarantia                := reg.CDSUBGARANTIA;

     lobjDetalle.cdConcepto          := '8';

     OPEN lcuTipoReserva;
     FETCH lcuTipoReserva INTO lvaCdTipoReserva,lvaCdramoContable;
     CLOSE lcuTipoReserva;

     lnuContadorDetalle              := lnuContadorDetalle + 1;
     lobjDetalle.cdTipoReserva       := lvaCdTipoReserva;

     IF lvaCdRamo = '081' AND lvaCdTipoReserva = 'T' THEN
      lobjDetalle.cdRamo              := 'MVI';
     ELSE
      lobjDetalle.cdRamo              := lvaCdramoContable;
     END IF;


     lobjDetalle.nmPoliza            := lvaNmPoliza;

     lobjDetalle.cdIntermediario     := lvaCdAgente;
     lobjDetalle.cdOficinaRadicacion := lvaCdDelegacionRadica;
     lobjDetalle.nmExpediente        := lvaNmExpediente;

     lobjDetalle.nmAsegurado         := lvaNmAsegurado;
     lobjDetalle.ptImporte           := reg.DEDUCIBLE;


     lobjDetalle.cdCentroCostos      := lvaCdDelegacionRadica;

     lobjDetalle.feAviso             := ldaFenotificacion;
     lobjDetalle.feOcurrencia        := ldaFeOcurrencia;

     lobjDetalle.cdIndicadorImpuesto := lvaCodIva;

     PCK_GESTION_PRODUCTOS.SPGET_COMPANIA_PRODUCTO( reg.cdramo,reg.cdsubramo,lvaCdCompania,lvaCdciaMatriz,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);
     lobjDetalle.cdCompaniaParametro := lvaCdCompania;

     IF lvaCdRamo = '041' THEN
      lobjDetalle.cdRamoParametro := '041';
     ELSIF lvaCdRamo = '092' THEN
      lobjDetalle.cdRamoParametro := '092';
     ELSE
      lobjDetalle.cdRamoParametro := 'N';
     END IF;

     lobjDetalle.cdOperacion   := lvaCdOperacion;

--     lobjDetalle.cdConcepto    := lvaCdConcepto;

     lobjDetalle.dsTextoPosicion             := lvaNmExpediente||'-'||'DEDUCIBLE';

     IF lnuContadorDetalle = 1 THEN
      lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
     ELSE
      lobjTabDetalles.Extend;
      lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
     END IF;

    END LOOP;

    lobjDocumento.detalleSiniestros        := lobjTabDetalles;
    lobjDocumento.cuentaBancaria           := lobjCuentaBancaria;

    IF lnuContadorDocumentos = 1 THEN
     lobjDocumentos(lnuContadorDocumentos) := lobjDocumento;
    ELSE
     lobjDocumentos.Extend;
     lobjDocumentos(lnuContadorDocumentos) := lobjDocumento;
    END IF;
   END IF;
   IF NVL(doc.PTDESCUENTO,0) <> 0 THEN
    -- Para DESCUENTO financiero o pronto pago
    lnuContadorDocumentos            := lnuContadorDocumentos + 1;

    lobjDocumento                    := OBJ_SAP_DOCUMENTO_CXP_SINI();

    lobjDocumento.nmBeneficiarioPago   := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(lvaDni);
    lobjDocumento.cdTipoIdentificacion := PCK_SIC_UTILITARIOS_I.FN_SIC_CDTIPO_IDENTIFICACION(lvaDni);

    lobjDocumento.cdOficinaRegistro  := lvaCdOficinaRegistro;

    lobjDocumento.snCalcularImpuestos:= lvaSnCalcularImpuestos;
    lobjDocumento.cdIva              := lvaCodIva;
    lobjDocumento.fePosiblePago      := lvaFeposiblePago;

    lobjDocumento.condicionPago      := lobjCondicionPago;

    lobjDocumento.cdViaPago          := lvaCdViaPago;
    lobjDocumento.cdBloqueoPago      := lvaCdbloqueoPago;
    lobjDocumento.dsTextoPosicion    := lvaDsTextoPosicion;
    lobjDocumento.nmPoliza           := lvaNmPoliza;
    lobjDocumento.cdRamo             := lvaCdRamo;
    lobjDocumento.cdOperacion        := lvaCdOperacion;
    lobjDocumento.cdTipoReserva      := doc.CDTIPO_RESERVA;

    lobjDocumento.cdConcepto := '9';
    lobjDocumento.ptImporte  := lnuTotalPtDescuento;

    lnuContadorDetalle        := 0;
    FOR reg IN lcuDetalleSumadosDescuento LOOP
     lvaCdRamo                       := reg.CDRAMO;
     lvaCdSubramo                    := reg.CDSUBRAMO;
     lvaCdGarantia                   := reg.CDGARANTIA;
     lvaCdSubGarantia                := reg.CDSUBGARANTIA;

     lobjDetalle.cdConcepto          := '9';

     OPEN lcuTipoReserva;
     FETCH lcuTipoReserva INTO lvaCdTipoReserva,lvaCdramoContable;
     CLOSE lcuTipoReserva;

     lnuContadorDetalle              := lnuContadorDetalle + 1;
     lobjDetalle.cdTipoReserva       := lvaCdTipoReserva;

     IF lvaCdRamo = '081' AND lvaCdTipoReserva = 'T' THEN
      lobjDetalle.cdRamo              := 'MVI';
     ELSE
      lobjDetalle.cdRamo              := lvaCdramoContable;
     END IF;

     lobjDetalle.nmPoliza            := lvaNmPoliza;

     lobjDetalle.cdIntermediario     := lvaCdAgente;
     lobjDetalle.cdOficinaRadicacion := lvaCdDelegacionRadica;
     lobjDetalle.nmExpediente        := lvaNmExpediente;

     lobjDetalle.nmAsegurado         := lvaNmAsegurado;
     lobjDetalle.ptImporte           := reg.PTDESCUENTO;

     lobjDetalle.cdCentroCostos      := lvaCdDelegacionRadica;

     lobjDetalle.feAviso             := ldaFenotificacion;
     lobjDetalle.feOcurrencia        := ldaFeOcurrencia;

     lobjDetalle.cdIndicadorImpuesto := lvaCodIva;

     PCK_GESTION_PRODUCTOS.SPGET_COMPANIA_PRODUCTO( reg.cdramo,reg.cdsubramo,lvaCdCompania,lvaCdciaMatriz,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);
     lobjDetalle.cdCompaniaParametro := lvaCdCompania;

     IF lvaCdRamo = '041' THEN
      lobjDetalle.cdRamoParametro := '041';
     ELSIF lvaCdRamo = '092' THEN
      lobjDetalle.cdRamoParametro := '092';
     ELSE
      lobjDetalle.cdRamoParametro := 'N';
     END IF;

     lobjDetalle.cdOperacion   := lvaCdOperacion;

--     lobjDetalle.cdConcepto    := lvaCdConcepto;

     lobjDetalle.dsTextoPosicion             := lvaNmExpediente||'-'||'IVA DESCUENTO FINANCIERO';

     IF lnuContadorDetalle = 1 THEN
      lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
     ELSE
      lobjTabDetalles.Extend;
      lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
     END IF;

    END LOOP;

    lobjDocumento.detalleSiniestros        := lobjTabDetalles;
    lobjDocumento.cuentaBancaria           := lobjCuentaBancaria;

    IF lnuContadorDocumentos = 1 THEN
     lobjDocumentos(lnuContadorDocumentos) := lobjDocumento;
    ELSE
     lobjDocumentos.Extend;
     lobjDocumentos(lnuContadorDocumentos) := lobjDocumento;
    END IF;

   END IF;
   IF NVL(doc.IVANODESCONTABLE,0) <> 0 THEN
    -- Para IVA NO DESCOBTABLE
    lnuContadorDocumentos            := lnuContadorDocumentos + 1;

    lobjDocumento                    := OBJ_SAP_DOCUMENTO_CXP_SINI();

    lobjDocumento.nmBeneficiarioPago   := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(lvaDni);
    lobjDocumento.cdTipoIdentificacion := PCK_SIC_UTILITARIOS_I.FN_SIC_CDTIPO_IDENTIFICACION(lvaDni);

    lobjDocumento.cdOficinaRegistro  := lvaCdOficinaRegistro;

    lobjDocumento.snCalcularImpuestos:= lvaSnCalcularImpuestos;
    lobjDocumento.cdIva              := lvaCodIva;
    lobjDocumento.fePosiblePago      := lvaFeposiblePago;

    lobjDocumento.condicionPago      := lobjCondicionPago;

    lobjDocumento.cdViaPago          := lvaCdViaPago;
    lobjDocumento.cdBloqueoPago      := lvaCdbloqueoPago;
    lobjDocumento.dsTextoPosicion    := lvaDsTextoPosicion;
    lobjDocumento.nmPoliza           := lvaNmPoliza;
    lobjDocumento.cdRamo             := lvaCdRamo;
    lobjDocumento.cdOperacion        := lvaCdOperacion;
    lobjDocumento.cdTipoReserva      := doc.CDTIPO_RESERVA;

    lobjDocumento.cdConcepto := '10';

    lobjDocumento.ptImporte  := lnuTotalIvaNoDescontable;

    lnuContadorDetalle       := 0;
    FOR reg IN lcuDetalleSumadosIMPIRPF LOOP
       lvaCdRamo                       := reg.CDRAMO;
       lvaCdSubramo                    := reg.CDSUBRAMO;
       lvaCdGarantia                   := reg.CDGARANTIA;
       lvaCdSubGarantia                := reg.CDSUBGARANTIA;

       lobjDetalle.cdConcepto          := 'PAR';
       lobjDetalle.cdConceptoAdicional := 'CON';


       OPEN lcuTipoReserva;
       FETCH lcuTipoReserva INTO lvaCdTipoReserva,lvaCdramoContable;
       CLOSE lcuTipoReserva;

       lnuContadorDetalle              := lnuContadorDetalle + 1;
       lobjDetalle.cdTipoReserva       := lvaCdTipoReserva;

       IF lvaCdRamo = '081' AND lvaCdTipoReserva = 'T' THEN
        lobjDetalle.cdRamo              := 'MVI';
       ELSE
        lobjDetalle.cdRamo              := lvaCdramoContable;
       END IF;

       lobjDetalle.nmPoliza            := lvaNmPoliza;

       lobjDetalle.cdIntermediario     := lvaCdAgente;
       lobjDetalle.cdOficinaRadicacion := lvaCdDelegacionRadica;
       lobjDetalle.nmExpediente        := lvaNmExpediente;

       lobjDetalle.nmAsegurado         := lvaNmAsegurado;
       lobjDetalle.ptImporte           := reg.IVANODESCONTABLE;

       lobjDetalle.cdCentroCostos      := lvaCdDelegacionRadica;

       lobjDetalle.feAviso             := ldaFenotificacion;
       lobjDetalle.feOcurrencia        := ldaFeOcurrencia;

       lobjDetalle.cdIndicadorImpuesto := lvaCodIva;

       PCK_GESTION_PRODUCTOS.SPGET_COMPANIA_PRODUCTO( reg.cdramo,
                                                      reg.cdsubramo,
                                                      lvaCdCompania,
                                                      lvaCdciaMatriz,
                                                      lvaMensajeTecnicoExt,
                                                      lvaMensajeUsuarioExt);
       lobjDetalle.cdCompaniaParametro := lvaCdCompania;

       IF lvaCdRamo = '041' THEN
        lobjDetalle.cdRamoParametro := '041';
       ELSIF lvaCdRamo = '092' THEN
        lobjDetalle.cdRamoParametro := '092';
       ELSE
        lobjDetalle.cdRamoParametro := 'N';
       END IF;

       lobjDetalle.cdOperacion   := lvaCdOperacion;

  --     lobjDetalle.cdConcepto    := lvaCdConcepto;

       lobjDetalle.dsTextoPosicion          := lvaNmExpediente||'-'||'IVA NO DESCONTABLE STROS';

       IF lnuContadorDetalle = 1 THEN
        lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
       ELSE
        lobjTabDetalles.Extend;
        lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
       END IF;

    END LOOP;
    lobjDocumento.detalleSiniestros        := lobjTabDetalles;
    lobjDocumento.cuentaBancaria           := lobjCuentaBancaria;

    IF lnuContadorDocumentos = 1 THEN
     lobjDocumentos(lnuContadorDocumentos) := lobjDocumento;
    ELSE
     lobjDocumentos.Extend;
     lobjDocumentos(lnuContadorDocumentos) := lobjDocumento;
    END IF;
   END IF;
  END LOOP; -- lcuDatosSumados

  --Datos de tercero
  OPEN lcuCdUsuario;
  FETCH lcuCdUsuario INTO lvaCdUsuario;
  CLOSE lcuCdUsuario;


  PCK_SIC_SAP.SP_SIC_POBLA_TERCERO_SAP(lvaDni,
                                       lvaCdUsuario,
                                       ltyTercero,
                                       lvaMensajeTecnicoExt,
                                       lvaMensajeUsuarioExt);
  IF lvaMensajeTecnicoExt IS NOT NULL OR lvaMensajeUsuarioExt IS NOT NULL THEN
   RAISE lexErrorProcedimientoExt;
  END IF;

  lobjtercero.dsTratamiento           := ltyTercero.dsTratamiento;
  lobjtercero.dsNombre                := ltyTercero.dsNombre;
  lobjtercero.dsApellidos             := ltyTercero.dsApellidos;
  lobjtercero.dsNombres               := ltyTercero.dsNombres;
  lobjtercero.dsDireccion             := ltyTercero.dsDireccion;
  lobjtercero.dsApartadoAereo         := ltyTercero.dsApartadoAereo;
  lobjtercero.cdPais                  := ltyTercero.cdPais;
  lobjtercero.cdRegion                := ltyTercero.cdRegion;
  lobjtercero.cdPoblacion             := ltyTercero.cdPoblacion;
  lobjtercero.cdIdioma                := ltyTercero.cdIdioma;

  lobjInfoFiscal.nmIdentificacion     := ltyTercero.nmIdentificacion;
  lobjInfoFiscal.cdTipoIdentificacion := ltyTercero.cdTipoId;

  lobjtercero.cuentaBancaria          := lobjCuentaBancaria;
  lobjtercero.informacionFiscal       := lobjInfoFiscal;

  lobjPago                            := OBJ_SAP_CXP_SINIESTROS() ;
  lobjPago.Tyinf                      := lobjTyinf;
  lobjPago.cabecera                   := lobjCabecera;
  lobjPago.documentosCXP              := lobjDocumentos;
  lobjPago.tercero                    := lobjtercero;
  RETURN lobjPago;


  EXCEPTION
      WHEN lexErrorProcedimientoExt THEN
        ovaMensajeTecnico:=lvaMensajeTecnicoExt;
        ovaMensajeUsuario:=lvaMensajeUsuarioExt;
        RETURN NULL;
      WHEN lexErrorProcedimiento THEN
        ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
        ovaMensajeUsuario:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeUsuario;
        RETURN NULL;
      WHEN OTHERS THEN
       ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
       ovaMensajeUsuario:= SQLERRM;--'TRANSACCION NO DISPONIBLE ' ;
       RETURN NULL;
  END FN_CREAR_MENSAJE_CXP_v6_0;

-----------------------------------------------------------------------------------------------------------
-- SALVAMENTOS
-- SALVAMENTOS
-- SALVAMENTOS
-----------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------------------

  FUNCTION FN_CREAR_MENSAJE_CXC(ivaNmExpediente        IN SIN_PAGOS_DET.EXPEDIENTE%TYPE,
                                ivaNmPagoAutorizacion  IN SIN_PAGOS_DET.NUMERO_PAGO_AUTORIZACION%TYPE,
                                ovaMensajeTecnico      OUT VARCHAR2,
                                ovaMensajeUsuario      OUT VARCHAR2,
                                ivaNmPagoVelru         IN NUMBER DEFAULT 0)
                                RETURN OBJ_SAP_CXC_SALVAMENTOS IS

  --Variables para el manejo de Errores
  lvaMensajeTecnico           VARCHAR2(1000)  := NULL;
  lvaMensajeTecnicoExt        VARCHAR2(1000)  := NULL;
  lvaMensajeUsuario           VARCHAR2(1000)  := NULL;
  lvaMensajeUsuarioExt        VARCHAR2(1000)  := NULL;
  lexErrorProcedimiento       EXCEPTION;
  lexErrorProcedimientoExt    EXCEPTION;
  lvaNombreObjeto             VARCHAR2(30)   :='FN_CREAR_MENSAJE_CXC';


  --Objeto para retornar con mensaje SAP
  lobjSalvamento                    OBJ_SAP_CXC_SALVAMENTOS     := OBJ_SAP_CXC_SALVAMENTOS();
  lobjTyinf                         OBJ_SBK_MENSAJE_INF         := OBJ_SBK_MENSAJE_INF(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
  ltyEncabezadoMens                 TAB_SBK_ENC_MENSAJE         := TAB_SBK_ENC_MENSAJE(OBJ_SBK_ENC_MENSAJE(NULL, NULL));
  lobjCabecera                      OBJ_SAP_CABECERA_CXC_SALV   := OBJ_SAP_CABECERA_CXC_SALV();
  lobjDetalle                       OBJ_SAP_POSICION_CXC_SALV   := OBJ_SAP_POSICION_CXC_SALV();
  lobjTabDetalles                   TAB_SAP_POSICIONES_CXC_SALV := TAB_SAP_POSICIONES_CXC_SALV(OBJ_SAP_POSICION_CXC_SALV ());
  lobjRetencion                     OBJ_SAP_DATO_RETENCION      := OBJ_SAP_DATO_RETENCION();
  lobjRetenciones                   TAB_SAP_DATOS_RETENCIONES   := TAB_SAP_DATOS_RETENCIONES(OBJ_SAP_DATO_RETENCION());
  lobjDatosConversion               OBJ_SAP_DATOS_CONVERSION    := OBJ_SAP_DATOS_CONVERSION();


-- PONER AQUI LO QUE VIENE SE SURACLIENTE

  lobjCreacionDeudor                OBJ_SAP_DEUDOR_CXC_SEG      := OBJ_SAP_DEUDOR_CXC_SEG();
  lobjDirDeudor                     OBJ_SAP_DIR_DEUDOR_CXC_SEG  := OBJ_SAP_DIR_DEUDOR_CXC_SEG();
  lobjCuentaBancaria                OBJ_SAP_BAN_DEUDOR_CXC_SEG  := OBJ_SAP_BAN_DEUDOR_CXC_SEG();
  lobjComDeudor                     OBJ_SAP_COM_DEUDOR_CXC_SEG  := OBJ_SAP_COM_DEUDOR_CXC_SEG();
  lobjEntDeudor                     OBJ_SAP_ENT_DEUDOR_CXC_SEG  := OBJ_SAP_ENT_DEUDOR_CXC_SEG();
  lobjCtrlDeudor                    OBJ_SAP_CTRL_DEUDOR_CXC_SEG :=OBJ_SAP_CTRL_DEUDOR_CXC_SEG();
  lvaDsUsuario                      T999_PARAMETROS.DSVALOR_PARAMETRO%TYPE;
  lvaDsClave                        T999_PARAMETROS.DSVALOR_PARAMETRO%TYPE;


  ltyjDirDeudor                     PCK_SIC_SAP.regDeudor;
--  ltyCuentasBancarias               PCK_SIC_SAP.regCuentasBancarias;
--  lvaNmSecuenciaSura                VARCHAR2(10);
  --Variables para llenar los Objetos
  lnuContadorDetalle                NUMBER                      := 0;
  lnuContadorRetencion              NUMBER                      := 0;

  --Variables propias del aplicativo
  lvaCdCompania                    DIC_ALIAS_RS.CDCIA%TYPE;
  lvaCdRamo                        SIN_PAGOS_DET.CDRAMO%TYPE;
  lvaCdSubRamo                     SIN_PAGOS_DET.CDSUBRAMO%TYPE;
  lvaCdGarantia                    SIN_PAGOS_DET.CDGARANTIA%TYPE;
  lvaCdSubGarantia                 SIN_PAGOS_DET.CDSUBGARANTIA%TYPE;
  lvaCdReserva                     SIN_PAGOS_DET.NUMERO_RESERVA%TYPE;

  lvaCdciaMatriz                   DIC_ALIAS_RS.CDCIA_MATRIZ%TYPE;
  lvaNmFactura                     SIN_FACTURAS.NMFACTURA%TYPE;
  lvaNmPrefijo                     SIN_FACTURAS.NMPREFIJO%TYPE;
  lvaSnCalcularImpuestos           VARCHAR2(1)                := 'S';
  lvaNmPoliza                      SIN_PAGOS_DET.NPOLIZA%TYPE;
  ldaFeOcurrencia                  SINIESTROS.FECHA_SINIESTRO%TYPE;
  ldaFenotificacion                SINIESTROS.FECHA_NOTIFICACION%TYPE;
  lvaFeposiblePago                 PAGOS.FEPOSIBLE_PAGO%TYPE;
  lvaCdMedioPago                   PAGOS.CDVIAPAGO%TYPE;
  lvaCdbloqueoPago                 PAGOS.CDBLOQUEOPAGO%TYPE;
  lvaCdPaisBanco                   PAGOS.CDPAISBANCO%TYPE;
  lvaCdBanco                       PAGOS.CDBANCO%TYPE;
  lvaNmCuenta                      PAGOS.NMCUENTA%TYPE;
  cdTipoCuenta                     PAGOS.CDTIPOCUENTA%TYPE;
  lvaCdSucursalBanco               PAGOS.CDSUCURSALBANCO%TYPE;
  lvaDsTitular                     PAGOS.DSTITULAR%TYPE;
  lvaCdTipoReserva                 DIC_ALIAS_COBERTURAS.CDTIPO_RESERVA%TYPE;
  lvaCdramoContable                DIC_ALIAS_COBERTURAS.CDRAMO_CONTABLE%TYPE;
  lvaCdRetencion                   SIN_PAGOS_DET.CDRETENCION%TYPE;
  lnuImpIrc                        SIN_PAGOS_DET.IMPIRC%TYPE;
--  lnuImpIca                        SIN_PAGOS_DET.IMPICA%TYPE;
  lvaCdAgente                      CUERPOLIZA.CDAGENTE%TYPE;
  lvaCdDelegacionRadica            CUERPOLIZA.CDDELEGACION_RADICA%TYPE;
  lvaMunicipioIca                  SIN_RETENCION_ICA.CDMUNICIPIO%TYPE;
  lnuPoIrpf                        SIN_DESC_RETENCIONES.PORETENCION%TYPE;

  lvaDsTextoPosicion               VARCHAR2(50);
  lvaCdOperacion                   PAGOS.CDOPERACION%TYPE;
  lvaCdOficinaRegistro             SIN_PAGOS_DET.CDENTIDAD%TYPE;
  lvaCodIva                        SIN_RETENCIONES.CDRETENCION%TYPE;
  lvaCdConcepto                    VARCHAR2(10);
  lvaSnBancaseguros                DIC_ALIAS_RS.SNBANCASEGUROS%TYPE;
  lvaDni                           PERSONAS.DNI%TYPE;
  lvaCdUsuario                     HISTORICO.CODIGO_USUARIO%TYPE;

  --Panam?
  ldaFeFecto                       CUERPOLIZA.FEFECTO%TYPE;
  ldaFeFectoAnualidad              CUERPOLIZA.FEFECTO_ANUALIDAD%TYPE;
  lvaDigitoVerificacion            PERSONAS.NMDIGITO_VER%TYPE;
  lvaSnRetPanama                   VARCHAR2(1); -- indica si la retencion es para panama

  --Coaseguro
  lvaTipoCoaseguro                 COA_TRATADO.CDCOA%TYPE;
  lvaIdSoloSura                    SIN_CLASES.CDCLASE%TYPE;
  lnuPorepartoCoa                  COA_TRATADO_DETALLE.POREPARTO_COA%TYPE;
  lvaCdCiaCoaseguradora            COMPANIAS.CDCIA%TYPE;
  lvaDniCoaseguradora              COMPANIAS.CIF%TYPE;

  lnuGastosEnvio                   SIN_PAGOS_DET.IMPORTE%TYPE;
  --Cursores para consultar la informacion

  -- Cursor base para el llenado de la Cabecera con el total de la CxP
  CURSOR lcuDatosCabecera IS
   SELECT s.CDRAMO, s.CDSUBRAMO, s.CDGARANTIA, s.CDSUBGARANTIA, s.NPOLIZA, S.NCERTIFICADO,
          s.CDENTIDAD, s.DNI, s.CDMONEDA, s.FEPAGO,
          DECODE(S.CARGO_ABONO,'A','907','C','916','907') CDOPERACION,
          s.CDRETENCION, s.POIRPF,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(s.IMPIRPF)),2),
                 ROUND(ABS(SUM(s.IMPIRPF))) ) IMPIRPF,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(s.IMPIRC)),2),
                  ROUND(ABS(SUM(s.IMPIRC))) ) IMPIRC,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(DEDUCIBLE)),2),
                 ROUND(ABS(SUM(DEDUCIBLE))) ) deducible,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(s.PTDESCUENTO)),2),
                 ROUND(ABS(SUM(s.PTDESCUENTO))) ) ptdescuento,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(s.IMPORTE - NVL(s.PTDESCUENTO,0))),2),
                 ROUND(ABS(SUM(s.IMPORTE - NVL(s.PTDESCUENTO,0)))) ) IMPORTE,
          SUM(DECODE(S.CARGO_ABONO,'A',DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(s.IMPORTE + s.DEDUCIBLE),2),
                                              (ROUND(ABS(s.IMPORTE + s.DEDUCIBLE)))
                                             ),
                                   'C',DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(s.IMPORTE- s.DEDUCIBLE),2),
                                              (ROUND(ABS(s.IMPORTE- s.DEDUCIBLE)))
                                             )
                     )
             ) IMPORTE_DET
   FROM SIN_PAGOS_DET s
   WHERE s.EXPEDIENTE             = ivaNmExpediente
   AND s.NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND s.NUMERO_RESERVA        LIKE 'R%'
   GROUP BY s.CDRAMO, s.CDSUBRAMO, s.CDGARANTIA, s.CDSUBGARANTIA, s.NPOLIZA, S.NCERTIFICADO,
            s.CDENTIDAD, s.DNI, s.CDMONEDA, s.FEPAGO,
            DECODE(S.CARGO_ABONO,'A','907','C','916','907'), s.CDRETENCION, s.POIRPF,
            EXPEDIENTE;

  --Cursors para el Coaseguro del salvamento
  CURSOR lcuDetalleSumadosCoaseguro IS
   SELECT s.CDRAMO, s.CDSUBRAMO, s.CDGARANTIA, s.CDSUBGARANTIA, s.DNI,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(s.IMPORTE)*(ctd.POREPARTO_COA/100),2),
                 ROUND(ABS(s.IMPORTE)*(ctd.POREPARTO_COA/100)) ) COASEGURO,
          ctd.CDCIA
   FROM SIN_PAGOS_DET s, DIC_ALIAS_COBERTURAS dac, COA_TRATADO_DETALLE ctd, COA_TRATADO CT
   WHERE EXPEDIENTE               = ivaNmExpediente
   AND   NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND   s.CDRAMO                 = dac.CDRAMO
   AND   s.CDSUBRAMO              = dac.CDSUBRAMO
   AND   s.CDGARANTIA             = dac.CDGARANTIA
   AND   s.CDSUBGARANTIA          = dac.CDSUBGARANTIA
   AND   dac.CDTIPO_RESERVA       = lvaCdTipoReserva
   AND   CDRETENCION              = lvaCdRetencion
   AND   CTD.NPOLIZA              = S.NPOLIZA
--   AND   ctd.CDCIA               <> '00000'
   AND   ldaFeOcurrencia    BETWEEN CTD.FEALTA
                                AND NVL(CTD.FEBAJA,SYSDATE)
   AND   CT.NPOLIZA               = S.NPOLIZA
   AND   ldaFeOcurrencia    BETWEEN CT.FEALTA
                                AND NVL(CT.FEBAJA,SYSDATE)
   AND   CDCOA                    = 'C'
   ORDER BY ctd.CDCIA;

  CURSOR lcuTipoCoaseguro IS
   SELECT CDCOA
   FROM COA_TRATADO
   WHERE NPOLIZA               = lvaNmPoliza
   AND   ldaFeOcurrencia BETWEEN FEALTA
                             AND NVL(FEBAJA,SYSDATE);

  CURSOR lcuCiaCoaseguradora IS
   SELECT CIF
   FROM COMPANIAS
   WHERE CDCIA = lvaCdCiaCoaseguradora;

  CURSOR lcuSoloSuraCoaseguro IS
   SELECT CDCLASE
   FROM SIN_CLASES_HISTORICO
   WHERE EXPEDIENTE = ivaNmExpediente
   AND cdclase      = '01';

/*  CURSOR lcuPorcentajeCoaseguro IS
   SELECT POREPARTO_COA
   FROM COA_TRATADO_DETALLE
   WHERE NPOLIZA               = lvaNmPoliza
   AND   CDCIA                 = '00000'
   AND   CDABRIDORA            = 'A'
   AND   ldaFeOcurrencia BETWEEN FEALTA
                             AND NVL(FEBAJA,SYSDATE); */
 -- Fin Cursores para el coaseguro salvamentos


  -- Cursor base para el llenado del detalle OBJ_SAP_POSICION_CXC_SALV  por cada tipo de reserva de Fondo de ahorro y Valores de Cesion

 CURSOR lcuDatosCaja IS
  SELECT NVL(FEPOSIBLE_PAGO,P.FECHA_PAGO), CDVIAPAGO, CDBLOQUEOPAGO, CDPAISBANCO, CDBANCO, NMCUENTA,
         PCK_SIC_SAP.FN_SIC_MAPEO_TIPO_CUENTA(CDTIPOCUENTA) CDTIPOCUENTA,
         CDSUCURSALBANCO, SUBSTR(DSTITULAR,1,60) DSTITULAR
  FROM PAGOS p
  WHERE p.EXPEDIENTE        = ivaNmExpediente
  AND p.NMPAGO_AUTORIZACION = ivaNmPagoAutorizacion;

  CURSOR lcuDatosSiniestro IS
   SELECT TO_DATE(TO_CHAR(FECHA_SINIESTRO,'DDMMYYYY'),'DDMMYYYY'), TO_DATE(TO_CHAR(s.FECHA_NOTIFICACION,'DDMMYYYY'),'DDMMYYYY')
   FROM SINIESTROS S
   WHERE EXPEDIENTE = ivaNmExpediente;

  CURSOR lcuDatosFactura IS
   SELECT NMFACTURA, NMPREFIJO
   FROM SIN_FACTURAS
   WHERE NMEXPEDIENTE      = ivaNmExpediente
   AND NMPAGO_AUTORIZACION = ivaNmPagoAutorizacion;

  CURSOR lcuDatosPoliza IS
   SELECT C.CDAGENTE, c.CDDELEGACION_RADICA, c.FEFECTO, c.FEFECTO_ANUALIDAD
   FROM CUERPOLIZA c
   WHERE c.NPOLIZA = lvaNmPoliza;

  CURSOR lcuTipoReserva IS
   SELECT D.CDTIPO_RESERVA,
          DECODE(NVL(D.SNTERREMOTO,'N'),'S',D.CDRAMO_CONTABLE,d.CDRAMO_HOST) CDRAMO_HOST
   FROM DIC_ALIAS_COBERTURAS D
   WHERE D.CDRAMO       = lvaCdRamo
   AND D.CDSUBRAMO      = lvaCdSubRamo
   AND d.CDGARANTIA     = lvaCdGarantia
   AND d.CDSUBGARANTIA  = lvaCdSubGarantia;

  CURSOR lcuMunicipioIca IS
   SELECT a.CDMUNICIPIO
   FROM AGE_DELEGACIONES a
   WHERE a.CDDELEGACION = lvaCdOficinaRegistro;

  CURSOR lcuSnBancaseguros IS
   SELECT SNBANCASEGUROS
   FROM DIC_ALIAS_RS
   WHERE CDRAMO  = lvaCdRamo
   AND CDSUBRAMO = lvaCdSubRamo;

  CURSOR lcuCdUsuario IS
   SELECT CODIGO_USUARIO
   FROM HISTORICO
   WHERE EXPEDIENTE             = ivaNmExpediente
   AND NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion;

/*  CURSOR lcuTipoIva IS
   SELECT CDTIPO_RETENCION
   FROM SIN_TIPOS_RETENCIONES
   WHERE CDRETENCION = lvaCdRetencion;*/

  CURSOR lcuTipoSalvamento IS
   SELECT NUMERO_RESERVA
   FROM SIN_PAGOS_DET
   WHERE EXPEDIENTE             = ivaNmExpediente
   AND NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion;

  CURSOR lcuCodigoIva(pvaCiaPanama VARCHAR2) IS
   SELECT CDTIPO_RETENCION
   FROM SIN_DESC_RETENCIONES
   WHERE CDTIPO_RETENCION LIKE 'V%'
   AND CDTIPORET_FUENTE_IVA  = 'I'
   AND FEBAJA               IS NULL
   AND PORETENCION           = lnuPoIrpf
   AND NVL(SNPANAMA,'N') = pvaCiaPanama;

  -- Panam?. Se El digito de verificacion
  CURSOR lcuDigitoVerificacion IS
   SELECT NMDIGITO_VER
   FROM PERSONAS
   WHERE DNI       = lvaDni;

  -- GASTOS DE ENVIO VELRU
  CURSOR lcuGastosEnvio IS
   SELECT PTCOSTO_ENVIO
   FROM TVLR_PAGOS
   WHERE NMPAGO = ivaNmPagoVelru;

  -- GASTOS SALVAMENTOS TOTALES
  CURSOR lcuGastosTotales IS
   SELECT NVL(SUM(NMVALOR_GASTO ),0)
   FROM TSAL_GASTOS
   WHERE NMINVENTARIOPARTE = ivaNmPagoVelru;


  BEGIN

  --Datos generales del mensaje que necesita Surabroker ...
  --Parametrizables
  lvaMensajeTecnico            := 'Valores Iniciales';
  lobjTyinf.CDCONSUMIDOR       := 'SINIESTROS';
  lobjTyinf.CDSERVICIO         := 'SI_os_WS_VentaSaldoSalvamentoCxC.wsdl';
  lobjTyinf.CDOPERACION        := 'SI_os_WS_VentaSaldoSalvamentoCxC';
  --lobjTyinf.CDTOKEN          := ''; hasta donde s?, no aplica
  lobjTyinf.CDVERSION_SERVICIO := '1.0';
  lobjTyinf.DSNAME_SPACE       := NULL;
  lobjTyinf.DSPUERTO           := 'HTTP_Port';

  --No Parametrizables
  lobjTyinf.DSCLAVE            := ivaNmPagoAutorizacion;
  lobjTyinf.FECREACION         := SYSDATE;
  lobjTyinf.NMPRIORIDAD        := 1;

  SP_USUARIO (lvaDsUsuario, lvaDsClave, lvaMensajeTecnicoExt, lvaMensajeUsuarioExt);

  ltyEncabezadoMens            := TAB_SBK_ENC_MENSAJE(OBJ_SBK_ENC_MENSAJE( PCK_SBK_SURABROKER.HEADER_BASIC_AUTH_USER,lvaDsUsuario));
  ltyEncabezadoMens.EXTEND;
  ltyEncabezadoMens(2)         := OBJ_SBK_ENC_MENSAJE( PCK_SBK_SURABROKER.HEADER_BASIC_AUTH_PASSWORD,lvaDsClave);  lobjTyinf.TYENCABEZADOS      := ltyEncabezadoMens;


  lvaSnRetPanama := 'N';
----------------------------------------------------------------------------------------------------------------------
  --Datos de la cabecera de la Cuenta por Cobrar de Salvamentos
  FOR cab IN lcuDatosCabecera LOOP
   lvaCdRamo    := cab.CDRAMO;
   lvaCdSubRamo := cab.CDSUBRAMO;
   lvaDni       := cab.DNI;
   lvaNmPoliza  := cab.NPOLIZA;
   lnuImpIrc    := cab.IMPIRC;

   --Panam?. Digito de verificaci?n
   OPEN lcuDigitoVerificacion;
   FETCH lcuDigitoVerificacion INTO lvaDigitoVerificacion;
   CLOSE lcuDigitoVerificacion;

    --Datos de conversi?n que solicita SAP
   lobjDatosConversion.cdFuente       := 'SIN';
   lobjDatosConversion.nmAplicacion   := '79';
   OPEN lcuSnBancaseguros;
   FETCH lcuSnBancaseguros INTO lvaSnBancaseguros;
   CLOSE lcuSnBancaseguros;
   IF lvaSnBancaseguros = 'S' THEN
    lobjDatosConversion.cdCanal := 'BAN';
   ELSE
    lobjDatosConversion.cdCanal := 'SEG';
   END IF;

   lobjCabecera.datosConversionTipoDoc := lobjDatosConversion;

   PCK_GESTION_PRODUCTOS.SPGET_COMPANIA_PRODUCTO( cab.cdramo,cab.cdsubramo,lvaCdCompania,lvaCdciaMatriz,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);
   lobjCabecera.feDocumento           := cab.FEPAGO;
   lobjCabecera.feContabilizacion     := cab.FEPAGO;
   lobjCabecera.nmMesPeriodo          := TO_CHAR(cab.FEPAGO,'MM');

   -- Panam? 20130722 Compa??a = 30 En Colombia es cdciaMatriz en SAP es 3000
   IF lvaCdciaMatriz = '00' THEN
    lobjCabecera.cdCompania := lvaCdCompania;
   ELSIF lvaCdciaMatriz = '30' THEN
    lobjCabecera.cdCompania := lvaCdciaMatriz;
    lvaSnRetPanama := 'S';
   ELSE
    lobjCabecera.cdCompania := lvaCdCompania;
   END IF;

   -- Todos los pagos de Sura se hacen en moneda pesos
   -- Panama.  la moneda base es 20
   IF lvaCdCompania IN ('01','02') THEN
    lobjCabecera.cdMoneda := '0';
   ELSE
    IF lvaCdciaMatriz = '30' THEN
     lobjCabecera.cdMoneda := '20';
    ELSE
     lobjCabecera.cdMoneda := cab.cdMoneda;
    END IF;
   END IF;

   lobjCabecera.ptTasaCambio          := NULL;
   lobjCabecera.feTasaCambio          := NULL;

   -- Para la referencia (dsFacturaOrdenPago) se toman la 8 primeras de la factura - las 7 primeras de la orden de pago
   OPEN lcuDatosFactura;
   FETCH lcuDatosFactura INTO lvaNmFactura,lvaNmPrefijo;
   CLOSE lcuDatosFactura;

   lobjCabecera.nmDocumento           := ivaNmPagoAutorizacion;
   IF LENGTH(TRIM(lvaNmPrefijo)) > 9 THEN
      lvaNmPrefijo                    := SUBSTR(lvaNmPrefijo,(LENGTH(TRIM(lvaNmPrefijo))-8));
   END IF;
   IF TRIM(lvaNmPrefijo) IS NOT NULL THEN
      lobjCabecera.dsComentarios      := lvaNmPrefijo ||'-'||lvaNmFactura;
   ELSE
      lobjCabecera.dsComentarios      := lvaNmFactura;
   END IF;

   lobjCabecera.cdTipoIdTercero       := PCK_SIC_UTILITARIOS_I.FN_SIC_CDTIPO_IDENTIFICACION(lvaDni);
   lobjCabecera.cdTercero             := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(lvaDni);

   --Panama. Digito de verificacion
   IF lvaCdciaMatriz = '30' THEN
    --Panama. Digito de verificacion
    IF lvaDigitoVerificacion IS NOT NULL THEN
--SAP va a poner el d?gito de verificaci?n.
NULL;
--     lobjCabecera.cdTercero             := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(lvaDni)||':'||lvaDigitoVerificacion;
    END IF;
   END IF;

   lobjCabecera.ptDocumento           := cab.IMPORTE;
   -- Gastos de Envio para VELRU
   lnuGastosEnvio := 0;
   OPEN lcuGastosEnvio;
   FETCH lcuGastosEnvio INTO lnuGastosEnvio;
   CLOSE lcuGastosEnvio;
   IF NVL(lnuGastosEnvio,0) <> 0 THEN
    lobjCabecera.ptDocumento := cab.IMPORTE + lnuGastosEnvio;
   END IF;

   lvaSnCalcularImpuestos             := 'S';
   lobjCabecera.snCalculaImpuesto     := lvaSnCalcularImpuestos;

   OPEN lcuDatosPoliza;
   FETCH lcuDatosPoliza INTO lvaCdAgente, lvaCdDelegacionRadica, ldaFeFecto, ldaFeFectoAnualidad;
   CLOSE lcuDatosPoliza;

   lobjCabecera.cdOficina             := lvaCdDelegacionRadica;

   lobjCabecera.nmPoliza              := cab.NPOLIZA;
   lobjCabecera.cdRamo                := cab.CDRAMO;
   lobjCabecera.cdIntermediario       := lvaCdAgente;
   lobjCabecera.cdCondicionPago       := '0';
   lobjCabecera.feVentaSalvamento     := cab.FEPAGO;

   OPEN lcuDatosCaja;
   FETCH lcuDatosCaja INTO lvaFeposiblePago, lvaCdMedioPago, lvaCdbloqueoPago,
                           lvaCdPaisBanco, lvaCdBanco, lvaNmCuenta, cdTipoCuenta,
                           lvaCdSucursalBanco, lvaDsTitular;
   CLOSE lcuDatosCaja;

   --Panam?.  Cuando para panam? se est? manejando GE, este par?metro va a venir en la tabla pagos
   IF lvaCdMedioPago = 'IO' THEN
    lvaCdMedioPago     := 'CA';
   END IF;
   --Fin Panam?


   lobjCabecera.cdMedioPago                := lvaCdMedioPago;
   lobjCabecera.feVencimiento              := lvaFeposiblePago;

--   lvaDsTextoPosicion                      := NULL;--'AUTORIZACIONES SALVAMENTOS';
   lvaCdReserva := NULL;
   OPEN lcuTipoSalvamento;
   FETCH lcuTipoSalvamento INTO lvaCdReserva;
   CLOSE lcuTipoSalvamento;
   IF lvaCdReserva = 'R040010' AND lvaCdRamo = '040' THEN
    lvaDsTextoPosicion := ivaNmExpediente||'-'||'AUTOS COMPLETOS';
    IF CAB.CDOPERACION = '907' THEN
     lvaDsTextoPosicion := ivaNmExpediente||'-'||'AUTOS COMPLETOS'||'-'||'PARTICIPACION VENTA';
    END IF;
   ELSIF lvaCdReserva = 'R040020' AND lvaCdRamo = '040' THEN
    lvaDsTextoPosicion := ivaNmExpediente||'-'||'REPUESTOS AUTOS';
   ELSIF lvaCdReserva IN ('R040010','R040020') AND lvaCdRamo != '040' THEN
    lvaDsTextoPosicion := ivaNmExpediente||'-'||'OTROS RAMOS';
   END IF;

   --GASTOS ADICIONALES PARA SALVAMENTOS TOTALES
   IF lvaCdReserva = 'R040010' THEN
    lnuGastosEnvio := 0;
    OPEN lcuGastosTotales;
    FETCH lcuGastosTotales INTO lnuGastosEnvio;
    CLOSE lcuGastosTotales;
    IF NVL(lnuGastosEnvio,0) <> 0 THEN
     lobjCabecera.ptDocumento := cab.IMPORTE + lnuGastosEnvio;
    END IF;
   END IF;


   lobjCabecera.dsTextoPosicion1           := lvaDsTextoPosicion;

   IF NVL(cab.CDRETENCION,0) <> '0099' THEN
    lvaCdConcepto := 'G';
    --Panam?.  en email de German Duque de mi?rcoles 2013/11/06 11:31 a.m.
    --reporta que el concepto es siempre no grabado y se envie una N
    IF lvaCdciaMatriz = '30' THEN
     lvaCdConcepto := 'N';
    END IF;
   ELSE
    lvaCdConcepto := 'N';
   END IF;

   lvaCdOperacion                          := cab.CDOPERACION;
   lobjCabecera.cdConcepto                 := lvaCdConcepto;
   lobjCabecera.cdOperacion                := lvaCdOperacion;
   --  Retenciones
   lvaCdRetencion                          := cab.CDRETENCION;
   lnuPoIrpf                               := cab.POIRPF;
   lvaCodIva                               := NULL;


/*   OPEN lcuTipoIva;
   FETCH lcuTipoIva INTO lvaCodIva;
   CLOSE lcuTipoIva;*/

   OPEN lcuCodigoIva(lvaSnRetPanama);
   FETCH lcuCodigoIva INTO lvaCodIva;
   CLOSE lcuCodigoIva;


   lobjCabecera.cdIndicadorImpuesto        := lvaCodIva;
   IF NVL(lnuGastosEnvio,0) <> 0 THEN
    lobjCabecera.cdIndicadorImpuesto := NULL;
   END IF;



   lnuContadorRetencion                    := 0;
   lobjRetenciones                         := TAB_SAP_DATOS_RETENCIONES(OBJ_SAP_DATO_RETENCION());
   --Con el cambio de retenciones, en el legacy se llevan a cero y es SAP quien las calcula
   --Se comenta como estaba anteriomente y se llevan solo si hay c?digo de retencion
   --IF NVL(lnuImpIrc,0) <> 0 THEN
   IF NVL(lvaCdRetencion,0) NOT IN ('0099','0000')  THEN
    lnuContadorRetencion                   := lnuContadorRetencion + 1;
    lobjRetencion.cdtipoRetencion          := lvaCdRetencion;
    lobjRetencion.cdindicadorRetencion     := 'R';
    lobjRetencion.ptBaseRetencion          := ROUND((cab.IMPORTE*100)/(100+cab.POIRPF));--NULL;
    lobjRetencion.ptRetencion              := NULL;

    IF lnuContadorRetencion = 1 THEN
     lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
    ELSE
     lobjRetenciones.Extend;
     lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
    END IF;
   END IF;

   --Con el cambio de retenciones, en el legacy se llevan a cero y es SAP quien las calcula
   --Se comenta como estaba anteriomente y se llevan solo si hay c?digo de retencion
   --IF NVL(lnuImpIca,0) <> 0 THEN
   IF NVL(lvaCdRetencion,0) NOT IN ('0099','0000')  THEN
    --Este cursor siempre lleva nulo el municipio dado que en este momento no se hace auto retencion de ica en siniestros
    --Se deja por si al futuro hay retencion de ICA y habr?a que tener la oficina para que retorne valor
    OPEN lcuMunicipioIca;
    FETCH lcuMunicipioIca INTO lvaMunicipioIca;
    CLOSE lcuMunicipioIca;
    lnuContadorRetencion                   := lnuContadorRetencion + 1;
    lobjRetencion.cdtipoRetencion          := lvaCdRetencion;
    lobjRetencion.cdindicadorRetencion     := lvaMunicipioIca;
    lobjRetencion.ptBaseRetencion          := ROUND((cab.IMPORTE*100)/(100+cab.POIRPF));--NULL;
    lobjRetencion.ptRetencion              := NULL;

    -- Se crea este if con el cambio de retenciones, dado que como ya no se valida con el valor  (lnuimpica),
    -- se tiene que validar con el cdindicadorRetencion que en este caso es la variable lvaMunicipioIca
    IF lvaMunicipioIca IS NOT NULL THEN
     IF lnuContadorRetencion = 1 THEN
      lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
     ELSE
      lobjRetenciones.Extend;
      lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
     END IF;
    END IF;
   END IF;

   lobjCabecera.retenciones                := lobjRetenciones;

   --------------------------------------------------------------------------------------------
   -- Llenado del detalle.  Se llena dentro del cursor de CABECERA
   --------------------------------------------------------------------------------------------
   -- 1. PARTE GENERAL DEL DETALLE
   lnuContadorDetalle                      := 0;
   lobjTabDetalles                         := TAB_SAP_POSICIONES_CXC_SALV(OBJ_SAP_POSICION_CXC_SALV());

   lvaCdRamo                               := cab.CDRAMO;
   lvaCdSubramo                            := cab.CDSUBRAMO;
   lvaCdGarantia                           := cab.CDGARANTIA;
   lvaCdSubGarantia                        := cab.CDSUBGARANTIA;

   OPEN lcuDatosSiniestro;
   FETCH lcuDatosSiniestro INTO ldaFeOcurrencia, ldaFenotificacion;
   CLOSE lcuDatosSiniestro;
   lobjDetalle.feAvisoSiniestro            := ldaFenotificacion;
   lobjDetalle.feSiniestro                 := ldaFeOcurrencia;

   OPEN lcuTipoReserva;
   FETCH lcuTipoReserva INTO lvaCdTipoReserva,lvaCdramoContable;
   CLOSE lcuTipoReserva;

   lobjDetalle.cdRamoContable              := lvaCdramoContable;
   lobjDetalle.feVentaSalvamento           := cab.FEPAGO;
   lobjDetalle.cdConcepto                  := lvaCdConcepto;

   lobjDetalle.cdIndicadorImpuestos         := lvaCodIva;
   lobjDetalle.cdTipoIVA                   := lvaCdConcepto;

   lvaTipoCoaseguro := NULL;
   OPEN lcuTipoCoaseguro;
   FETCH lcuTipoCoaseguro INTO lvaTipoCoaseguro;
   CLOSE lcuTipoCoaseguro;

   OPEN lcuSoloSuraCoaseguro;
   FETCH lcuSoloSuraCoaseguro INTO lvaIdSoloSura;
   IF lcuSoloSuraCoaseguro%FOUND THEN
    lnuPorepartoCoa := 100;
   END IF;
   CLOSE lcuSoloSuraCoaseguro;

   IF NVL(lvaTipoCoaseguro,' ') IN ('A',' ') OR NVL(lvaIdSoloSura,' ') = '01' THEN

    lobjDetalle.ptdocumento                 := cab.IMPORTE_DET;

    lvaCdReserva := NULL;
    OPEN lcuTipoSalvamento;
    FETCH lcuTipoSalvamento INTO lvaCdReserva;
    CLOSE lcuTipoSalvamento;
    IF lvaCdReserva = 'R040010' AND lvaCdRamo = '040' THEN
     lobjDetalle.dsTextoPosicion := ivaNmExpediente||'-'||'AUTOS COMPLETOS';
     IF CAB.CDOPERACION = '907' THEN
      lobjDetalle.dsTextoPosicion := ivaNmExpediente||'-'||'AUTOS COMPLETOS'||'-'||'PARTICIPACION VENTA';
     END IF;
    ELSIF lvaCdReserva = 'R040020' AND lvaCdRamo = '040' THEN
     lobjDetalle.dsTextoPosicion := ivaNmExpediente||'-'||'REPUESTOS AUTOS';
    ELSIF lvaCdReserva IN ('R040010','R040020') AND lvaCdRamo != '040' THEN
     lobjDetalle.dsTextoPosicion := ivaNmExpediente||'-'||'OTROS RAMOS';
    END IF;

    IF lvaTipoCoaseguro IS NULL THEN
     lobjDetalle.cdOperacion                 := lvaCdOperacion||'D';
    ELSIF lvaTipoCoaseguro = 'A' THEN
     lobjDetalle.cdOperacion                 := lvaCdOperacion||'A';
    ELSIF NVL(lvaIdSoloSura,' ') = '01' THEN
     lobjDetalle.cdOperacion                 := lvaCdOperacion||'D';
    ELSE
     lobjDetalle.cdOperacion                 := lvaCdOperacion||'D';
    END IF;

    lnuContadorDetalle                      := lnuContadorDetalle + 1;

    IF lnuContadorDetalle = 1 THEN
     lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
    ELSE
     lobjTabDetalles.Extend;
     lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
    END IF;

   ELSE
    -- Llenado de los documentos de Coaseguro
    --  Coaseguro
    FOR reg IN lcuDetalleSumadosCoaseguro LOOP
     IF reg.COASEGURO <> 0 THEN
      lobjDetalle.ptdocumento         := reg.COASEGURO;

      lvaCdCiaCoaseguradora           := reg.CDCIA;
      OPEN lcuCiaCoaseguradora;
      FETCH lcuCiaCoaseguradora INTO lvaDniCoaseguradora;
      CLOSE lcuCiaCoaseguradora;
      lvaDniCoaseguradora := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(lvaDniCoaseguradora);

      lvaCdReserva := NULL;
      OPEN lcuTipoSalvamento;
      FETCH lcuTipoSalvamento INTO lvaCdReserva;
      CLOSE lcuTipoSalvamento;
      IF lvaCdReserva = 'R040010' AND lvaCdRamo = '040' THEN
       lobjDetalle.dsTextoPosicion := ivaNmExpediente||'-'||'AUTOS COMPLETOS'||'-'||lvaDniCoaseguradora;
        IF CAB.CDOPERACION = '907' THEN
         lobjDetalle.dsTextoPosicion := ivaNmExpediente||'-'||'AUTOS COMPLETOS'||'-'||'PARTICIPACION VENTA';
        END IF;
      ELSIF lvaCdReserva = 'R040020' AND lvaCdRamo = '040' THEN
       lobjDetalle.dsTextoPosicion := ivaNmExpediente||'-'||'REPUESTOS AUTOS'||'-'||lvaDniCoaseguradora;
      ELSIF lvaCdReserva IN ('R040010','R040020') AND lvaCdRamo != '040' THEN
       lobjDetalle.dsTextoPosicion := ivaNmExpediente||'-'||'OTROS RAMOS'||'-'||lvaDniCoaseguradora;
      END IF;

      IF lvaCdCiaCoaseguradora IN ('00000','30000') THEN
       lobjDetalle.cdOperacion := lvaCdOperacion||'D';
       --El descuento es de Sura y no tiene porque repartircele a las coaseguradoras.
       lobjDetalle.ptdocumento := reg.COASEGURO-NVL(cab.PTDESCUENTO,0);
      ELSE
       lobjDetalle.cdOperacion := lvaCdOperacion||'C';
      END IF;

      lnuContadorDetalle                      := lnuContadorDetalle + 1;

      IF lnuContadorDetalle = 1 THEN
       lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
      ELSE
       lobjTabDetalles.Extend;
       lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
      END IF;

     END IF;
    END LOOP;
   -- Fin de coaseguro
   END IF;--NVL(lvaTipoCoaseguro,' ')

   -----------------------------------------------------------------
   -- GASTOS DE ENVIO PARA VELRU
   -----------------------------------------------------------------
   IF NVL(lnuGastosEnvio,0) <> 0 THEN
    lobjDetalle.ptdocumento                 := lnuGastosEnvio;
    lobjDetalle.cdIndicadorImpuestos        := NULL;--lvaCodIva;
    lobjDetalle.cdTipoIVA                   := NULL;

    lvaCdReserva := NULL;
    OPEN lcuTipoSalvamento;
    FETCH lcuTipoSalvamento INTO lvaCdReserva;
    CLOSE lcuTipoSalvamento;
    IF lvaCdReserva = 'R040010' AND lvaCdRamo = '040' THEN
     lobjDetalle.dsTextoPosicion := ivaNmExpediente||'-'||'AUTOS COMPLETOS';
      IF CAB.CDOPERACION = '907' THEN
       lobjDetalle.dsTextoPosicion := ivaNmExpediente||'-'||'AUTOS COMPLETOS'||'-'||'PARTICIPACION VENTA';
      END IF;
    ELSIF lvaCdReserva = 'R040020' AND lvaCdRamo = '040' THEN
     lobjDetalle.dsTextoPosicion := ivaNmExpediente||'-'||'REPUESTOS AUTOS';
    ELSIF lvaCdReserva IN ('R040010','R040020') AND lvaCdRamo != '040' THEN
     lobjDetalle.dsTextoPosicion := ivaNmExpediente||'-'||'OTROS RAMOS';
    END IF;

    lobjDetalle.cdOperacion := lvaCdOperacion||'CE';

    IF lvaCdReserva = 'R040010' THEN
     lobjDetalle.cdOperacion := lvaCdOperacion||'OP';
    END IF;

    lnuContadorDetalle                      := lnuContadorDetalle + 1;
    IF lnuContadorDetalle = 1 THEN
     lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
    ELSE
     lobjTabDetalles.Extend;
     lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
    END IF;
   END IF;
   -- Fin GASTOS DE ENVIO VELRU.

  END LOOP; --lcuDatosCabecera
--Fin de CABECERA

----------------------------------------------------------------------------------------------------------------------
  --Datos de Creaci?n de Deudor (beneficiario de pago del salvamento)
  OPEN lcuCdUsuario;
  FETCH lcuCdUsuario INTO lvaCdUsuario;
  CLOSE lcuCdUsuario;

  PCK_SIC_SAP.SP_SIC_POBLA_DEUDORES_BAS_DIR(lvaDni,
                                            lvaCdUsuario,
                                            ltyjDirDeudor,
                                            lvaMensajeTecnicoExt,
                                            lvaMensajeUsuarioExt);
  IF lvaMensajeTecnicoExt IS NOT NULL OR lvaMensajeUsuarioExt IS NOT NULL THEN
   RAISE lexErrorProcedimientoExt;
  END IF;

  lobjDirDeudor.CDTRATAMIENTO             := ltyjDirDeudor.CDTRATAMIENTO;
  lobjDirDeudor.DSPRIMER_NOMBRE           := ltyjDirDeudor.DSPRIMER_NOMBRE;
  lobjDirDeudor.DSSEGUNDO_NOMBRE          := ltyjDirDeudor.DSSEGUNDO_NOMBRE;
  lobjDirDeudor.DSPRIMER_APELLIDO         := ltyjDirDeudor.DSPRIMER_APELLIDO;
  lobjDirDeudor.DSSEGUNDO_APELLIDO        := ltyjDirDeudor.DSSEGUNDO_APELLIDO;
  lobjDirDeudor.DSPERSONA_JURIDICA        := ltyjDirDeudor.DSPERSONA_JURIDICA;
  lobjDirDeudor.CDTIPO_PERSONA            := ltyjDirDeudor.CDTIPO_PERSONA;
  lobjDirDeudor.CDCONCEPTO_BUSQUEDA       := ltyjDirDeudor.CDCONCEPTO_BUSQUEDA;
  lobjDirDeudor.DSDIRECCION               := ltyjDirDeudor.DSDIRECCION;
  lobjDirDeudor.DSDIRECCION2              := ltyjDirDeudor.DSDIRECCION2;
  lobjDirDeudor.CDPAIS                    := ltyjDirDeudor.CDPAIS;
  lobjDirDeudor.CDREGION                  := ltyjDirDeudor.CDREGION;
  lobjDirDeudor.CDPOBLACION               := ltyjDirDeudor.CDPOBLACION;
  lobjDirDeudor.NMAPARTADO_AEREO          := ltyjDirDeudor.NMAPARTADO_AEREO;
  lobjDirDeudor.CDIDIOMA                  := ltyjDirDeudor.CDIDIOMA;
  lobjDirDeudor.NMTELEFONO                := ltyjDirDeudor.NMTELEFONO;
  lobjDirDeudor.NMTELEFONO_MOVIL          := ltyjDirDeudor.NMTELEFONO_MOVIL;
  lobjDirDeudor.NMFAX                     := ltyjDirDeudor.NMFAX;
  lobjComDeudor.DSDIRECCION_INTERNET      := ltyjDirDeudor.DSDIRECCION_INTERNET;
  lobjComDeudor.DSEMAIL                   := ltyjDirDeudor.DSEMAIL;
  lobjCtrlDeudor.NMIDENTIF_FISCAL         := lobjCabecera.cdTercero;
  lobjCtrlDeudor.CDTIPO_NIF               := lobjCabecera.cdTipoIdTercero;

  lobjEntDeudor.CDGRUPO_CUENTAS           := PCK_SIC_SAP.FN_SIC_CALCULAR_GRUPO_DEUDOR(lvaDni, lvaCdciaMatriz);

  lobjCreacionDeudor.CAMPOSENTRADADATOSDEUDORCXC   := lobjEntDeudor;
  lobjCreacionDeudor.CAMPOSDIRECCIONDATOSDEUDORCXC := lobjDirDeudor;
  lobjCreacionDeudor.CAMPOSCOMUNICDATOSDEUDORCXC   := lobjComDeudor;
  lobjCreacionDeudor.CAMPOSCONTROLDATOSDEUDORCXC   := lobjCtrlDeudor;
  lobjCreacionDeudor.CAMPOSPAGRELBANDATDEUDORCXC   := lobjCuentaBancaria;


  lobjSalvamento                            := OBJ_SAP_CXC_SALVAMENTOS () ;
  lobjSalvamento.Tyinf                      := lobjTyinf;
  lobjSalvamento.datosEncabSalvamentos      := lobjCabecera;
  lobjSalvamento.datosPosicSalvamentos      := lobjTabDetalles;
  lobjSalvamento.datosCreacionDeudor        := lobjCreacionDeudor;

  RETURN lobjSalvamento;


  EXCEPTION
      WHEN lexErrorProcedimientoExt THEN
        ovaMensajeTecnico:=lvaMensajeTecnicoExt;
        ovaMensajeUsuario:=lvaMensajeUsuarioExt;
        RETURN NULL;
      WHEN lexErrorProcedimiento THEN
        ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
        ovaMensajeUsuario:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeUsuario;
        RETURN NULL;
      WHEN OTHERS THEN
       ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
       ovaMensajeUsuario:= SQLERRM;--'TRANSACCION NO DISPONIBLE ' ;
       RETURN NULL;
  END FN_CREAR_MENSAJE_CXC;

-------------------------------------------------------------------------------------------------------------------------------------------------

  FUNCTION FN_CREAR_MENSAJE_ANULAR_CXC (ivaNmExpediente        IN VARCHAR2,
                                        ivaNmPagoAutorizacion  IN SIN_PAGOS_DET.NUMERO_PAGO_AUTORIZACION%TYPE,
                                        ovaMensajeTecnico      OUT VARCHAR2,
                                        ovaMensajeUsuario      OUT VARCHAR2  ) RETURN OBJ_SAP_ANULACION_CXC_SEG IS
 --Variables para el manejo de Errores
  lvaMensajeTecnico           VARCHAR2(1000)  := NULL;
  lvaMensajeTecnicoExt        VARCHAR2(1000)  := NULL;
  lvaMensajeUsuario           VARCHAR2(1000)  := NULL;
  lvaMensajeUsuarioExt        VARCHAR2(1000)  := NULL;
  lexErrorProcedimiento       EXCEPTION;
  lexErrorProcedimientoExt    EXCEPTION;
  lvaNombreObjeto             VARCHAR2(30)   :='FN_CREAR_MENSAJE_ANULAR_CXC';


  --Objeto para retornar con mensaje SAP
   lobjMensaje                 OBJ_SAP_ANULACION_CXC_SEG := NULL;
  lobjTyinf                   OBJ_SBK_MENSAJE_INF      := OBJ_SBK_MENSAJE_INF(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
  ltyEncabezadoMens           TAB_SBK_ENC_MENSAJE      := TAB_SBK_ENC_MENSAJE(OBJ_SBK_ENC_MENSAJE(NULL,NULL));
  lvaDsUsuario                T999_PARAMETROS.DSVALOR_PARAMETRO%TYPE;
  lvaDsClave                  T999_PARAMETROS.DSVALOR_PARAMETRO%TYPE;

  --Variables propias del aplicativo
  lvaCdCompania                DIC_ALIAS_RS.CDCIA%TYPE;
  lvaCdCompaniaMatriz          DIC_ALIAS_RS.CDCIA_MATRIZ%TYPE;
  lvaCdRamo                    SIN_PAGOS_DET.CDRAMO%TYPE;
  lvaDni                       SIN_PAGOS_DET.DNI%TYPE;
  ldaFepago                    SIN_PAGOS_DET.FEPAGO%TYPE;
  lvaNpoliza                   SIN_PAGOS_DET.NPOLIZA%TYPE;
  lvaAnoContable               NUMBER(4);

  -- Panam?.  Se incluye en el cursor CDCIA_MATRIZ
  CURSOR lcuDatosPago IS
   SELECT DISTINCT D.CDCIA,S.DNI,D.CDRAMO, S.FEPAGO, s.NPOLIZA, D.CDCIA_MATRIZ
   FROM SIN_PAGOS_DET S, DIC_ALIAS_RS D
   WHERE S.EXPEDIENTE             = ivaNmExpediente
   AND S.NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND D.CDRAMO                   = S.CDRAMO
   AND D.CDSUBRAMO                = S.CDSUBRAMO;


  BEGIN

   IF ivaNmPagoAutorizacion IS NULL OR ivaNmExpediente IS NULL THEN
    lvaMensajeTecnico := 'Los datos No Pueden Ser vacios';
    RAISE lexErrorProcedimiento;
   END IF;

   --Datos generales del mensaje que necesita Surabroker ...
   --Parametrizables
   lvaMensajeTecnico            := 'Valores Iniciales';
   lobjTyinf.CDCONSUMIDOR       := 'SINIESTROS';
   lobjTyinf.CDSERVICIO         := 'SI_os_WS_AnulacionCxC.wsdl';
   lobjTyinf.CDOPERACION        := 'SI_os_WS_AnulacionCxC';
   --lobjTyinf.CDTOKEN          := '';
   lobjTyinf.CDVERSION_SERVICIO := '1.0';
   lobjTyinf.DSNAME_SPACE       := NULL;
   lobjTyinf.DSPUERTO           := 'HTTP_Port';

   --No Parametrizables
   lobjTyinf.DSCLAVE            := ivaNmPagoAutorizacion;
   lobjTyinf.FECREACION         := SYSDATE;
   lobjTyinf.NMPRIORIDAD        := NULL;

   SP_USUARIO (lvaDsUsuario, lvaDsClave, lvaMensajeTecnicoExt, lvaMensajeUsuarioExt);

   ltyEncabezadoMens            := TAB_SBK_ENC_MENSAJE(OBJ_SBK_ENC_MENSAJE( PCK_SBK_SURABROKER.HEADER_BASIC_AUTH_USER,lvaDsUsuario));
   ltyEncabezadoMens.EXTEND;
   ltyEncabezadoMens(2)         := OBJ_SBK_ENC_MENSAJE( PCK_SBK_SURABROKER.HEADER_BASIC_AUTH_PASSWORD,lvaDsClave);   lobjTyinf.TYENCABEZADOS      := ltyEncabezadoMens;

   lvaMensajeTecnico := 'Consultando los datos de DNI y CDCIA';

   -- Panam?.  Se incluye en el fetch lvaCdCiaMatriz
   OPEN lcuDatosPago;
   FETCH lcuDatosPago INTO lvaCdCompania, lvaDni, lvaCdRamo, ldaFepago, lvaNpoliza, lvaCdCompaniaMatriz;
   CLOSE lcuDatosPago;

   lvaAnoContable                   :=   TO_CHAR(ldaFepago,'YYYY');

   lobjMensaje                      := OBJ_SAP_ANULACION_CXC_SEG();
   lobjMensaje.Tyinf                := lobjTyinf;

   -- Panam?.  La compa??a es la Matriz
   IF lvaCdCompaniaMatriz = '00' THEN
    lobjMensaje.CDCOMPANIA := lvaCdCompania;
   ELSIF lvaCdCompaniaMatriz = '30' THEN
    lobjMensaje.CDCOMPANIA := lvaCdCompaniaMatriz;
   ELSE
    lobjMensaje.CDCOMPANIA := lvaCdCompaniaMatriz;
   END IF;


   lobjMensaje.CDANO_CONTABLE       := lvaAnoContable;
   lobjMensaje.CDMOTIVO_ANULACION   := '04';
   lobjMensaje.FECONTABILIZACION    := SYSDATE;
   lobjMensaje.NMDOCUMENTO          := ivaNmPagoAutorizacion;
   lobjMensaje.CDRAMO               := lvaCdRamo;
   lobjMensaje.NMPOLIZA             := lvaNpoliza;
   lobjMensaje.CDTIPO_ID_CLIENTE    := PCK_SIC_UTILITARIOS_I.FN_SIC_CDTIPO_IDENTIFICACION(lvaDni);
   lobjMensaje.CDCLIENTE            := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(lvaDni);


   RETURN lobjMensaje;

  EXCEPTION
   WHEN lexErrorProcedimientoExt THEN
    ovaMensajeTecnico:=lvaMensajeTecnicoExt;
    ovaMensajeUsuario:=lvaMensajeUsuarioExt;
    RETURN NULL;
   WHEN lexErrorProcedimiento THEN
    ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
    ovaMensajeUsuario:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeUsuario;
    RETURN NULL;
   WHEN OTHERS THEN
    ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
    ovaMensajeUsuario:= 'TRANSACCION NO DISPONIBLE ' ;
    RETURN NULL;
  END FN_CREAR_MENSAJE_ANULAR_CXC;
-------------------------------------------------------------------------------------------------------------------------------------------------

  PROCEDURE SP_USUARIO (ovaDsUsuario       OUT T999_PARAMETROS.DSVALOR_PARAMETRO%TYPE,
                       ovaDsClave         OUT T999_PARAMETROS.DSVALOR_PARAMETRO%TYPE,
                       ovaMensajeTecnico  OUT VARCHAR2,
                       ovaMensajeUsuario  OUT VARCHAR2  ) IS
  BEGIN
   ovaDsUsuario    := PCK_PARAMETROS.FN_GET_PARAMETROV2('%', '%', 'SEG_SAPUSUCNX_A', SYSDATE);
   ovaDsClave   := PCK_PARAMETROS.FN_GET_PARAMETROV2('%', '%', 'SEG_SAPPASCNX_A', SYSDATE);
   IF ovaDsUsuario IS NULL or ovaDsClave IS NULL THEN
    ovaMensajeUsuario :='No existen par?metros para el usuario';
    ovaMensajeTecnico :='No existen par?metros para el usuario';
   END IF;
  END SP_USUARIO;
-------------------------------------------------------------------------------------------------------------------------------------------------
  FUNCTION FN_RIESGO_EXTERIOR (ivaNmPoliza         IN VARCHAR2,
                               ivaNmCertificado    IN VARCHAR2,
                               ovaMensajeTecnico  OUT VARCHAR2,
                               ovaMensajeUsuario  OUT VARCHAR2)
                               RETURN VARCHAR2 IS

  --Variables para el manejo de Errores
  lvaMensajeTecnico           VARCHAR2(1000)  := NULL;
  lvaMensajeTecnicoExt        VARCHAR2(1000)  := NULL;
  lvaMensajeUsuario           VARCHAR2(1000)  := NULL;
  lvaMensajeUsuarioExt        VARCHAR2(1000)  := NULL;
  lexErrorProcedimiento       EXCEPTION;
  lexErrorProcedimientoExt    EXCEPTION;
  lvaNombreObjeto             VARCHAR2(30)    :='FN_RIESGO_EXTERIOR';

  lvaCdRamo                   CUERPOLIZA.CDRAMO%TYPE;
  lvaCdSubramo                CUERPOLIZA.CDSUBRAMO%TYPE;
  lvaSnRiesgoExterior         VARCHAR2(1)     := 'N';

  CURSOR lcuDatosPoliza IS
   SELECT CDRAMO, CDSUBRAMO
   FROM CUERPOLIZA
   WHERE NPOLIZA = ivaNmPoliza;

  CURSOR lcuRiegoExterior030 IS
   SELECT 'S'
   FROM CUERPOLIZA_RGO_030
   WHERE NPOLIZA       = ivaNmPoliza
   AND NCERTIFICADO LIKE NVL(ivaNmCertificado,'%')
   AND CDMANZANA       = '87888001001';

  BEGIN

   OPEN lcuDatosPoliza;
   FETCH lcuDatosPoliza INTO lvaCdRamo, lvaCdSubramo;
   CLOSE lcuDatosPoliza;

   IF lvaCdRamo = '030' THEN
    OPEN lcuRiegoExterior030;
    FETCH lcuRiegoExterior030 INTO lvaSnRiesgoExterior;
    CLOSE lcuRiegoExterior030;
   END IF;

   RETURN lvaSnRiesgoExterior;

  EXCEPTION
      WHEN lexErrorProcedimientoExt THEN
        ovaMensajeTecnico:=lvaMensajeTecnicoExt;
        ovaMensajeUsuario:=lvaMensajeUsuarioExt;
        RETURN NULL;
      WHEN lexErrorProcedimiento THEN
        ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
        ovaMensajeUsuario:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeUsuario;
        RETURN NULL;
      WHEN OTHERS THEN
       ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
       ovaMensajeUsuario:= 'TRANSACCION NO DISPONIBLE ' ;
       RETURN NULL;
  END FN_RIESGO_EXTERIOR;
---------------------------------------------------------------------------------------------------------------------------------------------
  PROCEDURE SP_DEDUCIBLE_CAJA_SAP(ivaTipoMovimiento      IN VARCHAR2,
                                  ivaExpediente          IN SIN_PAGOS_DET.EXPEDIENTE%TYPE,
                                  inuValorMovimiento     IN SIN_PAGOS_DET.IMPORTE%TYPE,
                                  onuNmPagoAutorizacion OUT SIN_PAGOS_DET.NUMERO_PAGO_AUTORIZACION%TYPE,
                                  ovaMensajeTecnico     OUT VARCHAR2,
                                  ovaMensajeUsuario     OUT VARCHAR2,
                                  ivaDniSubrogacion      IN VARCHAR2 DEFAULT NULL) IS

    lvaNombreObjeto          VARCHAR2(30) := 'SP_DEDUCIBLE_CAJA_SAP';

    lexErrorProcedimiento     EXCEPTION;
    lexErrorProcedimientoExt  EXCEPTION;

    lvaMensajeTecnico         VARCHAR2(1000)  := NULL;
    lvaMensajeTecnicoExt      VARCHAR2(1000)  := NULL;
    lvaMensajeUsuario         VARCHAR2(1000)  := NULL;
    lvaMensajeUsuarioExt      VARCHAR2(1000)  := NULL;

    ltabEntradaAutorizacion   PCK_SINIESTROS.tabDatosAutorizacion;
    lnuRegistros              NUMBER(3) := 0;
    lvaSituacionStro          SINIESTROS.SITUACION%TYPE;
    lvaCdCierre               SINIESTROS.CDCIERRE%TYPE;
    lvaCdUsuario              SINIESTROS.CODIGO_USUARIO%TYPE;
    lvaCdRamo                 SIN_PAGOS_DET.CDRAMO%TYPE;
    lvaCdSubramo              SIN_PAGOS_DET.CDSUBRAMO%TYPE;
    lvaCdGarantia             SIN_PAGOS_DET.CDGARANTIA%TYPE;
    lvaCdSubgarantia          SIN_PAGOS_DET.CDSUBGARANTIA%TYPE;
    lvaCdEntidad              SIN_PAGOS_DET.CDENTIDAD%TYPE;
    lnuValorReserva           RESERVAS.RESERVA_ACTUAL%TYPE;
    lnuValorPagos             SIN_PAGOS_DET.IMPORTE%TYPE;
    lvaCdreserva              SIN_RESERVAS.CDRESERVA%TYPE;
    lvaTipoEntidad            SIN_PAGOS_DET.TIPO_ENTIDAD%TYPE := 'D';
    lvaSnivaRetenido          SIN_PAGOS_DET.SNIVA_RETENIDO%TYPE := 'N';
    lnuPoIva                  SIN_PAGOS_DET.POIRPF%TYPE;
    lnuVlrIva                 SIN_PAGOS_DET.IMPIRPF%TYPE;
    lnuPoReteFuente           SIN_PAGOS_DET.POIRC%TYPE;
    lnuVlrReteFuente          SIN_PAGOS_DET.IMPIRC%TYPE;
    lvaNmPoliza               SIN_PAGOS_DET.NPOLIZA%TYPE;
    lvaNmCertificado          SIN_PAGOS_DET.NCERTIFICADO%TYPE;
    lvaDniAsegurado           SIN_PAGOS_DET.DNI%TYPE;
    lvaCrearReserva           VARCHAR2(1);
    lvaExisteDelegacion       VARCHAR2(1);
    lnuNumeroPagoAutorizacion SIN_PAGOS_DET.NUMERO_PAGO_AUTORIZACION%TYPE;
    lvaCdTributaria           SIN_PAGOS_DET.CDTRIBUTARIA%TYPE;
    lvaCodigoRetencion        SIN_RETENCIONES.CDRETENCION%TYPE;
    lvaExistePersona          VARCHAR2(1);

    CURSOR lcuSiniestros IS
      SELECT SITUACION,
             CDCIERRE,
             CODIGO_USUARIO,
             POLIZA,
             NCERTIFICADO
      FROM   SINIESTROS
      WHERE  expediente = ivaExpediente;

    CURSOR lcuReserva IS
      SELECT NVL(RESERVA_ACTUAL, 0)
      FROM   RESERVAS r
      WHERE  EXPEDIENTE = ivaExpediente
             AND CDRAMO = lvaCdramo
             AND CDSUBRAMO = lvaCdSubramo
             AND CDGARANTIA = lvaCdGarantia
             AND CDSUBGARANTIA = lvaCdSubGarantia
             AND r.NUMERO_RESERVA = lvaCdreserva;

    CURSOR lcuPagos IS
      SELECT MAX(IMPORTE),
             CDRAMO,
             CDSUBRAMO,
             CDGARANTIA,
             CDSUBGARANTIA,
             NUMERO_RESERVA,
             CDENTIDAD
      FROM   SIN_PAGOS_DET
      WHERE  EXPEDIENTE = ivaExpediente
      GROUP  BY CDRAMO,
                CDSUBRAMO,
                CDGARANTIA,
                CDSUBGARANTIA,
                NUMERO_RESERVA,
                CDENTIDAD
      ORDER  BY MAX(IMPORTE) DESC;

    CURSOR lcuDatosReservas IS
      SELECT MAX(RESERVA_ACTUAL),
             CDRAMO,
             CDSUBRAMO,
             CDGARANTIA,
             CDSUBGARANTIA,
             NUMERO_RESERVA
      FROM   RESERVAS
      WHERE  EXPEDIENTE = ivaExpediente
      GROUP  BY CDRAMO,
                CDSUBRAMO,
                CDGARANTIA,
                CDSUBGARANTIA,
                NUMERO_RESERVA
      ORDER  BY MAX(RESERVA_ACTUAL) DESC;

    CURSOR lcuDatosPoliza IS
     SELECT CDDELEGACION_RADICA
     FROM CUERPOLIZA
     WHERE NPOLIZA = lvaNmPoliza;


    CURSOR lcuDelegacion IS
      SELECT 'S' FROM AGE_DELEGACIONES WHERE CDDELEGACION = lvaCdEntidad;

    CURSOR lcuAsegurado IS
      SELECT DNI
      FROM PERSONAS_PROD
      WHERE NPOLIZA     = lvaNmPoliza
      AND NCERTIFICADO  = lvaNmCertificado
      AND CODIGO       IN ('020','120');

    CURSOR lcuExistePersona IS
     SELECT 'S'
     FROM PERSONAS
     WHERE dni = ivaDniSubrogacion;


  BEGIN

    OPEN lcuSiniestros;
    FETCH lcuSiniestros INTO lvaSituacionStro, lvaCdCierre, lvaCdUsuario, lvaNmPoliza, lvaNmCertificado;
    IF lcuSiniestros%NOTFOUND THEN
     lvaMensajeUsuario := 'NO EXISTE EL SINIESTRO';
     RAISE lexErrorProcedimiento;
    END IF;
    IF lvaSituacionStro = 'N' THEN
     lvaMensajeUsuario := 'EL SINIESTRO SE ENCUENTRA ANULADO';
     RAISE lexErrorProcedimiento;
    END IF;

-- Se elimina esta validaci?n por solicitud de Juan Diego Cadavid en correo del : lunes, 29 de septiembre de 2014 03:59 p.m.
-- con Asunto: Quitar validaci?n para deducibles Panam?
    lnuValorPagos:=0;lvaCdRamo:=NULL;lvaCdSubramo:=NULL;lvaCdGarantia:=NULL;lvaCdSubgarantia:=NULL;lvaCdreserva:=NULL;lvaCdEntidad:=NULL;
    OPEN lcuPagos;
    FETCH lcuPagos INTO lnuValorPagos, lvaCdRamo, lvaCdSubramo, lvaCdGarantia, lvaCdSubgarantia, lvaCdreserva, lvaCdEntidad;
    IF lcuPagos%NOTFOUND THEN
/*     lvaMensajeUsuario := 'No se han generado pagos al siniestro, no se pueden ingresar movimientos';
     RAISE lexErrorProcedimiento;*/
     OPEN lcuDatosReservas;
     FETCH lcuDatosReservas INTO lnuValorPagos, lvaCdRamo, lvaCdSubramo, lvaCdGarantia, lvaCdSubgarantia, lvaCdreserva;
     IF lcuDatosReservas%NOTFOUND THEN
      lvaMensajeUsuario := 'No se han generado ni reservas nipagos al siniestro, no se pueden ingresar movimientos';
      RAISE lexErrorProcedimiento;
     END IF;
     CLOSE lcuDatosReservas;

     OPEN lcuDatosPoliza;
     FETCH lcuDatosPoliza INTO lvaCdEntidad;
     IF lcuDatosPoliza%NOTFOUND THEN
      lvaMensajeUsuario := 'No existe datos de oficina de radicacion de la poliza';
      RAISE lexErrorProcedimiento;
     END IF;
     CLOSE lcuDatosPoliza;
    END IF;

    OPEN lcuAsegurado;
    FETCH lcuAsegurado INTO lvaDniAsegurado;
    IF lcuAsegurado%NOTFOUND THEN
     lvaMensajeUsuario := 'El asegurado no existe, no se pueden ingresar movimientos';
     RAISE lexErrorProcedimiento;
    END IF;
    CLOSE lcuAsegurado;

    -- Para Subrogaci?n el campo ivaDniSubrogacion es obligatorio
    IF ivaTipoMovimiento = 'S' AND ivaDniSubrogacion IS NULL THEN
     lvaMensajeUsuario := 'Para Subrogaciones, el DNI es obligatorio';
     RAISE lexErrorProcedimiento;
    END IF;

    IF ivaTipoMovimiento = 'S' AND ivaDniSubrogacion IS NOT NULL THEN
     OPEN lcuExistePersona;
     FETCH lcuExistePersona INTO lvaExistePersona;
     IF lcuExistePersona%NOTFOUND THEN
      lvaMensajeUsuario := 'Para Subrogaciones, el DNI debe estar creado en el modelo de personas';
      RAISE lexErrorProcedimiento;
     END IF;
     CLOSE lcuExistePersona;
    END IF;


    -- No se puede validar el usuario, porque viene de caja SAP

    -- Verifica El c?digo de Retenciones
    lvaCodigoRetencion := '0099';

    lvaSnivaRetenido     := 'N';

    -- Calcula si tiene tributos
    IF lvaCodigoRetencion = '0099' THEN
     lvaCdTributaria := 'S';
    ELSE
     lvaCdTributaria := 'N';
    END IF;

    -- Verifica Reserva
    IF ivaTipoMovimiento IN ('D','S') THEN
     lvaCdreserva := lvaCdreserva;--'P012099';
    ELSE
     lvaMensajeUsuario := 'El tipo de movimiento es obligatorio';
     RAISE lexErrorProcedimiento;
    END IF;

    lnuValorReserva := 0;
    lvaCrearReserva := 'N';
    OPEN lcuReserva;
    FETCH lcuReserva INTO lnuValorReserva;
    IF lcuReserva%NOTFOUND THEN
     lvaCrearReserva := 'S';
    END IF;
    CLOSE lcuReserva;

    -- Verifica pagos
    OPEN lcuDelegacion;
    FETCH lcuDelegacion INTO lvaExisteDelegacion;
    IF lcuDelegacion%NOTFOUND THEN
     lvaMensajeUsuario := 'No existe la ofina de pago';
     RAISE lexErrorProcedimiento;
    END IF;

    IF lvaSituacionStro IN ('T', 'C', 'O', 'D') THEN
     PCK_SINIESTROS.SP_REAPERTURA_SIN_RESERVA(ivaExpediente,
                                              lvaCdUsuario,
                                              lvaMensajeTecnicoExt,
                                              lvaMensajeUsuarioExt);
     IF lvaMensajeTecnicoExt IS NOT NULL OR  lvaMensajeUsuarioExt IS NOT NULL THEN
      lvaMensajeUsuarioExt:= 'Error Reaperturando el expediente: ' || lvaMensajeUsuarioExt  ;
      RAISE lexErrorProcedimientoExt;
     END IF;
    END IF;

    IF NVL(lvaCrearReserva, 'S') = 'S' THEN
     lnuValorReserva := 0;
     PCK_SINIESTROS.SP_CREAR_RESERVA(ivaExpediente,
                                     lvaCdGarantia,
                                     lvaCdSubGarantia,
                                     lvaCdreserva,
                                     lnuValorReserva,
                                     lvaCdUsuario,
                                     lvaMensajeTecnicoExt,
                                     lvaMensajeUsuarioExt);
     IF lvaMensajeTecnicoExt IS NOT NULL OR  lvaMensajeUsuarioExt IS NOT NULL THEN
      lvaMensajeUsuarioExt:= 'Error creando reserva: ' || lvaMensajeUsuarioExt  ;
      RAISE lexErrorProcedimientoExt;
     END IF;
    END IF;

    -- Graba pagos
    lnuRegistros := lnuRegistros + 1;
    ltabEntradaAutorizacion(lnuRegistros).ivacdusuario := lvaCdUsuario;
    ltabEntradaAutorizacion(lnuRegistros).ivaExpediente := ivaExpediente;
    ltabEntradaAutorizacion(lnuRegistros).ivaCdgarantia := lvaCdGarantia;
    ltabEntradaAutorizacion(lnuRegistros).ivaCdsubgarantia := lvaCdSubGarantia;
    ltabEntradaAutorizacion(lnuRegistros).ivaNumeroReserva := lvaCdreserva;
    ltabEntradaAutorizacion(lnuRegistros).inuVlrAutorizacion := inuValorMovimiento;
    ltabEntradaAutorizacion(lnuRegistros).ivaCdretencion := lvaCodigoRetencion;
    IF ivaTipoMovimiento = 'S' THEN
     ltabEntradaAutorizacion(lnuRegistros).ivaDni := ivaDniSubrogacion;
    ELSE
     ltabEntradaAutorizacion(lnuRegistros).ivaDni := lvaDniAsegurado;
    END IF;
    ltabEntradaAutorizacion(lnuRegistros).ivaTipoEntidad := lvaTipoEntidad;
    ltabEntradaAutorizacion(lnuRegistros).ivaCdentidad := lvaCdEntidad;
    ltabEntradaAutorizacion(lnuRegistros).inuPoirpf := lnuPoIva;
    ltabEntradaAutorizacion(lnuRegistros).inuImpirpf := ROUND(lnuVlrIva);
    ltabEntradaAutorizacion(lnuRegistros).inuDeducible := 0;
    ltabEntradaAutorizacion(lnuRegistros).inuPoirc := lnuPoReteFuente;
    ltabEntradaAutorizacion(lnuRegistros).inuImpirc := ROUND(lnuVlrReteFuente);
    ltabEntradaAutorizacion(lnuRegistros).inuPoirpfRetenido := 0;
    ltabEntradaAutorizacion(lnuRegistros).inuImpirpfRetenido := 0;
    ltabEntradaAutorizacion(lnuRegistros).inuPoica := 0;
    ltabEntradaAutorizacion(lnuRegistros).inuImpica := 0;
    ltabEntradaAutorizacion(lnuRegistros).ivasnivaRetenido := lvaSnivaRetenido;
    ltabEntradaAutorizacion(lnuRegistros).ivasniva := 'N';
    ltabEntradaAutorizacion(lnuRegistros).inupodescuento := 0;
    ltabEntradaAutorizacion(lnuRegistros).ivacdtributaria := lvaCdTributaria;
    ltabEntradaAutorizacion(lnuRegistros).idaFeposiblePago := SYSDATE;
    ltabEntradaAutorizacion(lnuRegistros).ivaSnGerencia := 'N';
    ltabEntradaAutorizacion(lnuRegistros).ivaCdbanco := NULL;
    ltabEntradaAutorizacion(lnuRegistros).ivaNnmcuenta := NULL;
    ltabEntradaAutorizacion(lnuRegistros).ivaCdSucursalBanco := NULL;
    ltabEntradaAutorizacion(lnuRegistros).ivaCdTipoCuenta := NULL;
    ltabEntradaAutorizacion(lnuRegistros).inuNumero_Pago_Autorizacion := NULL;
    ltabEntradaAutorizacion(lnuRegistros).ivaCdTipoMovimiento := ivaTipoMovimiento;

    PCK_SINIESTROS.SP_CREAR_AUTORIZACION(ltabEntradaAutorizacion,
                                         lvaMensajeTecnicoExt,
                                         lvaMensajeUsuarioExt);
    IF lvaMensajeTecnicoExt IS NOT NULL OR  lvaMensajeUsuarioExt IS NOT NULL THEN
     lvaMensajeUsuarioExt:= 'Error creando Aurorizacion: ' || lvaMensajeUsuarioExt  ;
     RAISE lexErrorProcedimientoExt;
    END IF;

    onuNmPagoAutorizacion     := ltabEntradaAutorizacion(lnuRegistros).inuNumero_Pago_Autorizacion;
    lnuNumeroPagoAutorizacion := ltabEntradaAutorizacion(lnuRegistros).inuNumero_Pago_Autorizacion;

    IF lnuNumeroPagoAutorizacion IS NOT NULL THEN
     PCK_SIN_GESTOR_SAP.SP_ENVIAR_MENSAJE_CXP(ivaExpediente,
                                              lnuNumeroPagoAutorizacion,
                                              lvaMensajeTecnicoExt,
                                              lvaMensajeUsuarioExt);
     IF lvaMensajeTecnicoExt IS NOT NULL OR  lvaMensajeUsuarioExt IS NOT NULL THEN
      lvaMensajeUsuarioExt:= 'Error llevando a SAP: ' || lvaMensajeUsuarioExt  ;
      RAISE lexErrorProcedimientoExt;
     END IF;
      -- INFORMACI?N PARA SINESTROS DE COMPA??AS EXTERNAS A SURA.
      -- Se tomo este codigo de cuando se ten?a en Caja Integrada.
      DECLARE
       lvaCdtipoMovimiento VARCHAR2(15) := 'AUTORIZA_PAGO';
       lvaCdOperacion      VARCHAR2(15) := 'CREACION';
       lvaCiaMatriz        VARCHAR2(5);
       lvaExiste           VARCHAR2(6) := ' ';
       w_neto_recibo       NUMBER := 0;

       CURSOR temp_cursor1 IS
        SELECT 'Existe'
        FROM tsin_externos
        WHERE cdcia_matriz      = lvaCiaMatriz
        AND nmexpediente        = ivaExpediente
        AND nmpago_autorizacion = lnuNumeroPagoAutorizacion
        AND cdtipo_movimiento   = lvaCdtipoMovimiento
        AND cdoperacion         = lvaCdOperacion;

       CURSOR temp_cursor2 IS
        SELECT SUM(NVL(importe,0)-NVL(impirc,0)-NVL(impirpf_retenido,0)-NVL(impica,0)-NVL(ptdescuento,0))
        FROM sin_pagos_det
        WHERE expediente             = ivaExpediente
        AND numero_pago_autorizacion = lnuNumeroPagoAutorizacion;

      BEGIN
       lvaCiaMatriz := PCK_GESTION_PRODUCTOS.fnget_compania_matriz_prod(lvaCdRamo,lvaCdSubramo);
       IF lvaCiaMatriz <> '00' THEN
                w_neto_recibo := 0;
                OPEN temp_cursor2;
                FETCH temp_cursor2 INTO w_neto_recibo;
                CLOSE temp_cursor2;

        IF w_neto_recibo > 0 THEN
         lvaCdOperacion := 'AUTORIZA_PAGO';
        ELSE
         lvaCdOperacion := 'AUTORIZA_RECO';
        END IF;

        OPEN temp_cursor1;
        FETCH temp_cursor1 INTO lvaExiste;
        CLOSE temp_cursor1;
        IF lvaExiste <> 'Existe' THEN
         BEGIN
          INSERT INTO tsin_externos_hist
                 (cdcia_matriz,nmexpediente,cdramo,cdsubramo,cdsituacion,fegeneracion,cdtipo_movimiento,cdoperacion,nmpago_autorizacion)
          VALUES (lvaCiaMatriz,ivaExpediente,lvaCdRamo, lvaCdSubramo, NULL,SYSDATE,lvaCdtipoMovimiento,lvaCdOperacion,lnuNumeroPagoAutorizacion);

          INSERT INTO tsin_externos
                 (cdcia_matriz,nmexpediente,cdramo,cdsubramo,cdsituacion,fegeneracion,cdtipo_movimiento,cdoperacion,nmpago_autorizacion)
          VALUES (lvaCiaMatriz,ivaExpediente,lvaCdRamo, lvaCdSubramo, NULL,SYSDATE,lvaCdtipoMovimiento,lvaCdOperacion,lnuNumeroPagoAutorizacion);
         EXCEPTION
          WHEN OTHERS THEN
           lvaMensajeUsuario:= 'Error Coexistencia pago';
           RAISE lexErrorProcedimiento;
         END;
        END IF;
       END IF;
      END;
      -- FIN INFORMACI?N PARA SINESTROS DE COMPA??AS EXTERNAS A SURA




                  /*         SP_INSERTAR_CAJA ( ivaExpediente, lnuNumeroPagoAutorizacion, ldaFePosiblePago,
                                              ivaUsuario, 'N',NULL, NULL, NULL, NULL,
                                              lvaMensajeTecnicoCaja, lvamensajeUsuarioCaja);
                  */
    END IF;

    -- Si el siniestro se encontraba cerrado, se debe volver a dejar cerrado en el estado inicial
    IF lvaSituacionStro IN ('T', 'C', 'O', 'D') THEN
     PCK_SINIESTROS.SP_CERRAR_SINIESTRO(ivaExpediente,
                                        lvaSituacionStro,
                                        lvaCdCierre,
                                        lvaCdUsuario,
                                        lvaMensajeTecnicoExt,
                                        lvaMensajeUsuarioExt);
     IF lvaMensajeTecnicoExt IS NOT NULL OR  lvaMensajeUsuarioExt IS NOT NULL THEN
      lvaMensajeUsuarioExt:= 'Error cerrando expediente: ' || lvaMensajeUsuarioExt  ;
      RAISE lexErrorProcedimientoExt;
     END IF;
    END IF;

    CLOSE lcuSiniestros;

  EXCEPTION
   WHEN lexErrorProcedimientoExt THEN
    ovaMensajeTecnico:=lvaMensajeTecnicoExt;
    ovaMensajeUsuario:=lvaMensajeUsuarioExt;
   WHEN lexErrorProcedimiento THEN
    ovaMensajeTecnico:= lvaMensajeTecnico;
    ovaMensajeUsuario:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeUsuario;
   WHEN OTHERS THEN
    ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
    ovaMensajeUsuario:= 'TRANSACCION NO DISPONIBLE ' ;
  END SP_DEDUCIBLE_CAJA_SAP;
---------------------------------------------------------------------------------------------------
  PROCEDURE SP_VALIDA_DEDUC_SUBROGA(ivaTipoMovimiento      IN VARCHAR2,
                                    ivaExpediente          IN SIN_PAGOS_DET.EXPEDIENTE%TYPE,
                                    ivaNmPoliza            IN SIN_PAGOS_DET.NPOLIZA%TYPE,
                                    ivaDniSubrogacion      IN VARCHAR2 DEFAULT NULL,
                                    ovaMensajeTecnico     OUT VARCHAR2,
                                    ovaMensajeUsuario     OUT VARCHAR2,
                                    ovaNnPoliza           OUT VARCHAR2) IS

    lvaNombreObjeto          VARCHAR2(30) := 'SP_VALIDA_DEDUC_SUBROGA';

    lexErrorProcedimiento     EXCEPTION;
    lexErrorProcedimientoExt  EXCEPTION;

    lvaMensajeTecnico         VARCHAR2(1000)  := NULL;
    lvaMensajeTecnicoExt      VARCHAR2(1000)  := NULL;
    lvaMensajeUsuario         VARCHAR2(1000)  := NULL;
    lvaMensajeUsuarioExt      VARCHAR2(1000)  := NULL;

    lvaSituacionStro          SINIESTROS.SITUACION%TYPE;
    lvaCdCierre               SINIESTROS.CDCIERRE%TYPE;
    lvaCdUsuario              SINIESTROS.CODIGO_USUARIO%TYPE;
    lvaCdRamo                 SIN_PAGOS_DET.CDRAMO%TYPE;
    lvaCdSubramo              SIN_PAGOS_DET.CDSUBRAMO%TYPE;
    lvaCdGarantia             SIN_PAGOS_DET.CDGARANTIA%TYPE;
    lvaCdSubgarantia          SIN_PAGOS_DET.CDSUBGARANTIA%TYPE;
    lvaCdEntidad              SIN_PAGOS_DET.CDENTIDAD%TYPE;
    lnuValorPagos             SIN_PAGOS_DET.IMPORTE%TYPE;
    lvaCdreserva              SIN_RESERVAS.CDRESERVA%TYPE;
    lvaNmPoliza               SIN_PAGOS_DET.NPOLIZA%TYPE;
    lvaNmCertificado          SIN_PAGOS_DET.NCERTIFICADO%TYPE;
    lvaDniAsegurado           SIN_PAGOS_DET.DNI%TYPE;
    lvaExistePersona          VARCHAR2(1);

    CURSOR lcuSiniestros IS
      SELECT SITUACION,
             CDCIERRE,
             CODIGO_USUARIO,
             POLIZA,
             NCERTIFICADO
      FROM   SINIESTROS
      WHERE  expediente = ivaExpediente;

    CURSOR lcuPagos IS
      SELECT MAX(IMPORTE),
             CDRAMO,
             CDSUBRAMO,
             CDGARANTIA,
             CDSUBGARANTIA,
             NUMERO_RESERVA,
             CDENTIDAD
      FROM   SIN_PAGOS_DET
      WHERE  EXPEDIENTE = ivaExpediente
      GROUP  BY CDRAMO,
                CDSUBRAMO,
                CDGARANTIA,
                CDSUBGARANTIA,
                NUMERO_RESERVA,
                CDENTIDAD
      ORDER  BY MAX(IMPORTE) DESC;

    CURSOR lcuDatosReservas IS
      SELECT MAX(RESERVA_ACTUAL),
             CDRAMO,
             CDSUBRAMO,
             CDGARANTIA,
             CDSUBGARANTIA,
             NUMERO_RESERVA
      FROM   RESERVAS
      WHERE  EXPEDIENTE = ivaExpediente
      GROUP  BY CDRAMO,
                CDSUBRAMO,
                CDGARANTIA,
                CDSUBGARANTIA,
                NUMERO_RESERVA
      ORDER  BY MAX(RESERVA_ACTUAL) DESC;

    CURSOR lcuDatosPoliza IS
     SELECT CDDELEGACION_RADICA
     FROM CUERPOLIZA
     WHERE NPOLIZA = lvaNmPoliza;

    CURSOR lcuAsegurado IS
      SELECT DNI
      FROM PERSONAS_PROD
      WHERE NPOLIZA     = lvaNmPoliza
      AND NCERTIFICADO  = lvaNmCertificado
      AND CODIGO       IN ('020','120');

    CURSOR lcuExistePersona IS
     SELECT 'S'
     FROM PERSONAS
     WHERE dni = ivaDniSubrogacion;


  BEGIN

    OPEN lcuSiniestros;
    FETCH lcuSiniestros INTO lvaSituacionStro, lvaCdCierre, lvaCdUsuario, lvaNmPoliza, lvaNmCertificado;
    IF lcuSiniestros%NOTFOUND THEN
     lvaMensajeUsuario := 'NO EXISTE EL SINIESTRO';
     RAISE lexErrorProcedimiento;
    END IF;
    IF lvaSituacionStro = 'N' THEN
     lvaMensajeUsuario := 'EL SINIESTRO SE ENCUENTRA ANULADO';
     RAISE lexErrorProcedimiento;
    END IF;
    IF lvaNmPoliza <> ivaNmPoliza THEN
     lvaMensajeUsuario := 'La p?liza enviada no corresponde a la poliza siniestrada.';
     ovaNnPoliza := lvaNmPoliza;
     RAISE lexErrorProcedimiento;
    END IF;

    lnuValorPagos:=0;lvaCdRamo:=NULL;lvaCdSubramo:=NULL;lvaCdGarantia:=NULL;lvaCdSubgarantia:=NULL;lvaCdreserva:=NULL;lvaCdEntidad:=NULL;
    OPEN lcuPagos;
    FETCH lcuPagos INTO lnuValorPagos, lvaCdRamo, lvaCdSubramo, lvaCdGarantia, lvaCdSubgarantia, lvaCdreserva, lvaCdEntidad;
    IF lcuPagos%NOTFOUND THEN
     OPEN lcuDatosReservas;
     FETCH lcuDatosReservas INTO lnuValorPagos, lvaCdRamo, lvaCdSubramo, lvaCdGarantia, lvaCdSubgarantia, lvaCdreserva;
     IF lcuDatosReservas%NOTFOUND THEN
      lvaMensajeUsuario := 'No se han generado ni reservas nipagos al siniestro, no se pueden ingresar movimientos';
      RAISE lexErrorProcedimiento;
     END IF;
     CLOSE lcuDatosReservas;

     OPEN lcuDatosPoliza;
     FETCH lcuDatosPoliza INTO lvaCdEntidad;
     IF lcuDatosPoliza%NOTFOUND THEN
      lvaMensajeUsuario := 'No existe datos de oficina de radicacion de la poliza';
      RAISE lexErrorProcedimiento;
     END IF;
     CLOSE lcuDatosPoliza;
    END IF;

    OPEN lcuAsegurado;
    FETCH lcuAsegurado INTO lvaDniAsegurado;
    IF lcuAsegurado%NOTFOUND THEN
     lvaMensajeUsuario := 'El asegurado no existe, no se pueden ingresar movimientos';
     RAISE lexErrorProcedimiento;
    END IF;
    CLOSE lcuAsegurado;

    -- Para Subrogaci?n el campo ivaDniSubrogacion es obligatorio
    IF ivaTipoMovimiento = 'S' AND ivaDniSubrogacion IS NULL THEN
     lvaMensajeUsuario := 'Para Subrogaciones, el DNI es obligatorio';
     RAISE lexErrorProcedimiento;
    END IF;

    IF ivaTipoMovimiento = 'S' AND ivaDniSubrogacion IS NOT NULL THEN
     OPEN lcuExistePersona;
     FETCH lcuExistePersona INTO lvaExistePersona;
     IF lcuExistePersona%NOTFOUND THEN
      lvaMensajeUsuario := 'Para Subrogaciones, el DNI debe estar creado en el modelo de personas';
      RAISE lexErrorProcedimiento;
     END IF;
     CLOSE lcuExistePersona;
    END IF;

    -- Verifica Reserva
    IF ivaTipoMovimiento IN ('D','S') THEN
     NULL;
    ELSE
     lvaMensajeUsuario := 'El tipo de movimiento es obligatorio';
     RAISE lexErrorProcedimiento;
    END IF;

  EXCEPTION
   WHEN lexErrorProcedimientoExt THEN
    ovaMensajeTecnico:=lvaMensajeTecnicoExt;
    ovaMensajeUsuario:=lvaMensajeUsuarioExt;
   WHEN lexErrorProcedimiento THEN
    ovaMensajeTecnico:= lvaMensajeTecnico;
    ovaMensajeUsuario:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeUsuario;
   WHEN OTHERS THEN
    ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
    ovaMensajeUsuario:= 'TRANSACCION NO DISPONIBLE ' ;
  END SP_VALIDA_DEDUC_SUBROGA;
---------------------------------------------------------------------------------------------------

/*  FUNCTION FN_CREAR_MENSAJE_RETENCIONES (ivaCdSociedad           IN VARCHAR2,
                                         ivaDniBenePago          IN VARCHAR2,
                                         inuPtImporte            IN NUMBER,
                                         inuPtDeducible          IN NUMBER,
                                         ivaCdMoneda             IN VARCHAR2,
                                         inuPoIVA                IN VARCHAR2,
                                         iarrRetenciones         IN TAB_SAP_RETENCIONES_SINI,
--                                         ivaCdCodigoRetencion    IN VARCHAR2,
--                                         ivaCdIndicadorRetencion IN VARCHAR2,
                                         ovaMensajeTecnico      OUT VARCHAR2,
                                         ovaMensajeUsuario      OUT VARCHAR2  )
                                         RETURN OBJ_SAP_SIMULA_RETENC_SINI_REQ IS

  --Variables para el manejo de Errores
  lvaMensajeTecnico           VARCHAR2(1000)  := NULL;
  lvaMensajeTecnicoExt        VARCHAR2(1000)  := NULL;
  lvaMensajeUsuario           VARCHAR2(1000)  := NULL;
  lvaMensajeUsuarioExt        VARCHAR2(1000)  := NULL;
  lexErrorProcedimiento       EXCEPTION;
  lexErrorProcedimientoExt    EXCEPTION;
  lvaNombreObjeto             VARCHAR2(30)   :='FN_CREAR_MENSAJE_RETENCIONES';

  lobjSimulaRetencionReq      OBJ_SAP_SIMULA_RETENC_SINI_REQ := OBJ_SAP_SIMULA_RETENC_SINI_REQ();
  lobjDocumentosRetencion     OBJ_SAP_DOC_RETENCIONES_SINI   := OBJ_SAP_DOC_RETENCIONES_SINI();
  ltabDocumentosRetencion     TAB_SAP_DOC_RETENCIONES_SINI   := TAB_SAP_DOC_RETENCIONES_SINI(OBJ_SAP_DOC_RETENCIONES_SINI());
  lobjRetenciones             OBJ_SAP_RETENCIONES_SINI       := OBJ_SAP_RETENCIONES_SINI();
  ltabRetenciones             TAB_SAP_RETENCIONES_SINI       := TAB_SAP_RETENCIONES_SINI(OBJ_SAP_RETENCIONES_SINI());
  lobjTyinf                   OBJ_SBK_MENSAJE_INF            := OBJ_SBK_MENSAJE_INF(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
  ltyEncabezadoMens           TAB_SBK_ENC_MENSAJE            := TAB_SBK_ENC_MENSAJE(OBJ_SBK_ENC_MENSAJE(NULL,NULL));
  lvaDsUsuario                TCOB_PARAMETROS_SAP.CDUSUARIO%TYPE;
  lvaDsClave                  TCOB_PARAMETROS_SAP.CDCLAVE%TYPE;

  CURSOR lcuUsuarioServicio IS
   SELECT CDUSUARIO, CDCLAVE
   FROM TCOB_PARAMETROS_SAP
   WHERE cdservicio = 'SI_o_WS_CausacionDocContable.wsdl';

  BEGIN

   IF ivaCdSociedad              IS NULL
      OR ivaDniBenePago          IS NULL
      OR inuPtImporte            IS NULL
--      OR inuPtDeducible          IS NULL
      OR ivaCdMoneda             IS NULL
      OR inuPoIVA                IS NULL
\*      OR ivaCdCodigoRetencion    IS NULL
      OR ivaCdIndicadorRetencion IS NULL*\ THEN
    lvaMensajeTecnico := 'Los datos de entrada NO pueden estar vacios';
    RAISE lexErrorProcedimiento;
   END IF;

  --Datos generales del mensaje que necesita Surabroker ...
  --Parametrizables
  lvaMensajeTecnico            := 'Valores Iniciales';
  lobjTyinf.CDCONSUMIDOR       := 'SINIESTROS';
  lobjTyinf.CDSERVICIO         := 'SI_o_WS_CausacionDocContable.wsdl';
  lobjTyinf.CDOPERACION        := 'OP_s_SimularRetenciones';
  --lobjTyinf.CDTOKEN          := ''; hasta donde s?, no aplica
  lobjTyinf.CDVERSION_SERVICIO := '1.0';
  lobjTyinf.DSNAME_SPACE       := NULL;
  lobjTyinf.DSPUERTO           := 'HTTP_Port';

  --No Parametrizables
  lobjTyinf.DSCLAVE            := ivaDniBenePago;--ivaCdCodigoRetencion;
  lobjTyinf.FECREACION         := SYSDATE;
  lobjTyinf.NMPRIORIDAD        := NULL;

  OPEN lcuUsuarioServicio;
  FETCH lcuUsuarioServicio INTO lvaDsUsuario, lvaDsClave;
  CLOSE lcuUsuarioServicio;

  ltyEncabezadoMens            := TAB_SBK_ENC_MENSAJE(OBJ_SBK_ENC_MENSAJE( PCK_SBK_SURABROKER.HEADER_BASIC_AUTH_USER,lvaDsUsuario));
  ltyEncabezadoMens.EXTEND;
  ltyEncabezadoMens(2)         := OBJ_SBK_ENC_MENSAJE( PCK_SBK_SURABROKER.HEADER_BASIC_AUTH_PASSWORD,lvaDsClave);  lobjTyinf.TYENCABEZADOS      := ltyEncabezadoMens;

  -- Se inicializa las variables de SuraBroker dado que el objeto lobjSimulaRetencionReq
  -- est? UNDER el objeto de SuraBroker OBJ_SBK_MENSAJE
  lobjSimulaRetencionReq.Tyinf := lobjTyinf;

  -- Se comienza el llenado del mensaje a enviar en el gestor
  --1. datos de la retencion
  FOR lnuRecord IN iarrRetenciones.FIRST..iarrRetenciones.LAST  LOOP
   lobjRetenciones.cdTipoRetencion      := iarrRetenciones(lnuRecord).cdTipoRetencion;--ivaCdCodigoRetencion;
   lobjRetenciones.cdIndicadorRetencion := iarrRetenciones(lnuRecord).cdIndicadorRetencion;--ivaCdIndicadorRetencion;

   IF lnuRecord = 1 THEN
    ltabRetenciones(lnuRecord) := lobjRetenciones;
   ELSE
    ltabRetenciones.Extend;
    ltabRetenciones(lnuRecord) := lobjRetenciones;
   END IF;
--  ltabRetenciones(1)                   := lobjRetenciones;

  END LOOP;

  --2. datos de los documentos de retencion
  lobjDocumentosRetencion.ptImporte            := inuPtImporte;
  lobjDocumentosRetencion.ptDeducciones        := inuPtDeducible;
  lobjDocumentosRetencion.cdMoneda             := ivaCdMoneda;
  lobjDocumentosRetencion.cdIndicadorImpuestos := LPAD(REPLACE(TO_CHAR(RPAD(inuPoIVA,4,'0')),'.',''),4,'0');
  lobjDocumentosRetencion.datosRetenciones     := ltabRetenciones;
  ltabDocumentosRetencion(1)                   := lobjDocumentosRetencion;

  --3. datos del simulado de retencion
  lobjSimulaRetencionReq.cdCompania := ivaCdSociedad;
  lobjSimulaRetencionReq.cdTipoNif       := PCK_SIC_UTILITARIOS_I.FN_SIC_CDTIPO_IDENTIFICACION(ivaDniBenePago);
  lobjSimulaRetencionReq.nmIdentifFiscal := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(ivaDniBenePago);
  lobjSimulaRetencionReq.documentos      := ltabDocumentosRetencion;

  -- Retorna el objeto completo par ser enviado en el Gestor
  RETURN lobjSimulaRetencionReq;

  EXCEPTION
      WHEN lexErrorProcedimientoExt THEN
        ovaMensajeTecnico:=lvaMensajeTecnicoExt;
        ovaMensajeUsuario:=lvaMensajeUsuarioExt;
        RETURN NULL;
      WHEN lexErrorProcedimiento THEN
        ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
        ovaMensajeUsuario:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeUsuario;
        RETURN NULL;
      WHEN OTHERS THEN
       ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
       ovaMensajeUsuario:= 'TRANSACCION NO DISPONIBLE ' ;
       RETURN NULL;
  END FN_CREAR_MENSAJE_RETENCIONES;
*/---------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------
  -- 22/11/2024 josebuvi Desarrollo para verificacion de retencion ramos de vida         
  FUNCTION FN_CREAR_MENSAJE_CXP_083(ivaNmExpediente        IN SIN_PAGOS_DET.EXPEDIENTE%TYPE,
                                    ivaNmPagoAutorizacion  IN SIN_PAGOS_DET.NUMERO_PAGO_AUTORIZACION%TYPE,
                                    ovaMensajeTecnico      OUT VARCHAR2,
                                    ovaMensajeUsuario      OUT VARCHAR2) RETURN OBJ_SAP_CXP_SINIESTROS IS

  --Variables para el manejo de Errores
  lvaMensajeTecnico           VARCHAR2(1000)  := NULL;
  lvaMensajeTecnicoExt        VARCHAR2(1000)  := NULL;
  lvaMensajeUsuario           VARCHAR2(1000)  := NULL;
  lvaMensajeUsuarioExt        VARCHAR2(1000)  := NULL;
  lexErrorProcedimiento       EXCEPTION;
  lexErrorProcedimientoExt    EXCEPTION;
  lvaNombreObjeto             VARCHAR2(30)   :='FN_CREAR_MENSAJE_CXP_083';


  --Objeto para retornar con mensaje SAP
  lobjPago                          OBJ_SAP_CXP_SINIESTROS      := OBJ_SAP_CXP_SINIESTROS();
  lobjTyinf                         OBJ_SBK_MENSAJE_INF         := OBJ_SBK_MENSAJE_INF(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
  ltyEncabezadoMens                 TAB_SBK_ENC_MENSAJE         := TAB_SBK_ENC_MENSAJE(OBJ_SBK_ENC_MENSAJE(NULL, NULL));
  lobjCabecera                      OBJ_SAP_CABECERA_CXP_SINI   := OBJ_SAP_CABECERA_CXP_SINI();
  lobjDocumento                     OBJ_SAP_DOCUMENTO_CXP_SINI  := OBJ_SAP_DOCUMENTO_CXP_SINI();
  lobjDocumentos                    TAB_SAP_DOCUMENTO_CXP_SINI  := TAB_SAP_DOCUMENTO_CXP_SINI(OBJ_SAP_DOCUMENTO_CXP_SINI());
  lobjDetalle                       OBJ_SAP_DETALLE_CXP_SINI    := OBJ_SAP_DETALLE_CXP_SINI();
  lobjTabDetalles                   TAB_SAP_DETALLES_CXP_SINI   := TAB_SAP_DETALLES_CXP_SINI(OBJ_SAP_DETALLE_CXP_SINI());
  lobjRetencion                     OBJ_SAP_DATO_RETENCION      := OBJ_SAP_DATO_RETENCION();
  lobjRetenciones                   TAB_SAP_DATOS_RETENCIONES   := TAB_SAP_DATOS_RETENCIONES(OBJ_SAP_DATO_RETENCION());
  lobjDatosConversion               OBJ_SAP_DATOS_CONVERSION    := OBJ_SAP_DATOS_CONVERSION();
  lobjCuentaBancaria                OBJ_SAP_CUENTA              := OBJ_SAP_CUENTA();
  lobjtercero                       OBJ_SAP_TERCERO             := OBJ_SAP_TERCERO();
  lobjCondicionPago                 OBJ_SAP_CONDICION_PAGO_SINI := OBJ_SAP_CONDICION_PAGO_SINI();
  lobjInfoFiscal                    OBJ_SAP_INFO_FISCAL         := OBJ_SAP_INFO_FISCAL();
  ltyTercero                        PCK_SIC_SAP.regTercero;

  ltabMapItems                      TAB_SAP_DTMAPITEM           := TAB_SAP_DTMAPITEM(OBJ_SAP_DTMAPITEM());
  lobjMap                           OBJ_SAP_DTMAP               := OBJ_SAP_DTMAP();
  lobjItemMap                       OBJ_SAP_DTMAPITEM           := OBJ_SAP_DTMAPITEM();
/*  ltabMapItems                      TAB_SAP_MAPITEM           := TAB_SAP_MAPITEM(OBJ_SAP_MAPITEM());
  lobjMap                           OBJ_SAP_MAP               := OBJ_SAP_MAP();
  lobjItemMap                       OBJ_SAP_MAPITEM           := OBJ_SAP_MAPITEM();*/
  lvaDsUsuario                      T999_PARAMETROS.DSVALOR_PARAMETRO%TYPE;
  lvaDsClave                        T999_PARAMETROS.DSVALOR_PARAMETRO%TYPE;

  --Variables para llenar los Objetos
  lnuContadorDetalle                NUMBER                    := 0;
  lnuContadorRetencion              NUMBER                    := 0;
  lnuContadorDocumentos             NUMBER                    := 0;
  lnuContadorRetencionVida          NUMBER                    := 0;

  --Variables propias del aplicativo
  lvaCdCompania                    DIC_ALIAS_RS.CDCIA%TYPE;
  lvaCdRamo                        SIN_PAGOS_DET.CDRAMO%TYPE;
  lvaCdSubRamo                     SIN_PAGOS_DET.CDSUBRAMO%TYPE;
  lvaCdGarantia                    SIN_PAGOS_DET.CDGARANTIA%TYPE;
  lvaCdSubGarantia                 SIN_PAGOS_DET.CDSUBGARANTIA%TYPE;
  lnuPoDescuento                   SIN_PAGOS_DET.PODESCUENTO%TYPE;

  lvaCdciaMatriz                   DIC_ALIAS_RS.CDCIA_MATRIZ%TYPE;
  -- juancagr 20160903 variables para el manejo de las facturas
  lnuVlrFactura                    SIN_FACTURAS.PTVALOR_FACTURA%TYPE;
  lvaNmFactura                     SIN_FACTURAS.NMFACTURA%TYPE;
  lvaNmPrefijo                     SIN_FACTURAS.NMPREFIJO%TYPE;
  lvaSnCalcularImpuestos           VARCHAR2(1)                := 'S';
  lvaNmExpediente                  SIN_PAGOS_DET.EXPEDIENTE%TYPE;
  lvaNmPoliza                      SIN_PAGOS_DET.NPOLIZA%TYPE;
  lvaNmCertificado                 SIN_PAGOS_DET.NCERTIFICADO%TYPE;
  lvaDniAsegurado                  PERSONAS.DNI%TYPE;
  lvaNmAsegurado                   PERSONAS.DNI%TYPE;
  lvaNmBeneficiarioPago            SIN_PAGOS_DET.DNI%TYPE;
  ldaFeOcurrencia                  SINIESTROS.FECHA_SINIESTRO%TYPE;
  ldaFenotificacion                SINIESTROS.FECHA_NOTIFICACION%TYPE;
  lvaFeposiblePago                 PAGOS.FEPOSIBLE_PAGO%TYPE;
  lvaCdViaPago                     PAGOS.CDVIAPAGO%TYPE;
  lvaCdbloqueoPago                 PAGOS.CDBLOQUEOPAGO%TYPE;
  lvaCdPaisBanco                   PAGOS.CDPAISBANCO%TYPE;
  lvaCdBanco                       PAGOS.CDBANCO%TYPE;
  lvaNmCuenta                      PAGOS.NMCUENTA%TYPE;
  cdTipoCuenta                     PAGOS.CDTIPOCUENTA%TYPE;
  lvaCdSucursalBanco               PAGOS.CDSUCURSALBANCO%TYPE;
  lvaDsTitular                     PAGOS.DSTITULAR%TYPE;
  lvaCdTipoReserva                 DIC_ALIAS_COBERTURAS.CDTIPO_RESERVA%TYPE;
  lvaCdramoContable                DIC_ALIAS_COBERTURAS.CDRAMO_CONTABLE%TYPE;
  lvaCdRetencion                   SIN_PAGOS_DET.CDRETENCION%TYPE;
  lnuImpIrc                        SIN_PAGOS_DET.IMPIRC%TYPE;
  lnuImpIrpfRetenido               SIN_PAGOS_DET.IMPIRPF_RETENIDO%TYPE;
  lnuImpIca                        SIN_PAGOS_DET.IMPICA%TYPE;
  lvaCdAgente                      CUERPOLIZA.CDAGENTE%TYPE;
  lvaCdDelegacionRadica            CUERPOLIZA.CDDELEGACION_RADICA%TYPE;
  lvaMunicipioIca                  SIN_RETENCION_ICA.CDMUNICIPIO%TYPE;

  lvaDsTextoPosicion               VARCHAR2(50);
  lvaCdOperacion                   PAGOS.CDOPERACION%TYPE;
  lvaCdOficinaRegistro             SIN_PAGOS_DET.CDENTIDAD%TYPE;
  lnuIvaDescontable                SIN_PAGOS_DET.IMPIRPF%TYPE;
  lnuDeducible                     SIN_PAGOS_DET.DEDUCIBLE%TYPE;
  lnuPtDescuento                   SIN_PAGOS_DET.PTDESCUENTO%TYPE;
  lvaCodIva                        SIN_RETENCIONES.CDRETENCION%TYPE;
  lvaCdConcepto                    VARCHAR2(10);
  lvaSnBancaseguros                DIC_ALIAS_RS.SNBANCASEGUROS%TYPE;
  lvaDni                           PERSONAS.DNI%TYPE;
  lvaCdUsuario                     HISTORICO.CODIGO_USUARIO%TYPE;
  lvaDsLoginUsuario                USUARIOS_1.DSLOGIN%TYPE;
  lvaCdCiaCoaseguradora            COA_TRATADO_DETALLE.CDCIA%TYPE;
  lvaIdSoloSura                    VARCHAR2(2) := '00';
  lnuPorepartoCoa                  COA_TRATADO_DETALLE.POREPARTO_COA%TYPE;
  lvaTipoCoaseguro                 COA_TRATADO.CDCOA%TYPE;

  lvaNumeroReserva                 SIN_PAGOS_DET.NUMERO_RESERVA%TYPE;
  lvaPoIrpf                        SIN_PAGOS_DET.POIRPF%TYPE;
  lvaPoirc                         SIN_PAGOS_DET.POIRC%TYPE;
  lvaPoIca                         SIN_PAGOS_DET.POICA%TYPE;
  ldaFePago                        SIN_PAGOS_DET.FEPAGO%TYPE;
  lnuPoBaseRetencion               SIN_RETENCIONES.PORETENCION%TYPE;
  lnuPoRetencion                   SIN_RETENCIONES.PORETENCION%TYPE;
  lnuReteIvaSimplificado           SIN_PAGOS_DET.IMPIRPF_RETENIDO%TYPE;
  lvaSnIva                         SIN_PAGOS_DET.SNIVA%TYPE;
  --20140728 Por historia de usuario 77550 solicitada por Mario Franco, ya no se lleva obligado por Caja la pretenci?n objetivada.
  --lvaSNPagoJuridico                VARCHAR2(1);

  --Panam?
  ldaFeFecto                       CUERPOLIZA.FEFECTO%TYPE;
  ldaFeFectoAnualidad              CUERPOLIZA.FEFECTO_ANUALIDAD%TYPE;
  lvaSnPrimerVigencia              VARCHAR2(1);
  lvaCdGrupoCobertura              DIC_ALIAS_COBERTURAS.CDGRUPO_COBERTURA%TYPE;
  lvaGrupoProducto                 DIC_ALIAS_RS.CDGRUPO_PRODUCTO%TYPE;
  lvaSnProveedorPanama             VARCHAR2(1);
  lvaSnRiesgoExterior              VARCHAR2(1)     := 'N';
  lvaDigitoVerificacion            PERSONAS.NMDIGITO_VER%TYPE;
  lvaDniCoaseguro                  PERSONAS.DNI%TYPE;
  lvaCodigoAceptacion              PAGOS.CODIGO_ACEPTACION%TYPE;
  lvaSnPagoCajaSura                VARCHAR2(1)     := 'N';
--  lnuTotalDeducible                SIN_PAGOS_DET.DEDUCIBLE%TYPE;
--  lnuTotalPtDescuento              SIN_PAGOS_DET.PTDESCUENTO%TYPE;

  -- Total de cuadre para Saldo en Moneda de transaccion.
  lnuTotalPago                     SIN_PAGOS_DET.IMPORTE%TYPE := 0;

  --fernavi - Identificar si el producto se contabiliza a una cuenta de personas en compa?ia 1000
  -- historia Cambios contabilizaci?n Productos Affinity- CXP
  lvaSnCuentaContable              DIC_ALIAS_RS.SNCUENTA_CONTABLE%TYPE;

  --Variable para identificar si de poliza de salud (ramos '090','091','085','183')
  lvaSnPolizaSalud                VARCHAR2(1)     := 'N';

  --linaduto - 2025/03/11 - HU756348 -Ajuste retenci?n en la fuente para ID NIT - subramos PCP y deudores
  lvaAplicaSinRetencion VARCHAR2(1) := 'N';
  
  -- luishure - 2025/12/10 - HU984785 - Exclusión de retención para Fondo de Ahorro
  lvaAplicaReservaSinRetencion VARCHAR2(1) := 'N';

  --Cursores para consultar la informacion

  -- Cursor base para el llenado de la Cabecera con el total de la CxP
  CURSOR lcuDatosCabecera IS
   SELECT s.CDRAMO, s.CDSUBRAMO,s.NPOLIZA, S.NCERTIFICADO, s.CDENTIDAD, s.DNI, NVL(s.CDMONEDA,0) CDMONEDA, s.FEPAGO,
          DECODE(S.CARGO_ABONO,'A','907','C','916','907') CDOPERACION,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(NVL(s.IMPIRPF,0))),2),
                 ROUND(ABS(SUM(NVL(s.IMPIRPF,0)))) ) impirpf,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(NVL(DEDUCIBLE,0))),2),
                 ROUND(ABS(SUM(NVL(DEDUCIBLE,0)))) ) deducible,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(NVL(s.PTDESCUENTO,0))),2),
                 ROUND(ABS(SUM(NVL(s.PTDESCUENTO,0)))) ) ptdescuento,
          MAX(s.PODESCUENTO) PODESCUENTO,
          MAX(s.numero_reserva) NUMERO_RESERVA
   FROM SIN_PAGOS_DET s
   WHERE s.EXPEDIENTE             = ivaNmExpediente
   AND s.NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   and s.numero_reserva <> 'P012100' --se eliminan las deducciones de primas
   GROUP BY s.CDRAMO, s.CDSUBRAMO, s.NPOLIZA, S.NCERTIFICADO,s.CDENTIDAD, s.DNI, NVL(s.CDMONEDA,0), s.FEPAGO,
            LPAD(REPLACE(TO_CHAR(RPAD(NVL(POIRPF,0),4,'0')),',',''),4,'0'),
            DECODE(S.CARGO_ABONO,'A','907','C','916','907'),
            EXPEDIENTE;

   -- Cursor base para el llenado con los datos del DOCUMENTO por cada tipo de reserva de Fondo de ahorro y Valores de Cesion
   -- 25/11/2024 josebuvi Adicion de parametro de garantia 														  
   CURSOR lcuDatosDocumentoFyC IS
   SELECT s.CDGARANTIA, dac.CDTIPO_RESERVA,NUMERO_RESERVA, NVL(POIRPF,0) POIRPF, S.CDRETENCION,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(s.IMPORTE - NVL(s.PTDESCUENTO,0))),2),
                 ROUND(ABS(SUM(s.IMPORTE - NVL(s.PTDESCUENTO,0)))) ) IMPORTE,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(NVL(S.IMPIRC,0))),2),
                 ROUND(ABS(SUM(NVL(S.IMPIRC,0)))) ) IMPIRC,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(NVL(IMPIRPF_RETENIDO,0))),2),
                 ROUND(ABS(SUM(NVL(IMPIRPF_RETENIDO,0)))) ) IMPIRPF_RETENIDO,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(NVL(IMPICA,0))),2),
                 ROUND(ABS(SUM(NVL(IMPICA,0)))) ) IMPICA,
          NVL(POIRC,0) POIRC, NVL(POIRPF_RETENIDO,0) POIRPF_RETENIDO, NVL(POICA,0) POICA,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(((IMPORTE*100)/(100+NVL(POIRPF,0))))),2),
                 ROUND(ABS(SUM(((IMPORTE*100)/(100+NVL(POIRPF,0)))))) ) BASEIMPUESTOS,
          --Con el cambio de retenciones desde SAP en la devuelta, Se incluye este campo en la consulta, para tener la base del IVA
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(NVL(s.IMPIRPF,0))),2),
                 ROUND(ABS(SUM(NVL(s.IMPIRPF,0)))) ) IMPIRPF,
          s.CDTRIBUTARIA/*, s.SNIVA*/
   FROM SIN_PAGOS_DET s, DIC_ALIAS_COBERTURAS dac
   WHERE EXPEDIENTE               = ivaNmExpediente
   AND   NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND   s.CDRAMO                 = dac.CDRAMO
   AND   s.CDSUBRAMO              = dac.CDSUBRAMO
   AND   s.CDGARANTIA             = dac.CDGARANTIA
   AND   s.CDSUBGARANTIA          = dac.CDSUBGARANTIA
   AND   NUMERO_RESERVA          IN ('P012091','P012081','P012093','P012096')
   GROUP BY s.CDGARANTIA, CDTIPO_RESERVA,NUMERO_RESERVA, NVL(POIRPF,0), S.CDRETENCION,NVL(POIRC,0), NVL(POIRPF_RETENIDO,0), NVL(POICA,0), /*ROUND(ABS(((IMPORTE*100)/(100+NVL(POIRPF,0))))),*/--Se cambia porque est? generando mas de un documento cuando no hay cambio de retenciones
            s.CDTRIBUTARIA/*, s.SNIVA*/,
            EXPEDIENTE;

   -- Cursor base para el llenado con los datos del DOCUMENTO por cada tipo de reserva Matem?tica o T?cnica
   -- 25/11/2024 josebuvi Adicion de parametro de garantia 
   CURSOR lcuDatosDocumentoRes IS
   SELECT s.CDGARANTIA, dac.CDTIPO_RESERVA, NVL(POIRPF,0) POIRPF, S.CDRETENCION,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(s.IMPORTE - NVL(s.PTDESCUENTO,0))),2),
                 ROUND(ABS(SUM(s.IMPORTE - NVL(s.PTDESCUENTO,0)))) ) IMPORTE,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(s.IMPORTE)),2),
                 ROUND(ABS(SUM(s.IMPORTE))) ) IMPORTE_SIN_DESC,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(NVL(S.IMPIRC,0))),2),
                 ROUND(ABS(SUM(NVL(S.IMPIRC,0)))) ) IMPIRC,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(NVL(IMPIRPF_RETENIDO,0))),2),
                 ROUND(ABS(SUM(NVL(IMPIRPF_RETENIDO,0)))) ) IMPIRPF_RETENIDO,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(NVL(IMPICA,0))),2),
                 ROUND(ABS(SUM(NVL(IMPICA,0)))) ) IMPICA,
          NVL(POIRC,0) POIRC, NVL(POIRPF_RETENIDO,0) POIRPF_RETENIDO, NVL(POICA,0) POICA,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(((IMPORTE*100)/(100+NVL(POIRPF,0))))),2),
                 ROUND(ABS(SUM(((IMPORTE*100)/(100+NVL(POIRPF,0)))))) ) BASEIMPUESTOS,
          --Con el cambio de retenciones desde SAP en la devuelta, Se incluye este campo en la consulta, para tener la base del IVA
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(SUM(NVL(s.IMPIRPF,0))),2),
                 ROUND(ABS(SUM(NVL(s.IMPIRPF,0)))) ) IMPIRPF,
          s.CDTRIBUTARIA/*, s.SNIVA*/
   FROM SIN_PAGOS_DET s , DIC_ALIAS_COBERTURAS dac
   WHERE EXPEDIENTE               = ivaNmExpediente
   AND   NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND   s.CDRAMO                 = dac.CDRAMO
   AND   s.CDSUBRAMO              = dac.CDSUBRAMO
   AND   s.CDGARANTIA             = dac.CDGARANTIA
   AND   s.CDSUBGARANTIA          = dac.CDSUBGARANTIA
   AND   NUMERO_RESERVA      NOT IN ('P012091','P012081','P012093','P012096')
   GROUP BY s.CDGARANTIA, CDTIPO_RESERVA, NVL(POIRPF,0), S.CDRETENCION,NVL(POIRC,0),
            NVL(POIRPF_RETENIDO,0), NVL(POICA,0),
            /*ROUND(ABS(((IMPORTE*100)/(100+NVL(POIRPF,0))))),*/
            s.CDTRIBUTARIA
            /*, s.SNIVA*/,
            EXPEDIENTE;
   -- 25/11/2024 josebuvi Adicion de parametro de garantia 
   CURSOR lcuDetalleSumadosDeducible(lvaCdGarantia SIN_PAGOS_DET.CDGARANTIA%TYPE) IS
   SELECT s.CDRAMO, s.CDSUBRAMO, s.CDGARANTIA, s.CDSUBGARANTIA,NUMERO_RESERVA, DNI,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(DEDUCIBLE),2),
                 ROUND(ABS(DEDUCIBLE)) ) DEDUCIBLE,DECODE(S.CARGO_ABONO,'A','907','C','916','907') CDOPERACION
   FROM SIN_PAGOS_DET s, DIC_ALIAS_COBERTURAS dac
   WHERE EXPEDIENTE               = ivaNmExpediente
   AND   NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND   s.CDRAMO                 = dac.CDRAMO
   AND   s.CDSUBRAMO              = dac.CDSUBRAMO
   AND   s.CDGARANTIA             = lvaCdGarantia											 
   AND   s.CDGARANTIA             = dac.CDGARANTIA
   AND   s.CDSUBGARANTIA          = dac.CDSUBGARANTIA
   AND   dac.CDTIPO_RESERVA       = lvaCdTipoReserva
   AND   s.DEDUCIBLE              <> 0
   AND   NVL(POIRPF,0)            = lvaPoIrpf
   AND   NVL(POIRC,0)             = lvaPoirc
   AND   NVL(POICA,0)             = lvaPoIca
   AND   CDRETENCION              = lvaCdRetencion;
  -- 25/11/2024 josebuvi se agrega argumento para obtener unicamente garantia														  
  CURSOR lcuDetalleSumadosDescuento(lvaCdGarantia SIN_PAGOS_DET.CDGARANTIA%TYPE) IS
   SELECT s.CDRAMO, s.CDSUBRAMO, s.CDGARANTIA, s.CDSUBGARANTIA, NUMERO_RESERVA,s.DNI,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(s.PTDESCUENTO),2),
                 ROUND(ABS(s.PTDESCUENTO)) ) PTDESCUENTO ,DECODE(S.CARGO_ABONO,'A','907','C','916','907') CDOPERACION
   FROM SIN_PAGOS_DET s, DIC_ALIAS_COBERTURAS dac
   WHERE EXPEDIENTE               = ivaNmExpediente
   AND   NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND   s.CDRAMO                 = dac.CDRAMO
   AND   s.CDSUBRAMO              = dac.CDSUBRAMO
   AND   s.CDGARANTIA             = lvaCdGarantia											 
   AND   s.CDGARANTIA             = dac.CDGARANTIA
   AND   s.CDSUBGARANTIA          = dac.CDSUBGARANTIA
   AND   dac.CDTIPO_RESERVA       = lvaCdTipoReserva
   AND   s.PTDESCUENTO           <> 0
   AND   NVL(POIRPF,0)            = lvaPoIrpf
   AND   NVL(POIRC,0)             = lvaPoirc
   AND   NVL(POICA,0)             = lvaPoIca
   AND   CDRETENCION              = lvaCdRetencion;

  -- 25/11/2024 josebuvi se agrega argumento para obtener unicamente garantia														  
  CURSOR lcuDetalleSumadosCoaseguro(lvaCdGarantia SIN_PAGOS_DET.CDGARANTIA%TYPE) IS
   SELECT s.CDRAMO, s.CDSUBRAMO, s.CDGARANTIA, s.CDSUBGARANTIA,NUMERO_RESERVA, s.DNI,
          DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS(s.IMPORTE)*(ctd.POREPARTO_COA/100),2),
                 ROUND(ABS(s.IMPORTE)*(ctd.POREPARTO_COA/100)) ) COASEGURO,
          ctd.CDCIA ,DECODE(S.CARGO_ABONO,'A','907','C','916','907') CDOPERACION
   FROM SIN_PAGOS_DET s, DIC_ALIAS_COBERTURAS dac, COA_TRATADO_DETALLE ctd, COA_TRATADO CT
   WHERE EXPEDIENTE               = ivaNmExpediente
   AND   NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND   s.CDRAMO                 = dac.CDRAMO
   AND   s.CDSUBRAMO              = dac.CDSUBRAMO
   AND   s.CDGARANTIA             = lvaCdGarantia												 
   AND   s.CDGARANTIA             = dac.CDGARANTIA
   AND   s.CDSUBGARANTIA          = dac.CDSUBGARANTIA
   AND   dac.CDTIPO_RESERVA       = lvaCdTipoReserva
   AND   NVL(POIRPF,0)            = lvaPoIrpf
   AND   NVL(POIRC,0)             = lvaPoirc
   AND   NVL(POICA,0)             = lvaPoIca
   AND   CDRETENCION              = lvaCdRetencion
   AND   CTD.NPOLIZA              = S.NPOLIZA
--   AND   ctd.CDCIA               <> '00000'
  AND   ctd.CDCIA            NOT IN ('00000','30000')
   AND   ldaFeOcurrencia    BETWEEN CTD.FEALTA
                                AND NVL(CTD.FEBAJA,SYSDATE)
   AND   CT.NPOLIZA               = S.NPOLIZA
   AND   ldaFeOcurrencia    BETWEEN CT.FEALTA
                                AND NVL(CT.FEBAJA,SYSDATE)
   AND   CDCOA                    = 'C';



  -- Cursor base para el llenado del detalle OBJ_SAP_DETALLE_CXP_SINI por cada tipo de reserva de Fondo de ahorro y Valores de Cesion
  CURSOR lcuDatosPagosFyC(lvaCdGarantia SIN_PAGOS_DET.CDGARANTIA%TYPE) IS
   SELECT CDRAMO, CDSUBRAMO, CDGARANTIA, CDSUBGARANTIA,
          DECODE(S.CARGO_ABONO,'A',DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS((s.IMPORTE * NVL((lnuPorepartoCoa/100),1)) + s.DEDUCIBLE),2),
                                          (ROUND(ABS((s.IMPORTE * NVL((lnuPorepartoCoa/100),1)) + s.DEDUCIBLE)))
                                         ),
                               'C',DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS((s.IMPORTE * NVL((lnuPorepartoCoa/100),1)) - s.DEDUCIBLE),2),
                                          (ROUND(ABS((s.IMPORTE * NVL((lnuPorepartoCoa/100),1)) - s.DEDUCIBLE)))
                                         )
                )IMPORTE,
          DNI,DECODE(S.CARGO_ABONO,'A','907','C','916','907') CDOPERACION, NUMERO_RESERVA
   FROM SIN_PAGOS_DET s/*, COA_TRATADO_DETALLE CTD*/
   WHERE EXPEDIENTE               = ivaNmExpediente
   AND   NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND   NUMERO_RESERVA           = lvaNumeroReserva
   AND   s.CDGARANTIA             = lvaCdGarantia											 
   AND   NVL(POIRPF,0)            = lvaPoIrpf
   AND   NVL(POIRC,0)             = lvaPoirc
   AND   NVL(POICA,0)             = lvaPoIca
   AND   CDRETENCION              = lvaCdRetencion
/*   AND   ctd.NPOLIZA    (+)       = s.NPOLIZA
   AND   ctd.CDCIA      (+)       = '00000'
   AND   ctd.CDABRIDORA (+)       = 'A'
   AND   ldaFeOcurrencia    BETWEEN FEALTA
                                AND NVL(FEBAJA,SYSDATE)*/;


  -- Cursor base para el llenado del detalle OBJ_SAP_DETALLE_CXP_SINI por cada tipo de reserva Matematica o T?cnica
  -- 25/11/2024 josebuvi se agrega argumento para obtener unicamente garantia
  CURSOR lcuDatosPagosRes(lvaCdGarantia SIN_PAGOS_DET.CDGARANTIA%TYPE) IS
   SELECT s.CDRAMO, s.CDSUBRAMO, s.CDGARANTIA, s.CDSUBGARANTIA,
          DECODE(S.CARGO_ABONO,'A',DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS((s.IMPORTE * NVL((lnuPorepartoCoa/100),1)) + s.DEDUCIBLE),2),
                                          (ROUND(ABS((s.IMPORTE * NVL((lnuPorepartoCoa/100),1)) + s.DEDUCIBLE)))
                                         ),
                               'C',DECODE(SUBSTR(EXPEDIENTE,6,1),3,ROUND(ABS((s.IMPORTE * NVL((lnuPorepartoCoa/100),1)) - s.DEDUCIBLE),2),
                                          (ROUND(ABS((s.IMPORTE * NVL((lnuPorepartoCoa/100),1)) - s.DEDUCIBLE)))
                                         )
                 ) IMPORTE,
          DNI, NUMERO_RESERVA,DECODE(S.CARGO_ABONO,'A','907','C','916','907') CDOPERACION
   FROM SIN_PAGOS_DET s, DIC_ALIAS_COBERTURAS dac/*, COA_TRATADO_DETALLE ctd*/
   WHERE EXPEDIENTE               = ivaNmExpediente
   AND   NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND   NUMERO_RESERVA      NOT IN ('P012091','P012081','P012093','P012096')
   AND   NVL(POIRPF,0)            = lvaPoIrpf
   AND   NVL(POIRC,0)             = lvaPoirc
   AND   NVL(POICA,0)             = lvaPoIca
   AND   CDRETENCION              = lvaCdRetencion
   AND   s.CDRAMO                 = dac.CDRAMO
   AND   s.CDSUBRAMO              = dac.CDSUBRAMO
   AND   s.CDGARANTIA             = lvaCdGarantia											 
   AND   s.CDGARANTIA             = dac.CDGARANTIA
   AND   s.CDSUBGARANTIA          = dac.CDSUBGARANTIA
   AND   dac.CDTIPO_RESERVA       = lvaCdTipoReserva
/*   AND   CTD.NPOLIZA    (+)       = S.NPOLIZA
   AND   ctd.CDCIA      (+)       = '00000'
   AND   ctd.CDABRIDORA (+)       = 'A'
   AND   ldaFeOcurrencia    BETWEEN FEALTA
                                AND NVL(FEBAJA,SYSDATE)*/;

 CURSOR lcuDatosCaja IS
  SELECT NVL(FEPOSIBLE_PAGO,P.FECHA_PAGO), CDVIAPAGO, CDBLOQUEOPAGO, CDPAISBANCO, CDBANCO, NMCUENTA,
         PCK_SIC_SAP.FN_SIC_MAPEO_TIPO_CUENTA(CDTIPOCUENTA) CDTIPOCUENTA,
         CDSUCURSALBANCO, SUBSTR(DSTITULAR,1,60) DSTITULAR, p.CODIGO_ACEPTACION
  FROM PAGOS p
  WHERE p.EXPEDIENTE        = ivaNmExpediente
  AND p.NMPAGO_AUTORIZACION = ivaNmPagoAutorizacion;

  CURSOR lcuDatosSiniestro IS
   SELECT TO_DATE(TO_CHAR(FECHA_SINIESTRO,'DDMMYYYY'),'DDMMYYYY'), TO_DATE(TO_CHAR(s.FECHA_NOTIFICACION,'DDMMYYYY'),'DDMMYYYY')
   FROM SINIESTROS S
   WHERE EXPEDIENTE = ivaNmExpediente;

  CURSOR lcuDatosFactura IS
   SELECT NMFACTURA, NMPREFIJO, PTVALOR_FACTURA
   FROM SIN_FACTURAS
   WHERE NMEXPEDIENTE      = ivaNmExpediente
   AND NMPAGO_AUTORIZACION = ivaNmPagoAutorizacion;

  CURSOR lcuAsegurado IS
   SELECT p.DNI
   FROM PERSONAS_PROD pp, PERSONAS p
   WHERE pp.NPOLIZA    = lvaNmPoliza
   AND pp.NCERTIFICADO = lvaNmCertificado
   AND pp.DNI          = p.DNI
   AND pp.CODIGO      IN ('020','120');

  CURSOR lcuDatosPoliza IS
   SELECT C.CDAGENTE, c.CDDELEGACION_RADICA, c.FEFECTO, c.FEFECTO_ANUALIDAD
   FROM CUERPOLIZA c
   WHERE c.NPOLIZA = lvaNmPoliza;

  CURSOR lcuTipoReserva IS
   SELECT D.CDTIPO_RESERVA,
          DECODE(NVL(D.SNTERREMOTO,'N'),'S',D.CDRAMO_CONTABLE,d.CDRAMO_HOST) CDRAMO_HOST
   FROM DIC_ALIAS_COBERTURAS D
   WHERE D.CDRAMO       = lvaCdRamo
   AND D.CDSUBRAMO      = lvaCdSubRamo
   AND d.CDGARANTIA     = lvaCdGarantia
   AND d.CDSUBGARANTIA  = lvaCdSubGarantia;

  CURSOR lcuMunicipioIca IS
   SELECT a.CDMUNICIPIO
   FROM AGE_DELEGACIONES a
   WHERE a.CDDELEGACION = lvaCdOficinaRegistro;

  CURSOR lcuSnBancaseguros IS
   SELECT SNBANCASEGUROS
   FROM DIC_ALIAS_RS
   WHERE CDRAMO  = lvaCdRamo
   AND CDSUBRAMO = lvaCdSubRamo;

  CURSOR lcuCdUsuario IS
   SELECT CODIGO_USUARIO
   FROM HISTORICO
   WHERE EXPEDIENTE             = ivaNmExpediente
   AND NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion;

  CURSOR lcuDsLoginUsuario IS
   SELECT UPPER(DSLOGIN)
   FROM USUARIOS_1
   WHERE CDN_EMPLE = lvaCdUsuario;

  CURSOR lcuPoBaseRetencion IS
   SELECT NVL(PORETENCION,0) PORETENCION
   FROM SIN_RETENCIONES
   WHERE CDRETENCION         = '9999'
   AND TRUNC(ldaFePago) BETWEEN TRUNC(FEALTA)
                            AND TRUNC(NVL(FEBAJA, ldaFePago +365))
   AND CDTIPO_RETENCION       = 'I';

  CURSOR lcuPoRetencion IS
   SELECT NVL(PORETENCION,0)
   FROM SIN_RETENCIONES
   WHERE CDRETENCION            = lvaCdRetencion
   AND ldaFePago          BETWEEN fealta
                              AND NVL(febaja,ldaFePago)
   AND CDTIPO_RETENCION         = 'I';

  CURSOR lcuSnIva IS
   SELECT SNIVA
   FROM SIN_PAGOS_DET
   WHERE EXPEDIENTE               = ivaNmExpediente
   AND   NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
   AND   SNIVA                    = 'S';

  CURSOR lcuCiaCoaseguradora IS
   SELECT CIF
   FROM COMPANIAS
   WHERE CDCIA = lvaCdCiaCoaseguradora;

  CURSOR lcuSoloSuraCoaseguro IS
   SELECT CDCLASE
   FROM SIN_CLASES_HISTORICO
   WHERE EXPEDIENTE = ivaNmExpediente
   AND cdclase      = '01';

  CURSOR lcuPorcentajeCoaseguro IS
   SELECT POREPARTO_COA
   FROM COA_TRATADO_DETALLE
   WHERE NPOLIZA               = lvaNmPoliza
--   AND   CDCIA                 = '00000'
   AND   CDCIA            IN ('00000','30000')
   AND   CDABRIDORA            = 'A'
   AND   ldaFeOcurrencia BETWEEN FEALTA
                             AND NVL(FEBAJA,SYSDATE);
  -- Se omite gastos del proceso jur?dico de acuerdo a solicitud de Jose Libardo Cruz con CA 120293
  --20140728 Por historia de usuario 77550 solicitada por Mario Franco, ya no se lleva obligado por Caja la pretenci?n objetivada.

  --CURSOR lcuSNPagoJuridico IS
  -- SELECT 'S'
  -- FROM SIN_PAGOS_DET
  -- WHERE EXPEDIENTE               = ivaNmExpediente
  -- AND   NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion
  -- AND   NUMERO_RESERVA          IN ('P010000','P010002','P010003'/*,'P012086'*/);
  -- Fin de 20140728 Por historia de usuario 77550 solicitada por Mario Franco, ya no se lleva obligado por Caja la pretenci?n objetivada.

  -- Panam?.  Para identificar el tipo de producto de acuerdo a la vigencia Si el siniestro est? en la priver vigencia
  --          para adicionar un 1 de lo contrario se adiciona una R
  CURSOR lcuPrimerVigencia IS
   SELECT 'S'
   FROM CUERPOLIZA cp, SINIESTROS s
   WHERE cp.NPOLIZA = s.POLIZA
   AND s.FECHA_SINIESTRO BETWEEN cp.NUEVA_FEFECTO AND ADD_MONTHS(cp.NUEVA_FEFECTO, 12)
   AND s.EXPEDIENTE = ivaNmExpediente;

  -- Panam?.  Se lee el tipo de producto por si es Tradicional o Universal.
  CURSOR lcuGrupoProducto IS
   SELECT CDGRUPO_PRODUCTO
   FROM DIC_ALIAS_RS
   WHERE CDRAMO  = lvaCdRamo
   AND CDSUBRAMO = lvaCdSubRamo;

  -- Panam?. Se lee el tipo de cobertura para determimar si la cobertura pertenece a Bancario, Fidelidad, o Construccion
  CURSOR lcuGrupoCobertura IS
   SELECT CDGRUPO_COBERTURA
   FROM DIC_ALIAS_COBERTURAS
   WHERE CDRAMO      = lvaCdRamo
   AND CDSUBRAMO     = lvaCdSubRamo
   AND CDGARANTIA    = lvaCdGarantia
   AND CDSUBGARANTIA = lvaCdSubGarantia;

  -- Panam?. Se lee Si es Proveedor de personas
  CURSOR lcuProveedor IS
   SELECT 'S'
   FROM PERSONAS
   WHERE DNI       = lvaDni
   AND SNPROVEEDOR = 'S';

  -- Panam?. Se El digito de verificacion
  CURSOR lcuDigitoVerificacion IS
   SELECT NMDIGITO_VER
   FROM PERSONAS
   WHERE DNI       = lvaDni;

  -- Panam?.  Tipo de Coaseguro para detectar cuando es Aceptado
  CURSOR lcuTipoCoaseguro IS
   SELECT CDCOA
   FROM COA_TRATADO
   WHERE NPOLIZA               = lvaNmPoliza
   AND   ldaFeOcurrencia BETWEEN FEALTA
                             AND NVL(FEBAJA,SYSDATE);

  -- fernsavi CURSOR PARA IDENTIFICAR SI EL PRODUCTO (RAMOCONTABLE) CONTABILIZA A CUENTA DE
  -- PERSONAS EN LA SOCIEDAD 1000
  CURSOR lcuSnCuentaContable IS
   SELECT NVL(D.SNCUENTA_CONTABLE,'N')
   FROM DIC_ALIAS_RS D
   WHERE D.CDRAMO = lvaCdramoContable
   AND D.CDSUBRAMO = lvaCdSubramo;

   --JuanAlNo Cursor temporal para obtener los datos de las garantias desde el detalle de los pagos, Asi validar condicion
   --unicamente para planes que no pagan copagos y coutas moderadores
   CURSOR lcuDatosTempGarantia IS
   SELECT CDGARANTIA, CDSUBGARANTIA 
   FROM SIN_PAGOS_DET 
	WHERE EXPEDIENTE = ivaNmExpediente 
	AND NUMERO_PAGO_AUTORIZACION = ivaNmPagoAutorizacion;

  BEGIN

  --Datos generales del mensaje que necesita Surabroker ...
  --Parametrizables
  lvaMensajeTecnico            := 'Valores Iniciales';
  lobjTyinf.CDCONSUMIDOR       := 'SINIESTROS';
  lobjTyinf.CDSERVICIO         := 'SiniestrosCxP';
  lobjTyinf.CDOPERACION        := 'SI_os_WS_SiniestrosCxP';
  --lobjTyinf.CDTOKEN          := ''; hasta donde s?, no aplica
  lobjTyinf.CDVERSION_SERVICIO := '1.0';
  lobjTyinf.DSNAME_SPACE       := NULL;
  lobjTyinf.DSPUERTO           := 'HTTP_Port';

  --No Parametrizables
  lobjTyinf.DSCLAVE            := ivaNmPagoAutorizacion;
  lobjTyinf.FECREACION         := SYSDATE;
  lobjTyinf.NMPRIORIDAD        := NULL;

  SP_USUARIO (lvaDsUsuario, lvaDsClave, lvaMensajeTecnicoExt, lvaMensajeUsuarioExt);

  ltyEncabezadoMens            := TAB_SBK_ENC_MENSAJE(OBJ_SBK_ENC_MENSAJE( PCK_SBK_SURABROKER.HEADER_BASIC_AUTH_USER,lvaDsUsuario));
  ltyEncabezadoMens.EXTEND;
  ltyEncabezadoMens(2)         := OBJ_SBK_ENC_MENSAJE( PCK_SBK_SURABROKER.HEADER_BASIC_AUTH_PASSWORD,lvaDsClave);
  lobjTyinf.TYENCABEZADOS      := ltyEncabezadoMens;
----------------------------------------------------------------------------------------------------------------------
  --Datos de la cabecera de la Cuenta por pagar
  FOR cab IN lcuDatosCabecera LOOP
   lvaCdRamo    := cab.CDRAMO;
   lvaCdSubRamo := cab.CDSUBRAMO;
   lvaDni       := cab.DNI;
   ldaFePago    := cab.FEPAGO;
   lvaNmPoliza  := cab.NPOLIZA;
   lnuPoDescuento := cab.PODESCUENTO;

   IF cab.NUMERO_RESERVA = 'PSUSALUD' THEN
     lvaSnPolizaSalud := 'S';
   END IF;

   -- Panama Fecha para coaseguro Aceptado
   OPEN lcuDatosSiniestro;
   FETCH lcuDatosSiniestro INTO ldaFeOcurrencia, ldaFenotificacion;
   CLOSE lcuDatosSiniestro;

   --Panam?. Digito de verificaci?n
   OPEN lcuDigitoVerificacion;
   FETCH lcuDigitoVerificacion INTO lvaDigitoVerificacion;
   CLOSE lcuDigitoVerificacion;

   --Datos de conversi?n que solicita SAP
   lobjDatosConversion.cdFuente       := 'SIN';
   lobjDatosConversion.nmAplicacion   := '79';

   -- SE MODIFICA CURSOR PARA EVITAR HACER UNO NUEVO A DIC_ALIAS_RS
   OPEN lcuSnBancaseguros;
   FETCH lcuSnBancaseguros INTO lvaSnBancaseguros;
   CLOSE lcuSnBancaseguros;
   IF lvaSnBancaseguros = 'S' THEN
    lobjDatosConversion.cdCanal := 'BAN';
   ELSE
    lobjDatosConversion.cdCanal := 'SEG';
   END IF;

   --Datos del usuario que hace el pago
   OPEN lcuCdUsuario;
   FETCH lcuCdUsuario INTO lvaCdUsuario;
   CLOSE lcuCdUsuario;

   IF translate(lvaCdUsuario,'T 0123456789-+.','T') IS NULL THEN
    OPEN lcuDsLoginUsuario;
    FETCH lcuDsLoginUsuario INTO lvaDsLoginUsuario;
    CLOSE lcuDsLoginUsuario;
   END IF;

   lobjCabecera.datosConversionOrigen := lobjDatosConversion;


   PCK_GESTION_PRODUCTOS.SPGET_COMPANIA_PRODUCTO( cab.cdramo,cab.cdsubramo,lvaCdCompania,lvaCdciaMatriz,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);
   lobjCabecera.feFactura             := cab.FEPAGO;
   lobjCabecera.cdCompania            := lvaCdCompania;
   lobjCabecera.feRegistroSap         := cab.FEPAGO;
   lobjCabecera.nmPeriodo             := TO_CHAR(cab.FEPAGO,'MM');

   -- Todos los pagos de Sura se hacen en moneda pesos
   -- Panama.  la moneda base es 20
   IF lvaCdCompania IN ('01','02') THEN
    lobjCabecera.cdMoneda    := '0';
   ELSE
    IF lvaCdciaMatriz = '30' THEN
     lobjCabecera.cdMoneda   := '20';
     lobjCabecera.cdCompania := lvaCdciaMatriz;
    ELSE
     lobjCabecera.cdMoneda := cab.cdMoneda;
    END IF;
   END IF;

   lobjCabecera.ptTasaCambio          := NULL;
   lobjCabecera.feTasaCambio          := NULL;

   -- Para la referencia (dsFacturaOrdenPago) se toman la 8 primeras de la factura - las 7 primeras de la orden de pago
   OPEN lcuDatosFactura;
   FETCH lcuDatosFactura INTO lvaNmFactura,lvaNmPrefijo,lnuVlrFactura;
   CLOSE lcuDatosFactura;

   lobjCabecera.nmOrdenPago           := ivaNmPagoAutorizacion;
   IF LENGTH(TRIM(lvaNmPrefijo)) > 9 THEN
      lvaNmPrefijo                    := SUBSTR(lvaNmPrefijo,(LENGTH(TRIM(lvaNmPrefijo))-8));
   END IF;
   IF TRIM(lvaNmPrefijo) IS NOT NULL THEN
      lobjCabecera.nmFactura          := lvaNmPrefijo ||'-'||lvaNmFactura;
   ELSE
      lobjCabecera.nmFactura          := lvaNmFactura;
   END IF;

   lvaSnCalcularImpuestos             := 'S';

   OPEN lcuDatosCaja;
   FETCH lcuDatosCaja INTO lvaFeposiblePago, lvaCdViaPago, lvaCdbloqueoPago,
                           lvaCdPaisBanco, lvaCdBanco, lvaNmCuenta, cdTipoCuenta,
                           lvaCdSucursalBanco, lvaDsTitular, lvaCodigoAceptacion;
   CLOSE lcuDatosCaja;
   -- Datos pago caja Sura
    lvaSnPagoCajaSura   := NVL(PCK_PARAMETROS.FN_GET_PARAMETROV2(lvaCdRamo,
                                                                 lvaCdSubRamo,
                                                                 'PAGOCAJASURA',
                                                                 SYSDATE,
                                                                 lvaNmPoliza,
                                                                 '%',
                                                                 '%',
                                                                 '%',
                                                                 '%'),
                                'N');

   IF lvaCdViaPago = 'CP' THEN
    lvaCdbloqueoPago := 'F';
    lvaCdViaPago     := 'CA';
   END IF;

   --Panam?.  Cuando para panam? se est? manejando GE, este par?metro va a venir en la tabla pagos
   IF lvaCdViaPago = 'IO' THEN
    lvaCdViaPago     := 'CA';
   END IF;
   --Fin Panam?

   IF lvaCdViaPago = 'CA' AND lvaSnPagoCajaSura = 'S' THEN
    lvaCdViaPago     := '2';
   END IF;

   -- Datos de la cuenta
   lobjCuentaBancaria.cdPaisBanco     := lvaCdPaisBanco;
   lobjCuentaBancaria.cdBanco         := lvaCdBanco;
   lobjCuentaBancaria.nmCuenta        := lvaNmCuenta;
   lobjCuentaBancaria.cdTipoCuenta    := cdTipoCuenta;
   lobjCuentaBancaria.dsTitular       := lvaDsTitular;

   lvaNmExpediente                    := ivaNmExpediente;
   lvaNmCertificado                   := cab.NCERTIFICADO;
   lobjCondicionPago.cdCondicionPago  := '0001';

   IF lvaSnPolizaSalud = 'S' THEN
     lobjCondicionPago.poDescuento      := lnuPoDescuento;
     lobjCondicionPago.nmDias           := PCK_GWB_ENVIO_SNTROS.FN_DIAS_PRONTO_PAGO(ivaNmPagoAutorizacion,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);

     IF lobjCondicionPago.nmDias > 0 THEN
       lobjCondicionPago.cdCondicionPago  := '0025';
     END IF;
   END IF;

   lvaDsTextoPosicion                 := 'AUTORIZACIONES SINIESTROS';
   -- calcular la operacion segun el neto del pago
   lvaCdOperacion                     := cab.CDOPERACION;
   lvaNmBeneficiarioPago              := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(cab.DNI);
   lvaCdOficinaRegistro               := cab.CDENTIDAD;
   lvaCdRamo                          := cab.CDRAMO;
   lnuIvaDescontable                  := cab.IMPIRPF;
   lnuDeducible                       := cab.DEDUCIBLE;
   lnuPtDescuento                     := cab.PTDESCUENTO;

   --Solicitud de German Duque 8000030708  CONTROL CAMBIO BANCASEGUROS RAMO-SUBRAMO, Componente BC-aba-FI

   --linaduto - 2025/03/11 - HU756348 -Ajuste retenci?n en la fuente para ID NIT - subramos PCP y deudores
   lvaAplicaSinRetencion := NVL(PCK_PARAMETROS.FN_GET_PARAMETROV2(lvaCdRamo,
                                                                 lvaCdSubRamo,
                                                                 'APLICASINRETEN',
                                                                 SYSDATE,
                                                                 '%',
                                                                 '%',
                                                                 '%',
                                                                 '%',
                                                                 '%'),
                                'N');

  END LOOP; --lcuDatosCabecera
--Fin de CABECERA
----------------------------------------------------------------------------------------------------------------------
-- Cursores de Documentos


  FOR doc IN lcuDatosDocumentoFyC LOOP
   INSERT INTO T999_INCONSISTENCIAS (cdramo, cdsubramo, nmnegocio, feingreso, dsparametros, dsmensaje_tecnico, cdaplicacion)
        VALUES ('', '', '', SYSDATE, 'FOR lcuDatosDocumentoFyC ', '', 'TRAZA_RETENCION_083');
   lvaCodIva                          := LPAD(REPLACE(TO_CHAR(RPAD(DOC.POIRPF,4,'0')),'.',''),4,'0');
   -- 8/10/2025. HT918841 - Códigos de retención específicos. luishure 
   IF lvaCodIva = '1900' AND PCK_PARAMETROS.FN_GET_PARAMETROV2('%','%','GET_INDICADOR',SYSDATE, DOC.CDRETENCION ,'*','*','*','*') IS NOT NULL THEN
     lvaCodIva                        := PCK_PARAMETROS.FN_GET_PARAMETROV2('%','%','GET_INDICADOR',SYSDATE, DOC.CDRETENCION ,'*','*','*','*');
   END IF;
   lvaNumeroReserva                   := doc.NUMERO_RESERVA;
   lvaPoIrpf                          := doc.POIRPF;
   lvaPoirc                           := doc.POIRC;
   lvaPoIca                           := doc.POICA;
   lvaCdRetencion                     := doc.CDRETENCION;
   lvaCdTipoReserva                   := doc.CDTIPO_RESERVA;

   lnuContadorDocumentos              := lnuContadorDocumentos + 1;
   lobjDocumento                      := OBJ_SAP_DOCUMENTO_CXP_SINI();
   lobjDocumento.cdOficinaRegistro    := lvaCdOficinaRegistro;
   lobjDocumento.ptImporte            := doc.importe;
   lobjDocumento.snCalcularImpuestos  := lvaSnCalcularImpuestos;
   lobjDocumento.cdIva                := NULL;--lvaCodIva;
   lobjDocumento.fePosiblePago        := lvaFeposiblePago;

   lobjDocumento.condicionPago        := lobjCondicionPago;

   lobjDocumento.cdTipoIdentificacion := PCK_SIC_UTILITARIOS_I.FN_SIC_CDTIPO_IDENTIFICACION(lvaDni);

   -- 17/07/2025 Mateo Zapata - Homologacion de tipo de documento TT para SAP
   IF UPPER(lobjDocumento.cdTipoIdentificacion) = 'TT' THEN
     lobjDocumento.cdTipoIdentificacion := 'PT';
   END IF;

   lobjDocumento.nmBeneficiarioPago   := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(lvaDni);
   --Panama. Digito de verificacion
   IF lvaCdciaMatriz = '30' THEN
    IF lvaDigitoVerificacion IS NOT NULL THEN
--SAP va a poner el d?gito de verificaci?n.
NULL;
--     lobjDocumento.nmBeneficiarioPago := lobjDocumento.nmBeneficiarioPago||':'||lvaDigitoVerificacion;
    END IF;
   END IF;

   lobjDocumento.cdViaPago            := lvaCdViaPago;
   lobjDocumento.cdBloqueoPago        := lvaCdbloqueoPago;
   lobjDocumento.dsTextoPosicion      := lvaDsTextoPosicion;
   lobjDocumento.nmPoliza             := lvaNmPoliza;
   lobjDocumento.cdRamo               := lvaCdRamo;
   lobjDocumento.cdOperacion          := lvaCdOperacion;
   lobjDocumento.cdTipoReserva        := doc.CDTIPO_RESERVA;
   -- Para atender la solicitud de catatalogo de servicio nro. 71527 de 02/04/2013 09:17:02 por Luis Gmo. Freyre
   IF lvaCdciaMatriz = '00' THEN
    IF doc.CDTRIBUTARIA = 'N' AND doc.CDRETENCION NOT IN ('0029','0028') THEN
     lobjDocumento.cdOperacion := lobjDocumento.cdOperacion||'P';
    END IF;
   ELSIF lvaCdciaMatriz = '30' THEN
   -- Panam? En la coexistencia, no se pregunta por reembolso.  Solo se lee de personas si es proveedor
--    IF doc.CDTRIBUTARIA = 'N' THEN
     OPEN lcuProveedor;
     FETCH lcuProveedor INTO lvaSnProveedorPanama;
     IF lcuProveedor%FOUND THEN
      lobjDocumento.cdOperacion := lobjDocumento.cdOperacion||'P';
     END IF;
     CLOSE lcuProveedor;
--    END IF;
   END IF;
    -- lobjDocumento.cdTipoReserva: Inicialmente ten?a NULL por requerimiento de las pruevas, con el mensaje: Va en null porque no aplica el tipo de reserva para Fondo y Cesion
    -- En correo de German Duque de Lunes 2010/1/18 07:50 a.m. Se informa que debe ir de acuerdo a lo que arroge el Cursor que debe ser (M)

   --Llenado de la tabla de Retenciones.
   -- Panam?. no se llevan las retenciones
   IF lvaCdciaMatriz = '00' THEN
    lvaCdRetencion                     := doc.CDRETENCION;
    lnuImpIrc                          := doc.IMPIRC;
    lnuImpIrpfRetenido                 := doc.IMPIRPF_RETENIDO;
    lnuImpIca                          := doc.IMPICA;

    lnuContadorRetencion               := 0;
    lobjRetenciones                    := TAB_SAP_DATOS_RETENCIONES(OBJ_SAP_DATO_RETENCION());
--Con el cambio de retenciones, en el legacy se llevan a cero y es SAP quien las calcula
--Se comenta como estaba anteriomente y se llevan solo si hay c?digo de retencion
--   IF NVL(lnuImpIrc,0) <> 0 THEN
    IF NVL(lvaCdRetencion,0) NOT IN ('0099','0000')  THEN
     lnuContadorRetencion                := lnuContadorRetencion + 1;
     lobjRetencion.cdtipoRetencion       := lvaCdRetencion;
     lobjRetencion.cdindicadorRetencion  := 'R';
     lobjRetencion.ptBaseRetencion       := doc.BASEIMPUESTOS;
     lobjRetencion.ptRetencion           := doc.IMPIRC;

     IF lnuContadorRetencion = 1 THEN
      lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
     ELSE
      lobjRetenciones.Extend;
      lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
     END IF;
    END IF;

--Con el cambio de retenciones, en el legacy se llevan a cero y es SAP quien las calcula
--Se comenta como estaba anteriomente y se llevan solo si hay c?digo de retencion
--      IF NVL(lnuImpIrpfRetenido,0) <> 0 THEN
    IF NVL(lvaCdRetencion,0) NOT IN ('0099','0000')  THEN
--   IF NVL(lnuImpIrpfRetenido,0) <> 0 THEN
     lnuContadorRetencion                := lnuContadorRetencion + 1;
     lobjRetencion.cdtipoRetencion       := lvaCdRetencion;
     lobjRetencion.cdindicadorRetencion  := 'I';
     --Se comenta esta l?nea por el cambio de calculo de retenci?n desde SAP y avisado desde la devuelta.
     --para la base se env?a el valor del IVA doc.IMPIRPF y no la base de toda la retenci?n como se ten?a acostumbrado.
     --    lobjRetencion.ptBaseRetencion       := doc.BASEIMPUESTOS;
     lobjRetencion.ptBaseRetencion       := doc.IMPIRPF;
     lobjRetencion.ptRetencion           := doc.IMPIRPF_RETENIDO;

     IF lnuContadorRetencion = 1 THEN
      lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
     ELSE
      lobjRetenciones.Extend;
      lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
     END IF;
    END IF;

    -- Retencion de IVA R?gimen Simplificado
    -- Por requerimiento de Fredy Rios enviado el Martes 2010/2/23 01:47 p.m.
    -- se elimina el regimen simplificado para los ramos de personas.
    IF lvaCdCompania IN ('01') THEN
     OPEN lcuSnIva;
     FETCH lcuSnIva INTO lvaSnIva;
     IF lcuSnIva%NOTFOUND THEN
      lvaSnIva := 'N';
     END IF;
     CLOSE lcuSnIva;
     IF NVL(lnuImpIrpfRetenido,0) = 0 AND lvaSnIva = 'N' AND doc.CDTRIBUTARIA = 'N'
        AND pck_sic_utilitarios.fn_sic_naturaleza_dni(lobjDocumento.cdTipoIdentificacion) <> 'JJURIDICO' THEN
      lnuPoBaseRetencion                  := 0;
      OPEN lcuPoBaseRetencion;
      FETCH lcuPoBaseRetencion INTO lnuPoBaseRetencion;
      CLOSE lcuPoBaseRetencion;

      lnuPoRetencion                      := 0;
      OPEN lcuPoRetencion;
      FETCH lcuPoRetencion INTO lnuPoRetencion;
      CLOSE lcuPoRetencion;

      --En el cambio del c?lculo de retenciones, el reteIVA regimen simplificado se calcula y se env?a a SAP calculado
      lnuReteIvaSimplificado              := doc.BASEIMPUESTOS * ((lnuPoRetencion*lnuPoBaseRetencion)/100);
      IF lnuReteIvaSimplificado <> 0 THEN
       lnuContadorRetencion                := lnuContadorRetencion + 1;
       lobjRetencion.cdtipoRetencion       := lvaCdRetencion;
       lobjRetencion.cdindicadorRetencion  := 'S';
       lobjRetencion.ptBaseRetencion       := doc.BASEIMPUESTOS;
       lobjRetencion.ptRetencion           := lnuReteIvaSimplificado;

       IF lnuContadorRetencion = 1 THEN
        lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
       ELSE
        lobjRetenciones.Extend;
        lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
       END IF;
      END IF;
     END IF;
    END IF;

--Con el cambio de retenciones, en el legacy se llevan a cero y es SAP quien las calcula
--Se comenta como estaba anteriomente y se llevan solo si hay c?digo de retencion
--   IF NVL(lnuImpIca,0) <> 0 THEN
    IF NVL(lvaCdRetencion,0) NOT IN ('0099','0000')  THEN
     OPEN lcuMunicipioIca;
     FETCH lcuMunicipioIca INTO lvaMunicipioIca;
     CLOSE lcuMunicipioIca;
     lnuContadorRetencion                := lnuContadorRetencion + 1;
     lobjRetencion.cdtipoRetencion       := lvaCdRetencion;
     lobjRetencion.cdindicadorRetencion  := lvaMunicipioIca;
     lobjRetencion.ptBaseRetencion       := doc.BASEIMPUESTOS;
     lobjRetencion.ptRetencion           := doc.IMPICA;

     IF lnuContadorRetencion = 1 THEN
      lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
     ELSE
      lobjRetenciones.Extend;
      lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
     END IF;
    END IF;

    lobjDocumento.retenciones        := lobjRetenciones;
   END IF;

   IF doc.NUMERO_RESERVA = 'P012091' THEN
   lvaCdConcepto  := '11';
   ELSIF doc.NUMERO_RESERVA = 'P012081' THEN
    lvaCdConcepto  := '5';
   ELSIF doc.NUMERO_RESERVA = 'P012093' THEN
    lvaCdConcepto  := '7';
   ELSIF doc.NUMERO_RESERVA = 'P012096' THEN
    lvaCdConcepto  := '3';
   END IF;

   -- Panama para Salvantos y Subrogaciones
   IF lvaCodigoAceptacion = 'D' THEN
    lvaCdConcepto  := '12';
   ELSIF lvaCodigoAceptacion = 'S' THEN
    lvaCdConcepto  := '10';
   END IF;

   lobjDocumento.cdConcepto := lvaCdConcepto;

  --Llenado de la tabla de Detalles para tipo de reserva de Fondo de ahorro y Valores de Cesion.
   lnuContadorDetalle := 0;
   lobjTabDetalles := tab_sap_detalles_cxp_sini(obj_sap_detalle_cxp_sini());

   OPEN lcuDatosSiniestro;
   FETCH lcuDatosSiniestro INTO ldaFeOcurrencia, ldaFenotificacion;
   CLOSE lcuDatosSiniestro;

   lnuPorepartoCoa := 100;
   OPEN lcuSoloSuraCoaseguro;
   FETCH lcuSoloSuraCoaseguro INTO lvaIdSoloSura;
   IF lcuSoloSuraCoaseguro%FOUND THEN
    lnuPorepartoCoa := 100;
   ELSE
    OPEN lcuPorcentajeCoaseguro;
    FETCH lcuPorcentajeCoaseguro INTO lnuPorepartoCoa;
    IF lcuPorcentajeCoaseguro%NOTFOUND THEN
     lnuPorepartoCoa := 100;
    END IF;
    CLOSE lcuPorcentajeCoaseguro;
   END IF;
   CLOSE lcuSoloSuraCoaseguro;


   FOR reg IN lcuDatosPagosFyC(doc.CDGARANTIA) LOOP

    lvaCdRamo                       := reg.CDRAMO;
    lvaCdSubramo                    := reg.CDSUBRAMO;
    lvaCdGarantia                   := reg.CDGARANTIA;
    lvaCdSubGarantia                := reg.CDSUBGARANTIA;
    INSERT INTO T999_INCONSISTENCIAS (cdramo, cdsubramo, nmnegocio, feingreso, dsparametros, dsmensaje_tecnico, cdaplicacion)
        VALUES ('', '', '', SYSDATE, 'FOR lcuDatosPagosFyC lvaCdRamo '||lvaCdRamo||' lvaCdSubramo '
        ||lvaCdSubramo||' lvaCdGarantia '||lvaCdGarantia||' lvaCdSubGarantia '||lvaCdSubGarantia||' ', '', 'TRAZA_RETENCION_083');

    lobjDetalle.cdIndicadorImpuesto := lvaCodIva;
    lvaAplicaReservaSinRetencion    := NVL(PCK_PARAMETROS.FN_GET_PARAMETROV2('%',
                                                                             '%',
                                                                             'RESERVASINRETEN',
                                                                             SYSDATE,
                                                                             reg.NUMERO_RESERVA,
                                                                             '%',
                                                                             '%',
                                                                             '%',
                                                                             '%'), 'N');
    -- 01/12/2024 josebuvi VERIFICACION DE VIDA PARA INDICADOR IMPUESTO
    -- luishure - 2025/12/10 - HU984785 - Exclusión de retención para Fondo de Ahorro
    IF lvaCdRamo = '083' AND lvaCdGarantia = 'VID' AND lvaAplicaReservaSinRetencion = 'N' THEN
      IF (lvaAplicaSinRetencion = 'N' OR (lvaAplicaSinRetencion = 'S' AND substr(lvaDni,1,1) <> 'A')) THEN 
        lnuContadorRetencionVida             := lnuContadorRetencionVida + 1;
        IF lnuContadorRetencionVida = 1 THEN
          lnuContadorRetencion               := lnuContadorRetencion + 1;
        lobjRetencion.cdtipoRetencion      := 'F5';
        lobjRetencion.cdindicadorRetencion := 'VI';
        IF lnuContadorRetencion = 1 THEN
        lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
        ELSE
        lobjRetenciones.Extend;
        lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
        END IF;
        lobjDocumento.retenciones := lobjRetenciones;
        END IF;	  
      END IF;
    END IF;
    lvaSnCuentaContable             := 'N';

    OPEN lcuTipoReserva;
    FETCH lcuTipoReserva INTO lvaCdTipoReserva,lvaCdramoContable;
    CLOSE lcuTipoReserva;

    lnuContadorDetalle              := lnuContadorDetalle + 1;
    lobjDetalle.cdTipoReserva       := lvaCdTipoReserva;

    OPEN lcuSnCuentaContable;
    FETCH lcuSnCuentaContable INTO lvaSnCuentaContable;
    CLOSE lcuSnCuentaContable;

    -- Panam? 20130722 Compa??a = 30 En Colombia es cdciaMatriz en SAP es 3000
    PCK_GESTION_PRODUCTOS.SPGET_COMPANIA_PRODUCTO( reg.cdramo,reg.cdsubramo,lvaCdCompania,lvaCdciaMatriz,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);
    -- Panam? 20130722 el ramo es el que viene de la fuente
    IF lvaCdciaMatriz = '00' THEN
     IF lvaCdRamo = '081' AND lvaCdTipoReserva = 'T' THEN
--     lobjDetalle.cdRamo  := 'MVI';
      lobjDetalle.cdRamo := 'AAV';
     ELSE
      lobjDetalle.cdRamo := lvaCdramoContable;
     END IF;
    ELSIF lvaCdciaMatriz = '30' THEN
     lobjDetalle.cdRamo  := lvaCdramoContable;
    END IF;
    lobjDetalle.nmPoliza            := lvaNmPoliza;

    OPEN lcuDatosPoliza;
    FETCH lcuDatosPoliza INTO lvaCdAgente, lvaCdDelegacionRadica, ldaFeFecto, ldaFeFectoAnualidad;
    CLOSE lcuDatosPoliza;

    lobjDetalle.cdIntermediario     := lvaCdAgente;
    lobjDetalle.cdOficinaRadicacion := lvaCdDelegacionRadica;
    lobjDetalle.nmExpediente        := lvaNmExpediente;

    OPEN lcuAsegurado;
    FETCH lcuAsegurado INTO lvaDniAsegurado;
    CLOSE lcuAsegurado;
    lvaNmAsegurado := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(lvaDniAsegurado);
    lobjDetalle.nmAsegurado         := lvaNmAsegurado;
    lobjDetalle.ptImporte           := REG.IMPORTE;

    lobjDetalle.cdCentroCostos      := lvaCdDelegacionRadica;

    OPEN lcuDatosSiniestro;
    FETCH lcuDatosSiniestro INTO ldaFeOcurrencia, ldaFenotificacion;
    CLOSE lcuDatosSiniestro;
    lobjDetalle.feAviso             := ldaFenotificacion;
    lobjDetalle.feOcurrencia        := ldaFeOcurrencia;

    -- Panam? 20130722 Compa??a = 30 En Colombia es cdciaMatriz en SAP es 3000
    IF lvaCdciaMatriz = '00' THEN
     lobjDetalle.cdCompaniaParametro := lvaCdCompania;
    ELSIF lvaCdciaMatriz = '30' THEN
     lobjDetalle.cdCompaniaParametro := lvaCdciaMatriz;
    ELSE
     lobjDetalle.cdCompaniaParametro := lvaCdCompania;
    END IF;

    IF lvaCdciaMatriz = '00' THEN
     IF lvaSnCuentaContable = 'S' THEN
      lobjDetalle.cdRamoParametro := lvaCdramoContable;
     ELSE
      lobjDetalle.cdRamoParametro := 'N';
     END IF;
    ELSIF lvaCdciaMatriz = '30' THEN
     IF lvaCdRamo = '081' THEN
      -- Moneda = 20 En SAP es PAB
      -- 081TA Vida individual tradicional 1 a?o
      -- 081TR Vida individual tradicional Renovacion
      -- 081UA Vida individual Universal 1 a?o
      -- 081UR Vida individual Universal Renovacion
      -- 012BR Fianza bienes raices (contruccion)
      -- 012FI Fianza Fidelidad
      -- 012BA Bancaria
      lvaSnPrimerVigencia := 'S';
      OPEN lcuPrimerVigencia;
      FETCH lcuPrimerVigencia INTO lvaSnPrimerVigencia;
      IF lcuPrimerVigencia%NOTFOUND THEN
       lvaSnPrimerVigencia := 'N';
      END IF;
      CLOSE lcuPrimerVigencia;

      --Para identificar si es Universal o tradicional.
      OPEN lcuGrupoProducto;
      FETCH lcuGrupoProducto INTO lvaGrupoProducto;
      CLOSE lcuGrupoProducto;

      IF lvaSnPrimerVigencia = 'S' THEN
       lobjDetalle.cdRamoParametro := lvaGrupoProducto||'A';
      ELSE
       lobjDetalle.cdRamoParametro := lvaGrupoProducto||'R';
      END IF;
     ELSE
      -- Solicitud via email de German Duque y Manuel Guevara el viernes, 17 de abril de 2015 04:19 p.m.
      -- con titulo Seguimiento BI Panam?
      lobjDetalle.cdRamoParametro := lvaCdramoContable;
--      lobjDetalle.cdRamoParametro := lvaCdRamo;
     END IF;
    END IF;

    lobjDetalle.cdOperacion                := reg.cdoperacion;

    lobjDetalle.cdConcepto                 := lvaCdConcepto;

    --Se comenta por solicitud de cat?logo de servicio 85529 Solicitada por Mario Franco y afirmada por SAP
    -- y se deja concatenando el codigo del usuario
    lobjDetalle.dsTextoPosicion            := lvaNmExpediente||'-'||lvaDsLoginUsuario;
    --lobjDetalle.dsTextoPosicion            := lvaNmExpediente||'-'||'FONDO AHORRO Y VLR CESION';

    IF lnuContadorDetalle = 1 THEN
       lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
    ELSE
       lobjTabDetalles.Extend;
       lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
    END IF;
   END LOOP;
   -- 25/11/2024 josebuvi se agrega argumento para obtener unicamente garantia
   FOR reg IN lcuDetalleSumadosDeducible(doc.CDGARANTIA) LOOP
    IF reg.DEDUCIBLE <> 0 THEN
     lvaCdRamo                       := reg.CDRAMO;
     lvaCdSubramo                    := reg.CDSUBRAMO;
     lvaCdGarantia                   := reg.CDGARANTIA;
     lvaCdSubGarantia                := reg.CDSUBGARANTIA;
     INSERT INTO T999_INCONSISTENCIAS (cdramo, cdsubramo, nmnegocio, feingreso, dsparametros, dsmensaje_tecnico, cdaplicacion)
        VALUES ('', '', '', SYSDATE, 'FOR lcuDetalleSumadosDeducible lvaCdRamo '||lvaCdRamo||' lvaCdSubramo '
        ||lvaCdSubramo||' lvaCdGarantia '||lvaCdGarantia||' lvaCdSubGarantia '||lvaCdSubGarantia||' ', '', 'TRAZA_RETENCION_083');
     lobjDetalle.cdIndicadorImpuesto := lvaCodIva;
     lvaAplicaReservaSinRetencion    := NVL(PCK_PARAMETROS.FN_GET_PARAMETROV2('%',
                                                                              '%',
                                                                              'RESERVASINRETEN',
                                                                              SYSDATE,
                                                                              reg.NUMERO_RESERVA,
                                                                              '%',
                                                                              '%',
                                                                              '%',
                                                                              '%'), 'N');
     
     -- 01/12/2024 josebuvi VERIFICACION DE VIDA PARA INDICADOR IMPUESTO
     -- linaduto - 2025/03/11 - HU756348 -Ajuste retenci?n en la fuente para ID NIT - subramos PCP y deudores
     -- linaduto - 2025/03/20 - HU764049 -Ajuste retenci?n en la fuente para ID NIT - Ramo BAN
     -- luishure - 2025/12/10 - HU984785 - Exclusión de retención para Fondo de Ahorro
     IF (lvaCdRamo = '083' OR lvaCdRamo = 'BAN') AND lvaCdGarantia = 'VID' AND lvaAplicaReservaSinRetencion = 'N' THEN     
       IF (lvaAplicaSinRetencion = 'N' OR (lvaAplicaSinRetencion = 'S' AND substr(lvaDni,1,1) <> 'A')) THEN 
        lnuContadorRetencionVida             := lnuContadorRetencionVida + 1;
        IF lnuContadorRetencionVida = 1 THEN
          lnuContadorRetencion               := lnuContadorRetencion + 1;
        lobjRetencion.cdtipoRetencion      := 'F5';
        lobjRetencion.cdindicadorRetencion := 'VI';
        IF lnuContadorRetencion = 1 THEN
        lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
        ELSE
        lobjRetenciones.Extend;
        lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
        END IF;
        lobjDocumento.retenciones := lobjRetenciones;
        END IF;
      END IF;	  
     END IF;
     lobjDetalle.cdConcepto          := '8';
     lvaSnCuentaContable             := 'N';

     OPEN lcuTipoReserva;
     FETCH lcuTipoReserva INTO lvaCdTipoReserva,lvaCdramoContable;
     CLOSE lcuTipoReserva;

     lnuContadorDetalle              := lnuContadorDetalle + 1;
     lobjDetalle.cdTipoReserva       := lvaCdTipoReserva;

     OPEN lcuSnCuentaContable;
     FETCH lcuSnCuentaContable INTO lvaSnCuentaContable;
     CLOSE lcuSnCuentaContable;

     IF lvaCdRamo = '081' AND lvaCdTipoReserva = 'T' THEN
--      lobjDetalle.cdRamo              := 'MVI';
      lobjDetalle.cdRamo              := 'AAV';
     ELSE
      lobjDetalle.cdRamo              := lvaCdramoContable;
     END IF;

     lobjDetalle.nmPoliza            := lvaNmPoliza;

     lobjDetalle.cdIntermediario     := lvaCdAgente;
     lobjDetalle.cdOficinaRadicacion := lvaCdDelegacionRadica;
     lobjDetalle.nmExpediente        := lvaNmExpediente;

     lobjDetalle.nmAsegurado         := lvaNmAsegurado;
     lobjDetalle.ptImporte           := reg.DEDUCIBLE;

     lobjDetalle.cdCentroCostos      := lvaCdDelegacionRadica;

     lobjDetalle.feAviso             := ldaFenotificacion;
     lobjDetalle.feOcurrencia        := ldaFeOcurrencia;

     PCK_GESTION_PRODUCTOS.SPGET_COMPANIA_PRODUCTO( reg.cdramo,reg.cdsubramo,lvaCdCompania,lvaCdciaMatriz,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);
     -- Se comenta esta l?nea por cambio de Panam?.
--     lobjDetalle.cdCompaniaParametro := lvaCdCompania;

    -- Panam? 20130722 Compa??a = 30 En Colombia es cdciaMatriz en SAP es 3000
     IF lvaCdciaMatriz = '00' THEN
      lobjDetalle.cdCompaniaParametro := lvaCdCompania;
     ELSIF lvaCdciaMatriz = '30' THEN
      lobjDetalle.cdCompaniaParametro := lvaCdciaMatriz;
     ELSE
      lobjDetalle.cdCompaniaParametro := lvaCdCompania;
     END IF;

     IF lvaCdciaMatriz = '00' THEN
      IF lvaSnCuentaContable = 'S' THEN
       lobjDetalle.cdRamoParametro := lvaCdramoContable;
      ELSE
        lobjDetalle.cdRamoParametro := 'N';
      END IF;
     ELSIF lvaCdciaMatriz = '30' THEN
      --Para panam? el indicador de impuesto para el deducible es cero.
      lobjDetalle.cdIndicadorImpuesto := '0';
      IF lvaCdRamo = '081' THEN
       lvaSnPrimerVigencia := 'S';
       OPEN lcuPrimerVigencia;
       FETCH lcuPrimerVigencia INTO lvaSnPrimerVigencia;
       IF lcuPrimerVigencia%NOTFOUND THEN
        lvaSnPrimerVigencia := 'N';
       END IF;
       CLOSE lcuPrimerVigencia;
       --Para identificar si es Universal o tradicional.
       OPEN lcuGrupoProducto;
       FETCH lcuGrupoProducto INTO lvaGrupoProducto;
       CLOSE lcuGrupoProducto;

       IF lvaSnPrimerVigencia = 'S' THEN
        lobjDetalle.cdRamoParametro := lvaGrupoProducto||'A';
       ELSE
        lobjDetalle.cdRamoParametro := lvaGrupoProducto||'R';
       END IF;
      ELSE
       -- Solicitud via email de German Duque y Manuel Guevara el viernes, 17 de abril de 2015 04:19 p.m.
       -- con titulo Seguimiento BI Panam?
       lobjDetalle.cdRamoParametro := lvaCdramoContable;
       --lobjDetalle.cdRamoParametro := lvaCdRamo;
      END IF;
     END IF;

     lobjDetalle.cdOperacion   := reg.cdoperacion;

--     lobjDetalle.cdConcepto    := lvaCdConcepto;

     --Se comenta por solicitud de cat?logo de servicio 85529 Solicitada por Mario Franco y afirmada por SAP
     -- y se deja concatenando el codigo del usuario
     lobjDetalle.dsTextoPosicion            := lvaNmExpediente||'-'||lvaDsLoginUsuario;
     --lobjDetalle.dsTextoPosicion             := lvaNmExpediente||'-'||'DEDUCIBLE';

     IF lnuContadorDetalle = 1 THEN
      lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
     ELSE
      lobjTabDetalles.Extend;
      lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
     END IF;
    END IF;
   END LOOP;

   --  Coaseguro
   -- Panam? Coaseguro Aceptado
   IF lvaCdciaMatriz = '30' THEN
    lvaTipoCoaseguro := NULL;
    OPEN lcuTipoCoaseguro;
    FETCH lcuTipoCoaseguro INTO lvaTipoCoaseguro;
    CLOSE lcuTipoCoaseguro;
    IF lvaTipoCoaseguro = 'A' THEN
     lobjDetalle.cdConcepto := lobjDetalle.cdConcepto||'A';
    END IF;
   END IF;
    -- Cedido
   IF lvaIdSoloSura <> '01' THEN
    -- 25/11/2024 josebuvi se agrega argumento para obtener unicamente garantia
    FOR reg IN lcuDetalleSumadosCoaseguro(doc.CDGARANTIA) LOOP
     IF reg.COASEGURO <> 0 THEN
      lvaCdRamo                       := reg.CDRAMO;
      lvaCdSubramo                    := reg.CDSUBRAMO;
      lvaCdGarantia                   := reg.CDGARANTIA;
      lvaCdSubGarantia                := reg.CDSUBGARANTIA;
      INSERT INTO T999_INCONSISTENCIAS (cdramo, cdsubramo, nmnegocio, feingreso, dsparametros, dsmensaje_tecnico, cdaplicacion)
        VALUES ('', '', '', SYSDATE, 'FOR lcuDetalleSumadosCoaseguro lvaCdRamo '||lvaCdRamo||' lvaCdSubramo '
        ||lvaCdSubramo||' lvaCdGarantia '||lvaCdGarantia||' lvaCdSubGarantia '||lvaCdSubGarantia||' ', '', 'TRAZA_RETENCION_083');

      lobjDetalle.cdIndicadorImpuesto := /*'0000';--*/lvaCodIva;
      lvaAplicaReservaSinRetencion    := NVL(PCK_PARAMETROS.FN_GET_PARAMETROV2('%',
                                                                               '%',
                                                                               'RESERVASINRETEN',
                                                                               SYSDATE,
                                                                               reg.NUMERO_RESERVA,
                                                                               '%',
                                                                               '%',
                                                                               '%',
                                                                               '%'), 'N');
     -- 01/12/2024 josebuvi VERIFICACION DE VIDA PARA INDICADOR IMPUESTO
     -- linaduto - 2025/03/11 - HU756348 -Ajuste retenci?n en la fuente para ID NIT - subramos PCP y deudores
     -- linaduto - 2025/03/20 - HU764049 -Ajuste retenci?n en la fuente para ID NIT - Ramo BAN
     -- luishure - 2025/12/10 - HU984785 - Exclusión de retención para Fondo de Ahorro
      IF (lvaCdRamo = '083' OR lvaCdRamo = 'BAN') AND lvaCdGarantia = 'VID' AND lvaAplicaReservaSinRetencion = 'N' THEN           
        IF (lvaAplicaSinRetencion = 'N' OR (lvaAplicaSinRetencion = 'S' AND substr(lvaDni,1,1) <> 'A')) THEN 
          lnuContadorRetencionVida             := lnuContadorRetencionVida + 1;
          IF lnuContadorRetencionVida = 1 THEN
            lnuContadorRetencion               := lnuContadorRetencion + 1;
            lobjRetencion.cdtipoRetencion      := 'F5';
            lobjRetencion.cdindicadorRetencion := 'VI';
            IF lnuContadorRetencion = 1 THEN
              lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
            ELSE
              lobjRetenciones.Extend;
              lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
            END IF;
            lobjDocumento.retenciones := lobjRetenciones;
          END IF;
        END IF;	  
      END IF;
      lobjDetalle.cdConcepto          := '1C';
      lvaSnCuentaContable             := 'N';

      OPEN lcuTipoReserva;
      FETCH lcuTipoReserva INTO lvaCdTipoReserva,lvaCdramoContable;
      CLOSE lcuTipoReserva;

      lnuContadorDetalle              := lnuContadorDetalle + 1;
      lobjDetalle.cdTipoReserva       := lvaCdTipoReserva;

      OPEN lcuSnCuentaContable;
      FETCH lcuSnCuentaContable INTO lvaSnCuentaContable;
      CLOSE lcuSnCuentaContable;

      IF lvaCdRamo = '081' AND lvaCdTipoReserva = 'T' THEN
       lobjDetalle.cdRamo              := 'AAV';
      ELSE
       lobjDetalle.cdRamo              := lvaCdramoContable;
      END IF;

      lobjDetalle.nmPoliza            := lvaNmPoliza;

      lobjDetalle.cdIntermediario     := lvaCdAgente;
      lobjDetalle.cdOficinaRadicacion := lvaCdDelegacionRadica;
      lobjDetalle.nmExpediente        := lvaNmExpediente;

      -- Para coaseguro, se tiene en el campo nmAsegurado el DNI de la Coaseguradora
      lvaCdCiaCoaseguradora := reg.CDCIA;
      OPEN lcuCiaCoaseguradora;
      FETCH lcuCiaCoaseguradora INTO lvaDniCoaseguro;--lobjDetalle.nmAsegurado;
      CLOSE lcuCiaCoaseguradora;
      lobjDetalle.nmAsegurado := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(lvaDniCoaseguro);


      lobjDetalle.ptImporte           := reg.COASEGURO;

      lobjDetalle.cdCentroCostos      := lvaCdDelegacionRadica;

      lobjDetalle.feAviso             := ldaFenotificacion;
      lobjDetalle.feOcurrencia        := ldaFeOcurrencia;

      -- Panam? 20130722 Compa??a = 30 En Colombia es cdciaMatriz en SAP es 3000
      PCK_GESTION_PRODUCTOS.SPGET_COMPANIA_PRODUCTO( reg.cdramo,reg.cdsubramo,lvaCdCompania,lvaCdciaMatriz,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);
      IF lvaCdciaMatriz = '00' THEN
       lobjDetalle.cdCompaniaParametro := lvaCdCompania;
      ELSIF lvaCdciaMatriz = '30' THEN
       lobjDetalle.cdCompaniaParametro := lvaCdciaMatriz;
      ELSE
       lobjDetalle.cdCompaniaParametro := lvaCdCompania;
      END IF;

      IF lvaCdciaMatriz = '00' THEN
       IF lvaSnCuentaContable = 'S' THEN
        lobjDetalle.cdRamoParametro := lvaCdramoContable;
       ELSE
        lobjDetalle.cdRamoParametro := 'N';
       END IF;
      ELSIF lvaCdciaMatriz = '30' THEN
       --20131023 De acuerdo a email de German Duque siempre va  lobjDetalle.cdRamoParametro = N
       -- por eso se comenta todo el IF para ramo 081 y 012
--       lobjDetalle.cdRamoParametro := 'N';
       IF lvaCdRamo = '081' THEN
        lvaSnPrimerVigencia := 'S';
        OPEN lcuPrimerVigencia;
        FETCH lcuPrimerVigencia INTO lvaSnPrimerVigencia;
        IF lcuPrimerVigencia%NOTFOUND THEN
         lvaSnPrimerVigencia := 'N';
        END IF;
        CLOSE lcuPrimerVigencia;
        --Para identificar si es Universal o tradicional.
        OPEN lcuGrupoProducto;
        FETCH lcuGrupoProducto INTO lvaGrupoProducto;
        CLOSE lcuGrupoProducto;

        IF lvaSnPrimerVigencia = 'S' THEN
         lobjDetalle.cdRamoParametro := lvaGrupoProducto||'A';
        ELSE
         lobjDetalle.cdRamoParametro := lvaGrupoProducto||'R';
        END IF;

       ELSIF lvaCdRamo = '012' THEN
        --Para identificar el tipo de cobertura Bancaria, Fidelidad, Construcci?n ...
        OPEN lcuGrupoCobertura;
        FETCH lcuGrupoCobertura INTO lvaCdGrupoCobertura;
        CLOSE lcuGrupoCobertura;
        lobjDetalle.cdRamoParametro := lvaCdRamo||lvaCdGrupoCobertura;
       ELSE
        -- Solicitud via email de German Duque y Manuel Guevara el viernes, 17 de abril de 2015 04:19 p.m.
        -- con titulo Seguimiento BI Panam?
        lobjDetalle.cdRamoParametro := lvaCdramoContable;
        --lobjDetalle.cdRamoParametro := lvaCdRamo;
       END IF;
      END IF;
      lobjDetalle.cdOperacion   := reg.cdoperacion;

      --Se comenta por solicitud de cat?logo de servicio 85529 Solicitada por Mario Franco y afirmada por SAP
      -- y se deja concatenando el codigo del usuario
      lobjDetalle.dsTextoPosicion            := lvaNmExpediente||'-'||lvaDsLoginUsuario;
      --lobjDetalle.dsTextoPosicion             := lvaNmExpediente||'-'||' COASEGURO CEDIDO';

      IF lnuContadorDetalle = 1 THEN
       lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
      ELSE
       lobjTabDetalles.Extend;
       lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
      END IF;
     END IF;
    END LOOP;
   END IF;
   -- Fin de coaseguro
   -- 25/11/2024 josebuvi se agrega argumento para obtener unicamente garantia
   FOR reg IN lcuDetalleSumadosDescuento(doc.CDGARANTIA) LOOP
    IF reg.PTDESCUENTO <> 0 THEN
     lvaCdRamo                       := reg.CDRAMO;
     lvaCdSubramo                    := reg.CDSUBRAMO;
     lvaCdGarantia                   := reg.CDGARANTIA;
     lvaCdSubGarantia                := reg.CDSUBGARANTIA;
     INSERT INTO T999_INCONSISTENCIAS (cdramo, cdsubramo, nmnegocio, feingreso, dsparametros, dsmensaje_tecnico, cdaplicacion)
        VALUES ('', '', '', SYSDATE, 'FOR lcuDetalleSumadosDescuento lvaCdRamo '||lvaCdRamo||' lvaCdSubramo '
        ||lvaCdSubramo||' lvaCdGarantia '||lvaCdGarantia||' lvaCdSubGarantia '||lvaCdSubGarantia||' ', '', 'TRAZA_RETENCION_083');
     lobjDetalle.cdIndicadorImpuesto := '0000';--lvaCodIva;
     lvaAplicaReservaSinRetencion    := NVL(PCK_PARAMETROS.FN_GET_PARAMETROV2('%',
                                                                              '%',
                                                                              'RESERVASINRETEN',
                                                                              SYSDATE,
                                                                              reg.NUMERO_RESERVA,
                                                                              '%',
                                                                              '%',
                                                                              '%',
                                                                              '%'), 'N');
     -- 01/12/2024 josebuvi VERIFICACION DE VIDA PARA INDICADOR IMPUESTO
     -- linaduto - 2025/03/11 - HU756348 -Ajuste retenci?n en la fuente para ID NIT - subramos PCP y deudores
     -- linaduto - 2025/03/20 - HU764049 -Ajuste retenci?n en la fuente para ID NIT - Ramo BAN
     -- luishure - 2025/12/10 - HU984785 - Exclusión de retención para Fondo de Ahorro
      IF (lvaCdRamo = '083' OR lvaCdRamo = 'BAN') AND lvaCdGarantia = 'VID' AND lvaAplicaReservaSinRetencion = 'N' THEN
        IF (lvaAplicaSinRetencion = 'N' OR (lvaAplicaSinRetencion = 'S' AND substr(lvaDni,1,1) <> 'A')) THEN 
          lnuContadorRetencionVida             := lnuContadorRetencionVida + 1;
          IF lnuContadorRetencionVida = 1 THEN
            lnuContadorRetencion               := lnuContadorRetencion + 1;
            lobjRetencion.cdtipoRetencion      := 'F5';
            lobjRetencion.cdindicadorRetencion := 'VI';
            IF lnuContadorRetencion = 1 THEN
              lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
            ELSE
              lobjRetenciones.Extend;
              lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
            END IF;
            lobjDocumento.retenciones := lobjRetenciones;
          END IF;
        END IF;	  
      END IF;
     lobjDetalle.cdConcepto          := '9';
     lvaSnCuentaContable             := 'N';

     OPEN lcuTipoReserva;
     FETCH lcuTipoReserva INTO lvaCdTipoReserva,lvaCdramoContable;
     CLOSE lcuTipoReserva;

     lnuContadorDetalle              := lnuContadorDetalle + 1;
     lobjDetalle.cdTipoReserva       := lvaCdTipoReserva;

     OPEN lcuSnCuentaContable;
     FETCH lcuSnCuentaContable INTO lvaSnCuentaContable;
     CLOSE lcuSnCuentaContable;

     IF lvaCdRamo = '081' AND lvaCdTipoReserva = 'T' THEN
--      lobjDetalle.cdRamo              := 'MVI';
      lobjDetalle.cdRamo              := 'AAV';
     ELSE
      lobjDetalle.cdRamo              := lvaCdramoContable;
     END IF;

     lobjDetalle.nmPoliza            := lvaNmPoliza;

     lobjDetalle.cdIntermediario     := lvaCdAgente;
     lobjDetalle.cdOficinaRadicacion := lvaCdDelegacionRadica;
     lobjDetalle.nmExpediente        := lvaNmExpediente;

     lobjDetalle.nmAsegurado         := lvaNmAsegurado;
     lobjDetalle.ptImporte           := reg.PTDESCUENTO;

     lobjDetalle.cdCentroCostos      := lvaCdDelegacionRadica;

     lobjDetalle.feAviso             := ldaFenotificacion;
     lobjDetalle.feOcurrencia        := ldaFeOcurrencia;

     -- Panam? 20130722 Compa??a = 30 En Colombia es cdciaMatriz en SAP es 3000
     PCK_GESTION_PRODUCTOS.SPGET_COMPANIA_PRODUCTO( reg.cdramo,reg.cdsubramo,lvaCdCompania,lvaCdciaMatriz,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);
     IF lvaCdciaMatriz = '00' THEN
      lobjDetalle.cdCompaniaParametro := lvaCdCompania;
     ELSIF lvaCdciaMatriz = '30' THEN
      lobjDetalle.cdCompaniaParametro := lvaCdciaMatriz;
     ELSE
      lobjDetalle.cdCompaniaParametro := lvaCdCompania;
     END IF;

     IF lvaCdciaMatriz = '00' THEN
      IF lvaSnCuentaContable = 'S' THEN
       lobjDetalle.cdRamoParametro := lvaCdramoContable;
      ELSE
       lobjDetalle.cdRamoParametro := 'N';
      END IF;
     ELSIF lvaCdciaMatriz = '30' THEN
      IF lvaCdRamo = '081' THEN
       lvaSnPrimerVigencia := 'S';
       OPEN lcuPrimerVigencia;
       FETCH lcuPrimerVigencia INTO lvaSnPrimerVigencia;
       IF lcuPrimerVigencia%NOTFOUND THEN
        lvaSnPrimerVigencia := 'N';
       END IF;
       CLOSE lcuPrimerVigencia;
       --Para identificar si es Universal o tradicional.
       OPEN lcuGrupoProducto;
       FETCH lcuGrupoProducto INTO lvaGrupoProducto;
       CLOSE lcuGrupoProducto;

       IF lvaSnPrimerVigencia = 'S' THEN
        lobjDetalle.cdRamoParametro := lvaGrupoProducto||'A';
       ELSE
        lobjDetalle.cdRamoParametro := lvaGrupoProducto||'R';
       END IF;
      ELSE
        -- Solicitud via email de German Duque y Manuel Guevara el viernes, 17 de abril de 2015 04:19 p.m.
        -- con titulo Seguimiento BI Panam?
        lobjDetalle.cdRamoParametro := lvaCdramoContable;
--      lobjDetalle.cdRamoParametro := lvaCdRamo;
      END IF;
     END IF;

     lobjDetalle.cdOperacion   := reg.cdoperacion;

--    lobjDetalle.cdConcepto    := lvaCdConcepto;

     --Se comenta por solicitud de cat?logo de servicio 85529 Solicitada por Mario Franco y afirmada por SAP
     -- y se deja concatenando el codigo del usuario
     lobjDetalle.dsTextoPosicion            := lvaNmExpediente||'-'||lvaDsLoginUsuario;
     --lobjDetalle.dsTextoPosicion             := lvaNmExpediente||'-'||' DESCUENTO FINANCIERO';

     IF lnuContadorDetalle = 1 THEN
      lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
     ELSE
      lobjTabDetalles.Extend;
      lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
     END IF;
    END IF;
   END LOOP;



   lobjDocumento.detalleSiniestros                   := lobjTabDetalles;

/*   FOR i IN lobjTabDetalles.FIRST..lobjTabDetalles.LAST LOOP
       DBMS_OUTPUT.put_line('Detalle 1: '||lobjTabDetalles(i).ptImporte);
   END LOOP;
*/
   lobjDocumento.cuentaBancaria := lobjCuentaBancaria;

   IF lnuContadorDocumentos = 1 THEN
    lobjDocumentos(lnuContadorDocumentos) := lobjDocumento;
   ELSE
    lobjDocumentos.Extend;
    lobjDocumentos(lnuContadorDocumentos) := lobjDocumento;
   END IF;
  lnuContadorRetencionVida := 0;
  END LOOP;-- lcuDatosDocumentoFyC

----------------------------------------------------------------------------------------------------------------------
  lobjTabDetalles := tab_sap_detalles_cxp_sini(obj_sap_detalle_cxp_sini());
  lobjRetenciones := tab_sap_datos_retenciones(obj_sap_dato_retencion());
  lobjDocumento   := obj_sap_documento_cxp_sini();
  lobjRetencion   := obj_sap_dato_retencion();
  lobjDetalle     := obj_sap_detalle_cxp_sini();
  FOR doc IN lcuDatosDocumentoRes LOOP
  INSERT INTO T999_INCONSISTENCIAS (cdramo, cdsubramo, nmnegocio, feingreso, dsparametros, dsmensaje_tecnico, cdaplicacion)
        VALUES ('', '', '', SYSDATE, 'FOR lcuDatosDocumentoRes ', '', 'TRAZA_RETENCION_083');

   lvaCodIva                          := LPAD(REPLACE(TO_CHAR(RPAD(DOC.POIRPF,4,'0')),'.',''),4,'0');
   -- 8/10/2025. HT918841 - Códigos de retención específicos. luishure 
   IF lvaCodIva = '1900' AND PCK_PARAMETROS.FN_GET_PARAMETROV2('%','%','GET_INDICADOR',SYSDATE, DOC.CDRETENCION ,'*','*','*','*') IS NOT NULL THEN
     lvaCodIva                        := PCK_PARAMETROS.FN_GET_PARAMETROV2('%','%','GET_INDICADOR',SYSDATE, DOC.CDRETENCION ,'*','*','*','*');
   END IF;
   lvaPoIrpf                          := doc.POIRPF;
   lvaPoirc                           := doc.POIRC;
   lvaPoIca                           := doc.POICA;
   lvaCdRetencion                     := doc.CDRETENCION;
   lvaCdTipoReserva                   := doc.CDTIPO_RESERVA;


   lnuContadorDocumentos              := lnuContadorDocumentos + 1;
   lobjDocumento                      := OBJ_SAP_DOCUMENTO_CXP_SINI();

   lobjDocumento.nmBeneficiarioPago   := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(lvaDni);
   lobjDocumento.cdTipoIdentificacion := PCK_SIC_UTILITARIOS_I.FN_SIC_CDTIPO_IDENTIFICACION(lvaDni);

   -- 17/07/2025 Mateo Zapata - Homologacion de tipo de documento TT para SAP
   IF UPPER(lobjDocumento.cdTipoIdentificacion) = 'TT' THEN
     lobjDocumento.cdTipoIdentificacion := 'PT';
   END IF;

   --Panam?. Digito Verificacion
   IF lvaCdciaMatriz = '30' THEN
    IF lvaDigitoVerificacion IS NOT NULL THEN
--SAP va a poner el d?gito de verificaci?n.
NULL;
--     lobjDocumento.nmBeneficiarioPago := lobjDocumento.nmBeneficiarioPago||':'||lvaDigitoVerificacion;
    END IF;
   END IF;
   lobjDocumento.cdOficinaRegistro    := lvaCdOficinaRegistro;

   IF lvaSnPolizaSalud = 'S' THEN
     lobjDocumento.ptImporte := doc.importe_sin_desc;
   ELSE
     lobjDocumento.ptImporte := doc.importe;
   END IF;

   lobjDocumento.snCalcularImpuestos  := lvaSnCalcularImpuestos;
   lobjDocumento.cdIva                := NULL;--lvaCodIva;
   lobjDocumento.fePosiblePago        := lvaFeposiblePago;

   -- Variable de control para evitar Saldo en moneda de transaccion
   lnuTotalPago                       := lobjDocumento.ptImporte;

   lobjDocumento.condicionPago        := lobjCondicionPago;
   lobjDocumento.cdViaPago            := lvaCdViaPago;
   lobjDocumento.cdBloqueoPago        := lvaCdbloqueoPago;
   lobjDocumento.dsTextoPosicion      := lvaDsTextoPosicion;
   lobjDocumento.nmPoliza             := lvaNmPoliza;
   lobjDocumento.cdRamo               := lvaCdRamo;
   --se debe revisar como obtener la operacion del neto
   lobjDocumento.cdOperacion          := lvaCdOperacion;
   lobjDocumento.cdTipoReserva        := doc.CDTIPO_RESERVA;

   -- Para atender la solicitud de catatalogo de servicio nro. 71527 de 02/04/2013 09:17:02 por Luis Gmo. Freyre
   IF lvaCdciaMatriz = '00' THEN
    IF doc.CDTRIBUTARIA = 'N' AND doc.CDRETENCION NOT IN ('0029','0028') THEN
     lobjDocumento.cdOperacion          := lobjDocumento.cdOperacion ||'P';
    END IF;
   ELSIF lvaCdciaMatriz = '30' THEN
   -- Panam? En la coexistencia, no se pregunta por reembolso.  Solo se lee de personas si es proveedor
--    IF doc.CDTRIBUTARIA = 'N' THEN
     OPEN lcuProveedor;
     FETCH lcuProveedor INTO lvaSnProveedorPanama;
     IF lcuProveedor%FOUND THEN
      lobjDocumento.cdOperacion := lobjDocumento.cdOperacion ||'P';
     END IF;
     CLOSE lcuProveedor;
--    END IF;
   END IF;

   --Llenado de la tabla de Retenciones.
   -- Panam?. no se llevan las retenciones
   IF lvaCdciaMatriz = '00' THEN

    lvaCdRetencion                   := doc.CDRETENCION;
    lnuImpIrc                        := doc.IMPIRC;
    lnuImpIrpfRetenido               := doc.IMPIRPF_RETENIDO;
    lnuImpIca                        := doc.IMPICA;

    lnuContadorRetencion             := 0;
    lobjRetenciones                  := TAB_SAP_DATOS_RETENCIONES(OBJ_SAP_DATO_RETENCION());

    --Con el cambio de retenciones, en el legacy se llevan a cero y es SAP quien las calcula
    --Se comenta como estaba anteriomente y se llevan solo si hay c?digo de retencion
    --IF NVL(lnuImpIrc,0) <> 0 THEN
    IF NVL(lvaCdRetencion,0) NOT IN ('0099','0000')  THEN
     lnuContadorRetencion                := lnuContadorRetencion + 1;
     lobjRetencion.cdtipoRetencion       := lvaCdRetencion;
     lobjRetencion.cdindicadorRetencion  := 'R';
     lobjRetencion.ptBaseRetencion       := doc.BASEIMPUESTOS;
     lobjRetencion.ptRetencion           := doc.IMPIRC;
     IF lnuContadorRetencion = 1 THEN
      lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
     ELSE
      lobjRetenciones.Extend;
      lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
     END IF;
    END IF;

    --Con el cambio de retenciones, en el legacy se llevan a cero y es SAP quien las calcula
    --Se comenta como estaba anteriomente y se llevan solo si hay c?digo de retencion
    --IF NVL(lnuImpIrpfRetenido,0) <> 0 THEN
    IF NVL(lvaCdRetencion,0) NOT IN ('0099','0000')  THEN
     lnuContadorRetencion                := lnuContadorRetencion + 1;
     lobjRetencion.cdtipoRetencion       := lvaCdRetencion;
     lobjRetencion.cdindicadorRetencion  := 'I';
     --Se comenta esta l?nea por el cambio de calculo de retenci?n desde SAP y avisado desde la devuelta.
     --para la base se env?a el valor del IVA doc.IMPIRPF y no la base de toda la retenci?n como se ten?a acostumbrado.
     --    lobjRetencion.ptBaseRetencion       := doc.BASEIMPUESTOS;
     lobjRetencion.ptBaseRetencion       := doc.IMPIRPF;
     lobjRetencion.ptRetencion           := doc.IMPIRPF_RETENIDO;
     IF lnuContadorRetencion = 1 THEN
      lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
     ELSE
      lobjRetenciones.Extend;
      lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
     END IF;
    END IF;

    -- Retencion de IVA R?gimen Simplificado
    -- Por requerimiento de Fredy Rios enviado el Martes 2010/2/23 01:47 p.m.
    -- se elimina el regimen simplificado para los ramos de personas.
    IF lvaCdCompania IN ('01') THEN
     OPEN lcuSnIva;
     FETCH lcuSnIva INTO lvaSnIva;
     IF lcuSnIva%NOTFOUND THEN
      lvaSnIva := 'N';
     END IF;
     CLOSE lcuSnIva;
     IF NVL(lnuImpIrpfRetenido,0) = 0 AND lvaSnIva = 'N' AND doc.CDTRIBUTARIA = 'N'
        AND pck_sic_utilitarios.fn_sic_naturaleza_dni(lobjDocumento.cdTipoIdentificacion) <> 'JJURIDICO' THEN
      lnuPoBaseRetencion                  := 0;
      OPEN lcuPoBaseRetencion;
      FETCH lcuPoBaseRetencion INTO lnuPoBaseRetencion;
      CLOSE lcuPoBaseRetencion;

      lnuPoRetencion                      := 0;
      OPEN lcuPoRetencion;
      FETCH lcuPoRetencion INTO lnuPoRetencion;
      CLOSE lcuPoRetencion;
      --Con el cambio de impuestos calculados desde SAP y que vienen en la devuelta,
      lnuReteIvaSimplificado               := doc.BASEIMPUESTOS * ((lnuPoRetencion*lnuPoBaseRetencion)/100);
      IF lnuReteIvaSimplificado <> 0 THEN
       lnuContadorRetencion                := lnuContadorRetencion + 1;
       lobjRetencion.cdtipoRetencion       := lvaCdRetencion;
       lobjRetencion.cdindicadorRetencion  := 'S';
       lobjRetencion.ptBaseRetencion       := doc.BASEIMPUESTOS;
       lobjRetencion.ptRetencion           := lnuReteIvaSimplificado;

       IF lnuContadorRetencion = 1 THEN
        lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
       ELSE
        lobjRetenciones.Extend;
        lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
       END IF;
      END IF;
     END IF;
    END IF;

    --Con el cambio de retenciones, en el legacy se llevan a cero y es SAP quien las calcula
    --Se comenta como estaba anteriomente y se llevan solo si hay c?digo de retencion
    --IF NVL(lnuImpIca,0) <> 0 THEN
    IF NVL(lvaCdRetencion,0) NOT IN ('0099','0000')  THEN
     OPEN lcuMunicipioIca;
     FETCH lcuMunicipioIca INTO lvaMunicipioIca;
     CLOSE lcuMunicipioIca;
     lnuContadorRetencion                := lnuContadorRetencion + 1;
     lobjRetencion.cdtipoRetencion       := lvaCdRetencion;
     lobjRetencion.cdindicadorRetencion  := lvaMunicipioIca;
     lobjRetencion.ptBaseRetencion       := doc.BASEIMPUESTOS;
     lobjRetencion.ptRetencion           := doc.IMPICA;
     IF lnuContadorRetencion = 1 THEN
      lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
     ELSE
      lobjRetenciones.Extend;
      lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
     END IF;
    END IF;
    lobjDocumento.retenciones        := lobjRetenciones;
   END IF;

   IF doc.CDTIPO_RESERVA = 'T' THEN
    lvaCdConcepto  := '1';
	-- JuanAlNo Se realiza validacion si son subramos que pertenecen a los productos de Salud para todos integral 
    IF lvaCdSubRamo in ('PVF','PVC') THEN
	 FOR cur IN lcuDatosTempGarantia LOOP
	  IF cur.CDGARANTIA = 'SK9' AND cur.CDSUBGARANTIA = 'NDX' THEN
	   lvaCdConcepto  := 'CO';
	  ELSIF cur.CDGARANTIA = 'SN4' AND cur.CDSUBGARANTIA = 'NDX' THEN
	   lvaCdConcepto  := 'MO';
	  END IF;
	 END LOOP;
    END IF;
   ELSE
    lvaCdConcepto  := '2';
   END IF;

   -- Panama para Salvantos y Subrogaciones
   IF lvaCodigoAceptacion = 'D' THEN
    lvaCdConcepto  := '12';
   ELSIF lvaCodigoAceptacion = 'S' THEN
    lvaCdConcepto  := '10';
   END IF;

   -- Panam? Coaseguro Aceptado
   IF lvaCdciaMatriz = '30' THEN
    lvaTipoCoaseguro := NULL;
    OPEN lcuTipoCoaseguro;
    FETCH lcuTipoCoaseguro INTO lvaTipoCoaseguro;
    CLOSE lcuTipoCoaseguro;
    IF lvaTipoCoaseguro = 'A' THEN
     lvaCdConcepto := lvaCdConcepto||'A';
    END IF;
   END IF;


   lobjDocumento.cdConcepto := lvaCdConcepto;

  --Llenado de la tabla de Detalles para tipo de reserva Matematica y T?cnina.
   lnuContadorDetalle := 0;
   lobjTabDetalles := tab_sap_detalles_cxp_sini(obj_sap_detalle_cxp_sini());

   OPEN lcuDatosSiniestro;
   FETCH lcuDatosSiniestro INTO ldaFeOcurrencia, ldaFenotificacion;
   CLOSE lcuDatosSiniestro;

   lnuPorepartoCoa := 100;
   OPEN lcuSoloSuraCoaseguro;
   FETCH lcuSoloSuraCoaseguro INTO lvaIdSoloSura;
   IF lcuSoloSuraCoaseguro%FOUND THEN
    lnuPorepartoCoa := 100;
   ELSE
    OPEN lcuPorcentajeCoaseguro;
    FETCH lcuPorcentajeCoaseguro INTO lnuPorepartoCoa;
    IF lcuPorcentajeCoaseguro%NOTFOUND THEN
     lnuPorepartoCoa := 100;
    END IF;
    CLOSE lcuPorcentajeCoaseguro;
   END IF;
   CLOSE lcuSoloSuraCoaseguro;
   -- 25/11/2024 josebuvi se agrega argumento para obtener unicamente garantia
   FOR reg IN lcuDatosPagosRes(doc.CDGARANTIA) LOOP
    lvaCdRamo                       := reg.CDRAMO;
    lvaCdSubramo                    := reg.CDSUBRAMO;
    lvaCdGarantia                   := reg.CDGARANTIA;
    lvaCdSubGarantia                := reg.CDSUBGARANTIA;
    INSERT INTO T999_INCONSISTENCIAS (cdramo, cdsubramo, nmnegocio, feingreso, dsparametros, dsmensaje_tecnico, cdaplicacion)
            VALUES ('', '', '', SYSDATE, 'FOR lcuDatosPagosRes lvaCdRamo '||lvaCdRamo||' lvaCdSubramo '
            ||lvaCdSubramo||' lvaCdGarantia '||lvaCdGarantia||' lvaCdSubGarantia '||lvaCdSubGarantia||' ', '', 'TRAZA_RETENCION_083');
    lobjDetalle.cdIndicadorImpuesto := lvaCodIva;
    lvaAplicaReservaSinRetencion    := NVL(PCK_PARAMETROS.FN_GET_PARAMETROV2('%',
                                                                             '%',
                                                                             'RESERVASINRETEN',
                                                                             SYSDATE,
                                                                             reg.NUMERO_RESERVA,
                                                                             '%',
                                                                             '%',
                                                                             '%',
                                                                             '%'), 'N');
    -- 01/12/2024 josebuvi VERIFICACION DE VIDA PARA INDICADOR IMPUESTO
    -- linaduto - 2025/03/11 - HU756348 -Ajuste retenci?n en la fuente para ID NIT - subramos PCP y deudores
    -- linaduto - 2025/03/20 - HU764049 -Ajuste retenci?n en la fuente para ID NIT - Ramo BAN
    -- luishure - 2025/12/10 - HU984785 - Exclusión de retención para Fondo de Ahorro
     IF (lvaCdRamo = '083' OR lvaCdRamo = 'BAN') AND lvaCdGarantia = 'VID' AND lvaAplicaReservaSinRetencion = 'N' THEN
       IF (lvaAplicaSinRetencion = 'N' OR (lvaAplicaSinRetencion = 'S' AND substr(lvaDni,1,1) <> 'A')) THEN 
          lnuContadorRetencionVida             := lnuContadorRetencionVida + 1;
          IF lnuContadorRetencionVida = 1 THEN
            lnuContadorRetencion               := lnuContadorRetencion + 1;
            lobjRetencion.cdtipoRetencion      := 'F5';
            lobjRetencion.cdindicadorRetencion := 'VI';
            IF lnuContadorRetencion = 1 THEN
              lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
            ELSE
              lobjRetenciones.Extend;
              lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
            END IF;
            lobjDocumento.retenciones := lobjRetenciones;
          END IF;
        END IF;	  
      END IF;

    IF reg.numero_reserva = 'P012100' THEN
       lobjDetalle.cdConcepto          := '13';
    ELSE
       lobjDetalle.cdConcepto          := lvaCdConcepto;
    END IF;
    lvaSnCuentaContable             := 'N';


    OPEN lcuTipoReserva;
    FETCH lcuTipoReserva INTO lvaCdTipoReserva,lvaCdramoContable;
    CLOSE lcuTipoReserva;

    lnuContadorDetalle              := lnuContadorDetalle + 1;
    lobjDetalle.cdTipoReserva       := lvaCdTipoReserva;

    OPEN lcuSnCuentaContable;
    FETCH lcuSnCuentaContable INTO lvaSnCuentaContable;
    CLOSE lcuSnCuentaContable;

    IF lvaCdRamo = '081' AND lvaCdTipoReserva = 'T' THEN
--     lobjDetalle.cdRamo              := 'MVI';
     lobjDetalle.cdRamo              := 'AAV';
    ELSE
     lobjDetalle.cdRamo              := lvaCdramoContable;
    END IF;

    lobjDetalle.nmPoliza            := lvaNmPoliza;

    OPEN lcuDatosPoliza;
    FETCH lcuDatosPoliza INTO lvaCdAgente, lvaCdDelegacionRadica, ldaFeFecto, ldaFeFectoAnualidad;
    CLOSE lcuDatosPoliza;

    lobjDetalle.cdIntermediario     := lvaCdAgente;
    lobjDetalle.cdOficinaRadicacion := lvaCdDelegacionRadica;
    lobjDetalle.nmExpediente        := lvaNmExpediente;

    OPEN lcuAsegurado;
    FETCH lcuAsegurado INTO lvaDniAsegurado;
    CLOSE lcuAsegurado;
    lvaNmAsegurado := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(lvaDniAsegurado);
    lobjDetalle.nmAsegurado         := lvaNmAsegurado;
    lobjDetalle.ptImporte           := REG.IMPORTE;

    -- Variable de control para evitar Saldo en moneda de transaccion
       lnuTotalPago     := lnuTotalPago - lobjDetalle.ptImporte;


    lobjDetalle.cdCentroCostos      := lvaCdDelegacionRadica;

    OPEN lcuDatosSiniestro;
    FETCH lcuDatosSiniestro INTO ldaFeOcurrencia, ldaFenotificacion;
    CLOSE lcuDatosSiniestro;
    lobjDetalle.feAviso             := ldaFenotificacion;
    lobjDetalle.feOcurrencia        := ldaFeOcurrencia;

    -- Panam? 20130722 Compa??a = 30 En Colombia es cdciaMatriz en SAP es 3000
    PCK_GESTION_PRODUCTOS.SPGET_COMPANIA_PRODUCTO( reg.cdramo,reg.cdsubramo,lvaCdCompania,lvaCdciaMatriz,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);
    IF lvaCdciaMatriz = '00' THEN
     lobjDetalle.cdCompaniaParametro := lvaCdCompania;
    ELSIF lvaCdciaMatriz = '30' THEN
     lobjDetalle.cdCompaniaParametro := lvaCdciaMatriz;
    ELSE
     lobjDetalle.cdCompaniaParametro := lvaCdCompania;
    END IF;

    IF lvaCdciaMatriz = '00' THEN
     IF lvaSnCuentaContable = 'S' THEN
      lobjDetalle.cdRamoParametro := lvaCdramoContable;
     ELSE
      lobjDetalle.cdRamoParametro := 'N';
     END IF;
    ELSIF lvaCdciaMatriz = '30' THEN
     IF lvaCdRamo = '081' THEN
      lvaSnPrimerVigencia := 'S';
      OPEN lcuPrimerVigencia;
      FETCH lcuPrimerVigencia INTO lvaSnPrimerVigencia;
      IF lcuPrimerVigencia%NOTFOUND THEN
       lvaSnPrimerVigencia := 'N';
      END IF;
      CLOSE lcuPrimerVigencia;
      --Para identificar si es Universal o tradicional.
      OPEN lcuGrupoProducto;
      FETCH lcuGrupoProducto INTO lvaGrupoProducto;
      CLOSE lcuGrupoProducto;

      IF lvaSnPrimerVigencia = 'S' THEN
       lobjDetalle.cdRamoParametro := lvaGrupoProducto||'A';
      ELSE
       lobjDetalle.cdRamoParametro := lvaGrupoProducto||'R';
      END IF;
     ELSE
      -- Solicitud via email de German Duque y Manuel Guevara el viernes, 17 de abril de 2015 04:19 p.m.
      -- con titulo Seguimiento BI Panam?
      lobjDetalle.cdRamoParametro := lvaCdramoContable;
--      lobjDetalle.cdRamoParametro := lvaCdRamo;
     END IF;
    END IF;

    lobjDetalle.cdOperacion         := reg.cdoperacion;


    --Se comenta por solicitud de cat?logo de servicio 85529 Solicitada por Mario Franco y afirmada por SAP
    -- y se deja concatenando el codigo del usuario
    lobjDetalle.dsTextoPosicion            := lvaNmExpediente||'-'||lvaDsLoginUsuario;
    --lobjDetalle.dsTextoPosicion             := lvaNmExpediente||'-'||'RESERVA MATEMATICA Y TECNICA';

    --Financiaciones de polizas
--    IF reg.NUMERO_RESERVA = 'P040099' THEN
-- Se modifica el if por solicitud de catalogo de servicio 77046 20/05/2013 10:27:38 por Luis Gmo. Freyre
    IF  lvaDni = 'A8110368755' OR reg.NUMERO_RESERVA = 'P040099' THEN
     lobjDetalle.cdConceptoAdicional := 'F';
    END IF;
    -- TRST-507- Modificacion gastos de siniestro (loregaar)
    -- se agrupan las reservas de gastos de siniestros en la variable: lva_rvas_gastossinsoat
    IF lvaDni = 'A8110368755' OR
       reg.NUMERO_RESERVA IN ('P012097',
                              'P012099',
                              'P012050',
                              'P012051',
                              'P012052',
                              'P012053',
                              'P012054',
                              'P012055') THEN
      lobjDetalle.cdConceptoAdicional := 'C';
    END IF;

    IF lnuContadorDetalle = 1 THEN
     lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
    ELSE
     lobjTabDetalles.Extend;
     lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
    END IF;

   END LOOP;
   -- 25/11/2024 josebuvi se agrega argumento para obtener unicamente garantia
   FOR reg IN lcuDetalleSumadosDeducible(doc.CDGARANTIA) LOOP
    IF NVL(REG.DEDUCIBLE,0) <> 0 THEN
    INSERT INTO T999_INCONSISTENCIAS (cdramo, cdsubramo, nmnegocio, feingreso, dsparametros, dsmensaje_tecnico, cdaplicacion)
            VALUES ('', '', '', SYSDATE, 'FOR lcuDetalleSumadosDeducible lvaCdRamo '||lvaCdRamo||' lvaCdSubramo '
            ||lvaCdSubramo||' lvaCdGarantia '||lvaCdGarantia||' lvaCdSubGarantia '||lvaCdSubGarantia||' ', '', 'TRAZA_RETENCION_083');
     lvaCdRamo                       := reg.CDRAMO;
     lvaCdSubramo                    := reg.CDSUBRAMO;
     lvaCdGarantia                   := reg.CDGARANTIA;
     lvaCdSubGarantia                := reg.CDSUBGARANTIA;

     lobjDetalle.cdIndicadorImpuesto := lvaCodIva;
     lvaAplicaReservaSinRetencion    := NVL(PCK_PARAMETROS.FN_GET_PARAMETROV2('%',
                                                                              '%',
                                                                              'RESERVASINRETEN',
                                                                              SYSDATE,
                                                                              reg.NUMERO_RESERVA,
                                                                              '%',
                                                                              '%',
                                                                              '%',
                                                                              '%'), 'N');
     -- 01/12/2024 josebuvi VERIFICACION DE VIDA PARA INDICADOR IMPUESTO
     -- linaduto - 2025/03/11 - HU756348 -Ajuste retenci?n en la fuente para ID NIT - subramos PCP y deudores
     -- linaduto - 2025/03/20 - HU764049 -Ajuste retenci?n en la fuente para ID NIT - Ramo BAN
     -- luishure - 2025/12/10 - HU984785 - Exclusión de retención para Fondo de Ahorro
     IF (lvaCdRamo = '083' OR lvaCdRamo = 'BAN') AND lvaCdGarantia = 'VID' AND lvaAplicaReservaSinRetencion = 'N' THEN
       IF (lvaAplicaSinRetencion = 'N' OR (lvaAplicaSinRetencion = 'S' AND substr(lvaDni,1,1) <> 'A')) THEN 
          lnuContadorRetencionVida             := lnuContadorRetencionVida + 1;
          IF lnuContadorRetencionVida = 1 THEN
            lnuContadorRetencion               := lnuContadorRetencion + 1;
            lobjRetencion.cdtipoRetencion      := 'F5';
            lobjRetencion.cdindicadorRetencion := 'VI';
            IF lnuContadorRetencion = 1 THEN
              lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
            ELSE
              lobjRetenciones.Extend;
              lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
            END IF;
            lobjDocumento.retenciones := lobjRetenciones;
          END IF;	
        END IF;  
      END IF;
     IF reg.numero_reserva = 'P012100' THEN
       lobjDetalle.cdConcepto          := '13';
     ELSE
       lobjDetalle.cdConcepto          := '8';
     END IF;
     lvaSnCuentaContable             := 'N';

     OPEN lcuTipoReserva;
     FETCH lcuTipoReserva INTO lvaCdTipoReserva,lvaCdramoContable;
     CLOSE lcuTipoReserva;

     lnuContadorDetalle              := lnuContadorDetalle + 1;
     lobjDetalle.cdTipoReserva       := lvaCdTipoReserva;

     OPEN lcuSnCuentaContable;
     FETCH lcuSnCuentaContable INTO lvaSnCuentaContable;
     CLOSE lcuSnCuentaContable;

     IF lvaCdRamo = '081' AND lvaCdTipoReserva = 'T' THEN
--      lobjDetalle.cdRamo              := 'MVI';
      lobjDetalle.cdRamo              := 'AAV';
     ELSE
      lobjDetalle.cdRamo              := lvaCdramoContable;
     END IF;

     lobjDetalle.nmPoliza            := lvaNmPoliza;

     lobjDetalle.cdIntermediario     := lvaCdAgente;
     lobjDetalle.cdOficinaRadicacion := lvaCdDelegacionRadica;
     lobjDetalle.nmExpediente        := lvaNmExpediente;

     lobjDetalle.nmAsegurado         := lvaNmAsegurado;
     lobjDetalle.ptImporte           := reg.DEDUCIBLE;

    -- Variable de control para evitar Saldo en moneda de transaccion
    lnuTotalPago                    := lnuTotalPago + lobjDetalle.ptImporte;

     lobjDetalle.cdCentroCostos      := lvaCdDelegacionRadica;

     lobjDetalle.feAviso             := ldaFenotificacion;
     lobjDetalle.feOcurrencia        := ldaFeOcurrencia;

     -- Panam? 20130722 Compa??a = 30 En Colombia es cdciaMatriz en SAP es 3000
     PCK_GESTION_PRODUCTOS.SPGET_COMPANIA_PRODUCTO( reg.cdramo,reg.cdsubramo,lvaCdCompania,lvaCdciaMatriz,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);
     IF lvaCdciaMatriz = '00' THEN
      lobjDetalle.cdCompaniaParametro := lvaCdCompania;
     ELSIF lvaCdciaMatriz = '30' THEN
      lobjDetalle.cdCompaniaParametro := lvaCdciaMatriz;
     ELSE
      lobjDetalle.cdCompaniaParametro := lvaCdCompania;
     END IF;

     IF lvaCdciaMatriz = '00' THEN
      IF lvaSnCuentaContable = 'S' THEN
       lobjDetalle.cdRamoParametro := lvaCdramoContable;
      ELSE
       lobjDetalle.cdRamoParametro := 'N';
      END IF;
     ELSIF lvaCdciaMatriz = '30' THEN
      --Para panam? el indicador de impuesto para el deducible es cero.
      lobjDetalle.cdIndicadorImpuesto := '0';
      IF lvaCdRamo = '081' THEN
       lvaSnPrimerVigencia := 'S';
       OPEN lcuPrimerVigencia;
       FETCH lcuPrimerVigencia INTO lvaSnPrimerVigencia;
       IF lcuPrimerVigencia%NOTFOUND THEN
        lvaSnPrimerVigencia := 'N';
       END IF;
       CLOSE lcuPrimerVigencia;
       --Para identificar si es Universal o tradicional.
       OPEN lcuGrupoProducto;
       FETCH lcuGrupoProducto INTO lvaGrupoProducto;
       CLOSE lcuGrupoProducto;

       IF lvaSnPrimerVigencia = 'S' THEN
        lobjDetalle.cdRamoParametro := lvaGrupoProducto||'A';
       ELSE
        lobjDetalle.cdRamoParametro := lvaGrupoProducto||'R';
       END IF;
      ELSE
       -- Solicitud via email de German Duque y Manuel Guevara el viernes, 17 de abril de 2015 04:19 p.m.
       -- con titulo Seguimiento BI Panam?
       lobjDetalle.cdRamoParametro := lvaCdramoContable;
--      lobjDetalle.cdRamoParametro := lvaCdRamo;
      END IF;
     END IF;

     lobjDetalle.cdOperacion   := reg.cdoperacion;

--    lobjDetalle.cdConcepto    := lvaCdConcepto;

     --Se comenta por solicitud de cat?logo de servicio 85529 Solicitada por Mario Franco y afirmada por SAP
     -- y se deja concatenando el codigo del usuario
     lobjDetalle.dsTextoPosicion            := lvaNmExpediente||'-'||lvaDsLoginUsuario;
     --lobjDetalle.dsTextoPosicion             := lvaNmExpediente||'-'||'DEDUCIBLE';

     IF lnuContadorDetalle = 1 THEN
      lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
     ELSE
      lobjTabDetalles.Extend;
      lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
     END IF;
    END IF;
   END LOOP;
   -- 25/11/2024 josebuvi se agrega argumento para obtener unicamente garantia
   FOR reg IN lcuDetalleSumadosDescuento(doc.CDGARANTIA) LOOP
    IF reg.PTDESCUENTO <> 0 AND lvaSnPolizaSalud = 'N' THEN
    INSERT INTO T999_INCONSISTENCIAS (cdramo, cdsubramo, nmnegocio, feingreso, dsparametros, dsmensaje_tecnico, cdaplicacion)
            VALUES ('', '', '', SYSDATE, 'FOR lcuDetalleSumadosDescuento lvaCdRamo '||lvaCdRamo||' lvaCdSubramo '
            ||lvaCdSubramo||' lvaCdGarantia '||lvaCdGarantia||' lvaCdSubGarantia '||lvaCdSubGarantia||' ', '', 'TRAZA_RETENCION_083');
     lvaCdRamo                       := reg.CDRAMO;
     lvaCdSubramo                    := reg.CDSUBRAMO;
     lvaCdGarantia                   := reg.CDGARANTIA;
     lvaCdSubGarantia                := reg.CDSUBGARANTIA;
     lobjDetalle.cdIndicadorImpuesto := '0000';--lvaCodIva;
     lvaAplicaReservaSinRetencion    := NVL(PCK_PARAMETROS.FN_GET_PARAMETROV2('%',
                                                                              '%',
                                                                              'RESERVASINRETEN',
                                                                              SYSDATE,
                                                                              reg.NUMERO_RESERVA,
                                                                              '%',
                                                                              '%',
                                                                              '%',
                                                                              '%'), 'N');
     -- 01/12/2024 josebuvi VERIFICACION DE VIDA PARA INDICADOR IMPUESTO
     -- linaduto - 2025/03/11 - HU756348 -Ajuste retenci?n en la fuente para ID NIT - subramos PCP y deudores
     -- linaduto - 2025/03/20 - HU764049 -Ajuste retenci?n en la fuente para ID NIT - Ramo BAN
     -- luishure - 2025/12/10 - HU984785 - Exclusión de retención para Fondo de Ahorro
     IF (lvaCdRamo = '083' OR lvaCdRamo = 'BAN') AND lvaCdGarantia = 'VID' AND lvaAplicaReservaSinRetencion = 'N' THEN
       IF (lvaAplicaSinRetencion = 'N' OR (lvaAplicaSinRetencion = 'S' AND substr(lvaDni,1,1) <> 'A')) THEN 
          lnuContadorRetencionVida             := lnuContadorRetencionVida + 1;
          IF lnuContadorRetencionVida = 1 THEN
            lnuContadorRetencion               := lnuContadorRetencion + 1;
            lobjRetencion.cdtipoRetencion      := 'F5';
            lobjRetencion.cdindicadorRetencion := 'VI';
            IF lnuContadorRetencion = 1 THEN
              lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
            ELSE
              lobjRetenciones.Extend;
              lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
            END IF;
            lobjDocumento.retenciones := lobjRetenciones;
          END IF;
        END IF;	  
      END IF;

     IF reg.numero_reserva = 'P012100' THEN
        lobjDetalle.cdConcepto          := '13';
     ELSE
        lobjDetalle.cdConcepto          := '9';
     END IF;
     lvaSnCuentaContable             := 'N';

     OPEN lcuTipoReserva;
     FETCH lcuTipoReserva INTO lvaCdTipoReserva,lvaCdramoContable;
     CLOSE lcuTipoReserva;

     lnuContadorDetalle              := lnuContadorDetalle + 1;
     lobjDetalle.cdTipoReserva       := lvaCdTipoReserva;

     OPEN lcuSnCuentaContable;
     FETCH lcuSnCuentaContable INTO lvaSnCuentaContable;
     CLOSE lcuSnCuentaContable;

     IF lvaCdRamo = '081' AND lvaCdTipoReserva = 'T' THEN
--      lobjDetalle.cdRamo              := 'MVI';
      lobjDetalle.cdRamo              := 'AAV';
     ELSE
      lobjDetalle.cdRamo              := lvaCdramoContable;
     END IF;

     lobjDetalle.nmPoliza            := lvaNmPoliza;

     lobjDetalle.cdIntermediario     := lvaCdAgente;
     lobjDetalle.cdOficinaRadicacion := lvaCdDelegacionRadica;
     lobjDetalle.nmExpediente        := lvaNmExpediente;

     lobjDetalle.nmAsegurado         := lvaNmAsegurado;
     lobjDetalle.ptImporte           := reg.PTDESCUENTO;

    -- Variable de control para evitar Saldo en moneda de transaccion
     lnuTotalPago                    := lnuTotalPago + lobjDetalle.ptImporte;

     lobjDetalle.cdCentroCostos      := lvaCdDelegacionRadica;

     lobjDetalle.feAviso             := ldaFenotificacion;
     lobjDetalle.feOcurrencia        := ldaFeOcurrencia;

     -- Panam? 20130722 Compa??a = 30 En Colombia es cdciaMatriz en SAP es 3000
     PCK_GESTION_PRODUCTOS.SPGET_COMPANIA_PRODUCTO( reg.cdramo,reg.cdsubramo,lvaCdCompania,lvaCdciaMatriz,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);
     IF lvaCdciaMatriz = '00' THEN
      lobjDetalle.cdCompaniaParametro := lvaCdCompania;
     ELSIF lvaCdciaMatriz = '30' THEN
      lobjDetalle.cdCompaniaParametro := lvaCdciaMatriz;
     ELSE
      lobjDetalle.cdCompaniaParametro := lvaCdCompania;
     END IF;

     IF lvaCdciaMatriz = '00' THEN
      IF lvaSnCuentaContable = 'S' THEN
       lobjDetalle.cdRamoParametro := lvaCdramoContable;
      ELSE
       lobjDetalle.cdRamoParametro := 'N';
      END IF;
     ELSIF lvaCdciaMatriz = '30' THEN
      IF lvaCdRamo = '081' THEN
       lvaSnPrimerVigencia := 'S';
       OPEN lcuPrimerVigencia;
       FETCH lcuPrimerVigencia INTO lvaSnPrimerVigencia;
       IF lcuPrimerVigencia%NOTFOUND THEN
        lvaSnPrimerVigencia := 'N';
       END IF;
       CLOSE lcuPrimerVigencia;
       --Para identificar si es Universal o tradicional.
       OPEN lcuGrupoProducto;
       FETCH lcuGrupoProducto INTO lvaGrupoProducto;
       CLOSE lcuGrupoProducto;

       IF lvaSnPrimerVigencia = 'S' THEN
        lobjDetalle.cdRamoParametro := lvaGrupoProducto||'A';
       ELSE
        lobjDetalle.cdRamoParametro := lvaGrupoProducto||'R';
       END IF;
      ELSE
       -- Solicitud via email de German Duque y Manuel Guevara el viernes, 17 de abril de 2015 04:19 p.m.
       -- con titulo Seguimiento BI Panam?
       lobjDetalle.cdRamoParametro := lvaCdramoContable;
--      lobjDetalle.cdRamoParametro := lvaCdRamo;
      END IF;
     END IF;

     lobjDetalle.cdOperacion   := reg.cdoperacion;

--    lobjDetalle.cdConcepto    := lvaCdConcepto;

     --Se comenta por solicitud de cat?logo de servicio 85529 Solicitada por Mario Franco y afirmada por SAP
     -- y se deja concatenando el codigo del usuario
     lobjDetalle.dsTextoPosicion            := lvaNmExpediente||'-'||lvaDsLoginUsuario;
     --lobjDetalle.dsTextoPosicion             := lvaNmExpediente||'-'||' DESCUENTO FINANCIERO';

     IF lnuContadorDetalle = 1 THEN
      lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
     ELSE
      lobjTabDetalles.Extend;
      lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
     END IF;
    END IF;
   END LOOP;

   --  Coaseguro

    -- Cedido
   IF lvaIdSoloSura <> '01' THEN
   -- 25/11/2024 josebuvi se agrega argumento para obtener unicamente garantia
    FOR reg IN lcuDetalleSumadosCoaseguro(doc.CDGARANTIA) LOOP
     IF reg.COASEGURO <> 0 THEN
      lvaCdRamo                       := reg.CDRAMO;
      lvaCdSubramo                    := reg.CDSUBRAMO;
      lvaCdGarantia                   := reg.CDGARANTIA;
      lvaCdSubGarantia                := reg.CDSUBGARANTIA;
      INSERT INTO T999_INCONSISTENCIAS (cdramo, cdsubramo, nmnegocio, feingreso, dsparametros, dsmensaje_tecnico, cdaplicacion)
            VALUES ('', '', '', SYSDATE, 'FOR lcuDetalleSumadosCoaseguro lvaCdRamo '||lvaCdRamo||' lvaCdSubramo '
            ||lvaCdSubramo||' lvaCdGarantia '||lvaCdGarantia||' lvaCdSubGarantia '||lvaCdSubGarantia||' ', '', 'TRAZA_RETENCION_083');

      lobjDetalle.cdIndicadorImpuesto := /*'0000';--*/lvaCodIva;
      lvaAplicaReservaSinRetencion    := NVL(PCK_PARAMETROS.FN_GET_PARAMETROV2('%',
                                                                               '%',
                                                                               'RESERVASINRETEN',
                                                                               SYSDATE,
                                                                               reg.NUMERO_RESERVA,
                                                                               '%',
                                                                               '%',
                                                                               '%',
                                                                               '%'), 'N');
     -- 01/12/2024 josebuvi VERIFICACION DE VIDA PARA INDICADOR IMPUESTO
     -- linaduto - 2025/03/11 - HU756348 -Ajuste retenci?n en la fuente para ID NIT - subramos PCP y deudores
     -- linaduto - 2025/03/20 - HU764049 -Ajuste retenci?n en la fuente para ID NIT - Ramo BAN
     -- luishure - 2025/12/10 - HU984785 - Exclusión de retención para Fondo de Ahorro
     IF (lvaCdRamo = '083' OR lvaCdRamo = 'BAN') AND lvaCdGarantia = 'VID' AND lvaAplicaReservaSinRetencion = 'N' THEN
       IF (lvaAplicaSinRetencion = 'N' OR (lvaAplicaSinRetencion = 'S' AND substr(lvaDni,1,1) <> 'A')) THEN 
          lnuContadorRetencionVida             := lnuContadorRetencionVida + 1;
          IF lnuContadorRetencionVida = 1 THEN
            lnuContadorRetencion               := lnuContadorRetencion + 1;
            lobjRetencion.cdtipoRetencion      := 'F5';
            lobjRetencion.cdindicadorRetencion := 'VI';
            IF lnuContadorRetencion = 1 THEN
              lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
            ELSE
              lobjRetenciones.Extend;
              lobjRetenciones(lnuContadorRetencion) := lobjRetencion;
            END IF;
            lobjDocumento.retenciones := lobjRetenciones;
          END IF;	 
        END IF; 
      END IF;
      IF reg.numero_reserva = 'P012100' THEN
        lobjDetalle.cdConcepto          := '13';
      ELSE
         lobjDetalle.cdConcepto          := '1C';
      END IF;
      lvaSnCuentaContable             := 'N';

      OPEN lcuTipoReserva;
      FETCH lcuTipoReserva INTO lvaCdTipoReserva,lvaCdramoContable;
      CLOSE lcuTipoReserva;

      lnuContadorDetalle              := lnuContadorDetalle + 1;
      lobjDetalle.cdTipoReserva       := lvaCdTipoReserva;

      OPEN lcuSnCuentaContable;
      FETCH lcuSnCuentaContable INTO lvaSnCuentaContable;
      CLOSE lcuSnCuentaContable;

      IF lvaCdRamo = '081' AND lvaCdTipoReserva = 'T' THEN
       lobjDetalle.cdRamo              := 'AAV';
      ELSE
       lobjDetalle.cdRamo              := lvaCdramoContable;
      END IF;

      lobjDetalle.nmPoliza            := lvaNmPoliza;

      lobjDetalle.cdIntermediario     := lvaCdAgente;
      lobjDetalle.cdOficinaRadicacion := lvaCdDelegacionRadica;
      lobjDetalle.nmExpediente        := lvaNmExpediente;

      -- Para coaseguro, se tiene en el campo nmAsegurado el DNI de la Coaseguradora
      lvaCdCiaCoaseguradora := reg.CDCIA;
      OPEN lcuCiaCoaseguradora;
      FETCH lcuCiaCoaseguradora INTO lvaDniCoaseguro;--lobjDetalle.nmAsegurado;
      CLOSE lcuCiaCoaseguradora;
      lobjDetalle.nmAsegurado := PCK_SIC_UTILITARIOS_I.FN_SIC_NMIDENTIFICACION(lvaDniCoaseguro);

      lobjDetalle.ptImporte           := reg.COASEGURO;

      -- Variable de control para evitar Saldo en moneda de transaccion
       lnuTotalPago     := lnuTotalPago - lobjDetalle.ptImporte;

      lobjDetalle.cdCentroCostos      := lvaCdDelegacionRadica;

      lobjDetalle.feAviso             := ldaFenotificacion;
      lobjDetalle.feOcurrencia        := ldaFeOcurrencia;

      -- Panam? 20130722 Compa??a = 30 En Colombia es cdciaMatriz en SAP es 3000
      PCK_GESTION_PRODUCTOS.SPGET_COMPANIA_PRODUCTO( reg.cdramo,reg.cdsubramo,lvaCdCompania,lvaCdciaMatriz,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);
      IF lvaCdciaMatriz = '00' THEN
       lobjDetalle.cdCompaniaParametro := lvaCdCompania;
      ELSIF lvaCdciaMatriz = '30' THEN
       lobjDetalle.cdCompaniaParametro := lvaCdciaMatriz;
      ELSE
       lobjDetalle.cdCompaniaParametro := lvaCdCompania;
      END IF;

      IF lvaCdciaMatriz = '00' THEN
       IF lvaSnCuentaContable = 'S' THEN
        lobjDetalle.cdRamoParametro := lvaCdramoContable;
       ELSE
        lobjDetalle.cdRamoParametro := 'N';
       END IF;
      ELSIF lvaCdciaMatriz = '30' THEN
       --20131023 De acuerdo a email de German Duque siempre va  lobjDetalle.cdRamoParametro = N
       -- por eso se comenta todo el IF para ramo 081 y 012
--       lobjDetalle.cdRamoParametro := 'N';
       IF lvaCdRamo = '081' THEN
        lvaSnPrimerVigencia := 'S';
        OPEN lcuPrimerVigencia;
        FETCH lcuPrimerVigencia INTO lvaSnPrimerVigencia;
        IF lcuPrimerVigencia%NOTFOUND THEN
         lvaSnPrimerVigencia := 'N';
        END IF;
        CLOSE lcuPrimerVigencia;
        --Para identificar si es Universal o tradicional.
        OPEN lcuGrupoProducto;
        FETCH lcuGrupoProducto INTO lvaGrupoProducto;
        CLOSE lcuGrupoProducto;

        IF lvaSnPrimerVigencia = 'S' THEN
         lobjDetalle.cdRamoParametro := lvaGrupoProducto||'A';
        ELSE
         lobjDetalle.cdRamoParametro := lvaGrupoProducto||'R';
        END IF;
       ELSE
        -- Solicitud via email de German Duque y Manuel Guevara el viernes, 17 de abril de 2015 04:19 p.m.
        -- con titulo Seguimiento BI Panam?
        lobjDetalle.cdRamoParametro := lvaCdramoContable;
--      lobjDetalle.cdRamoParametro := lvaCdRamo;
       END IF;
      END IF;

      lobjDetalle.cdOperacion   := reg.cdoperacion;

      --Se comenta por solicitud de cat?logo de servicio 85529 Solicitada por Mario Franco y afirmada por SAP
      -- y se deja concatenando el codigo del usuario
      lobjDetalle.dsTextoPosicion            := lvaNmExpediente||'-'||lvaDsLoginUsuario;
      --lobjDetalle.dsTextoPosicion             := lvaNmExpediente||'-'||' COASEGURO CEDIDO';

      IF lnuContadorDetalle = 1 THEN
       lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
      ELSE
       lobjTabDetalles.Extend;
       lobjTabDetalles(lnuContadorDetalle) := lobjDetalle;
      END IF;
     END IF;
    END LOOP;
    -- Variable de control para evitar Saldo en moneda de transaccion
    IF lnuTotalPago <> 0 THEN
     lobjTabDetalles(lnuContadorDetalle).ptImporte  := lobjTabDetalles(lnuContadorDetalle).ptImporte + lnuTotalPago;
    END IF;
   END IF;
   -- Fin de coaseguro


   lobjDocumento.detalleSiniestros        := lobjTabDetalles;

/*   FOR i IN lobjTabDetalles.FIRST..lobjTabDetalles.LAST LOOP
       DBMS_OUTPUT.put_line('Detalle 2: '||lobjTabDetalles(i).ptImporte);
   END LOOP;
*/
   lobjDocumento.cuentaBancaria           := lobjCuentaBancaria;

   IF lnuContadorDocumentos = 1 THEN
    lobjDocumentos(lnuContadorDocumentos) := lobjDocumento;
   ELSE
    lobjDocumentos.Extend;
    lobjDocumentos(lnuContadorDocumentos) := lobjDocumento;
   END IF;

  lnuContadorRetencionVida := 0;
  END LOOP;-- lcuDatosDocumentoRes

----------------------------------------------------------------------------------------------------------------------
  --Datos de tercero
  OPEN lcuCdUsuario;
  FETCH lcuCdUsuario INTO lvaCdUsuario;
  CLOSE lcuCdUsuario;


  PCK_SIC_SAP.SP_SIC_POBLA_TERCERO_SAP(lvaDni,
                                       lvaCdUsuario,
                                       ltyTercero,
                                       lvaMensajeTecnicoExt,
                                       lvaMensajeUsuarioExt);
  IF lvaMensajeTecnicoExt IS NOT NULL OR lvaMensajeUsuarioExt IS NOT NULL THEN
   RAISE lexErrorProcedimientoExt;
  END IF;

  lobjtercero.dsTratamiento           := ltyTercero.dsTratamiento;
  lobjtercero.dsNombre                := ltyTercero.dsNombre;
  lobjtercero.dsApellidos             := ltyTercero.dsApellidos;
  lobjtercero.dsNombres               := ltyTercero.dsNombres;
  lobjtercero.dsDireccion             := ltyTercero.dsDireccion;
  lobjtercero.dsApartadoAereo         := ltyTercero.dsApartadoAereo;
  lobjtercero.cdPais                  := ltyTercero.cdPais;
  lobjtercero.cdRegion                := ltyTercero.cdRegion;
  lobjtercero.cdPoblacion             := ltyTercero.cdPoblacion;
  lobjtercero.cdIdioma                := ltyTercero.cdIdioma;

  lobjInfoFiscal.nmIdentificacion     := ltyTercero.nmIdentificacion;
  lobjInfoFiscal.cdTipoIdentificacion := ltyTercero.cdTipoId;

  -- 17/07/2025 Mateo Zapata - Homologacion de tipo de documento TT para SAP
   IF UPPER(lobjInfoFiscal.cdTipoIdentificacion) = 'TT' THEN
     lobjInfoFiscal.cdTipoIdentificacion := 'PT';
   END IF;

  lobjtercero.cuentaBancaria          := lobjCuentaBancaria;
  lobjtercero.informacionFiscal       := lobjInfoFiscal;

  --lobjPago                            := OBJ_SAP_CXP_SINIESTROS() ;
  lobjPago.Tyinf                      := lobjTyinf;
  lobjPago.cabecera                   := lobjCabecera;
  lobjPago.documentosCXP              := lobjDocumentos;
  lobjPago.tercero                    := lobjtercero;
--DBMS_OUTPUT.put_line('lvaTipoCoaseguro='|| lvaTipoCoaseguro||' lobjDetalle.cdConcepto='||lobjDetalle.cdConcepto);

  RETURN lobjPago;


  EXCEPTION
      WHEN lexErrorProcedimientoExt THEN
        ovaMensajeTecnico:=lvaMensajeTecnicoExt;
        ovaMensajeUsuario:=lvaMensajeUsuarioExt;
        RETURN NULL;
      WHEN lexErrorProcedimiento THEN
        ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
        ovaMensajeUsuario:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeUsuario;
        RETURN NULL;
      WHEN OTHERS THEN
       ovaMensajeTecnico:= gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico;
       ovaMensajeUsuario:= SQLERRM;--'TRANSACCION NO DISPONIBLE ' ;
       RETURN NULL;
  END FN_CREAR_MENSAJE_CXP_083;

-------------------------------------------------------------------------------------------------------------------------------------------------
END PCK_SIN_ADAPTADOR_SAP;
/