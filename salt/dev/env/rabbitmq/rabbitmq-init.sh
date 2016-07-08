#!/bin/bash
if  rabbitmqctl list_users|grep {{ RABBITMQ_USER }};then
  exit 1
else
  rabbitmqctl add_user {{ RABBITMQ_USER }} {{ RABBITMQ_PASS }}
  rabbitmqctl set_permissions {{ RABBITMQ_USER }} ".*" ".*" ".*"
fi
