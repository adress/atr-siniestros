/*
    ============================================================================
    Archivo: adaptadores/pck_sin_adaptador_cpi.sql
    Descripción: Paquete adaptador que mapea objetos origen (por ejemplo,
                 OBJ_SAP_CXP_SINIESTROS) a OBJ_CPI_CAUSACION_CONTABLE.
    Autor: Jaime Andres Ortiz
    Fecha: 2025-09-17
    Versión: 1.0.0
    Notas:
      - Depende de los tipos OBJ_CPI_CAUSACION_CONTABLE y tipos relacionados.
      - Usado para transformar mensajes de origen a la estructura estándar CPI.

    Cambios:
      - 2025-09-17: Cabecera añadida.
    ============================================================================
*/

create or replace package pck_sin_adaptador_cpi is
  -- Mapea un objeto OBJ_SAP_CXP_SINIESTROS a OBJ_CPI_CAUSACION_CONTABLE
   function map_sap_cxp_to_causacion (
      i_obj in obj_sap_cxp_siniestros
   ) return obj_cpi_causacion_contable;
end pck_sin_adaptador_cpi;
/


create or replace package body pck_sin_adaptador_cpi is

   function map_sap_cxp_to_causacion (
      i_obj in obj_sap_cxp_siniestros
   ) return obj_cpi_causacion_contable is
      v_header            obj_cpi_headers;
      v_control           obj_cpi_causa_control;
      v_cabecera          obj_cpi_causa_cabecera;
      v_posiciones        tab_cpi_causa_posicion := tab_cpi_causa_posicion();
      v_param_adicionales tab_cpi_causa_param_adicional := tab_cpi_causa_param_adicional();
      v_param_adicional   obj_cpi_causa_param_adicional;
      v_resumen           obj_cpi_causa_pos_resumen;
      v_detalles          tab_cpi_causa_pos_detalle;
      v_descuento         obj_cpi_causa_pos_descuento;
      v_retenciones       tab_cpi_causa_pos_retencion;
      v_tercero           obj_cpi_causa_pos_tercero;
      v_doc               obj_sap_documento_cxp_sini;
      v_ret               obj_sap_dato_retencion;
      v_detalle_cxp       obj_sap_detalle_cxp_sini;
      v_idx_doc           pls_integer;
      v_idx_ret           pls_integer;
      v_idx_param         pls_integer;
      v_idx_param_pos     pls_integer;
      v_idx_pos           pls_integer;
      v_codigo_municipio  varchar2(100); -- Nuevo: para guardar el código de municipio de la retención
      o_obj               obj_cpi_causacion_contable;
   begin
    -- HEADERS
      v_header := obj_cpi_headers(
         request_id              => 'Prueba_Fenix',
         ref_src_1               => '123',
         target_system           => 'sap',
         target_system_process   => 'siniestros_cxp',
         source_application_name => 'atr',
         integration_method      => 'bd-async',
         key                     => '57W1hRyXRLSiswMg9RSL6DOGymReG9paAKY33CkGBltwBGMz',
         secret                  => 'gAAAAABo1avf8BCP-W3xacUJPQXwJ9tE9Fqb7i3ifloNOQSxkz-94Yi1Kn77g0FgeWc8Ev30UpwTi4eHZqo_1OKRV8i9xHE2mMT9RzVoWBpmIz8zuPQFKh4qsL6jf5Xasqf72gcyn7_i1yNDD7k2LotUCQzkCPmZbTFgU34YjhY2jxjMkr_M_o4='
         ,
         correlation_id          => pck_gnl_integration_utils.fn_gnl_get_correlation_id()
      );

    -- CONTROL
      v_control := obj_cpi_causa_control(
         sistemaorigen => 'ATRSINIEST',
         identificador => i_obj.cabecera.nmordenpago
      );
      
      -- CABECERA: determinacionContable, datosGenerales, parametrosAdicionales
      v_cabecera := obj_cpi_causa_cabecera(
         determinacioncontable => obj_cpi_causa_det_contable(
            canal      => i_obj.cabecera.datosconversionorigen.cdcanal,
            fuente     => i_obj.cabecera.datosconversionorigen.cdfuente,
            operacion  => 'CXP', -- No existe nmOperacion en la fuente, pero se pone el del excel #confirmar
            aplicacion => i_obj.cabecera.datosconversionorigen.nmaplicacion  -- 79
         ),
         datosgenerales        => obj_cpi_causa_cab_datos_generales(
            sociedad         => i_obj.cabecera.cdcompania, -- dato homologado #confrimar
            fechadocumento   => to_char(i_obj.cabecera.fefactura,'YYYY-MM-DD'),
            fechacontable    => to_char(i_obj.cabecera.feregistrosap,'YYYY-MM-DD'),
            moneda           => i_obj.cabecera.cdmoneda,
            referencia       => i_obj.cabecera.nmordenpago,
            clavereferencia1 => i_obj.documentoscxp(i_obj.documentoscxp.first)
                                 .detalleSiniestros(i_obj.documentoscxp(i_obj.documentoscxp.first)
                                 .detalleSiniestros.first).nmpoliza,
            clavereferencia2 => i_obj.documentoscxp(i_obj.documentoscxp.first)
                                 .detalleSiniestros(i_obj.documentoscxp(i_obj.documentoscxp.first)
                                 .detalleSiniestros.first).cdramo,
            texto            => i_obj.cabecera.nmfactura,
            tipocambio       => '', -- Siempre vacio en siniestros no hay dolares
            fechatipocambio  => ''  -- Segun homo previa
         ),
         parametrosadicionales => tab_cpi_causa_param_adicional(obj_cpi_causa_param_adicional('', ''))
      );

    -- POSICIONES[]: posiciones[i].resumen, posiciones[i].detalle[m]

      -- Se itera sobre documetnos documentoscxp
      v_idx_doc := i_obj.documentoscxp.first;
      while v_idx_doc is not null loop
         v_doc := i_obj.documentoscxp(v_idx_doc);

      -- Retenciones
      -- posiciones[i].resumen.retenciones[j]
         v_retenciones := tab_cpi_causa_pos_retencion();
         v_codigo_municipio := null; -- Inicializar antes de procesar retenciones
         v_idx_ret := v_doc.retenciones.first;
         while v_idx_ret is not null loop
            v_ret := v_doc.retenciones(v_idx_ret);
            -- Si el indicador no es R ni I, guardar el código de municipio
            if v_ret.cdIndicadorRetencion not in ('R', 'I') then
               v_codigo_municipio := v_ret.cdIndicadorRetencion;
            end if;
            v_retenciones.extend;
            v_retenciones(v_retenciones.last) := obj_cpi_causa_pos_retencion(
               tipoRetencion         => 
                  case 
                     when v_ret.cdIndicadorRetencion = 'R' then v_ret.cdTipoRetencion || '_RF'
                     when v_ret.cdIndicadorRetencion = 'I' then v_ret.cdTipoRetencion || '_RI'
                     else v_codigo_municipio || v_ret.cdTipoRetencion  || '_RC'
                  end,
               indicadorRetencion    => 
                  case 
                     when v_ret.cdIndicadorRetencion = 'R' then v_ret.cdTipoRetencion || '_RF'
                     when v_ret.cdIndicadorRetencion = 'I' then v_ret.cdTipoRetencion || '_RI'
                     else v_codigo_municipio || v_ret.cdTipoRetencion  || '_RC'
                  end,
               valorBaseRetencion    => to_char(v_ret.ptBaseRetencion),
               valorRetencion        => to_char(v_ret.ptRetencion)
            );
            v_idx_ret := v_doc.retenciones.next(v_idx_ret);
         end loop;

      -- Tercero
      -- POSICIONES[I].RESUMEN.TERCERO: general, pagadorAlternativo, datosBancarios, determinacionBancaria, parametrosAdicionales

         v_tercero := obj_cpi_causa_pos_tercero(
            general               => obj_cpi_causa_pos_tercero_general(
               codigotercero      => '',  --#pendiente  (01 Persona Natural, 02 Persona Juridica)
               tipoidentificacion => i_obj.tercero.informacionfiscal.cdtipoidentificacion,
               identificacion     => i_obj.tercero.informacionfiscal.nmidentificacion
            ),
            pagadoralternativo    => obj_cpi_causa_pos_tercero_pagador(
               tipoidentificacion => '',  --enviar vacio
               identificacion     => ''   --enviar vacio
            ),
            datosbancarios        => obj_cpi_causa_pos_tercero_bancario(
               paisbanco          => i_obj.tercero.cuentabancaria.cdpaisbanco,
               banco              => i_obj.tercero.cuentabancaria.cdbanco,
               cuenta             => i_obj.tercero.cuentabancaria.nmcuenta,
               tipocuenta         => i_obj.tercero.cuentabancaria.cdtipocuenta, -- (01 Cuenta corriente, 02 Cuenta de ahorros, 03 TC, 04 Libro mayor)
               tipoidentificacion => i_obj.tercero.informacionfiscal.cdtipoidentificacion,
               identificacion     => i_obj.tercero.informacionfiscal.nmidentificacion,
               nombretitular      => i_obj.tercero.cuentabancaria.dsTitular,
               apuntadorcuenta    => '' -- enviar vacio
            ),
            determinacionbancaria => obj_cpi_causa_pos_tercero_det_bancaria(
               tipoidentificacion => i_obj.tercero.informacionfiscal.cdtipoidentificacion,
               identificacion     => i_obj.tercero.informacionfiscal.nmidentificacion,
               clavereferencia1   => v_doc.nmpoliza,
               clavereferencia2   => v_doc.cdramo
            )
         );

      -- POSICIONES[I].RESUMEN.DESCUENTO
         v_descuento := obj_cpi_causa_pos_descuento(
            condicionpago  => v_doc.condicionpago.cdcondicionpago,
            base           => v_doc.condicionpago.ptimportedpp,
            valor          => '',
            dias01         => v_doc.condicionpago.nmdias,
            dias02         => '',
            dias03         => '',
            porcentaje01   => v_doc.condicionpago.podescuento,
            porcentaje02   => ''
         );

      -- POSICIONES[I].RESUMEN
         v_resumen := obj_cpi_causa_pos_resumen(
            -- posiciones[i].resumen.parametrosContables
            parametroscontables   => obj_cpi_causa_pos_param_contable(
               parametro01 => i_obj.cabecera.cdcompania,
               parametro02 => null,
               parametro03 => case
                  when substr(v_doc.cdConcepto, -1) in ('A', 'M') then v_doc.cdTipoReserva || 'A'
                  else v_doc.cdTipoReserva
               end,
               parametro04 => v_doc.cdoperacion,
               parametro05 => null,
               parametro06 => null,
               parametro07 => null,
               parametro08 => null,
               parametro09 => null,
               parametro10 => null
            ),
            -- posiciones[i].resumen.datosgenerales
            datosgenerales        => obj_cpi_causa_pos_datos_generales(
               clasecuenta       => 'K',                       --  K = acreedor
               sociedad          => '',                        
               valor             => to_char(v_doc.ptimporte),  
               indicadorimpuesto => v_doc.cdiva,
               oficina           => i_obj.cabecera.cdcompania || v_doc.detalleSiniestros(v_doc.detalleSiniestros.first).cdoficinaradicacion,
               centrocostos      => i_obj.cabecera.cdcompania || v_doc.detalleSiniestros(v_doc.detalleSiniestros.first).cdoficinaradicacion,
               indicadorbloqueo  => v_doc.cdbloqueopago,
               viapago           => v_doc.cdviapago,
               fechainicio       => to_char(v_doc.detalleSiniestros(v_doc.detalleSiniestros.first).feaviso, 'YYYY-MM-DD'),
               clavereferencia1  => v_doc.nmpoliza,         --número de identificación fiscal del tercero enviar nmIdentificacion del tercero
               clavereferencia2  => v_doc.cdramo,           
               clavereferencia3  => '',                     -- Enviar vacio
               asignacion        => null,                   -- #Enviar nmIdentificacion del tercero
               texto             => v_doc.detalleSiniestros(v_doc.detalleSiniestros.first).dsTextoPosicion, -- dsTextoPosicion del primer detalle
               contrato          => '',                     -- #pendiente Luis:(Si se maneja para unos pagos como onorarios pero no se almacena el numero del contrato)
               lineadenegocio    => v_doc.cdramo,          
               asesor            => v_doc.detalleSiniestros(v_doc.detalleSiniestros.first).cdIntermediario, -- Primer detalle: cdIntermediario
               zreferencia01     => v_doc.nmpoliza,         
               zreferencia02     => null,                   -- #pendiente *<Tipo de operacion> (PENDIENTE SAP)
               zreferencia03     => 'Daly Ceneth Munoz Campo', --i_obj.tercero.dsNombre, -- Nombre completo del tercero (Zznombre)
               zreferencia04     => i_obj.tercero.informacionfiscal.nmIdentificacion, -- NIT (ZZNIT)
               zreferencia05     => v_codigo_municipio,      -- Código de municipio si aplica
               zreferencia06     => v_doc.detalleSiniestros(v_doc.detalleSiniestros.first).nmExpediente, -- Primer NMEXPEDIENTE
               zreferencia07     => null,                   -- #pendiente *<Poliza lider> Luis: No aplica 
               zreferencia08     => null,                   -- #pendiente *<Certificado lider> Luis: No aplica 
               zreferencia09     => null,                   -- #pendiente *<Valores totales de factura> Luis: (si se puede enviar pero requiere un desarrollo)
               zreferencia10     => '',
               zfecha01          => to_char(v_doc.detalleSiniestros(v_doc.detalleSiniestros.first).feOcurrencia, 'YYYY-MM-DD') -- Fecha fin vigencia (ZZFECVEN)
            ),
            descuento             => v_descuento,
            retenciones           => v_retenciones,
            tercero               => v_tercero,
            parametrosadicionales => tab_cpi_causa_param_adicional(obj_cpi_causa_param_adicional('', ''))
         );

         v_posiciones.extend;

         -- posiciones[i].DETALLE[m]: parametrosContables, datosGenerales, parametrosAdicionales

         -- posiciones[i].resumen.parametrosAdicionales[k]
         v_param_adicionales := tab_cpi_causa_param_adicional();
         v_idx_param_pos := i_obj.parametrosadicionales.items.first;
         while v_idx_param_pos is not null loop
            v_param_adicional := obj_cpi_causa_param_adicional(
               clave => i_obj.parametrosadicionales.items(v_idx_param_pos).key,
               valor => i_obj.parametrosadicionales.items(v_idx_param_pos).value
            );
            v_param_adicionales.extend;
            v_param_adicionales(v_param_adicionales.last) := v_param_adicional;
            v_idx_param_pos := i_obj.parametrosadicionales.items.next(v_idx_param_pos);
         end loop;

         -- posiciones[i]detalle[m]: parametrosContables, datosGenerales, parametrosAdicionales[n]
         v_detalles := tab_cpi_causa_pos_detalle();
         if v_doc.detalleSiniestros is not null then
            for idx_det in 1 .. v_doc.detalleSiniestros.count loop
               v_detalle_cxp := v_doc.detalleSiniestros(idx_det);
               v_detalles.extend;

               -- posiciones[i].detalle[m].parametrosContables
               v_detalles(v_detalles.last) := obj_cpi_causa_pos_detalle(
                  parametroscontables => obj_cpi_causa_pos_param_contable(
                     parametro01 => v_detalle_cxp.cdCompaniaParametro,
                     parametro02 => case
                        when i_obj.cabecera.cdCompania = '30' and v_detalle_cxp.cdConcepto = '1C' then 'N'
                        else v_detalle_cxp.cdRamoParametro
                     end,
                     parametro03 => v_detalle_cxp.cdTipoReserva,
                     parametro04 => v_detalle_cxp.cdOperacion,
                     parametro05 => v_detalle_cxp.cdConcepto,
                     parametro06 => null,
                     parametro07 => null,
                     parametro08 => null,
                     parametro09 => null,
                     parametro10 => null
                  ),
                  -- posiciones[i].detalle[m].datosGenerales
                  datosgenerales => obj_cpi_causa_pos_datos_generales(
                     clasecuenta       => 'S',                                   -- S cuenta de mayor
                     sociedad          => '',                                    
                     valor             => to_char(v_detalle_cxp.ptImporte),
                     indicadorimpuesto => v_detalle_cxp.cdIndicadorImpuesto,
                     oficina           => i_obj.cabecera.cdcompania || v_doc.detalleSiniestros(v_doc.detalleSiniestros.first).cdoficinaradicacion,
                     centrocostos      => i_obj.cabecera.cdcompania || v_doc.detalleSiniestros(v_doc.detalleSiniestros.first).cdoficinaradicacion,
                     indicadorbloqueo  => null,
                     viapago           => null,
                     fechainicio       => to_char(v_detalle_cxp.feAviso, 'YYYY-MM-DD'),
                     clavereferencia1  => v_detalle_cxp.nmPoliza,
                     clavereferencia2  => v_detalle_cxp.cdRamo,
                     clavereferencia3  => v_detalle_cxp.cdIntermediario,
                     asignacion        => null,
                     texto             => v_detalle_cxp.dsTextoPosicion,
                     contrato          => null,
                     lineadenegocio    => null,
                     asesor            => null,
                     zreferencia01     => v_detalle_cxp.nmPoliza,
                     zreferencia02     => '',                                                      -- #pendiente SAP
                     zreferencia03     => 'Daly Ceneth Munoz Campo',--i_obj.tercero.dsNombre,                                  
                     zreferencia04     => i_obj.tercero.informacionfiscal.nmIdentificacion,        
                     zreferencia05     => v_codigo_municipio,                                                    -- #pendiente SAP
                     zreferencia06     => v_detalle_cxp.nmExpediente,
                     zreferencia07     => null,                                                    -- #pendiente SAP
                     zreferencia08     => null,                                                    -- #pendiente SAP
                     zreferencia09     => null,                                                    -- #pendiente SAP
                     zreferencia10     => '',
                     zfecha01          => to_char(v_detalle_cxp.feOcurrencia, 'YYYY-MM-DD')
                  ),
                  -- posiciones[i].detalle[m].parametrosAdicionales[n]
                  parametrosadicionales => v_param_adicionales
               );
            end loop;
         end if;

         -- Agregar la posición
         -- posiciones[i]
         v_posiciones(v_posiciones.last) := obj_cpi_causa_posicion(
            resumen => v_resumen,
            detalle => v_detalles
         );

         v_idx_doc := i_obj.documentoscxp.next(v_idx_doc);
      end loop;

      -- construir el objeto  causacion contable
      o_obj := obj_cpi_causacion_contable(
         headers    => v_header,
         control    => v_control,
         cabecera   => v_cabecera,
         posiciones => v_posiciones
      );

      return o_obj;
   end map_sap_cxp_to_causacion;

end pck_sin_adaptador_cpi;
/