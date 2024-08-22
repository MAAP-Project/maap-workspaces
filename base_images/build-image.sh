#!/bin/bash

set -ex
base_image_dir=$(dirname $0)
# Check if on a branch or in a detached HEAD state get commit sha
BRANCH=$(basename $(git symbolic-ref -q --short HEAD || git rev-parse --short HEAD))
DIRS="python isce3 pangeo r"
if [[ ! -z "$@" ]]; then
    DIRS=$@
fi
for dir in ${DIRS}; do
    pushd $base_image_dir/$dir
    IMAGE_NAME=$(basename $dir)
    IMAGE_REF=${CI_REGISTRY_IMAGE}/base_images/${IMAGE_NAME}:${BRANCH}
    docker build -t ${IMAGE_REF} --build-arg IMAGE_REF=${IMAGE_REF} -f docker/Dockerfile .
    docker push ${IMAGE_REF}
    popd
    echo "$IMAGE_REF" >> built_images.txt
done

