
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
    -- 22/11/2024 josebuvi Desarrollo para verificacion de retencion ramos de vida
    lvaCdRamo                   SINIESTROS.CDRAMO%TYPE := '000';
  
  CURSOR lcuContabilizarPagoSap IS
    SELECT P.DSVALOR_PARAMETRO
      FROM T999_PARAMETROS P
     WHERE P.DSPARAMETRO = 'PAGO_SURABROKER';
    
	BEGIN
        -- 22/11/2024 josebuvi Desarrollo para verificacion de retencion ramos de vida
        BEGIN 
            SELECT CDRAMO into lvaCdRamo 
            FROM SINIESTROS 
            WHERE EXPEDIENTE = ivaNmExpediente 
                  AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                lvaCdRamo := '000';
            WHEN OTHERS THEN
                lvaCdRamo := '000';
        END;
        IF (lvaCdRamo = '083') THEN 
            lobjPago := PCK_SIN_ADAPTADOR_SAP.FN_CREAR_MENSAJE_CXP_083(ivaNmExpediente,ivaNmPagoAutorizacion,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);
        ELSE
            lobjPago := PCK_SIN_ADAPTADOR_SAP.FN_CREAR_MENSAJE_CXP(ivaNmExpediente,ivaNmPagoAutorizacion,lvaMensajeTecnicoExt,lvaMensajeUsuarioExt);
        END IF;
        
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
		IF NVL(lvaUsaApiGeeSiniCxP, 'N') = 'S' THEN
          lobjCaus := PCK_SIN_ADAPTADOR_CPI.MAP_SAP_CXP_TO_CAUSACION(lobjPago);
          PCK_INTEGRATION_CPI.SP_EJECUTAR_SERVICIO_ASINCRONO(lobjCaus, 'TATR_ASYNC_TX_1');
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
			 --Llamado a Cronos
       ovaMensajeTecnico:= substr(gvaPackage ||'.'||lvaNombreObjeto ||':' || lpad(to_char(abs(SQLCODE)),7,'0' )||':'||lvaMensajeTecnico,1,255);
       ovaMensajeUsuario:= substr(SQLERRM,1,255);-- 'TRANSACCION NO DISPONIBLE ' ;
			 PCKCRO_INTERFAZ_CRONOS.SPCRO_ERROR('SINIESTROS',
																					'GestorSiniestros',
																					lpad(to_char(abs(SQLCODE)),7,'0' ),
																					'SINIESTROS',
																					SUBSTR(ivaNmExpediente||'-'||ivaNmPagoAutorizacion||'-'||lvaMensajeUsuario,1,255),
																					lvaMensajeTecnico);

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

	--Variables para el manejo de Errores
  lvaMensajeTecnico           VARCHAR2(255)  := NULL;
	lvaMensajeTecnicoExt        VARCHAR2(255)  := NULL;
	lvaMensajeUsuario           VARCHAR2(255)  := NULL;
	lvaMensajeUsuarioExt        VARCHAR2(255)  := NULL;
	lexErrorProcedimiento       EXCEPTION;
	lexErrorProcedimientoExt    EXCEPTION;
	lvaNombreObjeto             VARCHAR2(30)   :='FN_CONSULTAR_EST_CXP';

	lvaerror                    VARCHAR2(2000)  := NULL;

	lobjMensaje                 OBJ_SAP_CONSULTA_EST_CXP := NULL;
  lobjResultados		          TAB_SBK_ANYDATA;
  lobjTransaccion	            OBJ_SAP_RESP_CONSULTA_EST_CXP := OBJ_SAP_RESP_CONSULTA_EST_CXP();
  linStatus			                INTEGER;

	BEGIN

	   lvaMensajeTecnico := 'Llamando al Adaptador';
     lobjMensaje := PCK_SIN_ADAPTADOR_SAP.FN_CREAR_MENSAJE_CONSULTA_CXP(ivaClave1,
		                                                                    ivaClave2,
																																				ivaConsumidor,
																																				lvaMensajeTecnicoExt,
																																				lvaMensajeUsuarioExt);
		 IF lvaMensajeTecnicoExt IS NOT NULL OR lvaMensajeUsuarioExt IS NOT NULL THEN
		    RAISE lexErrorProcedimientoExt;
		 END IF;

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
																					SUBSTR(ivaClave1||'-'||ivaClave2||'-'||lvaMensajeUsuario,1,255),
																					lvaMensajeTecnico);

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

END PCK_SIN_GESTOR_SAP;
/