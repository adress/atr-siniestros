/*
    ============================================================================
    Archivo: pck_sin_adaptador_cpi.sql
    Descripcion: Paquete adaptador que mapea objetos origen (por ejemplo,
                 OBJ_SAP_CXP_SINIESTROS) a OBJ_CPI_CAUSACION_CONTABLE.
    Autor: Jaime Andres Ortiz
    Fecha: 2025-09-17
    Version: 1.0.0
    Notas:
      - Depende de los tipos OBJ_CPI_CAUSACION_CONTABLE y tipos relacionados.
      - Usado para transformar mensajes de origen a la estructura estandar CPI.

    Cambios:
      - 2025-09-17: Cabecera anadida.
      - 2025-12-05: Ajustes para Siniestros de global.
    ============================================================================
*/
CREATE OR REPLACE PACKAGE OPS$PROCEDIM.PCK_SIN_ADAPTADOR_CPI is
  -- Mapea un objeto OBJ_SAP_CXP_SINIESTROS a OBJ_CPI_CAUSACION_CONTABLE
   function map_sap_cxp_to_causacion (
      i_obj                     IN obj_sap_cxp_siniestros,
      p_param_client_id         IN  VARCHAR2,
      p_param_client_secret     IN  VARCHAR2,
      p_sistema_origen          IN  VARCHAR2,
      p_source_application_name IN  VARCHAR2
   ) return obj_cpi_causacion_contable;
end pck_sin_adaptador_cpi;
/

