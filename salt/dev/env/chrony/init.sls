chrony:
  pkg.installed: []

  service.running:
    - name: chronyd
    - enable: True
    - require:
      - pkg: chrony
      - file: /etc/chrony.conf

/etc/chrony.conf:
  file.managed:
    - source: salt://dev/env/chrony/files/chrony.conf
    - mode: 644
    - user: root
    - group: root
