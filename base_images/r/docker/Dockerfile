FROM continuumio/miniconda3:22.11.1
ENV LANG en_US.UTF-8
ENV TZ US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

# install maap-py library
ENV MAAP_CONF='/maap-py/'
RUN git clone --single-branch --branch v3.0.0 https://github.com/MAAP-Project/maap-py.git \
    && cd maap-py \
    && pip install -e .

RUN set -ex \
 && apt-get update

RUN mkdir /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd

RUN conda install -y -c conda-forge mamba=1.3.1
RUN conda install -y -c conda-forge pyOpenSSL=23.2.0

RUN mamba install -y -c conda-forge r==4.2 r-rgdal==1.5_32 r-sf==1.0_7 r-irkernel==1.3.2 r-gridExtra==2.3 \
    r-tidyverse==2.0.0 r-randomForest==4.7_1.1 r-raster==3.6_20 r-data.table==1.14.8 r-rlist==0.4.6.2 \
    r-gdalutils==2.0.3.2 r-stringr==1.5.0 && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy

ARG IMAGE_REF
ENV DOCKERIMAGE_PATH=${IMAGE_REF}
