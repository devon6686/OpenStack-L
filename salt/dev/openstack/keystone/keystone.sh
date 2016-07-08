#!/bin/bash

if [ ! -e /root/keystonerc ];then
  export OS_TOKEN={{ OS_TOKEN }}
  export OS_URL={{ OS_URL }}
  export OS_IDENTITY_API_VERSION=3

  openstack service create --name keystone --description "OpenStack Identity" identity
  openstack endpoint create --region RegionOne identity public http://{{ HOST }}:5000/v2.0
  openstack endpoint create --region RegionOne identity internal http://{{ HOST }}:5000/v2.0
  openstack endpoint create --region RegionOne identity admin http://{{ HOST }}:35357/v2.0

  openstack project create --domain default --description "Admin Project" admin
  openstack user create --domain default  --password {{ ADMIN_PASS }}  admin
  openstack role create admin
  openstack role create user
  openstack role add --project admin --user admin admin
  openstack project create --domain default  --description "Service Project" service

  unset OS_TOEKN
  unset OS_URL
  unset OS_IDENTITY_API_VERSION
fi

if 
  source /root/keystonerc 
  openstack service list |grep keystone
then
	exit 1
else
  export OS_TOKEN={{ OS_TOKEN }}
  export OS_URL={{ OS_URL }}
  export OS_IDENTITY_API_VERSION=3

  openstack service create --name keystone --description "OpenStack Identity" identity
  openstack endpoint create --region RegionOne identity public http://{{ HOST }}:5000/v2.0
  openstack endpoint create --region RegionOne identity internal http://{{ HOST }}:5000/v2.0
  openstack endpoint create --region RegionOne identity admin http://{{ HOST }}:35357/v2.0

  openstack project create --domain default --description "Admin Project" admin
  openstack user create --domain default  --password {{ ADMIN_PASS }}  admin
  openstack role create admin
  openstack role create user
  openstack role add --project admin --user admin admin
  openstack project create --domain default  --description "Service Project" service
  unset OS_TOEKN
  unset OS_URL
  unset OS_IDENTITY_API_VERSION

fi
