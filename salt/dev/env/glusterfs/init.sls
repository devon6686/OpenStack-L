include:
  - dev.env.glusterfs.pkg

create-cinder-volume:
  glusterfs.created:
    - name: {{ salt['pillar.get']('basic:cinder:VOLUME_NAME') }}
    - bricks:
{% if salt['pillar.get']('basic:cinder:BACKEND') == 'glusterfs' %}
      - {{ grains['host'] }}:{{ salt['pillar.get']('basic:cinder:BRICK') }}
    - transport: tcp
    - start: True
    - unless: ls / |grep cinder
      
{% endif %}
