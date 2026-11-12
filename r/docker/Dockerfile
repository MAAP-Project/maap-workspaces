FROM mas.maap-project.org/root/maap-workspaces/2i2c/r-base:v6.0.0
ENV LANG=en_US.UTF-8
ENV TZ=US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

USER ${NB_USER}

# Install shared MAAP extensions
COPY ../maap-extensions-versions.txt /tmp/
RUN ${CONDA_DIR}/bin/pip install -r /tmp/maap-extensions-versions.txt

# TODO graceal evaluate if this is needed
RUN conda init

ARG IMAGE_REF
ENV DOCKERIMAGE_PATH_BASE_IMAGE=${IMAGE_REF}
ARG DEFAULT_DOCKERFILE_PATH
ENV DOCKERIMAGE_PATH_DEFAULT=${DEFAULT_DOCKERFILE_PATH}

USER root
COPY scripts/init-user.sh /usr/local/bin/init-user.sh
RUN chmod +x /usr/local/bin/init-user.sh
USER ${NB_USER}

# This script returns control to base image's /srv/start after, need this for rclone
ENTRYPOINT ["/usr/local/bin/init-user.sh"]