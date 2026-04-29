FROM mas.dit.maap-project.org/root/maap-workspaces/2i2c/r-base:develop
ENV LANG=en_US.UTF-8
ENV TZ=US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

USER ${NB_USER}

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

# This script returns control to base image's /srv/start after 
ENTRYPOINT ["/usr/local/bin/init-user.sh"]