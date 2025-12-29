BEGIN
  -- Intentar eliminar el ACL si ya existe
  BEGIN
    DBMS_NETWORK_ACL_ADMIN.DROP_ACL('acl_habilitadoressura.xml');
  EXCEPTION
    WHEN OTHERS THEN NULL;
  END;

  -- Crear ACL y asignar permisos a OPS$PROCEDIM
  DBMS_NETWORK_ACL_ADMIN.CREATE_ACL(
    acl         => 'acl_habilitadoressura.xml',
    description => 'Permitir HTTPS a apiinternal.labsura.com',
    principal   => 'OPS$PROCEDIM',
    is_grant    => TRUE,
    privilege   => 'connect'
  );

  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(
    acl       => 'acl_habilitadoressura.xml',
    principal => 'OPS$PROCEDIM',
    is_grant  => TRUE,
    privilege => 'resolve'
  );

  -- Usuario ADM_ATRSURA
  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(
    acl       => 'acl_habilitadoressura.xml',
    principal => 'ADM_ATRSURA',
    is_grant  => TRUE,
    privilege => 'connect'
  );

  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(
    acl       => 'acl_habilitadoressura.xml',
    principal => 'ADM_ATRSURA',
    is_grant  => TRUE,
    privilege => 'resolve'
  );

  -- Asignar el ACL al host y puerto
  DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL(
    acl        => 'acl_habilitadoressura.xml',
    host       => 'apiinternal.labsura.com',
    lower_port => 443,
    upper_port => 443
  );

  COMMIT;
END;
/

