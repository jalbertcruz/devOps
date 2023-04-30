#!/usr/bin/env bash

cd install
ansible-playbook -i aws_ec2.yml build.yml
cd ..
