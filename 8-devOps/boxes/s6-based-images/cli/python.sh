#!/usr/bin/env bash


version=$1
preffix=$2

container=$(buildah from $DOCKER_REGISTRY_PREFIX/ubuntu-c-compiler-base:latest)

mnt=$(buildah mount $container)

buildah copy $container apps apps
buildah copy $container roles roles
buildah copy $container ansible.cfg
buildah copy $container provision-python.yml

buildah run $container -- apps/uv python install 3.12
buildah run $container -- apps/uv venv
buildah run $container -- apps/uv pip install ansible

buildah run $container -- .venv/bin/ansible-playbook --extra-vars version=$version --extra-vars preffix=$preffix provision-python.yml

buildah run $container -- rm -rf /home/app/apps
buildah run $container -- rm -rf /home/app/roles
buildah run $container -- rm -rf /home/app/ansible.cfg
buildah run $container -- rm -rf /home/app/provision-python.yml
buildah run $container -- rm -rf /home/app/.venv
buildah run $container -- rm -rf /root/.ansible

#buildah run $container -- .venv/bin/ansible-playbook -vvv provision.yml

#buildah run $container -- apt-get update
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
buildah commit $container $DOCKER_REGISTRY_PREFIX/ubuntu-python-$preffix:latest
buildah push $DOCKER_REGISTRY_PREFIX/ubuntu-python-$preffix:latest

# Clean up
buildah rm $container
