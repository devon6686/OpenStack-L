include:
  - dev.openstack.neutron.neutron-auth
  - dev.openstack.neutron.neutron-mysql
  - dev.openstack.neutron.neutron-init

neutron-table-sync:
  cmd.run:
    - name: su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron

neutron-server:
  service.running:
    - enable: True
    - watch:
      - file: /etc/neutron/neutron.conf
      - file: /etc/neutron/plugins/ml2/ml2_conf.ini
    - require:
      - pkg: openstack-neutron
      - file: /etc/neutron/neutron.conf

{% set agent_list = ['linuxbridge','dhcp','metadata'] %}
{% for srv in agent_list %}
neutron-{{ srv }}-agent:
  service.running:
    - enable: True
    - watch:
      - service: neutron-server
{% if srv == 'linuxbridge' %}
      - file: /etc/neutron/plugins/ml2/linuxbridge_agent.ini
{% elif srv == 'dhcp' %}
      - file: /etc/neutron/dhcp_agent.ini
{% elif srv == 'metadata'  %}
      - file: /etc/neutron/metadata_agent.ini
{% endif %}
      - file: /etc/neutron/neutron.conf
{% endfor%}

{% set NETWORK_TYPE = salt['pillar.get']('basic:neutron:TYPE') %}
{% if NETWORK_TYPE == 'self' %}
neutron-l3-agent:
  service.running:
    - enable: True
    - watch:
      - service: neutron-server
      - file: /etc/neutron/neutron.conf
      - file: /etc/neutron/l3_agent.conf
{% endif %}

public-network-create:
  cmd.run:
    - name: source /root/keystonerc && neutron net-create public --shared --provider:physical_network public --provider:network_type flat
    - unless: neutron net-list|grep public


{% if NETWORK_TYPE == 'self' %}
update-public-network:
  cmd.run:
    - name: source /root/keystonerc && neutron net-update public --router:external
{% endif %}
