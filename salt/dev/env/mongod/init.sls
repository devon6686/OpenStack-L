Mongodb:
  pkg.installed:
    - pkgs:
      - mongodb-server
      - mongodb

  service.running:
    - name: mongod
    - enable: True
    - require:
      - pkg: Mongodb
      - file: /etc/mongod.conf

/etc/mongod.conf:
  file.managed:
    - source: salt://dev/env/mongod/templates/mongod.conf.template
    - template: jinja
    - defaults:
       BIND_IP: {{ salt['pillar.get']('basic:mongod:HOST') }}
