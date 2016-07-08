glance-orch:
  salt.state:
    - tgt: '*'
    - sls:
      - dev.openstack.glance
    - require:
      - salt: keystone-orch
