nova-table-sync:
  cmd.run:
    - name: su -s /bin/sh -c "nova-manage db sync" nova

