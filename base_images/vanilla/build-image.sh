#!/bin/bash

BRANCH=$(git name-rev --name-only HEAD)
IMAGE_NAME=vanilla:${BRANCH}
docker build -t ${IMAGE_NAME} --build-arg IMAGE_NAME=${IMAGE_NAME} -f docker/Dockerfile .
