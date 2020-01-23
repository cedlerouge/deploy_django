#!/bin/bash

su -c 'ansible-playbook -u ubuntu -i localhost ansible/provision.yml' ubuntu
