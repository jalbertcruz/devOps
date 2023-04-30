#!/usr/bin/env bash

container=$(buildah from docker.io/ubuntu:24.04)

mnt=$(buildah mount $container)
buildah run $container -- mkdir /home/app
buildah config --workingdir /home/app $container
buildah config --user root $container

# buildah config --cmd /usr/sbin/nginx $container
# buildah run $container -- sh -c 'echo "daemon off;" >> /etc/nginx/nginx.conf'

buildah config --cmd /usr/local/bin/run_ $container

buildah config --entrypoint '["/init"]' $container

buildah copy $container apps apps
buildah copy $container roles roles
buildah copy $container ansible.cfg
buildah copy $container provision-ssh.yml

buildah run $container -- apps/uv python install 3.13
buildah run $container -- apps/uv venv
buildah run $container -- apps/uv pip install ansible

buildah run $container -- .venv/bin/ansible-playbook provision-ssh.yml

buildah run $container -- rm -rf /home/app/apps
buildah run $container -- rm -rf /home/app/roles
buildah run $container -- rm -rf /home/app/ansible.cfg
buildah run $container -- rm -rf /home/app/provision-ssh.yml
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
#buildah commit $container docker.io/jalbert/ubuntu-ssh:latest
#buildah commit $container localhost:5000/dev/ubuntu-ssh:latest
buildah commit $container $DOCKER_REGISTRY_PREFIX/ubuntu-ssh:latest
#buildah push $DOCKER_REGISTRY_PREFIX/ubuntu-ssh:latest

# Clean up
buildah rm $container
