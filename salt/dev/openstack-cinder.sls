cinder-orch:
  salt.state:
    - tgt: '*'
    - sls:
      - dev.openstack.cinder
    - require:
      - salt: horizon-orch
