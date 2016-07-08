#!/bin/bash

if [ ! -e /root/keystonerc ];then
  exit 1
fi

source /root/keystonerc
if openstack service list |grep glance;then
  exit 1
else
  openstack user create --domain default --password {{ AUTH_GLANCE_PASS }} glance
  openstack role add --project service --user glance admin
  openstack service create --name glance --description "OpenStack Image service" image
  openstack endpoint create --region RegionOne image public http://{{ HOST }}:9292
  openstack endpoint create --region RegionOne image internal http://{{ HOST }}:9292
  openstack endpoint create --region RegionOne image admin http://{{ HOST }}:9292
fi
