
  CREATE OR REPLACE EDITIONABLE TYPE "TAB_SBK_ANYDATA" is table of SYS.ANYDATA;
/

CREATE OR REPLACE EDITIONABLE TYPE "OBJ_SBK_ENC_MENSAJE" as object
(
  -- Author  : RAUL DE VILLA
  -- Created : 2009-07-16 11:31:55 a.m.
  -- Purpose : Esta clase representa uno de los encabezados que ser�n
  --           enviados como parte de la llamada al servicio remoto.

  CDCLAVE      varchar2(255),
  DSVALOR      varchar2(255),

  MEMBER FUNCTION toString RETURN VARCHAR2

)NOT FINAL;
/
CREATE OR REPLACE EDITIONABLE TYPE BODY "OBJ_SBK_ENC_MENSAJE" IS

  MEMBER FUNCTION toString RETURN VARCHAR2 IS
  BEGIN
     RETURN CDCLAVE || '=' || DSVALOR;
  END;

END;
/


  CREATE OR REPLACE EDITIONABLE TYPE "TAB_SBK_ENC_MENSAJE" is table of OBJ_SBK_ENC_MENSAJE;
/



  CREATE OR REPLACE EDITIONABLE TYPE "OBJ_SBK_MENSAJE_INF" as object
(
  -- Author  : RAUL DE VILLA
  -- Created : 26-Ago-2009
  -- Purpose : Almacena la informaci�n no funcional requerida para la transmisi�n y procesamiento de mensajes

  -- Identificaci�n de la aplicaci�n que env�a el mensaje
  CDCONSUMIDOR               varchar2(255),

  -- Servicio al que se debe entregar este mensaje
  CDSERVICIO                 varchar2(255),

  -- Operaci�n que se desea ejecutar con el llamado al servicio
  CDOPERACION                varchar2(255),

  -- Clave de relaci�n de este mensaje con el mensaje padre
  DSCLAVE                    varchar2(255),

  -- Fecha en que se crea este detalle de mensaje
  FECREACION                 date,

  -- Orden de ejecuci�n para este detalle de mensaje
  NMPRIORIDAD                number(10),

  -- Token de seguridad necesario para para consumir el servicio
  CDTOKEN                    varchar2(255),

  -- Versi�n del servicio a la que se dirige el mensaje
  CDVERSION_SERVICIO         varchar2(50),

  -- Corresponde al namespace del servicio que se quiere ejecutar.
  DSNAME_SPACE               varchar2(512),

  -- Puerto del servicio a donde se dirige el mensaje
  DSPUERTO                   varchar2(100),

  TYENCABEZADOS              TAB_SBK_ENC_MENSAJE,

  /* Cola OAQ a la que se dirige el mensaje
  *  El valor es una de las variables definidas en el paquete
  *  PCK_SBK_SURABROKER con el prefijo NOMBRE_COLA_******
  */
  DSCOLA                     varchar2(100),

  /*
  * Nombre del procedimeinto invocado cuando la invocacion
  * del servicio es realizada con CALLBACK
  */
  URL_SERV_RESP               varchar2(100),

  /*
  * Prioridad de encolamiento del mensaje
  */
  NMPRIORIDAD_ENCOLAMIENTO    number(1),


  -- Constructor del type que no necesita encabezados
  CONSTRUCTOR FUNCTION OBJ_SBK_MENSAJE_INF(ivaCdConsumidor      in varchar2,
                                           ivaCdServicio        in varchar2,
                                           ivaCdOperacion       in varchar2,
                                           ivaDsClave           in varchar2,
                                           idtFeCreacion        in date,
                                           ivaNmPrioridad       in varchar2,
                                           ivaCdToken           in varchar2,
                                           ivaCdVersionServicio in varchar2,
                                           ivaDsNameSpace       in varchar2
                                           ) RETURN self AS result,

  -- Constructor del type que no necesita encabezados
  CONSTRUCTOR FUNCTION OBJ_SBK_MENSAJE_INF(ivaCdConsumidor      in varchar2,
                                           ivaCdServicio        in varchar2,
                                           ivaCdOperacion       in varchar2,
                                           ivaDsClave           in varchar2,
                                           idtFeCreacion        in date,
                                           ivaNmPrioridad       in varchar2,
                                           ivaCdToken           in varchar2,
                                           ivaCdVersionServicio in varchar2,
                                           ivaDsNameSpace       in varchar2,
                                           ivaDsPuerto          in varchar2
                                           ) RETURN self AS result,

  -- Constructor del type con encabezados
  CONSTRUCTOR FUNCTION OBJ_SBK_MENSAJE_INF(ivaCdConsumidor      in varchar2,
                                           ivaCdServicio        in varchar2,
                                           ivaCdOperacion       in varchar2,
                                           ivaDsClave           in varchar2,
                                           idtFeCreacion        in date,
                                           ivaNmPrioridad       in varchar2,
                                           ivaCdToken           in varchar2,
                                           ivaCdVersionServicio in varchar2,
                                           ivaDsNameSpace       in varchar2,
                                           ivaDsPuerto          in varchar2,
                                           ityEncabezados       TAB_SBK_ENC_MENSAJE
                                           ) RETURN self AS result,

    -- Constructor del type con encabezados y definicion de cola
  CONSTRUCTOR FUNCTION OBJ_SBK_MENSAJE_INF(ivaCdConsumidor      in varchar2,
                                           ivaCdServicio        in varchar2,
                                           ivaCdOperacion       in varchar2,
                                           ivaDsClave           in varchar2,
                                           idtFeCreacion        in date,
                                           ivaNmPrioridad       in varchar2,
                                           ivaCdToken           in varchar2,
                                           ivaCdVersionServicio in varchar2,
                                           ivaDsNameSpace       in varchar2,
                                           ivaDsPuerto          in varchar2,
                                           ityEncabezados       TAB_SBK_ENC_MENSAJE,
                                           ivaDsCola            in varchar2
                                           ) RETURN self AS result,

  CONSTRUCTOR FUNCTION OBJ_SBK_MENSAJE_INF(ivaCdConsumidor      in varchar2,
                                           ivaCdServicio        in varchar2,
                                           ivaCdOperacion       in varchar2,
                                           ivaDsClave           in varchar2,
                                           idtFeCreacion        in date,
                                           ivaNmPrioridad       in varchar2,
                                           ivaCdToken           in varchar2,
                                           ivaCdVersionServicio in varchar2,
                                           ivaDsNameSpace       in varchar2,
                                           ivaDsPuerto          in varchar2,
                                           ityEncabezados       TAB_SBK_ENC_MENSAJE,
                                           ivaDsCola            in varchar2,
										   ivaNmPrioridadEncolamiento  in number
                                           ) RETURN self AS result,

  MEMBER FUNCTION toString RETURN VARCHAR2
)
/

