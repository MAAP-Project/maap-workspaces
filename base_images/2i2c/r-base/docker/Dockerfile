FROM ghcr.io/nmfs-opensci/container-images/py-rocket-geospatial-2:2026.01.25
ENV LANG=en_US.UTF-8
ENV TZ=US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

USER root

# Install system R and development libraries
# R will be completely separate from conda
RUN apt-get clean && apt-get update && \
    apt-get install -y --no-install-recommends \
    gdal-bin=3.8.4+dfsg-3ubuntu3 \
    lbzip2=2.5-2.3 \
    libfftw3-dev=3.3.10-1ubuntu3 \
    libgdal-dev=3.8.4+dfsg-3ubuntu3 \
    libgeos-dev=3.12.1-3build1 \
    libgl1-mesa-dev=25.0.7-0ubuntu0.24.04.2 \
    libglu1-mesa-dev=9.0.2-1.1build1 \
    libhdf4-alt-dev=4.2.16-4build1 \
    libhdf5-dev=1.10.10+repack-3.1ubuntu4 \
    libjq-dev=1.7.1-3ubuntu0.24.04.1 \
    libpq-dev=16.11-0ubuntu0.24.04.1 \
    libproj-dev=9.4.0-1build2 \
    libprotobuf-dev=3.21.12-8.2ubuntu0.2 \
    libnetcdf-dev=1:4.9.2-5ubuntu4 \
    libsqlite3-dev=3.45.1-1ubuntu2.5 \
    libssl-dev=3.0.13-0ubuntu3.6 \
    libudunits2-dev=2.2.28-7build1 \
    netcdf-bin=1:4.9.2-5ubuntu4 \
    postgis=3.4.2+dfsg-1ubuntu3 \
    protobuf-compiler=3.21.12-8.2ubuntu0.2 \
    sqlite3=3.45.1-1ubuntu2.5 \
    tk-dev=8.6.14build1 \
    unixodbc-dev=2.3.12-1ubuntu0.24.04.1 && \
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

RUN PYTHON_PATH=$(which python) && \
    R_HOME=$(R RHOME) && \
    echo "LD_LIBRARY_PATH=${CONDA_PREFIX}/lib" >> "$R_HOME/etc/Renviron.site" && \
    echo "library(reticulate)" >> "$R_HOME/etc/Rprofile.site" && \
    echo "use_python(\"$PYTHON_PATH\", required = TRUE)" >> "$R_HOME/etc/Rprofile.site" && \
    echo "py_config()" >> "$R_HOME/etc/Rprofile.site"

COPY scripts/init-user.sh /usr/local/bin/init-user.sh
RUN chmod +x /usr/local/bin/init-user.sh

USER ${NB_USER}

# This script returns control to base image's /srv/start after 
ENTRYPOINT ["/usr/local/bin/init-user.sh"]