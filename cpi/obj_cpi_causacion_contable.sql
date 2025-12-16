/*
    ============================================================================
    Archivo: obj_cpi_causacion_contable.sql
    Descripcion: Definicion de tipos OBJECT y TABLE utilizados para la
                 representacion de mensajes de causacion contable en CPI.
                 Incluye tipos auxiliares y principales (control, cabecera,
                 posiciones y colecciones relacionadas).
    Autor: Jaime Andres Ortiz
    Fecha: 2025-09-17
    Version: 1.0.0
    Notas:
      - Este archivo es consumido por paquetes de integracion como
        PCK_INTEGRATION_CPI y adaptadores en el directorio adaptadores/.
      - Mantener la compatibilidad de nombres de tipos para despliegues
        y scripts de rollback.

    Cambios:
      - 2025-09-17: Anadida cabecera del archivo.
    ============================================================================
*/

-- Tipos para headers
CREATE OR REPLACE TYPE OPS$PROCEDIM.OBJ_CPI_HEADERS AS OBJECT (
  request_id VARCHAR2(200),
  ref_src_1 VARCHAR2(200),
  target_system VARCHAR2(200),
  target_system_process VARCHAR2(200),
  source_application_name VARCHAR2(200),
  integration_method VARCHAR2(100),
  key VARCHAR2(4000),
  secret VARCHAR2(4000),
  correlation_id VARCHAR2(200),
  its_batch_operation number(1)
);
/

-- Tipos auxiliares para arrays
CREATE OR REPLACE TYPE OPS$PROCEDIM.OBJ_CPI_CAUSA_PARAM_ADICIONAL AS OBJECT (
  clave VARCHAR2(100),
  valor VARCHAR2(4000)
);
/
CREATE OR REPLACE TYPE OPS$PROCEDIM.TAB_CPI_CAUSA_PARAM_ADICIONAL AS TABLE OF OPS$PROCEDIM.OBJ_CPI_CAUSA_PARAM_ADICIONAL;
/

CREATE OR REPLACE TYPE OPS$PROCEDIM.OBJ_CPI_CAUSA_CONTROL AS OBJECT (
  sistemaOrigen VARCHAR2(100),
  identificador VARCHAR2(100)
);
/

CREATE OR REPLACE TYPE OPS$PROCEDIM.OBJ_CPI_CAUSA_DET_CONTABLE AS OBJECT (
  canal VARCHAR2(50),
  fuente VARCHAR2(50),
  operacion VARCHAR2(50),
  aplicacion VARCHAR2(50)
);
/

CREATE OR REPLACE TYPE OPS$PROCEDIM.OBJ_CPI_CAUSA_CAB_DATOS_GENERALES AS OBJECT (
  sociedad VARCHAR2(10),
  fechaDocumento VARCHAR2(10),
  fechaContable VARCHAR2(10),
  moneda VARCHAR2(10),
  referencia VARCHAR2(50),
  claveReferencia1 VARCHAR2(50),
  claveReferencia2 VARCHAR2(50),
  texto VARCHAR2(400),
  tipoCambio VARCHAR2(20),
  fechaTipoCambio VARCHAR2(10)
);
/

CREATE OR REPLACE TYPE OPS$PROCEDIM.OBJ_CPI_CAUSA_CABECERA AS OBJECT (
  determinacionContable OPS$PROCEDIM.OBJ_CPI_CAUSA_DET_CONTABLE,
  datosGenerales OPS$PROCEDIM.OBJ_CPI_CAUSA_CAB_DATOS_GENERALES,
  parametrosAdicionales OPS$PROCEDIM.TAB_CPI_CAUSA_PARAM_ADICIONAL
);
/

CREATE OR REPLACE TYPE OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_PARAM_CONTABLE AS OBJECT (
  parametro01 VARCHAR2(100),
  parametro02 VARCHAR2(100),
  parametro03 VARCHAR2(100),
  parametro04 VARCHAR2(100),
  parametro05 VARCHAR2(100),
  parametro06 VARCHAR2(100),
  parametro07 VARCHAR2(100),
  parametro08 VARCHAR2(100),
  parametro09 VARCHAR2(100),
  parametro10 VARCHAR2(100)
);
/

CREATE OR REPLACE TYPE OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_DATOS_GENERALES AS OBJECT (
  claseCuenta VARCHAR2(10),
  sociedad VARCHAR2(10),
  valor VARCHAR2(50),
  indicadorImpuesto VARCHAR2(10),
  oficina VARCHAR2(20),
  centroCostos VARCHAR2(20),
  indicadorBloqueo VARCHAR2(10),
  viaPago VARCHAR2(20),
  fechaInicio VARCHAR2(10),
  claveReferencia1 VARCHAR2(50),
  claveReferencia2 VARCHAR2(50),
  claveReferencia3 VARCHAR2(50),
  asignacion VARCHAR2(100),
  texto VARCHAR2(400),
  contrato VARCHAR2(100),
  lineaDeNegocio VARCHAR2(100),
  asesor VARCHAR2(100),
  zReferencia01 VARCHAR2(100),
  zReferencia02 VARCHAR2(100),
  zReferencia03 VARCHAR2(100),
  zReferencia04 VARCHAR2(100),
  zReferencia05 VARCHAR2(100),
  zReferencia06 VARCHAR2(100),
  zReferencia07 VARCHAR2(100),
  zReferencia08 VARCHAR2(100),
  zReferencia09 VARCHAR2(100),
  zReferencia10 VARCHAR2(100),
  zFecha01 VARCHAR2(10)
);
/