CREATE OR REPLACE EDITIONABLE TYPE BODY "OBJ_SBK_MENSAJE_INF" is

  /**
  * Este constructor inicializa el type sin encabezados
  * Autor: RAUL DE VILLA
  * Fecha: 26-Ago-2009
  */
  CONSTRUCTOR FUNCTION OBJ_SBK_MENSAJE_INF(ivaCdConsumidor      in varchar2,
                                           ivaCdServicio        in varchar2,
                                           ivaCdOperacion       in varchar2,
                                           ivaDsClave           in varchar2,
                                           idtFeCreacion        in date,
                                           ivaNmPrioridad       in varchar2,
                                           ivaCdToken           in varchar2,
                                           ivaCdVersionServicio in varchar2,
                                           ivaDsNameSpace       in varchar2
                                           ) RETURN self AS RESULT IS
  BEGIN
    CDCONSUMIDOR               := ivaCdConsumidor;
    CDSERVICIO                 := ivaCdServicio;
    CDOPERACION                := ivaCdOperacion;
    DSCLAVE                    := ivaDsClave;
    FECREACION                 := idtFeCreacion;
    NMPRIORIDAD                := ivaNmPrioridad;
    CDTOKEN                    := ivaCdToken;
    CDVERSION_SERVICIO         := ivaCdVersionServicio;
    DSNAME_SPACE               := ivaDsNameSpace;
    TYENCABEZADOS              := null;
    DSPUERTO                   := 'HTTP_Port';
    NMPRIORIDAD_ENCOLAMIENTO   := 4;

    return;
  END;

  /**
  * Este constructor inicializa el type sin encabezados
  * Autor: RAUL DE VILLA
  * Fecha: 26-Ago-2009
  */
  CONSTRUCTOR FUNCTION OBJ_SBK_MENSAJE_INF(ivaCdConsumidor      in varchar2,
                                           ivaCdServicio        in varchar2,
                                           ivaCdOperacion       in varchar2,
                                           ivaDsClave           in varchar2,
                                           idtFeCreacion        in date,
                                           ivaNmPrioridad       in varchar2,
                                           ivaCdToken           in varchar2,
                                           ivaCdVersionServicio in varchar2,
                                           ivaDsNameSpace       in varchar2,
                                           ivaDsPuerto          in varchar2
                                           ) RETURN self AS RESULT IS
  BEGIN
    CDCONSUMIDOR               := ivaCdConsumidor;
    CDSERVICIO                 := ivaCdServicio;
    CDOPERACION                := ivaCdOperacion;
    DSCLAVE                    := ivaDsClave;
    FECREACION                 := idtFeCreacion;
    NMPRIORIDAD                := ivaNmPrioridad;
    CDTOKEN                    := ivaCdToken;
    CDVERSION_SERVICIO         := ivaCdVersionServicio;
    DSNAME_SPACE               := ivaDsNameSpace;
    TYENCABEZADOS              := null;
    DSPUERTO                   := ivaDsPuerto;
    NMPRIORIDAD_ENCOLAMIENTO   := 4;

    return;
  END;

  /**
  * Este constructor inicializa el type con encabezados
  * Autor: DANIEL MONSALVE
  * Fecha: 12-Ene-2011
  */
  CONSTRUCTOR FUNCTION OBJ_SBK_MENSAJE_INF(ivaCdConsumidor      in varchar2,
                                           ivaCdServicio        in varchar2,
                                           ivaCdOperacion       in varchar2,
                                           ivaDsClave           in varchar2,
                                           idtFeCreacion        in date,
                                           ivaNmPrioridad       in varchar2,
                                           ivaCdToken           in varchar2,
                                           ivaCdVersionServicio in varchar2,
                                           ivaDsNameSpace       in varchar2,
                                           ivaDsPuerto          in varchar2,
                                           ityEncabezados       TAB_SBK_ENC_MENSAJE
                                           ) RETURN self AS RESULT IS
  BEGIN
    CDCONSUMIDOR               := ivaCdConsumidor;
    CDSERVICIO                 := ivaCdServicio;
    CDOPERACION                := ivaCdOperacion;
    DSCLAVE                    := ivaDsClave;
    FECREACION                 := idtFeCreacion;
    NMPRIORIDAD                := ivaNmPrioridad;
    CDTOKEN                    := ivaCdToken;
    CDVERSION_SERVICIO         := ivaCdVersionServicio;
    DSNAME_SPACE               := ivaDsNameSpace;
    DSPUERTO                   := ivaDsPuerto;
    TYENCABEZADOS              := ityEncabezados;
	NMPRIORIDAD_ENCOLAMIENTO   := 4;

    return;
  END;

  /**
  * Este constructor inicializa el type con encabezados
  * y definicion de cola
  * Autor: DANIEL MONSALVE
  * Fecha: 12-Ene-2011
  */
  CONSTRUCTOR FUNCTION OBJ_SBK_MENSAJE_INF(ivaCdConsumidor      in varchar2,
                                           ivaCdServicio        in varchar2,
                                           ivaCdOperacion       in varchar2,
                                           ivaDsClave           in varchar2,
                                           idtFeCreacion        in date,
                                           ivaNmPrioridad       in varchar2,
                                           ivaCdToken           in varchar2,
                                           ivaCdVersionServicio in varchar2,
                                           ivaDsNameSpace       in varchar2,
                                           ivaDsPuerto          in varchar2,
                                           ityEncabezados       TAB_SBK_ENC_MENSAJE,
                                           ivaDsCola            in varchar2
                                           ) RETURN self AS RESULT IS
  BEGIN
    CDCONSUMIDOR               := ivaCdConsumidor;
    CDSERVICIO                 := ivaCdServicio;
    CDOPERACION                := ivaCdOperacion;
    DSCLAVE                    := ivaDsClave;
    FECREACION                 := idtFeCreacion;
    NMPRIORIDAD                := ivaNmPrioridad;
    CDTOKEN                    := ivaCdToken;
    CDVERSION_SERVICIO         := ivaCdVersionServicio;
    DSNAME_SPACE               := ivaDsNameSpace;
    DSPUERTO                   := ivaDsPuerto;
    TYENCABEZADOS              := ityEncabezados;
    DSCOLA                     := ivaDsCola;
	NMPRIORIDAD_ENCOLAMIENTO   := 4;

    return;
  END;

  /**
  * Este constructor inicializa el type con encabezados, prioridad de encolamiento
  * y definicion de cola
  * Autor: CRISTIAN VELASQUEZ
  * Fecha: 19-Septiembre-2012
  */
  CONSTRUCTOR FUNCTION OBJ_SBK_MENSAJE_INF(ivaCdConsumidor      in varchar2,
                                           ivaCdServicio        in varchar2,
                                           ivaCdOperacion       in varchar2,
                                           ivaDsClave           in varchar2,
                                           idtFeCreacion        in date,
                                           ivaNmPrioridad       in varchar2,
                                           ivaCdToken           in varchar2,
                                           ivaCdVersionServicio in varchar2,
                                           ivaDsNameSpace       in varchar2,
                                           ivaDsPuerto          in varchar2,
                                           ityEncabezados       TAB_SBK_ENC_MENSAJE,
                                           ivaDsCola            in varchar2,
										   ivaNmPrioridadEncolamiento  in number
                                          ) RETURN self AS RESULT IS
  BEGIN
    CDCONSUMIDOR               := ivaCdConsumidor;
    CDSERVICIO                 := ivaCdServicio;
    CDOPERACION                := ivaCdOperacion;
    DSCLAVE                    := ivaDsClave;
    FECREACION                 := idtFeCreacion;
    NMPRIORIDAD                := ivaNmPrioridad;
    CDTOKEN                    := ivaCdToken;
    CDVERSION_SERVICIO         := ivaCdVersionServicio;
    DSNAME_SPACE               := ivaDsNameSpace;
    DSPUERTO                   := ivaDsPuerto;
    TYENCABEZADOS              := ityEncabezados;
    DSCOLA                     := ivaDsCola;
	NMPRIORIDAD_ENCOLAMIENTO   := ivaNmPrioridadEncolamiento;

    return;
  END;

  /**
  * Entrega una representaci�n de este objeto como un String
  */
  MEMBER FUNCTION toString RETURN VARCHAR2 IS
     -- EOL varchar2(2) := chr(13) || chr(10);
     EOL varchar2(2) := chr(10);
     lvaEncabezados varchar2(1024);
     lvaString varchar2(2048);

   cursor lcuEncabezados is
        SELECT value(e) enc
          FROM TABLE(CAST(TYENCABEZADOS AS TAB_SBK_ENC_MENSAJE)) e;

   BEGIN

     IF NOT (TYENCABEZADOS is null) THEN
        FOR lreEncabezado in lcuEncabezados LOOP
            lvaEncabezados := lvaEncabezados || '[' || lreEncabezado.enc.toString || ']';
        END LOOP;
     END IF;

     lvaString := 'CDCONSUMIDOR=' || CDCONSUMIDOR || eol ||
                  'CDSERVICIO=' || CDSERVICIO || eol ||
                  'CDOPERACION=' || CDOPERACION || eol ||
                  'DSCLAVE=' || DSCLAVE || eol ||
                  'FECREACION=' || to_char(FECREACION, 'dd/mm/yyyy hh:mi:ss') || eol ||
                  'NMPRIORIDAD=' || NMPRIORIDAD || eol ||
                  'CDTOKEN=' || CDTOKEN || eol ||
                  'CDVERSION_SERVICIO=' || CDVERSION_SERVICIO || eol ||
                  'DSNAME_SPACE=' || DSNAME_SPACE || eol ||
                  'DSPUERTO=' || DSPUERTO || eol ||
                  'CDSERVICIO=' || CDSERVICIO || eol ||
				  'NMPRIORIDAD_ENCOLAMIENTO=' || NMPRIORIDAD_ENCOLAMIENTO ;

     IF NOT (lvaEncabezados IS NULL) THEN
        lvaString := lvaString || eol || 'TYENCABEZADOS=' || lvaEncabezados;
     END IF;

     return lvaString;
  END;

