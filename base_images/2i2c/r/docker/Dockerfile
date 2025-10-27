FROM ghcr.io/nmfs-opensci/container-images/py-rocket-geospatial:2025.04.26
ENV LANG en_US.UTF-8
ENV TZ US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

RUN printenv

USER root
RUN mkdir -p /projects && \
    cp -a /home/${NB_USER}/. /projects/ && \
    usermod -d /projects ${NB_USER} && \
    chown -R ${NB_USER}:${NB_USER} /projects
WORKDIR /projects

# Install system R and development libraries
# R will be completely separate from conda
RUN apt-get clean && apt-get update && \
    apt-get install -y --no-install-recommends \
    gdal-bin \
    lbzip2 \
    libfftw3-dev \
    libgdal-dev \
    libgeos-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libhdf4-alt-dev \
    libhdf5-dev \
    libjq-dev \
    libpq-dev \
    libproj-dev \
    libprotobuf-dev \
    libnetcdf-dev \
    libsqlite3-dev \
    libssl-dev \
    libudunits2-dev \
    netcdf-bin \
    postgis \
    protobuf-compiler \
    sqlite3 \
    tk-dev \
    unixodbc-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# TODO should user be root?
USER ${NB_USER}

# Install additional packages from environment.yml
COPY ./environment.yml /tmp
RUN conda env update -n ${CONDA_ENV} -f "/tmp/environment.yml" \
    && find ${CONDA_DIR}/ -follow -type f -name '*.a' -delete \
    && find ${CONDA_DIR}/ -follow -type f -name '*.js.map' -delete \
    && ${CONDA_DIR}/bin/conda clean -afy

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

RUN conda init