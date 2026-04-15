FROM pangeo/base-notebook:2026.01.30
ENV LANG=en_US.UTF-8
ENV TZ=US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

USER root
RUN apt-get update -y && apt-get install -y vim wget git && \
    apt-get clean all

# Use sharded repodata for faster resolve times 
RUN conda install --name base 'conda-libmamba-solver>=25.11.0' -y
RUN conda config --set plugins.use_sharded_repodata true

USER ${NB_USER}

COPY ./environment.yml /tmp
RUN conda env update -n ${CONDA_ENV} -f "/tmp/environment.yml" \
    && find /srv/conda/ -follow -type f -name '*.a' -delete \
    && find /srv/conda/ -follow -type f -name '*.js.map' -delete \
    && /srv/conda/bin/conda clean -afy

RUN conda init

USER root
COPY scripts/init-user.sh /usr/local/bin/init-user.sh
RUN chmod +x /usr/local/bin/init-user.sh
USER ${NB_USER}

# This script returns control to base image's /srv/start after 
ENTRYPOINT ["/usr/local/bin/init-user.sh"]