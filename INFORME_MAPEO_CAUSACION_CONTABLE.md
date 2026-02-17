# Informe de Mapeo de Datos - Causación Contable

## Contexto

Este documento detalla el mapeo de datos realizado desde el objeto origen `OBJ_SAP_CXP_SINIESTROS` y la estructura XML `atr_siniestro_trama_broker.xml` hacia el objeto destino `OBJ_CPI_CAUSACION_CONTABLE`. Esta transformación se implementa en el paquete `pck_sin_adaptador_cpi` mediante la función `map_sap_cxp_to_causacion`.

## Información General

- **Fecha de Implementación**: 2025-09-17
- **Autor**: Jaime Andres Ortiz
- **Paquete**: `OPS$PROCEDIM.PCK_SIN_ADAPTADOR_CPI`
- **Función Principal**: `map_sap_cxp_to_causacion`
- **Versión**: 1.0.0

## Estructura de Objetos

### 1. Objeto Origen: `OBJ_SAP_CXP_SINIESTROS`

Este objeto representa una cuenta por pagar de siniestros y contiene:

```sql
OBJ_SAP_CXP_SINIESTROS
├── cabecera: OBJ_SAP_CABECERA_CXP_SINI
│   ├── datosConversionOrigen: OBJ_SAP_DATOS_CONVERSION
│   │   ├── cdFuente
│   │   ├── nmAplicacion
│   │   └── cdCanal
│   ├── feFactura (DATE)
│   ├── cdCompania (VARCHAR2)
│   ├── feRegistroSap (DATE)
│   ├── nmPeriodo (NUMBER)
│   ├── cdMoneda (VARCHAR2)
│   ├── ptTasaCambio (NUMBER)
│   ├── feTasaCambio (DATE)
│   ├── nmOrdenPago (VARCHAR2)
│   └── nmFactura (VARCHAR2)
├── documentosCXP: TAB_SAP_DOCUMENTO_CXP_SINI (collection)
│   └── [n]: OBJ_SAP_DOCUMENTO_CXP_SINI
│       ├── nmBeneficiarioPago
│       ├── cdTipoIdentificacion
│       ├── cdOficinaRegistro
│       ├── ptImporte
│       ├── snCalcularImpuestos
│       ├── cdIva
│       ├── fePosiblePago
│       ├── condicionPago: OBJ_SAP_CONDICION_PAGO_SINI
│       │   ├── cdCondicionPago
│       │   ├── nmDias
│       │   ├── poDescuento
│       │   └── ptImporteDpp
│       ├── cdViaPago
│       ├── cuentaBancaria: OBJ_SAP_CUENTA
│       │   ├── cdPaisBanco
│       │   ├── cdBanco
│       │   ├── nmCuenta
│       │   ├── cdTipoCuenta
│       │   └── dsTitular
│       ├── cdBloqueoPago
│       ├── dsTextoPosicion
│       ├── nmPoliza
│       ├── cdRamo
│       ├── cdOperacion
│       ├── cdConcepto
│       ├── cdTipoReserva
│       ├── retenciones: TAB_SAP_DATOS_RETENCIONES (collection)
│       │   └── [n]: OBJ_SAP_DATO_RETENCION
│       │       ├── cdTipoRetencion
│       │       ├── cdIndicadorRetencion
│       │       ├── ptBaseRetencion
│       │       └── ptRetencion
│       └── detalleSiniestros: TAB_SAP_DETALLES_CXP_SINI (collection)
│           └── [n]: OBJ_SAP_DETALLE_CXP_SINI
│               ├── cdRamo
│               ├── nmPoliza
│               ├── cdIntermediario
│               ├── nmExpediente
│               ├── nmAsegurado
│               ├── ptImporte
│               ├── cdCentroCostos
│               ├── feAviso
│               ├── feOcurrencia
│               ├── cdIndicadorImpuesto
│               ├── cdOficinaRadicacion
│               ├── cdCompaniaParametro
│               ├── cdRamoParametro
│               ├── cdTipoReserva
│               ├── cdOperacion
│               ├── cdConcepto
│               ├── cdConceptoAdicional
│               └── dsTextoPosicion
├── tercero: OBJ_SAP_TERCERO
│   ├── dsNombre
│   ├── dsApellidos
│   ├── dsNombres
│   ├── dsDireccion
│   ├── cdPais
│   ├── cdRegion
│   ├── cdPoblacion
│   ├── cuentaBancaria: OBJ_SAP_CUENTA
│   │   ├── cdPaisBanco
│   │   ├── cdBanco
│   │   ├── nmCuenta
│   │   ├── cdTipoCuenta
│   │   └── dsTitular
│   └── informacionFiscal: OBJ_SAP_INFO_FISCAL
│       ├── nmIdentificacion
│       └── cdTipoIdentificacion
└── parametrosAdicionales: OBJ_SAP_DTMAP
    └── items (collection)
        └── [n]: key, value
```

