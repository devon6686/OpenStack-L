mongod-orch:
  salt.state:
    - tgt: '*'
    - sls:
      - dev.env.mongod
    - require:
      - salt: mariadb-orch
