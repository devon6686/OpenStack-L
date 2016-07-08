keystone-init:
  pkg.installed:
    - pkgs:
      - python-keystoneclient
      - python-openstackclient
      - openstack-keystone
      - httpd
      - mod_wsgi
      - memcached
      - python-memcached
    - unless: rpm -qa|grep openstack-keystone

/etc/keystone/keystone.conf:
  file.managed:
    - source: salt://dev/openstack/keystone/templates/keystone.conf.template
    - user: keystone
    - group: keystone
    - mode: 640
    - template: jinja
    - defaults:
      HOST: {{ grains['host'] }}
      MYSQL_KEYSTONE_USER: {{ salt['pillar.get']('keystone:MYSQL_KEYSTONE_USER') }}
      MYSQL_KEYSTONE_PASS: {{ salt['pillar.get']('keystone:MYSQL_KEYSTONE_PASS') }}
      MYSQL_KEYSTONE_DBNAME: {{ salt['pillar.get']('keystone:MYSQL_KEYSTONE_DBNAME') }}
      ADMIN_TOKEN: {{ salt['pillar.get']('keystone:ADMIN_TOKEN') }}


keystone-table-sync:
  cmd.run:
    - name: su -s /bin/sh -c "keystone-manage db_sync" keystone
    - require:
      - file: /etc/keystone/keystone.conf