### 2. Objeto Destino: `OBJ_CPI_CAUSACION_CONTABLE`

Este objeto representa la estructura estandarizada para causación contable en CPI:

```sql
OBJ_CPI_CAUSACION_CONTABLE
├── headers: OBJ_CPI_HEADERS
│   ├── request_id
│   ├── ref_src_1
│   ├── target_system
│   ├── target_system_process
│   ├── source_application_name
│   ├── integration_method
│   ├── key
│   ├── secret
│   ├── correlation_id
│   └── is_batch_operation
├── control: OBJ_CPI_CAUSA_CONTROL
│   ├── sistemaOrigen
│   └── identificador
├── cabecera: OBJ_CPI_CAUSA_CABECERA
│   ├── determinacionContable: OBJ_CPI_CAUSA_DET_CONTABLE
│   │   ├── canal
│   │   ├── fuente
│   │   ├── operacion
│   │   └── aplicacion
│   ├── datosGenerales: OBJ_CPI_CAUSA_CAB_DATOS_GENERALES
│   │   ├── sociedad
│   │   ├── fechaDocumento
│   │   ├── fechaContable
│   │   ├── moneda
│   │   ├── referencia
│   │   ├── claveReferencia1
│   │   ├── claveReferencia2
│   │   ├── texto
│   │   ├── tipoCambio
│   │   └── fechaTipoCambio
│   └── parametrosAdicionales: TAB_CPI_CAUSA_PARAM_ADICIONAL
└── posiciones: TAB_CPI_CAUSA_POSICION (collection)
    └── [i]: OBJ_CPI_CAUSA_POSICION
        ├── resumen: OBJ_CPI_CAUSA_POS_RESUMEN
        │   ├── parametrosContables: OBJ_CPI_CAUSA_POS_PARAM_CONTABLE
        │   │   ├── parametro01 a parametro10
        │   ├── datosGenerales: OBJ_CPI_CAUSA_POS_DATOS_GENERALES
        │   │   ├── claseCuenta
        │   │   ├── sociedad
        │   │   ├── valor
        │   │   ├── indicadorImpuestos
        │   │   ├── oficina
        │   │   ├── centroCostos
        │   │   ├── centroBeneficios
        │   │   ├── indicadorBloqueo
        │   │   ├── viaPago
        │   │   ├── fechaInicio
        │   │   ├── claveReferencia1
        │   │   ├── claveReferencia2
        │   │   ├── claveReferencia3
        │   │   ├── asignacion
        │   │   ├── texto
        │   │   ├── contrato
        │   │   ├── lineaDeNegocio
        │   │   ├── asesor
        │   │   ├── zReferencia01 a zReferencia10
        │   │   └── zFecha01
        │   ├── descuento: OBJ_CPI_CAUSA_POS_DESCUENTO
        │   │   ├── condicionPago
        │   │   ├── base
        │   │   ├── valor
        │   │   ├── dias01, dias02, dias03
        │   │   └── porcentaje01, porcentaje02
        │   ├── retenciones: TAB_CPI_CAUSA_POS_RETENCION
        │   │   └── [j]: OBJ_CPI_CAUSA_POS_RETENCION
        │   │       ├── TipoRetencion
        │   │       ├── IndicadorRetencion
        │   │       ├── valorBaseRetencion
        │   │       └── valorRetencion
        │   ├── tercero: OBJ_CPI_CAUSA_POS_TERCERO
        │   │   ├── general: OBJ_CPI_CAUSA_POS_TERCERO_GENERAL
        │   │   │   ├── codigoTercero
        │   │   │   ├── tipoIdentificacion
        │   │   │   └── identificacion
        │   │   ├── pagadorAlternativo: OBJ_CPI_CAUSA_POS_TERCERO_PAGADOR
        │   │   │   ├── tipoIdentificacion
        │   │   │   └── identificacion
        │   │   ├── datosBancarios: OBJ_CPI_CAUSA_POS_TERCERO_BANCARIO
        │   │   │   ├── paisBanco
        │   │   │   ├── banco
        │   │   │   ├── cuenta
        │   │   │   ├── tipoCuenta
        │   │   │   ├── tipoIdentificacion
        │   │   │   ├── identificacion
        │   │   │   ├── nombreTitular
        │   │   │   └── apuntadorCuenta
        │   │   └── determinacionBancaria: OBJ_CPI_CAUSA_POS_TERCERO_DET_BANCARIA
        │   │       ├── tipoIdentificacion
        │   │       ├── identificacion
        │   │       ├── claveReferencia1
        │   │       └── claveReferencia2
        │   └── parametrosAdicionales: TAB_CPI_CAUSA_PARAM_ADICIONAL
        └── detalle: TAB_CPI_CAUSA_POS_DETALLE (collection)
            └── [m]: OBJ_CPI_CAUSA_POS_DETALLE
                ├── parametrosContables: OBJ_CPI_CAUSA_POS_PARAM_CONTABLE
                ├── datosGenerales: OBJ_CPI_CAUSA_POS_DATOS_GENERALES
                └── parametrosAdicionales: TAB_CPI_CAUSA_PARAM_ADICIONAL
```

