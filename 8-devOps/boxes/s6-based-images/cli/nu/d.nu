#!/usr/bin/env nu


let container = nu -c $"buildah from docker.io/jalbert/ubuntu-base:latest"

#buildah config --workingdir /wdir $container
#buildah copy $container data-extracted data-extracted
#buildah run $container -- cp -ru data-extracted/* /

buildah config --workingdir / $container
buildah copy $container data-extracted/* /

#let mnt = nu -c $"buildah mount ($container)"
#cp -ru data-extracted/* $mnt


#cp -ru /source/directory/* /destination/directory/

buildah umount $container
# Commit the changes to create a new image
buildah commit $container docker.io/jalbert/ubuntu-ssh:latest

buildah rm $container

