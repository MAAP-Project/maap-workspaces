FROM ghcr.io/nmfs-opensci/container-images/py-rocket-geospatial:2025.04.26
ENV LANG=en_US.UTF-8
ENV TZ=US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

USER root

# Install system R and development libraries
# R will be completely separate from conda
RUN apt-get clean && apt-get update && \
    apt-get install -y --no-install-recommends \
    gdal-bin=3.4.1+dfsg-1build4 \
    lbzip2=2.5-2.3 \
    libfftw3-dev=3.3.8-2ubuntu8 \
    libgdal-dev=3.4.1+dfsg-1build4 \
    libgeos-dev=3.10.2-1 \
    libgl1-mesa-dev=23.2.1-1ubuntu3.1~22.04.3 \
    libglu1-mesa-dev=9.0.2-1 \
    libhdf4-alt-dev=4.2.15-4 \
    libhdf5-dev=1.10.7+repack-4ubuntu2 \
    libjq-dev=1.6-2.1ubuntu3.1 \
    libpq-dev \
    libproj-dev=8.2.1-1 \
    libprotobuf-dev=3.12.4-1ubuntu7.22.04.4 \
    libnetcdf-dev=1:4.8.1-1 \
    libsqlite3-dev=3.37.2-2ubuntu0.5 \
    libssl-dev=3.0.2-0ubuntu1.20 \
    libudunits2-dev=2.2.28-3 \
    netcdf-bin=1:4.8.1-1 \
    postgis=3.2.0+dfsg-1ubuntu1 \
    protobuf-compiler=3.12.4-1ubuntu7.22.04.4 \
    sqlite3=3.37.2-2ubuntu0.5 \
    tk-dev=8.6.11+1build2 \
    unixodbc-dev=2.3.9-5ubuntu0.1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER ${NB_USER}

# Install additional packages from environment.yml
COPY ./environment.yml /tmp
RUN conda env update -n ${CONDA_ENV} -f "/tmp/environment.yml" \
    && find ${CONDA_DIR}/ -follow -type f -name '*.a' -delete \
    && find ${CONDA_DIR}/ -follow -type f -name '*.js.map' -delete \
    && ${CONDA_DIR}/bin/conda clean -afy

RUN conda init

USER root
SHELL ["/bin/bash", "-c"]
ADD . /
RUN ["chmod", "+x", "/scripts/install_cran_packages_r.sh"]
# Install R packages using SYSTEM R (not conda R)
# Do NOT activate conda environment here
# Clear conda's compiler paths to force use of system compiler
RUN export PATH=/usr/local/bin:/usr/bin:/bin:$PATH && \
    /scripts/install_cran_packages_r.sh
USER ${NB_USER}