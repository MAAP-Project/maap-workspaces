FROM ubuntu:24.04
ENV LANG en_US.UTF-8
ENV TZ US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

#RUN set -ex \
# && apt-get update

RUN mkdir /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd

ENV NB_USER=jovyan
RUN echo "Creating ${NB_USER} user..." \
    # Change user name from ubuntu to jovyan
    && usermod --login ${NB_USER} ubuntu \
    # Change group name from ubuntu to jovyan
    && groupmod --new-name ${NB_USER} ubuntu \
    # Set home directory of jovyan user
    && usermod --home /home/${NB_USER} --move-home ${NB_USER} \
    # Make sure that /srv is owned by non-root user, so we can install things there
    && chown -R ${NB_USER}:${NB_USER} /srv

ARG MINIFORGE_VERSION="24.11.2-1"
RUN apt-get update -y && apt-get install -y vim wget git && \
    apt-get clean all

RUN wget -O Miniforge3-installer.sh https://github.com/conda-forge/miniforge/releases/download/${MINIFORGE_VERSION}/Miniforge3-${MINIFORGE_VERSION}-Linux-x86_64.sh && \
    bash Miniforge3-installer.sh -b -p /srv/conda && \
    chgrp -R ${NB_USER} /srv/conda/ && chmod -R 775 /srv/conda/ && \
    /srv/conda/bin/conda clean -afy && \
    echo "source /srv/conda/etc/profile.d/conda.sh" >> /root/.bashrc

ENV PATH=/srv/conda/bin:$PATH

USER ${NB_USER}

COPY ./environment.yml /tmp
RUN conda env create -y -f "/tmp/environment.yml" \
    && find /srv/conda/ -follow -type f -name '*.a' -delete \
    && find /srv/conda/ -follow -type f -name '*.js.map' -delete \
    && /srv/conda/bin/conda clean -afy

RUN conda init && echo "conda activate notebook" >> ~/.bashrc

SHELL ["/bin/bash", "-c"]
RUN source activate notebook && \
    conda list

USER root
COPY ../start /srv/start
RUN chmod +x /srv/start

USER ${NB_USER}

ENTRYPOINT ["/srv/start"]