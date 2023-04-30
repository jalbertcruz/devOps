#!/usr/bin/env nu


echo "lalala"

let container = nu -c $"buildah from docker.io/jalbert/ubuntu-base:latest"


let mnt = nu -c $"buildah mount ($container)"
echo "teoruotre"
echo $mnt
ls $mnt
#buildah run $container -- cp data-extracted/* $mnt

#cp -ru /source/directory/* /destination/directory/

buildah umount $container
# Commit the changes to create a new image
buildah commit $container docker.io/jalbert/ubuntu-ssh:latest

# Clean up
buildah rm $container
