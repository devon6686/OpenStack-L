neutron-orch:
  salt.state:
    - tgt: '*'
    - sls:
      - dev.openstack.neutron
    - require:
      - salt: nova-orch