end;
/


  CREATE OR REPLACE EDITIONABLE TYPE "OBJ_SAP_DATOS_CONVERSION" AS OBJECT (
	cdFuente            VARCHAR2(10),
	nmAplicacion        VARCHAR2(5),
	cdCanal             VARCHAR2(10),

	CONSTRUCTOR FUNCTION OBJ_SAP_DATOS_CONVERSION RETURN SELF AS RESULT
);
/
CREATE OR REPLACE EDITIONABLE TYPE BODY "OBJ_SAP_DATOS_CONVERSION" IS
  CONSTRUCTOR FUNCTION OBJ_SAP_DATOS_CONVERSION RETURN SELF AS RESULT IS
  BEGIN
	cdFuente            := NULL;
	nmAplicacion        := NULL;
	cdCanal             := NULL;
   RETURN;
  END;
END;
/

  CREATE OR REPLACE EDITIONABLE TYPE "OBJ_SAP_CONDICION_PAGO_SINI" AS OBJECT
(
  -- Author  : Juan Guillermo Henao - Johan Miguel Ruiz
  -- Created : 2009/10/26
  -- Purpose : Representa la los Descuentos Financieros o Pronto Pago
  -- Modified:
  -- Cause:


  cdCondicionPago                VARCHAR2(15),
  nmDias                         NUMBER(10),
  poDescuento                    NUMBER(5,2),
  ptImporteDPP                   NUMBER(13,2),

  CONSTRUCTOR FUNCTION OBJ_SAP_CONDICION_PAGO_SINI RETURN SELF AS RESULT
);
/
CREATE OR REPLACE EDITIONABLE TYPE BODY "OBJ_SAP_CONDICION_PAGO_SINI" IS
  CONSTRUCTOR FUNCTION OBJ_SAP_CONDICION_PAGO_SINI RETURN SELF AS RESULT IS
  BEGIN
  cdCondicionPago                := NULL;
  nmDias                         := NULL;
  poDescuento                    := NULL;
  ptImporteDPP                   := NULL;
   RETURN;
  END;
