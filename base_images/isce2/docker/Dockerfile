FROM mas.maap-project.org/bnarayanarao/isce2:f6c1a08e72dce7771287e4931c2d69941aed937
ENV LANG=en_US.UTF-8
ENV TZ=US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

RUN mkdir /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd

# Install conda manually because not getting from docker image
ARG MINICONDA_INSTALLER="https://repo.anaconda.com/miniconda/Miniconda3-py312_24.4.0-0-Linux-x86_64.sh"
ARG MINICONDA_INSTALLER_SHA256="b6597785e6b071f1ca69cf7be6d0161015b96340b9a9e132215d5713408c3a7c"

# RUN yum update -y && yum install -y vim wget git && \
#     yum clean all
RUN apt-get clean && apt-get update && \
    apt-get install -y --no-install-recommends vim wget git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#RUN groupadd ops && groupadd conda-users  && useradd -d /home/ops -g ops -G conda-users ops
# I removed this from the commands below: chgrp -R conda-users /opt/conda/ &&

RUN wget -O Miniconda3-installer.sh ${MINICONDA_INSTALLER} && \
    echo "${MINICONDA_INSTALLER_SHA256} Miniconda3-installer.sh" | sha256sum --check --status && \
    bash Miniconda3-installer.sh -b -p /opt/conda && \
    chmod -R 775 /opt/conda/ && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy && \
    /opt/conda/bin/conda init bash

ENV PATH /opt/conda/bin:$PATH
#USER ops
RUN /opt/conda/bin/conda init bash
ENV PATH=/opt/conda/bin:$PATH

COPY ./environment.yml /tmp
RUN conda env create -y -f "/tmp/environment.yml" \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete \
    && /opt/conda/bin/conda clean -afy

RUN conda init && echo "conda activate isce2" >> ~/.bashrc

RUN ln -s /home/pkgs/isce2/isce /opt/conda/envs/isce2/lib/python3.10/site-packages/isce

SHELL ["/bin/bash", "-c"]
RUN source activate isce2 && \
    conda list

ARG IMAGE_REF
ENV DOCKERIMAGE_PATH=${IMAGE_REF}