glusterfs-orch:
  salt.state:
    - tgt: '*'
    - sls:
      - dev.env.glusterfs
    - require:
      - salt: rabbitmq-orch
