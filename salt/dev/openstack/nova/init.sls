include:
  - dev.openstack.nova.nova-mysql
  - dev.openstack.nova.nova-auth
 
nova-init:
  pkg.installed:
    - pkgs:
      - openstack-nova-api
      - openstack-nova-cert
      - openstack-nova-conductor
      - openstack-nova-console
      - openstack-nova-novncproxy
      - openstack-nova-scheduler
      - python-novaclient
      - openstack-nova-compute
      - sysfsutils

/etc/nova/nova.conf:
  file.managed:
    - source: salt://dev/openstack/nova/templates/nova.conf.template
    - template: jinja
    - mode: 644
    - user: nova
    - group: nova
    - defaults:
{% set HOSTNAME=grains['host'] %}
{% set NOVA_HOST=salt['pillar.get']('basic:nova:CONTROLLER:HOST') %}
      HOST: {{ grains['host'] }}
      HOST_IP: {{ NOVA_HOST.get(HOSTNAME,'') }}
      RABBIT_USER: {{ salt['pillar.get']('basic:rabbitmq:USER') }}
      RABBIT_PASS: {{ salt['pillar.get']('basic:rabbitmq:PASS') }}
      RABBIT_HOST: {{ salt['pillar.get']('basic:rabbitmq:HOST') }}
      MYSQL_NOVA_USER: {{ salt['pillar.get']('nova:MYSQL_NOVA_USER','nova') }}
      MYSQL_NOVA_PASS: {{ salt['pillar.get']('nova:MYSQL_NOVA_PASS','nova') }}
      MYSQL_NOVA_DBNAME: {{ salt['pillar.get']('nova:MYSQL_NOVA_DBNAME','nova') }}
      AUTH_NOVA_USER: {{ salt['pillar.get']('nova:AUTH_NOVA_USER','nova') }}
      AUTH_NOVA_PASS: {{ salt['pillar.get']('nova:AUTH_NOVA_PASS','nova') }}
      AUTH_NEUTRON_USER: {{ salt['pillar.get']('neutron:AUTH_NEUTRON_USER') }}
      AUTH_NEUTRON_PASS: {{ salt['pillar.get']('neutron:AUTH_NEUTRON_PASS') }}
      METADATA_SECRET: {{ salt['pillar.get']('neutron:METADATA_SECRET') }}
      
nova-table-sync:
  cmd.run:
    - name: su -s /bin/sh -c "nova-manage db sync" nova
    - require:
      - file: /etc/nova/nova.conf

openstack-nova:
  service.running:
    - names:
      - openstack-nova-api
      - openstack-nova-cert
      - openstack-nova-consoleauth
      - openstack-nova-scheduler
      - openstack-nova-conductor
      - openstack-nova-novncproxy
    - enable: True
    - require:
      - pkg: nova-init
    - watch:
      - file: /etc/nova/nova.conf

openstack-nova-compute:
  service.running:
    - enable: True
    - watch:
      - file: /etc/nova/nova.conf
    - require:
      - pkg: nova-init
      - file: /etc/nova/nova.conf

libvirtd:
  service.running:
    - enable: True
    - watch:
      - service: messagebus

messagebus:
  service.running:
    - enable: True


