FROM continuumio/miniconda3:23.10.0-1
ENV LANG en_US.UTF-8
ENV TZ US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

RUN mkdir /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd

RUN apt-get update \
    && apt-get install -y git

COPY ./environment.yml /tmp
RUN conda env create -y -f "/tmp/environment.yml" \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete \
    && /opt/conda/bin/conda clean -afy

SHELL ["conda", "run", "-n", "cardamom", "/bin/bash", "-c"]

WORKDIR /projects
RUN git clone https://github.com/CARDAMOM-framework/CARDAMOM_v2.3.git projects/cardamom/

RUN bash projects/cardamom/BASH/CARDAMOM_COMPILE.sh

# Install maap-py library
RUN mkdir /maap-py \
    && git clone --single-branch --branch v3.1.4 https://github.com/MAAP-Project/maap-py.git /maap-py/ \
    && pip install -e /maap-py/

RUN conda list

ARG IMAGE_REF
ENV DOCKERIMAGE_PATH=${IMAGE_REF}