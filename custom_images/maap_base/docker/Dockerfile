FROM oraclelinux:8

ARG MINICONDA_INSTALLER="https://repo.anaconda.com/miniconda/Miniconda3-py312_24.4.0-0-Linux-x86_64.sh"
ARG MINICONDA_INSTALLER_SHA256="b6597785e6b071f1ca69cf7be6d0161015b96340b9a9e132215d5713408c3a7c"

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