CREATE OR REPLACE PACKAGE BODY OPS$PROCEDIM.PCK_SIN_ADAPTADOR_CPI is

   function map_sap_cxp_to_causacion (
      i_obj                     IN obj_sap_cxp_siniestros,
      p_param_client_id         IN  VARCHAR2,
      p_param_client_secret     IN  VARCHAR2,
      p_sistema_origen          IN  VARCHAR2,
      p_source_application_name IN  VARCHAR2
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
      o_obj               obj_cpi_causacion_contable;

      v_codigo_municipio  varchar2(100);
      v_correlation_id     varchar2(100);
      v_key    tcob_parametros_sap.cdusuario%type;
      v_secret tcob_parametros_sap.cdclave%type;
   begin

      v_correlation_id := pck_gnl_integration_utils.fn_gnl_get_correlation_id();
      -- Obtener key y secret desde parametros
      begin
          v_key    := NVL(PCK_PARAMETROS.FN_GET_PARAMETROV2('%', '%', p_param_client_id, SYSDATE, '*','*','*','*','*'), '');
          v_secret := NVL(PCK_PARAMETROS.FN_GET_PARAMETROV2('%', '%', p_param_client_secret,   SYSDATE, '*','*','*','*','*'), '');

          -- Validar que key y secret no sean nulos o vacios
          if v_key is null or trim(v_key) is null then
              raise_application_error(-20001, 'ERROR: El parametro CLIENT_ID esta nulo o vacio');
          end if;

          if v_secret is null or trim(v_secret) is null then
              raise_application_error(-20002, 'ERROR: El parametro SECRET esta nulo o vacio');
          end if;
      exception
          when others then
              raise_application_error(-20003, 'ERROR obteniendo parametros de seguridad: ' || SQLERRM);
      end;

    -- HEADERS
      v_header := obj_cpi_headers(
         request_id              => v_correlation_id,
         ref_src_1               => 'ref-001',
         target_system           => 'sap',
         target_system_process   => 'siniestros_cxp',
         source_application_name => p_source_application_name,
         integration_method      => 'bd-async',
         key                     => v_key,
         secret                  => v_secret,
         correlation_id          => v_correlation_id,
         its_batch_operation     => 0
      );

    -- CONTROL
      v_control := obj_cpi_causa_control(
         sistemaorigen => p_sistema_origen,
         identificador => pck_gnl_integration_utils.fn_gnl_get_correlation_id()  --i_obj.cabecera.nmordenpago
      );

      -- CABECERA: determinacionContable, datosGenerales, parametrosAdicionales
      v_cabecera := obj_cpi_causa_cabecera(
         determinacioncontable => obj_cpi_causa_det_contable(
            canal      => i_obj.cabecera.datosconversionorigen.cdcanal,
            fuente     => i_obj.cabecera.datosconversionorigen.cdfuente,
            operacion  => 'CXP', 
            aplicacion => i_obj.cabecera.datosconversionorigen.nmaplicacion
         ),
         datosgenerales        => obj_cpi_causa_cab_datos_generales(
            sociedad         => i_obj.cabecera.cdcompania,
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
            texto            => NVL(i_obj.cabecera.nmfactura, 'REGISTRO SINIESTRO SEGURO'), --si no tiene factura, esta en blanco enviar "REGISTRO SINIESTRO SEGURO"
            tipocambio       => '',
            fechatipocambio  => ''
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
         v_codigo_municipio := null;
         v_idx_ret := v_doc.retenciones.first;
         while v_idx_ret is not null loop
            v_ret := v_doc.retenciones(v_idx_ret);
            -- Si el indicador no es R ni I, guardar el codigo de municipio
            if v_ret.cdIndicadorRetencion not in ('R', 'I') then
               v_codigo_municipio := v_ret.cdIndicadorRetencion;
            end if;
            v_retenciones.extend;
            v_retenciones(v_retenciones.last) := obj_cpi_causa_pos_retencion(
               tipoRetencion         => 
                  case 
                     when v_ret.cdIndicadorRetencion = 'R' then i_obj.cabecera.cdcompania || v_ret.cdTipoRetencion || '_RF'
                     when v_ret.cdIndicadorRetencion = 'I' then i_obj.cabecera.cdcompania || v_ret.cdTipoRetencion || '_RI'
                     else i_obj.cabecera.cdcompania || v_codigo_municipio || v_ret.cdTipoRetencion  || '_RC'
                  end,
               indicadorRetencion    => 
                  case 
                     when v_ret.cdIndicadorRetencion = 'R' then i_obj.cabecera.cdcompania || v_ret.cdTipoRetencion || '_RF'
                     when v_ret.cdIndicadorRetencion = 'I' then i_obj.cabecera.cdcompania || v_ret.cdTipoRetencion || '_RI'
                     else i_obj.cabecera.cdcompania || v_codigo_municipio || v_ret.cdTipoRetencion  || '_RC'
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
               codigotercero      => '',
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
               indicadorimpuestos => v_doc.cdiva,
               oficina           => i_obj.cabecera.cdcompania || v_doc.detalleSiniestros(v_doc.detalleSiniestros.first).cdoficinaradicacion,
               centrocostos      => i_obj.cabecera.cdcompania || v_doc.detalleSiniestros(v_doc.detalleSiniestros.first).cdoficinaradicacion,
               centroBeneficios  => null,
               indicadorbloqueo  => v_doc.cdbloqueopago,
               viapago           => v_doc.cdviapago,
               fechainicio       => to_char(v_doc.detalleSiniestros(v_doc.detalleSiniestros.first).feaviso, 'YYYY-MM-DD'),
               clavereferencia1  => i_obj.tercero.informacionfiscal.nmidentificacion,         --numero de identificacion fiscal del tercero enviar nmIdentificacion del tercero
               clavereferencia2  => v_doc.cdramo,           
               clavereferencia3  => '',                     -- Enviar vacio
               asignacion        => i_obj.tercero.informacionfiscal.nmidentificacion,                   -- #Enviar nmIdentificacion del tercero
               texto             => v_doc.detalleSiniestros(v_doc.detalleSiniestros.first).dsTextoPosicion, -- dsTextoPosicion del primer detalle
               contrato          => '',                     
               lineadenegocio    => v_doc.cdramo,          
               asesor            => v_doc.detalleSiniestros(v_doc.detalleSiniestros.first).cdIntermediario, -- Primer detalle: cdIntermediario
               zreferencia01     => v_doc.nmpoliza,         
               zreferencia02     => null,                   
               zreferencia03     => i_obj.tercero.dsNombre,
               zreferencia04     => i_obj.tercero.informacionfiscal.nmIdentificacion,
               zreferencia05     => v_codigo_municipio,
               zreferencia06     => v_doc.detalleSiniestros(v_doc.detalleSiniestros.first).nmExpediente, -- Primer NMEXPEDIENTE
               zreferencia07     => null,                   
               zreferencia08     => null,                   
               zreferencia09     => null,                   
               zreferencia10     => '',
               zfecha01          => to_char(v_doc.detalleSiniestros(v_doc.detalleSiniestros.first).feOcurrencia, 'YYYY-MM-DD') 
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
                     clasecuenta       => 'S',                                  
                     sociedad          => '',                                    
                     valor             => to_char(v_detalle_cxp.ptImporte),
                     indicadorimpuestos => i_obj.cabecera.cdcompania || v_detalle_cxp.cdIndicadorImpuesto,
                     oficina           => i_obj.cabecera.cdcompania || v_doc.detalleSiniestros(v_doc.detalleSiniestros.first).cdoficinaradicacion,
                     centrocostos      => i_obj.cabecera.cdcompania || v_doc.detalleSiniestros(v_doc.detalleSiniestros.first).cdoficinaradicacion,
                     centroBeneficios  => null,
                     indicadorbloqueo  => null,
                     viapago           => null,
                     fechainicio       => to_char(v_detalle_cxp.feAviso, 'YYYY-MM-DD'),
                     clavereferencia1  => i_obj.tercero.informacionfiscal.nmidentificacion, --NUMERO IDENTIFICACION TERCERO
                     clavereferencia2  => v_detalle_cxp.cdRamo,
                     clavereferencia3  => v_detalle_cxp.cdIntermediario,
                     asignacion        => i_obj.tercero.informacionfiscal.nmidentificacion, --NUMERO IDENTIFICACION TERCERO
                     texto             => v_detalle_cxp.dsTextoPosicion,
                     contrato          => null,
                     lineadenegocio    => null,
                     asesor            => null,
                     zreferencia01     => v_detalle_cxp.nmPoliza,
                     zreferencia02     => '',                                                      
                     zreferencia03     => i_obj.tercero.dsNombre,                                
                     zreferencia04     => i_obj.tercero.informacionfiscal.nmIdentificacion,        
                     zreferencia05     => v_codigo_municipio,                                                    
                     zreferencia06     => v_detalle_cxp.nmExpediente,
                     zreferencia07     => null,                                                    
                     zreferencia08     => null,                                                    
                     zreferencia09     => null,                                                    
                     zreferencia10     => '',
                     zfecha01          => to_char(v_detalle_cxp.feOcurrencia, 'YYYY-MM-DD')
                  ),
                  -- posiciones[i].detalle[m].parametrosAdicionales[n]
                  parametrosadicionales => v_param_adicionales
               );
            end loop;
         end if;

         -- Agregar la posicion
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