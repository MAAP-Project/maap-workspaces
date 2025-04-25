FROM mas.dit.maap-project.org/root/maap-workspaces/custom_images/maap_base:develop
ENV LANG en_US.UTF-8
ENV TZ US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

#RUN set -ex \
# && apt-get update

RUN mkdir /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd

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
    libpq-dev=13.20-0+deb11u1 \
    libproj-dev=7.2.1-1 \
    libprotobuf-dev=3.12.4-1+deb11u1 \
    libnetcdf-dev=1:4.7.4-1 \
    libsqlite3-dev=3.34.1-3+deb11u1 \
    libssl-dev=1.1.1w-0+deb11u2 \
    libudunits2-dev=2.2.28-3 \
    netcdf-bin=1:4.7.4-1 \
    postgis=3.1.1+dfsg-1+deb11u2 \
    protobuf-compiler=3.12.4-1+deb11u1 \
    sqlite3=3.34.1-3+deb11u1 \
    tk-dev=8.6.11+1 \
    unixodbc-dev=2.3.6-0.1+b1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./environment.yml /tmp
RUN conda env create -y -f "/tmp/environment.yml" \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete \
    && /opt/conda/bin/conda clean -afy

RUN conda init && echo "conda activate r" >> ~/.bashrc

SHELL ["/bin/bash", "-c"]
ADD . /
RUN ["chmod", "+x", "/scripts/install_cran_packages_r.sh"]
RUN source activate r && \
    /scripts/install_cran_packages_r.sh

RUN source activate r && \
    conda install /packages/r-lasr-0.13.7-r43h5888daf_0.conda && \
    conda list

ARG IMAGE_REF
ENV DOCKERIMAGE_PATH_BASE_IMAGE=${IMAGE_REF}
ARG DEFAULT_DOCKERFILE_PATH
ENV DOCKERIMAGE_PATH_DEFAULT=${DEFAULT_DOCKERFILE_PATH}