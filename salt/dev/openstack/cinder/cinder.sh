#!/bin/bash

if [ ! -e /root/keystonerc ];then
  exit 1
fi

source /root/keystonerc
if openstack service list |egrep 'cinder|cinderv2' ;then
  exit 1
else
  openstack user create --domain default --password {{ AUTH_CINDER_PASS }} cinder
  openstack role add --project service --user cinder admin
  openstack service create --name cinder --description "OpenStack Block Storage" volume
  openstack service create --name cinderv2 --description "OpenStack Block Storage" volumev2
  openstack endpoint create --region RegionOne volume public http://{{ HOST }}:8776/v1/%\(tenant_id\)s
  openstack endpoint create --region RegionOne volume internal http://{{ HOST }}:8776/v1/%\(tenant_id\)s
  openstack endpoint create --region RegionOne volume admin http://{{ HOST }}:8776/v1/%\(tenant_id\)s
  openstack endpoint create --region RegionOne volumev2 public http://{{ HOST }}:8776/v2/%\(tenant_id\)s
  openstack endpoint create --region RegionOne volumev2 internal http://{{ HOST }}:8776/v2/%\(tenant_id\)s 
  openstack endpoint create --region RegionOne volumev2 admin http://{{ HOST }}:8776/v2/%\(tenant_id\)s

fi
