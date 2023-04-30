#!/usr/bin/env nu


#let container=$(buildah from docker.io/ubuntu:22.04)

let container = nu -c $"buildah from docker.io/ubuntu:24.04"

buildah run $container -- apt-get update

let l = [
  openssh-server
  libssl-dev
  zlib1g-dev
  xz-utils
  unzip
  wget
  curl
  iputils-ping
]

$l | each {|name|
  buildah run $container -- apt-get install -y $name
}


buildah umount $container
# Commit the changes to create a new image
buildah commit $container docker.io/jalbert/ubuntu-base:latest

# Clean up
buildah rm $container
