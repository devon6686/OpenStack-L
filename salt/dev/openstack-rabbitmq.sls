rabbitmq-orch:
  salt.state:
    - tgt: '*'
    - sls:
      - dev.env.rabbitmq
    - require:
      - salt: mongod-orch
