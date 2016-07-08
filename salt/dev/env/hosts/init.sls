/etc/hosts:
  file.managed:
    - source: salt://dev/env/hosts/templates/hosts.template
    - template: jinja
    - defaults:
      CONTROLLER_HOST: {{ salt['pillar.get']('basic:nova:CONTROLLER:HOST','') }}
