nova-orch:
  salt.state:
    - tgt: '*'
    - sls:
      - dev.openstack.nova
    - require:
      - salt: glance-orch
