include:
  - dev.openstack.glance.glance-mysql
  - dev.openstack.glance.glance-init

openstack-glance:
  service.running:
    - names:
      - openstack-glance-api
      - openstack-glance-registry
    - enable: True
    - watch:
      - file: /etc/glance/glance-api.conf
      - file: /etc/glance/glance-registry.conf

{% for srv in ['api','registry'] %}
/etc/glance/glance-{{ srv }}.conf:
  file.managed:
    - source: salt://dev/openstack/glance/templates/glance-{{ srv }}.conf.template
    - template: jinja
    - mode: 640
    - user: glance
    - group: glance
    - defaults:
      HOST: {{ grains['host'] }}
      MYSQL_GLANCE_USER: {{ salt['pillar.get']('glance:MYSQL_GLANCE_USER') }}
      MYSQL_GLANCE_PASS: {{ salt['pillar.get']('glance:MYSQL_GLANCE_PASS') }}
      MYSQL_GLANCE_DBNAME: {{ salt['pillar.get']('glance:MYSQL_GLANCE_DBNAME') }}
      AUTH_GLANCE_USER: {{ salt['pillar.get']('glance:AUTH_GLANCE_USER') }}
      AUTH_GLANCE_PASS: {{ salt['pillar.get']('glance:AUTH_GLANCE_PASS') }}
{% endfor %}

glance-table-sync:
  cmd.run:
    - name: su -s /bin/sh -c "glance-manage db_sync" glance
    - require:
      - file: /etc/glance/glance-api.conf
      - file: /etc/glance/glance-registry.conf

