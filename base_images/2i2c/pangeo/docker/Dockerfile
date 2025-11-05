FROM pangeo/pangeo-notebook:2025.08.14
ENV LANG en_US.UTF-8
ENV TZ US/Pacific
ARG DEBIAN_FRONTEND noninteractive

USER ${NB_USER}

# Install additional packages from environment.yml
COPY ./environment.yml /tmp
RUN conda env update -n ${CONDA_ENV} -f "/tmp/environment.yml" \
    && find ${CONDA_DIR}/ -follow -type f -name '*.a' -delete \
    && find ${CONDA_DIR}/ -follow -type f -name '*.js.map' -delete \
    && ${CONDA_DIR}/bin/conda clean -afy

RUN conda init

ENV DOCKERIMAGE_PATH_BASE_IMAGE="mas.dit.maap-project.org/root/maap-workspaces/2i2c/pangeo:v5.0.0"
ENV DOCKERIMAGE_PATH_DEFAULT="mas.dit.maap-project.org/root/maap-workspaces/custom_images/maap_base:develop"