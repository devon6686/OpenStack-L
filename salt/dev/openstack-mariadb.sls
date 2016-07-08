mariadb-orch:
  salt.state:
    - tgt: '*'
    - sls:
      - dev.env.mariadb
    - require:
      - salt: chrony-orch