## Mapeo Detallado

### 3.1. Headers (OBJ_CPI_HEADERS)

Los headers se construyen con información de configuración y seguridad:

| Campo Destino | Origen | Notas |
|---------------|--------|-------|
| `request_id` | `pck_gnl_integration_utils.fn_gnl_get_correlation_id()` | Generado dinámicamente |
| `ref_src_1` | Constante: `'ref-001'` | Valor fijo |
| `target_system` | Constante: `'sap'` | Sistema destino |
| `target_system_process` | Constante: `'siniestros_cxp'` | Proceso específico |
| `source_application_name` | Parámetro: `p_source_application_name` | Pasado como parámetro |
| `integration_method` | Constante: `'bd-async'` | Método de integración |
| `key` | `PCK_PARAMETROS.FN_GET_PARAMETROV2` con `p_param_client_id` | Obtenido de tabla de parámetros |
| `secret` | `PCK_PARAMETROS.FN_GET_PARAMETROV2` con `p_param_client_secret` | Obtenido de tabla de parámetros |
| `correlation_id` | `pck_gnl_integration_utils.fn_gnl_get_correlation_id()` | Generado dinámicamente |
| `is_batch_operation` | Constante: `0` | No es operación batch |

### 3.2. Control (OBJ_CPI_CAUSA_CONTROL)

| Campo Destino | Origen | Notas |
|---------------|--------|-------|
| `sistemaOrigen` | Parámetro: `p_sistema_origen` | Pasado como parámetro |
| `identificador` | `pck_gnl_integration_utils.fn_gnl_get_correlation_id()` | Generado dinámicamente |

### 3.3. Cabecera (OBJ_CPI_CAUSA_CABECERA)

#### 3.3.1. Determinación Contable

| Campo Destino | Origen | Notas |
|---------------|--------|-------|
| `canal` | `i_obj.cabecera.datosConversionOrigen.cdCanal` | Del objeto cabecera origen |
| `fuente` | `i_obj.cabecera.datosConversionOrigen.cdFuente` | Del objeto cabecera origen |
| `operacion` | Constante: `'CXP'` | Cuentas por pagar |
| `aplicacion` | `i_obj.cabecera.datosConversionOrigen.nmAplicacion` | Del objeto cabecera origen |

