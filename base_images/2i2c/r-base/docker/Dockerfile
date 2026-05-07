FROM ghcr.io/nmfs-opensci/container-images/py-rocket-geospatial-2:2026.02.18
ENV LANG=en_US.UTF-8
ENV TZ=US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

USER root

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

USER ${NB_USER}

# Use sharded repodata for faster resolve times 
RUN conda install --name base 'conda-libmamba-solver>=25.11.0' -y
RUN conda config --set plugins.use_sharded_repodata true

# Install additional packages from environment.yml
COPY ./environment.yml /tmp
RUN conda env update -n ${CONDA_ENV} -f "/tmp/environment.yml" \
    && find ${CONDA_DIR}/ -follow -type f -name '*.a' -delete \
    && find ${CONDA_DIR}/ -follow -type f -name '*.js.map' -delete \
    && ${CONDA_DIR}/bin/conda clean -afy

RUN conda init

RUN conda list

USER root

# Set default CRAN mirror to use pre-built binaries from Posit Package Manager
RUN R_HOME=$(R RHOME) && \
    echo "options(repos = c(CRAN = 'https://packagemanager.posit.co/cran/__linux__/noble/latest'))" >> "$R_HOME/etc/Rprofile.site"

# Install pak for better package management
RUN Rscript -e "install.packages('pak', repos = sprintf('https://r-lib.github.io/p/pak/devel/%s/%s/%s', .Platform\$pkgType, R.Version()\$os, R.Version()\$arch))"

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
    CONDA_LIB="${CONDA_DIR}/envs/${CONDA_ENV}/lib" && \
    echo "# Preload conda OpenSSL libraries to prevent GDAL from loading system OpenSSL" >> "$R_HOME/etc/Rprofile.site" && \
    echo "Sys.setenv(LD_PRELOAD = '$CONDA_LIB/libcrypto.so.3:$CONDA_LIB/libssl.so.3')" >> "$R_HOME/etc/Rprofile.site" && \
    echo "library(reticulate)" >> "$R_HOME/etc/Rprofile.site" && \
    echo "use_python(\"$PYTHON_PATH\", required = TRUE)" >> "$R_HOME/etc/Rprofile.site" && \
    echo "py_config()" >> "$R_HOME/etc/Rprofile.site"

COPY scripts/init-user.sh /usr/local/bin/init-user.sh
RUN chmod +x /usr/local/bin/init-user.sh

USER ${NB_USER}

# This script returns control to base image's /srv/start after 
ENTRYPOINT ["/usr/local/bin/init-user.sh"]