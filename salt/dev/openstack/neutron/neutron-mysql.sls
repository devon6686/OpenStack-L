mysql-neutron-db:
  mysql_database.present:
    - name: {{ salt['pillar.get']('neutron:MYSQL_NEUTRON_DBNAME','neutron') }}
    - connection_user: root
    - connection_pass: ''

{% for host in ['localhost','%'] %}
mysql-neutron-{{ host }}-grants:
  mysql_user.present:
    - name: {{ salt['pillar.get']('neutron:MYSQL_NEUTRON_USER','neutron') }}
    - host: '{{ host }}'
    - password: "{{ salt['pillar.get']('neutron:MYSQL_NEUTRON_PASS','neutron') }}"
    - connection_user: root
    - connection_pass: ''
    - require:
      - mysql_database: {{ salt['pillar.get']('neutron:MYSQL_NEUTRON_DBNAME','neutron') }}
  mysql_grants.present:
    - grant: all privileges
    - database: {{ salt['pillar.get']('neutron:MYSQL_NEUTRON_DBNAME','neutron') }}.*
    - user: {{ salt['pillar.get']('neutron:MYSQL_NEUTRON_USER','neutron') }}
    - host: '{{ host }}'
    - require:
      - mysql_database: {{ salt['pillar.get']('neutron:MYSQL_NEUTRON_DBNAME','neutron') }}
      - mysql_user: {{ salt['pillar.get']('neutron:MYSQL_NEUTRON_USER','neutron') }}
{% endfor %}
 
