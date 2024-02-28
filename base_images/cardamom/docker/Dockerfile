FROM continuumio/miniconda3:23.10.0-1
ENV LANG en_US.UTF-8
ENV TZ US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

RUN mkdir /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd

RUN apt-get update \
    && apt-get install -y git 

RUN conda create --name cardamom python=3.10 -y

RUN conda install conda-forge::gcc conda-forge::netcdf4 conda-forge::hdf5 -y

WORKDIR /projects
RUN git clone https://github.com/CARDAMOM-framework/CARDAMOM_v2.3.git projects/cardamom/

ARG IMAGE_REF
ENV DOCKERIMAGE_PATH=${IMAGE_REF}
