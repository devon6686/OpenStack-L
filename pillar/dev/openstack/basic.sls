keystone_endpoint: 'http://openstack:35357/v3'
basic:
  mariadb:
    HOST: openstack

  mongod:
    HOST: openstack

  rabbitmq:
    HOST: openstack
    USER: openstack
    PASS: EiYiuPechooroh7x

  glusterfs:
    NODE: openstack
    VOLUME_NAME: nova
    BRICK: /nova/gfs
    VOLUME_URL: localhost:/nova
 
  nova:
    CONTROLLER:
      HOST: 
        openstack: 10.0.0.101

  neutron:
    HOST: 
      openstack: 10.0.0.101
    TYPE: provider  #provider or self    
    PUBLIC_INTERFACE: eth1
    LOCAL_IP: 10.0.0.101
    
  cinder:
    BACKEND: glusterfs
    VOLUME_NAME: cinder
    BRICK: /cinder/gfs
    VOLUME_URL: localhost:/cinder
