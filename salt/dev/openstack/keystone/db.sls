keystone-table-sync:
  cmd.run:
    - name: su -s /bin/sh -c "keystone-manage db_sync" keystone