#### 3.3.2. Datos Generales de Cabecera

| Campo Destino | Origen | Transformación |
|---------------|--------|----------------|
| `sociedad` | `i_obj.cabecera.cdCompania` | Directo |
| `fechaDocumento` | `i_obj.cabecera.feFactura` | Formato: `YYYY-MM-DD` |
| `fechaContable` | `i_obj.cabecera.feRegistroSap` | Formato: `YYYY-MM-DD` |
| `moneda` | `i_obj.cabecera.cdMoneda` | Directo |
| `referencia` | `i_obj.cabecera.nmOrdenPago` | Directo |
| `claveReferencia1` | `i_obj.documentosCXP(first).detalleSiniestros(first).nmPoliza` | Del primer documento/detalle |
| `claveReferencia2` | `i_obj.documentosCXP(first).detalleSiniestros(first).cdRamo` | Del primer documento/detalle |
| `texto` | `i_obj.cabecera.nmFactura` o `'REGISTRO SINIESTRO SEGURO'` | Si nmFactura es NULL, usar texto por defecto |
| `tipoCambio` | `''` (vacío) | No aplica para este proceso |
| `fechaTipoCambio` | `''` (vacío) | No aplica para este proceso |

#### 3.3.3. Parámetros Adicionales de Cabecera

Se envía un array con un elemento vacío: `[{clave: '', valor: ''}]`

### 3.4. Posiciones (iteración sobre documentosCXP)

Para cada documento en `i_obj.documentosCXP`, se crea una posición con su resumen y detalles.

#### 3.4.1. Resumen - Parámetros Contables

| Campo Destino | Origen | Transformación |
|---------------|--------|----------------|
| `parametro01` | `i_obj.cabecera.cdCompania` | Código de compañía |
| `parametro02` | `null` | No se mapea |
| `parametro03` | `v_doc.cdTipoReserva` | Si `cdConcepto` termina en 'A' o 'M', concatenar 'A' |
| `parametro04` | `v_doc.cdOperacion` | Código de operación |
| `parametro05` a `parametro10` | `null` | No se mapean |

**Regla especial para parametro03:**
```sql
CASE
  WHEN substr(v_doc.cdConcepto, -1) IN ('A', 'M') THEN v_doc.cdTipoReserva || 'A'
  ELSE v_doc.cdTipoReserva
END
```

#### 3.4.2. Resumen - Datos Generales

| Campo Destino | Origen | Transformación |
|---------------|--------|----------------|
| `claseCuenta` | Constante: `'K'` | K = Acreedor |
| `sociedad` | `''` (vacío) | No se mapea |
| `valor` | `v_doc.ptImporte` | Convertido a texto |
| `indicadorImpuestos` | `v_doc.cdIva` | Directo |
| `oficina` | `i_obj.cabecera.cdCompania || v_doc.detalleSiniestros(first).cdOficinaRadicacion` | Concatenación compañía + oficina |
| `centroCostos` | `i_obj.cabecera.cdCompania || v_doc.detalleSiniestros(first).cdOficinaRadicacion` | Concatenación compañía + oficina |
| `centroBeneficios` | `null` | No se mapea |
| `indicadorBloqueo` | `v_doc.cdBloqueoPago` | Directo |
| `viaPago` | `v_doc.cdViaPago` | Directo |
| `fechaInicio` | `v_doc.detalleSiniestros(first).feAviso` | Formato: `YYYY-MM-DD` |
| `claveReferencia1` | `i_obj.tercero.informacionFiscal.nmIdentificacion` | Identificación del tercero |
| `claveReferencia2` | `v_doc.cdRamo` | Código de ramo |
| `claveReferencia3` | `''` (vacío) | No se mapea |
| `asignacion` | `i_obj.tercero.informacionFiscal.nmIdentificacion` | Identificación del tercero |
| `texto` | `v_doc.detalleSiniestros(first).dsTextoPosicion` | Texto del primer detalle |
| `contrato` | `''` (vacío) | No se mapea |
| `lineaDeNegocio` | `v_doc.cdRamo` | Código de ramo |
| `asesor` | `v_doc.detalleSiniestros(first).cdIntermediario` | Del primer detalle |
| `zReferencia01` | `v_doc.nmPoliza` | Número de póliza |
| `zReferencia02` | `null` | No se mapea |
| `zReferencia03` | `i_obj.tercero.dsNombre` | Nombre del tercero |
| `zReferencia04` | `i_obj.tercero.informacionFiscal.nmIdentificacion` | Identificación del tercero |
| `zReferencia05` | `v_codigo_municipio` | Calculado de retenciones |
| `zReferencia06` | `v_doc.detalleSiniestros(first).nmExpediente` | Del primer detalle |
| `zReferencia07` a `zReferencia09` | `null` | No se mapean |
| `zReferencia10` | `''` (vacío) | No se mapea |
| `zFecha01` | `v_doc.detalleSiniestros(first).feOcurrencia` | Formato: `YYYY-MM-DD` |