CREATE OR REPLACE TYPE OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_DESCUENTO AS OBJECT (
  condicionPago VARCHAR2(50),
  base VARCHAR2(50),
  valor VARCHAR2(50),
  dias01 VARCHAR2(10),
  dias02 VARCHAR2(10),
  dias03 VARCHAR2(10),
  porcentaje01 VARCHAR2(10),
  porcentaje02 VARCHAR2(10)
);
/

CREATE OR REPLACE TYPE OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_RETENCION AS OBJECT (
  TipoRetencion VARCHAR2(50),
  IndicadorRetencion VARCHAR2(50),
  valorBaseRetencion VARCHAR2(50),
  valorRetencion VARCHAR2(50)
);
/
CREATE OR REPLACE TYPE OPS$PROCEDIM.TAB_CPI_CAUSA_POS_RETENCION AS TABLE OF OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_RETENCION;
/

CREATE OR REPLACE TYPE OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_TERCERO_GENERAL AS OBJECT (
  codigoTercero VARCHAR2(50),
  tipoIdentificacion VARCHAR2(10),
  identificacion VARCHAR2(20)
);
/
CREATE OR REPLACE TYPE OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_TERCERO_PAGADOR AS OBJECT (
  tipoIdentificacion VARCHAR2(10),
  identificacion VARCHAR2(20)
);
/
CREATE OR REPLACE TYPE OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_TERCERO_BANCARIO AS OBJECT (
  paisBanco VARCHAR2(50),
  banco VARCHAR2(50),
  cuenta VARCHAR2(50),
  tipoCuenta VARCHAR2(10),
  tipoIdentificacion VARCHAR2(10),
  identificacion VARCHAR2(20),
  nombreTitular VARCHAR2(100),
  apuntadorCuenta VARCHAR2(50)
);
/
CREATE OR REPLACE TYPE OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_TERCERO_DET_BANCARIA AS OBJECT (
  tipoIdentificacion VARCHAR2(10),
  identificacion VARCHAR2(20),
  claveReferencia1 VARCHAR2(50),
  claveReferencia2 VARCHAR2(50)
);
/
CREATE OR REPLACE TYPE OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_TERCERO AS OBJECT (
  general OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_TERCERO_GENERAL,
  pagadorAlternativo OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_TERCERO_PAGADOR,
  datosBancarios OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_TERCERO_BANCARIO,
  determinacionBancaria OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_TERCERO_DET_BANCARIA
);
/

CREATE OR REPLACE TYPE OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_RESUMEN AS OBJECT (
  parametrosContables OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_PARAM_CONTABLE,
  datosGenerales OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_DATOS_GENERALES,
  descuento OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_DESCUENTO,
  retenciones OPS$PROCEDIM.TAB_CPI_CAUSA_POS_RETENCION,
  tercero OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_TERCERO,
  parametrosAdicionales OPS$PROCEDIM.TAB_CPI_CAUSA_PARAM_ADICIONAL
);
/

CREATE OR REPLACE TYPE OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_DETALLE AS OBJECT (
  parametrosContables OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_PARAM_CONTABLE,
  datosGenerales OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_DATOS_GENERALES,
  parametrosAdicionales OPS$PROCEDIM.TAB_CPI_CAUSA_PARAM_ADICIONAL
);
/
CREATE OR REPLACE TYPE OPS$PROCEDIM.TAB_CPI_CAUSA_POS_DETALLE AS TABLE OF OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_DETALLE;
/

CREATE OR REPLACE TYPE OPS$PROCEDIM.OBJ_CPI_CAUSA_POSICION AS OBJECT (
  resumen OPS$PROCEDIM.OBJ_CPI_CAUSA_POS_RESUMEN,
  detalle OPS$PROCEDIM.TAB_CPI_CAUSA_POS_DETALLE
);
/
CREATE OR REPLACE TYPE OPS$PROCEDIM.TAB_CPI_CAUSA_POSICION AS TABLE OF OPS$PROCEDIM.OBJ_CPI_CAUSA_POSICION;
/

CREATE OR REPLACE TYPE OPS$PROCEDIM.OBJ_CPI_CAUSACION_CONTABLE AS OBJECT (
  --headers   OPS$PROCEDIM.OBJ_CPI_HEADERS,
  control OPS$PROCEDIM.OBJ_CPI_CAUSA_CONTROL,
  cabecera OPS$PROCEDIM.OBJ_CPI_CAUSA_CABECERA,
  posiciones OPS$PROCEDIM.TAB_CPI_CAUSA_POSICION
);
/
