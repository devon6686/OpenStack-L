keystone-orch:
  salt.state:
    - tgt: '*'
    - sls:
      - dev.openstack.keystone
    - require:
      - salt: glusterfs-orch
