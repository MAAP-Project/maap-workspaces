FROM oraclelinux:8

ARG MINICONDA_INSTALLER="https://repo.anaconda.com/miniconda/Miniconda3-py311_24.7.1-0-Linux-x86_64.sh"
ARG MINICONDA_INSTALLER_SHA256="a098a5b1581d8fd078c430b82e27106602223e335efef708a124e723814d120c"

RUN yum update -y && yum install -y vim wget git && \
    yum clean all

RUN groupadd ops && groupadd conda-users  && useradd -d /home/ops -g ops -G conda-users ops

RUN wget -O Miniconda3-installer.sh ${MINICONDA_INSTALLER} && \
    echo "${MINICONDA_INSTALLER_SHA256} Miniconda3-installer.sh" | sha256sum --check --status && \
    bash Miniconda3-installer.sh -b -p /opt/conda && \
    chgrp -R conda-users /opt/conda/ && chmod -R 775 /opt/conda/ && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy && \
    /opt/conda/bin/conda init --all --system

ENV PATH /opt/conda/bin:$PATH
