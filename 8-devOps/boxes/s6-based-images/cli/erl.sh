#!/usr/bin/env bash
# https://www.erlang-solutions.com/downloads-2/#

container=$(buildah from $DOCKER_REGISTRY_PREFIX/ubuntu-ssh:latest)

mnt=$(buildah mount $container)
buildah config --workingdir /home/app $container
buildah config --user root $container

buildah copy $container installers installers
buildah run $container -- dpkg -i /home/app/installers/esl-erlang_27.3.4-1~ubuntu~noble_amd64.deb

buildah run $container -- rm -rf /home/app/installers

buildah umount $container
# Commit the changes to create a new image
buildah commit $container $DOCKER_REGISTRY_PREFIX/ubuntu-erlang_27:latest
buildah push $DOCKER_REGISTRY_PREFIX/ubuntu-erlang_27:latest

# Clean up
buildah rm $container
