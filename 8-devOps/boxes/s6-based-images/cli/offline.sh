#!/usr/bin/env bash

# buildah run --volume /path/on/host:/path/in/container:ro,z containerID /bin/sh

container=$(buildah from --volume /home/z/src/devOps/8-devOps/boxes/s6-based-images/local-sources.list.d:/etc/apt/sources.list.d docker.io/ubuntu:24.04)

mnt=$(buildah mount $container)
buildah run $container -- mkdir /home/app
buildah config --workingdir /home/app $container
buildah config --user root $container

buildah copy $container apps apps

buildah run $container -- apps/uv python install 3.13
buildah run $container -- apps/uv venv

#buildah run $container -- apt-get update
#buildah run $container -- apt-get upgrade
buildah run $container -- apps/install.sh

#buildah run $container -- apps/uv tool install --with qtile-extras qtile[all]
#buildah run $container -- apps/uv tool install qtile[all]

#buildah run $container -- rm -rf /var/lib/dpkg/lock-frontend
#buildah run $container -- apt-get install -y nginx xz-utils
#buildah run $container -- sh -c 'echo "daemon off;" >> /etc/nginx/nginx.conf'

#buildah run $container -- ssh-keygen -A

#echo "======================================================="
#echo $mnt
#ls -a $mnt/wdir
#echo "======================================================="


#buildah run $container -- rm -rf /root/.local
#buildah run $container -- rm -rf /root/.cache

#buildah run $container -- ls -la /
#buildah run $container -- ls -la /root/.ssh
#buildah run $container -- ls -la /root/demo

buildah umount $container
# Commit the changes to create a new image
buildah commit $container docker.io/jalbert/ubuntu-with-dependencies:24.04

# Clean up
buildah rm $container
