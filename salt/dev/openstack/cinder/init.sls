include:
  - dev.openstack.cinder.cinder-mysql

salt://dev/openstack/cinder/cinder.sh:
  cmd.script:
    - template: jinja
    - defaults:
      HOST: {{ grains['host'] }}
      AUTH_CINDER_PASS: {{ salt['pillar.get']('cinder:AUTH_CINDER_PASS') }}

cinder-init:
  pkg.installed:
    - pkgs:
      - openstack-cinder
      - python-cinderclient

/etc/cinder/cinder.conf:
  file.managed:
    - template: jinja
    - source: salt://dev/openstack/cinder/templates/cinder.conf.template
    - user: cinder
    - group: cinder
    - mode: 644
    - require:
      - pkg: cinder-init
    - defaults:
{% set HOSTNAME=grains['host'] %}
{% set CINDER_HOST=salt['pillar.get']('basic:nova:CONTROLLER:HOST') %}
      HOST: {{ grains['host'] }}
      HOST_IP: {{ CINDER_HOST.get(HOSTNAME,'') }}
      MYSQL_CINDER_USER: {{ salt['pillar.get']('cinder:MYSQL_CINDER_USER') }}
      MYSQL_CINDER_PASS: {{ salt['pillar.get']('cinder:MYSQL_CINDER_PASS') }}
      MYSQL_CINDER_DBNAME: {{ salt['pillar.get']('cinder:MYSQL_CINDER_DBNAME') }}
      AUTH_CINDER_USER: {{ salt['pillar.get']('cinder:AUTH_CINDER_USER') }}
      AUTH_CINDER_PASS: {{ salt['pillar.get']('cinder:AUTH_CINDER_PASS') }}
      RABBIT_USER: {{ salt['pillar.get']('basic:rabbitmq:USER') }}
      RABBIT_PASS: {{ salt['pillar.get']('basic:rabbitmq:PASS') }}
      RABBIT_HOST: {{ salt['pillar.get']('basic:rabbitmq:HOST') }}

/etc/cinder/shares.conf:
  file.managed:
    - template: jinja
    - source: salt://dev/openstack/cinder/templates/shares.conf.template
    - require:
      - pkg: cinder-init
    - defaults:
      VOLUME_URL: {{ salt['pillar.get']('basic:cinder:VOLUME_URL') }}

/var/lib/cinder/volumes:
  file.directory:
    - user: cinder
    - group: cinder
    - dir_mode: 755

cinder-db-sync:
  cmd.run:
    - name: su -s /bin/sh -c "cinder-manage db sync" cinder
    - require:
      - pkg: cinder-init
      - file: /etc/cinder/cinder.conf

openstack-cinder:
  service.running:
    - names: 
      - openstack-cinder-api
      - openstack-cinder-scheduler
      - openstack-cinder-volume
    - enable: True
    - require:
      - pkg: cinder-init

