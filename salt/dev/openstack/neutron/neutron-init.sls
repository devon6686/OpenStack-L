openstack-neutron:
  pkg.installed:
    - pkgs:
      - openstack-neutron
      - openstack-neutron-ml2
      - openstack-neutron-linuxbridge
      - python-neutronclient
      - ebtables
      - ipset
      
/etc/neutron/plugin.ini:
   file.symlink:
      - target: /etc/neutron/plugins/ml2/ml2_conf.ini
      - require:
        - pkg: openstack-neutron

/etc/neutron/neutron.conf:
  file.managed:
    - source: salt://dev/openstack/neutron/templates/neutron.conf.template
    - template: jinja
    - mode: 644
    - user: neutron
    - group: neutron
    - defaults:
      HOST: {{ grains['host'] }}
      AUTH_NEUTRON_USER: {{ salt['pillar.get']('neutron:AUTH_NEUTRON_USER') }}  
      AUTH_NEUTRON_PASS: {{ salt['pillar.get']('neutron:AUTH_NEUTRON_PASS') }}  
      AUTH_NOVA_PASS: {{ salt['pillar.get']('nova:AUTH_NOVA_PASS') }}  
      MYSQL_NEUTRON_USER: {{ salt['pillar.get']('neutron:MYSQL_NEUTRON_USER') }}  
      MYSQL_NEUTRON_PASS: {{ salt['pillar.get']('neutron:MYSQL_NEUTRON_PASS') }}  
      MYSQL_NEUTRON_DBNAME: {{ salt['pillar.get']('neutron:MYSQL_NEUTRON_DBNAME') }}  
      RABBIT_USER: {{ salt['pillar.get']('basic:rabbitmq:USER') }}
      RABBIT_PASS: {{ salt['pillar.get']('basic:rabbitmq:PASS') }}
      RABBIT_HOST: {{ salt['pillar.get']('basic:rabbitmq:HOST') }}

{% for file1 in ['ml2_conf.ini','linuxbridge_agent.ini'] %}      
/etc/neutron/plugins/ml2/{{ file1 }}:
  file.managed:
    - source: salt://dev/openstack/neutron/templates/{{ file1 }}.template
    - template: jinja
    - mode: 644
    - user: neutron
    - group: neutron
    - defaults: 
      LOCAL_IP: {{ salt['pillar.get']('basic:neutron:LOCAL_IP') }}
      PUBLIC_INTERFACE: {{ salt['pillar.get']('basic:neutron:PUBLIC_INTERFACE') }}
{% endfor %}

{% for file2 in ['dhcp_agent.ini','metadata_agent.ini','dnsmasq-neutron.conf'] %}
/etc/neutron/{{ file2 }}:
  file.managed:
    - source: salt://dev/openstack/neutron/templates/{{ file2 }}.template
    - template: jinja
    - mode: 644
    - user: neutron
    - group: neutron
    - defaults:
      HOST: {{ grains['host'] }}
      AUTH_NEUTRON_USER: {{ salt['pillar.get']('neutron:AUTH_NEUTRON_USER') }}  
      AUTH_NEUTRON_PASS: {{ salt['pillar.get']('neutron:AUTH_NEUTRON_PASS') }}  
      METADATA_SECRET: {{ salt['pillar.get']('neutron:METADATA_SECRET') }}  
{% endfor %}
      
{% set NETWORK_TYPE = salt['pillar.get']('basic:neutron:TYPE') %}
{% if NETWORK_TYPE == 'self' %}
/etc/neutron/l3_agent.ini:
  file.managed:
    - source: salt://dev/openstack/neutron/templates/l3_agent.ini.template
    - template: jinja
    - mode: 644
    - user: neutron
    - group: neutron
{% endif %}

