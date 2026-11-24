FROM ghcr.io/rocker-org/binder@sha256:cf465bdf5fd487c5686543bbb2eeb4f811502336cc58157a101347d55e98e1f0
ENV LANG=en_US.UTF-8
ENV TZ=US/Pacific
ENV R_LIB=/usr/local/lib/R/site-library
ARG DEBIAN_FRONTEND=noninteractive

USER root

# Install system R and development libraries
RUN apt-get clean && apt-get update && \
    apt-get install -y --no-install-recommends \
    gdal-bin \
    lbzip2 \
    libfftw3-dev \
    libgdal-dev \
    libgeos-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libhdf4-dev \
    libhdf5-dev \
    libicu-dev \
    libjq-dev \
    libpq-dev \
    libproj-dev \
    libprotobuf-dev \
    libnetcdf-dev \
    libsqlite3-dev \
    libssl-dev \
    libudunits2-dev \
    libxml2-dev \
    netcdf-bin \
    postgis \
    protobuf-compiler \
    sqlite3 \
    tk-dev \
    unixodbc-dev \
    unzip \
    curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip

USER ${NB_USER}

# TODO graceal install MAAP extensions 
# Install Google Earth Engine Python package for rgee
RUN pip install --no-cache-dir earthengine-api


USER root

# For VScode extension
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Set default CRAN mirror to use pre-built binaries from Posit Package Manager
RUN R_HOME=$(R RHOME) && \
    echo "options(repos = c(CRAN = 'https://packagemanager.posit.co/cran/__linux__/noble/latest'))" >> "$R_HOME/etc/Rprofile.site"

SHELL ["/bin/bash", "-c"]
ADD . /
RUN ["chmod", "+x", "/scripts/install_cran_packages_r.sh"]
# Install R packages using SYSTEM R
RUN export PATH=/usr/local/bin:/usr/bin:/bin:$PATH && \
    /scripts/install_cran_packages_r.sh

# Reinstall xml2, XML, and stringi from source to override pre-compiled binaries
# The binaries from Posit Package Manager were built on systems with different library versions:
#   - xml2 and XML binaries expect libxml2.so.2 (old), but this system has libxml2.so.16
#   - stringi binary expects libicui18n.so.74 (old), but this system has libicui18n.so.78
# Rebuilding from source links them against the current system libraries
# This fixes loading errors in ggtext (depends on xml2), RStoolbox (depends on XML), and rockchalk (depends on stringi)
RUN Rscript -e "install.packages('xml2', lib = '$R_LIB', type = 'source', repos = 'https://cloud.r-project.org')" && \
    Rscript -e "install.packages('XML', lib = '$R_LIB', type = 'source', repos = 'https://cloud.r-project.org')" && \
    Rscript -e "install.packages('stringi', lib = '$R_LIB', type = 'source', repos = 'https://cloud.r-project.org')"

# This fix is needed for these issues: https://github.com/MAAP-Project/maap-workspaces/pull/194 https://github.com/MAAP-Project/maap-workspaces/pull/191
RUN PYTHON_PATH=$(which python) && \
    R_HOME=$(R RHOME) && \
    echo "library(reticulate)" >> "$R_HOME/etc/Rprofile.site" && \
    echo "use_python(\"$PYTHON_PATH\", required = TRUE)" >> "$R_HOME/etc/Rprofile.site" && \
    echo "py_config()" >> "$R_HOME/etc/Rprofile.site"

COPY scripts/init-user.sh /usr/local/bin/init-user.sh
RUN chmod +x /usr/local/bin/init-user.sh

USER ${NB_USER}

# This script returns control to base image's /srv/start after 
ENTRYPOINT ["/usr/local/bin/init-user.sh"]