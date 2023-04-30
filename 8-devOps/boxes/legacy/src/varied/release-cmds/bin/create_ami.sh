#!/usr/bin/env bash

cd base-ami
packer build centos7-ec2.json
cd ..
