openstack-dashboard:
  pkg.installed: []

/etc/openstack-dashboard/local_settings:
  file.managed:
    - source: salt://dev/openstack/horizon/templates/local_settings.template
    - mode: 644
    - user: apache
    - group: apache
    - template: jinja
    - require:
      - pkg: openstack-dashboard
    - defaults:
{% set HOSTNAME=grains['host'] %}
{% set HOST=salt['pillar.get']('basic:neutron:HOST')  %}
      IP: {{ HOST.get(HOSTNAME,'0.0.0.0') }}
      
dashboard:
  cmd.run:
    - name: systemctl restart httpd memcached    

