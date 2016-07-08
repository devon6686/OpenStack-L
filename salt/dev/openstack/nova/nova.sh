#!/bin/bash

if [ ! -e /root/keystonerc ];then
  exit 1
fi

source /root/keystonerc
if openstack service list |grep nova;then
  exit 1
else
  openstack user create --domain default --password {{ AUTH_NOVA_PASS }} nova
  openstack role add --project service --user nova admin
  openstack service create --name nova --description "OpenStack Compute" compute
  openstack endpoint create --region RegionOne compute public http://{{ HOST }}:8774/v2/%\(tenant_id\)s
  openstack endpoint create --region RegionOne compute internal http://{{ HOST }}:8774/v2/%\(tenant_id\)s
  openstack endpoint create --region RegionOne compute admin http://{{ HOST }}:8774/v2/%\(tenant_id\)s

fi
