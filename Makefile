export BASE_IMAGE_NAME ?= pangeo
export PROJECT_PREFIX = maap
export RUN_OPTIONS = 
export IMAGE_NAME_TAG = "${PROJECT_PREFIX}_${BASE_IMAGE_NAME}"

build-image:		
	echo "${BASE_IMAGE_NAME}"; \
	docker buildx build --platform linux/amd64 --progress=plain $(RUN_OPTIONS) -t ${IMAGE_NAME_TAG} -f ${BASE_IMAGE_NAME}/docker/Dockerfile .

build-image-no-cache: RUN_OPTIONS = "--no-cache"
build-image-no-cache: build-image

# Note there is also the build-images.sh to build and push all images 