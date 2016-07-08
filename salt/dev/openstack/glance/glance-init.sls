salt://dev/openstack/glance/glance.sh:
  cmd.script:
    - template: jinja
    - defaults:
      HOST: {{ grains['host'] }}
      AUTH_GLANCE_PASS: {{ salt['pillar.get']('glance:AUTH_GLANCE_PASS') }}  
    
glance-init:
  pkg.installed:
    - pkgs:
      - openstack-glance
      - python-glance
      - python-glanceclient

