salt://dev/openstack/nova/nova.sh:
  cmd.script:
    - template: jinja
    - defaults:
      HOST: {{ grains['host'] }}
      AUTH_NOVA_PASS: {{ salt['pillar.get']('nova:AUTH_NOVA_PASS') }}  