#### 3.4.3. Resumen - Descuento

| Campo Destino | Origen | Notas |
|---------------|--------|-------|
| `condicionPago` | `v_doc.condicionPago.cdCondicionPago` | Directo |
| `base` | `v_doc.condicionPago.ptImporteDpp` | Directo |
| `valor` | `''` (vacío) | No se mapea |
| `dias01` | `v_doc.condicionPago.nmDias` | Directo |
| `dias02` | `''` (vacío) | No se mapea |
| `dias03` | `''` (vacío) | No se mapea |
| `porcentaje01` | `v_doc.condicionPago.poDescuento` | Directo |
| `porcentaje02` | `''` (vacío) | No se mapea |

#### 3.4.4. Resumen - Retenciones (iteración sobre v_doc.retenciones)

Para cada retención, se mapea:

| Campo Destino | Origen | Transformación |
|---------------|--------|----------------|
| `TipoRetencion` | Según `cdIndicadorRetencion` | Ver reglas abajo |
| `IndicadorRetencion` | Según `cdIndicadorRetencion` | Ver reglas abajo |
| `valorBaseRetencion` | `v_ret.ptBaseRetencion` | Convertido a texto |
| `valorRetencion` | `v_ret.ptRetencion` | Convertido a texto |

**Reglas de transformación para retenciones:**

```sql
-- TipoRetencion e IndicadorRetencion se mapean igual:
CASE 
  WHEN cdIndicadorRetencion = 'R' THEN cdCompania || cdTipoRetencion || '_RF'
  WHEN cdIndicadorRetencion = 'I' THEN cdCompania || cdTipoRetencion || '_RI'
  ELSE cdCompania || v_codigo_municipio || cdTipoRetencion || '_RC'
END
```

**Nota especial:** El código de municipio (`v_codigo_municipio`) se extrae de las retenciones cuyo `cdIndicadorRetencion` no es 'R' ni 'I'.

#### 3.4.5. Resumen - Tercero

##### General

| Campo Destino | Origen | Notas |
|---------------|--------|-------|
| `codigoTercero` | `''` (vacío) | No se mapea |
| `tipoIdentificacion` | `i_obj.tercero.informacionFiscal.cdTipoIdentificacion` | Directo |
| `identificacion` | `i_obj.tercero.informacionFiscal.nmIdentificacion` | Directo |

##### Pagador Alternativo

| Campo Destino | Origen | Notas |
|---------------|--------|-------|
| `tipoIdentificacion` | `''` (vacío) | No se mapea |
| `identificacion` | `''` (vacío) | No se mapea |

##### Datos Bancarios

**Condición:** Si `v_doc.cdViaPago = 'CA'` (Pago en caja), todos los campos se envían vacíos. De lo contrario:

| Campo Destino | Origen | Notas |
|---------------|--------|-------|
| `paisBanco` | `i_obj.tercero.cuentaBancaria.cdPaisBanco` | Directo |
| `banco` | `i_obj.tercero.cuentaBancaria.cdBanco` | Directo |
| `cuenta` | `i_obj.tercero.cuentaBancaria.nmCuenta` | Directo |
| `tipoCuenta` | `i_obj.tercero.cuentaBancaria.cdTipoCuenta` | Directo |
| `tipoIdentificacion` | `i_obj.tercero.informacionFiscal.cdTipoIdentificacion` | Directo |
| `identificacion` | `i_obj.tercero.informacionFiscal.nmIdentificacion` | Directo |
| `nombreTitular` | `i_obj.tercero.cuentaBancaria.dsTitular` | Directo |
| `apuntadorCuenta` | `''` (vacío) | No se mapea |

##### Determinación Bancaria

| Campo Destino | Origen | Notas |
|---------------|--------|-------|
| `tipoIdentificacion` | `i_obj.tercero.informacionFiscal.cdTipoIdentificacion` | Directo |
| `identificacion` | `i_obj.tercero.informacionFiscal.nmIdentificacion` | Directo |
| `claveReferencia1` | `v_doc.nmPoliza` | Número de póliza |
| `claveReferencia2` | `v_doc.cdRamo` | Código de ramo |

##### Parámetros Adicionales del Resumen

Se copian los parámetros adicionales del objeto origen:

| Campo Destino | Origen |
|---------------|--------|
| `clave` | `i_obj.parametrosAdicionales.items[n].key` |
| `valor` | `i_obj.parametrosAdicionales.items[n].value` |

#### 3.4.6. Detalle (iteración sobre v_doc.detalleSiniestros)

Para cada detalle de siniestro, se crea un registro de detalle:

##### Parámetros Contables del Detalle

| Campo Destino | Origen | Transformación |
|---------------|--------|----------------|
| `parametro01` | `v_detalle_cxp.cdCompaniaParametro` | Directo |
| `parametro02` | `v_detalle_cxp.cdRamoParametro` | Con regla especial (ver abajo) |
| `parametro03` | `v_detalle_cxp.cdTipoReserva` | Directo |
| `parametro04` | `v_detalle_cxp.cdOperacion` | Directo |
| `parametro05` | `v_detalle_cxp.cdConcepto` | Directo |
| `parametro06` a `parametro10` | `null` | No se mapean |

**Regla especial para parametro02:**
```sql
CASE
  WHEN i_obj.cabecera.cdCompania = '30' AND v_detalle_cxp.cdConcepto = '1C' THEN 'N'
  ELSE v_detalle_cxp.cdRamoParametro
END
```

##### Datos Generales del Detalle

| Campo Destino | Origen | Transformación |
|---------------|--------|----------------|
| `claseCuenta` | Constante: `'S'` | S = Cuenta de gasto/ingreso |
| `sociedad` | `''` (vacío) | No se mapea |
| `valor` | `v_detalle_cxp.ptImporte` | Convertido a texto |
| `indicadorImpuestos` | `i_obj.cabecera.cdCompania || v_detalle_cxp.cdIndicadorImpuesto` | Concatenación |
| `oficina` | `i_obj.cabecera.cdCompania || v_doc.detalleSiniestros(first).cdOficinaRadicacion` | Del primer detalle del documento |
| `centroCostos` | `i_obj.cabecera.cdCompania || v_doc.detalleSiniestros(first).cdOficinaRadicacion` | Del primer detalle del documento |
| `centroBeneficios` | `null` | No se mapea |
| `indicadorBloqueo` | `null` | No se mapea en detalles |
| `viaPago` | `null` | No se mapea en detalles |
| `fechaInicio` | `v_detalle_cxp.feAviso` | Formato: `YYYY-MM-DD` |
| `claveReferencia1` | `i_obj.tercero.informacionFiscal.nmIdentificacion` | Identificación del tercero |
| `claveReferencia2` | `v_detalle_cxp.cdRamo` | Código de ramo |
| `claveReferencia3` | `v_detalle_cxp.cdIntermediario` | Código de intermediario |
| `asignacion` | `i_obj.tercero.informacionFiscal.nmIdentificacion` | Identificación del tercero |
| `texto` | `v_detalle_cxp.dsTextoPosicion` | Texto de posición |
| `contrato` | `null` | No se mapea |
| `lineaDeNegocio` | `null` | No se mapea |
| `asesor` | `null` | No se mapea |
| `zReferencia01` | `v_detalle_cxp.nmPoliza` | Número de póliza |
| `zReferencia02` | `''` (vacío) | No se mapea |
| `zReferencia03` | `i_obj.tercero.dsNombre` | Nombre del tercero |
| `zReferencia04` | `i_obj.tercero.informacionFiscal.nmIdentificacion` | Identificación del tercero |
| `zReferencia05` | `v_codigo_municipio` | Calculado de retenciones |
| `zReferencia06` | `v_detalle_cxp.nmExpediente` | Número de expediente |
| `zReferencia07` a `zReferencia09` | `null` | No se mapean |
| `zReferencia10` | `''` (vacío) | No se mapea |
| `zFecha01` | `v_detalle_cxp.feOcurrencia` | Formato: `YYYY-MM-DD` |

