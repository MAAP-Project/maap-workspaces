export IMAGE_NAME ?= vanilla
export PROJECT_PREFIX = maap_
export BASE_IMAGE_NAME = "${PROJECT_PREFIX}base_${IMAGE_NAME}"
export JUPYTER_IMAGE_NAME = "${PROJECT_PREFIX}jupyter_${IMAGE_NAME}"
export RUN_OPTIONS = 

build-images: build-base-image build-jupyter-image		## Build both the base and jupyterlab image

build-images-no-cache: build-base-image-no-cache build-jupyter-image-no-cache		## Build both the base and jupyterlab image without using the docker cache

build-base-image:		## Build the base image for the 'vanilla' workspace (default), or the workspace specified by setting the argument, IMAGE_NAME=<image_name>
	@cd base_images/${IMAGE_NAME}; \
	pwd; \
	docker buildx build --platform linux/amd64 --progress=plain $(RUN_OPTIONS) -t ${BASE_IMAGE_NAME} -f docker/Dockerfile .

build-base-image-no-cache: RUN_OPTIONS = "--no-cache"
build-base-image-no-cache: build-base-image

build-jupyter-image:		## Build the jupyter image for the 'vanilla' workspace (default), or the workspace specified by setting the argument, IMAGE_NAME=<image_name>
	@cd jupyterlab3; \
	pwd; \
	docker buildx build --platform linux/amd64 --progress=plain $(RUN_OPTIONS) -t ${JUPYTER_IMAGE_NAME} --build-arg BASE_IMAGE_TYPE=${IMAGE_NAME} --build-arg BASE_IMAGE=${BASE_IMAGE_NAME} -f docker/Dockerfile .

build-jupyter-image-no-cache: RUN_OPTIONS = "--no-cache"
build-jupyter-image-no-cache: build-jupyter-image

delete-image: delete-base-image delete-jupyter-image	## Delete the base and jupyter image for the 'vanilla' workspace (default), or the workspace specified by setting the argument, IMAGE_NAME=<image_name>

delete-base-image:		## Delete the base image for the 'vanilla' workspace (default), or the workspace specified by setting the argument, IMAGE_NAME=<image_name>
	docker image rm ${BASE_IMAGE_NAME}

delete-jupyter-image:		## Delete the jupyter image for the 'vanilla' workspace (default), or the workspace specified by setting the argument, IMAGE_NAME=<image_name>
	docker image rm ${JUPYTER_IMAGE_NAME}

open-jupyter:		## Open a browser window to access an already running instance of a 'vanilla' jupyter image, or the workspace specified by setting the argument, IMAGE_NAME=<image_name>
	open http://localhost:3100/

start-jupyter:		## Start the jupyter image for the 'vanilla' workspace (default), or the workspace specified by setting the argument, IMAGE_NAME=<image_name>
	docker run -p 3100:3100 ${JUPYTER_IMAGE_NAME}

# ----------------------------------------------------------------------------
# Self-Documented Makefile
# ref: http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
# ----------------------------------------------------------------------------
help:						## (DEFAULT) This help information
	@echo ====================================================================
	@grep -E '^## .*$$'  \
		$(MAKEFILE_LIST)  \
<<<<<<< HEAD
		| awk 'BEGIN { FS="## " }; {printf "\033[33m%-30s\033[0m \n", $$2}'
	@echo
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$'  \
		$(MAKEFILE_LIST)  \
		| awk 'BEGIN { FS=":.*?## " }; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'  \
=======
		| awk 'BEGIN { FS="## " }; {printf "\033[33m%-20s\033[0m \n", $$2}'
	@echo
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$'  \
		$(MAKEFILE_LIST)  \
		| awk 'BEGIN { FS=":.*?## " }; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'  \
>>>>>>> main
#		 | sort
.PHONY: help
.DEFAULT_GOAL := help