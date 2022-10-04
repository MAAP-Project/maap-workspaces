#!/bin/bash
set -ex
BRANCH=$(git name-rev --name-only HEAD)
BRANCH=$(basename ${BRANCH})
IMAGE_REF=${CI_REGISTRY_IMAGE}/edav:${BRANCH}
docker build --no-cache -t ${IMAGE_REF} -f docker/Dockerfile .
docker push ${IMAGE_REF}