END;
/

  CREATE OR REPLACE EDITIONABLE TYPE "OBJ_SAP_CUENTA" AS OBJECT
(
  -- Author  : JOHARURO
  -- Created : 2009/09/11 01:41:33 p.m.
  -- Purpose : Objeto Creado para representar una Cuenta bancaria en el intercambio con SAP
	--           va dentro del objeto OBJ_SQP_PROVEEDOR
  --Type usado por el modelo de clientes

     cdPaisBanco          VARCHAR2(3),
	 cdBanco              VARCHAR2(15),
	 nmCuenta             VARCHAR2(18),
	 cdTipoCuenta         VARCHAR2(2),
	 dsTitular            VARCHAR2(60),

	 CONSTRUCTOR FUNCTION OBJ_SAP_CUENTA RETURN SELF AS RESULT
);
/
CREATE OR REPLACE EDITIONABLE TYPE BODY "OBJ_SAP_CUENTA" IS
	CONSTRUCTOR FUNCTION OBJ_SAP_CUENTA RETURN SELF AS RESULT IS
	BEGIN
    cdPaisBanco     := null;
    cdBanco        := null;
    nmCuenta       := null;
    cdTipoCuenta   := null;
    dsTitular     := null;
		RETURN;
	END;
END;
/


  CREATE OR REPLACE EDITIONABLE TYPE "OBJ_SAP_DATO_RETENCION" AS OBJECT
