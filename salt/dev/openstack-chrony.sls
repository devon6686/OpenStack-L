chrony-orch:
  salt.state:
    - tgt: '*'
    - sls:
      - dev.env.chrony
    - require:
      - salt: hosts-orch

