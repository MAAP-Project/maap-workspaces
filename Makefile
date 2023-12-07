export IMAGE_NAME ?= vanilla
export BASE_IMAGE_NAME = "maap_base_${IMAGE_NAME}"
export JUPYTER_IMAGE_NAME = "maap_jupyter_${IMAGE_NAME}"
export RUN_OPTIONS = 

build-images: build-base-image build-jupyter-image

build-base-image:
	@cd base_images/${IMAGE_NAME}; \
	pwd; \
	docker buildx build --platform linux/amd64 --progress=plain $(RUN_OPTIONS) -t ${BASE_IMAGE_NAME} -f docker/Dockerfile .

build-base-image-no-cache: RUN_OPTIONS = "--no-cache"
build-base-image-no-cache: build-base-image

build-jupyter-image:
	@cd jupyterlab3; \
	pwd; \
	docker buildx build --platform linux/amd64 --progress=plain $(RUN_OPTIONS) -t ${JUPYTER_IMAGE_NAME} --build-arg BASE_IMAGE_TYPE=${IMAGE_NAME} --build-arg BASE_IMAGE=${BASE_IMAGE_NAME} -f docker/Dockerfile .

build-jupyter-image-no-cache: RUN_OPTIONS = "--no-cache"
build-jupyter-image-no-cache: build-jupyter-image

delete-images: delete-base-image delete-jupyter-image

delete-base-image:
	docker image rm ${BASE_IMAGE_NAME}

delete-jupyter-image:
	docker image rm ${JUPYTER_IMAGE_NAME}

start-jupyter:
	docker run -p 3100:3100 ${JUPYTER_IMAGE_NAME}

# ----------------------------------------------------------------------------
# Self-Documented Makefile
# ref: http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
# ----------------------------------------------------------------------------
help:						## (DEFAULT) This help information
	@echo ====================================================================
	@grep -E '^## .*$$'  \
		$(MAKEFILE_LIST)  \
		| awk 'BEGIN { FS="## " }; {printf "\033[33m%-20s\033[0m \n", $$2}'
	@echo
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$'  \
		$(MAKEFILE_LIST)  \
		| awk 'BEGIN { FS=":.*?## " }; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'  \
#		 | sort
.PHONY: help
.DEFAULT_GOAL := help