(
  -- Author  : Juan Guillermo Henao - Johan Miguel Ruiz
  -- Created : 2009/10/07
  -- Purpose : Objeto Creado para representar una Retenci�n en intercambios con SAP
  -- Modified: 2009/10/26
  -- Cause:  Cambio en el WSDL Se crean los campos ptBaseRetencion y ptRetencion y cambian
  --         los nombres y las longitudes de los campos cdtipo_retencion y cdind_retencion


  cdtipoRetencion           VARCHAR2(5),
  cdindicadorRetencion      VARCHAR2(10),
  ptBaseRetencion           NUMBER(13,2),
  ptRetencion               NUMBER(13,2),

  CONSTRUCTOR FUNCTION OBJ_SAP_DATO_RETENCION RETURN SELF AS RESULT
)
/
CREATE OR REPLACE EDITIONABLE TYPE BODY "OBJ_SAP_DATO_RETENCION" IS
  CONSTRUCTOR FUNCTION OBJ_SAP_DATO_RETENCION RETURN SELF AS RESULT IS
  BEGIN
  cdtipoRetencion           := NULL;
  cdindicadorRetencion      := NULL;
  ptBaseRetencion           := NULL;
  ptRetencion               := NULL;
  RETURN;
  END;
END;
/



  CREATE OR REPLACE EDITIONABLE TYPE "OBJ_SAP_DETALLE_CXP_SINI" AS OBJECT
