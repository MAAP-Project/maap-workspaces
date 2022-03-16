#!/bin/bash
set -ex
jupyterlab_dir=$(dirname $0)
BRANCH=$(git name-rev --name-only HEAD)
BRANCH=$(basename ${BRANCH})
pushd ${jupyterlab_dir}
if [[ -z ${BASE_IMAGE_NAME} ]]; then
    echo "WARNING: No value provided for BASE_IMAGE_NAME, will ./build with default miniconda3 image"
    BASE_IMAGE_NAME=continuumio/miniconda3:4.10.3p1
fi
IMAGE_REF=${CI_REGISTRY_IMAGE}/jupyterlab3/$(basename ${BASE_IMAGE_NAME})
docker build -t ${IMAGE_REF} --build-arg BASE_IMAGE=${BASE_IMAGE_NAME} -f docker/Dockerfile .
docker push ${IMAGE_REF}
