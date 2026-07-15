#!/bin/bash

set -ex

# Check required parameters
if [ -z "$ENV" ]; then
    echo "Error: ENV variable is required"
    echo "Usage: ENV=<environment> TAG=<tag> ./build-images.sh Options are dit, uat, ops"
    echo "Example: ENV=dit TAG=develop ./build-images.sh"
    exit 1
fi

if [ -z "$TAG" ]; then
    echo "Error: TAG variable is required"
    echo "Usage: ENV=<environment> TAG=<tag> ./build-images.sh DIT images should be tagged as develop and UAT/OPS releases should have numbered tag"
    echo "Example: ENV=dit TAG=develop ./build-images.sh"
    exit 1
fi

base_image_dir=$(dirname $0)

# Generate registry base URL based on ENV
if [ "$ENV" = "ops" ]; then
    REGISTRY_BASE="mas.maap-project.org"
else
    REGISTRY_BASE="mas.${ENV}.maap-project.org"
fi

# Build r-base first (required for r image)
echo "Building r-base image first..."
pushd $base_image_dir/r-base

R_BASE_IMAGE_REF="${REGISTRY_BASE}/root/maap-workspaces/2i2c/r-base:${TAG}"
echo "Building r-base image: ${R_BASE_IMAGE_REF}"

docker build -t ${R_BASE_IMAGE_REF} --build-arg IMAGE_REF=${R_BASE_IMAGE_REF} -f docker/Dockerfile .
# manually add this back in
#docker push ${R_BASE_IMAGE_REF}

popd
echo "$R_BASE_IMAGE_REF" >> built_images.txt

# Define the images to build
IMAGE_TYPES="isce3 pangeo r"

DOCKERIMAGE_PATH_DEFAULT="${REGISTRY_BASE}/root/maap-workspaces/2i2c/custom_images/maap_base:${TAG}"

echo "docker image default path $DOCKERIMAGE_PATH_DEFAULT"

for IMAGE_TYPE in ${IMAGE_TYPES}; do
    pushd $base_image_dir/$IMAGE_TYPE

    # Generate the full image reference
    IMAGE_REF="${REGISTRY_BASE}/root/maap-workspaces/2i2c/${IMAGE_TYPE}:${TAG}"

    echo "Building ${IMAGE_TYPE} image: ${IMAGE_REF}"

    # For R image, pass the r-base image as BASE_IMAGE
    if [ "$IMAGE_TYPE" = "r" ]; then
        docker build -t ${IMAGE_REF} --build-arg IMAGE_REF=${IMAGE_REF} --build-arg BASE_IMAGE=${R_BASE_IMAGE_REF} --build-arg DOCKERIMAGE_PATH_DEFAULT=${DOCKERIMAGE_PATH_DEFAULT} -f docker/Dockerfile .
    else
        docker build -t ${IMAGE_REF} --build-arg IMAGE_REF=${IMAGE_REF} --build-arg DOCKERIMAGE_PATH_DEFAULT=${DOCKERIMAGE_PATH_DEFAULT} -f docker/Dockerfile .
    fi

    # Push the image, commenting this line out as default 
    #docker push ${IMAGE_REF}

    popd

    echo "$IMAGE_REF" >> built_images.txt
done

echo "All images built successfully!"