(
  -- Author  : Juan Guillermo Henao - Johan Miguel Ruiz
  -- Created : 2009;09;14 11:26:07 a.m.
  -- Purpose : Objeto creado para la representación del detalle de una cuenta por pagar de siniestros en intercambios con
  --           SAP
  -- Modified: 20091021
  -- Cause: Cambio radical en el WSDL

  cdRamo                         VARCHAR2(12),
  nmPoliza                       VARCHAR2(12),
  cdIntermediario                VARCHAR2(12),
  nmExpediente                   VARCHAR2(13),
  nmAsegurado                    VARCHAR2(25),
  ptImporte                      NUMBER(17,4),
  cdCentroCostos                 VARCHAR2(10),
  feAviso                        DATE,
  feOcurrencia                   DATE,
  cdIndicadorImpuesto            VARCHAR2(4),
  cdOficinaRadicacion            VARCHAR2(10),
  cdCompaniaParametro            VARCHAR2(10),
  cdRamoParametro                VARCHAR2(10),
  cdTipoReserva                  VARCHAR2(10),
  cdOperacion                    VARCHAR2(10),
  cdConcepto                     VARCHAR2(10),
  cdConceptoAdicional            VARCHAR2(10),
  dsTextoPosicion                VARCHAR2(50),

  CONSTRUCTOR FUNCTION OBJ_SAP_DETALLE_CXP_SINI RETURN SELF AS RESULT
)
;
/
CREATE OR REPLACE EDITIONABLE TYPE BODY "OBJ_SAP_DETALLE_CXP_SINI" IS
  CONSTRUCTOR FUNCTION OBJ_SAP_DETALLE_CXP_SINI RETURN SELF AS RESULT IS
  BEGIN
    cdRamo                         :=NULL;
    nmPoliza                       :=NULL;
    cdIntermediario                :=NULL;
    nmExpediente                   :=NULL;
    nmAsegurado                    :=NULL;
    ptImporte                      :=NULL;
    cdCentroCostos                 :=NULL;
    feAviso                        :=NULL;
    feOcurrencia                   :=NULL;
    cdIndicadorImpuesto            :=NULL;
    cdOficinaRadicacion            :=NULL;
    cdCompaniaParametro            :=NULL;
    cdRamoParametro                :=NULL;
    cdTipoReserva                  :=NULL;
    cdOperacion                    :=NULL;
    cdConcepto                     :=NULL;
    cdConceptoAdicional            :=NULL;
    dsTextoPosicion                :=NULL;
  RETURN;
  END;
END;
/


  CREATE OR REPLACE EDITIONABLE TYPE "OBJ_SAP_INFO_FISCAL" AS OBJECT
(
     nmIdentificacion              VARCHAR2(20),
     cdTipoIdentificacion          VARCHAR2(2),
     CONSTRUCTOR FUNCTION OBJ_SAP_INFO_FISCAL RETURN SELF AS RESULT
);
/
CREATE OR REPLACE EDITIONABLE TYPE BODY "OBJ_SAP_INFO_FISCAL" IS
  CONSTRUCTOR FUNCTION OBJ_SAP_INFO_FISCAL RETURN SELF AS RESULT IS
  BEGIN
    nmIdentificacion     := null;
    cdTipoIdentificacion := null;
   RETURN;
  END;
END;
/

create or replace TYPE "OBJ_SAP_DTMAPITEM" AS OBJECT (
	KEY	VARCHAR2(255),
	VALUE	VARCHAR2(255),

	CONSTRUCTOR FUNCTION OBJ_SAP_DTMAPITEM RETURN SELF AS RESULT
);
/

  CREATE OR REPLACE EDITIONABLE TYPE "TAB_SAP_DTMAPITEM" IS TABLE OF OBJ_SAP_DTMAPITEM
/

  CREATE OR REPLACE EDITIONABLE TYPE "OBJ_SAP_DTMAP" AS OBJECT (
	ITEMS	TAB_SAP_DTMAPITEM,

	CONSTRUCTOR FUNCTION OBJ_SAP_DTMAP RETURN SELF AS RESULT
);
/
CREATE OR REPLACE EDITIONABLE TYPE BODY "OBJ_SAP_DTMAP" IS
	CONSTRUCTOR FUNCTION OBJ_SAP_DTMAP RETURN SELF AS RESULT IS
	BEGIN
		ITEMS := TAB_SAP_DTMAPITEM();
		RETURN;
	END;
END;
/


  CREATE OR REPLACE EDITIONABLE TYPE "TAB_SAP_DATOS_RETENCIONES" IS TABLE OF OBJ_SAP_DATO_RETENCION
/


  CREATE OR REPLACE EDITIONABLE TYPE "TAB_SAP_DETALLES_CXP_SINI" IS TABLE OF OBJ_SAP_DETALLE_CxP_SINI
/




  CREATE OR REPLACE EDITIONABLE TYPE "OBJ_SBK_MENSAJE" as object
(
  -- Author  : RAUL DE VILLA
  -- Created : 2009-07-13 10:52:47 a.m.
  -- Purpose : Definie los atributos b�sicos de un mensaje que se enviar�
  --           a un servicio remoto

  TYINF OBJ_SBK_MENSAJE_INF,

  MEMBER FUNCTION toString RETURN VARCHAR2

) NOT FINAL;
/
CREATE OR REPLACE EDITIONABLE TYPE BODY "OBJ_SBK_MENSAJE" IS

  /**
  * Entrega una representaci�n del objeto como String
  */
  MEMBER FUNCTION toString RETURN VARCHAR2 IS
     EOL varchar2(2) := chr(10);
     lvaString varchar2(2048);
   BEGIN

     lvaString := 'OBJ_SBK_MENSAJE_INF[' || eol ||
                  TYINF.toString || eol ||
                  ']';

     return lvaString;
  END;

