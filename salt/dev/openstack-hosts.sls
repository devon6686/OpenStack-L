hosts-orch:
  salt.state:
    - tgt: '*'
    - sls:
      - dev.env.hosts
