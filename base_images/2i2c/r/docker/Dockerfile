FROM ghcr.io/nmfs-opensci/container-images/py-rocket-geospatial:latest

RUN printenv

USER root
RUN mkdir -p /projects && \
    cp -a /home/${NB_USER}/. /projects/ && \
    usermod -d /projects ${NB_USER} && \
    chown -R ${NB_USER}:${NB_USER} /projects
WORKDIR /projects

# TODO should user be root?
USER ${NB_USER}

# Install additional packages from environment.yml
COPY ./environment.yml /tmp
RUN conda env update -n ${CONDA_ENV} -f "/tmp/environment.yml" \
    && find ${CONDA_DIR}/ -follow -type f -name '*.a' -delete \
    && find ${CONDA_DIR}/ -follow -type f -name '*.js.map' -delete \
    && ${CONDA_DIR}/bin/conda clean -afy

RUN conda init