END;
/



  CREATE OR REPLACE EDITIONABLE TYPE "OBJ_SAP_CABECERA_CXP_SINI" FORCE AS OBJECT
(
-- Author  : Juan Guillermo Henao - Johan Miguel Ruiz
-- Created : 2009/10/07
-- Purpose : Objeto creado para la representaci�n de la cabecera de una cuenta por pagar de siniestros en intercambios con SAP
-- Modified: 2009/10/21
-- Cause:  Cabio radical en la estructura del WSDL
-- Modified: 2009/10/26
-- Cause:  cambio de nombre de campo dsFactura WSDL

  datosConversionOrigen OBJ_SAP_DATOS_CONVERSION,
  feFactura             DATE,
  cdCompania            VARCHAR2(5),
  feRegistroSap         DATE,
  nmPeriodo             NUMBER,
  cdMoneda              VARCHAR2(5),
  ptTasaCambio          NUMBER(8, 2),
  feTasaCambio          DATE,
  nmOrdenPago           VARCHAR2(16),
  nmFactura             VARCHAR2(35),

  CONSTRUCTOR FUNCTION OBJ_SAP_CABECERA_CXP_SINI RETURN SELF AS RESULT
)
;
/
CREATE OR REPLACE EDITIONABLE TYPE BODY "OBJ_SAP_CABECERA_CXP_SINI" IS
  CONSTRUCTOR FUNCTION OBJ_SAP_CABECERA_CXP_SINI RETURN SELF AS RESULT IS
  BEGIN
    datosConversionOrigen := OBJ_SAP_DATOS_CONVERSION();
    feFactura             := NULL;
    cdCompania            := NULL;
    feRegistroSap         := NULL;
    nmPeriodo             := NULL;
    cdMoneda              := NULL;
    ptTasaCambio          := NULL;
    feTasaCambio          := NULL;
    nmOrdenPago           := NULL;
    nmFactura             := NULL;
    RETURN;
  END;
END;
/



  CREATE OR REPLACE EDITIONABLE TYPE "OBJ_SAP_TERCERO" AS OBJECT
(
  -- Author  : Juan Guillermo Henao - Johan Miguel Ruiz
  -- Created : 2009/09/14 11:12:49 a.m.
  -- Purpose : Objeto creado para la representaci�n de los terceros denrto de los Intercambios de informaci�n con
  --           SAP
  -- Modified: 2009/10/26
  -- Cause : Se crea el constructor
  --Type usado por el modelo de clientes

  dsTratamiento              VARCHAR2(40),
  dsNombre                   VARCHAR2(80),
  dsApellidos                VARCHAR2(40),
  dsNombres                  VARCHAR2(40),
  dsDireccion                VARCHAR2(30),
  dsApartadoAereo            VARCHAR2(5),
  cdPais                     VARCHAR2(3),
  cdRegion                   VARCHAR2(3),
  cdPoblacion                VARCHAR2(5),
  cdIdioma                   VARCHAR2(1),
  cuentaBancaria             OBJ_SAP_CUENTA,
  informacionFiscal          OBJ_SAP_INFO_FISCAL,

  CONSTRUCTOR FUNCTION OBJ_SAP_TERCERO RETURN SELF AS RESULT
);
/
CREATE OR REPLACE EDITIONABLE TYPE BODY "OBJ_SAP_TERCERO" IS
  CONSTRUCTOR FUNCTION OBJ_SAP_TERCERO RETURN SELF AS RESULT IS
  BEGIN
  dsTratamiento              := NULL;
  dsNombre                   := NULL;
  dsApellidos                := NULL;
  dsNombres                  := NULL;
  dsDireccion                := NULL;
  dsApartadoAereo            := NULL;
  cdPais                     := NULL;
  cdRegion                   := NULL;
  cdPoblacion                := NULL;
  cdIdioma                   := NULL;
  cuentaBancaria             := OBJ_SAP_CUENTA();
  informacionFiscal          := OBJ_SAP_INFO_FISCAL();
  RETURN;
  END;
END;
/



  CREATE OR REPLACE EDITIONABLE TYPE "OBJ_SAP_DOCUMENTO_CXP_SINI" AS OBJECT
