FROM continuumio/miniconda3:23.10.0-1
ENV LANG en_US.UTF-8
ENV TZ US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

RUN mkdir /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd

COPY ./environment.yml /tmp
RUN conda env create -y -f "/tmp/environment.yml" \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete \
    && /opt/conda/bin/conda clean -afy

RUN conda init && echo "conda activate vanilla" >> ~/.bashrc

# Going to extract this install into the environment.yml by this next release 
# Install maap-py library
SHELL ["/bin/bash", "-c"]
RUN source activate vanilla && \
    mkdir /maap-py && \
    git clone --single-branch --branch community-909 https://github.com/MAAP-Project/maap-py.git /maap-py/ && \
    /opt/conda/envs/vanilla/bin/pip install -e /maap-py/

RUN source activate vanilla && \
    conda list

ARG IMAGE_REF
ENV DOCKERIMAGE_PATH=${IMAGE_REF}