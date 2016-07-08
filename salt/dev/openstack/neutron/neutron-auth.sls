salt://dev/openstack/neutron/neutron.sh:
  cmd.script:
    - template: jinja
    - defaults:
      HOST: {{ grains['host'] }}
      AUTH_NEUTRON_PASS: {{ salt['pillar.get']('neutron:AUTH_NEUTRON_PASS') }}

