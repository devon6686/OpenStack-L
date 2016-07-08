Mariadb:
  pkg.installed:
    - pkgs:
      - mariadb
      - mariadb-server
      - MySQL-python

  service.running:
    - name: mariadb
    - enable: True
    - require:
      - pkg: Mariadb
      - file: /etc/my.cnf
      - file: /etc/my.cnf.d/mariadb_openstack.cnf
    - watch:
      - file: /etc/my.cnf
      - file: /etc/my.cnf.d/mariadb_openstack.cnf


/etc/my.cnf:
  file.replace:
    - pattern: '!includedir /etc/my.cnf.d'
    - repl: 'includedir /etc/my.cnf.d'
    - count: 1

/etc/my.cnf.d/mariadb_openstack.cnf:
  file.managed:
    - source: salt://dev/env/mariadb/templates/openstack.cnf.template
    - template: jinja
    - defaults:
      BIND_IP: {{ salt['pillar.get']('basic:mariadb:HOST','') }} 

salt://dev/env/mariadb/mysql-init.sh:
  cmd.script:
    - template: jinja
    - require:
      - service: Mariadb
    - defaults:
      HOST: {{ salt['pillar.get']('basic:mariadb:HOST') }}
