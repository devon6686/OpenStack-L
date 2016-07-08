system-upgrade:
  cmd.run:
    - name: yum -y upgrade

openstackclient:
  pkg.installed:
    - name: python-openstackclient


