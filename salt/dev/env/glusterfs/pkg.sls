glusterfs:
  pkg.installed:
    - pkgs:
      - glusterfs
      - glusterfs-fuse
      - glusterfs-server
      - glusterfs-api
      - glusterfs-libs
      - glusterfs-devel

  service.running:
    - name: glusterd
    - enable: True
    - require:
      - pkg: glusterfs
