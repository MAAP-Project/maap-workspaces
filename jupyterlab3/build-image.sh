#!/bin/bash

BRANCH=$(git name-rev --name-only HEAD)
BASE_IMAGE="vanilla:main"
IMAGE_NAME=jupyterlab3:${BRANCH}
docker build -t ${IMAGE_NAME} --build-arg IMAGE_NAME=${IMAGE_NAME} --build-arg BASE_IMAGE=${BASE_IMAGE} -f docker/Dockerfile .
