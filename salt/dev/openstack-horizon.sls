horizon-orch:
  salt.state:
    - tgt: '*'
    - sls:
      - dev.openstack.horizon
    - require:
      - salt: neutron-orch

openstack-services:
  salt.function:
    - tgt: '*'
    - arg:
      - openstack-service restart
