httpd:
  service.running:
    - enable: True
    - watch:
      - file: /etc/httpd/conf/httpd.conf
      - file: /etc/httpd/conf.d/wsgi-keystone.conf

/etc/httpd/conf/httpd.conf:
  file.append:
    - text: " ServerName {{ grains['host'] }}" 

/etc/httpd/conf.d/wsgi-keystone.conf:
  file.managed:
    - source: salt://dev/openstack/keystone/templates/wsgi-keystone.conf.template
    - mode: 644

memcached:
  service.running:
    - enable: True
    - watch:
      - file: /etc/httpd/conf/httpd.conf
      - file: /etc/httpd/conf.d/wsgi-keystone.conf

keystonerc:
  file.managed:
    - name: /root/keystonerc
    - source: salt://dev/openstack/keystone/templates/keystonerc.template
    - template: jinja
    - defaults:
      ADMIN_USER: {{ salt['pillar.get']('keystone:ADMIN_USER') }}
      ADMIN_PASS: {{ salt['pillar.get']('keystone:ADMIN_PASS') }}
      KEYSTONE_ENDPOINT: {{ salt['pillar.get']('keystone_endpoint') }}
