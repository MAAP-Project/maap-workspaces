FROM pangeo/base-notebook:2025.08.14
ENV LANG=en_US.UTF-8
ENV TZ=US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

USER root
RUN apt-get update -y && apt-get install -y vim wget git && \
    apt-get clean all
USER ${NB_USER}

COPY ./environment.yml /tmp
RUN conda env update -n ${CONDA_ENV} -f "/tmp/environment.yml" \
    && find /srv/conda/ -follow -type f -name '*.a' -delete \
    && find /srv/conda/ -follow -type f -name '*.js.map' -delete \
    && /srv/conda/bin/conda clean -afy

RUN conda init