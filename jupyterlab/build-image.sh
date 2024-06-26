#!/bin/bash
set -ex
jupyterlab_dir=$(dirname $0)
BRANCH=$(git name-rev --name-only HEAD)
BRANCH=$(basename ${BRANCH})
pushd ${jupyterlab_dir}
if [[ -z ${BASE_IMAGE_NAME} ]]; then
    echo "WARNING: No value provided for BASE_IMAGE_NAME, will ./build with default miniconda3 image"
    BASE_IMAGE_NAME=${CI_REGISTRY_IMAGE}/base_images/python:${BRANCH}
fi
[[ $(basename ${BASE_IMAGE_NAME}) =~ (([^:]*)\:) ]];
BASE_IMAGE_TYPE=${BASH_REMATCH[2]}
IMAGE_REF=${CI_REGISTRY_IMAGE}/jupyterlab/$(basename ${BASE_IMAGE_NAME})
docker build --no-cache -t ${IMAGE_REF} --build-arg BASE_IMAGE_TYPE=${BASE_IMAGE_TYPE} --build-arg BASE_IMAGE=${BASE_IMAGE_NAME} -f docker/Dockerfile .
docker push ${IMAGE_REF}
