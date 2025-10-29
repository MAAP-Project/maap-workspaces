FROM pangeo/base-notebook:2025.08.14
ENV LANG en_US.UTF-8
ENV TZ US/Pacific
ARG DEBIAN_FRONTEND noninteractive

# Copy home directory contents to /projects and set as new home
USER root
RUN mkdir -p /projects && \
    cp -a /home/${NB_USER}/. /projects/ && \
    usermod -d /projects ${NB_USER} && \
    chown -R ${NB_USER}:${NB_USER} /projects
WORKDIR /projects

RUN apt-get update -y && apt-get install -y vim wget git && \
    apt-get clean all

USER ${NB_USER}

COPY ./environment.yml /tmp
RUN conda env update -n ${CONDA_ENV} -f "/tmp/environment.yml" \
    && find /srv/conda/ -follow -type f -name '*.a' -delete \
    && find /srv/conda/ -follow -type f -name '*.js.map' -delete \
    && /srv/conda/bin/conda clean -afy

RUN conda init

ENV DOCKERIMAGE_PATH_BASE_IMAGE="mas.dit.maap-project.org/root/maap-workspaces/2i2c/isce3:v5.0.0"
ENV DOCKERIMAGE_PATH_DEFAULT="mas.dit.maap-project.org/root/maap-workspaces/custom_images/maap_base:develop"