#!/bin/bash

set -ex
base_image_dir=$(dirname $0)
BRANCH=$(basename $(git name-rev --name-only HEAD))
DIRS="vanilla r rgedi rsgislib"
if [[ ! -z "$@" ]]; then
    DIRS=$@
fi
for dir in ${DIRS}; do
    pushd $base_image_dir/$dir
    IMAGE_NAME=$(basename $dir)
    CACHE_BUST=$(date +%s)
    IMAGE_REF=${CI_REGISTRY_IMAGE}/base_images/${IMAGE_NAME}:${BRANCH}
    docker build -t ${IMAGE_REF} --build-arg IMAGE_REF=${IMAGE_REF} --build-arg CACHE_BUST=${CACHE_BUST} -f docker/Dockerfile .
    docker push ${IMAGE_REF}
    popd
    echo "$IMAGE_REF" >> built_images.txt
done

