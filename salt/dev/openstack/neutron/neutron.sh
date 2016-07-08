#!/bin/bash

if [ ! -e /root/keystonerc ];then
  exit 1
fi

source /root/keystonerc
if openstack service list |grep neutron;then
  exit 1
else
  openstack user create --domain default --password {{ AUTH_NEUTRON_PASS }} neutron
  openstack role add --project service --user neutron admin
  openstack service create --name neutron --description "OpenStack Networking" network
  openstack endpoint create --region RegionOne network public http://{{ HOST }}:9696
  openstack endpoint create --region RegionOne network internal http://{{ HOST }}:9696
  openstack endpoint create --region RegionOne network admin http://{{ HOST }}:9696

fi