##### Parámetros Adicionales del Detalle

Se copian los parámetros adicionales del objeto origen (mismos que en el resumen).

## Ejemplo de Uso

### Entrada (XML de atr_siniestro_trama_broker.xml)

```xml
<CABECERA>
  <DATOSCONVERSIONORIGEN>
    <CDFUENTE>SIN</CDFUENTE>
    <NMAPLICACION>79</NMAPLICACION>
    <CDCANAL>BAN</CDCANAL>
  </DATOSCONVERSIONORIGEN>
  <FEFACTURA>03/03/2025 14:45:44</FEFACTURA>
  <CDCOMPANIA>02</CDCOMPANIA>
  <NMORDENPAGO>6575268</NMORDENPAGO>
  ...
</CABECERA>
<DOCUMENTOSCXP>
  <OBJSAPDOCUMENTOCXPSINI1>
    <NMPOLIZA>BAN108787784</NMPOLIZA>
    <CDRAMO>BANVMR</CDRAMO>
    <PTIMPORTE>105437</PTIMPORTE>
    ...
  </OBJSAPDOCUMENTOCXPSINI1>
</DOCUMENTOSCXP>
<TERCERO>
  <DSNOMBRE>Daly Ceneth Muñoz Campo</DSNOMBRE>
  <INFORMACIONFISCAL>
    <NMIDENTIFICACION>34545936</NMIDENTIFICACION>
    <CDTIPOIDENTIFICACION>C</CDTIPOIDENTIFICACION>
  </INFORMACIONFISCAL>
  ...
</TERCERO>
```

### Salida (Estructura JSON de Causación Contable)

```json
{
  "headers": {
    "request-id": "2F6E022C1A7E0594E0630ACE02089D44",
    "target-system": "sap",
    "target-system-process": "siniestros_cxp",
    "integration-method": "bd-async",
    ...
  },
  "control": {
    "sistemaOrigen": "SINIESTROS",
    "identificador": "6575268"
  },
  "cabecera": {
    "determinacionContable": {
      "canal": "BAN",
      "fuente": "SIN",
      "operacion": "CXP",
      "aplicacion": "79"
    },
    "datosGenerales": {
      "sociedad": "02",
      "fechaDocumento": "2025-03-03",
      "moneda": "0",
      "referencia": "6575268",
      "claveReferencia1": "BAN108787784",
      "claveReferencia2": "081",
      "texto": "REGISTRO SINIESTRO SEGURO"
    }
  },
  "posiciones": [
    {
      "resumen": {
        "parametrosContables": {
          "parametro01": "02",
          "parametro03": "M",
          "parametro04": "907"
        },
        "datosGenerales": {
          "claseCuenta": "K",
          "valor": "105437",
          "indicadorImpuestos": "",
          "oficina": "02255",
          "centroCostos": "02255",
          "indicadorBloqueo": "6",
          "viaPago": "GE",
          "claveReferencia1": "34545936",
          "claveReferencia2": "BANVMR",
          "lineaDeNegocio": "BANVMR",
          "zReferencia01": "BAN108787784",
          "zReferencia03": "Daly Ceneth Muñoz Campo",
          "zReferencia04": "34545936"
        },
        "tercero": {
          "general": {
            "tipoIdentificacion": "C",
            "identificacion": "34545936"
          },
          "datosBancarios": {
            "paisBanco": "57",
            "banco": "07",
            "cuenta": "24244396100",
            "tipoCuenta": "01"
          }
        }
      },
      "detalle": [
        {
          "parametrosContables": {
            "parametro01": "02",
            "parametro02": "N",
            "parametro03": "M",
            "parametro04": "907",
            "parametro05": "2"
          },
          "datosGenerales": {
            "claseCuenta": "S",
            "valor": "105437",
            "claveReferencia1": "34545936",
            "claveReferencia2": "081"
          }
        }
      ]
    }
  ]
}
```

