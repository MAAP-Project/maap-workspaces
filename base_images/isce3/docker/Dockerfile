FROM continuumio/miniconda3:23.10.0-1
ENV LANG en_US.UTF-8
ENV TZ US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

#RUN set -ex \
# && apt-get update

RUN mkdir /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd

COPY ./environment.yml /tmp
RUN conda env create -y -f "/tmp/environment.yml" \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete \
    && /opt/conda/bin/conda clean -afy

RUN conda init && echo "conda activate isce3" >> ~/.bashrc

SHELL ["/bin/bash", "-c"]
RUN source activate isce3 && \
    conda list

ARG IMAGE_REF
ENV DOCKERIMAGE_PATH_BASE_IMAGE=${IMAGE_REF}
ARG DEFAULT_DOCKERFILE_PATH
ENV DOCKERIMAGE_PATH_DEFAULT=${DEFAULT_DOCKERFILE_PATH}