(
  -- Author  : Juan Guillermo Henao - Johan Miguel Ruiz
  -- Created : 2009;10;21
  -- Purpose : Representa la repetición de documentos con un encabezado comun
  -- Modified: 2009;10;26
  -- Cause:  Cambio en el WSDL Se elimina cdCondicionPago y se crea un objeto nuevo condicionPago
  --         se elimina el campo cdapuntadorBanco y se crea un oobjeto cuentaBancacaria

  nmBeneficiarioPago             VARCHAR2(25),
  cdTipoIdentificacion           VARCHAR2(4),
  cdOficinaRegistro              VARCHAR2(7),
  ptImporte                      NUMBER(13,2),
  snCalcularImpuestos            VARCHAR2(1),
  cdIva                          VARCHAR2(4),
  fePosiblePago                  DATE,
  condicionPago                  OBJ_SAP_CONDICION_PAGO_SINI,
  cdViaPago                      VARCHAR2(5),
  cuentaBancaria                 OBJ_SAP_CUENTA,
  cdBloqueoPago                  VARCHAR2(1),
  dsTextoPosicion                VARCHAR2(50),
  nmPoliza                       VARCHAR2(12),
  cdRamo                         VARCHAR2(12),
  cdOperacion                    VARCHAR2(10),
  cdConcepto                     VARCHAR2(10),
  cdTipoReserva                  VARCHAR2(10),
  retenciones                    TAB_SAP_DATOS_RETENCIONES,
  detalleSiniestros              TAB_SAP_DETALLES_CXP_SINI,

  CONSTRUCTOR FUNCTION OBJ_SAP_DOCUMENTO_CXP_SINI RETURN SELF AS RESULT
)
;
/
CREATE OR REPLACE EDITIONABLE TYPE BODY "OBJ_SAP_DOCUMENTO_CXP_SINI" IS
  CONSTRUCTOR FUNCTION OBJ_SAP_DOCUMENTO_CXP_SINI RETURN SELF AS RESULT IS
  BEGIN
  nmBeneficiarioPago             := NULL;
  cdTipoIdentificacion           := NULL;
  cdOficinaRegistro              := NULL;
  ptImporte                      := NULL;
  snCalcularImpuestos            := NULL;
  cdIva                          := NULL;
  fePosiblePago                  := NULL;
  condicionPago                  := OBJ_SAP_CONDICION_PAGO_SINI();
  cdViaPago                      := NULL;
  cuentaBancaria                 := OBJ_SAP_CUENTA();
  cdBloqueoPago                  := NULL;
  dsTextoPosicion                := NULL;
  nmPoliza                       := NULL;
  cdRamo                         := NULL;
  cdOperacion                    := NULL;
  cdConcepto                     := NULL;
  cdTipoReserva                  := NULL;
  retenciones                    := TAB_SAP_DATOS_RETENCIONES(OBJ_SAP_DATO_RETENCION());
  detalleSiniestros              := TAB_SAP_DETALLES_CXP_SINI(OBJ_SAP_DETALLE_CXP_SINI());
   RETURN;
  END;
END
;
/

  CREATE OR REPLACE EDITIONABLE TYPE "TAB_SAP_DOCUMENTO_CXP_SINI" AS TABLE OF OBJ_SAP_DOCUMENTO_CXP_SINI
/



  CREATE OR REPLACE EDITIONABLE TYPE "OBJ_SAP_CXP_SINIESTROS" UNDER OBJ_SBK_MENSAJE
(
  -- Author  : Juan Guillermo Henao - Johan Miguel Ruiz
  -- Created : 2009/09/14 11:26:07 a.m.
  -- Purpose : Objeto creado para la representaci�n de una cuenta por pagar de siniestros en intercambios con
  --           SAP
  -- Modified: 2009/10/21
  -- Cause: Cambio radical en el WSDL

  cabecera                      OBJ_SAP_CABECERA_CXP_SINI,
  documentosCXP                 TAB_SAP_DOCUMENTO_CXP_SINI,
  tercero                       OBJ_SAP_TERCERO,
  --parametrosAdicionales         OBJ_SAP_MAP ,
  parametrosAdicionales         OBJ_SAP_DTMAP ,
  CONSTRUCTOR FUNCTION OBJ_SAP_CXP_SINIESTROS RETURN SELF AS RESULT
)
/
CREATE OR REPLACE EDITIONABLE TYPE BODY "OBJ_SAP_CXP_SINIESTROS" IS
  CONSTRUCTOR FUNCTION OBJ_SAP_CXP_SINIESTROS RETURN SELF AS RESULT IS
  BEGIN
   cabecera                      := OBJ_SAP_CABECERA_CXP_SINI();
   documentosCXP                 := TAB_SAP_DOCUMENTO_CXP_SINI(OBJ_SAP_DOCUMENTO_CXP_SINI());
   tercero                       := OBJ_SAP_TERCERO();
   --parametrosAdicionales         := OBJ_SAP_MAP();
   parametrosAdicionales         := OBJ_SAP_DTMAP();
   RETURN;
  END;
END;
/