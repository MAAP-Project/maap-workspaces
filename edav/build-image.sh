#!/bin/bash
set -ex
edav_dir=$(dirname $0)
BRANCH=$(git name-rev --name-only HEAD)
BRANCH=$(basename ${BRANCH})
pushd ${edav_dir}
IMAGE_REF=${CI_REGISTRY_IMAGE}/edav:${BRANCH}
docker build --no-cache -t ${IMAGE_REF} -f docker/Dockerfile .
docker push ${IMAGE_REF}
