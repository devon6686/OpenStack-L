rabbitmq-server:
  pkg.installed: 
    - unless: rpm -qa|grep rabbitmq-server
  service.running:
    - enable: True
    
salt://dev/env/rabbitmq/rabbitmq-init.sh:
  cmd.script:
    - template: jinja
    - require:
      - service: rabbitmq-server
    - defaults:
      RABBITMQ_USER: {{ salt['pillar.get']('basic:rabbitmq:USER') }}
      RABBITMQ_PASS: {{ salt['pillar.get']('basic:rabbitmq:PASS') }}

