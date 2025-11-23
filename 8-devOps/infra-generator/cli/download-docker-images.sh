#!/usr/bin/env bash

shopt -s nullglob  # Ignore failed globs (if no files exist)

# sbt "root/runMain domain.logic.InfrastructureApp gen-docker"
DOCKER_IMAGES_DESTNATION_PATH="/media/z/data_extra/d/offline/docker-images/"
for image in $(yq '.images[]' out/docker-images.yaml); do
    echo "Downloading Docker image: $image"
    docker pull "$image"
    nimage=$(echo -n "$image" | sd '/' '__' | sd ':' '_')
    echo "Saving Docker image as: $nimage.tar"
    docker save "$image" > "$DOCKER_IMAGES_DESTNATION_PATH/$nimage".tar
    docker rmi "$image"
done
