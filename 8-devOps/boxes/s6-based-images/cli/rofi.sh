#!/usr/bin/env bash

container=$(buildah from --volume /home/z/src/devOps/8-devOps/boxes/s6-based-images/local-sources.list.d:/etc/apt/sources.list.d docker.io/jalbert/ubuntu-with-dependencies:24.04)

mnt=$(buildah mount $container)

#buildah config --workingdir /home/app $container
#buildah config --user root $container

buildah copy $container apps-2 apps-2
buildah run $container -- apps-2/install-rofi.sh

buildah umount $container

# Commit the changes to create a new image
#buildah commit $container docker.io/jalbert/ubuntu-with-dependencies:24.04

# Clean up
buildah rm $container
