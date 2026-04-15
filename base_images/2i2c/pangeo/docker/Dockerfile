FROM public.ecr.aws/nasa-veda/pangeo-notebook-veda-image:2025.12.30-v1
ENV LANG=en_US.UTF-8
ENV TZ=US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

USER ${NB_USER}

# Use sharded repodata for faster resolve times 
RUN conda install --name base 'conda-libmamba-solver>=25.11.0' -y
RUN conda config --set plugins.use_sharded_repodata true

# Install additional packages from environment.yml
COPY ./environment.yml /tmp
RUN conda env update -n ${CONDA_ENV} -f "/tmp/environment.yml" \
    && find ${CONDA_DIR}/ -follow -type f -name '*.a' -delete \
    && find ${CONDA_DIR}/ -follow -type f -name '*.js.map' -delete \
    && ${CONDA_DIR}/bin/conda clean -afy

RUN conda init

RUN jupyter server extension enable maap_jupyter_server_extension

USER root
COPY scripts/init-user.sh /usr/local/bin/init-user.sh
RUN chmod +x /usr/local/bin/init-user.sh
USER ${NB_USER}

ARG IMAGE_REF
ENV DOCKERIMAGE_PATH_BASE_IMAGE=${IMAGE_REF}
ARG DEFAULT_DOCKERFILE_PATH
ENV DOCKERIMAGE_PATH_DEFAULT=${DEFAULT_DOCKERFILE_PATH}

# This script returns control to base image's /srv/start after 
ENTRYPOINT ["/usr/local/bin/init-user.sh"]