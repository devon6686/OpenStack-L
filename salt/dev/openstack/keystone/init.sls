include:
  - dev.openstack.keystone.keystone-mysql
  - dev.openstack.keystone.keystone-init
  - dev.openstack.keystone.service

salt://dev/openstack/keystone/keystone.sh:
  cmd.script:
    - template: jinja
    - defaults:
      OS_TOKEN: {{ salt['pillar.get']('keystone:ADMIN_TOKEN')  }}
      OS_URL: {{ salt['pillar.get']('keystone_endpoint') }}
      HOST: {{ grains['host'] }}
      ADMIN_PASS: {{ salt['pillar.get']('keystone:ADMIN_PASS') }}
      

