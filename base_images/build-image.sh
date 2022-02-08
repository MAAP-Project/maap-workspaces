#!/bin/bash

set -x
base_image_dir=$(dirname $0)
BRANCH=$(basename $(git name-rev --name-only HEAD))

for dir in vanilla; do
    pushd $base_image_dir/$dir
    IMAGE_NAME=$(basename $dir)
    IMAGE_REF=${CI_REGISTRY_IMAGE}/base_images/${IMAGE_NAME}:${BRANCH}
    docker build -t ${IMAGE_REF} --build-arg IMAGE_REF=${IMAGE_REF} -f docker/Dockerfile .
    docker push ${IMAGE_REF}
    popd
    echo "$IMAGE_REF" >> built_images.txt
done

