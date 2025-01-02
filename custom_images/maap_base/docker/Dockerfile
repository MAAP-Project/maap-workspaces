FROM ubuntu:24.10

ARG MINICONDA_INSTALLER="https://repo.anaconda.com/miniconda/Miniconda3-py311_24.7.1-0-Linux-x86_64.sh"
ARG MINICONDA_INSTALLER_SHA256="a098a5b1581d8fd078c430b82e27106602223e335efef708a124e723814d120c"

RUN apt-get install software-properties-common

RUN add-apt-repository "http://deb.debian.org/debian"

RUN apt-get update -y && apt-get install -y vim wget git && \
    apt-get clean all

RUN apt-get clean && apt-get update && \
    apt-get install -y --no-install-recommends gdal-bin=3.2.2+dfsg-2+deb11u2 \
    lbzip2=2.5-2.1 \
    libfftw3-dev=3.3.8-2 \
    libgdal-dev=3.2.2+dfsg-2+deb11u2 \
    libgeos-dev=3.9.0-1 \
    libgl1-mesa-dev=20.3.5-1 \
    libglu1-mesa-dev=9.0.1-1 \
    libhdf4-alt-dev=4.2.15-3 \
    libhdf5-dev=1.10.6+repack-4+deb11u1 \
    libjq-dev=1.6-2.1 \
    libpq-dev=13.18-0+deb11u1 \
    libproj-dev=7.2.1-1 \
    libprotobuf-dev=3.12.4-1+deb11u1 \
    libnetcdf-dev=1:4.7.4-1 \
    libsqlite3-dev=3.34.1-3 \
    libssl-dev=1.1.1w-0+deb11u1 \
    libudunits2-dev=2.2.28-3 \
    netcdf-bin=1:4.7.4-1 \
    postgis=3.1.1+dfsg-1+deb11u2 \
    protobuf-compiler=3.12.4-1+deb11u1 \
    sqlite3=3.34.1-3 \
    tk-dev=8.6.11+1 \
    unixodbc-dev=2.3.6-0.1+b1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 

RUN groupadd conda-users

RUN wget -O Miniconda3-installer.sh ${MINICONDA_INSTALLER} && \
    echo "${MINICONDA_INSTALLER_SHA256} Miniconda3-installer.sh" | sha256sum --check --status && \
    bash Miniconda3-installer.sh -b -p /opt/conda && \
    chgrp -R conda-users /opt/conda/ && chmod -R 775 /opt/conda/ && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy && \
    /opt/conda/bin/conda init --all --system

ENV PATH /opt/conda/bin:$PATH
