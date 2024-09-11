#!/bin/bash
set -e
basedir=$( cd "$(dirname "$0")" ; pwd -P )
git clone https://github.com/MAAP-Project/maap-workspaces.git
pushd maap-workspaces
LATEST_COMMIT=$(git log -n 1 --all --format='%h')
if [[ ! -z ${FORCE_REF_BUILD} ]]; then
    LATEST_COMMIT=${FORCE_REF_BUILD}
fi
git checkout "${LATEST_COMMIT}"

if [[ ! -z ${BUILD_ALL_BASE_IMAGES} ]]; then
    ls -d base_images/*/* > ${basedir}/files_changed.txt
elif [[ ! -z ${BUILD_SPECIFIC_BASE_IMAGES} ]]; then
    base_image_array=(${BUILD_SPECIFIC_BASE_IMAGES})
    for path in ${base_image_array[@]}; do
        echo "base_images/${path}/docker" >> ${basedir}/files_changed.txt
    done
else
    # Find files changed in the latest commit
    echo "BUILD_ALL_BASE_IMAGES and BUILD_SPECIFIC_BASE_IMAGES unset"
    echo "Getting files changed in last commit"
    git diff --name-only HEAD HEAD~1 > ${basedir}/files_changed.txt
fi

if [[ ! -z ${BUILD_ALL_CUSTOM_IMAGES} ]]; then
    ls -d custom_images/*/* > ${basedir}/files_changed.txt
elif [[ ! -z ${BUILD_SPECIFIC_CUSTOM_IMAGES} ]]; then
    custom_image_array=(${BUILD_SPECIFIC_CUSTOM_IMAGES})
    for path in ${custom_image_array[@]}; do
        echo "custom_images/${path}/docker" >> ${basedir}/files_changed.txt
    done
else
    # Find files changed in the latest commit
    echo "BUILD_ALL_CUSTOM_IMAGES and BUILD_SPECIFIC_CUSTOM_IMAGES unset"
    echo "Getting files changed in last commit"
    git diff --name-only HEAD HEAD~1 > ${basedir}/files_changed.txt
fi

cat ${basedir}/files_changed.txt
export LATEST_COMMIT
popd
rm -rf maap-workspaces
touch stages.yml
# For each file changed, check if its in one of the base images directory
cat ${basedir}/files_changed.txt | while read path
do
  if [[ "$path" == base_images/*/* ]]; then
    template="${basedir}/stage.yml.tmpl"
    second_dir=$(echo "$path" | cut -d'/' -f2)
    export BASE_IMAGE_TYPE="$second_dir"
    echo "Adding stage for $path"
    # Add the base image changed file to build stage for downstream pipeline
    cat ${template} | CI_JOB_TOKEN='$CI_JOB_TOKEN' CI_REGISTRY='$CI_REGISTRY' envsubst >> stages.yml
  else
    echo "Path does not begin with base_images or does not have a second level directory, will not do anything"
  fi
  # This is not an elif because we can have both custom and base image repos with changes
  if [[ "$path" == custom_images/*/* ]]; then
    template="${basedir}/custom-image-build.yml.tmpl"
    second_dir=$(echo "$path" | cut -d'/' -f2)
    export BASE_IMAGE_TYPE="$second_dir"
    echo "Adding stage for $path"
    # Add the base image changed file to build stage for downstream pipeline
    cat "${template}" | CI_JOB_TOKEN='$CI_JOB_TOKEN' CI_REGISTRY='$CI_REGISTRY' envsubst >> stages.yml
  else
    echo "Path does not begin with base_images or custom_images or does not have a second level directory, will not do anything"
  fi
done

echo "Generate stages.yaml"
cat stages.yml || true
