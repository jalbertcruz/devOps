#!/usr/bin/env bash

cd deployment/aws/update
ansible-playbook -i aws_ec2.yml build.yml
cd ../../..
