#!/usr/bin/env nu


#let container=$(buildah from docker.io/ubuntu:22.04)

cd data
let files = ls * | where type == file
$files | each {|name|
  echo $name
  tar -C ../data-extracted/ -Jxpf $name.name
}

cd ..
#cp -ru /source/directory/* /destination/directory/
cp -ru roles/s6-server/files/s6-overlay/s6-rc.d/* data-extracted/etc/s6-overlay/s6-rc.d/

