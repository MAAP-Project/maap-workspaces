FROM pangeo/pangeo-notebook:2024.06.02
#FROM pangeo/pangeo-notebook:2025.08.14

# Copy home directory contents to /projects and set as new home
# Also need to change workdir in 2i2c infrastructure settings
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