## Reglas de Negocio Importantes

### 1. Manejo de Retenciones

- El indicador de retención determina el tipo:
  - `'R'` = Retención Fuente (RF)
  - `'I'` = Retención ICA (RI)
  - Otros valores = Retención Complementaria (RC) con código de municipio

### 2. Pago en Caja

- Cuando `cdViaPago = 'CA'`, los datos bancarios se envían vacíos

### 3. Código de Municipio

- Se extrae de la primera retención que no sea 'R' ni 'I'
- Se utiliza en las referencias z05 y en el código de retención complementaria

### 4. Transformación de Fechas

- Todas las fechas se convierten al formato ISO: `YYYY-MM-DD`

### 5. Tipo de Reserva con Ajuste

- Si el concepto termina en 'A' o 'M', se concatena 'A' al tipo de reserva

### 6. Clase de Cuenta

- Resumen: `'K'` (Acreedor)
- Detalle: `'S'` (Cuenta de gasto/ingreso)

### 7. Concatenación de Códigos

- Oficina y Centro de Costos = `cdCompania + cdOficinaRadicacion`
- Indicador de Impuestos en Detalle = `cdCompania + cdIndicadorImpuesto`

## Validaciones

El paquete implementa las siguientes validaciones:

1. **Validación de Parámetros de Seguridad:**
   - Verifica que `CLIENT_ID` no esté nulo o vacío
   - Verifica que `SECRET` no esté nulo o vacío
   - Lanza error `-20001` o `-20002` si fallan

2. **Generación de IDs de Correlación:**
   - Utiliza `pck_gnl_integration_utils.fn_gnl_get_correlation_id()`
   - Asegura trazabilidad de la transacción

## Dependencias

El paquete depende de:

1. **Tipos de Datos:**
   - `OBJ_SAP_CXP_SINIESTROS` y tipos relacionados
   - `OBJ_CPI_CAUSACION_CONTABLE` y tipos relacionados

2. **Paquetes:**
   - `PCK_PARAMETROS`: Para obtener parámetros de configuración
   - `pck_gnl_integration_utils`: Para generar IDs de correlación

3. **Tablas:**
   - `TCOB_PARAMETROS_SAP`: Para almacenar credenciales

## Notas de Implementación

- **Versión del Paquete:** 1.0.0
- **Fecha de Creación:** 2025-09-17
- **Última Modificación:** 2025-12-05 (Ajustes para Siniestros de global)
- **Estrategia de Serialización:** `OBJ_ATR_CPI_JSON_CAUSACION_STRATEGY`

## Conclusión

Este mapeo transforma completamente la estructura de datos de siniestros desde el formato SAP CXP hacia el formato estandarizado de causación contable CPI. La transformación incluye:

- Reestructuración completa de la jerarquía de datos
- Aplicación de reglas de negocio específicas
- Validaciones de seguridad y parametrización
- Formateo de fechas y concatenación de códigos
- Manejo condicional de datos bancarios según vía de pago
- Preservación de trazabilidad mediante IDs de correlación

La función `map_sap_cxp_to_causacion` del paquete `pck_sin_adaptador_cpi` es el componente central que ejecuta esta transformación de manera consistente y confiable.
