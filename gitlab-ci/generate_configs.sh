#!/bin/bash
set -e
basedir=$( cd "$(dirname "$0")" ; pwd -P )

# Get webhook payload
echo TRIGGER_PAYLOAD=$TRIGGER_PAYLOAD
if [[ ! -z $TRIGGER_PAYLOAD ]]; then
    PAYLOAD_COMMIT=$(cat $TRIGGER_PAYLOAD | python3 -c "import sys, json; print(json.loads(json.load(sys.stdin)['payload'])['after'])")
    REF=$(cat $TRIGGER_PAYLOAD | python3 -c "import sys, json; print(json.loads(json.load(sys.stdin)['payload'])['ref'])")
fi
git clone https://github.com/MAAP-Project/maap-workspaces.git
pushd maap-workspaces
LATEST_COMMIT=$PAYLOAD_COMMIT
if [[ -z ${PAYLOAD_COMMIT} ]]; then
    # If no payload commit was set, find the latest commit on the repo
    LATEST_COMMIT=$(git log -n 1 --all --format='%h')
fi
if [[ ! -z ${FORCE_REF_BUILD} ]]; then
    LATEST_COMMIT=${FORCE_REF_BUILD}
fi
git checkout ${LATEST_COMMIT}

# Set LATEST_COMMIT to what we want as image tag
# Default set it to latest commit hash, branch name if commit is HEAD of branch
LATEST_COMMIT=$(basename $(git symbolic-ref -q --short HEAD || git rev-parse --short HEAD))

# If REF (branch name) in payload use that
if [[ ! -z ${REF} ]]; then
    LATEST_COMMIT=$(basename ${REF})
fi

# If FORCE_CUSTOM_TAGNAME then use that as tag, eg. nightly
if [[ ! -z ${FORCE_CUSTOM_TAGNAME} ]]; then
    LATEST_COMMIT=${FORCE_CUSTOM_TAGNAME}
fi
echo "Using ${LATEST_COMMIT} as tag for images"

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
cat ${basedir}/files_changed.txt
export LATEST_COMMIT
popd
rm -rf maap-workspaces
template="${basedir}/stage.yml.tmpl"
# For each file changed, check if its in one of the base images directory
cat ${basedir}/files_changed.txt | while read path
do
  if [[ "$path" == base_images/*/* ]]; then
    second_dir=$(echo "$path" | cut -d'/' -f2)
    export BASE_IMAGE_TYPE="$second_dir"
    echo "Adding stage for $path"
    # Add the base image changed file to build stage for downstream pipeline
    cat ${template} | CI_JOB_TOKEN='$CI_JOB_TOKEN' CI_REGISTRY='$CI_REGISTRY' envsubst >> stages.yml
  else
    echo "Path does not begin with base_images or does not have a second directory, will not do anything"
    touch stages.yml
  fi
done

echo "Generate stages.yaml"
cat stages.yml || true
