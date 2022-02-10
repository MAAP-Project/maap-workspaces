#!/bin/bash
set -ex
jupyterlab_dir=$(dirname $0)
BRANCH=$(git name-rev --name-only HEAD)
BRANCH=$(basename ${BRANCH})

if [[ ${SKIP_BASE_IMAGE_BUILD} -eq 0 ]]; then
    pushd $(dirname $jupyterlab_dir)
    bash base_images/build-image.sh
    for base_image in $(cat built_images.txt); do
        pushd ${PWD}/$jupyterlab_dir
        IMAGE_NAME=$(basename $base_image)
        IMAGE_REF=${CI_REGISTRY_IMAGE}/jupyterlab3/${IMAGE_NAME}
        docker build -t ${IMAGE_REF} --build-arg BASE_IMAGE=${base_image} -f docker/Dockerfile .
        docker push ${IMAGE_REF}
        popd
    done

    elif [[ ${SKIP_BASE_IMAGE_BUILD} -eq 1 ]]; then
        pushd ${PWD}/$jupyterlab_dir
        echo "WARNING: Skipping building base images"
        if [[ -z ${BASE_IMAGE_NAME} ]]; then
            echo "WARNING: No value provided for BASE_IMAGE_NAME, will continue with default miniconda3 image"
            BASE_IMAGE_NAME=continuumio/miniconda3:4.10.3p1
        fi
        IMAGE_REF=${CI_REGISTRY_IMAGE}/jupyterlab3/${BASE_IMAGE_NAME}
        docker build -t ${IMAGE_REF} --build-arg BASE_IMAGE=${BASE_IMAGE_NAME} -f docker/Dockerfile .
        docker push ${IMAGE_REF}
fi
